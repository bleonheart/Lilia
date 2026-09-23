"""Shared command-line orchestration for the Lilia and Sam Modules auditors."""

from __future__ import annotations

import contextlib
import copy
import io
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Iterable, List, Optional

from function_comparison_dashboard import (
    CombinedReportData,
    FunctionComparisonReportGenerator,
    FunctionInfo,
)


IGNORED_SOURCE_DIRS = {"docs", "documentation", "languages", "_disabled"}
REPORT_NAME = "comparison_report.md"


@dataclass(frozen=True)
class AuditPaths:
    lilia_root: Path
    gamemode_root: Path
    docs_root: Path
    language_file: Path


def resolve_lilia_paths(base_path: Path, docs_path: Optional[Path] = None) -> AuditPaths:
    """Resolve either a Lilia repository root or its gamemode directory."""
    base = base_path.expanduser().resolve()
    if base.name.lower() == "gamemode":
        lilia_root = base.parent
        gamemode_root = base
    else:
        lilia_root = base
        gamemode_root = base / "gamemode"
    docs_root = (docs_path.expanduser().resolve() if docs_path else lilia_root / "documentation")
    return AuditPaths(
        lilia_root=lilia_root,
        gamemode_root=gamemode_root,
        docs_root=docs_root,
        language_file=gamemode_root / "languages" / "english.lua",
    )


def discover_top_level_modules(modules_root: Path) -> List[Path]:
    """Return deterministic top-level module directories, excluding support folders."""
    return sorted(
        (
            child.resolve()
            for child in modules_root.iterdir()
            if child.is_dir() and child.name.lower() not in IGNORED_SOURCE_DIRS
        ),
        key=lambda path: path.name.lower(),
    )


def discover_nested_modules(module_path: Path) -> List[Path]:
    """Find nested module.lua owners without traversing ignored source folders."""
    found = []
    for marker in module_path.rglob("module.lua"):
        relative_parts = {part.lower() for part in marker.relative_to(module_path).parts}
        if relative_parts & IGNORED_SOURCE_DIRS:
            continue
        if marker.parent.resolve() != module_path.resolve():
            found.append(marker.parent.resolve())
    return sorted(set(found), key=lambda path: str(path).lower())


def _iter_relevant_files(roots: Iterable[Path], include_docs: bool = False) -> Iterable[Path]:
    suffixes = {".lua", ".md"} if include_docs else {".lua"}
    for root in roots:
        if not root.is_dir():
            continue
        for path in root.rglob("*"):
            if not path.is_file() or path.suffix.lower() not in suffixes:
                continue
            if path.name.lower() == REPORT_NAME:
                continue
            if not include_docs and {part.lower() for part in path.parts} & IGNORED_SOURCE_DIRS:
                continue
            yield path


def _stable_generated_at(roots: Iterable[Path]) -> str:
    """Use source state, rather than wall-clock time, for reproducible reports."""
    mtimes = [path.stat().st_mtime for path in _iter_relevant_files(roots, include_docs=True)]
    stamp = max(mtimes, default=0)
    return datetime.fromtimestamp(stamp, tz=timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def _run_generator(generator: FunctionComparisonReportGenerator, quiet: bool) -> CombinedReportData:
    if quiet:
        with contextlib.redirect_stdout(io.StringIO()):
            return generator.run_all_analyses()
    return generator.run_all_analyses()


def _module_scoped_data(
    generator: FunctionComparisonReportGenerator,
    data: CombinedReportData,
    root: Path,
) -> CombinedReportData:
    """Build a report payload containing only findings owned by a module tree."""
    scoped = generator._scope_data_to_path(data, root)
    resolved_root = root.resolve()

    def belongs(row) -> bool:
        if not isinstance(row, dict):
            return False
        for key in ("module_path", "file", "path", "language_file"):
            value = row.get(key)
            if not value:
                continue
            candidate = generator._resolve_report_path(str(value))
            try:
                if candidate and (candidate.resolve() == resolved_root or candidate.resolve().is_relative_to(resolved_root)):
                    return True
            except (OSError, ValueError):
                pass
        return False

    scoped.undefined_inferred_loc_keys = [row for row in data.undefined_inferred_loc_keys if belongs(row)]
    scoped.modules_data = [row for row in data.modules_data if belongs(row)]
    scoped.localization_data = scoped.modules_data[0] if len(scoped.modules_data) == 1 else {}
    scoped.inferred_localization = {
        file_ref: rows
        for file_ref, rows in (data.inferred_localization or {}).items()
        if generator._path_is_within_module(file_ref, resolved_root)
    }
    scoped.derma_panels_defined = [row for row in data.derma_panels_defined if belongs(row)]
    scoped.derma_panels_unused = [row for row in data.derma_panels_unused if belongs(row)]
    scoped.net_messages_direction_issues = generator._filter_entries_for_module(
        data.net_messages_direction_issues, resolved_root
    )
    scoped.module_net_messages_misregistered = generator._filter_entries_for_module(
        data.module_net_messages_misregistered, resolved_root
    )
    scoped.module_net_messages_undefined = generator._filter_entries_for_module(
        data.module_net_messages_undefined, resolved_root
    )
    scoped.fonts_file_usages = {
        file_ref: names for file_ref, names in data.fonts_file_usages.items()
        if generator._path_is_within_module(file_ref, resolved_root)
    }
    scoped.fonts_used = set().union(*scoped.fonts_file_usages.values()) if scoped.fonts_file_usages else set()
    scoped.fonts_registered = set()
    scoped.fonts_unregistered = scoped.fonts_used
    scoped.fonts_default_gmod = scoped.fonts_used & {"DermaDefault", "DermaDefaultBold", "DermaLarge", "Marlett"}
    scoped.fonts_unregistered -= scoped.fonts_default_gmod
    entries = sorted(
        scoped.modules_scan,
        key=lambda entry: (entry.get("module_scope", ""), entry.get("module_path", "").lower()),
    )

    functions = set()
    meta_functions = set()
    undefined = set()
    hooks = set()
    hook_locations = {}
    for entry in entries:
        functions.update(entry.get("undoc_functions", []))
        meta_functions.update(entry.get("undoc_meta_functions", []))
        undefined.update(entry.get("undefined_functions", []))
        hooks.update(entry.get("undoc_hooks", []))
        for name, locations in (entry.get("hook_locations", {}) or {}).items():
            hook_locations.setdefault(name, []).extend(locations)

    all_missing = sorted(functions | meta_functions | undefined, key=str.lower)
    scoped.function_comparison = {
        str(root): {
            "functions": {name: {"parameters": []} for name in all_missing},
            "missing_functions": all_missing,
            "missing_functions_count": len(all_missing),
            "total_functions": len(all_missing),
            "documented_functions": 0,
            "unused_functions": [],
            "unused_functions_count": 0,
        }
    }
    scoped.missing_library_functions = [FunctionInfo(name=name) for name in sorted(functions | undefined, key=str.lower)]
    scoped.missing_meta_functions = [FunctionInfo(name=name) for name in sorted(meta_functions, key=str.lower)]
    scoped.missing_hook_functions = []
    scoped.hooks_missing = sorted(hooks, key=str.lower)
    scoped.hooks_registered = sorted(hooks, key=str.lower)
    scoped.hooks_method = []
    scoped.hooks_standard = sorted(hooks, key=str.lower)
    scoped.hooks_locations = {
        name: sorted(locations, key=lambda item: (item.get("path", ""), item.get("style", "")))
        for name, locations in sorted(hook_locations.items())
    }
    scoped.lilia_rp_cross_usage = []
    privilege_report = copy.deepcopy(data.privilege_report or {})
    privilege_report["framework"] = {}
    privilege_report["modules"] = [row for row in privilege_report.get("modules", []) if belongs(row)]
    if "counts" in privilege_report:
        privilege_report["counts"]["modules_scanned"] = len(privilege_report["modules"])
        privilege_report["counts"]["modules_with_missing_registrations"] = sum(
            1 for row in privilege_report["modules"]
            if (row.get("counts") or {}).get("missing_registrations", 0)
        )
    scoped.privilege_report = privilege_report
    return scoped


def _render_scoped_report(generator: FunctionComparisonReportGenerator, data: CombinedReportData, root: Path) -> str:
    """Render with generator-owned extended audit counts scoped to the same root."""
    original = getattr(generator, "extended_audits", {}) or {}
    scoped_extended = copy.deepcopy(original)
    for section in scoped_extended.values():
        if not isinstance(section, dict) or not isinstance(section.get("issues"), list):
            continue
        section["issues"] = generator._filter_entries_for_module(section["issues"], root)
    generator.extended_audits = scoped_extended
    try:
        return generator.generate_markdown_report(data)
    finally:
        generator.extended_audits = original


def run_lilia_audit(
    paths: AuditPaths,
    output_path: Path,
    quiet: bool = False,
) -> List[Path]:
    generator = FunctionComparisonReportGenerator(
        base_path=str(paths.gamemode_root),
        docs_path=str(paths.docs_root),
        language_file=str(paths.language_file),
        modules_paths=[],
        generate_module_docs=False,
        audit_scope="lilia",
    )
    data = _run_generator(generator, quiet)
    data.generated_at = _stable_generated_at([paths.gamemode_root, paths.docs_root])
    target = output_path.expanduser().resolve()
    target.parent.mkdir(parents=True, exist_ok=True)
    report = "\n".join([
        "# Lilia Framework Audit",
        "",
        f"- **Scanned source:** `{paths.gamemode_root}`",
        "- **External module roots scanned:** 0",
        f"- **Documentation reference:** `{paths.docs_root}`",
        "",
        generator.generate_markdown_report(data),
    ])
    target.write_text(report, encoding="utf-8")
    return [target]


def run_modules_audit(
    paths: AuditPaths,
    modules_root: Path,
    output_path: Path,
    quiet: bool = False,
) -> List[Path]:
    modules_root = modules_root.expanduser().resolve()
    generator = FunctionComparisonReportGenerator(
        base_path=str(paths.gamemode_root),
        docs_path=str(paths.docs_root),
        language_file=str(paths.language_file),
        modules_paths=[str(modules_root)],
        generate_module_docs=True,
        audit_scope="modules",
    )
    data = _run_generator(generator, quiet)
    data.generated_at = _stable_generated_at([modules_root, paths.docs_root, paths.gamemode_root])

    target = output_path.expanduser().resolve()
    target.parent.mkdir(parents=True, exist_ok=True)
    aggregate = _module_scoped_data(generator, data, modules_root)
    modules = discover_top_level_modules(modules_root)
    inventory = []
    for module_path in modules:
        nested = discover_nested_modules(module_path)
        nested_text = ", ".join(path.relative_to(module_path).as_posix() for path in nested) or "—"
        inventory.append(f"| `{module_path.name}` | {nested_text} |")
    aggregate_header = [
        "# Sam Modules Audit",
        "",
        f"- **Scanned source:** `{modules_root}`",
        f"- **Top-level modules scanned:** {len(modules)}",
        f"- **Lilia API reference (read-only):** `{paths.gamemode_root}`",
        "",
        "## Module Inventory",
        "",
        "| Module | Nested `module.lua` owners |",
        "|---|---|",
        *inventory,
        "",
    ]
    target.write_text("\n".join(aggregate_header) + "\n" + _render_scoped_report(generator, aggregate, modules_root), encoding="utf-8")
    written = [target]

    for module_path in modules:
        scoped = _module_scoped_data(generator, data, module_path)
        module_report = module_path / REPORT_NAME
        module_header = "\n".join([
            f"# Sam Module Audit: {module_path.name}",
            "",
            f"- **Scanned source:** `{module_path}`",
            f"- **Nested modules detected:** {len(discover_nested_modules(module_path))}",
            "",
        ])
        module_report.write_text(module_header + "\n" + _render_scoped_report(generator, scoped, module_path), encoding="utf-8")
        written.append(module_report)
    return written


def watch_audit(callback, roots: Iterable[Path], interval: float, quiet: bool) -> None:
    """Poll relevant inputs and rerun the selected auditor after a change."""
    roots = list(roots)

    def snapshot():
        return tuple(sorted((str(path), path.stat().st_mtime_ns) for path in _iter_relevant_files(roots, include_docs=True)))

    previous = snapshot()
    if not quiet:
        print(f"[audit] watch mode enabled ({interval:g}s polling interval); press Ctrl+C to stop")
    while True:
        time.sleep(interval)
        current = snapshot()
        if current != previous:
            previous = current
            callback()


def ensure_directory(path: Path, label: str) -> Path:
    resolved = path.expanduser().resolve()
    if not resolved.is_dir():
        raise SystemExit(f"{label} does not exist or is not a directory: {resolved}")
    return resolved

"""Run the Sam Modules-only auditor."""

from __future__ import annotations

import argparse
from pathlib import Path

from audit_shared import (
    discover_nested_modules,
    discover_top_level_modules,
    ensure_directory,
    resolve_lilia_paths,
    run_modules_audit,
    watch_audit,
)


SCRIPT_DIR = Path(__file__).resolve().parent
DEFAULT_BASE = SCRIPT_DIR.parent
DEFAULT_MODULES = DEFAULT_BASE.parent / "lilia_rp" / "modules" / "done"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Audit only Sam Modules under a modules/done root.")
    parser.add_argument("modules_root", nargs="?", type=Path, help="Explicit modules/done root.")
    parser.add_argument("--modules-path", type=Path, default=None, help="Modules root (alternative to the positional argument).")
    parser.add_argument("--base-path", type=Path, default=DEFAULT_BASE, help="Lilia root or gamemode directory, used read-only as an API reference.")
    parser.add_argument("--documentation-path", "--docs-path", type=Path, default=None, help="Documentation root used as a read-only reference.")
    parser.add_argument("--output-path", type=Path, default=None, help="Aggregate report (default: <modules-root>/comparison_report.md).")
    parser.add_argument("--quiet", "-q", action="store_true", help="Suppress progress output.")
    parser.add_argument("--watch", action="store_true", help="Rerun when module or reference inputs change.")
    parser.add_argument("--watch-interval", type=float, default=1.5, help="Watch polling interval in seconds.")
    args = parser.parse_args()
    if args.modules_root and args.modules_path:
        parser.error("use either the positional modules_root or --modules-path, not both")
    return args


def main() -> None:
    args = parse_args()
    paths = resolve_lilia_paths(args.base_path, args.documentation_path)
    ensure_directory(paths.gamemode_root, "Lilia API reference path")
    modules_root = ensure_directory(args.modules_path or args.modules_root or DEFAULT_MODULES, "Sam Modules root")
    output = (args.output_path or (modules_root / "comparison_report.md")).resolve()

    def audit():
        modules = discover_top_level_modules(modules_root)
        nested = sum((len(discover_nested_modules(module)) for module in modules), 0)
        if not args.quiet:
            print(f"[modules-audit] scanning: {modules_root}")
            print(f"[modules-audit] Lilia API reference (read-only): {paths.gamemode_root}")
            print(f"[modules-audit] modules: {len(modules)} top-level, {nested} nested")
            print(f"[modules-audit] aggregate report: {output}")
            print(f"[modules-audit] per-module reports: {modules_root / '<module>' / 'comparison_report.md'}")
        written = run_modules_audit(paths, modules_root, output, args.quiet)
        if not args.quiet:
            print(f"[modules-audit] wrote {len(written)} reports")

    audit()
    if args.watch:
        watch_audit(audit, [modules_root, paths.gamemode_root, paths.docs_root], args.watch_interval, args.quiet)


if __name__ == "__main__":
    main()


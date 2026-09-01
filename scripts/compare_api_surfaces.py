#!/usr/bin/env python3
"""Compare removed Lilia net messages, commands, and privileges.

The comparison is intentionally source based: it does not execute Garry's Mod
Lua.  It understands the literal declaration forms used by Lilia and reports
all matching source locations in both trees.

Examples:
    python scripts/compare_api_surfaces.py
    python scripts/compare_api_surfaces.py --output report.md
    python scripts/compare_api_surfaces.py --stable C:/repo/Lilia --bleeding D:/repo/lilia
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Iterable


DEFAULT_BLEEDING = Path(r"D:\GMOD\Server\garrysmod\gamemodes\lilia")
DEFAULT_STABLE = Path(r"C:\Users\Administrator\Documents\GitHub\Lilia")


@dataclass(frozen=True)
class Hit:
    path: str
    line: int
    kind: str
    text: str

    def display(self) -> str:
        return f"{self.path}:{self.line} ({self.kind})"


@dataclass
class Item:
    name: str
    declarations: list[Hit]
    usages: list[Hit]


LUA = "*.lua"
QUOTED = r"(['\"])([^'\"]+)\1"


def lua_files(root: Path) -> Iterable[Path]:
    yield from (p for p in root.rglob(LUA) if ".git" not in p.parts)


def read_files(root: Path) -> list[tuple[Path, str]]:
    return [(p, p.read_text(encoding="utf-8", errors="replace")) for p in lua_files(root)]


def hit(root: Path, path: Path, line: int, kind: str, text: str) -> Hit:
    excerpt = text.strip().replace("\ufeff", "")
    if len(excerpt) > 240:
        excerpt = excerpt[:237] + "..."
    return Hit(str(path.relative_to(root)).replace("\\", "/"), line, kind, excerpt)


def literal_call(pattern: str, files: list[tuple[Path, str]], root: Path) -> dict[str, list[Hit]]:
    found: dict[str, list[Hit]] = {}
    rx = re.compile(pattern)
    for path, source in files:
        for number, line in enumerate(source.splitlines(), 1):
            for match in rx.finditer(line):
                name = match.group(2)
                found.setdefault(name, []).append(hit(root, path, number, match.group(1), line))
    return found


def network_data(root: Path) -> tuple[dict[str, list[Hit]], dict[str, list[Hit]]]:
    files = read_files(root)
    declarations: dict[str, list[Hit]] = {}
    usages: dict[str, list[Hit]] = {}
    declaration_rx = re.compile(r"\b(util\.AddNetworkString|net\.Receive|net\.Start)\s*\(\s*(['\"])([^'\"]+)\2")
    # Direct util.AddNetworkString declarations.
    for path, source in files:
        lines = source.splitlines()
        for number, line in enumerate(lines, 1):
            for match in declaration_rx.finditer(line):
                name = match.group(3)
                location = hit(root, path, number, match.group(1), line)
                if match.group(1) == "util.AddNetworkString":
                    declarations.setdefault(name, []).append(location)
                else:
                    usages.setdefault(name, []).append(location)

        # MODULE.NetworkStrings / SCHEMA.NetworkStrings tables, including
        # multiline tables. This also covers the legacy init.lua list when it
        # is assigned to local networkStrings and then iterated.
        table_rx = re.compile(r"\b(?:MODULE|SCHEMA)\.NetworkStrings\s*=\s*\{", re.M)
        for start in table_rx.finditer(source):
            end = source.find("}", start.end())
            if end < 0:
                end = len(source)
            block = source[start.start():end]
            base_line = source.count("\n", 0, start.start()) + 1
            for match in re.finditer(QUOTED, block):
                name = match.group(2)
                line = base_line + block.count("\n", 0, match.start())
                declarations.setdefault(name, []).append(hit(root, path, line, "NetworkStrings", linesafe(lines, line)))

        legacy_rx = re.compile(r"\blocal\s+networkStrings\s*=\s*\{(.+?)\}", re.S)
        for start in legacy_rx.finditer(source):
            block = start.group(1)
            base_line = source.count("\n", 0, start.start()) + 1
            for match in re.finditer(QUOTED, block):
                name = match.group(2)
                line = base_line + block.count("\n", 0, match.start())
                declarations.setdefault(name, []).append(hit(root, path, line, "networkStrings", linesafe(lines, line)))
    return declarations, usages


def linesafe(lines: list[str], line: int) -> str:
    return lines[line - 1] if 0 < line <= len(lines) else ""


def command_data(root: Path) -> tuple[dict[str, list[Hit]], dict[str, list[Hit]]]:
    files = read_files(root)
    declarations: dict[str, list[Hit]] = {}
    usages: dict[str, list[Hit]] = {}
    decl_rx = re.compile(r"\b(concommand\.Add|lia\.command\.add)\s*\(\s*(['\"])([^'\"]+)\2")
    declaration_lines: set[tuple[Path, int]] = set()
    for path, source in files:
        lines = source.splitlines()
        for number, line in enumerate(lines, 1):
            for match in decl_rx.finditer(line):
                declarations.setdefault(match.group(3), []).append(hit(root, path, number, match.group(1), line))
                declaration_lines.add((path, number))
    # Report literal references outside declaration calls. This catches
    # RunConsoleCommand, command lists, and other source-level references.
    if declarations:
        reference_rx = re.compile(r"(?<![A-Za-z0-9_])(?:" + "|".join(re.escape(x) for x in sorted(declarations, key=len, reverse=True)) + r")(?![A-Za-z0-9_])")
        for path, source in files:
            for number, line in enumerate(source.splitlines(), 1):
                if (path, number) in declaration_lines:
                    continue
                for match in reference_rx.finditer(line):
                    usages.setdefault(match.group(0), []).append(hit(root, path, number, "reference", line))
    return declarations, usages


def privilege_data(root: Path) -> tuple[dict[str, list[Hit]], dict[str, list[Hit]]]:
    files = read_files(root)
    declarations: dict[str, list[Hit]] = {}
    usages: dict[str, list[Hit]] = {}
    key_rx = re.compile(r"\[\s*(['\"])([^'\"]+)\1\s*\]\s*=\s*\{")
    id_rx = re.compile(r"\bID\s*=\s*(['\"])([^'\"]+)\1")
    privilege_block = re.compile(r"\b(?:MODULE|SCHEMA)\.Privileges\s*=\s*\{", re.M)
    for path, source in files:
        lines = source.splitlines()
        for start in privilege_block.finditer(source):
            end = source.find("\n}", start.end())
            if end < 0:
                end = len(source)
            block = source[start.start():end]
            base_line = source.count("\n", 0, start.start()) + 1
            for match in key_rx.finditer(block):
                name = match.group(2)
                line = base_line + block.count("\n", 0, match.start())
                declarations.setdefault(name, []).append(hit(root, path, line, "Privileges", linesafe(lines, line)))
        for match in id_rx.finditer(source):
            line = source.count("\n", 0, match.start()) + 1
            # Only count IDs inside a registerPrivilege call, not unrelated tables.
            prior = source[max(0, match.start() - 500):match.start()]
            if "registerPrivilege" in prior and prior.rfind("registerPrivilege") > prior.rfind("}"):
                declarations.setdefault(match.group(2), []).append(hit(root, path, line, "registerPrivilege", linesafe(lines, line)))
        for number, line in enumerate(lines, 1):
            for match in re.finditer(r"\b(?:hasPrivilege|hasStaffCharacterPermission)\s*\(\s*(['\"])([^'\"]+)\1", line):
                usages.setdefault(match.group(2), []).append(hit(root, path, number, match.group(0), line))
    return declarations, usages


def meta_data(root: Path) -> tuple[dict[str, list[Hit]], dict[str, list[Hit]]]:
    """Find methods defined on Lua metatables and literal method calls."""
    files = read_files(root)
    declarations: dict[str, list[Hit]] = {}
    usages: dict[str, list[Hit]] = {}
    definition_rx = re.compile(r"\bfunction\s+([A-Za-z_][A-Za-z0-9_]*Meta):([A-Za-z_][A-Za-z0-9_]*)\s*\(")
    for path, source in files:
        lines = source.splitlines()
        for number, line in enumerate(lines, 1):
            for match in definition_rx.finditer(line):
                name = f"{match.group(1)}:{match.group(2)}"
                declarations.setdefault(name, []).append(hit(root, path, number, "meta definition", line))
    if declarations:
        # Include both colon calls and direct method references. The metatable
        # name is part of the key, but usages are necessarily source-level and
        # may not reveal the concrete receiver type.
        methods = sorted({name.split(":", 1)[1] for name in declarations}, key=len, reverse=True)
        call_rx = re.compile(r":" + r"(?:" + "|".join(re.escape(method) for method in methods) + r")\s*\(")
        names_by_method = {}
        for name in declarations:
            names_by_method.setdefault(name.split(":", 1)[1], []).append(name)
        for path, source in files:
            for number, line in enumerate(source.splitlines(), 1):
                for match in call_rx.finditer(line):
                    method = match.group(0)[1:].split("(", 1)[0].strip()
                    for name in names_by_method[method]:
                        usages.setdefault(name, []).append(hit(root, path, number, "meta call", line))
    return declarations, usages


def compare(kind: str, stable_root: Path, bleeding_root: Path, extractor) -> list[dict]:
    stable_decl, stable_use = extractor(stable_root)
    bleeding_decl, bleeding_use = extractor(bleeding_root)
    removed = sorted(set(stable_decl) - set(bleeding_decl), key=str.casefold)
    result = []
    for name in removed:
        stable_locations = stable_decl.get(name, []) + stable_use.get(name, [])
        bleeding_locations = bleeding_decl.get(name, []) + bleeding_use.get(name, [])
        result.append({
            "name": name,
            "stable_declarations": [asdict(x) for x in stable_decl.get(name, [])],
            "bleeding_declarations": [asdict(x) for x in bleeding_decl.get(name, [])],
            "stable_usages": [asdict(x) for x in stable_use.get(name, [])],
            "bleeding_usages": [asdict(x) for x in bleeding_use.get(name, [])],
            "unused_in_both": not stable_locations and not bleeding_locations,
        })
    return result


def markdown(report: dict) -> str:
    out = ["# Lilia API surface comparison", "", f"Stable: `{report['stable']}`  ", f"Bleeding edge: `{report['bleeding']}`", ""]
    for kind, items in report["removed"].items():
        out += [f"## Removed {kind} ({len(items)})", ""]
        if not items:
            out.append("None found.\n")
            continue
        for item in items:
            status = "UNUSED IN BOTH" if item["unused_in_both"] else "USED"
            out += [f"### `{item['name']}` — {status}"]
            for label in ("stable_declarations", "stable_usages", "bleeding_usages"):
                locations = item[label]
                if locations:
                    out.append(f"- {label.replace('_', ' ').title()}:")
                    out.extend(f"  - `{x['path']}:{x['line']}` ({x['kind']}) — `{x['text']}`" for x in locations)
            out.append("")
    return "\n".join(out)


def main() -> int:
    # Windows consoles commonly default to cp1252, while Lua source may
    # contain Unicode text in the source-line excerpts.
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stable", type=Path, default=DEFAULT_STABLE)
    parser.add_argument("--bleeding", type=Path, default=DEFAULT_BLEEDING)
    parser.add_argument("--format", choices=("md", "json"), default="md")
    parser.add_argument("--output", type=Path, default=Path("api-surface-comparison.md"), help="Write the report to this file.")
    parser.add_argument("--stdout", action="store_true", help="Print the report instead of writing a file.")
    args = parser.parse_args()
    for label, path in (("stable", args.stable), ("bleeding", args.bleeding)):
        if not path.is_dir():
            print(f"{label} path does not exist or is not a directory: {path}", file=sys.stderr)
            return 2
    report = {
        "stable": str(args.stable.resolve()),
        "bleeding": str(args.bleeding.resolve()),
        "removed": {
            "net messages": compare("net messages", args.stable, args.bleeding, network_data),
            "commands": compare("commands", args.stable, args.bleeding, command_data),
            "privileges": compare("privileges", args.stable, args.bleeding, privilege_data),
            "meta methods": compare("meta methods", args.stable, args.bleeding, meta_data),
        },
    }
    content = json.dumps(report, indent=2) if args.format == "json" else markdown(report)
    if args.stdout:
        print(content)
    elif args.output:
        args.output.write_text(content + "\n", encoding="utf-8")
    else:
        print(content)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

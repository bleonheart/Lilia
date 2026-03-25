#!/usr/bin/env python3
import os
import re
from pathlib import Path
from typing import Dict, List, Tuple, Optional, Set

ROOT = Path(r"d:\GMOD\Server\garrysmod\gamemodes\Lilia")
REPORT_PATH = ROOT / "documentation" / "report.md"
SCAN_DIRS = [
    ROOT / "gamemode",
    Path(r"d:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules"),
]

# ── Core L() / resolveToken / notifyLocalized call detection ──────────────────
RE_L_CALL = re.compile(r"""\bL\s*\(\s*(?P<key>(?:"[^"]*"|'[^']*'))(?P<rest>\s*,[^)]*)?\)""")
RE_RESOLVE_CALL = re.compile(r"""\blia\.lang\.resolveToken\s*\(\s*(?P<key>(?:"[^"]*"|'[^']*'|[^,\)]+))(?P<rest>\s*,[^)]*)?\)""")
RE_NOTIFY_LOC = re.compile(r"""\:\s*notify(?:Error|Warning|Success)?Localized\s*\(\s*(?P<key>(?:"[^"]*"|'[^']*'))(?P<rest>\s*,[^)]*)?\)""")

# ── Inferred-localization patterns ────────────────────────────────────────────
# These detect sites where L() is resolved at definition/load time (the string
# is computed immediately and stored, rather than the key being passed around
# for later resolution by the UI layer).

# Generic: any  identifier = L(  or  self.identifier = L(
RE_ASSIGN_FIELD_L = re.compile(
    r"""(?:(?P<obj>[A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*)\.)?(?P<field>[A-Za-z_]\w*)\s*=\s*L\s*\("""
)
RE_ASSIGN_FIELD_RES = re.compile(
    r"""(?:(?P<obj>[A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*)\.)?(?P<field>[A-Za-z_]\w*)\s*=\s*lia\.lang\.resolveToken\s*\("""
)

# Specific high-value inferred patterns (SWEP / ENT / MODULE meta-tables,
# privilege names, tool names).
_INFERRED_FIELD_NAMES: Set[str] = {
    # SWEP / WEAPON meta-fields
    "PrintName", "Instructions", "Purpose",
    # ENT meta-fields
    "PrintName",
    # GUI / panel labels stored at init time
    "title", "label",
    # Privilege / admin system name fields
    "Name", "name",
    # Generic description / category strings cached at load time
    "desc", "description", "category",
}

# Placeholder detection: %s, %d, %i, %f
RE_PLACEHOLDER = re.compile(r"(?<!%)%(?:s|d|i|f)")


def _strip_quotes(s: str) -> str:
    s = s.strip()
    if (s.startswith('"') and s.endswith('"')) or (s.startswith("'") and s.endswith("'")):
        return s[1:-1]
    return s


def _count_top_level_args(rest: Optional[str]) -> int:
    if not rest:
        return 0
    s = rest.strip()
    if not s.startswith(","):
        return 0
    s = s[1:].strip()
    if not s:
        return 0
    args = 1
    depth = 0
    in_single = False
    in_double = False
    i = 0
    while i < len(s):
        ch = s[i]
        if in_single:
            if ch == "\\":
                i += 2
                continue
            if ch == "'":
                in_single = False
            i += 1
            continue
        if in_double:
            if ch == "\\":
                i += 2
                continue
            if ch == '"':
                in_double = False
            i += 1
            continue
        if ch == "'":
            in_single = True
            i += 1
            continue
        if ch == '"':
            in_double = True
            i += 1
            continue
        if ch in "([{":
            depth += 1
            i += 1
            continue
        if ch in ")]}":
            depth = max(0, depth - 1)
            i += 1
            continue
        if ch == "," and depth == 0:
            args += 1
        i += 1
    return args


def _load_language_placeholders() -> Dict[str, int]:
    mapping: Dict[str, int] = {}
    lang_dir = ROOT / "gamemode" / "languages"
    eng = lang_dir / "english.lua"
    if not eng.exists():
        return mapping
    try:
        text = eng.read_text(encoding="utf-8-sig")
    except UnicodeDecodeError:
        text = eng.read_text(encoding="latin-1")
    start = text.find("LANGUAGE")
    if start == -1:
        return mapping
    brace_start = text.find("{", start)
    if brace_start == -1:
        return mapping
    i = brace_start + 1
    depth = 1
    while i < len(text) and depth > 0:
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
        i += 1
    body = text[brace_start + 1 : i - 1]
    for line in body.splitlines():
        line = line.strip()
        if not line or line.startswith("--"):
            continue
        m = re.match(r"([A-Za-z_]\w*)\s*=\s*(?P<val>\"[^\"]*\"|'[^']*')", line)
        if m:
            key = m.group(1)
            val = _strip_quotes(m.group("val"))
            placeholders = len(RE_PLACEHOLDER.findall(val))
            mapping[key] = placeholders
    return mapping


class Mismatch:
    def __init__(self, file: Path, line_no: int, key: str, expected: int, provided: int, context: str):
        self.file = file
        self.line_no = line_no
        self.key = key
        self.expected = expected
        self.provided = provided
        self.context = context


class MissingKeyUsage:
    def __init__(self, file: Path, line_no: int, key: str, context: str):
        self.file = file
        self.line_no = line_no
        self.key = key
        self.context = context


class InferredSite:
    """A site where L() is resolved at source/definition time rather than at
    UI/application time — e.g. SWEP.PrintName = L("..."), privilege Name = L("...")"""
    def __init__(self, file: Path, line_no: int, field: str, obj: Optional[str], key: str, context: str):
        self.file = file
        self.line_no = line_no
        self.field = field
        self.obj = obj       # leading object prefix, e.g. "SWEP", "ENT", "self"
        self.key = key
        self.context = context


def _scan_file_for_calls(
    file_path: Path, lang_map: Dict[str, int]
) -> Tuple[Set[str], List[MissingKeyUsage], List[Mismatch], List[InferredSite]]:
    """
    Returns:
    - used_keys: set of normalised keys seen in this file
    - missing_usages: keys used here that are not defined in the language file
    - mismatches: argument-count mismatches
    - inferred_sites: sites where L() is resolved at definition time
    """
    used: Set[str] = set()
    missing_usages: List[MissingKeyUsage] = []
    mismatches: List[Mismatch] = []
    inferred_sites: List[InferredSite] = []

    try:
        text = file_path.read_text(encoding="utf-8-sig")
    except UnicodeDecodeError:
        text = file_path.read_text(encoding="latin-1")

    lines = text.splitlines()

    for idx, line in enumerate(lines, start=1):
        stripped = line.strip()

        # ── Inferred-localization detection ───────────────────────────────────
        # Check for  [obj.]field = L(  assignments on this line.
        for fm in RE_ASSIGN_FIELD_L.finditer(line):
            field = fm.group("field")
            obj = fm.group("obj") or ""
            # Extract the key from the L() call that follows the assignment
            # Re-search from the match position so we get the correct L() call
            rest_of_line = line[fm.end():]
            key_m = RE_L_CALL.search("L(" + rest_of_line)
            key = key_m.group("key") if key_m else ""
            key = _strip_quotes(key) if key else ""
            inferred_sites.append(InferredSite(file_path, idx, field, obj or None, key, stripped))

        for fm in RE_ASSIGN_FIELD_RES.finditer(line):
            field = fm.group("field")
            obj = fm.group("obj") or ""
            rest_of_line = line[fm.end():]
            r = RE_RESOLVE_CALL.search("lia.lang.resolveToken(" + rest_of_line)
            key = ""
            if r:
                raw = _strip_quotes(r.group("key"))
                key = raw[1:] if raw.startswith("@") else raw
            inferred_sites.append(InferredSite(file_path, idx, field, obj or None, key, stripped))

        # ── L(...) calls ──────────────────────────────────────────────────────
        for m in RE_L_CALL.finditer(line):
            raw_key = _strip_quotes(m.group("key"))
            used.add(raw_key)
            provided = _count_top_level_args(m.group("rest"))
            expected = lang_map.get(raw_key, 0)
            if raw_key not in lang_map:
                missing_usages.append(MissingKeyUsage(file_path, idx, raw_key, stripped))
            if provided != expected:
                mismatches.append(Mismatch(file_path, idx, raw_key, expected, provided, stripped))

        # ── lia.lang.resolveToken(...) calls ──────────────────────────────────
        for m in RE_RESOLVE_CALL.finditer(line):
            raw_key = _strip_quotes(m.group("key"))
            norm_key = raw_key[1:] if raw_key.startswith("@") else raw_key
            if norm_key:
                used.add(norm_key)
                if norm_key not in lang_map and raw_key.startswith("@"):
                    missing_usages.append(MissingKeyUsage(file_path, idx, norm_key, stripped))
            provided = _count_top_level_args(m.group("rest"))
            expected = lang_map.get(norm_key, 0)
            if raw_key.startswith("@") and provided != expected:
                mismatches.append(Mismatch(file_path, idx, norm_key, expected, provided, stripped))

        # ── :notifyXLocalized(...) calls ──────────────────────────────────────
        for m in RE_NOTIFY_LOC.finditer(line):
            raw_key = _strip_quotes(m.group("key"))
            used.add(raw_key)
            if raw_key not in lang_map:
                missing_usages.append(MissingKeyUsage(file_path, idx, raw_key, stripped))
            provided = _count_top_level_args(m.group("rest"))
            expected = lang_map.get(raw_key, 0)
            if provided != expected:
                mismatches.append(Mismatch(file_path, idx, raw_key, expected, provided, stripped))

    return used, missing_usages, mismatches, inferred_sites


def _gather_data() -> Tuple[int, int, List[Mismatch], List[MissingKeyUsage], Dict[Path, List[InferredSite]]]:
    lang_map = _load_language_placeholders()
    all_used: Set[str] = set()
    all_missing: List[MissingKeyUsage] = []
    all_mismatches: List[Mismatch] = []
    inferred_by_file: Dict[Path, List[InferredSite]] = {}

    for base in SCAN_DIRS:
        if not base.exists():
            continue
        for root, _, files in os.walk(base):
            for fn in files:
                if not fn.endswith(".lua"):
                    continue
                fp = Path(root) / fn
                used, missing, mismatches, inferred = _scan_file_for_calls(fp, lang_map)
                all_used |= used
                all_missing.extend(missing)
                all_mismatches.extend(mismatches)
                if inferred:
                    inferred_by_file.setdefault(fp, []).extend(inferred)

    unique_keys = len(all_used)
    # "Undefined Calls" = distinct keys that appear in code but not in english.lua
    undefined_calls = len({m.key for m in all_missing})
    return unique_keys, undefined_calls, all_mismatches, all_missing, inferred_by_file


# ── Formatting helpers ────────────────────────────────────────────────────────

def _rel(file_path: Path) -> str:
    try:
        return str(file_path.relative_to(ROOT)).replace("/", "\\")
    except ValueError:
        return str(file_path)


def _format_mismatches(mismatches: List[Mismatch]) -> str:
    lines: List[str] = ["### Argument Mismatches"]
    lines.append(f"- **Total Mismatches:** {len(mismatches)}")
    if not mismatches:
        return "\n".join(lines)
    lines.append("")
    by_file: Dict[Path, List[Mismatch]] = {}
    for mm in mismatches:
        by_file.setdefault(mm.file, []).append(mm)
    for fp, items in sorted(by_file.items(), key=lambda kv: _rel(kv[0]).lower()):
        lines.append(f"#### {_rel(fp)}")
        lines.append("")
        for mm in items:
            lines.append(f"- **Line {mm.line_no}:** {mm.key}(args)")
            lines.append(f"  - Expected: {mm.expected} args, Provided: {mm.provided} args")
            lines.append(f"  - Context: {mm.context}")
        lines.append("")
    return "\n".join(lines).rstrip()


def _format_missing_keys(missing_usages: List[MissingKeyUsage]) -> str:
    lines: List[str] = ["### Missing Keys"]
    if not missing_usages:
        lines.append("")
        lines.append("No undefined keys found.")
        return "\n".join(lines)
    lines.append("")
    by_file: Dict[Path, List[MissingKeyUsage]] = {}
    for mu in missing_usages:
        by_file.setdefault(mu.file, []).append(mu)
    for fp, items in sorted(by_file.items(), key=lambda kv: _rel(kv[0]).lower()):
        lines.append(f"#### {_rel(fp)}")
        lines.append("")
        for mu in items:
            lines.append(f"- **Line {mu.line_no}:** `{mu.key}`")
            lines.append(f"  - Context: {mu.context}")
        lines.append("")
    return "\n".join(lines).rstrip()


def _build_section(unique_keys: int, undefined_calls: int, mismatches: List[Mismatch], missing_usages: List[MissingKeyUsage]) -> str:
    parts = [
        f"- **Unique Keys:** {unique_keys}",
        f"- **Undefined Calls:** {undefined_calls}",
        f"- **Argument Mismatch:** {len(mismatches)}",
        "",
        _format_mismatches(mismatches),
        "",
        _format_missing_keys(missing_usages),
    ]
    return "\n".join(parts).rstrip() + "\n"


def _rewrite_localization_section(
    unique_keys: int,
    undefined_calls: int,
    mismatches: List[Mismatch],
    missing_usages: List[MissingKeyUsage],
) -> None:
    if not REPORT_PATH.exists():
        return
    try:
        content = REPORT_PATH.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        content = REPORT_PATH.read_text(encoding="latin-1")

    section_body = _build_section(unique_keys, undefined_calls, mismatches, missing_usages)
    new_content = content

    # Replace every "## Localization Analysis" block
    h2_tag = "## Localization Analysis"
    h2_positions = [m.start() for m in re.finditer(re.escape(h2_tag), new_content)]
    for idx in reversed(h2_positions):
        end = new_content.find("\n## ", idx + len(h2_tag))
        if end == -1:
            end = len(new_content)
        new_content = new_content[: idx + len(h2_tag)] + "\n\n" + section_body + new_content[end:]

    # Replace "### Localization Analysis" (executive-summary sub-section)
    h3_tag = "### Localization Analysis"
    idx2 = new_content.find(h3_tag)
    if idx2 != -1:
        candidates = []
        p1 = new_content.find("\n### ", idx2 + len(h3_tag))
        p2 = new_content.find("\n## ", idx2 + len(h3_tag))
        if p1 != -1:
            candidates.append(p1)
        if p2 != -1:
            candidates.append(p2)
        end2 = min(candidates) if candidates else len(new_content)
        new_content = new_content[: idx2 + len(h3_tag)] + "\n\n" + section_body + new_content[end2:]

    REPORT_PATH.write_text(new_content, encoding="utf-8")


# ── Entry point ───────────────────────────────────────────────────────────────

def main() -> None:
    unique_keys, undefined_calls, mismatches, missing_usages, inferred_by_file = _gather_data()
    _rewrite_localization_section(unique_keys, undefined_calls, mismatches, missing_usages)

    print(f"Unique Keys:              {unique_keys}")
    print(f"Undefined Calls:          {undefined_calls}")
    print(f"Argument Mismatches:      {len(mismatches)}")
    total_inferred = sum(len(v) for v in inferred_by_file.values())
    print(f"Inferred Localization Sites: {total_inferred}")
    print()

    # Detailed inferred-site listing grouped by file
    for fp, entries in sorted(inferred_by_file.items(), key=lambda kv: _rel(kv[0]).lower()):
        print(_rel(fp))
        for site in entries:
            prefix = f"{site.obj}." if site.obj else ""
            print(f"  L{site.line_no:4d}: {prefix}{site.field} = L(\"{site.key}\")")
        print()


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Lilia Unused Language Keys Checker

This script scans the English language file for defined keys and checks
for direct usages across the codebase. A key is considered "used" if it
appears in a direct lookup such as:
  - L("key") or L('key')
  - lia.lang.Get("key") / lia.lang.get('key')
  - notifyLocalized("key", ...)

Additionally, it checks for:
  - Keys that are used but don't exist in the language file
  - Argument count mismatches in L() and notifyLocalized() calls

Keys that are defined but have no direct usage are written to a Markdown
report: unused_language_keys.md

Run from the repository root (same directory as this script).
"""

from __future__ import annotations

import os
import re
from pathlib import Path
from typing import Iterable, Set, Dict, List, Tuple


REPO_ROOT = Path(__file__).resolve().parent
GAMEMODE_DIR = REPO_ROOT / "gamemode"
LANG_DIR = GAMEMODE_DIR / "languages"
ENGLISH_LANG_FILE = LANG_DIR / "english.lua"
REPORT_FILE = REPO_ROOT / "unused_language_keys.md"


# Data structures for tracking localization calls
LocalizationCall = Tuple[str, str, int]  # (key, file_path, line_number)
ArgumentMismatch = Tuple[str, str, int, int, int]  # (key, file_path, line_number, expected_args, actual_args)


def read_english_keys() -> Tuple[Set[str], Dict[str, str]]:
    """Parse keys from gamemode/languages/english.lua within LANGUAGE = { ... }.

    Returns a tuple of (keys_set, language_strings_dict).
    language_strings_dict maps keys to their string templates.
    """
    if not ENGLISH_LANG_FILE.exists():
        raise FileNotFoundError(f"Missing language file: {ENGLISH_LANG_FILE}")

    content = ENGLISH_LANG_FILE.read_text(encoding="utf-8", errors="ignore")

    keys = set()
    language_strings = {}

    # Locate the LANGUAGE table block
    start_match = re.search(r"\bLANGUAGE\s*=\s*\{", content)
    if not start_match:
        # Fallback: parse all key="value" style pairs anywhere in file
        return _extract_keys_and_strings_from_text(content)

    start_index = start_match.end()  # index after the opening '{'
    brace_depth = 1
    i = start_index
    end_index = len(content)

    while i < len(content):
        ch = content[i]
        if ch == '{':
            brace_depth += 1
        elif ch == '}':
            brace_depth -= 1
            if brace_depth == 0:
                end_index = i
                break
        i += 1

    language_block = content[start_index:end_index]
    keys, language_strings = _extract_keys_and_strings_from_text(language_block)
    return keys, language_strings


def _extract_keys_and_strings_from_text(text: str) -> Tuple[Set[str], Dict[str, str]]:
    """Extract keys and their string values of the form key = "..." or key = '...'."""
    keys: Set[str] = set()
    language_strings: Dict[str, str] = {}

    # Matches lines like: keyName = "Some Value",
    pattern = re.compile(r"^\s*(\w+)\s*=\s*(['\"])(.*?)\2\s*,?\s*$", re.MULTILINE)
    for match in pattern.finditer(text):
        key = match.group(1)
        value = match.group(3)
        if key and key != "NAME":  # Ignore NAME metadata if present
            keys.add(key)
            language_strings[key] = value
    return keys, language_strings


def count_format_specifiers(template: str) -> int:
    """Count the number of format specifiers (%s, %d, %f, %g) in a template string."""
    # Match format specifiers that are not escaped (not preceded by another %)
    pattern = re.compile(r'(?<!%)%[sdfg]')
    return len(pattern.findall(template))


def find_localization_calls_and_mismatches(language_strings: Dict[str, str]) -> Tuple[Set[str], List[LocalizationCall], List[ArgumentMismatch]]:
    """Scan all non-language Lua files for localization calls and check for mismatches.

    Returns:
        - Set of keys that are used in localization calls
        - List of localization calls found
        - List of argument mismatches found
    """
    used_keys: Set[str] = set()
    localization_calls: List[LocalizationCall] = []
    argument_mismatches: List[ArgumentMismatch] = []

    # Regex patterns for localization calls
    # L("key", arg1, arg2, ...) or L('key', arg1, arg2, ...)
    l_pattern = re.compile(r'\bL\(\s*([\'"]([^\'"]+)[\'"])\s*,?\s*(.*?)\s*\)', re.DOTALL)

    # notifyLocalized(client, "key", type, arg1, arg2, ...) or notifyLocalized("key", type, arg1, arg2, ...)
    notify_pattern = re.compile(r'\bnotifyLocalized\(\s*([^,]+)\s*,\s*([\'"]([^\'"]+)[\'"])\s*,?\s*(.*?)\s*\)', re.DOTALL)

    for root, dirs, files in os.walk(GAMEMODE_DIR):
        # Skip the languages directory when searching usages
        dirs[:] = [d for d in dirs if (Path(root) / d) != LANG_DIR]

        for filename in files:
            if not filename.endswith(".lua"):
                continue

            file_path = Path(root) / filename
            try:
                text = file_path.read_text(encoding="utf-8", errors="ignore")
            except Exception:
                continue

            lines = text.splitlines()

            # Check L() calls
            for match in l_pattern.finditer(text):
                key = match.group(2)
                args_part = match.group(3) or ""
                line_number = text[:match.start()].count('\n') + 1

                if key:
                    used_keys.add(key)
                    localization_calls.append((key, str(file_path.relative_to(GAMEMODE_DIR)), line_number))

                    # Count actual arguments
                    actual_args = count_arguments_in_call(args_part)
                    expected_args = language_strings.get(key, 0)
                    if isinstance(expected_args, str):
                        expected_args = count_format_specifiers(expected_args)

                    if expected_args != actual_args:
                        argument_mismatches.append((key, str(file_path.relative_to(GAMEMODE_DIR)), line_number, expected_args, actual_args))

            # Check notifyLocalized() calls
            for match in notify_pattern.finditer(text):
                key = match.group(3)
                args_part = match.group(4) or ""
                line_number = text[:match.start()].count('\n') + 1

                if key:
                    used_keys.add(key)
                    localization_calls.append((key, str(file_path.relative_to(GAMEMODE_DIR)), line_number))

                    # Count actual arguments (excluding client and type parameters)
                    actual_args = count_arguments_in_call(args_part)
                    expected_args = language_strings.get(key, 0)
                    if isinstance(expected_args, str):
                        expected_args = count_format_specifiers(expected_args)

                    if expected_args != actual_args:
                        argument_mismatches.append((key, str(file_path.relative_to(GAMEMODE_DIR)), line_number, expected_args, actual_args))

    return used_keys, localization_calls, argument_mismatches


def count_arguments_in_call(args_part: str) -> int:
    """Count the number of arguments in a function call arguments string."""
    if not args_part.strip():
        return 0

    # This is a simplified argument counter - it counts commas and handles some edge cases
    # For more complex cases, we might need a proper Lua parser
    args_part = args_part.strip()

    # Remove string literals and comments to avoid false positives
    # This is a basic implementation - a full Lua parser would be better
    args_part = re.sub(r'".*?"', '""', args_part)  # Remove string literals
    args_part = re.sub(r"'.*?'", "''", args_part)  # Remove string literals

    # Count top-level commas
    comma_count = 0
    paren_depth = 0
    bracket_depth = 0
    brace_depth = 0

    for char in args_part:
        if char == '(':
            paren_depth += 1
        elif char == ')':
            paren_depth -= 1
        elif char == '[':
            bracket_depth += 1
        elif char == ']':
            bracket_depth -= 1
        elif char == '{':
            brace_depth += 1
        elif char == '}':
            brace_depth -= 1
        elif char == ',' and paren_depth == 0 and bracket_depth == 0 and brace_depth == 0:
            comma_count += 1

    # If there are no commas, there's 1 argument if there's content
    if comma_count == 0:
        return 1 if args_part.strip() else 0

    # Otherwise, number of arguments = comma count + 1
    return comma_count + 1


def find_keys_with_direct_matches(keys: Iterable[str]) -> Set[str]:
    """Scan all non-language Lua files and detect direct exact string matches for keys.

    A key is considered matched if it appears as a quoted string, e.g., "key" or 'key'.
    Returns the subset of keys that have at least one direct match anywhere in code.
    """
    key_patterns = {key: [
        re.compile(rf"['\"]{re.escape(key)}['\"]")
    ] for key in keys}

    matched: Set[str] = set()

    for root, dirs, files in os.walk(GAMEMODE_DIR):
        # Skip the languages directory when searching usages
        dirs[:] = [d for d in dirs if (Path(root) / d) != LANG_DIR]

        for filename in files:
            if not filename.endswith(".lua"):
                continue

            file_path = Path(root) / filename
            try:
                text = file_path.read_text(encoding="utf-8", errors="ignore")
            except Exception:
                continue

            # Skip early if all keys matched
            if len(matched) == len(key_patterns):
                break

            for key, patterns in key_patterns.items():
                if key in matched:
                    continue
                for pattern in patterns:
                    if pattern.search(text):
                        matched.add(key)
                        break

    return matched


def write_report(defined: Iterable[str], used_in_localization: Iterable[str], matched: Iterable[str], localization_calls: List[LocalizationCall], argument_mismatches: List[ArgumentMismatch]) -> None:
    defined_set = set(defined)
    used_in_localization_set = set(used_in_localization)
    matched_set = set(matched)

    # Keys that are defined but not used in localization calls
    unused = sorted(defined_set - used_in_localization_set)

    # Keys that are used in localization calls but don't exist in the language file
    missing_keys = sorted(used_in_localization_set - defined_set)

    lines = []
    lines.append("# Unused Language Keys (English)")
    lines.append("")
    lines.append("## Summary")
    lines.append(f"- Total defined keys: {len(defined_set)}")
    lines.append(f"- Keys used in localization calls: {len(used_in_localization_set)}")
    lines.append(f"- Keys with direct matches in code: {len(matched_set)}")
    lines.append(f"- Unused keys (defined but not used): {len(unused)}")
    lines.append(f"- Missing keys (used but not defined): {len(missing_keys)}")
    lines.append("")

    # Missing keys section
    if missing_keys:
        lines.append("## Missing Keys (Used but not defined)")
        lines.append("")
        lines.append("These keys are used in localization calls but are not defined in the English language file.")
        lines.append("")

        for key in missing_keys:
            # Find calls for this key
            calls_for_key = [call for call in localization_calls if call[0] == key]
            if calls_for_key:
                lines.append(f"### `{key}`")
                lines.append("")
                lines.append("**Used in files:**")
                for _, file_path, line_number in sorted(set(calls_for_key)):
                    lines.append(f"- `{file_path}:{line_number}`")
                lines.append("")

    # Unused keys section
    if unused:
        lines.append("## Unused Keys (Defined but not used)")
        lines.append("")
        lines.append("These keys are defined in the English language file but are not used in any localization calls.")
        lines.append("")

        for key in unused:
            lines.append(f"- `{key}`")
    else:
        lines.append("## Unused Keys")
        lines.append("")
        lines.append("All defined keys are used in localization calls.")

    # Argument mismatches section
    if argument_mismatches:
        lines.append("")
        lines.append("## Argument Mismatches")
        lines.append("")
        lines.append("These localization calls have incorrect argument counts compared to their format specifiers.")
        lines.append("")

        for key, file_path, line_number, expected, actual in sorted(argument_mismatches):
            lines.append(f"### `{key}`")
            lines.append(f"- **File:** `{file_path}:{line_number}`")
            lines.append(f"- **Expected arguments:** {expected}")
            lines.append(f"- **Actual arguments:** {actual}")
            lines.append("")

    # All localization calls section (for reference)
    if localization_calls:
        lines.append("")
        lines.append("## All Localization Calls")
        lines.append("")
        lines.append("Complete list of localization calls found in the codebase:")
        lines.append("")

        # Group calls by key
        calls_by_key = {}
        for key, file_path, line_number in localization_calls:
            if key not in calls_by_key:
                calls_by_key[key] = []
            calls_by_key[key].append((file_path, line_number))

        for key in sorted(calls_by_key.keys()):
            calls = calls_by_key[key]
            lines.append(f"### `{key}`")
            lines.append("")
            lines.append("**Used in:**")
            for file_path, line_number in sorted(set(calls)):
                lines.append(f"- `{file_path}:{line_number}`")
            lines.append("")

    REPORT_FILE.write_text("\n".join(lines), encoding="utf-8")
    print(f"[OK] Wrote report: {REPORT_FILE}")


def main() -> None:
    print("[SEARCH] Collecting English language keys...")
    defined_keys, language_strings = read_english_keys()
    print(f"   Loaded {len(defined_keys)} keys from {ENGLISH_LANG_FILE}")

    print("[SCAN] Checking for localization calls and argument mismatches...")
    used_keys, localization_calls, argument_mismatches = find_localization_calls_and_mismatches(language_strings)
    print(f"   Found {len(used_keys)} keys used in localization calls")
    print(f"   Found {len(localization_calls)} localization calls")
    print(f"   Found {len(argument_mismatches)} argument mismatches")

    print("[SCAN] Checking for direct exact string matches across codebase...")
    matched_keys = find_keys_with_direct_matches(defined_keys)
    print(f"   Found {len(matched_keys)} keys with direct matches")

    print("[REPORT] Generating Markdown report...")
    write_report(defined_keys, used_keys, matched_keys, localization_calls, argument_mismatches)

    print("[DONE] Unused language key scan completed.")


if __name__ == "__main__":
    main()



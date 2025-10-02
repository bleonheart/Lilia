#!/usr/bin/env python3
"""
Localization Key Sync Verifier for Lilia Gamemode

This script parses all language files in the gamemode/languages/ directory
and generates a markdown report showing missing or inconsistent localization keys.
"""

import os
import re
from pathlib import Path
from typing import Dict, List, Set, Tuple


def parse_lua_localization_file(file_path: str) -> Dict[str, str]:
    """
    Parse a Lua localization file and extract key-value pairs.

    Args:
        file_path: Path to the Lua localization file

    Returns:
        Dictionary mapping localization keys to their values
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
    except UnicodeDecodeError:
        # Try with different encoding if UTF-8 fails
        try:
            with open(file_path, 'r', encoding='latin-1') as file:
                content = file.read()
        except UnicodeDecodeError:
            print(f"[WARNING] Could not decode file: {file_path}")
            return {}

    # Pattern to match Lua key-value pairs: key = "value",
    # This handles multiline strings and escaped quotes
    # Note: Some entries have trailing commas, some don't (last entry)
    pattern = r'(\w+)\s*=\s*"([^"]*(?:\\.[^"]*)*)"\s*,?'

    matches = re.findall(pattern, content)

    # Remove any empty matches that might occur
    matches = [(key, value) for key, value in matches if key and value]

    # Filter out the NAME entry as it's not a localization key
    filtered_matches = [(key, value) for key, value in matches if key != 'NAME']

    print(f"[DEBUG] Raw matches: {len(matches)}, Filtered matches: {len(filtered_matches)}")

    return dict(filtered_matches)


def get_language_files() -> List[Path]:
    """Get all language files in the gamemode/languages directory."""
    languages_dir = Path("gamemode/languages")
    if not languages_dir.exists():
        raise FileNotFoundError(f"Directory {languages_dir} not found")

    # Find all .lua files in the languages directory
    lua_files = list(languages_dir.glob("*.lua"))
    if not lua_files:
        raise FileNotFoundError(f"No .lua files found in {languages_dir}")

    return lua_files


def compare_localization_keys(language_files: List[Path]) -> Tuple[Dict[str, Dict[str, str]], Dict[str, Set[str]], Dict[str, List[Tuple[str, str]]]]:
    """
    Compare localization keys across all language files.

    Returns:
        Tuple containing:
        - Dictionary mapping file names to their key-value pairs
        - Dictionary mapping each key to the set of files that contain it
        - Dictionary mapping each key to list of (file, value) pairs for comparison
    """
    all_keys = {}
    key_files = {}
    key_values = {}

    # Parse all files
    for file_path in language_files:
        file_name = file_path.stem  # Get filename without extension
        keys = parse_lua_localization_file(str(file_path))
        all_keys[file_name] = keys

        # Debug: print key count for each file
        print(f"[DEBUG] {file_name}: {len(keys)} keys parsed")

        # Track which files contain each key and their values
        for key, value in keys.items():
            if key not in key_files:
                key_files[key] = set()
                key_values[key] = []
            key_files[key].add(file_name)
            key_values[key].append((file_name, value))

    return all_keys, key_files, key_values


def generate_markdown_report(all_keys: Dict[str, Dict[str, str]], key_files: Dict[str, Set[str]], key_values: Dict[str, List[Tuple[str, str]]]) -> str:
    """
    Generate a markdown report of missing and inconsistent localization keys.
    """
    # Get all unique keys across all files
    all_unique_keys = set()
    for keys in all_keys.values():
        all_unique_keys.update(keys.keys())

    # Sort keys for consistent output
    sorted_keys = sorted(all_unique_keys)

    # Get list of all languages for consistent column ordering
    all_languages = sorted(all_keys.keys())

    report = ["# Localization Keys Sync Report\n"]
    report.append(f"Generated on: {__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    report.append("## Summary\n")
    report.append(f"- **Total unique keys found:** {len(all_unique_keys)}")
    report.append(f"- **Languages checked:** {', '.join(all_languages)}")
    report.append("")

    # Find missing keys for each language
    missing_keys = {}
    for lang in all_languages:
        missing_keys[lang] = all_unique_keys - set(all_keys[lang].keys())

    # Find inconsistent values (same key, different values across languages)
    inconsistent_keys = {}
    for key, values in key_values.items():
        if len(values) > 1:  # Only check if key exists in multiple files
            unique_values = set(value for _, value in values)
            if len(unique_values) > 1:  # Multiple different values
                inconsistent_keys[key] = values

    if missing_keys:
        report.append("## Missing Keys\n")
        for lang in all_languages:
            if missing_keys[lang]:
                report.append(f"### {lang.title()} ({len(missing_keys[lang])} missing keys)\n")
                for key in sorted(missing_keys[lang]):
                    report.append(f"- `{key}`")
                report.append("")

    if inconsistent_keys:
        report.append("## Inconsistent Values\n")
        report.append("Keys that have different values across languages:\n")
        for key in sorted(inconsistent_keys.keys()):
            report.append(f"### `{key}`\n")
            for lang, value in inconsistent_keys[key]:
                report.append(f"- **{lang}:** `{value}`")
            report.append("")

    # Complete key-value table
    report.append("## Complete Key-Value Reference\n")
    report.append("| Key | " + " | ".join(f"{lang.title()}" for lang in all_languages) + " |")
    report.append("|-----|" + "|".join("-" * (len(lang) + 2) for lang in all_languages) + "|")

    for key in sorted_keys:
        row = [f"`{key}`"]
        for lang in all_languages:
            if key in all_keys[lang]:
                # Escape markdown special characters in values
                value = all_keys[lang][key].replace("|", "\\|").replace("*", "\\*").replace("_", "\\_")
                row.append(f"`{value}`")
            else:
                row.append("*Missing*")
        report.append("| " + " | ".join(row) + " |")
    report.append("")

    return "\n".join(report)


def main():
    """Main function to run the localization verification."""
    try:
        # Get language files
        language_files = get_language_files()
        print(f"Found {len(language_files)} language files: {[f.stem for f in language_files]}")

        # Compare localization keys
        all_keys, key_files, key_values = compare_localization_keys(language_files)

        # Generate markdown report
        report = generate_markdown_report(all_keys, key_files, key_values)

        # Write report to file
        output_file = "localization_sync_report.md"
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(report)

        print(f"\n[SUCCESS] Localization sync report generated: {output_file}")

        # Print summary to console
        total_keys = len(set().union(*[set(keys.keys()) for keys in all_keys.values()]))
        print(f"[INFO] Total unique keys found: {total_keys}")

        # Check for missing keys
        missing_count = sum(len(set().union(*[set(keys.keys()) for keys in all_keys.values()]) - set(keys.keys()))
                          for keys in all_keys.values())

        if missing_count > 0:
            print(f"[WARNING] Found missing keys across {missing_count} entries")

        # Check for inconsistent values
        inconsistent_count = sum(1 for values in key_values.values()
                               if len(values) > 1 and len(set(v for _, v in values)) > 1)

        if inconsistent_count > 0:
            print(f"[WARNING] Found {inconsistent_count} keys with inconsistent values")

        if missing_count == 0 and inconsistent_count == 0:
            print("[SUCCESS] All localization keys are properly synced!")

    except Exception as e:
        print(f"[ERROR] {e}")
        return 1

    return 0


if __name__ == "__main__":
    exit(main())

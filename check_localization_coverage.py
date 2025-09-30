#!/usr/bin/env python3
"""
Check localization coverage and consistency across all language files
"""

import os
import re
from pathlib import Path

def extract_localization_keys():
    """Extract all localization keys from the English file"""
    english_file = Path("gamemode/languages/english.lua")

    if not english_file.exists():
        print("English language file not found!")
        return set()

    try:
        with open(english_file, 'r', encoding='utf-8') as f:
            content = f.read()

        # Extract key-value pairs
        pairs = re.findall(r'(\w+)\s*=\s*"([^"]*)"', content)
        keys = {key for key, value in pairs}

        return keys
    except Exception as e:
        print(f"Error reading English file: {e}")
        return set()

def check_language_coverage(language_file, expected_keys):
    """Check coverage for a specific language file"""
    if not os.path.exists(language_file):
        print(f"Language file not found: {language_file}")
        return set(), set()

    try:
        with open(language_file, 'r', encoding='utf-8') as f:
            content = f.read()

        # Extract existing keys
        pairs = re.findall(r'(\w+)\s*=\s*"([^"]*)"', content)
        existing_keys = {key for key, value in pairs}

        # Find missing keys
        missing_keys = expected_keys - existing_keys

        # Find extra keys (keys that exist but shouldn't)
        extra_keys = existing_keys - expected_keys

        return missing_keys, extra_keys
    except Exception as e:
        print(f"Error reading {language_file}: {e}")
        return set(), set()

def main():
    print("Checking localization coverage...")

    # Get expected keys from English
    expected_keys = extract_localization_keys()
    print(f"Found {len(expected_keys)} expected localization keys")

    if not expected_keys:
        return

    # Check each language file
    lang_files = {
        'French': 'gamemode/languages/french.lua',
        'German': 'gamemode/languages/german.lua',
        'Portuguese': 'gamemode/languages/portuguese.lua',
        'Spanish': 'gamemode/languages/spanish.lua'
    }

    total_missing = 0

    for lang_name, filepath in lang_files.items():
        print(f"\nChecking {lang_name}...")

        missing, extra = check_language_coverage(filepath, expected_keys)

        if missing:
            print(f"  Missing keys ({len(missing)}):")
            for key in sorted(missing)[:10]:  # Show first 10
                print(f"    {key}")
            if len(missing) > 10:
                print(f"    ... and {len(missing) - 10} more")
            total_missing += len(missing)

        if extra:
            print(f"  Extra keys ({len(extra)}):")
            for key in sorted(extra)[:5]:  # Show first 5
                print(f"    {key}")
            if len(extra) > 5:
                print(f"    ... and {len(extra) - 5} more")

    print(f"\nTotal missing translations: {total_missing}")

    if total_missing == 0:
        print("✅ All language files have complete coverage!")
    else:
        print(f"❌ {total_missing} translations are missing across all language files")

if __name__ == "__main__":
    main()

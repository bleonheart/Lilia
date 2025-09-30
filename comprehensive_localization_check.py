#!/usr/bin/env python3
"""
Comprehensive check for unlocalized strings across the entire codebase
"""

import os
import re
from pathlib import Path

def load_all_localized_strings():
    """Load all strings from all language files"""
    localized_strings = set()
    language_dir = Path("gamemode/languages")

    for lang_file in language_dir.glob("*.lua"):
        try:
            with open(lang_file, 'r', encoding='utf-8') as f:
                content = f.read()

            # Extract string values from LANGUAGE table
            strings = re.findall(r'\s*[\w_]+\s*=\s*"([^"]*)"', content)
            localized_strings.update(strings)
        except:
            pass

    return localized_strings

def find_potential_unlocalized_strings():
    """Find strings that might need localization"""
    localized_strings = load_all_localized_strings()
    candidates = set()

    # Check key directories for Lua files
    key_dirs = [
        "gamemode/core",
        "gamemode/modules",
        "gamemode/entities"
    ]

    for dir_path in key_dirs:
        if Path(dir_path).exists():
            for lua_file in Path(dir_path).rglob("*.lua"):
                try:
                    with open(lua_file, 'r', encoding='utf-8') as f:
                        content = f.read()

                    # Remove comments
                    content = re.sub(r'--.*$', '', content, flags=re.MULTILINE)

                    # Find string literals
                    strings = re.findall(r'"([^"]*)"', content)

                    for string in strings:
                        # Skip if already localized
                        if string in localized_strings:
                            continue

                        # Skip empty or very short strings
                        if not string.strip() or len(string) < 3:
                            continue

                        # Skip code-like strings
                        if re.match(r'^[A-Z_][A-Z0-9_]*$', string):
                            continue

                        # Skip file paths and URLs
                        if '/' in string or '\\' in string or '.mdl' in string:
                            continue

                        # Skip strings with code patterns
                        if any(pattern in string for pattern in ['%s', '%d', '==', '++', '--', '..']):
                            continue

                        # Only include strings that look like user-facing text
                        if (' ' in string or
                            string.endswith('.') or
                            string.endswith('!') or
                            string.endswith('?') or
                            any(word in string.lower() for word in ['the', 'and', 'for', 'are', 'but', 'not', 'you', 'can', 'will', 'should', 'have', 'this', 'that'])):

                            # Skip if it looks like a variable or function name
                            if not re.match(r'^[a-z][a-zA-Z]*$', string) or ' ' in string:
                                candidates.add(string)

                except:
                    pass

    return sorted(list(candidates))

def main():
    print("Running comprehensive localization check...")
    candidates = find_potential_unlocalized_strings()

    print(f"Found {len(candidates)} potential unlocalized strings")

    if candidates:
        print("\nTop candidates:")
        for i, candidate in enumerate(candidates[:20], 1):
            print(f"{i:2d}. '{candidate}'")

        if len(candidates) > 20:
            print(f"... and {len(candidates) - 20} more")

        # Save to file for review
        with open('remaining_candidates.txt', 'w', encoding='utf-8') as f:
            for candidate in candidates:
                f.write(f"'{candidate}'\n")

        print("\nFull list saved to remaining_candidates.txt")
    else:
        print("No unlocalized strings found!")

if __name__ == "__main__":
    main()

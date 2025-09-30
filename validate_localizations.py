#!/usr/bin/env python3
"""
Validation script for localization files
"""

import os
import re

def validate_lua_file(filepath):
    """Validate a Lua file for basic syntax issues"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Check for balanced braces
        lines = content.split('\n')
        brace_count = 0

        for line in lines:
            # Skip comments and strings for brace counting
            in_string = False
            escape_next = False

            for char in line:
                if escape_next:
                    escape_next = False
                    continue
                if char == '\\':
                    escape_next = True
                    continue
                if char == '"' and not in_string:
                    in_string = True
                elif char == '"' and in_string:
                    in_string = False
                elif not in_string and char not in [' ', '\t', '-']:
                    if char == '{':
                        brace_count += 1
                    elif char == '}':
                        brace_count -= 1

        if brace_count != 0:
            print(f'ERROR: Unbalanced braces in {filepath}: {brace_count}')
            return False

        return True
    except Exception as e:
        print(f'ERROR reading {filepath}: {e}')
        return False

def check_duplicate_keys(filepath):
    """Check for duplicate localization keys"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Extract key-value pairs
        pairs = re.findall(r'(\w+)\s*=\s*"([^"]*)"', content)
        keys = [pair[0] for pair in pairs]

        duplicates = set()
        seen = set()

        for key in keys:
            if key in seen:
                duplicates.add(key)
            seen.add(key)

        if duplicates:
            print(f'WARNING: Duplicate keys in {filepath}: {", ".join(duplicates)}')

        return len(duplicates) == 0
    except Exception as e:
        print(f'ERROR checking duplicates in {filepath}: {e}')
        return False

def main():
    print("Validating localization files...")

    lang_files = [
        'gamemode/languages/english.lua',
        'gamemode/languages/french.lua',
        'gamemode/languages/german.lua',
        'gamemode/languages/portuguese.lua',
        'gamemode/languages/spanish.lua'
    ]

    all_valid = True

    for filepath in lang_files:
        if os.path.exists(filepath):
            print(f"\nChecking {filepath}...")

            # Validate syntax
            syntax_ok = validate_lua_file(filepath)
            if not syntax_ok:
                all_valid = False

            # Check for duplicate keys
            duplicates_ok = check_duplicate_keys(filepath)
            if not duplicates_ok:
                all_valid = False

            if syntax_ok and duplicates_ok:
                print(f"✓ {filepath} - OK")
        else:
            print(f"ERROR: {filepath} not found")
            all_valid = False

    if all_valid:
        print("\n✅ All localization files are valid!")
    else:
        print("\n❌ Some localization files have issues!")

    return all_valid

if __name__ == "__main__":
    main()

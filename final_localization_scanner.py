#!/usr/bin/env python3
"""
Final Localization Scanner for Lilia Gamemode
Finds strings in code that aren't in language files
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

def find_unlocalized_strings():
    """Find strings in code that aren't localized"""
    localized_strings = load_all_localized_strings()
    candidates = []

    for root, dirs, files in os.walk('gamemode'):
        for file in files:
            if file.endswith('.lua'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()

                    # Remove comments
                    content = re.sub(r'--.*$', '', content, flags=re.MULTILINE)

                    # Find string literals - both single and double quoted
                    strings = re.findall(r'"([^"]*)"', content)
                    single_strings = re.findall(r"'([^']*)'", content)
                    strings.extend(single_strings)

                    for string in strings:
                        # Skip if already localized
                        if string in localized_strings:
                            continue

                        # Skip empty or very short strings
                        if not string.strip() or len(string) < 3:
                            continue

                        # Skip obvious code patterns
                        if re.match(r'^[A-Z_][A-Z0-9_]*$', string):  # ALL_CAPS
                            continue

                        # Skip file paths and URLs
                        if '/' in string or '\\' in string or '.mdl' in string or '.wav' in string or '.mp3' in string:
                            continue

                        # Skip strings with code patterns
                        if any(pattern in string for pattern in ['%s', '%d', '==', '++', '--', '..']):
                            continue

                        # Skip strings that look like variable names or function calls
                        if re.search(r'\w+\([^)]*\)', string):
                            continue

                        # Skip strings with brackets/braces that suggest code
                        if re.search(r'[{}()\[\]]', string):
                            continue

                        # Skip strings that are clearly internal/technical
                        if any(keyword in string.lower() for keyword in ['function', 'local', 'if', 'then', 'else', 'end', 'return', 'nil', 'true', 'false']):
                            continue

                        # Skip SQL fragments
                        if any(sql_word in string.upper() for sql_word in ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'FROM', 'WHERE', 'ORDER BY', 'LIMIT', 'AND', 'OR', 'NOT', 'NULL']):
                            continue

                        # Skip console commands and CVars
                        if string.startswith('+') or string.startswith('-') or string.startswith('sv_') or string.startswith('cl_'):
                            continue

                        # Only include strings that look like natural language
                        if (' ' in string or
                            string.endswith('.') or
                            string.endswith('!') or
                            string.endswith('?') or
                            string.lower() in ['ok', 'cancel', 'yes', 'no', 'save', 'load', 'delete', 'edit', 'create', 'close', 'open', 'settings', 'help', 'info', 'warning', 'error', 'success', 'failed', 'loading', 'ready', 'enabled', 'disabled', 'active', 'inactive']):

                            # Skip if it looks like a variable or function name
                            if not re.match(r'^[a-z][a-zA-Z]*$', string) or ' ' in string:
                                candidates.append(string)

                except:
                    pass

    return sorted(list(set(candidates)))

def main():
    print("Running final localization scan...")
    candidates = find_unlocalized_strings()

    print(f"Found {len(candidates)} potential unlocalized strings")

    if candidates:
        print("\nTop candidates:")
        for i, candidate in enumerate(candidates[:30], 1):
            print(f"{i:2d}. '{candidate}'")

        if len(candidates) > 30:
            print(f"... and {len(candidates) - 30} more")

        # Save to file for review
        with open('final_candidates.txt', 'w', encoding='utf-8') as f:
            for candidate in candidates:
                f.write(f"'{candidate}'\n")

        print("\nFull list saved to final_candidates.txt")
    else:
        print("No unlocalized strings found!")

if __name__ == "__main__":
    main()

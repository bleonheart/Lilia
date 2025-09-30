#!/usr/bin/env python3
"""
Comprehensive Localization Scanner for Lilia Gamemode
Finds all unlocalized English strings that need to be added to language files
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
    """Find English strings that are not localized"""
    localized_strings = load_all_localized_strings()
    candidates = set()

    # Patterns that indicate UI contexts where strings need localization
    ui_patterns = [
        # Chat and notification functions
        r"(?:ChatPrint|notify|MsgC|lia.chat.send)\s*\(\s*[\"']([^\"']+)[\"']",
        # Surface text drawing
        r"draw\.SimpleText\s*\(\s*[\"']([^\"']+)[\"']",
        r"draw\.DrawText\s*\(\s*[\"']([^\"']+)[\"']",
        # VGUI text elements
        r"SetText\s*\(\s*[\"']([^\"']+)[\"']",
        r"SetTitle\s*\(\s*[\"']([^\"']+)[\"']",
        r"SetPlaceholderText\s*\(\s*[\"']([^\"']+)[\"']",
        r"AddOption\s*\(\s*[\"']([^\"']+)[\"']",
        r"SetValue\s*\(\s*[\"']([^\"']+)[\"']",
        r"SetHelpText\s*\(\s*[\"']([^\"']+)[\"']",
        # Derma menu options
        r"AddSubMenu\s*\(\s*[\"']([^\"']+)[\"']",
        # Panel text content
        r"SetText\s*\(\s*[\"']([^\"']+)[\"']",
        # Button text
        r"SetButtonText\s*\(\s*[\"']([^\"']+)[\"']",
        # Label text
        r"SetLabelText\s*\(\s*[\"']([^\"']+)[\"']",
        # Tooltip text
        r"SetTooltip\s*\(\s*[\"']([^\"']+)[\"']",
        # Console print
        r"print\s*\(\s*[\"']([^\"']+)[\"']",
        # Error messages
        r"error\s*\(\s*[\"']([^\"']+)[\"']",
        # Warning messages
        r"warning\s*\(\s*[\"']([^\"']+)[\"']",
    ]

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
                    content = re.sub(r'--\[\[.*?\]\]', '', content, flags=re.DOTALL)

                    # Find strings in UI contexts
                    for pattern in ui_patterns:
                        matches = re.findall(pattern, content, re.IGNORECASE)
                        for match in matches:
                            # Skip if already localized
                            if match in localized_strings:
                                continue

                            # Skip empty or very short strings
                            if not match.strip() or len(match) < 2:
                                continue

                            # Skip obvious code patterns
                            if re.match(r'^[A-Z_][A-Z0-9_]*$', match):  # ALL_CAPS
                                continue

                            # Skip file paths and URLs
                            if '/' in match or '\\' in match or '.mdl' in match or '.wav' in match or '.mp3' in match:
                                continue

                            # Skip strings with code patterns
                            if any(pattern in match for pattern in ['%s', '%d', '==', '++', '--', '..']):
                                continue

                            # Skip strings that look like variable names or function calls
                            if re.search(r'\w+\([^)]*\)', match):
                                continue

                            # Skip hex colors and other code-like strings
                            if re.match(r'^#[0-9A-Fa-f]{6}$', match):
                                continue

                            # Skip numeric strings
                            if match.isdigit():
                                continue

                            # Only include strings that look like natural language
                            if (' ' in match or
                                match.endswith('.') or
                                match.endswith('!') or
                                match.endswith('?') or
                                match.endswith(':') or
                                match.endswith(',') or
                                match.lower() in ['ok', 'cancel', 'yes', 'no', 'save', 'load', 'delete', 'edit', 'create', 'close', 'open', 'settings', 'help', 'info', 'warning', 'error', 'success', 'failed', 'loading', 'ready', 'enabled', 'disabled', 'active', 'inactive', 'on', 'off', 'true', 'false']):

                                candidates.add(match.strip())

                except Exception as e:
                    print(f"Error processing {lua_file}: {e}")
                    pass

    return sorted(list(candidates))

def find_hardcoded_english_strings():
    """Find hardcoded English strings that should be localized"""
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
                    content = re.sub(r'--\[\[.*?\]\]', '', content, flags=re.DOTALL)

                    # Find string literals that are NOT preceded by L( and are in UI contexts
                    lines = content.split('\n')
                    for line_num, line in enumerate(lines, 1):
                        # Look for string literals in UI contexts that aren't localized
                        string_patterns = [
                            r'SetText\s*\(\s*["\']([^"\']+)["\']',
                            r'SetTitle\s*\(\s*["\']([^"\']+)["\']',
                            r'SetPlaceholderText\s*\(\s*["\']([^"\']+)["\']',
                            r'AddOption\s*\(\s*["\']([^"\']+)["\']',
                            r'SetValue\s*\(\s*["\']([^"\']+)["\']',
                            r'SetHelpText\s*\(\s*["\']([^"\']+)["\']',
                            r'ChatPrint\s*\(\s*["\']([^"\']+)["\']',
                            r'notify\s*\(\s*["\']([^"\']+)["\']',
                            r'MsgC\s*\(\s*["\']([^"\']+)["\']',
                            r'draw\.SimpleText\s*\(\s*["\']([^"\']+)["\']',
                            r'print\s*\(\s*["\']([^"\']+)["\']',
                            r'error\s*\(\s*["\']([^"\']+)["\']',
                        ]

                        for pattern in string_patterns:
                            if re.search(pattern, line):
                                # Extract the string
                                string_match = re.search(r'["\']([^"\']+)["\']', line)
                                if string_match:
                                    string = string_match.group(1)

                                    # Skip if it's already using L() function
                                    if 'L(' in line and (f'L("{string}")' in line or f"L('{string}')" in line):
                                        continue

                                    # Skip if it looks like a variable reference
                                    if re.search(r'\w+\.\w+', string) or re.search(r'\$\w+', string):
                                        continue

                                    # Apply same filters as before
                                    if (string.strip() and len(string) >= 2 and
                                        not re.match(r'^[A-Z_][A-Z0-9_]*$', string) and
                                        '/' not in string and '\\' not in string and
                                        not any(ext in string for ext in ['.mdl', '.wav', '.mp3']) and
                                        not any(pattern in string for pattern in ['%s', '%d', '==', '++', '--', '..']) and
                                        not re.match(r'^#[0-9A-Fa-f]{6}$', string) and
                                        not string.isdigit() and
                                        (' ' in string or string.endswith('.') or string.endswith('!') or string.endswith('?') or string.endswith(':') or string.endswith(',') or
                                         string.lower() in ['ok', 'cancel', 'yes', 'no', 'save', 'load', 'delete', 'edit', 'create', 'close', 'open', 'settings', 'help', 'info', 'warning', 'error', 'success', 'failed', 'loading', 'ready', 'enabled', 'disabled', 'active', 'inactive', 'on', 'off', 'true', 'false'])):

                                        candidates.add(string.strip())

                except Exception as e:
                    print(f"Error processing {lua_file}: {e}")
                    pass

    return sorted(list(candidates))

def main():
    print("Running comprehensive localization scan...")

    # Get strings from UI contexts
    ui_strings = find_unlocalized_strings()

    # Get hardcoded English strings
    hardcoded_strings = find_hardcoded_english_strings()

    # Combine and deduplicate
    all_candidates = sorted(list(set(ui_strings + hardcoded_strings)))

    print(f"Found {len(all_candidates)} potential unlocalized English strings")

    if all_candidates:
        print("\nUnlocalized strings found:")
        for i, candidate in enumerate(all_candidates[:100], 1):
            print(f"{i:3d}. '{candidate}'")

        if len(all_candidates) > 100:
            print(f"... and {len(all_candidates) - 100} more")

        # Save to file for review
        with open('remaining_candidates.txt', 'w', encoding='utf-8') as f:
            for candidate in all_candidates:
                f.write(f"'{candidate}'\n")

        print("\nFull list saved to remaining_candidates.txt")
    else:
        print("No unlocalized strings found!")

if __name__ == "__main__":
    main()

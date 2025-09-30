#!/usr/bin/env python3
"""
Smart Localization Scanner for Lilia Gamemode
Uses pattern matching to find strings used in UI contexts, notifications, and chat
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

def find_ui_context_strings():
    """Find strings used in UI contexts that likely need localization"""
    localized_strings = load_all_localized_strings()
    candidates = set()

    # Patterns that indicate UI contexts where strings need localization
    ui_patterns = [
        # Chat and notification functions
        r"(?:ChatPrint|notify|MsgC)\s*\(\s*[\"']([^\"']+)[\"']",
        r"L\(\s*[\"']([^\"']+)[\"']\s*\)",
        # Surface text drawing
        r"draw\.SimpleText\s*\(\s*[\"']([^\"']+)[\"']",
        r"surface\.CreateFont\s*\([^)]*font\s*=\s*[\"']([^\"']+)[\"']",
        # VGUI text elements
        r"SetText\s*\(\s*[\"']([^\"']+)[\"']",
        r"SetTitle\s*\(\s*[\"']([^\"']+)[\"']",
        r"SetPlaceholderText\s*\(\s*[\"']([^\"']+)[\"']",
        r"AddOption\s*\(\s*[\"']([^\"']+)[\"']",
        # Panel text content
        r"SetValue\s*\(\s*[\"']([^\"']+)[\"']",
        # Derma menu options
        r"AddSubMenu\s*\(\s*[\"']([^\"']+)[\"']",
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

                    # Find strings in UI contexts
                    for pattern in ui_patterns:
                        matches = re.findall(pattern, content)
                        for match in matches:
                            # Skip if already localized
                            if match in localized_strings:
                                continue

                            # Skip empty or very short strings
                            if not match.strip() or len(match) < 3:
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

                            # Only include strings that look like natural language
                            if (' ' in match or
                                match.endswith('.') or
                                match.endswith('!') or
                                match.endswith('?') or
                                match.lower() in ['ok', 'cancel', 'yes', 'no', 'save', 'load', 'delete', 'edit', 'create', 'close', 'open', 'settings', 'help', 'info', 'warning', 'error', 'success', 'failed', 'loading', 'ready', 'enabled', 'disabled', 'active', 'inactive']):

                                candidates.add(match)

                except:
                    pass

    return sorted(list(candidates))

def find_unlocalized_ui_strings():
    """Find strings in UI contexts that are not using L() function"""
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

                    # Find string literals that are NOT preceded by L( and are in UI contexts
                    lines = content.split('\n')
                    for line_num, line in enumerate(lines, 1):
                        # Look for string literals in UI contexts that aren't localized
                        if re.search(r'\b(SetText|SetTitle|SetPlaceholderText|AddOption|SetValue|ChatPrint|notify|MsgC|draw\.SimpleText)\s*\(\s*["\']([^"\']+)["\']', line):
                            # Extract the string
                            string_match = re.search(r'["\']([^"\']+)["\']', line)
                            if string_match:
                                string = string_match.group(1)

                                # Skip if it's already using L() function
                                if 'L(' in line and f'L("{string}")' in line or f"L('{string}')" in line:
                                    continue

                                # Skip if it looks like a variable reference
                                if re.search(r'\w+\.\w+', string) or re.search(r'\$\w+', string):
                                    continue

                                # Apply same filters as before
                                if (string.strip() and len(string) >= 3 and
                                    not re.match(r'^[A-Z_][A-Z0-9_]*$', string) and
                                    '/' not in string and '\\' not in string and
                                    not any(ext in string for ext in ['.mdl', '.wav', '.mp3']) and
                                    not any(pattern in string for pattern in ['%s', '%d', '==', '++', '--', '..']) and
                                    (' ' in string or string.endswith('.') or string.endswith('!') or string.endswith('?') or
                                     string.lower() in ['ok', 'cancel', 'yes', 'no', 'save', 'load', 'delete', 'edit', 'create', 'close', 'open', 'settings', 'help', 'info', 'warning', 'error', 'success', 'failed', 'loading', 'ready', 'enabled', 'disabled', 'active', 'inactive'])):

                                    candidates.add(string)

                except:
                    pass

    return sorted(list(candidates))

def main():
    print("Running smart localization scan...")

    # Get strings from UI contexts
    ui_strings = find_ui_context_strings()

    # Get unlocalized UI strings
    unlocalized_strings = find_unlocalized_ui_strings()

    # Combine and deduplicate
    all_candidates = sorted(list(set(ui_strings + unlocalized_strings)))

    print(f"Found {len(all_candidates)} potential user-facing strings")

    if all_candidates:
        print("\nTop candidates:")
        for i, candidate in enumerate(all_candidates[:50], 1):
            print(f"{i:2d}. '{candidate}'")

        if len(all_candidates) > 50:
            print(f"... and {len(all_candidates) - 50} more")

        # Save to file for review
        with open('smart_candidates.txt', 'w', encoding='utf-8') as f:
            for candidate in all_candidates:
                f.write(f"'{candidate}'\n")

        print("\nFull list saved to smart_candidates.txt")
    else:
        print("No user-facing strings found!")

if __name__ == "__main__":
    main()

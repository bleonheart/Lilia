#!/usr/bin/env python3
"""
Final Comprehensive Localization Scanner for Lilia Gamemode
Finds all remaining unlocalized English strings that need to be added to language files
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
        except Exception as e:
            print(f"Error reading {lang_file}: {e}")

    return localized_strings

def find_unlocalized_strings():
    """Find English strings that are not localized"""
    localized_strings = load_all_localized_strings()
    candidates = set()

    # Search in all Lua files except language files
    lua_files = []
    for root, dirs, files in os.walk("gamemode"):
        # Skip language files and some other directories
        if "languages" in root:
            continue
        for file in files:
            if file.endswith(".lua"):
                lua_files.append(os.path.join(root, file))

    for lua_file in lua_files:
        try:
            with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()

            # Skip files that are mostly comments or configurations
            if len(content.strip()) < 100:
                continue

            # Find strings that appear to be user-facing English text
            # Look for strings in various UI contexts
            patterns = [
                # Chat and notification functions
                r"(?:ChatPrint|notify|MsgC|lia\.chat\.send)\s*\(\s*[\"']([^\"']+)[\"']",
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
                r"SetHTML\s*\(\s*[\"']([^\"']+)[\"']",
                # Error messages and user feedback
                r"LIA_PRINT\s*\(\s*[\"']([^\"']+)[\"']",
                # Direct string literals in UI contexts
                r"[\"']([A-Z][^\"']*[.!?])[\"']",
                # Menu and button text
                r"button\.SetText\s*\(\s*[\"']([^\"']+)[\"']",
                # Label text
                r"label\.SetText\s*\(\s*[\"']([^\"']+)[\"']",
                # Frame titles
                r"frame\.SetTitle\s*\(\s*[\"']([^\"']+)[\"']",
                # Tooltip text
                r"SetTooltip\s*\(\s*[\"']([^\"']+)[\"']",
            ]

            for pattern in patterns:
                matches = re.findall(pattern, content, re.MULTILINE | re.IGNORECASE)
                for match in matches:
                    # Clean up the string
                    string = match.strip()
                    if (len(string) > 2 and  # Not too short
                        not string.isdigit() and  # Not a number
                        not any(char in string for char in ['%', '\\', '{', '}', '[', ']']) and  # Not a format string
                        string not in localized_strings and  # Not already localized
                        not re.match(r'^[0-9\s\.,\-()]+$', string) and  # Not just numbers/symbols
                        not string.startswith(('http', 'www', 'ftp')) and  # Not URLs
                        not string.endswith(('.lua', '.txt', '.cfg', '.ini', '.json', '.xml')) and  # Not file extensions
                        string not in ['Yes', 'No', 'OK', 'Cancel', 'Close', 'Open', 'Save', 'Load', 'Delete', 'Edit', 'Create', 'Remove', 'Add', 'Apply', 'Reset', 'Default', 'None', 'All', 'Help', 'Info', 'Warning', 'Error', 'Success', 'Failed', 'Enabled', 'Disabled', 'On', 'Off', 'True', 'False']):  # Common UI words

                        # Filter out code-like strings
                        if not re.search(r'[{}()\[\]]', string) and not string.count('.') > 2:
                            candidates.add(string)

        except Exception as e:
            print(f"Error processing {lua_file}: {e}")

    return candidates

def filter_legitimate_strings(candidates):
    """Filter out strings that don't need localization"""
    legitimate = set()

    # Common patterns that indicate legitimate user-facing strings
    legitimate_patterns = [
        r'^[A-Z].*[.!?]$',  # Sentences starting with capital letters
        r'^[A-Z][^.!?]*$',  # Titles and labels
        r'.*\s+[a-z]+\s+.*',  # Multi-word strings
        r'.*ing\s+.*',  # Gerunds
        r'.*ed\s+.*',  # Past tense verbs
        r'.*ly\s+.*',  # Adverbs
        r'.*ment\s+.*',  # Nouns ending in -ment
        r'.*tion\s+.*',  # Nouns ending in -tion
        r'.*ness\s+.*',  # Nouns ending in -ness
    ]

    # Words that indicate user-facing content
    user_facing_indicators = [
        'player', 'character', 'inventory', 'item', 'weapon', 'menu', 'button',
        'option', 'setting', 'config', 'admin', 'staff', 'server', 'game',
        'chat', 'message', 'notification', 'warning', 'error', 'success',
        'failed', 'cannot', 'unable', 'invalid', 'missing', 'found', 'created',
        'deleted', 'saved', 'loaded', 'opened', 'closed', 'enabled', 'disabled',
        'allowed', 'denied', 'granted', 'revoked', 'banned', 'kicked', 'muted',
        'jailed', 'killed', 'respawned', 'teleported', 'moved', 'copied', 'pasted',
        'selected', 'chosen', 'picked', 'taken', 'given', 'received', 'sent',
        'received', 'displayed', 'shown', 'hidden', 'visible', 'invisible'
    ]

    for candidate in candidates:
        candidate_lower = candidate.lower()
        # Check if it matches legitimate patterns
        is_legitimate = any(re.search(pattern, candidate) for pattern in legitimate_patterns)

        # Check if it contains user-facing indicator words
        has_indicators = any(indicator in candidate_lower for indicator in user_facing_indicators)

        # Check if it's a clear sentence or phrase
        is_sentence = (candidate[0].isupper() and
                      len(candidate.split()) >= 3 and
                      any(punct in candidate for punct in '.!?'))

        if is_legitimate or has_indicators or is_sentence:
            legitimate.add(candidate)

    return legitimate

def main():
    print("Scanning for unlocalized strings...")

    candidates = find_unlocalized_strings()
    print(f"Found {len(candidates)} potential unlocalized strings")

    # Filter for legitimate user-facing strings
    legitimate_strings = filter_legitimate_strings(candidates)
    print(f"Filtered to {len(legitimate_strings)} legitimate user-facing strings")

    # Sort and save results
    sorted_strings = sorted(legitimate_strings)

    # Save to file
    with open('remaining_unlocalized_strings.txt', 'w', encoding='utf-8') as f:
        f.write("Remaining Unlocalized Strings:\n")
        f.write("=" * 50 + "\n\n")
        for string in sorted_strings:
            f.write(f'"{string}"\n')

    print(f"Results saved to 'remaining_unlocalized_strings.txt'")
    print(f"Found {len(sorted_strings)} strings that need localization")

    if sorted_strings:
        print("\nSample strings found:")
        for string in sorted_strings[:10]:
            print(f'  "{string}"')
        if len(sorted_strings) > 10:
            print(f"  ... and {len(sorted_strings) - 10} more")

if __name__ == "__main__":
    main()

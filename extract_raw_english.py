#!/usr/bin/env python3
"""
Extract raw English strings that need localization from the filtered results
"""
import os
import re
from pathlib import Path

def load_filtered_strings():
    """Load the filtered user-facing strings"""
    try:
        with open('filtered_user_strings.txt', 'r', encoding='utf-8') as f:
            content = f.read()

        # Extract strings from the file
        strings_by_file = {}
        current_file = None
        current_strings = []

        for line in content.split('\n'):
            line = line.strip()
            if line.startswith('gamemode/') and line.endswith('strings):'):
                if current_file and current_strings:
                    strings_by_file[current_file] = current_strings
                current_file = line.split(' (')[0]
                current_strings = []
            elif line.startswith('"') and line.endswith('"'):
                # Extract the string content
                string_content = line[1:-1]
                # Skip if it's clearly code or not user-facing
                if not is_code_like(string_content) and is_user_facing(string_content):
                    current_strings.append(string_content)

        if current_file and current_strings:
            strings_by_file[current_file] = current_strings

        return strings_by_file

    except FileNotFoundError:
        print("filtered_user_strings.txt not found")
        return {}

def is_code_like(string_content):
    """Check if a string looks like code rather than user-facing text"""
    # Skip strings that are clearly code patterns
    code_patterns = [
        r'^[A-Z_]+\s*=',  # Constants like "NAME ="
        r'^[a-zA-Z_][a-zA-Z0-9_]*\s*=',  # Variable assignments
        r'^SELECT\s+',  # SQL queries
        r'^INSERT\s+',  # SQL queries
        r'^UPDATE\s+',  # SQL queries
        r'^DELETE\s+',  # SQL queries
        r'^DROP\s+',  # SQL queries
        r'^ALTER\s+',  # SQL queries
        r'^CREATE\s+',  # SQL queries
        r'^FROM\s+',  # SQL fragments
        r'^WHERE\s+',  # SQL fragments
        r'^AND\s+',  # SQL fragments
        r'^OR\s+',  # SQL fragments
        r'^[a-zA-Z_][a-zA-Z0-9_]*\s*\(',  # Function calls
        r'^[a-zA-Z_][a-zA-Z0-9_]*\s*\[',  # Array access
        r'^[a-zA-Z_][a-zA-Z0-9_]*\s*\.',  # Method calls
        r'^http[s]?://',  # URLs
        r'^[A-Z][a-z]+ [A-Z][a-z]+.*',  # Names like "John Doe"
        r'^[0-9\.\-\s]+$',  # Numbers and coordinates
        r'^#[0-9a-fA-F]{6}$',  # Hex colors
        r'^[A-Z_]{3,}$',  # Constants like "STEAM_ID"
    ]

    for pattern in code_patterns:
        if re.match(pattern, string_content.strip()):
            return True

    return False

def is_user_facing(string_content):
    """Check if a string is user-facing and needs localization"""
    # Must contain spaces or be a clear message
    if ' ' not in string_content and len(string_content) < 10:
        return False

    # Check for user-facing patterns
    user_patterns = [
        r'.*(?:error|Error|failed|Failed|invalid|Invalid).*',
        r'.*(?:cannot|Cannot|can\'t|Can\'t|unable|Unable|not allowed|Not Allowed).*',
        r'.*(?:need|Need|requires|Requires|missing|Missing).*',
        r'.*(?:success|Success|complete|Complete|done|Done).*',
        r'.*(?:loading|Loading|please wait|Please Wait).*',
        r'.*(?:press|Press|click|Click|select|Select).*',
        r'.*(?:use|Use|enter|Enter|type|Type).*',
        r'.*(?:warning|Warning|alert|Alert|notice|Notice).*',
        r'.*(?:information|Information|info|Info).*',
        r'.*(?:\?|question|Question|confirm|Confirm).*',
        r'.*(?:inventory|Inventory|item|Item|weapon|Weapon).*',
        r'.*(?:character|Character|faction|Faction|class|Class).*',
        r'.*(?:money|Money|cash|Cash|credit|Credit).*',
    ]

    for pattern in user_patterns:
        if re.search(pattern, string_content, re.IGNORECASE):
            return True

    # Check for strings that look like proper sentences
    if string_content[0].isupper() and len(string_content) > 15:
        return True

    # Check for UI-related words
    ui_words = ['menu', 'button', 'panel', 'window', 'dialog', 'message', 'notification', 'alert', 'warning']
    if any(word in string_content.lower() for word in ui_words):
        return True

    return False

def main():
    """Main function to extract raw English strings"""
    print("=== EXTRACTING RAW ENGLISH STRINGS FOR LOCALIZATION ===\n")

    strings_by_file = load_filtered_strings()

    all_strings = []
    for file_path, strings in strings_by_file.items():
        all_strings.extend(strings)

    print(f"Found {len(all_strings)} potential raw English strings across {len(strings_by_file)} files")

    # Remove duplicates and sort
    unique_strings = list(set(all_strings))
    unique_strings.sort()

    print(f"Unique strings: {len(unique_strings)}")

    # Show some examples
    print("\n=== SAMPLE STRINGS ===")
    for i, string in enumerate(unique_strings[:20]):
        print(f"{i+1}. '{string}'")

    if len(unique_strings) > 20:
        print(f"... and {len(unique_strings) - 20} more")

    # Save to file
    with open('raw_english_strings.txt', 'w', encoding='utf-8') as f:
        f.write("Raw English Strings That Need Localization:\n")
        f.write("=" * 50 + "\n\n")

        for string in unique_strings:
            f.write(f'"{string}"\n')

    print(f"\nSaved {len(unique_strings)} strings to raw_english_strings.txt")

if __name__ == "__main__":
    main()

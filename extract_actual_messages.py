#!/usr/bin/env python3
"""
Extract actual user-facing messages that need localization
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
                current_strings.append(string_content)

        if current_file and current_strings:
            strings_by_file[current_file] = current_strings

        return strings_by_file

    except FileNotFoundError:
        print("filtered_user_strings.txt not found")
        return {}

def is_actual_user_message(string_content):
    """Check if a string is an actual user-facing message"""
    # Skip if it's clearly code or technical
    code_indicators = [
        'SELECT ', 'INSERT ', 'UPDATE ', 'DELETE ', 'DROP ', 'ALTER ', 'CREATE ',
        ' FROM ', ' WHERE ', ' AND ', ' OR ', ' = ', ' LIKE ', ' JOIN ',
        'lia_', 'charID =', 'itemID =', 'invID =', 'steamID =',
        'function', 'end', 'return', 'local', 'if ', 'then', 'else',
        'net.', 'hook.', 'vgui.', 'draw.', 'surface.',
        'client:', 'notify', 'Error', 'Failed',
        '%s', '%d', '%%', '\\n', '\\t',
        'http', 'ftp', 'file.', 'data/',
        'icon16/', 'materials/', 'models/', 'sound/',
        '.mdl', '.wav', '.mp3', '.ogg', '.vmt', '.png', '.jpg',
    ]

    for indicator in code_indicators:
        if indicator in string_content:
            return False

    # Must be readable English text
    if not re.match(r'^[A-Za-z0-9\s\.,!?\-\'\"]+$', string_content):
        return False

    # Must contain spaces (likely a sentence or phrase)
    if ' ' not in string_content:
        return False

    # Should be a reasonable length for a message
    if len(string_content) < 8 or len(string_content) > 100:
        return False

    # Check for actual user-facing content
    user_keywords = [
        'character', 'password', 'failed', 'invalid', 'cannot', 'unable',
        'success', 'complete', 'loading', 'please', 'press', 'click',
        'select', 'use', 'enter', 'type', 'warning', 'alert', 'notice',
        'information', 'inventory', 'item', 'weapon', 'money', 'cash',
        'staff', 'admin', 'player', 'server', 'game', 'menu', 'button',
        'panel', 'window', 'dialog', 'message', 'notification'
    ]

    has_keyword = any(keyword in string_content.lower() for keyword in user_keywords)
    starts_with_capital = string_content[0].isupper()

    return has_keyword or starts_with_capital

def main():
    """Main function to extract actual user-facing messages"""
    print("=== EXTRACTING ACTUAL USER-FACING MESSAGES FOR LOCALIZATION ===\n")

    strings_by_file = load_filtered_strings()

    all_strings = []
    for file_path, strings in strings_by_file.items():
        for string in strings:
            if is_actual_user_message(string):
                all_strings.append((file_path, string))

    print(f"Found {len(all_strings)} actual user-facing messages across {len(strings_by_file)} files")

    # Group by string for uniqueness
    unique_messages = {}
    for file_path, string in all_strings:
        if string not in unique_messages:
            unique_messages[string] = []
        unique_messages[string].append(file_path)

    print(f"Unique messages: {len(unique_messages)}")

    # Show the messages
    print("\n=== USER-FACING MESSAGES ===")
    for i, (string, files) in enumerate(unique_messages.items()):
        print(f"{i+1}. '{string}'")
        print(f"    Files: {', '.join(set(files))}")
        print()

    # Save to file
    with open('actual_user_messages.txt', 'w', encoding='utf-8') as f:
        f.write("Actual User-Facing Messages That Need Localization:\n")
        f.write("=" * 60 + "\n\n")

        for string, files in unique_messages.items():
            f.write(f'"{string}"\n')
            f.write(f"Files: {', '.join(set(files))}\n\n")

    print(f"Saved {len(unique_messages)} messages to actual_user_messages.txt")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Filter unlocalized strings to find user-facing messages that need localization
"""
import os
import re
from pathlib import Path
from collections import defaultdict

def find_lua_files():
    """Find all Lua files in the gamemode directory"""
    lua_files = []
    for root, dirs, files in os.walk('gamemode'):
        # Skip language files and third-party libraries
        if "languages" in root or "thirdparty" in root or "vendor" in root.lower():
            continue
        for file in files:
            if file.endswith('.lua'):
                lua_files.append(os.path.join(root, file))
    return lua_files

def check_for_unlocalized_strings(file_path):
    """Check a file for potential unlocalized strings"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Find strings that look like they should be localized
        # Look for quoted strings that are not already wrapped in L() and are not comments
        unlocalized_patterns = []

        # Find strings like "Some text" that aren't in L() calls and aren't in comments
        string_pattern = r'"([^"]*)"'
        matches = re.finditer(string_pattern, content)

        for match in matches:
            string_content = match.group(1)
            start_pos = match.start()

            # Skip if this string is already in an L() call
            before_context = content[max(0, start_pos-50):start_pos]
            if 'L(' in before_context:
                continue

            # Skip if this is in a comment
            line_start = content.rfind('\n', 0, start_pos) + 1
            line_end = content.find('\n', start_pos)
            if line_end == -1:
                line_end = len(content)
            line = content[line_start:line_end]

            # Skip comments and certain patterns
            if ('--' in line[:line.find('"')]) or ('//' in line) or ('/*' in line):
                continue

            # Skip certain technical strings
            if (string_content.startswith('icon16/') or
                string_content.startswith('materials/') or
                string_content.startswith('models/') or
                string_content.startswith('sound/') or
                string_content.endswith('.mdl') or
                string_content.endswith('.wav') or
                string_content.endswith('.mp3') or
                string_content.endswith('.ogg') or
                string_content.endswith('.vmt') or
                string_content.endswith('.png') or
                string_content.endswith('.jpg') or
                string_content.endswith('.gma') or
                string_content.endswith('.lua') or
                string_content in ['NULL', 'nil', 'true', 'false'] or
                re.match(r'^[A-Za-z][A-Za-z0-9_]*$', string_content) or  # Variable names
                re.match(r'^[0-9\.\-\s]+$', string_content) or  # Numbers and coordinates
                re.match(r'^#[0-9a-fA-F]{6}$', string_content) or  # Hex colors
                re.match(r'^[A-Z_]+$', string_content)):  # Constants
                continue

            # Skip very short strings that are likely not user-facing
            if len(string_content) < 8:
                continue

            unlocalized_patterns.append((file_path, start_pos, string_content))

        return unlocalized_patterns

    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return []

def filter_user_messages(strings):
    """Filter strings to find user-facing messages"""
    user_message_patterns = [
        # Error messages
        r'.*(?:error|Error|ERROR|failed|Failed|FAILED|invalid|Invalid|INVALID).*',
        r'.*(?:cannot|Cannot|can\'t|Can\'t|unable|Unable|not allowed|Not Allowed).*',
        r'.*(?:need|Need|requires|Requires|missing|Missing).*',

        # Status messages
        r'.*(?:success|Success|SUCCESS|complete|Complete|COMPLETE|done|Done|DONE).*',
        r'.*(?:loading|Loading|LOADING|please wait|Please Wait|PLEASE WAIT).*',

        # User instructions
        r'.*(?:press|Press|PRESS|click|Click|CLICK|select|Select|SELECT).*',
        r'.*(?:use|Use|USE|enter|Enter|ENTER|type|Type|TYPE).*',

        # Notifications and alerts
        r'.*(?:warning|Warning|WARNING|alert|Alert|ALERT|notice|Notice|NOTICE).*',
        r'.*(?:information|Information|INFORMATION|info|Info|INFO).*',

        # Questions and confirmations
        r'.*(?:\?|question|Question|QUESTION|confirm|Confirm|CONFIRM).*',

        # Game-specific messages
        r'.*(?:inventory|Inventory|INVENTORY|item|Item|ITEM|weapon|Weapon|WEAPON).*',
        r'.*(?:character|Character|CHARACTER|faction|Faction|FACTION|class|Class|CLASS).*',
        r'.*(?:money|Money|MONEY|cash|Cash|CASH|credit|Credit|CREDIT).*',
        r'.*(?:level|Level|LEVEL|experience|Experience|EXPERIENCE|xp|XP).*',
        r'.*(?:quest|Quest|QUEST|mission|Mission|MISSION|task|Task|TASK).*',
        r'.*(?:achievement|Achievement|ACHIEVEMENT|reward|Reward|REWARD).*',
    ]

    filtered_strings = []
    for file_path, pos, string_content in strings:
        # Check if string matches user message patterns
        is_user_message = False
        for pattern in user_message_patterns:
            if re.search(pattern, string_content, re.IGNORECASE):
                is_user_message = True
                break

        # Also check for strings that look like sentences (contain spaces and common words)
        if not is_user_message and ' ' in string_content:
            # Check for strings that start with capital letters (likely proper sentences)
            if string_content[0].isupper() and len(string_content) > 15:
                is_user_message = True
            # Check for strings that contain common UI words
            elif any(word in string_content.lower() for word in ['menu', 'button', 'panel', 'window', 'dialog', 'message', 'notification', 'alert', 'warning']):
                is_user_message = True

        if is_user_message:
            filtered_strings.append((file_path, pos, string_content))

    return filtered_strings

def main():
    """Main function to check all Lua files"""
    print("=== FILTERING USER-FACING MESSAGES FOR LOCALIZATION ===\n")

    lua_files = find_lua_files()
    print(f"Found {len(lua_files)} Lua files to check")

    all_unlocalized = []
    for file_path in lua_files:
        unlocalized = check_for_unlocalized_strings(file_path)
        if unlocalized:
            all_unlocalized.extend(unlocalized)

    print(f"Found {len(all_unlocalized)} potential unlocalized strings")

    # Filter for user-facing messages
    user_messages = filter_user_messages(all_unlocalized)
    print(f"Found {len(user_messages)} user-facing messages that need localization")

    # Group by file and show results
    file_strings = defaultdict(list)
    for file_path, pos, string_content in user_messages:
        file_strings[file_path].append(string_content)

    print("\n=== USER-FACING STRINGS BY FILE ===")
    for file_path, strings in file_strings.items():
        print(f"\n{file_path} ({len(strings)} strings):")
        for string in strings[:5]:  # Show first 5 strings per file
            print(f'  "{string}"')
        if len(strings) > 5:
            print(f'  ... and {len(strings) - 5} more')

    # Save filtered results
    with open('filtered_user_strings.txt', 'w', encoding='utf-8') as f:
        f.write("User-Facing Strings That Need Localization:\n")
        f.write("=" * 50 + "\n\n")

        for file_path, strings in file_strings.items():
            f.write(f"{file_path} ({len(strings)} strings):\n")
            for string in strings:
                f.write(f'  "{string}"\n')
            f.write("\n")

if __name__ == "__main__":
    main()

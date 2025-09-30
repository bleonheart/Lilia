#!/usr/bin/env python3
"""
Comprehensive scanner for unlocalized strings in Lilia gamemode
"""
import os
import re
from pathlib import Path
from collections import defaultdict

def find_lua_files():
    """Find all Lua files in the gamemode directory"""
    lua_files = []
    for root, dirs, files in os.walk('gamemode'):
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
            if len(string_content) < 3:
                continue

            unlocalized_patterns.append((file_path, start_pos, string_content))

        return unlocalized_patterns

    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return []

def main():
    """Main function to check all Lua files"""
    print("=== COMPREHENSIVE SCAN FOR UNLOCALIZED STRINGS ===\n")

    lua_files = find_lua_files()
    print(f"Found {len(lua_files)} Lua files to check")

    all_unlocalized = []
    string_locations = defaultdict(list)

    for file_path in lua_files:
        unlocalized = check_for_unlocalized_strings(file_path)
        if unlocalized:
            print(f"\n{file_path} ({len(unlocalized)} potential unlocalized strings):")
            for _, _, string_content in unlocalized[:3]:  # Show first 3 only
                print(f'  "{string_content}"')
            if len(unlocalized) > 3:
                print(f'  ... and {len(unlocalized) - 3} more')
            all_unlocalized.extend(unlocalized)

            # Track locations for each string
            for file_path, _, string_content in unlocalized:
                string_locations[string_content].append(file_path)

    print(f"\n=== SUMMARY ===")
    print(f"Total potential unlocalized strings found: {len(all_unlocalized)}")

    if all_unlocalized:
        print("\n=== TOP 20 LONGEST STRINGS ===")
        sorted_strings = sorted(all_unlocalized, key=lambda x: len(x[2]), reverse=True)
        for i, (_, _, string_content) in enumerate(sorted_strings[:20]):
            locations = string_locations[string_content]
            print(f"{i+1}. ({len(string_content)} chars): '{string_content}'")
            print(f"    Files: {', '.join(set(locations))}")

    # Save results to file
    with open('remaining_unlocalized_strings.txt', 'w', encoding='utf-8') as f:
        f.write("Remaining Unlocalized Strings:\n")
        f.write("=" * 50 + "\n\n")

        for string_content, locations in string_locations.items():
            f.write(f'"{string_content}"\n')
            f.write(f"Files: {', '.join(set(locations))}\n\n")

if __name__ == "__main__":
    main()

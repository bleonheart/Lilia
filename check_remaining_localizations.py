#!/usr/bin/env python3
"""
Check for remaining unlocalized strings in Lilia gamemode
"""
import os
import re
import json

def find_lua_files():
    """Find all Lua files in the gamemode directory"""
    lua_files = []
    for root, dirs, files in os.walk('gamemode'):
        for file in files:
            if file.endswith('.lua'):
                lua_files.append(os.path.join(root, file))
    return lua_files

def generate_localization_key(text):
    """Generate a reasonable localization key from text"""
    # Remove special characters and convert to snake_case
    key = re.sub(r'[^\w\s]', '', text.lower())
    key = re.sub(r'\s+', '_', key.strip())
    # Limit length and add prefix if too short
    if len(key) < 3:
        key = f"text_{key}"
    elif len(key) > 50:
        key = key[:47] + "..."
    return key

def check_for_unlocalized_strings(file_path):
    """Check a file for potential unlocalized strings"""
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        # Find strings that look like they should be localized
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

            # Skip technical patterns that are clearly not user-facing
            skip_patterns = [
                # File paths and URLs
                'icon16/', 'materials/', 'models/', 'sound/', 'data/', 'lua/', 'gamemode/',
                '.mdl', '.wav', '.mp3', '.ogg', '.vmt', '.png', '.jpg', '.gma', '.lua',
                'http://', 'https://', 'www.', '.com', '.net', '.org',

                # Code patterns and markup
                '<font=', '</font>', '<color=', '<img=', '&lt;', '&gt;', '&amp;',
                'vgui/', 'pp/', 'ValveBiped.', 'liaChatFont', 'liaItem',

                # Regex patterns
                '^', '$', '%d', '%s', '%w', '%b',

                # Programming constructs
                'NULL', 'nil', 'true', 'false', 'function', 'local', 'if', 'then', 'else', 'end',
                'for', 'while', 'do', 'return', 'break', 'continue',

                # Technical constants
                'STEAM_', 'Color(', 'Vector(', 'Angle(', 'LIA_', 'lia.',

                # Very short technical strings
                'ID', 'IP', 'URL', 'API', 'GUI', 'HUD', 'SQL', 'DB', 'NET'
            ]

            # Check if string matches any skip pattern
            should_skip = False
            for pattern in skip_patterns:
                if pattern.lower() in string_content.lower():
                    should_skip = True
                    break

            if should_skip:
                continue

            # Skip variable names, numbers, hex colors, constants
            if (re.match(r'^[A-Za-z][A-Za-z0-9_]*$', string_content) or
                re.match(r'^[0-9\.\-\s]+$', string_content) or
                re.match(r'^#[0-9a-fA-F]{6}$', string_content) or
                re.match(r'^[A-Z_]+$', string_content)):
                continue

            # Skip very short strings that are likely not user-facing
            if len(string_content) < 4:
                continue

            # Skip very long strings that are clearly code (over 200 chars)
            if len(string_content) > 200:
                continue

            # Skip strings that look like code snippets (contain multiple operators)
            code_indicators = [' = ', ' == ', ' += ', ' -= ', 'if ', 'then ', 'end', 'function ', 'local ', 'self.', 'client:', 'player:']
            if any(indicator in string_content for indicator in code_indicators):
                continue

            # Skip strings that are mostly symbols or punctuation
            if len(re.findall(r'[a-zA-Z]', string_content)) < 3:
                continue

            # Generate a localization key for this string
            loc_key = generate_localization_key(string_content)

            unlocalized_patterns.append((file_path, start_pos, string_content, loc_key))

        return unlocalized_patterns

    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return []

def main():
    """Main function to check all Lua files"""
    print("=== CHECKING FOR UNLOCALIZED STRINGS ===\n")

    lua_files = find_lua_files()
    print(f"Found {len(lua_files)} Lua files to check")

    all_unlocalized = []

    # Process files in batches to avoid memory issues
    batch_size = 50
    for i in range(0, len(lua_files), batch_size):
        batch = lua_files[i:i+batch_size]
        print(f"Processing batch {i//batch_size + 1}/{(len(lua_files)-1)//batch_size + 1} ({len(batch)} files)")

        for file_path in batch:
            unlocalized = check_for_unlocalized_strings(file_path)
            if unlocalized:
                all_unlocalized.extend(unlocalized)

    print("\n=== SUMMARY ===")
    print(f"Total potential unlocalized strings found: {len(all_unlocalized)}")

    if all_unlocalized:
        # Save detailed results to JSON file for easier processing
        results = {
            "total_count": len(all_unlocalized),
            "strings": []
        }

        for file_path, _, string_content, loc_key in all_unlocalized:
            results["strings"].append({
                "file": file_path,
                "text": string_content,
                "key": loc_key
            })

        with open('unlocalized_detailed.json', 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, ensure_ascii=False)

        print(f"\nDetailed results saved to 'unlocalized_detailed.json'")

        # Save a human-readable text file with the top strings
        with open('unlocalized_strings.txt', 'w', encoding='utf-8') as f:
            f.write("UNLOCALIZED STRINGS THAT NEED LOCALIZATION\n")
            f.write("=" * 50 + "\n\n")

            # Group by file for better organization
            files_dict = {}
            for file_path, _, string_content, loc_key in all_unlocalized:
                if file_path not in files_dict:
                    files_dict[file_path] = []
                files_dict[file_path].append((string_content, loc_key))

            for file_path, strings in files_dict.items():
                f.write(f"{file_path} ({len(strings)} strings):\n")
                for string_content, loc_key in strings:
                    f.write(f'  L("{loc_key}") = "{string_content}"\n')
                f.write("\n")

        print(f"Human-readable results saved to 'unlocalized_strings.txt'")
        print(f"\nTop 10 longest strings:")
        sorted_strings = sorted(all_unlocalized, key=lambda x: len(x[2]), reverse=True)
        for i, (_, _, string_content, loc_key) in enumerate(sorted_strings[:10]):
            print(f"{i+1}. ({len(string_content)} chars): L('{loc_key}') = '{string_content}'")

if __name__ == "__main__":
    main()

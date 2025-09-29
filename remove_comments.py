#!/usr/bin/env python3
"""
Script to remove all comments from Lua files in the Lilia gamemode.
This script processes all .lua files and removes:
- Single line comments starting with --
- Multi-line comments enclosed in --[[ and ]]
"""

import os
import re
import glob

def remove_lua_comments(content):
    """
    Remove Lua comments from content while preserving strings.
    This is a simplified approach - a full parser would be more accurate.
    """
    # First, let's handle multi-line comments
    # Pattern to match --[[ ... ]] (including nested ones)
    multiline_pattern = r'--\[\[(?:[^\]]|\](?!\]))*\]\]'

    # Remove multi-line comments
    content = re.sub(multiline_pattern, '', content, flags=re.MULTILINE | re.DOTALL)

    # Now handle single-line comments
    # This is trickier because we need to avoid removing -- inside strings
    lines = content.split('\n')
    cleaned_lines = []

    for line in lines:
        # Skip empty lines that contain only whitespace and comments
        stripped = line.strip()
        if not stripped or stripped.startswith('--'):
            # Check if this line has any actual code before the comment
            code_part = line.split('--')[0].rstrip()
            if not code_part:  # Line is only a comment
                continue
            else:
                # Keep only the code part
                cleaned_lines.append(code_part)
        else:
            cleaned_lines.append(line)

    return '\n'.join(cleaned_lines)

def process_lua_file(filepath):
    """Process a single Lua file to remove comments."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            original_content = f.read()

        cleaned_content = remove_lua_comments(original_content)

        # Only write back if content changed
        if cleaned_content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(cleaned_content)
            return True
        return False

    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return False

def find_lua_files(directory):
    """Find all Lua files recursively."""
    lua_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.lua'):
                lua_files.append(os.path.join(root, file))
    return lua_files

def main():
    print("Starting Lua comment removal...")

    # Find all Lua files
    lua_files = find_lua_files('.')

    print(f"Found {len(lua_files)} Lua files to process")

    processed_count = 0
    changed_count = 0

    for filepath in lua_files:
        processed_count += 1
        if process_lua_file(filepath):
            changed_count += 1
            print(f"Processed: {filepath}")

    print("\nSummary:")
    print(f"Processed {processed_count} files")
    print(f"Modified {changed_count} files")
    print("Comment removal completed!")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Script to fix spacing after section headers in Lua documentation blocks.

This script removes blank lines immediately after section headers like
Purpose:, When Called:, Parameters:, etc.
"""

import os
import re
import sys
from pathlib import Path

def fix_section_spacing(content):
    """
    Fix documentation section spacing by removing blank lines after section headers.

    Args:
        content: The file content as a string

    Returns:
        Modified content with proper section spacing
    """
    lines = content.split('\n')
    modified_lines = []
    in_doc_block = False

    # Major section headers that should not have blank lines after them
    section_headers = [
        'Title:',
        'Purpose:',
        'When Called:',
        'Parameters:',
        'Returns:',
        'Realm:',
        'Example Usage:',
        'Low Complexity:',
        'Medium Complexity:',
        'High Complexity:'
    ]

    i = 0
    while i < len(lines):
        line = lines[i]

        # Check if we're entering a documentation block
        if line.strip().startswith('--[['):
            in_doc_block = True
            modified_lines.append(line)
            i += 1
            continue

        # Check if we're exiting a documentation block
        if in_doc_block and line.strip().startswith(']]'):
            in_doc_block = False
            modified_lines.append(line)
            i += 1
            continue

        if in_doc_block:
            # Check if this line contains a major section header
            is_section_header = False
            for header in section_headers:
                if header in line and not line.strip().startswith('    ') and not line.strip().startswith('\t'):
                    is_section_header = True
                    break

            if is_section_header:
                modified_lines.append(line)
                i += 1

                # Skip any blank lines immediately after the section header
                while i < len(lines) and lines[i].strip() == '':
                    i += 1
                continue

            modified_lines.append(line)
        else:
            modified_lines.append(line)

        i += 1

    return '\n'.join(modified_lines)

def process_file(file_path):
    """
    Process a single Lua file to fix section spacing in documentation.

    Args:
        file_path: Path to the Lua file
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        modified_content = fix_section_spacing(content)

        # Only write if content changed
        if content != modified_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(modified_content)
            return True
        return False
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def find_lua_files(directory):
    """
    Find all Lua files in the given directory recursively.

    Args:
        directory: Root directory to search

    Returns:
        List of Lua file paths
    """
    lua_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.lua'):
                lua_files.append(os.path.join(root, file))
    return lua_files

def main():
    """Main function to process all Lua files in the codebase."""
    script_dir = Path(__file__).parent

    # Process Lilia gamemode
    lilia_dir = script_dir / 'gamemode'
    if lilia_dir.exists():
        print("Processing Lilia gamemode files...")
        lilia_files = find_lua_files(str(lilia_dir))
        modified_count = 0

        for file_path in lilia_files:
            if process_file(file_path):
                modified_count += 1
                print(f"Modified: {file_path}")

        print(f"Modified {modified_count} files in Lilia gamemode")

    print("\nSection spacing fix complete!")

if __name__ == '__main__':
    main()

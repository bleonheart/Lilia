#!/usr/bin/env python3
"""
Script to remove comments from files in the Lilia gamemode project.
Supports Lua files primarily, but can be extended for other file types.
"""

import os
import re
import argparse
from pathlib import Path

def remove_lua_comments(content):
    """
    Remove Lua comments from content.
    Handles both single-line comments (--) and multi-line comments (--[[ ... ]])
    """
    # Remove single-line comments
    # This regex matches -- followed by anything until end of line
    content = re.sub(r'--[^\n]*\n', '\n', content)
    content = re.sub(r'--[^\n]*$', '', content)  # Handle comments at EOF

    # Remove multi-line comments --[[ ... ]]
    # This regex matches --[[ followed by anything until ]]
    content = re.sub(r'--\[\[.*?\]\]', '', content, flags=re.DOTALL)

    return content

def remove_comments_from_file(file_path):
    """
    Remove comments from a single file based on its extension.
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        original_content = content

        # Get file extension
        _, ext = os.path.splitext(file_path)
        ext = ext.lower()

        if ext == '.lua':
            content = remove_lua_comments(content)
        elif ext in ['.js', '.ts', '.py', '.java', '.c', '.cpp', '.h', '.hpp']:
            # For these languages, remove // and /* */ style comments
            content = re.sub(r'//[^\n]*\n', '\n', content)
            content = re.sub(r'//[^\n]*$', '', content)
            content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
        elif ext in ['.md', '.txt']:
            # For markdown and text, we could remove HTML comments if any
            content = re.sub(r'<!--.*?-->', '', content, flags=re.DOTALL)
        # Add more file types as needed

        # Only write back if content changed
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True

        return False

    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def main():
    """
    Main function to process all files in the current directory and subdirectories.
    """
    parser = argparse.ArgumentParser(description='Remove comments from source files')
    parser.add_argument('--dry-run', action='store_true',
                       help='Show what would be changed without actually modifying files')
    parser.add_argument('--extensions', nargs='+', default=['.lua'],
                       help='File extensions to process (default: .lua)')
    parser.add_argument('--exclude-dirs', nargs='+',
                       default=['.git', 'node_modules', '__pycache__', '.vscode'],
                       help='Directories to exclude from processing')

    args = parser.parse_args()

    # Find all files to process
    files_processed = 0
    files_changed = 0

    for root, dirs, files in os.walk('.'):
        # Remove excluded directories from dirs list to avoid traversing them
        dirs[:] = [d for d in dirs if d not in args.exclude_dirs]

        for file in files:
            file_path = os.path.join(root, file)

            # Check if file extension matches
            _, ext = os.path.splitext(file_path)
            if ext.lower() in args.extensions:
                files_processed += 1

                if args.dry_run:
                    # For dry run, just check if file would be changed
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            content = f.read()

                        if ext.lower() == '.lua':
                            modified = remove_lua_comments(content)
                        else:
                            modified = content  # For now, only check Lua files in dry run

                        if modified != content:
                            print(f"Would change: {file_path}")
                            files_changed += 1
                    except Exception as e:
                        print(f"Error checking {file_path}: {e}")
                else:
                    # Actually process the file
                    if remove_comments_from_file(file_path):
                        print(f"Processed: {file_path}")
                        files_changed += 1
                    else:
                        print(f"No changes: {file_path}")

    print(f"\nSummary: {files_processed} files processed, {files_changed} files changed")

if __name__ == '__main__':
    main()

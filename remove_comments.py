#!/usr/bin/env python3
"""
Script to remove Lua comments from files in the Lilia gamemode project.
Only removes -- style comments, keeping the rest of the line intact.
"""

import os
import re
import argparse

def remove_lua_comments(content):
    """
    Remove Lua single-line comments (--) from content.
    Only removes the comment part, keeping the rest of the line intact.
    """
    # Remove single-line comments --
    # This regex matches -- followed by anything except newline
    content = re.sub(r'--[^\n]*', '', content)

    return content

def remove_comments_from_file(file_path):
    """
    Remove comments from a single Lua file.
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
    Main function to process all Lua files in the current directory and subdirectories.
    """
    parser = argparse.ArgumentParser(description='Remove Lua comments from source files')
    parser.add_argument('--dry-run', action='store_true',
                       help='Show what would be changed without actually modifying files')
    parser.add_argument('--exclude-dirs', nargs='+',
                       default=['.git', 'node_modules', '__pycache__', '.vscode'],
                       help='Directories to exclude from processing')

    args = parser.parse_args()

    # Find all Lua files to process
    files_processed = 0
    files_changed = 0

    for root, dirs, files in os.walk('.'):
        # Remove excluded directories from dirs list to avoid traversing them
        dirs[:] = [d for d in dirs if d not in args.exclude_dirs]

        for file in files:
            file_path = os.path.join(root, file)

            # Check if file is a Lua file
            _, ext = os.path.splitext(file_path)
            if ext.lower() == '.lua':
                files_processed += 1

                if args.dry_run:
                    # For dry run, just check if file would be changed
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            content = f.read()

                        modified = remove_lua_comments(content)

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

    print(f"\nSummary: {files_processed} Lua files processed, {files_changed} files changed")

if __name__ == '__main__':
    main()

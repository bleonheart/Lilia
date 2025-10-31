#!/usr/bin/env python3
"""
Batch Hook Documentation Spacing Fixer for Lilia Framework

This script fixes all spacing issues in hook documentation at once.
It adds missing blank lines after section headers safely.

Usage:
python fix_all_hook_spacing.py shared    # Fix shared.lua hooks file
"""

import os
import re
import sys
from typing import List

class BatchSpacingFixer:
    def __init__(self):
        # Sections that should have blank lines after them
        self.sections_with_blank_lines = [
            'Purpose:',
            'When Called:',
            'Parameters:',
            'Returns:',
            'Realm:'
        ]

    def read_file(self, file_path: str) -> str:
        """Read the entire file content."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return f.read()
        except FileNotFoundError:
            print(f"Error: File {file_path} not found.")
            sys.exit(1)
        except Exception as e:
            print(f"Error reading file: {e}")
            sys.exit(1)

    def write_file(self, file_path: str, content: str) -> None:
        """Write content back to file."""
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
        except Exception as e:
            print(f"Error writing file: {e}")
            sys.exit(1)

    def fix_spacing_issues(self, content: str) -> str:
        """Fix all spacing issues in the content."""
        lines = content.split('\n')
        result_lines = []

        i = 0
        while i < len(lines):
            line = lines[i]

            # Check if this is a section header in a documentation block
            stripped = line.strip()
            is_section_header = any(section in stripped for section in self.sections_with_blank_lines)

            # If this is a section header and we're not at the start, add a blank line before it
            if is_section_header and result_lines and result_lines[-1].strip():
                # Check if we're in a documentation block by looking backwards
                in_doc_block = False
                for j in range(len(result_lines) - 1, -1, -1):
                    prev_line = result_lines[j].strip()
                    if prev_line.startswith('--[['):
                        in_doc_block = True
                        break
                    elif prev_line.startswith(']]'):
                        in_doc_block = False
                        break

                if in_doc_block:
                    result_lines.append('')

            result_lines.append(line)
            i += 1

        return '\n'.join(result_lines)

    def fix_file(self, file_path: str) -> None:
        """Fix all spacing issues in the file."""
        print(f"Fixing hook documentation spacing in: {file_path}")

        # Read the file
        content = self.read_file(file_path)

        # Fix the spacing issues
        fixed_content = self.fix_spacing_issues(content)

        # Only write if there were changes
        if fixed_content != content:
            # Create backup
            backup_path = file_path + '.backup'
            self.write_file(backup_path, content)
            print(f"Created backup: {backup_path}")

            # Write fixed content
            self.write_file(file_path, fixed_content)
            print("All spacing issues fixed!")
        else:
            print("No spacing issues found.")

def main():
    if len(sys.argv) < 2:
        print("Usage: python fix_all_hook_spacing.py <target>")
        print("Targets:")
        print("  shared    - Fix shared.lua hooks file")
        print("  client    - Fix client.lua hooks file")
        print("  server    - Fix server.lua hooks file")
        print("  all       - Fix ALL files in gamemode/docs directory")
        print("  meta      - Fix ALL files in gamemode/core/meta directory")
        print("  libraries - Fix ALL files in gamemode/core/libraries directory")
        print("  core      - Fix ALL files in both meta and libraries directories")
        print("  <file>    - Fix a specific file")
        sys.exit(1)

    target = sys.argv[1]
    fixer = BatchSpacingFixer()

    if target == 'all':
        # Process all files in the docs directory recursively
        docs_dir = os.path.join(os.path.dirname(__file__), 'gamemode', 'docs')
        processed_count = 0

        for root, dirs, files in os.walk(docs_dir):
            for file in files:
                if file.endswith('.lua'):
                    file_path = os.path.join(root, file)
                    print(f"\nProcessing: {os.path.relpath(file_path, docs_dir)}")
                    fixer.fix_file(file_path)
                    processed_count += 1

        print(f"\nProcessed {processed_count} Lua files in the docs directory!")

    elif target == 'meta':
        # Process all files in the meta directory
        meta_dir = os.path.join(os.path.dirname(__file__), 'gamemode', 'core', 'meta')
        processed_count = 0

        for file in os.listdir(meta_dir):
            if file.endswith('.lua'):
                file_path = os.path.join(meta_dir, file)
                print(f"\nProcessing: meta/{file}")
                fixer.fix_file(file_path)
                processed_count += 1

        print(f"\nProcessed {processed_count} Lua files in the meta directory!")

    elif target == 'libraries':
        # Process all files in the libraries directory recursively
        libraries_dir = os.path.join(os.path.dirname(__file__), 'gamemode', 'core', 'libraries')
        processed_count = 0

        for root, dirs, files in os.walk(libraries_dir):
            for file in files:
                if file.endswith('.lua'):
                    file_path = os.path.join(root, file)
                    print(f"\nProcessing: {os.path.relpath(file_path, libraries_dir)}")
                    fixer.fix_file(file_path)
                    processed_count += 1

        print(f"\nProcessed {processed_count} Lua files in the libraries directory!")

    elif target == 'core':
        # Process all files in both meta and libraries directories
        processed_count = 0

        # Process meta directory
        meta_dir = os.path.join(os.path.dirname(__file__), 'gamemode', 'core', 'meta')
        for file in os.listdir(meta_dir):
            if file.endswith('.lua'):
                file_path = os.path.join(meta_dir, file)
                print(f"\nProcessing: meta/{file}")
                fixer.fix_file(file_path)
                processed_count += 1

        # Process libraries directory recursively
        libraries_dir = os.path.join(os.path.dirname(__file__), 'gamemode', 'core', 'libraries')
        for root, dirs, files in os.walk(libraries_dir):
            for file in files:
                if file.endswith('.lua'):
                    file_path = os.path.join(root, file)
                    print(f"\nProcessing: {os.path.relpath(file_path, libraries_dir)}")
                    fixer.fix_file(file_path)
                    processed_count += 1

        print(f"\nProcessed {processed_count} Lua files in the core directories!")

    elif target == 'shared':
        shared_path = os.path.join(os.path.dirname(__file__), 'gamemode', 'docs', 'hooks', 'shared.lua')
        fixer.fix_file(shared_path)
    elif target == 'client':
        client_path = os.path.join(os.path.dirname(__file__), 'gamemode', 'docs', 'hooks', 'client.lua')
        fixer.fix_file(client_path)
    elif target == 'server':
        server_path = os.path.join(os.path.dirname(__file__), 'gamemode', 'docs', 'hooks', 'server.lua')
        fixer.fix_file(server_path)
    else:
        # Assume it's a file path
        fixer.fix_file(target)

if __name__ == '__main__':
    main()

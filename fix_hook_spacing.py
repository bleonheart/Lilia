#!/usr/bin/env python3
"""
Manual Hook Documentation Spacing Fixer for Lilia Framework

This script helps fix documentation formatting by showing exactly what changes are needed.
It identifies sections that need blank lines added after them.

Usage:
python fix_hook_spacing.py show-issues    # Show all issues
python fix_hook_spacing.py fix-section <line_number>  # Fix a specific section
"""

import os
import sys
from typing import List, Tuple, Dict

class HookSpacingFixer:
    def __init__(self):
        # Sections that should have blank lines after them
        self.sections_with_blank_lines = [
            'Purpose:',
            'When Called:',
            'Parameters:',
            'Returns:',
            'Realm:',
            'Example Usage:'
        ]

    def read_file(self, file_path: str) -> List[str]:
        """Read the entire file content."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return f.read().split('\n')
        except FileNotFoundError:
            print(f"Error: File {file_path} not found.")
            sys.exit(1)
        except Exception as e:
            print(f"Error reading file: {e}")
            sys.exit(1)

    def write_file(self, file_path: str, lines: List[str]) -> None:
        """Write content back to file."""
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write('\n'.join(lines))
        except Exception as e:
            print(f"Error writing file: {e}")
            sys.exit(1)

    def find_issues(self, lines: List[str]) -> List[Dict]:
        """Find all sections that need blank lines after them."""
        issues = []

        for i, line in enumerate(lines):
            stripped = line.strip()

            # Check if this is a section header that needs a blank line after it
            for section in self.sections_with_blank_lines:
                if stripped.startswith(section):
                    # Check if next non-empty line should have a blank line before it
                    next_line_idx = i + 1
                    while next_line_idx < len(lines) and not lines[next_line_idx].strip():
                        next_line_idx += 1

                    if next_line_idx < len(lines):
                        next_line = lines[next_line_idx].strip()
                        # If next line is not another section header and not already preceded by blank, it's an issue
                        if (next_line and
                            not any(section in next_line for section in self.sections_with_blank_lines) and
                            not next_line.startswith('Low Complexity:') and
                            not next_line.startswith('Medium Complexity:') and
                            not next_line.startswith('High Complexity:') and
                            not next_line.startswith('```')):
                            # Check if there's a blank line
                            has_blank = False
                            blank_check_idx = i + 1
                            while blank_check_idx < next_line_idx:
                                if not lines[blank_check_idx].strip():
                                    has_blank = True
                                    break
                                blank_check_idx += 1

                            if not has_blank:
                                issues.append({
                                    'line': i + 1,
                                    'section': section.strip(),
                                    'fix_type': 'add_blank_line',
                                    'description': f"Missing blank line after '{section.strip()}' section"
                                })

        return issues

    def show_issues(self, file_path: str) -> None:
        """Show all issues in the file."""
        lines = self.read_file(file_path)
        issues = self.find_issues(lines)

        if not issues:
            print("No spacing issues found!")
            return

        print(f"Found {len(issues)} spacing issues in {file_path}:")
        print()

        for issue in issues:
            print(f"Line {issue['line']}: {issue['description']}")

        print()
        print("To fix individual issues, run:")
        print("python fix_hook_spacing.py fix-section <line_number>")

    def fix_section(self, file_path: str, line_number: int) -> None:
        """Fix a specific section by adding a blank line after it."""
        lines = self.read_file(file_path)
        issues = self.find_issues(lines)

        # Find the issue for this line
        target_issue = None
        for issue in issues:
            if issue['line'] == line_number:
                target_issue = issue
                break

        if not target_issue:
            print(f"No fixable issue found at line {line_number}")
            return

        # Add blank line after the section header
        insert_idx = line_number  # Convert to 0-based indexing
        lines.insert(insert_idx, '')

        # Write back to file
        self.write_file(file_path, lines)
        print(f"Fixed: Added blank line after '{target_issue['section']}' section at line {line_number}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python fix_hook_spacing.py <command> [args]")
        print("Commands:")
        print("  show-issues              - Show all spacing issues")
        print("  fix-section <line_num>   - Fix spacing at specific line")
        sys.exit(1)

    command = sys.argv[1]
    fixer = HookSpacingFixer()

    shared_path = os.path.join(os.path.dirname(__file__), 'gamemode', 'docs', 'hooks', 'shared.lua')

    if command == 'show-issues':
        fixer.show_issues(shared_path)
    elif command == 'fix-section':
        if len(sys.argv) < 3:
            print("Error: fix-section requires a line number")
            sys.exit(1)
        try:
            line_num = int(sys.argv[2])
            fixer.fix_section(shared_path, line_num)
        except ValueError:
            print("Error: Line number must be an integer")
            sys.exit(1)
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)

if __name__ == '__main__':
    main()

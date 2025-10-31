#!/usr/bin/env python3
"""
Hook Documentation Validator for Lilia Framework

This script validates hook documentation formatting in shared.lua files.
It checks for:
- Proper line breaks between documentation sections
- 4-space indentation for Lua code examples
- Consistent structure across all hook documentation blocks

Usage:
python validate_hook_docs.py shared    # Validate shared.lua hooks file
python validate_hook_docs.py client    # Validate client.lua hooks file
python validate_hook_docs.py server    # Validate server.lua hooks file
"""

import os
import sys
from typing import List, Tuple

class HookDocumentationValidator:
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

    def find_documentation_blocks(self, content: str) -> List[Tuple[int, int]]:
        """Find all documentation blocks (between --[[ and ]])."""
        blocks = []
        lines = content.split('\n')

        in_block = False
        block_start = -1

        for i, line in enumerate(lines):
            stripped = line.strip()

            if stripped.startswith('--[['):
                in_block = True
                block_start = i
            elif stripped.startswith(']]') and in_block:
                blocks.append((block_start, i))
                in_block = False

        return blocks

    def validate_documentation_block(self, lines: List[str], start_idx: int, end_idx: int, file_path: str) -> List[str]:
        """Validate a single documentation block."""
        issues = []

        # Extract the block
        block_lines = lines[start_idx:end_idx + 1]
        block_content = '\n'.join(block_lines)

        # Skip if this is not a hook documentation block
        if 'Purpose:' not in block_content:
            return issues

        # Find the start of the documentation (after --[[)
        doc_start = -1
        for i, line in enumerate(block_lines):
            if line.strip().startswith('--[['):
                doc_start = i + 1
                break

        if doc_start == -1:
            return issues

        # Extract just the documentation content
        doc_lines = block_lines[doc_start:end_idx - start_idx]

        # Validate the documentation formatting
        issues.extend(self.validate_documentation_formatting(doc_lines, start_idx + doc_start, file_path))

        # Validate code indentation
        issues.extend(self.validate_lua_code_indentation(doc_lines, start_idx + doc_start))

        return issues

    def validate_documentation_formatting(self, doc_lines: List[str], line_offset: int, file_path: str) -> List[str]:
        """Validate the formatting of documentation lines."""
        issues = []

        for i, line in enumerate(doc_lines):
            stripped = line.strip()

            # Check if this is a section header that needs content after it
            for section in self.sections_with_blank_lines:
                if stripped.startswith(section):
                    # Different validation rules for different sections
                    if section == 'Example Usage:':
                        # Example Usage should be followed by a blank line in hook files only
                        if "hooks" in file_path:
                            if i + 1 < len(doc_lines):
                                next_line = doc_lines[i + 1]
                                if next_line.strip():  # Should be blank
                                    issues.append(f"Line {line_offset + i + 1}: 'Example Usage:' section should be followed by a blank line")
                    else:
                        # Other sections should be followed by content
                        if i + 1 < len(doc_lines):
                            next_line = doc_lines[i + 1]
                            if not next_line.strip():  # Should have content
                                issues.append(f"Line {line_offset + i + 1}: '{section.strip()}' section header should be followed by content")

        return issues

    def validate_lua_code_indentation(self, doc_lines: List[str], line_offset: int) -> List[str]:
        """Validate indentation in Lua code blocks within documentation."""
        issues = []
        in_code_block = False

        for i, line in enumerate(doc_lines):
            stripped = line.strip()

            # Check for code block markers
            if stripped.startswith('```lua'):
                in_code_block = True
                continue
            elif stripped.startswith('```') and in_code_block:
                in_code_block = False
                continue

            if in_code_block:
                # Check indentation in code blocks
                if stripped and not stripped.startswith('--'):
                    indent = len(line) - len(line.lstrip())
                    if indent > 0 and indent % 4 != 0:
                        issues.append(f"Line {line_offset + i + 1}: Lua code indentation should be multiple of 4 spaces (found {indent})")

        return issues

    def validate_file(self, file_path: str) -> List[str]:
        """Validate the entire file."""
        print(f"Validating hook documentation in: {file_path}")

        # Read the file
        content = self.read_file(file_path)
        lines = content.split('\n')

        # Find all documentation blocks
        blocks = self.find_documentation_blocks(content)

        if not blocks:
            print("No documentation blocks found.")
            return []

        print(f"Found {len(blocks)} documentation blocks.")

        all_issues = []

        # Process each block
        for block_idx, (start_idx, end_idx) in enumerate(blocks):
            print(f"Validating block {block_idx + 1}/{len(blocks)} at lines {start_idx + 1}-{end_idx + 1}")
            issues = self.validate_documentation_block(lines, start_idx, end_idx, file_path)
            all_issues.extend(issues)

        if all_issues:
            print(f"\nFound {len(all_issues)} formatting issues:")
            for issue in all_issues:
                print(f"  - {issue}")
        else:
            print("\nAll documentation formatting appears correct!")

        return all_issues

def main():
    if len(sys.argv) < 2:
        print("Usage: python validate_hook_docs.py <target>")
        print("Targets:")
        print("  shared    - Validate shared.lua hooks file")
        print("  client    - Validate client.lua hooks file")
        print("  server    - Validate server.lua hooks file")
        print("  <file>    - Validate a specific file")
        sys.exit(1)

    target = sys.argv[1]
    validator = HookDocumentationValidator()

    if target == 'shared':
        shared_path = os.path.join(os.path.dirname(__file__), 'gamemode', 'docs', 'hooks', 'shared.lua')
        issues = validator.validate_file(shared_path)
        sys.exit(1 if issues else 0)
    elif target == 'client':
        client_path = os.path.join(os.path.dirname(__file__), 'gamemode', 'docs', 'hooks', 'client.lua')
        issues = validator.validate_file(client_path)
        sys.exit(1 if issues else 0)
    elif target == 'server':
        server_path = os.path.join(os.path.dirname(__file__), 'gamemode', 'docs', 'hooks', 'server.lua')
        issues = validator.validate_file(server_path)
        sys.exit(1 if issues else 0)
    else:
        # Assume it's a file path
        issues = validator.validate_file(target)
        sys.exit(1 if issues else 0)

if __name__ == '__main__':
    main()

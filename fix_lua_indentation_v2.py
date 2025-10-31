#!/usr/bin/env python3
"""
Comprehensive Lua Code Indentation Fixer for Lilia Framework Documentation

This script properly fixes indentation in Lua code blocks by:
1. Parsing Lua syntax to understand block structure
2. Applying correct 4-space indentation per nesting level
3. Preserving comment alignment

Usage:
python fix_lua_indentation_v2.py <target>
Targets:
  shared    - Fix shared.lua hooks file
  client    - Fix client.lua hooks file
  server    - Fix server.lua hooks file
  all       - Fix ALL files in gamemode/docs directory
"""

import os
import sys
import re
from typing import List, Tuple, Dict, Optional

class LuaCodeParser:
    def __init__(self):
        # Keywords that start blocks
        self.block_starters = {
            'function', 'if', 'for', 'while', 'repeat', 'do'
        }
        # Keywords/patterns that end blocks
        self.block_enders = {
            'end', 'until', 'else', 'elseif'
        }
        # Keywords that don't change indentation but need proper alignment
        self.control_keywords = {
            'then', 'do', 'else', 'elseif'
        }

    def parse_line_type(self, line: str) -> Dict:
        """Analyze a line to determine its type and indentation requirements."""
        stripped = line.strip()

        # Empty lines
        if not stripped:
            return {'type': 'empty', 'indent_change': 0, 'base_indent': 0}

        # Comments
        if stripped.startswith('--'):
            return {'type': 'comment', 'indent_change': 0, 'base_indent': 0}

        # Function definitions
        if re.match(r'^(local\s+)?function\s', stripped):
            return {'type': 'function_start', 'indent_change': 1, 'base_indent': 0}

        # If statements
        if re.match(r'^if\s+.*\s+then\s*$', stripped) or stripped.startswith('if '):
            indent_change = 1 if 'then' in stripped else 0
            return {'type': 'if_start', 'indent_change': indent_change, 'base_indent': 0}

        # Else/elseif
        if stripped.startswith(('else', 'elseif')):
            if stripped == 'else':
                return {'type': 'else', 'indent_change': 0, 'base_indent': -1}
            else:
                return {'type': 'elseif', 'indent_change': 0, 'base_indent': -1}

        # Loops
        if re.match(r'^(for|while)\s+.*\s+do\s*$', stripped) or stripped.startswith(('for ', 'while ')):
            indent_change = 1 if 'do' in stripped else 0
            return {'type': 'loop_start', 'indent_change': indent_change, 'base_indent': 0}

        # Repeat/until
        if stripped == 'repeat':
            return {'type': 'repeat_start', 'indent_change': 1, 'base_indent': 0}
        if stripped.startswith('until '):
            return {'type': 'until', 'indent_change': -1, 'base_indent': 0}

        # Do blocks
        if stripped == 'do':
            return {'type': 'do_start', 'indent_change': 1, 'base_indent': 0}

        # End statements
        if stripped == 'end':
            return {'type': 'end', 'indent_change': -1, 'base_indent': 0}

        # Regular statements
        return {'type': 'statement', 'indent_change': 0, 'base_indent': 0}

    def fix_indentation(self, code_lines: List[str], base_indent: int = 0) -> List[str]:
        """Fix indentation for a block of Lua code."""
        if not code_lines:
            return code_lines

        fixed_lines = []
        current_indent_level = 0

        for line in code_lines:
            line_info = self.parse_line_type(line)

            if line_info['type'] == 'empty':
                fixed_lines.append('')
                continue

            if line_info['type'] == 'comment':
                # Comments should align with the current indent level
                indent = base_indent + (current_indent_level * 4)
                fixed_lines.append(' ' * indent + line.strip())
                continue

            # Calculate indentation for this line
            if line_info['base_indent'] < 0:
                # Special handling for else/elseif - they go back one level
                indent_level = max(0, current_indent_level + line_info['base_indent'])
            else:
                indent_level = current_indent_level

            indent = base_indent + (indent_level * 4)
            fixed_lines.append(' ' * indent + line.strip())

            # Update indent level for next line
            current_indent_level += line_info['indent_change']

        return fixed_lines

class DocumentationFixer:
    def __init__(self):
        self.parser = LuaCodeParser()

    def read_file(self, file_path: str) -> List[str]:
        """Read file content."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return f.read().split('\n')
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
            return []

    def write_file(self, file_path: str, lines: List[str]) -> None:
        """Write content to file."""
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write('\n'.join(lines))
        except Exception as e:
            print(f"Error writing {file_path}: {e}")

    def find_lua_code_blocks(self, lines: List[str]) -> List[Tuple[int, int]]:
        """Find all Lua code blocks in the file."""
        blocks = []
        in_code_block = False
        block_start = -1

        for i, line in enumerate(lines):
            stripped = line.strip()

            if stripped == '```lua':
                in_code_block = True
                block_start = i
            elif stripped == '```' and in_code_block:
                blocks.append((block_start, i))
                in_code_block = False

        return blocks

    def fix_file(self, file_path: str) -> bool:
        """Fix all Lua code blocks in a file."""
        print(f"Fixing Lua indentation in: {file_path}")

        lines = self.read_file(file_path)
        if not lines:
            return False

        blocks = self.find_lua_code_blocks(lines)
        if not blocks:
            print("No Lua code blocks found.")
            return False

        print(f"Found {len(blocks)} Lua code blocks.")

        # Create backup
        backup_path = file_path + '.backup2'
        try:
            self.write_file(backup_path, lines)
            print(f"Created backup: {backup_path}")
        except:
            pass

        modified = False

        for start_idx, end_idx in blocks:
            # Get base indentation (indentation of the ```lua line)
            base_indent = len(lines[start_idx]) - len(lines[start_idx].lstrip())

            # Extract code lines
            code_lines = lines[start_idx + 1:end_idx]

            # Fix indentation
            fixed_code_lines = self.parser.fix_indentation(code_lines, base_indent)

            # Check if changed
            if fixed_code_lines != code_lines:
                modified = True
                lines[start_idx + 1:end_idx] = fixed_code_lines

        if modified:
            self.write_file(file_path, lines)
            print("Fixed Lua code indentation!")
            return True
        else:
            print("No changes needed.")
            return False

def main():
    if len(sys.argv) < 2:
        print("Usage: python fix_lua_indentation_v2.py <target>")
        print("Targets:")
        print("  shared    - Fix shared.lua hooks file")
        print("  client    - Fix client.lua hooks file")
        print("  server    - Fix server.lua hooks file")
        print("  all       - Fix ALL files in gamemode/docs directory")
        sys.exit(1)

    target = sys.argv[1]
    fixer = DocumentationFixer()

    base_path = os.path.join(os.path.dirname(__file__), 'gamemode', 'docs', 'hooks')

    if target == 'shared':
        fixer.fix_file(os.path.join(base_path, 'shared.lua'))
    elif target == 'client':
        fixer.fix_file(os.path.join(base_path, 'client.lua'))
    elif target == 'server':
        fixer.fix_file(os.path.join(base_path, 'server.lua'))
    elif target == 'all':
        docs_path = os.path.join(os.path.dirname(__file__), 'gamemode', 'docs')
        import glob
        lua_files = glob.glob(os.path.join(docs_path, '**', '*.lua'), recursive=True)
        fixed_count = 0
        for lua_file in lua_files:
            if fixer.fix_file(lua_file):
                fixed_count += 1
        print(f"Fixed {fixed_count} files.")
    else:
        fixer.fix_file(target)

if __name__ == '__main__':
    main()

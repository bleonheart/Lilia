#!/usr/bin/env python3
"""
Lua String Extraction Script for Lilia Gamemode

This script extracts localizable strings from Lua files in the gamemode
and organizes them into JSON and Lua formats for translation management.
"""

import os
import re
import json
import argparse
from pathlib import Path
from typing import Dict, List, Set


class LuaStringExtractor:
    """Extracts localizable strings from Lua files."""

    def __init__(self, gamemode_path: str):
        self.gamemode_path = Path(gamemode_path)
        self.extracted_strings: Dict[str, bool] = {}
        self.ignored_paths = {
            'languages',  # Skip existing language files
            '__pycache__',  # Skip Python cache
            '.git',  # Skip git directory
        }

    def should_ignore_path(self, path: Path) -> bool:
        """Check if a path should be ignored during traversal."""
        parts = path.parts
        return any(ignored in parts for ignored in self.ignored_paths)

    def find_lua_files(self) -> List[Path]:
        """Recursively find all Lua files in the gamemode directory."""
        lua_files = []

        for root, dirs, files in os.walk(self.gamemode_path):
            root_path = Path(root)

            # Skip ignored directories
            if self.should_ignore_path(root_path):
                continue

            for file in files:
                if file.endswith('.lua'):
                    lua_files.append(root_path / file)

        return lua_files

    def is_localizable_string(self, string: str) -> bool:
        """Check if a string is likely to be localizable content."""
        if not string or len(string) < 3 or len(string) > 100:
            return False

        # Filter out common non-localizable patterns
        non_localizable_patterns = [
            r'^\$',  # Shader parameters like $basetexture
            r'^\d+\s*$',  # Pure numbers
            r'^[A-Za-z_][A-Za-z0-9_]*$',  # Variable/function names (single words)
            r'^[\w\-\.]+@[\w\-\.]+\.\w+$',  # Email addresses
            r'^https?://',  # URLs
            r'^#[0-9A-Fa-f]{6}$',  # Hex colors
            r'^[0-9]+\.[0-9]+$',  # Version numbers
            r'^[A-Z_]+$',  # Constants
            r'^<\w+>$',  # HTML-like tags
            r'^[(){}[\]]+$',  # Just brackets/braces
            r'^end\s*$',  # Lua end statements
            r'^function\s',  # Lua function definitions
            r'^if\s',  # Lua if statements
            r'^else\s*$',  # Lua else statements
            r'^return\s',  # Lua return statements
            r'^local\s',  # Lua local declarations
            r'^for\s',  # Lua for loops
            r'^while\s',  # Lua while loops
            r'^do\s*$',  # Lua do blocks
            r'^then\s*$',  # Lua then statements
            r'^break\s*$',  # Lua break statements
            r'^continue\s*$',  # Lua continue statements
        ]

        stripped = string.strip()
        for pattern in non_localizable_patterns:
            if re.match(pattern, stripped, re.IGNORECASE):
                return False

        # Must contain at least one letter and not be mostly punctuation
        if not re.search(r'[a-zA-Z]', stripped):
            return False

        # Filter out strings that look like code (contain many special chars or Lua keywords)
        special_chars = len(re.findall(r'[^a-zA-Z0-9\s]', stripped))
        if special_chars > len(stripped) * 0.15:  # More than 15% special characters
            return False

        # Filter out strings with Lua code patterns
        code_indicators = ['(', ')', '{', '}', '[', ']', ':', '==', '!=', '<=', '>=', '+=', '-=', '*=', '/=']
        if any(indicator in stripped for indicator in code_indicators):
            return False

        # Filter out strings that are clearly variable names (contain camelCase or snake_case patterns)
        if re.search(r'[a-z][A-Z]|[a-z]_[a-z]', stripped):
            return False

        return True

    def extract_l_function_strings(self, content: str, file_path: str) -> Set[str]:
        """Extract strings used in L() function calls."""
        l_strings = set()

        # Pattern for L("string") or L('string')
        l_pattern = r'L\(["\']([^"\']+)["\']\)'


        matches = re.findall(l_pattern, content)
        for match in matches:
            # Clean up the string and filter out non-localizable content
            clean_string = match.strip()
            if self.is_localizable_string(clean_string):
                l_strings.add(clean_string)

        return l_strings

    def extract_hardcoded_strings(self, content: str, file_path: str) -> Set[str]:
        """Extract hardcoded strings that might need localization."""
        hardcoded_strings = set()

        # Very targeted patterns for obvious hardcoded messages that aren't in L() calls
        patterns = [
            # Error messages and notifications (not in function calls)
            r'["\']([^"\']*(?:error|Error|failed|Failed|invalid|Invalid)[^"\']*)["\']',
        ]

        for pattern in patterns:
            matches = re.findall(pattern, content, re.IGNORECASE)
            for match in matches:
                # Use the localizable string filter
                clean_string = match.strip()
                if self.is_localizable_string(clean_string) and len(clean_string) > 6:
                    hardcoded_strings.add(clean_string)

        return hardcoded_strings

    def extract_from_file(self, file_path: Path) -> Set[str]:
        """Extract all localizable strings from a single Lua file."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"Warning: Could not read file {file_path}: {e}")
            return set()

        all_strings = set()

        # Extract from L() function calls (primary source)
        l_strings = self.extract_l_function_strings(content, str(file_path))
        all_strings.update(l_strings)

        # Extract hardcoded strings that might need localization (secondary source)
        hardcoded_strings = self.extract_hardcoded_strings(content, str(file_path))
        all_strings.update(hardcoded_strings)

        return all_strings

    def extract_all_strings(self) -> Dict[str, bool]:
        """Extract strings from all Lua files and organize them."""
        lua_files = self.find_lua_files()
        print(f"Found {len(lua_files)} Lua files to process...")

        for file_path in lua_files:
            strings = self.extract_from_file(file_path)

            for string in strings:
                if string not in self.extracted_strings:
                    self.extracted_strings[string] = True

        return self.extracted_strings

    def save_to_json(self, output_file: str = "extracted_strings.json"):
        """Save the extracted strings to a JSON file."""
        # Sort strings alphabetically for consistent output
        sorted_strings = sorted(self.extracted_strings.keys())

        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(sorted_strings, f, indent=2, ensure_ascii=False)

        print(f"Saved {len(sorted_strings)} strings to {output_file}")

    def save_to_lua(self, output_file: str = "extracted_strings.lua"):
        """Save the extracted strings to a Lua language file format."""
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write('NAME = "English (Extracted)"\n')
            f.write('LANGUAGE = {\n')

            # Sort strings alphabetically for consistent output
            for string in sorted(self.extracted_strings.keys()):
                # Escape quotes in the string value
                escaped_value = string.replace('"', '\\"')
                f.write(f'    "{escaped_value}",\n')

            f.write('}\n')

        print(f"Saved {len(self.extracted_strings)} strings to {output_file} in Lua format")

    def print_summary(self):
        """Print a summary of extracted strings."""
        total_strings = len(self.extracted_strings)
        print("\n=== String Extraction Summary ===")
        print(f"Total unique strings found: {total_strings}")

        # Show some examples
        print("\nExample strings found:")
        count = 0
        for string in sorted(self.extracted_strings.keys()):
            if count >= 5:
                break
            print(f"  '{string}'")
            count += 1


def main():
    parser = argparse.ArgumentParser(description='Extract localizable strings from Lilia gamemode Lua files')
    parser.add_argument('--path', '-p', default='gamemode',
                       help='Path to the gamemode directory (default: gamemode)')
    parser.add_argument('--output', '-o', default='extracted_strings',
                       help='Output file prefix (default: extracted_strings)')
    parser.add_argument('--format', '-f', choices=['json', 'lua', 'both'], default='both',
                       help='Output format: json, lua, or both (default: both)')

    args = parser.parse_args()

    if not os.path.exists(args.path):
        print(f"Error: Path '{args.path}' does not exist")
        return 1

    extractor = LuaStringExtractor(args.path)
    strings = extractor.extract_all_strings()

    if args.format in ['json', 'both']:
        extractor.save_to_json(f"{args.output}.json")

    if args.format in ['lua', 'both']:
        extractor.save_to_lua(f"{args.output}.lua")

    extractor.print_summary()

    return 0


if __name__ == "__main__":
    exit(main())
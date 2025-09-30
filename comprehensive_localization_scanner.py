#!/usr/bin/env python3
"""
Comprehensive scanner for unlocalized strings in the Lilia gamemode
Scans all Lua files for hardcoded strings that should be localized
"""

import os
import re
import json
from pathlib import Path
from collections import defaultdict

class LocalizationScanner:
    def __init__(self, root_dir="gamemode"):
        self.root_dir = Path(root_dir)
        self.existing_keys = set()
        self.potential_strings = defaultdict(list)
        self.ignored_patterns = self._get_ignored_patterns()

    def _get_ignored_patterns(self):
        """Patterns that should be ignored when scanning for localization"""
        return [
            # Code patterns
            r'^[a-zA-Z_][a-zA-Z0-9_]*$',  # Variable names, function names
            r'^[0-9]+$',  # Numbers
            r'^[0-9]+\.[0-9]+$',  # Decimal numbers
            r'^#[0-9a-fA-F]{6}$',  # Hex colors
            r'^[a-zA-Z_][a-zA-Z0-9_]*\s*\([^)]*\)$',  # Function calls
            r'^[a-zA-Z_][a-zA-Z0-9_]*\s*[=<>!]+\s*',  # Comparisons
            r'^[a-zA-Z_][a-zA-Z0-9_]*\s*[\+\-\*\/]',  # Arithmetic
            r'^".*\\n.*"$',  # Strings with newlines (likely formatting)
            r'^".*\\t.*"$',  # Strings with tabs (likely formatting)

            # File paths and URLs
            r'^[a-zA-Z_][a-zA-Z0-9_/\\.-]*$',  # File paths
            r'^https?://.*$',  # URLs

            # Already localized strings
            r'^L\(["\'][^"\']+["\']\)$',  # L("string")
            r'^L\([^)]+\)$',  # L(variable)

            # Very short strings (likely not user-facing)
            r'^.$',  # Single characters
            r'^..$',  # Two characters

            # Technical strings
            r'^[A-Z_][A-Z0-9_]*$',  # Constants
            r'^[a-z]+[0-9]+$',  # Mixed alphanumeric (likely IDs)
        ]

    def load_existing_keys(self):
        """Load all existing localization keys from English file"""
        english_file = self.root_dir / "languages" / "english.lua"

        if not english_file.exists():
            print("English language file not found!")
            return

        try:
            with open(english_file, 'r', encoding='utf-8') as f:
                content = f.read()

            # Extract key-value pairs
            pairs = re.findall(r'(\w+)\s*=\s*"([^"]*)"', content)
            self.existing_keys = {key for key, value in pairs}

            print(f"Loaded {len(self.existing_keys)} existing localization keys")

        except Exception as e:
            print(f"Error reading English file: {e}")

    def should_ignore_string(self, string):
        """Check if a string should be ignored"""
        # Remove quotes if present
        clean_string = string.strip('"\'')
        if not clean_string:
            return True

        # Check against ignored patterns
        for pattern in self.ignored_patterns:
            if re.match(pattern, clean_string):
                return True

        # Skip very short strings that are likely not user-facing
        if len(clean_string) < 3:
            return True

        # Skip strings that look like code
        if re.search(r'[{}()\[\]]', clean_string):
            return True

        # Skip strings that are all caps (likely constants)
        if clean_string.isupper() and len(clean_string) > 3:
            return True

        return False

    def extract_strings_from_file(self, filepath):
        """Extract potential localization strings from a single file"""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()

            # Find all string literals
            strings = re.findall(r'["\']([^"\']+)["\']', content)

            file_strings = []
            for string in strings:
                if not self.should_ignore_string(string):
                    file_strings.append(string)

            return file_strings

        except Exception as e:
            print(f"Error reading {filepath}: {e}")
            return []

    def scan_codebase(self):
        """Scan all Lua files for potential localization strings"""
        print("Scanning codebase for unlocalized strings...")

        total_files = 0
        total_strings = 0

        # Scan all Lua files except language files (which are already localized)
        for lua_file in self.root_dir.rglob("*.lua"):
            # Skip language files as they contain already localized content
            if "languages" in lua_file.parts:
                continue

            total_files += 1
            strings = self.extract_strings_from_file(lua_file)

            for string in strings:
                # Check if this string is already localized (appears as a key)
                if string in self.existing_keys:
                    continue

                # Add to potential strings with file location
                self.potential_strings[string].append(str(lua_file.relative_to(self.root_dir)))

            total_strings += len(strings)

        print(f"Scanned {total_files} files, found {total_strings} string literals")

    def filter_and_rank_strings(self):
        """Filter and rank strings by priority and frequency"""
        print("Filtering and ranking potential localization strings...")

        filtered_strings = {}

        for string, files in self.potential_strings.items():
            # Skip strings that appear in too many files (likely code or very common)
            if len(files) > 10:
                continue

            # Skip strings that are too short
            if len(string) < 4:
                continue

            # Skip strings that look like code or paths
            if any(char in string for char in ['/', '\\', '{', '}', '[', ']']):
                continue

            # Skip strings that are all caps (likely constants or acronyms)
            if string.isupper() and len(string) > 4:
                continue

            # Skip strings that contain mostly numbers or special chars
            if re.search(r'[0-9@$%^&*!]{2,}', string):
                continue

            # Skip strings that contain Lua concatenation operators
            if ' .. ' in string or '.. ' in string or ' ..' in string:
                continue

            # Skip strings that look like incomplete code fragments
            if string.strip().startswith('..') or string.strip().endswith('..'):
                continue

            # Skip strings that are likely variable names or code
            if re.search(r'^[a-zA-Z_][a-zA-Z0-9_]*$', string.strip()):
                continue

            # Skip strings that contain newlines (likely multi-line code)
            if '\\n' in string or '\n' in string:
                continue

            # Prioritize strings that look like complete sentences or user messages
            is_user_message = (
                len(string) > 10 and
                not string.startswith(' ') and
                not string.endswith(' ') and
                not any(char in string for char in ['=', '(', ')', '{', '}', '[', ']', '<', '>']) and
                (string[0].isupper() or string.endswith('.') or string.endswith('!') or string.endswith('?'))
            )

            filtered_strings[string] = {
                'files': files,
                'frequency': len(files),
                'length': len(string),
                'is_user_message': is_user_message
            }

        # Sort by user message priority first, then frequency, then length
        sorted_strings = sorted(
            filtered_strings.items(),
            key=lambda x: (x[1]['is_user_message'], x[1]['frequency'], x[1]['length']),
            reverse=True
        )

        return sorted_strings

    def generate_report(self, output_file="unlocalized_strings_report.json"):
        """Generate a report of potential unlocalized strings"""
        sorted_strings = self.filter_and_rank_strings()

        report = {
            'total_potential_strings': len(self.potential_strings),
            'filtered_strings': len(sorted_strings),
            'strings': []
        }

        for string, data in sorted_strings:
            report['strings'].append({
                'string': string,
                'files': data['files'],
                'frequency': data['frequency'],
                'length': data['length']
            })

        # Write report
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)

        print(f"Generated report with {len(sorted_strings)} potential strings")

        return report

    def print_top_candidates(self, limit=50):
        """Print the top candidates for localization"""
        sorted_strings = self.filter_and_rank_strings()

        print(f"\nTop {limit} localization candidates:")
        print("=" * 60)

        for i, (string, data) in enumerate(sorted_strings[:limit]):
            print(f"{i+1:2d}. '{string}'")
            print(f"    Files: {', '.join(data['files'][:3])}{'...' if len(data['files']) > 3 else ''}")
            print(f"    Frequency: {data['frequency']}")
            print()

def main():
    scanner = LocalizationScanner()
    scanner.load_existing_keys()
    scanner.scan_codebase()
    report = scanner.generate_report()

    # Print top candidates
    scanner.print_top_candidates(30)

    print("Full report saved to unlocalized_strings_report.json")

if __name__ == "__main__":
    main()

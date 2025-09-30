#!/usr/bin/env python3
"""
Localization Scanner for Lilia Gamemode
Scans Lua files for unlocalized strings that need to be added to language files
"""

import os
import re
import json
from pathlib import Path
import argparse

class LocalizationScanner:
    def __init__(self, gamemode_path="gamemode"):
        self.gamemode_path = Path(gamemode_path)
        self.language_dir = self.gamemode_path / "languages"

    def load_existing_strings(self):
        """Load existing localized strings from all language files"""
        existing_strings = set()

        if not self.language_dir.exists():
            print(f"Warning: Language directory not found at {self.language_dir}")
            return existing_strings

        # Find all language files
        language_files = list(self.language_dir.glob("*.lua"))
        print(f"Loading strings from {len(language_files)} language files...")

        for lang_file in language_files:
            try:
                content = lang_file.read_text(encoding='utf-8')

                # Extract string values from the LANGUAGE table
                # Pattern matches: key = "value",
                string_pattern = r'\s*[\w_]+\s*=\s*"([^"]*)"'

                for match in re.finditer(string_pattern, content):
                    value = match.group(1)
                    if value:  # Only add non-empty strings
                        existing_strings.add(value)
            except Exception as e:
                print(f"Error reading {lang_file}: {e}")

        print(f"Loaded {len(existing_strings)} existing localized strings")
        return existing_strings

    def scan_lua_files(self):
        """Scan Lua files for string literals"""
        string_literals = set()

        # Find all .lua files in gamemode directory
        lua_files = list(self.gamemode_path.rglob("*.lua"))

        print(f"Scanning {len(lua_files)} Lua files...")

        for lua_file in lua_files:
            try:
                content = lua_file.read_text(encoding='utf-8')

                # Find string literals (single and double quoted)
                # Skip strings that are already in comments or part of function names
                strings = self.extract_string_literals(content)

                for string in strings:
                    string_literals.add(string)

            except Exception as e:
                print(f"Error reading {lua_file}: {e}")

        print(f"Found {len(string_literals)} total string literals")
        return string_literals

    def extract_string_literals(self, content):
        """Extract string literals from Lua code"""
        strings = []

        # Remove comments first
        content = re.sub(r'--.*$', '', content, flags=re.MULTILINE)

        # Find double quoted strings
        double_quoted = re.findall(r'"([^"]*)"', content)
        strings.extend(double_quoted)

        # Find single quoted strings
        single_quoted = re.findall(r"'([^']*)'", content)
        strings.extend(single_quoted)

        return strings

    def is_english_text(self, string):
        """Check if a string appears to be English user-facing text"""
        # Must be ASCII (no accented characters for unlocalized strings)
        if not string.isascii():
            return False

        # Must be reasonably long (but not too long - avoid code blocks)
        if len(string) < 3 or len(string) > 100:
            return False

        # Should contain letters and spaces (user-facing text)
        if not re.search(r'[a-zA-Z]', string):
            return False

        # Skip strings that look like code/variables
        if re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', string):
            return False

        # Skip strings that are likely file paths or URLs
        if '/' in string or '\\' in string or '.mdl' in string or '.wav' in string or '.mp3' in string:
            return False

        # Skip strings that contain code-like patterns
        if re.search(r'[{}()\[\]\\|<>=\+\-*/%]', string):
            return False

        # Skip strings that look like SQL queries or code fragments
        if re.search(r'\b(SELECT|INSERT|UPDATE|DELETE|FROM|WHERE|ORDER BY|LIMIT|AND|OR|NOT|NULL|DEFAULT|PRIMARY KEY)\b', string.upper()):
            return False

        # Skip strings that contain variable interpolation patterns
        if re.search(r'\$\w+|\.\.\s*\w+', string):
            return False

        # Skip strings that look like function calls or code
        if re.search(r'\w+\([^)]*\)', string):
            return False

        # Skip strings that contain Lua code patterns
        if re.search(r'\b(local|function|if|then|else|end|for|do|in|return|nil|true|false)\b', string):
            return False

        # Skip strings that contain vgui.Create or other UI code patterns
        if re.search(r'\b(vgui\.Create|surface\.|draw\.|IsValid|SetEnabled|SetText)\b', string):
            return False

        # Skip strings that look like incomplete code fragments
        if re.search(r'[#\[\]{}(),;.]', string):
            return False

        # Must contain spaces or be a complete phrase (not just single words that are likely variable names)
        if ' ' not in string and not any(string.endswith(punct) for punct in '.!?'):
            # Allow some common UI words that might not have spaces
            ui_words = {'ok', 'cancel', 'yes', 'no', 'save', 'load', 'delete', 'edit', 'create', 'close', 'open', 'settings', 'help', 'info', 'warning', 'error', 'success', 'failed', 'loading', 'ready', 'enabled', 'disabled', 'active', 'inactive'}
            if string.lower() not in ui_words:
                return False

        return True

    def filter_candidates(self, all_strings, existing_strings):
        """Filter strings to find localization candidates"""
        candidates = []

        for string in all_strings:
            # Skip if already localized
            if string in existing_strings:
                continue

            # Skip empty strings
            if not string.strip():
                continue

            # Skip strings with non-ASCII characters (likely already localized)
            if not string.isascii():
                continue

            # Skip very short strings (likely not user-facing)
            if len(string) < 3:
                continue

            # Skip strings that look like code/variables
            if re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', string):
                continue

            # Skip strings that are likely file paths or URLs
            if '/' in string or '\\' in string or '.mdl' in string or '.wav' in string or '.mp3' in string:
                continue

            # Skip strings that are likely internal identifiers
            if re.match(r'^[A-Z][A-Z_]*$', string):  # ALL_CAPS
                continue

            # Skip strings with special characters that suggest they're not user text
            if re.search(r'[{}()\[\]\\|<>]', string):
                continue

            # Skip strings that look like function calls or code
            if re.search(r'\w+\([^)]*\)', string):
                continue

            # Skip strings that contain code-like patterns
            if re.search(r'[=+\-*/%]', string):
                continue

            # Skip strings that look like SQL queries or code fragments
            if re.search(r'\b(SELECT|INSERT|UPDATE|DELETE|FROM|WHERE|ORDER BY|LIMIT|AND|OR|NOT|NULL|DEFAULT|PRIMARY KEY)\b', string.upper()):
                continue

            # Skip strings that contain variable interpolation patterns
            if re.search(r'\$\w+|\.\.\s*\w+', string):
                continue

            # Check if it appears to be English user-facing text
            if self.is_english_text(string):
                candidates.append(string)

        return candidates

    def scan(self):
        """Main scanning function"""
        print("Starting localization scan...")

        # Load existing strings
        existing_strings = self.load_existing_strings()

        # Scan for all string literals
        all_strings = self.scan_lua_files()

        # Filter to find candidates
        candidates = self.filter_candidates(all_strings, existing_strings)

        print(f"Found {len(candidates)} localization candidates")

        # Group and sort candidates
        results = {
            'candidates': sorted(list(set(candidates))),
            'total_strings': len(all_strings),
            'existing_strings': len(existing_strings)
        }

        return results

def main():
    parser = argparse.ArgumentParser(description='Scan for unlocalized strings in Lilia gamemode')
    parser.add_argument('--output', '-o', default='localization_report.json',
                       help='Output file for the report')
    parser.add_argument('--format', '-f', choices=['json', 'text'], default='json',
                       help='Output format')

    args = parser.parse_args()

    scanner = LocalizationScanner()
    results = scanner.scan()

    if args.format == 'json':
        with open(args.output, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, ensure_ascii=False)
        print(f"Results saved to {args.output}")
        print(f"Found {len(results['candidates'])} localization candidates")
    else:
        # Text format
        print("\n" + "="*60)
        print("LOCALIZATION CANDIDATES")
        print("="*60)
        print(f"Total strings found: {results['total_strings']}")
        print(f"Existing localized strings: {results['existing_strings']}")
        print(f"Candidates for localization: {len(results['candidates'])}")
        print()

        if results['candidates']:
            for i, candidate in enumerate(results['candidates'], 1):
                try:
                    print(f"{i:3d}. '{candidate}'")
                except UnicodeEncodeError:
                    print(f"{i:3d}. [Unicode string - check JSON output]")
        else:
            print("No localization candidates found!")

if __name__ == "__main__":
    main()

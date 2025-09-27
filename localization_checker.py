#!/usr/bin/env python3
"""
Lilia Localization Checker - Python Version
This script finds hardcoded strings that should be localized in the Lilia gamemode.
"""

import os
import re
import json
from pathlib import Path
from typing import Dict, List, Set, Tuple


def read_english_language_file() -> Dict[str, str]:
    """Read the English language file and extract all localized strings."""
    lang_file = Path("gamemode/languages/english.lua")

    if not lang_file.exists():
        print(f"ERROR: Could not find {lang_file}")
        return {}

    try:
        with open(lang_file, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"ERROR: Could not read {lang_file}: {e}")
        return {}

    # Extract the LANGUAGE table
    language_table = {}
    in_language_table = False

    for line in content.splitlines():
        line = line.strip()

        if line.startswith("LANGUAGE = {"):
            in_language_table = True
            continue
        elif line == "}" and in_language_table:
            break
        elif in_language_table:
            # Parse key = "value" pairs
            match = re.match(r'^(\w+)\s*=\s*"([^"]*)"', line)
            if match:
                key, value = match.groups()
                language_table[key] = value

    return language_table


def is_user_facing_string(text: str) -> bool:
    """Check if a string looks like user-facing text that should be localized."""
    if len(text) <= 3 or not text.strip():
        return False

    # Skip database and technical strings
    skip_conditions = [
        text.startswith(('/', '\\')),
        text.startswith('http'),
        text.endswith(('.lua', '.png', '.jpg', '.wav', '.mp3')),
        bool(re.match(r'^\d+x?\d*$', text)),  # Resolution-like strings
        bool(re.match(r'^\d+\.?\d*$', text)),  # Numeric strings
        bool(re.match(r'^[A-Z_][A-Z_]+$', text)),  # Constants
        bool(re.match(r'^\[.*\]$', text)),  # Table/array strings
        bool(re.match(r'^\{.*\}$', text)),  # Object notation
        bool(re.match(r'^#.*', text)),  # Comments
    ]

    if any(skip_conditions):
        return False

    # Additional skip conditions for code patterns
    code_patterns = [
        # Lua code patterns
        'function' in text.lower(),
        'local' in text.lower(),
        'end' in text.lower(),
        'return' in text.lower(),
        'if' in text.lower(),
        'for' in text.lower(),
        'while' in text.lower(),
        'do' in text.lower(),
        'then' in text.lower(),
        'else' in text.lower(),
        'elseif' in text.lower(),
        # Code patterns
        text.count('[') > 0,
        text.count(']') > 0,
        text.count('{') > 0,
        text.count('}') > 0,
        'self.' in text,
        'client:' in text,
        'player:' in text,
        '.Get' in text,
        '.Set' in text,
        'table.' in text,
        'string.' in text,
        'math.' in text,
        'lia.' in text,
        'net.' in text,
        'hook.' in text,
        'util.' in text,
        'vgui.' in text,
        'surface.' in text,
        'render.' in text,
        # Hook patterns
        'hook.Add' in text,
        'hook.Call' in text,
        'hook.Run' in text,
        # Net patterns
        'net.Receive' in text,
        'net.Start' in text,
        'net.Send' in text,
        'net.Broadcast' in text,
        # Database/SQL patterns - comprehensive
        text.upper() in [
            'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'FROM', 'WHERE', 'AND', 'OR',
            'JOIN', 'ORDER', 'GROUP', 'BY', 'LIMIT', 'CREATE', 'DROP', 'ALTER',
            'TABLE', 'INDEX', 'PRIMARY', 'KEY', 'FOREIGN', 'REFERENCES', 'UNIQUE',
            'DEFAULT', 'AUTO_INCREMENT', 'NOT', 'NULL', 'INT', 'VARCHAR', 'TEXT',
            'DATETIME', 'TIMESTAMP', 'BOOL', 'BOOLEAN', 'FLOAT', 'DOUBLE', 'DECIMAL',
            'ASC', 'DESC', 'LIKE', 'IN', 'BETWEEN', 'EXISTS', 'DISTINCT', 'COUNT',
            'MAX', 'MIN', 'AVG', 'SUM', 'HAVING', 'UNION', 'ALL', 'AS', 'ON'
        ],
        'ADD COLUMN' in text.upper(),
        'DROP COLUMN' in text.upper(),
        'LEFT JOIN' in text.upper(),
        'INNER JOIN' in text.upper(),
        'RIGHT JOIN' in text.upper(),
        'FULL JOIN' in text.upper(),
        'LEFT OUTER JOIN' in text.upper(),
        'RIGHT OUTER JOIN' in text.upper(),
        'FULL OUTER JOIN' in text.upper(),
        'CROSS JOIN' in text.upper(),
        'AS c' in text,
        'AS p' in text,
        'lia_characters' in text,
        'lia_players' in text,
        'lia_' in text and ('FROM' in text.upper() or 'WHERE' in text.upper() or 'JOIN' in text.upper()),
        'ORDER BY' in text.upper(),
        'GROUP BY' in text.upper(),
        'DESC' in text.upper(),
        'ASC' in text.upper(),
        'LIMIT' in text.upper(),
        'OFFSET' in text.upper(),
        'NOT NULL' in text.upper(),
        'PRIMARY KEY' in text.upper(),
        'FOREIGN KEY' in text.upper(),
        'AUTO_INCREMENT' in text.upper(),
        'UNIQUE KEY' in text.upper(),
        bool(re.match(r'^\s*\d+\s*$', text)),  # Just numbers
        # Database table/column patterns - comprehensive
        bool(re.match(r'^[a-z_]+_id$', text.lower())),  # ID columns
        bool(re.match(r'^[a-z_]+_name$', text.lower())),  # Name columns
        bool(re.match(r'^[a-z_]+_data$', text.lower())),  # Data columns
        bool(re.match(r'^[a-z_]+_time$', text.lower())),  # Time columns
        bool(re.match(r'^[a-z_]+_date$', text.lower())),  # Date columns
        bool(re.match(r'^[a-z_]+_count$', text.lower())),  # Count columns
        bool(re.match(r'^[a-z_]+_value$', text.lower())),  # Value columns
        bool(re.match(r'^[a-z_]+_type$', text.lower())),  # Type columns
        bool(re.match(r'^[a-z_]+_status$', text.lower())),  # Status columns
        bool(re.match(r'^[a-z_]+_level$', text.lower())),  # Level columns
        bool(re.match(r'^[a-z_]+_amount$', text.lower())),  # Amount columns
        bool(re.match(r'^[a-z_]+_price$', text.lower())),  # Price columns
        bool(re.match(r'^[a-z_]+_cost$', text.lower())),  # Cost columns
        # Database query patterns
        ' = ' in text and ('AND' in text.upper() or 'WHERE' in text.upper() or 'SET' in text.upper()),
        ' LIKE ' in text.upper(),
        ' IN ' in text.upper(),
        ' BETWEEN ' in text.upper(),
        # SQL operators and fragments
        text.strip().startswith('= ') or text.strip().endswith(' ='),
        text.strip().startswith('> ') or text.strip().endswith(' >'),
        text.strip().startswith('< ') or text.strip().endswith(' <'),
        text.strip().startswith('>= ') or text.strip().endswith(' >='),
        text.strip().startswith('<= ') or text.strip().endswith(' <='),
        text.strip().startswith('!= ') or text.strip().endswith(' !='),
        text.strip().startswith('<> ') or text.strip().endswith(' <>'),
        # Localization checker script strings
        'Found in files:' in text,
        'Suggested key:' in text,
        'Suggested localization entry:' in text,
        'MISSING LOCALIZATION' in text,
        'ALREADY LOCALIZED' in text,
        'Total hardcoded strings found:' in text,
        'Total localized strings in English:' in text,
        # Other script output
        '=== LILIA LOCALIZATION REPORT ===' in text,
        'SUMMARY:' in text,
        'These strings were found in the code' in text,
        # Module metadata patterns
        'MODULE.name = ' in text,
        'MODULE.desc = ' in text,
        'MODULE.author = ' in text,
        'MODULE.version = ' in text,
        # Table/array data patterns
        text.count(',') > 3 and text.count('"') > 2,  # Likely table data
        bool(re.match(r'^\s*\{.*\}.*$', text)),  # Table-like structures
        bool(re.match(r'^\s*\[.*\].*$', text)),  # Array-like structures
        # Configuration values that are clearly technical
        'Enabled' in text and ('true' in text.lower() or 'false' in text.lower()),
        'Disabled' in text and ('true' in text.lower() or 'false' in text.lower()),
        # Framework constants and technical values
        text.isupper() and len(text) > 5,  # All caps technical constants
        bool(re.match(r'^\d+\.\d+$', text)),  # Version numbers
        bool(re.match(r'^\d{4}-\d{2}-\d{2}$', text)),  # Date patterns
        # String concatenation patterns
        text.startswith(' .. '),
        text.endswith(' .. '),
        text.startswith(' .. L('),
        text.endswith(') .. '),
        text.startswith('L('),
        text.endswith(')'),
        # Variable patterns
        text.startswith(' .. '),
        text.endswith(' .. '),
        bool(re.match(r'^\s*\.\.\s*', text)),  # Starts with ..
        bool(re.match(r'\s*\.\.\s*$', text)),  # Ends with ..
    ]

    if any(code_patterns):
        return False

    # Must contain actual words or be user-facing
    # Check for multiple words or clear user-facing patterns
    words = re.findall(r'\b\w+\b', text)
    if len(words) < 2 and not any(keyword in text for keyword in [
        'Error', 'Warning', 'Success', 'Failed', 'Invalid',
        'Please', 'Loading', 'Saving', 'Cannot', 'Unable',
        'Click', 'Press', 'Select', 'Choose', 'Enter',
        'Save', 'Load', 'Delete', 'Create', 'Edit', 'View'
    ]):
        return False

    # Check if it looks like user-facing text
    return (bool(re.search(r'\s', text)) or  # Contains spaces
            bool(re.match(r'^[A-Z][a-z]', text)) or  # Starts with capital letter
            any(keyword in text for keyword in [
                'Error', 'Warning', 'Success', 'Failed', 'Invalid',
                'Please', 'Loading', 'Saving', 'Cannot', 'Unable',
                'Click', 'Press', 'Select', 'Choose', 'Enter',
                'Save', 'Load', 'Delete', 'Create', 'Edit', 'View'
            ]))


def find_all_quoted_strings() -> Dict[str, List[str]]:
    """Find all quoted strings in Lua files that look like user-facing text."""
    strings = {}
    gamemode_path = Path("gamemode")

    if not gamemode_path.exists():
        print(f"ERROR: Could not find gamemode directory")
        return strings

    # Find all Lua files
    lua_files = []
    for root, dirs, files in os.walk(gamemode_path):
        # Skip language directories
        dirs[:] = [d for d in dirs if not d.startswith('languages')]

        for file in files:
            if file.endswith('.lua'):
                lua_files.append(Path(root) / file)

    print(f"Scanning {len(lua_files)} Lua files...")

    for file_path in lua_files:
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
        except Exception as e:
            print(f"Warning: Could not read {file_path}: {e}")
            continue

        # Find all quoted strings
        for match in re.finditer(r'"([^"]*)"', content):
            string_content = match.group(1)

            if is_user_facing_string(string_content):
                if string_content not in strings:
                    strings[string_content] = []
                strings[string_content].append(str(file_path.relative_to(gamemode_path)))

    return strings


def generate_report(localized_strings: Dict[str, str],
                   hardcoded_strings: Dict[str, List[str]]) -> None:
    """Generate a detailed report of the localization analysis."""
    missing = {}
    found = {}

    for string, files in hardcoded_strings.items():
        if string not in localized_strings:
            missing[string] = files
        else:
            found[string] = files

    # Create report (markdown format)
    report_lines = []
    report_lines.append("# Lilia Localization Report")
    report_lines.append("")
    report_lines.append("## Summary")
    report_lines.append(f"- **Total hardcoded strings found:** {len(hardcoded_strings)}")
    report_lines.append(f"- **Strings already localized:** {len(found)}")
    report_lines.append(f"- **Strings missing localization:** {len(missing)}")
    report_lines.append(f"- **Total localized strings in English:** {len(localized_strings)}")
    report_lines.append("")

    # Missing strings
    if missing:
        report_lines.append("## Missing Localization")
        report_lines.append("")
        report_lines.append("These strings were found in the code but are not in the English language file.")
        report_lines.append("Add them to `gamemode/languages/english.lua` in the `LANGUAGE` table.")
        report_lines.append("")

        for string, files in sorted(missing.items()):
            report_lines.append(f'### "{string}"')
            report_lines.append("")
            report_lines.append("**Found in files:**")
            for file in sorted(set(files)):  # Remove duplicates
                report_lines.append(f"- `{file}`")


    # Write report to file
    report_content = "\n".join(report_lines)

    try:
        with open("localization_report.md", 'w', encoding='utf-8') as f:
            f.write(report_content)
        print("[OK] Report generated: localization_report.md")
    except Exception as e:
        print(f"ERROR: Could not write report: {e}")

    # Print summary to console
    print("\n=== SUMMARY ===")
    print(f"Total hardcoded strings found: {len(hardcoded_strings)}")
    print(f"Strings already localized: {len(found)}")
    print(f"Strings missing localization: {len(missing)}")
    print(f"Total localized strings in English: {len(localized_strings)}")


def main():
    """Main execution function."""
    print("[SEARCH] Starting Lilia localization check...")

    # Read localized strings
    print("[BOOK] Reading English language file...")
    localized_strings = read_english_language_file()
    print(f"   Loaded {len(localized_strings)} localized strings")

    # Find hardcoded strings
    print("[SCAN] Scanning for hardcoded strings...")
    hardcoded_strings = find_all_quoted_strings()
    print(f"   Found {len(hardcoded_strings)} potential hardcoded strings")

    # Generate report
    print("[REPORT] Generating report...")
    generate_report(localized_strings, hardcoded_strings)

    print("\n[SUCCESS] Localization check complete!")


if __name__ == "__main__":
    main()

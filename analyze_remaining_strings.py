#!/usr/bin/env python3
"""
Analyze remaining unlocalized strings in Lilia gamemode
"""
import json
import re
from pathlib import Path

def load_unlocalized_report():
    """Load the unlocalized strings report"""
    try:
        with open('unlocalized_strings_report.json', 'r', encoding='utf-8') as f:
            return json.load(f)
    except FileNotFoundError:
        print("unlocalized_strings_report.json not found")
        return None

def load_filtered_strings():
    """Load filtered strings that need localization"""
    try:
        with open('filtered_remaining_strings.txt', 'r', encoding='utf-8') as f:
            content = f.read()
            # Extract strings from the file (skipping the header)
            lines = content.split('\n')[3:]  # Skip header lines
            strings = []
            for line in lines:
                line = line.strip()
                if line.startswith('"') and line.endswith('"'):
                    strings.append(line[1:-1])  # Remove quotes
                elif line and not line.startswith('='):
                    strings.append(line)
            return strings
    except FileNotFoundError:
        print("filtered_remaining_strings.txt not found")
        return []

def load_remaining_strings():
    """Load remaining unlocalized strings"""
    try:
        with open('remaining_unlocalized_strings.txt', 'r', encoding='utf-8') as f:
            content = f.read()
            # Extract strings from the file (skipping the header)
            lines = content.split('\n')[3:]  # Skip header lines
            strings = []
            for line in lines:
                line = line.strip()
                if line.startswith('"') and line.endswith('"'):
                    strings.append(line[1:-1])  # Remove quotes
                elif line and not line.startswith('='):
                    strings.append(line)
            return strings
    except FileNotFoundError:
        print("remaining_unlocalized_strings.txt not found")
        return []

def analyze_strings():
    """Analyze and categorize the strings"""
    report = load_unlocalized_report()
    filtered = load_filtered_strings()
    remaining = load_remaining_strings()

    print("=== UNLOCALIZED STRINGS ANALYSIS ===\n")

    print(f"Total potential strings in JSON report: {report['total_potential_strings']}")
    print(f"Filtered strings: {report['filtered_strings']}")
    print(f"JSON report contains {len(report['strings'])} string entries")

    print(f"\nFiltered strings file contains {len(filtered)} strings")
    print(f"Remaining strings file contains {len(remaining)} strings")

    # Analyze by file types and patterns
    file_patterns = {}
    for entry in report['strings']:
        for file_path in entry['files']:
            if file_path not in file_patterns:
                file_patterns[file_path] = []
            file_patterns[file_path].append(entry['string'])

    print("
=== STRINGS BY FILE TYPE ===")
    for file_path, strings in file_patterns.items():
        print(f"\n{file_path} ({len(strings)} strings):")
        for string in strings[:5]:  # Show first 5 strings per file
            print(f'  "{string}"')
        if len(strings) > 5:
            print(f"  ... and {len(strings) - 5} more")

    # Show high-frequency strings (likely important)
    print("
=== HIGH FREQUENCY STRINGS (>1 occurrence) ===")
    high_freq = [entry for entry in report['strings'] if entry['frequency'] > 1]
    for entry in sorted(high_freq, key=lambda x: x['frequency'], reverse=True):
        print(f"{entry['frequency']}x: '{entry['string']}' in {len(entry['files'])} files")

    # Show longest strings (likely descriptions)
    print("
=== LONGEST STRINGS (>50 chars) ===")
    long_strings = [entry for entry in report['strings'] if entry['length'] > 50]
    for entry in sorted(long_strings, key=lambda x: x['length'], reverse=True)[:10]:
        print(f"{entry['length']} chars: '{entry['string']}'")

if __name__ == "__main__":
    analyze_strings()

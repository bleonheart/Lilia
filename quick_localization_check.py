#!/usr/bin/env python3
"""
Quick check for any remaining unlocalized strings in key files
"""

import os
import re
from pathlib import Path

def check_file_for_unlocalized_strings(filepath):
    """Check a single file for potential unlocalized strings"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except:
        return []

    # Find string literals that might need localization
    strings = re.findall(r'"([^"]*)"', content)
    candidates = []

    for string in strings:
        # Skip if too short or looks like code
        if len(string) < 4 or re.match(r'^[A-Z_][A-Z0-9_]*$', string):
            continue

        # Skip if contains code patterns
        if any(pattern in string for pattern in ['%s', '%d', '..', '==', '++', '--']):
            continue

        # Skip if already looks like a localization key
        if re.match(r'^[a-z][a-zA-Z]*$', string) and string not in ['the', 'and', 'for', 'are', 'but', 'not', 'you', 'can', 'will', 'should']:
            continue

        candidates.append(string)

    return candidates

def main():
    gamemode_path = Path("gamemode")

    # Check some key files that might have unlocalized strings
    key_files = [
        "gamemode/core/libraries/client.lua",
        "gamemode/core/libraries/server.lua",
        "gamemode/modules/administration/sv_commands.lua",
        "gamemode/modules/chatbox/sv_commands.lua",
    ]

    all_candidates = []

    for file_path in key_files:
        full_path = gamemode_path / file_path
        if full_path.exists():
            candidates = check_file_for_unlocalized_strings(full_path)
            if candidates:
                print(f"\n{file_path}:")
                for candidate in candidates[:10]:  # Show first 10
                    print(f"  '{candidate}'")
                if len(candidates) > 10:
                    print(f"  ... and {len(candidates) - 10} more")

if __name__ == "__main__":
    main()

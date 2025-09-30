#!/usr/bin/env python3
"""
Targeted scanner for user-facing messages that need localization
Focuses on strings that are clearly meant for users
"""

import os
import re
from pathlib import Path
from collections import defaultdict

def scan_for_user_messages():
    """Scan for strings that are clearly user-facing messages"""
    root_dir = Path("gamemode")
    potential_strings = defaultdict(list)

    # Patterns that indicate user-facing messages
    user_message_patterns = [
        # Error messages
        r'".*(?:error|Error|ERROR|failed|Failed|FAILED|invalid|Invalid|INVALID).*?"',
        r'".*(?:cannot|Cannot|can\'t|Can\'t|unable|Unable|not allowed|Not Allowed).*?"',
        r'".*(?:need|Need|requires|Requires|missing|Missing).*?"',

        # Status messages
        r'".*(?:success|Success|SUCCESS|complete|Complete|COMPLETE|done|Done|DONE).*?"',
        r'".*(?:loading|Loading|LOADING|please wait|Please Wait|PLEASE WAIT).*?"',

        # User instructions
        r'".*(?:press|Press|PRESS|click|Click|CLICK|select|Select|SELECT).*?"',
        r'".*(?:use|Use|USE|enter|Enter|ENTER|type|Type|TYPE).*?"',

        # Notifications and alerts
        r'".*(?:warning|Warning|WARNING|alert|Alert|ALERT|notice|Notice|NOTICE).*?"',
        r'".*(?:information|Information|INFORMATION|info|Info|INFO).*?"',

        # Questions and confirmations
        r'".*(?:\?|question|Question|QUESTION|confirm|Confirm|CONFIRM).*?"',

        # Game-specific messages
        r'".*(?:playtime|Playtime|PLAYTIME|level|Level|LEVEL|experience|Experience|EXPERIENCE).*?"',
        r'".*(?:inventory|Inventory|INVENTORY|item|Item|ITEM|weapon|Weapon|WEAPON).*?"',
        r'".*(?:character|Character|CHARACTER|faction|Faction|FACTION|class|Class|CLASS).*?"',
    ]

    print("Scanning for user-facing messages...")

    for lua_file in root_dir.rglob("*.lua"):
        # Skip language files and third-party libraries
        if ("languages" in lua_file.parts or
            "thirdparty" in lua_file.parts or
            "vendor" in str(lua_file).lower()):
            continue

        try:
            with open(lua_file, 'r', encoding='utf-8') as f:
                content = f.read()

            # Find all string literals
            strings = re.findall(r'["\']([^"\']+)["\']', content)

            for string in strings:
                # Skip very short strings
                if len(string) < 8:
                    continue

                # Skip strings that look like code
                if any(char in string for char in ['{', '}', '[', ']', '(', ')']):
                    continue

                # Skip strings with newlines (likely multi-line code)
                if '\n' in string:
                    continue

                # Skip strings that are likely variable names or code
                if re.match(r'^[a-zA-Z_][a-zA-Z0-9_]*$', string):
                    continue

                # Check if string matches user message patterns
                is_user_message = False
                for pattern in user_message_patterns:
                    if re.search(pattern, string, re.IGNORECASE):
                        is_user_message = True
                        break

                if is_user_message:
                    potential_strings[string].append(str(lua_file.relative_to(root_dir)))

        except Exception as e:
            print(f"Error reading {lua_file}: {e}")

    # Filter and sort results
    filtered_results = []
    for string, files in potential_strings.items():
        # Skip strings that appear in too many files (likely common messages)
        if len(files) > 5:
            continue

        filtered_results.append({
            'string': string,
            'files': files,
            'frequency': len(files)
        })

    # Sort by frequency
    filtered_results.sort(key=lambda x: x['frequency'], reverse=True)

    return filtered_results

def main():
    results = scan_for_user_messages()

    print(f"\nFound {len(results)} potential user-facing messages that need localization:")
    print("=" * 80)

    for i, result in enumerate(results[:50], 1):  # Show top 50
        print(f"{i:2d}. '{result['string']}'")
        print(f"    Files: {', '.join(result['files'])}")
        print(f"    Frequency: {result['frequency']}")
        print()

    if len(results) > 50:
        print(f"... and {len(results) - 50} more")

    print("These strings should be wrapped with L() for proper localization.")

if __name__ == "__main__":
    main()

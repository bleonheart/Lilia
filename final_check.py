#!/usr/bin/env python3
"""
Final check for unlocalized strings
"""

import os
import re
from pathlib import Path

def load_localized_strings():
    localized = set()
    for lang_file in Path('gamemode/languages').glob('*.lua'):
        try:
            with open(lang_file, 'r', encoding='utf-8') as f:
                content = f.read()
            strings = re.findall(r'\s*[\w_]+\s*=\s*"([^"]*)"', content)
            localized.update(strings)
        except: pass
    return localized

def find_hardcoded_strings():
    localized = load_localized_strings()
    candidates = []

    for root, dirs, files in os.walk('gamemode'):
        for file in files:
            if file.endswith('.lua'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()

                    # Remove comments
                    content = re.sub(r'--.*$', '', content, flags=re.MULTILINE)

                    # Find string literals that are NOT in L() function calls
                    # Pattern to match strings that are NOT preceded by L( on the same line
                    pattern = r'(?<!L\()\s*["\']([^"\']+)["\']'
                    matches = re.findall(pattern, content)

                    for string in matches:
                        if string in localized: continue
                        if not string.strip() or len(string) < 3: continue
                        if re.match(r'^[A-Z_][A-Z0-9_]*$', string): continue
                        if '/' in string or '\\' in string or '.mdl' in string or '.wav' in string or '.mp3' in string: continue
                        if any(pattern in string for pattern in ['%s', '%d', '==', '++', '--', '..']): continue
                        if re.search(r'\w+\([^)]*\)', string): continue
                        if re.search(r'[{}()\[\]]', string): continue
                        if any(keyword in string.lower() for keyword in ['function', 'local', 'if', 'then', 'else', 'end', 'return', 'nil', 'true', 'false']): continue
                        if any(sql_word in string.upper() for sql_word in ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'FROM', 'WHERE', 'ORDER BY', 'LIMIT', 'AND', 'OR', 'NOT', 'NULL']): continue
                        if string.startswith('+') or string.startswith('-') or string.startswith('sv_') or string.startswith('cl_'): continue
                        if any(technical in string.lower() for technical in ['id =', 'steamid =', 'charid =', 'schema =', 'dropdelay', 'takedelay', 'equipdelay', 'unequipdelay']): continue

                        if (' ' in string or string.endswith('.') or string.endswith('!') or string.endswith('?') or
                            string.lower() in ['ok', 'cancel', 'yes', 'no', 'save', 'load', 'delete', 'edit', 'create', 'close', 'open', 'settings', 'help', 'info', 'warning', 'error', 'success', 'failed', 'loading', 'ready', 'enabled', 'disabled', 'active', 'inactive', 'copy']):
                            candidates.append((filepath, string))

                except: pass

    return candidates

candidates = find_hardcoded_strings()
print(f'Found {len(candidates)} hardcoded strings that may need localization:')

# Save to file for review
with open('remaining_candidates.txt', 'w', encoding='utf-8') as f:
    for filepath, string in candidates:
        f.write(f'{filepath}: "{string}"\n')

# Show first 50 for review
for filepath, string in candidates[:50]:
    print(f'  {filepath}: "{string}"')

if len(candidates) > 50:
    print(f'  ... and {len(candidates) - 50} more')
    print(f'Full list saved to remaining_candidates.txt')

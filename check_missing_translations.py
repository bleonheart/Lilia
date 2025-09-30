#!/usr/bin/env python3
import re
from pathlib import Path

def load_strings(filename):
    strings = set()
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            content = f.read()
        strings = set(re.findall(r'\s*[\w_]+\s*=\s*"([^"]*)"', content))
    except:
        pass
    return strings

def main():
    english = load_strings('gamemode/languages/english.lua')
    french = load_strings('gamemode/languages/french.lua')
    german = load_strings('gamemode/languages/german.lua')
    portuguese = load_strings('gamemode/languages/portuguese.lua')
    spanish = load_strings('gamemode/languages/spanish.lua')

    print(f'English: {len(english)} strings')
    print(f'French: {len(french)} strings')
    print(f'German: {len(german)} strings')
    print(f'Portuguese: {len(portuguese)} strings')
    print(f'Spanish: {len(spanish)} strings')

    missing_in_french = english - french
    missing_in_german = english - german
    missing_in_portuguese = english - portuguese
    missing_in_spanish = english - spanish

    print(f'\nMissing in French: {len(missing_in_french)}')
    print(f'Missing in German: {len(missing_in_german)}')
    print(f'Missing in Portuguese: {len(missing_in_portuguese)}')
    print(f'Missing in Spanish: {len(missing_in_spanish)}')

    # Find strings that are in multiple languages but missing from one
    if missing_in_french:
        print('\nFirst 20 missing in French:')
        for i, string in enumerate(sorted(list(missing_in_french))[:20]):
            print(f'  {i+1}. "{string}"')

    if missing_in_german:
        print('\nFirst 20 missing in German:')
        for i, string in enumerate(sorted(list(missing_in_german))[:20]):
            print(f'  {i+1}. "{string}"')

    if missing_in_portuguese:
        print('\nFirst 20 missing in Portuguese:')
        for i, string in enumerate(sorted(list(missing_in_portuguese))[:20]):
            print(f'  {i+1}. "{string}"')

    if missing_in_spanish:
        print('\nFirst 20 missing in Spanish:')
        for i, string in enumerate(sorted(list(missing_in_spanish))[:20]):
            print(f'  {i+1}. "{string}"')

if __name__ == "__main__":
    main()

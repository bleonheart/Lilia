#!/usr/bin/env python3
import re
from pathlib import Path

def load_language_file(filename):
    """Load a language file and return a dict of key -> value pairs"""
    lang_dict = {}
    try:
        with open(filename, 'r', encoding='utf-8') as f:
            content = f.read()

        # Extract key = "value" pairs
        matches = re.findall(r'\s*(\w+)\s*=\s*"([^"]*)"', content)
        for key, value in matches:
            lang_dict[key] = value
    except Exception as e:
        print(f"Error loading {filename}: {e}")
    return lang_dict

def main():
    # Load all language files
    english = load_language_file('gamemode/languages/english.lua')
    french = load_language_file('gamemode/languages/french.lua')
    german = load_language_file('gamemode/languages/german.lua')
    portuguese = load_language_file('gamemode/languages/portuguese.lua')
    spanish = load_language_file('gamemode/languages/spanish.lua')

    print("Language file statistics:")
    print(f"English: {len(english)} entries")
    print(f"French: {len(french)} entries")
    print(f"German: {len(german)} entries")
    print(f"Portuguese: {len(portuguese)} entries")
    print(f"Spanish: {len(spanish)} entries")

    # Find entries that are in other languages but not in English
    all_non_english = set(french.keys()) | set(german.keys()) | set(portuguese.keys()) | set(spanish.keys())
    missing_in_english = all_non_english - set(english.keys())

    print(f"\nEntries in other languages but missing in English: {len(missing_in_english)}")

    if missing_in_english:
        print("\nFirst 30 entries missing in English:")
        for i, key in enumerate(sorted(list(missing_in_english))[:30]):
            # Find which language has this key
            sources = []
            if key in french: sources.append("French")
            if key in german: sources.append("German")
            if key in portuguese: sources.append("Portuguese")
            if key in spanish: sources.append("Spanish")

            # Get the value from one of the sources (French as primary)
            value = french.get(key, german.get(key, portuguese.get(key, spanish.get(key, "???"))))
            print(f"{i+1:2d}. {key} = \"{value}\" (from: {', '.join(sources)})")

        if len(missing_in_english) > 30:
            print(f"... and {len(missing_in_english) - 30} more")

    # Also check for entries that are in English but missing in other languages
    print("\nChecking for entries in English but missing in other languages...")

    for lang_name, lang_dict in [("French", french), ("German", german), ("Portuguese", portuguese), ("Spanish", spanish)]:
        missing_in_lang = set(english.keys()) - set(lang_dict.keys())
        if missing_in_lang:
            print(f"\n{lang_name} is missing {len(missing_in_lang)} entries that are in English")
            print("First 10:")
            for i, key in enumerate(sorted(list(missing_in_lang))[:10]):
                print(f"  {i+1}. {key} = \"{english[key]}\"")

if __name__ == "__main__":
    main()

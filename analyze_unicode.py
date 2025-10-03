#!/usr/bin/env python3
import os
import re
import json

def has_unicode_only(text):
    """Check if text contains only unicode characters (no ASCII)"""
    if not text.strip():
        return False

    # Check if the text has any non-ASCII characters
    has_unicode = bool(re.search(r'[^\x00-\x7F]', text))

    # For unicode-only, we want strings that contain unicode but are not purely ASCII
    # Actually, let's reconsider - unicode-only might mean strings that consist entirely of unicode characters
    # But looking at the user's request, they probably want to identify strings that contain unicode characters

    return has_unicode

def analyze_language_file(file_path):
    """Analyze a language file for unicode characters"""
    print(f"\n=== Analyzing {os.path.basename(file_path)} ===")

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find all string assignments in the Lua file
    string_pattern = r'(\w+)\s*=\s*"([^"]*)"'
    matches = re.findall(string_pattern, content)

    unicode_only_strings = []
    strings_with_unicode = []

    for key, value in matches:
        if has_unicode_only(value):
            unicode_only_strings.append((key, value))
        elif re.search(r'[^\x00-\x7F]', value):
            strings_with_unicode.append((key, value))

    if unicode_only_strings:
        print(f"\n[UNICODE-ONLY] ({len(unicode_only_strings)} strings):")
        for key, value in unicode_only_strings:
            # Replace problematic unicode characters for display
            display_value = value.encode('unicode_escape').decode('ascii', 'ignore')
            print(f"  {key} = \"{display_value}\"")

    if strings_with_unicode:
        print(f"\n[WITH-UNICODE] ({len(strings_with_unicode)} strings):")
        for key, value in strings_with_unicode[:20]:  # Show first 20
            # Replace problematic unicode characters for display
            display_value = value.encode('unicode_escape').decode('ascii', 'ignore')
            print(f"  {key} = \"{display_value}\"")
        if len(strings_with_unicode) > 20:
            print(f"  ... and {len(strings_with_unicode) - 20} more")

    return unicode_only_strings, strings_with_unicode

def main():
    languages_dir = r"E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\languages"

    all_unicode_only = {}
    all_with_unicode = {}

    for filename in os.listdir(languages_dir):
        if filename.endswith('.lua'):
            file_path = os.path.join(languages_dir, filename)
            unicode_only, with_unicode = analyze_language_file(file_path)

            if unicode_only:
                all_unicode_only[filename] = unicode_only
            if with_unicode:
                all_with_unicode[filename] = with_unicode

    print("\n=== SUMMARY ===")
    print(f"Files with unicode-only strings: {len(all_unicode_only)}")
    for filename, strings in all_unicode_only.items():
        print(f"  {filename}: {len(strings)} unicode-only strings")

    print(f"\nFiles with unicode characters: {len(all_with_unicode)}")
    for filename, strings in all_with_unicode.items():
        print(f"  {filename}: {len(strings)} strings with unicode")

    return all_unicode_only, all_with_unicode

if __name__ == "__main__":
    main()

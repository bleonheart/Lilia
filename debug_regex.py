#!/usr/bin/env python3
import re

def debug_regex():
    # Test the regex on a small sample from French file
    sample_content = '''NAME = "French"
LANGUAGE = {
    mustProvideString = "Vous devez fournir une chane de caractres",
    use = "Utiliser",
    read = "Lire",
    testKey = "Test Value",
}'''

    print("Sample content:")
    print(sample_content)
    print("\n" + "="*50 + "\n")

    # Current pattern
    pattern = r'(\w+)\s*=\s*"([^"]*(?:\\.[^"]*)*)"\s*,?'
    matches = re.findall(pattern, sample_content)

    print(f"Pattern: {pattern}")
    print(f"Matches found: {len(matches)}")
    for i, (key, value) in enumerate(matches):
        print(f"  {i+1}. '{key}' = '{value}'")

    print("\n" + "="*50 + "\n")

    # Let's also try a simpler pattern
    simple_pattern = r'(\w+)\s*=\s*"([^"]+)"'
    simple_matches = re.findall(simple_pattern, sample_content)

    print(f"Simple pattern: {simple_pattern}")
    print(f"Simple matches found: {len(simple_matches)}")
    for i, (key, value) in enumerate(simple_matches):
        print(f"  {i+1}. '{key}' = '{value}'")

if __name__ == "__main__":
    debug_regex()

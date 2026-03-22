#!/usr/bin/env python3
"""
Script to find all quoted strings in the codebase and identify unused language entries.
"""

import os
import re
import json
from pathlib import Path
from typing import Set, Dict, List

def extract_quoted_strings(file_path: Path) -> Set[str]:
    """Extract all strings enclosed in quotes from a file."""
    strings = set()
    
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
        # Match both single and double quoted strings
        # This regex handles escaped quotes and various Lua string patterns
        patterns = [
            r'"([^"\\]*(\\.[^"\\]*)*)"',  # Double quoted strings
            r"'([^'\\]*(\\.[^'\\]*)*)'"   # Single quoted strings
        ]
        
        for pattern in patterns:
            matches = re.findall(pattern, content, re.MULTILINE | re.DOTALL)
            for match in matches:
                # Handle the tuple returned by regex groups
                string_content = match[0] if isinstance(match, tuple) else match
                if string_content and len(string_content.strip()) > 0:
                    strings.add(string_content.strip())
                    
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
    
    return strings

def get_lua_files(directory: Path) -> List[Path]:
    """Get all Lua files in the directory recursively."""
    lua_files = []
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.lua'):
                lua_files.append(Path(root) / file)
    
    return lua_files

def extract_language_keys(file_path: Path) -> Dict[str, str]:
    """Extract language keys and their values from a Lua language file."""
    keys = {}
    
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # Find the language table (assuming format like "english = { ... }")
        # Look for key = "value" patterns
        pattern = r'(\w+)\s*=\s*"([^"]*)"'
        matches = re.findall(pattern, content)
        
        for key, value in matches:
            keys[key] = value
            
    except Exception as e:
        print(f"Error reading language file {file_path}: {e}")
    
    return keys

def find_unused_keys(all_strings: Set[str], language_keys: Dict[str, str]) -> Set[str]:
    """Find language keys that are not used in any quoted strings."""
    unused_keys = set()
    
    for key in language_keys.keys():
        # Check if the key appears in any quoted string
        key_used = False
        for string_content in all_strings:
            if key in string_content:
                key_used = True
                break
        
        if not key_used:
            unused_keys.add(key)
    
    return unused_keys

def remove_unused_keys(file_path: Path, unused_keys: Set[str]) -> bool:
    """Remove unused keys from the language file."""
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # Remove lines containing unused keys
        lines = content.split('\n')
        filtered_lines = []
        
        for line in lines:
            should_keep = True
            for key in unused_keys:
                # Match pattern like "key = "value""
                if re.match(rf'\s*{re.escape(key)}\s*=', line):
                    should_keep = False
                    break
            if should_keep:
                filtered_lines.append(line)
        
        # Write back the filtered content
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(filtered_lines))
        
        return True
        
    except Exception as e:
        print(f"Error modifying language file {file_path}: {e}")
        return False

def main():
    """Main function to orchestrate the process."""
    # Get the current directory (gamemode root)
    current_dir = Path.cwd()
    print(f"Scanning directory: {current_dir}")
    
    # Get all Lua files
    lua_files = get_lua_files(current_dir)
    print(f"Found {len(lua_files)} Lua files")
    
    # Extract all quoted strings
    all_strings = set()
    for lua_file in lua_files:
        print(f"Processing: {lua_file.relative_to(current_dir)}")
        strings = extract_quoted_strings(lua_file)
        all_strings.update(strings)
    
    print(f"Found {len(all_strings)} unique quoted strings")
    
    # Read the English language file
    lang_file = current_dir / "gamemode" / "languages" / "english.lua"
    if not lang_file.exists():
        print(f"Language file not found: {lang_file}")
        return
    
    language_keys = extract_language_keys(lang_file)
    print(f"Found {len(language_keys)} language keys")
    
    # Find unused keys
    unused_keys = find_unused_keys(all_strings, language_keys)
    print(f"Found {len(unused_keys)} unused language keys")
    
    if unused_keys:
        print("\nUnused keys:")
        for key in sorted(unused_keys):
            print(f"  - {key}: {language_keys.get(key, 'N/A')}")
        
        # Automatically remove unused keys
        print(f"\nAutomatically removing {len(unused_keys)} unused keys...")
        if remove_unused_keys(lang_file, unused_keys):
            print(f"Successfully removed unused keys from {lang_file}")
        else:
            print("Failed to remove unused keys")
    else:
        print("No unused keys found")

if __name__ == "__main__":
    main()

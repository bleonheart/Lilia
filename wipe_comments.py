R#!/usr/bin/env python3
"""
Simple script to remove comments from Lua files.
Removes both single-line (--) and multi-line (--[[ ]]) comments.
"""

import os
import re
import sys

def remove_comments(content):
    """Remove Lua comments from content."""
    lines = content.split('\n')
    cleaned_lines = []
    
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # Skip multi-line comments
        if '--[[' in line and ']]' not in line:
            i += 1
            while i < len(lines) and ']]' not in lines[i]:
                i += 1
            if i < len(lines):
                i += 1
            continue
        
        # Remove single-line comments
        line = re.sub(r'--.*', '', line)
        
        # Keep non-empty lines
        line = line.rstrip()
        if line:
            cleaned_lines.append(line)
        
        i += 1
    
    return '\n'.join(cleaned_lines)

def process_file(filepath):
    """Process a single file."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        cleaned = remove_comments(content)
        
        if content != cleaned:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(cleaned)
            print(f"Cleaned: {filepath}")
            return True
        return False
    except Exception as e:
        print(f"Error: {filepath} - {e}")
        return False

def main():
    if len(sys.argv) > 1:
        target = sys.argv[1]
    else:
        target = "."
    
    if os.path.isfile(target) and target.endswith('.lua'):
        # Single file
        process_file(target)
    else:
        # Directory
        count = 0
        for root, dirs, files in os.walk(target):
            for file in files:
                if file.endswith('.lua'):
                    if process_file(os.path.join(root, file)):
                        count += 1
        print(f"Processed {count} files")

if __name__ == '__main__':
    main()

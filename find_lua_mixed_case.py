#!/usr/bin/env python3
"""
Script to find single-word strings with mixed case patterns in Lua files only.
Targets strings like "nigga", "anaDidThis", and similar camelCase/PascalCase patterns.
"""

import os
import re
import argparse
from pathlib import Path
from typing import List, Tuple, Dict

def find_mixed_case_strings(file_path: str) -> List[Tuple[int, str, int]]:
    """
    Find single-word strings with mixed case patterns in a Lua file.
    
    Args:
        file_path: Path to the file to search
    
    Returns:
        List of tuples (line_number, matched_string, column_position)
    """
    results = []
    
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            lines = f.readlines()
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return results
    
    for line_num, line in enumerate(lines, 1):
        # Remove Lua comments
        clean_line = line
        clean_line = re.sub(r'--.*$', '', clean_line)  # Remove Lua comments
        clean_line = re.sub(r'/\*.*?\*/', '', clean_line, flags=re.DOTALL)  # Remove block comments
        
        # Remove all net.*() calls, hook.*() calls, vgui.Create(), and vgui.Register() calls to exclude their string literals
        clean_line = re.sub(r'net\.\w*\s*\([^)]*\)', '', clean_line)
        clean_line = re.sub(r'hook\.\w*\s*\([^)]*\)', '', clean_line)
        clean_line = re.sub(r'vgui\.Create\s*\([^)]*\)', '', clean_line)
        clean_line = re.sub(r'vgui\.Register\s*\([^)]*\)', '', clean_line)
        
        # Extract only the content within quotes
        # Find all quoted strings and search within them
        quoted_strings = re.findall(r'["\']([^"\']*)["\']', clean_line)
        
        # Combine all quoted strings into one line for searching
        quoted_content = ' '.join(quoted_strings)
        
        # Pattern for single words with mixed case (not all caps or all lowercase)
        # This specifically targets words that have both uppercase and lowercase letters
        mixed_case_pattern = r'\b[a-zA-Z]*[a-z][a-zA-Z]*[A-Z][a-zA-Z]*\b|\b[a-zA-Z]*[A-Z][a-zA-Z]*[a-z][a-zA-Z]*\b'
        
        # More specific pattern for camelCase/PascalCase style words
        camelcase_pattern = r'\b[a-z]+[A-Z][a-zA-Z]*\b'
        pascalcase_pattern = r'\b[A-Z][a-z]+[A-Z][a-zA-Z]*\b'
        
        # Pattern for words that start with lowercase and have uppercase letters inside
        lower_start_upper_middle = r'\b[a-z]+[A-Z][a-z]+\b'
        
        # Pattern for words that have uppercase letters not at the start
        upper_not_at_start = r'\b[a-z]+[A-Z][a-zA-Z]*\b'
        
        patterns = [
            mixed_case_pattern,
            camelcase_pattern,
            pascalcase_pattern,
            lower_start_upper_middle,
            upper_not_at_start
        ]
        
        for pattern in patterns:
            matches = re.finditer(pattern, quoted_content)
            for match in matches:
                matched_string = match.group()
                column_pos = match.start() + 1
                
                # Filter out common programming terms and very short words
                excluded_words = {
                    # Common Lua/GMod terms
                    'true', 'false', 'nil', 'self', 'self', 'super', 'base', 'class', 'public', 'private', 'static', 'final', 'const',
                    'var', 'let', 'func', 'function', 'method', 'return', 'break', 'continue',
                    'if', 'else', 'then', 'end', 'for', 'while', 'do', 'foreach',
                    'in', 'of', 'to', 'by', 'at', 'on', 'off', 'and', 'or', 'not', 'xor',
                    # Common acronyms (all caps)
                    'ID', 'URL', 'HTTP', 'HTTPS', 'API', 'JSON', 'XML', 'HTML', 'CSS', 'JS',
                    'TS', 'SQL', 'UI', 'UX', 'CPU', 'GPU', 'RAM', 'ROM', 'OS', 'GUI', 'CLI',
                    # Very short words
                    'a', 'i', 'is', 'it', 'in', 'on', 'at', 'to', 'do', 'go', 'be', 'so',
                    'no', 'yes', 'ok', 'up', 'my', 'we', 'us', 'he', 'she', 'him', 'her',
                    # Common English words that happen to have mixed case patterns
                    'iPhone', 'iPad', 'iOS', 'macOS', 'JavaScript', 'TypeScript', 'NodeJS',
                    # GMod/Lia specific common terms
                    'hook', 'net', 'util', 'player', 'entity', 'vector', 'angle', 'color',
                    'surface', 'draw', 'render', 'input', 'cam', 'gui', 'derma', 'vgui',
                    'file', 'http', 'sql', 'timer', 'concommand', 'cvar', 'sound', 'material',
                    'model', 'particle', 'effect', 'weapon', 'item', 'npc', 'vehicle',
                    # File extensions
                    'lua', 'py', 'js', 'ts', 'cpp', 'c', 'h', 'hpp', 'cs', 'java', 'php',
                    'rb', 'go', 'rs', 'swift', 'kt', 'scala', 'sh', 'bat', 'ps1', 'md',
                }
                
                if (len(matched_string) >= 4 and 
                    matched_string not in excluded_words and
                    not matched_string.isupper() and 
                    not matched_string.islower() and
                    not matched_string.istitle() and
                    # Check if it actually has mixed case (both upper and lower)
                    any(c.isupper() for c in matched_string) and 
                    any(c.islower() for c in matched_string)):
                    
                    results.append((line_num, matched_string, column_pos))
    
    # Remove duplicates and sort
    results = list(set(results))
    results.sort()
    
    return results

def scan_directory(directory: str) -> Dict[str, List[Tuple[int, str, int]]]:
    """
    Scan a directory for Lua files and search for patterns.
    
    Args:
        directory: Directory to scan
    
    Returns:
        Dictionary mapping file paths to list of matches
    """
    results = {}
    directory_path = Path(directory)
    
    if not directory_path.exists():
        print(f"Directory {directory} does not exist")
        return results
    
    # Find all Lua files
    for file_path in directory_path.rglob("*.lua"):
        if file_path.is_file():
            matches = find_mixed_case_strings(str(file_path))
            if matches:
                results[str(file_path)] = matches
    
    return results

def write_markdown_report(results: Dict[str, List[Tuple[int, str, int]]], output_file: str):
    """
    Write results to a markdown file with only unique words.
    
    Args:
        results: Dictionary of file paths and their matches
        output_file: Path to output markdown file
    """
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# Lua Mixed Case Single-Word String Search Results\n\n")
        f.write(f"Generated on: {__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("**Search Criteria:** Single words with mixed case letters (both uppercase and lowercase) in Lua files only\n\n")
        
        total_matches = sum(len(matches) for matches in results.values())
        f.write(f"**Total files with matches:** {len(results)}\n")
        f.write(f"**Total matches found:** {total_matches}\n\n")
        
        if not results:
            f.write("No matches found.\n")
            return
        
        # Create a summary of unique words found
        all_words = set()
        for matches in results.values():
            for _, word, _ in matches:
                all_words.add(word)
        
        f.write(f"## Summary of Unique Words Found ({len(all_words)})\n\n")
        for word in sorted(all_words):
            f.write(f"- `{word}`\n")

def main():
    parser = argparse.ArgumentParser(description='Find single-word strings with mixed case patterns in Lua files')
    parser.add_argument('directory', help='Directory to search')
    parser.add_argument('-o', '--output', default='lua_mixed_case_strings_report.md', 
                       help='Output markdown file (default: lua_mixed_case_strings_report.md)')
    
    args = parser.parse_args()
    
    print(f"Scanning directory: {args.directory}")
    print(f"Output file: {args.output}")
    print(f"File type: Lua files only")
    print()
    
    results = scan_directory(args.directory)
    
    write_markdown_report(results, args.output)
    
    print(f"Report generated: {args.output}")
    print(f"Found {len(results)} Lua files with matches")
    
    # Print summary of unique words found
    all_words = set()
    for matches in results.values():
        for _, word, _ in matches:
            all_words.add(word)
    
    print(f"Total unique words found: {len(all_words)}")
    
    # Print some examples
    print("\nExample matches:")
    match_count = 0
    for file_path, matches in list(results.items())[:5]:
        print(f"\n{file_path}:")
        for line_num, matched_string, column_pos in matches[:3]:
            print(f"  Line {line_num}: {matched_string}")
            match_count += 1
            if match_count >= 15:
                break
        if match_count >= 15:
            break

if __name__ == "__main__":
    main()

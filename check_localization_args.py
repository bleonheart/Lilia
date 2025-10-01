#!/usr/bin/env python3
"""
Lilia Framework Localization Argument Checker

This script finds argument count mismatches between localization function calls
and their corresponding language strings in the Lilia gamemode.

Checks the following functions:
- L(key, args...)
- lia.lang.getLocalizedString(key, args...)
- notifyLocalized(client, key, notifType, args...)
- player:notifyLocalized(key, notifType, args...)
"""

import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Set
from collections import defaultdict


class Colors:
    """ANSI color codes for terminal output"""
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'


def count_format_specifiers(text: str) -> int:
    """
    Count the number of format specifiers in a string.
    Matches %s, %d, %f, %x, etc., but not %%
    """
    # This pattern matches format specifiers like %s, %d, %f, etc.
    # but excludes %% (escaped percent)
    pattern = r'%[^%]'
    matches = re.findall(pattern, text)
    return len(matches)


def count_arguments_properly(arg_str: str) -> int:
def parse_lua_string(content: str, start_pos: int) -> Tuple[str, int]:
    """
    Parse a Lua string starting at start_pos.
    Handles single quotes, double quotes, and multi-line strings.
    Returns (parsed_string, end_position)
    """
    if start_pos >= len(content):
        return None, start_pos
    
    quote_char = content[start_pos]
    
    # Handle single or double quoted strings
    if quote_char in ('"', "'"):
        end_pos = start_pos + 1
        result = []
        
        while end_pos < len(content):
            char = content[end_pos]
            
            if char == '\\' and end_pos + 1 < len(content):
                # Handle escape sequences
                next_char = content[end_pos + 1]
                if next_char == 'n':
                    result.append('\n')
                elif next_char == 't':
                    result.append('\t')
                elif next_char == '\\':
                    result.append('\\')
                elif next_char in ('"', "'"):
                    result.append(next_char)
                else:
                    result.append(next_char)
                end_pos += 2
            elif char == quote_char:
                return ''.join(result), end_pos + 1
            else:
                result.append(char)
                end_pos += 1
        
        return None, start_pos  # Unclosed string
    
    # Handle multi-line strings [[...]]
    elif content[start_pos:start_pos+2] == '[[':
        end_marker = content.find(']]', start_pos + 2)
        if end_marker == -1:
            return None, start_pos
        return content[start_pos+2:end_marker], end_marker + 2
    
    return None, start_pos


def parse_language_files(lang_dir: Path) -> Dict[str, int]:
    """
    Parse all language files and extract localization keys with their expected argument counts.
    Returns a dictionary mapping key -> expected_arg_count
    """
    lang_keys = {}
    
    if not lang_dir.exists():
        print(f"{Colors.RED}Error: Language directory not found: {lang_dir}{Colors.ENDC}")
        return lang_keys
    
    for lang_file in lang_dir.glob("*.lua"):
        try:
            with open(lang_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            # Parse LANGUAGE table entries
            # Pattern matches: key = "value" or key = 'value' or key = [[value]]
            pattern = r'(\w+)\s*=\s*(["\']|(\[\[))'
            
            for match in re.finditer(pattern, content):
                key = match.group(1)
                start_pos = match.end() - 1  # Position of the quote or bracket
                
                value, _ = parse_lua_string(content, start_pos)
                if value:
                    arg_count = count_format_specifiers(value)
                    if key not in lang_keys:
                        lang_keys[key] = arg_count
                    # If key exists with different count, keep the higher count
                    # (some languages might have different argument counts)
                    elif lang_keys[key] != arg_count:
                        lang_keys[key] = max(lang_keys[key], arg_count)
        
        except Exception as e:
            print(f"{Colors.YELLOW}Warning: Error parsing {lang_file}: {e}{Colors.ENDC}")
    
    return lang_keys


def find_function_calls(content: str, filename: str, lang_keys: Dict[str, int]) -> List[Dict]:
    """
    Find all localization function calls and check for argument mismatches.
    Returns a list of issues found.
    """
    issues = []
    lines = content.split('\n')
    
    # Pattern for L("key", args...)
    l_pattern = r'\bL\s*\(\s*(["\']|(\[\[))'
    
    for match in re.finditer(l_pattern, content):
        start_pos = match.end() - 1
        key, end_pos = parse_lua_string(content, start_pos)
        
        if not key:
            continue
        
        # Count arguments after the key
        # Find the closing parenthesis of the function call
        paren_depth = 1
        current_pos = end_pos
        arg_content = []
        
        while current_pos < len(content) and paren_depth > 0:
            char = content[current_pos]
            if char == '(':
                paren_depth += 1
            elif char == ')':
                paren_depth -= 1
                if paren_depth == 0:
                    break
            arg_content.append(char)
            current_pos += 1
        
        # Count commas to determine argument count (rough approximation)
        arg_str = ''.join(arg_content).strip()
        if arg_str and arg_str.strip(','):
            # Split by commas, but need to be careful with nested function calls
            # For now, simple count of commas
            arg_count = len([c for c in arg_str if c == ',']) + 1 if arg_str.strip(',') else 0
        else:
            arg_count = 0
        
        # Check if key exists and if argument count matches
        if key in lang_keys:
            expected = lang_keys[key]
            if arg_count != expected:
                line_num = content[:match.start()].count('\n') + 1
                issues.append({
                    'file': filename,
                    'line': line_num,
                    'function': 'L',
                    'key': key,
                    'expected': expected,
                    'provided': arg_count,
                    'context': lines[line_num - 1].strip() if line_num <= len(lines) else ''
                })
        else:
            # Key not found in language files
            line_num = content[:match.start()].count('\n') + 1
            issues.append({
                'file': filename,
                'line': line_num,
                'function': 'L',
                'key': key,
                'expected': '?',
                'provided': arg_count,
                'context': lines[line_num - 1].strip() if line_num <= len(lines) else '',
                'missing_key': True
            })
    
    # Pattern for lia.lang.getLocalizedString("key", args...)
    gls_pattern = r'\blia\.lang\.getLocalizedString\s*\(\s*(["\']|(\[\[))'
    
    for match in re.finditer(gls_pattern, content):
        start_pos = match.end() - 1
        key, end_pos = parse_lua_string(content, start_pos)
        
        if not key:
            continue
        
        # Count arguments (same logic as L function)
        paren_depth = 1
        current_pos = end_pos
        arg_content = []
        
        while current_pos < len(content) and paren_depth > 0:
            char = content[current_pos]
            if char == '(':
                paren_depth += 1
            elif char == ')':
                paren_depth -= 1
                if paren_depth == 0:
                    break
            arg_content.append(char)
            current_pos += 1
        
        arg_str = ''.join(arg_content).strip()
        if arg_str and arg_str.strip(','):
            arg_count = len([c for c in arg_str if c == ',']) + 1 if arg_str.strip(',') else 0
        else:
            arg_count = 0
        
        if key in lang_keys:
            expected = lang_keys[key]
            if arg_count != expected:
                line_num = content[:match.start()].count('\n') + 1
                issues.append({
                    'file': filename,
                    'line': line_num,
                    'function': 'lia.lang.getLocalizedString',
                    'key': key,
                    'expected': expected,
                    'provided': arg_count,
                    'context': lines[line_num - 1].strip() if line_num <= len(lines) else ''
                })
        else:
            line_num = content[:match.start()].count('\n') + 1
            issues.append({
                'file': filename,
                'line': line_num,
                'function': 'lia.lang.getLocalizedString',
                'key': key,
                'expected': '?',
                'provided': arg_count,
                'context': lines[line_num - 1].strip() if line_num <= len(lines) else '',
                'missing_key': True
            })
    
    # Pattern for notifyLocalized (standalone or method call)
    # notifyLocalized(client, key, notifType, args...)
    # player:notifyLocalized(key, notifType, args...)
    notify_pattern = r'\bnotifyLocalized\s*\(\s*([^,\)]+)\s*,\s*(["\']|(\[\[))'
    
    for match in re.finditer(notify_pattern, content):
        # The second argument is the key
        start_pos = match.end() - 1
        key, end_pos = parse_lua_string(content, start_pos)
        
        if not key:
            continue
        
        # Count arguments after key and notifType (skip first 2 commas)
        paren_depth = 1
        current_pos = end_pos
        arg_content = []
        commas_seen = 0
        
        while current_pos < len(content) and paren_depth > 0:
            char = content[current_pos]
            if char == '(':
                paren_depth += 1
            elif char == ')':
                paren_depth -= 1
                if paren_depth == 0:
                    break
            elif char == ',' and paren_depth == 1:
                commas_seen += 1
                if commas_seen > 1:  # After notifType
                    arg_content.append(char)
                current_pos += 1
                continue
            
            if commas_seen > 1:
                arg_content.append(char)
            current_pos += 1
        
        arg_str = ''.join(arg_content).strip()
        if arg_str and arg_str.strip(','):
            arg_count = len([c for c in arg_str if c == ',']) + 1 if arg_str.strip(',') else 0
        else:
            arg_count = 0
        
        if key in lang_keys:
            expected = lang_keys[key]
            if arg_count != expected:
                line_num = content[:match.start()].count('\n') + 1
                issues.append({
                    'file': filename,
                    'line': line_num,
                    'function': 'notifyLocalized',
                    'key': key,
                    'expected': expected,
                    'provided': arg_count,
                    'context': lines[line_num - 1].strip() if line_num <= len(lines) else ''
                })
        else:
            line_num = content[:match.start()].count('\n') + 1
            issues.append({
                'file': filename,
                'line': line_num,
                'function': 'notifyLocalized',
                'key': key,
                'expected': '?',
                'provided': arg_count,
                'context': lines[line_num - 1].strip() if line_num <= len(lines) else '',
                'missing_key': True
            })
    
    # Pattern for :notifyLocalized(key, notifType, args...)
    method_notify_pattern = r':notifyLocalized\s*\(\s*(["\']|(\[\[))'
    
    for match in re.finditer(method_notify_pattern, content):
        start_pos = match.end() - 1
        key, end_pos = parse_lua_string(content, start_pos)
        
        if not key:
            continue
        
        # Count arguments after key and notifType
        paren_depth = 1
        current_pos = end_pos
        arg_content = []
        commas_seen = 0
        
        while current_pos < len(content) and paren_depth > 0:
            char = content[current_pos]
            if char == '(':
                paren_depth += 1
            elif char == ')':
                paren_depth -= 1
                if paren_depth == 0:
                    break
            elif char == ',' and paren_depth == 1:
                commas_seen += 1
                if commas_seen > 0:  # After notifType (only 1 comma before args in method call)
                    arg_content.append(char)
                current_pos += 1
                continue
            
            if commas_seen > 0:
                arg_content.append(char)
            current_pos += 1
        
        arg_str = ''.join(arg_content).strip()
        if arg_str and arg_str.strip(','):
            arg_count = len([c for c in arg_str if c == ',']) + 1 if arg_str.strip(',') else 0
        else:
            arg_count = 0
        
        if key in lang_keys:
            expected = lang_keys[key]
            if arg_count != expected:
                line_num = content[:match.start()].count('\n') + 1
                issues.append({
                    'file': filename,
                    'line': line_num,
                    'function': ':notifyLocalized',
                    'key': key,
                    'expected': expected,
                    'provided': arg_count,
                    'context': lines[line_num - 1].strip() if line_num <= len(lines) else ''
                })
        else:
            line_num = content[:match.start()].count('\n') + 1
            issues.append({
                'file': filename,
                'line': line_num,
                'function': ':notifyLocalized',
                'key': key,
                'expected': '?',
                'provided': arg_count,
                'context': lines[line_num - 1].strip() if line_num <= len(lines) else '',
                'missing_key': True
            })
    
    return issues


def scan_lua_files(root_dir: Path, lang_keys: Dict[str, int]) -> List[Dict]:
    """
    Recursively scan all Lua files in the gamemode directory for localization calls.
    """
    all_issues = []
    lua_files = list(root_dir.rglob("*.lua"))
    
    print(f"{Colors.CYAN}Scanning {len(lua_files)} Lua files...{Colors.ENDC}")
    
    for lua_file in lua_files:
        # Skip language files themselves
        if 'languages' in lua_file.parts:
            continue
        
        try:
            with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            # Skip empty files or files with only comments
            if not content.strip():
                continue
            
            issues = find_function_calls(content, str(lua_file.relative_to(root_dir)), lang_keys)
            all_issues.extend(issues)
        
        except Exception as e:
            print(f"{Colors.YELLOW}Warning: Error scanning {lua_file}: {e}{Colors.ENDC}")
    
    return all_issues


def print_report(issues: List[Dict], lang_keys: Dict[str, int]):
    """
    Print a formatted report of all issues found.
    """
    if not issues:
        print(f"\n{Colors.GREEN}{Colors.BOLD}✓ No argument count mismatches found!{Colors.ENDC}")
        return
    
    # Separate missing keys from mismatches
    missing_keys = [issue for issue in issues if issue.get('missing_key', False)]
    mismatches = [issue for issue in issues if not issue.get('missing_key', False)]
    
    print(f"\n{Colors.BOLD}{'='*80}{Colors.ENDC}")
    print(f"{Colors.BOLD}{Colors.RED}Localization Argument Check Report{Colors.ENDC}")
    print(f"{Colors.BOLD}{'='*80}{Colors.ENDC}\n")
    
    print(f"Total language keys: {Colors.CYAN}{len(lang_keys)}{Colors.ENDC}")
    print(f"Total issues found: {Colors.RED}{len(issues)}{Colors.ENDC}")
    print(f"  - Argument mismatches: {Colors.YELLOW}{len(mismatches)}{Colors.ENDC}")
    print(f"  - Missing keys: {Colors.RED}{len(missing_keys)}{Colors.ENDC}\n")
    
    if mismatches:
        print(f"{Colors.BOLD}{Colors.YELLOW}Argument Count Mismatches:{Colors.ENDC}\n")
        
        for issue in sorted(mismatches, key=lambda x: (x['file'], x['line'])):
            print(f"{Colors.BOLD}{issue['file']}:{issue['line']}{Colors.ENDC}")
            print(f"  Function: {Colors.CYAN}{issue['function']}{Colors.ENDC}")
            print(f"  Key: {Colors.BLUE}'{issue['key']}'{Colors.ENDC}")
            print(f"  Expected: {Colors.GREEN}{issue['expected']} args{Colors.ENDC}")
            print(f"  Provided: {Colors.RED}{issue['provided']} args{Colors.ENDC}")
            print(f"  Context: {issue['context'][:100]}...")
            print()
    
    if missing_keys:
        print(f"{Colors.BOLD}{Colors.RED}Missing Localization Keys:{Colors.ENDC}\n")
        
        # Group by key
        key_locations = defaultdict(list)
        for issue in missing_keys:
            key_locations[issue['key']].append((issue['file'], issue['line'], issue['function']))
        
        for key, locations in sorted(key_locations.items()):
            print(f"{Colors.BOLD}Key: {Colors.BLUE}'{key}'{Colors.ENDC}")
            print(f"  Used in {len(locations)} location(s):")
            for file, line, func in locations[:5]:  # Show first 5 locations
                print(f"    - {file}:{line} ({Colors.CYAN}{func}{Colors.ENDC})")
            if len(locations) > 5:
                print(f"    ... and {len(locations) - 5} more locations")
            print()


def main():
    """Main entry point of the script."""
    print(f"{Colors.BOLD}{Colors.HEADER}Lilia Localization Argument Checker{Colors.ENDC}\n")
    
    # Determine script location and gamemode root
    script_dir = Path(__file__).parent
    gamemode_dir = script_dir / "gamemode"
    
    # Allow command line override
    if len(sys.argv) > 1:
        gamemode_dir = Path(sys.argv[1])
    
    if not gamemode_dir.exists():
        print(f"{Colors.RED}Error: Gamemode directory not found: {gamemode_dir}{Colors.ENDC}")
        print(f"Usage: {sys.argv[0]} [gamemode_directory]")
        sys.exit(1)
    
    lang_dir = gamemode_dir / "languages"
    
    print(f"Gamemode directory: {Colors.CYAN}{gamemode_dir}{Colors.ENDC}")
    print(f"Language directory: {Colors.CYAN}{lang_dir}{Colors.ENDC}\n")
    
    # Parse language files
    print(f"{Colors.CYAN}Parsing language files...{Colors.ENDC}")
    lang_keys = parse_language_files(lang_dir)
    print(f"{Colors.GREEN}Found {len(lang_keys)} localization keys{Colors.ENDC}\n")
    
    # Scan Lua files
    issues = scan_lua_files(gamemode_dir, lang_keys)
    
    # Print report
    print_report(issues, lang_keys)
    
    # Exit with error code if issues found
    if issues:
        sys.exit(1)
    else:
        sys.exit(0)


if __name__ == "__main__":
    main()


#!/usr/bin/env python3
"""
String Extractor for Lilia Gamemode
Extracts all strings from Lua files and outputs them in JSON format
"""

import os
import re
import json
import argparse
from pathlib import Path
from typing import Dict, List, Set, Tuple

class StringExtractor:
    def __init__(self, gamemode_path: str):
        self.gamemode_path = Path(gamemode_path)
        self.extracted_strings = {}
        self.string_patterns = [
            # Single quoted strings (handles escaped quotes)
            r"'([^'\\]*(?:\\.[^'\\]*)*)'",
            # Double quoted strings (handles escaped quotes)
            r'"([^"\\]*(?:\\.[^"\\]*)*)"',
            # Long strings [[...]] (non-greedy)
            r'\[\[(.*?)\]\]',
            # Long strings [=[...]=] (handles multiple equals)
            r'\[=+\[(.*?)\]=+\]'
        ]
        
    def extract_strings_from_file(self, file_path: Path) -> List[Tuple[str, int, str]]:
        """Extract all strings from a single Lua file"""
        strings = []
        
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                lines = content.split('\n')
                
                for line_num, line in enumerate(lines, 1):
                    # Skip comments and empty lines
                    if not line or line.strip().startswith('--'):
                        continue
                        
                    # Find all string patterns in the line
                    for pattern in self.string_patterns:
                        matches = re.finditer(pattern, line, re.DOTALL)
                        for match in matches:
                            # For patterns with groups, use the group content
                            # For patterns without groups, use the full match
                            if match.groups():
                                string_content = match.group(1)
                            else:
                                string_content = match.group(0)
                            
                            # Clean up the string content - remove quotes if present
                            if string_content and string_content.startswith("'") and string_content.endswith("'"):
                                string_content = string_content[1:-1]
                            elif string_content and string_content.startswith('"') and string_content.endswith('"'):
                                string_content = string_content[1:-1]
                            
                            # Skip empty strings and very short strings (likely code)
                            if string_content and len(string_content.strip()) > 2:
                                # Skip strings that look like code patterns
                                if not self.is_code_pattern(string_content):
                                    strings.append((string_content, line_num, line.strip()))
                                    
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
            
        return strings
    
    def is_code_pattern(self, string: str) -> bool:
        """Check if a string looks like code rather than user-facing text"""
        if not string or len(string.strip()) < 3:
            return True
            
        string = string.strip()
        
        # Very strict filtering - only exclude obvious code patterns
        code_indicators = [
            # File paths and extensions
            r'\.lua$', r'\.md$', r'\.txt$', r'\.json$', r'\.png$', r'\.jpg$', r'\.jpeg$',
            # Function calls and variables (but not if they contain spaces)
            r'^[a-zA-Z_][a-zA-Z0-9_]*\([^)]*\)$',
            r'^[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z0-9_]+$',
            # HTML/CSS patterns
            r'<[^>]+>',
            r'#[0-9a-fA-F]{3,6}',
            # SQL patterns
            r'^(SELECT|INSERT|UPDATE|DELETE|FROM|WHERE|ALTER|CREATE|DROP)\s',
            # Lua keywords
            r'^(function|local|return|if|then|else|end|for|while|do|true|false|nil)$',
            # Pure numbers
            r'^\d+$', r'^\d+\.\d+$',
            # Color/Vector constructors
            r'^Color\(', r'^Vector\(', r'^Angle\(',
            # File system paths
            r'^[a-zA-Z]:\\', r'^/', r'^\.\.?/',
            # URLs
            r'^https?://', r'^ftp://', r'^steam://',
            # Base64 encoded data (very long strings)
            r'^[A-Za-z0-9+/]{50,}={0,2}$',
            # Very short variable names (1-2 chars)
            r'^[a-z_]{1,2}$',
            # Technical identifiers (all caps with underscores)
            r'^[A-Z_][A-Z0-9_]*$'
        ]
        
        for pattern in code_indicators:
            if re.search(pattern, string, re.IGNORECASE):
                return True
        return False
    
    def should_include_string(self, string: str) -> bool:
        """Determine if a string should be included in the output"""
        # Skip very short strings
        if len(string.strip()) < 3:
            return False
            
        # Skip strings that are mostly whitespace
        if len(string.strip()) < len(string) * 0.5:
            return False
            
        # Skip strings that look like code
        if self.is_code_pattern(string):
            return False
            
        # Skip strings that are just numbers
        if string.strip().isdigit():
            return False
            
        return True
    
    def extract_all_strings(self) -> Dict[str, List[Dict]]:
        """Extract strings from all Lua files in the gamemode (excluding languages)"""
        all_strings = {}
        
        # Find all Lua files, excluding the languages directory
        lua_files = []
        for file_path in self.gamemode_path.rglob("*.lua"):
            relative_path = file_path.relative_to(self.gamemode_path)
            # Skip files in the languages directory
            if not str(relative_path).startswith("languages"):
                lua_files.append(file_path)
        
        print(f"Found {len(lua_files)} Lua files to process (excluding languages)...")
        
        for file_path in lua_files:
            relative_path = file_path.relative_to(self.gamemode_path)
            print(f"Processing: {relative_path}")
            
            strings = self.extract_strings_from_file(file_path)
            file_strings = []
            
            for string_content, line_num, context in strings:
                if self.should_include_string(string_content):
                    file_strings.append({
                        "string": string_content,
                        "line": line_num,
                        "context": context[:100] + "..." if len(context) > 100 else context
                    })
            
            if file_strings:
                all_strings[str(relative_path)] = file_strings
        
        return all_strings
    
    def generate_lua_output(self, strings_data: Dict[str, List[Dict]]) -> str:
        """Generate Lua output with just the unique strings"""
        # Create a set to store unique strings
        unique_strings = set()
        for file_path, strings in strings_data.items():
            for string_info in strings:
                unique_strings.add(string_info["string"])
        
        # Convert set to sorted list for consistent output
        all_strings = sorted(list(unique_strings))
        
        # Generate Lua table format
        lua_output = "local extracted_strings = {\n"
        for i, string in enumerate(all_strings):
            # Escape quotes and backslashes for Lua
            escaped_string = string.replace("\\", "\\\\").replace('"', '\\"')
            lua_output += f'    "{escaped_string}"'
            if i < len(all_strings) - 1:
                lua_output += ","
            lua_output += "\n"
        lua_output += "}\n\nreturn extracted_strings"
        
        return lua_output
    
    def run(self, output_file: str = "extracted_strings.lua"):
        """Main extraction process"""
        print("Starting string extraction from gamemode directory...")
        
        strings_data = self.extract_all_strings()
        lua_output = self.generate_lua_output(strings_data)
        
        # Write to file
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(lua_output)
        
        total_strings = sum(len(strings) for strings in strings_data.values())
        print(f"\nExtraction complete!")
        print(f"Found {total_strings} strings in gamemode directory")
        print(f"Output saved to: {output_file}")

def main():
    parser = argparse.ArgumentParser(description="Extract strings from Lilia gamemode")
    parser.add_argument("--path", "-p", default="gamemode", 
                       help="Path to gamemode directory (default: gamemode)")
    parser.add_argument("--output", "-o", default="extracted_strings.lua",
                       help="Output Lua file (default: extracted_strings.lua)")
    
    args = parser.parse_args()
    
    if not os.path.exists(args.path):
        print(f"Error: Path '{args.path}' does not exist")
        return 1
    
    extractor = StringExtractor(args.path)
    extractor.run(args.output)
    return 0

if __name__ == "__main__":
    exit(main())

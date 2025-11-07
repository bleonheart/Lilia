
#!/usr/bin/env python3
import os
import sys
import json
import re
import argparse
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Set, Tuple, Optional
from dataclasses import dataclass
from collections import defaultdict

# Dynamic paths based on file location
def _get_paths_from_file_location():
    """Determine paths based on the current file's location"""
    current_file = Path(__file__).resolve()
    file_path_str = str(current_file)

    # Check if file is in the E:\Server\garrysmod\gamemodes\Lilia\ structure
    if r"E:\Server\garrysmod\gamemodes\Lilia\documentation\docs\tools" in file_path_str:
        # File is in E:\Server\garrysmod\gamemodes\Lilia\documentation\docs\tools\
        lilia_root = Path(r"E:\Server\garrysmod\gamemodes\Lilia")
        gamemode_root = lilia_root / "gamemode"
        docs_root = lilia_root / "documentation"
        language_file = gamemode_root / "languages" / "english.lua"
        # Derive metrorp path relative to lilia_root
        metrorp_root = lilia_root.parent / "metrorp"
        modules_paths = [
            metrorp_root / "gitmodules",
            metrorp_root / "modules",
            # Note: devmodules doesn't exist in the actual directory structure
            # metrorp_root / "devmodules",
        ]
        output_dir = docs_root

    # Check if file is in the E:\Server\garrysmod\gamemodes\Lilia\ structure (legacy support)
    elif r"E:\Server\garrysmod\gamemodes\Lilia\documentation\docs\tools" in file_path_str:
        # File is in E:\Server\garrysmod\gamemodes\Lilia\documentation\docs\tools\
        lilia_root = Path(r"E:\Server\garrysmod\gamemodes\Lilia")
        gamemode_root = lilia_root / "gamemode"
        docs_root = lilia_root / "documentation"
        language_file = gamemode_root / "languages" / "english.lua"
        # Derive metrorp path relative to lilia_root
        metrorp_root = lilia_root.parent / "metrorp"
        modules_paths = [
            metrorp_root / "gitmodules",
            metrorp_root / "modules",
            # Note: devmodules doesn't exist in the actual directory structure
            # metrorp_root / "devmodules",
        ]
        output_dir = docs_root

    # Check if file is in the D:\Lilia\ structure
    elif r"D:\Lilia\documentation\docs\tools" in file_path_str:
        # File is in D:\Lilia\documentation\docs\tools\
        lilia_root = Path(r"D:\Lilia")
        gamemode_root = lilia_root / "gamemode"
        docs_root = lilia_root / "documentation"
        language_file = gamemode_root / "languages" / "english.lua"
        # For D:\ drive, we can't derive metrorp path, so use E:\Server as fallback
        modules_paths = [
            Path(r"E:\Server\garrysmod\gamemodes\metrorp\gitmodules"),
            Path(r"E:\Server\garrysmod\gamemodes\metrorp\modules"),
        ]
        output_dir = docs_root

    else:
        # Fallback for other locations - try to derive from current file location
        current_dir = current_file.parent

        # Go up the directory tree to find the Lilia root (assuming standard structure)
        lilia_root = None
        check_dir = current_dir

        # Look for gamemode directory by going up the tree
        for _ in range(6):  # Reasonable depth limit
            if (check_dir / "gamemode").exists() and (check_dir / "documentation").exists():
                lilia_root = check_dir
                break
            check_dir = check_dir.parent

        if lilia_root:
            gamemode_root = lilia_root / "gamemode"
            docs_root = lilia_root / "documentation"
            language_file = gamemode_root / "languages" / "english.lua"
            # Derive metrorp path relative to lilia_root
            metrorp_root = lilia_root.parent / "metrorp"
            modules_paths = [
                metrorp_root / "gitmodules",
                metrorp_root / "modules",
                # Note: devmodules doesn't exist in the actual directory structure
                # metrorp_root / "devmodules",
            ]
            output_dir = docs_root
        else:
            # Ultimate fallback - use hardcoded defaults
            print("Warning: Could not determine Lilia root from file location, using hardcoded defaults")
            gamemode_root = Path(r"E:\Server\garrysmod\gamemodes\Lilia\gamemode")
            docs_root = Path(r"E:\Server\garrysmod\gamemodes\Lilia\documentation")
            language_file = Path(r"E:\Server\garrysmod\gamemodes\Lilia\gamemode\languages\english.lua")
            # Derive metrorp path relative to lilia_root
            lilia_root = Path(r"E:\Server\garrysmod\gamemodes\Lilia")
            metrorp_root = lilia_root.parent / "metrorp"
            modules_paths = [
                metrorp_root / "gitmodules",
                metrorp_root / "modules",
                # Note: devmodules doesn't exist in the actual directory structure
                # metrorp_root / "devmodules",
            ]
            output_dir = docs_root

    return {
        'gamemode_root': gamemode_root,
        'docs_root': docs_root,
        'language_file': language_file,
        'modules_paths': modules_paths,
        'output_dir': output_dir
    }

# Get paths based on file location
_paths = _get_paths_from_file_location()

DEFAULT_GAMEMODE_ROOT = _paths['gamemode_root']
DEFAULT_DOCS_ROOT = _paths['docs_root']
DEFAULT_LANGUAGE_FILE = _paths['language_file']
# Ensure correct path for E:\Server structure
if str(DEFAULT_LANGUAGE_FILE).startswith(r'E:\Server'):
    DEFAULT_LANGUAGE_FILE = Path(r"E:\Server\garrysmod\gamemodes\Lilia\gamemode\languages\english.lua")
DEFAULT_MODULES_PATHS = _paths['modules_paths']
DEFAULT_OUTPUT_DIR = _paths['output_dir']

# Debug output (only in non-quiet mode)
import sys
_is_quiet = '--quiet' in sys.argv or '-q' in sys.argv
if not _is_quiet:
    print("Detected file location and using the following paths:")
    print(f"  Gamemode root: {DEFAULT_GAMEMODE_ROOT}")
    print(f"  Documentation root: {DEFAULT_DOCS_ROOT}")
    print(f"  Language file: {DEFAULT_LANGUAGE_FILE}")
    print(f"  Output directory: {DEFAULT_OUTPUT_DIR}")
    print(f"  Modules paths: {len(DEFAULT_MODULES_PATHS)} paths")
    for i, path in enumerate(DEFAULT_MODULES_PATHS, 1):
        print(f"    {i}. {path}")
    print()

# Import from existing files
import os

# Add current directory to path for imports
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)

try:
    from compare_functions import FunctionComparator, LuaFunctionExtractor, DocumentationParser
    from missinghooks import scan_hooks, read_documented_hooks, GMOD_HOOKS_BLACKLIST, FRAMEWORK_HOOKS_WHITELIST
    from localization_analysis_report import (
        analyze_data, write_framework_md, write_framework_txt,
        write_modules_md, write_modules_txt, DEFAULT_FRAMEWORK_GAMEMODE_DIR,
        DEFAULT_LANGUAGE_FILE, DEFAULT_MODULES_PATHS
    )
except ImportError as e:
    print(f"Error importing required modules: {e}")
    print("Make sure compare_functions.py, missinghooks.py, and localization_analysis_report.py exist in the same directory")
    sys.exit(1)

# Functions that should NOT be checked during documentation analysis
# These are typically internal functions, callbacks, or auto-generated code
FUNCTIONS_NOT_TO_CHECK = {
    # Derma/UI related functions that are internal callbacks
    "lia.derma.menuPlayerSelector.btn_close.DoClick",

    # Add other functions here as needed
    # Examples:
    # "internal.helperFunction",
    # "autoGenerated.callback",
}

# Functions that should be checked (explicit allowlist)
# If a function is not in this list and not in FUNCTIONS_NOT_TO_CHECK,
# it will be flagged for documentation review
FUNCTIONS_TO_CHECK = {
    # Core framework functions that need documentation
    "lia.util.*",
    "lia.config.*",
    "lia.database.*",

    # Add other patterns here as needed
}

def should_check_function(function_name):
    """
    Determine if a function should be checked for documentation.

    Args:
        function_name (str): The name of the function to check

    Returns:
        bool: True if the function should be checked, False otherwise
    """
    # First check if it's explicitly in the "not to check" list
    if function_name in FUNCTIONS_NOT_TO_CHECK:
        return False

    # Then check if it matches any pattern in the "to check" list
    for pattern in FUNCTIONS_TO_CHECK:
        if function_name.startswith(pattern.replace("*", "")):
            return True

    # Default behavior: check the function
    return True

def get_exclusion_reason(function_name):
    """
    Get the reason why a function is excluded from checking.

    Args:
        function_name (str): The name of the function

    Returns:
        str: Reason for exclusion, or None if not excluded
    """
    if function_name in FUNCTIONS_NOT_TO_CHECK:
        return "Explicitly excluded from documentation checking"
    return None

@dataclass
class FunctionInfo:
    """Information about a function"""
    name: str
    parameters: List[str]

@dataclass
class CombinedReportData:
    """Container for all analysis results"""
    function_comparison: Dict[str, Dict]
    hooks_missing: List[str]
    hooks_documented: List[str]
    hooks_registered: List[str]  # New field for hooks registered in code
    hooks_signatures: Dict[str, List[str]]  # New field for hook -> parameter names
    localization_data: Dict
    argument_mismatches: List[Dict]  # New field for argument mismatches
    modules_data: List
    modules_scan: List[Dict]
    language_comparison: Dict[str, Dict[str, List[str]]]  # New field for language key mismatches
    panels_found: List[str]  # New field for panels found in code
    panels_documented: List[str]  # New field for documented panels
    # Categorized missing documentation
    missing_library_functions: List[FunctionInfo]
    missing_hook_functions: List[FunctionInfo]
    missing_meta_functions: List[FunctionInfo]
    generated_at: str

class FunctionComparisonReportGenerator:
    """Main class for generating comprehensive function comparison reports"""

    def __init__(self, base_path: str = None, docs_path: str = None, language_file: str = None,
                 modules_paths: List[str] = None, generate_module_docs: bool = True):
        self.base_path = Path(base_path) if base_path else DEFAULT_GAMEMODE_ROOT
        self.docs_path = Path(docs_path) if docs_path else DEFAULT_DOCS_ROOT
        self.language_file = language_file or str(DEFAULT_LANGUAGE_FILE)
        self.generate_module_docs = generate_module_docs

        # Handle modules_paths - convert to list of strings if provided
        if modules_paths:
            self.modules_paths = [str(p) for p in modules_paths]
        else:
            self.modules_paths = [str(p) for p in DEFAULT_MODULES_PATHS]

        # Initialize analyzers
        self.function_comparator = FunctionComparator(str(self.base_path))
        self.hooks_doc_dir = self.docs_path / "docs" / "hooks"

    def _detect_argument_mismatches(self) -> List[Dict]:
        """Detect argument mismatches in localization function calls"""
        mismatches = []

        # Load language keys and their expected argument counts
        lang_keys = self._get_localization_keys_with_arg_counts()

        # Scan Lua files for localization function calls
        lua_files = list(self.base_path.rglob("*.lua"))

        for lua_file in lua_files:
            # Skip language files themselves and docs directory
            if 'languages' in lua_file.parts or 'docs' in lua_file.parts:
                continue

            try:
                with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()

                # Find localization function calls and check arguments
                mismatches.extend(self._check_file_for_arg_mismatches(content, str(lua_file.relative_to(self.base_path)), lang_keys))

            except Exception as e:
                print(f"Warning: Error scanning {lua_file}: {e}")
                continue

        return mismatches

    def _scan_all_language_files(self) -> Dict[str, Set[str]]:
        """Scan all language files and extract their keys"""
        language_keys = {}
        languages_dir = self.base_path / "languages"

        if not languages_dir.exists():
            print(f"Warning: Languages directory not found: {languages_dir}")
            return language_keys

        # Find all .lua files in languages directory
        for lang_file in languages_dir.glob("*.lua"):
            lang_name = lang_file.stem  # filename without extension
            keys = self._extract_language_keys(str(lang_file))

            if keys:
                language_keys[lang_name] = keys
                print(f"Found {len(keys)} keys in {lang_name}")
            else:
                print(f"No keys found in {lang_name}")

        return language_keys

    def _extract_language_keys(self, file_path: str) -> Set[str]:
        """Extract all language keys from a single language file"""
        keys = set()

        if not Path(file_path).exists():
            return keys

        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()

            # Parse LANGUAGE table entries by processing the entire file
            # This approach is more reliable than trying to extract the table content
            in_language_table = False
            brace_depth = 0

            lines = content.split('\n')
            for line in lines:
                stripped_line = line.strip()

                # Check if we're entering or exiting the LANGUAGE table
                if stripped_line == 'LANGUAGE = {' or stripped_line == 'LANGUAGE = {':
                    in_language_table = True
                    brace_depth = 1
                    continue
                elif in_language_table:
                    # Count opening and closing braces
                    brace_depth += line.count('{')
                    brace_depth -= line.count('}')

                    # If we've closed all braces, we're done
                    if brace_depth <= 0:
                        in_language_table = False
                        break

                # If we're inside the LANGUAGE table, look for key patterns
                if in_language_table and brace_depth > 0:
                    # Pattern matches: key = "value" or key = 'value' or key = [[value]]
                    # Also handles whitespace and optional commas
                    key_pattern = r'(\w+)\s*=\s*["\'](?:[^"\'\\]|\\.)*["\']'

                    for match in re.finditer(key_pattern, line):
                        key = match.group(1)
                        if key and key != 'LANGUAGE':  # Skip the LANGUAGE key itself
                            keys.add(key)

                    # Also find multiline string keys [[...]]
                    multiline_pattern = r'(\w+)\s*=\s*\[\[([^]]*)\]\]'
                    for match in re.finditer(multiline_pattern, line, re.DOTALL):
                        key = match.group(1)
                        if key and key != 'LANGUAGE':  # Skip the LANGUAGE key itself
                            keys.add(key)

        except Exception as e:
            print(f"Warning: Error parsing language file {file_path}: {e}")

        return keys

    def _get_localization_keys_with_arg_counts(self) -> Dict[str, int]:
        """Get localization keys and count their expected format specifiers"""
        keys = {}

        if not Path(self.language_file).exists():
            return keys

        try:
            with open(self.language_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()

            # Parse LANGUAGE table entries by processing the entire file
            # This approach is more reliable than trying to extract the table content
            in_language_table = False
            brace_depth = 0

            lines = content.split('\n')
            for line in lines:
                stripped_line = line.strip()

                # Check if we're entering or exiting the LANGUAGE table
                if stripped_line == 'LANGUAGE = {' or stripped_line == 'LANGUAGE = {':
                    in_language_table = True
                    brace_depth = 1
                    continue
                elif in_language_table:
                    # Count opening and closing braces
                    brace_depth += line.count('{')
                    brace_depth -= line.count('}')

                    # If we've closed all braces, we're done
                    if brace_depth <= 0:
                        in_language_table = False
                        break

                # If we're inside the LANGUAGE table, look for key patterns
                if in_language_table and brace_depth > 0:
                    # Find key = "value" patterns and extract the value properly
                    key_value_pattern = r'(\w+)\s*=\s*["\']'
                    for match in re.finditer(key_value_pattern, line):
                        key = match.group(1)
                        if key and key != 'LANGUAGE':
                            # Extract the full quoted string value, handling escaped quotes
                            start_pos = match.end() - 1  # Position of the opening quote
                            quote_char = line[start_pos]
                            end_pos = start_pos + 1
                            while end_pos < len(line):
                                if line[end_pos] == quote_char:
                                    # Check if this quote is escaped (preceded by odd number of backslashes)
                                    escape_count = 0
                                    check_pos = end_pos - 1
                                    while check_pos >= 0 and line[check_pos] == '\\':
                                        escape_count += 1
                                        check_pos -= 1
                                    # If even number of escapes, this quote is not escaped (it's the closing quote)
                                    if escape_count % 2 == 0:
                                        break
                                end_pos += 1
                            if end_pos < len(line):
                                value = line[start_pos + 1:end_pos]
                                arg_count = self._count_format_specifiers(value)
                                keys[key] = arg_count

                    # Also find multiline strings [[...]]
                    multiline_pattern = r'(\w+)\s*=\s*\[\['
                    for match in re.finditer(multiline_pattern, line):
                        key = match.group(1)
                        if key and key != 'LANGUAGE':
                            # Extract the full multiline string value
                            start_pos = match.end()  # Position after [[
                            end_marker = ']]'
                            end_pos = line.find(end_marker, start_pos)
                            if end_pos != -1:
                                value = line[start_pos:end_pos]
                                arg_count = self._count_format_specifiers(value)
                                keys[key] = arg_count

        except Exception as e:
            print(f"Warning: Error parsing language file {self.language_file}: {e}")

        return keys

    def _parse_lua_string_simple(self, content: str, start_pos: int) -> Tuple[str, int]:
        """Simple Lua string parser for format specifiers"""
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
                    if next_char in ('n', 't', '\\', '"', "'"):
                        result.append(next_char if next_char != 'n' else '\n')
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

    def _count_format_specifiers(self, text: str) -> int:
        """Count the number of format specifiers in a string (excluding escaped %)"""
        # This pattern matches format specifiers like %s, %d, %f, etc.
        # but excludes %% (escaped percent)
        pattern = r'%[^%]'
        matches = re.findall(pattern, text)
        return len(matches)

    def _count_function_arguments(self, arg_str: str) -> int:
        """Count function arguments properly, handling nested parentheses and strings"""
        if not arg_str or arg_str == ',':
            return 0

        # Remove leading comma if present
        arg_str = arg_str.lstrip(',').strip()
        if not arg_str:
            return 0

        args = []
        current_arg = []
        paren_depth = 0
        in_string = False
        string_char = None
        escape_next = False

        i = 0
        while i < len(arg_str):
            char = arg_str[i]

            if escape_next:
                escape_next = False
                current_arg.append(char)
                i += 1
                continue

            if char == '\\' and in_string:
                escape_next = True
                current_arg.append(char)
                i += 1
                continue

            if not in_string:
                if char in ('"', "'"):
                    in_string = True
                    string_char = char
                    current_arg.append(char)
                elif char == '(':
                    paren_depth += 1
                    current_arg.append(char)
                elif char == ')':
                    paren_depth -= 1
                    current_arg.append(char)
                elif char == ',' and paren_depth == 0:
                    # Found argument separator at top level
                    args.append(''.join(current_arg).strip())
                    current_arg = []
                else:
                    current_arg.append(char)
            else:
                if char == string_char:
                    in_string = False
                    string_char = None
                current_arg.append(char)

            i += 1

        # Add the last argument
        if current_arg:
            args.append(''.join(current_arg).strip())

        return len(args)

    def _split_top_level_args(self, arg_str: str) -> List[str]:
        """Split a Lua argument list into top-level arguments, respecting strings and nested parens."""
        if not arg_str:
            return []

        args: List[str] = []
        current_arg: List[str] = []
        paren_depth = 0
        in_string = False
        string_char: Optional[str] = None
        escape_next = False

        i = 0
        while i < len(arg_str):
            char = arg_str[i]

            if escape_next:
                escape_next = False
                current_arg.append(char)
                i += 1
                continue

            if in_string:
                if char == '\\':
                    escape_next = True
                    current_arg.append(char)
                elif char == string_char:
                    in_string = False
                    string_char = None
                    current_arg.append(char)
                else:
                    current_arg.append(char)
                i += 1
                continue

            if char in ('"', "'"):
                in_string = True
                string_char = char
                current_arg.append(char)
            elif char == '(':
                paren_depth += 1
                current_arg.append(char)
            elif char == ')':
                paren_depth = max(0, paren_depth - 1)
                current_arg.append(char)
            elif char == ',' and paren_depth == 0:
                args.append(''.join(current_arg).strip())
                current_arg = []
            else:
                current_arg.append(char)

            i += 1

        if current_arg:
            args.append(''.join(current_arg).strip())

        # Drop empty entries
        return [a for a in args if a]

    def _check_file_for_arg_mismatches(self, content: str, filename: str, lang_keys: Dict[str, int]) -> List[Dict]:
        """Check a single file for argument mismatches"""
        mismatches = []
        lines = content.split('\n')

        # Define all localization patterns to check
        patterns = [
            # L("key", args...)
            (r'\bL\s*\(\s*["\']', 'L'),  # L with single/double quoted strings
            (r'\bL\s*\(\s*\[\[', 'L'),   # L with multiline strings
            # lia.lang.getLocalizedString("key", args...)
            (r'\blia\.lang\.getLocalizedString\s*\(\s*["\']', 'lia.lang.getLocalizedString'),
            (r'\blia\.lang\.getLocalizedString\s*\(\s*\[\[', 'lia.lang.getLocalizedString'),
            # :notifyLocalized("key", args...)
            (r':notifyLocalized\s*\(\s*["\']', ':notifyLocalized'),
            (r':notifyLocalized\s*\(\s*\[\[', ':notifyLocalized'),
            # :notifyErrorLocalized("key", args...)
            (r':notifyErrorLocalized\s*\(\s*["\']', ':notifyErrorLocalized'),
            (r':notifyErrorLocalized\s*\(\s*\[\[', ':notifyErrorLocalized'),
            # :notifyWarningLocalized("key", args...)
            (r':notifyWarningLocalized\s*\(\s*["\']', ':notifyWarningLocalized'),
            (r':notifyWarningLocalized\s*\(\s*\[\[', ':notifyWarningLocalized'),
            # :notifyInfoLocalized("key", args...)
            (r':notifyInfoLocalized\s*\(\s*["\']', ':notifyInfoLocalized'),
            (r':notifyInfoLocalized\s*\(\s*\[\[', ':notifyInfoLocalized'),
            # :notifySuccessLocalized("key", args...)
            (r':notifySuccessLocalized\s*\(\s*["\']', ':notifySuccessLocalized'),
            (r':notifySuccessLocalized\s*\(\s*\[\[', ':notifySuccessLocalized'),
            # :notifyMoneyLocalized("key", args...)
            (r':notifyMoneyLocalized\s*\(\s*["\']', ':notifyMoneyLocalized'),
            (r':notifyMoneyLocalized\s*\(\s*\[\[', ':notifyMoneyLocalized'),
            # :notifyAdminLocalized("key", args...)
            (r':notifyAdminLocalized\s*\(\s*["\']', ':notifyAdminLocalized'),
            (r':notifyAdminLocalized\s*\(\s*\[\[', ':notifyAdminLocalized'),
        ]

        for pattern, func_name in patterns:
            for match in re.finditer(pattern, content):
                # Extract the key from the match - start from the quote character
                start_pos = match.end() - 1
                key, end_pos = self._parse_lua_string_simple(content, start_pos)

                if not key:
                    continue

                # Find the opening parenthesis of the function call (should be before the quote)
                func_start = match.start()
                open_paren_pos = content.find('(', func_start)
                if open_paren_pos == -1:
                    continue

                # Find the matching closing parenthesis
                paren_depth = 0
                current_pos = open_paren_pos
                arg_end = open_paren_pos

                while current_pos < len(content):
                    char = content[current_pos]
                    if char == '(':
                        paren_depth += 1
                    elif char == ')':
                        paren_depth -= 1
                        if paren_depth == 0:
                            arg_end = current_pos
                            break
                    current_pos += 1

                # Extract arguments (content between opening and closing paren, excluding the parens themselves)
                if arg_end > open_paren_pos:
                    arg_content = content[open_paren_pos + 1:arg_end]
                    raw_arg_count = self._count_function_arguments(arg_content.strip())

                    # For localization functions, subtract 1 because the key itself is the first argument
                    arg_count = max(0, raw_arg_count - 1)
                else:
                    arg_count = 0

                # Check if key exists and if argument count matches
                if key in lang_keys:
                    expected = lang_keys[key]
                    if arg_count != expected:
                        line_num = content[:match.start()].count('\n') + 1
                        mismatches.append({
                            'file': filename,
                            'line': line_num,
                            'function': func_name,
                            'key': key,
                            'expected': expected,
                            'provided': arg_count,
                            'context': lines[line_num - 1].strip() if line_num <= len(lines) else ''
                        })

        return mismatches

    def _compare_language_files(self) -> Dict[str, Dict[str, List[str]]]:
        """Compare all language files to find missing keys"""
        print("Comparing language files for missing keys...")

        # Scan all language files
        language_keys = self._scan_all_language_files()

        if len(language_keys) < 2:
            print(f"Warning: Need at least 2 language files to compare, found {len(language_keys)}")
            return {}

        # Get all unique keys across all languages
        all_keys = set()
        for keys in language_keys.values():
            all_keys.update(keys)

        # Compare each language against all others
        missing_keys = {}

        for base_lang, base_keys in language_keys.items():
            missing_keys[base_lang] = {}

            for other_lang, other_keys in language_keys.items():
                if base_lang == other_lang:
                    continue

                # Find keys that base_lang is missing compared to other_lang
                missing = sorted(list(other_keys - base_keys))
                missing_keys[base_lang][other_lang] = missing

        print(f"Compared {len(language_keys)} language files, found {len(all_keys)} total unique keys")
        return missing_keys

    def run_all_analyses(self) -> CombinedReportData:
        """Run all three analyses and combine results"""

        print("Running comprehensive analysis...")
        print("=" * 60)

        # 1. Function Documentation Comparison
        print("Analyzing function documentation...")
        function_results = self._run_function_comparison()

        # 2. Missing Hooks Analysis
        print("Analyzing hooks documentation...")
        hooks_missing, hooks_documented, hooks_registered = self._run_hooks_analysis()

        # 3. Localization Analysis
        print("Analyzing localization...")
        localization_data, modules_data = self._run_localization_analysis()

        # 4. Argument Mismatch Detection
        print("Detecting argument mismatches...")
        argument_mismatches = self._detect_argument_mismatches()

        # 5. Module undocumented items scan (hooks and lia.* functions)
        modules_scan = []
        if self.generate_module_docs:
            print("Scanning external modules for undocumented items...")
            modules_scan = self._scan_modules_for_undocumented()

        # 6. Language file comparison
        print("Comparing language files...")
        language_comparison = self._compare_language_files()

        # 7. Panel Documentation Analysis
        print("Analyzing panel documentation...")
        panels_found, panels_documented = self._run_panels_analysis()

        # Categorize missing functions by type
        missing_library_functions, missing_hook_functions, missing_meta_functions = self._categorize_missing_functions(function_results)

        return CombinedReportData(
            function_comparison=function_results,
            hooks_missing=hooks_missing,
            hooks_documented=hooks_documented,
            hooks_registered=hooks_registered,
            hooks_signatures=getattr(self, 'hooks_signatures', {}),
            localization_data=localization_data,
            argument_mismatches=argument_mismatches,
            modules_data=modules_data,
            modules_scan=modules_scan,
            language_comparison=language_comparison,
            panels_found=panels_found,
            panels_documented=panels_documented,
            missing_library_functions=missing_library_functions,
            missing_hook_functions=missing_hook_functions,
            missing_meta_functions=missing_meta_functions,
            generated_at=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        )

    def _categorize_missing_functions(self, function_comparison: Dict[str, Dict]) -> Tuple[List[FunctionInfo], List[FunctionInfo], List[FunctionInfo]]:
        """Categorize missing functions into library, hook, and meta types"""
        missing_library_functions = []
        missing_hook_functions = []
        missing_meta_functions = []

        # Get documented functions from each category
        documented_libraries = self._get_documented_library_functions()
        documented_hooks = set(self.hooks_documented) if hasattr(self, 'hooks_documented') else set()
        documented_meta = self._get_documented_meta_functions()

        # Process all missing functions from function_comparison
        for file_data in function_comparison.values():
            for func_name in file_data.get('missing_functions', []):
                # Get function info including parameters
                func_info = file_data.get('functions', {}).get(func_name)
                if not func_info:
                    continue

                # Create FunctionInfo object with name and parameters
                function_info = FunctionInfo(
                    name=func_name,
                    parameters=func_info.get('parameters', [])
                )

                # Remove duplicates while preserving order
                existing_names = {f.name for f in missing_library_functions + missing_hook_functions + missing_meta_functions}
                if func_name in existing_names:
                    continue

                # Categorize based on naming patterns and existing documentation
                if func_name in documented_libraries or self._is_library_function(func_name):
                    missing_library_functions.append(function_info)
                elif func_name in documented_hooks or self._is_hook_function(func_name):
                    missing_hook_functions.append(function_info)
                elif func_name in documented_meta or self._is_meta_function(func_name):
                    missing_meta_functions.append(function_info)
                else:
                    # Default to library if we can't determine the type
                    missing_library_functions.append(function_info)

        return missing_library_functions, missing_hook_functions, missing_meta_functions

    def _format_function_signature(self, func_info: FunctionInfo) -> str:
        """Format a function signature with its actual parameters"""
        if func_info.parameters:
            param_str = ', '.join(func_info.parameters)
            return f"{func_info.name}({param_str})"
        else:
            return f"{func_info.name}()"

    def _get_documented_library_functions(self) -> Set[str]:
        """Get all documented library functions"""
        documented_functions = set()
        libs_dir = self.docs_path / "docs" / "libraries"

        if not libs_dir.exists():
            return documented_functions

        for md_file in libs_dir.glob("*.md"):
            try:
                with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                # Extract function names from headers like ### lia.util.functionName
                for match in re.finditer(r'^###+\s+([A-Za-z_][\w\.:]*)\s*$', content, re.MULTILINE):
                    func_name = match.group(1).strip()
                    documented_functions.add(func_name)
            except Exception:
                continue

        return documented_functions

    def _get_documented_meta_functions(self) -> Set[str]:
        """Get all documented meta functions"""
        documented_functions = set()
        meta_dir = self.docs_path / "docs" / "meta"

        if not meta_dir.exists():
            return documented_functions

        for md_file in meta_dir.glob("*.md"):
            try:
                with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                # Extract method names from code patterns like `methodName(...)`
                for match in re.finditer(r'`([A-Za-z_][\w\.:]*)\([^)]*\)`', content):
                    method_name = match.group(1).strip()
                    documented_functions.add(method_name)
            except Exception:
                continue

        return documented_functions

    def _is_library_function(self, func_name: str) -> bool:
        """Check if a function name indicates it's a library function"""
        # Library functions typically start with lia. and have dotted paths
        return func_name.startswith('lia.') and func_name.count('.') >= 1

    def _is_hook_function(self, func_name: str) -> bool:
        """Check if a function name indicates it's a hook function"""
        # Hook functions are typically just the hook name (no dots)
        # and are used with hook.Add/hook.Run
        return '.' not in func_name and len(func_name) > 0

    def _is_meta_function(self, func_name: str) -> bool:
        """Check if a function name indicates it's a meta function"""
        # Meta functions are typically methods on entities/players/panels
        # They might be prefixed with the type name
        meta_patterns = [
            r'^[A-Za-z_][a-z_]*\.[A-Za-z_]',  # Like Entity.GetPos, Player.SetName
            r'^[A-Z][a-zA-Z]*\.[A-Z][a-zA-Z]*',  # Like Panel.SetVisible, Vector.Normalize
        ]
        return any(re.match(pattern, func_name) for pattern in meta_patterns)

    def _run_function_comparison(self) -> Dict[str, Dict]:
        """Run function documentation comparison analysis"""
        try:
            return self.function_comparator.compare_functions()
        except Exception as e:
            print(f"Error in function comparison: {e}")
            return {}

    def _run_hooks_analysis(self) -> Tuple[List[str], List[str], List[str]]:
        """Run hooks documentation analysis"""
        try:
            hooks_registered, hooks_signatures = self._scan_hook_registrations_with_signatures()
            self.hooks_signatures = hooks_signatures
            hooks_documented = self._read_all_documented_hooks()
            hooks_missing = [h for h in hooks_registered if h not in hooks_documented]
            return sorted(hooks_missing), sorted(list(hooks_documented)), hooks_registered
        except Exception as e:
            print(f"Error in hooks analysis: {e}")
            return [], [], []

    def _read_all_documented_hooks(self) -> Set[str]:
        """Read documented hooks from all hooks documentation files"""
        documented_hooks = set()
        
        if not self.hooks_doc_dir.exists():
            print(f"Warning: Hooks documentation directory not found: {self.hooks_doc_dir}")
            return documented_hooks
        
        # Read from all .md files in the hooks directory
        for md_file in self.hooks_doc_dir.glob("*.md"):
            try:
                file_hooks = read_documented_hooks(str(md_file))
                documented_hooks.update(file_hooks)
            except Exception as e:
                print(f"Warning: Could not read hooks from {md_file}: {e}")
                continue
        
        return documented_hooks

    def _remove_lua_comments(self, content: str) -> str:
        """Remove Lua comments from content to avoid detecting commented-out code.

        Handles:
        - Single line comments: -- comment
        - Multi-line comments: --[[ comment ]]
        - Long string comments: --[=[ comment ]=]
        """
        # First, handle long string comments (--[=[...]=], --[[...]], etc.)
        # Pattern matches --[ followed by optional = signs, then content until matching ]=]
        long_comment_pattern = r'--\[(=*)\[.*?\]\1\]'
        content = re.sub(long_comment_pattern, '', content, flags=re.DOTALL)

        # Handle single-line comments (-- comment)
        # Split into lines, remove comments from each line
        lines = content.split('\n')
        processed_lines = []

        for line in lines:
            # Find the first -- that's not inside a string
            in_string = False
            string_char = None
            comment_start = -1

            i = 0
            while i < len(line):
                char = line[i]

                if not in_string:
                    if char in ('"', "'"):
                        in_string = True
                        string_char = char
                    elif char == '-' and i + 1 < len(line) and line[i + 1] == '-':
                        # Found --, this starts a comment
                        comment_start = i
                        break
                else:
                    if char == string_char:
                        # Check if this quote is escaped
                        escape_count = 0
                        check_pos = i - 1
                        while check_pos >= 0 and line[check_pos] == '\\':
                            escape_count += 1
                            check_pos -= 1
                        if escape_count % 2 == 0:  # Not escaped
                            in_string = False
                            string_char = None

                i += 1

            if comment_start != -1:
                # Remove everything from -- to end of line
                line = line[:comment_start]

            processed_lines.append(line)

        return '\n'.join(processed_lines)

    def _scan_hook_registrations_with_signatures(self) -> Tuple[List[str], Dict[str, List[str]]]:
        """Scan Lua files for hooks and attempt to capture their parameter names.

        Returns (registered_hooks_sorted, hook_signatures_map)
        """
        registered_hooks: Set[str] = set()
        hook_signatures: Dict[str, List[str]] = {}

        # Scan gamemode files
        lua_files = list(self.base_path.rglob("*.lua"))

        for lua_file in lua_files:
            # Skip certain directories
            if any(skip in str(lua_file) for skip in ['languages', 'documentation', 'docs']):
                continue

            try:
                with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()

                # Remove comments from content before processing
                content = self._remove_lua_comments(content)

                # Names only
                file_hooks = self._extract_hooks_from_file_content(content)
                registered_hooks.update(file_hooks)

                # Signatures
                file_signatures = self._extract_hook_signatures_from_file_content(content)
                for hook_name, params in file_signatures.items():
                    existing = hook_signatures.get(hook_name)
                    if not existing or (len(params) > len(existing)):
                        hook_signatures[hook_name] = params

            except Exception as e:
                print(f"Warning: Error scanning {lua_file}: {e}")
                continue

        return sorted(list(registered_hooks)), hook_signatures

    def _extract_hooks_from_file_content(self, content: str) -> Set[str]:
        """Extract hooks from file content using all patterns"""
        hooks = set()

        # Pattern for hook.Add calls
        # Matches: hook.Add("hook_name", ...)
        hook_add_pattern = r'hook\.Add\s*\(\s*([\'"`])([^\'"`]+)\1'

        # Pattern for hook.Run calls
        # Matches: hook.Run("hook_name", ...)
        hook_run_pattern = r'hook\.Run\s*\(\s*([\'"`])([^\'"`]+)\1'

        # Pattern for hook.Call calls
        # Matches: hook.Call("hook_name", ...)
        hook_call_pattern = r'hook\.Call\s*\(\s*([\'"`])([^\'"`]+)\1'

        # Pattern for GM:HookName function definitions
        # Matches: function GM:HookName(params)
        gm_hook_pattern = r'function\s+GM:([A-Za-z_][A-Za-z0-9_]*)'

        # Pattern for MODULE:HookName function definitions
        # Matches: function MODULE:HookName(params)
        module_hook_pattern = r'function\s+MODULE:([A-Za-z_][A-Za-z0-9_]*)'

        # Pattern for SCHEMA:HookName function definitions
        # Matches: function SCHEMA:HookName(params)
        schema_hook_pattern = r'function\s+SCHEMA:([A-Za-z_][A-Za-z0-9_]*)'

        # Find hook.Add calls
        for match in re.finditer(hook_add_pattern, content):
            hook_name = match.group(2)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        # Find hook.Run calls
        for match in re.finditer(hook_run_pattern, content):
            hook_name = match.group(2)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        # Find hook.Call calls
        for match in re.finditer(hook_call_pattern, content):
            hook_name = match.group(2)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        # Find GM:HookName function definitions
        for match in re.finditer(gm_hook_pattern, content):
            hook_name = match.group(1)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        # Find MODULE:HookName function definitions
        for match in re.finditer(module_hook_pattern, content):
            hook_name = match.group(1)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        # Find SCHEMA:HookName function definitions
        for match in re.finditer(schema_hook_pattern, content):
            hook_name = match.group(1)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        return hooks

    def _extract_hook_signatures_from_file_content(self, content: str) -> Dict[str, List[str]]:
        """Extract hook parameter names from callback and method definitions in file content."""
        signatures: Dict[str, List[str]] = {}

        # hook.Add("HookName", "id", function(a,b,c) ... end)
        for m in re.finditer(r'hook\.Add\s*\(\s*([\'"`])([^\'"`]+)\1\s*,\s*[^,]*,\s*function\s*\(([^)]*)\)', content, re.DOTALL):
            hook_name = m.group(2).strip()
            params_str = (m.group(3) or '').strip()
            params = [p.strip() for p in params_str.split(',') if p.strip()]
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                existing = signatures.get(hook_name)
                if not existing or len(params) > len(existing):
                    signatures[hook_name] = params

        # function GM:HookName(param1, param2)
        for m in re.finditer(r'function\s+GM:([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)', content):
            hook_name = m.group(1).strip()
            params_str = (m.group(2) or '').strip()
            params = [p.strip() for p in params_str.split(',') if p.strip()]
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                existing = signatures.get(hook_name)
                if not existing or len(params) > len(existing):
                    signatures[hook_name] = params

        # function MODULE:HookName(param1, param2)
        for m in re.finditer(r'function\s+MODULE:([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)', content):
            hook_name = m.group(1).strip()
            params_str = (m.group(2) or '').strip()
            params = [p.strip() for p in params_str.split(',') if p.strip()]
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                existing = signatures.get(hook_name)
                if not existing or len(params) > len(existing):
                    signatures[hook_name] = params

        # function SCHEMA:HookName(param1, param2)
        for m in re.finditer(r'function\s+SCHEMA:([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)', content):
            hook_name = m.group(1).strip()
            params_str = (m.group(2) or '').strip()
            params = [p.strip() for p in params_str.split(',') if p.strip()]
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                existing = signatures.get(hook_name)
                if not existing or len(params) > len(existing):
                    signatures[hook_name] = params

        # Fallback: infer param placeholders from hook.Run("HookName", a, b, c)
        for m in re.finditer(r'hook\.Run\s*\(\s*([\'"`])([^\'"`]+)\1\s*,\s*(.*?)\)', content, re.DOTALL):
            hook_name = m.group(2).strip()
            raw_args = (m.group(3) or '').strip()
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                arg_list = self._split_top_level_args(raw_args)
                if arg_list:
                    # Prefer meaningful identifier names; fallback to argN when needed
                    names: List[str] = []
                    for i, tok in enumerate(arg_list, start=1):
                        t = tok.strip()
                        if self._is_simple_identifier(t) and t not in ('true', 'false', 'nil') and not self._is_number(t):
                            names.append(t)
                        else:
                            names.append(f"arg{i}")

                    existing = signatures.get(hook_name)
                    if (not existing or len(names) > len(existing)
                        or (len(names) == len(existing) and self._are_generic_names(existing) and not self._are_generic_names(names))):
                        signatures[hook_name] = names

        # Handle hook.Run("HookName") with no arguments
        for m in re.finditer(r'hook\.Run\s*\(\s*([\'"`])([^\'"`]+)\1\s*\)', content):
            hook_name = m.group(2).strip()
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                existing = signatures.get(hook_name)
                if not existing:
                    signatures[hook_name] = []

        return signatures

    def _is_number(self, value: str) -> bool:
        """Check if a string represents a number"""
        try:
            float(value)
            return True
        except ValueError:
            return False

    def _is_simple_identifier(self, token: str) -> bool:
        """Return True for simple Lua identifiers (no dots, calls, or indexing)."""
        return bool(re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', token))

    def _are_generic_names(self, names: List[str]) -> bool:
        """True if all names look like argN placeholders."""
        if not names:
            return False
        return all(re.match(r'^arg\d+$', n) for n in names)

    def _run_panels_analysis(self) -> Tuple[List[str], List[str]]:
        """Run panel documentation analysis"""
        try:
            panels_found = self._scan_panels_in_code()
            panels_documented = self._read_documented_panels()
            return sorted(panels_found), sorted(list(panels_documented))
        except Exception as e:
            print(f"Error in panels analysis: {e}")
            return [], []

    def _scan_panels_in_code(self) -> List[str]:
        """Scan Lua files for vgui.Register() calls to find panels"""
        panels = set()

        # Scan gamemode files
        lua_files = list(self.base_path.rglob("*.lua"))

        for lua_file in lua_files:
            # Skip certain directories
            if any(skip in str(lua_file) for skip in ['languages', 'documentation', 'docs']):
                continue

            try:
                with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()

                # Remove comments from content before processing
                content = self._remove_lua_comments(content)

                # Find vgui.Register() calls
                # Pattern: vgui.Register("PanelName", panelData) or vgui.Register('PanelName', panelData)
                pattern = r'vgui\.Register\s*\(\s*["\']([^"\']+)["\']'
                matches = re.findall(pattern, content, re.IGNORECASE)

                for panel_name in matches:
                    if panel_name and panel_name.strip():
                        panels.add(panel_name.strip())

            except Exception as e:
                print(f"Warning: Error scanning {lua_file}: {e}")
                continue

        return list(panels)

    def _read_documented_panels(self) -> Set[str]:
        """Read documented panels from panels documentation files"""
        documented_panels = set()

        # Check panels documentation file in definitions directory
        panels_doc_file = self.docs_path / "docs" / "definitions" / "panels.md"
        if not panels_doc_file.exists():
            print(f"Warning: Panels documentation file not found: {panels_doc_file}")
            return documented_panels

        try:
            with open(panels_doc_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()

            # Look for panel names in headers or content
            # Pattern matches: ### PanelName or # PanelName or mentions in content
            lines = content.split('\n')
            for line in lines:
                line = line.strip()
                # Check for headers like ### liaMenu or # liaMenu
                if line.startswith('#') and len(line) > 1:
                    # Extract panel name from header (remove # symbols and get first word)
                    header_content = line.lstrip('#').strip()
                    panel_name = header_content.split()[0] if header_content else ""
                    if panel_name and panel_name not in ['Panels', 'Panel']:
                        documented_panels.add(panel_name)

                # Also check for vgui.Register mentions in content
                register_pattern = r'vgui\.Register\s*\(\s*["\']([^"\']+)["\']'
                matches = re.findall(register_pattern, line, re.IGNORECASE)
                for panel_name in matches:
                    if panel_name and panel_name.strip():
                        documented_panels.add(panel_name.strip())

        except Exception as e:
            print(f"Warning: Could not read panels from {panels_doc_file}: {e}")

        return documented_panels

    def _run_localization_analysis(self) -> Tuple[Dict, List]:
        """Run localization analysis"""
        try:
            # Framework analysis
            framework_data = analyze_data(self.language_file, str(self.base_path))

            # Modules analysis (only if module docs generation is enabled)
            modules = []
            if self.generate_module_docs:
                lang_name = Path(self.language_file).stem

                for base_path in self.modules_paths:
                    base_path = Path(base_path)
                    if not base_path.exists():
                        continue

                    for module_name in sorted(os.listdir(base_path)):
                        module_dir = base_path / module_name
                        if not module_dir.is_dir():
                            continue

                        # Skip _disabled directories and modules inside _disabled
                        if module_name == "_disabled" or "_disabled" in str(module_dir):
                            print(f"Skipping disabled module: {module_dir}")
                            continue

                        lang_file = module_dir / "languages" / f"{lang_name}.lua"
                        # Only check localization for gitmodules; skip other modules for localization
                        if 'gitmodules' not in str(base_path).lower():
                            # Skip localization analysis for non-gitmodules
                            pass
                        else:
                            if not lang_file.exists():
                                continue
                            module_data = analyze_data(str(lang_file), str(module_dir))
                            modules.append(module_data)

            return framework_data, modules
        except Exception as e:
            print(f"Error in localization analysis: {e}")
            return {}, []

    def generate_markdown_report(self, data: CombinedReportData) -> str:
        """Generate comprehensive markdown report"""
        report_lines = []


        # Executive Summary
        report_lines.extend(self._generate_executive_summary(data))

        # Function Documentation Section
        report_lines.extend(self._generate_function_docs_section(data))

        # Hooks Documentation Section
        report_lines.extend(self._generate_hooks_section(data))

        # Panels Documentation Section
        report_lines.extend(self._generate_panels_section(data))

        # Localization Section
        report_lines.extend(self._generate_localization_section(data))

        # Language Comparison Section
        report_lines.extend(self._generate_language_comparison_section(data))

        # Modules Section (in-report; do not create per-module files)
        if self.generate_module_docs:
            try:
                report_lines.extend(self._generate_modules_section(data.modules_scan))
            except Exception as e:
                print(f"Error generating modules section: {e}")

        return "\n".join(report_lines)

    def _scan_modules_for_undocumented(self) -> List[Dict]:
        """Scan external modules for undocumented hooks and lia.* functions.

        Returns a list of dicts: {
            'module_path': str,
            'undoc_hooks': List[str],
            'undoc_functions': List[str]
        }
        Includes entries for all modules encountered (even if counts are zero) so we can build a complete summary.
        """
        results: List[Dict] = []

        # Get documented hooks from main Lilia documentation to filter out already documented hooks
        try:
            documented_hooks = self._read_all_documented_hooks()
        except Exception:
            documented_hooks = set()

        # Get all documented functions from main Lilia documentation
        try:
            documented_functions = set()
            docs_path = Path(self.docs_path) / "docs"

            # Check libraries documentation
            if (docs_path / "libraries").exists():
                for md_file in (docs_path / "libraries").glob("*.md"):
                    if md_file.name.startswith("lia.") or md_file.stem == "lia.core":
                        try:
                            with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
                                content = f.read()
                            import re
                            for match in re.finditer(r'^###+\s+([A-Za-z_][\w\.:]*)\s*$', content, re.MULTILINE):
                                func_name = match.group(1).strip()
                                # Qualify bare headers on core page as lia.func
                                if '.' not in func_name and md_file.stem == 'lia.core':
                                    documented_functions.add(f'lia.{func_name}')
                                else:
                                    documented_functions.add(func_name)
                        except Exception:
                            continue

            # Check meta documentation (method names may also appear in code as type-qualified)
            if (docs_path / "meta").exists():
                for md_file in (docs_path / "meta").glob("*.md"):
                    try:
                        with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read()
                        import re
                        for match in re.finditer(r'`([A-Za-z_][\w\.:]*)\([^)]*\)`', content):
                            method_name = match.group(1).strip()
                            documented_functions.add(method_name)
                    except Exception:
                        continue
        except Exception:
            documented_functions = set()

        # Iterate modules and scan
        for base_path in self.modules_paths:
            base_path = Path(base_path)
            if not base_path.exists():
                continue

            for module_name in sorted(os.listdir(base_path)):
                module_dir = base_path / module_name
                if not module_dir.is_dir():
                    continue
                if module_name == "_disabled" or "_disabled" in str(module_dir):
                    print(f"Skipping disabled module: {module_dir}")
                    continue

                # Read module-level docs if present
                documented_module_hooks, documented_module_functions = self._read_module_docs(module_dir)

                undoc_functions: Set[str] = set()
                undoc_hooks: Set[str] = set()

                for root, _, files in os.walk(module_dir):
                    for fname in files:
                        if not fname.lower().endswith('.lua'):
                            continue
                        fpath = Path(root) / fname
                        try:
                            with open(fpath, 'r', encoding='utf-8', errors='ignore') as f:
                                content = f.read()
                        except Exception:
                            continue

                        import re
                        # lia.* dotted functions declared in module
                        for m in re.finditer(r'\b(function\s+([A-Za-z_][\w\.]*?)\s*\(|([A-Za-z_][\w\.]*?)\s*=\s*function\s*\()', content):
                            name = m.group(2) or m.group(3)
                            if name and name.startswith('lia.') and name.count('.') >= 2:
                                if name not in documented_functions and name not in documented_module_functions:
                                    undoc_functions.add(name)

                        # Hooks via hook.Add / hook.Run literals in module, filtered by documented core hooks
                        for m in re.finditer(r'hook\s*\.\s*Add\s*\(\s*(["\'])\s*([^"\']+)\1', content):
                            hook_name = m.group(2)
                            if hook_name not in documented_hooks and hook_name not in documented_module_hooks:
                                undoc_hooks.add(hook_name)
                        for m in re.finditer(r'hook\s*\.\s*Run\s*\(\s*(["\'])\s*([^"\']+)\1', content):
                            hook_name = m.group(2)
                            if hook_name not in documented_hooks and hook_name not in documented_module_hooks:
                                undoc_hooks.add(hook_name)

                results.append({
                    'module_path': str(module_dir),
                    'undoc_hooks': sorted(undoc_hooks, key=str.lower),
                    'undoc_functions': sorted(undoc_functions, key=str.lower),
                })

        return results

    def _read_module_docs(self, module_dir: Path) -> Tuple[Set[str], Set[str]]:
        """Read module-level documentation markers from module_dir/docs.
        - hooks.md: list of documented hook names (strings)
        - libraries.md: list of documented lia.* function names
        Returns (documented_hooks, documented_functions)
        """
        documented_hooks: Set[str] = set()
        documented_functions: Set[str] = set()

        docs_dir = module_dir / 'docs'
        if not docs_dir.exists() or not docs_dir.is_dir():
            return documented_hooks, documented_functions

        # hooks.md
        hooks_file = docs_dir / 'hooks.md'
        if hooks_file.exists():
            try:
                with open(hooks_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                import re
                # Extract hook names from markdown headers (e.g., ## HookName)
                for m in re.finditer(r'^##+\s+([A-Za-z_][A-Za-z0-9_]*)\s*$', content, re.MULTILINE):
                    documented_hooks.add(m.group(1))
            except Exception:
                pass

        # libraries.md
        libs_file = docs_dir / 'libraries.md'
        if libs_file.exists():
            try:
                with open(libs_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                import re
                # Extract lia.* dotted function names from markdown headers (e.g., ## lia.utilities.Blend)
                for m in re.finditer(r'^##+\s+(lia\.[A-Za-z_][\w\.]*)\s*$', content, re.MULTILINE):
                    documented_functions.add(m.group(1))
            except Exception:
                pass

        return documented_hooks, documented_functions

    def _generate_modules_section(self, modules_scan: List[Dict]) -> List[str]:
        """Build the in-report Modules section with per-module details and a final summary.
        Only show a module's detail section if it has any undocumented items, but include all in the summary.
        """
        lines: List[str] = []
        if modules_scan is None:
            return lines

        lines.append("# Modules")
        lines.append("")

        # Detail sections
        for entry in modules_scan:
            undoc_hooks = entry.get('undoc_hooks', [])
            undoc_functions = entry.get('undoc_functions', [])
            if not undoc_hooks and not undoc_functions:
                continue
            lines.append("---")
            lines.append("")
            lines.append(f"## Module: `{entry['module_path']}`")
            lines.append("")
            lines.append("### Module Documentation Report")
            lines.append("")
            if undoc_hooks:
                lines.append("- **Undocumented Hooks:**")
                for h in undoc_hooks:
                    lines.append(f"  - `{h}()`")
            if undoc_functions:
                if undoc_hooks:
                    lines.append("")
                lines.append("- **Undocumented lia.* Functions:**")
                for f in undoc_functions:
                    lines.append(f"  - `{f}()`")
            lines.append("")

        # Summary table
        if modules_scan:
            lines.append("---")
            lines.append("")
            lines.append("# Module Documentation Summary")
            lines.append("")
            lines.append("| Module Path | Undocumented Hooks | Undocumented lia.* Functions |")
            lines.append("|---|---:|---:|")
            for entry in modules_scan:
                lines.append(f"| {entry['module_path']} | {len(entry.get('undoc_hooks', []))} | {len(entry.get('undoc_functions', []))} |")
            lines.append("")

        return lines

    def _generate_module_docs(self, data: CombinedReportData) -> None:
        """Generate docs inside each external module (non-Lilia) when entries are found.

        Rules:
        - Only modules (from modules_paths) are considered; framework base is ignored.
        - Create a `docs` folder in module directory when any entries exist.
        - If functions with dotted names (e.g., lia.something.doThing) exist, write libraries.md.
        - If hooks are found in module code that are NOT already documented in gamemode_hooks.md, write hooks.md.
        - Meta/functions inside module files (if any) are also recorded in libraries.md.
        """
        # Build a quick detector for dotted function names from function_comparison
        function_map = data.function_comparison or {}

        # Pre-compute per-file functions
        per_file_functions = {}
        for file_name, file_data in function_map.items():
            per_file_functions[file_name] = list(file_data.get('functions', {}).keys())

        # Get documented hooks from main Lilia documentation to filter out already documented hooks
        try:
            documented_hooks = self._read_all_documented_hooks()
        except Exception:
            documented_hooks = set()

        # Get all documented functions from main Lilia documentation
        try:
            documented_functions = set()
            docs_path = Path(self.docs_path) / "docs"

            # Check libraries documentation
            if (docs_path / "libraries").exists():
                for md_file in (docs_path / "libraries").glob("*.md"):
                    if md_file.name.startswith("lia."):
                        try:
                            with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
                                content = f.read()
                            # Extract function names from headers
                            import re
                            for match in re.finditer(r'^###+\s+([A-Za-z_][\w\.:]*)\s*$', content, re.MULTILINE):
                                func_name = match.group(1).strip()
                                documented_functions.add(func_name)
                        except Exception:
                            continue

            # Check meta documentation
            if (docs_path / "meta").exists():
                for md_file in (docs_path / "meta").glob("*.md"):
                    try:
                        with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read()
                        # Extract method names from meta docs
                        for match in re.finditer(r'`([A-Za-z_][\w\.:]*)\([^)]*\)`', content):
                            method_name = match.group(1).strip()
                            documented_functions.add(method_name)
                    except Exception:
                        continue

        except Exception:
            documented_functions = set()

        # Iterate modules
        lang_name = Path(self.language_file).stem
        for base_path in self.modules_paths:
            base_path = Path(base_path)
            if not base_path.exists():
                continue

            for module_name in sorted(os.listdir(base_path)):
                module_dir = base_path / module_name
                if not module_dir.is_dir():
                    continue

                # Skip _disabled directories and modules inside _disabled
                if module_name == "_disabled" or "_disabled" in str(module_dir):
                    print(f"Skipping disabled module: {module_dir}")
                    continue

                docs_dir = module_dir / 'docs'

                # Scan module lua files for dotted functions and hooks
                dotted_functions = []
                hooks_found = set()

                for root, _, files in os.walk(module_dir):
                    for fname in files:
                        if not fname.lower().endswith('.lua'):
                            continue
                        fpath = Path(root) / fname
                        try:
                            with open(fpath, 'r', encoding='utf-8', errors='ignore') as f:
                                content = f.read()
                        except Exception:
                            continue

                        # Dotted functions - only lia.xxxxxx.xxxx pattern
                        import re
                        for m in re.finditer(r'\b(function\s+([A-Za-z_][\w\.]*?)\s*\(|([A-Za-z_][\w\.]*?)\s*=\s*function\s*\()', content):
                            name = m.group(2) or m.group(3)
                            # Only include functions that start with "lia." and have at least one more dot
                            # AND are not already documented in main Lilia docs
                            if (name and name.startswith('lia.') and name.count('.') >= 2
                                and name not in documented_functions):
                                dotted_functions.append(name)

                        # Hooks via hook.Add / hook.Run literals in module
                        # Only add hooks that are NOT already documented in gamemode_hooks.md
                        for m in re.finditer(r'hook\s*\.\s*Add\s*\(\s*([\"\"])\s*([^\"\']+)\1', content):
                            hook_name = m.group(2)
                            if hook_name not in documented_hooks:
                                hooks_found.add(hook_name)
                        for m in re.finditer(r'hook\s*\.\s*Run\s*\(\s*([\"\"])\s*([^\"\']+)\1', content):
                            hook_name = m.group(2)
                            if hook_name not in documented_hooks:
                                hooks_found.add(hook_name)

        # If any entries exist, create docs folder and write files
        if dotted_functions or hooks_found:
            docs_dir.mkdir(parents=True, exist_ok=True)

            # Write libraries.md if dotted functions found (always overwrite)
            if dotted_functions:
                lib_md_path = docs_dir / 'libraries.md'
                with open(lib_md_path, 'w', encoding='utf-8') as f:
                    f.write('# Module Libraries\n\n')
                    f.write('Detected dotted functions in this module.\n\n')
                    for name in sorted(set(dotted_functions)):
                        f.write(f'## {name}\n\n')
                        f.write('**Purpose**\n\n')
                        f.write('Function description goes here.\n\n')
                        f.write('**Parameters**\n\n')
                        f.write('* `param1` (*type*): Description\n\n')
                        f.write('**Returns**\n\n')
                        f.write('* `return` (*type*): Description\n\n')
                        f.write('**Realm**\n\n')
                        f.write('Shared.\n\n')
                        f.write('**Example Usage**\n\n')
                        f.write('```lua\n')
                        f.write(f'-- Example usage of {name}\n')
                        f.write(f'local result = {name}()\n')
                        f.write('```\n\n')
                        f.write('---\n\n')

            # Handle hooks.md - always overwrite the main file
            hooks_md_path = docs_dir / 'hooks.md'

            # Read existing hooks from hooks.md to compare
            existing_hooks = set()
            if hooks_md_path.exists():
                try:
                    with open(hooks_md_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                        # Extract existing hook names from markdown headers
                        import re
                        for match in re.finditer(r'^##+\s+([A-Za-z_][A-Za-z0-9_]*)\s*$', content, re.MULTILINE):
                            existing_hooks.add(match.group(1).strip())
                except Exception:
                    existing_hooks = set()

            # Determine new hooks (hooks that weren't in the previous file)
            new_hooks = hooks_found - existing_hooks

            # Always update hooks.md with current status
            with open(hooks_md_path, 'w', encoding='utf-8') as f:
                f.write('# Module Hooks\n\n')
                f.write('This document describes the hooks available in this module.\n\n')
                f.write('---\n\n')
                if hooks_found:
                    for name in sorted(hooks_found, key=str.lower):
                        f.write(f'## {name}\n\n')
                        f.write('**Purpose**\n\n')
                        f.write('Called when [description goes here].\n\n')
                        f.write('**Parameters**\n\n')
                        f.write('* `param1` (*type*): Description\n\n')
                        f.write('**Realm**\n\n')
                        f.write('Server.\n\n')
                        f.write('**When Called**\n\n')
                        f.write('This hook is triggered when [description goes here].\n\n')
                        f.write('**Example Usage**\n\n')
                        f.write('```lua\n')
                        f.write(f'hook.Add("{name}", "MyHookName", function(param1)\n')
                        f.write('    -- Hook logic here\n')
                        f.write('end)\n')
                        f.write('```\n\n')
                        f.write('---\n\n')
                else:
                    f.write('All hooks used in this module are already documented in the main hooks documentation.\n\n')

            # Create hooks_new.md only if there are truly new hooks
            if new_hooks:
                hooks_new_path = docs_dir / 'hooks_new.md'
                with open(hooks_new_path, 'w', encoding='utf-8') as f:
                    f.write('# New Module Hooks\n\n')
                    f.write('New hooks detected in this module that were not in the previous hooks.md:\n\n')
                    for name in sorted(new_hooks, key=str.lower):
                        f.write(f'- `{name}`\n')

    def _generate_executive_summary(self, data: CombinedReportData) -> List[str]:
        """Generate executive summary section"""
        lines = ["## Executive Summary", ""]

        # Function stats - use unique counts for display
        total_functions = sum(r.get('total_functions', 0) for r in data.function_comparison.values())
        total_documented = sum(r.get('documented_functions', 0) for r in data.function_comparison.values())
        total_missing = sum(len(r.get('missing_functions', [])) for r in data.function_comparison.values())
        total_missing_unique = sum(r.get('missing_functions_count', len(r.get('missing_functions', []))) for r in data.function_comparison.values())

        # Categorized missing functions counts
        missing_library_count = len(data.missing_library_functions)
        missing_hook_count = len(data.missing_hook_functions)
        missing_meta_count = len(data.missing_meta_functions)

        # Hooks stats
        hooks_missing_count = len(data.hooks_missing)
        # Calculate unused hooks with whitelist filtering
        unused_hooks_count = len([h for h in data.hooks_documented if h not in data.hooks_registered and h not in FRAMEWORK_HOOKS_WHITELIST])

        # Panels stats
        panels_missing_count = len(data.panels_found) - len(data.panels_documented) if data.panels_found else 0

        # Localization stats
        undefined_calls = data.localization_data.get('undefined_count', len(data.localization_data.get('undefined_rows', []))) if data.localization_data else 0
        at_patterns = data.localization_data.get('at_pattern_count', len(data.localization_data.get('at_pattern_rows', []))) if data.localization_data else 0
        arg_mismatches = len(data.argument_mismatches)

        lines.extend([
            "### Function Documentation",
            f"- **Total Functions:** {total_functions}",
            f"- **Documented:** {total_documented} ({(total_documented/total_functions*100):.1f}%)" if total_functions > 0 else "- **Documented:** N/A",
            f"- **Missing Functions:** {total_missing} unique ({total_missing_unique} total occurrences)",
            f"  - **Library Functions:** {missing_library_count}",
            f"  - **Hook Functions:** {missing_hook_count}",
            f"  - **Meta Functions:** {missing_meta_count}",
            "",
            "### Hooks Documentation",
            f"- **Missing Hooks:** {hooks_missing_count} (used but undocumented)",
            f"- **Unused Hooks:** {unused_hooks_count} (documented but unused)",
            f"- **Total Documented Hooks:** {len(data.hooks_documented)}",
            f"- **Total Registered Hooks:** {len(data.hooks_registered)}",
            "",
            "### Panels Documentation",
            f"- **Panels Found:** {len(data.panels_found)}",
            f"- **Documented Panels:** {len(data.panels_documented)}",
            f"- **Missing Panels:** {panels_missing_count}",
            "",
            "### Localization Analysis",
            f"- **Undefined Calls:** {undefined_calls} unique",
            f"- **@xxxxx Patterns:** {at_patterns} unique",
            f"- **Argument Mismatches:** {arg_mismatches}",
            "",
            "---",
            ""
        ])

        return lines

    def _generate_function_docs_section(self, data: CombinedReportData) -> List[str]:
        """Generate function documentation section"""
        lines = ["## Function Documentation Analysis", ""]

        if not data.function_comparison:
            lines.append("_No function comparison data available._")
            lines.append("")
            return lines

        # Summary stats
        total_files = len(data.function_comparison)
        total_functions = sum(r.get('total_functions', 0) for r in data.function_comparison.values())
        total_documented = sum(r.get('documented_functions', 0) for r in data.function_comparison.values())
        total_missing = sum(len(r.get('missing_functions', [])) for r in data.function_comparison.values())
        total_missing_unique = sum(r.get('missing_functions_count', len(r.get('missing_functions', []))) for r in data.function_comparison.values())

        lines.extend([
            "### Summary Statistics",
            f"- **Files Analyzed:** {total_files}",
            f"- **Total Functions:** {total_functions}",
            f"- **Documented Functions:** {total_documented}",
            f"- **Missing Documentation:** {total_missing} unique ({total_missing_unique} total occurrences)",
            f"- **Coverage:** {(total_documented/total_functions*100):.1f}%" if total_functions > 0 else "- **Coverage:** N/A",
            "",
        ])

        # Missing functions by category
        if data.missing_library_functions:
            lines.extend([
                "### Missing Library Functions",
                f"Total: {len(data.missing_library_functions)} functions",
                "",
            ])
            
            # Group functions by library prefix
            library_groups = {}
            for func_info in data.missing_library_functions:
                func_name = func_info.name
                if '.' in func_name:
                    # Extract library prefix
                    parts = func_name.split('.')
                    if len(parts) >= 2:
                        # For core lia functions (like lia.error), use just "lia"
                        if parts[0] == 'lia' and len(parts) == 2:
                            library_prefix = 'lia'
                        else:
                            # For other functions (like lia.char.something), use "lia.char"
                            library_prefix = '.'.join(parts[:2])
                    else:
                        library_prefix = parts[0]  # fallback
                else:
                    library_prefix = "other"

                if library_prefix not in library_groups:
                    library_groups[library_prefix] = []
                library_groups[library_prefix].append(func_info)

            # Sort groups by prefix name
            for library_prefix in sorted(library_groups.keys()):
                functions = library_groups[library_prefix]
                lines.append(f"#### {library_prefix}")
                lines.append(f"Count: {len(functions)} functions")
                lines.append("")
                for func_info in sorted(functions, key=lambda f: f.name):
                    lines.append(f"- `{self._format_function_signature(func_info)}`")
                lines.append("")

        if data.missing_hook_functions:
            lines.extend([
                "### Missing Hook Functions",
                f"Total: {len(data.missing_hook_functions)} functions",
                "",
            ])
            for func_info in sorted(data.missing_hook_functions, key=lambda f: f.name):
                lines.append(f"- `{self._format_function_signature(func_info)}`")
            lines.append("")

        if data.missing_meta_functions:
            lines.extend([
                "### Missing Meta Functions",
                f"Total: {len(data.missing_meta_functions)} functions",
                "",
            ])
            
            # Group meta functions by meta type
            meta_groups = {}
            for func_info in data.missing_meta_functions:
                func_name = func_info.name
                # Extract meta type from function name
                # Common patterns: Character.something, Player.something, Entity.something, Panel.something, etc.
                if ':' in func_name:
                    meta_type = func_name.split(':')[0]  # e.g., "characterMeta" from "characterMeta:something"
                else:
                    meta_type = "other"

                if meta_type not in meta_groups:
                    meta_groups[meta_type] = []
                meta_groups[meta_type].append(func_info)

            # Sort groups by meta type name
            for meta_type in sorted(meta_groups.keys()):
                functions = meta_groups[meta_type]
                lines.append(f"#### {meta_type}")
                lines.append(f"Count: {len(functions)} functions")
                lines.append("")
                for func_info in sorted(functions, key=lambda f: f.name):
                    lines.append(f"- `{self._format_function_signature(func_info)}`")
                lines.append("")

        # Show uncategorized if any exist (shouldn't happen with proper categorization)
        all_categorized = {func_info.name for func_info in data.missing_library_functions + data.missing_hook_functions + data.missing_meta_functions}
        all_missing = []
        for file_data in data.function_comparison.values():
            all_missing.extend(file_data.get('missing_functions', []))

        uncategorized = [func for func in set(all_missing) if func not in all_categorized]
        if uncategorized:
            lines.extend([
                "### Uncategorized Functions",
                f"Total: {len(uncategorized)} functions (could not be categorized)",
                "",
            ])
            for func in sorted(uncategorized):
                lines.append(f"- `{func}()`")
            lines.append("")

        return lines

    def _generate_hooks_section(self, data: CombinedReportData) -> List[str]:
        """Generate hooks documentation section"""
        lines = ["## Hooks Documentation Analysis", ""]

        if not data.hooks_missing and not data.hooks_documented and not data.hooks_registered:
            lines.append("_No hooks analysis data available._")
            lines.append("")
            return lines

        # Find unused hooks (documented but not registered)
        unused_hooks = [h for h in data.hooks_documented if h not in data.hooks_registered and h not in FRAMEWORK_HOOKS_WHITELIST]

        lines.extend([
            f"### Summary",
            f"- **Missing Hooks:** {len(data.hooks_missing)} (used in code but not documented)",
            f"- **Documented Hooks:** {len(data.hooks_documented)}",
            f"- **Registered Hooks:** {len(data.hooks_registered)}",
            f"- **Unused Hooks:** {len(unused_hooks)} (documented but not registered)",
            "",
        ])

        if data.hooks_missing:
            lines.append("### Missing Hook Documentation:")
            lines.append("These hooks are registered in code but missing from documentation:")
            for hook in data.hooks_missing:
                params = data.hooks_signatures.get(hook, []) if hasattr(data, 'hooks_signatures') else []
                if params:
                    param_str = ', '.join(params)
                    lines.append(f"- `{hook}({param_str})`")
                else:
                    lines.append(f"- `{hook}()`")
            lines.append("")

        if unused_hooks:
            lines.append("### Unused Hook Documentation:")
            lines.append("These hooks are documented but not registered in code:")
            for hook in sorted(unused_hooks):
                lines.append(f"- `{hook}()`")
            lines.append("")


        return lines

    def _generate_panels_section(self, data: CombinedReportData) -> List[str]:
        """Generate panels documentation section"""
        lines = ["## Panels Documentation Analysis", ""]

        if not data.panels_found and not data.panels_documented:
            lines.append("_No panels analysis data available._")
            lines.append("")
            return lines

        # Categorize panels
        panels_found_set = set(data.panels_found)
        panels_documented_set = set(data.panels_documented)

        # Panels registered in code but not documented
        panels_missing_docs = [p for p in data.panels_found if p not in panels_documented_set]

        # Panels documented but not registered in code (potentially obsolete)
        panels_obsolete_docs = [p for p in data.panels_documented if p not in panels_found_set]

        # Panels that are both registered and documented (properly documented)
        panels_properly_documented = [p for p in data.panels_found if p in panels_documented_set]

        lines.extend([
            "### Summary",
            f"- **Panels Registered in Code:** {len(data.panels_found)}",
            f"- **Panels in Documentation:** {len(data.panels_documented)}",
            f"- **Missing Documentation:** {len(panels_missing_docs)}",
            f"- **Obsolete Documentation:** {len(panels_obsolete_docs)}",
            f"- **Properly Documented:** {len(panels_properly_documented)}",
            "",
        ])

        if panels_missing_docs:
            lines.append("### Panels Missing Documentation:")
            lines.append("These panels are registered in code but not documented:")
            for panel in sorted(panels_missing_docs):
                lines.append(f"- `{panel}()`")
            lines.append("")

        if panels_obsolete_docs:
            lines.append("### Obsolete Panel Documentation:")
            lines.append("These panels are documented but not registered in code:")
            for panel in sorted(panels_obsolete_docs):
                lines.append(f"- `{panel}()`")
            lines.append("")

        if panels_properly_documented:
            lines.append("### Properly Documented Panels:")
            lines.append("These panels are both registered in code and documented:")
            for panel in sorted(panels_properly_documented):
                lines.append(f"- `{panel}()`")
            lines.append("")

        return lines

    def _generate_localization_section(self, data: CombinedReportData) -> List[str]:
        """Generate localization analysis section"""
        lines = ["## Localization Analysis", ""]

        if not data.localization_data and not data.argument_mismatches:
            lines.append("_No localization data available._")
            lines.append("")
            return lines

        loc_data = data.localization_data

        # Framework summary
        if data.localization_data:
            lines.extend([
                "### Framework Localization",
                f"- **Language Keys:** {len(loc_data.get('keys', []))}",
                f"- **Total Usages:** {loc_data.get('total_hits', 0)}",
                f"- **Undefined Calls:** {loc_data.get('undefined_count', len(loc_data.get('undefined_rows', [])))}",
                f"- **@xxxxx Patterns:** {loc_data.get('at_pattern_count', len(loc_data.get('at_pattern_rows', [])))}",
                "",
            ])

        # Argument mismatches summary
        if data.argument_mismatches:
            lines.extend([
                "### Argument Mismatches",
                f"- **Total Mismatches:** {len(data.argument_mismatches)}",
                "",
            ])

            # Group mismatches by file for better organization
            file_mismatches = defaultdict(list)
            for mismatch in data.argument_mismatches:
                file_mismatches[mismatch['file']].append(mismatch)

            for filename, mismatches in sorted(file_mismatches.items()):
                lines.append(f"#### {filename}")
                for mismatch in sorted(mismatches, key=lambda x: x['line']):
                    lines.append(f"- **Line {mismatch['line']}:** `{mismatch['key']}(args)`")
                    lines.append(f"  - Expected: {mismatch['expected']} args, Provided: {mismatch['provided']} args")
                    lines.append(f"  - Context: `{mismatch['context'][:80]}{'...' if len(mismatch['context']) > 80 else ''}`")
                lines.append("")

        # Issues summary (for backward compatibility)
        issues = []
        if data.localization_data and loc_data.get('undefined_rows'):
            issues.append(f"- {len(loc_data['undefined_rows'])} undefined calls")
        if data.localization_data and loc_data.get('at_pattern_rows'):
            issues.append(f"- {len(loc_data['at_pattern_rows'])} @xxxxx patterns")
        if data.argument_mismatches:
            issues.append(f"- {len(data.argument_mismatches)} argument mismatches")

        if issues:
            lines.append("### Key Issues:")
            lines.extend(issues)
            lines.append("")

        # All issues (complete list) - only undefined calls for backward compatibility
        if data.localization_data and loc_data.get('undefined_rows'):
            lines.append("### Undefined Localization Calls:")
            for row in loc_data['undefined_rows']:
                lines.append(f"- `{row[4]}(args)` in {row[0]}:{row[1]}:{row[2]} ({row[3]})")
            lines.append("")

        return lines

    def _generate_language_comparison_section(self, data: CombinedReportData) -> List[str]:
        """Generate language comparison section"""
        lines = ["## Language File Comparison", ""]

        if not data.language_comparison:
            lines.append("_No language comparison data available._")
            lines.append("")
            return lines

        # Count total missing keys
        total_missing = sum(
            len(missing_list)
            for lang_data in data.language_comparison.values()
            for missing_list in lang_data.values()
        )

        lines.extend([
            "### Summary",
            f"- **Languages Compared:** {len(data.language_comparison)}",
            f"- **Total Missing Keys:** {total_missing}",
            "",
        ])

        # Generate the detailed comparison for each language
        for base_lang in sorted(data.language_comparison.keys()):
            lang_missing = data.language_comparison[base_lang]

            if not any(lang_missing.values()):  # Skip if no missing keys
                continue

            lines.append(f"### {base_lang.title()}")
            lines.append("")

            # Check if this language is missing any keys from others
            has_missing_keys = any(missing_keys for missing_keys in lang_missing.values())

            if has_missing_keys:
                lines.append("- **Missing Keys:**")
                for other_lang in sorted(lang_missing.keys()):
                    missing_keys = lang_missing[other_lang]
                    if missing_keys:
                        lines.append(f"  - **From {other_lang.title()}:** {len(missing_keys)} keys")
                        for key in missing_keys:
                            lines.append(f"    - `{key}()`")
                lines.append("")
            else:
                lines.append("- **No missing keys from other languages**")
                lines.append("")

        return lines

    def save_report(self, data: CombinedReportData, output_file: str = None):
        """Generate and save the comprehensive report"""
        # Ensure output directory exists (use the dynamic docs_path)
        self.docs_path.mkdir(parents=True, exist_ok=True)

        if output_file is None:
            output_file = str(self.docs_path / "report.md")
        else:
            # If user provided a relative path, make it relative to self.docs_path
            if not Path(output_file).is_absolute():
                output_file = str(self.docs_path / output_file)

        report = self.generate_markdown_report(data)

        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(report)

        return output_file

def confirm_analysis_actions(base_path: Path, docs_path: Path, language_file: str,
                           modules_paths: List[str], output_dir: Path, quiet: bool = False) -> Tuple[bool, List[str]]:
    """Display analysis actions and get user confirmation

    Returns:
        Tuple[bool, List[str]]: (generate_module_docs, approved_modules_paths)
    """
    # In quiet mode, skip all prompts and don't generate module docs
    if quiet:
        return False, []
    
    print("\nANALYSIS CONFIGURATION")
    print("=" * 60)

    print("\nMAIN DIRECTORIES TO SCAN:")
    print(f"   - Gamemode: {base_path}")
    print(f"   - Documentation: {docs_path}")
    print(f"   - Language file: {language_file}")

    print("\nOUTPUT LOCATION:")
    print(f"   - Documentation directory: {output_dir}")
    print("   - The report.md file will be created/updated here")

    print("\n" + "=" * 60)

    # Ask about module documentation generation
    print("\nMODULE DOCUMENTATION:")
    print("   - Module documentation includes scanning external modules for undocumented items")
    print("   - This can create 'docs' folders in module directories")
    print("   - Main analysis will always run regardless of this choice")
    
    while True:
        response = input("\nDo you want to generate module documentation? (y/n): ").strip().lower()
        if response in ['y', 'yes']:
            generate_module_docs = True
            break
        elif response in ['n', 'no']:
            generate_module_docs = False
            print("Module documentation generation disabled. Proceeding with main analysis only.")
            print("\nProceeding with analysis...\n")
            return False, []
        else:
            print("Please enter 'y' for yes or 'n' for no.")

    # Ask about each module path individually (only if module docs are enabled)
    approved_modules_paths = []
    if generate_module_docs:
        print("\nMODULE PATH CONFIRMATION:")
        print("-" * 40)

        for i, path in enumerate(modules_paths, 1):
            path_obj = Path(path)
            status = "Exists" if path_obj.exists() else "Missing"
            print(f"\n{i}. {path}")
            print(f"   Status: {status}")

            if not path_obj.exists():
                print("   Directory does not exist - skipping")
                continue

            while True:
                response = input(f"   Scan this module path? (y/n): ").strip().lower()
                if response in ['y', 'yes']:
                    approved_modules_paths.append(path)
                    print("   Added to scan list")
                    break
                elif response in ['n', 'no']:
                    print("   Skipped")
                    break
                else:
                    print("   Please enter 'y' for yes or 'n' for no.")

        if not approved_modules_paths:
            print("\nNo module paths approved for scanning.")
            print("Proceeding with main analysis only.")
            generate_module_docs = False

    print("\nProceeding with analysis...\n")
    return generate_module_docs, approved_modules_paths

def main():
    """Main function"""
    parser = argparse.ArgumentParser(
        description="Generate comprehensive function comparison reports",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python function_comparison_report.py
  python function_comparison_report.py --base-path /path/to/gamemode --docs-path /path/to/docs
  python function_comparison_report.py --output my_report.md --quiet
        """
    )
    parser.add_argument("--base-path", default=str(DEFAULT_GAMEMODE_ROOT),
                       help=f"Base path to gamemode directory (default: {DEFAULT_GAMEMODE_ROOT})")
    parser.add_argument("--docs-path", default=str(DEFAULT_DOCS_ROOT),
                       help=f"Path to documentation directory (default: {DEFAULT_DOCS_ROOT})")
    # Use correct language file path for E:\Server structure
    default_lang_file = str(DEFAULT_LANGUAGE_FILE)
    if default_lang_file.startswith(r'E:\Server'):
        default_lang_file = r"E:\Server\garrysmod\gamemodes\Lilia\gamemode\languages\english.lua"
    parser.add_argument("--language-file", default=default_lang_file,
                       help=f"Path to main language file (default: {default_lang_file})")
    parser.add_argument("--modules-path", action="append",
                       help=f"Paths to modules directories (default: {DEFAULT_MODULES_PATHS})")
    parser.add_argument("--output", "-o", help="Output file path (default: report.md)")
    parser.add_argument("--quiet", "-q", action="store_true", help="Suppress progress output")

    args = parser.parse_args()

    # Validate paths
    base_path = Path(args.base_path)
    docs_path = Path(args.docs_path)

    if not base_path.exists():
        print(f"Error: Base path does not exist: {base_path}")
        sys.exit(1)

    if not docs_path.exists():
        print(f"Error: Documentation path does not exist: {docs_path}")
        sys.exit(1)

    # Handle modules paths
    modules_paths = args.modules_path if args.modules_path else [str(p) for p in DEFAULT_MODULES_PATHS]

    # Confirm analysis actions with user
    generate_module_docs, approved_modules_paths = confirm_analysis_actions(
        base_path, docs_path, args.language_file, modules_paths,
        DEFAULT_OUTPUT_DIR, args.quiet
    )

    if not args.quiet:
        print("Starting comprehensive function comparison analysis...")
        print(f"Base Path: {base_path}")
        print(f"Docs Path: {docs_path}")
        print(f"Approved Module Paths: {len(approved_modules_paths)}")
        for i, path in enumerate(approved_modules_paths, 1):
            print(f"   {i}. {path}")

    # Initialize generator
    generator = FunctionComparisonReportGenerator(
        str(base_path),
        str(docs_path),
        args.language_file,
        approved_modules_paths,
        generate_module_docs
    )

    # Run analyses
    try:
        data = generator.run_all_analyses()

        # Generate and save report
        report_file = generator.save_report(data, args.output)

        if not args.quiet:
            print("\nAnalysis complete!")
            print(f"Report saved: {report_file}")

            # Print quick summary
            total_functions = sum(r.get('total_functions', 0) for r in data.function_comparison.values())
            total_documented = sum(r.get('documented_functions', 0) for r in data.function_comparison.values())

            print("\nQuick Summary:")
            print(f"   - Functions: {total_documented}/{total_functions} documented ({(total_documented/total_functions*100):.1f}%)" if total_functions > 0 else "   - Functions: No data")
            print(f"   - Missing hooks: {len(data.hooks_missing)}")
            unused_hooks = len(data.hooks_documented) - len(data.hooks_registered) if data.hooks_registered else 0
            print(f"   - Unused hooks: {unused_hooks}")
            print(f"   - Localization issues: {len(data.localization_data.get('unused', []))} unused, {len(data.localization_data.get('undefined_rows', []))} undefined")

    except Exception as e:
        print(f"ERROR during analysis: {e}")
        if not args.quiet:
            import traceback
            traceback.print_exc()
        sys.exit(1)

def test_path_detection():
    """Test function to verify path detection works correctly"""
    print("Testing path detection...")
    paths = _get_paths_from_file_location()
    print(f"Gamemode root: {paths['gamemode_root']}")
    print(f"Documentation root: {paths['docs_root']}")
    print(f"Language file: {paths['language_file']}")
    print(f"Output directory: {paths['output_dir']}")
    print(f"Modules paths: {len(paths['modules_paths'])} paths")
    for i, path in enumerate(paths['modules_paths'], 1):
        print(f"  {i}. {path}")

    # Verify paths exist
    all_good = True
    if not paths['gamemode_root'].exists():
        print(f"ERROR: Gamemode root does not exist: {paths['gamemode_root']}")
        all_good = False
    if not paths['docs_root'].exists():
        print(f"ERROR: Documentation root does not exist: {paths['docs_root']}")
        all_good = False

    # Check modules paths
    for path in paths['modules_paths']:
        if not path.exists():
            print(f"ERROR: Modules path does not exist: {path}")
            all_good = False

    if all_good:
        print("SUCCESS: Path detection test passed!")
    else:
        print("ERROR: Path detection test failed!")

    return all_good

if __name__ == "__main__":
    # If run with --test-paths argument, just test path detection
    if len(sys.argv) > 1 and sys.argv[1] == '--test-paths':
        test_path_detection()
    else:
        # Always run comprehensive analysis (complex mode)
        main()

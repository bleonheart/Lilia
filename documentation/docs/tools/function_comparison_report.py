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

# Hardcoded paths
DEFAULT_GAMEMODE_ROOT = Path(r"E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode")
DEFAULT_DOCS_ROOT = Path(r"E:\GMOD\Server\garrysmod\gamemodes\Lilia\documentation")
DEFAULT_LANGUAGE_FILE = Path(r"E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\languages\english.lua")
DEFAULT_MODULES_PATHS = [
    Path(r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules"),
    Path(r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules"),
    Path(r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\devmodules"),
]
DEFAULT_OUTPUT_DIR = Path(r"E:\GMOD\Server\garrysmod\gamemodes\Lilia\documentation")

# Import from existing files
import sys
import os

# Add current directory to path for imports
current_dir = os.path.dirname(os.path.abspath(__file__))
if current_dir not in sys.path:
    sys.path.insert(0, current_dir)

try:
    from compare_functions import FunctionComparator, LuaFunctionExtractor, DocumentationParser
    from missinghooks import scan_hooks, read_documented_hooks
    from localization_analysis_report import (
        analyze_data, write_framework_md, write_framework_txt,
        write_modules_md, write_modules_txt, DEFAULT_FRAMEWORK_GAMEMODE_DIR,
        DEFAULT_LANGUAGE_FILE, DEFAULT_MODULES_PATHS
    )
except ImportError as e:
    print(f"Error importing required modules: {e}")
    print("Make sure compare_functions.py, missinghooks.py, and localization_analysis_report.py exist in the same directory")
    sys.exit(1)

@dataclass
class CombinedReportData:
    """Container for all analysis results"""
    function_comparison: Dict[str, Dict]
    hooks_missing: List[str]
    hooks_documented: List[str]
    localization_data: Dict
    argument_mismatches: List[Dict]  # New field for argument mismatches
    modules_data: List
    modules_scan: List[Dict]
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
            # Skip language files themselves
            if 'languages' in lua_file.parts:
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

    def _get_localization_keys_with_arg_counts(self) -> Dict[str, int]:
        """Get localization keys and count their expected format specifiers"""
        keys = {}

        if not Path(self.language_file).exists():
            return keys

        try:
            with open(self.language_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()

            # Parse LANGUAGE table entries
            # Pattern matches: key = "value" or key = 'value' or key = [[value]]
            pattern = r'(\w+)\s*=\s*(["\']|(\[\[))'

            for match in re.finditer(pattern, content):
                key = match.group(1)
                start_pos = match.end() - 1  # Position of the quote or bracket

                # Simple string parsing for format specifiers
                value, _ = self._parse_lua_string_simple(content, start_pos)
                if value:
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

    def _check_file_for_arg_mismatches(self, content: str, filename: str, lang_keys: Dict[str, int]) -> List[Dict]:
        """Check a single file for argument mismatches"""
        mismatches = []
        lines = content.split('\n')

        # Pattern for L("key", args...)
        l_pattern = r'\bL\s*\(\s*(["\']|(\[\[))'

        for match in re.finditer(l_pattern, content):
            start_pos = match.end() - 1
            key, end_pos = self._parse_lua_string_simple(content, start_pos)

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

            # Count arguments properly, handling nested function calls and strings
            arg_count = self._count_function_arguments(''.join(arg_content).strip())

            # Check if key exists and if argument count matches
            if key in lang_keys:
                expected = lang_keys[key]
                if arg_count != expected:
                    line_num = content[:match.start()].count('\n') + 1
                    mismatches.append({
                        'file': filename,
                        'line': line_num,
                        'function': 'L',
                        'key': key,
                        'expected': expected,
                        'provided': arg_count,
                        'context': lines[line_num - 1].strip() if line_num <= len(lines) else ''
                    })

        return mismatches

    def run_all_analyses(self) -> CombinedReportData:
        """Run all three analyses and combine results"""

        print("Running comprehensive analysis...")
        print("=" * 60)

        # 1. Function Documentation Comparison
        print("Analyzing function documentation...")
        function_results = self._run_function_comparison()

        # 2. Missing Hooks Analysis
        print("Analyzing hooks documentation...")
        hooks_missing, hooks_documented = self._run_hooks_analysis()

        # 3. Localization Analysis
        print("Analyzing localization...")
        localization_data, modules_data = self._run_localization_analysis()

        # 4. Argument Mismatch Detection
        print("Detecting argument mismatches...")
        argument_mismatches = self._detect_argument_mismatches()

        # 5. Module undocumented items scan (hooks and lia.* functions)
        print("Scanning external modules for undocumented items...")
        modules_scan = self._scan_modules_for_undocumented()

        return CombinedReportData(
            function_comparison=function_results,
            hooks_missing=hooks_missing,
            hooks_documented=hooks_documented,
            localization_data=localization_data,
            argument_mismatches=argument_mismatches,
            modules_data=modules_data,
            modules_scan=modules_scan,
            generated_at=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        )

    def _run_function_comparison(self) -> Dict[str, Dict]:
        """Run function documentation comparison analysis"""
        try:
            return self.function_comparator.compare_functions()
        except Exception as e:
            print(f"⚠️  Error in function comparison: {e}")
            return {}

    def _run_hooks_analysis(self) -> Tuple[List[str], List[str]]:
        """Run hooks documentation analysis"""
        try:
            hooks_found = scan_hooks(self.base_path / "gamemode")
            hooks_documented = self._read_all_documented_hooks()
            hooks_missing = [h for h in hooks_found if h not in hooks_documented]
            return sorted(hooks_missing), sorted(list(hooks_documented))
        except Exception as e:
            print(f"⚠️  Error in hooks analysis: {e}")
            return [], []

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

    def _run_localization_analysis(self) -> Tuple[Dict, List]:
        """Run localization analysis"""
        try:
            # Framework analysis
            framework_data = analyze_data(self.language_file, str(self.base_path))

            # Modules analysis
            modules = []
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
                        print(f"ℹ️  Skipping disabled module: {module_dir}")
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
            print(f"⚠️  Error in localization analysis: {e}")
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

        # Localization Section
        report_lines.extend(self._generate_localization_section(data))

        # Modules Section (in-report; do not create per-module files)
        try:
            report_lines.extend(self._generate_modules_section(data.modules_scan))
        except Exception as e:
            print(f"⚠️  Error generating modules section: {e}")

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
                    print(f"ℹ️  Skipping disabled module: {module_dir}")
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
            lines.append("### :package: Module Documentation Report")
            lines.append("")
            if undoc_hooks:
                lines.append("- **Undocumented Hooks:**")
                for h in undoc_hooks:
                    lines.append(f"  - `{h}`")
            if undoc_functions:
                if undoc_hooks:
                    lines.append("")
                lines.append("- **Undocumented lia.* Functions:**")
                for f in undoc_functions:
                    lines.append(f"  - `{f}`")
            lines.append("")

        # Summary table
        if modules_scan:
            lines.append("---")
            lines.append("")
            lines.append("# :clipboard: Module Documentation Summary")
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
                    print(f"ℹ️  Skipping disabled module: {module_dir}")
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
        lines = ["## 📊 Executive Summary", ""]

        # Function stats - use unique counts for display
        total_functions = sum(r.get('total_functions', 0) for r in data.function_comparison.values())
        total_documented = sum(r.get('documented_functions', 0) for r in data.function_comparison.values())
        total_missing = sum(len(r.get('missing_functions', [])) for r in data.function_comparison.values())
        total_missing_unique = sum(r.get('missing_functions_count', len(r.get('missing_functions', []))) for r in data.function_comparison.values())

        # Hooks stats
        hooks_missing_count = len(data.hooks_missing)

        # Localization stats
        undefined_calls = data.localization_data.get('undefined_count', len(data.localization_data.get('undefined_rows', []))) if data.localization_data else 0
        at_patterns = data.localization_data.get('at_pattern_count', len(data.localization_data.get('at_pattern_rows', []))) if data.localization_data else 0
        arg_mismatches = len(data.argument_mismatches)

        lines.extend([
            "### 📋 Function Documentation",
            f"- **Total Functions:** {total_functions}",
            f"- **Documented:** {total_documented} ({(total_documented/total_functions*100):.1f}%)" if total_functions > 0 else "- **Documented:** N/A",
            f"- **Missing Functions:** {total_missing} unique ({total_missing_unique} total occurrences)",
            "",
            "### 🎣 Hooks Documentation",
            f"- **Missing Hooks:** {hooks_missing_count}",
            f"- **Documented Hooks:** {len(data.hooks_documented)}",
            "",
            "### 🌐 Localization Analysis",
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
        lines = ["## 📋 Function Documentation Analysis", ""]

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
            f"### Summary Statistics",
            f"- **Files Analyzed:** {total_files}",
            f"- **Total Functions:** {total_functions}",
            f"- **Documented Functions:** {total_documented}",
            f"- **Missing Documentation:** {total_missing} unique ({total_missing_unique} total occurrences)",
            f"- **Coverage:** {(total_documented/total_functions*100):.1f}%" if total_functions > 0 else "- **Coverage:** N/A",
            "",
        ])

        # Global missing functions list
        all_missing = []
        for file_data in data.function_comparison.values():
            all_missing.extend(file_data.get('missing_functions', []))

        if all_missing:
            lines.extend([
                "### Missing Documentation (Global List)",
                f"Total: {len(set(all_missing))} unique functions across all files",
                "",
            ])
            for func in sorted(set(all_missing)):
                lines.append(f"- `{func}`")
            lines.append("")

        return lines

    def _generate_hooks_section(self, data: CombinedReportData) -> List[str]:
        """Generate hooks documentation section"""
        lines = ["## 🎣 Hooks Documentation Analysis", ""]

        if not data.hooks_missing and not data.hooks_documented:
            lines.append("_No hooks analysis data available._")
            lines.append("")
            return lines

        lines.extend([
            f"### Summary",
            f"- **Missing Hooks:** {len(data.hooks_missing)}",
            f"- **Documented Hooks:** {len(data.hooks_documented)}",
            "",
        ])

        if data.hooks_missing:
            lines.append("### Missing Hook Documentation:")
            for hook in data.hooks_missing:
                lines.append(f"- `{hook}`")
            lines.append("")

        return lines

    def _generate_localization_section(self, data: CombinedReportData) -> List[str]:
        """Generate localization analysis section"""
        lines = ["## 🌐 Localization Analysis", ""]

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
                "### ⚠️ Argument Mismatches",
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
                    lines.append(f"- **Line {mismatch['line']}:** `{mismatch['key']}`")
                    lines.append(f"  - Expected: {mismatch['expected']} args, Provided: {mismatch['provided']} args")
                    lines.append(f"  - Context: `{mismatch['context'][:80]}{'...' if len(mismatch['context']) > 80 else ''}`")
                lines.append("")

        # Issues summary (for backward compatibility)
        issues = []
        if data.localization_data and loc_data.get('undefined_rows'):
            issues.append(f"🔸 {len(loc_data['undefined_rows'])} undefined calls")
        if data.localization_data and loc_data.get('at_pattern_rows'):
            issues.append(f"🔸 {len(loc_data['at_pattern_rows'])} @xxxxx patterns")
        if data.argument_mismatches:
            issues.append(f"🔸 {len(data.argument_mismatches)} argument mismatches")

        if issues:
            lines.append("### Key Issues:")
            lines.extend(issues)
            lines.append("")

        # All issues (complete list) - only undefined calls for backward compatibility
        if data.localization_data and loc_data.get('undefined_rows'):
            lines.append("### Undefined Localization Calls:")
            for row in loc_data['undefined_rows']:
                lines.append(f"- `{row[4]}` in {row[0]}:{row[1]}:{row[2]} ({row[3]})")
            lines.append("")

        return lines

    def save_report(self, data: CombinedReportData, output_file: str = None):
        """Generate and save the comprehensive report"""
        # Ensure output directory exists
        DEFAULT_OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

        if output_file is None:
            output_file = str(DEFAULT_OUTPUT_DIR / "report.md")
        else:
            # If user provided a relative path, make it relative to DEFAULT_OUTPUT_DIR
            if not Path(output_file).is_absolute():
                output_file = str(DEFAULT_OUTPUT_DIR / output_file)

        report = self.generate_markdown_report(data)

        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(report)

        return output_file

def confirm_analysis_actions(base_path: Path, docs_path: Path, language_file: str,
                           modules_paths: List[str], output_dir: Path, force: bool = False,
                           no_module_docs: bool = False) -> Tuple[bool, bool, List[str]]:
    """Display analysis actions and get user confirmation

    Returns:
        Tuple[bool, bool, List[str]]: (proceed_with_analysis, generate_module_docs, approved_modules_paths)
    """
    if force:
        return True, not no_module_docs, modules_paths

    print("\n🔍 ANALYSIS CONFIRMATION")
    print("=" * 60)

    print("\n📁 MAIN DIRECTORIES TO SCAN:")
    print(f"   • Gamemode: {base_path}")
    print(f"   • Documentation: {docs_path}")
    print(f"   • Language file: {language_file}")

    print("\n📤 OUTPUT LOCATION:")
    print(f"   • Documentation directory: {output_dir}")
    print("   • The report.md file will be created/updated here")

    print("\n⚠️  POTENTIAL FILESYSTEM CHANGES:")
    print("   • The report.md file will be created/updated in the documentation directory")
    if not no_module_docs:
        print("   • 'docs' folders may be created in module directories")
        print("   • 'libraries.md' and 'hooks.md' files may be created in module docs folders")

    print("\n" + "=" * 60)

    # Ask about main analysis
    while True:
        response = input("Do you want to proceed with the main analysis? (y/n): ").strip().lower()
        if response in ['y', 'yes']:
            break
        elif response in ['n', 'no']:
            print("❌ Analysis cancelled by user.")
            return False, False, []
        else:
            print("Please enter 'y' for yes or 'n' for no.")

    # Module docs generation is controlled by the no_module_docs flag
    generate_module_docs = not no_module_docs

    # Ask about each module path individually
    approved_modules_paths = []
    print("\n📂 MODULE PATH CONFIRMATION:")
    print("-" * 40)

    for i, path in enumerate(modules_paths, 1):
        path_obj = Path(path)
        status = "✅ Exists" if path_obj.exists() else "❌ Missing"
        print(f"\n{i}. {path}")
        print(f"   Status: {status}")

        if not path_obj.exists():
            print("   ⚠️  Directory does not exist - skipping")
            continue

        while True:
            response = input(f"   Scan this module path? (y/n): ").strip().lower()
            if response in ['y', 'yes']:
                approved_modules_paths.append(path)
                print("   ✅ Added to scan list")
                break
            elif response in ['n', 'no']:
                print("   ❌ Skipped")
                break
            else:
                print("   Please enter 'y' for yes or 'n' for no.")

    if not approved_modules_paths:
        print("\n⚠️  No module paths approved for scanning.")
        while True:
            response = input("Continue with main analysis only? (y/n): ").strip().lower()
            if response in ['y', 'yes']:
                break
            elif response in ['n', 'no']:
                print("❌ Analysis cancelled by user.")
                return False, False, []
            else:
                print("Please enter 'y' for yes or 'n' for no.")

    print("\n✅ Proceeding with analysis...\n")
    return True, generate_module_docs, approved_modules_paths

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
  python function_comparison_report.py --force  # Skip confirmations
        """
    )
    parser.add_argument("--base-path", default=str(DEFAULT_GAMEMODE_ROOT),
                       help=f"Base path to gamemode directory (default: {DEFAULT_GAMEMODE_ROOT})")
    parser.add_argument("--docs-path", default=str(DEFAULT_DOCS_ROOT),
                       help=f"Path to documentation directory (default: {DEFAULT_DOCS_ROOT})")
    parser.add_argument("--language-file", default=str(DEFAULT_LANGUAGE_FILE),
                       help=f"Path to main language file (default: {DEFAULT_LANGUAGE_FILE})")
    parser.add_argument("--modules-path", action="append",
                       help=f"Paths to modules directories (default: {DEFAULT_MODULES_PATHS})")
    parser.add_argument("--output", "-o", help="Output file path (default: report.md)")
    parser.add_argument("--quiet", "-q", action="store_true", help="Suppress progress output")
    parser.add_argument("--force", "-f", action="store_true", help="Skip confirmation prompts")
    parser.add_argument("--no-module-docs", action="store_true", help="Skip generation of docs in module directories")

    args = parser.parse_args()

    # Validate paths
    base_path = Path(args.base_path)
    docs_path = Path(args.docs_path)

    if not base_path.exists():
        print(f"❌ Error: Base path does not exist: {base_path}")
        sys.exit(1)

    if not docs_path.exists():
        print(f"❌ Error: Documentation path does not exist: {docs_path}")
        sys.exit(1)

    # Handle modules paths
    modules_paths = args.modules_path if args.modules_path else [str(p) for p in DEFAULT_MODULES_PATHS]

    # Confirm analysis actions with user
    proceed, generate_module_docs, approved_modules_paths = confirm_analysis_actions(
        base_path, docs_path, args.language_file, modules_paths,
        DEFAULT_OUTPUT_DIR, args.force, args.no_module_docs
    )
    if not proceed:
        sys.exit(0)

    if not args.quiet:
        print("🚀 Starting comprehensive function comparison analysis...")
        print(f"📁 Base Path: {base_path}")
        print(f"📚 Docs Path: {docs_path}")
        print(f"📂 Approved Module Paths: {len(approved_modules_paths)}")
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
            print("\n✅ Analysis complete!")
            print(f"📄 Report saved: {report_file}")

            # Print quick summary
            total_functions = sum(r.get('total_functions', 0) for r in data.function_comparison.values())
            total_documented = sum(r.get('documented_functions', 0) for r in data.function_comparison.values())

            print("\n📈 Quick Summary:")
            print(f"   • Functions: {total_documented}/{total_functions} documented ({(total_documented/total_functions*100):.1f}%)" if total_functions > 0 else "   • Functions: No data")
            print(f"   • Missing hooks: {len(data.hooks_missing)}")
            print(f"   • Localization issues: {len(data.localization_data.get('unused', []))} unused, {len(data.localization_data.get('undefined_rows', []))} undefined")

    except Exception as e:
        print(f"ERROR during analysis: {e}")
        if not args.quiet:
            import traceback
            traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()


"""
Local browser dashboard for the Lilia function comparison report.
"""

import argparse
import json
import threading
import time
import traceback
import webbrowser
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional
from urllib.parse import urlparse



import os
import sys
import json
import re
import argparse
from pathlib import Path
from datetime import datetime
from typing import Any, Dict, List, Set, Tuple, Optional
from dataclasses import dataclass
from collections import defaultdict

HOOKS_REPORT_IGNORE = {
    "CalcStaminaChange",
    "IsValid",
    "getData",
    "setData",
    "PopulateInventoryItems",
    "ChatAddText",
    "OnCheaterCaught",
    "PlayerCheatDetected",
    "StorageCanTransferItem",
}

NET_MESSAGE_REPORT_IGNORE = {
    "wire_expression2_upload",
}

def _get_paths_from_file_location():
    """Determine paths based on the current file's location"""
    current_file = Path(__file__).resolve()
    file_path_str = str(current_file)

    
    if r"D:\GMOD\Server\garrysmod\gamemodes\Lilia\documentation\docs\tools" in file_path_str:
        
        lilia_root = Path(r"D:\GMOD\Server\garrysmod\gamemodes\Lilia")
        gamemode_root = lilia_root / "gamemode"
        docs_root = lilia_root / "documentation"
        language_file = gamemode_root / "languages" / "english.lua"
        
        metrorp_root = lilia_root.parent / "metrorp"
        modules_paths = [
            metrorp_root / "gitmodules",
            metrorp_root / "modules",
            
            
        ]
        output_dir = docs_root

    
    elif r"D:\GMOD\Server\garrysmod\gamemodes\Lilia\documentation\docs\tools" in file_path_str:
        
        lilia_root = Path(r"D:\GMOD\Server\garrysmod\gamemodes\Lilia")
        gamemode_root = lilia_root / "gamemode"
        docs_root = lilia_root / "documentation"
        language_file = gamemode_root / "languages" / "english.lua"
        
        metrorp_root = lilia_root.parent / "metrorp"
        modules_paths = [
            metrorp_root / "gitmodules",
            metrorp_root / "modules",
            
            
        ]
        output_dir = docs_root

    
    elif r"D:\Lilia\documentation\docs\tools" in file_path_str:
        
        lilia_root = Path(r"D:\Lilia")
        gamemode_root = lilia_root / "gamemode"
        docs_root = lilia_root / "documentation"
        language_file = gamemode_root / "languages" / "english.lua"
        
        modules_paths = [
            Path(r"D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules"),
            Path(r"D:\GMOD\Server\garrysmod\gamemodes\metrorp\modules"),
        ]
        output_dir = docs_root

    
    elif r"D:\GMOD\Server" in file_path_str or r"d:\gmod\server" in file_path_str.lower():
        
        
        current_dir = current_file.parent
        lilia_root = None
        check_dir = current_dir
        
        for _ in range(6):
            if (check_dir / "gamemode").exists() and (check_dir / "documentation").exists():
                lilia_root = check_dir
                break
            check_dir = check_dir.parent
        
        if lilia_root:
            gamemode_root = lilia_root / "gamemode"
            docs_root = lilia_root / "documentation"
            language_file = gamemode_root / "languages" / "english.lua"
            
            metrorp_root = lilia_root.parent / "metrorp"
            modules_paths = [
                metrorp_root / "gitmodules",
                metrorp_root / "modules",
            ]
            output_dir = docs_root
        else:
            
            lilia_root = Path(r"D:\GMOD\Server\garrysmod\gamemodes\Lilia")
            gamemode_root = lilia_root / "gamemode"
            docs_root = lilia_root / "documentation"
            language_file = gamemode_root / "languages" / "english.lua"
            metrorp_root = lilia_root.parent / "metrorp"
            modules_paths = [
                metrorp_root / "gitmodules",
                metrorp_root / "modules",
            ]
            output_dir = docs_root

    else:
        
        current_dir = current_file.parent

        
        lilia_root = None
        check_dir = current_dir

        
        for _ in range(6):  
            if (check_dir / "gamemode").exists() and (check_dir / "documentation").exists():
                lilia_root = check_dir
                break
            check_dir = check_dir.parent

        if lilia_root:
            gamemode_root = lilia_root / "gamemode"
            docs_root = lilia_root / "documentation"
            language_file = gamemode_root / "languages" / "english.lua"
            
            metrorp_root = lilia_root.parent / "metrorp"
            modules_paths = [
                metrorp_root / "gitmodules",
                metrorp_root / "modules",
                
                
            ]
            output_dir = docs_root
        else:
            
            print("Warning: Could not determine Lilia root from file location, using hardcoded defaults")
            gamemode_root = Path(r"D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode")
            docs_root = Path(r"D:\GMOD\Server\garrysmod\gamemodes\Lilia\documentation")
            language_file = Path(r"D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\languages\english.lua")
            
            lilia_root = Path(r"D:\GMOD\Server\garrysmod\gamemodes\Lilia")
            metrorp_root = lilia_root.parent / "metrorp"
            modules_paths = [
                metrorp_root / "gitmodules",
                metrorp_root / "modules",
                
                
            ]
            output_dir = docs_root

    return {
        'gamemode_root': gamemode_root,
        'docs_root': docs_root,
        'language_file': language_file,
        'modules_paths': modules_paths,
        'output_dir': output_dir
    }


_paths = _get_paths_from_file_location()

DEFAULT_GAMEMODE_ROOT = _paths['gamemode_root']
DEFAULT_DOCS_ROOT = _paths['docs_root']
DEFAULT_LANGUAGE_FILE = _paths['language_file']

if not DEFAULT_LANGUAGE_FILE.exists():
    
    script_dir = Path(__file__).parent
    potential_paths = [
        script_dir.parent.parent.parent / "gamemode" / "languages" / "english.lua",
        Path(r"D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\languages\english.lua"),
        Path(r"D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\languages\english.lua"),
    ]
    for path in potential_paths:
        if path.exists():
            DEFAULT_LANGUAGE_FILE = path
            break
DEFAULT_MODULES_PATHS = _paths['modules_paths']
DEFAULT_OUTPUT_DIR = _paths['output_dir']








"""
Function comparison module for analyzing Lua function documentation coverage.
"""

import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Set, Tuple, Optional
from dataclasses import dataclass



FUNCTIONS_NOT_TO_CHECK = {
    
    "lia.derma.menuPlayerSelector.btn_close.DoClick",

    
    "lia.gui.*",

    
}




FUNCTIONS_TO_CHECK = {
    
    "lia.util.*",
    "lia.config.*",
    "lia.database.*",
    "lia.admin.*",
    "lia.attribs.*",
    "lia.bar.*",
    "lia.char.*",
    "lia.chat.*",
    "lia.class.*",
    "lia.color.*",
    "lia.command.*",
    "lia.currency.*",
    "lia.darkrp.*",
    "lia.data.*",
    "lia.derma.*",
    "lia.dialog.*",
    "lia.doors.*",
    "lia.faction.*",
    "lia.flag.*",
    "lia.font.*",
    "lia.inventory.*",
    "lia.item.*",
    "lia.keybind.*",
    "lia.lang.*",
    "lia.loader.*",
    "lia.log.*",
    "lia.menu.*",
    "lia.module.*",
    "lia.net.*",
    "lia.notice.*",
    "lia.option.*",
    "lia.performance.*",
    "lia.playerinteract.*",
    "lia.thirdparty.*",
    "lia.time.*",
    "lia.vendor.*",
    "lia.webimage.*",
    "lia.websound.*",
    "lia.workshop.*",
    
    "characterMeta:*",
    "itemMeta:*",
    "inventoryMeta:*",
    "entityMeta:*",
    "panelMeta:*",
    "playerMeta:*",
    
}


def should_check_function(func_name):
    """
    Determine if a function should be checked for documentation.

    Args:
        func_name (str): The name of the function to check

    Returns:
        bool: True if the function should be checked, False otherwise
    """

def should_check_function(func_name):
    """
    Determine if a function should be checked for documentation.

    Args:
        func_name (str): The name of the function to check

    Returns:
        bool: True if the function should be checked, False otherwise
    """
    
    if func_name in FUNCTIONS_NOT_TO_CHECK:
        return False

    
    for pattern in FUNCTIONS_NOT_TO_CHECK:
        if pattern.endswith("*") and func_name.startswith(pattern[:-1]):
            return False

    
    for pattern in FUNCTIONS_TO_CHECK:
        if func_name.startswith(pattern.replace("*", "")):
            return True

    
    return True

def get_exclusion_reason(func_name):
    """
    Get the reason why a function is excluded from checking.
    
    Args:
        func_name (str): The name of the function
        
    Returns:
        str: Reason for exclusion, or None if not excluded
    """
    FUNCTIONS_NOT_TO_CHECK = {
        "lia.derma.menuPlayerSelector.btn_close.DoClick",
    }
    
    if func_name in FUNCTIONS_NOT_TO_CHECK:
        return "Explicitly excluded from documentation checking"
    return None


@dataclass
class FunctionInfo:
    """Information about a function"""
    name: str
    line_number: int
    is_server_only: bool = False
    is_client_only: bool = False
    parameters: List[str] = None
    description: str = ""

    def __post_init__(self):
        if self.parameters is None:
            self.parameters = []


class LuaFunctionExtractor:
    """Extracts functions from Lua files"""

    def __init__(self, base_path: str):
        self.base_path = Path(base_path)

    def extract_functions_from_file(self, file_path: str) -> Dict[str, FunctionInfo]:
        """Extract all functions from a single Lua file"""
        functions = {}

        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
        except Exception as e:
            print(f"Warning: Could not read {file_path}: {e}")
            return functions

        lines = content.split('\n')

        for line_num, line in enumerate(lines, 1):
            func_name = None
            params = ""
            
            
            match1 = re.search(r'^\s*function\s+(lia\.[A-Za-z_][\w\.]*)\s*\(([^)]*)\)', line)
            if match1:
                func_name = match1.group(1)
                params = match1.group(2)
            else:
                
                match2 = re.search(r'^\s*(lia\.[A-Za-z_][\w\.]*)\s*=\s*function\s*\(([^)]*)\)', line)
                if match2:
                    func_name = match2.group(1)
                    params = match2.group(2)
                else:
                    
                    
                    match3 = re.search(r'^\s*function\s+([A-Za-z_]*Meta):([A-Za-z_][\w]*)\s*\(([^)]*)\)', line)
                    if match3:
                        meta_table = match3.group(1)
                        method_name = match3.group(2)
                        params = match3.group(3)
                        
                        func_name = f"{meta_table}:{method_name}"
                    else:
                        continue  

            if func_name:
                
                if not should_check_function(func_name):
                    continue  

                
                param_list = []
                if params and params.strip():
                    param_list = [p.strip() for p in params.split(',') if p.strip()]

                
                is_server = self._is_server_realm(content, line_num)
                is_client = self._is_client_realm(content, line_num)

                functions[func_name] = FunctionInfo(
                    name=func_name,
                    line_number=line_num,
                    is_server_only=is_server and not is_client,
                    is_client_only=is_client and not is_server,
                    parameters=param_list
                )

        return functions

    def _is_server_realm(self, content: str, line_num: int) -> bool:
        """Check if function is in server realm"""
        lines = content.split('\n')
        start_line = max(0, line_num - 20)  

        for i in range(start_line, line_num):
            line = lines[i].strip().lower()
            if 'if server' in line or 'if (server)' in line:
                return True
            if 'if client' in line or 'if (client)' in line:
                return False
            if 'server' in line and ('then' in line or '{' in line):
                return True

        return False

    def _is_client_realm(self, content: str, line_num: int) -> bool:
        """Check if function is in client realm"""
        lines = content.split('\n')
        start_line = max(0, line_num - 20)  

        for i in range(start_line, line_num):
            line = lines[i].strip().lower()
            if 'if client' in line or 'if (client)' in line:
                return True
            if 'if server' in line or 'if (server)' in line:
                return False
            if 'client' in line and ('then' in line or '{' in line):
                return True

        return False

    def extract_all_functions(self) -> Dict[str, Dict[str, FunctionInfo]]:
        """Extract functions from all Lua files in the gamemode"""
        all_functions = {}

        
        for root, dirs, files in os.walk(self.base_path):
            
            dirs[:] = [d for d in dirs if d not in ['node_modules', '.git', 'docs', 'documentation']]

            for file in files:
                if file.endswith('.lua'):
                    file_path = os.path.join(root, file)
                    relative_path = os.path.relpath(file_path, self.base_path)

                    functions = self.extract_functions_from_file(file_path)
                    if functions:
                        all_functions[relative_path] = functions

        return all_functions


class DocumentationParser:
    """Parses documentation files to extract documented functions"""

    def __init__(self, docs_path: str):
        self.docs_path = Path(docs_path)

    def _existing_doc_dirs(self, *relative_paths: str) -> List[Path]:
        """Return existing documentation directories in preferred order."""
        return [
            self.docs_path.joinpath(*parts.split("/"))
            for parts in relative_paths
            if self.docs_path.joinpath(*parts.split("/")).exists()
        ]

    def extract_documented_functions(self) -> Dict[str, Dict[str, FunctionInfo]]:
        """Extract all documented functions from documentation files"""
        documented_functions = {}

        
        library_dirs = self._existing_doc_dirs(
            "docs/developer/libraries",
            "docs/development/libraries",
            "docs/libraries",
        )
        for libraries_path in library_dirs:
            prefix = ""
            if libraries_path.parts[-2:] == ("docs", "libraries"):
                prefix = "old/"

            for md_file in libraries_path.glob("*.md"):
                
                if md_file.name == "index.md":
                    continue
                functions = self._parse_library_file(md_file)
                if functions:
                    documented_functions[f"{prefix}{md_file.name}"] = functions

        meta_dirs = self._existing_doc_dirs(
            "docs/developer/meta",
            "docs/development/meta",
            "docs/meta",
        )
        for meta_path in meta_dirs:
            prefix = "meta/"
            if meta_path.parts[-2:] == ("docs", "meta"):
                prefix = "old/meta/"

            for md_file in meta_path.glob("*.md"):
                functions = self._parse_meta_file(md_file)
                if functions:
                    documented_functions[f"{prefix}{md_file.name}"] = functions

        return documented_functions

    def _parse_library_file(self, file_path: Path) -> Dict[str, FunctionInfo]:
        """Parse a library documentation file"""
        functions = {}

        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
        except Exception as e:
            print(f"Warning: Could not read {file_path}: {e}")
            return functions

        lines = content.split('\n')

        
        library_name = file_path.stem
        try:
            
            m = re.search(r"\(`(lia(?:\.[\w\.]+)?)`\)", content)
            if m:
                library_name = m.group(1)
        except Exception:
            pass

        
        global_lia_functions = {
            'bootstrap', 'error', 'warning', 'information', 'relaydiscordMessage'
        }
        is_core_library_page = file_path.stem == "lia.core"

        
        for line_num, line in enumerate(lines, 1):
            stripped = line.strip()

            
            func_match = re.search(r'^###+\s+([A-Za-z_][\w\.]*)\s*$', stripped)
            if func_match:
                header_name = func_match.group(1)
                
                
                if '.' in header_name:
                    qualified_name = header_name
                else:
                    
                    if not is_core_library_page and header_name not in global_lia_functions:
                        continue
                    
                    if header_name in global_lia_functions:
                        qualified_name = f"lia.{header_name}"
                    else:
                        
                        qualified_name = f"{library_name}.{header_name}"
                
                
                params = self._extract_parameters_from_docs(lines, line_num)

                functions[qualified_name] = FunctionInfo(
                    name=qualified_name,
                    line_number=line_num,
                    parameters=params
                )

        
        summary_pattern = re.compile(
            r'<summary\b[^>]*>.*?<a[^>]*></a>\s*([A-Za-z_][\w\.:]*)\(([^)]*)\)',
            re.DOTALL,
        )
        for match in summary_pattern.finditer(content):
            func_name = match.group(1).strip()
            
            line_num = content[:match.start()].count('\n') + 1
            params_str = match.group(2)
            params = [p.strip() for p in params_str.split(',') if p.strip()] if params_str.strip() else []
            
            
            if '.' in func_name:
                qualified_name = func_name
            else:
                
                if not is_core_library_page and func_name not in global_lia_functions:
                    continue
                
                if func_name in global_lia_functions:
                    qualified_name = f"lia.{func_name}"
                else:
                    
                    qualified_name = f"{library_name}.{func_name}"
            
            
            if qualified_name not in functions:
                functions[qualified_name] = FunctionInfo(
                    name=qualified_name,
                    line_number=line_num,
                    parameters=params
                )

        return functions

    def _extract_parameters_from_docs(self, lines: List[str], start_line: int) -> List[str]:
        """Extract parameters from documentation following a function header"""
        params = []

        
        in_params_section = False
        for i in range(start_line, min(start_line + 50, len(lines))):  
            line = lines[i].strip()

            if line.lower() == '**parameters**':
                in_params_section = True
                continue
            elif line.startswith('**') and in_params_section:
                
                break
            elif in_params_section and line.startswith('* `'):
                
                param_match = re.search(r'\* `([^`]+)`', line)
                if param_match:
                    params.append(param_match.group(1))

        return params

    def _parse_meta_file(self, file_path: Path) -> Dict[str, FunctionInfo]:
        """Parse a meta documentation file"""
        functions = {}

        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
        except Exception as e:
            print(f"Warning: Could not read {file_path}: {e}")
            return functions

        lines = content.split('\n')
        
        
        stem = file_path.stem
        overrides = {
            'tool': 'toolGunMeta',
        }
        meta_table = overrides.get(stem, f"{stem}Meta")

        
        
        
        for line_num, line in enumerate(lines, 1):
            stripped = line.strip()
            
            
            method_match = re.search(r'^###+\s+([A-Za-z_][\w]*)\s*$', stripped)
            if method_match:
                method_name = method_match.group(1)
                
                params = self._extract_parameters_from_docs(lines, line_num)

                
                qualified_name = f"{meta_table}:{method_name}"
                functions[qualified_name] = FunctionInfo(
                    name=qualified_name,
                    line_number=line_num,
                    parameters=params
                )
            else:
                
                method_match = re.search(r'`([A-Za-z_][\w\.:]*)\(([^)]*)\)`', line)
                if method_match:
                    method_name = method_match.group(1)
                    params_str = method_match.group(2)
                    params = [p.strip() for p in params_str.split(',') if p.strip()]

                    
                    if ':' in method_name and method_name.split(':', 1)[0].endswith('Meta'):
                        qualified_name = method_name
                    else:
                        qualified_name = f"{meta_table}:{method_name}"

                    functions[qualified_name] = FunctionInfo(
                        name=qualified_name,
                        line_number=line_num,
                        parameters=params
                    )

        
        summary_pattern = re.compile(
            r'<summary\b[^>]*>.*?<a[^>]*></a>\s*([A-Za-z_][\w\.:]*)\(([^)]*)\)',
            re.DOTALL,
        )
        for match in summary_pattern.finditer(content):
            method_name = match.group(1).strip()
            
            line_num = content[:match.start()].count('\n') + 1
            
            params_str = match.group(2)
            params = [p.strip() for p in params_str.split(',') if p.strip()] if params_str.strip() else []
            
            
            qualified_name = f"{meta_table}:{method_name}"
            
            
            if qualified_name not in functions:
                functions[qualified_name] = FunctionInfo(
                    name=qualified_name,
                    line_number=line_num,
                    parameters=params
                )

        return functions


class FunctionComparator:
    """Compares functions between code and documentation"""

    def __init__(self, base_path: str, docs_path: str = None):
        self.base_path = Path(base_path)
        self.docs_path = Path(docs_path) if docs_path else self.base_path.parent / "documentation"

        self.extractor = LuaFunctionExtractor(str(self.base_path))
        self.parser = DocumentationParser(str(self.docs_path))

    def compare_functions(self) -> Dict[str, Dict]:
        """Compare functions between code and documentation"""
        print("Extracting functions from code...")
        code_functions = self.extractor.extract_all_functions()

        print(f"Found {sum(len(funcs) for funcs in code_functions.values())} functions in code")
        print("Extracting functions from documentation...")
        doc_functions = self.parser.extract_documented_functions()

        print("Comparing functions...")
        comparison_results = {}

        
        all_code_functions = set()
        for file_functions in code_functions.values():
            all_code_functions.update(file_functions.keys())

        
        all_documented_functions = set()
        for doc_file_functions in doc_functions.values():
            all_documented_functions.update(doc_file_functions.keys())

        
        
        excluded_functions = {'L'}  
        filtered_documented = {func for func in all_documented_functions if func not in excluded_functions}
        extra_documented = sorted(filtered_documented - all_code_functions)

        
        for file_path, functions in code_functions.items():
            file_comparison = self._compare_file_functions(file_path, functions, doc_functions)
            if file_comparison:
                comparison_results[file_path] = file_comparison

        # Keep this separate from the documentation comparison.  A function can
        # be documented and still never be used by the gamemode.  The usage scan
        # understands local library aliases, for example:
        #
        #     local keybind = lia.keybind
        #     keybind.add(...)
        #
        # The alias declaration itself is not treated as a function use.
        unused_functions = self._find_unused_lilia_functions(code_functions)
        for file_path, file_comparison in comparison_results.items():
            file_unused = unused_functions.get(file_path, [])
            file_comparison['unused_functions'] = file_unused
            file_comparison['unused_functions_count'] = len(file_unused)

        
        if comparison_results and extra_documented:
            first_file = next(iter(comparison_results.keys()))
            comparison_results[first_file]['extra_documented'] = extra_documented
            comparison_results[first_file]['extra_documented_count'] = len(extra_documented)

        return comparison_results

    def _find_unused_lilia_functions(
        self, code_functions: Dict[str, Dict[str, FunctionInfo]]
    ) -> Dict[str, List[str]]:
        """Return defined Lilia functions that have no usage in Lua code.

        Local aliases are resolved per file.  This prevents registrations such
        as ``local keybind = lia.keybind`` from being reported as usages while
        still recognizing calls such as ``keybind.add(...)``.
        """
        all_functions = {
            function_name
            for functions in code_functions.values()
            for function_name in functions
            if function_name.startswith("lia.")
        }
        used_functions: Set[str] = set()
        # Only declaration forms should suppress a matching name on that
        # line.  The previous lookahead alternative (``(?=lia\.)``) also
        # matched ordinary calls such as ``lia.admin.createGroup(...)`` when
        # they appeared at the start of a line, causing those calls to be
        # thrown away as if they were definitions.
        definition_pattern = re.compile(
            r"^\s*(?:function\s+|)"
            r"(lia\.[A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*)"
            r"\s*=\s*function\b|"
            r"^\s*function\s+"
            r"(lia\.[A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*)\s*\("
        )
        alias_pattern = re.compile(
            r"\blocal\s+([A-Za-z_]\w*)\s*=\s*(lia(?:\.[A-Za-z_]\w*)*)\b"
        )
        path_pattern = re.compile(r"\blia(?:\.[A-Za-z_]\w*)+")

        for root, dirs, files in os.walk(self.base_path):
            dirs[:] = [
                directory for directory in dirs
                if directory not in {"node_modules", ".git", "docs", "documentation"}
            ]
            for file_name in files:
                if not file_name.endswith(".lua"):
                    continue

                file_path = Path(root) / file_name
                try:
                    content = file_path.read_text(encoding="utf-8", errors="ignore")
                except OSError:
                    continue

                aliases = {
                    alias: library_path
                    for alias, library_path in alias_pattern.findall(content)
                }
                relative_path = os.path.relpath(file_path, self.base_path)
                for line in content.splitlines():
                    # Do not count a function's declaration as a call/reference.
                    definition_match = definition_pattern.match(line)
                    defined_name = next(
                        (group for group in definition_match.groups() if group),
                        None,
                    ) if definition_match else None

                    # The right-hand side of a local alias is registration/setup,
                    # not a call to the library function being audited.
                    is_alias_declaration = bool(alias_pattern.search(line))
                    if not is_alias_declaration:
                        for referenced_name in path_pattern.findall(line):
                            if referenced_name in all_functions and referenced_name != defined_name:
                                used_functions.add(referenced_name)

                    for alias, library_path in aliases.items():
                        for function_name in all_functions:
                            prefix = f"{library_path}."
                            if not function_name.startswith(prefix):
                                continue
                            suffix = function_name[len(prefix):]
                            if re.search(rf"\b{re.escape(alias)}\.{re.escape(suffix)}\b", line):
                                if function_name != defined_name:
                                    used_functions.add(function_name)

        unused_by_file = {}
        for file_path, functions in code_functions.items():
            unused = sorted(
                function_name
                for function_name in functions
                if function_name.startswith("lia.") and function_name not in used_functions
            )
            if unused:
                unused_by_file[file_path] = unused
        return unused_by_file

    def _extract_base_function_name(self, full_name: str) -> str:
        """Extract base function name from dotted name (e.g., 'lia.administrator.hasAccess' -> 'hasAccess')"""
        if '.' in full_name:
            return full_name.split('.')[-1]
        return full_name

    def _compare_file_functions(self, file_path: str, code_functions: Dict[str, FunctionInfo],
                               doc_functions: Dict[str, Dict[str, FunctionInfo]]) -> Dict:
        """Compare functions for a single file"""
        
        all_documented = {}
        for doc_file, funcs in doc_functions.items():
            for func_name, func_info in funcs.items():
                all_documented[func_name] = func_info

        
        documented_in_file = {}
        missing_functions = []

        for func_name, func_info in code_functions.items():
            
            is_documented = False

            
            if func_name in all_documented:
                is_documented = True
            else:
                
                if ':' in func_name and func_name.split(':', 1)[0].endswith('Meta'):
                    if func_name in all_documented:
                        is_documented = True
                else:
                    
                    if func_name.startswith('lia.'):
                        
                        if func_name in all_documented:
                            is_documented = True
                        else:
                            base_name = self._extract_base_function_name(func_name)
                            if base_name in all_documented:
                                is_documented = True

            if is_documented:
                documented_in_file[func_name] = func_info
            else:
                missing_functions.append(func_name)

        
        
        extra_documented = []

        
        unique_missing = sorted(set(missing_functions))
        unique_extra = sorted(set(extra_documented))

        return {
            'total_functions': len(code_functions),
            'documented_functions': len(documented_in_file),
            'missing_functions': unique_missing,
            'extra_documented': unique_extra,
            'functions': {name: {
                'line_number': info.line_number,
                'is_server_only': info.is_server_only,
                'is_client_only': info.is_client_only,
                'parameters': info.parameters
            } for name, info in code_functions.items()},
            
            'missing_functions_count': len(missing_functions),
            'extra_documented_count': len(extra_documented)
        }


"""
Hook analysis module for finding missing hook documentation.
"""

import os
import re
from pathlib import Path
from typing import List, Set



GMOD_HOOKS_BLACKLIST = {
    "AcceptInput", "AddDeathNotice", "AdjustMouseSensitivity", "AllowPlayerPickup",
    "CalcMainActivity", "CalcVehicleView", "CalcView", "CalcViewModelView",
    "CanCreateUndo", "CanEditVariable", "CanExitVehicle", "CanPlayerEnterVehicle",
    "CanPlayerSuicide", "CanPlayerUnfreeze", "CanProperty", "CanUndo",
    "CaptureVideo", "ChatText", "ChatTextChanged", "CheckPassword",
    "ClientSignOnStateChanged", "CloseDermaMenus", "CreateClientsideRagdoll",
    "CreateEntityRagdoll", "CreateMove", "CreateTeams", "DoAnimationEvent",
    "DoPlayerDeath", "DrawDeathNotice", "DrawMonitors", "DrawOverlay",
    "DrawPhysgunBeam", "EndEntityDriving", "EntityEmitSound", "EntityFireBullets",
    "EntityKeyValue", "EntityNetworkedVarChanged", "EntityRemoved", "EntityTakeDamage",
    "FindUseEntity", "FinishChat", "FinishMove", "ForceDermaSkin",
    "GameContentChanged", "GetDeathNoticeEntityName", "GetFallDamage",
    "GetGameDescription", "GetMotionBlurValues", "GetPreferredCarryAngles",
    "GetTeamColor", "GetTeamNumColor", "GrabEarAnimation", "GravGunOnDropped",
    "GravGunOnPickedUp", "GravGunPickupAllowed", "GravGunPunt", "GUIMouseDoublePressed",
    "GUIMousePressed", "GUIMouseReleased", "HandlePlayerArmorReduction",
    "HandlePlayerDriving", "HandlePlayerDucking", "HandlePlayerJumping",
    "HandlePlayerLanding", "HandlePlayerNoClipping", "HandlePlayerSwimming",
    "HandlePlayerVaulting", "HideTeam", "HUDAmmoPickedUp", "HUDDrawPickupHistory",
    "HUDDrawScoreBoard", "HUDDrawTargetID", "HUDItemPickedUp", "HUDPaint",
    "HUDPaintBackground", "HUDShouldDraw", "HUDWeaponPickedUp", "Initialize",
    "InitPostEntity", "InputMouseApply", "IsSpawnpointSuitable", "KeyPress",
    "KeyRelease", "LoadGModSave", "LoadGModSaveFailed", "MenuStart",
    "MouthMoveAnimation", "Move", "NeedsDepthPass", "NetworkEntityCreated",
    "NetworkIDValidated", "NotifyShouldTransmit", "OnAchievementAchieved",
    "OnChatTab", "OnCleanup", "OnClientLuaError", "OnCloseCaptionEmit",
    "OnContextMenuClose", "OnContextMenuOpen", "OnCrazyPhysics",
    "OnDamagedByExplosion", "OnEntityCreated", "OnEntityWaterLevelChanged",
    "OnGamemodeLoaded", "OnLuaError", "OnNotifyAddonConflict", "OnNPCDropItem",
    "OnNPCKilled", "OnPauseMenuBlockedTooManyTimes", "OnPauseMenuShow",
    "OnPermissionsChanged", "OnPhysgunFreeze", "OnPhysgunPickup",
    "OnPhysgunReload", "OnPlayerChangedTeam", "OnPlayerChat", "OnPlayerHitGround",
    "OnPlayerJump", "OnPlayerPhysicsDrop", "OnPlayerPhysicsPickup",
    "OnReloaded", "OnScreenSizeChanged", "OnSpawnMenuClose", "OnSpawnMenuOpen",
    "OnTextEntryGetFocus", "OnTextEntryLoseFocus", "OnUndo", "OnViewModelChanged",
    "PhysgunDrop", "PhysgunPickup", "PlayerAmmoChanged", "PlayerAuthed",
    "PlayerBindPress", "PlayerButtonDown", "PlayerButtonUp",
    "PlayerCanHearPlayersVoice", "PlayerCanJoinTeam", "PlayerCanPickupItem",
    "PlayerCanPickupWeapon", "PlayerCanSeePlayersChat", "PlayerChangedTeam",
    "PlayerCheckLimit", "PlayerClassChanged", "PlayerConnect", "PlayerDeath", "PlayerDisconnect",
    "PlayerDeathSound", "PlayerDeathThink", "PlayerDisconnected",
    "PlayerDriveAnimate", "PlayerDroppedWeapon", "PlayerEndVoice",
    "PlayerEnteredVehicle", "PlayerFireAnimationEvent", "PlayerFootstep",
    "PlayerFrozeObject", "PlayerHandleAnimEvent", "PlayerHurt",
    "PlayerInitialSpawn", "PlayerJoinTeam", "PlayerLeaveVehicle",
    "PlayerLoadout", "PlayerNoClip", "PlayerPostThink", "PlayerRequestTeam",
    "PlayerSay", "PlayerSelectSpawn", "PlayerSelectTeamSpawn",
    "PlayerSetHandsModel", "PlayerSetModel", "PlayerShouldAct", "PlayerShouldTakeDamage",
    "PlayerShouldTaunt", "PlayerSilentDeath", "PlayerSpawn",
    "PlayerSpawnAsSpectator", "PlayerSpray", "PlayerStartTaunt",
    "PlayerStartVoice", "PlayerStepSoundTime", "PlayerSwitchFlashlight",
    "PlayerSwitchWeapon", "PlayerTick", "PlayerTraceAttack",
    "PlayerUnfrozeObject", "PlayerUse", "PopulateMenuBar", "PostCleanupMap",
    "PostDraw2DSkyBox", "PostDrawEffects", "PostDrawHUD",
    "PostDrawOpaqueRenderables", "PostDrawPlayerHands", "PostDrawSkyBox",
    "PostDrawTranslucentRenderables", "PostDrawViewModel",
    "PostEntityFireBullets", "PostEntityTakeDamage", "PostGamemodeLoaded",
    "PostPlayerDeath", "PostPlayerDraw", "PostProcessPermitted", "PostRender",
    "PostRenderVGUI", "PostUndo", "PreCleanupMap", "PreDrawEffects",
    "PreDrawHalos", "PreDrawHUD", "PreDrawOpaqueRenderables",
    "PreDrawPlayerHands", "PreDrawSkyBox", "PreDrawTranslucentRenderables",
    "PreDrawViewModel", "PreDrawViewModels", "PreGamemodeLoaded",
    "PrePlayerDraw", "PreRegisterSENT", "PreRegisterSWEP", "PreRender",
    "PreUndo", "PreventScreenClicks", "PropBreak", "RenderScene",
    "RenderScreenspaceEffects", "Restored", "Saved", "ScaleNPCDamage",
    "ScalePlayerDamage", "ScoreboardHide", "ScoreboardShow", "SendDeathNotice",
    "SetPlayerSpeed", "SetupMove", "SetupPlayerVisibility", "SetupSkyboxFog",
    "SetupWorldFog", "ShouldCollide", "ShouldDrawLocalPlayer", "ShowHelp",
    "ShowSpare1", "ShowSpare2", "ShowTeam", "ShutDown", "SpawniconGenerated",
    "SpawnMenuCreated", "StartChat", "StartCommand", "StartEntityDriving",
    "StartGame", "Think", "Tick", "TranslateActivity", "UpdateAnimation",
    "VariableEdited", "VehicleMove", "VGUIMousePressAllowed", "VGUIMousePressed",
    "WeaponEquip", "WorkshopDownloadedFile", "WorkshopDownloadFile",
    "WorkshopDownloadProgress", "WorkshopDownloadTotals", "WorkshopEnd",
    "WorkshopExtractProgress", "WorkshopStart", "WorkshopSubscriptionsChanged",
    "WorkshopSubscriptionsMessage",     "WorkshopSubscriptionsProgress",
    
    "AddGamemodeToolMenuCategories", "AddGamemodeToolMenuTabs", "AddToolMenuCategories",
    "AddToolMenuTabs", "CanArmDupe", "CanDrive", "CanTool", "ContentSidebarSelection",
    "ContextMenuClosed", "ContextMenuCreated", "ContextMenuEnabled", "ContextMenuOpen",
    "ContextMenuOpened", "ContextMenuShowTool", "OnRevertSpawnlist", "OnSaveSpawnlist",
    "OpenToolbox", "PaintNotes", "PaintWorldTips", "PersistenceLoad", "PersistenceSave",
    "PlayerGiveSWEP", "PlayerSpawnedEffect", "PlayerSpawnedNPC", "PlayerSpawnedProp",
    "PlayerSpawnedRagdoll", "PlayerSpawnedSENT", "PlayerSpawnedSWEP", "PlayerSpawnedVehicle",
    "PlayerSpawnEffect", "PlayerSpawnNPC", "PlayerSpawnObject", "PlayerSpawnProp",
    "PlayerSpawnRagdoll", "PlayerSpawnSENT", "PlayerSpawnSWEP", "PlayerSpawnVehicle",
    "PopulateContent", "PopulateEntities", "PopulateNPCs", "PopulatePropMenu",
    "PopulateToolMenu", "PopulateVehicles", "PopulateWeapons", "PostReloadToolsMenu",
    "PreRegisterTOOL", "PreReloadToolsMenu", "SpawnlistContentChanged",
    "SpawnlistOpenGenericMenu", "SpawnMenuEnabled", "SpawnmenuIconMenuOpen",
    "SpawnMenuOpen", "SpawnMenuOpened",
    
    "CAMI.OnPrivilegeRegistered", "CAMI.OnPrivilegeUnregistered", "CAMI.OnUsergroupRegistered",
    "CAMI.OnUsergroupUnregistered", "CAMI.PlayerHasAccess", "CAMI.PlayerUsergroupChanged",
    "CAMI.SteamIDUsergroupChanged",
    
    "server_addban", "server_removeban", "serverguard.RankPermissionGiven",
    "serverguard.RankPermissionTaken", "serverguard.RanksLoaded", "VC_canAddMoney",
    "VC_canAfford", "VC_canRemoveMoney", "ULibGroupAccessChanged", "SAM.CanRunCommand",
    "SAM.RankPermissionGiven", "SAM.RankPermissionTaken", "PAC3RegisterEvents",
    "PermaProps.CanPermaProp", "PermaProps.OnEntityCreated", "PermaProps.OnEntitySaved",
    "simfphysUse", "CheckValidSit", "simfphysPhysicsCollide",
    
    "ArcCW_PlayerCanShoot", "ArcCW_PlayerReload", "ArcCW_PlayerShoot",
    
    "player_disconnect", "player_spawn", "PlayerAccessorChanged",
    
    "canDarkRPUse", "canLockpick", "InputMouseAppl_", "lockpickCompleted",
    "onKeysMenuOpened", "playerBoughtCustomEntity", "playerBuyDoor",
    "YorkshireRP_PropertyPurchased", "zlockpick_success",
    
    "AdvDupe_FinishPasting", "PrePACEditorOpen", "pac_CanWearParts", "SAM.LoadedRanks",
    
    "SuppressHint",
    
    "GetSetting", "GetValidatedData", "SaveComplexData", "SaveSettings"
}



FRAMEWORK_HOOKS_WHITELIST = {
    "AddEssentialItems", "AddFactionEquipment", "AnalyzeCharacterListChanges",
    "ApplyBackgroundEffects", "ApplyCharacterSettings", "ApplyChatFilters",
    "ApplyContentFilters", "ApplyEconomicModifiers", "ApplyFactionModifications",
    "ApplyMenuPreferences", "ApplyMenuTheme", "ApplyServerModifiers",
    "ApplyStartingBonuses", "ArchiveCharacterData", "AreClassesRelated",
    "AttemptDiscordRecovery", "CalculateDynamicFactionLimit", "CalculateEffectiveMemberCount",
    "CalculatePerformanceBonus", "CanLockDoor", "CanSetDoorPrice", "CanToggleDoorOwnable",
    "CanToggleDoorVisibility", "CancelPendingCharacterOperations", "CharacterMeetsPrerequisites",
    "CheckAdvancedFlagInheritance", "CheckCommandAbuse", "CheckConditionalFlags",
    "CheckDeletionTriggers", "CheckFactionClassFlags", "CheckFlagInheritance",
    "CleanupCharacterPreviews", "CleanupCharacterReferences", "CleanupDoorOwnership",
    "CleanupQuestData", "CleanupQuestOnCharDelete", "CleanupTemporaryPanels",
    "ClearCharacterCache", "ConfigureMainChatPanel", "CreateAppearanceStep",
    "CreateBackgroundStoryStep", "CreateCategoryTabs", "CreateCharacterBackup",
    "CreateCustomInventory", "CreateEquipmentStep", "CreateFactionSpecificStep",
    "CreateReviewStep", "CreateSearchBar", "CreateSkillsStep", "CustomCharacterValidation",
    "EnhanceHUDWithCharacterInfo", "ExecutePostCommandActions", "ExecuteTriggerAction",
    "FactionWouldUnbalanceServer", "FilterDiscordContent", "FinalCharacterValidation",
    "GenerateCharacterAnalytics", "GenerateCharacterGoals", "GetBackgroundBonuses",
    "GetBaseSalary", "GetCharacterChanges", "GetEquippedWeight", "GetFactionIcon",
    "GetFactionMemberStats", "GetFactionModels", "GetFactionSalaryMultiplier",
    "GetInventoryWeight", "GetPlayerCharacterCount", "GetPlayerProtectionLevel",
    "GetRecentPlayerCommands", "GetStartingEquipment", "GetTotalAchievements",
    "GetTraitBonuses", "GetXPForLevel", "HandleCharacterSwitch", "HandleCommandAbuse",
    "HandleMechanicalLock", "HandleSoulboundItems", "HandleSpecialCharacterSelection",
    "HasCharacterChanged", "HasDoorTogglePermission", "HasFactionJoinOverride",
    "HideDoorWithEffect", "ITEM", "InitializeAnalyticsTracking", "InitializeCharacterData",
    "InitializeCharacterPermissions", "InitializeCharacterPreviews", "InitializeCharacterRelationships",
    "InitializeChatFilters", "InitializeMenuSounds", "IsDoorOwner", "IsFactionAlly",
    "IsFactionHostile", "IsInFactionQueue", "IsNameTaken", "IsOnFactionRecruitmentCooldown",
    "IsSpamCommand", "IsValidCharacterModel", "IsValidSkin", "LoadCharacterMenuPreferences",
    "LoadDataFromFile", "LogCharacterCreation", "LogFailedSelection", "LogSuccessfulSelection",
    "MODULE", "MeetsFactionDiversityRequirements", "NotifyStaffOfDiscordOutage",
    "ParseChatMessageArgs", "PreProcessCharacterData", "ProcessDiscordChatMessage",
    "RemoveCharacterFromGroups", "RemoveFromGroup", "ResetCameraState", "RunDatabaseMigrations",
    "SanitizeArguments", "SaveCharacterMenuPreferences", "SaveEntityData", "SaveSkinPreference",
    "SendCharacterSelectionConfirmation", "SendCommandAnalytics", "SendCreationAnalytics",
    "SetupAccessibilityFeatures", "SetupAdvancedUI", "SetupAutoSave", "SetupCharacterPreview",
    "SetupCustomEventHandlers", "SetupKeyboardShortcuts", "SetupRealTimeUpdates",
    "SetupStepNavigation", "SetupWelcomeSequence", "ShowNewPlayerTutorial", "StoreCommandHistory",
    "TrackMenuSession", "TriggerDoorAlarm", "UpdateCharacterPreview", "UpdateCharacterRelationships",
    "UpdateCharacterSelectionStats", "UpdatePlayerCommandStats", "UpdateServerSelectionStats",
    "ValidateCharacterCreation", "ValidateCharacterData", "ValidateCharacterForSave",
    "ValidateCommandData", "ValidateConfigurationChange", "ValidateDatabaseSchema",
    "ValidateDeletionRequest", "ValidateDiscordEmbed", "ValidateDiscordMessage",
    "ValidateDoorPrice", "ValidateHUDInfo", "ValidateModuleStructure", "ValidateRestoredCharacter",
    "AddWarning", "ChooseCharacter", "CreateCharacter", "CreateSalaryTimers", "DeleteCharacter",
    "FetchSpawns", "ForceRecognizeRange", "GetAllCaseClaims", "GetTicketsByRequester",
    "GetWarningsByIssuer", "InitializeStorage", "OnPlayerDropWeapon",
    "RemoveWarning", "SendPopup", "StorageItemRemoved", "StoreSpawns", "SyncCharList", "ToggleLock"
}


def scan_hooks(base_path: str) -> List[str]:
    """Scan Lua files for hook.Add and hook.Run calls"""
    hooks_found = set()
    base_path = Path(base_path)

    
    for root, dirs, files in os.walk(base_path):
        
        dirs[:] = [d for d in dirs if d not in ['node_modules', '.git']]

        for file in files:
            if file.endswith('.lua'):
                file_path = os.path.join(root, file)
                file_hooks = _extract_hooks_from_file(file_path)
                hooks_found.update(file_hooks)

    return sorted(list(hooks_found))


def _extract_hooks_from_file(file_path: str) -> Set[str]:
    """Extract hooks from a single Lua file"""
    hooks = set()

    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception as e:
        print(f"Warning: Could not read {file_path}: {e}")
        return hooks

    
    
    hook_add_pattern = r'hook\.Add\s*\(\s*([\'"`])([^\'"`]+)\1'

    
    
    hook_run_pattern = r'hook\.Run\s*\(\s*([\'"`])([^\'"`]+)\1'

    
    for match in re.finditer(hook_add_pattern, content):
        hook_name = match.group(2)
        if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
            hooks.add(hook_name.strip())

    
    for match in re.finditer(hook_run_pattern, content):
        hook_name = match.group(2)
        if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
            hooks.add(hook_name.strip())

    return hooks


def read_documented_hooks(hooks_doc_path: str) -> List[str]:
    """Read documented hooks from the hooks documentation file"""
    documented_hooks = set()
    hooks_doc_path = Path(hooks_doc_path)

    if not hooks_doc_path.exists():
        print(f"Warning: Hooks documentation file not found: {hooks_doc_path}")
        return []

    try:
        with open(hooks_doc_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception as e:
        print(f"Warning: Could not read hooks documentation: {e}")
        return []

    lines = content.split('\n')

    in_code_block = False
    for line in lines:
        
        if line.strip().startswith('```'):
            in_code_block = not in_code_block
            continue

        
        if in_code_block:
            continue

        
        
        
        if not line.strip().startswith('|') and 'hook.Add(' in line:
            hook_match = re.search(r'hook\.Add\s*\(\s*["\']([^"\']+)["\']', line)
            if hook_match:
                hook_name = hook_match.group(1).strip()
                if hook_name and len(hook_name) > 2 and hook_name not in GMOD_HOOKS_BLACKLIST:
                    documented_hooks.add(hook_name)

        
        
        header_match = re.search(r'^###+\s+([A-Z][A-Za-z0-9_]+)\s*$', line)
        if header_match:
            header_text = header_match.group(1).strip()
            
            
            if (len(header_text) > 2 and re.search(r'^[A-Z][A-Za-z0-9_]+$', header_text)
                and header_text not in GMOD_HOOKS_BLACKLIST):
                documented_hooks.add(header_text)

    return sorted(list(documented_hooks))


"""
Localization analysis module for analyzing language file usage.
"""

import os
import re
from pathlib import Path
from typing import Dict, List, Tuple, Set
from collections import defaultdict


LOCALIZATION_CALL_PATTERNS = [
    (re.compile(r'\bL\s*\(\s*(["\'])([^"\']+)\1'), 'L'),
    (re.compile(r'\blia\.lang\.getLocalizedString\s*\(\s*(["\'])([^"\']+)\1'), 'lia.lang.getLocalizedString'),
    (re.compile(r'\blia\.lang\.resolveToken\s*\(\s*(["\'])([^"\']+)\1'), 'lia.lang.resolveToken'),
    (re.compile(r':notifyLocalized\s*\(\s*(["\'])([^"\']+)\1'), ':notifyLocalized'),
    (re.compile(r':notifyErrorLocalized\s*\(\s*(["\'])([^"\']+)\1'), ':notifyErrorLocalized'),
    (re.compile(r':notifyWarningLocalized\s*\(\s*(["\'])([^"\']+)\1'), ':notifyWarningLocalized'),
    (re.compile(r':notifyInfoLocalized\s*\(\s*(["\'])([^"\']+)\1'), ':notifyInfoLocalized'),
    (re.compile(r':notifySuccessLocalized\s*\(\s*(["\'])([^"\']+)\1'), ':notifySuccessLocalized'),
    (re.compile(r':notifyMoneyLocalized\s*\(\s*(["\'])([^"\']+)\1'), ':notifyMoneyLocalized'),
    (re.compile(r':notifyAdminLocalized\s*\(\s*(["\'])([^"\']+)\1'), ':notifyAdminLocalized'),
]
GENERIC_AT_TOKEN_PATTERN = re.compile(r'(["\'])(@[A-Za-z_][A-Za-z0-9_\.:-]*)\1')
AT_VALUE_PATTERN = re.compile(r'@[A-Za-z_][A-Za-z0-9_\.:-]*')


def _normalize_localization_key(key: str) -> str:
    """Normalize localization references so @token and token map to the same language key."""
    if not isinstance(key, str):
        return key
    return key[1:] if key.startswith('@') else key


def analyze_data(language_file: str, gamemode_path: str) -> Dict:
    """
    Analyze localization data from language file and gamemode usage.

    Args:
        language_file: Path to the language file (e.g., english.lua)
        gamemode_path: Path to the gamemode directory

    Returns:
        Dict containing analysis results
    """
    
    keys, key_lines = _load_language_keys(language_file)

    
    usage_data = _scan_localization_usage(gamemode_path)

    
    return _analyze_localization_data(keys, key_lines, usage_data, gamemode_path)


def _load_language_keys(language_file: str) -> Tuple[Dict[str, str], Dict[str, int]]:
    """Load language keys from Lua language file using a simple, robust approach"""
    keys = {}
    key_lines = {}

    if not os.path.exists(language_file):
        print(f"Warning: Language file not found: {language_file}")
        return keys, key_lines

    try:
        with open(language_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception as e:
        print(f"Warning: Could not read language file {language_file}: {e}")
        return keys, key_lines

    lines = content.split('\n')
    inside_table = False
    
    for line_num, line in enumerate(lines, 1):
        stripped = line.strip()
        
        
        if 'LANGUAGE = {' in stripped:
            inside_table = True
            continue
        elif inside_table and stripped == '}':
            inside_table = False
            continue
        
        
        if not inside_table:
            continue
        
        
        if not stripped or stripped.startswith('--'):
            continue
        
        
        if '= [[' in stripped:
            
            key_match = re.match(r'^(\w+)\s*=\s*\[\[', stripped)
            if key_match:
                key = key_match.group(1)
                
                multiline_content = []
                current_line = line
                
                first_line_content = current_line.split('= [[')[1] if '= [[' in current_line else ''
                if first_line_content.strip():
                    multiline_content.append(first_line_content)
                
                
                for next_line_num in range(line_num + 1, len(lines)):
                    next_line = lines[next_line_num]
                    if ']]' in next_line:
                        
                        before_close = next_line.split(']]')[0]
                        if before_close.strip():
                            multiline_content.append(before_close)
                        break
                    else:
                        multiline_content.append(next_line)
                
                
                value = '\n'.join(multiline_content).strip()
                keys[key] = value
                key_lines[key] = line_num
            continue
        
        
        pattern = r'^(\w+)\s*=\s*"([^"]*)"'
        match = re.match(pattern, stripped)
        if match:
            key = match.group(1)
            value = match.group(2)
            keys[key] = value
            key_lines[key] = line_num

    return keys, key_lines


def _scan_localization_usage(gamemode_path: str) -> Dict[str, List[Tuple[str, int, str, str]]]:
    """Scan gamemode files for localization function calls"""
    usage_data = defaultdict(list)
    gamemode_path = Path(gamemode_path)

    
    for root, dirs, files in os.walk(gamemode_path):
        
        skip_dirs = ['node_modules', '.git', 'docs', 'documentation']
        dirs[:] = [d for d in dirs if d not in skip_dirs]

        for file in files:
            if file.endswith('.lua'):
                file_path = os.path.join(root, file)
                relative_path = os.path.relpath(file_path, gamemode_path)
                
                if os.sep == '\\':
                    relative_path = relative_path.replace('/', '\\')
                else:
                    relative_path = relative_path.replace('\\', '/')

                
                if 'languages' in str(file_path) and file.endswith('.lua'):
                    continue

                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                except Exception:
                    continue

                lines = content.split('\n')

                for line_num, line in enumerate(lines, 1):
                    seen_entries = set()

                    for pattern, func_type in LOCALIZATION_CALL_PATTERNS:
                        for match in pattern.finditer(line):
                            key = match.group(2)
                            
                            if func_type == 'lia.lang.resolveToken' and not key.startswith('@'):
                                continue
                            normalized_key = _normalize_localization_key(key)
                            entry_key = (normalized_key, match.span())
                            if not normalized_key or entry_key in seen_entries:
                                continue
                            seen_entries.add(entry_key)
                            usage_data[normalized_key].append((relative_path, line_num, line.strip(), func_type))

                    for match in GENERIC_AT_TOKEN_PATTERN.finditer(line):
                        raw_key = match.group(2)
                        normalized_key = _normalize_localization_key(raw_key)
                        entry_key = (normalized_key, match.span())
                        if not normalized_key or entry_key in seen_entries:
                            continue
                        seen_entries.add(entry_key)
                        usage_data[normalized_key].append((relative_path, line_num, line.strip(), '@token'))

    return usage_data


def _analyze_localization_data(keys: Dict[str, str], key_lines: Dict[str, int],
                              usage_data: Dict[str, List[Tuple[str, int, str, str]]],
                              gamemode_path: str) -> Dict:
    """Analyze localization data and return results"""
    results = {
        'keys': keys,
        'key_lines': key_lines,
        'usage_data': usage_data,
        'unused': [],
        'undefined_rows': [],
        'mismatch_rows': [],
        'at_pattern_rows': [],
        'total_hits': 0,
        'unused_count': 0,
        'undefined_count': 0,
        'mismatch_count': 0,
        'at_pattern_count': 0
    }

    
    for key, usages in usage_data.items():
        results['total_hits'] += len(usages)

    
    used_keys = set(usage_data.keys())
    unused_keys = []
    for key in keys:
        if key not in used_keys:
            unused_keys.append(key)
    results['unused'] = unused_keys
    results['unused_count'] = len(unused_keys)

    
    undefined_keys_seen = set()
    for key, usages in usage_data.items():
        
        if key.startswith('[['):
            continue
        
        if key not in keys and key not in undefined_keys_seen:
            undefined_keys_seen.add(key)
            
            usage = usages[0]
            results['undefined_rows'].append(usage + (key,))
    results['undefined_count'] = len(results['undefined_rows'])

    
    at_pattern_keys_seen = set()
    for key, usages in usage_data.items():
        if key in keys and key not in at_pattern_keys_seen:
            value = keys[key]
            if AT_VALUE_PATTERN.search(value):
                at_pattern_keys_seen.add(key)
                
                usage = usages[0]
                results['at_pattern_rows'].append(usage + (key,))
    results['at_pattern_count'] = len(results['at_pattern_rows'])

    
    mismatch_keys_seen = set()
    for key, usages in usage_data.items():
        if key in keys and key not in mismatch_keys_seen:
            value = keys[key]
            
            placeholder_count = value.count('%s')

            for usage in usages:
                file_path, line_num, line_content, func_type = usage

                
                patterns = {
                    'L': r'\bL\s*\(\s*["\'][^\'"]+["\']\s*,\s*(.+)\)',
                    'lia.lang.getLocalizedString': r'\blia\.lang\.getLocalizedString\s*\(\s*["\'][^\'"]+["\']\s*,\s*(.+)\)',
                    'lia.lang.resolveToken': r'\blia\.lang\.resolveToken\s*\(\s*["\'][^\'"]+["\']\s*,\s*(.+)\)',
                    ':notifyLocalized': r':notifyLocalized\s*\(\s*["\'][^\'"]+["\']\s*,\s*(.+)\)',
                    ':notifyErrorLocalized': r':notifyErrorLocalized\s*\(\s*["\'][^\'"]+["\']\s*,\s*(.+)\)',
                    ':notifyWarningLocalized': r':notifyWarningLocalized\s*\(\s*["\'][^\'"]+["\']\s*,\s*(.+)\)',
                    ':notifyInfoLocalized': r':notifyInfoLocalized\s*\(\s*["\'][^\'"]+["\']\s*,\s*(.+)\)',
                    ':notifySuccessLocalized': r':notifySuccessLocalized\s*\(\s*["\'][^\'"]+["\']\s*,\s*(.+)\)',
                    ':notifyMoneyLocalized': r':notifyMoneyLocalized\s*\(\s*["\'][^\'"]+["\']\s*,\s*(.+)\)',
                    ':notifyAdminLocalized': r':notifyAdminLocalized\s*\(\s*["\'][^\'"]+["\']\s*,\s*(.+)\)',
                }

                
                if func_type in patterns:
                    
                    args_match = re.search(patterns[func_type], line_content)
                    if args_match:
                        args_str = args_match.group(1)
                        
                        arg_count = args_str.count(',') + 1 if args_str.strip() else 0

                        if arg_count != placeholder_count:
                            mismatch_keys_seen.add(key)
                            results['mismatch_rows'].append(usage + (key,))
                            break  
    results['mismatch_count'] = len(results['mismatch_rows'])

    return results



def write_framework_md(data: Dict, output_path: str = None) -> str:
    """Write framework localization analysis to markdown"""
    if not output_path:
        output_path = "localization_framework_report.md"

    content = ["# Framework Localization Analysis", ""]

    content.extend(_generate_localization_summary(data))

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(content))

    return output_path


def write_framework_txt(data: Dict, output_path: str = None) -> str:
    """Write framework localization analysis to text"""
    if not output_path:
        output_path = "localization_framework_report.txt"

    content = ["FRAMEWORK LOCALIZATION ANALYSIS", "=" * 40, ""]

    
    content.append(f"Language Keys: {len(data.get('keys', {}))}")
    content.append(f"Total Usages: {data.get('total_hits', 0)}")
    content.append(f"Unused Keys: {len(data.get('unused', []))}")
    content.append(f"Undefined Calls: {len(data.get('undefined_rows', []))}")
    content.append(f"Argument Mismatches: {len(data.get('mismatch_rows', []))}")
    content.append(f"@xxxxx Patterns: {len(data.get('at_pattern_rows', []))}")
    content.append("")

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(content))

    return output_path


def write_modules_md(data: Dict, output_path: str = None) -> str:
    """Write modules localization analysis to markdown"""
    if not output_path:
        output_path = "localization_modules_report.md"

    content = ["# Modules Localization Analysis", ""]

    
    content.append("Module-specific localization analysis not yet implemented.")
    content.append("")

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(content))

    return output_path


def write_modules_txt(data: Dict, output_path: str = None) -> str:
    """Write modules localization analysis to text"""
    if not output_path:
        output_path = "localization_modules_report.txt"

    content = ["MODULES LOCALIZATION ANALYSIS", "=" * 30, ""]

    content.append("Module-specific localization analysis not yet implemented.")
    content.append("")

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(content))

    return output_path


def _generate_localization_summary(data: Dict) -> List[str]:
    """Generate localization summary section"""
    lines = ["## Summary", ""]

    lines.append(f"- **Language Keys:** {len(data.get('keys', {}))}")
    lines.append(f"- **Total Usages:** {data.get('total_hits', 0)}")
    lines.append(f"- **Unused Keys:** {len(data.get('unused', []))}")
    lines.append(f"- **Undefined Calls:** {len(data.get('undefined_rows', []))}")
    lines.append(f"- **Argument Mismatches:** {len(data.get('mismatch_rows', []))}")
    lines.append(f"- **@xxxxx Patterns:** {len(data.get('at_pattern_rows', []))}")
    lines.append("")

    return lines



DEFAULT_FRAMEWORK_GAMEMODE_DIR = r"D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode"
DEFAULT_LANGUAGE_FILE = r"D:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\languages\english.lua"
DEFAULT_MODULES_PATHS = [
    r"D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules",
    r"D:\GMOD\Server\garrysmod\gamemodes\metrorp\modules"
]



FUNCTIONS_NOT_TO_CHECK = {
    
    "lia.derma.menuPlayerSelector.btn_close.DoClick",

    
    "lia.gui.*",

    
    
    
    
}




FUNCTIONS_TO_CHECK = {
    
    "lia.util.*",
    "lia.config.*",
    "lia.database.*",
    "lia.admin.*",
    "lia.attribs.*",
    "lia.bar.*",
    "lia.char.*",
    "lia.chat.*",
    "lia.class.*",
    "lia.color.*",
    "lia.command.*",
    "lia.currency.*",
    "lia.darkrp.*",
    "lia.data.*",
    "lia.derma.*",
    "lia.dialog.*",
    "lia.doors.*",
    "lia.faction.*",
    "lia.flag.*",
    "lia.font.*",
    "lia.inventory.*",
    "lia.item.*",
    "lia.keybind.*",
    "lia.lang.*",
    "lia.loader.*",
    "lia.log.*",
    "lia.menu.*",
    "lia.module.*",
    "lia.net.*",
    "lia.notice.*",
    "lia.option.*",
    "lia.performance.*",
    "lia.playerinteract.*",
    "lia.thirdparty.*",
    "lia.time.*",
    "lia.vendor.*",
    "lia.webimage.*",
    "lia.websound.*",
    "lia.workshop.*",
    
    "characterMeta:*",
    "itemMeta:*",
    "inventoryMeta:*",
    "entityMeta:*",
    "panelMeta:*",
    "playerMeta:*",
    
}

def should_check_function(function_name):
    """
    Determine if a function should be checked for documentation.

    Args:
        function_name (str): The name of the function to check

    Returns:
        bool: True if the function should be checked, False otherwise
    """
    
    if function_name in FUNCTIONS_NOT_TO_CHECK:
        return False

    
    for pattern in FUNCTIONS_NOT_TO_CHECK:
        if pattern.endswith("*") and function_name.startswith(pattern[:-1]):
            return False

    
    for pattern in FUNCTIONS_TO_CHECK:
        if function_name.startswith(pattern.replace("*", "")):
            return True

    
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
    line_number: int = 0
    is_server_only: bool = False
    is_client_only: bool = False
    parameters: List[str] = None
    description: str = ""

    def __post_init__(self):
        if self.parameters is None:
            self.parameters = []

@dataclass
class CombinedReportData:
    """Container for all analysis results"""
    function_comparison: Dict[str, Dict]
    hooks_missing: List[str]
    hooks_documented: List[str]
    hooks_registered: List[str]  
    hooks_signatures: Dict[str, List[str]]  
    hooks_locations: Dict[str, List[Dict[str, str]]]  
    hooks_method: List[str]  
    hooks_standard: List[str]  
    localization_data: Dict
    argument_mismatches: List[Dict]  
    inferred_localization: Dict[str, List[Dict]]  
    modules_data: List
    module_localization_conflicts: Dict[str, List[Dict[str, str]]]  
    modules_scan: List[Dict]
    language_comparison: Dict[str, Dict[str, List[str]]]  
    
    missing_library_functions: List[FunctionInfo]
    missing_hook_functions: List[FunctionInfo]
    missing_meta_functions: List[FunctionInfo]
    
    fonts_registered: Set[str]
    fonts_used: Set[str]
    fonts_unregistered: Set[str]
    fonts_default_gmod: Set[str]
    fonts_variable: Set[str]
    fonts_getfont_count: int
    fonts_file_usages: Dict[str, Set[str]]  
    
    config_undefined_get_calls: List[Dict]  
    
    undefined_inferred_loc_keys: List[Dict]  
    
    net_messages_defined: Dict[str, List[Dict[str, Any]]]
    net_messages_used: Dict[str, List[Dict[str, Any]]]
    net_messages_unused_defined: List[str]
    net_messages_used_but_undefined: List[str]
    net_message_analysis_notes: List[str]
    module_net_messages_misregistered: List[Dict[str, Any]]
    module_net_messages_undefined: List[Dict[str, Any]]
    module_net_messages_notes: List[str]
    net_messages_direction_issues: List[Dict[str, Any]]
    derma_panels_defined: List[Dict[str, Any]]
    derma_panels_used: Set[str]
    derma_panels_unused: List[Dict[str, Any]]
    module_derma_panels_outside_folder: List[Dict[str, Any]]
    module_file_placement_issues: List[Dict[str, Any]]
    duplicate_key_analysis: Dict[str, Any]
    privilege_report: Dict[str, Any]
    generated_at: str

@dataclass(frozen=True)
class ReportTarget:
    """Represents one markdown report target."""
    report_name: str
    display_name: str
    module_path: Optional[Path] = None
    module_scan_entry: Optional[Dict[str, Any]] = None

class FunctionComparisonReportGenerator:
    """Main class for generating comprehensive function comparison reports"""

    def __init__(self, base_path: str = None, docs_path: str = None, language_file: str = None,
                 modules_paths: List[str] = None, generate_module_docs: bool = True):
        self.base_path = Path(base_path) if base_path else DEFAULT_GAMEMODE_ROOT
        self.docs_path = Path(docs_path) if docs_path else DEFAULT_DOCS_ROOT
        
        
        if language_file:
            self.language_file = str(language_file) if isinstance(language_file, Path) else language_file
        else:
            lang_file_path = Path(DEFAULT_LANGUAGE_FILE) if isinstance(DEFAULT_LANGUAGE_FILE, (str, Path)) else DEFAULT_LANGUAGE_FILE
            if not lang_file_path.exists():
                
                potential_lang_file = self.base_path / "languages" / "english.lua"
                if potential_lang_file.exists():
                    self.language_file = str(potential_lang_file)
                else:
                    
                    fallback_lang_file = self.base_path / "languages" / "english.lua"
                    self.language_file = str(fallback_lang_file)
            else:
                self.language_file = str(lang_file_path)
        self.generate_module_docs = generate_module_docs

        
        
        
        if modules_paths is not None:
            self.modules_paths = [str(p) for p in modules_paths]
        else:
            self.modules_paths = [str(p) for p in DEFAULT_MODULES_PATHS]

        
        self.function_comparator = FunctionComparator(str(self.base_path))
        preferred_hooks_dir = self.docs_path / "docs" / "developer" / "hooks"
        legacy_hooks_dir = self.docs_path / "docs" / "development" / "hooks"
        fallback_hooks_dir = self.docs_path / "docs" / "hooks"
        if preferred_hooks_dir.exists():
            self.hooks_doc_dir = preferred_hooks_dir
        elif legacy_hooks_dir.exists():
            self.hooks_doc_dir = legacy_hooks_dir
        else:
            self.hooks_doc_dir = fallback_hooks_dir

    def _detect_argument_mismatches(self) -> List[Dict]:
        """Detect argument mismatches in localization function calls"""
        mismatches = []

        
        lang_keys = self._get_localization_keys_with_arg_counts()

        
        lua_files = list(self.base_path.rglob("*.lua"))

        for lua_file in lua_files:
            
            if 'languages' in lua_file.parts or 'docs' in lua_file.parts:
                continue

            try:
                with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()

                
                
                content = self._remove_lua_comments(content)

                
                mismatches.extend(self._check_file_for_arg_mismatches(content, str(lua_file.relative_to(self.base_path)), lang_keys))

            except Exception as e:
                print(f"Warning: Error scanning {lua_file}: {e}")
                continue

        return mismatches

    def _detect_inferred_localization(self) -> Dict[str, List[Dict]]:
        inferred: Dict[str, List[Dict]] = defaultdict(list)

        def should_skip_path(p: Path) -> bool:
            lowered = [part.lower() for part in p.parts]
            return any(
                skip in lowered
                for skip in [
                    "documentation",
                    "docs",
                    "languages",
                    "thirdparty",
                ]
            )

        scan_roots: List[Tuple[Path, str]] = []
        gamemode_root = Path(self.base_path)
        for rel in ["core/libraries", "core/meta", "entities", "items", "modules"]:
            root = gamemode_root / rel
            if root.exists():
                scan_roots.append((root, str(gamemode_root)))

        for modules_base in (Path(p) for p in (self.modules_paths or [])):
            if modules_base.exists():
                scan_roots.append((modules_base, str(modules_base)))

            if modules_base.name.lower() == "modules":
                sibling = modules_base.parent / "devmodules"
                if sibling.exists():
                    scan_roots.append((sibling, str(sibling)))

        field_assign_l = re.compile(r'^\s*([A-Za-z_][\w\.\[\]:]*)\s*=\s*L\s*\(\s*')
        field_assign_resolve = re.compile(
            r'^\s*([A-Za-z_][\w\.\[\]:]*)\s*=\s*(?:isstring\([^)]+\)\s*and\s*)?lia\.lang\.resolveToken\s*\(\s*(.+)$'
        )
        call_resolve = re.compile(r'\blia\.lang\.resolveToken\s*\(\s*(.+)$')
        generic_l_call = re.compile(r'\bL\s*\(\s*')
        attr_at_token = re.compile(r'@([A-Za-z_][A-Za-z0-9_\.:-]*)')

        
        
        raw_loc_field = re.compile(
            r'^\s*(?:ITEM|MODULE|FACTION|CLASS)\s*\.\s*(name|desc)\s*=\s*["\']([^"\']+)["\']'
        )
        
        raw_contact_field = re.compile(
            r'^\s*(?:MODULE|ENT|SWEP)\s*\.\s*(discord|Contact)\s*=\s*["\'](@[A-Za-z_][A-Za-z0-9_]*)["\']'
        )
        
        config_add_name = re.compile(
            r'\blia\.config\.add\s*\(\s*["\'][^"\']+["\']\s*,\s*["\']([^"\']+)["\']'
        )
        
        data_desc_field = re.compile(r'\bdesc\s*=\s*["\'](@?[a-z][a-zA-Z0-9_]+)["\']')
        
        data_category_field = re.compile(r'\bcategory\s*=\s*["\'](@[A-Za-z_][A-Za-z0-9_]*)["\']')
        
        option_add_name = re.compile(
            r'\blia\.option\.add\s*\(\s*["\'][^"\']+["\']\s*,\s*["\']([^"\']+)["\']'
        )
        option_add_desc = re.compile(
            r'\blia\.option\.add\s*\(\s*["\'][^"\']+["\']\s*,\s*["\'][^"\']*["\']\s*,\s*["\']([^"\']+)["\']'
        )
        
        flag_add_desc = re.compile(
            r'\blia\.flag\.add\s*\(\s*["\'][^"\']+["\']\s*,\s*["\'](@?[a-z][A-Za-z0-9_]*)["\']'
        )
        
        data_privilege_field = re.compile(r'\bprivilege\s*=\s*["\'](@[A-Za-z_][A-Za-z0-9_]*)["\']')
        
        action_text_field = re.compile(r'\b(?:actionText|targetActionText)\s*=\s*["\'](@[A-Za-z_][A-Za-z0-9_]*)["\']')

        for root, rel_base in scan_roots:
            for lua_file in root.rglob("*.lua"):
                if should_skip_path(lua_file):
                    continue
                try:
                    content = lua_file.read_text(encoding="utf-8", errors="ignore")
                except Exception:
                    continue

                rel_path = None
                try:
                    rel_path = str(lua_file.relative_to(Path(rel_base)))
                except Exception:
                    rel_path = str(lua_file)

                in_long_comment = False
                for idx, raw_line in enumerate(content.splitlines(), start=1):
                    line = raw_line.rstrip("\n")
                    stripped = line.strip()

                    if stripped.startswith("--[["):
                        if "]]" not in stripped:
                            in_long_comment = True
                        continue

                    if in_long_comment:
                        if "]]" in stripped:
                            in_long_comment = False
                        continue

                    if stripped.startswith("--") or stripped == "":
                        continue

                    m = field_assign_l.match(line)
                    if m:
                        lhs = m.group(1)
                        inferred[rel_path].append(
                            {
                                "line": idx,
                                "kind": "field=L(...)",
                                "lhs": lhs,
                                "context": stripped[:240],
                            }
                        )

                    m = field_assign_resolve.match(line)
                    if m:
                        lhs = m.group(1)
                        after = m.group(2).lstrip()
                        kind = "field=resolveToken(dynamic)"
                        if after.startswith(("'", '"', "[[")):
                            kind = "field=resolveToken(const)"
                        inferred[rel_path].append(
                            {
                                "line": idx,
                                "kind": kind,
                                "lhs": lhs,
                                "context": stripped[:240],
                            }
                        )

                    if "lia.lang.resolveToken" in line:
                        m = call_resolve.search(line)
                        if m:
                            after = m.group(1).lstrip()
                            kind = "resolveToken(dynamic)"
                            if after.startswith(("'", '"', "[[")):
                                kind = "resolveToken(const)"
                            inferred[rel_path].append(
                                {
                                    "line": idx,
                                    "kind": kind,
                                    "lhs": None,
                                    "context": stripped[:240],
                                }
                            )

                    if generic_l_call.search(line):
                        inferred[rel_path].append(
                            {
                                "line": idx,
                                "kind": "call=L(...)",
                                "lhs": None,
                                "context": stripped[:240],
                            }
                        )

                    for at_match in attr_at_token.finditer(line):
                        inferred[rel_path].append(
                            {
                                "line": idx,
                                "kind": "@token",
                                "lhs": None,
                                "context": stripped[:240],
                            }
                        )

                    
                    m = raw_loc_field.match(line)
                    if m:
                        inferred[rel_path].append({
                            "line": idx,
                            "kind": f"raw_field:{m.group(1)}",
                            "lhs": m.group(1),
                            "context": stripped[:240],
                        })

                    
                    for cm in config_add_name.finditer(line):
                        inferred[rel_path].append({
                            "line": idx,
                            "kind": "config_add:name",
                            "lhs": "lia.config.add:name",
                            "context": stripped[:240],
                        })

                    
                    for dm in data_desc_field.finditer(line):
                        inferred[rel_path].append({
                            "line": idx,
                            "kind": "data_table:desc",
                            "lhs": "desc",
                            "context": stripped[:240],
                        })

                    
                    for om in option_add_name.finditer(line):
                        inferred[rel_path].append({
                            "line": idx,
                            "kind": "option_add:name",
                            "lhs": "lia.option.add:name",
                            "context": stripped[:240],
                        })
                    for om in option_add_desc.finditer(line):
                        inferred[rel_path].append({
                            "line": idx,
                            "kind": "option_add:desc",
                            "lhs": "lia.option.add:desc",
                            "context": stripped[:240],
                        })

                    
                    m = raw_contact_field.match(line)
                    if m:
                        inferred[rel_path].append({
                            "line": idx,
                            "kind": f"raw_field:{m.group(1)}",
                            "lhs": m.group(1),
                            "context": stripped[:240],
                        })

                    
                    for fm in data_category_field.finditer(line):
                        inferred[rel_path].append({
                            "line": idx,
                            "kind": "data_table:category",
                            "lhs": "category",
                            "context": stripped[:240],
                        })

                    
                    for fm in flag_add_desc.finditer(line):
                        inferred[rel_path].append({
                            "line": idx,
                            "kind": "flag_add:desc",
                            "lhs": "lia.flag.add:desc",
                            "context": stripped[:240],
                        })

                    
                    for pm in data_privilege_field.finditer(line):
                        inferred[rel_path].append({
                            "line": idx,
                            "kind": "data_table:privilege",
                            "lhs": "privilege",
                            "context": stripped[:240],
                        })

                    
                    for am in action_text_field.finditer(line):
                        inferred[rel_path].append({
                            "line": idx,
                            "kind": f"data_table:{am.group(0).split('=')[0].strip()}",
                            "lhs": am.group(0).split('=')[0].strip(),
                            "context": stripped[:240],
                        })

        for k in list(inferred.keys()):
            uniq = {}
            for entry in inferred[k]:
                key = (entry.get("line"), entry.get("kind"), entry.get("lhs"), entry.get("context"))
                uniq[key] = entry
            inferred[k] = sorted(uniq.values(), key=lambda e: int(e.get("line", 0)))

        return dict(sorted(inferred.items(), key=lambda kv: kv[0].lower()))

    def _detect_undefined_inferred_loc_keys(self) -> List[Dict]:
        """Scan for string literals stored in localization-by-convention fields that have
        no matching entry in the language file.

        Checked patterns:
        - ITEM.name / ITEM.desc / MODULE.name / MODULE.desc / FACTION.name / FACTION.desc /
          CLASS.name / CLASS.desc                                      (raw field assignment)
        - lia.config.add("key", "nameLocKey", ...)                    (2nd positional arg)
        - lia.config.add(..., {desc = "descLocKey"})                  (data.desc field)
        - lia.option.add("key", "nameLocKey", "descLocKey", ...)      (2nd and 3rd args)
        - lia.flag.add("X", "@descKey", ...)                          (2nd positional arg)
        - MODULE.Privileges[x] = {Name = "@token", Category = "@token"} (via @token scanner)
        - category = "@token"                                         (data table field)
        - privilege = "@token"                                        (command data table field)
        - MODULE.discord / ENT.Contact / SWEP.Contact = "@token"      (entity contact fields)
        - actionText / targetActionText = "@token"                    (interaction fields)

        Returns list of dicts: {file, line, field, key, context}
        """
        defined_keys: Set[str] = self._extract_language_keys(str(self.language_file))

        def normalize(v: str) -> str:
            return v[1:] if v.startswith('@') else v

        
        PATTERNS: List[Tuple] = [
            (
                re.compile(r'\b(ITEM|MODULE|FACTION|CLASS)\s*\.\s*(name|desc)\s*=\s*["\']([^"\']+)["\']'),
                3,
                lambda m: f"{m.group(1)}.{m.group(2)}",
                True,
            ),
            (
                re.compile(r'\blia\.config\.add\s*\(\s*["\'][^"\']+["\']\s*,\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "lia.config.add:name",
                True,
            ),
            (
                re.compile(r'\bdesc\s*=\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "data.desc",
                True,
            ),
            (
                re.compile(r'\blia\.option\.add\s*\(\s*["\'][^"\']+["\']\s*,\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "lia.option.add:name",
                True,
            ),
            (
                re.compile(r'\blia\.option\.add\s*\(\s*["\'][^"\']+["\']\s*,\s*["\'][^"\']*["\']\s*,\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "lia.option.add:desc",
                True,
            ),
            (
                re.compile(r'\bName\s*=\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "Privilege.Name",
                True,
            ),
            (
                re.compile(r'\bCategory\s*=\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "Privilege.Category",
                True,
            ),
            (
                re.compile(r'\bcategory\s*=\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "data.category",
                True,
            ),
            (
                re.compile(r'\blia\.flag\.add\s*\(\s*["\'][^"\']+["\']\s*,\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "lia.flag.add:desc",
                True,
            ),
            (
                re.compile(r'\bprivilege\s*=\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "data.privilege",
                False,
            ),
            (
                re.compile(r'\b(?:MODULE|ENT|SWEP)\s*\.\s*(?:discord|Contact)\s*=\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "entity.contact",
                False,
            ),
            (
                re.compile(r'\b(?:actionText|targetActionText)\s*=\s*["\']([^"\']+)["\']'),
                1,
                lambda m: "interaction.actionText",
                True,
            ),
        ]

        scan_roots: List[Path] = [self.base_path]
        for mp in (self.modules_paths or []):
            p = Path(mp)
            if p.exists():
                scan_roots.append(p)

        undefined: List[Dict] = []
        seen: set = set()

        for root in scan_roots:
            for lua_file in root.rglob("*.lua"):
                lowered = [part.lower() for part in lua_file.parts]
                if any(s in lowered for s in ("documentation", "docs", "languages", "thirdparty")):
                    continue
                try:
                    content = lua_file.read_text(encoding="utf-8", errors="ignore")
                    content_clean = self._remove_lua_comments(content)
                except Exception:
                    continue

                split_lines = content_clean.splitlines()
                try:
                    rel_path = str(lua_file.relative_to(self.base_path))
                except ValueError:
                    rel_path = str(lua_file)

                for pattern, value_group, field_label_fn, allow_plain_literal in PATTERNS:
                    for m in pattern.finditer(content_clean):
                        raw_value = m.group(value_group).strip()
                        issue = None
                        value = None

                        if self._looks_like_localization_key(raw_value):
                            norm = normalize(raw_value)
                            if norm in defined_keys:
                                continue
                            issue = "missing_key"
                            value = norm
                        elif allow_plain_literal and self._is_probably_unlocalized_literal(raw_value):
                            issue = "unlocalized_literal"
                            value = raw_value
                        else:
                            continue

                        line_num = content_clean[: m.start()].count("\n") + 1
                        context = split_lines[line_num - 1].strip() if line_num <= len(split_lines) else ""
                        sig = (rel_path, line_num, field_label_fn(m), issue, value)
                        if sig in seen:
                            continue
                        seen.add(sig)
                        undefined.append({
                            "file": rel_path,
                            "line": line_num,
                            "field": field_label_fn(m),
                            "issue": issue,
                            "key": value,
                            "context": context[:240],
                        })

        return sorted(undefined, key=lambda e: (e["field"], e["file"], e["line"]))

    def _scan_all_language_files(self) -> Dict[str, Set[str]]:
        """Scan all language files and extract their keys"""
        language_keys = {}
        languages_dir = self.base_path / "languages"

        if not languages_dir.exists():
            print(f"Warning: Languages directory not found: {languages_dir}")
            return language_keys

        
        for lang_file in languages_dir.glob("*.lua"):
            lang_name = lang_file.stem  
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

            
            
            in_language_table = False
            brace_depth = 0

            lines = content.split('\n')
            for line in lines:
                stripped_line = line.strip()

                
                if stripped_line == 'LANGUAGE = {' or stripped_line == 'LANGUAGE = {':
                    in_language_table = True
                    brace_depth = 1
                    continue
                elif in_language_table:
                    
                    brace_depth += line.count('{')
                    brace_depth -= line.count('}')

                    
                    if brace_depth <= 0:
                        in_language_table = False
                        break

                
                if in_language_table and brace_depth > 0:
                    
                    
                    key_pattern = r'(\w+)\s*=\s*["\'](?:[^"\'\\]|\\.)*["\']'

                    for match in re.finditer(key_pattern, line):
                        key = match.group(1)
                        if key and key != 'LANGUAGE':  
                            keys.add(key)

                    
                    multiline_pattern = r'(\w+)\s*=\s*\[\[([^]]*)\]\]'
                    for match in re.finditer(multiline_pattern, line, re.DOTALL):
                        key = match.group(1)
                        if key and key != 'LANGUAGE':  
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

            
            
            in_language_table = False
            brace_depth = 0

            lines = content.split('\n')
            for line in lines:
                stripped_line = line.strip()

                
                if stripped_line == 'LANGUAGE = {' or stripped_line == 'LANGUAGE = {':
                    in_language_table = True
                    brace_depth = 1
                    continue
                elif in_language_table:
                    
                    brace_depth += line.count('{')
                    brace_depth -= line.count('}')

                    
                    if brace_depth <= 0:
                        in_language_table = False
                        break

                
                if in_language_table and brace_depth > 0:
                    
                    key_value_pattern = r'(\w+)\s*=\s*["\']'
                    for match in re.finditer(key_value_pattern, line):
                        key = match.group(1)
                        if key and key != 'LANGUAGE':
                            
                            start_pos = match.end() - 1  
                            quote_char = line[start_pos]
                            end_pos = start_pos + 1
                            while end_pos < len(line):
                                if line[end_pos] == quote_char:
                                    
                                    escape_count = 0
                                    check_pos = end_pos - 1
                                    while check_pos >= 0 and line[check_pos] == '\\':
                                        escape_count += 1
                                        check_pos -= 1
                                    
                                    if escape_count % 2 == 0:
                                        break
                                end_pos += 1
                            if end_pos < len(line):
                                value = line[start_pos + 1:end_pos]
                                arg_count = self._count_format_specifiers(value)
                                keys[key] = arg_count

                    
                    multiline_pattern = r'(\w+)\s*=\s*\[\['
                    for match in re.finditer(multiline_pattern, line):
                        key = match.group(1)
                        if key and key != 'LANGUAGE':
                            
                            start_pos = match.end()  
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

        
        if quote_char in ('"', "'"):
            end_pos = start_pos + 1
            result = []

            while end_pos < len(content):
                char = content[end_pos]

                if char == '\\' and end_pos + 1 < len(content):
                    
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

            return None, start_pos  

        
        elif content[start_pos:start_pos+2] == '[[':
            end_marker = content.find(']]', start_pos + 2)
            if end_marker == -1:
                return None, start_pos
            return content[start_pos+2:end_marker], end_marker + 2

        return None, start_pos

    def _count_format_specifiers(self, text: str) -> int:
        """Count the number of format specifiers in a string (excluding escaped %)"""
        
        
        pattern = r'%[^%]'
        matches = re.findall(pattern, text)
        return len(matches)

    def _normalize_localization_key(self, key: Optional[str]) -> Optional[str]:
        """Normalize localization references so @token and token share the same lookup key."""
        if not key:
            return key
        return key[1:] if key.startswith('@') else key

    @staticmethod
    def _looks_like_localization_key(value: Optional[str]) -> bool:
        """Return True when a string literal resembles a localization key/token."""
        if not value:
            return False
        return bool(re.match(r'^@?[A-Za-z_][A-Za-z0-9_\.:-]*$', value.strip()))

    @staticmethod
    def _is_probably_unlocalized_literal(value: Optional[str]) -> bool:
        """Heuristic for plain user-facing text that should likely be localized."""
        if not value:
            return False
        stripped = value.strip()
        if not stripped or stripped.startswith('@'):
            return False
        return not bool(re.match(r'^[A-Za-z_][A-Za-z0-9_\.:-]*$', stripped))

    @staticmethod
    def _lua_long_string_close(s: str, i: int) -> int:
        """If s[i] starts a Lua long string ([[ or [=*[), return the index just after its
        closing bracket.  Returns -1 if s[i] is not the start of a long string."""
        if i >= len(s) or s[i] != '[':
            return -1
        j = i + 1
        level = 0
        while j < len(s) and s[j] == '=':
            level += 1
            j += 1
        if j >= len(s) or s[j] != '[':
            return -1
        close = ']' + '=' * level + ']'
        end = s.find(close, j + 1)
        if end == -1:
            return -1
        return end + len(close)

    def _count_function_arguments(self, arg_str: str) -> int:
        """Count function arguments properly, handling nested parentheses and strings
        (including Lua [[...]] / [=[...]=] long strings)."""
        if not arg_str or arg_str == ',':
            return 0

        
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
                
                if char == '[':
                    end = self._lua_long_string_close(arg_str, i)
                    if end != -1:
                        current_arg.extend(list(arg_str[i:end]))
                        i = end
                        continue
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

        
        if current_arg:
            args.append(''.join(current_arg).strip())

        return len(args)

    def _split_top_level_args(self, arg_str: str) -> List[str]:
        """Split a Lua argument list into top-level arguments, respecting strings
        (including [[...]] long strings) and nested parentheses."""
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

            
            if char == '[':
                end = self._lua_long_string_close(arg_str, i)
                if end != -1:
                    current_arg.extend(list(arg_str[i:end]))
                    i = end
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

        
        return [a for a in args if a]

    def _find_matching_close_paren(self, content: str, open_paren_pos: int) -> int:
        """Return the index of the ')' that closes the '(' at open_paren_pos.
        Correctly skips over quoted strings ("", '') and Lua long strings ([[...]], [=[...]=]).
        Returns -1 if no matching ')' is found."""
        paren_depth = 0
        i = open_paren_pos
        in_string = False
        string_char = None

        while i < len(content):
            char = content[i]

            if in_string:
                if char == '\\':
                    i += 2  
                    continue
                if char == string_char:
                    in_string = False
                    string_char = None
                i += 1
                continue

            
            if char == '[':
                end = self._lua_long_string_close(content, i)
                if end != -1:
                    i = end
                    continue

            if char in ('"', "'"):
                in_string = True
                string_char = char
            elif char == '(':
                paren_depth += 1
            elif char == ')':
                paren_depth -= 1
                if paren_depth == 0:
                    return i

            i += 1

        return -1

    def _check_file_for_arg_mismatches(self, content: str, filename: str, lang_keys: Dict[str, int]) -> List[Dict]:
        """Check a single file for argument mismatches.

        ``content`` must already have Lua comments stripped so that examples
        in documentation block comments do not produce false positives.
        """
        mismatches = []
        lines = content.split('\n')

        
        
        
        
        
        
        patterns = [
            
            (r'\bL\s*\(\s*["\']',                                   'L',                            False),
            (r'\bL\s*\(\s*\[\[',                                    'L',                            False),
            
            (r'\blia\.lang\.getLocalizedString\s*\(\s*["\']',       'lia.lang.getLocalizedString',  False),
            (r'\blia\.lang\.getLocalizedString\s*\(\s*\[\[',        'lia.lang.getLocalizedString',  False),
            
            (r'\blia\.lang\.resolveToken\s*\(\s*["\']',             'lia.lang.resolveToken',        True),
            (r'\blia\.lang\.resolveToken\s*\(\s*\[\[',              'lia.lang.resolveToken',        True),
            
            (r':[A-Za-z_]+Localized\s*\(\s*["\']',                  'methodLocalized',              False),
            (r':[A-Za-z_]+Localized\s*\(\s*\[\[',                   'methodLocalized',              False),
        ]

        for pattern, func_name, at_only in patterns:
            for match in re.finditer(pattern, content):
                
                start_pos = match.end() - 1
                key, _end_pos = self._parse_lua_string_simple(content, start_pos)

                if not key:
                    continue

                
                if at_only and not key.startswith('@'):
                    continue

                normalized_key = self._normalize_localization_key(key)
                if not normalized_key:
                    continue

                
                open_paren_pos = content.find('(', match.start())
                if open_paren_pos == -1:
                    continue

                
                arg_end = self._find_matching_close_paren(content, open_paren_pos)
                if arg_end == -1:
                    continue

                arg_content = content[open_paren_pos + 1:arg_end]
                raw_arg_count = self._count_function_arguments(arg_content.strip())
                
                arg_count = max(0, raw_arg_count - 1)

                if normalized_key in lang_keys:
                    expected = lang_keys[normalized_key]
                    if arg_count != expected:
                        line_num = content[:match.start()].count('\n') + 1
                        mismatches.append({
                            'file': filename,
                            'line': line_num,
                            'function': func_name,
                            'key': normalized_key,
                            'expected': expected,
                            'provided': arg_count,
                            'context': lines[line_num - 1].strip() if line_num <= len(lines) else ''
                        })

        return mismatches

    def _compare_language_files(self) -> Dict[str, Dict[str, List[str]]]:
        """Compare all language files to find missing keys"""
        print("Comparing language files for missing keys...")

        
        language_keys = self._scan_all_language_files()

        if len(language_keys) < 2:
            print(f"Warning: Need at least 2 language files to compare, found {len(language_keys)}")
            return {}

        
        all_keys = set()
        for keys in language_keys.values():
            all_keys.update(keys)

        
        missing_keys = {}

        for base_lang, base_keys in language_keys.items():
            missing_keys[base_lang] = {}

            for other_lang, other_keys in language_keys.items():
                if base_lang == other_lang:
                    continue

                
                missing = sorted(list(other_keys - base_keys))
                missing_keys[base_lang][other_lang] = missing

        print(f"Compared {len(language_keys)} language files, found {len(all_keys)} total unique keys")
        return missing_keys

    def _iter_workspace_roots(self) -> List[Path]:
        """Return repository and configured module roots that exist on disk."""
        roots: List[Path] = []
        for root in [self.base_path, *[Path(p) for p in (self.modules_paths or [])]]:
            try:
                resolved = root.resolve()
            except Exception:
                resolved = root
            if root.exists() and resolved not in roots:
                roots.append(resolved)
        return roots

    def _scan_lua_files_for_net_analysis(self) -> List[Path]:
        """Return Lua files that should be included in code placement analyses."""
        lua_files: Dict[str, Path] = {}
        for root in self._iter_workspace_roots():
            for lua_file in root.rglob("*.lua"):
                path_text = str(lua_file).lower()
                if any(part in path_text for part in ("\\documentation\\", "/documentation/", "\\docs\\", "/docs/")):
                    continue
                if "_disabled" in path_text:
                    continue
                lua_files[str(lua_file.resolve()).lower()] = lua_file.resolve()
        return sorted(lua_files.values(), key=lambda path: str(path).lower())

    def _path_ref_for_report(self, file_path: Path) -> str:
        """Return a stable path reference for markdown reports."""
        try:
            return str(file_path.resolve().relative_to(self.base_path.resolve())).replace("\\", "/")
        except Exception:
            return str(file_path.resolve()).replace("\\", "/")

    def _resolve_report_path(self, file_ref: str) -> Optional[Path]:
        """Resolve a stored report path, accepting both absolute and base-relative refs."""
        if not file_ref:
            return None
        try:
            candidate = Path(file_ref)
            if candidate.is_absolute():
                return candidate.resolve()
            return (self.base_path / candidate).resolve()
        except Exception:
            return None

    def _discover_module_roots(self) -> List[Dict[str, Any]]:
        """Discover built-in, external, and nested module roots."""
        roots_by_path: Dict[str, Dict[str, Any]] = {}

        def add_module(path: Path, source: str):
            try:
                resolved = path.resolve()
            except Exception:
                return
            if not resolved.is_dir() or "_disabled" in str(resolved).lower():
                return
            roots_by_path[str(resolved).lower()] = {
                "name": resolved.name,
                "path": resolved,
                "source": source,
            }

        built_in_base = self.base_path / "modules"
        if built_in_base.exists():
            for child in built_in_base.iterdir():
                if child.is_dir():
                    add_module(child, "framework")
                    for module_lua in child.rglob("module.lua"):
                        add_module(module_lua.parent, "framework")

        for modules_base in (Path(p) for p in (self.modules_paths or [])):
            if not modules_base.exists():
                continue
            for child in modules_base.iterdir():
                if child.is_dir():
                    add_module(child, "external")
                    for module_lua in child.rglob("module.lua"):
                        add_module(module_lua.parent, "external")

        return sorted(roots_by_path.values(), key=lambda info: len(str(info["path"])), reverse=True)

    def _module_owner_for_path(self, file_ref_or_path: Any, module_roots: Optional[List[Dict[str, Any]]] = None) -> Optional[Dict[str, Any]]:
        """Return the most specific owning module for a file reference."""
        candidate = file_ref_or_path if isinstance(file_ref_or_path, Path) else self._resolve_report_path(str(file_ref_or_path or ""))
        if candidate is None:
            return None
        try:
            resolved = candidate.resolve()
        except Exception:
            return None
        for module in module_roots or self._discover_module_roots():
            try:
                if resolved.is_relative_to(module["path"].resolve()):
                    return module
            except Exception:
                continue
        return None

    def _path_is_under_named_child(self, file_ref_or_path: Any, module_path: Path, child_name: str) -> bool:
        """Return True when a file lives under a named module child folder."""
        candidate = file_ref_or_path if isinstance(file_ref_or_path, Path) else self._resolve_report_path(str(file_ref_or_path or ""))
        if candidate is None:
            return False
        try:
            return candidate.resolve().is_relative_to((module_path / child_name).resolve())
        except Exception:
            return False

    def _extract_lua_string_literals(self, text: str) -> List[str]:
        """Extract simple quoted or long-bracket Lua string literals from text."""
        values: List[str] = []
        for match in re.finditer(r'"((?:\\.|[^"\\])*)"|\'((?:\\.|[^\'\\])*)\'|\[\[(.*?)\]\]', text, re.DOTALL):
            if match.group(1) is not None:
                values.append(match.group(1))
            elif match.group(2) is not None:
                values.append(match.group(2))
            elif match.group(3) is not None:
                values.append(match.group(3))
        return [value for value in values if value]

    def _extract_named_string_tables(self, content: str, file_path: Path) -> Dict[str, Dict[str, Any]]:
        """Extract simple literal string tables like local x = {...} and MODULE.NetworkStrings = {...}."""
        tables: Dict[str, Dict[str, Any]] = {}
        assignment_pattern = re.compile(
            r'(?P<name>(?:local\s+)?[A-Za-z_][\w\.]*)\s*=\s*\{',
            re.MULTILINE
        )

        for match in assignment_pattern.finditer(content):
            raw_name = match.group("name").strip()
            table_name = raw_name.replace("local ", "", 1).strip()
            brace_start = match.end() - 1
            brace_depth = 0
            index = brace_start
            while index < len(content):
                char = content[index]
                if char == "{":
                    brace_depth += 1
                elif char == "}":
                    brace_depth -= 1
                    if brace_depth == 0:
                        table_body = content[brace_start + 1:index]
                        tables[table_name] = {
                            "strings": self._extract_lua_string_literals(table_body),
                            "line": content[:match.start()].count("\n") + 1,
                            "raw_name": raw_name,
                        }
                        break
                index += 1
        return tables

    def _record_net_message_site(self, bucket: Dict[str, List[Dict[str, Any]]], message_name: str, site: Dict[str, Any]):
        """Record a net-message site while deduplicating identical entries."""
        existing_sites = bucket.setdefault(message_name, [])
        site_key = (site["file"], site["line"], site["type"], site["detail"])
        existing_keys = {
            (entry["file"], entry["line"], entry["type"], entry["detail"])
            for entry in existing_sites
        }
        if site_key not in existing_keys:
            existing_sites.append(site)

    def _scan_net_message_definitions_in_file(self, file_path: Path, content: str, defined: Dict[str, List[Dict[str, Any]]]):
        """Extract base GMod net-message definitions from one file."""
        named_tables = self._extract_named_string_tables(content, file_path)

        rel_file = self._path_ref_for_report(file_path)

        for match in re.finditer(r'util\.AddNetworkString\s*\(\s*("((?:\\.|[^"\\])*)"|\'((?:\\.|[^\'\\])*)\'|\[\[(.*?)\]\])\s*\)', content):
            message_name = match.group(2) or match.group(3) or match.group(4)
            if not message_name:
                continue
            self._record_net_message_site(
                defined,
                message_name,
                {
                    "file": rel_file,
                    "line": content[:match.start()].count("\n") + 1,
                    "type": "direct util.AddNetworkString",
                    "detail": "literal util.AddNetworkString(...)",
                }
            )

        for loop_match in re.finditer(
            r'for\s+[^,\n]+,\s*(?P<item>[A-Za-z_]\w*)\s+in\s+ipairs\s*\(\s*(?P<table>[A-Za-z_][\w\.]*)\s*\)\s*do(?P<body>.*?)\bend\b',
            content,
            re.DOTALL
        ):
            loop_var = loop_match.group("item")
            table_name = loop_match.group("table")
            if table_name not in named_tables:
                continue
            body = loop_match.group("body")
            if not re.search(rf'util\.AddNetworkString\s*\(\s*{re.escape(loop_var)}\s*\)', body):
                continue
            source_type = "init.lua networkStrings" if file_path.name == "init.lua" and table_name == "networkStrings" else f"table via util.AddNetworkString loop ({table_name})"
            detail = f"strings from `{table_name}` passed to util.AddNetworkString({loop_var})"
            for message_name in named_tables[table_name]["strings"]:
                self._record_net_message_site(
                    defined,
                    message_name,
                    {
                        "file": rel_file,
                        "line": named_tables[table_name]["line"],
                        "type": source_type,
                        "detail": detail,
                    }
                )

        for table_name in ("MODULE.NetworkStrings", "SCHEMA.NetworkStrings"):
            table_info = named_tables.get(table_name)
            if not table_info:
                continue
            for message_name in table_info["strings"]:
                self._record_net_message_site(
                    defined,
                    message_name,
                    {
                        "file": rel_file,
                        "line": table_info["line"],
                        "type": table_name,
                        "detail": f"literal strings in `{table_name}` registered by modularity loader",
                    }
                )

    def _scan_net_message_usages_in_file(self, file_path: Path, content: str, used: Dict[str, List[Dict[str, Any]]]):
        """Extract base GMod net-message usage sites from one file."""
        usage_patterns = [
            (r'net\.Start\s*\(\s*("((?:\\.|[^"\\])*)"|\'((?:\\.|[^\'\\])*)\'|\[\[(.*?)\]\])', "net.Start", "send-side usage"),
            (r'net\.Receive\s*\(\s*("((?:\\.|[^"\\])*)"|\'((?:\\.|[^\'\\])*)\'|\[\[(.*?)\]\])', "net.Receive", "receive-side usage"),
            (r'lia\.net\.readBigTable\s*\(\s*("((?:\\.|[^"\\])*)"|\'((?:\\.|[^\'\\])*)\'|\[\[(.*?)\]\])', "lia.net.readBigTable", "Lilia helper receive usage"),
            (r'lia\.net\.writeBigTable\s*\(\s*[^,\n\)]+?\s*,\s*("((?:\\.|[^"\\])*)"|\'((?:\\.|[^\'\\])*)\'|\[\[(.*?)\]\])', "lia.net.writeBigTable", "Lilia helper send usage"),
        ]
        rel_file = self._path_ref_for_report(file_path)

        for pattern, site_type, detail in usage_patterns:
            for match in re.finditer(pattern, content, re.DOTALL):
                message_name = match.group(2) or match.group(3) or match.group(4)
                if not message_name:
                    continue
                self._record_net_message_site(
                    used,
                    message_name,
                    {
                        "file": rel_file,
                        "line": content[:match.start()].count("\n") + 1,
                        "type": site_type,
                        "detail": detail,
                    }
                )

    def _run_net_message_analysis(self) -> Tuple[Dict[str, List[Dict[str, Any]]], Dict[str, List[Dict[str, Any]]], List[str], List[str], List[str]]:
        """Analyze base GMod net-message definitions and usage sites."""
        defined: Dict[str, List[Dict[str, Any]]] = {}
        used: Dict[str, List[Dict[str, Any]]] = {}
        notes = [
            "Checked for `lia.net.register` and did not find an implementation in this repository; analysis is based on the real patterns present here.",
            "Definition detection includes literal `util.AddNetworkString(...)`, the `networkStrings` table flow in `gamemode/init.lua`, and literal `MODULE.NetworkStrings` / `SCHEMA.NetworkStrings` tables registered by `gamemode/core/libraries/modularity.lua`.",
            "Usage detection includes literal `net.Start(...)`, `net.Receive(...)`, `lia.net.readBigTable(...)`, and `lia.net.writeBigTable(...)`.",
            "Logical `netstream.Hook(...)` names are intentionally excluded from base net-message results; only the underlying `liaNetStreamData` message participates here.",
        ]

        for lua_file in self._scan_lua_files_for_net_analysis():
            try:
                content = lua_file.read_text(encoding='utf-8', errors='ignore')
            except Exception as e:
                print(f"Warning: Error reading {lua_file} during net-message analysis: {e}")
                continue

            content_clean = self._remove_lua_comments(content)
            self._scan_net_message_definitions_in_file(lua_file, content_clean, defined)
            self._scan_net_message_usages_in_file(lua_file, content_clean, used)

        defined_names = set(defined.keys())
        used_names = set(used.keys())
        for ignored_name in NET_MESSAGE_REPORT_IGNORE:
            defined.pop(ignored_name, None)
            used.pop(ignored_name, None)
            defined_names.discard(ignored_name)
            used_names.discard(ignored_name)
        unused_defined = sorted(defined_names - used_names, key=str.lower)
        used_but_undefined = sorted(used_names - defined_names, key=str.lower)
        return defined, used, unused_defined, used_but_undefined, notes

    def _run_module_net_registration_analysis(
        self,
        defined: Dict[str, List[Dict[str, Any]]],
        used: Dict[str, List[Dict[str, Any]]],
    ) -> Tuple[List[Dict[str, Any]], List[Dict[str, Any]], List[str]]:
        """Find module-local net messages whose registrations are missing or outside the module."""
        module_roots = self._discover_module_roots()
        misregistered: List[Dict[str, Any]] = []
        undefined: List[Dict[str, Any]] = []
        notes = [
            "A message is treated as module-specific when all detected literal usage sites belong to one module.",
            "Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.",
        ]

        for message_name, usage_sites in sorted((used or {}).items(), key=lambda item: item[0].lower()):
            usage_modules = [self._module_owner_for_path(site.get("file"), module_roots) for site in usage_sites]
            if not usage_sites or any(module is None for module in usage_modules):
                continue
            module_paths = {str(module["path"].resolve()).lower() for module in usage_modules if module}
            if len(module_paths) != 1:
                continue

            module = usage_modules[0]
            definition_sites = defined.get(message_name, []) or []
            in_module_defs = [
                site for site in definition_sites
                if self._module_owner_for_path(site.get("file"), module_roots)
                and self._module_owner_for_path(site.get("file"), module_roots)["path"].resolve() == module["path"].resolve()
            ]

            base_entry = {
                "message": message_name,
                "module_name": module["name"],
                "module_path": str(module["path"]),
                "usage_sites": usage_sites,
                "definition_sites": definition_sites,
            }
            if not definition_sites:
                undefined.append({
                    **base_entry,
                    "reason": f'Used only by module "{module["name"]}" and not defined anywhere',
                })
            elif not in_module_defs:
                misregistered.append({
                    **base_entry,
                    "reason": f'Used only by module "{module["name"]}" but defined outside that module',
                })

        return misregistered, undefined, notes

    def _infer_lua_site_side(self, site: Dict[str, Any]) -> str:
        """Infer the likely Lua execution side from path naming conventions."""
        file_ref = (site.get("file") or "").replace("\\", "/").lower()
        name = Path(file_ref).name
        if name.startswith("cl_") or name == "client.lua" or "/client/" in file_ref or "/derma/" in file_ref:
            return "client"
        if name.startswith("sv_") or name in {"server.lua", "init.lua"} or "/server/" in file_ref:
            return "server"
        if name.startswith("sh_") or name == "shared.lua":
            return "shared"
        return "unknown"

    def _run_net_direction_analysis(self, used: Dict[str, List[Dict[str, Any]]]) -> List[Dict[str, Any]]:
        """Find suspicious one-sided or same-side net-message flow patterns."""
        issues: List[Dict[str, Any]] = []
        sender_types = {"net.Start", "lia.net.writeBigTable"}
        receiver_types = {"net.Receive", "lia.net.readBigTable"}

        for message_name, sites in sorted((used or {}).items(), key=lambda item: item[0].lower()):
            senders = [site for site in sites if site.get("type") in sender_types]
            receivers = [site for site in sites if site.get("type") in receiver_types]
            if not senders and not receivers:
                continue

            send_sides = sorted({self._infer_lua_site_side(site) for site in senders})
            receive_sides = sorted({self._infer_lua_site_side(site) for site in receivers})
            reason = None
            if receivers and not senders:
                reason = "Message has receivers but no detected senders"
            elif senders and not receivers:
                reason = "Message has senders but no detected receivers"
            elif set(send_sides) == {"client"} and set(receive_sides) == {"client"}:
                reason = "Message appears to send and receive only on the client side"
            elif set(send_sides) == {"server"} and set(receive_sides) == {"server"}:
                reason = "Message appears to send and receive only on the server side"

            if reason:
                issues.append({
                    "message": message_name,
                    "sender_sites": senders,
                    "receiver_sites": receivers,
                    "send_sides": send_sides,
                    "receive_sides": receive_sides,
                    "reason": reason,
                })

        return issues

    def _scan_derma_panel_analysis(self) -> Tuple[List[Dict[str, Any]], Set[str], List[Dict[str, Any]], List[Dict[str, Any]], List[Dict[str, Any]]]:
        """Scan Derma panel definitions, use sites, and module placement issues."""
        module_roots = self._discover_module_roots()
        panels_defined: List[Dict[str, Any]] = []
        panels_used: Set[str] = set()
        module_panels_outside_folder: List[Dict[str, Any]] = []
        file_placement_issues: List[Dict[str, Any]] = []
        ui_create_counts: Dict[str, Dict[str, Any]] = {}

        lua_string = r'("((?:\\.|[^"\\])*)"|\'((?:\\.|[^\'\\])*)\'|\[\[(.*?)\]\])'
        register_pattern = re.compile(
            rf'vgui\.Register\s*\(\s*{lua_string}\s*,\s*[^,\n\)]+(?:\s*,\s*{lua_string})?',
        )
        # Derma controls are commonly created through a parent panel's
        # ``:Add("ControlName")`` method rather than ``vgui.Create``.  The
        # old scanner only saw the latter, so virtually every panel used by a
        # normal ``panel:Add(...)`` call was reported as unused.  Keep the
        # patterns separate so that AddSheet/AddItem/etc. are not mistaken for
        # panel construction, while still supporting the standard control-table
        # probe used for optional panels.
        create_pattern = re.compile(
            rf'(?:vgui\.Create|:[ \t]*Add)\s*\(\s*{lua_string}',
            re.DOTALL,
        )
        control_table_pattern = re.compile(
            rf'vgui\.GetControlTable\s*\(\s*{lua_string}',
            re.DOTALL,
        )

        for lua_file in self._scan_lua_files_for_net_analysis():
            try:
                content = lua_file.read_text(encoding='utf-8', errors='ignore')
            except Exception as e:
                print(f"Warning: Error reading {lua_file} during Derma analysis: {e}")
                continue

            content_clean = self._remove_lua_comments(content)
            rel_file = self._path_ref_for_report(lua_file)
            module = self._module_owner_for_path(lua_file, module_roots)

            create_matches = list(create_pattern.finditer(content_clean))
            control_table_matches = list(control_table_pattern.finditer(content_clean))
            if create_matches or control_table_matches:
                for match in create_matches + control_table_matches:
                    # The string is the first capture from lua_string for
                    # vgui.Create/:Add, and the same capture after the
                    # vgui.GetControlTable prefix.
                    panel_name = match.group(2) or match.group(3) or match.group(4)
                    if panel_name:
                        panels_used.add(panel_name)
                ui_create_counts[rel_file] = {
                    "count": len(create_matches),
                    "line": content_clean[:(create_matches or control_table_matches)[0].start()].count("\n") + 1,
                    "module": module,
                    "path": lua_file,
                }

            for match in register_pattern.finditer(content_clean):
                panel_name = match.group(2) or match.group(3) or match.group(4)
                base_panel = match.group(6) or match.group(7) or match.group(8)
                if not panel_name:
                    continue
                if base_panel:
                    panels_used.add(base_panel)
                line = content_clean[:match.start()].count("\n") + 1
                panel_entry = {
                    "panel": panel_name,
                    "base_panel": base_panel,
                    "file": rel_file,
                    "line": line,
                    "module_name": module["name"] if module else None,
                    "module_path": str(module["path"]) if module else None,
                }
                panels_defined.append(panel_entry)

                if module and not self._path_is_under_named_child(lua_file, module["path"], "derma"):
                    issue = {
                        **panel_entry,
                        "expected_folder": str(module["path"] / "derma"),
                        "reason": f'Panel belongs to module "{module["name"]}" but is defined outside its derma folder',
                    }
                    module_panels_outside_folder.append(issue)
                    file_placement_issues.append({
                        "type": "UI / Derma Code Outside derma",
                        "module_name": module["name"],
                        "module_path": str(module["path"]),
                        "file": rel_file,
                        "line": line,
                        "reason": "Module Derma code is outside the derma folder",
                        "expected_folder": str(module["path"] / "derma"),
                    })

        # Dynamic construction of shared/base controls is not a panel-owned
        # placement violation. Only explicit vgui.Register definitions above
        # establish panel ownership; creation sites are retained for usage
        # and unused-panel analysis but must not produce folder warnings.

        defined_names = {entry["panel"] for entry in panels_defined}
        unused_panels = [
            entry for entry in panels_defined
            if entry["module_name"]
            and entry["panel"] not in panels_used
            and entry["panel"] in defined_names
        ]
        unused_panels.sort(key=lambda entry: ((entry.get("module_name") or ""), entry["panel"].lower(), entry["file"], entry["line"]))
        module_panels_outside_folder.sort(key=lambda entry: ((entry.get("module_name") or ""), entry["file"], entry["line"]))
        file_placement_issues.sort(key=lambda entry: (entry["type"], entry["module_name"], entry["file"], entry["line"]))
        return panels_defined, panels_used, unused_panels, module_panels_outside_folder, file_placement_issues

    def _run_module_file_placement_analysis(self, used: Dict[str, List[Dict[str, Any]]], existing_issues: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Find module-owned net handlers outside the conventional netcalls folder."""
        module_roots = self._discover_module_roots()
        issues = list(existing_issues or [])
        seen = {
            (issue.get("type"), issue.get("file"), issue.get("line"), issue.get("module_name"))
            for issue in issues
        }

        for sites in (used or {}).values():
            for site in sites:
                if site.get("type") != "net.Receive":
                    continue
                # These are deferred request/response receivers created inside
                # module API methods. They close over the method's Deferred and
                # are not load-time net handlers that can be moved safely.
                if site.get("file") == "modules/mainmenu/module.lua":
                    continue
                module = self._module_owner_for_path(site.get("file"), module_roots)
                if not module or self._path_is_under_named_child(site.get("file"), module["path"], "netcalls"):
                    continue
                issue = {
                    "type": "Net Handlers Outside netcalls",
                    "module_name": module["name"],
                    "module_path": str(module["path"]),
                    "file": site.get("file"),
                    "line": site.get("line"),
                    "reason": "Module net handler is outside the netcalls folder",
                    "expected_folder": str(module["path"] / "netcalls"),
                }
                key = (issue["type"], issue["file"], issue["line"], issue["module_name"])
                if key not in seen:
                    seen.add(key)
                    issues.append(issue)

        return sorted(issues, key=lambda entry: (entry["type"], entry["module_name"], entry["file"], entry["line"]))

    def _collect_language_file_targets(self) -> List[Dict[str, Any]]:
        """Collect framework and module language files for duplicate-key analysis."""
        targets: List[Dict[str, Any]] = []
        seen: Set[str] = set()
        languages = ["english", "french", "german", "portuguese", "spanish", "russian"]

        def add_target(file_path: Path, language: str, scope: str, module_name: Optional[str] = None):
            try:
                resolved = str(file_path.resolve()).lower()
            except Exception:
                resolved = str(file_path).lower()
            if resolved in seen or not file_path.exists():
                return
            seen.add(resolved)
            targets.append({
                "path": file_path,
                "language": language,
                "scope": scope,
                "module_name": module_name,
                "file": self._path_ref_for_report(file_path),
            })

        for language in languages:
            add_target(self.base_path / "languages" / f"{language}.lua", language, "framework")

        for module in self._discover_module_roots():
            module_path = module.get("path")
            module_name = module.get("name")
            if not isinstance(module_path, Path):
                continue
            for language in languages:
                add_target(module_path / "languages" / f"{language}.lua", language, "module", module_name)

        return sorted(targets, key=lambda entry: (entry["scope"], entry.get("module_name") or "", entry["language"], entry["file"]))

    def _scan_duplicate_assignments_in_file(self, file_path: Path, pattern: re.Pattern, value_group: Optional[str] = None) -> List[Dict[str, Any]]:
        """Find duplicate keyed assignments in a file while keeping the first occurrence."""
        duplicates: List[Dict[str, Any]] = []
        key_occurrences: Dict[str, Dict[str, Any]] = {}
        try:
            lines = file_path.read_text(encoding="utf-8", errors="ignore").splitlines()
        except OSError:
            return duplicates

        for line_num, line in enumerate(lines, 1):
            match = pattern.match(line)
            if not match:
                continue
            key = match.group("key") if "key" in match.re.groupindex else match.group(1)
            value = ""
            if value_group:
                try:
                    value = match.group(value_group) or ""
                except IndexError:
                    value = ""
            if key not in key_occurrences:
                key_occurrences[key] = {
                    "first_line": line_num,
                    "first_value": value,
                    "first_raw": line.strip(),
                }
                continue

            first = key_occurrences[key]
            duplicates.append({
                "key": key,
                "value": value,
                "line": line_num,
                "raw": line.strip(),
                "first_line": first["first_line"],
                "first_value": first["first_value"],
                "first_raw": first["first_raw"],
            })

        return duplicates

    def _run_duplicate_key_analysis(self) -> Dict[str, Any]:
        """Analyze duplicate keyed assignments across language files using both language-specific and generic patterns."""
        language_pattern = re.compile(r'^\s*(?P<key>\w+)\s*=\s*"(?P<value>[^"]*)"', re.MULTILINE)
        generic_pattern = re.compile(r'^\s*(?P<key>\[?"?[\w]+"?\]?)\s*=\s*".*",?', re.MULTILINE)

        language_files: List[Dict[str, Any]] = []
        generic_files: List[Dict[str, Any]] = []
        language_duplicate_total = 0
        generic_duplicate_total = 0

        for target in self._collect_language_file_targets():
            file_path: Path = target["path"]
            language_duplicates = self._scan_duplicate_assignments_in_file(file_path, language_pattern, value_group="value")
            generic_duplicates = self._scan_duplicate_assignments_in_file(file_path, generic_pattern)

            language_duplicate_total += len(language_duplicates)
            generic_duplicate_total += len(generic_duplicates)

            if language_duplicates:
                language_files.append({
                    **{k: v for k, v in target.items() if k != "path"},
                    "duplicate_count": len(language_duplicates),
                    "duplicates": language_duplicates,
                })
            if generic_duplicates:
                generic_files.append({
                    **{k: v for k, v in target.items() if k != "path"},
                    "duplicate_count": len(generic_duplicates),
                    "duplicates": generic_duplicates,
                })

        return {
            "dry_run": True,
            "language_duplicates": {
                "total_duplicates": language_duplicate_total,
                "files_with_duplicates": len(language_files),
                "files": language_files,
            },
            "generic_duplicates": {
                "total_duplicates": generic_duplicate_total,
                "files_with_duplicates": len(generic_files),
                "files": generic_files,
            },
        }

    def _privilege_extract_used_in_dir(self, base_dir: Path) -> List[str]:
        pattern = re.compile(r"[:.]hasPrivilege\s*\(\s*(['\"])([^'\"\s)]+)\1\s*\)", re.IGNORECASE | re.DOTALL)
        privileges: Set[str] = set()
        for lua_file in base_dir.rglob("*.lua"):
            try:
                content = lua_file.read_text(encoding="utf-8", errors="ignore")
            except OSError:
                continue
            for _, privilege_id in pattern.findall(content):
                privileges.add(privilege_id)
        return sorted(privileges, key=str.lower)

    def _privilege_load_localizations(self) -> Dict[str, str]:
        localizations: Dict[str, str] = {}
        language_path = Path(self.language_file)
        if not language_path.exists():
            return localizations
        try:
            content = language_path.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            return localizations
        for key, value in re.findall(r'^\s*(\w+)\s*=\s*"(.*?)"\s*$', content, re.MULTILINE):
            localizations[key] = value
        for key, value in re.findall(r'^\s*L\.\s*(\w+)\s*=\s*"(.*?)"\s*$', content, re.MULTILINE):
            localizations[key] = value
        for key, value in re.findall(r'L\[\s*["\']([^"\']+)["\']\s*\]\s*=\s*["\']([^"\']*)["\']', content, re.MULTILINE):
            localizations[key] = value
        for key, value in re.findall(
            r'lia\.(?:lang|language)\.Add\(\s*["\']([^"\']+)["\']\s*,\s*["\']([^"\']*)["\']\s*\)',
            content,
            re.IGNORECASE,
        ):
            localizations[key] = value
        return localizations

    def _privilege_load_registered_json_ids(self) -> List[str]:
        data_path = self.base_path.parent / "data" / "lilia_registered_privileges.json"
        if not data_path.exists():
            return []
        try:
            payload = json.loads(data_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            return []

        ids: List[str] = []
        seen: Set[str] = set()

        def add(value: Any):
            text = str(value)
            if text and text != "None" and text not in seen:
                seen.add(text)
                ids.append(text)

        def walk(value: Any):
            if isinstance(value, list):
                for item in value:
                    walk(item)
            elif isinstance(value, dict):
                for key, item in value.items():
                    if key.lower() == "id" and isinstance(item, (str, int)):
                        add(item)
                    elif key.lower() == "privileges":
                        walk(item)
                    elif isinstance(item, (list, dict)):
                        walk(item)
            elif isinstance(value, (str, int)):
                add(value)

        walk(payload)
        return sorted(ids, key=str.lower)

    def _privilege_extract_registered_ids_from_content(self, content: str) -> List[str]:
        ids: Set[str] = set()
        start_pos = 0
        while True:
            match = re.search(r"\bPrivileges\s*=\s*\{", content[start_pos:], re.IGNORECASE)
            if not match:
                break
            block_start = start_pos + match.end() - 1
            index = block_start
            depth = 0
            in_string = False
            string_char = ""
            escaped = False
            while index < len(content):
                char = content[index]
                if in_string:
                    if escaped:
                        escaped = False
                    elif char == "\\":
                        escaped = True
                    elif char == string_char:
                        in_string = False
                else:
                    if char in ('"', "'"):
                        in_string = True
                        string_char = char
                    elif char == "{":
                        depth += 1
                    elif char == "}":
                        depth -= 1
                        if depth == 0:
                            block_end = index
                            break
                index += 1
            else:
                block_end = len(content)
            block = content[block_start:block_end + 1]
            brace_depth = 0
            for line in block.splitlines():
                if brace_depth == 1:
                    key_match = re.match(r'^\s*(?:\[\s*["\']([^"\']+)["\']\s*\]|([A-Za-z_]\w*))\s*=\s*\{', line)
                    if key_match:
                        privilege_id = key_match.group(1) or key_match.group(2)
                        if privilege_id and privilege_id.lower() != "privileges":
                            ids.add(privilege_id)

                in_string = False
                string_char = ""
                escaped = False
                for char in line:
                    if in_string:
                        if escaped:
                            escaped = False
                        elif char == "\\":
                            escaped = True
                        elif char == string_char:
                            in_string = False
                    else:
                        if char in ('"', "'"):
                            in_string = True
                            string_char = char
                        elif char == "{":
                            brace_depth += 1
                        elif char == "}":
                            brace_depth = max(0, brace_depth - 1)
            for privilege_id in re.findall(r'(?i)\bID\s*=\s*["\']([^"\']+)["\']', block):
                ids.add(privilege_id)
            start_pos = block_end + 1
        return sorted(ids, key=str.lower)

    def _privilege_extract_registered_ids_in_dir(self, base_dir: Path) -> List[str]:
        ids: Set[str] = set()
        for lua_file in base_dir.rglob("*.lua"):
            try:
                content = lua_file.read_text(encoding="utf-8", errors="ignore")
            except OSError:
                continue
            for privilege_id in self._privilege_extract_registered_ids_from_content(content):
                ids.add(privilege_id)
        return sorted(ids, key=str.lower)

    def _privilege_build_framework_report(self, used: List[str], registered: List[str], localizations: Dict[str, str]) -> Dict[str, Any]:
        used_set = set(used)
        registered_set = set(registered)
        missing = sorted(used_set - registered_set, key=str.lower)
        unused = sorted(registered_set - used_set, key=str.lower)
        return {
            "counts": {
                "used_in_code": len(used),
                "registered": len(registered),
                "used_but_not_registered": len(missing),
                "registered_but_not_used": len(unused),
            },
            "used_but_not_registered": [{"id": privilege_id, "name": localizations.get(privilege_id, "")} for privilege_id in missing],
            "registered_but_not_used": [{"id": privilege_id, "name": localizations.get(privilege_id, "")} for privilege_id in unused],
        }

    def _privilege_build_module_reports(self, framework_registered: List[str], localizations: Dict[str, str]) -> List[Dict[str, Any]]:
        reports: List[Dict[str, Any]] = []
        framework_registered_set = set(framework_registered)
        seen_paths: Set[str] = set()

        for module in sorted(self._discover_module_roots(), key=lambda entry: str(entry.get("name", "")).lower()):
            module_path = module.get("path")
            module_name = module.get("name") or Path(module_path).name
            if not isinstance(module_path, Path):
                continue
            try:
                resolved_key = str(module_path.resolve()).lower()
            except Exception:
                resolved_key = str(module_path).lower()
            if resolved_key in seen_paths:
                continue
            seen_paths.add(resolved_key)

            used = self._privilege_extract_used_in_dir(module_path)
            registered_in_module = self._privilege_extract_registered_ids_in_dir(module_path)
            allowed = framework_registered_set | set(registered_in_module)
            missing = sorted(set(used) - allowed, key=str.lower)
            reports.append({
                "name": module_name,
                "path": str(module_path),
                "scope": module.get("source", "module"),
                "counts": {
                    "used_in_code": len(used),
                    "registered_in_module": len(registered_in_module),
                    "missing_registrations": len(missing),
                },
                "used_but_not_registered": [{"id": privilege_id, "name": localizations.get(privilege_id, "")} for privilege_id in missing],
            })

        return reports

    def _run_privilege_analysis(self) -> Dict[str, Any]:
        """Analyze privilege usage and registration coverage for the framework and modules."""
        localizations = self._privilege_load_localizations()
        used = self._privilege_extract_used_in_dir(self.base_path)
        registered_json = self._privilege_load_registered_json_ids()
        registered_lua = self._privilege_extract_registered_ids_in_dir(self.base_path)
        framework_registered = sorted(set(registered_json) | set(registered_lua), key=str.lower)
        framework_report = self._privilege_build_framework_report(used, framework_registered, localizations)
        module_reports = self._privilege_build_module_reports(framework_registered, localizations)

        return {
            "generated_at": datetime.utcnow().replace(microsecond=0).isoformat() + "Z",
            "repo_root": str(self.base_path.parent),
            "framework": framework_report,
            "modules": module_reports,
            "counts": {
                "modules_scanned": len(module_reports),
                "modules_with_missing_registrations": len([entry for entry in module_reports if entry["counts"]["missing_registrations"] > 0]),
            },
        }

    def run_all_analyses(self) -> CombinedReportData:
        """Run all three analyses and combine results"""

        print("Running comprehensive analysis...")
        print("=" * 60)

        
        print("Analyzing function documentation...")
        function_results = self._run_function_comparison()

        
        print("Analyzing hooks documentation...")
        hooks_missing, hooks_documented, hooks_registered, hooks_method, hooks_standard = self._run_hooks_analysis()

        
        print("Analyzing localization...")
        localization_data, modules_data, module_localization_conflicts = self._run_localization_analysis()

        
        print("Detecting argument mismatches...")
        argument_mismatches = self._detect_argument_mismatches()

        
        print("Detecting inferred localization (resolved at source)...")
        inferred_localization = self._detect_inferred_localization()

        
        modules_scan = []
        if self.generate_module_docs:
            print("Scanning external modules for undocumented items...")
            modules_scan = self._scan_modules_for_undocumented()

        
        print("Comparing language files...")
        language_comparison = self._compare_language_files()

        
        print("Analyzing fonts...")
        fonts_registered, fonts_used, fonts_unregistered, fonts_default_gmod, fonts_variable, fonts_getfont_count, fonts_file_usages = self._run_font_analysis()

        
        print("Detecting undefined lia.config.get calls...")
        config_undefined_get_calls = self._detect_undefined_config_get_calls()

        
        print("Analyzing net messages...")
        net_messages_defined, net_messages_used, net_messages_unused_defined, net_messages_used_but_undefined, net_message_analysis_notes = self._run_net_message_analysis()
        module_net_messages_misregistered, module_net_messages_undefined, module_net_messages_notes = self._run_module_net_registration_analysis(
            net_messages_defined,
            net_messages_used,
        )
        net_messages_direction_issues = self._run_net_direction_analysis(net_messages_used)
        print("Analyzing Derma panels and module file placement...")
        derma_panels_defined, derma_panels_used, derma_panels_unused, module_derma_panels_outside_folder, derma_file_placement_issues = self._scan_derma_panel_analysis()
        module_file_placement_issues = self._run_module_file_placement_analysis(net_messages_used, derma_file_placement_issues)

        
        print("Analyzing duplicate keys...")
        duplicate_key_analysis = self._run_duplicate_key_analysis()

        
        print("Analyzing privileges...")
        privilege_report = self._run_privilege_analysis()

        
        undefined_inferred_loc_keys = []
        print("Detecting undefined inferred localization keys...")
        undefined_inferred_loc_keys = self._detect_undefined_inferred_loc_keys()

        
        missing_library_functions, missing_hook_functions, missing_meta_functions = self._categorize_missing_functions(function_results)

        return CombinedReportData(
            function_comparison=function_results,
            hooks_missing=hooks_missing,
            hooks_documented=hooks_documented,
            hooks_registered=hooks_registered,
            hooks_signatures=getattr(self, 'hooks_signatures', {}),
            hooks_locations=getattr(self, 'hooks_locations', {}),
            hooks_method=hooks_method,
            hooks_standard=hooks_standard,
            localization_data=localization_data,
            argument_mismatches=argument_mismatches,
            inferred_localization=inferred_localization,
            modules_data=modules_data,
            module_localization_conflicts=module_localization_conflicts,
            modules_scan=modules_scan,
            language_comparison=language_comparison,
            missing_library_functions=missing_library_functions,
            missing_hook_functions=missing_hook_functions,
            missing_meta_functions=missing_meta_functions,
            fonts_registered=fonts_registered,
            fonts_used=fonts_used,
            fonts_unregistered=fonts_unregistered,
            fonts_default_gmod=fonts_default_gmod,
            fonts_variable=fonts_variable,
            fonts_getfont_count=fonts_getfont_count,
            fonts_file_usages=fonts_file_usages,
            config_undefined_get_calls=config_undefined_get_calls,
            undefined_inferred_loc_keys=undefined_inferred_loc_keys,
            net_messages_defined=net_messages_defined,
            net_messages_used=net_messages_used,
            net_messages_unused_defined=net_messages_unused_defined,
            net_messages_used_but_undefined=net_messages_used_but_undefined,
            net_message_analysis_notes=net_message_analysis_notes,
            module_net_messages_misregistered=module_net_messages_misregistered,
            module_net_messages_undefined=module_net_messages_undefined,
            module_net_messages_notes=module_net_messages_notes,
            net_messages_direction_issues=net_messages_direction_issues,
            derma_panels_defined=derma_panels_defined,
            derma_panels_used=derma_panels_used,
            derma_panels_unused=derma_panels_unused,
            module_derma_panels_outside_folder=module_derma_panels_outside_folder,
            module_file_placement_issues=module_file_placement_issues,
            duplicate_key_analysis=duplicate_key_analysis,
            privilege_report=privilege_report,
            generated_at=datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        )

    def _categorize_missing_functions(self, function_comparison: Dict[str, Dict]) -> Tuple[List[FunctionInfo], List[FunctionInfo], List[FunctionInfo]]:
        """Categorize missing functions into library, hook, and meta types"""
        missing_library_functions = []
        missing_hook_functions = []
        missing_meta_functions = []

        
        documented_libraries = self._get_documented_library_functions()
        documented_hooks = set(self.hooks_documented) if hasattr(self, 'hooks_documented') else set()
        documented_meta = self._get_documented_meta_functions()

        
        for file_data in function_comparison.values():
            for func_name in file_data.get('missing_functions', []):
                
                func_info = file_data.get('functions', {}).get(func_name)
                if not func_info:
                    continue

                
                function_info = FunctionInfo(
                    name=func_name,
                    parameters=func_info.get('parameters', [])
                )

                
                existing_names = {f.name for f in missing_library_functions + missing_hook_functions + missing_meta_functions}
                if func_name in existing_names:
                    continue

                
                if func_name in documented_libraries or self._is_library_function(func_name):
                    missing_library_functions.append(function_info)
                elif func_name in documented_hooks or self._is_hook_function(func_name):
                    missing_hook_functions.append(function_info)
                elif func_name in documented_meta or self._is_meta_function(func_name):
                    missing_meta_functions.append(function_info)
                else:
                    
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
                
                for match in re.finditer(r'^###+\s+([A-Za-z_][\w\.:]*)\s*$', content, re.MULTILINE):
                    func_name = match.group(1).strip()
                    if '.' in func_name or md_file.stem == 'lia.core':
                        documented_functions.add(func_name if '.' in func_name else f'lia.{func_name}')
                
                for match in re.finditer(r'<summary><a[^>]*></a>([A-Za-z_][\w\.:]+)\([^)]*\)</summary>', content):
                    func_name = match.group(1).strip()
                    if '.' in func_name or md_file.stem == 'lia.core':
                        documented_functions.add(func_name if '.' in func_name else f'lia.{func_name}')
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
                
                for match in re.finditer(r'`([A-Za-z_][\w\.:]*)\([^)]*\)`', content):
                    method_name = match.group(1).strip()
                    documented_functions.add(method_name)
                
                
                stem = md_file.stem
                overrides = {
                    'tool': 'toolGunMeta',
                }
                meta_table = overrides.get(stem, f"{stem}Meta")
                for match in re.finditer(r'<summary><a[^>]*></a>([A-Za-z_][\w]+)\([^)]*\)</summary>', content):
                    method_name = match.group(1).strip()
                    
                    qualified_name = f"{meta_table}:{method_name}"
                    documented_functions.add(qualified_name)
            except Exception:
                continue

        return documented_functions

    def _is_library_function(self, func_name: str) -> bool:
        """Check if a function name indicates it's a library function"""
        
        return func_name.startswith('lia.') and func_name.count('.') >= 1

    def _is_hook_function(self, func_name: str) -> bool:
        """Check if a function name indicates it's a hook function"""
        
        
        return '.' not in func_name and len(func_name) > 0

    def _is_meta_function(self, func_name: str) -> bool:
        """Check if a function name indicates it's a meta function"""
        
        
        meta_patterns = [
            r'^[A-Za-z_][a-z_]*\.[A-Za-z_]',  
            r'^[A-Z][a-zA-Z]*\.[A-Z][a-zA-Z]*',  
        ]
        return any(re.match(pattern, func_name) for pattern in meta_patterns)

    def _run_function_comparison(self) -> Dict[str, Dict]:
        """Run function documentation comparison analysis"""
        try:
            return self.function_comparator.compare_functions()
        except Exception as e:
            print(f"Error in function comparison: {e}")
            return {}

    def _run_hooks_analysis(self) -> Tuple[List[str], List[str], List[str], List[str], List[str]]:
        """Run hooks documentation analysis"""
        try:
            hooks_registered, hooks_signatures, hook_locations, method_hooks, standard_hooks = self._scan_hook_registrations_with_signatures()
            hooks_registered = [h for h in hooks_registered if h not in HOOKS_REPORT_IGNORE]
            method_hooks = {h for h in method_hooks if h not in HOOKS_REPORT_IGNORE}
            standard_hooks = {h for h in standard_hooks if h not in HOOKS_REPORT_IGNORE}
            if hooks_signatures:
                for h in HOOKS_REPORT_IGNORE:
                    hooks_signatures.pop(h, None)
            if hook_locations:
                for h in HOOKS_REPORT_IGNORE:
                    hook_locations.pop(h, None)

            self.hooks_signatures = hooks_signatures
            self.hooks_locations = hook_locations
            hooks_documented = self._read_all_documented_hooks()
            hooks_missing = [h for h in hooks_registered if h not in hooks_documented]
            return (sorted(hooks_missing), sorted(list(hooks_documented)), hooks_registered,
                    sorted(list(method_hooks)), sorted(list(standard_hooks)))
        except Exception as e:
            print(f"Error in hooks analysis: {e}")
            return [], [], [], [], []

    def _read_all_documented_hooks(self) -> Set[str]:
        """Read documented hooks from all hooks documentation files"""
        documented_hooks = set()
        
        if not self.hooks_doc_dir.exists():
            print(f"Warning: Hooks documentation directory not found: {self.hooks_doc_dir}")
            return documented_hooks
        
        
        for md_file in self.hooks_doc_dir.glob("*.md"):
            try:
                file_hooks = read_documented_hooks(str(md_file))
                documented_hooks.update(file_hooks)
            except Exception as e:
                print(f"Warning: Could not read hooks from {md_file}: {e}")
                continue

        
        
        
        for library_dir in (
            self.docs_path / "docs" / "developer" / "libraries",
            self.docs_path / "docs" / "development" / "libraries",
            self.docs_path / "docs" / "libraries",
        ):
            if not library_dir.exists():
                continue

            for md_file in library_dir.glob("*.md"):
                try:
                    documented_hooks.update(self._read_library_documented_hooks(md_file))
                except Exception as e:
                    print(f"Warning: Could not read library hooks from {md_file}: {e}")
                    continue
        
        return documented_hooks

    def _read_library_documented_hooks(self, file_path: Path) -> Set[str]:
        """Extract hook names documented inside library pages."""
        documented_hooks: Set[str] = set()

        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        
        
        for match in re.finditer(r'<summary\b[^>]*>.*?([A-Z][A-Za-z0-9_]+)\([^)]*\)</summary>', content, re.DOTALL):
            hook_name = match.group(1).strip()
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                documented_hooks.add(hook_name)

        
        for match in re.finditer(r'hook\.Add\s*\(\s*["\']([^"\']+)["\']', content):
            hook_name = match.group(1).strip()
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                documented_hooks.add(hook_name)

        return documented_hooks

    def _remove_lua_comments(self, content: str) -> str:
        """Remove Lua comments and documentation code blocks from content to avoid detecting commented-out or example code.

        Handles:
        - Single line comments: -- comment
        - Multi-line comments: --[[ comment ]]
        - Long string comments: --[=[ comment ]=]
        - Markdown code blocks: ```lua ... ```
        """
        
        
        long_comment_pattern = r'--\[(=*)\[.*?\]\1\]'
        content = re.sub(long_comment_pattern, '', content, flags=re.DOTALL)

        
        
        code_block_pattern = r'```.*?```'
        content = re.sub(code_block_pattern, '', content, flags=re.DOTALL | re.IGNORECASE)

        
        
        lines = content.split('\n')
        processed_lines = []

        for line in lines:
            
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
                        
                        comment_start = i
                        break
                else:
                    if char == string_char:
                        
                        escape_count = 0
                        check_pos = i - 1
                        while check_pos >= 0 and line[check_pos] == '\\':
                            escape_count += 1
                            check_pos -= 1
                        if escape_count % 2 == 0:  
                            in_string = False
                            string_char = None

                i += 1

            if comment_start != -1:
                
                line = line[:comment_start]

            processed_lines.append(line)

        return '\n'.join(processed_lines)

    def _classify_hook_location(self, file_path: Path, style: str, module_root: Optional[Path] = None,
                                module_scope: Optional[str] = None, owner_name: Optional[str] = None) -> Dict[str, str]:
        """Classify a hook registration location for report output."""
        resolved_path = file_path.resolve()

        if module_root is not None:
            module_root = module_root.resolve()
            try:
                relative = resolved_path.relative_to(module_root)
                path_str = str(relative).replace("\\", "/")
            except Exception:
                path_str = str(resolved_path)

            scope = module_scope or "module"
            owner = owner_name or module_root.name
            kind = "submodule" if scope == "submodule" else "module"
            return {
                "kind": kind,
                "scope": scope,
                "owner": owner,
                "path": path_str,
                "style": style,
            }

        try:
            relative = resolved_path.relative_to(self.base_path.resolve())
            rel_parts = list(relative.parts)
            path_str = str(relative).replace("\\", "/")
        except Exception:
            rel_parts = list(resolved_path.parts)
            path_str = str(resolved_path)

        kind = "other"
        scope = "framework"
        owner = "framework"

        if len(rel_parts) >= 2 and rel_parts[0] == "core" and rel_parts[1] == "libraries":
            kind = "library"
            if len(rel_parts) >= 3:
                owner = rel_parts[2]
            elif len(rel_parts) >= 1:
                owner = Path(rel_parts[-1]).stem
        elif len(rel_parts) >= 2 and rel_parts[0] == "core" and rel_parts[1] == "meta":
            kind = "meta"
            owner = Path(rel_parts[-1]).stem
        elif rel_parts and rel_parts[0] == "entities":
            kind = "entity"
            owner = rel_parts[1] if len(rel_parts) >= 2 else Path(rel_parts[-1]).stem
        elif rel_parts and rel_parts[0] == "items":
            kind = "item"
            owner = rel_parts[1] if len(rel_parts) >= 2 else Path(rel_parts[-1]).stem
        elif rel_parts and rel_parts[0] == "plugins":
            kind = "plugin"
            owner = rel_parts[1] if len(rel_parts) >= 2 else Path(rel_parts[-1]).stem
        elif rel_parts and rel_parts[0] == "schema":
            kind = "schema"
            owner = rel_parts[1] if len(rel_parts) >= 2 else "schema"
        elif rel_parts and rel_parts[0] == "core":
            kind = "core"
            owner = rel_parts[1] if len(rel_parts) >= 2 else "core"

        return {
            "kind": kind,
            "scope": scope,
            "owner": owner,
            "path": path_str,
            "style": style,
        }

    def _append_hook_location(self, locations: Dict[str, List[Dict[str, str]]], hook_name: str, location: Dict[str, str]) -> None:
        """Add one hook location entry while avoiding duplicates."""
        entries = locations.setdefault(hook_name, [])
        if location not in entries:
            entries.append(location)

    def _scan_hook_registrations_with_signatures(self) -> Tuple[List[str], Dict[str, List[str]], Dict[str, List[Dict[str, str]]], Set[str], Set[str]]:
        """Scan Lua files for hooks and attempt to capture their parameter names.

        Returns (registered_hooks_sorted, hook_signatures_map, hook_locations_map, method_hooks, standard_hooks)
        """
        registered_hooks: Set[str] = set()
        hook_signatures: Dict[str, List[str]] = {}
        hook_locations: Dict[str, List[Dict[str, str]]] = {}
        method_hooks: Set[str] = set()  
        standard_hooks: Set[str] = set()  

        
        lua_files = list(self.base_path.rglob("*.lua"))

        for lua_file in lua_files:
            
            skip_file = False
            if 'languages' in lua_file.parts:
                skip_file = True
            elif 'docs' in lua_file.parts or 'documentation' in lua_file.parts:
                
                if 'hooks' not in lua_file.parts:
                    skip_file = True

            if skip_file:
                continue

            try:
                with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()

                
                content = self._remove_lua_comments(content)

                
                file_method_hooks, file_standard_hooks = self._extract_hooks_by_type_from_file_content(content)

                
                method_hooks.update(file_method_hooks)
                standard_hooks.update(file_standard_hooks)

                
                registered_hooks.update(file_method_hooks)
                registered_hooks.update(file_standard_hooks)

                location_path = lua_file.resolve()
                for hook_name in file_method_hooks:
                    self._append_hook_location(
                        hook_locations,
                        hook_name,
                        self._classify_hook_location(location_path, "method"),
                    )
                for hook_name in file_standard_hooks:
                    self._append_hook_location(
                        hook_locations,
                        hook_name,
                        self._classify_hook_location(location_path, "standard"),
                    )

                
                file_signatures = self._extract_hook_signatures_from_file_content(content)
                for hook_name, params in file_signatures.items():
                    existing = hook_signatures.get(hook_name)
                    if not existing or (len(params) > len(existing)):
                        hook_signatures[hook_name] = params

            except Exception as e:
                print(f"Warning: Error scanning {lua_file}: {e}")
                continue

        
        
        
        method_hooks = method_hooks - standard_hooks

        return sorted(list(registered_hooks)), hook_signatures, hook_locations, method_hooks, standard_hooks

    def _extract_hooks_by_type_from_file_content(self, content: str) -> Tuple[Set[str], Set[str]]:
        """Extract hooks from file content and categorize them by type.

        Returns (method_hooks, standard_hooks)
        where method_hooks are XXXX:Hook() style and standard_hooks are hook.Add/hook.Run style.
        Note: A hook cannot be in both categories - standard hooks take precedence.
        """
        method_hooks: Set[str] = set()
        standard_hooks: Set[str] = set()

        
        
        hook_add_pattern = r'hook\.Add\s*\(\s*([\'"`])([^\'"`]+)\1'

        
        
        hook_run_pattern = r'hook\.Run\s*\(\s*([\'"`])([^\'"`]+)\1'

        
        
        hook_call_pattern = r'hook\.Call\s*\(\s*([\'"`])([^\'"`]+)\1'

        
        
        gm_hook_pattern = r'function\s+GM:([A-Za-z_][A-Za-z0-9_]*)'

        
        
        module_hook_pattern = r'function\s+MODULE:([A-Za-z_][A-Za-z0-9_]*)'

        
        
        schema_hook_pattern = r'function\s+SCHEMA:([A-Za-z_][A-Za-z0-9_]*)'

        
        for match in re.finditer(gm_hook_pattern, content):
            hook_name = match.group(1)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                method_hooks.add(hook_name.strip())

        
        for match in re.finditer(module_hook_pattern, content):
            hook_name = match.group(1)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                method_hooks.add(hook_name.strip())

        
        for match in re.finditer(schema_hook_pattern, content):
            hook_name = match.group(1)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                method_hooks.add(hook_name.strip())

        
        for match in re.finditer(hook_add_pattern, content):
            hook_name = match.group(2)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                standard_hooks.add(hook_name.strip())

        
        for match in re.finditer(hook_run_pattern, content):
            hook_name = match.group(2)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                standard_hooks.add(hook_name.strip())

        
        for match in re.finditer(hook_call_pattern, content):
            hook_name = match.group(2)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                standard_hooks.add(hook_name.strip())

        return method_hooks, standard_hooks

    def _extract_hooks_from_file_content(self, content: str) -> Set[str]:
        """Extract hooks from file content using all patterns"""
        hooks = set()

        
        
        hook_add_pattern = r'hook\.Add\s*\(\s*([\'"`])([^\'"`]+)\1'

        
        
        hook_run_pattern = r'hook\.Run\s*\(\s*([\'"`])([^\'"`]+)\1'

        
        
        hook_call_pattern = r'hook\.Call\s*\(\s*([\'"`])([^\'"`]+)\1'

        
        
        gm_hook_pattern = r'function\s+GM:([A-Za-z_][A-Za-z0-9_]*)'

        
        
        module_hook_pattern = r'function\s+MODULE:([A-Za-z_][A-Za-z0-9_]*)'

        
        
        schema_hook_pattern = r'function\s+SCHEMA:([A-Za-z_][A-Za-z0-9_]*)'

        
        for match in re.finditer(hook_add_pattern, content):
            hook_name = match.group(2)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        
        for match in re.finditer(hook_run_pattern, content):
            hook_name = match.group(2)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        
        for match in re.finditer(hook_call_pattern, content):
            hook_name = match.group(2)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        
        for match in re.finditer(gm_hook_pattern, content):
            hook_name = match.group(1)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        
        for match in re.finditer(module_hook_pattern, content):
            hook_name = match.group(1)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        
        for match in re.finditer(schema_hook_pattern, content):
            hook_name = match.group(1)
            if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
                hooks.add(hook_name.strip())

        return hooks

    def _extract_hook_signatures_from_file_content(self, content: str) -> Dict[str, List[str]]:
        """Extract hook parameter names from callback and method definitions in file content."""
        signatures: Dict[str, List[str]] = {}

        
        for m in re.finditer(r'hook\.Add\s*\(\s*([\'"`])([^\'"`]+)\1\s*,\s*[^,]*,\s*function\s*\(([^)]*)\)', content, re.DOTALL):
            hook_name = m.group(2).strip()
            params_str = (m.group(3) or '').strip()
            params = [p.strip() for p in params_str.split(',') if p.strip()]
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                existing = signatures.get(hook_name)
                if not existing or len(params) > len(existing):
                    signatures[hook_name] = params

        
        for m in re.finditer(r'function\s+GM:([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)', content):
            hook_name = m.group(1).strip()
            params_str = (m.group(2) or '').strip()
            params = [p.strip() for p in params_str.split(',') if p.strip()]
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                existing = signatures.get(hook_name)
                if not existing or len(params) > len(existing):
                    signatures[hook_name] = params

        
        for m in re.finditer(r'function\s+MODULE:([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)', content):
            hook_name = m.group(1).strip()
            params_str = (m.group(2) or '').strip()
            params = [p.strip() for p in params_str.split(',') if p.strip()]
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                existing = signatures.get(hook_name)
                if not existing or len(params) > len(existing):
                    signatures[hook_name] = params

        
        for m in re.finditer(r'function\s+SCHEMA:([A-Za-z_][A-Za-z0-9_]*)\s*\(([^)]*)\)', content):
            hook_name = m.group(1).strip()
            params_str = (m.group(2) or '').strip()
            params = [p.strip() for p in params_str.split(',') if p.strip()]
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                existing = signatures.get(hook_name)
                if not existing or len(params) > len(existing):
                    signatures[hook_name] = params

        
        for m in re.finditer(r'hook\.Run\s*\(\s*([\'"`])([^\'"`]+)\1\s*,\s*(.*?)\)', content, re.DOTALL):
            hook_name = m.group(2).strip()
            raw_args = (m.group(3) or '').strip()
            if hook_name and hook_name not in GMOD_HOOKS_BLACKLIST:
                arg_list = self._split_top_level_args(raw_args)
                if arg_list:
                    
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

    def _run_localization_analysis(self) -> Tuple[Dict, List, Dict[str, List[Dict[str, str]]]]:
        """Run localization analysis and detect conflicting module localization keys"""
        try:
            
            
            lang_file_str = str(self.language_file)
            
            if lang_file_str.startswith(r'E:\Server'):
                lang_file_str = lang_file_str.replace(r'E:\Server', r'D:\GMOD\Server')
            framework_data = analyze_data(lang_file_str, str(self.base_path))

            
            modules: List[Dict] = []
            module_conflicts: Dict[str, List[Dict[str, str]]] = {}

            if self.generate_module_docs:
                lang_name = Path(self.language_file).stem
                key_occurrences: Dict[str, List[Dict[str, str]]] = defaultdict(list)

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

                        lang_file = module_dir / "languages" / f"{lang_name}.lua"
                        
                        if 'gitmodules' not in str(base_path).lower():
                            continue

                        if not lang_file.exists():
                            continue

                        module_data = analyze_data(str(lang_file), str(module_dir))
                        module_info = {
                            **module_data,
                            'module_name': module_name,
                            'module_path': str(module_dir),
                            'language_file': str(lang_file),
                        }
                        modules.append(module_info)

                        
                        for key, value in module_data.get('keys', {}).items():
                            key_occurrences[key].append({
                                'module_name': module_name,
                                'module_path': str(module_dir),
                                'language_file': str(lang_file),
                                'value': value,
                            })

                
                module_conflicts = {k: v for k, v in key_occurrences.items() if len(v) > 1}

            return framework_data, modules, module_conflicts
        except Exception as e:
            print(f"Error in localization analysis: {e}")
            return {}, [], {}

    def _run_font_analysis(self) -> Tuple[Set[str], Set[str], Set[str], Set[str], Set[str], int, Dict[str, Set[str]]]:
        """Run font analysis to find registered and used fonts"""
        try:
            
            REGISTER_PATTERN = re.compile(
                r'lia\.font\.register\s*\(\s*["\']([^"\']+)["\']\s*[,)]',
                re.IGNORECASE
            )
            
            
            SURFACE_SETFONT_STRING_PATTERN = re.compile(
                r'surface\.SetFont\s*\(\s*["\']([^"\']+)["\']',
                re.IGNORECASE
            )
            PANEL_SETFONT_STRING_PATTERN = re.compile(
                r':SetFont\s*\(\s*["\']([^"\']+)["\']',
                re.IGNORECASE
            )
            SETFONT_STRING_PATTERN = re.compile(
                r'SetFont\s*\(\s*["\']([^"\']+)["\']',
                re.IGNORECASE
            )
            SURFACE_SETFONT_VAR_PATTERN = re.compile(
                r'surface\.SetFont\s*\(\s*([a-zA-Z_][a-zA-Z0-9_.]*)',
                re.IGNORECASE
            )
            PANEL_SETFONT_VAR_PATTERN = re.compile(
                r':SetFont\s*\(\s*([a-zA-Z_][a-zA-Z0-9_.]*)',
                re.IGNORECASE
            )
            GETFONT_PATTERN = re.compile(
                r'\.GetFont\s*\(',
                re.IGNORECASE
            )
            
            all_registered = set()
            all_used_string = set()
            all_used_variables = set()
            file_usages = defaultdict(set)
            getfont_count = 0
            
            
            workspace_paths = [str(self.base_path)]
            workspace_paths.extend(self.modules_paths)
            
            for workspace_path in workspace_paths:
                workspace_path_obj = Path(workspace_path)
                if not workspace_path_obj.exists():
                    continue
                
                
                lua_files = list(workspace_path_obj.rglob("*.lua"))
                
                for file_path in lua_files:
                    
                    if any(skip in str(file_path) for skip in ["addons", "workshop", "docs", "documentation", "languages"]):
                        continue
                    
                    try:
                        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read()
                        
                        
                        content = self._remove_lua_comments(content)
                        
                        
                        registered = self._extract_registered_fonts_from_content(content)
                        all_registered.update(registered)
                        
                        
                        used_string, used_vars, file_getfont_count = self._extract_used_fonts_from_content(
                            content, SURFACE_SETFONT_STRING_PATTERN, PANEL_SETFONT_STRING_PATTERN,
                            SETFONT_STRING_PATTERN, SURFACE_SETFONT_VAR_PATTERN, PANEL_SETFONT_VAR_PATTERN,
                            GETFONT_PATTERN
                        )
                        if used_string:
                            all_used_string.update(used_string)
                            file_usages[str(file_path)] = used_string
                        if used_vars:
                            all_used_variables.update(used_vars)
                        getfont_count += file_getfont_count
                        
                    except Exception as e:
                        print(f"Warning: Error reading {file_path}: {e}")
                        continue
            
            
            unregistered = all_used_string - all_registered
            
            
            default_gmod_fonts = {"DermaDefault", "DermaDefaultBold", "DermaLarge", "Marlett"}
            truly_unregistered = unregistered - default_gmod_fonts
            default_fonts_used = unregistered & default_gmod_fonts
            
            return (all_registered, all_used_string, truly_unregistered, default_fonts_used,
                    all_used_variables, getfont_count, file_usages)
            
        except Exception as e:
            print(f"Error in font analysis: {e}")
            return set(), set(), set(), set(), set(), 0, {}

    def _extract_registered_fonts_from_content(self, content: str) -> Set[str]:
        """Extract font names from lia.font.register calls in content"""
        registered = set()
        
        REGISTER_PATTERN = re.compile(
            r'lia\.font\.register\s*\(\s*["\']([^"\']+)["\']\s*[,)]',
            re.IGNORECASE
        )
        
        
        for match in REGISTER_PATTERN.finditer(content):
            
            start_pos = match.start()
            before_match = content[:start_pos]
            
            
            last_comment_start = before_match.rfind('--[[')
            if last_comment_start != -1:
                comment_end = content.find(']]', last_comment_start)
                if comment_end != -1 and comment_end > start_pos:
                    continue  
            
            font_name = match.group(1)
            registered.add(font_name)
        
        
        liliafont_pattern = re.compile(
            r'lia\.font\.register\s*\(\s*["\']LiliaFont\.["\']\s*\.\.\s*size',
            re.IGNORECASE
        )
        liliafont_match = liliafont_pattern.search(content)
        if liliafont_match:
            start_pos = liliafont_match.start()
            before_match = content[:start_pos]
            
            last_comment_start = before_match.rfind('--[[')
            skip_detection = False
            if last_comment_start != -1:
                comment_end = content.find(']]', last_comment_start)
                if comment_end != -1 and comment_end > start_pos:
                    skip_detection = True
            
            if not skip_detection:
                sizes_match = re.search(r'local\s+fontSizes\s*=\s*\{([^}]+)\}', content, re.MULTILINE)
                if not sizes_match:
                    sizes_match = re.search(r'fontSizes\s*=\s*\{([^}]+)\}', content, re.MULTILINE)
                
                if sizes_match:
                    sizes_str = sizes_match.group(1)
                    sizes = [int(s) for s in re.findall(r'\d+', sizes_str)]
                    for size in sizes:
                        registered.add(f"LiliaFont.{size}")
                        registered.add(f"LiliaFont.{size}b")
                        registered.add(f"LiliaFont.{size}i")
                else:
                    default_sizes = [12, 14, 15, 16, 17, 18, 20, 22, 23, 24, 25, 26, 28, 30, 34, 36, 40, 48]
                    for size in default_sizes:
                        registered.add(f"LiliaFont.{size}")
                        registered.add(f"LiliaFont.{size}b")
                        registered.add(f"LiliaFont.{size}i")
        
        
        customfont_pattern = re.compile(
            r'lia\.font\.register\s*\(\s*["\']CustomFont["\']\s*\.\.\s*size',
            re.IGNORECASE
        )
        customfont_match = customfont_pattern.search(content)
        if customfont_match:
            start_pos = customfont_match.start()
            before_match = content[:start_pos]
            
            last_comment_start = before_match.rfind('--[[')
            skip_detection = False
            if last_comment_start != -1:
                comment_end = content.find(']]', last_comment_start)
                if comment_end != -1 and comment_end > start_pos:
                    skip_detection = True
            
            if not skip_detection:
                sizes_match = re.search(r'local\s+sizes\s*=\s*\{([^}]+)\}', content)
                if sizes_match:
                    sizes_str = sizes_match.group(1)
                    sizes = re.findall(r'\d+', sizes_str)
                    for size in sizes:
                        registered.add(f"CustomFont{size}")
                        registered.add(f"CustomFont{size}Bold")
        
        return registered

    def _extract_used_fonts_from_content(self, content: str, surface_string_pattern, panel_string_pattern,
                                         setfont_string_pattern, surface_var_pattern, panel_var_pattern,
                                         getfont_pattern) -> Tuple[Set[str], Set[str], int]:
        """Extract font names from SetFont calls in content"""
        string_fonts = set()
        variable_fonts = set()
        getfont_count = 0
        
        
        for pattern in [surface_string_pattern, panel_string_pattern, setfont_string_pattern]:
            for match in pattern.finditer(content):
                font_name = match.group(1)
                string_fonts.add(font_name)
        
        
        for pattern in [surface_var_pattern, panel_var_pattern]:
            for match in pattern.finditer(content):
                var_name = match.group(1)
                
                if var_name not in ['font', 'finalFont', 'topfont', 'bottomfont', 'buttonFont']:
                    variable_fonts.add(var_name)
        
        
        getfont_count = len(getfont_pattern.findall(content))
        
        return string_fonts, variable_fonts, getfont_count

    def _detect_undefined_config_get_calls(self) -> List[Dict]:
        """Find lia.config.get("key") calls where the key was never registered with lia.config.add.

        Returns a list of dicts:
            {
                'file': str,      # relative path from base_path
                'line': int,
                'key': str,       # config key used in the get call
                'context': str,   # trimmed source line
            }
        """
        
        defined_keys: Set[str] = set()
        add_pattern = re.compile(
            r'\blia\.config\.add\s*\(\s*(["\'])([^"\']+)\1',
            re.IGNORECASE,
        )

        scan_roots = [self.base_path]
        for mp in (self.modules_paths or []):
            mp_path = Path(mp)
            if mp_path.exists():
                scan_roots.append(mp_path)

        all_lua_files: List[Path] = []
        for root in scan_roots:
            all_lua_files.extend(root.rglob("*.lua"))

        for lua_file in all_lua_files:
            
            lowered_parts = [p.lower() for p in lua_file.parts]
            if any(skip in lowered_parts for skip in ("documentation", "docs", "languages")):
                continue
            try:
                content = lua_file.read_text(encoding="utf-8", errors="ignore")
                content_no_comments = self._remove_lua_comments(content)
            except Exception:
                continue
            for m in add_pattern.finditer(content_no_comments):
                defined_keys.add(m.group(2))

        
        get_pattern = re.compile(
            r'\blia\.config\.get\s*\(\s*(["\'])([^"\']+)\1',
            re.IGNORECASE,
        )

        undefined_calls: List[Dict] = []

        for lua_file in all_lua_files:
            lowered_parts = [p.lower() for p in lua_file.parts]
            if any(skip in lowered_parts for skip in ("documentation", "docs", "languages")):
                continue
            try:
                content = lua_file.read_text(encoding="utf-8", errors="ignore")
                content_no_comments = self._remove_lua_comments(content)
            except Exception:
                continue

            lines = content_no_comments.splitlines()
            for m in get_pattern.finditer(content_no_comments):
                key = m.group(2)
                if key in defined_keys:
                    continue
                line_num = content_no_comments[: m.start()].count("\n") + 1
                context = lines[line_num - 1].strip() if line_num <= len(lines) else ""
                try:
                    rel_path = str(lua_file.relative_to(self.base_path))
                except ValueError:
                    rel_path = str(lua_file)
                undefined_calls.append({
                    "file": rel_path,
                    "line": line_num,
                    "key": key,
                    "context": context[:240],
                })

        
        seen: set = set()
        deduped: List[Dict] = []
        for entry in undefined_calls:
            sig = (entry["file"], entry["line"], entry["key"])
            if sig not in seen:
                seen.add(sig)
                deduped.append(entry)

        return sorted(deduped, key=lambda e: (e["file"], e["line"]))

    def generate_markdown_report(self, data: CombinedReportData) -> str:
        """Generate comprehensive markdown report"""
        report_lines = []


        
        report_lines.extend(self._generate_executive_summary(data))

        
        report_lines.extend(self._generate_function_docs_section(data))

        
        report_lines.extend(self._generate_hooks_section(data))

        
        report_lines.extend(self._generate_localization_section(data))

        
        report_lines.extend(self._generate_language_comparison_section(data))

        
        report_lines.extend(self._generate_net_message_section(data))

        
        report_lines.extend(self._generate_derma_panel_section(data))

        
        report_lines.extend(self._generate_module_file_placement_section(data))

        
        report_lines.extend(self._generate_config_undefined_section(data))

        
        if self.generate_module_docs:
            try:
                report_lines.extend(self._generate_modules_section(data.modules_scan))
            except Exception as e:
                print(f"Error generating modules section: {e}")

        return "\n".join(report_lines)

    def _get_reports_dir(self) -> Path:
        """Return the centralized reports directory."""
        return self.docs_path / "reports"

    def _sanitize_report_filename(self, name: str) -> str:
        """Create a safe and predictable markdown filename stem."""
        sanitized = re.sub(r'[<>:"/\\|?*]+', "_", (name or "").strip().lower())
        sanitized = re.sub(r"\s+", "_", sanitized)
        sanitized = re.sub(r"_+", "_", sanitized).strip("._")
        return sanitized or "report"

    def _module_display_name(self, module_entry: Dict[str, Any]) -> str:
        """Return the display name for a module report."""
        module_name = (module_entry or {}).get("module_name")
        if module_name:
            return module_name
        module_path = (module_entry or {}).get("module_path")
        return Path(module_path).name if module_path else "module"

    def _build_report_targets(self, data: CombinedReportData) -> List[ReportTarget]:
        """Build the framework target plus one target per detected module."""
        targets = [ReportTarget(report_name="lilia", display_name="Lilia")]
        used_names = {"lilia"}

        for module_entry in getattr(data, "modules_scan", []) or []:
            module_path = Path(module_entry["module_path"]).resolve()
            base_name = self._sanitize_report_filename(self._module_display_name(module_entry))
            candidate = base_name
            suffix = 2
            while candidate in used_names:
                candidate = f"{base_name}_{suffix}"
                suffix += 1
            used_names.add(candidate)
            targets.append(
                ReportTarget(
                    report_name=candidate,
                    display_name=self._module_display_name(module_entry),
                    module_path=module_path,
                    module_scan_entry=module_entry,
                )
            )

        return targets

    def _path_is_within_module(self, file_ref: str, module_path: Path) -> bool:
        """Return True when a file reference belongs to the given module path."""
        if not file_ref:
            return False

        try:
            candidate = self._resolve_report_path(file_ref)
            if candidate is None:
                return False
            return candidate.resolve().is_relative_to(module_path.resolve())
        except Exception:
            return False

    def _filter_net_message_sites_for_module(self, message_map: Dict[str, List[Dict[str, Any]]], module_path: Path) -> Dict[str, List[Dict[str, Any]]]:
        """Filter net-message definitions/usages down to one module."""
        filtered: Dict[str, List[Dict[str, Any]]] = {}
        for message_name, sites in (message_map or {}).items():
            matching_sites = [
                site for site in sites
                if self._path_is_within_module(site.get("file"), module_path)
            ]
            if matching_sites:
                filtered[message_name] = matching_sites
        return filtered

    def _filter_entries_for_module(self, entries: List[Dict[str, Any]], module_path: Path) -> List[Dict[str, Any]]:
        """Filter finding dictionaries to entries owned by or referencing one module."""
        filtered: List[Dict[str, Any]] = []
        target_path = str(module_path.resolve()).lower()
        for entry in entries or []:
            entry_module_path = entry.get("module_path")
            if entry_module_path:
                try:
                    if str(Path(entry_module_path).resolve()).lower() == target_path:
                        filtered.append(entry)
                        continue
                except Exception:
                    pass
            if self._path_is_within_module(entry.get("file"), module_path):
                filtered.append(entry)
                continue
            site_lists = [
                entry.get("usage_sites", []),
                entry.get("definition_sites", []),
                entry.get("sender_sites", []),
                entry.get("receiver_sites", []),
            ]
            if any(self._path_is_within_module(site.get("file"), module_path) for sites in site_lists for site in (sites or [])):
                filtered.append(entry)
        return filtered

    def _build_module_function_comparison(self, module_entry: Dict[str, Any]) -> Dict[str, Dict[str, Any]]:
        """Create lightweight function-comparison data for a module from the scan results."""
        module_path = Path(module_entry["module_path"])
        documented_hooks, documented_functions = self._read_module_docs(module_path)
        undoc_functions = sorted(module_entry.get("undoc_functions", []), key=str.lower)
        undoc_meta_functions = sorted(module_entry.get("undoc_meta_functions", []), key=str.lower)
        all_functions = sorted(set(documented_functions) | set(undoc_functions) | set(undoc_meta_functions), key=str.lower)
        missing_functions = sorted(set(undoc_functions) | set(undoc_meta_functions), key=str.lower)

        return {
            str(module_path): {
                "functions": {
                    function_name: {"parameters": []}
                    for function_name in all_functions
                },
                "missing_functions": missing_functions,
                "missing_functions_count": len(missing_functions),
                "total_functions": len(all_functions),
                "documented_functions": len(all_functions) - len(missing_functions),
            }
        }

    def _build_scoped_report_data(self, data: CombinedReportData, target: ReportTarget) -> CombinedReportData:
        """Return report data scoped to the framework or a specific module."""
        if target.module_path is None or target.module_scan_entry is None:
            return data

        module_path = target.module_path
        module_entry = target.module_scan_entry
        documented_module_hooks, documented_module_functions = self._read_module_docs(module_path)
        localization_data = {}
        for entry in getattr(data, "modules_data", []) or []:
            if Path(entry.get("module_path", "")).resolve() == module_path:
                localization_data = entry
                break

        argument_mismatches = [
            mismatch for mismatch in (data.argument_mismatches or [])
            if self._path_is_within_module(mismatch.get("file"), module_path)
        ]
        config_undefined = [
            entry for entry in (getattr(data, "config_undefined_get_calls", []) or [])
            if self._path_is_within_module(entry.get("file"), module_path)
        ]
        undefined_inferred = [
            entry for entry in (getattr(data, "undefined_inferred_loc_keys", []) or [])
            if self._path_is_within_module(entry.get("file"), module_path)
        ]
        filtered_defined = self._filter_net_message_sites_for_module(getattr(data, "net_messages_defined", {}) or {}, module_path)
        filtered_used = self._filter_net_message_sites_for_module(getattr(data, "net_messages_used", {}) or {}, module_path)
        filtered_defined_names = set(filtered_defined.keys())
        filtered_used_names = set(filtered_used.keys())
        scoped_module_net_misregistered = self._filter_entries_for_module(getattr(data, "module_net_messages_misregistered", []) or [], module_path)
        scoped_module_net_undefined = self._filter_entries_for_module(getattr(data, "module_net_messages_undefined", []) or [], module_path)
        scoped_direction_issues = self._filter_entries_for_module(getattr(data, "net_messages_direction_issues", []) or [], module_path)
        scoped_derma_defined = self._filter_entries_for_module(getattr(data, "derma_panels_defined", []) or [], module_path)
        scoped_derma_unused = self._filter_entries_for_module(getattr(data, "derma_panels_unused", []) or [], module_path)
        scoped_derma_outside = self._filter_entries_for_module(getattr(data, "module_derma_panels_outside_folder", []) or [], module_path)
        scoped_file_placement = self._filter_entries_for_module(getattr(data, "module_file_placement_issues", []) or [], module_path)
        module_conflicts = {
            key: occurrences
            for key, occurrences in (getattr(data, "module_localization_conflicts", {}) or {}).items()
            if any(Path(item.get("module_path", "")).resolve() == module_path for item in occurrences)
        }

        scoped_function_comparison = self._build_module_function_comparison(module_entry)
        missing_library_functions = [
            FunctionInfo(name=function_name, parameters=[])
            for function_name in module_entry.get("undoc_functions", [])
        ]
        missing_meta_functions = [
            FunctionInfo(name=function_name, parameters=[])
            for function_name in module_entry.get("undoc_meta_functions", [])
        ]

        return CombinedReportData(
            function_comparison=scoped_function_comparison,
            hooks_missing=sorted(module_entry.get("undoc_hooks", []), key=str.lower),
            hooks_documented=sorted(documented_module_hooks),
            hooks_registered=sorted(set(documented_module_hooks) | set(module_entry.get("undoc_hooks", [])), key=str.lower),
            hooks_signatures={hook: [] for hook in module_entry.get("undoc_hooks", [])},
            hooks_locations=dict(module_entry.get("hook_locations", {})),
            hooks_method=[],
            hooks_standard=sorted(module_entry.get("undoc_hooks", []), key=str.lower),
            localization_data=localization_data,
            argument_mismatches=argument_mismatches,
            inferred_localization={},
            modules_data=[localization_data] if localization_data else [],
            module_localization_conflicts=module_conflicts,
            modules_scan=[module_entry],
            language_comparison={},
            missing_library_functions=missing_library_functions,
            missing_hook_functions=[],
            missing_meta_functions=missing_meta_functions,
            fonts_registered=set(),
            fonts_used=set(),
            fonts_unregistered=set(),
            fonts_default_gmod=set(),
            fonts_variable=set(),
            fonts_getfont_count=0,
            fonts_file_usages={},
            config_undefined_get_calls=config_undefined,
            undefined_inferred_loc_keys=undefined_inferred,
            net_messages_defined=filtered_defined,
            net_messages_used=filtered_used,
            net_messages_unused_defined=sorted(filtered_defined_names - filtered_used_names, key=str.lower),
            net_messages_used_but_undefined=sorted(filtered_used_names - filtered_defined_names, key=str.lower),
            net_message_analysis_notes=list(getattr(data, "net_message_analysis_notes", []) or []),
            module_net_messages_misregistered=scoped_module_net_misregistered,
            module_net_messages_undefined=scoped_module_net_undefined,
            module_net_messages_notes=list(getattr(data, "module_net_messages_notes", []) or []),
            net_messages_direction_issues=scoped_direction_issues,
            derma_panels_defined=scoped_derma_defined,
            derma_panels_used=set(getattr(data, "derma_panels_used", set()) or set()),
            derma_panels_unused=scoped_derma_unused,
            module_derma_panels_outside_folder=scoped_derma_outside,
            module_file_placement_issues=scoped_file_placement,
            duplicate_key_analysis={},
            privilege_report={},
            generated_at=data.generated_at,
        )

    def _format_hook_location_label(self, location: Dict[str, str]) -> str:
        """Return a compact human-readable label for one hook location."""
        kind = (location or {}).get("kind", "other")
        owner = (location or {}).get("owner", "")
        path = (location or {}).get("path", "")
        style = (location or {}).get("style", "")

        if kind == "library":
            prefix = f"library `{owner}`"
        elif kind == "submodule":
            prefix = f"submodule `{owner}`"
        elif kind == "module":
            prefix = f"module `{owner}`"
        elif kind == "entity":
            prefix = f"entity `{owner}`"
        elif kind == "item":
            prefix = f"item `{owner}`"
        elif kind == "plugin":
            prefix = f"plugin `{owner}`"
        elif kind == "meta":
            prefix = f"meta `{owner}`"
        elif kind == "schema":
            prefix = f"schema `{owner}`"
        elif kind == "core":
            prefix = f"core `{owner}`"
        else:
            prefix = kind

        if style:
            prefix = f"{prefix} [{style}]"

        return f"{prefix} in `{path}`" if path else prefix

    def _generate_hook_locations_block(self, hook_locations: Dict[str, List[Dict[str, str]]], hook_names: List[str],
                                       heading: str, description: str) -> List[str]:
        """Generate a markdown block listing where hooks were found."""
        lines: List[str] = []
        if not hook_names:
            return lines

        lines.append(heading)
        lines.append(description)
        for hook_name in hook_names:
            locations = hook_locations.get(hook_name, []) if hook_locations else []
            if not locations:
                continue
            lines.append(f"- `{hook_name}`")
            for location in locations:
                lines.append(f"  - {self._format_hook_location_label(location)}")
        lines.append("")
        return lines

    def _filter_hook_locations_by_kinds(self, hook_locations: Dict[str, List[Dict[str, str]]],
                                        allowed_kinds: Set[str]) -> Dict[str, List[Dict[str, str]]]:
        """Return hook locations limited to the specified location kinds."""
        filtered: Dict[str, List[Dict[str, str]]] = {}
        for hook_name, locations in (hook_locations or {}).items():
            matching = [
                location for location in (locations or [])
                if location.get("kind") in allowed_kinds
            ]
            if matching:
                filtered[hook_name] = matching
        return filtered

    def _generate_config_undefined_section(self, data: CombinedReportData) -> List[str]:
        """Generate the config undefined get-calls section of the report."""
        lines: List[str] = ["## Config: Undefined lia.config.get Keys", ""]
        calls = getattr(data, "config_undefined_get_calls", []) or []

        if not calls:
            lines.append("_No undefined `lia.config.get` calls detected._")
            lines.append("")
            lines.append("---")
            lines.append("")
            return lines

        lines.extend([
            f"Total: **{len(calls)}** call(s) reference a config key that has no matching `lia.config.add`.",
            "",
        ])

        
        by_key: Dict[str, List[Dict]] = defaultdict(list)
        for entry in calls:
            by_key[entry["key"]].append(entry)

        lines.append("### By Key")
        lines.append("")
        lines.append("| Config Key | Occurrences |")
        lines.append("|---|---:|")
        for key in sorted(by_key.keys()):
            lines.append(f"| `{key}` | {len(by_key[key])} |")
        lines.append("")

        lines.append("### Details")
        lines.append("")
        for key in sorted(by_key.keys()):
            lines.append(f"#### `{key}`")
            lines.append("")
            for entry in by_key[key]:
                lines.append(f"- **{entry['file']}** line {entry['line']}: `{entry['context']}`")
            lines.append("")

        lines.append("---")
        lines.append("")
        return lines

    def _generate_net_message_section(self, data: CombinedReportData) -> List[str]:
        """Generate the base GMod net-message analysis section."""
        lines: List[str] = ["## Net Message Analysis", ""]

        defined = getattr(data, "net_messages_defined", {}) or {}
        used = getattr(data, "net_messages_used", {}) or {}
        unused_defined = getattr(data, "net_messages_unused_defined", []) or []
        used_but_undefined = getattr(data, "net_messages_used_but_undefined", []) or []
        if not defined and not used:
            lines.append("_No net-message analysis data available._")
            lines.append("")
            return lines

        lines.extend([
            "### Summary",
            f"- **Defined Net Messages:** {len(defined)}",
            f"- **Used Net Messages:** {len(used)}",
            f"- **Defined But Unused:** {len(unused_defined)}",
            f"- **Used But Undefined:** {len(used_but_undefined)}",
            "",
        ])

        lines.append("### Used But Undefined")
        lines.append("")
        if used_but_undefined:
            for name in used_but_undefined:
                usage_sites = used.get(name, [])
                if usage_sites:
                    summary = "; ".join(
                        f"{site['type']} at {site['file']}:{site['line']}"
                        for site in usage_sites[:3]
                    )
                    lines.append(f"- `{name}`")
                    lines.append(f"  - Used at: {summary}")
                else:
                    lines.append(f"- `{name}`")
            lines.append("")
        else:
            lines.append("None")
            lines.append("")

        misregistered = getattr(data, "module_net_messages_misregistered", []) or []
        module_undefined = getattr(data, "module_net_messages_undefined", []) or []
        direction_issues = getattr(data, "net_messages_direction_issues", []) or []

        lines.append("### Module-Specific Registration Issues")
        lines.append("")
        lines.extend([
            f"- **Module-Specific But Registered Outside Module:** {len(misregistered)}",
            f"- **Module-Specific Used But Undefined:** {len(module_undefined)}",
            "",
        ])
        for note in getattr(data, "module_net_messages_notes", []) or []:
            lines.append(f"- Note: {note}")
        if getattr(data, "module_net_messages_notes", []) or []:
            lines.append("")

        lines.append("#### Module-Specific But Registered Outside Module")
        lines.append("")
        if misregistered:
            for entry in misregistered:
                lines.append(f"- `{entry['message']}` in module `{entry['module_name']}`")
                lines.append(f"  - Reason: {entry['reason']}")
                usage_summary = "; ".join(f"{site['type']} at {site['file']}:{site['line']}" for site in entry.get("usage_sites", [])[:5])
                definition_summary = "; ".join(f"{site['type']} at {site['file']}:{site['line']}" for site in entry.get("definition_sites", [])[:5])
                lines.append(f"  - Usage sites: {usage_summary or 'None'}")
                lines.append(f"  - Definition sites: {definition_summary or 'None'}")
        else:
            lines.append("None")
        lines.append("")

        lines.append("#### Module-Specific Used But Undefined")
        lines.append("")
        if module_undefined:
            for entry in module_undefined:
                lines.append(f"- `{entry['message']}` in module `{entry['module_name']}`")
                lines.append(f"  - Reason: {entry['reason']}")
                usage_summary = "; ".join(f"{site['type']} at {site['file']}:{site['line']}" for site in entry.get("usage_sites", [])[:5])
                lines.append(f"  - Usage sites: {usage_summary or 'None'}")
        else:
            lines.append("None")
        lines.append("")

        lines.append("### Direction / Flow Issues")
        lines.append("")
        lines.append(f"Total suspicious patterns: **{len(direction_issues)}**")
        lines.append("")
        if direction_issues:
            for entry in direction_issues:
                sender_summary = "; ".join(f"{site['file']}:{site['line']}" for site in entry.get("sender_sites", [])[:5])
                receiver_summary = "; ".join(f"{site['file']}:{site['line']}" for site in entry.get("receiver_sites", [])[:5])
                lines.append(f"- `{entry['message']}`")
                lines.append(f"  - Reason: {entry['reason']}")
                lines.append(f"  - Send sides: {', '.join(entry.get('send_sides', [])) or 'none'}")
                lines.append(f"  - Receive sides: {', '.join(entry.get('receive_sides', [])) or 'none'}")
                lines.append(f"  - Sender sites: {sender_summary or 'None'}")
                lines.append(f"  - Receiver sites: {receiver_summary or 'None'}")
        else:
            lines.append("None")
        lines.append("")

        lines.append("---")
        lines.append("")
        return lines

    def _generate_derma_panel_section(self, data: CombinedReportData) -> List[str]:
        """Generate Derma panel placement and usage analysis."""
        lines: List[str] = ["## Derma Panel Analysis", ""]
        panels_defined = getattr(data, "derma_panels_defined", []) or []
        panels_used = getattr(data, "derma_panels_used", set()) or set()
        panels_unused = getattr(data, "derma_panels_unused", []) or []
        outside_folder = getattr(data, "module_derma_panels_outside_folder", []) or []

        lines.extend([
            "### Summary",
            f"- **Registered Panels:** {len(panels_defined)}",
            f"- **Referenced Panels:** {len(panels_used)}",
            f"- **Module Panels Outside derma:** {len(outside_folder)}",
            f"- **Registered But Unused:** {len(panels_unused)}",
            "",
        ])

        lines.append("### Module Panels Outside derma")
        lines.append("")
        if outside_folder:
            lines.append("| Panel | Module | Location | Expected Folder |")
            lines.append("|---|---|---|---|")
            for entry in outside_folder:
                lines.append(f"| `{entry['panel']}` | `{entry['module_name']}` | `{entry['file']}:{entry['line']}` | `{entry['expected_folder']}` |")
            lines.append("")
        else:
            lines.append("None")
            lines.append("")

        lines.append("### Registered But Unused Panels")
        lines.append("")
        if panels_unused:
            lines.append("| Panel | Module | Location |")
            lines.append("|---|---|---|")
            for entry in panels_unused:
                module_name = entry.get("module_name") or "framework"
                lines.append(f"| `{entry['panel']}` | `{module_name}` | `{entry['file']}:{entry['line']}` |")
            lines.append("")
        else:
            lines.append("None")
            lines.append("")

        lines.append("---")
        lines.append("")
        return lines

    def _generate_module_file_placement_section(self, data: CombinedReportData) -> List[str]:
        """Generate module file placement convention findings."""
        lines: List[str] = ["## Module File Placement Analysis", ""]
        issues = getattr(data, "module_file_placement_issues", []) or []
        net_issues = [issue for issue in issues if issue.get("type") == "Net Handlers Outside netcalls"]
        ui_issues = [issue for issue in issues if issue.get("type") == "UI / Derma Code Outside derma"]

        lines.extend([
            "### Summary",
            f"- **Net Handlers Outside netcalls:** {len(net_issues)}",
            f"- **UI / Derma Code Outside derma:** {len(ui_issues)}",
            "",
        ])

        for heading, bucket in (
            ("### Net Handlers Outside netcalls", net_issues),
            ("### UI / Derma Code Outside derma", ui_issues),
        ):
            lines.append(heading)
            lines.append("")
            if bucket:
                lines.append("| Module | Location | Expected Folder | Reason |")
                lines.append("|---|---|---|---|")
                for issue in bucket:
                    lines.append(f"| `{issue['module_name']}` | `{issue['file']}:{issue['line']}` | `{issue['expected_folder']}` | {issue['reason']} |")
                lines.append("")
            else:
                lines.append("None")
                lines.append("")

        lines.append("---")
        lines.append("")
        return lines

    def _scan_modules_for_undocumented(self) -> List[Dict]:
        """Scan external modules for undocumented hooks and lia.* functions.

        Returns a list of dicts: {
            'module_path': str,
            'undoc_hooks': List[str],
            'undoc_functions': List[str],
            'undoc_meta_functions': List[str]
        }
        Includes entries for all modules encountered (even if counts are zero) so we can build a complete summary.
        """
        results: List[Dict] = []

        
        try:
            documented_hooks = self._read_all_documented_hooks()
        except Exception:
            documented_hooks = set()

        
        try:
            documented_functions = set()
            docs_path = Path(self.docs_path) / "docs"

            
            if (docs_path / "libraries").exists():
                for md_file in (docs_path / "libraries").glob("*.md"):
                    if md_file.name.startswith("lia.") or md_file.stem == "lia.core":
                        try:
                            with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
                                content = f.read()
                            import re
                            for match in re.finditer(r'^###+\s+([A-Za-z_][\w\.:]*)\s*$', content, re.MULTILINE):
                                func_name = match.group(1).strip()
                                
                                if '.' not in func_name and md_file.stem == 'lia.core':
                                    documented_functions.add(f'lia.{func_name}')
                                else:
                                    documented_functions.add(func_name)
                            for match in re.finditer(r'<summary><a[^>]*></a>([A-Za-z_][\w\.:]+)\([^)]*\)</summary>', content):
                                func_name = match.group(1).strip()
                                if '.' not in func_name and md_file.stem == 'lia.core':
                                    documented_functions.add(f'lia.{func_name}')
                                else:
                                    documented_functions.add(func_name)
                        except Exception:
                            continue

            
            if (docs_path / "meta").exists():
                for md_file in (docs_path / "meta").glob("*.md"):
                    try:
                        with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read()
                        import re
                        for match in re.finditer(r'`([A-Za-z_][\w\.:]*)\([^)]*\)`', content):
                            method_name = match.group(1).strip()
                            documented_functions.add(method_name)
                        
                        stem = md_file.stem
                        overrides = {
                            'tool': 'toolGunMeta',
                        }
                        meta_table = overrides.get(stem, f"{stem}Meta")
                        for match in re.finditer(r'<summary><a[^>]*></a>([A-Za-z_][\w]+)\([^)]*\)</summary>', content):
                            method_name = match.group(1).strip()
                            qualified_name = f"{meta_table}:{method_name}"
                            documented_functions.add(qualified_name)
                    except Exception:
                        continue
        except Exception:
            documented_functions = set()

        
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

                
                submodules = []
                for item in module_dir.iterdir():
                    if item.is_dir() and (item / "module.lua").exists():
                        submodules.append(item)

                
                documented_module_hooks, documented_module_functions = self._read_module_docs(module_dir)

                undoc_functions: Set[str] = set()
                undoc_hooks: Set[str] = set()
                undoc_meta_functions: Set[str] = set()
                hook_locations: Dict[str, List[Dict[str, str]]] = {}

                for root, _, files in os.walk(module_dir):
                    
                    if 'addons' in Path(root).parts:
                        continue
                    
                    root_path = Path(root)
                    is_submodule_path = any(root_path.is_relative_to(submod) or root_path == submod for submod in submodules)
                    if is_submodule_path:
                        continue
                    for fname in files:
                        if not fname.lower().endswith('.lua'):
                            continue
                        fpath = Path(root) / fname
                        try:
                            with open(fpath, 'r', encoding='utf-8', errors='ignore') as f:
                                content = f.read()
                        except Exception:
                            continue

                        content = self._remove_lua_comments(content)

                        import re
                        
                        for m in re.finditer(r'\b(function\s+([A-Za-z_][\w\.]*?)\s*\(|([A-Za-z_][\w\.]*?)\s*=\s*function\s*\()', content):
                            name = m.group(2) or m.group(3)
                            if name and name.startswith('lia.') and name.count('.') >= 2:
                                if name not in documented_functions and name not in documented_module_functions:
                                    undoc_functions.add(name)

                        
                        
                        for m in re.finditer(r'^\s*function\s+([A-Za-z_]*Meta):([A-Za-z_][\w]*)\s*\(([^)]*)\)', content, re.MULTILINE):
                            meta_name = f"{m.group(1)}:{m.group(2)}"
                            if meta_name not in documented_functions and meta_name not in documented_module_functions:
                                undoc_meta_functions.add(meta_name)

                        
                        for m in re.finditer(r'hook\s*\.\s*Add\s*\(\s*(["\'])\s*([^"\']+)\1', content):
                            hook_name = m.group(2)
                            if (hook_name not in documented_hooks and
                                hook_name not in documented_module_hooks and
                                hook_name not in GMOD_HOOKS_BLACKLIST):
                                undoc_hooks.add(hook_name)
                                self._append_hook_location(
                                    hook_locations,
                                    hook_name,
                                    self._classify_hook_location(fpath, "standard", module_dir, "module", module_name),
                                )
                        for m in re.finditer(r'hook\s*\.\s*Run\s*\(\s*(["\'])\s*([^"\']+)\1', content):
                            hook_name = m.group(2)
                            if (hook_name not in documented_hooks and
                                hook_name not in documented_module_hooks and
                                hook_name not in GMOD_HOOKS_BLACKLIST):
                                undoc_hooks.add(hook_name)
                                self._append_hook_location(
                                    hook_locations,
                                    hook_name,
                                    self._classify_hook_location(fpath, "standard", module_dir, "module", module_name),
                                )
                        for m in re.finditer(r'hook\s*\.\s*Call\s*\(\s*(["\'])\s*([^"\']+)\1', content):
                            hook_name = m.group(2)
                            if (hook_name not in documented_hooks and
                                hook_name not in documented_module_hooks and
                                hook_name not in GMOD_HOOKS_BLACKLIST):
                                undoc_hooks.add(hook_name)
                                self._append_hook_location(
                                    hook_locations,
                                    hook_name,
                                    self._classify_hook_location(fpath, "standard", module_dir, "module", module_name),
                                )

                results.append({
                    'module_path': str(module_dir),
                    'module_name': module_name,
                    'module_scope': 'module',
                    'undoc_hooks': sorted(undoc_hooks, key=str.lower),
                    'hook_locations': hook_locations,
                    'undoc_functions': sorted(undoc_functions, key=str.lower),
                    'undoc_meta_functions': sorted(undoc_meta_functions, key=str.lower),
                })

                
                for submod_dir in submodules:
                    submod_documented_hooks, submod_documented_functions = self._read_module_docs(submod_dir)
                    submod_undoc_functions: Set[str] = set()
                    submod_undoc_hooks: Set[str] = set()
                    submod_undoc_meta_functions: Set[str] = set()
                    submod_hook_locations: Dict[str, List[Dict[str, str]]] = {}

                    for root, _, files in os.walk(submod_dir):
                        
                        if 'addons' in Path(root).parts:
                            continue
                        for fname in files:
                            if not fname.lower().endswith('.lua'):
                                continue
                            fpath = Path(root) / fname
                            try:
                                with open(fpath, 'r', encoding='utf-8', errors='ignore') as f:
                                    content = f.read()
                            except Exception:
                                continue

                            content = self._remove_lua_comments(content)

                            import re
                            
                            for m in re.finditer(r'\b(function\s+([A-Za-z_][\w\.]*?)\s*\(|([A-Za-z_][\w\.]*?)\s*=\s*function\s*\()', content):
                                name = m.group(2) or m.group(3)
                                if name and name.startswith('lia.') and name.count('.') >= 2:
                                    if name not in documented_functions and name not in submod_documented_functions:
                                        submod_undoc_functions.add(name)

                            for m in re.finditer(r'^\s*function\s+([A-Za-z_]*Meta):([A-Za-z_][\w]*)\s*\(([^)]*)\)', content, re.MULTILINE):
                                meta_name = f"{m.group(1)}:{m.group(2)}"
                                if meta_name not in documented_functions and meta_name not in submod_documented_functions:
                                    submod_undoc_meta_functions.add(meta_name)

                            
                            for m in re.finditer(r'hook\s*\.\s*Add\s*\(\s*(["\'])\s*([^"\']+)\1', content):
                                hook_name = m.group(2)
                                if (hook_name not in documented_hooks and
                                    hook_name not in submod_documented_hooks and
                                    hook_name not in GMOD_HOOKS_BLACKLIST):
                                    submod_undoc_hooks.add(hook_name)
                                    self._append_hook_location(
                                        submod_hook_locations,
                                        hook_name,
                                        self._classify_hook_location(fpath, "standard", submod_dir, "submodule", submod_dir.name),
                                    )
                            for m in re.finditer(r'hook\s*\.\s*Run\s*\(\s*(["\'])\s*([^"\']+)\1', content):
                                hook_name = m.group(2)
                                if (hook_name not in documented_hooks and
                                    hook_name not in submod_documented_hooks and
                                    hook_name not in GMOD_HOOKS_BLACKLIST):
                                    submod_undoc_hooks.add(hook_name)
                                    self._append_hook_location(
                                        submod_hook_locations,
                                        hook_name,
                                        self._classify_hook_location(fpath, "standard", submod_dir, "submodule", submod_dir.name),
                                    )
                            for m in re.finditer(r'hook\s*\.\s*Call\s*\(\s*(["\'])\s*([^"\']+)\1', content):
                                hook_name = m.group(2)
                                if (hook_name not in documented_hooks and
                                    hook_name not in submod_documented_hooks and
                                    hook_name not in GMOD_HOOKS_BLACKLIST):
                                    submod_undoc_hooks.add(hook_name)
                                    self._append_hook_location(
                                        submod_hook_locations,
                                        hook_name,
                                        self._classify_hook_location(fpath, "standard", submod_dir, "submodule", submod_dir.name),
                                    )

                    results.append({
                        'module_path': str(submod_dir),
                        'module_name': submod_dir.name,
                        'module_scope': 'submodule',
                        'undoc_hooks': sorted(submod_undoc_hooks, key=str.lower),
                        'hook_locations': submod_hook_locations,
                        'undoc_functions': sorted(submod_undoc_functions, key=str.lower),
                        'undoc_meta_functions': sorted(submod_undoc_meta_functions, key=str.lower),
                    })

        return results

    def _read_module_docs(self, module_dir: Path) -> Tuple[Set[str], Set[str]]:
        """Read module-level documentation markers from module_dir/docs.
        - hooks.md: list of documented hook names (strings)
        - libraries.md: list of documented lia.* function names
        - meta.md: list of documented meta methods
        Returns (documented_hooks, documented_functions)
        """
        documented_hooks: Set[str] = set()
        documented_functions: Set[str] = set()

        docs_dir = module_dir / 'docs'
        if not docs_dir.exists() or not docs_dir.is_dir():
            return documented_hooks, documented_functions

        
        hooks_file = docs_dir / 'hooks.md'
        if hooks_file.exists():
            try:
                with open(hooks_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                import re
                
                for m in re.finditer(r'^##+\s+([A-Za-z_][A-Za-z0-9_]*)\s*$', content, re.MULTILINE):
                    documented_hooks.add(m.group(1))
            except Exception:
                pass

        
        libs_file = docs_dir / 'libraries.md'
        if libs_file.exists():
            try:
                with open(libs_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                import re
                
                for m in re.finditer(r'^##+\s+(lia\.[A-Za-z_][\w\.]*)\s*$', content, re.MULTILINE):
                    documented_functions.add(m.group(1))
            except Exception:
                pass

        meta_file = docs_dir / 'meta.md'
        if meta_file.exists():
            try:
                with open(meta_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                import re
                stem = meta_file.stem
                overrides = {
                    'tool': 'toolGunMeta',
                }
                for m in re.finditer(r'^##+\s+([A-Za-z_][\w:]*)\s*$', content, re.MULTILINE):
                    method_name = m.group(1).strip()
                    if ':' in method_name and method_name.split(':', 1)[0].endswith('Meta'):
                        documented_functions.add(method_name)
                for m in re.finditer(r'`([A-Za-z_][\w\.:]*)\([^)]*\)`', content):
                    method_name = m.group(1).strip()
                    if ':' in method_name and method_name.split(':', 1)[0].endswith('Meta'):
                        documented_functions.add(method_name)
                for m in re.finditer(r'<summary><a[^>]*></a>([A-Za-z_][\w]+)\([^)]*\)</summary>', content):
                    method_name = m.group(1).strip()
                    documented_functions.add(f"{stem}Meta:{method_name}")
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

        
        for entry in modules_scan:
            undoc_hooks = entry.get('undoc_hooks', [])
            undoc_functions = entry.get('undoc_functions', [])
            undoc_meta_functions = entry.get('undoc_meta_functions', [])
            if not undoc_hooks and not undoc_functions and not undoc_meta_functions:
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
            if undoc_meta_functions:
                if undoc_hooks or undoc_functions:
                    lines.append("")
                lines.append("- **Undocumented Meta Functions:**")
                for f in undoc_meta_functions:
                    lines.append(f"  - `{f}()`")
            lines.append("")

        
        if modules_scan:
            lines.append("---")
            lines.append("")
            lines.append("# Module Documentation Summary")
            lines.append("")
            lines.append("| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |")
            lines.append("|---|---:|---:|---:|")
            for entry in modules_scan:
                lines.append(f"| {entry['module_path']} | {len(entry.get('undoc_hooks', []))} | {len(entry.get('undoc_functions', []))} | {len(entry.get('undoc_meta_functions', []))} |")
            lines.append("")

        return lines

    def _generate_module_docs(self, data: CombinedReportData) -> None:
        """Generate docs inside each external module (non-Lilia) when entries are found.

        Rules:
        - Only modules (from modules_paths) are considered; framework base is ignored.
        - Create a `docs` folder in module directory when any entries exist.
        - If functions with dotted names (e.g., lia.something.doThing) exist, write libraries.md.
        - If hooks are found in module code that are NOT already documented in gamemode_hooks.md, write hooks.md.
        - If meta methods are found in module code, write meta.md scoped to those module-owned methods.
        """
        
        function_map = data.function_comparison or {}

        
        per_file_functions = {}
        for file_name, file_data in function_map.items():
            per_file_functions[file_name] = list(file_data.get('functions', {}).keys())

        
        try:
            documented_hooks = self._read_all_documented_hooks()
        except Exception:
            documented_hooks = set()

        
        try:
            documented_functions = set()
            docs_path = Path(self.docs_path) / "docs"

            
            if (docs_path / "libraries").exists():
                for md_file in (docs_path / "libraries").glob("*.md"):
                    if md_file.name.startswith("lia."):
                        try:
                            with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
                                content = f.read()
                            
                            import re
                            for match in re.finditer(r'^###+\s+([A-Za-z_][\w\.:]*)\s*$', content, re.MULTILINE):
                                func_name = match.group(1).strip()
                                documented_functions.add(func_name)
                            for match in re.finditer(r'<summary><a[^>]*></a>([A-Za-z_][\w\.:]+)\([^)]*\)</summary>', content):
                                func_name = match.group(1).strip()
                                documented_functions.add(func_name)
                        except Exception:
                            continue

            
            if (docs_path / "meta").exists():
                for md_file in (docs_path / "meta").glob("*.md"):
                    try:
                        with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read()
                        
                        for match in re.finditer(r'`([A-Za-z_][\w\.:]*)\([^)]*\)`', content):
                            method_name = match.group(1).strip()
                            documented_functions.add(method_name)
                        
                        stem = md_file.stem
                        overrides = {
                            'tool': 'toolGunMeta',
                        }
                        meta_table = overrides.get(stem, f"{stem}Meta")
                        for match in re.finditer(r'<summary><a[^>]*></a>([A-Za-z_][\w]+)\([^)]*\)</summary>', content):
                            method_name = match.group(1).strip()
                            qualified_name = f"{meta_table}:{method_name}"
                            documented_functions.add(qualified_name)
                    except Exception:
                        continue

        except Exception:
            documented_functions = set()

        
        lang_name = Path(self.language_file).stem
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

                docs_dir = module_dir / 'docs'

                
                submodules = []
                for item in module_dir.iterdir():
                    if item.is_dir() and (item / "module.lua").exists():
                        submodules.append(item)

                
                dotted_functions = []
                meta_functions = []
                hooks_found = set()

                for root, _, files in os.walk(module_dir):
                    
                    if 'addons' in Path(root).parts:
                        continue
                    
                    root_path = Path(root)
                    is_submodule_path = any(root_path.is_relative_to(submod) or root_path == submod for submod in submodules)
                    if is_submodule_path:
                        continue
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
                        for m in re.finditer(r'\b(function\s+([A-Za-z_][\w\.]*?)\s*\(|([A-Za-z_][\w\.]*?)\s*=\s*function\s*\()', content):
                            name = m.group(2) or m.group(3)
                            
                            
                            if (name and name.startswith('lia.') and name.count('.') >= 2
                                and name not in documented_functions):
                                dotted_functions.append(name)

                        for m in re.finditer(r'^\s*function\s+([A-Za-z_]*Meta):([A-Za-z_][\w]*)\s*\(([^)]*)\)', content, re.MULTILINE):
                            name = f"{m.group(1)}:{m.group(2)}"
                            if name not in documented_functions:
                                meta_functions.append(name)

                        
                        
                        for m in re.finditer(r'hook\s*\.\s*Add\s*\(\s*([\"\"])\s*([^\"\']+)\1', content):
                            hook_name = m.group(2)
                            if hook_name not in documented_hooks:
                                hooks_found.add(hook_name)
                        for m in re.finditer(r'hook\s*\.\s*Run\s*\(\s*([\"\"])\s*([^\"\']+)\1', content):
                            hook_name = m.group(2)
                            if hook_name not in documented_hooks:
                                hooks_found.add(hook_name)

                
                if dotted_functions or meta_functions or hooks_found:
                    docs_dir.mkdir(parents=True, exist_ok=True)

                    
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

                    if meta_functions:
                        meta_md_path = docs_dir / 'meta.md'
                        with open(meta_md_path, 'w', encoding='utf-8') as f:
                            f.write('# Module Meta\n\n')
                            f.write('Detected meta methods owned by this module.\n\n')
                            for name in sorted(set(meta_functions), key=str.lower):
                                f.write(f'## {name}\n\n')
                                f.write('**Purpose**\n\n')
                                f.write('Method description goes here.\n\n')
                                f.write('**Parameters**\n\n')
                                f.write('* `param1` (*type*): Description\n\n')
                                f.write('**Returns**\n\n')
                                f.write('* `return` (*type*): Description\n\n')
                                f.write('**Realm**\n\n')
                                f.write('Shared.\n\n')
                                f.write('**Example Usage**\n\n')
                                f.write('```lua\n')
                                f.write(f'-- Example usage of {name}\n')
                                f.write(f'object:{name.split(":", 1)[1]}()\n')
                                f.write('```\n\n')
                                f.write('---\n\n')

                    
                    hooks_md_path = docs_dir / 'hooks.md'

                    
                    existing_hooks = set()
                    if hooks_md_path.exists():
                        try:
                            with open(hooks_md_path, 'r', encoding='utf-8') as f:
                                content = f.read()
                                
                                import re
                                for match in re.finditer(r'^##+\s+([A-Za-z_][A-Za-z0-9_]*)\s*$', content, re.MULTILINE):
                                    existing_hooks.add(match.group(1).strip())
                        except Exception:
                            existing_hooks = set()

                    
                    new_hooks = hooks_found - existing_hooks

                    
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

                    
                    if new_hooks:
                        hooks_new_path = docs_dir / 'hooks_new.md'
                        with open(hooks_new_path, 'w', encoding='utf-8') as f:
                            f.write('# New Module Hooks\n\n')
                            f.write('New hooks detected in this module that were not in the previous hooks.md:\n\n')
                            for name in sorted(new_hooks, key=str.lower):
                                f.write(f'- `{name}`\n')

                
                for submod_dir in submodules:
                    submod_docs_dir = submod_dir / 'docs'
                    submod_dotted_functions = []
                    submod_hooks_found = set()

                    for root, _, files in os.walk(submod_dir):
                        
                        if 'addons' in Path(root).parts:
                            continue
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
                            for m in re.finditer(r'\b(function\s+([A-Za-z_][\w\.]*?)\s*\(|([A-Za-z_][\w\.]*?)\s*=\s*function\s*\()', content):
                                name = m.group(2) or m.group(3)
                                if (name and name.startswith('lia.') and name.count('.') >= 2
                                    and name not in documented_functions):
                                    submod_dotted_functions.append(name)

                            
                            for m in re.finditer(r'hook\s*\.\s*Add\s*\(\s*([\"\"])\s*([^\"\']+)\1', content):
                                hook_name = m.group(2)
                                if hook_name not in documented_hooks:
                                    submod_hooks_found.add(hook_name)
                            for m in re.finditer(r'hook\s*\.\s*Run\s*\(\s*([\"\"])\s*([^\"\']+)\1', content):
                                hook_name = m.group(2)
                                if hook_name not in documented_hooks:
                                    submod_hooks_found.add(hook_name)

                    
                    if submod_dotted_functions or submod_hooks_found:
                        submod_docs_dir.mkdir(parents=True, exist_ok=True)

                        
                        if submod_dotted_functions:
                            submod_lib_md_path = submod_docs_dir / 'libraries.md'
                            with open(submod_lib_md_path, 'w', encoding='utf-8') as f:
                                f.write('# Module Libraries\n\n')
                                f.write('Detected dotted functions in this module.\n\n')
                                for name in sorted(set(submod_dotted_functions)):
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

                        
                        submod_hooks_md_path = submod_docs_dir / 'hooks.md'
                        with open(submod_hooks_md_path, 'w', encoding='utf-8') as f:
                            f.write('# Module Hooks\n\n')
                            f.write('This document describes the hooks available in this module.\n\n')
                            f.write('---\n\n')
                            if submod_hooks_found:
                                for name in sorted(submod_hooks_found, key=str.lower):
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

    def _generate_executive_summary(self, data: CombinedReportData) -> List[str]:
        """Generate executive summary section"""
        lines = ["## Executive Summary", ""]

        
        total_functions = sum(r.get('total_functions', 0) for r in data.function_comparison.values())
        total_documented = sum(r.get('documented_functions', 0) for r in data.function_comparison.values())
        total_missing = sum(len(r.get('missing_functions', [])) for r in data.function_comparison.values())
        total_missing_unique = sum(r.get('missing_functions_count', len(r.get('missing_functions', []))) for r in data.function_comparison.values())
        
        missing_library_count = len(data.missing_library_functions)
        missing_hook_count = len(data.missing_hook_functions)
        missing_meta_count = len(data.missing_meta_functions)

        
        hooks_missing_count = len(data.hooks_missing)
        
        unused_hooks_count = len([h for h in data.hooks_documented if h not in data.hooks_registered and h not in FRAMEWORK_HOOKS_WHITELIST and h not in HOOKS_REPORT_IGNORE])

        
        undefined_calls = data.localization_data.get('undefined_count', len(data.localization_data.get('undefined_rows', []))) if data.localization_data else 0
        at_patterns = data.localization_data.get('at_pattern_count', len(data.localization_data.get('at_pattern_rows', []))) if data.localization_data else 0
        arg_mismatches = len(data.argument_mismatches)
        module_conflicts = len(getattr(data, 'module_localization_conflicts', {}) or {})
        net_defined_count = len(getattr(data, 'net_messages_defined', {}) or {})
        net_used_count = len(getattr(data, 'net_messages_used', {}) or {})
        net_unused_count = len(getattr(data, 'net_messages_unused_defined', []) or [])
        net_undefined_count = len(getattr(data, 'net_messages_used_but_undefined', []) or [])

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
            "### Localization Analysis",
            f"- **Undefined Calls:** {undefined_calls} unique",
            f"- **@xxxxx Patterns:** {at_patterns} unique",
            f"- **Module Key Conflicts:** {module_conflicts} keys",
            f"- **Argument Mismatches:** {arg_mismatches}",
            "",
            "### Net Message Analysis",
            f"- **Defined Net Messages:** {net_defined_count}",
            f"- **Used Net Messages:** {net_used_count}",
            f"- **Defined But Unused:** {net_unused_count}",
            f"- **Used But Undefined:** {net_undefined_count}",
            "",
        ])

        config_undefined_count = len(getattr(data, 'config_undefined_get_calls', []) or [])
        lines.extend([
            "### Config Analysis",
            f"- **Undefined lia.config.get Keys:** {config_undefined_count}",
        ])
        if self.generate_module_docs:
            inferred_undef_count = len(getattr(data, 'undefined_inferred_loc_keys', []) or [])
            lines.append(f"- **Undefined Inferred Localization Keys:** {inferred_undef_count}")
        lines.extend(["", ])

        lines.extend(["---", ""])

        return lines

    def _generate_function_docs_section(self, data: CombinedReportData) -> List[str]:
        """Generate function documentation section"""
        lines = ["## Function Documentation Analysis", ""]

        if not data.function_comparison:
            lines.append("_No function comparison data available._")
            lines.append("")
            return lines

        
        total_files = len(data.function_comparison)
        total_missing = sum(len(r.get('missing_functions', [])) for r in data.function_comparison.values())

        lines.extend([
            "### Summary",
            f"- **Files Analyzed:** {total_files}",
            f"- **Missing Documentation:** {total_missing} unique functions",
            "",
        ])

        
        if data.missing_library_functions:
            lines.extend([
                "### Missing Library Functions",
                f"Total: {len(data.missing_library_functions)} functions",
                "",
            ])
            
            
            library_groups = {}
            for func_info in data.missing_library_functions:
                func_name = func_info.name
                if '.' in func_name:
                    
                    parts = func_name.split('.')
                    if len(parts) >= 2:
                        
                        if parts[0] == 'lia' and len(parts) == 2:
                            library_prefix = 'lia'
                        else:
                            
                            library_prefix = '.'.join(parts[:2])
                    else:
                        library_prefix = parts[0]  
                else:
                    library_prefix = "other"

                if library_prefix not in library_groups:
                    library_groups[library_prefix] = []
                library_groups[library_prefix].append(func_info)

            
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
            
            
            meta_groups = {}
            for func_info in data.missing_meta_functions:
                func_name = func_info.name
                
                
                if ':' in func_name:
                    meta_type = func_name.split(':')[0]  
                else:
                    meta_type = "other"

                if meta_type not in meta_groups:
                    meta_groups[meta_type] = []
                meta_groups[meta_type].append(func_info)

            
            for meta_type in sorted(meta_groups.keys()):
                functions = meta_groups[meta_type]
                lines.append(f"#### {meta_type}")
                lines.append(f"Count: {len(functions)} functions")
                lines.append("")
                for func_info in sorted(functions, key=lambda f: f.name):
                    lines.append(f"- `{self._format_function_signature(func_info)}`")
                lines.append("")

        
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

        
        unused_hooks = [h for h in data.hooks_documented if h not in data.hooks_registered and h not in FRAMEWORK_HOOKS_WHITELIST and h not in HOOKS_REPORT_IGNORE]
        method_hooks = sorted(data.hooks_method) if getattr(data, "hooks_method", None) else []
        standard_hooks = sorted(data.hooks_standard) if getattr(data, "hooks_standard", None) else []
        hook_locations = getattr(data, "hooks_locations", {}) or {}

        lines.extend([
            f"### Summary",
            f"- **Missing Hooks:** {len(data.hooks_missing)} (used in code but not documented)",
            f"- **Documented Hooks:** {len(data.hooks_documented)}",
            f"- **Registered Hooks:** {len(data.hooks_registered)}",
            f"- **Method Hooks:** {len(method_hooks)} (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)",
            f"- **Standard Hooks:** {len(standard_hooks)} (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)",
            f"- **Unused Hooks:** {len(unused_hooks)} (documented but not registered)",
            "",
        ])

        if method_hooks:
            lines.append("### Method-Style Hooks:")
            lines.append("These hooks are defined as `function GM:HookName(...)`, `function MODULE:HookName(...)`, or `function SCHEMA:HookName(...)`.")
            for hook in method_hooks:
                params = data.hooks_signatures.get(hook, []) if hasattr(data, 'hooks_signatures') else []
                if params:
                    param_str = ', '.join(params)
                    lines.append(f"- `{hook}({param_str})`")
                else:
                    lines.append(f"- `{hook}()`")
            lines.append("")

        module_location_hooks: Dict[str, List[Dict[str, str]]] = {}
        for entry in getattr(data, "modules_scan", []) or []:
            for hook_name, locations in (entry.get("hook_locations", {}) or {}).items():
                module_location_hooks.setdefault(hook_name, [])
                for location in locations:
                    if location not in module_location_hooks[hook_name]:
                        module_location_hooks[hook_name].append(location)

        library_hook_locations = self._filter_hook_locations_by_kinds(hook_locations, {"library"})
        library_hook_names = sorted(library_hook_locations.keys(), key=str.lower)
        if library_hook_names:
            lines.extend(self._generate_hook_locations_block(
                library_hook_locations,
                library_hook_names,
                "### Library Hook Registration Locations:",
                "These entries show hooks registered from framework libraries.",
            ))

        module_submodule_hook_names = sorted(module_location_hooks.keys(), key=str.lower)
        if module_submodule_hook_names:
            lines.extend(self._generate_hook_locations_block(
                module_location_hooks,
                module_submodule_hook_names,
                "### Module and Submodule Hook Registration Locations:",
                "These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.",
            ))

        other_hook_locations = self._filter_hook_locations_by_kinds(
            hook_locations,
            {"core", "meta", "entity", "item", "plugin", "schema", "other"},
        )
        other_hook_names = sorted(other_hook_locations.keys(), key=str.lower)
        if other_hook_names:
            lines.extend(self._generate_hook_locations_block(
                other_hook_locations,
                other_hook_names,
                "### Other Hook Registration Locations:",
                "These entries show hooks registered outside libraries and outside external module/submodule scans.",
            ))

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


    def _generate_fonts_section(self, data: CombinedReportData) -> List[str]:
        """Generate font analysis section"""
        lines = ["## Font Analysis", ""]

        if not data.fonts_registered and not data.fonts_used:
            lines.append("_No font analysis data available._")
            lines.append("")
            return lines

        
        lines.append("### Used But Not Registered Fonts")
        lines.append("")
        if data.fonts_unregistered:
            for font in sorted(data.fonts_unregistered):
                lines.append(f"- `{font}`")
            lines.append("")
        else:
            lines.append("None")
            lines.append("")

        
        lines.append("### Registered Fonts")
        lines.append("")
        if data.fonts_registered:
            for font in sorted(data.fonts_registered):
                lines.append(f"- `{font}`")
            lines.append("")
        else:
            lines.append("None")
            lines.append("")

        return lines

    def _generate_localization_section(self, data: CombinedReportData) -> List[str]:
        """Generate localized report section as requested by user."""
        lines = ["## Localization Analysis", ""]

        loc_data = data.localization_data or {}
        inferred = getattr(data, "inferred_localization", {}) or {}

        unique_keys = len(loc_data.get('keys', {}))
        undefined_calls = loc_data.get('undefined_count', len(loc_data.get('undefined_rows', [])))
        arg_mismatch_count = len(data.argument_mismatches or [])

        lines.append(f"- **Unique Keys:** {unique_keys}")
        lines.append(f"- **Undefined Calls:** {undefined_calls}")
        lines.append(f"- **Argument Mismatch:** {arg_mismatch_count}")
        lines.append("")

        
        lines.append("### Undefined Calls")
        lines.append("")

        undefined_rows = loc_data.get('undefined_rows', [])
        if undefined_rows:
            for row in undefined_rows:
                
                rel_file = row[0]
                line_num = row[1]
                line_content = row[2]
                key = row[4] if len(row) > 4 else None
                lines.append(f"- **{key}** in {rel_file}:{line_num}")
                lines.append(f"  - Context: {line_content}")
        else:
            lines.append("- None")

        lines.append("")

        
        lines.append("### Argument Mismatches")
        lines.append("")
        lines.append(f"- **Total Mismatches:** {arg_mismatch_count}")

        if arg_mismatch_count > 0:
            lines.append("")
            file_mismatches = defaultdict(list)
            for mismatch in data.argument_mismatches:
                file_mismatches[mismatch['file']].append(mismatch)

            for filename in sorted(file_mismatches.keys(), key=str.lower):
                lines.append("")
                lines.append(f"#### {filename}")
                for mismatch in sorted(file_mismatches[filename], key=lambda x: x['line']):
                    
                    lines.append(f"- **Line {mismatch['line']}:** {mismatch['key']}({mismatch.get('provided')})")
                    lines.append(f"  - Expected: {mismatch['expected']} args, Provided: {mismatch['provided']} args")
                    context_text = mismatch.get('context', '')
                    lines.append(f"  - Context: {context_text}")

        lines.append("")

        
        inferred_undef = getattr(data, "undefined_inferred_loc_keys", []) or []
        if inferred_undef:
            lines.append("### Undefined or Unlocalized Inferred Localization Values")
            lines.append("")
            lines.append(
                "These string literals are stored in localization-by-convention fields "
                "(e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) "
                "and either reference a missing language key or use plain unlocalized text."
            )
            lines.append("")

            
            by_field: Dict[str, List[Dict]] = defaultdict(list)
            for entry in inferred_undef:
                by_field[entry["field"]].append(entry)

            lines.append("| Field | Issue | Value | File | Line |")
            lines.append("|---|---|---|---|---:|")
            for field in sorted(by_field.keys()):
                for entry in by_field[field]:
                    issue_label = "Missing key" if entry.get("issue") == "missing_key" else "Unlocalized string"
                    lines.append(
                        f"| `{entry['field']}` | {issue_label} | `{entry['key']}` | {entry['file']} | {entry['line']} |"
                    )
            lines.append("")

        return lines

    def _generate_language_comparison_section(self, data: CombinedReportData) -> List[str]:
        """Generate language comparison section"""
        lines = ["## Language File Comparison", ""]

        if not data.language_comparison:
            lines.append("_No language comparison data available._")
            lines.append("")
            return lines

        
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

        
        for base_lang in sorted(data.language_comparison.keys()):
            lang_missing = data.language_comparison[base_lang]

            if not any(lang_missing.values()):  
                continue

            lines.append(f"### {base_lang.title()}")
            lines.append("")

            
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

    def _json_safe(self, value: Any) -> Any:
        """Recursively convert analysis data into JSON-safe values."""
        if isinstance(value, Path):
            return str(value)
        if isinstance(value, set):
            return sorted(self._json_safe(item) for item in value)
        if isinstance(value, tuple):
            return [self._json_safe(item) for item in value]
        if isinstance(value, list):
            return [self._json_safe(item) for item in value]
        if isinstance(value, dict):
            return {str(key): self._json_safe(item) for key, item in value.items()}
        if hasattr(value, "__dataclass_fields__"):
            return {
                field_name: self._json_safe(getattr(value, field_name))
                for field_name in value.__dataclass_fields__.keys()
            }
        return value

    def _build_executive_summary_payload(self, data: CombinedReportData) -> Dict[str, Any]:
        """Build a compact summary payload for dashboard consumers."""
        total_functions = sum(r.get('total_functions', 0) for r in data.function_comparison.values())
        total_documented = sum(r.get('documented_functions', 0) for r in data.function_comparison.values())
        total_missing_unique = sum(r.get('missing_functions_count', len(r.get('missing_functions', []))) for r in data.function_comparison.values())
        unused_lilia_count = sum(
            r.get('unused_functions_count', len(r.get('unused_functions', [])))
            for r in data.function_comparison.values()
        )
        hooks_missing_count = len(data.hooks_missing)
        unused_hooks_count = len([
            h for h in data.hooks_documented
            if h not in data.hooks_registered and h not in FRAMEWORK_HOOKS_WHITELIST and h not in HOOKS_REPORT_IGNORE
        ])
        undefined_calls = data.localization_data.get('undefined_count', len(data.localization_data.get('undefined_rows', []))) if data.localization_data else 0
        at_patterns = data.localization_data.get('at_pattern_count', len(data.localization_data.get('at_pattern_rows', []))) if data.localization_data else 0
        module_conflicts = len(getattr(data, 'module_localization_conflicts', {}) or {})
        config_undefined_count = len(getattr(data, 'config_undefined_get_calls', []) or [])
        net_defined_count = len(getattr(data, 'net_messages_defined', {}) or {})
        net_used_count = len(getattr(data, 'net_messages_used', {}) or {})
        net_unused_count = len(getattr(data, 'net_messages_unused_defined', []) or [])
        net_undefined_count = len(getattr(data, 'net_messages_used_but_undefined', []) or [])
        derma_defined_count = len(getattr(data, 'derma_panels_defined', []) or [])
        derma_unused_count = len(getattr(data, 'derma_panels_unused', []) or [])
        file_placement_count = len(getattr(data, 'module_file_placement_issues', []) or [])
        duplicate_language_total = len((((getattr(data, "duplicate_key_analysis", {}) or {}).get("language_duplicates", {}) or {}).get("files", []) or []))
        duplicate_language_entries = (((getattr(data, "duplicate_key_analysis", {}) or {}).get("language_duplicates", {}) or {}).get("total_duplicates", 0))
        privilege_framework = (getattr(data, "privilege_report", {}) or {}).get("framework", {}) or {}
        privilege_modules = (getattr(data, "privilege_report", {}) or {}).get("counts", {}) or {}

        coverage_percent = round((total_documented / total_functions) * 100, 2) if total_functions else None

        return {
            "functions": {
                "total": total_functions,
                "documented": total_documented,
                "missing_unique": total_missing_unique,
                "missing_library": len(data.missing_library_functions),
                "missing_hooks": len(data.missing_hook_functions),
                "missing_meta": len(data.missing_meta_functions),
                "unused_lilia": unused_lilia_count,
                "coverage_percent": coverage_percent,
            },
            "hooks": {
                "missing": hooks_missing_count,
                "unused": unused_hooks_count,
                "documented_total": len(data.hooks_documented),
                "registered_total": len(data.hooks_registered),
            },
            "localization": {
                "undefined_calls": undefined_calls,
                "at_patterns": at_patterns,
                "argument_mismatches": len(data.argument_mismatches),
                "module_conflicts": module_conflicts,
                "undefined_inferred_keys": len(getattr(data, "undefined_inferred_loc_keys", []) or []),
            },
            "net_messages": {
                "defined": net_defined_count,
                "used": net_used_count,
                "unused_defined": net_unused_count,
                "used_but_undefined": net_undefined_count,
                "direction_issues": len(getattr(data, "net_messages_direction_issues", []) or []),
            },
            "derma": {
                "defined": derma_defined_count,
                "unused": derma_unused_count,
                "outside_folder": len(getattr(data, "module_derma_panels_outside_folder", []) or []),
            },
            "file_placement": {
                "issues": file_placement_count,
            },
            "config": {
                "undefined_get_calls": config_undefined_count,
            },
            "modules": {
                "scanned": len(getattr(data, "modules_scan", []) or []),
                "localization_entries": len(getattr(data, "modules_data", []) or []),
            },
            "duplicates": {
                "language_files_with_duplicates": duplicate_language_total,
                "duplicate_entries": duplicate_language_entries,
            },
            "privileges": {
                "framework_missing": (privilege_framework.get("counts", {}) or {}).get("used_but_not_registered", 0),
                "framework_unused": (privilege_framework.get("counts", {}) or {}).get("registered_but_not_used", 0),
                "modules_with_missing_registrations": privilege_modules.get("modules_with_missing_registrations", 0),
                "modules_scanned": privilege_modules.get("modules_scanned", 0),
            },
        }

    def build_dashboard_snapshot(self, data: CombinedReportData, metadata: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Return a stable JSON snapshot for the local dashboard."""
        metadata = dict(metadata or {})
        metadata.setdefault("schema_version", 1)
        metadata.setdefault("generated_at", data.generated_at)
        metadata.setdefault("report_generated_at", data.generated_at)

        functions_by_file = []
        for file_path, file_data in sorted((data.function_comparison or {}).items(), key=lambda item: str(item[0]).lower()):
            functions_by_file.append({
                "file": file_path,
                "total_functions": file_data.get("total_functions", 0),
                "documented_functions": file_data.get("documented_functions", 0),
                "missing_functions_count": file_data.get("missing_functions_count", len(file_data.get("missing_functions", []))),
                "missing_functions": list(file_data.get("missing_functions", [])),
                "unused_functions_count": file_data.get("unused_functions_count", len(file_data.get("unused_functions", []))),
                "unused_functions": list(file_data.get("unused_functions", [])),
                "extra_documented": list(file_data.get("extra_documented", [])),
                "functions": self._json_safe(file_data.get("functions", {})),
            })

        hooks_unused = sorted([
            h for h in data.hooks_documented
            if h not in data.hooks_registered and h not in FRAMEWORK_HOOKS_WHITELIST and h not in HOOKS_REPORT_IGNORE
        ], key=str.lower)

        snapshot = {
            "metadata": self._json_safe(metadata),
            "summary": self._build_executive_summary_payload(data),
            "sections": {
                "functions": {
                    "missing_library_functions": self._json_safe(data.missing_library_functions),
                    "missing_hook_functions": self._json_safe(data.missing_hook_functions),
                    "missing_meta_functions": self._json_safe(data.missing_meta_functions),
                    "unused_lilia_functions": self._json_safe([
                        function_name
                        for file_data in (data.function_comparison or {}).values()
                        for function_name in file_data.get("unused_functions", [])
                    ]),
                    "files": functions_by_file,
                },
                "hooks": {
                    "missing": list(data.hooks_missing),
                    "unused": hooks_unused,
                    "documented": list(data.hooks_documented),
                    "registered": list(data.hooks_registered),
                    "signatures": self._json_safe(getattr(data, "hooks_signatures", {}) or {}),
                    "locations": self._json_safe(getattr(data, "hooks_locations", {}) or {}),
                    "method_hooks": list(getattr(data, "hooks_method", []) or []),
                    "standard_hooks": list(getattr(data, "hooks_standard", []) or []),
                },
                "localization": {
                    "overview": self._json_safe(data.localization_data or {}),
                    "argument_mismatches": self._json_safe(data.argument_mismatches),
                    "inferred_localization": self._json_safe(data.inferred_localization),
                    "module_conflicts": self._json_safe(data.module_localization_conflicts),
                    "modules_data": self._json_safe(data.modules_data),
                    "language_comparison": self._json_safe(data.language_comparison),
                    "undefined_inferred_loc_keys": self._json_safe(getattr(data, "undefined_inferred_loc_keys", []) or []),
                },
                "net_messages": {
                    "defined": self._json_safe(data.net_messages_defined),
                    "used": self._json_safe(data.net_messages_used),
                    "unused_defined": self._json_safe(data.net_messages_unused_defined),
                    "used_but_undefined": self._json_safe(data.net_messages_used_but_undefined),
                    "analysis_notes": self._json_safe(data.net_message_analysis_notes),
                    "module_misregistered": self._json_safe(data.module_net_messages_misregistered),
                    "module_undefined": self._json_safe(data.module_net_messages_undefined),
                    "module_notes": self._json_safe(data.module_net_messages_notes),
                    "direction_issues": self._json_safe(data.net_messages_direction_issues),
                },
                "derma": {
                    "defined": self._json_safe(data.derma_panels_defined),
                    "used": self._json_safe(data.derma_panels_used),
                    "unused": self._json_safe(data.derma_panels_unused),
                    "outside_folder": self._json_safe(data.module_derma_panels_outside_folder),
                },
                "file_placement": {
                    "issues": self._json_safe(data.module_file_placement_issues),
                },
                "config": {
                    "undefined_get_calls": self._json_safe(data.config_undefined_get_calls),
                },
                "fonts": {
                    "registered": self._json_safe(data.fonts_registered),
                    "used": self._json_safe(data.fonts_used),
                    "unregistered": self._json_safe(data.fonts_unregistered),
                    "default_gmod": self._json_safe(data.fonts_default_gmod),
                    "variable": self._json_safe(data.fonts_variable),
                    "getfont_count": data.fonts_getfont_count,
                    "file_usages": self._json_safe(data.fonts_file_usages),
                },
                "modules": {
                    "scan_results": self._json_safe(data.modules_scan),
                },
                "duplicates": self._json_safe(getattr(data, "duplicate_key_analysis", {}) or {}),
                "privileges": self._json_safe(getattr(data, "privilege_report", {}) or {}),
            },
        }
        return snapshot

    def save_report(self, data: CombinedReportData, output_file: str = None):
        """Generate and save the comprehensive report"""
        reports_dir = self._get_reports_dir()
        reports_dir.mkdir(parents=True, exist_ok=True)

        if output_file is None:
            output_file = str(reports_dir / "lilia.md")
        else:
            
            if not Path(output_file).is_absolute():
                output_file = str(reports_dir / output_file)

        report = self.generate_markdown_report(data)

        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(report)

        return output_file

    def save_reports(self, data: CombinedReportData, output_file: str = None) -> List[str]:
        """Generate the centralized framework report plus one report per detected module."""
        report_files = [self.save_report(data, output_file)]
        reports_dir = self._get_reports_dir()
        reports_dir.mkdir(parents=True, exist_ok=True)

        for target in self._build_report_targets(data):
            if target.module_path is None:
                continue

            scoped_data = self._build_scoped_report_data(data, target)
            output_path = reports_dir / f"{target.report_name}.md"
            report = self.generate_markdown_report(scoped_data)
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(report)
            report_files.append(str(output_path))

        return report_files




WATCH_DEBOUNCE_SECONDS = 1.5
WATCH_POLL_SECONDS = 1.0


def utc_now_iso() -> str:
    return datetime.utcnow().replace(microsecond=0).isoformat() + "Z"


def safe_json(data: Any) -> bytes:
    return json.dumps(data, ensure_ascii=True, indent=2).encode("utf-8")


class DashboardState:
    """Shared state for the dashboard server, background builder, and watcher."""

    def __init__(
        self,
        base_path: Path,
        docs_path: Path,
        language_file: Path,
        include_modules: bool,
        refresh_seconds: int,
        quiet: bool = False,
    ):
        self.base_path = base_path
        self.docs_path = docs_path
        self.language_file = language_file
        self.include_modules = include_modules
        self.refresh_seconds = refresh_seconds
        self.quiet = quiet
        self.lock = threading.RLock()
        self.snapshot: Optional[Dict[str, Any]] = None
        self.snapshot_json: Optional[bytes] = None
        self.is_building = False
        self.last_build_started_at: Optional[str] = None
        self.last_build_finished_at: Optional[str] = None
        self.last_build_duration_ms: Optional[int] = None
        self.last_success_at: Optional[str] = None
        self.last_error: Optional[str] = None
        self.last_error_at: Optional[str] = None
        self.last_trigger_reason: str = "startup"
        self.build_count = 0
        self.watched_scope = "Lilia only"
        self.pending_rebuild_at: Optional[float] = None
        self.pending_reason: Optional[str] = None
        self._stop_event = threading.Event()
        self._wake_event = threading.Event()
        self._watch_roots = self._build_watch_roots()
        self._watch_files: Dict[str, float] = {}

    def _log(self, message: str):
        if not self.quiet:
            print(message)

    def _build_watch_roots(self) -> List[Path]:
        roots = [
            self.base_path,
            self.docs_path / "docs" / "developer",
            self.docs_path / "docs" / "definitions",
        ]
        if self.include_modules:
            for modules_path in DEFAULT_MODULES_PATHS:
                path_obj = Path(modules_path)
                if path_obj.exists():
                    roots.append(path_obj)
        return roots

    def iter_watch_files(self) -> Iterable[Path]:
        for lua_file in self.base_path.rglob("*.lua"):
            yield lua_file

        doc_roots = [
            self.docs_path / "docs" / "developer",
            self.docs_path / "docs" / "definitions",
        ]
        for root in doc_roots:
            if not root.exists():
                continue
            for md_file in root.rglob("*.md"):
                yield md_file

        if self.include_modules:
            for modules_path in DEFAULT_MODULES_PATHS:
                path_obj = Path(modules_path)
                if not path_obj.exists():
                    continue
                for lua_file in path_obj.rglob("*.lua"):
                    yield lua_file
                docs_dir = path_obj / "docs"
                if docs_dir.exists():
                    for md_file in docs_dir.rglob("*.md"):
                        yield md_file

    def prime_watch_index(self):
        index: Dict[str, float] = {}
        for file_path in self.iter_watch_files():
            try:
                index[str(file_path)] = file_path.stat().st_mtime
            except OSError:
                continue
        with self.lock:
            self._watch_files = index

    def schedule_rebuild(self, reason: str):
        with self.lock:
            self.pending_rebuild_at = time.time() + WATCH_DEBOUNCE_SECONDS
            self.pending_reason = reason
        self._wake_event.set()

    def build_once(self, reason: str):
        with self.lock:
            self.is_building = True
            self.last_build_started_at = utc_now_iso()
            self.last_trigger_reason = reason
            self.pending_rebuild_at = None
            self.pending_reason = None
        self._log(f"[dashboard] starting analysis build ({reason})")
        started = time.perf_counter()

        try:
            modules_paths = [str(path) for path in DEFAULT_MODULES_PATHS] if self.include_modules else []
            generator = FunctionComparisonReportGenerator(
                str(self.base_path),
                str(self.docs_path),
                str(self.language_file),
                modules_paths=modules_paths,
                generate_module_docs=self.include_modules,
            )
            data = generator.run_all_analyses()
            report_files = generator.save_reports(data)
            duration_ms = int((time.perf_counter() - started) * 1000)
            metadata = {
                "schema_version": 1,
                "generated_at": utc_now_iso(),
                "report_generated_at": data.generated_at,
                "build_duration_ms": duration_ms,
                "refresh_seconds": self.refresh_seconds,
                "watched_scope": self.watched_scope,
                "include_modules": self.include_modules,
                "status": "ready",
                "last_trigger_reason": reason,
                "report_files": report_files,
            }
            snapshot = generator.build_dashboard_snapshot(data, metadata=metadata)
            snapshot_json = safe_json(snapshot)

            with self.lock:
                self.snapshot = snapshot
                self.snapshot_json = snapshot_json
                self.last_build_duration_ms = duration_ms
                self.last_build_finished_at = utc_now_iso()
                self.last_success_at = self.last_build_finished_at
                self.last_error = None
                self.last_error_at = None
                self.is_building = False
                self.build_count += 1

            self._log(f"[dashboard] analysis build completed in {duration_ms} ms")
        except Exception:
            error_text = traceback.format_exc()
            with self.lock:
                self.last_build_finished_at = utc_now_iso()
                self.last_error = error_text
                self.last_error_at = self.last_build_finished_at
                self.is_building = False
            self._log("[dashboard] analysis build failed")
            if not self.quiet:
                print(error_text)

    def build_loop(self):
        while not self._stop_event.is_set():
            with self.lock:
                pending_at = self.pending_rebuild_at
                reason = self.pending_reason or "scheduled"
            if pending_at is None:
                self._wake_event.wait(0.5)
                self._wake_event.clear()
                continue

            wait_for = pending_at - time.time()
            if wait_for > 0:
                self._wake_event.wait(min(wait_for, 0.5))
                self._wake_event.clear()
                continue

            self.build_once(reason)

    def watch_loop(self):
        self.prime_watch_index()
        while not self._stop_event.is_set():
            changed: List[str] = []
            current_index: Dict[str, float] = {}
            for file_path in self.iter_watch_files():
                try:
                    current_index[str(file_path)] = file_path.stat().st_mtime
                except OSError:
                    continue

            with self.lock:
                previous = self._watch_files
                self._watch_files = current_index

            previous_keys = set(previous.keys())
            current_keys = set(current_index.keys())
            for path_str in sorted(current_keys - previous_keys):
                changed.append(f"created {path_str}")
            for path_str in sorted(previous_keys - current_keys):
                changed.append(f"deleted {path_str}")
            for path_str in sorted(current_keys & previous_keys):
                if current_index[path_str] != previous[path_str]:
                    changed.append(f"updated {path_str}")

            if changed:
                summary = f"watch change ({len(changed)} files)"
                self._log(f"[dashboard] {summary}")
                self.schedule_rebuild(summary)

            self._stop_event.wait(WATCH_POLL_SECONDS)

    def start_background_workers(self, watch: bool):
        self.schedule_rebuild("startup")
        self.builder_thread = threading.Thread(target=self.build_loop, name="dashboard-builder", daemon=True)
        self.builder_thread.start()
        self.watcher_thread = None
        if watch:
            self.watcher_thread = threading.Thread(target=self.watch_loop, name="dashboard-watcher", daemon=True)
            self.watcher_thread.start()

    def stop(self):
        self._stop_event.set()
        self._wake_event.set()

    def get_status_payload(self) -> Dict[str, Any]:
        with self.lock:
            stale = bool(self.last_error and self.snapshot is not None)
            return {
                "status": "updating" if self.is_building else ("error" if self.last_error and self.snapshot is None else "ready"),
                "has_snapshot": self.snapshot is not None,
                "showing_last_successful_snapshot": stale,
                "refresh_seconds": self.refresh_seconds,
                "watched_scope": self.watched_scope,
                "include_modules": self.include_modules,
                "build_count": self.build_count,
                "last_build_started_at": self.last_build_started_at,
                "last_build_finished_at": self.last_build_finished_at,
                "last_build_duration_ms": self.last_build_duration_ms,
                "last_success_at": self.last_success_at,
                "last_error_at": self.last_error_at,
                "last_error": self.last_error,
                "last_trigger_reason": self.last_trigger_reason,
            }

    def get_report_payload(self) -> Dict[str, Any]:
        with self.lock:
            if self.snapshot is None:
                return {
                    "metadata": {
                        "schema_version": 1,
                        "generated_at": utc_now_iso(),
                        "status": "booting",
                        "refresh_seconds": self.refresh_seconds,
                        "watched_scope": self.watched_scope,
                        "include_modules": self.include_modules,
                    },
                    "summary": {},
                    "sections": {},
                }
            return self.snapshot

    def get_report_bytes(self) -> bytes:
        with self.lock:
            if self.snapshot_json is not None:
                return self.snapshot_json
        return safe_json(self.get_report_payload())


def render_index_html(refresh_seconds: int) -> str:
    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Lilia Audit Dashboard</title>
  <style>
    :root {{
      --bg: #07111b;
      --bg-deep: #030812;
      --ink: #e8f0fb;
      --muted: #91a5bd;
      --panel: rgba(10, 20, 33, 0.88);
      --panel-strong: rgba(7, 15, 25, 0.98);
      --line: rgba(145, 165, 189, 0.18);
      --accent: #67e8f9;
      --accent-soft: rgba(103, 232, 249, 0.12);
      --warn: #f59e0b;
      --warn-soft: rgba(245, 158, 11, 0.14);
      --danger: #fb7185;
      --danger-soft: rgba(251, 113, 133, 0.14);
      --ok: #34d399;
      --ok-soft: rgba(52, 211, 153, 0.14);
      --shadow: 0 26px 80px rgba(0, 0, 0, 0.34);
      --radius: 22px;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      color: var(--ink);
      font-family: "IBM Plex Sans", "Segoe UI", sans-serif;
      background:
        radial-gradient(circle at top left, rgba(103, 232, 249, 0.12), transparent 26%),
        radial-gradient(circle at top right, rgba(59, 130, 246, 0.14), transparent 24%),
        radial-gradient(circle at 20% 80%, rgba(16, 185, 129, 0.08), transparent 22%),
        linear-gradient(180deg, #09111c 0%, var(--bg) 48%, var(--bg-deep) 100%);
    }}
    .shell {{
      max-width: 1380px;
      margin: 0 auto;
      padding: 28px 20px 80px;
    }}
    .hero {{
      background: linear-gradient(135deg, rgba(8, 18, 30, 0.92), rgba(9, 25, 40, 0.98));
      border: 1px solid rgba(103, 232, 249, 0.12);
      border-radius: calc(var(--radius) + 8px);
      box-shadow: var(--shadow);
      padding: 28px;
      position: relative;
      overflow: hidden;
    }}
    .hero::after {{
      content: "";
      position: absolute;
      inset: auto -80px -110px auto;
      width: 260px;
      height: 260px;
      background: radial-gradient(circle, rgba(103, 232, 249, 0.22), transparent 70%);
      pointer-events: none;
    }}
    h1, h2, h3 {{ margin: 0; font-weight: 700; }}
    h1 {{ font-size: clamp(2rem, 3vw, 3.4rem); letter-spacing: -0.04em; }}
    h2 {{ font-size: 1.2rem; margin-bottom: 12px; }}
    p {{ margin: 0; color: var(--muted); line-height: 1.6; }}
    .hero-top {{
      display: flex;
      gap: 18px;
      justify-content: space-between;
      align-items: flex-start;
      flex-wrap: wrap;
    }}
    .hero-copy {{
      max-width: 760px;
      display: grid;
      gap: 12px;
    }}
    .status-strip {{
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
      margin-top: 18px;
    }}
    .badge {{
      display: inline-flex;
      align-items: center;
      gap: 8px;
      border-radius: 999px;
      padding: 9px 14px;
      font-size: 0.92rem;
      border: 1px solid transparent;
      background: rgba(12, 24, 39, 0.94);
      color: var(--ink);
      backdrop-filter: blur(8px);
    }}
    .badge.ok {{ background: var(--ok-soft); color: var(--ok); border-color: rgba(22, 101, 52, 0.18); }}
    .badge.warn {{ background: var(--warn-soft); color: var(--warn); border-color: rgba(180, 83, 9, 0.18); }}
    .badge.danger {{ background: var(--danger-soft); color: var(--danger); border-color: rgba(180, 35, 24, 0.18); }}
    .grid {{
      display: grid;
      grid-template-columns: repeat(12, minmax(0, 1fr));
      gap: 18px;
      margin-top: 22px;
    }}
    .card {{
      grid-column: span 12;
      background: var(--panel);
      border: 1px solid rgba(103, 232, 249, 0.08);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      padding: 22px;
      backdrop-filter: blur(10px);
    }}
    .summary-grid {{
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 14px;
      margin-top: 22px;
    }}
    .summary-card {{
      background: rgba(14, 28, 45, 0.84);
      border: 1px solid rgba(103, 232, 249, 0.08);
      border-radius: 18px;
      padding: 16px;
      display: grid;
      gap: 8px;
    }}
    .summary-card .label {{
      color: var(--muted);
      font-size: 0.82rem;
      text-transform: uppercase;
      letter-spacing: 0.08em;
    }}
    .summary-card .value {{
      font-size: 1.9rem;
      font-weight: 700;
      letter-spacing: -0.04em;
    }}
    .summary-card .sub {{
      color: var(--muted);
      font-size: 0.92rem;
    }}
    .two-up {{
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 18px;
    }}
    .span-6 {{ grid-column: span 6; }}
    .span-4 {{ grid-column: span 4; }}
    .span-8 {{ grid-column: span 8; }}
    .toolbar {{
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
      align-items: center;
      margin-bottom: 16px;
    }}
    .toolbar input {{
      width: min(320px, 100%);
      border-radius: 12px;
      border: 1px solid var(--line);
      padding: 11px 13px;
      font: inherit;
      background: rgba(8, 18, 30, 0.92);
      color: var(--ink);
    }}
    .table-wrap {{
      overflow: auto;
      border: 1px solid var(--line);
      border-radius: 16px;
      background: var(--panel-strong);
    }}
    table {{
      width: 100%;
      border-collapse: collapse;
      min-width: 680px;
    }}
    th, td {{
      padding: 12px 14px;
      border-bottom: 1px solid var(--line);
      text-align: left;
      vertical-align: top;
      font-size: 0.95rem;
    }}
    th {{
      color: var(--muted);
      font-size: 0.82rem;
      text-transform: uppercase;
      letter-spacing: 0.08em;
      background: rgba(9, 18, 30, 0.96);
      position: sticky;
      top: 0;
      cursor: pointer;
    }}
    tr:last-child td {{ border-bottom: none; }}
    code {{
      font-family: "IBM Plex Mono", Consolas, monospace;
      background: rgba(103, 232, 249, 0.10);
      padding: 2px 6px;
      border-radius: 8px;
      font-size: 0.9em;
    }}
    .section-meta {{
      margin-top: 8px;
      margin-bottom: 18px;
      color: var(--muted);
      font-size: 0.95rem;
    }}
    details {{
      border: 1px solid var(--line);
      border-radius: 16px;
      background: rgba(10, 22, 36, 0.72);
      padding: 0 16px;
    }}
    details + details {{ margin-top: 12px; }}
    summary {{
      cursor: pointer;
      list-style: none;
      padding: 16px 0;
      font-weight: 600;
    }}
    summary::-webkit-details-marker {{ display: none; }}
    .mono-list {{
      display: grid;
      gap: 8px;
      padding-bottom: 16px;
    }}
    .mono-list div {{
      padding: 10px 12px;
      border-radius: 12px;
      background: rgba(8, 18, 30, 0.82);
      border: 1px solid rgba(103, 232, 249, 0.08);
      font-family: "IBM Plex Mono", Consolas, monospace;
      font-size: 0.9rem;
      word-break: break-word;
    }}
    .banner {{
      margin-top: 18px;
      padding: 14px 16px;
      border-radius: 16px;
      border: 1px solid rgba(180, 35, 24, 0.18);
      background: var(--danger-soft);
      color: var(--danger);
      display: none;
      white-space: pre-wrap;
    }}
    .muted {{ color: var(--muted); }}
    a {{ color: var(--accent); }}
    @media (max-width: 1040px) {{
      .span-6, .span-4, .span-8 {{ grid-column: span 12; }}
      .two-up {{ grid-template-columns: 1fr; }}
    }}
    @media (max-width: 720px) {{
      .shell {{ padding: 16px 14px 48px; }}
      .hero, .card {{ padding: 18px; border-radius: 18px; }}
      table {{ min-width: 560px; }}
      h1 {{ font-size: 2rem; }}
    }}
  </style>
</head>
<body>
  <div class="shell">
    <section class="hero">
      <div class="hero-top">
        <div class="hero-copy">
          <p class="muted">Live local audit view for Lilia documentation coverage and structural health.</p>
          <h1>Lilia Function Comparison Dashboard</h1>
          <p>This page refreshes itself every {refresh_seconds} seconds and keeps showing the last successful snapshot if a rebuild fails.</p>
        </div>
        <div class="status-strip">
          <span id="status-badge" class="badge">Starting up</span>
          <span id="updated-badge" class="badge">Waiting for first analysis</span>
        </div>
      </div>
      <div id="error-banner" class="banner"></div>
      <div id="summary-grid" class="summary-grid"></div>
    </section>

    <section class="grid">
      <article class="card span-8">
        <h2>Function Documentation Coverage</h2>
        <p class="section-meta">Which Lua files still contain undocumented functions.</p>
        <div class="toolbar">
          <input id="functions-filter" type="search" placeholder="Filter files or function names">
        </div>
        <div class="table-wrap">
          <table id="functions-table">
            <thead>
              <tr>
                <th data-sort-key="file">File</th>
                <th data-sort-key="coverage">Coverage</th>
                <th data-sort-key="missing">Missing</th>
                <th data-sort-key="documented">Documented</th>
                <th data-sort-key="total">Total</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>
      </article>

      <article class="card span-4">
        <h2>Build Status</h2>
        <p class="section-meta">Server health and live refresh details.</p>
        <div id="build-status" class="mono-list"></div>
      </article>

      <article class="card span-6">
        <h2>Hooks</h2>
        <p class="section-meta">Undocumented hooks and documented hooks that no longer appear in runtime code.</p>
        <div id="hooks-details"></div>
      </article>

      <article class="card span-6">
        <h2>Localization</h2>
        <p class="section-meta">Plain-language counts first, then the concrete issues behind them.</p>
        <div id="localization-details"></div>
      </article>

      <article class="card span-6">
        <h2>Net Messages</h2>
        <p class="section-meta">Definitions, usage drift, and same-side message flow problems.</p>
        <div id="net-details"></div>
      </article>

      <article class="card span-6">
        <h2>Privileges</h2>
        <p class="section-meta">Privilege IDs used in code versus what is actually registered in framework and module space.</p>
        <div id="privilege-details"></div>
      </article>

      <article class="card span-6">
        <h2>Duplicate Keys</h2>
        <p class="section-meta">Duplicate language-key findings powered by the cleanup tools, shown in dry-run form for safe review.</p>
        <div id="duplicate-details"></div>
      </article>

      <article class="card span-6">
        <h2>Derma and Placement</h2>
        <p class="section-meta">Unused panels and module files living outside the expected folders.</p>
        <div id="placement-details"></div>
      </article>

      <article class="card span-12">
        <h2>Raw Drill-Down</h2>
        <p class="section-meta">Expandable technical lists for deeper review without overwhelming casual readers.</p>
        <div id="drilldown"></div>
      </article>
    </section>
  </div>

  <script>
    const refreshMs = {refresh_seconds} * 1000;
    let reportData = null;
    let statusData = null;
    const tableSort = {{}};
    let openDetailKeys = new Set();

    function escapeHtml(value) {{
      return String(value ?? "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");
    }}

    function metricCard(label, value, sub) {{
      return `<div class="summary-card"><div class="label">${{escapeHtml(label)}}</div><div class="value">${{escapeHtml(value)}}</div><div class="sub">${{escapeHtml(sub || "")}}</div></div>`;
    }}

    function formatPercent(value) {{
      if (value === null || value === undefined || Number.isNaN(value)) return "N/A";
      return `${{Number(value).toFixed(1)}}%`;
    }}

    function setStatusBadge(status, showingLastSnapshot) {{
      const badge = document.getElementById("status-badge");
      const updated = document.getElementById("updated-badge");
      badge.className = "badge";
      updated.className = "badge";

      if (status === "updating") {{
        badge.classList.add("warn");
        badge.textContent = "Updating";
      }} else if (status === "ready") {{
        badge.classList.add("ok");
        badge.textContent = showingLastSnapshot ? "Ready with stale snapshot" : "Ready";
      }} else {{
        badge.classList.add("danger");
        badge.textContent = "Waiting for first successful analysis";
      }}

      if (statusData?.last_success_at) {{
        updated.textContent = `Last updated ${{statusData.last_success_at}}`;
        updated.classList.add("ok");
      }} else {{
        updated.textContent = "No successful build yet";
      }}
    }}

    function renderSummary() {{
      const summary = reportData?.summary || {{}};
      const grid = document.getElementById("summary-grid");
      grid.innerHTML = [
        metricCard("Function Coverage", formatPercent(summary.functions?.coverage_percent), `${{summary.functions?.documented ?? 0}} documented of ${{summary.functions?.total ?? 0}}; ${{summary.functions?.unused_lilia ?? 0}} unused`),
        metricCard("Missing Hooks", summary.hooks?.missing ?? 0, `${{summary.hooks?.unused ?? 0}} documented but unused`),
        metricCard("Localization Issues", (summary.localization?.undefined_calls ?? 0) + (summary.localization?.argument_mismatches ?? 0), `${{summary.localization?.undefined_calls ?? 0}} undefined calls, ${{summary.localization?.argument_mismatches ?? 0}} mismatches`),
        metricCard("Net Message Risk", (summary.net_messages?.used_but_undefined ?? 0) + (summary.net_messages?.direction_issues ?? 0), `${{summary.net_messages?.used_but_undefined ?? 0}} undefined, ${{summary.net_messages?.direction_issues ?? 0}} flow issues`),
        metricCard("Privilege Gaps", summary.privileges?.framework_missing ?? 0, `${{summary.privileges?.modules_with_missing_registrations ?? 0}} modules with missing privilege registrations`),
        metricCard("Duplicate Keys", summary.duplicates?.duplicate_entries ?? 0, `${{summary.duplicates?.language_files_with_duplicates ?? 0}} language files with duplicates`),
        metricCard("Derma Drift", summary.derma?.unused ?? 0, `${{summary.derma?.outside_folder ?? 0}} module panels outside folder`),
        metricCard("Placement Issues", summary.file_placement?.issues ?? 0, `${{summary.config?.undefined_get_calls ?? 0}} undefined config lookups`),
      ].join("");
    }}

    function renderStatusPanel() {{
      const panel = document.getElementById("build-status");
      if (!statusData) {{
        panel.innerHTML = "<div>Waiting for status...</div>";
        return;
      }}
      const lines = [
        `Watched scope: ${{statusData.watched_scope || "unknown"}}`,
        `Refresh interval: ${{statusData.refresh_seconds || "?"}} seconds`,
        `Build count: ${{statusData.build_count || 0}}`,
        `Last trigger: ${{statusData.last_trigger_reason || "startup"}}`,
        `Last build started: ${{statusData.last_build_started_at || "n/a"}}`,
        `Last build finished: ${{statusData.last_build_finished_at || "n/a"}}`,
        `Last build duration: ${{statusData.last_build_duration_ms ?? "n/a"}} ms`,
      ];
      panel.innerHTML = lines.map(line => `<div>${{escapeHtml(line)}}</div>`).join("");
    }}

    function renderFunctionsTable() {{
      const tbody = document.querySelector("#functions-table tbody");
      const files = [...(reportData?.sections?.functions?.files || [])];
      const query = document.getElementById("functions-filter").value.trim().toLowerCase();
      const sortState = tableSort.functions || {{ key: "missing", dir: "desc" }};

      const filtered = files.filter(entry => {{
        if (!query) return true;
        const haystack = [
          entry.file,
          ...(entry.missing_functions || []),
        ].join(" ").toLowerCase();
        return haystack.includes(query);
      }});

      filtered.sort((a, b) => {{
        const av = sortValue(a, sortState.key);
        const bv = sortValue(b, sortState.key);
        if (av < bv) return sortState.dir === "asc" ? -1 : 1;
        if (av > bv) return sortState.dir === "asc" ? 1 : -1;
        return 0;
      }});

      tbody.innerHTML = filtered.map(entry => {{
        const coverage = entry.total_functions ? ((entry.documented_functions / entry.total_functions) * 100) : 0;
        return `<tr>
          <td><code>${{escapeHtml(entry.file)}}</code></td>
          <td>${{formatPercent(coverage)}}</td>
          <td>${{entry.missing_functions_count ?? 0}}</td>
          <td>${{entry.documented_functions ?? 0}}</td>
          <td>${{entry.total_functions ?? 0}}</td>
        </tr>`;
      }}).join("");
    }}

    function sortValue(entry, key) {{
      if (key === "file") return String(entry.file || "");
      if (key === "coverage") return entry.total_functions ? (entry.documented_functions / entry.total_functions) : 0;
      if (key === "missing") return entry.missing_functions_count || 0;
      if (key === "documented") return entry.documented_functions || 0;
      if (key === "total") return entry.total_functions || 0;
      return "";
    }}

    function detailsBlock(title, items, formatter, keyOverride) {{
      const safeItems = items || [];
      const count = safeItems.length;
      const detailKey = keyOverride || title;
      const inner = count
        ? `<div class="mono-list">${{safeItems.map(item => `<div>${{formatter(item)}}</div>`).join("")}}</div>`
        : `<p class="muted">No items in this section.</p>`;
      return `<details data-details-key="${{escapeHtml(detailKey)}}"><summary>${{escapeHtml(title)}} (${{count}})</summary>${{inner}}</details>`;
    }}

    function captureOpenDetails() {{
      openDetailKeys = new Set(
        Array.from(document.querySelectorAll("details[data-details-key][open]"))
          .map(node => node.getAttribute("data-details-key"))
          .filter(Boolean)
      );
    }}

    function restoreOpenDetails() {{
      document.querySelectorAll("details[data-details-key]").forEach(node => {{
        const key = node.getAttribute("data-details-key");
        if (key && openDetailKeys.has(key)) {{
          node.open = true;
        }}
      }});
    }}

    function renderHooks() {{
      const hooks = reportData?.sections?.hooks || {{}};
      const target = document.getElementById("hooks-details");
      target.innerHTML = [
        detailsBlock("Undocumented hooks", hooks.missing, item => `<code>${{escapeHtml(item)}}</code>`),
        detailsBlock("Documented but unused hooks", hooks.unused, item => `<code>${{escapeHtml(item)}}</code>`),
      ].join("");
    }}

    function renderLocalization() {{
      const loc = reportData?.sections?.localization || {{}};
      const overview = loc.overview || {{}};
      const target = document.getElementById("localization-details");
      const summaryLine = `
        <div class="mono-list">
          <div>Undefined calls: ${{overview.undefined_count ?? (overview.undefined_rows?.length || 0)}}</div>
          <div>@token patterns: ${{overview.at_pattern_count ?? (overview.at_pattern_rows?.length || 0)}}</div>
          <div>Argument mismatches: ${{loc.argument_mismatches?.length || 0}}</div>
          <div>Module key conflicts: ${{Object.keys(loc.module_conflicts || {{}}).length}}</div>
        </div>`;
      target.innerHTML = summaryLine + [
        detailsBlock("Undefined localization rows", overview.undefined_rows, item => `<code>${{escapeHtml(item.file || "unknown")}}</code> line ${{escapeHtml(item.line || "?")}}: ${{escapeHtml(item.key || item.raw || JSON.stringify(item))}}`),
        detailsBlock("Argument mismatches", loc.argument_mismatches, item => `<code>${{escapeHtml(item.file || "unknown")}}</code> line ${{escapeHtml(item.line || "?")}}: expected ${{escapeHtml(item.expected_args ?? "?")}}, got ${{escapeHtml(item.actual_args ?? "?")}} for ${{escapeHtml(item.key || "?")}}`),
      ].join("");
    }}

    function renderNet() {{
      const net = reportData?.sections?.net_messages || {{}};
      const target = document.getElementById("net-details");
      target.innerHTML = [
        detailsBlock("Used but undefined messages", net.used_but_undefined, item => `<code>${{escapeHtml(item)}}</code>`),
        detailsBlock("Defined but unused messages", net.unused_defined, item => `<code>${{escapeHtml(item)}}</code>`),
        detailsBlock("Direction issues", net.direction_issues, item => `<code>${{escapeHtml(item.message || "?")}}</code>: ${{escapeHtml(item.reason || "")}}`),
      ].join("");
    }}

    function renderPrivileges() {{
      const privileges = reportData?.sections?.privileges || {{}};
      const framework = privileges.framework || {{}};
      const counts = framework.counts || {{}};
      const modules = privileges.modules || [];
      const target = document.getElementById("privilege-details");
      const summaryLine = `
        <div class="mono-list">
          <div>Framework privileges used in code: ${{counts.used_in_code ?? 0}}</div>
          <div>Framework registered privileges: ${{counts.registered ?? 0}}</div>
          <div>Framework missing registrations: ${{counts.used_but_not_registered ?? 0}}</div>
          <div>Modules scanned: ${{privileges.counts?.modules_scanned ?? modules.length}}</div>
        </div>`;
      target.innerHTML = summaryLine + [
        detailsBlock("Framework used but not registered", framework.used_but_not_registered, item => `<code>${{escapeHtml(item.id || "?")}}</code>${{item.name ? `: ${{escapeHtml(item.name)}}` : ""}}`),
        detailsBlock("Framework registered but not used", framework.registered_but_not_used, item => `<code>${{escapeHtml(item.id || "?")}}</code>${{item.name ? `: ${{escapeHtml(item.name)}}` : ""}}`),
        detailsBlock("Modules with missing privilege registrations", modules.filter(item => (item.counts?.missing_registrations || 0) > 0), item => `<code>${{escapeHtml(item.name || "?")}}</code>: ${{item.counts?.missing_registrations || 0}} missing registrations`),
      ].join("");
    }}

    function renderDuplicates() {{
      const duplicates = reportData?.sections?.duplicates || {{}};
      const language = duplicates.language_duplicates || {{}};
      const generic = duplicates.generic_duplicates || {{}};
      const target = document.getElementById("duplicate-details");
      const summaryLine = `
        <div class="mono-list">
          <div>Language duplicate entries: ${{language.total_duplicates ?? 0}}</div>
          <div>Language files with duplicates: ${{language.files_with_duplicates ?? 0}}</div>
          <div>Generic duplicate candidates: ${{generic.total_duplicates ?? 0}}</div>
          <div>Mode: dry-run audit only</div>
        </div>`;
      target.innerHTML = summaryLine + [
        detailsBlock("Language duplicate files", language.files, item => `<code>${{escapeHtml(item.file || "?")}}</code>: ${{item.duplicate_count || 0}} duplicates`),
        detailsBlock("Generic duplicate files", generic.files, item => `<code>${{escapeHtml(item.file || "?")}}</code>: ${{item.duplicate_count || 0}} duplicate keyed entries`),
      ].join("");
    }}

    function renderPlacement() {{
      const derma = reportData?.sections?.derma || {{}};
      const placement = reportData?.sections?.file_placement || {{}};
      const target = document.getElementById("placement-details");
      target.innerHTML = [
        detailsBlock("Unused Derma panels", derma.unused, item => `<code>${{escapeHtml(item.panel || "?")}}</code> in <code>${{escapeHtml(item.file || "unknown")}}</code>`),
        detailsBlock("Panels outside module derma folder", derma.outside_folder, item => `<code>${{escapeHtml(item.panel || "?")}}</code>: ${{escapeHtml(item.reason || "")}}`),
        detailsBlock("Module file placement issues", placement.issues, item => `<code>${{escapeHtml(item.file || "unknown")}}</code>: ${{escapeHtml(item.reason || "")}}`),
      ].join("");
    }}

    function renderDrilldown() {{
      const sections = reportData?.sections || {{}};
      const drilldown = document.getElementById("drilldown");
      const missingLibraries = sections.functions?.missing_library_functions || [];
      const missingMeta = sections.functions?.missing_meta_functions || [];
      const unusedLilia = sections.functions?.unused_lilia_functions || [];
      const configIssues = sections.config?.undefined_get_calls || [];
      const duplicateFiles = sections.duplicates?.language_duplicates?.files || [];
      const privilegeModules = sections.privileges?.modules || [];

      drilldown.innerHTML = [
        detailsBlock("Missing library functions", missingLibraries, item => `<code>${{escapeHtml(item.name || "?")}}</code>`),
        detailsBlock("Missing meta functions", missingMeta, item => `<code>${{escapeHtml(item.name || "?")}}</code>`),
        detailsBlock("Unused Lilia functions", unusedLilia, item => `<code>${{escapeHtml(item)}}</code>`),
        detailsBlock("Undefined config get calls", configIssues, item => `<code>${{escapeHtml(item.file || "unknown")}}</code> line ${{escapeHtml(item.line || "?")}}: ${{escapeHtml(item.key || JSON.stringify(item))}}`),
        detailsBlock("Duplicate language entries", duplicateFiles.flatMap(item => (item.duplicates || []).map(dup => ({{
          file: item.file,
          language: item.language,
          key: dup.key,
          line: dup.line,
          first_line: dup.first_line,
        }}))), item => `<code>${{escapeHtml(item.file || "?")}}</code> [${{escapeHtml(item.language || "?")}}] key <code>${{escapeHtml(item.key || "?")}}</code> duplicates line ${{escapeHtml(item.first_line || "?")}} at line ${{escapeHtml(item.line || "?")}}`),
        detailsBlock("Module privilege gaps", privilegeModules.flatMap(item => (item.used_but_not_registered || []).map(priv => ({{
          module: item.name,
          id: priv.id,
          name: priv.name,
        }}))), item => `<code>${{escapeHtml(item.module || "?")}}</code>: <code>${{escapeHtml(item.id || "?")}}</code>${{item.name ? ` (${{escapeHtml(item.name)}})` : ""}}`),
      ].join("");
    }}

    function renderErrorBanner() {{
      const banner = document.getElementById("error-banner");
      if (statusData?.last_error) {{
        const intro = statusData.showing_last_successful_snapshot
          ? "Analysis failed, showing the last successful snapshot.\\n\\n"
          : "Analysis failed before a successful snapshot was available.\\n\\n";
        banner.style.display = "block";
        banner.textContent = intro + statusData.last_error;
      }} else {{
        banner.style.display = "none";
        banner.textContent = "";
      }}
    }}

    function renderAll() {{
      captureOpenDetails();
      setStatusBadge(statusData?.status, statusData?.showing_last_successful_snapshot);
      renderErrorBanner();
      renderSummary();
      renderStatusPanel();
      renderFunctionsTable();
      renderHooks();
      renderLocalization();
      renderNet();
      renderPrivileges();
      renderDuplicates();
      renderPlacement();
      renderDrilldown();
      restoreOpenDetails();
    }}

    async function refreshData() {{
      try {{
        const [reportResponse, statusResponse] = await Promise.all([
          fetch("/api/report", {{ cache: "no-store" }}),
          fetch("/api/status", {{ cache: "no-store" }}),
        ]);
        reportData = await reportResponse.json();
        statusData = await statusResponse.json();
        renderAll();
      }} catch (error) {{
        console.error("Failed to refresh dashboard data", error);
      }}
    }}

    document.getElementById("functions-filter").addEventListener("input", renderFunctionsTable);
    document.querySelectorAll("#functions-table th").forEach(th => {{
      th.addEventListener("click", () => {{
        const key = th.dataset.sortKey;
        const current = tableSort.functions || {{ key: "missing", dir: "desc" }};
        const dir = current.key === key && current.dir === "desc" ? "asc" : "desc";
        tableSort.functions = {{ key, dir }};
        renderFunctionsTable();
      }});
    }});

    refreshData();
    setInterval(refreshData, refreshMs);
  </script>
</body>
</html>"""


class DashboardHandler(BaseHTTPRequestHandler):
    server_version = "LiliaDashboard/1.0"

    def _send_bytes(self, status_code: int, content_type: str, payload: bytes):
        self.send_response(status_code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(payload)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(payload)

    def do_GET(self):
        parsed = urlparse(self.path)
        state: DashboardState = self.server.dashboard_state  

        if parsed.path == "/":
            html = render_index_html(state.refresh_seconds).encode("utf-8")
            self._send_bytes(200, "text/html; charset=utf-8", html)
            return
        if parsed.path == "/api/report":
            self._send_bytes(200, "application/json; charset=utf-8", state.get_report_bytes())
            return
        if parsed.path == "/api/status":
            self._send_bytes(200, "application/json; charset=utf-8", safe_json(state.get_status_payload()))
            return

        self._send_bytes(404, "application/json; charset=utf-8", safe_json({"error": "not found"}))

    def log_message(self, format: str, *args):
        state: DashboardState = self.server.dashboard_state  
        if not state.quiet:
            super().log_message(format, *args)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Serve a live local dashboard for the function comparison report.")
    parser.add_argument("--host", default="127.0.0.1", help="Host interface to bind the local server to.")
    parser.add_argument("--port", type=int, default=8765, help="Port for the local dashboard server.")
    parser.add_argument("--base-path", default=str(DEFAULT_GAMEMODE_ROOT), help="Path to the Lilia gamemode directory.")
    parser.add_argument("--docs-path", default=str(DEFAULT_DOCS_ROOT), help="Path to the documentation root.")
    parser.add_argument("--language-file", default=str(DEFAULT_LANGUAGE_FILE), help="Path to the main language file.")
    parser.add_argument("--refresh-seconds", type=int, default=10, help="Browser polling interval in seconds.")
    parser.add_argument("--watch", dest="watch", action="store_true", default=True, help="Enable background watching and automatic rebuilds.")
    parser.add_argument("--no-watch", dest="watch", action="store_false", help="Disable background file watching.")
    parser.add_argument("--include-modules", action="store_true", help="Include external modules in analysis and watch scope.")
    parser.add_argument("--open-browser", action="store_true", help="Open the dashboard in the default web browser after startup.")
    parser.add_argument("--quiet", "-q", action="store_true", help="Reduce console logging.")
    return parser.parse_args()


def main():
    args = parse_args()
    base_path = Path(args.base_path)
    docs_path = Path(args.docs_path)
    language_file = Path(args.language_file)

    state = DashboardState(
        base_path=base_path,
        docs_path=docs_path,
        language_file=language_file,
        include_modules=args.include_modules,
        refresh_seconds=args.refresh_seconds,
        quiet=args.quiet,
    )

    state.start_background_workers(watch=args.watch)
    server = ThreadingHTTPServer((args.host, args.port), DashboardHandler)
    server.dashboard_state = state  

    url = f"http://{args.host}:{args.port}/"
    if not args.quiet:
        print(f"[dashboard] serving {url}")
        print(f"[dashboard] watch mode: {'on' if args.watch else 'off'}")
        print(f"[dashboard] module scanning: {'on' if args.include_modules else 'off'}")

    if args.open_browser:
        webbrowser.open(url)

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        state.stop()
        server.server_close()


if __name__ == "__main__":
    main()

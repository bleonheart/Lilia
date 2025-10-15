#!/usr/bin/env python3
"""
Script to find case inconsistencies in lia.*.* usage patterns and meta method usage in Lua files.
"""

import os
import re
from collections import defaultdict
import glob

def find_lua_files(base_paths):
    """Find all .lua files in the given base paths."""
    lua_files = []
    for base_path in base_paths:
        if os.path.isfile(base_path) and base_path.endswith('.lua'):
            lua_files.append(base_path)
        elif os.path.isdir(base_path):
            # Use glob to find all .lua files recursively
            pattern = os.path.join(base_path, '**', '*.lua')
            lua_files.extend(glob.glob(pattern, recursive=True))

    return lua_files

def extract_meta_methods(meta_folder):
    """Extract all method definitions from meta files."""
    meta_methods = {}
    
    meta_files = [
        'player.lua',
        'character.lua', 
        'entity.lua',
        'inventory.lua',
        'item.lua',
        'panel.lua',
        'tool.lua',
        'vector.lua'
    ]
    
    for meta_file in meta_files:
        file_path = os.path.join(meta_folder, meta_file)
        if os.path.exists(file_path):
            try:
                with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                
                # Find function definitions in meta files
                # Pattern matches: function metaTable:methodName(...) or function metaTable.methodName(...)
                patterns = [
                    r'function\s+(\w+)\s*:\s*(\w+)\s*\(',
                    r'function\s+(\w+)\.(\w+)\s*\('
                ]
                
                for pattern in patterns:
                    matches = re.findall(pattern, content)
                    for match in matches:
                        table_name, method_name = match
                        if table_name not in meta_methods:
                            meta_methods[table_name] = []
                        if method_name not in meta_methods[table_name]:
                            meta_methods[table_name].append(method_name)
                            
            except Exception as e:
                print(f"Error reading meta file {file_path}: {e}")
    
    return meta_methods

def extract_lia_patterns(file_path):
    """Extract all lia.*.* patterns from a Lua file."""
    patterns = []

    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        # Find all lia.*.* patterns using regex
        # This matches lia followed by dot, identifier, dot, identifier
        # We use word boundaries to avoid partial matches
        pattern = r'lia\.([a-zA-Z_][a-zA-Z0-9_]*)\.([a-zA-Z_][a-zA-Z0-9_]*)'

        matches = re.findall(pattern, content)
        for match in matches:
            full_pattern = f"lia.{match[0]}.{match[1]}"
            patterns.append(full_pattern)

    except Exception as e:
        print(f"Error reading {file_path}: {e}")

    return patterns

def extract_meta_method_usage(file_path, meta_methods):
    """Extract all meta method usage from a Lua file."""
    usages = []
    
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # Search for method calls on objects: object:methodName(...) or object.methodName(...)
        for table_name, methods in meta_methods.items():
            for method_name in methods:
                # Pattern matches: object:methodName(...) or object.methodName(...)
                patterns = [
                    rf'(\w+)\s*:\s*{re.escape(method_name)}\s*\(',
                    rf'(\w+)\s*\.\s*{re.escape(method_name)}\s*\('
                ]
                
                for pattern in patterns:
                    matches = re.findall(pattern, content)
                    for match in matches:
                        usages.append((table_name, method_name, match))
                        
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
    
    return usages

def analyze_case_inconsistencies(lua_files, meta_methods, meta_folder):
    """Analyze patterns and find case inconsistencies."""
    # Dictionary to store patterns by their normalized (lowercase) version
    pattern_groups = defaultdict(list)
    method_groups = defaultdict(list)

    # Track which files contain each pattern
    file_locations = defaultdict(list)
    method_locations = defaultdict(list)

    # First, analyze lia patterns
    for file_path in lua_files:
        patterns = extract_lia_patterns(file_path)

        for pattern in patterns:
            # Create normalized version (everything after lia. in lowercase)
            parts = pattern.split('.')
            if len(parts) >= 3:
                normalized = f"lia.{parts[1].lower()}.{parts[2].lower()}"

                pattern_groups[normalized].append(pattern)
                if file_path not in file_locations[pattern]:
                    file_locations[pattern].append(file_path)

    # Then, analyze meta method usages
    for file_path in lua_files:
        if file_path.startswith(meta_folder):
            continue  # Skip meta files themselves to avoid false positives
            
        method_usages = extract_meta_method_usage(file_path, meta_methods)
        
        for table_name, method_name, object_name in method_usages:
            # Create a normalized method identifier
            normalized_method = f"{table_name}.{method_name.lower()}"
            
            method_groups[normalized_method].append((table_name, method_name, object_name))
            location_key = f"{table_name}.{method_name}"
            if file_path not in method_locations[location_key]:
                method_locations[location_key].append(file_path)

    # Find inconsistencies for lia patterns
    inconsistencies = []

    for normalized, patterns in pattern_groups.items():
        if len(patterns) > 1:
            # Check if there are different casings
            unique_patterns = list(set(patterns))
            if len(unique_patterns) > 1:
                inconsistencies.append({
                    'type': 'lia_pattern',
                    'normalized': normalized,
                    'patterns': unique_patterns,
                    'files': []
                })

                # Collect all files that use these patterns
                for pattern in unique_patterns:
                    inconsistencies[-1]['files'].extend(file_locations[pattern])

    # Find inconsistencies for meta methods
    # Group by table and method name to find case inconsistencies
    for normalized_method, usages in method_groups.items():
        if len(usages) > 1:
            # Find if there are different casings of the same method
            method_casings = {}
            for table_name, method_name, object_name in usages:
                key = f"{table_name}.{method_name}"
                if key not in method_casings:
                    method_casings[key] = []
                method_casings[key].append((table_name, method_name, object_name))
            
            # Check for actual case inconsistencies
            unique_methods = list(method_casings.keys())
            if len(unique_methods) > 1:
                # Check if any of these are actually the same method with different casing
                for i, method1 in enumerate(unique_methods):
                    for method2 in unique_methods[i+1:]:
                        # Compare method names case-insensitively but check if casing differs
                        if method1.lower() == method2.lower() and method1 != method2:
                            # Found a case inconsistency!
                            all_usages = []
                            all_usages.extend(method_casings[method1])
                            all_usages.extend(method_casings[method2])
                            
                            inconsistencies.append({
                                'type': 'meta_method',
                                'normalized': normalized_method,
                                'usages': all_usages,
                                'files': []
                            })
                            
                            # Collect all files that use these methods
                            for usage in all_usages:
                                table_name, method_name, object_name = usage
                                location_key = f"{table_name}.{method_name}"
                                inconsistencies[-1]['files'].extend(method_locations[location_key])
                            break

    return inconsistencies

def generate_report(inconsistencies, output_file='lia_case_inconsistencies_report.md'):
    """Generate a markdown report of the findings."""
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# Lia Case Inconsistency Report\n\n")
        f.write(f"Found {len(inconsistencies)} case inconsistencies in lia.*.* usage patterns and meta method usage.\n\n")

        if not inconsistencies:
            f.write("✅ No case inconsistencies found!\n")
            return

        # Group by type for better organization
        lia_inconsistencies = [inc for inc in inconsistencies if inc['type'] == 'lia_pattern']
        meta_inconsistencies = [inc for inc in inconsistencies if inc['type'] == 'meta_method']

        if lia_inconsistencies:
            f.write(f"## Lia Pattern Inconsistencies ({len(lia_inconsistencies)})\n\n")
            for i, inconsistency in enumerate(lia_inconsistencies, 1):
                f.write(f"### {i}. `{inconsistency['normalized']}`\n\n")
                f.write("**Different casings found:**\n")
                for pattern in inconsistency['patterns']:
                    f.write(f"- `{pattern}`\n")
                f.write("\n")

                # List files (deduplicated)
                files = list(set(inconsistency['files']))
                if files:
                    f.write("**Files containing these patterns:**\n")
                    for file_path in sorted(files):
                        f.write(f"- `{file_path}`\n")
                f.write("\n")
                f.write("---\n\n")

        if meta_inconsistencies:
            f.write(f"## Meta Method Inconsistencies ({len(meta_inconsistencies)})\n\n")
            for i, inconsistency in enumerate(meta_inconsistencies, 1):
                f.write(f"### {i}. `{inconsistency['normalized']}`\n\n")
                f.write("**Different casings found:**\n")
                for usage in inconsistency['usages']:
                    table_name, method_name, object_name = usage
                    f.write(f"- `{table_name}.{method_name}` (used on `{object_name}`)\n")
                f.write("\n")

                # List files (deduplicated)
                files = list(set(inconsistency['files']))
                if files:
                    f.write("**Files containing these method calls:**\n")
                    for file_path in sorted(files):
                        f.write(f"- `{file_path}`\n")
                f.write("\n")
                f.write("---\n\n")

def main():
    # Base paths to search in
    base_paths = [
        r'E:\GMOD\Server\garrysmod\gamemodes\Lilia',
        r'E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done',
        r'E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules'
    ]
    
    # Meta folder path
    meta_folder = r'E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta'

    print("Finding all Lua files...")
    lua_files = find_lua_files(base_paths)
    print(f"Found {len(lua_files)} Lua files")

    print("Extracting meta methods...")
    meta_methods = extract_meta_methods(meta_folder)
    print(f"Found methods in {len(meta_methods)} meta tables")
    
    # Print some meta method info for debugging
    for table_name, methods in list(meta_methods.items())[:3]:  # Show first 3 tables
        print(f"  {table_name}: {len(methods)} methods (e.g., {', '.join(methods[:3])})")

    print("Extracting patterns and method usages...")
    inconsistencies = analyze_case_inconsistencies(lua_files, meta_methods, meta_folder)

    print(f"Found {len(inconsistencies)} case inconsistencies")

    print("Generating report...")
    generate_report(inconsistencies)

    print("Report saved to: lia_case_inconsistencies_report.md")

    # Also print summary to console
    lia_inconsistencies = [inc for inc in inconsistencies if inc['type'] == 'lia_pattern']
    meta_inconsistencies = [inc for inc in inconsistencies if inc['type'] == 'meta_method']
    
    if inconsistencies:
        print(f"\nFound {len(lia_inconsistencies)} lia pattern inconsistencies and {len(meta_inconsistencies)} meta method inconsistencies")
        for inconsistency in lia_inconsistencies:
            print(f"  LIA: {inconsistency['normalized']}: {inconsistency['patterns']}")
        for inconsistency in meta_inconsistencies:
            print(f"  META: {inconsistency['normalized']}: {[usage[1] for usage in inconsistency['usages']]}")
    else:
        print("No case inconsistencies found!")

if __name__ == "__main__":
    main()

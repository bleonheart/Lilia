#!/usr/bin/env python3
"""
Script to find case inconsistencies in hook usage patterns in Lua files.
"""

import os
import re
from collections import defaultdict
import glob

def find_lua_files(base_paths):
    """Find all .lua files in the given base paths, excluding addons folders."""
    lua_files = []
    for base_path in base_paths:
        if os.path.isfile(base_path) and base_path.endswith('.lua'):
            lua_files.append(base_path)
        elif os.path.isdir(base_path):
            # Use glob to find all .lua files recursively
            pattern = os.path.join(base_path, '**', '*.lua')
            all_files = glob.glob(pattern, recursive=True)
            
            # Filter out files in addons folders and gmacreator.lua
            for file_path in all_files:
                # Check if the path contains 'addons' folder
                path_parts = file_path.split(os.sep)
                if 'addons' not in path_parts:
                    # Also ignore gmacreator.lua
                    if not file_path.endswith('gmacreator.lua'):
                        lua_files.append(file_path)

    return lua_files

def extract_hook_patterns(file_path):
    """Extract all hook patterns from a Lua file."""
    patterns = []
    
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # Define all hook patterns
        hook_patterns = [
            # GM:HOOK(args) - function GM:HookName(args)
            (r'function\s+GM\s*:\s*(\w+)\s*\(', 'GM', 'function'),
            
            # MODULE:HOOK(args) - function ModuleName:HookName(args)
            (r'function\s+(\w+)\s*:\s*(\w+)\s*\(', 'MODULE', 'function'),
            
            # SCHEMA:HOOK(args) - function SchemaName:HookName(args)
            (r'function\s+(\w+)\s*:\s*(\w+)\s*\(', 'SCHEMA', 'function'),
            
            # self:HOOK(args) - self:HookName(args)
            (r'self\s*:\s*(\w+)\s*\(', 'self', 'method'),
            
            # Method calls: MODULE:HookName(args) - not just function definitions
            (r'(\w+)\s*:\s*(\w+)\s*\(', 'MODULE', 'method_call'),
            
            # hook.add("HOOK", ...) - hook.Add("HookName", ...)
            (r'hook\.add\s*\(\s*["\'](\w+)["\']', 'hook.add', 'add'),
            
            # hook.Run("HOOK", ...) - hook.Run("HookName", ...)
            (r'hook\.run\s*\(\s*["\'](\w+)["\']', 'hook.run', 'run'),
            
            # hook.Call("HOOK", ...) - hook.Call("HookName", ...)
            (r'hook\.call\s*\(\s*["\'](\w+)["\']', 'hook.call', 'call'),
            
            # Also check for capitalized versions
            (r'hook\.Add\s*\(\s*["\'](\w+)["\']', 'hook.Add', 'add'),
            (r'hook\.Run\s*\(\s*["\'](\w+)["\']', 'hook.Run', 'run'),
            (r'hook\.Call\s*\(\s*["\'](\w+)["\']', 'hook.Call', 'call'),
        ]
        
        for pattern, context, hook_type in hook_patterns:
            matches = re.findall(pattern, content)  # Remove re.IGNORECASE to detect case differences
            for match in matches:
                if isinstance(match, tuple):
                    # For patterns with two groups (like MODULE:HookName)
                    if len(match) == 2:
                        module_name, hook_name = match
                        patterns.append({
                            'type': hook_type,
                            'context': context,
                            'hook_name': hook_name,
                            'module_name': module_name,
                            'full_pattern': f"{module_name}:{hook_name}"
                        })
                    else:
                        hook_name = match[0]
                        patterns.append({
                            'type': hook_type,
                            'context': context,
                            'hook_name': hook_name,
                            'module_name': None,
                            'full_pattern': f"{context}:{hook_name}"
                        })
                else:
                    # For patterns with one group
                    hook_name = match
                    patterns.append({
                        'type': hook_type,
                        'context': context,
                        'hook_name': hook_name,
                        'module_name': None,
                        'full_pattern': f"{context}:{hook_name}"
                    })
                    
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
    
    return patterns

def analyze_hook_inconsistencies(lua_files):
    """Analyze hook patterns and find case inconsistencies."""
    # Dictionary to store patterns by their normalized (lowercase) version
    hook_groups = defaultdict(list)
    
    # Track which files contain each pattern
    file_locations = defaultdict(list)
    
    # Panel-related patterns to ignore
    panel_patterns_to_ignore = [
        'init', 'setup', 'update', 'think', 'draw', 'paint', 'paintover',
        'setsize', 'setpos', 'add', 'remove', 'addspacer', 'addtab', 'additem',
        'setactivetab', 'setactive', 'setvalue', 'getvalue', 'setmax', 'seticon',
        'fadeout', 'getcategory', 'notify', 'populateitems', 'populateoptions',
        'setaction', 'painttextentry', 'getdata', 'setdata', 'setmodel', 'getmodel',
        'getskin', 'getowner', 'getname', 'getclass', 'kick', 'getplayer',
        'getdisplayedname', 'steamname', 'getammocount', 'drawhud', 'reload',
        'deploy', 'holster', 'getitemid', 'use', 'oncanbetransfered', 'onsave',
        'setanim', 'isempty', 'setnw2int', 'getnw2int', 'settyingdata',
        'getplayerradiofrequency', 'initializestorage', 'removeitem', 'onloaded',
        # Additional patterns to ignore
        'setconvar', 'setupmove', 'setskin', 'getsize', 'getentity'
    ]
    
    for file_path in lua_files:
        patterns = extract_hook_patterns(file_path)
        
        for pattern in patterns:
            # Skip panel-related patterns
            if pattern['hook_name'].lower() in panel_patterns_to_ignore:
                continue
                
            # Create normalized version (lowercase hook name)
            normalized_hook = pattern['hook_name'].lower()
            
            # Group by hook name and context type
            group_key = f"{pattern['context']}:{normalized_hook}"
            
            hook_groups[group_key].append(pattern)
            if file_path not in file_locations[pattern['hook_name']]:
                file_locations[pattern['hook_name']].append(file_path)
    
    # Find inconsistencies
    inconsistencies = []
    
    for group_key, patterns in hook_groups.items():
        if len(patterns) > 1:
            # Check if there are different casings
            unique_hook_names = list(set([p['hook_name'] for p in patterns]))
            if len(unique_hook_names) > 1:
                # Check if any are actually the same hook with different casing
                for i, hook1 in enumerate(unique_hook_names):
                    for hook2 in unique_hook_names[i+1:]:
                        if hook1.lower() == hook2.lower() and hook1 != hook2:
                            # Found a case inconsistency!
                            inconsistent_patterns = [p for p in patterns if p['hook_name'] in [hook1, hook2]]
                            
                            inconsistencies.append({
                                'group_key': group_key,
                                'hook_names': unique_hook_names,
                                'patterns': inconsistent_patterns,
                                'files': []
                            })
                            
                            # Collect all files that use these patterns
                            for pattern in inconsistent_patterns:
                                inconsistencies[-1]['files'].extend(file_locations[pattern['hook_name']])
                            break
    
    return inconsistencies

def generate_report(inconsistencies, output_file='hook_case_inconsistencies_report.md'):
    """Generate a markdown report of the findings."""
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# Hook Case Inconsistency Report\n\n")
        f.write(f"Found {len(inconsistencies)} case inconsistencies in hook usage patterns.\n\n")
        
        if not inconsistencies:
            f.write("✅ No case inconsistencies found!\n")
            return
        
        for i, inconsistency in enumerate(inconsistencies, 1):
            f.write(f"## {i}. `{inconsistency['group_key']}`\n\n")
            f.write("**Different casings found:**\n")
            for hook_name in inconsistency['hook_names']:
                f.write(f"- `{hook_name}`\n")
            f.write("\n")
            
            f.write("**Usage patterns:**\n")
            for pattern in inconsistency['patterns']:
                f.write(f"- `{pattern['full_pattern']}` ({pattern['type']})\n")
            f.write("\n")
            
            # List files (deduplicated)
            files = list(set(inconsistency['files']))
            if files:
                f.write("**Files containing these hooks:**\n")
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
    
    print("Finding all Lua files...")
    lua_files = find_lua_files(base_paths)
    print(f"Found {len(lua_files)} Lua files")
    
    print("Extracting hook patterns...")
    inconsistencies = analyze_hook_inconsistencies(lua_files)
    
    print(f"Found {len(inconsistencies)} case inconsistencies")
    
    print("Generating report...")
    generate_report(inconsistencies)
    
    print("Report saved to: hook_case_inconsistencies_report.md")
    
    # Also print summary to console
    if inconsistencies:
        print(f"\nFound {len(inconsistencies)} inconsistencies:")
        for inconsistency in inconsistencies:
            print(f"  {inconsistency['group_key']}: {inconsistency['hook_names']}")
    else:
        print("No case inconsistencies found!")

if __name__ == "__main__":
    main()

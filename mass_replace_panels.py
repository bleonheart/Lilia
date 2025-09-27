#!/usr/bin/env python3
"""
Mass replacement script to replace default GMod panels with Lia panels
"""

import os
import re
import glob

# Mapping of default GMod panels to Lia equivalents
PANEL_REPLACEMENTS = {
    'DPanel': 'liaBasePanel',
    'DListView': 'liaTable',
    'DPropertySheet': 'liaTabs',
    'DTextEntry': 'liaEntry',
    'DButton': 'liaButton',
    'DFrame': 'liaFrame',
    'DMenu': 'liaDermaMenu',
    'DScrollPanel': 'liaScrollPanel',
    'DSlider': 'liaSlideBox',
    'DComboBox': 'liaComboBox',
    'DCheckBox': 'liaCheckBox',
    'DLabel': 'liaText',
    'DImage': 'liaImage',
    'DNumberWang': 'liaNumberWang',
    'DColorMixer': 'liaColorMixer',
    'DAvaTarImage': 'liaAvatarImage',
    'DAvatarImage': 'liaAvatarImage',
    'DModelPanel': 'liaModelPanel',
    'DNumSlider': 'liaSlideBox',
    'DCheckBoxLabel': 'liaCheckBoxLabel',
    'DProgress': 'DProgressBar'
}

# Files to exclude from replacement
EXCLUDE_PATTERNS = [
    '*.pyc',
    '__pycache__',
    '.git',
    'node_modules',
    '*.min.js',
    '*.min.css',
    'documentation/',
    'content/',
]

def should_exclude_file(filepath):
    """Check if file should be excluded from replacement"""
    for pattern in EXCLUDE_PATTERNS:
        if pattern.endswith('/'):
            if pattern[:-1] in filepath:
                return True
        elif pattern in filepath:
            return True
    return False

def get_lua_files(directory):
    """Get all Lua files in directory recursively"""
    lua_files = []
    for root, dirs, files in os.walk(directory):
        # Skip excluded directories
        dirs[:] = [d for d in dirs if not should_exclude_file(os.path.join(root, d))]

        for file in files:
            if file.endswith('.lua'):
                filepath = os.path.join(root, file)
                if not should_exclude_file(filepath):
                    lua_files.append(filepath)
    return lua_files

def replace_panels_in_file(filepath):
    """Replace panels in a single file"""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        original_content = content
        replacements_made = 0

        # Replace panel names
        for old_panel, new_panel in PANEL_REPLACEMENTS.items():
            # Use word boundaries to avoid partial matches
            pattern = r'\b' + re.escape(old_panel) + r'\b'
            if re.search(pattern, content):
                content = re.sub(pattern, new_panel, content)
                replacements_made += len(re.findall(pattern, original_content))

        # Only write back if changes were made
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8', errors='ignore') as f:
                f.write(content)
            return replacements_made

        return 0

    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return 0

def main():
    """Main function"""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = script_dir

    print(f"Scanning for Lua files in: {project_root}")
    lua_files = get_lua_files(project_root)

    print(f"Found {len(lua_files)} Lua files")

    total_replacements = 0
    files_modified = 0

    for filepath in lua_files:
        replacements = replace_panels_in_file(filepath)
        if replacements > 0:
            total_replacements += replacements
            files_modified += 1
            print(f"Modified {filepath}: {replacements} replacements")

    print("\n=== Summary ===")
    print(f"Files modified: {files_modified}")
    print(f"Total replacements: {total_replacements}")
    print(f"Files scanned: {len(lua_files)}")

if __name__ == '__main__':
    main()

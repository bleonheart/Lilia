import os
import re
import subprocess
import sys

# Path to the fonts.lua file
FONTS_FILE = 'gamemode/core/libraries/fonts.lua'

# Directories to exclude from search
EXCLUDE_DIRS = [
    'documentation',
    'content/resource/fonts',
    '.git',
    '__pycache__',
    'node_modules'
]

# Files to exclude from search (documentation/test files)
EXCLUDE_FILES = [
    'test_report.md',
    'string_analysis_report.md'
]

def extract_font_names():
    """Extract font names from fonts.lua"""
    font_names = []
    with open(FONTS_FILE, 'r') as f:
        content = f.read()

    # Regex to match lia.font.register("FontName", {...})
    pattern = r'lia\.font\.register\(\s*"([^"]+)"'
    matches = re.findall(pattern, content)
    font_names = list(set(matches))  # Remove duplicates

    return font_names

def search_font_usage(font_name):
    """Search for usage of the font name in the codebase"""
    found_files = []
    fonts_file = os.path.join('.', 'gamemode', 'core', 'libraries', 'fonts.lua')

    for root, dirs, files in os.walk('.'):
        # Skip excluded directories
        dirs[:] = [d for d in dirs if not any(exclude in os.path.join(root, d) for exclude in EXCLUDE_DIRS)]

        for file in files:
            if file.endswith(('.lua', '.md')):
                file_path = os.path.join(root, file)
                # Skip excluded files
                if any(excluded in file_path for excluded in EXCLUDE_FILES):
                    continue
                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        # Skip the fonts.lua file itself (only the registration, not actual usage)
                        if file_path == fonts_file:
                            # Only count if it's not the registration line
                            lines = content.split('\n')
                            for i, line in enumerate(lines):
                                if font_name in line and 'lia.font.register' not in line and f'"{font_name}"' not in line:
                                    found_files.append(file_path)
                                    break
                        elif font_name in content:
                            found_files.append(file_path)
                except:
                    pass
    return '\n'.join(found_files) if found_files else ""

def main():
    font_names = extract_font_names()
    print(f"Found {len(font_names)} registered fonts:")
    for name in font_names:
        print(f"  - {name}")

    used_fonts = []
    unused_fonts = []

    for font_name in font_names:
        print(f"\nChecking usage for: {font_name}")
        usage = search_font_usage(font_name)
        if usage:
            used_fonts.append((font_name, usage.split('\n')))
            print(f"  Used in {len(usage.split(chr(10)))} locations")
        else:
            unused_fonts.append(font_name)
            print("  Not used")

    print("\n--- Summary ---")
    print(f"Used fonts ({len(used_fonts)}):")
    for font, locations in used_fonts:
        print(f"  - {font} ({len(locations)} usages)")

    print(f"\nUnused fonts ({len(unused_fonts)}):")
    for font in unused_fonts:
        print(f"  - {font}")

    # Save results to file
    with open('font_usage_report.txt', 'w') as f:
        f.write("Font Usage Report\n")
        f.write("=" * 50 + "\n\n")
        f.write(f"Total fonts: {len(font_names)}\n")
        f.write(f"Used fonts: {len(used_fonts)}\n")
        f.write(f"Unused fonts: {len(unused_fonts)}\n\n")
        f.write("Used fonts:\n")
        for font, locations in used_fonts:
            f.write(f"  - {font} ({len(locations)} usages)\n")
        f.write("\nUnused fonts:\n")
        for font in unused_fonts:
            f.write(f"  - {font}\n")

    print("\nReport saved to font_usage_report.txt")
if __name__ == "__main__":
    main()

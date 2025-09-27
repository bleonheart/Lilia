#!/usr/bin/env python3
"""
Script to remove Lua comments from files in the Lilia gamemode project.
Only removes -- style comments, keeping the rest of the line intact.
"""

import os
import subprocess
from pathlib import Path

DEFAULT_DIRECTORIES = [
    Path(r"E:\GMOD\Server\garrysmod\gamemodes\metrorp"),
    Path(r"E:\GMOD\Server\garrysmod\gamemodes\lilia"),
]

def remove_lua_comments(content: str) -> str:
    """Remove Lua comments from content, keeping the rest of the line intact."""
    lines = content.split('\n')
    cleaned_lines = []

    for line in lines:
        # Remove -- style comments but keep the rest of the line
        if '--' in line:
            # Find the first -- occurrence
            comment_pos = line.find('--')
            if comment_pos >= 0:
                # Keep everything before the comment
                line = line[:comment_pos].rstrip()
                # If the line becomes empty, don't add it
                if line.strip():
                    cleaned_lines.append(line)
            else:
                cleaned_lines.append(line)
        else:
            cleaned_lines.append(line)

    return '\n'.join(cleaned_lines)

def process_file(file_path: Path) -> int:
    """Process a single Lua file and return the number of comment lines removed."""
    try:
        # Read the file
        with open(file_path, 'r', encoding='utf-8') as f:
            original_content = f.read()

        # Remove comments
        cleaned_content = remove_lua_comments(original_content)

        # Only write back if content changed
        if original_content != cleaned_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(cleaned_content)
            # Count removed lines
            original_lines = len(original_content.split('\n'))
            cleaned_lines = len(cleaned_content.split('\n'))
            return original_lines - cleaned_lines

        return 0

    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return 0

def find_lua_files(directory: Path) -> list:
    """Find all Lua files in the given directory recursively."""
    lua_files = []

    for root, dirs, files in os.walk(directory):
        # Skip certain directories
        dirs[:] = [d for d in dirs if not d.startswith('.') and d not in ['__pycache__', 'node_modules']]

        for file in files:
            if file.endswith('.lua'):
                lua_files.append(Path(root) / file)

    return lua_files

def run_glualint_pretty_print(directory: Path):
    """Run glualint pretty-print on all Lua files in the directory."""
    try:
        print(f"\nRunning glualint pretty-print on: {directory}")
        result = subprocess.run(
            ['glualint', 'pretty-print', str(directory)],
            capture_output=True,
            text=True,
            check=True
        )
        print(f"glualint pretty-print completed successfully for {directory}")
        if result.stdout:
            print(f"Output: {result.stdout}")
    except subprocess.CalledProcessError as e:
        print(f"Error running glualint pretty-print on {directory}:")
        print(f"Return code: {e.returncode}")
        if e.stdout:
            print(f"Stdout: {e.stdout}")
        if e.stderr:
            print(f"Stderr: {e.stderr}")
    except FileNotFoundError:
        print("Error: glualint command not found. Please ensure glualint is installed and available in PATH.")

def main():
    """Main function to process all directories in DEFAULT_DIRECTORIES."""
    total_lines_removed = 0
    total_processed_files = 0

    for directory in DEFAULT_DIRECTORIES:
        if not directory.exists():
            print(f"Directory does not exist: {directory}")
            continue

        print(f"\nProcessing Lua files in: {directory}")

        # Find all Lua files
        lua_files = find_lua_files(directory)
        print(f"Found {len(lua_files)} Lua files")

        if not lua_files:
            print("No Lua files found!")
            continue

        # Process files
        directory_lines_removed = 0
        directory_processed_files = 0

        for file_path in lua_files:
            lines_removed = process_file(file_path)
            if lines_removed > 0:
                print(f"Removed {lines_removed} comment lines from {file_path}")
                directory_lines_removed += lines_removed
                directory_processed_files += 1

        print(f"Directory complete! Removed comments from {directory_processed_files} files, total {directory_lines_removed} lines removed")
        
        total_lines_removed += directory_lines_removed
        total_processed_files += directory_processed_files

    print(f"\nOverall processing complete! Removed comments from {total_processed_files} files across all directories, total {total_lines_removed} lines removed")

    # Run glualint pretty-print on all processed directories
    print(f"\n{'='*60}")
    print("Running glualint pretty-print on processed directories...")
    print(f"{'='*60}")

    for directory in DEFAULT_DIRECTORIES:
        if directory.exists():
            run_glualint_pretty_print(directory)

    print(f"\n{'='*60}")
    print("glualint pretty-print processing complete!")
    print(f"{'='*60}")

if __name__ == "__main__":
    main()
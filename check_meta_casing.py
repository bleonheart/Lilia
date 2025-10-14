#!/usr/bin/env python3
"""
Script to check for incorrect casing in panelMeta and vectorMeta function calls.
"""

import os
from pathlib import Path

# Define the directories to search
SEARCH_DIRS = [
    r"E:\GMOD\Server\garrysmod\gamemodes\Lilia",
    r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done",
    r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules"
]

# Define the correct function signatures and their potential incorrect casing patterns
META_FUNCTIONS = {
    "panelMeta:liaDeleteInventoryHooks": {
        "correct": ":liaDeleteInventoryHooks(",
        "incorrect": [":liadeleteinventoryhooks(", ":LIADELETEINVENTORYHOOKS(", ":LiaDeleteInventoryHooks("]
    },
    "panelMeta:liaListenForInventoryChanges": {
        "correct": ":liaListenForInventoryChanges(",
        "incorrect": [":lialistenforinventorychanges(", ":LIALISTENFORINVENTORYCHANGES(", ":LiaListenForInventoryChanges("]
    },
    "panelMeta:setScaledPos": {
        "correct": ":setScaledPos(",
        "incorrect": [":setscaledpos(", ":SETSCALEDPOS(", ":SetScaledPos("]
    },
    "panelMeta:setScaledSize": {
        "correct": ":setScaledSize(",
        "incorrect": [":setscaledsize(", ":SETSCALEDSIZE(", ":SetScaledSize("]
    },
    "vectorMeta:center": {
        "correct": ":center(",
        "incorrect": [":Center(", ":CENTER("]
    },
    "vectorMeta:distance": {
        "correct": ":distance(",
        "incorrect": [":Distance(", ":DISTANCE("]
    },
    "vectorMeta:right": {
        "correct": ":right(",
        "incorrect": [":Right(", ":RIGHT("]
    },
    "vectorMeta:rotateAroundAxis": {
        "correct": ":rotateAroundAxis(",
        "incorrect": [":rotatearoundaxis(", ":ROTATEAROUNDAXIS(", ":RotateAroundAxis("]
    },
    "vectorMeta:up": {
        "correct": ":up(",
        "incorrect": [":Up(", ":UP("]
    }
}

def search_files_simple(pattern, search_dir):
    """Simple file search without external tools."""
    results = []

    for root, dirs, files in os.walk(search_dir):
        for file in files:
            if file.endswith('.lua'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        lines = f.readlines()
                        for line_num, line in enumerate(lines, 1):
                            if pattern in line:
                                results.append(f"{file_path}:{line_num}:{line.strip()}")
                except Exception as e:
                    pass  # Skip files that can't be read

    return results

def check_meta_function_casing():
    """Check for incorrect casing in meta function calls."""
    issues_found = []

    for func_name, patterns in META_FUNCTIONS.items():
        print(f"Checking {func_name}...")

        # Check for incorrect usage patterns
        for incorrect_pattern in patterns["incorrect"]:
            for search_dir in SEARCH_DIRS:
                incorrect_usage = search_files_simple(incorrect_pattern, search_dir)
                if incorrect_usage:
                    issues_found.append({
                        'function': func_name,
                        'incorrect_pattern': incorrect_pattern,
                        'correct_pattern': patterns["correct"],
                        'found_in': '\n'.join(incorrect_usage[:5]) + ("..." if len(incorrect_usage) > 5 else "")
                    })

    return issues_found

def main():
    print("Checking for panelMeta and vectorMeta function casing issues...")
    print("=" * 60)

    issues = check_meta_function_casing()

    if issues:
        print(f"\nFound {len(issues)} casing issues:")
        print("=" * 60)
        for issue in issues:
            print(f"\nFunction: {issue['function']}")
            print(f"Incorrect: {issue['incorrect_pattern']}")
            print(f"Correct: {issue['correct_pattern']}")
            print("Found in:")
            print(issue['found_in'])
    else:
        print("\nNo casing issues found!")

    print("\n" + "=" * 60)
    print("Check complete!")

if __name__ == "__main__":
    main()

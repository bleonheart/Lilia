#!/usr/bin/env python3
"""
Script to check for common casing issues in playerMeta function calls.
"""

import os
from pathlib import Path

# Define the directories to search
SEARCH_DIRS = [
    r"E:\GMOD\Server\garrysmod\gamemodes\Lilia",
    r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done",
    r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules"
]

# Common casing issues to check
COMMON_ISSUES = [
    (":CanOverrideView(", ":canOverrideView("),
    (":DoStaredAction(", ":doStaredAction("),
    (":IsStaffOnDuty(", ":isStaffOnDuty("),
    (":GetTracedEntity(", ":getTracedEntity("),
    (":SetNetVar(", ":setNetVar("),
    (":GetChar(", ":getChar("),
    (":Notify(", ":notify("),
]

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

def check_common_issues():
    """Check for common casing issues."""
    issues_found = []

    for incorrect_pattern, correct_pattern in COMMON_ISSUES:
        print(f"Checking {incorrect_pattern} -> {correct_pattern}...")

        for search_dir in SEARCH_DIRS:
            incorrect_usage = search_files_simple(incorrect_pattern, search_dir)
            if incorrect_usage:
                issues_found.append({
                    'incorrect_pattern': incorrect_pattern,
                    'correct_pattern': correct_pattern,
                    'found_in': '\n'.join(incorrect_usage[:5]) + ("..." if len(incorrect_usage) > 5 else "")
                })

    return issues_found

def main():
    print("Checking for common playerMeta function casing issues...")
    print("=" * 60)

    issues = check_common_issues()

    if issues:
        print(f"\nFound {len(issues)} casing issues:")
        print("=" * 60)
        for issue in issues:
            print(f"\nIncorrect: {issue['incorrect_pattern']}")
            print(f"Correct: {issue['correct_pattern']}")
            print("Found in:")
            print(issue['found_in'])
    else:
        print("\nNo common casing issues found!")

    print("\n" + "=" * 60)
    print("Check complete!")

if __name__ == "__main__":
    main()

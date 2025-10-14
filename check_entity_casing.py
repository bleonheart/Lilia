#!/usr/bin/env python3
"""
Script to check for incorrect casing in entityMeta function calls.
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
ENTITY_FUNCTIONS = {
    "entityMeta:checkDoorAccess": {
        "correct": ":checkDoorAccess(",
        "incorrect": [":checkdooraccess(", ":CHECKDOORACCESS(", ":CheckDoorAccess("]
    },
    "entityMeta:clearNetVars": {
        "correct": ":clearNetVars(",
        "incorrect": [":clearnetvars(", ":CLEARNETVARS(", ":ClearNetVars("]
    },
    "entityMeta:getDoorOwner": {
        "correct": ":getDoorOwner(",
        "incorrect": [":getdoorowner(", ":GETDOOROWNER(", ":GetDoorOwner("]
    },
    "entityMeta:getDoorPartner": {
        "correct": ":getDoorPartner(",
        "incorrect": [":getdoorpartner(", ":GETDOORPARTNER(", ":GetDoorPartner("]
    },
    "entityMeta:getEntItemDropPos": {
        "correct": ":getEntItemDropPos(",
        "incorrect": [":getentitemdroppos(", ":GETENTITEMDROPPOS(", ":GetEntItemDropPos("]
    },
    "entityMeta:getNetVar": {
        "correct": ":getNetVar(",
        "incorrect": [":getnetvar(", ":GETNETVAR(", ":GetNetVar("]
    },
    "entityMeta:isDoor": {
        "correct": ":isDoor(",
        "incorrect": [":isdoor(", ":ISDOOR(", ":IsDoor("]
    },
    "entityMeta:isDoorLocked": {
        "correct": ":isDoorLocked(",
        "incorrect": [":isdoorlocked(", ":ISDOORLOCKED(", ":IsDoorLocked("]
    },
    "entityMeta:isFemale": {
        "correct": ":isFemale(",
        "incorrect": [":isfemale(", ":ISFEMALE(", ":IsFemale("]
    },
    "entityMeta:isItem": {
        "correct": ":isItem(",
        "incorrect": [":isitem(", ":ISITEM(", ":IsItem("]
    },
    "entityMeta:isLocked": {
        "correct": ":isLocked(",
        "incorrect": [":islocked(", ":ISLOCKED(", ":IsLocked("]
    },
    "entityMeta:isMoney": {
        "correct": ":isMoney(",
        "incorrect": [":ismoney(", ":ISMONEY(", ":IsMoney("]
    },
    "entityMeta:isNearEntity": {
        "correct": ":isNearEntity(",
        "incorrect": [":isnearentity(", ":ISNEARENTITY(", ":IsNearEntity("]
    },
    "entityMeta:isProp": {
        "correct": ":isProp(",
        "incorrect": [":isprop(", ":ISPROP(", ":IsProp("]
    },
    "entityMeta:isSimfphysCar": {
        "correct": ":isSimfphysCar(",
        "incorrect": [":issimfphyscar(", ":ISSIMFPHYSCAR(", ":IsSimfphysCar("]
    },
    "entityMeta:keysLock": {
        "correct": ":keysLock(",
        "incorrect": [":keyslock(", ":KEYSLOCK(", ":KeysLock("]
    },
    "entityMeta:keysOwn": {
        "correct": ":keysOwn(",
        "incorrect": [":keysown(", ":KEYSOWN(", ":KeysOwn("]
    },
    "entityMeta:keysUnLock": {
        "correct": ":keysUnLock(",
        "incorrect": [":keysunlock(", ":KEYSUNLOCK(", ":KeysUnLock("]
    },
    "entityMeta:playFollowingSound": {
        "correct": ":playFollowingSound(",
        "incorrect": [":playfollowingsound(", ":PLAYFOLLOWINGSOUND(", ":PlayFollowingSound("]
    },
    "entityMeta:removeDoorAccessData": {
        "correct": ":removeDoorAccessData(",
        "incorrect": [":removedooraccessdata(", ":REMOVEDOORACCESSDATA(", ":RemoveDoorAccessData("]
    },
    "entityMeta:sendNetVar": {
        "correct": ":sendNetVar(",
        "incorrect": [":sendnetvar(", ":SENDNETVAR(", ":SendNetVar("]
    },
    "entityMeta:setKeysNonOwnable": {
        "correct": ":setKeysNonOwnable(",
        "incorrect": [":setkeysnonownable(", ":SETKEYSNONOWNABLE(", ":SetKeysNonOwnable("]
    },
    "entityMeta:setLocked": {
        "correct": ":setLocked(",
        "incorrect": [":setlocked(", ":SETLOCKED(", ":SetLocked("]
    },
    "entityMeta:setNetVar": {
        "correct": ":setNetVar(",
        "incorrect": [":setnetvar(", ":SETNETVAR(", ":SetNetVar("]
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

def check_entity_function_casing():
    """Check for incorrect casing in entityMeta function calls."""
    issues_found = []

    for func_name, patterns in ENTITY_FUNCTIONS.items():
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
    print("Checking for entityMeta function casing issues...")
    print("=" * 60)

    issues = check_entity_function_casing()

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

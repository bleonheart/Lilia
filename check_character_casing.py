#!/usr/bin/env python3
"""
Script to check for incorrect casing in characterMeta function calls.
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
CHARACTER_FUNCTIONS = {
    "characterMeta:addBoost": {
        "correct": ":addBoost(",
        "incorrect": [":addboost(", ":ADDBOOST(", ":AddBoost("]
    },
    "characterMeta:ban": {
        "correct": ":ban(",
        "incorrect": [":BAN(", ":Ban("]
    },
    "characterMeta:delete": {
        "correct": ":delete(",
        "incorrect": [":DELETE(", ":Delete("]
    },
    "characterMeta:destroy": {
        "correct": ":destroy(",
        "incorrect": [":DESTROY(", ":Destroy("]
    },
    "characterMeta:doesFakeRecognize": {
        "correct": ":doesFakeRecognize(",
        "incorrect": [":DOESFAKERECOGNIZE(", ":DoesFakeRecognize("]
    },
    "characterMeta:doesRecognize": {
        "correct": ":doesRecognize(",
        "incorrect": [":DOESRECOGNIZE(", ":DoesRecognize("]
    },
    "characterMeta:getAttrib": {
        "correct": ":getAttrib(",
        "incorrect": [":GETATTRIB(", ":GetAttrib("]
    },
    "characterMeta:getBoost": {
        "correct": ":getBoost(",
        "incorrect": [":GETBOOST(", ":GetBoost("]
    },
    "characterMeta:getData": {
        "correct": ":getData(",
        "incorrect": [":GETDATA(", ":GetData("]
    },
    "characterMeta:getDisplayedName": {
        "correct": ":getDisplayedName(",
        "incorrect": [":GETDISPLAYEDNAME(", ":GetDisplayedName("]
    },
    "characterMeta:getID": {
        "correct": ":getID(",
        "incorrect": [":GETID(", ":GetID("]
    },
    "characterMeta:getItemWeapon": {
        "correct": ":getItemWeapon(",
        "incorrect": [":GETITEMWEAPON(", ":GetItemWeapon("]
    },
    "characterMeta:getPlayer": {
        "correct": ":getPlayer(",
        "incorrect": [":GETPLAYER(", ":GetPlayer("]
    },
    "characterMeta:giveFlags": {
        "correct": ":giveFlags(",
        "incorrect": [":GIVEFLAGS(", ":GiveFlags("]
    },
    "characterMeta:giveMoney": {
        "correct": ":giveMoney(",
        "incorrect": [":GIVEMONEY(", ":GiveMoney("]
    },
    "characterMeta:hasFlags": {
        "correct": ":hasFlags(",
        "incorrect": [":HASFLAGS(", ":HasFlags("]
    },
    "characterMeta:hasMoney": {
        "correct": ":hasMoney(",
        "incorrect": [":HASMONEY(", ":HasMoney("]
    },
    "characterMeta:isBanned": {
        "correct": ":isBanned(",
        "incorrect": [":ISBANNED(", ":IsBanned("]
    },
    "characterMeta:joinClass": {
        "correct": ":joinClass(",
        "incorrect": [":JOINCLASS(", ":JoinClass("]
    },
    "characterMeta:kick": {
        "correct": ":kick(",
        "incorrect": [":KICK(", ":Kick("]
    },
    "characterMeta:kickClass": {
        "correct": ":kickClass(",
        "incorrect": [":KICKCLASS(", ":KickClass("]
    },
    "characterMeta:recognize": {
        "correct": ":recognize(",
        "incorrect": [":RECOGNIZE(", ":Recognize("]
    },
    "characterMeta:removeBoost": {
        "correct": ":removeBoost(",
        "incorrect": [":REMOVEBOOST(", ":RemoveBoost("]
    },
    "characterMeta:save": {
        "correct": ":save(",
        "incorrect": [":SAVE(", ":Save("]
    },
    "characterMeta:setAttrib": {
        "correct": ":setAttrib(",
        "incorrect": [":SETATTRIB(", ":SetAttrib("]
    },
    "characterMeta:setData": {
        "correct": ":setData(",
        "incorrect": [":SETDATA(", ":SetData("]
    },
    "characterMeta:setFlags": {
        "correct": ":setFlags(",
        "incorrect": [":SETFLAGS(", ":SetFlags("]
    },
    "characterMeta:setup": {
        "correct": ":setup(",
        "incorrect": [":SETUP(", ":Setup("]
    },
    "characterMeta:sync": {
        "correct": ":sync(",
        "incorrect": [":SYNC(", ":Sync("]
    },
    "characterMeta:takeFlags": {
        "correct": ":takeFlags(",
        "incorrect": [":TAKEFLAGS(", ":TakeFlags("]
    },
    "characterMeta:takeMoney": {
        "correct": ":takeMoney(",
        "incorrect": [":TAKEMONEY(", ":TakeMoney("]
    },
    "characterMeta:tostring": {
        "correct": ":tostring(",
        "incorrect": [":TOSTRING(", ":ToString("]
    },
    "characterMeta:updateAttrib": {
        "correct": ":updateAttrib(",
        "incorrect": [":UPDATEATTRIB(", ":UpdateAttrib("]
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

def check_character_function_casing():
    """Check for incorrect casing in characterMeta function calls."""
    issues_found = []

    for func_name, patterns in CHARACTER_FUNCTIONS.items():
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
    print("Checking for characterMeta function casing issues...")
    print("=" * 60)

    issues = check_character_function_casing()

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

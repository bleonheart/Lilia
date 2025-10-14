#!/usr/bin/env python3
"""
Script to check for incorrect casing in playerMeta function calls across the Lilia gamemode.
"""

import os
import re
from pathlib import Path

# Define the directories to search
SEARCH_DIRS = [
    r"E:\GMOD\Server\garrysmod\gamemodes\Lilia",
    r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done",
    r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules"
]

# Define the correct function signatures and their potential incorrect casing patterns
FUNCTIONS = {
    "Name": {
        "correct": ":Name(",
        "incorrect": [":name(", ":NAME("]
    },
    "addMoney": {
        "correct": ":addMoney(",
        "incorrect": [":addmoney(", ":ADDMONEY(", ":AddMoney("]
    },
    "addPart": {
        "correct": ":addPart(",
        "incorrect": [":addpart(", ":ADDPART(", ":AddPart("]
    },
    "banPlayer": {
        "correct": ":banPlayer(",
        "incorrect": [":banplayer(", ":BANPLAYER(", ":BanPlayer("]
    },
    "binaryQuestion": {
        "correct": ":binaryQuestion(",
        "incorrect": [":binaryquestion(", ":BINARYQUESTION(", ":BinaryQuestion("]
    },
    "canAfford": {
        "correct": ":canAfford(",
        "incorrect": [":canafford(", ":CANAFFORD(", ":CanAfford("]
    },
    "canEditVendor": {
        "correct": ":canEditVendor(",
        "incorrect": [":caneditvendor(", ":CANEDITVENDOR(", ":CanEditVendor("]
    },
    "canOverrideView": {
        "correct": ":canOverrideView(",
        "incorrect": [":canoverrideview(", ":CANOVERRIDEVIEW(", ":CanOverrideView(", ":Canoverrideview("]
    },
    "consumeStamina": {
        "correct": ":consumeStamina(",
        "incorrect": [":consumestamina(", ":CONSUMESTAMINA(", ":ConsumeStamina("]
    },
    "createRagdoll": {
        "correct": ":createRagdoll(",
        "incorrect": [":createragdoll(", ":CREATERAGDOLL(", ":CreateRagdoll("]
    },
    "doGesture": {
        "correct": ":doGesture(",
        "incorrect": [":dogesture(", ":DOGESTURE(", ":DoGesture("]
    },
    "doStaredAction": {
        "correct": ":doStaredAction(",
        "incorrect": [":dostaredaction(", ":DOSTAREDACTION(", ":DoStaredAction("]
    },
    "entitiesNearPlayer": {
        "correct": ":entitiesNearPlayer(",
        "incorrect": [":entitiesnearplayer(", ":ENTITIESNEARPLAYER(", ":EntitiesNearPlayer("]
    },
    "forceSequence": {
        "correct": ":forceSequence(",
        "incorrect": [":forcesequence(", ":FORCESEQUENCE(", ":ForceSequence("]
    },
    "getAllLiliaData": {
        "correct": ":getAllLiliaData(",
        "incorrect": [":getallliliadata(", ":GETALLLILIADATA(", ":GetAllLiliaData("]
    },
    "getChar": {
        "correct": ":getChar(",
        "incorrect": [":getchar(", ":GETCHAR(", ":GetChar("]
    },
    "getClassData": {
        "correct": ":getClassData(",
        "incorrect": [":getclassdata(", ":GETCLASSDATA(", ":GetClassData("]
    },
    "getDarkRPVar": {
        "correct": ":getDarkRPVar(",
        "incorrect": [":getdarkrpvar(", ":GETDARKRPVAR(", ":GetDarkRPVar("]
    },
    "getEyeEnt": {
        "correct": ":getEyeEnt(",
        "incorrect": [":geteyeent(", ":GETEYEENT(", ":GetEyeEnt("]
    },
    "getFlags": {
        "correct": ":getFlags(",
        "incorrect": [":getflags(", ":GETFLAGS(", ":GetFlags("]
    },
    "getItemDropPos": {
        "correct": ":getItemDropPos(",
        "incorrect": [":getitemdroppos(", ":GETITEMDROPPOS(", ":GetItemDropPos("]
    },
    "getItemWeapon": {
        "correct": ":getItemWeapon(",
        "incorrect": [":getitemweapon(", ":GETITEMWEAPON(", ":GetItemWeapon("]
    },
    "getItems": {
        "correct": ":getItems(",
        "incorrect": [":getitems(", ":GETITEMS(", ":GetItems("]
    },
    "getLiliaData": {
        "correct": ":getLiliaData(",
        "incorrect": [":getliliadata(", ":GETLILIADATA(", ":GetLiliaData("]
    },
    "getMoney": {
        "correct": ":getMoney(",
        "incorrect": [":getmoney(", ":GETMONEY(", ":GetMoney("]
    },
    "getParts": {
        "correct": ":getParts(",
        "incorrect": [":getparts(", ":GETPARTS(", ":GetParts("]
    },
    "getPlayTime": {
        "correct": ":getPlayTime(",
        "incorrect": [":getplaytime(", ":GETPLAYTIME(", ":GetPlayTime("]
    },
    "getSessionTime": {
        "correct": ":getSessionTime(",
        "incorrect": [":getsessiontime(", ":GETSESSIONTIME(", ":GetSessionTime("]
    },
    "getTrace": {
        "correct": ":getTrace(",
        "incorrect": [":gettrace(", ":GETTRACE(", ":GetTrace("]
    },
    "getTracedEntity": {
        "correct": ":getTracedEntity(",
        "incorrect": [":gettracedentity(", ":GETTRACEDENTITY(", ":GetTracedEntity("]
    },
    "giveFlags": {
        "correct": ":giveFlags(",
        "incorrect": [":giveflags(", ":GIVEFLAGS(", ":GiveFlags("]
    },
    "hasFlags": {
        "correct": ":hasFlags(",
        "incorrect": [":hasflags(", ":HASFLAGS(", ":HasFlags("]
    },
    "hasPrivilege": {
        "correct": ":hasPrivilege(",
        "incorrect": [":hasprivilege(", ":HASPRIVILEGE(", ":HasPrivilege("]
    },
    "hasSkillLevel": {
        "correct": ":hasSkillLevel(",
        "incorrect": [":hasskilllevel(", ":HASSKILLLEVEL(", ":HasSkillLevel("]
    },
    "hasWhitelist": {
        "correct": ":hasWhitelist(",
        "incorrect": [":haswhitelist(", ":HASWHITELIST(", ":HasWhitelist("]
    },
    "isFamilySharedAccount": {
        "correct": ":isFamilySharedAccount(",
        "incorrect": [":isfamilysharedaccount(", ":ISFAMILYSHAREDACCOUNT(", ":IsFamilySharedAccount("]
    },
    "isInThirdPerson": {
        "correct": ":isInThirdPerson(",
        "incorrect": [":isinthirdperson(", ":ISINTHIRDPERSON(", ":IsInThirdPerson("]
    },
    "isNearPlayer": {
        "correct": ":isNearPlayer(",
        "incorrect": [":isnearplayer(", ":ISNEARPLAYER(", ":IsNearPlayer("]
    },
    "isRunning": {
        "correct": ":isRunning(",
        "incorrect": [":isrunning(", ":ISRUNNING(", ":IsRunning("]
    },
    "isStaff": {
        "correct": ":isStaff(",
        "incorrect": [":isstaff(", ":ISSTAFF(", ":IsStaff("]
    },
    "isStaffOnDuty": {
        "correct": ":isStaffOnDuty(",
        "incorrect": [":isstaffonduty(", ":ISSTAFFONDUTY(", ":IsStaffOnDuty("]
    },
    "isStuck": {
        "correct": ":isStuck(",
        "incorrect": [":isstuck(", ":ISSTUCK(", ":IsStuck("]
    },
    "isVIP": {
        "correct": ":isVIP(",
        "incorrect": [":isvip(", ":ISVIP(", ":IsVIP("]
    },
    "leaveSequence": {
        "correct": ":leaveSequence(",
        "incorrect": [":leavesequence(", ":LEAVESEQUENCE(", ":LeaveSequence("]
    },
    "loadLiliaData": {
        "correct": ":loadLiliaData(",
        "incorrect": [":loadliliadata(", ":LOADLILIADATA(", ":LoadLiliaData("]
    },
    "meetsRequiredSkills": {
        "correct": ":meetsRequiredSkills(",
        "incorrect": [":meetsrequiredskills(", ":MEETSREQUIREDSKILLS(", ":MeetsRequiredSkills("]
    },
    "networkAnimation": {
        "correct": ":networkAnimation(",
        "incorrect": [":networkanimation(", ":NETWORKANIMATION(", ":NetworkAnimation("]
    },
    "notify": {
        "correct": ":notify(",
        "incorrect": [":NOTIFY(", ":Notify("]
    },
    "notifyAdmin": {
        "correct": ":notifyAdmin(",
        "incorrect": [":notifyadmin(", ":NOTIFYADMIN(", ":NotifyAdmin("]
    },
    "notifyAdminLocalized": {
        "correct": ":notifyAdminLocalized(",
        "incorrect": [":notifyadminlocalized(", ":NOTIFYADMINLOCALIZED(", ":NotifyAdminLocalized("]
    },
    "notifyError": {
        "correct": ":notifyError(",
        "incorrect": [":notifyerror(", ":NOTIFYERROR(", ":NotifyError("]
    },
    "notifyErrorLocalized": {
        "correct": ":notifyErrorLocalized(",
        "incorrect": [":notifyerrorlocalized(", ":NOTIFYERRORLOCALIZED(", ":NotifyErrorLocalized("]
    },
    "notifyInfo": {
        "correct": ":notifyInfo(",
        "incorrect": [":notifyinfo(", ":NOTIFYINFO(", ":NotifyInfo("]
    },
    "notifyInfoLocalized": {
        "correct": ":notifyInfoLocalized(",
        "incorrect": [":notifyinfolocalized(", ":NOTIFYINFOLOCALIZED(", ":NotifyInfoLocalized("]
    },
    "notifyLocalized": {
        "correct": ":notifyLocalized(",
        "incorrect": [":notifylocalized(", ":NOTIFYLOCALIZED(", ":NotifyLocalized("]
    },
    "notifyMoney": {
        "correct": ":notifyMoney(",
        "incorrect": [":notifymoney(", ":NOTIFYMONEY(", ":NotifyMoney("]
    },
    "notifyMoneyLocalized": {
        "correct": ":notifyMoneyLocalized(",
        "incorrect": [":notifymoneylocalized(", ":NOTIFYMONEYLOCALIZED(", ":NotifyMoneyLocalized("]
    },
    "notifySuccess": {
        "correct": ":notifySuccess(",
        "incorrect": [":notifysuccess(", ":NOTIFYSUCCESS(", ":NotifySuccess("]
    },
    "notifySuccessLocalized": {
        "correct": ":notifySuccessLocalized(",
        "incorrect": [":notifysuccesslocalized(", ":NOTIFYSUCCESSLOCALIZED(", ":NotifySuccessLocalized("]
    },
    "notifyWarning": {
        "correct": ":notifyWarning(",
        "incorrect": [":notifywarning(", ":NOTIFYWARNING(", ":NotifyWarning("]
    },
    "notifyWarningLocalized": {
        "correct": ":notifyWarningLocalized(",
        "incorrect": [":notifywarninglocalized(", ":NOTIFYWARNINGLOCALIZED(", ":NotifyWarningLocalized("]
    },
    "playTimeGreaterThan": {
        "correct": ":playTimeGreaterThan(",
        "incorrect": [":playtimegreaterthan(", ":PLAYTIMEGREATERTHAN(", ":PlayTimeGreaterThan("]
    },
    "removePart": {
        "correct": ":removePart(",
        "incorrect": [":removepart(", ":REMOVEPART(", ":RemovePart("]
    },
    "removeRagdoll": {
        "correct": ":removeRagdoll(",
        "incorrect": [":removeragdoll(", ":REMOVERAGDOLL(", ":RemoveRagdoll("]
    },
    "requestArguments": {
        "correct": ":requestArguments(",
        "incorrect": [":requestarguments(", ":REQUESTARGUMENTS(", ":RequestArguments("]
    },
    "requestButtons": {
        "correct": ":requestButtons(",
        "incorrect": [":requestbuttons(", ":REQUESTBUTTONS(", ":RequestButtons("]
    },
    "requestDropdown": {
        "correct": ":requestDropdown(",
        "incorrect": [":requestdropdown(", ":REQUESTDROPDOWN(", ":RequestDropdown("]
    },
    "requestOptions": {
        "correct": ":requestOptions(",
        "incorrect": [":requestoptions(", ":REQUESTOPTIONS(", ":RequestOptions("]
    },
    "requestString": {
        "correct": ":requestString(",
        "incorrect": [":requeststring(", ":REQUESTSTRING(", ":RequestString("]
    },
    "resetParts": {
        "correct": ":resetParts(",
        "incorrect": [":resetparts(", ":RESETPARTS(", ":ResetParts("]
    },
    "restoreStamina": {
        "correct": ":restoreStamina(",
        "incorrect": [":restorestamina(", ":RESTORESTAMINA(", ":RestoreStamina("]
    },
    "saveLiliaData": {
        "correct": ":saveLiliaData(",
        "incorrect": [":saveliliadata(", ":SAVELILIADATA(", ":SaveLiliaData("]
    },
    "setAction": {
        "correct": ":setAction(",
        "incorrect": [":setaction(", ":SETACTION(", ":SetAction("]
    },
    "setLiliaData": {
        "correct": ":setLiliaData(",
        "incorrect": [":setliliadata(", ":SETLILIADATA(", ":SetLiliaData("]
    },
    "setNetVar": {
        "correct": ":setNetVar(",
        "incorrect": [":setnetvar(", ":SETNETVAR(", ":SetNetVar("]
    },
    "setRagdolled": {
        "correct": ":setRagdolled(",
        "incorrect": [":setragdolled(", ":SETRAGDOLLED(", ":SetRagdolled("]
    },
    "setWaypoint": {
        "correct": ":setWaypoint(",
        "incorrect": [":setwaypoint(", ":SETWAYPOINT(", ":SetWaypoint("]
    },
    "stopAction": {
        "correct": ":stopAction(",
        "incorrect": [":stopaction(", ":STOPACTION(", ":StopAction("]
    },
    "syncParts": {
        "correct": ":syncParts(",
        "incorrect": [":syncparts(", ":SYNCPARTS(", ":SyncParts("]
    },
    "syncVars": {
        "correct": ":syncVars(",
        "incorrect": [":syncvars(", ":SYNCVARS(", ":SyncVars("]
    },
    "takeFlags": {
        "correct": ":takeFlags(",
        "incorrect": [":takeflags(", ":TAKEFLAGS(", ":TakeFlags("]
    },
    "takeMoney": {
        "correct": ":takeMoney(",
        "incorrect": [":takemoney(", ":TAKEMONEY(", ":TakeMoney("]
    },
    "tostring": {
        "correct": ":tostring(",
        "incorrect": [":TOSTRING(", ":ToString("]
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

def check_function_casing():
    """Check for incorrect casing in function calls."""
    issues_found = []

    for func_name, patterns in FUNCTIONS.items():
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
                        'found_in': '\n'.join(incorrect_usage[:10]) + ("..." if len(incorrect_usage) > 10 else "")
                    })

    return issues_found

def main():
    print("Checking for playerMeta function casing issues...")
    print("=" * 60)

    issues = check_function_casing()

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

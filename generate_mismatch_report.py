#!/usr/bin/env python3
"""
Script to generate a comprehensive mismatch report for all meta function casing issues.
"""

import os
from pathlib import Path
from collections import defaultdict

# Define the directories to search
SEARCH_DIRS = [
    r"E:\GMOD\Server\garrysmod\gamemodes\Lilia",
    r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done",
    r"E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules"
]

# Define all the correct function signatures and their potential incorrect casing patterns
ALL_FUNCTIONS = {
    "playerMeta": {
        "Name": { "correct": ":Name(", "incorrect": [":name(", ":NAME("] },
        "addMoney": { "correct": ":addMoney(", "incorrect": [":addmoney(", ":ADDMONEY(", ":AddMoney("] },
        "addPart": { "correct": ":addPart(", "incorrect": [":addpart(", ":ADDPART(", ":AddPart("] },
        "banPlayer": { "correct": ":banPlayer(", "incorrect": [":banplayer(", ":BANPLAYER(", ":BanPlayer("] },
        "binaryQuestion": { "correct": ":binaryQuestion(", "incorrect": [":binaryquestion(", ":BINARYQUESTION(", ":BinaryQuestion("] },
        "canAfford": { "correct": ":canAfford(", "incorrect": [":canafford(", ":CANAFFORD(", ":CanAfford("] },
        "canEditVendor": { "correct": ":canEditVendor(", "incorrect": [":caneditvendor(", ":CANEDITVENDOR(", ":CanEditVendor("] },
        "canOverrideView": { "correct": ":canOverrideView(", "incorrect": [":canoverrideview(", ":CANOVERRIDEVIEW(", ":CanOverrideView(", ":Canoverrideview("] },
        "consumeStamina": { "correct": ":consumeStamina(", "incorrect": [":consumestamina(", ":CONSUMESTAMINA(", ":ConsumeStamina("] },
        "createRagdoll": { "correct": ":createRagdoll(", "incorrect": [":createragdoll(", ":CREATERAGDOLL(", ":CreateRagdoll("] },
        "doGesture": { "correct": ":doGesture(", "incorrect": [":dogesture(", ":DOGESTURE(", ":DoGesture("] },
        "doStaredAction": { "correct": ":doStaredAction(", "incorrect": [":dostaredaction(", ":DOSTAREDACTION(", ":DoStaredAction("] },
        "entitiesNearPlayer": { "correct": ":entitiesNearPlayer(", "incorrect": [":entitiesnearplayer(", ":ENTITIESNEARPLAYER(", ":EntitiesNearPlayer("] },
        "forceSequence": { "correct": ":forceSequence(", "incorrect": [":forcesequence(", ":FORCESEQUENCE(", ":ForceSequence("] },
        "getAllLiliaData": { "correct": ":getAllLiliaData(", "incorrect": [":getallliliadata(", ":GETALLLILIADATA(", ":GetAllLiliaData("] },
        "getChar": { "correct": ":getChar(", "incorrect": [":getchar(", ":GETCHAR(", ":GetChar("] },
        "getClassData": { "correct": ":getClassData(", "incorrect": [":getclassdata(", ":GETCLASSDATA(", ":GetClassData("] },
        "getDarkRPVar": { "correct": ":getDarkRPVar(", "incorrect": [":getdarkrpvar(", ":GETDARKRPVAR(", ":GetDarkRPVar("] },
        "getEyeEnt": { "correct": ":getEyeEnt(", "incorrect": [":geteyeent(", ":GETEYEENT(", ":GetEyeEnt("] },
        "getFlags": { "correct": ":getFlags(", "incorrect": [":getflags(", ":GETFLAGS(", ":GetFlags("] },
        "getItemDropPos": { "correct": ":getItemDropPos(", "incorrect": [":getitemdroppos(", ":GETITEMDROPPOS(", ":GetItemDropPos("] },
        "getItemWeapon": { "correct": ":getItemWeapon(", "incorrect": [":getitemweapon(", ":GETITEMWEAPON(", ":GetItemWeapon("] },
        "getItems": { "correct": ":getItems(", "incorrect": [":getitems(", ":GETITEMS(", ":GetItems("] },
        "getLiliaData": { "correct": ":getLiliaData(", "incorrect": [":getliliadata(", ":GETLILIADATA(", ":GetLiliaData("] },
        "getMoney": { "correct": ":getMoney(", "incorrect": [":getmoney(", ":GETMONEY(", ":GetMoney("] },
        "getParts": { "correct": ":getParts(", "incorrect": [":getparts(", ":GETPARTS(", ":GetParts("] },
        "getPlayTime": { "correct": ":getPlayTime(", "incorrect": [":getplaytime(", ":GETPLAYTIME(", ":GetPlayTime("] },
        "getSessionTime": { "correct": ":getSessionTime(", "incorrect": [":getsessiontime(", ":GETSESSIONTIME(", ":GetSessionTime("] },
        "getTrace": { "correct": ":getTrace(", "incorrect": [":gettrace(", ":GETTRACE(", ":GetTrace("] },
        "getTracedEntity": { "correct": ":getTracedEntity(", "incorrect": [":gettracedentity(", ":GETTRACEDENTITY(", ":GetTracedEntity("] },
        "giveFlags": { "correct": ":giveFlags(", "incorrect": [":giveflags(", ":GIVEFLAGS(", ":GiveFlags("] },
        "hasFlags": { "correct": ":hasFlags(", "incorrect": [":hasflags(", ":HASFLAGS(", ":HasFlags("] },
        "hasPrivilege": { "correct": ":hasPrivilege(", "incorrect": [":hasprivilege(", ":HASPRIVILEGE(", ":HasPrivilege("] },
        "hasSkillLevel": { "correct": ":hasSkillLevel(", "incorrect": [":hasskilllevel(", ":HASSKILLLEVEL(", ":HasSkillLevel("] },
        "hasWhitelist": { "correct": ":hasWhitelist(", "incorrect": [":haswhitelist(", ":HASWHITELIST(", ":HasWhitelist("] },
        "isFamilySharedAccount": { "correct": ":isFamilySharedAccount(", "incorrect": [":isfamilysharedaccount(", ":ISFAMILYSHAREDACCOUNT(", ":IsFamilySharedAccount("] },
        "isInThirdPerson": { "correct": ":isInThirdPerson(", "incorrect": [":isinthirdperson(", ":ISINTHIRDPERSON(", ":IsInThirdPerson("] },
        "isNearPlayer": { "correct": ":isNearPlayer(", "incorrect": [":isnearplayer(", ":ISNEARPLAYER(", ":IsNearPlayer("] },
        "isRunning": { "correct": ":isRunning(", "incorrect": [":isrunning(", ":ISRUNNING(", ":IsRunning("] },
        "isStaff": { "correct": ":isStaff(", "incorrect": [":isstaff(", ":ISSTAFF(", ":IsStaff("] },
        "isStaffOnDuty": { "correct": ":isStaffOnDuty(", "incorrect": [":isstaffonduty(", ":ISSTAFFONDUTY(", ":IsStaffOnDuty("] },
        "isStuck": { "correct": ":isStuck(", "incorrect": [":isstuck(", ":ISSTUCK(", ":IsStuck("] },
        "isVIP": { "correct": ":isVIP(", "incorrect": [":isvip(", ":ISVIP(", ":IsVIP("] },
        "leaveSequence": { "correct": ":leaveSequence(", "incorrect": [":leavesequence(", ":LEAVESEQUENCE(", ":LeaveSequence("] },
        "loadLiliaData": { "correct": ":loadLiliaData(", "incorrect": [":loadliliadata(", ":LOADLILIADATA(", ":LoadLiliaData("] },
        "meetsRequiredSkills": { "correct": ":meetsRequiredSkills(", "incorrect": [":meetsrequiredskills(", ":MEETSREQUIREDSKILLS(", ":MeetsRequiredSkills("] },
        "networkAnimation": { "correct": ":networkAnimation(", "incorrect": [":networkanimation(", ":NETWORKANIMATION(", ":NetworkAnimation("] },
        "notify": { "correct": ":notify(", "incorrect": [":NOTIFY(", ":Notify("] },
        "notifyAdmin": { "correct": ":notifyAdmin(", "incorrect": [":notifyadmin(", ":NOTIFYADMIN(", ":NotifyAdmin("] },
        "notifyAdminLocalized": { "correct": ":notifyAdminLocalized(", "incorrect": [":notifyadminlocalized(", ":NOTIFYADMINLOCALIZED(", ":NotifyAdminLocalized("] },
        "notifyError": { "correct": ":notifyError(", "incorrect": [":notifyerror(", ":NOTIFYERROR(", ":NotifyError("] },
        "notifyErrorLocalized": { "correct": ":notifyErrorLocalized(", "incorrect": [":notifyerrorlocalized(", ":NOTIFYERRORLOCALIZED(", ":NotifyErrorLocalized("] },
        "notifyInfo": { "correct": ":notifyInfo(", "incorrect": [":notifyinfo(", ":NOTIFYINFO(", ":NotifyInfo("] },
        "notifyInfoLocalized": { "correct": ":notifyInfoLocalized(", "incorrect": [":notifyinfolocalized(", ":NOTIFYINFOLOCALIZED(", ":NotifyInfoLocalized("] },
        "notifyLocalized": { "correct": ":notifyLocalized(", "incorrect": [":notifylocalized(", ":NOTIFYLOCALIZED(", ":NotifyLocalized("] },
        "notifyMoney": { "correct": ":notifyMoney(", "incorrect": [":notifymoney(", ":NOTIFYMONEY(", ":NotifyMoney("] },
        "notifyMoneyLocalized": { "correct": ":notifyMoneyLocalized(", "incorrect": [":notifymoneylocalized(", ":NOTIFYMONEYLOCALIZED(", ":NotifyMoneyLocalized("] },
        "notifySuccess": { "correct": ":notifySuccess(", "incorrect": [":notifysuccess(", ":NOTIFYSUCCESS(", ":NotifySuccess("] },
        "notifySuccessLocalized": { "correct": ":notifySuccessLocalized(", "incorrect": [":notifysuccesslocalized(", ":NOTIFYSUCCESSLOCALIZED(", ":NotifySuccessLocalized("] },
        "notifyWarning": { "correct": ":notifyWarning(", "incorrect": [":notifywarning(", ":NOTIFYWARNING(", ":NotifyWarning("] },
        "notifyWarningLocalized": { "correct": ":notifyWarningLocalized(", "incorrect": [":notifywarninglocalized(", ":NOTIFYWARNINGLOCALIZED(", ":NotifyWarningLocalized("] },
        "playTimeGreaterThan": { "correct": ":playTimeGreaterThan(", "incorrect": [":playtimegreaterthan(", ":PLAYTIMEGREATERTHAN(", ":PlayTimeGreaterThan("] },
        "removePart": { "correct": ":removePart(", "incorrect": [":removepart(", ":REMOVEPART(", ":RemovePart("] },
        "removeRagdoll": { "correct": ":removeRagdoll(", "incorrect": [":removeragdoll(", ":REMOVERAGDOLL(", ":RemoveRagdoll("] },
        "requestArguments": { "correct": ":requestArguments(", "incorrect": [":requestarguments(", ":REQUESTARGUMENTS(", ":RequestArguments("] },
        "requestButtons": { "correct": ":requestButtons(", "incorrect": [":requestbuttons(", ":REQUESTBUTTONS(", ":RequestButtons("] },
        "requestDropdown": { "correct": ":requestDropdown(", "incorrect": [":requestdropdown(", ":REQUESTDROPDOWN(", ":RequestDropdown("] },
        "requestOptions": { "correct": ":requestOptions(", "incorrect": [":requestoptions(", ":REQUESTOPTIONS(", ":RequestOptions("] },
        "requestString": { "correct": ":requestString(", "incorrect": [":requeststring(", ":REQUESTSTRING(", ":RequestString("] },
        "resetParts": { "correct": ":resetParts(", "incorrect": [":resetparts(", ":RESETPARTS(", ":ResetParts("] },
        "restoreStamina": { "correct": ":restoreStamina(", "incorrect": [":restorestamina(", ":RESTORESTAMINA(", ":RestoreStamina("] },
        "saveLiliaData": { "correct": ":saveLiliaData(", "incorrect": [":saveliliadata(", ":SAVELILIADATA(", ":SaveLiliaData("] },
        "setAction": { "correct": ":setAction(", "incorrect": [":setaction(", ":SETACTION(", ":SetAction("] },
        "setLiliaData": { "correct": ":setLiliaData(", "incorrect": [":setliliadata(", ":SETLILIADATA(", ":SetLiliaData("] },
        "setNetVar": { "correct": ":setNetVar(", "incorrect": [":setnetvar(", ":SETNETVAR(", ":SetNetVar("] },
        "setRagdolled": { "correct": ":setRagdolled(", "incorrect": [":setragdolled(", ":SETRAGDOLLED(", ":SetRagdolled("] },
        "setWaypoint": { "correct": ":setWaypoint(", "incorrect": [":setwaypoint(", ":SETWAYPOINT(", ":SetWaypoint("] },
        "stopAction": { "correct": ":stopAction(", "incorrect": [":stopaction(", ":STOPACTION(", ":StopAction("] },
        "syncParts": { "correct": ":syncParts(", "incorrect": [":syncparts(", ":SYNCPARTS(", ":SyncParts("] },
        "syncVars": { "correct": ":syncVars(", "incorrect": [":syncvars(", ":SYNCVARS(", ":SyncVars("] },
        "takeFlags": { "correct": ":takeFlags(", "incorrect": [":takeflags(", ":TAKEFLAGS(", ":TakeFlags("] },
        "takeMoney": { "correct": ":takeMoney(", "incorrect": [":takemoney(", ":TAKEMONEY(", ":TakeMoney("] },
        "tostring": { "correct": ":tostring(", "incorrect": [":TOSTRING(", ":ToString("] },
    },
    "characterMeta": {
        "addBoost": { "correct": ":addBoost(", "incorrect": [":ADDBOOST(", ":AddBoost("] },
        "ban": { "correct": ":ban(", "incorrect": [":BAN(", ":Ban("] },
        "delete": { "correct": ":delete(", "incorrect": [":DELETE(", ":Delete("] },
        "destroy": { "correct": ":destroy(", "incorrect": [":DESTROY(", ":Destroy("] },
        "doesFakeRecognize": { "correct": ":doesFakeRecognize(", "incorrect": [":DOESFAKERECOGNIZE(", ":DoesFakeRecognize("] },
        "doesRecognize": { "correct": ":doesRecognize(", "incorrect": [":DOESRECOGNIZE(", ":DoesRecognize("] },
        "getAttrib": { "correct": ":getAttrib(", "incorrect": [":GETATTRIB(", ":GetAttrib("] },
        "getBoost": { "correct": ":getBoost(", "incorrect": [":GETBOOST(", ":GetBoost("] },
        "getData": { "correct": ":getData(", "incorrect": [":GETDATA(", ":GetData("] },
        "getDisplayedName": { "correct": ":getDisplayedName(", "incorrect": [":GETDISPLAYEDNAME(", ":GetDisplayedName("] },
        "getID": { "correct": ":getID(", "incorrect": [":GETID(", ":GetID("] },
        "getItemWeapon": { "correct": ":getItemWeapon(", "incorrect": [":GETITEMWEAPON(", ":GetItemWeapon("] },
        "getPlayer": { "correct": ":getPlayer(", "incorrect": [":GETPLAYER(", ":GetPlayer("] },
        "giveFlags": { "correct": ":giveFlags(", "incorrect": [":GIVEFLAGS(", ":GiveFlags("] },
        "giveMoney": { "correct": ":giveMoney(", "incorrect": [":GIVEMONEY(", ":GiveMoney("] },
        "hasFlags": { "correct": ":hasFlags(", "incorrect": [":HASFLAGS(", ":HasFlags("] },
        "hasMoney": { "correct": ":hasMoney(", "incorrect": [":HASMONEY(", ":HasMoney("] },
        "isBanned": { "correct": ":isBanned(", "incorrect": [":ISBANNED(", ":IsBanned("] },
        "joinClass": { "correct": ":joinClass(", "incorrect": [":JOINCLASS(", ":JoinClass("] },
        "kick": { "correct": ":kick(", "incorrect": [":KICK(", ":Kick("] },
        "kickClass": { "correct": ":kickClass(", "incorrect": [":KICKCLASS(", ":KickClass("] },
        "recognize": { "correct": ":recognize(", "incorrect": [":RECOGNIZE(", ":Recognize("] },
        "removeBoost": { "correct": ":removeBoost(", "incorrect": [":REMOVEBOOST(", ":RemoveBoost("] },
        "save": { "correct": ":save(", "incorrect": [":SAVE(", ":Save("] },
        "setAttrib": { "correct": ":setAttrib(", "incorrect": [":SETATTRIB(", ":SetAttrib("] },
        "setData": { "correct": ":setData(", "incorrect": [":SETDATA(", ":SetData("] },
        "setFlags": { "correct": ":setFlags(", "incorrect": [":SETFLAGS(", ":SetFlags("] },
        "setup": { "correct": ":setup(", "incorrect": [":SETUP(", ":Setup("] },
        "sync": { "correct": ":sync(", "incorrect": [":SYNC(", ":Sync("] },
        "takeFlags": { "correct": ":takeFlags(", "incorrect": [":TAKEFLAGS(", ":TakeFlags("] },
        "takeMoney": { "correct": ":takeMoney(", "incorrect": [":TAKEMONEY(", ":TakeMoney("] },
        "tostring": { "correct": ":tostring(", "incorrect": [":TOSTRING(", ":ToString("] },
        "updateAttrib": { "correct": ":updateAttrib(", "incorrect": [":UPDATEATTRIB(", ":UpdateAttrib("] },
    },
    "panelMeta": {
        "liaDeleteInventoryHooks": { "correct": ":liaDeleteInventoryHooks(", "incorrect": [":LIADELETEINVENTORYHOOKS(", ":LiaDeleteInventoryHooks("] },
        "liaListenForInventoryChanges": { "correct": ":liaListenForInventoryChanges(", "incorrect": [":LIALISTENFORINVENTORYCHANGES(", ":LiaListenForInventoryChanges("] },
        "setScaledPos": { "correct": ":setScaledPos(", "incorrect": [":SETSCALEDPOS(", ":SetScaledPos("] },
        "setScaledSize": { "correct": ":setScaledSize(", "incorrect": [":SETSCALEDSIZE(", ":SetScaledSize("] },
    },
    "vectorMeta": {
        "center": { "correct": ":center(", "incorrect": [":Center(", ":CENTER("] },
        "distance": { "correct": ":distance(", "incorrect": [":Distance(", ":DISTANCE("] },
        "right": { "correct": ":right(", "incorrect": [":Right(", ":RIGHT("] },
        "rotateAroundAxis": { "correct": ":rotateAroundAxis(", "incorrect": [":RotateAroundAxis("] },
        "up": { "correct": ":up(", "incorrect": [":Up(", ":UP("] },
    },
    "entityMeta": {
        "checkDoorAccess": { "correct": ":checkDoorAccess(", "incorrect": [":CHECKDOORACCESS(", ":CheckDoorAccess("] },
        "clearNetVars": { "correct": ":clearNetVars(", "incorrect": [":CLEARNETVARS(", ":ClearNetVars("] },
        "getDoorOwner": { "correct": ":getDoorOwner(", "incorrect": [":GETDOOROWNER(", ":GetDoorOwner("] },
        "getDoorPartner": { "correct": ":getDoorPartner(", "incorrect": [":GETDOORPARTNER(", ":GetDoorPartner("] },
        "getEntItemDropPos": { "correct": ":getEntItemDropPos(", "incorrect": [":GETENTITEMDROPPOS(", ":GetEntItemDropPos("] },
        "getNetVar": { "correct": ":getNetVar(", "incorrect": [":GETNETVAR(", ":GetNetVar("] },
        "isDoor": { "correct": ":isDoor(", "incorrect": [":ISDOOR(", ":IsDoor("] },
        "isDoorLocked": { "correct": ":isDoorLocked(", "incorrect": [":ISDOORLOCKED(", ":IsDoorLocked("] },
        "isFemale": { "correct": ":isFemale(", "incorrect": [":ISFEMALE(", ":IsFemale("] },
        "isItem": { "correct": ":isItem(", "incorrect": [":ISITEM(", ":IsItem("] },
        "isLocked": { "correct": ":isLocked(", "incorrect": [":ISLOCKED(", ":IsLocked("] },
        "isMoney": { "correct": ":isMoney(", "incorrect": [":ISMONEY(", ":IsMoney("] },
        "isNearEntity": { "correct": ":isNearEntity(", "incorrect": [":ISNEARENTITY(", ":IsNearEntity("] },
        "isProp": { "correct": ":isProp(", "incorrect": [":ISPROP(", ":IsProp("] },
        "isSimfphysCar": { "correct": ":isSimfphysCar(", "incorrect": [":ISSIMFPHYSCAR(", ":IsSimfphysCar("] },
        "keysLock": { "correct": ":keysLock(", "incorrect": [":KEYSLOCK(", ":KeysLock("] },
        "keysOwn": { "correct": ":keysOwn(", "incorrect": [":KEYSOWN(", ":KeysOwn("] },
        "keysUnLock": { "correct": ":keysUnLock(", "incorrect": [":KEYSUNLOCK(", ":KeysUnLock("] },
        "playFollowingSound": { "correct": ":playFollowingSound(", "incorrect": [":PLAYFOLLOWINGSOUND(", ":PlayFollowingSound("] },
        "removeDoorAccessData": { "correct": ":removeDoorAccessData(", "incorrect": [":REMOVEDOORACCESSDATA(", ":RemoveDoorAccessData("] },
        "sendNetVar": { "correct": ":sendNetVar(", "incorrect": [":SENDNETVAR(", ":SendNetVar("] },
        "setKeysNonOwnable": { "correct": ":setKeysNonOwnable(", "incorrect": [":SETKEYSNONOWNABLE(", ":SetKeysNonOwnable("] },
        "setLocked": { "correct": ":setLocked(", "incorrect": [":SETLOCKED(", ":SetLocked("] },
        "setNetVar": { "correct": ":setNetVar(", "incorrect": [":SETNETVAR(", ":SetNetVar("] },
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

def generate_mismatch_report():
    """Generate a comprehensive mismatch report."""
    report_data = defaultdict(lambda: defaultdict(list))

    for meta_type, functions in ALL_FUNCTIONS.items():
        for func_name, patterns in functions.items():
            for incorrect_pattern in patterns["incorrect"]:
                for search_dir in SEARCH_DIRS:
                    incorrect_usage = search_files_simple(incorrect_pattern, search_dir)
                    if incorrect_usage:
                        for usage in incorrect_usage:
                            # Parse the format: file_path:line_number:content
                            if ':' in usage:
                                parts = usage.split(':', 2)
                                if len(parts) >= 3:
                                    file_path = parts[0]
                                    line_num_str = parts[1]
                                    line_content = parts[2]
                                    try:
                                        line_num = int(line_num_str)
                                        report_data[meta_type][func_name].append({
                                            'file': file_path,
                                            'line': line_num,
                                            'content': line_content,
                                            'pattern': incorrect_pattern
                                        })
                                    except ValueError:
                                        # Skip malformed lines
                                        continue

    return report_data

def write_markdown_report(report_data):
    """Write the mismatch report to a markdown file."""
    with open('mismatch_report.md', 'w', encoding='utf-8') as f:
        f.write("# Meta Function Casing Mismatch Report\n\n")
        f.write("This report shows all detected casing mismatches in meta function calls across the Lilia gamemode.\n\n")

        total_issues = 0

        for meta_type, functions in report_data.items():
            if not functions:
                continue

            f.write(f"## {meta_type} Functions\n\n")

            for func_name, issues in functions.items():
                if not issues:
                    continue

                f.write(f"### {func_name}\n\n")
                f.write("**Issues Found:**\n\n")

                for issue in issues:
                    f.write(f"- **File:** `{issue['file']}`\n")
                    f.write(f"  - **Line:** {issue['line']}\n")
                    f.write(f"  - **Content:** `{issue['content']}`\n")
                    f.write(f"  - **Incorrect Pattern:** `{issue['pattern']}`\n\n")

                total_issues += len(issues)

            f.write("\n")

        f.write("## Summary\n\n")
        f.write(f"**Total Issues Found:** {total_issues}\n\n")

        if total_issues == 0:
            f.write("🎉 **No casing mismatches found! All meta functions are correctly cased.**\n")
        else:
            f.write("❌ **Casing issues detected. Please fix the function calls to use correct camelCase.**\n")

def main():
    print("Generating mismatch report...")
    print("=" * 60)

    report_data = generate_mismatch_report()
    write_markdown_report(report_data)

    total_issues = sum(len(issues) for functions in report_data.values() for issues in functions.values())

    print(f"Report generated: mismatch_report.md")
    print(f"Total issues found: {total_issues}")

    if total_issues == 0:
        print("✅ No casing mismatches found!")
    else:
        print("❌ Casing issues detected. Check mismatch_report.md for details.")

if __name__ == "__main__":
    main()

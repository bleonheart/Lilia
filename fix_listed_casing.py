#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Fix casing ONLY for functions listed in the canonical Meta Functions and Hook Functions below.

Behavior:
- Update call sites to match the exact casing provided in the lists
- DO NOT modify function definitions
- DO NOT change unrelated methods
- Meta functions are matched as ":name(" (colon method calls)
- Hook functions are matched inside hook.Run/Call/Add and lia.hook.* with quoted names

Usage:
  python fix_listed_casing.py --dry-run
  python fix_listed_casing.py --write
  python fix_listed_casing.py --limit 200
"""

import argparse
import pathlib
import re
from typing import Dict, Iterable, List, Pattern, Tuple


META_FUNCTIONS = [
    # characterMeta functions
    "addBoost","ban","delete","destroy","doesFakeRecognize","doesRecognize","getAttrib","getBoost","getData","getDisplayedName","getID","getItemWeapon","getPlayer","giveFlags","giveMoney","hasFlags","hasMoney","isBanned","joinClass","kick","kickClass","recognize","removeBoost","save","setAttrib","setData","setFlags","setup","sync","takeFlags","takeMoney","updateAttrib",
    # entityMeta functions  
    "checkDoorAccess","clearNetVars","getDoorOwner","getDoorPartner","getEntItemDropPos","getNetVar","isDoor","isDoorLocked","isFemale","isItem","isLocked","isMoney","isNearEntity","isProp","isSimfphysCar","keysLock","keysOwn","keysUnLock","playFollowingSound","removeDoorAccessData","sendNetVar","setKeysNonOwnable","setLocked","setNetVar",
    # panelMeta functions
    "liaDeleteInventoryHooks","liaListenForInventoryChanges","setScaledPos","setScaledSize",
    # playerMeta functions
    "addMoney","addPart","banPlayer","binaryQuestion","canAfford","canEditVendor","canOverrideView","consumeStamina","createRagdoll","doGesture","doStaredAction","entitiesNearPlayer","forceSequence","getAllLiliaData","getChar","getClassData","getCurrentVehicle","getDarkRPVar","getEyeEnt","getFlags","getItemDropPos","getItemWeapon","getItems","getLiliaData","getMoney","getParts","getPlayTime","getSessionTime","getTrace","getTracedEntity","giveFlags","hasFlags","hasPrivilege","hasSkillLevel","hasWhitelist","isClass","isFaction","isFamilySharedAccount","isInThirdPerson","isNearPlayer","isRunning","isStaff","isStaffOnDuty","isStuck","isVIP","leaveSequence","loadLiliaData","meetsRequiredSkills","networkAnimation","notify","notifyAdmin","notifyAdminLocalized","notifyError","notifyErrorLocalized","notifyInfo","notifyInfoLocalized","notifyLocalized","notifyMoney","notifyMoneyLocalized","notifySuccess","notifySuccessLocalized","notifyWarning","notifyWarningLocalized","playTimeGreaterThan","removePart","removeRagdoll","requestArguments","requestButtons","requestDropdown","requestOptions","requestString","resetParts","restoreStamina","saveLiliaData","setAction","setLiliaData","setNetVar","setRagdolled","setWaypoint","stopAction","syncParts","syncVars","takeFlags","takeMoney",
    # toolGunMeta functions (safe ones only)
    "allowed","buildConVarList","checkObjects","clearObjects","createConVars","deploy","drawHUD","freezeMovement","getClientInfo","getClientNumber","getMode","getSWEP","getServerInfo","holster","leftClick","releaseGhostEntity","reload","rightClick","updateData",
]

HOOK_FUNCTIONS = [
    "AddAdminStickCategory","AddAdminStickSubCategory","AddBarField","AddSection","AddTextField","AddToAdminStickHUD","AddWarning","AdjustCreationData","AdjustPACPartData","AdjustStaminaOffset","AttachPart","BagInventoryReady","BagInventoryRemoved","CalcStaminaChange","CanCharBeTransfered","CanDeleteChar","CanDisplayCharInfo","CanInviteToClass","CanInviteToFaction","CanItemBeTransfered","CanOpenBagPanel","CanOutfitChangeModel","CanPerformVendorEdit","CanPersistEntity","CanPickupMoney","CanPlayerAccessDoor","CanPlayerAccessVendor","CanPlayerChooseWeapon","CanPlayerCreateChar","CanPlayerDropItem","CanPlayerEarnSalary","CanPlayerEquipItem","CanPlayerHoldObject","CanPlayerInteractItem","CanPlayerJoinClass","CanPlayerKnock","CanPlayerLock","CanPlayerModifyConfig","CanPlayerOpenScoreboard","CanPlayerRotateItem","CanPlayerSeeLogCategory","CanPlayerSpawnStorage","CanPlayerSwitchChar","CanPlayerTakeItem","CanPlayerThrowPunch","CanPlayerTradeWithVendor","CanPlayerUnequipItem","CanPlayerUnlock","CanPlayerUseChar","CanPlayerUseCommand","CanPlayerUseDoor","CanPlayerViewInventory","CanRunItemAction","CanSaveData","CharCleanUp","CharDeleted","CharForceRecognized","CharHasFlags","CharListColumns","CharListEntry","CharListExtraDetails","CharListLoaded","CharListUpdated","CharLoaded","CharMenuClosed","CharMenuOpened","CharPostSave","CharPreSave","CharRestored","ChatAddText","ChatParsed","ChatboxPanelCreated","ChatboxTextAdded","CheckFactionLimitReached","ChooseCharacter","ClassOnLoadout","ClassPostLoadout","CommandAdded","CommandRan","ConfigChanged","ConfigureCharacterCreationSteps","CreateCharacter","CreateChat","CreateDefaultInventory","CreateInformationButtons","CreateInventoryPanel","CreateMenuButtons","CreateSalaryTimers","DatabaseConnected","DeleteCharacter","DermaSkinChanged","DiscordRelaySend","DiscordRelayUnavailable","DiscordRelayed","DoModuleIncludes","DoorEnabledToggled","DoorHiddenToggled","DoorLockToggled","DoorOwnableToggled","DoorPriceSet","DoorTitleSet","DrawCharInfo","DrawEntityInfo","DrawLiliaModelView","DrawPlayerRagdoll","ExitStorage","F1MenuClosed","F1MenuOpened","F1OnAddBarField","F1OnAddSection","F1OnAddTextField","FactionOnLoadout","FactionPostLoadout","FetchSpawns","FilterCharModels","ForceRecognizeRange","GetAdjustedPartData","GetAllCaseClaims","GetAttributeMax","GetAttributeStartingMax","GetCharMaxStamina","GetDamageScale","GetDefaultCharDesc","GetDefaultCharName","GetDefaultInventorySize","GetDefaultInventoryType","GetDisplayedDescription","GetDisplayedName","GetDoorInfo","GetEntitySaveData","GetHandsAttackSpeed","GetInjuredText","GetItemDropModel","GetItemStackKey","GetItemStacks","GetMainMenuPosition","GetMaxPlayerChar","GetMaxStartingAttributePoints","GetModelGender","GetMoneyModel","GetOOCDelay","GetPlayTime","GetPlayerDeathSound","GetPlayerPainSound","GetPlayerPunchDamage","GetPlayerPunchRagdollTime","GetPriceOverride","GetRagdollTime","GetSalaryAmount","GetTicketsByRequester","GetVendorSaleScale","GetWarnings","GetWarningsByIssuer","GetWeaponName","HandleItemTransferRequest","InitializeStorage","InitializedConfig","InitializedItems","InitializedKeybinds","InitializedModules","InitializedOptions","InitializedSchema","InteractionMenuClosed","InteractionMenuOpened","InterceptClickItemIcon","InventoryClosed","InventoryDataChanged","InventoryDeleted","InventoryInitialized","InventoryItemAdded","InventoryItemDataChanged","InventoryItemIconCreated","InventoryItemRemoved","InventoryOpened","InventoryPanelCreated","IsCharFakeRecognized","IsCharRecognized","IsRecognizedChatType","IsSuitableForTrunk","IsValid","ItemCombine","ItemDataChanged","ItemDefaultFunctions","ItemDeleted","ItemDraggedOutOfInventory","ItemFunctionCalled","ItemInitialized","ItemPaintOver","ItemQuantityChanged","ItemShowEntityMenu","ItemTransfered","KeyLock","KeyUnlock","KickedFromChar","LiliaLoaded","LiliaTablesLoaded","LoadCharInformation","LoadData","LoadMainMenuInformation","ModifyCharacterModel","ModifyScoreboardModel","NetVarChanged","OnAdminSystemLoaded","OnCharAttribBoosted","OnCharAttribUpdated","OnCharCreated","OnCharDelete","OnCharDisconnect","OnCharFallover","OnCharFlagsGiven","OnCharFlagsTaken","OnCharGetup","OnCharKick","OnCharNetVarChanged","OnCharPermakilled","OnCharRecognized","OnCharTradeVendor","OnCharVarChanged","OnChatReceived","OnCheaterCaught","OnCheaterStatusChanged","OnConfigUpdated","OnCreateItemInteractionMenu","OnCreatePlayerRagdoll","OnCreateStoragePanel","OnDataSet","OnDatabaseLoaded","OnDeathSoundPlayed","OnEntityLoaded","OnEntityPersistUpdated","OnEntityPersisted","OnFontsRefreshed","OnItemAdded","OnItemCreated","OnItemRegistered","OnItemSpawned","OnLoadTables","OnOOCMessageSent","OnOpenVendorMenu","OnPAC3PartTransfered","OnPainSoundPlayed","OnPickupMoney","OnPlayerDropWeapon","OnPlayerEnterSequence","OnPlayerInteractItem","OnPlayerJoinClass","OnPlayerLeaveSequence","OnPlayerLostStackItem","OnPlayerObserve","OnPlayerPurchaseDoor","OnPlayerSwitchClass","OnPrivilegeRegistered","OnPrivilegeUnregistered","OnRequestItemTransfer","OnSalaryAdjust","OnSalaryGiven","OnSavedItemLoaded","OnServerLog","OnThemeChanged","OnTicketClaimed","OnTicketClosed","OnTicketCreated","OnTransferred","OnUsergroupCreated","OnUsergroupPermissionsChanged","OnUsergroupRemoved","OnUsergroupRenamed","OnVendorEdited","OnlineStaffDataReceived","OpenAdminStickUI","OptionChanged","OptionReceived","OverrideFactionDesc","OverrideFactionModels","OverrideFactionName","OverrideSpawnTime","PaintItem","PlayerAccessVendor","PlayerCheatDetected","PlayerDisconnect","PlayerGagged","PlayerLiliaDataLoaded","PlayerLoadedChar","PlayerMessageSend","PlayerModelChanged","PlayerMuted","PlayerShouldAct","PlayerShouldPermaKill","PlayerSpawnPointSelected","PlayerStaminaGained","PlayerStaminaLost","PlayerThrowPunch","PlayerUngagged","PlayerUnmuted","PlayerUseDoor","PopulateAdminStick","PopulateAdminTabs","PopulateConfigurationButtons","PopulateInventoryItems","PostDoorDataLoad","PostDrawInventory","PostLoadData","PostLoadFonts","PostPlayerInitialSpawn","PostPlayerLoadedChar","PostPlayerLoadout","PostPlayerSay","PostScaleDamage","PreCharDelete","PreDoorDataSave","PreDrawPhysgunBeam","PreLiliaLoaded","PrePlayerInteractItem","PrePlayerLoadedChar","PreSalaryGive","PreScaleDamage","RefreshFonts","RegisterPreparedStatements","RemovePart","RemoveWarning","ResetCharacterPanel","RunAdminSystemCommand","SaveData","ScoreboardClosed","ScoreboardOpened","ScoreboardRowCreated","ScoreboardRowRemoved","SendPopup","SetupBagInventoryAccessRules","SetupBotPlayer","SetupDatabase","SetupPACDataFromItems","SetupPlayerModel","SetupQuickMenu","ShouldAllowScoreboardOverride","ShouldBarDraw","ShouldDataBeSaved","ShouldDeleteSavedItems","ShouldDisableThirdperson","ShouldDrawEntityInfo","ShouldDrawPlayerInfo","ShouldDrawWepSelect","ShouldHideBars","ShouldMenuButtonShow","ShouldPlayDeathSound","ShouldPlayPainSound","ShouldRespawnScreenAppear","ShouldShowPlayerOnScoreboard","ShouldSpawnClientRagdoll","ShowPlayerOptions","StorageCanTransferItem","StorageEntityRemoved","StorageInventorySet","StorageItemRemoved","StorageOpen","StorageRestored","StorageUnlockPrompt","StoreSpawns","SyncCharList","ThirdPersonToggled","TicketFrame","TicketSystemClaim","TicketSystemClose","TicketSystemCreated","ToggleLock","TooltipInitialize","TooltipLayout","TooltipPaint","TransferItem","TryViewModel","UpdateEntityPersistence","VendorClassUpdated","VendorEdited","VendorExited","VendorFactionUpdated","VendorItemMaxStockUpdated","VendorItemModeUpdated","VendorItemPriceUpdated","VendorItemStockUpdated","VendorOpened","VendorSynchronized","VendorTradeEvent","VoiceToggled","WarningIssued","WarningRemoved","WeaponCycleSound","WeaponSelectSound","WebImageDownloaded","WebSoundDownloaded","getData","setData"
]


META_LOOKUP: Dict[str, str] = {name.lower(): name for name in META_FUNCTIONS}
HOOK_LOOKUP: Dict[str, str] = {name.lower(): name for name in HOOK_FUNCTIONS}


def find_lua_files(root_dirs: List[pathlib.Path]) -> Iterable[pathlib.Path]:
    for root in root_dirs:
        if not root.exists():
            continue
        for path in root.rglob("*"):
            if path.is_file() and path.suffix.lower() == ".lua":
                yield path


def _collect_function_name_spans(content: str) -> List[Tuple[int, int]]:
    # Collect spans (start,end) of method names in function definitions to avoid editing them
    spans: List[Tuple[int, int]] = []
    # Matches: function Receiver:Name(
    pat1 = re.compile(r"^\s*function\s+[A-Za-z_][\w\.]*\s*[:\.]\s*([A-Za-z_][A-Za-z0-9_]*)\s*\(", re.MULTILINE)
    for m in pat1.finditer(content):
        spans.append((m.start(1), m.end(1)))
    # Matches assigned methods: Receiver.Name = function(
    pat2 = re.compile(r"^\s*[A-Za-z_][\w\.]*\s*[:\.]\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*function\s*\(", re.MULTILINE)
    for m in pat2.finditer(content):
        spans.append((m.start(1), m.end(1)))
    return spans


def _pos_in_spans(pos: int, spans: List[Tuple[int, int]]) -> bool:
    for s, e in spans:
        if s <= pos < e:
            return True
    return False


def fix_meta_calls(content: str) -> Tuple[str, int]:
    total = 0
    # Replace only call sites, not definitions.
    def_spans = _collect_function_name_spans(content)
    pat = re.compile(r":\s*([A-Za-z_][A-Za-z0-9_]*)\b")
    result_parts: List[str] = []
    last_idx = 0
    for m in pat.finditer(content):
        name = m.group(1)
        canonical = META_LOOKUP.get(name.lower())
        if not canonical or canonical == name:
            continue
        # Skip if this position falls within a function definition name span
        if _pos_in_spans(m.start(1), def_spans):
            continue

        # Accept replacement
        print(f"  Changing {name} -> {canonical}")
        result_parts.append(content[last_idx:m.start(1)])
        result_parts.append(canonical)
        last_idx = m.end(1)
        total += 1

    if total == 0:
        return content, 0
    result_parts.append(content[last_idx:])
    return "".join(result_parts), total


def fix_hook_calls(content: str) -> Tuple[str, int]:
    total = 0
    pat = re.compile(r"\b(?:hook\.(?:Run|Call|Add)|lia\.hook\.(?:Run|Call|Add|Emit))\s*\(\s*([\'\"])"  # opening quote
                     r"([A-Za-z_][A-Za-z0-9_]*)"  # name
                     r"\1")
    def _repl(m: re.Match[str]) -> str:
        nonlocal total
        q = m.group(1)
        name = m.group(2)
        canonical = HOOK_LOOKUP.get(name.lower())
        if canonical and canonical != name:
            total += 1
            return m.group(0).replace(f"{q}{name}{q}", f"{q}{canonical}{q}")
        return m.group(0)
    return pat.sub(_repl, content), total


def revert_panel_init_defs(content: str) -> Tuple[str, int]:
    # Revert accidental changes of function PANEL:Init(...) back to :init(...)
    # Only touches function definitions, not calls
    pat = re.compile(r"^(\s*function\s+PANEL\s*:\s*)Init(\s*\()", re.MULTILINE)
    def _repl(m: re.Match[str]) -> str:
        return f"{m.group(1)}init{m.group(2)}"
    updated, n = pat.subn(_repl, content)
    return updated, n


def main() -> int:
    parser = argparse.ArgumentParser(description="Fix casing only for listed functions")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--limit", type=int, default=0)
    parser.add_argument("--revert-panel-init-defs", action="store_true")
    args = parser.parse_args()

    roots = [
        pathlib.Path(r"E:\\GMOD\\Server\\garrysmod\\gamemodes\\metrorp\\modules\\done"),
        pathlib.Path(r"E:\\GMOD\\Server\\garrysmod\\gamemodes\\metrorp\\gitmodules"),
        pathlib.Path(r"E:\\GMOD\\Server\\garrysmod\\gamemodes\\Lilia\\gamemode"),
    ]

    files = list(find_lua_files(roots))
    processed = 0
    changed_files = 0
    total_meta = 0
    total_hooks = 0

    for fp in files:
        if args.limit and processed >= args.limit:
            break
        processed += 1
        try:
            original = fp.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            original = fp.read_text(errors="ignore")

        updated, m1 = fix_meta_calls(original)
        updated, m2 = fix_hook_calls(updated)
        m3 = 0
        if args.revert_panel_init_defs:
            updated, m3 = revert_panel_init_defs(updated)

        if updated != original:
            changed_files += 1
            total_meta += m1
            total_hooks += m2
            extra = f", defs_reverted={m3}" if m3 else ""
            print(f"[CHANGE] {fp} (meta={m1}, hooks={m2}{extra})")
            if args.write:
                with open(fp, "rb") as fbin:
                    raw = fbin.read()
                newline = "\r\n" if b"\r\n" in raw else None
                fp.write_text(updated, encoding="utf-8", newline=newline)

    print(f"Processed {processed} files, changed {changed_files} files.")
    print(f"Meta fixes: {total_meta}, Hook fixes: {total_hooks}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())



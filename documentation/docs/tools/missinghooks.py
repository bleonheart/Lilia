#!/usr/bin/env python3
"""
Hook analysis module for finding missing hook documentation.
"""

import os
import re
from pathlib import Path
from typing import List, Set

# Blacklist of standard Garry's Mod hooks that should not be counted as missing documentation
# These are built-in GMod hooks and don't need Lilia-specific documentation
GMOD_HOOKS_BLACKLIST = {
    "AcceptInput", "AddDeathNotice", "AdjustMouseSensitivity", "AllowPlayerPickup",
    "CalcMainActivity", "CalcVehicleView", "CalcView", "CalcViewModelView",
    "CanCreateUndo", "CanEditVariable", "CanExitVehicle", "CanPlayerEnterVehicle",
    "CanPlayerSuicide", "CanPlayerUnfreeze", "CanProperty", "CanUndo",
    "CaptureVideo", "ChatText", "ChatTextChanged", "CheckPassword",
    "ClientSignOnStateChanged", "CloseDermaMenus", "CreateClientsideRagdoll",
    "CreateEntityRagdoll", "CreateMove", "CreateTeams", "DoAnimationEvent",
    "DoPlayerDeath", "DrawDeathNotice", "DrawMonitors", "DrawOverlay",
    "DrawPhysgunBeam", "EndEntityDriving", "EntityEmitSound", "EntityFireBullets",
    "EntityKeyValue", "EntityNetworkedVarChanged", "EntityRemoved", "EntityTakeDamage",
    "FindUseEntity", "FinishChat", "FinishMove", "ForceDermaSkin",
    "GameContentChanged", "GetDeathNoticeEntityName", "GetFallDamage",
    "GetGameDescription", "GetMotionBlurValues", "GetPreferredCarryAngles",
    "GetTeamColor", "GetTeamNumColor", "GrabEarAnimation", "GravGunOnDropped",
    "GravGunOnPickedUp", "GravGunPickupAllowed", "GravGunPunt", "GUIMouseDoublePressed",
    "GUIMousePressed", "GUIMouseReleased", "HandlePlayerArmorReduction",
    "HandlePlayerDriving", "HandlePlayerDucking", "HandlePlayerJumping",
    "HandlePlayerLanding", "HandlePlayerNoClipping", "HandlePlayerSwimming",
    "HandlePlayerVaulting", "HideTeam", "HUDAmmoPickedUp", "HUDDrawPickupHistory",
    "HUDDrawScoreBoard", "HUDDrawTargetID", "HUDItemPickedUp", "HUDPaint",
    "HUDPaintBackground", "HUDShouldDraw", "HUDWeaponPickedUp", "Initialize",
    "InitPostEntity", "InputMouseApply", "IsSpawnpointSuitable", "KeyPress",
    "KeyRelease", "LoadGModSave", "LoadGModSaveFailed", "MenuStart",
    "MouthMoveAnimation", "Move", "NeedsDepthPass", "NetworkEntityCreated",
    "NetworkIDValidated", "NotifyShouldTransmit", "OnAchievementAchieved",
    "OnChatTab", "OnCleanup", "OnClientLuaError", "OnCloseCaptionEmit",
    "OnContextMenuClose", "OnContextMenuOpen", "OnCrazyPhysics",
    "OnDamagedByExplosion", "OnEntityCreated", "OnEntityWaterLevelChanged",
    "OnGamemodeLoaded", "OnLuaError", "OnNotifyAddonConflict", "OnNPCDropItem",
    "OnNPCKilled", "OnPauseMenuBlockedTooManyTimes", "OnPauseMenuShow",
    "OnPermissionsChanged", "OnPhysgunFreeze", "OnPhysgunPickup",
    "OnPhysgunReload", "OnPlayerChangedTeam", "OnPlayerChat", "OnPlayerHitGround",
    "OnPlayerJump", "OnPlayerPhysicsDrop", "OnPlayerPhysicsPickup",
    "OnReloaded", "OnScreenSizeChanged", "OnSpawnMenuClose", "OnSpawnMenuOpen",
    "OnTextEntryGetFocus", "OnTextEntryLoseFocus", "OnUndo", "OnViewModelChanged",
    "PhysgunDrop", "PhysgunPickup", "PlayerAmmoChanged", "PlayerAuthed",
    "PlayerBindPress", "PlayerButtonDown", "PlayerButtonUp",
    "PlayerCanHearPlayersVoice", "PlayerCanJoinTeam", "PlayerCanPickupItem",
    "PlayerCanPickupWeapon", "PlayerCanSeePlayersChat", "PlayerChangedTeam",
    "PlayerCheckLimit", "PlayerClassChanged", "PlayerConnect", "PlayerDeath", "PlayerDisconnect",
    "PlayerDeathSound", "PlayerDeathThink", "PlayerDisconnected",
    "PlayerDriveAnimate", "PlayerDroppedWeapon", "PlayerEndVoice",
    "PlayerEnteredVehicle", "PlayerFireAnimationEvent", "PlayerFootstep",
    "PlayerFrozeObject", "PlayerHandleAnimEvent", "PlayerHurt",
    "PlayerInitialSpawn", "PlayerJoinTeam", "PlayerLeaveVehicle",
    "PlayerLoadout", "PlayerNoClip", "PlayerPostThink", "PlayerRequestTeam",
    "PlayerSay", "PlayerSelectSpawn", "PlayerSelectTeamSpawn",
    "PlayerSetHandsModel", "PlayerSetModel", "PlayerShouldTakeDamage",
    "PlayerShouldTaunt", "PlayerSilentDeath", "PlayerSpawn",
    "PlayerSpawnAsSpectator", "PlayerSpray", "PlayerStartTaunt",
    "PlayerStartVoice", "PlayerStepSoundTime", "PlayerSwitchFlashlight",
    "PlayerSwitchWeapon", "PlayerTick", "PlayerTraceAttack",
    "PlayerUnfrozeObject", "PlayerUse", "PopulateMenuBar", "PostCleanupMap",
    "PostDraw2DSkyBox", "PostDrawEffects", "PostDrawHUD",
    "PostDrawOpaqueRenderables", "PostDrawPlayerHands", "PostDrawSkyBox",
    "PostDrawTranslucentRenderables", "PostDrawViewModel",
    "PostEntityFireBullets", "PostEntityTakeDamage", "PostGamemodeLoaded",
    "PostPlayerDeath", "PostPlayerDraw", "PostProcessPermitted", "PostRender",
    "PostRenderVGUI", "PostUndo", "PreCleanupMap", "PreDrawEffects",
    "PreDrawHalos", "PreDrawHUD", "PreDrawOpaqueRenderables",
    "PreDrawPlayerHands", "PreDrawSkyBox", "PreDrawTranslucentRenderables",
    "PreDrawViewModel", "PreDrawViewModels", "PreGamemodeLoaded",
    "PrePlayerDraw", "PreRegisterSENT", "PreRegisterSWEP", "PreRender",
    "PreUndo", "PreventScreenClicks", "PropBreak", "RenderScene",
    "RenderScreenspaceEffects", "Restored", "Saved", "ScaleNPCDamage",
    "ScalePlayerDamage", "ScoreboardHide", "ScoreboardShow", "SendDeathNotice",
    "SetPlayerSpeed", "SetupMove", "SetupPlayerVisibility", "SetupSkyboxFog",
    "SetupWorldFog", "ShouldCollide", "ShouldDrawLocalPlayer", "ShowHelp",
    "ShowSpare1", "ShowSpare2", "ShowTeam", "ShutDown", "SpawniconGenerated",
    "SpawnMenuCreated", "StartChat", "StartCommand", "StartEntityDriving",
    "StartGame", "Think", "Tick", "TranslateActivity", "UpdateAnimation",
    "VariableEdited", "VehicleMove", "VGUIMousePressAllowed", "VGUIMousePressed",
    "WeaponEquip", "WorkshopDownloadedFile", "WorkshopDownloadFile",
    "WorkshopDownloadProgress", "WorkshopDownloadTotals", "WorkshopEnd",
    "WorkshopExtractProgress", "WorkshopStart", "WorkshopSubscriptionsChanged",
    "WorkshopSubscriptionsMessage",     "WorkshopSubscriptionsProgress",
    # Additional spawn menu and tool menu hooks
    "AddGamemodeToolMenuCategories", "AddGamemodeToolMenuTabs", "AddToolMenuCategories",
    "AddToolMenuTabs", "CanArmDupe", "CanDrive", "CanTool", "ContentSidebarSelection",
    "ContextMenuClosed", "ContextMenuCreated", "ContextMenuEnabled", "ContextMenuOpen",
    "ContextMenuOpened", "ContextMenuShowTool", "OnRevertSpawnlist", "OnSaveSpawnlist",
    "OpenToolbox", "PaintNotes", "PaintWorldTips", "PersistenceLoad", "PersistenceSave",
    "PlayerGiveSWEP", "PlayerSpawnedEffect", "PlayerSpawnedNPC", "PlayerSpawnedProp",
    "PlayerSpawnedRagdoll", "PlayerSpawnedSENT", "PlayerSpawnedSWEP", "PlayerSpawnedVehicle",
    "PlayerSpawnEffect", "PlayerSpawnNPC", "PlayerSpawnObject", "PlayerSpawnProp",
    "PlayerSpawnRagdoll", "PlayerSpawnSENT", "PlayerSpawnSWEP", "PlayerSpawnVehicle",
    "PopulateContent", "PopulateEntities", "PopulateNPCs", "PopulatePropMenu",
    "PopulateToolMenu", "PopulateVehicles", "PopulateWeapons", "PostReloadToolsMenu",
    "PreRegisterTOOL", "PreReloadToolsMenu", "SpawnlistContentChanged",
    "SpawnlistOpenGenericMenu", "SpawnMenuEnabled", "SpawnmenuIconMenuOpen",
    "SpawnMenuOpen", "SpawnMenuOpened",
    # CAMI (Compatibility and Mod Integration) hooks
    "CAMI.OnPrivilegeRegistered", "CAMI.OnPrivilegeUnregistered", "CAMI.OnUsergroupRegistered",
    "CAMI.OnUsergroupUnregistered", "CAMI.PlayerHasAccess", "CAMI.PlayerUsergroupChanged",
    "CAMI.SteamIDUsergroupChanged",
    # Additional addon hooks
    "server_addban", "server_removeban", "serverguard.RankPermissionGiven",
    "serverguard.RankPermissionTaken", "serverguard.RanksLoaded", "VC_canAddMoney",
    "VC_canAfford", "VC_canRemoveMoney", "ULibGroupAccessChanged", "SAM.CanRunCommand",
    "SAM.RankPermissionGiven", "SAM.RankPermissionTaken", "PAC3RegisterEvents",
    "PermaProps.CanPermaProp", "PermaProps.OnEntityCreated", "PermaProps.OnEntitySaved",
    "simfphysUse", "CheckValidSit", "simfphysPhysicsCollide"
}

# Whitelist of framework hooks that are documented but may not be explicitly registered
# These are legitimate hooks that are part of the Lilia framework and should not be flagged as unused
FRAMEWORK_HOOKS_WHITELIST = {
    "AddEssentialItems", "AddFactionEquipment", "AnalyzeCharacterListChanges",
    "ApplyBackgroundEffects", "ApplyCharacterSettings", "ApplyChatFilters",
    "ApplyContentFilters", "ApplyEconomicModifiers", "ApplyFactionModifications",
    "ApplyMenuPreferences", "ApplyMenuTheme", "ApplyServerModifiers",
    "ApplyStartingBonuses", "ArchiveCharacterData", "AreClassesRelated",
    "AttemptDiscordRecovery", "CalculateDynamicFactionLimit", "CalculateEffectiveMemberCount",
    "CalculatePerformanceBonus", "CanLockDoor", "CanSetDoorPrice", "CanToggleDoorOwnable",
    "CanToggleDoorVisibility", "CancelPendingCharacterOperations", "CharacterMeetsPrerequisites",
    "CheckAdvancedFlagInheritance", "CheckCommandAbuse", "CheckConditionalFlags",
    "CheckDeletionTriggers", "CheckFactionClassFlags", "CheckFlagInheritance",
    "CleanupCharacterPreviews", "CleanupCharacterReferences", "CleanupDoorOwnership",
    "CleanupQuestData", "CleanupQuestOnCharDelete", "CleanupTemporaryPanels",
    "ClearCharacterCache", "ConfigureMainChatPanel", "CreateAppearanceStep",
    "CreateBackgroundStoryStep", "CreateCategoryTabs", "CreateCharacterBackup",
    "CreateCustomInventory", "CreateEquipmentStep", "CreateFactionSpecificStep",
    "CreateReviewStep", "CreateSearchBar", "CreateSkillsStep", "CustomCharacterValidation",
    "EnhanceHUDWithCharacterInfo", "ExecutePostCommandActions", "ExecuteTriggerAction",
    "FactionWouldUnbalanceServer", "FilterDiscordContent", "FinalCharacterValidation",
    "GenerateCharacterAnalytics", "GenerateCharacterGoals", "GetBackgroundBonuses",
    "GetBaseSalary", "GetCharacterChanges", "GetEquippedWeight", "GetFactionIcon",
    "GetFactionMemberStats", "GetFactionModels", "GetFactionSalaryMultiplier",
    "GetInventoryWeight", "GetPlayerCharacterCount", "GetPlayerProtectionLevel",
    "GetRecentPlayerCommands", "GetStartingEquipment", "GetTotalAchievements",
    "GetTraitBonuses", "GetXPForLevel", "HandleCharacterSwitch", "HandleCommandAbuse",
    "HandleMechanicalLock", "HandleSoulboundItems", "HandleSpecialCharacterSelection",
    "HasCharacterChanged", "HasDoorTogglePermission", "HasFactionJoinOverride",
    "HideDoorWithEffect", "ITEM", "InitializeAnalyticsTracking", "InitializeCharacterData",
    "InitializeCharacterPermissions", "InitializeCharacterPreviews", "InitializeCharacterRelationships",
    "InitializeChatFilters", "InitializeMenuSounds", "IsDoorOwner", "IsFactionAlly",
    "IsFactionHostile", "IsInFactionQueue", "IsNameTaken", "IsOnFactionRecruitmentCooldown",
    "IsSpamCommand", "IsValidCharacterModel", "IsValidSkin", "LoadCharacterMenuPreferences",
    "LoadDataFromFile", "LogCharacterCreation", "LogFailedSelection", "LogSuccessfulSelection",
    "MODULE", "MeetsFactionDiversityRequirements", "NotifyStaffOfDiscordOutage",
    "ParseChatMessageArgs", "PreProcessCharacterData", "ProcessDiscordChatMessage",
    "RemoveCharacterFromGroups", "RemoveFromGroup", "ResetCameraState", "RunDatabaseMigrations",
    "SanitizeArguments", "SaveCharacterMenuPreferences", "SaveEntityData", "SaveSkinPreference",
    "SendCharacterSelectionConfirmation", "SendCommandAnalytics", "SendCreationAnalytics",
    "SetupAccessibilityFeatures", "SetupAdvancedUI", "SetupAutoSave", "SetupCharacterPreview",
    "SetupCustomEventHandlers", "SetupKeyboardShortcuts", "SetupRealTimeUpdates",
    "SetupStepNavigation", "SetupWelcomeSequence", "ShowNewPlayerTutorial", "StoreCommandHistory",
    "TrackMenuSession", "TriggerDoorAlarm", "UpdateCharacterPreview", "UpdateCharacterRelationships",
    "UpdateCharacterSelectionStats", "UpdatePlayerCommandStats", "UpdateServerSelectionStats",
    "ValidateCharacterCreation", "ValidateCharacterData", "ValidateCharacterForSave",
    "ValidateCommandData", "ValidateConfigurationChange", "ValidateDatabaseSchema",
    "ValidateDeletionRequest", "ValidateDiscordEmbed", "ValidateDiscordMessage",
    "ValidateDoorPrice", "ValidateHUDInfo", "ValidateModuleStructure", "ValidateRestoredCharacter",
    "AddWarning", "ChooseCharacter", "CreateCharacter", "CreateSalaryTimers", "DeleteCharacter",
    "FetchSpawns", "ForceRecognizeRange", "GetAllCaseClaims", "GetTicketsByRequester",
    "GetWarningsByIssuer", "InitializeStorage", "OnPlayerDropWeapon", "PlayerShouldAct",
    "RemoveWarning", "SendPopup", "StorageItemRemoved", "StoreSpawns", "SyncCharList", "ToggleLock"
}


def scan_hooks(base_path: str) -> List[str]:
    """Scan Lua files for hook.Add and hook.Run calls"""
    hooks_found = set()
    base_path = Path(base_path)

    # Scan all .lua files
    for root, dirs, files in os.walk(base_path):
        # Skip certain directories
        dirs[:] = [d for d in dirs if d not in ['node_modules', '.git']]

        for file in files:
            if file.endswith('.lua'):
                file_path = os.path.join(root, file)
                file_hooks = _extract_hooks_from_file(file_path)
                hooks_found.update(file_hooks)

    return sorted(list(hooks_found))


def _extract_hooks_from_file(file_path: str) -> Set[str]:
    """Extract hooks from a single Lua file"""
    hooks = set()

    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception as e:
        print(f"Warning: Could not read {file_path}: {e}")
        return hooks

    # Pattern for hook.Add calls
    # Matches: hook.Add("hook_name", ...)
    hook_add_pattern = r'hook\.Add\s*\(\s*([\'"`])([^\'"`]+)\1'

    # Pattern for hook.Run calls
    # Matches: hook.Run("hook_name", ...)
    hook_run_pattern = r'hook\.Run\s*\(\s*([\'"`])([^\'"`]+)\1'

    # Find hook.Add calls
    for match in re.finditer(hook_add_pattern, content):
        hook_name = match.group(2)
        if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
            hooks.add(hook_name.strip())

    # Find hook.Run calls
    for match in re.finditer(hook_run_pattern, content):
        hook_name = match.group(2)
        if hook_name and hook_name.strip() not in GMOD_HOOKS_BLACKLIST:
            hooks.add(hook_name.strip())

    return hooks


def read_documented_hooks(hooks_doc_path: str) -> List[str]:
    """Read documented hooks from the hooks documentation file"""
    documented_hooks = set()
    hooks_doc_path = Path(hooks_doc_path)

    if not hooks_doc_path.exists():
        print(f"Warning: Hooks documentation file not found: {hooks_doc_path}")
        return []

    try:
        with open(hooks_doc_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception as e:
        print(f"Warning: Could not read hooks documentation: {e}")
        return []

    lines = content.split('\n')

    for line in lines:
        # Look for hook names in backticks - be more specific about what constitutes a hook name
        # Only match backticks that contain what looks like a hook name (starts with capital letter, contains only alphanumeric and underscores)
        hook_match = re.search(r'`([A-Z][A-Za-z0-9_]+)`', line)
        if hook_match:
            hook_name = hook_match.group(1).strip()
            if hook_name and len(hook_name) > 2:  # Filter out very short matches
                documented_hooks.add(hook_name)

        # Check for markdown headers that look like hook names
        # Only match headers that start with capital letter and look like hook names
        header_match = re.search(r'^###+\s+([A-Z][A-Za-z0-9_]+)\s*$', line)
        if header_match:
            header_text = header_match.group(1).strip()
            # Only add if it looks like a hook name (starts with capital, reasonable length)
            if len(header_text) > 2 and re.search(r'^[A-Z][A-Za-z0-9_]+$', header_text):
                documented_hooks.add(header_text)

    return sorted(list(documented_hooks))

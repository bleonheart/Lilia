local fontFiles = {"content/resource/fonts/montserrat-regular.ttf", "content/resource/fonts/montserrat-medium.ttf", "content/resource/fonts/montserrat-bold.ttf"}
local networkStrings = {"liaWeaponOverrideUpdate", "liaWeaponOverrideSync", "liaActBar", "liaAdminModeSwapCharacter", "liaAnimationStatus", "liaArgumentsRequest", "liaArgumentsRequestCancel", "liaAssureClientSideAssets", "liaAttributeData", "liaBigTableAck", "liaBinaryQuestionRequest", "liaBinaryQuestionRequestCancel", "liaPopupQuestionRequest", "liaBlindFade", "liaBlindTarget", "liaButtonRequest", "liaCfgList", "liaCfgSet", "liaCharChoose", "liaCharCreate", "liaCharDelete", "liaCharDeleted", "liaCharInfo", "liaCharKick", "liaCharList", "liaCharRequest", "liaCharSet", "liaCharVar", "liaCharacterData", "liaCharacterInvList", "liaChatMsg", "liaCheckHack", "liaCheckSeed", "liaClassUpdate", "liaCmdArgPrompt", "liaCommandData", "liaDataSync", "liaDisplayCharList", "liaDoorMenu", "liaDoorPerm", "liaDoorDataUpdate", "liaDoorDataBulk", "liaEmitUrlSound", "liaGlobalVar", "liaGroupPermChanged", "liaGroupsAdd", "liaGroupsRemove", "liaGroupsRename", "liaGroupsRequest", "liaGroupsSetPerm", "liaInsertKeyPressed", "liaInvAct", "liaInvData", "liaInvQuantity", "liaInventoryAdd", "liaInventoryData", "liaInventoryDelete", "liaInventoryInit", "liaInventoryRemove", "liaItemDelete", "liaItemInstance", "liaItemRotate", "liaKeybindServer", "liaMessageData", "liaModifyCharacterFlags", "liaModifyFlags", "liaNetDel", "liaNetLocal", "liaNetStreamData", "liaNetVar", "liaNotificationData", "liaNotifyLocal", "liaOpenInvMenu", "liaOpenPanelBrowser", "liaOptionsRequest", "liaOptionsRequestCancel", "liaPacPartAdd", "liaPacPartRemove", "liaPacPartReset", "liaPacSync", "liaPlayerInteractCategories", "liaPlayerInteractSync", "liaPlayerRespawn", "liaProvideInteractOptions", "liaRegenChat", "liaRemoveFOne", "liaRequestDropdown", "liaRequestDropdownCancel", "liaRequestInteractOptions", "liaRequestOnlineStaffData", "liaReturnFromEntity", "liaRunInteraction", "liaSendTableUI", "liaSeqSet", "liaServerChatAddText", "liaServerChatAddTextShadowed", "liaSetMainCharacter", "liaSetWaypoint", "liaSitSitFacing", "liaStaffDiscordPrompt", "liaStaffDiscordResponse", "liaStorageOpen", "liaStorageSync", "liaStorageSyncRequest", "liaStringRequest", "liaStringRequestCancel", "liaWeaponRuntimeOverrideUpdate", "liaWeaponRuntimeOverrideSync", "liaWeaponRuntimeOverrideReset", "liaSyncGesture", "liaTeleportToEntity", "liaTransferItem", "liaUpdateAdminGroups", "liaUpdateAdminPrivileges", "liaVendorEdit", "liaVendorSyncPresets", "liaVendorPropertySync", "liaVerifyCheatsResponse", "liaWaypointReached", "liaWorkshopDownloaderInfo", "liaWorkshopDownloaderRequest", "liaWorkshopDownloaderStart", "liaRemoveFeaturePosition"}
table.RemoveByValue(networkStrings, "liaDisplayCharList")
DeriveGamemode("sandbox")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("core/libraries/core/loader.lua")
include("shared.lua")
for _, fontFile in ipairs(fontFiles) do
    resource.AddSingleFile(fontFile)
end

for _, netString in ipairs(networkStrings) do
    util.AddNetworkString(netString)
end

resource.AddWorkshop("3527535922")

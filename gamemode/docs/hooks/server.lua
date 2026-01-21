function AddWarning(charID, warned, warnedSteamID, timestamp, message, warner, warnerSteamID, severity)
end

function CollectDoorDataFields(extras)
end

function CanItemBeTransfered(item, inventory, VendorInventoryMeasure, client)
end

function CanPersistEntity(entity)
end

function CanPlayerAccessDoor(client, door, access)
end

function CanPlayerAccessVendor(client, vendor)
end

function CanPlayerDropItem(client, item)
end

function CanPlayerEarnSalary(client)
end

function CanPlayerEquipItem(client, item)
end

function CanPlayerHoldObject(client, entity)
end

function CanPlayerInteractItem(client, action, item, data)
end

function CanPlayerLock(client, door)
end

function CanPlayerSeeLogCategory(client, category)
end

function CanPlayerSpawnStorage(client, entity, info)
end

function CanPlayerSwitchChar(client, currentCharacter, newCharacter)
end

function CanPlayerTakeItem(client, item)
end

function CanPlayerTradeWithVendor(client, vendor, itemType, isSellingToVendor)
end

function CanPlayerUnequipItem(client, item)
end

function CanPlayerUnlock(client, door)
end

function CanPlayerUseChar(client, character)
end

function CanPlayerUseDoor(client, door)
end

function CanSaveData(ent, inventory)
end

function CreateSalaryTimers()
end

function CharCleanUp(character)
end

function CharDeleted(client, character)
end

function CharListExtraDetails(client, entry, stored)
end

function CharPostSave(character)
end

function CharPreSave(character)
end

function CheckFactionLimitReached(faction, character, client)
end

function DatabaseConnected()
end

function DiscordRelaySend(embed)
end

function DiscordRelayUnavailable()
end

function DiscordRelayed(embed)
end

function DoorEnabledToggled(client, door, newState)
end

function DoorHiddenToggled(client, entity, newState)
end

function DoorLockToggled(client, door, state)
end

function DoorOwnableToggled(client, door, newState)
end

function DoorPriceSet(client, door, price)
end

function DoorTitleSet(client, door, name)
end

function FetchSpawns()
end

function GetAllCaseClaims()
end

function GetBotModel(client, faction)
end

function GetDamageScale(hitgroup, dmgInfo, damageScale)
end

function GetDefaultInventoryType(character)
end

function GetEntitySaveData(ent)
end

function GetOOCDelay(speaker)
end

function GetPlayTime(client)
end

function GetPlayerDeathSound(client, isFemale)
end

function GetPlayerPainSound(client, paintype, isFemale)
end

function GetPlayerRespawnLocation(client, character)
end

function GetPlayerSpawnLocation(client, character)
end

function GetPrestigePayBonus(client, char, pay, faction, class)
end

function GetSalaryAmount(client, faction, class)
end

function GetTicketsByRequester(steamID)
end

function GetWarnings(charID)
end

function GetWarningsByIssuer(steamID)
end

function HandleItemTransferRequest(client, itemID, x, y, invID)
end

function InventoryDeleted(instance)
end

function ItemCombine(client, item, target)
end

function ItemDeleted(instance)
end

function ItemFunctionCalled(item, method, client, entity, results)
end

function ItemTransfered(context)
end

function KeyLock(client, door, time)
end

function KeyUnlock(client, door, time)
end

function KickedFromChar(characterID, isCurrentChar)
end

function LiliaTablesLoaded()
end

function LoadData()
end

function ModifyCharacterModel(context, character)
end

function OnCharAttribBoosted(client, character, attribID, boostID, data)
end

function OnCharAttribUpdated(client, character, key, oldValue)
end

function OnCharCreated(client, character, originalData)
end

function OnCharDelete(client, id)
end

function OnCharDisconnect(client, character)
end

function OnCharFlagsGiven(ply, character, addedFlags)
end

function OnCharFlagsTaken(ply, character, removedFlags)
end

function OnCharKick(character, client)
end

function OnCharNetVarChanged(character, key, oldVar, value)
end

function OnCharPermakilled(character, time)
end

function OnCharRecognized(client, target)
end

function OnCharTradeVendor(client, vendor, item, isSellingToVendor, character, itemType, isFailed)
end

function OnCheaterCaught(client)
end

function OnDataSet(key, value, gamemode, map)
end

function OnDatabaseLoaded()
end

function OnDeathSoundPlayed(client, deathSound)
end

function OnEntityLoaded(ent, data)
end

function OnEntityPersistUpdated(ent, data)
end

function OnEntityPersisted(ent, entData)
end

function OnItemSpawned(itemEntity)
end

function OnLoadTables()
end

function OnNPCTypeSet(client, npc, npcID, filteredData)
end

function OnOOCMessageSent(client, message)
end

function OnPainSoundPlayed(entity, painSound)
end

function OnPickupMoney(activator, moneyEntity)
end

function OnPlayerEnterSequence(client, sequenceName, callback, time, noFreeze)
end

function OnPlayerInteractItem(client, action, item, result, data)
end

function OnPlayerJoinClass(target, newClass, oldClass)
end

function OnPlayerLeaveSequence(client)
end

function OnPlayerLostStackItem(itemTypeOrItem)
end

function OnPlayerObserve(client, state)
end

function OnPlayerRagdolled(client, ragdoll)
end

function OnPlayerSwitchClass(client, class, oldClass)
end

function OnRequestItemTransfer(inventoryPanel, itemID, targetInventoryID, x, y)
end

function OnSalaryAdjust(client)
end

function OnSalaryGiven(client, char, pay, faction, class)
end

function OnSetUsergroup(sid, new, source, ply)
end

function OnSavedItemLoaded(loadedItems)
end

function OnServerLog(client, logType, logString, category)
end

function OnTicketClaimed(client, requester, ticketMessage)
end

function OnTicketClosed(client, requester, ticketMessage)
end

function OnTicketCreated(noob, message)
end

function OnUsergroupPermissionsChanged(groupName, permissions)
end

function OnVendorEdited(client, vendor, key)
end

function OnVoiceTypeChanged(client)
end

function OptionReceived(client, key, value)
end

function PlayerAccessVendor(client, vendor)
end

function PlayerCheatDetected(client)
end

function PlayerGagged(target, admin)
end

function PlayerLiliaDataLoaded(client)
end

function PlayerLoadedChar(client, character, currentChar)
end

function PlayerMessageSend(speaker, chatType, text, anonymous, receivers)
end

function PlayerModelChanged(client, value)
end

function PlayerMuted(target, admin)
end

function PlayerShouldPermaKill(client, inflictor, attacker)
end

function PlayerSpawnPointSelected(client, pos, ang)
end

function PlayerStaminaGained(client)
end

function PlayerStaminaLost(client)
end

function PlayerUngagged(target, admin)
end

function PlayerUnmuted(target, admin)
end

function PlayerUseDoor(client, door)
end

function PostDoorDataLoad(ent, doorData)
end

function PostLoadData()
end

function PostPlayerInitialSpawn(client)
end

function PostPlayerLoadedChar(client, character, currentChar)
end

function PostPlayerLoadout(client)
end

function PostPlayerSay(client, message, chatType, anonymous)
end

function PostScaleDamage(hitgroup, dmgInfo, damageScale)
end

function PreCharDelete(id)
end

function PreDoorDataSave(door, doorData)
end

function PrePlayerInteractItem(client, action, item)
end

function PrePlayerLoadedChar(client, character, currentChar)
end

function PreSalaryGive(client, char, pay, faction, class)
end

function PreScaleDamage(hitgroup, dmgInfo, damageScale)
end

function RemoveWarning(charID, index)
end

function SaveData()
end

function SendPopup(noob, message)
end

function SetupBotPlayer(client)
end

function SetupDatabase()
end

function SetupPlayerModel(modelEntity, character)
end

function ShouldDataBeSaved()
end

function ShouldOverrideSalaryTimers()
end

function ShouldDeleteSavedItems()
end

function ShouldPlayDeathSound(client, deathSound)
end

function ShouldPlayPainSound(entity, painSound)
end

function ShouldSpawnClientRagdoll(client)
end

function StorageCanTransferItem(client, storage, item)
end

function StorageEntityRemoved(storageEntity, inventory)
end

function StorageInventorySet(entity, inventory, isCar)
end

function StorageItemRemoved()
end

function StorageRestored(ent, inventory)
end

function StoreSpawns(spawns)
end

function SyncCharList(client)
end

function TicketSystemClaim(client, requester, ticketMessage)
end

function TicketSystemClose(client, requester, ticketMessage)
end

function ToggleLock(client, door, state)
end

function UpdateEntityPersistence(vendor)
end

function VendorClassUpdated(vendor, id, allowed)
end

function VendorEdited(liaVendorEnt, key)
end

function VendorFactionBuyScaleUpdated(vendor, factionID, scale)
end

function VendorFactionSellScaleUpdated(vendor, factionID, scale)
end

function VendorFactionUpdated(vendor, id, allowed)
end

function VendorItemMaxStockUpdated(vendor, itemType, value)
end

function VendorItemModeUpdated(vendor, itemType, value)
end

function VendorItemPriceUpdated(vendor, itemType, value)
end

function VendorItemStockUpdated(vendor, itemType, value)
end

function VendorMessagesUpdated(vendor)
end

function VendorSynchronized(vendor)
end

function VendorTradeEvent(client, vendor, itemType, isSellingToVendor)
end

function WarningIssued(client, target, reason, severity, count, warnerSteamID, targetSteamID)
end

function WarningRemoved(client, targetClient, warningData, context1, context2, context3)
end

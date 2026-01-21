function AdjustCreationData(client, data, newData, originalData)
end

function AdjustPACPartData(wearer, id, data)
end

function AdjustStaminaOffset(client, offset)
end

function AdvDupe_FinishPasting(tbl)
end

function AttachPart(client, id)
end

function BagInventoryReady(bagItem, inventory)
end

function BagInventoryRemoved(bagItem, inventory)
end

function CalcStaminaChange(client)
end

function CanCharBeTransfered(tChar, faction, oldFaction)
end

function CanInviteToClass(client, target)
end

function CanInviteToFaction(client, target)
end

function CanOutfitChangeModel(item)
end

function CanPerformVendorEdit(client, vendor)
end

function CanPickupMoney(activator, moneyEntity)
end

function CanPlayerChooseWeapon(weapon)
end

function CanPlayerCreateChar(client, data)
end

function CanPlayerJoinClass(client, class, info)
end

function CanPlayerKnock(client, door)
end

function CanPlayerModifyConfig(client, key)
end

function CanPlayerRotateItem(client, item)
end

function CanPlayerThrowPunch(client)
end

function CanPlayerUseCommand(client, command)
end

function CanRunItemAction(tempItem, key)
end

function CharForceRecognized(ply, range)
end

function CharHasFlags(client, flags)
end

function ChatParsed(client, chatType, message, anonymous)
end

function CommandAdded(command, data)
end

function ConfigChanged(key, value, oldValue, client)
end

function DoModuleIncludes(path, MODULE)
end

function ForceRecognizeRange(ply, range, fakeName)
end

function GetAttributeMax(client, id)
end

function GetAttributeStartingMax(client, attribute)
end

function GetCharMaxStamina(char)
end

function GetDefaultCharDesc(client, faction, data)
end

function GetDefaultCharName(client, faction, data)
end

function GetDefaultInventorySize(client, char)
end

function GetDisplayedName(client, chatType)
end

function GetHandsAttackSpeed(client, defaultDelay)
end

function GetItemDropModel(itemTable, itemEntity)
end

function GetMaxPlayerChar(client)
end

function GetMaxStartingAttributePoints(client, count)
end

function GetModelGender(model)
end

function GetMoneyModel(amount)
end

function GetNPCDialogOptions(client, npc, canCustomize)
end

function GetPlayerPunchDamage(client, damage, context)
end

function GetPlayerPunchRagdollTime(client, target)
end

function GetPriceOverride(client, vendor, uniqueID, price, isSellingToVendor)
end

function GetRagdollTime(client, time)
end

function GetVendorSaleScale(vendor)
end

function GetWeaponName(weapon)
end

function InitializeStorage(entity)
end

function InitializedConfig()
end

function InitializedItems()
end

function InitializedKeybinds()
end

function InitializedModules()
end

function InitializedOptions()
end

function InitializedSchema()
end

function InventoryDataChanged(instance, key, oldValue, value)
end

function InventoryInitialized(instance)
end

function InventoryItemAdded(inventory, item)
end

function InventoryItemRemoved(inventory, instance, preserveItem)
end

function IsCharFakeRecognized(character, id)
end

function IsCharRecognized(a, id)
end

function IsRecognizedChatType(chatType)
end

function IsSuitableForTrunk(ent)
end

function ItemDataChanged(item, key, oldValue, newValue)
end

function ItemDefaultFunctions(funcs)
end

function ItemInitialized(item)
end

function ItemQuantityChanged(item, oldValue, quantity)
end

function LiliaLoaded()
end

function NetVarChanged(client, key, oldValue, value)
end

function OnAdminSystemLoaded(adminData, metadata)
end

function OnCharGetup(target, entity)
end

function OnCharVarChanged(character, varName, oldVar, newVar)
end

function OnConfigUpdated(key, oldValue, value)
end

function OnItemAdded(owner, item)
end

function OnItemCreated(itemTable, itemEntity)
end

function OnItemOverridden(item, overrides)
end

function OnItemRegistered(ITEM)
end

function OnLocalizationLoaded()
end

function OnPAC3PartTransfered(part)
end

function OnPlayerPurchaseDoor(client, door, selling)
end

function OnPlayerDroppedItem(client, spawnedItem)
end

function OnPlayerRotateItem(client, item, newRot)
end

function OnPlayerTakeItem(client, item)
end

function OnPrivilegeRegistered(privilege, context1, context2, context3)
end

function OnPrivilegeUnregistered(privilege, context)
end

function OnThemeChanged(themeName, useTransition)
end

function OnTransferred(target)
end

function OnUsergroupCreated(groupName, data)
end

function OnUsergroupRemoved(groupName)
end

function OnUsergroupRenamed(oldName, newName)
end

function OptionAdded(key, name, option)
end

function OptionChanged(key, old, value)
end

function OverrideFactionDesc(uniqueID, desc)
end

function OverrideFactionModels(uniqueID, models)
end

function OverrideFactionName(uniqueID, name)
end

function OverrideSpawnTime(ply, baseTime)
end

function PlayerThrowPunch(client)
end

function PreLiliaLoaded()
end

function RemovePart(client, id)
end

function SetupBagInventoryAccessRules(inventory)
end

function SetupPACDataFromItems()
end

function TryViewModel(entity)
end

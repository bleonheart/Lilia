function AddBarField(sectionName, fieldName, labelText, minFunc, maxFunc, valueFunc)
end

function AddSection(sectionName, color, priority, location)
end

function AddTextField(sectionName, fieldName, labelText, valueFunc)
end

function AddToAdminStickHUD(client, target, information)
end

function AdminPrivilegesUpdated()
end

function AdminStickAddModels(allModList, tgt)
end

function CanDeleteChar(client, character)
end

function CanDisplayCharInfo(name)
end

function CanOpenBagPanel(item)
end

function CanPlayerOpenScoreboard(client)
end

function CanTakeEntity(client, targetEntity, itemUniqueID)
end

function CanPlayerViewInventory()
end

function CharListColumns(columns)
end

function CharListEntry(entry, row)
end

function CharListLoaded(newCharList)
end

function CharListUpdated(oldCharList, newCharList)
end

function CharLoaded(character)
end

function CharMenuClosed()
end

function CharMenuOpened(charMenu)
end

function CharRestored(character)
end

function ChatAddText(text, ...)
end

function ChatboxPanelCreated(panel)
end

function ChatboxTextAdded(panel)
end

function ChooseCharacter(id)
end

function CommandRan(client, command, arguments, results)
end

function ConfigureCharacterCreationSteps(creationPanel)
end

function CreateCharacter(data)
end

function CreateChatboxPanel()
end

function CreateDefaultInventory(character)
end

function CreateInformationButtons(pages)
end

function CreateInventoryPanel(inventory, parent)
end

function CreateMenuButtons(tabs)
end

function DeleteCharacter(id)
end

function DermaSkinChanged(newSkin)
end

function DisplayPlayerHUDInformation(client, hudInfos)
end

function DoorDataReceived(door, syncData)
end

function DrawCharInfo(client, character, info)
end

function DrawEntityInfo(e, a, pos)
end

function DrawItemEntityInfo(itemEntity, item, infoTable, alpha)
end

function DrawLiliaModelView(client, entity)
end

function DrawPlayerRagdoll(entity)
end

function F1MenuClosed()
end

function F1MenuOpened(f1MenuPanel)
end

function FilterCharModels(models)
end

function FilterDoorInfo(entity, doorData, doorInfo)
end

function GetAdjustedPartData(wearer, id)
end

function GetCharacterCreateButtonTooltip(client, currentChars, maxChars)
end

function GetCharacterDisconnectButtonTooltip(client)
end

function GetCharacterDiscordButtonTooltip(client, discordURL)
end

function GetCharacterLoadButtonTooltip(client)
end

function GetCharacterLoadMainButtonTooltip(client)
end

function GetCharacterMountButtonTooltip(client)
end

function GetCharacterReturnButtonTooltip(client)
end

function GetCharacterStaffButtonTooltip(client, hasStaffChar)
end

function GetCharacterWorkshopButtonTooltip(client, workshopURL)
end

function GetAdminESPTarget(ent, client)
end

function GetAdminStickLists(tgt, lists)
end

function GetDisplayedDescription(client, isHUD)
end

function GetDoorInfo(entity, doorData, doorInfo)
end

function GetDoorInfoForAdminStick(target, extraInfo)
end

function GetInjuredText(c)
end

function GetMainCharacterID()
end

function GetMainMenuPosition(character)
end

function InteractionMenuClosed()
end

function InteractionMenuOpened(frame)
end

function InterceptClickItemIcon(inventoryPanel, itemIcon, keyCode)
end

function InventoryClosed(inventoryPanel, inventory)
end

function InventoryItemDataChanged(item, key, oldValue, newValue, inventory)
end

function InventoryItemIconCreated(icon, item, inventoryPanel)
end

function InventoryOpened(panel, inventory)
end

function InventoryPanelCreated(panel, inventory, parent)
end

function ItemDraggedOutOfInventory(client, item)
end

function ItemPaintOver(itemIcon, itemTable, w, h)
end

function ItemShowEntityMenu(entity)
end

function LoadCharInformation()
end

function LoadMainCharacter()
end

function LoadMainMenuInformation(info, character)
end

function ModifyScoreboardModel(modelPanel, ply)
end

function ModifyVoiceIndicatorText(client, voiceText, voiceType)
end

function DrawPlayerInfoBackground()
end

function OnAdminStickMenuClosed()
end

function OnChatReceived(client, chatType, text, anonymous)
end

function OnCreateDualInventoryPanels(panel1, panel2, inventory1, inventory2)
end

function OnCreateItemInteractionMenu(itemIcon, menu, itemTable)
end

function OnCreateStoragePanel(localInvPanel, storageInvPanel, storage)
end

function OnLocalVarSet(key, value)
end

function OnOpenVendorMenu(vendorPanel, vendor)
end

function OnlineStaffDataReceived(staffData)
end

function OpenAdminStickUI(tgt)
end

function PaintItem(item)
end

function PopulateAdminStick(currentMenu, currentTarget, currentStores)
end

function PopulateAdminTabs(pages)
end

function PopulateConfigurationButtons(pages)
end

function PopulateInventoryItems(pnlContent, tree)
end

function PostDrawInventory(mainPanel, parentPanel)
end

function PostLoadFonts(mainFont, mainFont)
end

function DrawPhysgunBeam()
end

function RefreshFonts()
end

function RegisterAdminStickSubcategories(categories)
end

function ResetCharacterPanel()
end

function RunAdminSystemCommand(cmd, admin, victim, dur, reason)
end

function ScoreboardClosed(scoreboardPanel)
end

function ScoreboardOpened(scoreboardPanel)
end

function ScoreboardRowCreated(slot, ply)
end

function ScoreboardRowRemoved(scoreboardPanel, ply)
end

function SetMainCharacter(charID)
end

function SetupQuickMenu(quickMenuPanel)
end

function ShouldAllowScoreboardOverride(client, var)
end

function ShouldBarDraw(bar)
end

function ShouldDisableThirdperson(client)
end

function ShouldDrawAmmo(wpn)
end

function ShouldDrawEntityInfo(e)
end

function ShouldDrawPlayerInfo(e)
end

function ShouldDrawWepSelect(client)
end

function ShouldHideBars()
end

function ShouldMenuButtonShow(button)
end

function ShouldRespawnScreenAppear()
end

function ShouldShowCharVarInCreation(key)
end

function ShouldShowClassOnScoreboard(clsData)
end

function ShouldShowFactionOnScoreboard(ply)
end

function ShouldShowPlayerOnScoreboard(ply)
end

function ShouldShowQuickMenu()
end

function ShowPlayerOptions(target, options)
end

function StorageOpen(storage, isCar)
end

function StorageUnlockPrompt(entity)
end

function ThirdPersonToggled(enabled)
end

function TooltipInitialize(var, panel)
end

function TooltipLayout(var)
end

function TooltipPaint(var, w, h)
end

function VendorExited()
end

function VendorOpened(vendor)
end

function VoiceToggled(enabled)
end

function WeaponCycleSound()
end

function WeaponSelectSound()
end

function WebImageDownloaded(name, path)
end

function WebSoundDownloaded(name, path)
end

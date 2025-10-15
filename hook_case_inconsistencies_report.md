# Hook Case Inconsistency Report

Found 20 case inconsistencies in hook usage patterns.

## 1. `MODULE:setbodygroup`

**Different casings found:**
- `SetBodygroup`
- `setBodyGroup`

**Usage patterns:**
- `ent:SetBodygroup` (method_call)
- `modelEntity:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `Entity:SetBodygroup` (method_call)
- `Entity:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `client:SetBodygroup` (method_call)
- `createdEnt:SetBodygroup` (method_call)
- `client:SetBodygroup` (method_call)
- `client:SetBodygroup` (method_call)
- `target:SetBodygroup` (method_call)
- `vendor:setBodyGroup` (method_call)
- `ent:SetBodygroup` (method_call)
- `client:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `self:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `client:SetBodygroup` (method_call)
- `player:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `ENT:setBodyGroup` (function)
- `ENT:setBodyGroup` (method_call)
- `self:SetBodygroup` (method_call)
- `ent:SetBodygroup` (method_call)
- `ent:SetBodygroup` (method_call)
- `child:SetBodygroup` (method_call)
- `ent:SetBodygroup` (method_call)
- `ent:SetBodygroup` (method_call)
- `v:SetBodygroup` (method_call)
- `bonemerge:SetBodygroup` (method_call)
- `ent:SetBodygroup` (method_call)
- `hands:SetBodygroup` (method_call)
- `ent:SetBodygroup` (method_call)
- `child:SetBodygroup` (method_call)
- `bonemerge:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `ent:SetBodygroup` (method_call)
- `ent2:SetBodygroup` (method_call)
- `npc:SetBodygroup` (method_call)
- `npc:SetBodygroup` (method_call)
- `self:SetBodygroup` (method_call)
- `npc:SetBodygroup` (method_call)
- `npc:SetBodygroup` (method_call)
- `npc:SetBodygroup` (method_call)
- `npc:SetBodygroup` (method_call)
- `ent:SetBodygroup` (method_call)
- `ent:SetBodygroup` (method_call)
- `Entity:SetBodygroup` (method_call)
- `Entity:SetBodygroup` (method_call)
- `Entity:SetBodygroup` (method_call)
- `vehicle:SetBodygroup` (method_call)
- `veh:SetBodygroup` (method_call)
- `veh:SetBodygroup` (method_call)
- `model:SetBodygroup` (method_call)
- `entity:SetBodygroup` (method_call)
- `target:SetBodygroup` (method_call)
- `Entity:SetBodygroup` (method_call)
- `Entity:SetBodygroup` (method_call)
- `Entity:SetBodygroup` (method_call)
- `marker:SetBodygroup` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\f1menu\cl_classes.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\mainmenu\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\mainmenu\creation.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\item.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\scoreboard.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\spawnicon.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\hooks\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\commands.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\thirdparty\sh_extensions.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\vendor.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\player.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\entities\entities\lia_item\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\items\base\entities.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\items\base\outfit.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\derma\cl_grid_inventory_item.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\vendor\entities\entities\lia_vendor\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\vendor\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\bodygrouper\derma\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\bodygrouper\netcalls\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\derma\cl_viewer.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\netcalls\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\core\cl_bonemerge.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\core\cl_vendor.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\derma\cl_creation.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\derma\cl_inv_panel.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\corpselooting\libraries\sv_hooks.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\commands\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\entities\entities\dialog_npc\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\cardealer\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\cardealer\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\delivery\libraries\server.lua`

---

## 2. `MODULE:onremove`

**Different casings found:**
- `OnRemove`
- `onRemove`

**Usage patterns:**
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `QuickPanel:OnRemove` (function)
- `QuickPanel:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `panel:OnRemove` (function)
- `panel:OnRemove` (method_call)
- `d:onRemove` (method_call)
- `d:onRemove` (method_call)
- `frame:OnRemove` (function)
- `frame:OnRemove` (method_call)
- `ENT:OnRemove` (function)
- `ENT:OnRemove` (method_call)
- `SWEP:OnRemove` (function)
- `SWEP:OnRemove` (method_call)
- `menu:OnRemove` (function)
- `frm:OnRemove` (function)
- `menu:OnRemove` (method_call)
- `frm:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `ENT:OnRemove` (function)
- `ENT:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (method_call)
- `ENT:OnRemove` (function)
- `ENT:OnRemove` (method_call)
- `localInvPanel:OnRemove` (function)
- `itemBankInvPanel:OnRemove` (function)
- `localInvPanel:OnRemove` (method_call)
- `itemBankInvPanel:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `ENT:OnRemove` (function)
- `ENT:OnRemove` (method_call)
- `SWEP:OnRemove` (function)
- `SWEP:OnRemove` (method_call)
- `SWEP:OnRemove` (function)
- `SWEP:OnRemove` (method_call)
- `ENT:OnRemove` (function)
- `ENT:OnRemove` (method_call)
- `SWEP:OnRemove` (function)
- `SWEP:OnRemove` (method_call)
- `SWEP:OnRemove` (function)
- `SWEP:OnRemove` (method_call)
- `PANEL:OnRemove` (function)
- `PANEL:OnRemove` (method_call)
- `SWEP:OnRemove` (function)
- `SWEP:OnRemove` (method_call)
- `SWEP:OnRemove` (function)
- `SWEP:OnRemove` (method_call)
- `SWEP:OnRemove` (function)
- `SWEP:OnRemove` (method_call)
- `ENT:OnRemove` (function)
- `ENT:OnRemove` (method_call)
- `ENT:OnRemove` (function)
- `ENT:OnRemove` (method_call)
- `ENT:OnRemove` (function)
- `ENT:OnRemove` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\f1menu\cl_information.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\f1menu\cl_menu.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\mainmenu\bg_music.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\mainmenu\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\chatbox.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\combobox.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\lia_tab_button.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\panels.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\radialpanel.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\scoreboard.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\slidebox.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\inventory.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\menu.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\playerinteract.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\entities\entities\lia_item\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\entities\weapons\lia_hands\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\derma\cl_grid_inventroy.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\storage\entities\entities\lia_storage\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\vendor\derma\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\vendor\entities\entities\lia_vendor\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\entities\entities\wartable\cl_init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\banking\libraries\cl_bankcalls.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\derma\cl_inv_panel.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\derma\cl_vendorpanel.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\chess\entities\entities\ent_chess_board.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\chess\entities\weapons\chess_admin_tool.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\chess\entities\weapons\chess_admin_tool\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\extraction\entities\entities\ent_flare.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\gathering\entities\weapons\weapon_hl2axe\shared.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\gathering\entities\weapons\weapon_hl2pickaxe\shared.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\derma\cl_computer.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\entities\weapons\nightstick\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\entities\weapons\weapon_stungun\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\radio\entities\weapons\radio\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\territories\entities\entities\controlpoint\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\terrorism\entities\entities\planted_bomb\init.lua`

---

## 3. `MODULE:getid`

**Different casings found:**
- `GetID`
- `getID`

**Usage patterns:**
- `charObj:getID` (method_call)
- `clientChar:getID` (method_call)
- `character:getID` (method_call)
- `cObj:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `clientChar:getID` (method_call)
- `character:getID` (method_call)
- `clientChar:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `inventory:getID` (method_call)
- `v:getID` (method_call)
- `charFound:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `char:getID` (method_call)
- `character:getID` (method_call)
- `item:getID` (method_call)
- `targetInv:getID` (method_call)
- `char:getID` (method_call)
- `characterMeta:getID` (function)
- `characterMeta:getID` (method_call)
- `character:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `id:getID` (method_call)
- `id:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `character:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `curChar:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `Inventory:getID` (function)
- `Inventory:getID` (method_call)
- `item:getID` (method_call)
- `self:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `item:getID` (method_call)
- `self:getID` (method_call)
- `ITEM:getID` (function)
- `ITEM:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `self:getID` (method_call)
- `inventory:getID` (method_call)
- `item:getID` (method_call)
- `inventory:getID` (method_call)
- `character:getID` (method_call)
- `line:GetID` (method_call)
- `character:getID` (method_call)
- `from:getID` (method_call)
- `to:getID` (method_call)
- `char:getID` (method_call)
- `targetInv:getID` (method_call)
- `inventory:getID` (method_call)
- `targetInventory:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `targetInv:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `inventory:getID` (method_call)
- `item:getID` (method_call)
- `inventory:getID` (method_call)
- `item:getID` (method_call)
- `inventory:getID` (method_call)
- `item:getID` (method_call)
- `inventory:getID` (method_call)
- `item:getID` (method_call)
- `self:getID` (method_call)
- `inventory:getID` (method_call)
- `other:getID` (method_call)
- `bagInv:getID` (method_call)
- `inventory:getID` (method_call)
- `bagInv:getID` (method_call)
- `bagInv:getID` (method_call)
- `bagInv:getID` (method_call)
- `inventory:getID` (method_call)
- `bagInv:getID` (method_call)
- `oldInventory:getID` (method_call)
- `newInventory:getID` (method_call)
- `inventory:getID` (method_call)
- `inv:getID` (method_call)
- `clientInv:getID` (method_call)
- `fromInv:getID` (method_call)
- `toInv:getID` (method_call)
- `fromInv:getID` (method_call)
- `toInv:getID` (method_call)
- `character:getID` (method_call)
- `newCharacter:getID` (method_call)
- `character:getID` (method_call)
- `b:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `other:getID` (method_call)
- `attackerChar:getID` (method_call)
- `targetChar:getID` (method_call)
- `char:getID` (method_call)
- `it:getID` (method_call)
- `it:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `inventory:getID` (method_call)
- `targetChar:getID` (method_call)
- `char:getID` (method_call)
- `it:getID` (method_call)
- `it:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `character:getID` (method_call)
- `char:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `it:getID` (method_call)
- `char:getID` (method_call)
- `it:getID` (method_call)
- `it:getID` (method_call)
- `char:getID` (method_call)
- `bagInv:getID` (method_call)
- `bagInv:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `char:getID` (method_call)
- `againstChar:getID` (method_call)
- `char:getID` (method_call)
- `againstChar:getID` (method_call)
- `inventory:getID` (method_call)
- `lootInv:getID` (method_call)
- `lootInv:getID` (method_call)
- `from:getID` (method_call)
- `v:getID` (method_call)
- `inv:getID` (method_call)
- `clientInv:getID` (method_call)
- `inventory:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `baitItem:getID` (method_call)
- `baitItem:getID` (method_call)
- `character:getID` (method_call)
- `char:getID` (method_call)
- `character:getID` (method_call)
- `char:getID` (method_call)
- `inventory:getID` (method_call)
- `inventory:getID` (method_call)
- `LootInventory:getID` (method_call)
- `fallbackInv:getID` (method_call)
- `fallbackInv:getID` (method_call)
- `LootInventory:getID` (method_call)
- `item:getID` (method_call)
- `LootInventory:getID` (method_call)
- `LootInventory:getID` (method_call)
- `LootInventory:getID` (method_call)
- `LootInventory:getID` (method_call)
- `LootInventory:getID` (method_call)
- `LootInventory:getID` (method_call)
- `LootInventory:getID` (method_call)
- `LootInventory:getID` (method_call)
- `LootInventory:getID` (method_call)
- `LootInventory:getID` (method_call)
- `inv:getID` (method_call)
- `inv:getID` (method_call)
- `item:getID` (method_call)
- `lootInventory:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `item:getID` (method_call)
- `LootInventory:getID` (method_call)
- `item:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `char:getID` (method_call)
- `item:getID` (method_call)
- `ownerChar:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)
- `character:getID` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\mainmenu\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\hooks\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\commands.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\item.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\logger.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\inventory.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\item.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\panel.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\netcalls\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\entities\entities\lia_money\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\derma\cl_grid_inventory_item.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\derma\cl_grid_inventory_panel.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\gridinv.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\items\base\bags.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\storage\entities\entities\lia_storage\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\storage\libraries\shared.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\storage\netcalls\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\mainmenu\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\recognition\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\recognition\libraries\shared.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\recognition\pim.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\spawns\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\teams\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\banking\libraries\cl_bankcalls.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\banking\libraries\sv_banker_actions.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\banking\libraries\sv_player_actions.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\banking\libraries\sv_tables.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\banking\pim.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\core\cl_bonemerge.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\core\sv_network.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\derma\cl_inv_panel.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\items\base\bonemerge.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\items\base\ties.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\chess\chess\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\corpselooting\libraries\cl_hooks.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\corpselooting\libraries\sv_hooks.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\corpselooting\libraries\sv_networking.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\cuffs\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\drugs\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\drugs\libraries\shared.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\gathering\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\leveling\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\looting\entities\entities\lia_loot\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\looting\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\looting\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lscs\items\base\ability.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lscs\items\base\crystal.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lscs\items\base\hilt.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lscs\items\base\stance.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\medals\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\fence\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\marketplace\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\property\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\hooks\shared.lua`

---

## 4. `MODULE:getbodygroups`

**Different casings found:**
- `GetBodyGroups`
- `getBodygroups`

**Usage patterns:**
- `character:getBodygroups` (method_call)
- `item:getBodygroups` (method_call)
- `ply:GetBodyGroups` (method_call)
- `ply:GetBodyGroups` (method_call)
- `ItemTable:getBodygroups` (method_call)
- `ItemTable:getBodygroups` (method_call)
- `character:getBodygroups` (method_call)
- `character:getBodygroups` (method_call)
- `dummy:GetBodyGroups` (method_call)
- `self:getBodygroups` (method_call)
- `ITEM:getBodygroups` (function)
- `ITEM:getBodygroups` (method_call)
- `character:getBodygroups` (method_call)
- `character:getBodygroups` (method_call)
- `item:getBodygroups` (method_call)
- `ent:GetBodyGroups` (method_call)
- `ent1:GetBodyGroups` (method_call)
- `target:GetBodyGroups` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\mainmenu\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\item.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\scoreboard.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\spawnicon.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\hooks\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\factions.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\item.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\items\base\outfit.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\derma\cl_grid_inventory_item.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\derma\cl_viewer.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\core\cl_bonemerge.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\corpselooting\libraries\sv_hooks.lua`

---

## 5. `MODULE:setname`

**Different casings found:**
- `setName`
- `SetName`

**Usage patterns:**
- `icon:SetName` (method_call)
- `vendor:setName` (method_call)
- `icon:SetName` (method_call)
- `icon:SetName` (method_call)
- `ENT:setName` (function)
- `ENT:setName` (method_call)
- `client:SetName` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\extended_spawnmenu.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\thirdparty\sh_extensions.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\vendor.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\vendor\entities\entities\lia_vendor\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\shootlock\libraries\server.lua`

---

## 6. `MODULE:size`

**Different casings found:**
- `Size`
- `size`

**Usage patterns:**
- `infoMarkup:Size` (method_call)
- `f:Size` (method_call)
- `MarkupObject:size` (function)
- `MarkupObject:size` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\weaponselector.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\thirdparty\cl_markup.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\util.lua`

---

## 7. `MODULE:getweapon`

**Different casings found:**
- `GetWeapon`
- `getWeapon`

**Usage patterns:**
- `self:GetWeapon` (method_call)
- `toolGunMeta:getWeapon` (function)
- `toolGunMeta:getWeapon` (method_call)
- `client:GetWeapon` (method_call)
- `client:GetWeapon` (method_call)
- `ply:GetWeapon` (method_call)
- `ply:GetWeapon` (method_call)
- `ply:GetWeapon` (method_call)
- `ply:GetWeapon` (method_call)
- `client:GetWeapon` (method_call)
- `client:GetWeapon` (method_call)
- `client:GetWeapon` (method_call)
- `client:GetWeapon` (method_call)
- `client:GetWeapon` (method_call)
- `client:GetWeapon` (method_call)
- `ply:GetWeapon` (method_call)
- `ply:GetWeapon` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\derma\panels\weaponselector.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\tool.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\items\base\weapons.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lockpicking\lua\zlockpick\sh_main.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lockpicking\lua\zlockpick\sv_main.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lockpicking\lua\zlockpick\sv_net.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\items\base\weapons.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\radio\items\radio.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\radio\libraries\server.lua`

---

## 8. `MODULE:start`

**Different casings found:**
- `start`
- `Start`

**Usage patterns:**
- `fadeAnim:Start` (method_call)
- `cinematics:start` (method_call)
- `cinematics:start` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\hooks\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\cinematicloading\netcalls\client.lua`

---

## 9. `MODULE:setammo`

**Different casings found:**
- `setAmmo`
- `SetAmmo`

**Usage patterns:**
- `character:setAmmo` (method_call)
- `character:setAmmo` (method_call)
- `self:SetAmmo` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\hooks\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\player.lua`

---

## 10. `MODULE:setbodygroups`

**Different casings found:**
- `setBodygroups`
- `SetBodyGroups`

**Usage patterns:**
- `client:SetBodyGroups` (method_call)
- `character:setBodygroups` (method_call)
- `character:setBodygroups` (method_call)
- `character:setBodygroups` (method_call)
- `entity:SetBodyGroups` (method_call)
- `character:setBodygroups` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\hooks\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\items\base\outfit.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\bodygrouper\netcalls\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\derma\cl_creation.lua`

---

## 11. `MODULE:spawn`

**Different casings found:**
- `Spawn`
- `spawn`

**Usage patterns:**
- `client:Spawn` (method_call)
- `client:Spawn` (method_call)
- `createdEnt:Spawn` (method_call)
- `itemCreated:spawn` (method_call)
- `target:Spawn` (method_call)
- `client:Spawn` (method_call)
- `client:Spawn` (method_call)
- `money:Spawn` (method_call)
- `item:spawn` (method_call)
- `item:spawn` (method_call)
- `item:spawn` (method_call)
- `item:spawn` (method_call)
- `n:Spawn` (method_call)
- `client:Spawn` (method_call)
- `ITEM:spawn` (function)
- `ITEM:spawn` (method_call)
- `entity:Spawn` (method_call)
- `entity:Spawn` (method_call)
- `holdEntity:Spawn` (method_call)
- `entity:Spawn` (method_call)
- `item:spawn` (method_call)
- `storage:Spawn` (method_call)
- `item:spawn` (method_call)
- `entity:Spawn` (method_call)
- `client:Spawn` (method_call)
- `client:Spawn` (method_call)
- `client:Spawn` (method_call)
- `ent:Spawn` (method_call)
- `instance:spawn` (method_call)
- `newItem:spawn` (method_call)
- `instance:spawn` (method_call)
- `newItem:spawn` (method_call)
- `instance:spawn` (method_call)
- `item:spawn` (method_call)
- `item:spawn` (method_call)
- `CCTVCamera:Spawn` (method_call)
- `board:Spawn` (method_call)
- `board:Spawn` (method_call)
- `tbl:Spawn` (method_call)
- `BlackSeat:Spawn` (method_call)
- `WhiteSeat:Spawn` (method_call)
- `ent:Spawn` (method_call)
- `ent:Spawn` (method_call)
- `prop:Spawn` (method_call)
- `corpse:Spawn` (method_call)
- `item:spawn` (method_call)
- `ent:Spawn` (method_call)
- `ent:Spawn` (method_call)
- `npc:Spawn` (method_call)
- `flare:Spawn` (method_call)
- `flare:Spawn` (method_call)
- `ent:Spawn` (method_call)
- `light:Spawn` (method_call)
- `npc:Spawn` (method_call)
- `entity:Spawn` (method_call)
- `entity:Spawn` (method_call)
- `imported:Spawn` (method_call)
- `vehicle:Spawn` (method_call)
- `vehicle:Spawn` (method_call)
- `vehicle:Spawn` (method_call)
- `crate:Spawn` (method_call)
- `ent2:Spawn` (method_call)
- `HelpEnt:Spawn` (method_call)
- `ent:Spawn` (method_call)
- `propConstructHolo:Spawn` (method_call)
- `fort:Spawn` (method_call)
- `bombEnt:Spawn` (method_call)
- `bombEnt:Spawn` (method_call)
- `bombEnt:Spawn` (method_call)
- `bombEnt:Spawn` (method_call)
- `bombEnt:Spawn` (method_call)
- `bombEnt:Spawn` (method_call)
- `bombEnt:Spawn` (method_call)
- `bombEnt:Spawn` (method_call)
- `debris:Spawn` (method_call)
- `npc:Spawn` (method_call)
- `entity:Spawn` (method_call)
- `spin:Spawn` (method_call)
- `e:Spawn` (method_call)
- `e:Spawn` (method_call)
- `MarkerModel:Spawn` (method_call)
- `marker:Spawn` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\hooks\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\admin.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\currency.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\item.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\keybind.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\thirdparty\sh_extensions.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\item.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\player.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\entities\weapons\lia_hands\shared.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\items\base\entities.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\storage\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\storage\netcalls\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\vendor\entities\entities\lia_vendor\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\mainmenu\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\spawns\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\npcspawner\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\slots\entities\entities\slot_machine\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\utilities\libs\sh_utils.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\wartable\netcalls\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\core\cl_vendor.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\core\sv_network.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\items\base\ties.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\cameras\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\chess\chess\sv_database.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\chess\entities\entities\ent_chess_board.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\chess\entities\weapons\chess_admin_tool.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\chess\entities\weapons\chess_admin_tool\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\corpselooting\libraries\sv_hooks.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\corpselooting\libraries\sv_networking.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\cuffs\meta\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\events\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\extraction\entities\weapons\weapon_extraction_flare.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\extraction\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lockpicking\lua\zlockpick\sv_main.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\looting\entities\entities\lia_loot\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\looting\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\blackmarket\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\cardealer\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\delivery\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\entities\weapons\weapon_stungun\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\propbasedbuilding\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\terrorism\libraries\server.lua`

---

## 12. `MODULE:getusergroup`

**Different casings found:**
- `GetUserGroup`
- `getUserGroup`

**Usage patterns:**
- `ply:getUserGroup` (method_call)
- `ply:GetUserGroup` (method_call)
- `ply:GetUserGroup` (method_call)
- `ply:GetUserGroup` (method_call)
- `client:GetUserGroup` (method_call)
- `client:GetUserGroup` (method_call)
- `pl:GetUserGroup` (method_call)
- `actor:getUserGroup` (method_call)
- `actor:GetUserGroup` (method_call)
- `ply:GetUserGroup` (method_call)
- `ply:GetUserGroup` (method_call)
- `self:GetUserGroup` (method_call)
- `self:GetUserGroup` (method_call)
- `target:GetUserGroup` (method_call)
- `ply:GetUserGroup` (method_call)
- `client:GetUserGroup` (method_call)
- `client:GetUserGroup` (method_call)
- `client:GetUserGroup` (method_call)
- `client:GetUserGroup` (method_call)
- `client:GetUserGroup` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\admin.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\commands.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\compatibility\cami.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\derma.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\player.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\entities\weapons\adminstick\cl_init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\administration\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\attributes\libraries\shared.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\vendor\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\donator\libraries\shared.lua`

---

## 13. `MODULE:getvar`

**Different casings found:**
- `GetVar`
- `getVar`

**Usage patterns:**
- `character:getVar` (method_call)
- `stored:getVar` (method_call)
- `self:getVar` (method_call)
- `self:getVar` (method_call)
- `self:getVar` (method_call)
- `self:getVar` (method_call)
- `character:getVar` (method_call)
- `character:getVar` (method_call)
- `storage:GetVar` (method_call)
- `ent:GetVar` (method_call)
- `ent:GetVar` (method_call)
- `client:GetVar` (method_call)
- `corpse:GetVar` (method_call)
- `corpse:GetVar` (method_call)
- `corpse:GetVar` (method_call)
- `corpse:GetVar` (method_call)
- `client:GetVar` (method_call)
- `corpse:GetVar` (method_call)
- `client:GetVar` (method_call)
- `ch:getVar` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\commands.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\character.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\netcalls\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\corpselooting\libraries\sv_access_rules.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\corpselooting\libraries\sv_hooks.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\libraries\server.lua`

---

## 14. `MODULE:distance`

**Different casings found:**
- `distance`
- `Distance`

**Usage patterns:**
- `spawn:distance` (method_call)
- `HitPos:distance` (method_call)
- `pPos:distance` (method_call)
- `a:distance` (method_call)
- `b:distance` (method_call)
- `hitPos:distance` (method_call)
- `vectorMeta:distance` (function)
- `vectorMeta:distance` (method_call)
- `StartPos:distance` (method_call)
- `StartPos:distance` (method_call)
- `StartPos:distance` (method_call)
- `hitPos:Distance` (method_call)
- `playerPos:distance` (method_call)
- `playerPos:distance` (method_call)
- `lastPos:distance` (method_call)
- `pos:distance` (method_call)
- `groundPos:Distance` (method_call)
- `playerPos:Distance` (method_call)
- `playerPos:Distance` (method_call)
- `refPos:Distance` (method_call)
- `refPos:Distance` (method_call)
- `startPos:Distance` (method_call)
- `pos:Distance` (method_call)
- `pos:Distance` (method_call)
- `pos:Distance` (method_call)
- `playerPos:Distance` (method_call)
- `position:Distance` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\commands.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\compatibility\simfphys.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\keybind.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\menu.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\util.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\vector.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\entities\weapons\distance\cl_init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\protection\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\shootlock\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\core\cl_bonemerge.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\dailyrewards\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\drugs\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\cardealer\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\cardealer\libraries\shared.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\delivery\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\taxi\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\hooks\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\propbasedbuilding\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\territories\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\terrorism\items\detonator.lua`

---

## 15. `MODULE:create`

**Different casings found:**
- `Create`
- `create`

**Usage patterns:**
- `tool:Create` (method_call)
- `MarkupObject:create` (function)
- `MarkupObject:create` (method_call)
- `MarkupObject:create` (method_call)
- `toolGunMeta:create` (function)
- `toolGunMeta:create` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\loader.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\thirdparty\cl_markup.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\tool.lua`

---

## 16. `MODULE:createconvars`

**Different casings found:**
- `CreateConVars`
- `createConVars`

**Usage patterns:**
- `TOOL:CreateConVars` (method_call)
- `toolGunMeta:createConVars` (function)
- `toolGunMeta:createConVars` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\loader.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\tool.lua`

---

## 17. `MODULE:up`

**Different casings found:**
- `up`
- `Up`

**Usage patterns:**
- `curAng:Up` (method_call)
- `vectorMeta:up` (function)
- `vectorMeta:up` (method_call)
- `ang:up` (method_call)
- `ang:up` (method_call)
- `ang:up` (method_call)
- `ang:up` (method_call)
- `ang:up` (method_call)
- `ang:up` (method_call)
- `ang:up` (method_call)
- `ang:up` (method_call)
- `ang:up` (method_call)
- `ang:up` (method_call)
- `ang:up` (method_call)
- `ang:Up` (method_call)
- `garageAng:Up` (method_call)
- `ang2:Up` (method_call)
- `angMod:Up` (method_call)
- `angMod:Up` (method_call)
- `angle:Up` (method_call)
- `BoneAng:Up` (method_call)
- `TextAngle:Up` (method_call)
- `vm_angles:up` (method_call)
- `Ang:up` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\thirdperson.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\vector.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\realisticview\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\cuffs\entities\entities\cuffs\cl_init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\cuffs\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lockpicking\lua\zlockpick\cl_door_locks.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lockpicking\lua\zlockpick\cl_main.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\cardealer\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\entities\weapons\weapon_stungun\cl_init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\entities\weapons\weapon_stungun\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\hooks\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\radio\entities\weapons\radio\cl_init.lua`

---

## 18. `MODULE:right`

**Different casings found:**
- `right`
- `Right`

**Usage patterns:**
- `curAng:Right` (method_call)
- `vectorMeta:right` (function)
- `vectorMeta:right` (method_call)
- `currentPlayerAngles:right` (method_call)
- `angles:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang:right` (method_call)
- `ang2:Right` (method_call)
- `ang2:Right` (method_call)
- `angMod:Right` (method_call)
- `angMod:Right` (method_call)
- `BoneAng:Right` (method_call)
- `TextAngle:Right` (method_call)
- `vm_angles:right` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\thirdperson.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\meta\vector.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\entities\weapons\lia_hands\shared.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\raisedweapons\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\bonemerge\core\cl_vendor.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\cuffs\entities\entities\cuffs\cl_init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\cuffs\libraries\client.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\lockpicking\lua\zlockpick\cl_door_locks.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\entities\weapons\weapon_stungun\cl_init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\policesuite\entities\weapons\weapon_stungun\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\radio\entities\weapons\radio\cl_init.lua`

---

## 19. `MODULE:setanimation`

**Different casings found:**
- `SetAnimation`
- `setAnimation`

**Usage patterns:**
- `vendor:setAnimation` (method_call)
- `ENT:setAnimation` (function)
- `ENT:setAnimation` (method_call)
- `ply:SetAnimation` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\vendor.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\submodules\vendor\entities\entities\lia_vendor\init.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\looting\entities\entities\lia_loot\init.lua`

---

## 20. `MODULE:setowner`

**Different casings found:**
- `SetOwner`
- `setOwner`

**Usage patterns:**
- `part:SetOwner` (method_call)
- `holdEntity:SetOwner` (method_call)
- `GridInv:setOwner` (function)
- `GridInv:setOwner` (method_call)
- `flare:SetOwner` (method_call)
- `flare:SetOwner` (method_call)
- `MODULE:setOwner` (function)
- `MODULE:setOwner` (method_call)
- `MODULE:setOwner` (method_call)
- `self:SetOwner` (method_call)

**Files containing these hooks:**
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\core\libraries\compatibility\pac.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\entities\weapons\lia_hands\shared.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\Lilia\gamemode\modules\inventory\gridinv.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\extraction\entities\weapons\weapon_extraction_flare.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\extraction\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\npcs\submodules\property\libraries\server.lua`
- `E:\GMOD\Server\garrysmod\gamemodes\metrorp\modules\done\terrorism\entities\entities\planted_bomb\init.lua`

---


# Lilia API surface comparison

Stable: `C:\Users\Administrator\Documents\GitHub\Lilia`  
Bleeding edge: `D:\GMOD\Server\garrysmod\gamemodes\lilia`

## Removed net messages (55)

### `BodygrouperMenu` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/entities/entities/lia_bodygrouper/init.lua:12` (net.Start) — `net.Start("BodygrouperMenu")`
  - `gamemode/core/libraries/commands.lua:4580` (net.Start) — `net.Start("BodygrouperMenu")`
  - `gamemode/core/libraries/commands.lua:9163` (net.Start) — `net.Start("BodygrouperMenu")`
  - `gamemode/core/netcalls/client.lua:2145` (net.Receive) — `net.Receive("BodygrouperMenu", function()`
  - `gamemode/core/netcalls/server.lua:1743` (net.Receive) — `net.Receive("BodygrouperMenu", function(_, client)`
  - `gamemode/core/derma/panels/bodygrouper.lua:103` (net.Start) — `net.Start("BodygrouperMenu")`

### `BodygrouperMenuClose` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/server.lua:1727` (net.Receive) — `net.Receive("BodygrouperMenuClose", function(_, client)`
  - `gamemode/core/derma/panels/bodygrouper.lua:117` (net.Start) — `net.Start("BodygrouperMenuClose")`

### `BodygrouperMenuCloseClientside` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/client.lua:2154` (net.Receive) — `net.Receive("BodygrouperMenuCloseClientside", function() if IsValid(lia.gui.bodygroupMenu) then lia.gui.bodygroupMenu:Remove() end end)`
  - `gamemode/core/netcalls/server.lua:1799` (net.Start) — `net.Start("BodygrouperMenuCloseClientside")`

### `liaActiveTickets` — USED
- Stable Declarations:
  - `gamemode/modules/administration/submodules/tickets/module.lua:234` (NetworkStrings) — `MODULE.NetworkStrings = {"liaActiveTickets", "liaClearAllTicketFrames", "liaRequestActiveTickets", "liaRequestTicketsCount", "liaTicketsCount", "liaTicketSystem", "liaTicketSystemClaim", "liaTicketSystemClose", "liaViewClaims",}`
- Stable Usages:
  - `gamemode/modules/administration/submodules/tickets/netcalls/client.lua:2` (net.Receive) — `net.Receive("liaActiveTickets", function()`
  - `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:106` (net.Start) — `net.Start("liaActiveTickets")`

### `liaAdminSetCharProperty` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`
- Stable Usages:
  - `gamemode/modules/administration/netcalls/server.lua:624` (net.Receive) — `net.Receive("liaAdminSetCharProperty", function(_, client)`

### `liaAllFlags` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`

### `liaAllPks` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`
- Stable Usages:
  - `gamemode/modules/administration/netcalls/client.lua:184` (net.Receive) — `net.Receive("liaAllPks", function()`
  - `gamemode/modules/administration/netcalls/server.lua:909` (net.Start) — `net.Start("liaAllPks")`

### `liaAllPlayers` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`

### `liaAllWarnings` — USED
- Stable Declarations:
  - `gamemode/modules/administration/submodules/warnings/module.lua:196` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAllWarnings", "liaPlayerWarnings", "liaRequestAllWarnings", "liaRequestRemoveWarning", "liaRequestWarningsCount", "liaWarningsCount",}`
- Stable Usages:
  - `gamemode/modules/administration/submodules/warnings/netcalls/client.lua:1` (net.Receive) — `net.Receive("liaAllWarnings", function()`
  - `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:47` (net.Start) — `net.Start("liaAllWarnings")`

### `liaButtonRequestCancel` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/server.lua:1168` (net.Receive) — `net.Receive("liaButtonRequestCancel", function(_, client)`

### `liaCheckHack` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/server.lua:580` (net.Receive) — `net.Receive("liaCheckHack", function(_, client)`

### `liaCheckSeed` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/modules/protection/libraries/client.lua:77` (net.Start) — `net.Start("liaCheckSeed")`
  - `gamemode/core/netcalls/server.lua:566` (net.Receive) — `net.Receive("liaCheckSeed", function(_, client)`
- Bleeding Usages:
  - `gamemode/core/libraries/core/protection/core.lua:361` (net.Start) — `net.Start("liaCheckSeed")`
  - `gamemode/core/libraries/core/protection/netcalls.lua:13` (net.Receive) — `net.Receive("liaCheckSeed", function(_, client)`

### `liaDisplayCharList` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/modules/administration/netcalls/client.lua:326` (net.Receive) — `net.Receive("liaDisplayCharList", function()`
  - `gamemode/core/libraries/commands.lua:2705` (net.Start) — `net.Start("liaDisplayCharList")`

### `liaDoorData` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/client.lua:1972` (net.Receive) — `net.Receive("liaDoorData", function()`

### `liaEntityTabData` — USED
- Stable Declarations:
  - `gamemode/modules/protection/module.lua:156` (NetworkStrings) — `MODULE.NetworkStrings = {"liaVerifyCheats", "liaRequestEntityTabData", "liaEntityTabData"}`

### `liaFullCharList` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`

### `liaInsertKeyPressed` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/modules/protection/libraries/client.lua:66` (net.Start) — `net.Start("liaInsertKeyPressed")`
  - `gamemode/core/netcalls/server.lua:471` (net.Receive) — `net.Receive("liaInsertKeyPressed", function(_, client)`
- Bleeding Usages:
  - `gamemode/core/libraries/core/protection/core.lua:350` (net.Start) — `net.Start("liaInsertKeyPressed")`
  - `gamemode/core/libraries/core/protection/netcalls.lua:1` (net.Receive) — `net.Receive("liaInsertKeyPressed", function(_, client)`

### `liaItemData` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/client.lua:1102` (net.Receive) — `net.Receive("liaItemData", function()`

### `liaJobNpcCloseDialog` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/client.lua:2144` (net.Receive) — `net.Receive("liaJobNpcCloseDialog", function() if IsValid(lia.dialog.vgui) then lia.dialog.vgui:Remove() end end)`

### `liaKickCharacter` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/server.lua:503` (net.Receive) — `net.Receive("liaKickCharacter", function(_, client)`

### `liaNetMessage` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/client.lua:1782` (net.Receive) — `net.Receive("liaNetMessage", function()`
  - `gamemode/core/netcalls/server.lua:1415` (net.Receive) — `net.Receive("liaNetMessage", function(_, client)`

### `liaNPCWeaponChange` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/server.lua:949` (net.Receive) — `net.Receive("liaNPCWeaponChange", function(_, ply)`

### `liaOpenPanelBrowser` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/libraries/commands.lua:8484` (net.Receive) — `net.Receive("liaOpenPanelBrowser", openPanelBrowser)`
  - `gamemode/core/libraries/commands.lua:8493` (net.Start) — `net.Start("liaOpenPanelBrowser")`

### `liaPksCount` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`
- Stable Usages:
  - `gamemode/modules/administration/netcalls/server.lua:919` (net.Start) — `net.Start("liaPksCount")`

### `liaPlayerWarnings` — USED
- Stable Declarations:
  - `gamemode/modules/administration/submodules/warnings/module.lua:196` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAllWarnings", "liaPlayerWarnings", "liaRequestAllWarnings", "liaRequestRemoveWarning", "liaRequestWarningsCount", "liaWarningsCount",}`
- Stable Usages:
  - `gamemode/modules/administration/submodules/warnings/netcalls/client.lua:86` (net.Receive) — `net.Receive("liaPlayerWarnings", function()`
  - `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:69` (net.Start) — `net.Start("liaPlayerWarnings")`

### `liaPopupQuestionRequestCancel` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/server.lua:1153` (net.Receive) — `net.Receive("liaPopupQuestionRequestCancel", function(_, client)`

### `liaProvideServerPassword` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/client.lua:921` (net.Receive) — `net.Receive("liaProvideServerPassword", function()`

### `liaRequestActiveTickets` — USED
- Stable Declarations:
  - `gamemode/modules/administration/submodules/tickets/module.lua:234` (NetworkStrings) — `MODULE.NetworkStrings = {"liaActiveTickets", "liaClearAllTicketFrames", "liaRequestActiveTickets", "liaRequestTicketsCount", "liaTicketsCount", "liaTicketSystem", "liaTicketSystemClaim", "liaTicketSystemClose", "liaViewClaims",}`
- Stable Usages:
  - `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:89` (net.Receive) — `net.Receive("liaRequestActiveTickets", function(_, client)`

### `liaRequestAllFlags` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`
- Stable Usages:
  - `gamemode/modules/administration/netcalls/server.lua:1114` (net.Receive) — `net.Receive("liaRequestAllFlags", function(_, client)`

### `liaRequestAllWarnings` — USED
- Stable Declarations:
  - `gamemode/modules/administration/submodules/warnings/module.lua:196` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAllWarnings", "liaPlayerWarnings", "liaRequestAllWarnings", "liaRequestRemoveWarning", "liaRequestWarningsCount", "liaWarningsCount",}`
- Stable Usages:
  - `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:43` (net.Receive) — `net.Receive("liaRequestAllWarnings", function(_, client)`

### `liaRequestEntityTabData` — USED
- Stable Declarations:
  - `gamemode/modules/protection/module.lua:156` (NetworkStrings) — `MODULE.NetworkStrings = {"liaVerifyCheats", "liaRequestEntityTabData", "liaEntityTabData"}`
- Stable Usages:
  - `gamemode/modules/protection/libraries/client.lua:91` (net.Start) — `net.Start("liaRequestEntityTabData")`
  - `gamemode/modules/protection/libraries/server.lua:20` (net.Receive) — `net.Receive("liaRequestEntityTabData", function(_, client)`

### `liaRequestFullCharList` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`
- Stable Usages:
  - `gamemode/modules/administration/netcalls/server.lua:1099` (net.Receive) — `net.Receive("liaRequestFullCharList", function(_, client)`

### `liaRequestPksCount` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`
- Stable Usages:
  - `gamemode/modules/administration/netcalls/server.lua:915` (net.Receive) — `net.Receive("liaRequestPksCount", function(_, client)`

### `liaRequestPlayers` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`
- Stable Usages:
  - `gamemode/modules/administration/netcalls/server.lua:1314` (net.Receive) — `net.Receive("liaRequestPlayers", function(_, client)`

### `liaRequestPlayerWarnings` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:63` (net.Receive) — `net.Receive("liaRequestPlayerWarnings", function(_, client)`

### `liaRequestStaffSummary` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`
- Stable Usages:
  - `gamemode/modules/administration/netcalls/server.lua:1308` (net.Receive) — `net.Receive("liaRequestStaffSummary", function(_, client)`

### `liaRequestTicketsCount` — USED
- Stable Declarations:
  - `gamemode/modules/administration/submodules/tickets/module.lua:234` (NetworkStrings) — `MODULE.NetworkStrings = {"liaActiveTickets", "liaClearAllTicketFrames", "liaRequestActiveTickets", "liaRequestTicketsCount", "liaTicketsCount", "liaTicketSystem", "liaTicketSystemClaim", "liaTicketSystemClose", "liaViewClaims",}`
- Stable Usages:
  - `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:111` (net.Receive) — `net.Receive("liaRequestTicketsCount", function(_, client)`

### `liaRequestWarningsCount` — USED
- Stable Declarations:
  - `gamemode/modules/administration/submodules/warnings/module.lua:196` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAllWarnings", "liaPlayerWarnings", "liaRequestAllWarnings", "liaRequestRemoveWarning", "liaRequestWarningsCount", "liaWarningsCount",}`
- Stable Usages:
  - `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:53` (net.Receive) — `net.Receive("liaRequestWarningsCount", function(_, client)`

### `liaReturnFromEntity` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/modules/protection/libraries/client.lua:229` (net.Start) — `net.Start("liaReturnFromEntity")`
  - `gamemode/core/netcalls/server.lua:936` (net.Receive) — `net.Receive("liaReturnFromEntity", function(_, client)`

### `liaSeqSet` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/client.lua:953` (net.Receive) — `net.Receive("liaSeqSet", function()`

### `liaSetWaypointWithLogo` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/client.lua:564` (net.Receive) — `net.Receive("liaSetWaypointWithLogo", function()`

### `liaStaffSummary` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:502` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAdminSetCharProperty", "liaAllFlags", "liaAllPks", "liaAllPlayers", "liaFeaturePositions", "liaFeaturePositionsRequest", "liaFullCharList", "liaFullCharListPage", "liaManagesitroomsAction", "liaMapEntities", ...`

### `liaStorageTransfer` — USED
- Stable Declarations:
  - `gamemode/modules/inventory/types/gridinv/submodules/storage/module.lua:288` (NetworkStrings) — `MODULE.NetworkStrings = {"liaStorageExit", "liaStorageSetPassword", "liaStorageTransfer", "liaStorageUnlock", "liaTrunkInitStorage",}`
- Stable Usages:
  - `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:34` (net.Receive) — `net.Receive("liaStorageTransfer", function(_, client)`

### `liaTeleportToEntity` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/modules/protection/libraries/client.lua:220` (net.Start) — `net.Start("liaTeleportToEntity")`
  - `gamemode/core/netcalls/server.lua:653` (net.Receive) — `net.Receive("liaTeleportToEntity", function(_, client)`

### `liaTicketsCount` — USED
- Stable Declarations:
  - `gamemode/modules/administration/submodules/tickets/module.lua:234` (NetworkStrings) — `MODULE.NetworkStrings = {"liaActiveTickets", "liaClearAllTicketFrames", "liaRequestActiveTickets", "liaRequestTicketsCount", "liaTicketsCount", "liaTicketSystem", "liaTicketSystemClaim", "liaTicketSystemClose", "liaViewClaims",}`
- Stable Usages:
  - `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:118` (net.Start) — `net.Start("liaTicketsCount")`

### `liaTrunkInitStorage` — USED
- Stable Declarations:
  - `gamemode/modules/inventory/types/gridinv/submodules/storage/module.lua:288` (NetworkStrings) — `MODULE.NetworkStrings = {"liaStorageExit", "liaStorageSetPassword", "liaStorageTransfer", "liaStorageUnlock", "liaTrunkInitStorage",}`
- Stable Usages:
  - `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/shared.lua:1` (net.Receive) — `net.Receive("liaTrunkInitStorage", function()`

### `liaVendorBuyPrice` — USED
- Stable Declarations:
  - `gamemode/modules/vendor/module.lua:679` (NetworkStrings) — `MODULE.NetworkStrings = {"liaVendorAllowClass", "liaVendorAllowFaction", "liaVendorBuyPrice", "liaVendorDeletePreset", "liaVendorExit", "liaVendorFaction", "liaVendorFactionBuyScale", "liaVendorFactionSellScale", "liaVendorInitialSync", ...`
- Stable Usages:
  - `gamemode/modules/vendor/netcalls/client.lua:62` (net.Receive) — `net.Receive("liaVendorBuyPrice", function()`

### `liaVendorFaction` — USED
- Stable Declarations:
  - `gamemode/modules/vendor/module.lua:679` (NetworkStrings) — `MODULE.NetworkStrings = {"liaVendorAllowClass", "liaVendorAllowFaction", "liaVendorBuyPrice", "liaVendorDeletePreset", "liaVendorExit", "liaVendorFaction", "liaVendorFactionBuyScale", "liaVendorFactionSellScale", "liaVendorInitialSync", ...`
- Stable Usages:
  - `gamemode/modules/vendor/netcalls/client.lua:57` (net.Receive) — `net.Receive("liaVendorFaction", function()`

### `liaVendorSellPrice` — USED
- Stable Declarations:
  - `gamemode/modules/vendor/module.lua:679` (NetworkStrings) — `MODULE.NetworkStrings = {"liaVendorAllowClass", "liaVendorAllowFaction", "liaVendorBuyPrice", "liaVendorDeletePreset", "liaVendorExit", "liaVendorFaction", "liaVendorFactionBuyScale", "liaVendorFactionSellScale", "liaVendorInitialSync", ...`
- Stable Usages:
  - `gamemode/modules/vendor/netcalls/client.lua:73` (net.Receive) — `net.Receive("liaVendorSellPrice", function()`

### `liaVerifyCheats` — USED
- Stable Declarations:
  - `gamemode/modules/protection/module.lua:156` (NetworkStrings) — `MODULE.NetworkStrings = {"liaVerifyCheats", "liaRequestEntityTabData", "liaEntityTabData"}`
- Stable Usages:
  - `gamemode/modules/protection/libraries/server.lua:380` (net.Start) — `net.Start("liaVerifyCheats")`
  - `gamemode/modules/protection/netcalls/client.lua:2` (net.Receive) — `net.Receive("liaVerifyCheats", function()`

### `liaVerifyCheatsResponse` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/modules/protection/netcalls/client.lua:4` (net.Start) — `net.Start("liaVerifyCheatsResponse")`
  - `gamemode/core/netcalls/server.lua:611` (net.Receive) — `net.Receive("liaVerifyCheatsResponse", function(_, client)`

### `liaWarningsCount` — USED
- Stable Declarations:
  - `gamemode/modules/administration/submodules/warnings/module.lua:196` (NetworkStrings) — `MODULE.NetworkStrings = {"liaAllWarnings", "liaPlayerWarnings", "liaRequestAllWarnings", "liaRequestRemoveWarning", "liaRequestWarningsCount", "liaWarningsCount",}`
- Stable Usages:
  - `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:57` (net.Start) — `net.Start("liaWarningsCount")`

### `SeeModelTable` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/entities/entities/model_wardrobe/init.lua:50` (net.Start) — `net.Start("SeeModelTable")`
  - `gamemode/core/netcalls/client.lua:2155` (net.Receive) — `net.Receive("SeeModelTable", function()`

### `WardrobeChangeModel` — USED
- Stable Declarations:
  - `gamemode/init.lua:2` (networkStrings) — `local networkStrings = {"liaWeaponOverrideUpdate", "BodygrouperMenu", "BodygrouperMenuClose", "BodygrouperMenuCloseClientside", "SeeModelTable", "WardrobeChangeModel", "liaWeaponOverrideSync", "liaActBar", "liaJobNpcCloseDialog", "liaAdm...`
- Stable Usages:
  - `gamemode/core/netcalls/client.lua:2319` (net.Start) — `net.Start("WardrobeChangeModel")`
  - `gamemode/core/netcalls/server.lua:1847` (net.Receive) — `net.Receive("WardrobeChangeModel", function(_, client)`

## Removed commands (8)

### `charlist` — USED
- Stable Declarations:
  - `gamemode/core/libraries/commands.lua:2612` (lia.command.add) — `lia.command.add("charlist", {`

### `example` — USED
- Stable Declarations:
  - `gamemode/core/libraries/commands.lua:374` (lia.command.add) — `lia.command.add("example", {`
- Stable Usages:
  - `gamemode/languages/english.lua:52` (reference) — `toggleExampleDesc = "Toggles the example feature.",`
  - `gamemode/languages/english.lua:638` (reference) — `exampleEnabledDesc = "Whether the example feature is enabled.",`
  - `gamemode/languages/english.lua:640` (reference) — `exampleOptionDesc = "An example client option.",`
  - `gamemode/languages/english.lua:3118` (reference) — `exampleDesc = "An example command.",`
  - `gamemode/languages/english.lua:3881` (reference) — `dialogTutorialResponseMoreClasses = "Classes give you special equipment, abilities, or restrictions. For example, a SWAT class might have better armor and weapons but move slower.",`
  - `gamemode/languages/english.lua:3907` (reference) — `dialogTutorialResponseMetagaming = "Metagaming is using out-of-character knowledge in roleplay. For example, knowing someone's identity from their Steam name.",`
  - `gamemode/languages/french.lua:3862` (reference) — `dialogTutorialResponseMoreClasses = "Classes donner vous special equipment, abilities, ou restrictions. Pour example, un SWAT classe might ont better armure et armes but move slower.",`
  - `gamemode/languages/french.lua:3888` (reference) — `dialogTutorialResponseMetagaming = "Metagaming est utilisant hors personnage knowledge dans roleplay. Pour example, knowing someone's identity depuis leur Steam nom.",`
  - `gamemode/languages/german.lua:3862` (reference) — `dialogTutorialResponseMoreClasses = "Klassen geben du special equipment, abilities, oder restrictions. Für example, ein SWAT Klasse könnte haben better Rüstung und Waffen but move slower.",`
  - `gamemode/languages/german.lua:3888` (reference) — `dialogTutorialResponseMetagaming = "Metagaming ist verwendet Out-of-Character knowledge in roleplay. Für example, knowing jemand's identity von deren Steam Name.",`
  - `gamemode/languages/portuguese.lua:3862` (reference) — `dialogTutorialResponseMoreClasses = "Classes give you special equipment, abilities, or restrictions. For example, a SWAT classe might have better armor and armas but move slower.",`
  - `gamemode/languages/portuguese.lua:3888` (reference) — `dialogTutorialResponseMetagaming = "Metagaming is using out-of-personagem knowledge in roleplay. For example, knowing someone's identity from their Steam nome.",`
  - `gamemode/languages/russian.lua:3853` (reference) — `dialogTutorialResponseMoreClasses = "Классы дать вы special equipment, abilities, или ограничения. Для example, SWAT класс может better броня и оружие но переместить slower.",`
  - `gamemode/languages/russian.lua:3879` (reference) — `dialogTutorialResponseMetagaming = "Metagaming: использование вне персонажа knowledge в roleplay. Для example, knowing someone identity от их Steam имя.",`
  - `gamemode/languages/spanish.lua:3862` (reference) — `dialogTutorialResponseMoreClasses = "Classes dar you special equipment, abilities, o restrictions. For example, a SWAT clase might have better armadura y armas but move slower.",`
  - `gamemode/languages/spanish.lua:3888` (reference) — `dialogTutorialResponseMetagaming = "Metagaming is usando fuera-de-personaje knowledge en roleplay. For example, knowing someone's identity de their Steam nombre.",`
  - `gamemode/modules/administration/submodules/adminstick/libraries/client.lua:25` (reference) — `subcategory = "example",`
  - `gamemode/core/libraries/character.lua:614` (reference) — `lia.char.registerVar("example", {`
  - `gamemode/core/libraries/character.lua:616` (reference) — `field = "example",`
  - `gamemode/core/libraries/commands.lua:802` (reference) — `lia.command.openArgumentPrompt("example", {"target"}, {}, definitions)`
  - `gamemode/core/libraries/commands.lua:8260` (reference) — `example = true`
  - `gamemode/core/libraries/commands.lua:8265` (reference) — `example = true`
  - `gamemode/core/libraries/commands.lua:8270` (reference) — `example = true`
  - `gamemode/core/libraries/commands.lua:8275` (reference) — `example = true`
  - `gamemode/core/libraries/commands.lua:8453` (reference) — `panelBrowserNotify("No curated example is available for " .. selectedPanel.name .. ".", true)`
  - `gamemode/core/libraries/data.lua:380` (reference) — `file.Write("example.json", raw)`
  - `gamemode/core/libraries/database.lua:1375` (reference) — `lia.db.createTable("example", "id", {`
  - `gamemode/core/libraries/database.lua:1481` (reference) — `lia.db.removeTable("example")`
  - `gamemode/core/libraries/dialog.lua:2129` (reference) — `createField(inspector, "Sound Path", "soundPath", "vo/npc/example.wav")`
  - `gamemode/core/libraries/item.lua:737` (reference) — `local itemDef = lia.item.register("example", "base_entities", false, nil, true)`
  - `gamemode/core/libraries/keybind.lua:249` (reference) — `client:notify("Pressed example keybind.")`
  - `gamemode/core/libraries/loader.lua:550` (reference) — `lia.loader.includeGroupedDir("modules/example/libs", false, true)`
  - `gamemode/core/libraries/modularity.lua:415` (reference) — `lia.module.loadFromDir("schema/modules", "module", {example = true})`
  - `gamemode/core/libraries/webimage.lua:118` (reference) — `lia.webimage.download("schema_logo", "https://example.com/schema_logo.png", function(material, fromCache, err)`
  - `gamemode/core/libraries/webimage.lua:233` (reference) — `lia.webimage.register("schema_logo", "https://example.com/schema_logo.png", function(material)`
  - `gamemode/core/libraries/webimage.lua:410` (reference) — `lia.webimage.register("schema_logo", "https://example.com/schema_logo.png")`
  - `gamemode/core/libraries/webimage.lua:411` (reference) — `lia.webimage.register("schema_icon", "https://example.com/schema_icon.png")`
  - `gamemode/core/libraries/websound.lua:143` (reference) — `lia.websound.download("effects/click.mp3", "https://example.com/click.mp3", function(path, fromCache, err)`
  - `gamemode/core/libraries/websound.lua:250` (reference) — `lia.websound.register("effects/click.mp3", "https://example.com/click.mp3")`
  - `gamemode/core/libraries/websound.lua:599` (reference) — `lia.websound.playButtonSound("https://example.com/ui/button.wav", function(success)`
  - `gamemode/core/meta/entity.lua:51` (reference) — `entity:EmitSound("https://example.com/radio.mp3", 75, 100, 1)`
  - `gamemode/core/meta/entity.lua:700` (reference) — `entity:playFollowingSound("https://example.com/ambience.mp3", 0.8, true, 1200)`
  - `gamemode/core/meta/panel.lua:1134` (reference) — `panel:SetOpenURL("https://example.com")`
  - `gamemode/core/derma/panels/panels.lua:23` (reference) — `end, "Runs an example quick action.")`

### `lia_panel_tester` — USED
- Stable Declarations:
  - `gamemode/core/derma/panels/panel_tester.lua:1137` (concommand.Add) — `concommand.Add("lia_panel_tester", buildTester, nil, "Open the Lilia and Garry's Mod VGUI panel tester V2")`

### `listnearbyentities` — USED
- Stable Declarations:
  - `gamemode/core/libraries/commands.lua:9006` (lia.command.add) — `lia.command.add("listnearbyentities", {`

### `panelbrowser` — USED
- Stable Declarations:
  - `gamemode/core/libraries/commands.lua:8487` (lia.command.add) — `lia.command.add("panelbrowser", {`

### `previewchatmessages` — USED
- Stable Declarations:
  - `gamemode/core/libraries/commands.lua:8235` (lia.command.add) — `lia.command.add("previewchatmessages", {`

### `sayall` — USED
- Stable Declarations:
  - `gamemode/modules/administration/libraries/shared.lua:45` (lia.command.add) — `lia.command.add("sayall", {`

### `speed` — USED
- Stable Declarations:
  - `gamemode/modules/teams/libraries/server.lua:353` (lia.command.add) — `lia.command.add("speed", {`
- Stable Usages:
  - `gamemode/languages/english.lua:1313` (reference) — `setSpeedDesc = "Set a player's run speed.",`
  - `gamemode/languages/english.lua:2168` (reference) — `walkRatioDesc = "Defines the walk speed ratio when holding the Alt key.",`
  - `gamemode/languages/portuguese.lua:1311` (reference) — `setSpeedDesc = "Definir a jogador's run speed.",`
  - `gamemode/languages/portuguese.lua:2166` (reference) — `walkRatioDesc = "Defines the walk speed ratio when holding the Alt tecla.",`
  - `gamemode/modules/attributes/libraries/shared.lua:128` (reference) — `if bind == "+speed" and stamina <= maxStamina * 0.25 then`
  - `gamemode/modules/attributes/libraries/shared.lua:129` (reference) — `client:ConCommand("-speed")`
  - `gamemode/core/hooks/server.lua:1561` (reference) — `function GM:GetFallDamage(client, speed)`
  - `gamemode/core/hooks/server.lua:1563` (reference) — `return math.max(0, (speed - 580) * 100 / 444)`
  - `gamemode/core/hooks/server.lua:2058` (reference) — `client:ConCommand("-speed")`
  - `gamemode/core/libraries/color.lua:302` (reference) — `speed = 3,`
  - `gamemode/core/libraries/color.lua:337` (reference) — `lia.color.transition.progress = math.min(lia.color.transition.progress + (lia.color.transition.speed * dt), 1)`
  - `gamemode/core/libraries/commands.lua:4506` (reference) — `name = "speed",`
  - `gamemode/core/libraries/commands.lua:4523` (reference) — `local speed = tonumber(arguments[2]) or lia.config.get("WalkSpeed")`
  - `gamemode/core/libraries/commands.lua:4524` (reference) — `target:SetRunSpeed(speed)`
  - `gamemode/core/libraries/config.lua:1000` (reference) — `if lowerKey:find("stamina", 1, true) or lowerKey:find("punch", 1, true) or lowerKey:find("damage", 1, true) or lowerKey:find("speed", 1, true) or lowerKey:find("spawn", 1, true) or lowerKey:find("death", 1, true) or lowerKey:find("pain",...`
  - `gamemode/core/libraries/derma.lua:3040` (reference) — `speed (number)`
  - `gamemode/core/libraries/derma.lua:3041` (reference) — `Smoothing speed.`
  - `gamemode/core/libraries/derma.lua:3057` (reference) — `function lia.derma.approachExp(current, target, speed, dt)`
  - `gamemode/core/libraries/derma.lua:3058` (reference) — `local t = 1 - math.exp(-speed * dt)`
  - `gamemode/core/libraries/derma.lua:4280` (reference) — `local speed = (target > prev) and appearSpeed or disappearSpeed`
  - `gamemode/core/libraries/derma.lua:4281` (reference) — `local cur = lia.derma.approachExp(prev, target, speed, dt)`
  - `gamemode/core/libraries/keybind.lua:512` (reference) — `local GMODDefaultBindNames = {"+forward", "+back", "+moveleft", "+moveright", "+use", "+jump", "+duck", "+walk", "+speed", "+reload", "impulse 100", "+showscores", "messagemode", "messagemode2", "+menu_context", "+menu", "slot1", "slot2"...`
  - `gamemode/core/libraries/util.lua:1844` (reference) — `local speed = (target > prev) and appearSpeed or disappearSpeed`
  - `gamemode/core/libraries/util.lua:1845` (reference) — `local cur = lia.util.approachExp(prev, target, speed, dt)`
  - `gamemode/core/libraries/util.lua:1898` (reference) — `local speed = (target > prev) and appearSpeed or disappearSpeed`
  - `gamemode/core/libraries/util.lua:1899` (reference) — `local cur = lia.util.approachExp(prev, target, speed, dt)`
  - `gamemode/core/meta/panel.lua:232` (reference) — `speed (number)`
  - `gamemode/core/meta/panel.lua:233` (reference) — `The interpolation speed multiplier.`
  - `gamemode/core/meta/panel.lua:250` (reference) — `function panelMeta:SetupTransition(name, speed, fn)`
  - `gamemode/core/meta/panel.lua:253` (reference) — `self:On("Think", function(s) s[name] = Lerp(FrameTime() * speed, s[name], fn(s) and 1 or 0) end)`
  - `gamemode/core/meta/panel.lua:263` (reference) — `speed (number|nil)`
  - `gamemode/core/meta/panel.lua:264` (reference) — `The hover fade speed.`
  - `gamemode/core/meta/panel.lua:279` (reference) — `function panelMeta:FadeHover(col, speed, rad)`
  - `gamemode/core/meta/panel.lua:281` (reference) — `speed = speed or 6`
  - `gamemode/core/meta/panel.lua:281` (reference) — `speed = speed or 6`
  - `gamemode/core/meta/panel.lua:282` (reference) — `self:SetupTransition("FadeHover", speed, function(s) return s:IsHovered() end)`
  - `gamemode/core/meta/panel.lua:303` (reference) — `speed (number|nil)`
  - `gamemode/core/meta/panel.lua:304` (reference) — `The transition speed.`
  - `gamemode/core/meta/panel.lua:317` (reference) — `function panelMeta:BarHover(col, height, speed)`
  - `gamemode/core/meta/panel.lua:320` (reference) — `speed = speed or 6`
  - `gamemode/core/meta/panel.lua:320` (reference) — `speed = speed or 6`
  - `gamemode/core/meta/panel.lua:321` (reference) — `self:SetupTransition("BarHover", speed, function(s) return s:IsHovered() end)`
  - `gamemode/core/meta/panel.lua:338` (reference) — `speed (number|nil)`
  - `gamemode/core/meta/panel.lua:339` (reference) — `The transition speed.`
  - `gamemode/core/meta/panel.lua:354` (reference) — `function panelMeta:FillHover(col, dir, speed, mat)`
  - `gamemode/core/meta/panel.lua:357` (reference) — `speed = speed or 8`
  - `gamemode/core/meta/panel.lua:357` (reference) — `speed = speed or 8`
  - `gamemode/core/meta/panel.lua:358` (reference) — `self:SetupTransition("FillHover", speed, function(s) return s:IsHovered() end)`
  - `gamemode/core/meta/panel.lua:753` (reference) — `speed (number|nil)`
  - `gamemode/core/meta/panel.lua:754` (reference) — `The expansion and fade speed.`
  - `gamemode/core/meta/panel.lua:769` (reference) — `function panelMeta:CircleClick(col, speed, trad)`
  - `gamemode/core/meta/panel.lua:771` (reference) — `speed = speed or 5`
  - `gamemode/core/meta/panel.lua:771` (reference) — `speed = speed or 5`
  - `gamemode/core/meta/panel.lua:778` (reference) — `s.Rad = Lerp(FrameTime() * speed, s.Rad, trad or w)`
  - `gamemode/core/meta/panel.lua:779` (reference) — `s.Alpha = Lerp(FrameTime() * speed, s.Alpha, 0)`
  - `gamemode/core/meta/panel.lua:797` (reference) — `speed (number|nil)`
  - `gamemode/core/meta/panel.lua:798` (reference) — `The transition speed.`
  - `gamemode/core/meta/panel.lua:813` (reference) — `function panelMeta:CircleHover(col, speed, trad)`
  - `gamemode/core/meta/panel.lua:815` (reference) — `speed = speed or 6`
  - `gamemode/core/meta/panel.lua:815` (reference) — `speed = speed or 6`
  - `gamemode/core/meta/panel.lua:817` (reference) — `self:SetupTransition("CircleHover", speed, function(s) return s:IsHovered() end)`
  - `gamemode/core/meta/panel.lua:835` (reference) — `speed (number|nil)`
  - `gamemode/core/meta/panel.lua:836` (reference) — `The transition speed.`
  - `gamemode/core/meta/panel.lua:849` (reference) — `function panelMeta:SquareCheckbox(inner, outer, speed)`
  - `gamemode/core/meta/panel.lua:852` (reference) — `speed = speed or 14`
  - `gamemode/core/meta/panel.lua:852` (reference) — `speed = speed or 14`
  - `gamemode/core/meta/panel.lua:853` (reference) — `self:SetupTransition("SquareCheckbox", speed, function(s) return s:GetChecked() end)`
  - `gamemode/core/meta/panel.lua:874` (reference) — `speed (number|nil)`
  - `gamemode/core/meta/panel.lua:875` (reference) — `The transition speed.`
  - `gamemode/core/meta/panel.lua:888` (reference) — `function panelMeta:CircleCheckbox(inner, outer, speed)`
  - `gamemode/core/meta/panel.lua:891` (reference) — `speed = speed or 14`
  - `gamemode/core/meta/panel.lua:891` (reference) — `speed = speed or 14`
  - `gamemode/core/meta/panel.lua:892` (reference) — `self:SetupTransition("CircleCheckbox", speed, function(s) return s:GetChecked() end)`
  - `gamemode/core/meta/panel.lua:1010` (reference) — `speed (number|nil)`
  - `gamemode/core/meta/panel.lua:1011` (reference) — `The transition speed.`
  - `gamemode/core/meta/panel.lua:1024` (reference) — `function panelMeta:CircleFadeHover(col, speed)`
  - `gamemode/core/meta/panel.lua:1026` (reference) — `speed = speed or 6`
  - `gamemode/core/meta/panel.lua:1026` (reference) — `speed = speed or 6`
  - `gamemode/core/meta/panel.lua:1027` (reference) — `self:SetupTransition("CircleFadeHover", speed, function(s) return s:IsHovered() end)`
  - `gamemode/core/meta/panel.lua:1042` (reference) — `speed (number|nil)`
  - `gamemode/core/meta/panel.lua:1043` (reference) — `The transition speed.`
  - `gamemode/core/meta/panel.lua:1056` (reference) — `function panelMeta:CircleExpandHover(col, speed)`
  - `gamemode/core/meta/panel.lua:1058` (reference) — `speed = speed or 6`
  - `gamemode/core/meta/panel.lua:1058` (reference) — `speed = speed or 6`
  - `gamemode/core/meta/panel.lua:1059` (reference) — `self:SetupTransition("CircleExpandHover", speed, function(s) return s:IsHovered() end)`

## Removed privileges (31)

### `canAccessFlagManagement` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:576` (Privileges) — `["canAccessFlagManagement"] = {`

### `canAccessItemInformations` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:686` (Privileges) — `["canAccessItemInformations"] = {`

### `canAccessPlayerList` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:566` (Privileges) — `["canAccessPlayerList"] = {`
- Stable Usages:
  - `gamemode/modules/administration/netcalls/server.lua:1315` (hasPrivilege("canAccessPlayerList") — `if not client:hasPrivilege("canAccessPlayerList") then return end`

### `canEditWeapons` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:736` (Privileges) — `["canEditWeapons"] = {`

### `command_ban` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:796` (Privileges) — `["command_ban"] = {`

### `command_bring` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:861` (Privileges) — `["command_bring"] = {`

### `command_cloak` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:886` (Privileges) — `["command_cloak"] = {`

### `command_extinguish` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:911` (Privileges) — `["command_extinguish"] = {`

### `command_freeze` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:811` (Privileges) — `["command_freeze"] = {`

### `command_gag` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:841` (Privileges) — `["command_gag"] = {`

### `command_god` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:896` (Privileges) — `["command_god"] = {`

### `command_ignite` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:906` (Privileges) — `["command_ignite"] = {`

### `command_jail` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:876` (Privileges) — `["command_jail"] = {`

### `command_kick` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:801` (Privileges) — `["command_kick"] = {`

### `command_kill` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:806` (Privileges) — `["command_kill"] = {`

### `command_respawn` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:826` (Privileges) — `["command_respawn"] = {`

### `command_return` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:871` (Privileges) — `["command_return"] = {`

### `command_slay` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:821` (Privileges) — `["command_slay"] = {`

### `command_strip` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:916` (Privileges) — `["command_strip"] = {`

### `command_unblind` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:836` (Privileges) — `["command_unblind"] = {`

### `command_uncloak` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:891` (Privileges) — `["command_uncloak"] = {`

### `command_unfreeze` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:816` (Privileges) — `["command_unfreeze"] = {`

### `command_ungag` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:846` (Privileges) — `["command_ungag"] = {`

### `command_ungod` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:901` (Privileges) — `["command_ungod"] = {`

### `command_unjail` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:881` (Privileges) — `["command_unjail"] = {`

### `command_unmute` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:856` (Privileges) — `["command_unmute"] = {`

### `examplePrivilege` — USED
- Stable Declarations:
  - `gamemode/core/libraries/admin.lua:1472` (registerPrivilege) — `ID = "examplePrivilege",`

### `manageAttributes` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:606` (Privileges) — `["manageAttributes"] = {`

### `manageClasses` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:621` (Privileges) — `["manageClasses"] = {`

### `receiveCheaterNotifications` — USED
- Stable Declarations:
  - `gamemode/modules/administration/module.lua:646` (Privileges) — `["receiveCheaterNotifications"] = {`
- Stable Usages:
  - `gamemode/modules/protection/libraries/server.lua:391` (hasPrivilege("receiveCheaterNotifications") — `local hasReceiveCheaterNotifications = p:hasPrivilege("receiveCheaterNotifications")`
  - `gamemode/modules/protection/libraries/server.lua:403` (hasPrivilege("receiveCheaterNotifications") — `local permission = staff:hasPrivilege("receiveCheaterNotifications")`
  - `gamemode/core/netcalls/server.lua:588` (hasPrivilege("receiveCheaterNotifications") — `local hasReceiveCheaterNotifications = p:hasPrivilege("receiveCheaterNotifications")`
  - `gamemode/core/netcalls/server.lua:601` (hasPrivilege("receiveCheaterNotifications") — `local permission = staff:hasPrivilege("receiveCheaterNotifications")`

### `teleportToEntity` — USED
- Stable Declarations:
  - `gamemode/modules/protection/module.lua:163` (Privileges) — `["teleportToEntity"] = {`
- Stable Usages:
  - `gamemode/modules/protection/libraries/client.lua:215` (hasPrivilege("teleportToEntity") — `local canTeleportToEntity = client:hasPrivilege("teleportToEntity")`
  - `gamemode/core/netcalls/server.lua:654` (hasPrivilege("teleportToEntity") — `lia.debug("[Permissions]", "Permission Check for net.Receive liaTeleportToEntity", "hasPrivilege(teleportToEntity)=", tostring(client:hasPrivilege("teleportToEntity")), "finalResult=", tostring(client:hasPrivilege("teleportToEntity")))`
  - `gamemode/core/netcalls/server.lua:654` (hasPrivilege("teleportToEntity") — `lia.debug("[Permissions]", "Permission Check for net.Receive liaTeleportToEntity", "hasPrivilege(teleportToEntity)=", tostring(client:hasPrivilege("teleportToEntity")), "finalResult=", tostring(client:hasPrivilege("teleportToEntity")))`
  - `gamemode/core/netcalls/server.lua:655` (hasPrivilege("teleportToEntity") — `if not client:hasPrivilege("teleportToEntity") then`

## Removed meta methods (0)

None found.


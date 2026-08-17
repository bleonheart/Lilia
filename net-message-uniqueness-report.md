# Net-message caller uniqueness report

Recursive review of Lua files under `gamemode`, including libraries, modules, submodules, entities, panels, metadata, hooks, and netcall files.

## Interpretation

- **Unique to one library** means every literal send/call site (`net.Start("name")`) is in the same exact library file?for example, `liaCfgList` is attributed to `gamemode/core/libraries/config.lua` when that is its sole library caller.
- **Unique to one module** means every literal send/call site under `gamemode/modules` is in one top-level module. The report additionally identifies a sole submodule when applicable.
- Registration, receiving, and handler-definition locations are listed for context but do not make a message belong to a caller library/module.
- `send/start` represents the call site; the following `net.Send*`/`net.Broadcast` is the transport action. `receive/handler` represents `net.Receive` and its callback definition.
- Dynamic names such as `net.Start(option.net)` are not assigned to a concrete message unless statically visible.

Static message names found: **251**. Messages with a unique literal caller library/module: **138**.

## Library callers

### `BodygrouperMenu` - unique to library caller

Purpose: Handles the bodygrouper menu network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core | `gamemode/entities/entities/lia_bodygrouper/init.lua:12` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:4570` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:9158` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:2145` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1743` |
| send/start | gamemode/core | `gamemode/core/derma/panels/bodygrouper.lua:103` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaAdminModeSwapCharacter` - unique to library caller

Purpose: Handles the admin mode swap character network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/client.lua:99` |
| send/start | gamemode/core; library gamemode/core/libraries/keybind.lua | `gamemode/core/libraries/keybind.lua:1329` |
| send/start | gamemode/core; library gamemode/core/libraries/keybind.lua | `gamemode/core/libraries/keybind.lua:1363` |
| send/start | gamemode/core; library gamemode/core/libraries/keybind.lua | `gamemode/core/libraries/keybind.lua:1384` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaBigTableAck` - unique to library caller

Purpose: Handles the big table ack network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/net.lua | `gamemode/core/libraries/net.lua:361` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1391` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaBlindFade` - unique to library caller

Purpose: Handles the blind fade network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/client.lua:69` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:2922` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:2968` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:3305` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:3330` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCfgList` - unique to library caller

Purpose: Handles the cfg list network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/core; library gamemode/core/libraries/config.lua | `gamemode/core/libraries/config.lua:638` |
| send/start | gamemode/core; library gamemode/core/libraries/config.lua | `gamemode/core/libraries/config.lua:793` |
| receive/handler | gamemode/core; library gamemode/core/libraries/config.lua | `gamemode/core/libraries/config.lua:848` |
| send/start | gamemode/core; library gamemode/core/libraries/config.lua | `gamemode/core/libraries/config.lua:1497` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCfgSet` - unique to library caller

Purpose: Handles the cfg set network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/config.lua | `gamemode/core/libraries/config.lua:584` |
| receive/handler | gamemode/core; library gamemode/core/libraries/config.lua | `gamemode/core/libraries/config.lua:653` |
| receive/handler | gamemode/core; library gamemode/core/libraries/config.lua | `gamemode/core/libraries/config.lua:853` |
| send/start | gamemode/core; library gamemode/core/libraries/config.lua | `gamemode/core/libraries/config.lua:931` |
| send/start | gamemode/core | `gamemode/core/derma/panels/f1menu.lua:2985` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCharDeleted` - unique to library caller

Purpose: Handles the char deleted network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/client.lua:320` |
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:1594` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCharKick` - unique to library caller

Purpose: Handles the char kick network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:1521` |
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:1584` |
| send/start | gamemode/core | `gamemode/core/meta/character.lua:1268` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1613` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCharRequest` - unique to library caller

Purpose: Handles the char request network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:403` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:959` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCharSet` - unique to library caller

Purpose: Handles the char set network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:642` |
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:655` |
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:766` |
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:857` |
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:884` |
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:921` |
| send/start | gamemode/core | `gamemode/core/meta/character.lua:987` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1074` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCharVar` - unique to library caller

Purpose: Handles the char var network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:998` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1088` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCharacterInvList` - unique to library caller

Purpose: Handles the character inv list network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:1032` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1048` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaChatMsg` - unique to library caller

Purpose: Handles the chat msg network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/chatbox.lua | `gamemode/core/libraries/chatbox.lua:403` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1898` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCmdArgPrompt` - unique to library caller

Purpose: Handles the cmd arg prompt network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:759` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1598` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCommandData` - unique to library caller

Purpose: Handles the command data network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:1064` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1349` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaDisplayCharList` - unique to library caller

Purpose: Handles the display char list network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/client.lua:326` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:2695` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaDoorDataUpdate` - unique to library caller

Purpose: Handles the door data update network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/doors.lua | `gamemode/core/libraries/doors.lua:192` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1942` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaGlobalVar` - unique to library caller

Purpose: Handles the global var network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/net.lua | `gamemode/core/libraries/net.lua:561` |
| send/start | gamemode/core | `gamemode/core/meta/player.lua:2851` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1619` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaGroupPermChanged` - unique to library caller

Purpose: Handles the group perm changed network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:2123` |
| send/start | gamemode/core | `gamemode/core/netcalls/server.lua:2045` |
| send/start | gamemode/core; library gamemode/core/libraries/compatibility/sam.lua | `gamemode/core/libraries/compatibility/sam.lua:94` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaGroupsAdd` - unique to library caller

Purpose: Handles the groups add network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/admin.lua | `gamemode/core/libraries/admin.lua:2914` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1896` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaGroupsRemove` - unique to library caller

Purpose: Handles the groups remove network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/admin.lua | `gamemode/core/libraries/admin.lua:3804` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1922` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaGroupsRename` - unique to library caller

Purpose: Handles the groups rename network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/admin.lua | `gamemode/core/libraries/admin.lua:3785` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1938` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaGroupsRequest` - unique to library caller

Purpose: Handles the groups request network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/admin.lua | `gamemode/core/libraries/admin.lua:3862` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1886` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaGroupsSetPerm` - unique to library caller

Purpose: Handles the groups set perm network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/admin.lua | `gamemode/core/libraries/admin.lua:3821` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:2008` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaKeybindServer` - unique to library caller

Purpose: Handles the keybind server network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/keybind.lua | `gamemode/core/libraries/keybind.lua:1531` |
| send/start | gamemode/core; library gamemode/core/libraries/keybind.lua | `gamemode/core/libraries/keybind.lua:1549` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1031` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaManagesitrooms` - unique to library caller

Purpose: Handles the managesitrooms network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/client.lua:123` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:2402` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaNetStreamData` - unique to library caller

Purpose: Handles the net stream data network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/thirdparty/sh_net.lua | `gamemode/core/libraries/thirdparty/sh_net.lua:362` |
| receive/handler | gamemode/core; library gamemode/core/libraries/thirdparty/sh_net.lua | `gamemode/core/libraries/thirdparty/sh_net.lua:374` |
| send/start | gamemode/core; library gamemode/core/libraries/thirdparty/sh_net.lua | `gamemode/core/libraries/thirdparty/sh_net.lua:402` |
| receive/handler | gamemode/core; library gamemode/core/libraries/thirdparty/sh_net.lua | `gamemode/core/libraries/thirdparty/sh_net.lua:410` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaNotificationData` - unique to library caller

Purpose: Handles the notification data network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/core; library gamemode/core/libraries/notice.lua | `gamemode/core/libraries/notice.lua:61` |
| send/start | gamemode/core; library gamemode/core/libraries/notice.lua | `gamemode/core/libraries/notice.lua:431` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:2120` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaNotifyLocal` - unique to library caller

Purpose: Handles the notify local network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/core; library gamemode/core/libraries/notice.lua | `gamemode/core/libraries/notice.lua:101` |
| send/start | gamemode/core; library gamemode/core/libraries/notice.lua | `gamemode/core/libraries/notice.lua:385` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:2121` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaNpcCustomize` - unique to library caller

Purpose: Handles the npc customize network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/dialog.lua | `gamemode/core/libraries/dialog.lua:1388` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1684` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaOpenInvMenu` - unique to library caller

Purpose: Handles the open inv menu network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:3833` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1203` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaOpenNpcDialog` - unique to library caller

Purpose: Handles the open npc dialog network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/dialog.lua | `gamemode/core/libraries/dialog.lua:1325` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1646` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaOpenPanelBrowser` - unique to library caller

Purpose: Handles the open panel browser network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:8474` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:8483` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaRegenChat` - unique to library caller

Purpose: Handles the regen chat network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/chatbox | `gamemode/modules/chatbox/netcalls/client.lua:2` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:6093` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaRemoveFOne` - unique to library caller

Purpose: Handles the remove fone network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core | `gamemode/core/hooks/server.lua:1699` |
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:1582` |
| send/start | gamemode/core | `gamemode/core/meta/character.lua:1264` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1981` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaRemoveFeaturePosition` - unique to library caller

Purpose: Handles the remove feature position network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:873` |
| send/start | gamemode/core; library gamemode/core/libraries/util.lua | `gamemode/core/libraries/util.lua:2163` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaRequestInteractOptions` - unique to library caller

Purpose: Handles the request interact options network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/playerinteract.lua | `gamemode/core/libraries/playerinteract.lua:647` |
| send/start | gamemode/core; library gamemode/core/libraries/playerinteract.lua | `gamemode/core/libraries/playerinteract.lua:658` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1245` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaRequestNPCSelection` - unique to library caller

Purpose: Handles the request npcselection network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core | `gamemode/entities/entities/lia_npc/init.lua:57` |
| send/start | gamemode/core; library gamemode/core/libraries/dialog.lua | `gamemode/core/libraries/dialog.lua:1246` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1685` |
| send/start | gamemode/core | `gamemode/core/netcalls/client.lua:1706` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1707` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaWeaponOverrideUpdate` - unique to library caller

Purpose: Handles the weapon override update network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/item.lua | `gamemode/core/libraries/item.lua:1918` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:362` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaWeaponRuntimeOverrideReset` - unique to library caller

Purpose: Handles the weapon runtime override reset network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/item.lua | `gamemode/core/libraries/item.lua:2529` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:448` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaWeaponRuntimeOverrideUpdate` - unique to library caller

Purpose: Handles the weapon runtime override update network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/item.lua | `gamemode/core/libraries/item.lua:1928` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:423` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaWorkshopDownloaderInfo` - unique to library caller

Purpose: Handles the workshop downloader info network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/workshop.lua | `gamemode/core/libraries/workshop.lua:127` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:2122` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaWorkshopDownloaderRequest` - unique to library caller

Purpose: Handles the workshop downloader request network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/workshop.lua | `gamemode/core/libraries/workshop.lua:361` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1451` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaWorkshopDownloaderStart` - unique to library caller

Purpose: Handles the workshop downloader start network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/core; library gamemode/core/libraries/workshop.lua | `gamemode/core/libraries/workshop.lua:119` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:2108` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

## Module callers

### `liaAllPks` - unique to module caller

Purpose: Handles the all pks network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/client.lua:184` |
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:909` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaCharCreate` - unique to module caller

Purpose: Handles the char create network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/module.lua:561` |
| send/start | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/module.lua:571` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:791` |
| send/start | gamemode/core | `gamemode/core/netcalls/server.lua:793` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCharDelete` - unique to module caller

Purpose: Handles the char delete network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/module.lua:584` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:855` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCharList` - unique to module caller

Purpose: Handles the char list network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/module.lua:480` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:657` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaCharacterData` - unique to module caller

Purpose: Handles the character data network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/mainmenu; library gamemode/modules/mainmenu/libraries/server.lua | `gamemode/modules/mainmenu/libraries/server.lua:46` |
| send/start | gamemode/core; library gamemode/core/libraries/character.lua | `gamemode/core/libraries/character.lua:1776` |
| send/start | gamemode/core | `gamemode/core/meta/character.lua:563` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1632` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaChatboxAddFilteredWord` - unique to library caller, unique to module caller

Purpose: Handles the chatbox add filtered word network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/chatbox; library gamemode/modules/chatbox/libraries/client.lua | `gamemode/modules/chatbox/libraries/client.lua:196` |
| receive/handler | gamemode/modules/chatbox | `gamemode/modules/chatbox/netcalls/server.lua:7` |
| registration | gamemode/modules/chatbox | `gamemode/modules/chatbox/module.lua:317` |

---

### `liaChatboxRemoveFilteredWord` - unique to library caller, unique to module caller

Purpose: Handles the chatbox remove filtered word network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/chatbox; library gamemode/modules/chatbox/libraries/client.lua | `gamemode/modules/chatbox/libraries/client.lua:243` |
| receive/handler | gamemode/modules/chatbox | `gamemode/modules/chatbox/netcalls/server.lua:24` |
| registration | gamemode/modules/chatbox | `gamemode/modules/chatbox/module.lua:317` |

---

### `liaChatboxRequestFilteredWords` - unique to library caller, unique to module caller

Purpose: Handles the chatbox request filtered words network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/chatbox; library gamemode/modules/chatbox/libraries/client.lua | `gamemode/modules/chatbox/libraries/client.lua:580` |
| receive/handler | gamemode/modules/chatbox | `gamemode/modules/chatbox/netcalls/server.lua:2` |
| registration | gamemode/modules/chatbox | `gamemode/modules/chatbox/module.lua:317` |

---

### `liaChatboxSyncFilteredWords` - unique to library caller, unique to module caller

Purpose: Handles the chatbox sync filtered words network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/chatbox; library gamemode/modules/chatbox/libraries/server.lua | `gamemode/modules/chatbox/libraries/server.lua:121` |
| receive/handler | gamemode/modules/chatbox | `gamemode/modules/chatbox/netcalls/client.lua:13` |
| registration | gamemode/modules/chatbox | `gamemode/modules/chatbox/module.lua:317` |

---

### `liaCheckSeed` - unique to library caller, unique to module caller

Purpose: Handles the check seed network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/protection; library gamemode/modules/protection/libraries/client.lua | `gamemode/modules/protection/libraries/client.lua:44` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:566` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaClassUpdate` - unique to library caller, unique to module caller

Purpose: Handles the class update network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/teams; library gamemode/modules/teams/libraries/server.lua | `gamemode/modules/teams/libraries/server.lua:13` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:643` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaDoorMenu` - unique to library caller, unique to module caller

Purpose: Handles the door menu network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/doors; library gamemode/modules/doors/libraries/server.lua | `gamemode/modules/doors/libraries/server.lua:415` |
| send/start | gamemode/core | `gamemode/core/meta/entity.lua:520` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1920` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaFeaturePositions` - unique to module caller

Purpose: Handles the feature positions network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/client.lua:37` |
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:821` |
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:833` |
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:857` |
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:889` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaFeaturePositionsRequest` - unique to library caller, unique to module caller

Purpose: Handles the feature positions request network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/shared.lua | `gamemode/modules/administration/libraries/shared.lua:616` |
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/shared.lua | `gamemode/modules/administration/libraries/shared.lua:745` |
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/shared.lua | `gamemode/modules/administration/libraries/shared.lua:816` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:811` |
| send/start | gamemode/modules/administration/submodules/adminstick | `gamemode/modules/administration/submodules/adminstick/entities/weapons/lia_adminstick/cl_init.lua:225` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaInsertKeyPressed` - unique to library caller, unique to module caller

Purpose: Handles the insert key pressed network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/protection; library gamemode/modules/protection/libraries/client.lua | `gamemode/modules/protection/libraries/client.lua:33` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:471` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaInvAct` - unique to library caller, unique to module caller

Purpose: Handles the inv act network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/inventory | `gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory.lua:328` |
| send/start | gamemode/core | `gamemode/core/hooks/client.lua:1548` |
| send/start | gamemode/core | `gamemode/core/hooks/client.lua:1569` |
| send/start | gamemode/core; library gamemode/core/libraries/keybind.lua | `gamemode/core/libraries/keybind.lua:476` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1183` |
| send/start | gamemode/core | `gamemode/core/derma/panels/item.lua:147` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaInventoryDelete` - unique to module caller

Purpose: Handles the inventory delete network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/inventory | `gamemode/modules/inventory/types/gridinv/items/base/bags.lua:118` |
| send/start | gamemode/core | `gamemode/core/meta/inventory.lua:1145` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/client.lua:1027` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaKickCharacterToBase` - unique to library caller, unique to module caller

Purpose: Handles the kick character to base network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/teams; library gamemode/modules/teams/libraries/client.lua | `gamemode/modules/teams/libraries/client.lua:721` |
| receive/handler | gamemode/modules/teams | `gamemode/modules/teams/netcalls/server.lua:18` |
| registration | gamemode/modules/teams | `gamemode/modules/teams/module.lua:345` |

---

### `liaMainCharacterSet` - unique to module caller

Purpose: Handles the main character set network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/netcalls/client.lua:1` |
| send/start | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/netcalls/server.lua:6` |
| registration | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/module.lua:476` |

---

### `liaManagesitroomsAction` - unique to module caller

Purpose: Handles the managesitrooms action network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/client.lua:150` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:769` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaMapEntityAction` - unique to library caller, unique to module caller

Purpose: Handles the map entity action network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:1591` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:1522` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaModifyCharacterFlags` - unique to library caller, unique to module caller

Purpose: Handles the modify character flags network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:4205` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:1183` |
| registration | gamemode/core | `gamemode/init.lua:2` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaModifyFlags` - unique to module caller

Purpose: Handles the modify flags network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:309` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:1155` |
| send/start | gamemode/modules/administration/submodules/adminstick; library gamemode/modules/administration/submodules/adminstick/libraries/client.lua | `gamemode/modules/administration/submodules/adminstick/libraries/client.lua:1187` |
| send/start | gamemode/modules/administration/submodules/adminstick; library gamemode/modules/administration/submodules/adminstick/libraries/client.lua | `gamemode/modules/administration/submodules/adminstick/libraries/client.lua:1204` |
| send/start | gamemode/modules/administration/submodules/adminstick; library gamemode/modules/administration/submodules/adminstick/libraries/client.lua | `gamemode/modules/administration/submodules/adminstick/libraries/client.lua:1215` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaNetProfilerSnapshot` - unique to module caller

Purpose: Handles the net profiler snapshot network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:4706` |
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:82` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaOnlineStaffData` - unique to module caller

Purpose: Handles the online staff data network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/client.lua:321` |
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:1608` |
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:1670` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaPksCount` - unique to module caller

Purpose: Handles the pks count network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:919` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaPlayerRespawn` - unique to library caller, unique to module caller

Purpose: Handles the player respawn network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/spawns; library gamemode/modules/spawns/libraries/client.lua | `gamemode/modules/spawns/libraries/client.lua:279` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:308` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaRequestFactionMemberDetails` - unique to library caller, unique to module caller

Purpose: Handles the request faction member details network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/teams; library gamemode/modules/teams/libraries/client.lua | `gamemode/modules/teams/libraries/client.lua:220` |
| receive/handler | gamemode/modules/teams | `gamemode/modules/teams/netcalls/server.lua:10` |
| registration | gamemode/modules/teams | `gamemode/modules/teams/module.lua:345` |

---

### `liaRequestFactionMembers` - unique to library caller, unique to module caller

Purpose: Handles the request faction members network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/teams; library gamemode/modules/teams/libraries/client.lua | `gamemode/modules/teams/libraries/client.lua:358` |
| send/start | gamemode/modules/teams; library gamemode/modules/teams/libraries/client.lua | `gamemode/modules/teams/libraries/client.lua:391` |
| receive/handler | gamemode/modules/teams | `gamemode/modules/teams/netcalls/server.lua:2` |
| registration | gamemode/modules/teams | `gamemode/modules/teams/module.lua:345` |

---

### `liaRequestFullCharListPage` - unique to library caller, unique to module caller

Purpose: Handles the request full char list page network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:45` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:1105` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaRequestMapEntities` - unique to library caller, unique to module caller

Purpose: Handles the request map entities network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:2607` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:1515` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaRequestNetProfilerLogs` - unique to library caller, unique to module caller

Purpose: Handles the request net profiler logs network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:3610` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:552` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaRequestRemoveWarning` - unique to library caller, unique to module caller

Purpose: Handles the request remove warning network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:983` |
| receive/handler | gamemode/modules/administration/submodules/warnings | `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:2` |
| registration | gamemode/modules/administration/submodules/warnings | `gamemode/modules/administration/submodules/warnings/module.lua:196` |

---

### `liaRequestStaffCases` - unique to library caller, unique to module caller

Purpose: Handles the request staff cases network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:1239` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:925` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaRequestStaffCharacterConfiguration` - unique to library caller, unique to module caller

Purpose: Handles the request staff character configuration network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:6018` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:484` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaRequestToolPermissionTiers` - unique to library caller, unique to module caller

Purpose: Handles the request tool permission tiers network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:6623` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:542` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaResetStaffCharacterConfiguration` - unique to library caller, unique to module caller

Purpose: Handles the reset staff character configuration network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:5699` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:505` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaResetToolPermissionTiers` - unique to library caller, unique to module caller

Purpose: Handles the reset tool permission tiers network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:6193` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:617` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaRestoreOverflowItems` - unique to module caller

Purpose: Handles the restore overflow items network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/inventory | `gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory.lua:54` |
| receive/handler | gamemode/modules/inventory | `gamemode/modules/inventory/types/gridinv/netcalls/server.lua:1` |
| registration | gamemode/modules/inventory | `gamemode/modules/inventory/types/gridinv/module.lua:297` |

---

### `liaRgnDone` - unique to library caller, unique to module caller

Purpose: Handles the rgn done network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/recognition | `gamemode/modules/recognition/pim.lua:49` |
| send/start | gamemode/modules/recognition | `gamemode/modules/recognition/pim.lua:93` |
| send/start | gamemode/modules/recognition; library gamemode/modules/recognition/libraries/server.lua | `gamemode/modules/recognition/libraries/server.lua:18` |
| receive/handler | gamemode/modules/recognition | `gamemode/modules/recognition/netcalls/client.lua:1` |
| registration | gamemode/modules/recognition | `gamemode/modules/recognition/module.lua:92` |

---

### `liaSaveFactionNote` - unique to library caller, unique to module caller

Purpose: Handles the save faction note network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/teams; library gamemode/modules/teams/libraries/client.lua | `gamemode/modules/teams/libraries/client.lua:271` |
| receive/handler | gamemode/modules/teams | `gamemode/modules/teams/netcalls/server.lua:100` |
| registration | gamemode/modules/teams | `gamemode/modules/teams/module.lua:345` |

---

### `liaSetFeaturePosition` - unique to library caller, unique to module caller

Purpose: Handles the set feature position network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/shared.lua | `gamemode/modules/administration/libraries/shared.lua:563` |
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/shared.lua | `gamemode/modules/administration/libraries/shared.lua:689` |
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/shared.lua | `gamemode/modules/administration/libraries/shared.lua:793` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:841` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaSetMainCharacter` - unique to module caller

Purpose: Handles the set main character network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/module.lua:599` |
| receive/handler | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/netcalls/server.lua:1` |
| send/start | gamemode/core | `gamemode/core/meta/player.lua:1657` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaSetStaffCharacterFlag` - unique to library caller, unique to module caller

Purpose: Handles the set staff character flag network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:5955` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:495` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaSetStaffCharacterPermission` - unique to library caller, unique to module caller

Purpose: Handles the set staff character permission network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:5917` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:485` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaSetToolPermissionTier` - unique to library caller, unique to module caller

Purpose: Handles the set tool permission tier network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:6152` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:578` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaSetToolPermissionTiersBatch` - unique to library caller, unique to module caller

Purpose: Handles the set tool permission tiers batch network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:6176` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:590` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaSpawnMenuGiveItem` - unique to library caller, unique to module caller

Purpose: Handles the spawn menu give item network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:4585` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:756` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaSpawnMenuSpawnItem` - unique to library caller, unique to module caller

Purpose: Handles the spawn menu spawn item network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:4578` |
| receive/handler | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:719` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaSpeciesCreatorOpen` - unique to library caller, unique to module caller

Purpose: Handles the species creator open network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/species_creator_poc; library gamemode/modules/species_creator_poc/libraries/shared.lua | `gamemode/modules/species_creator_poc/libraries/shared.lua:277` |
| receive/handler | gamemode/modules/species_creator_poc | `gamemode/modules/species_creator_poc/netcalls/client.lua:1` |
| registration | gamemode/modules/species_creator_poc | `gamemode/modules/species_creator_poc/module.lua:5` |

---

### `liaStaffCharacterConfiguration` - unique to module caller

Purpose: Handles the staff character configuration network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:5484` |
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:479` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaStaffDiscordResponse` - unique to module caller

Purpose: Handles the staff discord response network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/netcalls/client.lua:16` |
| send/start | gamemode/modules/mainmenu | `gamemode/modules/mainmenu/netcalls/client.lua:20` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:925` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaTicketSystemClaim` - unique to module caller

Purpose: Handles the ticket system claim network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:963` |
| send/start | gamemode/modules/administration/submodules/tickets; library gamemode/modules/administration/submodules/tickets/libraries/client.lua | `gamemode/modules/administration/submodules/tickets/libraries/client.lua:155` |
| receive/handler | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/client.lua:120` |
| receive/handler | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:12` |
| send/start | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:30` |
| registration | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/module.lua:234` |

---

### `liaTicketSystemClose` - unique to module caller

Purpose: Handles the ticket system close network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:970` |
| send/start | gamemode/modules/administration/submodules/tickets; library gamemode/modules/administration/submodules/tickets/libraries/client.lua | `gamemode/modules/administration/submodules/tickets/libraries/client.lua:161` |
| send/start | gamemode/modules/administration/submodules/tickets; library gamemode/modules/administration/submodules/tickets/libraries/server.lua | `gamemode/modules/administration/submodules/tickets/libraries/server.lua:113` |
| send/start | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/client.lua:132` |
| receive/handler | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/client.lua:143` |
| receive/handler | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:59` |
| send/start | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:74` |
| registration | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/module.lua:234` |

---

### `liaToolPermissionTiers` - unique to module caller

Purpose: Handles the tool permission tiers network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration; library gamemode/modules/administration/libraries/client.lua | `gamemode/modules/administration/libraries/client.lua:5465` |
| send/start | gamemode/modules/administration | `gamemode/modules/administration/netcalls/server.lua:533` |
| registration | gamemode/modules/administration | `gamemode/modules/administration/module.lua:502` |

---

### `liaTransferItem` - unique to module caller

Purpose: Handles the transfer item network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/inventory | `gamemode/modules/inventory/types/gridinv/gridinv.lua:378` |
| send/start | gamemode/modules/inventory | `gamemode/modules/inventory/types/weightinv/weightinv.lua:168` |
| receive/handler | gamemode/core | `gamemode/core/netcalls/server.lua:1173` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaVendorAllowClass` - unique to library caller, unique to module caller

Purpose: Handles the vendor allow class network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor; library gamemode/modules/vendor/libraries/server.lua | `gamemode/modules/vendor/libraries/server.lua:233` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:130` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:88` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorAllowFaction` - unique to library caller, unique to module caller

Purpose: Handles the vendor allow faction network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor; library gamemode/modules/vendor/libraries/server.lua | `gamemode/modules/vendor/libraries/server.lua:224` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:116` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:69` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorDeletePreset` - unique to module caller

Purpose: Handles the vendor delete preset network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/derma/client.lua:1837` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:44` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorEdit` - unique to library caller, unique to module caller

Purpose: Handles the vendor edit network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/derma/client.lua:1635` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:49` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:6` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:113` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:196` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:205` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:215` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:224` |
| send/start | gamemode/core; library gamemode/core/libraries/vendor.lua | `gamemode/core/libraries/vendor.lua:175` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaVendorExit` - unique to module caller

Purpose: Handles the vendor exit network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/derma/client.lua:451` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:44` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:1` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:99` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:179` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorFactionBuyScale` - unique to library caller, unique to module caller

Purpose: Handles the vendor faction buy scale network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor; library gamemode/modules/vendor/libraries/server.lua | `gamemode/modules/vendor/libraries/server.lua:197` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:144` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/shared.lua:111` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorFactionSellScale` - unique to library caller, unique to module caller

Purpose: Handles the vendor faction sell scale network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor; library gamemode/modules/vendor/libraries/server.lua | `gamemode/modules/vendor/libraries/server.lua:208` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:154` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/shared.lua:123` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorInitialSync` - unique to library caller, unique to module caller

Purpose: Handles the vendor initial sync network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor; library gamemode/modules/vendor/libraries/server.lua | `gamemode/modules/vendor/libraries/server.lua:248` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:172` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorLoadPreset` - unique to module caller

Purpose: Handles the vendor load preset network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/derma/client.lua:1757` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:33` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorMaxStock` - unique to module caller

Purpose: Handles the vendor max stock network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:105` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:55` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:170` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorMode` - unique to module caller

Purpose: Handles the vendor mode network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:84` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:123` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorOpen` - unique to library caller, unique to module caller

Purpose: Handles the vendor open network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor; library gamemode/modules/vendor/libraries/server.lua | `gamemode/modules/vendor/libraries/server.lua:168` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:33` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorPropertySync` - unique to module caller

Purpose: Handles the vendor property sync network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor; library gamemode/modules/vendor/libraries/server.lua | `gamemode/modules/vendor/libraries/server.lua:177` |
| send/start | gamemode/modules/vendor; library gamemode/modules/vendor/libraries/server.lua | `gamemode/modules/vendor/libraries/server.lua:186` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:191` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:107` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:116` |
| send/start | gamemode/core; library gamemode/core/libraries/vendor.lua | `gamemode/core/libraries/vendor.lua:287` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaVendorRequestData` - unique to module caller

Purpose: Handles the vendor request data network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:37` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:101` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/cl_init.lua:26` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorSavePreset` - unique to module caller

Purpose: Handles the vendor save preset network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/derma/client.lua:1060` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:72` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorStock` - unique to module caller

Purpose: Handles the vendor stock network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:95` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:32` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:159` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorSync` - unique to module caller

Purpose: Handles the vendor sync network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:1` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:263` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:280` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorSyncMessages` - unique to library caller, unique to module caller

Purpose: Handles the vendor sync messages network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor; library gamemode/modules/vendor/libraries/server.lua | `gamemode/modules/vendor/libraries/server.lua:217` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:164` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/entities/entities/lia_vendor/shared.lua:157` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVendorSyncPresets` - unique to module caller

Purpose: Handles the vendor sync presets network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor; library gamemode/modules/vendor/libraries/server.lua | `gamemode/modules/vendor/libraries/server.lua:171` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/client.lua:171` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:67` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:96` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:5944` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaVendorTrade` - unique to module caller

Purpose: Handles the vendor trade network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/derma/client.lua:221` |
| send/start | gamemode/modules/vendor | `gamemode/modules/vendor/derma/client.lua:228` |
| receive/handler | gamemode/modules/vendor | `gamemode/modules/vendor/netcalls/server.lua:17` |
| registration | gamemode/modules/vendor | `gamemode/modules/vendor/module.lua:679` |

---

### `liaVerifyCheats` - unique to library caller, unique to module caller

Purpose: Handles the verify cheats network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/protection; library gamemode/modules/protection/libraries/server.lua | `gamemode/modules/protection/libraries/server.lua:322` |
| registration | gamemode/modules/protection | `gamemode/modules/protection/module.lua:156` |

---

## Submodule callers

### `liaActiveTickets` - unique to module caller, unique to submodule caller

Purpose: Handles the active tickets network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/client.lua:2` |
| send/start | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:106` |
| registration | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/module.lua:234` |

---

### `liaAdminStickPlayerState` - unique to library caller, unique to module caller, unique to submodule caller

Purpose: Handles the admin stick player state network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration/submodules/adminstick; library gamemode/modules/administration/submodules/adminstick/libraries/client.lua | `gamemode/modules/administration/submodules/adminstick/libraries/client.lua:3095` |
| send/start | gamemode/modules/administration/submodules/adminstick; library gamemode/modules/administration/submodules/adminstick/libraries/server.lua | `gamemode/modules/administration/submodules/adminstick/libraries/server.lua:39` |
| registration | gamemode/modules/administration/submodules/adminstick | `gamemode/modules/administration/submodules/adminstick/module.lua:5` |

---

### `liaAdminStickRequestPlayerState` - unique to library caller, unique to module caller, unique to submodule caller

Purpose: Handles the admin stick request player state network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration/submodules/adminstick; library gamemode/modules/administration/submodules/adminstick/libraries/client.lua | `gamemode/modules/administration/submodules/adminstick/libraries/client.lua:272` |
| receive/handler | gamemode/modules/administration/submodules/adminstick; library gamemode/modules/administration/submodules/adminstick/libraries/server.lua | `gamemode/modules/administration/submodules/adminstick/libraries/server.lua:35` |
| registration | gamemode/modules/administration/submodules/adminstick | `gamemode/modules/administration/submodules/adminstick/module.lua:5` |

---

### `liaAllWarnings` - unique to module caller, unique to submodule caller

Purpose: Handles the all warnings network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration/submodules/warnings | `gamemode/modules/administration/submodules/warnings/netcalls/client.lua:1` |
| send/start | gamemode/modules/administration/submodules/warnings | `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:47` |
| registration | gamemode/modules/administration/submodules/warnings | `gamemode/modules/administration/submodules/warnings/module.lua:196` |

---

### `liaClearAllTicketFrames` - unique to library caller, unique to module caller, unique to submodule caller

Purpose: Handles the clear all ticket frames network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration/submodules/tickets; library gamemode/modules/administration/submodules/tickets/libraries/server.lua | `gamemode/modules/administration/submodules/tickets/libraries/server.lua:100` |
| receive/handler | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/client.lua:153` |
| registration | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/module.lua:234` |

---

### `liaPlayerWarnings` - unique to module caller, unique to submodule caller

Purpose: Handles the player warnings network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration/submodules/warnings | `gamemode/modules/administration/submodules/warnings/netcalls/client.lua:86` |
| send/start | gamemode/modules/administration/submodules/warnings | `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:69` |
| registration | gamemode/modules/administration/submodules/warnings | `gamemode/modules/administration/submodules/warnings/module.lua:196` |

---

### `liaSendLogsCategories` - unique to module caller, unique to submodule caller

Purpose: Handles the send logs categories network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration/submodules/logs | `gamemode/modules/administration/submodules/logs/netcalls/client.lua:2` |
| send/start | gamemode/modules/administration/submodules/logs | `gamemode/modules/administration/submodules/logs/netcalls/server.lua:22` |
| registration | gamemode/modules/administration/submodules/logs | `gamemode/modules/administration/submodules/logs/module.lua:167` |

---

### `liaSendLogsCategoriesRequest` - unique to library caller, unique to module caller, unique to submodule caller

Purpose: Handles the send logs categories request network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration/submodules/logs; library gamemode/modules/administration/submodules/logs/libraries/client.lua | `gamemode/modules/administration/submodules/logs/libraries/client.lua:351` |
| receive/handler | gamemode/modules/administration/submodules/logs | `gamemode/modules/administration/submodules/logs/netcalls/server.lua:10` |
| registration | gamemode/modules/administration/submodules/logs | `gamemode/modules/administration/submodules/logs/module.lua:167` |

---

### `liaSendLogsRequest` - unique to library caller, unique to module caller, unique to submodule caller

Purpose: Handles the send logs request network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration/submodules/logs; library gamemode/modules/administration/submodules/logs/libraries/client.lua | `gamemode/modules/administration/submodules/logs/libraries/client.lua:250` |
| send/start | gamemode/modules/administration/submodules/logs; library gamemode/modules/administration/submodules/logs/libraries/client.lua | `gamemode/modules/administration/submodules/logs/libraries/client.lua:438` |
| receive/handler | gamemode/modules/administration/submodules/logs | `gamemode/modules/administration/submodules/logs/netcalls/server.lua:2` |
| registration | gamemode/modules/administration/submodules/logs | `gamemode/modules/administration/submodules/logs/module.lua:167` |

---

### `liaStorageExit` - unique to library caller, unique to module caller, unique to submodule caller

Purpose: Handles the storage exit network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/inventory/submodules/storage; library gamemode/modules/inventory/types/gridinv/submodules/storage/libraries/client.lua | `gamemode/modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:8` |
| receive/handler | gamemode/modules/inventory/submodules/storage | `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:1` |
| registration | gamemode/modules/inventory/submodules/storage | `gamemode/modules/inventory/types/gridinv/submodules/storage/module.lua:288` |

---

### `liaStorageOpen` - unique to library caller, unique to module caller, unique to submodule caller

Purpose: Handles the storage open network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/inventory/submodules/storage | `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua:6` |
| send/start | gamemode/modules/inventory/submodules/storage | `gamemode/modules/inventory/types/gridinv/submodules/storage/entities/entities/lia_storage/init.lua:51` |
| send/start | gamemode/core; library gamemode/core/libraries/commands.lua | `gamemode/core/libraries/commands.lua:5852` |
| registration | gamemode/core | `gamemode/init.lua:2` |

---

### `liaStorageSetPassword` - unique to library caller, unique to module caller, unique to submodule caller

Purpose: Handles the storage set password network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/inventory/submodules/storage; library gamemode/modules/inventory/types/gridinv/submodules/storage/libraries/client.lua | `gamemode/modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:72` |
| receive/handler | gamemode/modules/inventory/submodules/storage | `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:83` |
| registration | gamemode/modules/inventory/submodules/storage | `gamemode/modules/inventory/types/gridinv/submodules/storage/module.lua:288` |

---

### `liaStorageUnlock` - unique to library caller, unique to module caller, unique to submodule caller

Purpose: Handles the storage unlock network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/inventory/submodules/storage; library gamemode/modules/inventory/types/gridinv/submodules/storage/libraries/client.lua | `gamemode/modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:15` |
| receive/handler | gamemode/modules/inventory/submodules/storage | `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua:1` |
| receive/handler | gamemode/modules/inventory/submodules/storage | `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:7` |
| send/start | gamemode/modules/inventory/submodules/storage | `gamemode/modules/inventory/types/gridinv/submodules/storage/entities/entities/lia_storage/init.lua:73` |
| registration | gamemode/modules/inventory/submodules/storage | `gamemode/modules/inventory/types/gridinv/submodules/storage/module.lua:288` |

---

### `liaTicketSystem` - unique to library caller, unique to module caller, unique to submodule caller

Purpose: Handles the ticket system network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration/submodules/tickets; library gamemode/modules/administration/submodules/tickets/libraries/server.lua | `gamemode/modules/administration/submodules/tickets/libraries/server.lua:10` |
| receive/handler | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/client.lua:111` |
| registration | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/module.lua:234` |

---

### `liaTicketsCount` - unique to module caller, unique to submodule caller

Purpose: Handles the tickets count network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:118` |
| registration | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/module.lua:234` |

---

### `liaViewClaims` - unique to module caller, unique to submodule caller

Purpose: Handles the view claims network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| receive/handler | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/client.lua:98` |
| receive/handler | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:2` |
| send/start | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:5` |
| registration | gamemode/modules/administration/submodules/tickets | `gamemode/modules/administration/submodules/tickets/module.lua:234` |

---

### `liaWarningsCount` - unique to module caller, unique to submodule caller

Purpose: Handles the warnings count network operation.

| Role | Library/module/submodule | File and line |
|---|---|---|
| send/start | gamemode/modules/administration/submodules/warnings | `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:57` |
| registration | gamemode/modules/administration/submodules/warnings | `gamemode/modules/administration/submodules/warnings/module.lua:196` |

---

## Registration-only names

Registered names with no literal `net.Start` or `net.Receive` call in this repository. These may be dynamic, external, or stale.

| Message | Registration location |
|---|---|
| `liaAllFlags` | `gamemode/modules/administration/module.lua:502` |
| `liaAllPlayers` | `gamemode/modules/administration/module.lua:502` |
| `liaDialogSync` | `gamemode/init.lua:2` |
| `liaDoorDataBulk` | `gamemode/init.lua:2` |
| `liaFactionMemberDetails` | `gamemode/modules/teams/module.lua:345` |
| `liaFactionMembers` | `gamemode/modules/teams/module.lua:345` |
| `liaFullCharList` | `gamemode/modules/administration/module.lua:502` |
| `liaFullCharListPage` | `gamemode/modules/administration/module.lua:502` |
| `liaMapEntities` | `gamemode/modules/administration/module.lua:502` |
| `liaNetProfilerLogs` | `gamemode/modules/administration/module.lua:502` |
| `liaPlayerInteractCategories` | `gamemode/init.lua:2` |
| `liaPlayerInteractSync` | `gamemode/init.lua:2` |
| `liaSendLogs` | `gamemode/modules/administration/submodules/logs/module.lua:167` |
| `liaSendTableUI` | `gamemode/init.lua:2` |
| `liaStaffCasesSnapshot` | `gamemode/modules/administration/module.lua:502` |
| `liaStaffSummary` | `gamemode/modules/administration/module.lua:502` |
| `liaSyncGesture` | `gamemode/init.lua:2` |
| `liaUpdateAdminGroups` | `gamemode/init.lua:2` |
| `liaUpdateAdminPrivileges` | `gamemode/init.lua:2` |

## Limitations

This is a lexical scan: it does not execute Lua, resolve arbitrary variables or concatenation, or inspect external addons. Helper APIs that accept a variable message name require runtime/data-flow analysis for complete concrete-name attribution.

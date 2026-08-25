# Lilia ownership report

Generated before refactoring from the complete `gamemode/**/*.lua` scan. The loader and all module, submodule, compatibility, entity, weapon, derma, library, command, and netcall paths were inspected.

## Loader and realm baseline

`gamemode/core/libraries/loader.lua` loads core packages in a fixed order, then compatibility integrations, then `gamemode/modules/*` through `lia.module.loadFromDir`. `gamemode/core/libraries/core/modularity/core.lua` loads each module's `module.lua`, root extras, ordered `libraries`, `commands`, `netcalls`, `derma`, entities, items, and recursive submodules. `shared.lua` registers the legacy global network-string list; module `MODULE.NetworkStrings` are registered by the module loader. Entity `init.lua`, `shared.lua`, and `cl_init.lua` are loaded by `includeEntities` in server/shared/client order.

## Ownership decisions

| Current source | Implementation context | Current realm | Proposed destination | Decision |
|---|---|---:|---|---|
| `modules/recognition/pim.lua:1-103` | Recognition interaction actions and recognition network send | server | `modules/recognition/libraries/server.lua` | Move; preserve local helpers and registration order |
| `modules/teams/pim.lua:1-121` | Faction/class invitation interaction actions | server | `modules/teams/libraries/server.lua` | Move; preserve interaction IDs and callbacks |
| `core/netcalls/server.lua:27-41` | Protection/anti-tamper SteamID seed validation | server | `modules/protection/netcalls/server.lua` | Move; register `liaCheckSeed` through protection module metadata |
| `core/netcalls/server.lua:1-11` | Protection INSERT-key anti-cheat notification | server | `modules/protection/netcalls/server.lua` | Move; register `liaInsertKeyPressed` through protection module metadata |
| `core/netcalls/server.lua:15-35` | Chat input dispatch | server | `modules/chatbox/netcalls/server.lua` | Move; register `liaMessageData` through chatbox metadata |
| `core/netcalls/client.lua:125-250` | Chatbox display handlers | client | `modules/chatbox/netcalls/client.lua` | Move; register `liaChatMsg` and server chat display messages through chatbox metadata |
| `core/netcalls/server.lua:36-58` | Door access permission updates | server | `modules/doors/netcalls/server.lua` | Move; register `liaDoorPerm` through doors metadata |
| `core/netcalls/client.lua:891-942` | Door menu, cached data, and permission UI handlers | client | `modules/doors/netcalls/client.lua` | Move; register door network messages through doors metadata |
| `core/netcalls/server.lua:59-69` | Main-menu Discord response | server | `modules/mainmenu/netcalls/server.lua` | Move; register `liaStaffDiscordResponse` through main-menu metadata |
| `core/netcalls/server.lua:742-861` | Administration bodygroup menu authorization and response | server | `modules/administration/netcalls/server.lua` | Move; preserve privilege checks and response message |
| `core/netcalls/client.lua:945-954` | Administration bodygroup menu UI handlers | client | `modules/administration/netcalls/client.lua` | Move; preserve panel state and message names |
| `core/netcalls/server.lua:862-877` | Administration model wardrobe selection | server | `modules/administration/netcalls/server.lua` | Move; reuse wardrobe access/model helpers already owned by administration |
| `core/netcalls/client.lua:955-1120` | Administration model wardrobe UI | client | `modules/administration/netcalls/client.lua` | Move; preserve model selection UI and network message |
| `core/libraries/core/attributes/core.lua:1-37` | Attribute registry/API | shared | `modules/attributes/libraries/shared.lua` | Domain-owned, but defer if schema/core consumers require bootstrap ordering |
| `core/libraries/core/attributes/netcalls.lua:1-8` | Attribute network handler | server/client as implemented | `modules/attributes/netcalls/{server,client}.lua` | Domain-owned; split only at existing realm boundary |
| `core/libraries/core/doors/core.lua:1-252` | Door state/API | shared | `modules/doors/libraries/shared.lua` | Domain-owned, but preserve loader ordering |
| `core/libraries/core/vendor/core.lua:1-287` | Vendor registry/API | shared | `modules/vendor/libraries/shared.lua` | Domain-owned, but preserve loader ordering |
| `core/libraries/core/inventory/{core:1-303,meta:1-378,netcalls:1-231}.lua` | Inventory registry/metatable/network | shared + client/server | `modules/inventory/libraries/{shared,client,server}.lua` and `modules/inventory/netcalls/{client,server}.lua` | Domain-owned; move as grouped implementation |
| `core/libraries/core/item/{core:1-1498,meta:1-421,netcalls:1-203}.lua` | Item registry/metatable/network | shared + client/server | `modules/inventory/libraries/{shared,client,server}.lua` and `modules/inventory/netcalls/{client,server}.lua` | Inventory/item ownership; preserve item API |
| `core/libraries/core/character/{core:1-1077,meta:1-509,commands:1-207,netcalls:1-287}.lua` | Character registry/metatable/commands/network | shared + client/server | character-owned module library/netcall/commands paths | Ambiguous: no character module currently exists; report rather than guess |
| `core/libraries/core/flags/{core:1-415,commands:1-122}.lua` | Flag registry and flag commands | shared + server | administration/flags-owned paths | Ambiguous: no flags module currently exists; generic permission infrastructure is also consumed by core |
| `core/libraries/core/player/{core:1,meta:1-1256,commands:1-18,netcalls:1-64}.lua` | Player API/metatable/network | shared + client/server | administration/player-owned paths | Ambiguous: player API is framework-wide and has cross-module consumers; retain in core |
| `core/libraries/compatibility/*/core.lua` | Explicit third-party compatibility integrations | declared per loader | existing `core/libraries/compatibility/<integration>` | Retain; compatibility behavior must stay isolated |
| `core/libraries/core/{commands,config,data,database,modularity,net,util}.lua` | Framework/loader/database/config/network/utility infrastructure | declared per loader | existing core paths | Retain as genuinely generic infrastructure |

## Registration inventory

The following repository searches were run against every Lua file. Source line numbers are retained in the scan output and should be used as the authoritative exact locations during edits.

### Commands

- `concommand.Add`: `modules/administration/commands.lua`, `modules/inventory/commands.lua`, `modules/protection/commands.lua`, `core/libraries/performance.lua`, `core/libraries/core/workshop/{commands,netcalls}.lua`, `core/libraries/core/sit/commands.lua`, `core/libraries/core/player/commands.lua`, `core/libraries/core/net/core.lua`, `core/libraries/core/flags/commands.lua`, `core/libraries/core/config/commands.lua`, `core/libraries/core/commands/core.lua`, `core/libraries/core/character/commands.lua`, `core/libraries/core/camera/commands.lua`, `core/derma/panels/circle.lua`.
- `lia.command.add`: module-local command files for vendor, administration, warnings, tickets, inventory, spawns, teams, recognition, and doors; plus core command packages, compatibility integrations, and schema/framework commands. Each occurrence was checked by file and line with `rg -n "lia\\.command\\.add" --glob '*.lua' gamemode`.

### Network

- `util.AddNetworkString`: `gamemode/init.lua` legacy global list and module-loader registration from `MODULE.NetworkStrings`; no module metadata is to be removed.
- `net.Receive`, `net.Start`, `net.Send`, `net.Broadcast`, and `net.SendToServer`: all occurrences were enumerated with `rg -n` across `gamemode/**/*.lua`; module-local handlers already reside in module/submodule `netcalls` except the recognition and teams root `pim.lua` implementations above and the core domain packages listed above.

### Hooks and metatables

- Module hook methods are declared as `MODULE:<HookName>` or `function MODULE:<HookName>` and are registered by `core/libraries/core/modularity/core.lua`; they must remain in their owning module library or module file with the same method name.
- Metatable methods were identified with `function <receiver>:<method>` and `FindMetaTable`/`DEFINE_BASECLASS` searches. Domain methods in character, item, inventory, and entity packages follow the ownership decisions above; player methods remain core because they are shared framework API.
- Entity and weapon methods remain beside their existing module entity/weapon registrations; generic derma panel methods remain under `core/derma/panels`.

## Ambiguities recorded

1. There is no existing character or flags module directory, so moving those core APIs would require creating new modules and changing bootstrap order. This is not safe to infer from names alone.
2. Player, config, database, command-dispatch, net, loader, and utility APIs are consumed by many modules and remain core infrastructure.
3. Compatibility files remain under `core/libraries/compatibility` because their implementation is integration-specific, even when they add administration or item commands.

## Remaining core netcalls classified as infrastructure

After the repass, the remaining handlers in `core/netcalls` are the framework-level data/netvar transport, argument and command dispatch, keybind, options/dropdown/question/dialog transport, player-interaction transport, big-table acknowledgement, generic NPC dialog transport, PAC/asset integration, and F1/menu teardown. They have no single feature-module owner in the current architecture and are retained in core. Domain handlers for protection, chatbox, doors, main menu, administration/bodygroups, and wardrobe are no longer in `core/netcalls`.

## Validation targets after edits

Searches must show exactly one intended implementation for every `net.Receive`, `concommand.Add`, `lia.command.add`, and `util.AddNetworkString`; all moved hooks/metatable methods must remain present; every destination must be reached by the module loader; and no old root `pim.lua` implementation or stale include path may remain.

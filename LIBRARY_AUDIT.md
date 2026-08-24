# Lilia Library Audit

## Scope and baseline

This audit covers the Lilia repository rooted at `gamemode/` only. The baseline was captured from the working tree on 2026-08-24 before this audit made source changes. The working tree was already dirty: it contained edits and untracked files from an earlier reorganization pass. Those pre-existing edits are recorded as baseline state and are not attributed to this audit.

The audit used direct searches for `net.Receive`, `util.AddNetworkString`, `net.Start`, net send calls, `lia.command.add`, `concommand.Add`, hooks, loader entries, module initialization, and the existing dashboard/report outputs. Ownership was confirmed by tracing registration, send/receive pairs, module folder, library API use, and loader realm. Filename proximity and dashboard heuristics were not treated as proof of ownership.

## Loader and realm constraints

* `gamemode/shared.lua` loads `core/libraries/loader.lua`.
* The core loader explicitly loads core libraries and core `netcalls/client.lua` and `netcalls/server.lua` once per realm.
* `lia.modularity` discovers module folders including `libraries`, `commands`, `netcalls`, and `derma`; module files are included through `lia.loader.includeDir` with realm inference.
* Module-owned networking is not library-owned and must remain in its module or nested submodule.
* The core singleton library layout is an established loader convention. Core library files often contain shared APIs, hooks, and related sends; splitting them would require proving local scope and ordering across a large shared dependency graph, so they are intentionally treated as placement exceptions unless ownership is exclusive and extraction is mechanical.

## Libraries and nested components analyzed

### Core libraries

All files under `gamemode/core/libraries/` were analyzed, including `compatibility/*`, `thirdparty/*`, and the core library loader list. The analyzed libraries/components are:

`admin`, `attributes`, `bars`, `camera`, `character`, `chatbox`, `classes`, `color`, `commands`, `config`, `currency`, `darkrp`, `data`, `database`, `derma`, `dialog`, `doors`, `factions`, `flags`, `fonts`, `inventory`, `item`, `keybind`, `languages`, `loader`, `logger`, `menu`, `modularity`, `net`, `notice`, `option`, `performance`, `playerinteract`, `sit`, `time`, `util`, `vendor`, `webimage`, `websound`, `workshop`, `compatibility`, and `thirdparty`.

Core supporting files analyzed with these libraries were `gamemode/core/netcalls/client.lua`, `gamemode/core/netcalls/server.lua`, `gamemode/core/hooks/{shared,client,server}.lua`, `gamemode/core/meta/{character,entity,inventory,item,panel,player}.lua`, and `gamemode/core/derma/**`. These are core/shared infrastructure, not module-library folders.

### Modules and nested libraries/components

* `administration`: `libraries/{shared,server,client}.lua`, `netcalls/{server,client}.lua`, plus nested `adminstick`, `logs`, `tickets`, and `warnings` components. Each nested component's `module.lua`, `libraries/**`, `netcalls/**`, `commands.lua` when present, entities, and derma were analyzed.
* `attributes`: `libraries/{shared,server,client}.lua`.
* `chatbox`: `libraries/{shared,server,client}.lua`, `netcalls/{server,client}.lua`.
* `doors`: `libraries/{server,client}.lua`, entities, and weapons.
* `inventory`: `module.lua`, `types/gridinv` and `types/weightinv`; nested grid inventory libraries, netcalls, derma, items, and `submodules/storage` libraries, netcalls, entities, and module files.
* `mainmenu`: `module.lua`, `libraries/server.lua`, `netcalls/{server,client}.lua`, and derma files/steps.
* `protection`: `libraries/{server,client}.lua`, `commands.lua`, and module files.
* `recognition`: `libraries/{shared,server,client}.lua`, `netcalls/client.lua`, and `pim.lua`.
* `spawns`: `libraries/{server,client}.lua` and module files.
* `teams`: `libraries/{shared,server,client}.lua`, `netcalls/server.lua`, `commands.lua`, `pim.lua`, and module files.
* `vendor`: `libraries/{server,client}.lua`, `netcalls/{server,client}.lua`, derma, entities, and module files.

## Ownership findings

### Confirmed module-owned networking already in the correct location

The following module or nested-component receivers are exclusively tied to their owning component and are already under realm-separated `netcalls` files:

* `chatbox`: `liaChatboxRequestFilteredWords`, `liaChatboxAddFilteredWord`, `liaChatboxRemoveFilteredWord`, `liaRegenChat`, `liaChatboxSyncFilteredWords`.
* `teams`: `liaKickCharacterToBase`, `liaRequestFactionMembers`, `liaRequestFactionMemberDetails`, `liaSaveFactionNote`.
* `recognition`: `liaRgnDone`.
* `vendor`: all `liaVendor*` receivers in `modules/vendor/netcalls/{server,client}.lua`.
* `administration`: its staff configuration, tool permission, spawn-menu, feature-position, profiler, map-entity, staff-case, and online-staff receivers in `modules/administration/netcalls/{server,client}.lua`.
* `administration/adminstick`: `liaAdminStickRequestPlayerState` and `liaAdminStickPlayerState` in the nested `netcalls` files.
* `administration/logs`: `liaSendLogsRequest`, `liaSendLogsCategoriesRequest`, and `liaSendLogsCategories` in nested `netcalls` files.
* `administration/tickets`: ticket UI receivers in nested `netcalls` files.
* `administration/warnings`: warning receivers in nested `netcalls` files.
* `inventory/types/gridinv`: `liaRestoreOverflowItems` in its nested server `netcalls` file.
* `inventory/types/gridinv/submodules/storage`: storage receivers in nested realm-separated `netcalls` files.
* `mainmenu`: `liaSetMainCharacter`, `liaMainCharacterSet`, `liaStaffDiscordPrompt`, and `liaStaffDiscordResponse` in `mainmenu/netcalls`.

Related `net.Start`/send calls in module libraries, module derma, and module entities remain with those components where they are not receiver registrations. Moving those sends separately would split local helpers or entity/module scope and is not required for receiver placement.

### Confirmed module-owned commands

* `modules/teams/commands.lua`: `speed`.
* `modules/protection/commands.lua`: `lia_backdoorcheck`.
* `modules/administration/submodules/tickets/commands.lua`: `ticket` and its private `SendPopup` helper.

The ticket and protection command files were already present in the baseline working tree. Their pre-existing relocation is documented here; no duplicate relocation is performed by this audit.

### Core/shared or mixed code intentionally left unchanged

* `core/netcalls/{server,client}.lua` contains cross-library character, inventory, item, door, dialog, chat, option, interaction, admin, group, workshop, and framework transport code. It is shared/core and is not moved into module libraries.
* Core meta files and core hooks contain sends and command-related helpers used by multiple libraries or framework lifecycle hooks. They remain unchanged.
* `core/libraries/commands.lua` contains the command framework plus many cross-library/core commands and console commands. It is shared/core, not a single module library's command file.
* Core library files such as `character.lua`, `chatbox.lua`, `admin.lua`, `doors.lua`, `inventory.lua`, `item.lua`, `camera.lua`, `keybind.lua`, `performance.lua`, `sit.lua`, and compatibility libraries contain mixed APIs, hooks, dynamic registrations, or shared sends. Their command/net placement is an intentional core-layout exception.
* Module `module.lua`, entity, weapon, `pim.lua`, derma, and item files with module-owned sends are module implementation code, not library receiver code. They were not moved into library folders.

## Confirmed placement issue in the baseline

| Library/component | Existing path | Symbol | Ownership evidence | Correct target | Safe to move? | Baseline action |
|---|---|---|---|---|---|---|
| `teams` | `gamemode/modules/teams/libraries/server.lua` | `lia.command.add("speed", ...)` | The command is a single teams command, has no shared helper dependency, and an identical registration already exists in the module's `commands.lua`. | `gamemode/modules/teams/commands.lua` | Yes; remove the duplicate from the library file while retaining the `commands.lua` registration. | Corrected after this initial report was written. |

This is a duplicate/stray registration rather than a need to copy code. The `commands.lua` registration is server-gated and is loaded by the module loader; the library copy is removed to ensure exactly one registration.

## Ambiguous or intentionally unmodified candidates

* `liaPlayerRespawn`, `liaSetWaypoint`, `liaActBar`, character, inventory, item, door, dialog, and interaction messages cross core libraries/meta/hooks and modules; ownership is shared or cannot be proven from one library.
* `liaCharChoose` and related character messages are referenced by both main menu and administration/core paths; they remain in the owning module/core files rather than being assigned to one library.
* Dynamic command registration in `core/libraries/chatbox.lua`, `core/libraries/darkrp.lua`, and `core/libraries/commands.lua` cannot be safely separated without changing registration order or shared command behavior.
* Console commands generated from command definitions, waypoint IDs, compatibility integrations, and UI test panels are dynamic or core-owned; dashboard text matching can misclassify them as library-specific.
* Any dashboard finding based only on filename, `lia.*` symbol naming, proximity, or a single caller is a false positive unless registration and all references establish exclusive ownership.

## Dashboard/report reconciliation

The existing dashboard and `documentation/reports/lilia.md` are useful inventories of library names and references, but their scanner is text/structure based. Valid findings are the module command/netcall placements listed above. False positives include shared core receivers, dynamic registrations, sends in entities/derma/meta files, and commands whose implementation is in the shared command framework. No dashboard-only finding was used as ownership proof.

## Pre-existing working-tree changes

Before this audit, the working tree already contained a broad reorganization pass affecting administration, adminstick, tickets, main menu, teams, vendor, documentation, hooks, and the dashboard script, including untracked destination files. Those files are deliberately not rewritten or reverted. The baseline audit records their current placement; the final section below distinguishes the single correction made after the initial report from those pre-existing changes.

## Verification plan

After the correction, verify loader discovery, stale old paths, duplicate `net.Receive` and command registrations, realms, net message names, hooks, APIs, syntax/lint availability, `git diff --check`, `git status`, and the complete diff. Any source change must map to the confirmed issue table above.

## Remediation / Final State

* Removed the duplicate `speed` registration from `gamemode/modules/teams/libraries/server.lua`.
* Retained the sole server-gated `speed` registration in `gamemode/modules/teams/commands.lua`.
* No shared/core, ambiguous, or module-only implementation was moved into a library.
* No network message names, aliases, hooks, public APIs, or realms were changed.
* Final verification results are recorded below after checks complete.

### Final verification results

* `git diff --check` completed without errors; Git emitted only existing line-ending normalization warnings.
* Python syntax checks passed for `scripts/function_comparison_dashboard.py` and `generate_docs.py`; no Lua interpreter or `luacheck` executable is available in the environment, so runtime Lua syntax validation could not be run.
* Literal `net.Receive` duplicate scanning found no duplicate receiver within the same source file/realm. Same message names appearing once on client and once on server are expected realm pairs.
* The `speed` command now occurs only in `modules/teams/commands.lua`; no stale `speed` registration remains in `teams/libraries/server.lua`.
* A pre-existing shared-core duplicate registration remains for `plyrespawn` in `core/libraries/commands.lua` at lines 2723 and 8482. It was not changed because it is shared/core code outside the confirmed module-library correction scope.
* Literal old-path search found stale references only in `ui-overhaul-audit.html` historical/dashboard data and the pre-existing core loader reference for `core/libraries/vendor.lua`. These were not source loader changes made by this audit. The staged vendor rename is not reflected in the working-tree filesystem, so it remains an intentional pre-existing working-tree constraint requiring its owner to resolve.
* Module receiver scans identified many names absent from the static `init.lua` network-string list, including administration, tickets, vendor, teams, chatbox, recognition, and nested inventory messages. This is a pre-existing registration/configuration gap or dynamic-registration dependency; no network-string list was changed because ownership and intended registration mechanism cannot be proven solely from this repository scan.
* Module `commands/` and `netcalls/` folders are discovered by the modularity loader; no new file was created by this audit and no moved file requires a loader edit.
* Hooks, public library APIs, command names/aliases, net message names, and realms were unchanged by the one source correction.

## Change inventory

### Files created by this audit

* `LIBRARY_AUDIT.md`.

### Files modified by this audit

* `gamemode/modules/teams/libraries/server.lua`: removed the duplicate `speed` command block. The file also contained pre-existing working-tree edits.

### Files moved or created before this audit (preserved, not attributed)

The baseline working tree already staged or contained these placement changes: the main-menu derma files from `core/derma/mainmenu/**` to `modules/mainmenu/derma/**`; protection `libraries/shared.lua` to `commands.lua`; and core vendor `libraries/vendor.lua` to module vendor `libraries/shared.lua`. It also contained untracked module command/netcall/derma destinations for teams, tickets, and adminstick. Because these changes predated this audit and are mixed with staged/worktree state, they were not rewritten.

The final source diff therefore contains pre-existing user changes in addition to the documented audit correction. Shared code, ambiguous code, module-owned code, and core-owned code were not newly moved by this audit.

## Follow-up remediation

The remaining confirmed module placements are now represented by the module command files already present in the working tree:

* `recognition/commands.lua`: recognition commands (`recogwhisper`, `recognormal`, `recogyell`, `recogbots`).
* `administration/submodules/warnings/commands.lua`: warning commands (`warn`, `viewwarns`, `viewwarnsissued`).
* `administration/submodules/tickets/commands.lua`: ticket and claim commands (`ticket`, `viewtickets`, `plyviewclaims`, `viewallclaims`, `viewclaims`).
* `spawns/commands.lua`: spawn commands (`spawnadd`, `spawnremoveinradius`, `spawnremovebyname`).
* `teams/commands.lua`: faction/class commands (`plytransfer`, `plywhitelist`, `plyunwhitelist`, `beclass`, `setclass`, `classwhitelist`, `classunwhitelist`).
* `vendor/commands.lua`: vendor commands (`restockvendor`, `restockallvendors`, `deletevendorpreset`, `listvendorpresets`, `resetvendorcooldowns`).
* The corresponding door, inventory, storage, administration, protection, and main command files contain their confirmed module-owned registrations.

The final placement scan found no module `net.Receive` outside a `netcalls/{server,client}.lua` file and no module command or console registration outside a `commands.lua` file. The two main-menu client response receivers (`liaCharChoose`, `liaCharCreate`) were moved into `mainmenu/netcalls/client.lua`; their deferred requests are queued by `module.lua` so the response behavior and request pairing are preserved.

### Library send-call exceptions

The remaining `net.Start` calls visible in module `libraries/*.lua` are inside public library methods, entity/library synchronization methods, UI methods, or callbacks whose local variables and API scope are defined in the same function. They are related sends, not receiver registrations. Extracting only the send statements would break scope; extracting each entire method would move public library APIs and change loader ordering. They are therefore intentional placement exceptions under the original rule to preserve local helper scope, load order, and library APIs. The receiver registrations paired with them are in the owning realm-specific `netcalls` files.

# Lilia Net Message Audit

Last rescanned: 2026-10-06.

This audit compares literal `net.Start` and `net.Receive` calls in the active `lilia` gamemode and `lilia_rp` schema tree. Dynamic senders, big-table wrappers, module registrations, netstream calls, and schema gitmodules were checked to avoid known false positives. Hidden parked directories such as `modules/.modules` and `modules/.wip` are excluded from the active totals and reported separately.

## Summary

- 232 unique literal `net.Start` names across active Lilia and Lilia RP code
- 259 unique literal `net.Receive` names across active Lilia and Lilia RP code
- No wholly start-only messages
- 27 receiver-only names
- 2 receiver-only names have valid dynamic or external senders
- 1 receiver-only message appears intentional as a security honeypot
- 23 confirmed-dead messages still have receivers; a 24th (`liaJobNpcCloseDialog`) now has only a stale registration
- 1 additional probable receiver-only orphan message
- 5 likely stale active registrations with no active `net` sender or receiver
- 1 confirmed-dead receiver, `liaRequestAllPks`, is no longer registered and is therefore only partially cleaned up
- All 18 active big-table message names are now paired
- Parked code adds 12 start-only and 34 receiver-only static candidates

## Confirmed dead core messages

These messages have been confirmed as dead and can be removed from their receiver implementations and network-string registrations. `liaJobNpcCloseDialog` has already had its active receiver removed, but its core registration remains; parked `.wip` modules still contain senders.

| Message | Receiver | Notes |
|---|---|---|
| `liaSetWaypointWithLogo` | `gamemode/core/netcalls/client.lua:8` | Obsolete. The current waypoint implementation sends `liaSetWaypoint` from `gamemode/core/meta/player.lua:438`. |
| `liaProvideServerPassword` | `gamemode/core/netcalls/client.lua:365` | Confirmed dead; no sender exists. |
| `liaItemData` | `gamemode/core/netcalls/client.lua:546` | Confirmed dead; no sender exists. |
| `liaDoorData` | `gamemode/core/netcalls/client.lua:1406` | Appears superseded by `liaDoorDataUpdate` and the `liaDoorDataBulk` big-table path. |
| `liaJobNpcCloseDialog` | Registration only: `gamemode/init.lua:2` | Confirmed dead in the active tree. Its receiver has been removed; senders remain only in parked `.wip` modules. |
| `liaKickCharacter` | `gamemode/core/netcalls/server.lua:196` | Confirmed dead; separate `liaKickCharacterToBase` flow is active. |
| `liaNPCWeaponChange` | `gamemode/core/netcalls/server.lua:642` | Confirmed dead; no sender exists. |
| `liaPopupQuestionRequestCancel` | `gamemode/core/netcalls/server.lua:846` | Client sends the normal response but never sends this cancellation message. |
| `liaButtonRequestCancel` | `gamemode/core/netcalls/server.lua:861` | Client sends the normal response but never sends this cancellation message. |
| `liaNetMessage` | `gamemode/core/netcalls/server.lua:1108`, `gamemode/core/netcalls/client.lua:1226` | Confirmed dead. Receivers exist in both realms, but there is no sender and nothing populates `lia.net.registry`. |

### `liaSetWaypointWithLogo`

This message is definitely stale. Its client receiver reads a name, position, logo, and on-reach value, but the live `playerMeta:setWaypoint` implementation only sends `liaSetWaypoint`:

```lua
net.Start("liaSetWaypoint")
net.WriteString(name)
net.WriteVector(vector)
net.WriteString(logo or "")
net.Send(self)
```

The current sender is at `gamemode/core/meta/player.lua:438`.

## Confirmed dead administration messages

These administration receivers have also been confirmed as dead and can be removed together with their network-string registrations.

| Message | Receiver |
|---|---|
| `liaAdminSetCharProperty` | `gamemode/modules/administration/netcalls/server.lua:150` |
| `liaRequestAllPks` | `gamemode/modules/administration/netcalls/server.lua:431` |
| `liaRequestFullCharList` | `gamemode/modules/administration/netcalls/server.lua:615` |
| `liaRequestAllFlags` | `gamemode/modules/administration/netcalls/server.lua:630` |
| `liaRequestStaffSummary` | `gamemode/modules/administration/netcalls/server.lua:824` |
| `liaRequestPlayers` | `gamemode/modules/administration/netcalls/server.lua:830` |
| `liaRequestActiveTickets` | `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:81` |
| `liaRequestAllWarnings` | `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:43` |
| `liaRequestPlayerWarnings` | `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:53` |

Several of these appear to be older administration endpoints superseded by newer paginated or consolidated requests, including `liaRequestFullCharListPage` and `liaRequestStaffCases`.

## Confirmed dead inventory and vendor messages

These inventory and vendor receivers have been confirmed as dead and can be removed together with their network-string registrations.

| Message | Receiver | Notes |
|---|---|---|
| `liaStorageTransfer` | `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:34` | Confirmed dead; no sender exists. |
| `liaTrunkInitStorage` | `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/shared.lua:1` | Confirmed dead; no sender exists. |
| `liaVendorFaction` | `gamemode/modules/vendor/netcalls/client.lua:57` | Confirmed dead; no sender exists. |
| `liaVendorBuyPrice` | `gamemode/modules/vendor/netcalls/client.lua:62` | Confirmed dead; no sender exists. |
| `liaVendorSellPrice` | `gamemode/modules/vendor/netcalls/client.lua:73` | Confirmed dead; no sender exists. |

## Lilia RP orphan

| Message | Receiver | Notes |
|---|---|---|
| `RemoveWarTableMarker` | `lilia_rp/gitmodules/wartable/netcalls/server.lua:54` | Registered by the wartable module, but its UI only sends `PlaceWarTableMarker`; no removal sender exists. |

## Stale or redundant registrations

Five names are registered in active code but have no active `net.Start`, `net.Receive`, big-table writer, or big-table reader. One further registration is used only as a netstream logical name and is redundant for Garry's Mod's `net` string pool.

| Message | Registration | Current state |
|---|---|---|
| `liaJobNpcCloseDialog` | `gamemode/init.lua:2` | Confirmed dead. Active receiver removed; only parked `.wip` senders remain. |
| `liaFullCharList` | `gamemode/modules/administration/module.lua:5` | Old big-table reader removed; active code uses `liaFullCharListPage`. |
| `liaViewClaims` | `gamemode/modules/administration/submodules/tickets/module.lua:5` | Former incomplete request/response implementation has been removed; registration remains. |
| `liaPropertyRequestData` | `lilia_rp/modules/realtor/module.lua:8` | No sender, receiver, or dynamic use found. |
| `liaPropertyDoorSelection` | `lilia_rp/modules/realtor/module.lua:8` | No sender, receiver, or dynamic use found. |
| `liaSyncGesture` | `gamemode/init.lua:2` | Live as a `netstream.Start`/`netstream.Hook` name, but not as a direct `net` message; the explicit `util.AddNetworkString` registration appears redundant. |

## Partially cleaned message

`liaRequestAllPks` still has its confirmed-dead receiver at `gamemode/modules/administration/netcalls/server.lua:431`, but its entry has already been removed from `MODULE.NetworkStrings`. The remaining receiver should be removed rather than re-registering the dead message.

## Big-table message audit

Lilia's large-payload transport does not use literal message names directly in `net.Start` and `net.Receive`. The underlying implementation calls `net.Start(s.netStr)` and `net.Receive(netStr, ...)`, so `lia.net.writeBigTable` and `lia.net.readBigTable` call sites must be compared separately.

The active trees now contain 18 unique big-table writer names and 18 unique big-table reader names. Every name is paired. The previous `liaFactionMemberDetails(` typo has been corrected, and the obsolete `liaFullCharList` reader has been removed. Only the stale `liaFullCharList` registration remains.

### Correctly paired big-table messages

- `liaAllFlags`
- `liaAllPlayers`
- `liaDialogSync`
- `liaDoorDataBulk`
- `liaEntityTabData`
- `liaFactionMembers`
- `liaFullCharListPage`
- `liaMapEntities`
- `liaPlayerInteractCategories`
- `liaPlayerInteractSync`
- `liaSendLogs`
- `liaSendTableUI`
- `liaStaffCasesSnapshot`
- `liaStaffSummary`
- `liaUpdateAdminGroups`
- `liaUpdateAdminPrivileges`
- `liaPropertyData` in `lilia_rp`

## Removed messages

- `liaAllMedalsData`: removed from the parked medals module's registration and all four big-table write sites.

## Receiver-only messages that are not orphans

| Message | Explanation |
|---|---|
| `liaRunInteraction` | Sent dynamically through `net.Start(netMsg)` in `gamemode/core/libraries/core/playerinteract/core.lua:304`. The message name is supplied by `gamemode/core/netcalls/client.lua:726`. |
| `wire_expression2_upload` | A Wiremod-owned message handled by Lilia compatibility code. Its sender exists outside this repository. |

`liaSeqSet` looks receiver-only when scanning the Lilia repository alone, but is a normal literal pair once the active `lilia_rp/gitmodules/animations` code is included, so it is not part of the combined receiver-only count above.

## Intentional receiver-only message

`liaCheckHack`, received at `gamemode/core/netcalls/server.lua:273`, has no legitimate sender in the repository. Its handler immediately records a hack attempt and invokes cheat-detection hooks, so it appears intentionally designed as a honeypot message rather than an orphan.

## How Lilia handles network messages

Core network strings are listed and registered with `util.AddNetworkString` in `gamemode/init.lua`.

Module-specific messages are declared through `MODULE.NetworkStrings`. They are registered by the modularity loader in `gamemode/core/libraries/core/modularity/core.lua:221`.

Most messages use direct `net.Start("name")` and `net.Receive("name", callback)` calls. There are also several dynamic mechanisms that must be considered during an orphan audit:

- `lia.net.writeBigTable` and `lia.net.readBigTable` use a message name supplied as an argument.
- Player interactions use `net.Start(netMsg)`.
- Table UI actions use `net.Start(option.net)`.
- `panelMeta:NetMessage` uses `net.Start(name)`.

Because of these dynamic paths, a simple textual comparison of literal `net.Start` and `net.Receive` calls produces false positives unless their call sites are traced.

## Scope

This is a static repository audit. A receiver classified as an orphan may still be used by an external addon that sends the message by its known string name. The active scan covers `lilia/gamemode` and the non-hidden Lua trees under `lilia_rp`, including `gitmodules`. Hidden parked directories were not counted as active code. For example, `.wip` card-dealer and police-suite code contains senders for `liaJobNpcCloseDialog`; the active tree does not.

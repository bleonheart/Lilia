# Lilia Net Message Audit

This audit compares literal `net.Start` and `net.Receive` calls in the `lilia` gamemode. Dynamic senders and the `lilia_rp` schema were also checked to avoid reporting known false positives.

## Summary

- 199 unique literal `net.Start` names
- 227 unique literal `net.Receive` names
- No wholly start-only messages
- 25 receiver-only names
- 3 receiver-only names have valid dynamic or external senders
- 1 receiver-only message appears intentional as a security honeypot
- 24 probable orphan messages
- 1 additional incomplete bidirectional flow: `liaViewClaims`
- 2 framework big-table issues
- 1 writer-only big-table message in a parked `lilia_rp/.modules` module

## Probable core orphans

| Message | Receiver | Notes |
|---|---|---|
| `liaSetWaypointWithLogo` | `gamemode/core/netcalls/client.lua:8` | Obsolete. The current waypoint implementation sends `liaSetWaypoint` from `gamemode/core/meta/player.lua:438`. |
| `liaProvideServerPassword` | `gamemode/core/netcalls/client.lua:365` | No sender found. |
| `liaItemData` | `gamemode/core/netcalls/client.lua:546` | No sender found. |
| `liaDoorData` | `gamemode/core/netcalls/client.lua:1406` | Appears superseded by `liaDoorDataUpdate` and the `liaDoorDataBulk` big-table path. |
| `liaJobNpcCloseDialog` | `gamemode/core/netcalls/client.lua:1578` | No sender found. |
| `liaKickCharacter` | `gamemode/core/netcalls/server.lua:196` | No sender found; separate `liaKickCharacterToBase` flow is active. |
| `liaNPCWeaponChange` | `gamemode/core/netcalls/server.lua:642` | No sender found. |
| `liaPopupQuestionRequestCancel` | `gamemode/core/netcalls/server.lua:846` | Client sends the normal response but never sends this cancellation message. |
| `liaButtonRequestCancel` | `gamemode/core/netcalls/server.lua:861` | Client sends the normal response but never sends this cancellation message. |
| `liaNetMessage` | `gamemode/core/netcalls/server.lua:1108`, `gamemode/core/netcalls/client.lua:1226` | Receivers exist in both realms, but there is no sender and nothing populates `lia.net.registry`. |

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

## Administration orphans

| Message | Receiver |
|---|---|
| `liaAdminSetCharProperty` | `gamemode/modules/administration/netcalls/server.lua:150` |
| `liaRequestAllPks` | `gamemode/modules/administration/netcalls/server.lua:431` |
| `liaRequestFullCharList` | `gamemode/modules/administration/netcalls/server.lua:615` |
| `liaRequestAllFlags` | `gamemode/modules/administration/netcalls/server.lua:630` |
| `liaRequestStaffSummary` | `gamemode/modules/administration/netcalls/server.lua:824` |
| `liaRequestPlayers` | `gamemode/modules/administration/netcalls/server.lua:830` |
| `liaRequestActiveTickets` | `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:89` |
| `liaRequestAllWarnings` | `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:43` |
| `liaRequestPlayerWarnings` | `gamemode/modules/administration/submodules/warnings/netcalls/server.lua:53` |

Several of these appear to be older administration endpoints superseded by newer paginated or consolidated requests, including `liaRequestFullCharListPage` and `liaRequestStaffCases`.

## Inventory and vendor orphans

| Message | Receiver | Notes |
|---|---|---|
| `liaStorageTransfer` | `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/server.lua:34` | No sender found. |
| `liaTrunkInitStorage` | `gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/shared.lua:1` | No sender found. |
| `liaVendorFaction` | `gamemode/modules/vendor/netcalls/client.lua:57` | No sender found. |
| `liaVendorBuyPrice` | `gamemode/modules/vendor/netcalls/client.lua:62` | No sender found. |
| `liaVendorSellPrice` | `gamemode/modules/vendor/netcalls/client.lua:73` | No sender found. |

## Incomplete bidirectional flow

### `liaViewClaims`

`liaViewClaims` is not wholly receiver-only because the server sends a response using the same message name. However, its request half is incomplete:

- Server request receiver: `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:2`
- Server response sender: `gamemode/modules/administration/submodules/tickets/netcalls/server.lua:5`
- Client response receiver: `gamemode/modules/administration/submodules/tickets/netcalls/client.lua:98`
- Client request sender: missing

The server receiver cannot be reached by any sender inside `lilia` or `lilia_rp`.

## Big-table message audit

Lilia's large-payload transport does not use literal message names directly in `net.Start` and `net.Receive`. The underlying implementation calls `net.Start(s.netStr)` and `net.Receive(netStr, ...)`, so `lia.net.writeBigTable` and `lia.net.readBigTable` call sites must be compared separately.

The framework contains 17 unique big-table writer names and 18 unique big-table reader names. Sixteen names match correctly in both directions. The following do not.

### Broken: `liaFactionMemberDetails`

- Writer: `gamemode/modules/teams/libraries/server.lua:668`
- Intended reader: `gamemode/modules/teams/libraries/client.lua:896`
- Registered name: `liaFactionMemberDetails`
- Actual reader name: `liaFactionMemberDetails(`

The client reader has a stray opening parenthesis:

```lua
lia.net.readBigTable("liaFactionMemberDetails(", function(data)
```

The server writes to `liaFactionMemberDetails`, so the payload has no matching reader. The malformed reader name is also not present in `MODULE.NetworkStrings`.

### Orphan reader: `liaFullCharList`

- Reader: `gamemode/modules/administration/libraries/client.lua:3748`
- Writer: missing

The active implementation writes and reads `liaFullCharListPage`. The older `liaFullCharList` reader and its registration appear obsolete.

### Parked schema module: `liaAllMedalsData`

The `lilia_rp/modules/.modules/medals` module writes `liaAllMedalsData` from these locations:

- `lilia_rp/modules/.modules/medals/libraries/server.lua:235`
- `lilia_rp/modules/.modules/medals/libraries/server.lua:245`
- `lilia_rp/modules/.modules/medals/libraries/server.lua:297`
- `lilia_rp/modules/.modules/medals/libraries/server.lua:301`

No `lia.net.readBigTable("liaAllMedalsData", ...)` receiver exists in either repository. Because this module is under `.modules`, it appears parked or disabled, but it is still internally incomplete if re-enabled.

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

## Receiver-only messages that are not orphans

| Message | Explanation |
|---|---|
| `liaRunInteraction` | Sent dynamically through `net.Start(netMsg)` in `gamemode/core/libraries/core/playerinteract/core.lua:304`. The message name is supplied by `gamemode/core/netcalls/client.lua:726`. |
| `liaSeqSet` | Sent by the `lilia_rp` animations module in `gitmodules/animations/meta/sh_player.lua`. |
| `wire_expression2_upload` | A Wiremod-owned message handled by Lilia compatibility code. Its sender exists outside this repository. |

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

This is a static repository audit. A receiver classified as an orphan may still be used by an external addon that sends the message by its known string name. The findings above mean that no corresponding sender exists inside the checked `lilia` and `lilia_rp` repositories.

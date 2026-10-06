# Lilia net-message cleanup

Last rescanned and cleaned: 2026-10-06

Scope:

- `lilia/gamemode`
- `lilia_rp/modules`
- `lilia_rp/gitmodules`

Parked hidden module directories such as `lilia_rp/modules/.modules` were excluded.

## Current result

The confirmed dead direct-net handlers and registrations from the initial audit have been removed. The current active scan contains:

- 361 unique literal `net.Start` names
- 360 unique literal `net.Receive` names
- 377 unique registered names
- 15 `lia.net.writeBigTable` names, all paired with readers
- no remaining confirmed-dead receiver-only messages
- no remaining confirmed-dead registration-only messages

The only literal receiver-only results now are known exceptions:

| Message | Reason retained |
|---|---|
| `liaRunInteraction` | Sent dynamically through `net.Start(netMsg)` |
| `liaCheckHack` | Intentional security honeypot |
| `wire_expression2_upload` | Wiremod-owned external message |

## Removed core and administration flows

Removed dead request handlers, their unreachable responses, and their registrations where present:

- `liaAdminSetCharProperty`
- `liaRequestActiveTickets` / `liaActiveTickets`
- `liaRequestAllFlags` / `liaAllFlags`
- `liaRequestAllPks` / `liaAllPks`
- `liaRequestAllWarnings` / `liaAllWarnings`
- `liaRequestFullCharList`
- `liaRequestPlayers` / `liaAllPlayers`
- `liaRequestPlayerWarnings` / `liaPlayerWarnings`
- `liaRequestStaffSummary` / `liaStaffSummary`

Removed stale core registrations:

- `liaButtonRequestCancel`
- `liaDoorData`
- `liaItemData`
- `liaJobNpcCloseDialog`
- `liaKickCharacter`
- `liaNetMessage`
- `liaNPCWeaponChange`
- `liaPopupQuestionRequestCancel`
- `liaProvideServerPassword`
- `liaSetWaypointWithLogo`

The unused helper implementations that only served these messages were also removed. The warnings client netcall file became empty and was deleted.

## Removed banking flows

Removed dead or unreachable banking handlers and registrations:

- `liaBankingAdminTestDeposit`
- `liaBankingAdminTestReceive`
- `liaBankingAdminTestRequest`
- `liaBankingAdminTestWithdraw`
- `liaBankingConfigUpdate`
- `liaBankingGetAccountDetails` / `liaBankingReceiveAccountDetails`
- `liaBankingGetBankAccountCount` / `liaBankingReceiveBankAccountCount`
- `liaBankingOpenAdminPanel`
- `liaBankingOpenBankGUI`
- `liaBankingOpenBankerUI`
- `liaBankingRedeemCheckAtATM`
- `liaBankingRequestAccountDetails`
- `liaBankingRequestConfig`
- `liaBankingRequestMemberPermissions` / `liaBankingReceiveMemberPermissions`
- `liaBankingRetrievePaycheck`
- `liaBankingTransferMoney`
- `liaBankingUpdateMember`
- `liaBankingValidateAccount`
- `liaBankingWipeDatabase`

## Removed Lilia RP module messages

| Module | Removed messages |
|---|---|
| Bonemerge | `Bonemerge.StartAdjustingItem`, `Bonemerge.EntityKilled`, `Bonemerge.PlayerDeath`, `Bonemerge.PlayerDisconnect`, `Bonemerge.PlayerLoadedChar`, `Bonemerge.PlayerSpawn`, `Bonemerge.RequestFullSync` |
| Drugs | `liaDrugsConfigUpdate`, `liaDrugsReceiveConfig`, `liaDrugsRequestConfig` |
| Injuries | `HellStart`, `HellEnd`, `liaInjuryTestAdd`, `liaInjuryTestRemove`, `liaInjuryTestClearAll`, `liaInjuryTestUpdate` |
| Police suite | `liaAdminStickOpen`, `liaOpenJailerNPC`, `liaPoliceQuizResults`, `liaJailerOpenViewPrisoners`, `liaPoliceComputerOpen`, `liaPolicePayAllFinesFromAccount`, `liaPolicePayFineFromAccount`, `liaPoliceSetRank` |
| Realtor | `liaPropertyDoorSelection`, `liaPropertyRequestData` |
| Radio and computers/radio | `liaRadioConfigUpdate`, `liaRadioReceiveConfig`, `liaRadioRequestConfig` |
| Territories | `liaControlPointAreaEnter`, `liaControlPointAreaExit` |
| Tickets | `liaViewClaims` |
| Wartable | `RemoveWarTableMarker` |

## Retained repair candidates

These were not deleted because they have active UI/gameplay call sites and appear incomplete rather than safely dead:

| Message | Problem |
|---|---|
| `Bonemerge.ConvertModel` | Client sends, but no server receiver exists |
| `liaBankingReceiveAccountName` | Server responds to the live `liaBankingGetAccountName` request, but no client receiver exists |
| `liapadScreen` | Camera pad sends it, but no client receiver exists |
| `liaChessTop10` | Client both sends and receives the name; no server handler exists |

## Active registration issue retained for a repair pass

`liaRequestFullCharListPage` is active:

- sender: `gamemode/modules/administration/libraries/client.lua:6`
- receiver: `gamemode/modules/administration/netcalls/server.lua:540`

It is still absent from `gamemode/modules/administration/module.lua` and needs to be added to `MODULE.NetworkStrings`.

## Netstream exception

`liaSyncGesture` remains in the core registration list. Its logical name is live through:

- `netstream.Start` in `gamemode/core/meta/player.lua`
- `netstream.Hook` in `gamemode/core/netcalls/client.lua`

Its direct `util.AddNetworkString` entry may be redundant, but the live netstream flow itself is not dead.

## Validation

`glualint` successfully parsed every modified Lua file. It reported existing style/complexity warnings but no syntax errors. A final literal/dynamic rescan found only the retained repair candidates and documented exceptions above.

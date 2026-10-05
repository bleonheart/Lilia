# Lilia command inventory

This is a source-level inventory of the command registrations in `gamemode/`.
It includes the 184 literal `lia.command.add` registrations, chat-prefix
commands registered at runtime, and all literal `concommand.Add` registrations.
Names in the **Slash commands** sections are entered as `/name`; console names
are entered without a leading slash. Availability and permissions are defined by
each command's registration and can depend on enabled modules/configuration.

## Quick reference

Use this section to find a command by task. The full, source-grouped inventory
follows below.

| Area | Commands |
| --- | --- |
| Character basics | `playtime`, `charid`, `charlist`, `chardesc`, `charsetdesc`, `charsetname`, `charsetmodel`, `chargetmodel`, `getmodel`, `charsetscale`, `charsetjump`, `chargetup`, `fallover`, `forcefallover`, `forcegetup`, `returntodeathpos` |
| Character administration | `charkill`, `charkick`, `charban`, `charunban`, `charbanoffline`, `charunbanoffline`, `charwipe`, `charwipeoffline`, `clearinv`, `chargiveitem`, `charsetmoney`, `charaddmoney`, `charsetattrib`, `charaddattrib`, `charsetspeed`, `charsetskin`, `charsetbodygroup`, `chareditbodygroups` |
| Player moderation | `plyban`, `plyunban`, `plykick`, `plykill`, `plyslay`, `plyrespawn`, `forcerespawn`, `plyfreeze`, `plyunfreeze`, `plygag`, `plyungag`, `plymute`, `plyunmute`, `plyblind`, `plyunblind`, `plyblindfade`, `blindfadeall`, `warn`, `viewwarns`, `viewwarnsissued` |
| Player movement/state | `plybring`, `plygoto`, `plyreturn`, `plytransfer`, `plyjail`, `plyunjail`, `plycloak`, `plyuncloak`, `plygod`, `plyungod`, `plyignite`, `plyextinguish`, `plystrip`, `plyspectate`, `stopspectate` |
| Player/character inspection | `plycheckid`, `checkid`, `plygetplaytime`, `checkinventory`, `checkmoney`, `checkallmoney`, `checkflags`, `checkattributes`, `getallinfos`, `chargetname`, `chargethealth`, `chargetmoney`, `chargetinventory`, `listbodygroups`, `listnearbyentities` |
| Chat and roleplay | `pm`, `sayall`, `clearchat`, `roll`, `playsound`, `playglobalsound`, `forcesay`, `globalbotsay`, `botsay`, `botspeak`, `staffdiscord`, `recogwhisper`, `recognormal`, `recogyell`, `recogbots` |
| Items, money, vendors, storage | `dropmoney`, `bringlostitems`, `returnitems`, `returnallitems`, `trunk`, `restockvendor`, `restockallvendors`, `resetvendorcooldowns`, `listvendorpresets`, `deletevendorpreset`, `storagepasswordremove`, `storagepasswordchange` |
| Doors and map cleanup | `doorbuy`, `doorsell`, `admindoorsell`, `doorinfo`, `doorid`, `listdoorids`, `doorsetprice`, `doorsettitle`, `doortogglelock`, `doortoggleownable`, `doortoggleenabled`, `doortogglehidden`, `doorresetdata`, `savedoors`, `togglealldoors`, `cleanitems`, `cleanprops`, `cleanragdolls`, `cleannpcs`, `resetmapprops`, `freezeallprops` |
| Factions, classes, spawns | `beclass`, `setclass`, `plywhitelist`, `plyunwhitelist`, `classwhitelist`, `classunwhitelist`, `spawnadd`, `spawnremoveinradius`, `spawnremovebyname`, `dooraddfaction`, `doorremovefaction`, `doorsetclass`, `doorremoveclass` |
| Bots and tools | `bot`, `bots`, `kickbots`, `spawnbots`, `fillwithbots`, `panelbrowser`, `previewchatmessages`, `viewtickets`, `viewclaims`, `viewallclaims`, `plyviewclaims`, `managesitrooms`, `addsitroom`, `sendtositroom`, `returnsitroom` |

## Slash commands

### Complete source inventory

### `gamemode/core/libraries/core/commands/core.lua`

```text
playtime, charid, plygetplaytime, plycheckid, checkid, managesitrooms, addsitroom,
sendtositroom, returnsitroom, charkill, charlist, plyban, plykick, plykill,
plyunban, plyfreeze, plyunfreeze, plyslay, plyrespawn, plyblind, plyunblind,
plyblindfade, blindfadeall, plygag, plyungag, plymute, plyunmute, plybring,
plygoto, plyreturn, plyjail, plyunjail, plycloak, plyuncloak, plygod, plyungod,
plyignite, plyextinguish, plystrip, charunbanoffline, charbanoffline,
playglobalsound, plyspectate, stopspectate, playsound, returntodeathpos, roll,
forcefallover, forcegetup, chardesc, chargetup, fallover, togglelockcharacters,
checkinventory, flaggive, flaggiveall, flagtakeall, flagtake, bringlostitems,
charvoicetoggle, cleanitems, cleanprops, cleanragdolls, resetmapprops, cleannpcs,
charunban, clearinv, charkick, freezeallprops, charban, charwipe,
charwipeoffline, checkmoney, listbodygroups, charsetspeed, charsetmodel,
chareditbodygroups, chargiveitem, charsetdesc, charsetname, charsetscale,
charsetjump, charsetbodygroup, charsetskin, charsetmoney, charaddmoney,
globalbotsay, botsay, forcesay, getmodel, pm, chargetmodel, checkallmoney,
checkflags, chargetname, chargethealth, chargetmoney, chargetinventory,
getallinfos, dropmoney, exportprivileges, fillwithbots, spawnbots, bot, botspeak,
charsetattrib, checkattributes, staffdiscord, trunk, restockvendor,
restockallvendors, deletevendorpreset, listvendorpresets, charaddattrib, banooc,
unbanooc, clearchat, doorsell, admindoorsell, doortogglelock, doorbuy,
doortoggleownable, doorresetdata, doortoggleenabled, doortogglehidden,
doorsetprice, doorsettitle, savedoors, doorinfo, doorsampledata, doorrandominfo,
dooraddfaction, doorremovefaction, doorsetclass, doorremoveclass,
doorcopyfactions, doorpastefactions, doorcopyclasses, doorpasteclasses,
togglealldoors, doorid, listdoorids, plytransfer, plywhitelist, plyunwhitelist,
beclass, setclass, classwhitelist, classunwhitelist, spawnadd,
spawnremoveinradius, spawnremovebyname, returnitems, returnallitems, viewtickets,
plyviewclaims, viewallclaims, viewclaims, warn, previewchatmessages, panelbrowser,
viewwarns, viewwarnsissued, recogwhisper, recognormal, recogyell, recogbots,
kickbots, npcchangetype, plyrespawn, forcerespawn, resetvendorcooldowns,
storagepasswordremove, storagepasswordchange, listnearbyentities, viewBodygroups
```

`plyrespawn` appears twice in source; the later registration replaces the
earlier entry under the same command key.

### Other literal registrations

| Source | Commands |
| --- | --- |
| `gamemode/core/libraries/compatibility/pac/core.lua` | `fixpac`, `pacenable`, `pacdisable` |
| `gamemode/core/libraries/compatibility/sam/core.lua` | `cleardecals` |
| `gamemode/modules/administration/libraries/shared.lua` | `sayall` |
| `gamemode/modules/administration/submodules/tickets/libraries/server.lua` | `ticket` |
| `gamemode/modules/species_creator_poc/libraries/shared.lua` | `speciescreator` |
| `gamemode/modules/teams/libraries/server.lua` | `speed` |

## Chat-prefix commands

Chat classes add command aliases from `prefix` values at runtime in
`gamemode/modules/chatbox/libraries/shared.lua`. These usable prefixes are:

```text
/meclose, /actionclose, /mefar, /actionfar, /itclose, /itfar, /coinflip,
/me, /action, /globalme, /it, /w, /whisper, /y, /yell, /looc, /eventlocal,
/event, //, /ooc, /me's, /action's, /mefarfar, /actionyy, /meyy
```

The `roll` and `pm` chat classes use the ordinary `/roll` and `/pm` commands
listed above. `ic`, `actions`, `help`, and `adminchat` are chat classes but do
not define slash prefixes in this file.

### Slash-command metadata aliases

| Registered command | Additional usable name(s) |
| --- | --- |
| `charkill` | `permakill` |
| `chargetup` | `getup` |
| `flaggive` | `giveflag`, `chargiveflag` |
| `flagtake` | `takeflag` |
| `charaddmoney` | `chargivemoney` |
| `fillwithbots` | `bots` |
| `doorsetclass` | `jobdoor` |
| `plytransfer` | `charsetfaction` |
| `plywhitelist` | `factionwhitelist` |
| `plyunwhitelist` | `factionunwhitelist` |
| `panelbrowser` | `preview` |

## Console commands

### Literal console registrations

**Administration and maintenance** (`gamemode/core/libraries/core/commands/core.lua`)

```text
lia_givepermaflags, lia_check_updates, plysetgroup, plysetusergroup, stopsoundall,
lia_wipedb, lia_wipecharacters, lia_wipelogs, lia_wipebans, lia_wipepersistence,
lia_wipeconfig, lia_randomconfig, list_entities, lia_database_list,
lia_fix_characters, lia_redownload_assets, lia_snapshot, lia_snapshot_load,
lia_wipetable, lia_setextrachars, lia_set_inventory_size_all_chars,
lia_give_money_steamid
```

**Developer, diagnostics, and client tools**

| Source | Console commands |
| --- | --- |
| `core/commands/core.lua` | `print_vector`, `print_angle`, `printpos`, `weighpoint_stop`, `lia_scoreboard_reload`, `lia_vgui_cleanup`, `lia_saved_sounds`, `lia_wipe_sounds`, `lia_validate_sounds`, `lia_cleanup_sounds`, `lia_list_sounds`, `lia_saved_images`, `lia_cleanup_images`, `lia_wipewebimages` |
| `core/derma/panels/panel_tester.lua` | `lia_panel_tester` |
| `core/libraries/core/camera/core.lua` | `+freelook`, `-freelook` |
| `core/meta/player.lua` | `waypoint_stop_<waypointID>` (generated) |
| `core/netcalls/client.lua` | `workshop_force_redownload` |
| `modules/performance/module.lua` | `luamemory` |
| `modules/protection/libraries/shared.lua` | `lia_backdoorcheck` |

**Bot utilities** (`gamemode/core/libraries/core/commands/core.lua`): `kickbots`,
`bots`.

### Generated administrator console commands

`registerAdminConsoleCommand` in `gamemode/core/libraries/core/commands/core.lua`
prefixes each of these names with `lia_`:

```text
lia_plyban, lia_plykick, lia_plykill, lia_plyunban, lia_plyfreeze,
lia_plyunfreeze, lia_plyslay, lia_plyrespawn, lia_plyblind, lia_plyunblind,
lia_plygag, lia_plyungag, lia_plymute, lia_plyunmute, lia_plybring, lia_plygoto,
lia_plyreturn, lia_plyjail, lia_plyunjail, lia_plycloak, lia_plyuncloak,
lia_plygod, lia_plyungod, lia_plyignite, lia_plyextinguish, lia_plystrip,
lia_plyblindfade, lia_blindfadeall, lia_charvoicetoggle
```

## Runtime and compatibility registrations

The code also exposes `DarkRP.defineChatCommand` and
`DarkRP.definePrivilegedChatCommand` in
`gamemode/core/libraries/core/darkrp/core.lua`. Any addon invoking either API
creates an additional Lilia slash command at runtime, so those names cannot be
enumerated from this gamemode alone.

Console commands removed by the gamemode (rather than registered) are not
listed: `gm_save` on dedicated servers, optionally `pac_load_url`, and
`vj_cleanup` when the VJ Base compatibility layer is active.

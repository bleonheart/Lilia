# Main F1 Sidebar Tabs Without Dedicated Icons

This report lists only top-level tabs that can appear in the main F1 sidebar and do not have a dedicated `HOUNDED_MENUICON_*` picture.

Scanned locations:

- `D:\GMOD\Server\garrysmod\gamemodes\lilia\gamemode`
- `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp`

The originally supplied `lilia\_rp` path does not exist; `lilia_rp` was used as the intended second directory.

| Main F1 sidebar tab | Availability | Source |
|---|---|---|
| Classes | Only when joinable classes exist | [`teams/libraries/client.lua:324`](gamemode/modules/teams/libraries/client.lua:324) |
| Faction Roster | Conditional on faction-roster availability | [`teams/libraries/client.lua:336`](gamemode/modules/teams/libraries/client.lua:336) |
| Achievements | `lilia_rp` achievements module; permission/module dependent | [`achievements/libraries/client.lua:4`](../lilia_rp/modules/done/achievements/libraries/client.lua:4) |
| Leveling | `lilia_rp` leveling module | [`leveling/libraries/client.lua:206`](../lilia_rp/modules/done/leveling/libraries/client.lua:206) |
| Faction Messages | `lilia_rp` module; management permission dependent | [`factionmessages/libraries/client.lua:91`](../lilia_rp/modules/done/factionmessages/libraries/client.lua:91) |
| Respawn Points | `lilia_rp` module; FOB management permission dependent | [`respawnpoints/libraries/client.lua:550`](../lilia_rp/modules/done/respawnpoints/libraries/client.lua:550) |

`Admin` is omitted because it is a container tab for admin pages rather than a dedicated feature tab. Its child pages already have dedicated icon assignments.

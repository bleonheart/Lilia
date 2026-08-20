# Lilia UI Panel Review Checklist

Use this file for the actual review pass. It is grouped by user-facing panel areas instead of technical trigger types.

## Character Menu

- [ ] Character browser shell: [gamemode/core/derma/mainmenu/character.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/character.lua:2440)
- [ ] Character creation shell: [gamemode/core/derma/mainmenu/creation.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/creation.lua:491)
- [ ] Biography step: [gamemode/core/derma/mainmenu/steps/biography.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/steps/biography.lua:327)
- [ ] Model step: [gamemode/core/derma/mainmenu/steps/model.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/steps/model.lua:544)
- [ ] Summary step: [gamemode/core/derma/mainmenu/steps/summary.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/steps/summary.lua:310)
- [ ] Attribute step / rows: [gamemode/core/derma/panels/attribs.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/attribs.lua:75)

## Player Menu Tabs

- [ ] Main F1 shell: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:1452)
- [ ] `@you` tab / character info card: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2130)
- [ ] `@information` tab container: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2143)
- [ ] `@settings` tab container: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2238)
- [ ] `@themes` tab: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2743)

## Information Tabs

- [ ] Commands page: [gamemode/core/libraries/commands.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/commands.lua:1127)
- [ ] Character flags page: [gamemode/core/libraries/flags.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/flags.lua:175)
- [ ] Workshop addons page: [gamemode/core/libraries/workshop.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/workshop.lua:559)

## Settings Tabs

- [ ] Server config pages: [gamemode/core/libraries/config.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/config.lua:870)
- [ ] Client options pages: [gamemode/core/libraries/option.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/option.lua:536)
- [ ] Keybind pages: [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:1681)
- [ ] Weapon-item config extension: [gamemode/core/libraries/item.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/item.lua:1937)

## Admin Tabs

- [ ] Admin tab container in F1: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2379)
- [ ] Core admin pages / usergroups / permissions / entity tools: [gamemode/core/libraries/admin.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/admin.lua:3848)
- [ ] Administration module pages: [gamemode/modules/administration/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/libraries/client.lua:3778)
- [ ] Ticket pages and live ticket frames: [gamemode/modules/administration/submodules/tickets/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/tickets/libraries/client.lua:1)
- [ ] Warning pages: [gamemode/modules/administration/submodules/warnings/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/warnings/netcalls/client.lua:1)
- [ ] PK review pages: [gamemode/modules/administration/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/netcalls/client.lua:184)
- [ ] Logs tab: [gamemode/modules/administration/submodules/logs/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/logs/libraries/client.lua:356)
- [ ] Team/class admin tabs: [gamemode/modules/teams/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/teams/libraries/client.lua:830)
- [ ] Admin stick multi-tab tools: [gamemode/modules/administration/submodules/adminstick/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/adminstick/libraries/client.lua:689)

## Inventory, Storage, and Vendor

- [ ] Grid inventory panel flow: [gamemode/modules/inventory/types/gridinv/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/libraries/client.lua:239)
- [ ] Weight inventory panel flow: [gamemode/modules/inventory/types/weightinv/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/weightinv/libraries/client.lua:236)
- [ ] Storage unlock/open flow: [gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua:1)
- [ ] Standalone inventory menu: [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:1072)
- [ ] Vendor storefront: [gamemode/modules/vendor/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/libraries/client.lua:1)
- [ ] Vendor editor: [gamemode/modules/vendor/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/netcalls/client.lua:49)

## Interaction Panels

- [ ] Quick menu: [gamemode/core/derma/panels/quick.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/quick.lua:746)
- [ ] Radial interaction menu: [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1243)
- [ ] NPC dialog menu: [gamemode/core/derma/panels/dialog.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/dialog.lua:661)
- [ ] Door menu: [gamemode/core/derma/panels/door.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/door.lua:92)
- [ ] Bodygrouper / wardrobe flow: [gamemode/core/derma/panels/bodygrouper.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/bodygrouper.lua:202)

## Chat, Scoreboard, and HUD

- [ ] Chatbox: [gamemode/core/derma/panels/chatbox.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/chatbox.lua:691)
- [ ] Scoreboard: [gamemode/core/derma/panels/scoreboard.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/scoreboard.lua:725)
- [ ] Voice panel: [gamemode/core/derma/panels/voice.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/voice.lua:149)
- [ ] Action circle / progress UI: [gamemode/core/derma/panels/circle.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/circle.lua:80)
- [ ] Notices and question prompts: [gamemode/core/derma/panels/notice.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/notice.lua:174)

## Shared Building Blocks

- [ ] Tabs system: [gamemode/core/derma/panels/tabs.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/tabs.lua:421)
- [ ] Frame shell: [gamemode/core/derma/panels/frame.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/frame.lua:397)
- [ ] Scroll panel: [gamemode/core/derma/panels/scrollpanel.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/scrollpanel.lua:19)
- [ ] Table widget: [gamemode/core/derma/panels/table.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/table.lua:633)
- [ ] Entry / text field: [gamemode/core/derma/panels/entry.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/entry.lua:310)
- [ ] Buttons / checkbox / combobox / slider primitives: [gamemode/core/derma/panels/buttons.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/buttons.lua:233), [gamemode/core/derma/panels/checkbox.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/checkbox.lua:124), [gamemode/core/derma/panels/combobox.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/combobox.lua:399), [gamemode/core/derma/panels/slider.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/slider.lua:179)

## Review Order

- [ ] 1. Character Menu
- [ ] 2. Player Menu Tabs
- [ ] 3. Settings Tabs
- [ ] 4. Admin Tabs
- [ ] 5. Inventory / Vendor / Storage
- [ ] 6. Interaction Panels
- [ ] 7. Chat / Scoreboard / HUD
- [ ] 8. Shared Building Blocks

# Lilia UI Audit

## Summary

- Custom registered panels / custom controls found: `48`
- Direct VGUI creation systems found: `34+`
- Manually drawn UI / HUD systems found: `24+`
- Network-triggered UI paths found: `20+`
- Command-triggered UI entry points found: `10+`
- Hook-triggered UI entry points found: `12+`
- Entity / item / interaction-triggered UI entry points found: `14+`
- Dynamic / unresolved-at-static-time UI extension points found: `11`

Notes:

- Totals are conservative and count reviewable systems/entry points, not every child `DLabel`/`DButton` created inside a larger builder function.
- A few systems are intentionally grouped by builder function because single functions create dozens of child controls.
- `vgui.Register` appears `63` times total, but that includes duplicate class names, `vgui.RegisterTable`, and `derma.DefineControl` helpers. The actionable custom panel/control total is `48`.

## Network-Triggered UI

- [ ] `liaActionCircle` - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1186)
  - Network: `liaActBar`
  - Trigger: `net.Receive`
  - Creates/opens: `vgui.Create("liaActionCircle")`
  - Call chain: `net.Receive("liaActBar") -> vgui.Create("liaActionCircle") -> PANEL:Start`
  - Purpose: timed action/progress circle
  - Notes: same visual can also be opened through `PlayerMeta:doAction` in [gamemode/core/meta/player.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/meta/player.lua:289)

- [ ] Dual inventory panels - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1203)
  - Network: `liaOpenInvMenu`
  - Trigger: `net.Receive`
  - Creates/opens: inventory UI via `lia.inventory.showDual`
  - Call chain: `net.Receive("liaOpenInvMenu") -> lia.inventory.showDual -> lia.inventory.show -> hook.Run("CreateInventoryPanel")`
  - Purpose: staff inventory inspection / remote inventory viewing
  - Notes: final panel class is dynamic and depends on the active inventory type hook

- [ ] Options request frame - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1216)
  - Network: `liaOptionsRequest`
  - Trigger: `net.Receive`
  - Creates/opens: `lia.derma.requestOptions`
  - Call chain: `net.Receive -> lia.derma.requestOptions -> vgui.Create("liaFrame")`
  - Purpose: generic server-driven checkbox/combo request UI

- [ ] Interaction / action radial menu - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1243)
  - Network: `liaProvideInteractOptions`
  - Trigger: `net.Receive`
  - Creates/opens: `lia.playerinteract.openMenu`
  - Call chain: `net.Receive -> lia.playerinteract.openMenu`
  - Purpose: player interactions / personal actions
  - Notes: actual panel is built in `playerinteract.lua`; menu content is fully network-driven

- [ ] Dropdown request frame - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1285)
  - Network: `liaRequestDropdown`
  - Trigger: `net.Receive`
  - Creates/opens: `lia.derma.requestDropdown`
  - Call chain: `net.Receive -> lia.derma.requestDropdown -> vgui.Create("liaFrame")`
  - Purpose: generic server-driven selection list

- [ ] Arguments request frame - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1310)
  - Network: `liaArgumentsRequest`
  - Trigger: `net.Receive`
  - Creates/opens: `lia.derma.requestArguments`
  - Call chain: `net.Receive -> lia.derma.requestArguments -> vgui.Create("liaFrame")`
  - Purpose: generic multi-field form

- [ ] String request frame - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1328)
  - Network: `liaStringRequest`
  - Trigger: `net.Receive`
  - Creates/opens: `lia.derma.requestString`
  - Call chain: `net.Receive -> lia.derma.requestString -> vgui.Create("liaFrame")`
  - Purpose: generic single-text prompt

- [ ] Binary question notice - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1421)
  - Network: `liaBinaryQuestionRequest`
  - Trigger: `net.Receive`
  - Creates/opens: `liaNoticePanel` + child `DButton`s
  - Call chain: `net.Receive -> CreateNoticePanel -> vgui.Create("liaNoticePanel")`
  - Purpose: top-screen accept/decline/cancel prompt

- [ ] Popup question frame - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1545)
  - Network: `liaPopupQuestionRequest`
  - Trigger: `net.Receive`
  - Creates/opens: `lia.derma.requestPopupQuestion`
  - Call chain: `net.Receive -> lia.derma.requestPopupQuestion -> vgui.Create("liaFrame")`
  - Purpose: generic multi-button popup

- [ ] Button request frame - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1566)
  - Network: `liaButtonRequest`
  - Trigger: `net.Receive`
  - Creates/opens: `lia.derma.requestButtons`
  - Call chain: `net.Receive -> lia.derma.requestButtons -> vgui.Create("liaFrame")`
  - Purpose: generic button list prompt

- [ ] Command argument prompt - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1598)
  - Network: `liaCmdArgPrompt`
  - Trigger: `net.Receive`
  - Creates/opens: `lia.command.openArgumentPrompt`
  - Call chain: `net.Receive -> lia.command.openArgumentPrompt -> request-style frame UI`
  - Purpose: command argument entry UI

- [ ] NPC dialog window - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1646)
  - Network: `liaOpenNpcDialog`
  - Trigger: `net.Receive`
  - Creates/opens: `vgui.Create("liaDialogMenu")`
  - Call chain: `net.Receive -> vgui.Create("liaDialogMenu") -> LoadNPCDialog`
  - Purpose: NPC conversation / generated dialog UI

- [ ] NPC type selection window - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1685)
  - Network: `liaRequestNPCSelection`
  - Trigger: `net.Receive`
  - Creates/opens: direct `liaFrame` + `liaScrollPanel` + `liaButton` list
  - Call chain: `net.Receive -> vgui.Create("liaFrame")`
  - Purpose: select NPC dialog type/configuration

- [ ] Door menu - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1920)
  - Network: `liaDoorMenu`
  - Trigger: `net.Receive`
  - Creates/opens: `vgui.Create("liaDoorMenu")`
  - Call chain: `net.Receive -> vgui.Create("liaDoorMenu") -> PANEL:setDoor`
  - Purpose: door ownership/access management

- [ ] Workshop downloader / addon browser - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:2108)
  - Network: `liaWorkshopDownloaderStart`
  - Trigger: `net.Receive`
  - Creates/opens: workshop UI via `refresh(...)`
  - Call chain: `net.Receive -> workshop UI builder in gamemode/core/libraries/workshop.lua`
  - Purpose: server content download/mount review
  - Notes: exact panel class is builder-driven, not a single `vgui.Register` class

- [ ] Bodygrouper menu - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:2145)
  - Network: `BodygrouperMenu`
  - Trigger: `net.Receive`
  - Creates/opens: `vgui.Create("BodygrouperMenu")`
  - Call chain: `net.Receive -> vgui.Create("BodygrouperMenu") -> SetTarget`
  - Purpose: bodygroup/skin editing

- [ ] Model selection frame - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:2155)
  - Network: `SeeModelTable`
  - Trigger: `net.Receive`
  - Creates/opens: direct `liaFrame` + `liaScrollPanel` model buttons
  - Purpose: wardrobe/model-switch UI

- [ ] Vendor UI open path - [gamemode/modules/vendor/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/netcalls/client.lua:33)
  - Network: `liaVendorOpen`
  - Trigger: `net.Receive`
  - Creates/opens: vendor UI indirectly through hook
  - Call chain: `net.Receive("liaVendorOpen") -> hook.Run("VendorOpened", vendor) -> MODULE:VendorOpened in gamemode/modules/vendor/libraries/client.lua -> vgui.Create("liaVendor")`
  - Purpose: vendor storefront

- [ ] Vendor editor UI - [gamemode/modules/vendor/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/netcalls/client.lua:49)
  - Network: `liaVendorEdit`
  - Trigger: `net.Receive`
  - Creates/opens: vendor editor indirectly
  - Call chain: `net.Receive("liaVendorEdit") -> timer.Simple -> hook.Run("VendorEdited") -> vendor client hook -> vgui.Create("liaVendorEditor")`
  - Purpose: vendor configuration editor

- [ ] Storage unlock prompt - [gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua:1)
  - Network: `liaStorageUnlock`
  - Trigger: `net.Receive`
  - Creates/opens: string request prompt
  - Call chain: `net.Receive -> hook.Run("StorageUnlockPrompt") -> MODULE:StorageUnlockPrompt -> LocalPlayer():requestString`
  - Purpose: password entry for locked storage

- [ ] Storage dual inventory UI - [gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/submodules/storage/netcalls/client.lua:6)
  - Network: `liaStorageOpen`
  - Trigger: `net.Receive`
  - Creates/opens: storage UI through hook
  - Call chain: `net.Receive("liaStorageOpen") -> hook.Run("StorageOpen") -> MODULE:StorageOpen -> lia.inventory.showDual`
  - Purpose: trunk/storage container inventory
  - Notes: weight inventory module handles the same hook differently and opens `liaListStorage`

- [ ] Sitroom manager - [gamemode/modules/administration/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/netcalls/client.lua:123)
  - Network: `liaManagesitrooms`
  - Trigger: `net.Receive`
  - Creates/opens: direct `liaFrame` + rename prompt
  - Call chain: `net.Receive -> vgui.Create("liaFrame")`, and nested rename path creates another `liaFrame`
  - Purpose: manage sitroom definitions

- [ ] PK records browser - [gamemode/modules/administration/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/netcalls/client.lua:184)
  - Network: `liaAllPks`
  - Trigger: `net.Receive`
  - Creates/opens: populates existing admin page panel with `liaEntry` + `liaTable`
  - Purpose: PK case review UI

- [ ] Character list browser - [gamemode/modules/administration/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/netcalls/client.lua:326)
  - Network: `liaDisplayCharList`
  - Trigger: `net.Receive`
  - Creates/opens: `lia.util.createTableUI`
  - Call chain: `net.Receive -> lia.util.createTableUI -> lia.derma.createTableUI -> vgui.Create("liaDListView")`
  - Purpose: full character list browser

- [ ] Tickets table population - [gamemode/modules/administration/submodules/tickets/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/tickets/netcalls/client.lua:2)
  - Network: `liaActiveTickets`
  - Trigger: `net.Receive`
  - Creates/opens: populates existing admin page with `liaEntry` + `liaTable`
  - Purpose: active tickets page

- [ ] Ticket popup frames - [gamemode/modules/administration/submodules/tickets/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/tickets/netcalls/client.lua:111)
  - Network: `liaTicketSystem`
  - Trigger: `net.Receive`
  - Creates/opens: `MODULE:CreateTicketFrame`
  - Call chain: `net.Receive -> MODULE:CreateTicketFrame -> direct framed UI in tickets library`
  - Purpose: staff live-ticket popup windows

- [ ] Warnings table population - [gamemode/modules/administration/submodules/warnings/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/warnings/netcalls/client.lua:1)
  - Network: `liaAllWarnings`
  - Trigger: `net.Receive`
  - Creates/opens: populates existing admin page with `liaEntry` + `liaTable`
  - Purpose: warnings audit page

- [ ] Staff Discord prompt - [gamemode/modules/mainmenu/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/mainmenu/netcalls/client.lua:13)
  - Network: `liaStaffDiscordPrompt`
  - Trigger: `net.Receive`
  - Creates/opens: `lia.derma.requestString`
  - Purpose: prompt for staff Discord username during staff character setup

- [ ] Chatbox rebuild - [gamemode/modules/chatbox/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/chatbox/netcalls/client.lua:2)
  - Network: `liaRegenChat`
  - Trigger: `net.Receive`
  - Creates/opens: chatbox indirectly
  - Call chain: `net.Receive -> hook.Run("CreateChatboxPanel") -> MODULE:CreateChatboxPanel -> vgui.Create("liaChatBox")`
  - Purpose: regenerate the custom chatbox panel

## Registered Panels

- [ ] `liaCharacter`
  - Defined: [gamemode/core/derma/mainmenu/character.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/character.lua:2440)
  - Base: `EditablePanel`
  - Created from: [gamemode/modules/mainmenu/module.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/mainmenu/module.lua:497), [gamemode/core/derma/mainmenu/character.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/character.lua:2253)
  - Opened by: main menu module when player has no active character; can also be reopened locally
  - Purpose: top-level character selection / loading / creation screen

- [ ] `liaCharacterCreation`
  - Defined: [gamemode/core/derma/mainmenu/creation.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/creation.lua:491)
  - Base: `EditablePanel`
  - Created from: [gamemode/core/derma/mainmenu/character.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/character.lua:1739)
  - Opened by: character menu create-flow
  - Purpose: multi-step character creation shell

- [ ] `liaCharacterCreateStep`
  - Defined: [gamemode/core/derma/mainmenu/step.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/step.lua:72)
  - Base: `liaScrollPanel`
  - Created from: only subclassed in static analysis
  - Opened by: `liaCharacterBiography`, `liaCharacterModel`, `liaCharacterSummary`, `liaCharacterAttribs`
  - Purpose: common base for creation steps

- [ ] `liaCharacterBiography`
  - Defined: [gamemode/core/derma/mainmenu/steps/biography.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/steps/biography.lua:327)
  - Base: `liaCharacterCreateStep`
  - Created from: [gamemode/core/derma/mainmenu/creation.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/creation.lua:70)
  - Purpose: biography/name/field entry step

- [ ] `liaCharacterModel`
  - Defined: [gamemode/core/derma/mainmenu/steps/model.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/steps/model.lua:544)
  - Base: `liaCharacterCreateStep`
  - Created from: [gamemode/core/derma/mainmenu/creation.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/creation.lua:71)
  - Purpose: model / skin / bodygroup selection step

- [ ] `liaCharacterSummary`
  - Defined: [gamemode/core/derma/mainmenu/steps/summary.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/steps/summary.lua:310)
  - Base: `liaCharacterCreateStep`
  - Created from: [gamemode/core/derma/mainmenu/creation.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/creation.lua:18), [gamemode/core/derma/mainmenu/creation.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/creation.lua:81)
  - Purpose: review/finalize creation step

- [ ] `liaCharacterAttribs`
  - Defined: [gamemode/core/derma/panels/attribs.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/attribs.lua:75)
  - Base: `liaCharacterCreateStep`
  - Created from: [gamemode/core/derma/mainmenu/steps/biography.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/steps/biography.lua:152)
  - Purpose: attribute allocation widget inside creation

- [ ] `liaCharacterAttribsRow`
  - Defined: [gamemode/core/derma/panels/attribs.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/attribs.lua:198)
  - Base: `DPanel`
  - Created from: [gamemode/core/derma/panels/attribs.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/attribs.lua:45)
  - Purpose: per-attribute row

- [ ] `CircularAvatar`
  - Defined: [gamemode/core/derma/panels/avatar.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/avatar.lua:69) and again in [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:506)
  - Base: unspecified / `Panel`
  - Created from: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:529), [gamemode/modules/administration/submodules/adminstick/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/adminstick/libraries/client.lua:2442)
  - Purpose: masked circular avatar widget
  - Notes: duplicate class registration; requires runtime verification for final winner

- [ ] `BodygrouperMenu`
  - Defined: [gamemode/core/derma/panels/bodygrouper.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/bodygrouper.lua:202)
  - Base: `liaFrame`
  - Created from: [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:2149)
  - Opened by: entity use -> server `BodygrouperMenu` net -> client receive
  - Purpose: bodygroup editor

- [ ] `liaButton`
  - Defined: [gamemode/core/derma/panels/buttons.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/buttons.lua:233)
  - Base: `Button`
  - Created from: used across main menu, door menu, command prompts, dialog editor, admin tools, storage lock UI, vendor UI
  - Purpose: shared styled button primitive

- [ ] `liaChatBox`
  - Defined: [gamemode/core/derma/panels/chatbox.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/chatbox.lua:691)
  - Base: `liaFrame`
  - Created from: [gamemode/modules/chatbox/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/chatbox/libraries/client.lua:99)
  - Opened by: message-mode bind and `liaRegenChat`
  - Purpose: custom chatbox

- [ ] `liaCheckbox`
  - Defined: [gamemode/core/derma/panels/checkbox.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/checkbox.lua:124)
  - Base: `Panel`
  - Created from: config/options/commands/dialog/vendor systems
  - Purpose: shared styled checkbox primitive

- [ ] `liaActionCircle`
  - Defined: [gamemode/core/derma/panels/circle.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/circle.lua:80)
  - Base: `EditablePanel`
  - Created from: [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1198), [gamemode/core/meta/player.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/meta/player.lua:304)
  - Purpose: centered timed action indicator

- [ ] `liaComboBox`
  - Defined: [gamemode/core/derma/panels/combobox.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/combobox.lua:399)
  - Base: `DComboBox`
  - Created from: biography, admin/usergroup tools, config/options, keybind editor, dialog editor, workshop filter, vendor editor
  - Purpose: shared styled dropdown primitive

- [ ] `liaDialogMenu`
  - Defined: [gamemode/core/derma/panels/dialog.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/dialog.lua:661)
  - Base: `EditablePanel`
  - Created from: [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1657)
  - Opened by: NPC use -> server net -> client dialog open
  - Purpose: NPC dialog / conversation UI

- [ ] `liaDListView`
  - Defined: [gamemode/core/derma/panels/dlistview.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/dlistview.lua:133)
  - Base: `liaFrame`
  - Created from: [gamemode/core/libraries/derma.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/derma.lua:3104)
  - Purpose: searchable list-view window used by table browsers

- [ ] `liaDoorMenu`
  - Defined: [gamemode/core/derma/panels/door.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/door.lua:92)
  - Base: `liaFrame`
  - Created from: [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1934)
  - Opened by: door interaction -> `liaDoorMenu` network message
  - Purpose: door title/access editor

- [ ] `liaProgressBar`
  - Defined: [gamemode/core/derma/panels/dprogressbar.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/dprogressbar.lua:95)
  - Base: `DPanel`
  - Created from: main menu stats, F1 player stats, action bar in [gamemode/core/libraries/bars.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/bars.lua:247), notice-style server password prompt in [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1994)
  - Purpose: reusable progress bar / action bar

- [ ] `DTooltip`
  - Defined: [gamemode/core/derma/panels/dproperties.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/dproperties.lua:81)
  - Base: `DLabel`
  - Created from: no explicit creation site found during static analysis
  - Purpose: tooltip control for custom properties stack

- [ ] `DProperties`
  - Defined: [gamemode/core/derma/panels/dproperties.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/dproperties.lua:234)
  - Base: `Panel`
  - Created from: no explicit creation site found during static analysis
  - Purpose: custom properties panel implementation

- [ ] `liaEntry`
  - Defined: [gamemode/core/derma/panels/entry.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/entry.lua:310)
  - Base: `EditablePanel`
  - Created from: chatbox, DListView, door UI, config/options/admin/keybind/dialog/vendor, storage prompts
  - Purpose: shared styled text-entry primitive

- [ ] `liaCharInfo`
  - Defined: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:893)
  - Base: `EditablePanel`
  - Created from: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2135)
  - Purpose: player status card in F1

- [ ] `liaMenu`
  - Defined: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:1452)
  - Base: `EditablePanel`
  - Created from: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2124), [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:355)
  - Opened by: `gm_showhelp` / menu keybind / tab keybind helpers
  - Purpose: F1 menu shell

- [ ] `liaClasses`
  - Defined: [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2030)
  - Base: `EditablePanel`
  - Created from: [gamemode/modules/teams/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/teams/libraries/client.lua:327)
  - Purpose: joinable class browser

- [ ] `liaFrame`
  - Defined: [gamemode/core/derma/panels/frame.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/frame.lua:397)
  - Base: `EditablePanel`
  - Created from: almost every request dialog, utility popup, panel browser, item readers, scoreboard subwindows, admin utilities
  - Purpose: shared framed window shell

- [ ] `liaInventory`
  - Defined: [gamemode/core/derma/panels/frame.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/frame.lua:434)
  - Base: `liaFrame`
  - Created from: subclass base only
  - Purpose: inventory window shell

- [ ] `liaHeaderPanel`
  - Defined: [gamemode/core/derma/panels/headerpanel.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/headerpanel.lua:20)
  - Base: `Panel`
  - Created from: character summary, panel browser, model table selector
  - Purpose: standardized header strip

- [ ] `liaHorizontalScroll`
  - Defined: [gamemode/core/derma/panels/horizontal_scroll.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/horizontal_scroll.lua:70)
  - Base: `DPanel`
  - Created from: no external creation site found during static analysis
  - Purpose: horizontal scroll container

- [ ] `liaHorizontalScrollBar`
  - Defined: [gamemode/core/derma/panels/horizontal_scroll.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/horizontal_scroll.lua:128)
  - Base: `DVScrollBar`
  - Created from: internal use by `liaHorizontalScroll`
  - Purpose: custom scrollbar

- [ ] `liaItemIcon`
  - Defined: [gamemode/core/derma/panels/item.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/item.lua:278)
  - Base: `SpawnIcon`
  - Created from: inventory systems, vendor item cards, admin item preview
  - Purpose: item model icon with overlays/actions

- [ ] `liaModelPanel`
  - Defined: [gamemode/core/derma/panels/model.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/model.lua:149)
  - Base: `DModelPanel`
  - Created from: character creation, F1 preview, grid/weight inventory previews
  - Purpose: standardized model preview

- [ ] `liaNotice`
  - Defined: [gamemode/core/derma/panels/notice.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/notice.lua:174)
  - Base: `DPanel`
  - Created from: [gamemode/core/libraries/notice.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/notice.lua:77), [gamemode/core/libraries/notice.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/notice.lua:124), [gamemode/core/libraries/notice.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/notice.lua:440)
  - Purpose: standard notice card

- [ ] `liaNoticePanel`
  - Defined: [gamemode/core/derma/panels/notice.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/notice.lua:210)
  - Base: `DPanel`
  - Created from: [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1405)
  - Purpose: question/timeout notice container

- [ ] `liaQuick`
  - Defined: [gamemode/core/derma/panels/quick.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/quick.lua:746)
  - Base: `liaFrame`
  - Created from: [gamemode/core/hooks/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/hooks/client.lua:1622)
  - Opened by: context menu open hook
  - Purpose: quick actions/options menu

- [ ] `liaRadialPanel`
  - Defined: [gamemode/core/derma/panels/radialpanel.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/radialpanel.lua:556)
  - Base: `DPanel`
  - Created from: [gamemode/core/libraries/derma.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/derma.lua:278)
  - Purpose: radial options menu primitive

- [ ] `liaScoreboard`
  - Defined: [gamemode/core/derma/panels/scoreboard.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/scoreboard.lua:725)
  - Base: `liaFrame`
  - Created from: [gamemode/core/derma/panels/scoreboard.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/scoreboard.lua:703), [gamemode/core/derma/panels/scoreboard.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/scoreboard.lua:750), [gamemode/core/libraries/commands.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/commands.lua:1969)
  - Opened by: scoreboard hooks and reload command
  - Purpose: custom scoreboard

- [ ] `liaScrollPanel`
  - Defined: [gamemode/core/derma/panels/scrollpanel.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/scrollpanel.lua:19)
  - Base: `DScrollPanel`
  - Created from: used across main menu, F1, dialog, commands, config/options/keybind/workshop/admin/vendor
  - Purpose: shared styled scroll container

- [ ] `liaSheet`
  - Defined: [gamemode/core/derma/panels/sheet.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/sheet.lua:468)
  - Base: `DPanel`
  - Created from: internal recursion in [gamemode/core/derma/panels/sheet.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/sheet.lua:184)
  - Purpose: nested information/config content renderer

- [ ] `liaSlideBox`
  - Defined: [gamemode/core/derma/panels/slidebox.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/slidebox.lua:159)
  - Base: `Panel`
  - Created from: [gamemode/core/derma/panels/bodygrouper.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/bodygrouper.lua:56), [gamemode/core/derma/panels/bodygrouper.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/bodygrouper.lua:138)
  - Purpose: slider-like selector for skin/bodygroup values

- [ ] `liaSlider`
  - Defined: [gamemode/core/derma/panels/slider.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/slider.lua:179)
  - Base: `Panel`
  - Created from: character model customization, quick menu, vendor editor
  - Purpose: shared slider primitive

- [ ] `liaSpawnIcon`
  - Defined: [gamemode/core/derma/panels/spawnicon.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/spawnicon.lua:117)
  - Base: `DModelPanel`
  - Created from: [gamemode/core/derma/panels/scoreboard.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/scoreboard.lua:495)
  - Purpose: scoreboard/player model icon

- [ ] `liaTable`
  - Defined: [gamemode/core/derma/panels/table.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/table.lua:633)
  - Base: `Panel`
  - Created from: door access table, admin tables, tickets/warnings/PK tables, teams compatibility table
  - Purpose: shared sortable/context-menu table widget

- [ ] `liaTabs`
  - Defined: [gamemode/core/derma/panels/tabs.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/tabs.lua:421)
  - Base: `Panel`
  - Created from: F1 top tabs and adminstick tab strips
  - Purpose: custom tab navigation

- [ ] `liaTabButton`
  - Defined: [gamemode/core/derma/panels/tab_button.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/tab_button.lua:109)
  - Base: `DPanel`
  - Created from: [gamemode/core/derma/panels/tabs.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/tabs.lua:174)
  - Purpose: tab button primitive

- [ ] `liaVoicePanel`
  - Defined: [gamemode/core/derma/panels/voice.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/voice.lua:149)
  - Base: `DPanel`
  - Created from: [gamemode/core/derma/panels/voice.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/voice.lua:192)
  - Purpose: voice HUD speaker strip

- [ ] `liaStandaloneInventoryMenu`
  - Defined: [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:1072)
  - Base: `EditablePanel`
  - Created from: [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:1143)
  - Opened by: `lia_inventory` / keybind-based standalone inventory
  - Purpose: standalone inventory host for grid-inventory menu content

- [ ] `liaMarkupPanel`
  - Defined: [gamemode/core/libraries/thirdparty/cl_markup.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/thirdparty/cl_markup.lua:540)
  - Base: `DPanel`
  - Created from: [gamemode/core/derma/panels/chatbox.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/chatbox.lua:557)
  - Purpose: rich chat message markup renderer

- [ ] `liaPaintedNotification`
  - Defined: [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:797)
  - Base: `DPanel`
  - Created from: [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:812), [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:854), [gamemode/modules/chatbox/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/chatbox/libraries/client.lua:69)
  - Purpose: painted notification/chat insertion panel

- [ ] `liaAdminStickActionCollector`
  - Defined: [gamemode/modules/administration/submodules/adminstick/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/adminstick/libraries/client.lua:1751)
  - Base: `DPanel`
  - Created from: [gamemode/modules/administration/submodules/adminstick/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/adminstick/libraries/client.lua:1720), [gamemode/modules/administration/submodules/adminstick/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/adminstick/libraries/client.lua:2862)
  - Purpose: nested action collector for adminstick UI

- [ ] `liaAdminStickPanel`
  - Defined: [gamemode/modules/administration/submodules/adminstick/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/adminstick/libraries/client.lua:2860)
  - Base: `EditablePanel`
  - Created from: [gamemode/modules/administration/submodules/adminstick/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/adminstick/libraries/client.lua:2964)
  - Opened by: adminstick logic / state receive
  - Purpose: adminstick action browser

- [ ] `liaGridInventory`
  - Defined: [gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory.lua:107)
  - Base: `liaInventory`
  - Created from: [gamemode/modules/inventory/types/gridinv/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/libraries/client.lua:122)
  - Purpose: grid inventory frame

- [ ] `liaGridInventoryMenu`
  - Defined: [gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory.lua:656)
  - Base: `EditablePanel`
  - Created from: [gamemode/modules/inventory/types/gridinv/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/libraries/client.lua:256), [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:1143)
  - Purpose: standalone/in-menu inventory surface

- [ ] `liaGridInvItem`
  - Defined: [gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory_item.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory_item.lua:176)
  - Base: `liaItemIcon`
  - Created from: [gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory_panel.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory_panel.lua:394)
  - Purpose: grid cell item icon

- [ ] `liaGridInventoryPanel`
  - Defined: [gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory_panel.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory_panel.lua:532)
  - Base: `DPanel`
  - Created from: keybind standalone inventory, `liaGridInventory`, bag viewport panels
  - Purpose: grid layout/content panel

- [ ] `liaListInventory`
  - Defined: [gamemode/modules/inventory/types/weightinv/derma/cl_list_inventory.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/weightinv/derma/cl_list_inventory.lua:27)
  - Base: `liaInventory`
  - Created from: [gamemode/modules/inventory/types/weightinv/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/weightinv/libraries/client.lua:226), [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:1247)
  - Purpose: weight/list inventory frame

- [ ] `liaListInventoryPanel`
  - Defined: [gamemode/modules/inventory/types/weightinv/derma/cl_list_inventory_panel.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/weightinv/derma/cl_list_inventory_panel.lua:169)
  - Base: `DPanel`
  - Created from: list inventory frame and list storage frame
  - Purpose: item grid/list content holder

- [ ] `liaListStorage`
  - Defined: [gamemode/modules/inventory/types/weightinv/derma/cl_list_storage.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/weightinv/derma/cl_list_storage.lua:80)
  - Base: `DFrame`
  - Created from: [gamemode/modules/inventory/types/weightinv/derma/cl_list_storage.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/weightinv/derma/cl_list_storage.lua:83), [gamemode/modules/inventory/types/weightinv/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/weightinv/libraries/client.lua:233)
  - Opened by: `StorageOpen` hook when weight inventory type is active
  - Purpose: paired storage/list inventory window

- [ ] `liaVendor`
  - Defined: [gamemode/modules/vendor/derma/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/derma/client.lua:474)
  - Base: `EditablePanel`
  - Created from: [gamemode/modules/vendor/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/libraries/client.lua:91)
  - Opened by: `liaVendorOpen` -> `VendorOpened` hook
  - Purpose: vendor storefront

- [ ] `liaVendorItem`
  - Defined: [gamemode/modules/vendor/derma/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/derma/client.lua:739)
  - Base: `DPanel`
  - Created from: [gamemode/modules/vendor/derma/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/derma/client.lua:279)
  - Purpose: item card inside vendor UI

- [ ] `liaVendorEditorItemRow`
  - Defined: [gamemode/modules/vendor/derma/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/derma/client.lua:1618)
  - Base: `DPanel`
  - Created from: [gamemode/modules/vendor/derma/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/derma/client.lua:2185)
  - Purpose: item row in editor

- [ ] `liaVendorEditor`
  - Defined: [gamemode/modules/vendor/derma/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/derma/client.lua:2196)
  - Base: `liaFrame`
  - Created from: [gamemode/modules/vendor/derma/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/derma/client.lua:129)
  - Opened by: vendor edit path after network trigger
  - Purpose: vendor editor

## Direct Panel Creation

- [ ] Request/dialog utility suite - [gamemode/core/libraries/derma.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/derma.lua:91)
  - Function: `lia.derma.requestColorPicker`, `requestPlayerSelector`, `requestArguments`, `createTableUI`, `openOptionsMenu`, `requestDropdown`, `requestString`, `requestOptions`, `requestBinaryQuestion`, `requestButtons`, `requestPopupQuestion`
  - Trigger: called by network handlers, admin tools, config/options/keybinds, vendor/storage flows, and commands
  - Purpose: shared direct-creation UI toolkit

- [ ] Command panel browser - [gamemode/core/libraries/commands.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/commands.lua:8374)
  - Function: `openPanelBrowser`
  - Trigger: `net.Receive("liaOpenPanelBrowser")` and `lia.command.add("panelbrowser")`
  - Purpose: preview shared panels from a browser-like frame

- [ ] Scoreboard reload utility - [gamemode/core/libraries/commands.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/commands.lua:1967)
  - Function: `concommand.Add("lia_scoreboard_reload", ...)`
  - Trigger: console command
  - Purpose: force-create/reload scoreboard frame

- [ ] Admin shared spawned-entity/detail viewers - [gamemode/modules/administration/libraries/shared.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/libraries/shared.lua:381)
  - Function: inline `DFrame` builder with `liaScrollPanel`, `DTextEntry`, copy buttons
  - Trigger: admin feature actions
  - Purpose: data inspection popup

- [ ] Sitroom manager / rename prompt - [gamemode/modules/administration/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/netcalls/client.lua:123)
  - Function: net-driven frame builder
  - Trigger: network
  - Purpose: manage and rename sitrooms

- [ ] Ticket frame builder - [gamemode/modules/administration/submodules/tickets/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/tickets/libraries/client.lua:41)
  - Function: `MODULE:CreateTicketFrame`
  - Trigger: `liaTicketSystem`
  - Purpose: per-ticket live popup window

- [ ] Item book reader - [gamemode/items/base/books.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/items/base/books.lua:9)
  - Function: item `Read`
  - Trigger: item interaction
  - Creates: `liaFrame` + `DHTML`
  - Purpose: open book content URL

- [ ] Item URL viewer - [gamemode/items/base/url.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/items/base/url.lua:15)
  - Function: item `use`
  - Trigger: item interaction
  - Creates: `liaFrame` + `DHTML`
  - Purpose: open item-linked URL

- [ ] Team note editor / faction roster admin page - [gamemode/modules/teams/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/teams/libraries/client.lua:228)
  - Function: note editor frame and admin roster page builders
  - Trigger: faction roster/admin tab actions
  - Purpose: faction note editing and roster/member details

- [ ] Vendor preset selectors - [gamemode/modules/vendor/derma/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/derma/client.lua:1693)
  - Function: preset selector and delete selector builders
  - Trigger: vendor editor buttons
  - Creates: direct `DPanel` overlays containing `liaFrame` children
  - Purpose: load/delete vendor presets

- [ ] Character/NPC/model selection frame - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1685)
  - Function: NPC selection frame builder
  - Trigger: network
  - Purpose: choose NPC type/configuration

- [ ] Character delete confirmation / info popups - [gamemode/core/derma/mainmenu/character.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/mainmenu/character.lua:1851)
  - Function: info frame and confirmation frame builders
  - Trigger: character menu actions
  - Purpose: detail view and destructive-action confirmation

## HUD / Manually Drawn UI

- [ ] Main HUD renderer - [gamemode/core/hooks/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/hooks/client.lua:1370)
  - Hook: `GM:HUDPaint`
  - Drawing APIs: `draw.SimpleText`, `draw.RoundedBox`, `surface.DrawRect`, helper renderers
  - Purpose: core player HUD, player/entity info, crosshair-like markers, various contextual overlays
  - Trigger/conditions: always active when client HUD is visible

- [ ] HUD background renderer - [gamemode/core/hooks/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/hooks/client.lua:1596)
  - Hook: `GM:HUDPaintBackground`
  - Drawing APIs: `surface.DrawRect`, `draw.SimpleText`
  - Purpose: blackout/fallover overlay and branch warning text

- [ ] Action/stat bars system - [gamemode/core/libraries/bars.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/bars.lua:335)
  - Hook: `HUDPaintBackground`
  - Drawing APIs: bar draw helpers and `liaProgressBar`
  - Purpose: stamina/needs/action bar stack

- [ ] Waypoint overlay - [gamemode/core/meta/player.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/meta/player.lua:1465)
  - Hook: dynamic `HUDPaint`
  - Drawing APIs: `surface.SetMaterial`, `surface.DrawTexturedRect`, `draw.SimpleText`
  - Purpose: world waypoint name/distance/logo overlay
  - Trigger/conditions: created per active waypoint

- [ ] Blind target blackout - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:931)
  - Hook: dynamic `HUDPaint`
  - Drawing APIs: `draw.RoundedBox`
  - Purpose: full-screen black blindfold/obscure effect

- [ ] Blind fade overlay - [gamemode/modules/administration/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/netcalls/client.lua:58)
  - Hook: dynamic `HUDPaint`
  - Drawing APIs: `surface.DrawRect`
  - Purpose: black/white flash fade effect

- [ ] Scoreboard paint system - [gamemode/core/derma/panels/scoreboard.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/scoreboard.lua:1)
  - Hook: frame/panel paint methods plus `ScoreboardShow`/`ScoreboardHide`
  - Drawing APIs: `draw.SimpleText`, `surface.DrawRect`, `surface.DrawOutlinedRect`
  - Purpose: faction/class/player scoreboard UI

- [ ] Weapon selector HUD - [gamemode/core/derma/panels/weaponselector.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/weaponselector.lua:349)
  - Hook: `HUDPaint`, `PlayerBindPress`, `StartCommand`
  - Drawing APIs: manual selector painting
  - Purpose: custom weapon switch HUD

- [ ] Hands crosshair - [gamemode/entities/weapons/lia_hands/cl_init.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/entities/weapons/lia_hands/cl_init.lua:4)
  - Hook/function: SWEP draw routine
  - Drawing APIs: `surface.DrawRect`
  - Purpose: simple center crosshair square

- [ ] Notification paint panels - [gamemode/core/derma/panels/notice.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/notice.lua:174)
  - Hook/function: panel `Paint`
  - Drawing APIs: `draw.RoundedBox`, text helpers
  - Purpose: notice and question card rendering

- [ ] Painted chat notifications - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:747)
  - Hook/function: `liaPaintedNotification` panel `Paint`
  - Drawing APIs: `draw.RoundedBox`, `draw.SimpleText`, `surface.DrawText`
  - Purpose: shadowed multi-line message card

- [ ] Panel meta drawing toolkit - [gamemode/core/meta/panel.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/meta/panel.lua:190)
  - Hook/function: helper methods used by many custom panels
  - Drawing APIs: `surface.DrawPoly`, `draw.RoundedBox`, `surface.DrawTexturedRect`, stencil ops, blur ops
  - Purpose: reusable rounded boxes, outlines, gradients, circle effects, blur, stencil clipping
  - Notes: infrastructure, but directly affects visual output across the codebase

- [ ] Skin renderer - [gamemode/core/derma/skins/skin.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/skins/skin.lua:1)
  - Hook/function: Derma skin paints
  - Drawing APIs: `draw.RoundedBox`, `surface.DrawRect`, `draw.SimpleText`
  - Purpose: default Lilia skin

- [ ] Alternate skin renderer - [gamemode/core/derma/skins/skin_alt.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/skins/skin_alt.lua:1)
  - Hook/function: alternate Derma skin paints
  - Drawing APIs: `surface.DrawRect`, `surface.DrawOutlinedRect`
  - Purpose: legacy/alternate UI skin

- [ ] Vendor UI paint suite - [gamemode/modules/vendor/derma/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/derma/client.lua:16)
  - Hook/function: multiple panel `Paint` overrides
  - Drawing APIs: `surface.SetMaterial`, `surface.DrawRect`, `draw.SimpleText`, `draw.RoundedBox`
  - Purpose: storefront/editor card rendering

- [ ] Grid inventory visual overlays - [gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory.lua:122)
  - Hook/function: header/search/details paints
  - Drawing APIs: `draw.SimpleText`, `surface.DrawLine`, `surface.DrawCircle`, `surface.DrawRect`
  - Purpose: grid inventory headings, search icon, detail card accents

- [ ] Grid inventory item overlays - [gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory_item.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/derma/cl_grid_inventory_item.lua:65)
  - Hook/function: item icon paint
  - Drawing APIs: `surface.DrawTexturedRect`, `draw.SimpleText`
  - Purpose: item art and quantity overlays

- [ ] Standalone inventory header paint - [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:1066)
  - Hook/function: `liaStandaloneInventoryMenu` paint
  - Drawing APIs: `draw.SimpleText`, `surface.DrawRect`
  - Purpose: standalone inventory title/stats bar

- [ ] Options page paints - [gamemode/core/libraries/option.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/option.lua:790)
  - Hook/function: category rows and empty states
  - Drawing APIs: `draw.SimpleText`, `surface.DrawRect`, `draw.RoundedBox`
  - Purpose: options browser page visuals

- [ ] Keybind page paints - [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:1830)
  - Hook/function: category rows, empty states, icons, save indicators
  - Drawing APIs: `draw.SimpleText`, `surface.DrawRect`, `surface.DrawOutlinedRect`
  - Purpose: keybind browser visuals

- [ ] Workshop content page paints - [gamemode/core/libraries/workshop.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/workshop.lua:413)
  - Hook/function: stats cards, rows, detail panels, progress meters
  - Drawing APIs: `draw.RoundedBox`, `draw.SimpleText`, `draw.DrawText`, `surface.DrawRect`, `surface.DrawTexturedRect`
  - Purpose: workshop/addon information pages in F1

- [ ] Sit helper world indicators - [gamemode/core/libraries/sit.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/sit.lua:242)
  - Hook: `PostDrawOpaqueRenderables`
  - Drawing APIs: `cam.Start3D2D`, `surface.DrawTexturedRectRotated`
  - Purpose: sit-position arrows

- [ ] Item state overlay markers - [gamemode/items/base/weapons.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/items/base/weapons.lua:145), [gamemode/items/base/outfit.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/items/base/outfit.lua:107), [gamemode/items/base/pacoutfit.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/items/base/pacoutfit.lua:15), [gamemode/items/base/arccw_att.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/items/base/arccw_att.lua:14)
  - Hook/function: item icon paint overlays
  - Drawing APIs: `draw.RoundedBox`
  - Purpose: equipped/active state indicators on item icons

## Command-Triggered UI

- [ ] F1 menu - [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2119)
  - Trigger: `PlayerBindPress` on `gm_showhelp`
  - Call chain: `PlayerBindPress -> vgui.Create("liaMenu")`

- [ ] Standalone inventory - [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:1303)
  - Trigger: `concommand.Add("lia_inventory")` and bound key actions
  - Call chain: `toggleStandaloneInventory -> createStandaloneGridInventory/createStandaloneListInventory`

- [ ] Scoreboard reload - [gamemode/core/libraries/commands.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/commands.lua:1967)
  - Trigger: `concommand.Add("lia_scoreboard_reload")`
  - Call chain: `vgui.Create("liaScoreboard")`

- [ ] VGUI cleanup - [gamemode/core/libraries/commands.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/commands.lua:1972)
  - Trigger: `concommand.Add("lia_vgui_cleanup")`
  - Purpose: closes stray panels
  - Notes: cleanup utility, not itself a creator

- [ ] Panel browser - [gamemode/core/libraries/commands.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/commands.lua:8477)
  - Trigger: `lia.command.add("panelbrowser")`
  - Call chain: `onRun -> net.Start("liaOpenPanelBrowser") -> client openPanelBrowser`

- [ ] Chatbox open - [gamemode/modules/chatbox/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/chatbox/libraries/client.lua:120)
  - Trigger: `PlayerBindPress` on `messagemode`
  - Call chain: `hook.Run("CreateChatboxPanel") -> vgui.Create("liaChatBox")`

- [ ] Quick menu - [gamemode/core/hooks/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/hooks/client.lua:1614)
  - Trigger: context-menu key open
  - Call chain: `GM:OnContextMenuOpen -> vgui.Create("liaQuick")`

- [ ] Menu tab keybinds - [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:353)
  - Trigger: dynamically registered tab-opening keybinds
  - Call chain: `openMenuTab -> vgui.Create("liaMenu")`

- [ ] Character menu close - [gamemode/modules/mainmenu/module.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/mainmenu/module.lua:500)
  - Trigger: `PlayerButtonDown` on `KEY_ESCAPE`
  - Purpose: closes main menu UI

## Hook-Triggered UI

- [ ] Character menu shell - [gamemode/modules/mainmenu/module.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/mainmenu/module.lua:492)
  - Hook/path: `MODULE:OpenCharacterMenu`, `ResetCharacterPanel`, `OpenCharacterMenuOverride`
  - Call chain: no-char state -> `OpenCharacterMenu` -> `vgui.Create("liaCharacter")`

- [ ] Vendor storefront - [gamemode/modules/vendor/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/libraries/client.lua:91)
  - Hook/path: `VendorOpened`
  - Call chain: `hook.Run("VendorOpened") -> vgui.Create("liaVendor")`

- [ ] Vendor editor - [gamemode/modules/vendor/derma/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/derma/client.lua:129)
  - Hook/path: `VendorEdited`
  - Call chain: `hook.Run("VendorEdited") -> vgui.Create("liaVendorEditor")`

- [ ] Storage open abstraction - [gamemode/modules/inventory/types/gridinv/submodules/storage/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:22)
  - Hook/path: `StorageOpen`
  - Call chain: `hook.Run("StorageOpen") -> lia.inventory.showDual`

- [ ] Weight-inventory storage open - [gamemode/modules/inventory/types/weightinv/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/weightinv/libraries/client.lua:232)
  - Hook/path: `StorageOpen`
  - Call chain: `MODULE:StorageOpen -> vgui.Create("liaListStorage")`

- [ ] Inventory panel creation abstraction - [gamemode/core/libraries/inventory.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/inventory.lua:773)
  - Hook/path: `CreateInventoryPanel`
  - Call chain: `lia.inventory.show -> hook.Run("CreateInventoryPanel")`
  - Notes: final panel class is supplied by the active inventory implementation

- [ ] F1 information pages - [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2152)
  - Hook/path: `CreateInformationButtons`
  - Call chain: `liaMenu -> hook.Run("CreateInformationButtons") -> builder functions in commands/flags/workshop`

- [ ] F1 configuration pages - [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2247)
  - Hook/path: `PopulateConfigurationButtons`
  - Call chain: `liaMenu -> hook.Run("PopulateConfigurationButtons") -> config/option/keybind/weapon-item pages`

- [ ] F1 admin pages - [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:2373)
  - Hook/path: `PopulateAdminTabs`
  - Call chain: `liaMenu -> hook.Run("PopulateAdminTabs") -> admin/usergroups/teams/chatbox/staff tools pages`

- [ ] Quick menu - [gamemode/core/hooks/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/hooks/client.lua:1614)
  - Hook/path: `GM:OnContextMenuOpen`
  - Call chain: `OnContextMenuOpen -> vgui.Create("liaQuick")`

- [ ] Scoreboard - [gamemode/core/derma/panels/scoreboard.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/scoreboard.lua:758)
  - Hook/path: `ScoreboardShow` / `ScoreboardHide`
  - Call chain: `ScoreboardShow -> vgui.Create("liaScoreboard")`

- [ ] Chatbox creation abstraction - [gamemode/modules/chatbox/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/chatbox/libraries/client.lua:99)
  - Hook/path: `CreateChatboxPanel`
  - Call chain: `hook.Run("CreateChatboxPanel") -> vgui.Create("liaChatBox")`

## Entity / Interaction-Triggered UI

- [ ] Bodygrouper entity use - [gamemode/entities/entities/lia_bodygrouper/init.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/entities/entities/lia_bodygrouper/init.lua:10)
  - Trigger: `ENT:Use`
  - Call chain: `Use -> server net.Start("BodygrouperMenu") -> client vgui.Create("BodygrouperMenu")`

- [ ] Vendor entity use - [gamemode/modules/vendor/entities/entities/lia_vendor/init.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/vendor/entities/entities/lia_vendor/init.lua:13)
  - Trigger: `ENT:Use`
  - Call chain: `Use -> server vendor open net -> client hook -> vgui.Create("liaVendor")`

- [ ] Storage entity use - [gamemode/modules/inventory/types/gridinv/submodules/storage/entities/entities/lia_storage/init.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/submodules/storage/entities/entities/lia_storage/init.lua:59)
  - Trigger: `ENT:Use`
  - Call chain: `Use -> net.Start("liaStorageOpen") -> hook.Run("StorageOpen") -> inventory UI`

- [ ] NPC entity use - [gamemode/entities/entities/lia_npc/init.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/entities/entities/lia_npc/init.lua:43)
  - Trigger: `ENT:Use`
  - Call chain: `Use -> server dialog logic -> net.Start("liaOpenNpcDialog") -> vgui.Create("liaDialogMenu")`

- [ ] Wardrobe entity use - [gamemode/entities/entities/model_wardrobe/init.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/entities/entities/model_wardrobe/init.lua:30)
  - Trigger: `ENT:Use`
  - Call chain: `Use -> wardrobe/model table network path -> model selection frame`

- [ ] Book item read - [gamemode/items/base/books.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/items/base/books.lua:6)
  - Trigger: `ITEM.functions.Read`
  - Call chain: item action -> `vgui.Create("liaFrame")`

- [ ] URL item use - [gamemode/items/base/url.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/items/base/url.lua:9)
  - Trigger: `ITEM.functions.use`
  - Call chain: item action -> `vgui.Create("liaFrame")`

- [ ] Grid-inventory bag open - [gamemode/modules/inventory/types/gridinv/items/base/bags.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/items/base/bags.lua:99)
  - Trigger: bag item function
  - Call chain: `lia.inventory.showDual(myInv, inventory)`

- [ ] Player interaction menu - [gamemode/core/libraries/playerinteract.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/playerinteract.lua:510)
  - Trigger: interaction/action request flow
  - Call chain: trace/entity logic -> server options payload -> `lia.playerinteract.openMenu`

- [ ] Door interaction menu - [gamemode/core/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/netcalls/client.lua:1934)
  - Trigger: door use/interaction
  - Call chain: server door net -> `vgui.Create("liaDoorMenu")`

- [ ] Ticket popup frames - [gamemode/modules/administration/submodules/tickets/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/submodules/tickets/libraries/client.lua:41)
  - Trigger: server-side ticket creation by player action
  - Call chain: ticket creation -> `liaTicketSystem` -> `CreateTicketFrame`

- [ ] Storage lock management strip - [gamemode/modules/inventory/types/gridinv/submodules/storage/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/submodules/storage/libraries/client.lua:72)
  - Trigger: `OnCreateStoragePanel`
  - Call chain: storage open -> lock-management `DPanel` + `liaButton`s

## Miscellaneous UI

- [ ] F1 page injectors
  - Files: [gamemode/core/libraries/commands.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/commands.lua:1127), [gamemode/core/libraries/flags.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/flags.lua:175), [gamemode/core/libraries/workshop.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/workshop.lua:559), [gamemode/core/libraries/config.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/config.lua:870), [gamemode/core/libraries/option.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/option.lua:536), [gamemode/core/libraries/keybind.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/keybind.lua:1681), [gamemode/core/libraries/item.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/item.lua:1937), [gamemode/modules/teams/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/teams/libraries/client.lua:830), [gamemode/modules/chatbox/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/chatbox/libraries/client.lua:572), [gamemode/modules/administration/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/libraries/client.lua:5524)
  - Purpose: dynamically extend F1 info/config/admin tabs
  - Notes: must be reviewed feature-by-feature because panel creation is delegated through callbacks

- [ ] Font registration - [gamemode/core/libraries/fonts.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/fonts.lua:88)
  - API: `surface.CreateFont`
  - Purpose: all custom UI/HUD font families used by Derma and HUD

- [ ] Menu draw helper infrastructure - [gamemode/core/libraries/menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/menu.lua:133)
  - Purpose: shared manual draw stack for custom menus

## Potentially Dead / Unused Panels

- [ ] `DTooltip`
  - Defined: [gamemode/core/derma/panels/dproperties.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/dproperties.lua:81)
  - No creation/opening call found during static analysis
  - Requires manual verification

- [ ] `DProperties`
  - Defined: [gamemode/core/derma/panels/dproperties.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/dproperties.lua:234)
  - No creation/opening call found during static analysis
  - Requires manual verification

- [ ] `liaHorizontalScroll`
  - Defined: [gamemode/core/derma/panels/horizontal_scroll.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/horizontal_scroll.lua:70)
  - No external creation/opening call found during static analysis
  - Requires manual verification

- [ ] `liaInventory`
  - Defined: [gamemode/core/derma/panels/frame.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/frame.lua:434)
  - No direct `vgui.Create("liaInventory")` call found during static analysis
  - Used as a subclass base
  - Requires manual verification

## Duplicate / Overlapping UI Systems

- [ ] Grid inventory and weight inventory both exist and both hook `CreateMenuButtons` / `StorageOpen`
  - Files: [gamemode/modules/inventory/types/gridinv/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/gridinv/libraries/client.lua:239), [gamemode/modules/inventory/types/weightinv/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/inventory/types/weightinv/libraries/client.lua:236)
  - Notes: same abstract entry points, different final panel stacks

- [ ] Duplicate `CircularAvatar` registration
  - Files: [gamemode/core/derma/panels/avatar.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/avatar.lua:69), [gamemode/core/derma/panels/f1menu.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/f1menu.lua:506)
  - Notes: runtime load order decides which definition wins

- [ ] Two Derma skins ship in-tree
  - Files: [gamemode/core/derma/skins/skin.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/skins/skin.lua:1), [gamemode/core/derma/skins/skin_alt.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/skins/skin_alt.lua:1)
  - Notes: both are visual systems that should be reviewed together

- [ ] Legacy table/list admin pages and newer rich admin pages coexist
  - Files: [gamemode/modules/administration/netcalls/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/netcalls/client.lua:184), [gamemode/modules/administration/libraries/client.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/modules/administration/libraries/client.lua:1)
  - Notes: some features populate old `liaTable` pages while others use larger bespoke admin dashboards

- [ ] Scoreboard is opened both from hook flow and command/debug flow
  - Files: [gamemode/core/derma/panels/scoreboard.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/derma/panels/scoreboard.lua:758), [gamemode/core/libraries/commands.lua](/D:/GMOD/Server/garrysmod/gamemodes/Lilia/gamemode/core/libraries/commands.lua:1967)

## Audit Coverage

- Directories searched: `gamemode/core`, `gamemode/modules`, `gamemode/entities`, `gamemode/items`, top-level `gamemode/*.lua`
- File types searched: `*.lua`
- Lua files inspected: `266`
- Major search patterns used: `vgui.Register`, `derma.DefineControl`, `vgui.Create`, `:Add(`, `DermaMenu`, `HUDPaint`, `HUDPaintBackground`, `ScoreboardShow`, `ScoreboardHide`, `OnContextMenuOpen`, `PlayerBindPress`, `draw.`, `surface.`, `render.`, `cam.Start2D`, `CreateFont`, `net.Receive`, `lia.net.readBigTable`, `MakePopup`, `SetVisible`, `:Show(`, `:Open(`, `notification`
- Directories intentionally excluded: `documentation`, `tools`, non-Lua `content`
- Findings that could not be statically resolved:
  - `CreateInventoryPanel` final class depends on active inventory implementation and hooks
  - `CreateInformationButtons`, `PopulateConfigurationButtons`, and `PopulateAdminTabs` defer page construction to callback registrants
  - `CircularAvatar` is registered twice
  - `DTooltip`, `DProperties`, `liaHorizontalScroll`, and base `liaInventory` had no direct external creation calls in static analysis
  - some UI mutations happen through update hooks rather than first-time creation, especially vendor/admin pages

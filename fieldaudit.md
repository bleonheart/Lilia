## FACTION

- `index` - Numeric team index used to register the faction with Garry's Mod's team system.
- `uniqueID` - Stable string ID used for lookups, whitelists, transfers, doors, and saved faction references.
- `name` - Display name shown in menus, logs, notifications, and team labels.
- `desc` - Description text shown to players and used anywhere faction information is summarized.
- `color` - Team color used for `team.SetUp`, UI display, and faction-related presentation.
- `models` - Model list or categorized model table used for character creation, previews, and faction model selection.
- `isDefault` - Marks whether the faction is available by default instead of requiring a whitelist.
- `skinAllowed` - Enables manual skin customization for characters in the faction.
- `bodygroupsAllowed` - Enables manual bodygroup customization for characters in the faction.
- `allowedSkins` - Optional whitelist of skin IDs that faction characters are allowed to use.
- `allowedBodygroups` - Optional whitelist rules that restrict which bodygroup values faction characters may use.
- `items` - Items automatically granted to a newly created character in this faction.
- `oneCharOnly` - Prevents a player from owning multiple characters in the same faction.
- `spawns` - Map-based spawn table for this faction.
- `NPCRelations` - NPC relationship overrides applied when faction members spawn or NPCs are created.
- `OnTransferred` - Callback run when a character is transferred into the faction.
- `health` - Base health override applied during loadout.
- `armor` - Base armor override applied during loadout.
- `weapons` - Weapons granted during loadout.
- `scale` - Player model scale multiplier applied during spawn/loadout.
- `runSpeed` - Multiplier applied to the configured run speed.
- `walkSpeed` - Multiplier applied to the configured walk speed.
- `jumpPower` - Multiplier applied to jump power.
- `bloodcolor` - Blood color override used when the player spawns.
- `OnSpawn` - Callback run after the faction's merged loadout attributes are applied.

## CLASS

- `index` - Numeric class index stored in `lia.class.list` and used for lookups.
- `uniqueID` - Stable string ID for the class.
- `name` - Display name used in class menus, logs, and notifications.
- `desc` - Description shown in class UI and summaries.
- `limit` - Maximum number of players allowed in the class at once; `0` means unlimited.
- `faction` - Required faction/team index that the class belongs to.
- `OnCanBe` - Callback that decides whether a player is allowed to join the class.
- `isDefault` - Marks the default class for a faction and affects whitelist behavior.
- `isWhitelisted` - Explicitly controls whether the class requires a whitelist instead of relying on default behavior.
- `color` - Optional UI color used when displaying class information.
- `logo` - Optional image path shown in class selection UI.
- `model` - Class-specific player model or model list override used when joining the class.
- `models` - Alternate class model collection used by UI and class selection code.
- `skin` - Default skin applied in class previews and class model presentation.
- `bodyGroups` - Preferred bodygroup table applied to class previews and normalized for character bodygroups.
- `bodygroups` - Lowercase alias of `bodyGroups`, supported by the same normalization and preview code.
- `subMaterials` - Submaterial overrides used in class model previews.
- `OnSet` - Callback run when the player joins the class.
- `OnTransferred` - Callback run when the player switches from one class to another.
- `OnLeave` - Callback run on the old class when the player leaves it.
- `health` - Base health override applied during loadout.
- `armor` - Base armor override applied during loadout.
- `weapons` - Weapons granted during loadout.
- `scale` - Player model scale multiplier applied during spawn/loadout.
- `runSpeed` - Multiplier applied to the configured run speed.
- `walkSpeed` - Multiplier applied to the configured walk speed.
- `jumpPower` - Multiplier applied to jump power.
- `bloodcolor` - Blood color override used when the player spawns.
- `NPCRelations` - NPC relationship overrides supported through the shared merged loadout attributes.
- `OnSpawn` - Callback run after the class's merged loadout attributes are applied.

## MODULE

- `name` - Primary display name for the module; the loader resolves it, uses it for bootstrap messages, and defaults privilege categories to it.
- `author` - Author metadata for the module.
- `discord` - Contact metadata for the module author.
- `desc` - Human-readable module description; resolved by the loader for UI/log output.
- `version` - Documented version number field for module metadata.
- `Privileges` - Table of admin privilege definitions registered while the module loads.
- `Dependencies` - Table of dependency includes; each entry can point at a file or folder plus an optional realm.
- `NetworkStrings` - Server-side list of network strings registered with `util.AddNetworkString`.
- `WorkshopContent` - Documented field for required Workshop content IDs.
- `WebSounds` - Client-side map of sound IDs/paths to remote URLs registered through `lia.websound`.
- `WebImages` - Client-side map of image IDs/paths to remote URLs registered through `lia.webimage`.
- `enabled` - Boolean or callback controlling whether the module should finish loading.
- `folder` - Internal module folder path; also used when loading dependencies and inventory types.
- `path` - Internal copy of the module load path set during initialization.
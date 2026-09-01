## Executive Summary

### Function Documentation
- **Total Functions:** 11
- **Documented:** 0 (0.0%)
- **Missing Functions:** 11 unique (11 total occurrences)
  - **Library Functions:** 5
  - **Hook Functions:** 0
  - **Meta Functions:** 6

### Hooks Documentation
- **Missing Hooks:** 4 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 4

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 6
- **Used Net Messages:** 6
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 510

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 11 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 5 functions

#### lia.medals
Count: 5 functions

- `lia.medals.getAll()`
- `lia.medals.getCharacterMedals()`
- `lia.medals.getIconPath()`
- `lia.medals.getIconURL()`
- `lia.medals.registerMedal()`

### Missing Meta Functions
Total: 6 functions

#### playerMeta
Count: 6 functions

- `playerMeta:canGiveMedals()`
- `playerMeta:canTakeMedals()`
- `playerMeta:giveMedal()`
- `playerMeta:giveMedalWorn()`
- `playerMeta:medalsID()`
- `playerMeta:takeMedal()`

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 4 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 4
- **Method Hooks:** 0 (`function GM:HookName(...)`, `function MODULE:HookName(...)`, `function SCHEMA:HookName(...)`)
- **Standard Hooks:** 4 (`hook.Add(...)`, `hook.Run(...)`, `hook.Call(...)`)
- **Unused Hooks:** 0 (documented but not registered)

### Module and Submodule Hook Registration Locations:
These hooks were found in external module scans, so you can see whether they belong to a parent module or only to a specific submodule.
- `MedalsDataUpdated`
  - module `medals` [standard] in `libraries/client.lua`
- `PlayerCanGiveMedals`
  - module `medals` [standard] in `libraries/server.lua`
- `PlayerCanTakeMedals`
  - module `medals` [standard] in `libraries/server.lua`
- `PlayerMedalsChanged`
  - module `medals` [standard] in `libraries/server.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `MedalsDataUpdated()`
- `PlayerCanGiveMedals()`
- `PlayerCanTakeMedals()`
- `PlayerMedalsChanged()`

## Localization Analysis

- **Unique Keys:** 0
- **Undefined Calls:** 0
- **Argument Mismatch:** 0

### Undefined Calls

- None

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `ITEM.desc` | Missing key | `medalDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\items\base\medal.lua | 2 |
| `ITEM.name` | Missing key | `medalName` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\items\base\medal.lua | 1 |
| `MODULE.desc` | Unlocalized string | `A comprehensive medal award and display system featuring multiple themed medal packs (1942 RP, US Military branches, Police departments, Star Wars RP), persistent character-based medal storage with rarity tiers (Common, Uncommon, Rare, Exceptionally Rare), staff permissions for medal management, wearable medal slots (up to 5 medals), character profile integration, and admin controls for giving/taking medals with full network synchronization` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\module.lua | 9 |
| `MODULE.name` | Missing key | `Medals` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\module.lua | 3 |
| `Privilege.Category` | Missing key | `medals` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\client.lua | 5 |
| `Privilege.Category` | Missing key | `medals` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\client.lua | 15 |
| `Privilege.Category` | Missing key | `medals` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 13 |
| `Privilege.Category` | Missing key | `medals` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 116 |
| `Privilege.Category` | Missing key | `medals` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 259 |
| `Privilege.Category` | Missing key | `medals` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 297 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\module.lua | 14 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\module.lua | 19 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\module.lua | 24 |
| `Privilege.Name` | Unlocalized string | `Give Medal` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\client.lua | 4 |
| `Privilege.Name` | Unlocalized string | `Take Medal` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\client.lua | 14 |
| `Privilege.Name` | Unlocalized string | `Give Medal` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 12 |
| `Privilege.Name` | Unlocalized string | `Take Medal` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 115 |
| `Privilege.Name` | Unlocalized string | `Give All Medals` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 258 |
| `Privilege.Name` | Unlocalized string | `Give All Medals (Silent)` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 296 |
| `Privilege.Name` | Unlocalized string | `Can Give Medals Anytime` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\module.lua | 12 |
| `Privilege.Name` | Unlocalized string | `Can Take Medals Anytime` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\module.lua | 17 |
| `Privilege.Name` | Unlocalized string | `View Player Medals` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\module.lua | 22 |
| `data.category` | Missing key | `Medals` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\items\base\medal.lua | 3 |
| `data.category` | Unlocalized string | `Medals -` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\libraries\shared.lua | 73 |
| `data.desc` | Unlocalized string | `Give a medal to a player.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\client.lua | 2 |
| `data.desc` | Unlocalized string | `Take a medal from a player.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\client.lua | 12 |
| `data.desc` | Unlocalized string | `Give a medal to a player.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 10 |
| `data.desc` | Unlocalized string | `Take a medal from a player.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 113 |
| `data.desc` | Unlocalized string | `Give all medals to yourself or a target player.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 256 |
| `data.desc` | Unlocalized string | `Silently give all medals to yourself or a target player (no notifications).` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\commands\server.lua | 294 |
| `data.desc` | Missing key | `medalDesc` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\items\base\medal.lua | 2 |
| `data.desc` | Unlocalized string | `Awarded for 4 years of dedicated service in the Reich Labour Service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 3 |
| `data.desc` | Unlocalized string | `Awarded to party members for 10 years of loyal service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 15 |
| `data.desc` | Unlocalized string | `Given to those who have been a party member for more than 10 years.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 27 |
| `data.desc` | Unlocalized string | `Awarded for 12 years of dedicated service in the Reich Labour Service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 39 |
| `data.desc` | Unlocalized string | `Awarded to party members for 15 years of loyal service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 51 |
| `data.desc` | Unlocalized string | `Awarded for 18 years of devoted service in the Reich Labour Service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 63 |
| `data.desc` | Unlocalized string | `Awarded to party members for 25 years of loyal service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 75 |
| `data.desc` | Unlocalized string | `Awarded for 25 years of devoted service in the Reich Labour Service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 87 |
| `data.desc` | Unlocalized string | `Awarded to an appointed Generalfeldmarschall.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 99 |
| `data.desc` | Unlocalized string | `Awarded for meritorious service in artillery units.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 111 |
| `data.desc` | Unlocalized string | `Awarded for service aboard German auxiliary cruisers.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 123 |
| `data.desc` | Unlocalized string | `Awarded for contributions to the war economy and industrial efforts.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 135 |
| `data.desc` | Unlocalized string | `An honor badge recognizing special distinction.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 147 |
| `data.desc` | Unlocalized string | `An honor badge for outstanding achievements.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 159 |
| `data.desc` | Unlocalized string | `Awarded for anti-partisan operations against enemy irregular forces.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 171 |
| `data.desc` | Unlocalized string | `Commemorates the 100th anniversary of a significant Baumer event.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 183 |
| `data.desc` | Unlocalized string | `A coin issued to honor distinguished citizens of Baumer.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 195 |
| `data.desc` | Unlocalized string | `A ring presented for notable service to Baumer.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 207 |
| `data.desc` | Unlocalized string | `A religious or charitable order cross recognizing special devotion.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 219 |
| `data.desc` | Unlocalized string | `Awarded for service or cooperation in the Benelux region.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 231 |
| `data.desc` | Unlocalized string | `A papal or honorary medal for outstanding service to the community.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 243 |
| `data.desc` | Unlocalized string | `A variant awarded for anti-partisan operations, black grade.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 255 |
| `data.desc` | Unlocalized string | `Awarded for being wounded in combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 267 |
| `data.desc` | Unlocalized string | `Awarded for service on warships or merchant vessels running enemy blockades.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 279 |
| `data.desc` | Unlocalized string | `A highly prestigious NSDAP decoration recognizing participation in early party actions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 291 |
| `data.desc` | Unlocalized string | `Awarded for extraordinary personal achievement, historically Prussia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 303 |
| `data.desc` | Unlocalized string | `A decoration commemorating victory in a specific military campaign.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 315 |
| `data.desc` | Unlocalized string | `Recognizes efforts in upholding civil law and order.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 327 |
| `data.desc` | Unlocalized string | `Awarded for extensive years of meritorious service in civil duty, first class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 339 |
| `data.desc` | Unlocalized string | `Awarded for many years of meritorious service in civil duty, second class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 351 |
| `data.desc` | Unlocalized string | `Awarded for significant years of service in civil duty, third class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 363 |
| `data.desc` | Unlocalized string | `Given for killing an enemy in hand to hand combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 375 |
| `data.desc` | Unlocalized string | `Awarded for exceptional hand to hand combat achievements.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 387 |
| `data.desc` | Unlocalized string | `Awarded for service on coastal artillery batteries protecting shorelines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 399 |
| `data.desc` | Unlocalized string | `The First Class of the Order of the Rising Sun, awarded to foreign heads of government and leading figures.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 411 |
| `data.desc` | Unlocalized string | `Issued for participation in operations against communist forces.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 423 |
| `data.desc` | Unlocalized string | `Issued for service in the Deutsche Arbeitsfront (German Labour Front).` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 435 |
| `data.desc` | Unlocalized string | `Awarded to pilots or aircrews for extraordinary achievement during flight.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 447 |
| `data.desc` | Unlocalized string | `Recognizes excellent athletic achievement under the German League of the Reich for Physical Exercise.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 459 |
| `data.desc` | Unlocalized string | `Awarded for service on the Eastern Front in harsh winter conditions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 471 |
| `data.desc` | Unlocalized string | `Awarded to crews of fast attack craft (S-Boats) for successful missions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 483 |
| `data.desc` | Unlocalized string | `Likely a British-origin medal recognized for special merits or bravery.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 495 |
| `data.desc` | Unlocalized string | `Recognizes technical and field engineering skill in military operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 507 |
| `data.desc` | Unlocalized string | `Awarded to individuals who have demonstrated unwavering loyalty.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 519 |
| `data.desc` | Unlocalized string | `Awarded after completion of the required jumps and valorous service as a Fallschirmj-ger.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 531 |
| `data.desc` | Unlocalized string | `A pin awarded for membership or achievement in a recognized guild federation.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 543 |
| `data.desc` | Unlocalized string | `Issued for exceptional bravery or service in firefighting or fire protection roles.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 555 |
| `data.desc` | Unlocalized string | `Awarded for devoted service in firefighting duties.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 567 |
| `data.desc` | Unlocalized string | `Indicates the first level of marksmanship proficiency.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 579 |
| `data.desc` | Unlocalized string | `Shoot down an enemy plane with a flak gun.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 591 |
| `data.desc` | Unlocalized string | `Awarded for noteworthy actions using anti-aircraft artillery.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 603 |
| `data.desc` | Unlocalized string | `Given by the Gauleiter to a person for their service to the Gau.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 615 |
| `data.desc` | Unlocalized string | `Awarded for taking part in ground-based attacks as a non-infantry element.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 627 |
| `data.desc` | Unlocalized string | `Issued for service in the occupied territories of Poland under the General Government.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 639 |
| `data.desc` | Unlocalized string | `A combat decoration for repeated acts of bravery or achievement.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 651 |
| `data.desc` | Unlocalized string | `A higher grade awarded for extreme acts of bravery or leadership in combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 663 |
| `data.desc` | Unlocalized string | `An even rarer grade of the German Cross, bestowed for extraordinary distinction.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 675 |
| `data.desc` | Unlocalized string | `A version awarded for notable merit in war effort or non-combat roles.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 687 |
| `data.desc` | Unlocalized string | `A decoration for the highest levels of political and military loyalty.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 699 |
| `data.desc` | Unlocalized string | `A top-level victory decoration for exceptional strategic success.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 711 |
| `data.desc` | Unlocalized string | `Awarded for significant strategic achievements leading to major victories.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 723 |
| `data.desc` | Unlocalized string | `Awarded to DRK Members for their service to the Reich and the Citizens of Berlin.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 735 |
| `data.desc` | Unlocalized string | `A higher class for those providing significant welfare contributions to the Reich.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 747 |
| `data.desc` | Unlocalized string | `A higher grade of the anti-partisan warfare badge for extensive operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 759 |
| `data.desc` | Unlocalized string | `Awarded for being severely or repeatedly wounded in combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 771 |
| `data.desc` | Unlocalized string | `An extremely rare version with diamond additions for utmost distinction.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 783 |
| `data.desc` | Unlocalized string | `A prestigious variant for combat valor.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 795 |
| `data.desc` | Unlocalized string | `Given to NSDAP Members with low membership numbers or awarded by the F-hrer.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 807 |
| `data.desc` | Unlocalized string | `A pin signifying high achievement or leadership within the WRK organization.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 819 |
| `data.desc` | Unlocalized string | `Awarded for outstanding service or achievement benefiting the nation.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 831 |
| `data.desc` | Unlocalized string | `Symbolizes special favor or recognition from imperial authority.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 843 |
| `data.desc` | Unlocalized string | `Highest distinction in the USSR for heroic feats in service to the state.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 855 |
| `data.desc` | Unlocalized string | `Recognizes service on large warships of the Kriegsmarine high seas fleet.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 867 |
| `data.desc` | Unlocalized string | `Awarded to Keiteljugend after passing state examinations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 879 |
| `data.desc` | Unlocalized string | `For members of the Allgemeine-SS who joined prior to 30 January 1933.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 891 |
| `data.desc` | Unlocalized string | `A decorative clasp for those recorded in the Honor Roll of the Wehrmacht.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 903 |
| `data.desc` | Unlocalized string | `Awarded for taking part in an infantry assault against the enemy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 915 |
| `data.desc` | Unlocalized string | `A highly valued medal awarded to the bravest of soldiers.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 927 |
| `data.desc` | Unlocalized string | `A highly valued medal awarded to the bravest of soldiers.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 939 |
| `data.desc` | Unlocalized string | `Awarded for Heroism and Valor in the German Military.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 951 |
| `data.desc` | Unlocalized string | `Awarded for extraordinary heroism in the German Military.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 963 |
| `data.desc` | Unlocalized string | `A highly valued medal awarded to the bravest of soldiers.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 975 |
| `data.desc` | Unlocalized string | `A rare addition awarded for elite heroism.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 987 |
| `data.desc` | Unlocalized string | `An extremely rare highest grade of the Knight` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 999 |
| `data.desc` | Unlocalized string | `An exceptionally high honor for pivotal victories in battle.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1011 |
| `data.desc` | Unlocalized string | `Awarded to youth passing state examinations for the Keiteljugend.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1023 |
| `data.desc` | Unlocalized string | `Issued for acts of bravery in saving a life at imminent risk.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1035 |
| `data.desc` | Unlocalized string | `A Finnish military order for exceptional bravery.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1047 |
| `data.desc` | Unlocalized string | `A ribbon denoting expert level rifle marksmanship.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1059 |
| `data.desc` | Unlocalized string | `A ribbon denoting master-level rifle marksmanship.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1071 |
| `data.desc` | Unlocalized string | `A badge denoting recognized proficiency in marksmanship.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1083 |
| `data.desc` | Unlocalized string | `An emblem of the highest rank in various armies, reserved for Marshals.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1095 |
| `data.desc` | Unlocalized string | `Bestowed upon foreign nationals for acts benefiting the awarding nation.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1107 |
| `data.desc` | Unlocalized string | `Granted for acts of heroism beyond the call of duty.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1119 |
| `data.desc` | Unlocalized string | `Recognizes significant medical service and care under combat conditions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1131 |
| `data.desc` | Unlocalized string | `Awarded to those who have contributed significantly to war support activities.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1143 |
| `data.desc` | Unlocalized string | `For police personnel who have shown distinguished service and bravery.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1155 |
| `data.desc` | Unlocalized string | `A higher grade for continued distinction in police duties.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1167 |
| `data.desc` | Unlocalized string | `Awarded for skillful operation of machine guns in combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1179 |
| `data.desc` | Unlocalized string | `Certification ribbon for expert-level MG42 handling.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1191 |
| `data.desc` | Unlocalized string | `Certification ribbon for master-level MG42 proficiency.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1203 |
| `data.desc` | Unlocalized string | `Awarded for exceptional dedication in military service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1215 |
| `data.desc` | Unlocalized string | `For participation in a recognized military operation or campaign.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1227 |
| `data.desc` | Unlocalized string | `Recognizes 4 years of honorable military service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1239 |
| `data.desc` | Unlocalized string | `Recognizes a dozen years of loyal military service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1251 |
| `data.desc` | Unlocalized string | `Recognizes long-term dedication and service in the military.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1263 |
| `data.desc` | Unlocalized string | `Awarded for exemplary conduct and steadfastness in duty.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1275 |
| `data.desc` | Unlocalized string | `Awarded for service on minesweeping vessels or related operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1287 |
| `data.desc` | Unlocalized string | `Granted by the Ministry of the Interior for 4 years of service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1299 |
| `data.desc` | Unlocalized string | `Recognizes extended service within the Ministry of the Interior.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1311 |
| `data.desc` | Unlocalized string | `Awarded for a dozen years of faithful service in the Ministry of the Interior.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1323 |
| `data.desc` | Unlocalized string | `Acknowledges a quarter century of commitment to the Ministry of the Interior.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1335 |
| `data.desc` | Unlocalized string | `Recognizes proficiency and valor in mortar operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1347 |
| `data.desc` | Unlocalized string | `High state award for mothers bearing and raising numerous children.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1359 |
| `data.desc` | Unlocalized string | `Awarded to a German mother for exceptional merit to the German nation.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1371 |
| `data.desc` | Unlocalized string | `Awarded for outstanding contributions to intelligence operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1383 |
| `data.desc` | Unlocalized string | `For exemplary service benefiting the nation in civil or military spheres.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1395 |
| `data.desc` | Unlocalized string | `A shield-shaped decoration for meritorious contributions to the state.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1407 |
| `data.desc` | Unlocalized string | `Awarded by the Nationaal-Socialistische Beweging for loyal service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1419 |
| `data.desc` | Unlocalized string | `Awarded to Officers and Crew for service on Kriegsmarine destroyers.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1431 |
| `data.desc` | Unlocalized string | `Awarded for frontline service within naval operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1443 |
| `data.desc` | Unlocalized string | `Given to Officers of the Kriegsmarine.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1455 |
| `data.desc` | Unlocalized string | `Recognizes successful completion of an officer training program.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1467 |
| `data.desc` | Unlocalized string | `Given to SS Officers after Graduation.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1479 |
| `data.desc` | Unlocalized string | `Awarded for safeguarding and effectively managing the nation` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1491 |
| `data.desc` | Unlocalized string | `A Soviet award for leadership and heroism in WWII, second class level.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1503 |
| `data.desc` | Unlocalized string | `A Soviet award for leadership and heroism in WWII, third class level.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1515 |
| `data.desc` | Unlocalized string | `A Finnish distinction for civil or military merit.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1527 |
| `data.desc` | Missing key | `Romania` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1539 |
| `data.desc` | Unlocalized string | `A Soviet order awarded to officers for personal bravery and leadership.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1551 |
| `data.desc` | Unlocalized string | `Soviet order for courage in defending the homeland, third class tier.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1563 |
| `data.desc` | Unlocalized string | `A high Soviet military decoration for personal valor, first class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1575 |
| `data.desc` | Unlocalized string | `A Soviet award for notable bravery in combat, second class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1587 |
| `data.desc` | Unlocalized string | `A Soviet award for courage in battle, third class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1599 |
| `data.desc` | Unlocalized string | `The highest civilian decoration bestowed by the Soviet Union.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1611 |
| `data.desc` | Unlocalized string | `A royal or state order awarded for distinguished service to the monarchy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1623 |
| `data.desc` | Unlocalized string | `A dynastic order for loyal service to the House of Baumer.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1635 |
| `data.desc` | Unlocalized string | `A Soviet decoration for bravery in WWII, first class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1647 |
| `data.desc` | Unlocalized string | `A Soviet decoration for brave deeds during WWII, second class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1659 |
| `data.desc` | Unlocalized string | `A Soviet military decoration for heroism in the face of the enemy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1671 |
| `data.desc` | Unlocalized string | `A Soviet honor for great service to the defense of the USSR.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1683 |
| `data.desc` | Unlocalized string | `The highest Soviet military decoration for World War II successes.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1695 |
| `data.desc` | Unlocalized string | `Japanese order awarded for distinguished achievements in international relations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1707 |
| `data.desc` | Unlocalized string | `A Finnish order granted for civic merit and contributions to society.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1719 |
| `data.desc` | Unlocalized string | `Symbolic pin representing the cyclical nature of eternity or unity.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1731 |
| `data.desc` | Unlocalized string | `Served as a panzer crewman with bravery.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1743 |
| `data.desc` | Unlocalized string | `Recognizes key accomplishments within governmental or party roles.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1755 |
| `data.desc` | Unlocalized string | `Recognition for 10 years of service within the Party.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1767 |
| `data.desc` | Unlocalized string | `Recognition for 15 years of service within the Party.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1779 |
| `data.desc` | Unlocalized string | `Recognition for 25 years of service within the Party.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1791 |
| `data.desc` | Unlocalized string | `Ceremonial Award for Service during WW1.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1803 |
| `data.desc` | Unlocalized string | `Awarded to Luftwaffe Pilots for 100 Hours of Flight Service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1815 |
| `data.desc` | Unlocalized string | `Awarded to Luftwaffe Pilots for valorous service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1827 |
| `data.desc` | Unlocalized string | `Awarded for engaging in direct combat while serving in a police capacity.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1839 |
| `data.desc` | Unlocalized string | `Given to members of the Police for long service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1851 |
| `data.desc` | Unlocalized string | `Given to members of the Police for long service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1863 |
| `data.desc` | Unlocalized string | `Issued to police for commendable duration of duty.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1875 |
| `data.desc` | Unlocalized string | `Issued to police who served 25 years with distinction.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1887 |
| `data.desc` | Unlocalized string | `An award from the Pope for religious or humanitarian service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1899 |
| `data.desc` | Unlocalized string | `A papal award for distinguished service to the Church.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1911 |
| `data.desc` | Unlocalized string | `A seldom-seen medal with special significance, possibly Guard Division.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1923 |
| `data.desc` | Unlocalized string | `Awarded to reconnaissance troops for effective scouting operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1935 |
| `data.desc` | Unlocalized string | `For service or acts of mercy under the Red Cross banner.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1947 |
| `data.desc` | Unlocalized string | `Granted for participation in the Second West Russian campaign.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1959 |
| `data.desc` | Unlocalized string | `Awarded for being wounded in combat, second degree.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1971 |
| `data.desc` | Unlocalized string | `Recognizes distinguished service in small unit engagements.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1983 |
| `data.desc` | Unlocalized string | `Acknowledges high skill and confirmed eliminations with a sniper rifle.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 1995 |
| `data.desc` | Unlocalized string | `Recognizes humanitarian or welfare efforts for the state.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2007 |
| `data.desc` | Unlocalized string | `Marks two decades of faithful service in the Soviet military or state.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2019 |
| `data.desc` | Unlocalized string | `Given to Members of the SS for long standing service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2031 |
| `data.desc` | Unlocalized string | `Acknowledges 8 years of consistent and honorable SS service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2043 |
| `data.desc` | Unlocalized string | `Marks 15 years of proven loyalty and service in the SS.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2055 |
| `data.desc` | Unlocalized string | `Celebrates 25 years of unwavering dedication in the SS.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2067 |
| `data.desc` | Unlocalized string | `Awarded to SS Members for Honorable Service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2079 |
| `data.desc` | Unlocalized string | `Given to SS Members after Honorable service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2091 |
| `data.desc` | Unlocalized string | `Awarded to SS members demonstrating especial loyalty and achievement.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2103 |
| `data.desc` | Unlocalized string | `Awarded to SS Members for Honorable Service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2115 |
| `data.desc` | Unlocalized string | `A papal award for a significant contribution to the Church or society.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2127 |
| `data.desc` | Unlocalized string | `A papal order of knighthood for laity or clergy who have served the Church.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2139 |
| `data.desc` | Unlocalized string | `A proposed or commemorative shield for participants in the Battle of Stalingrad.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2151 |
| `data.desc` | Unlocalized string | `Awarded for significant contributions to procurement and supply efforts.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2163 |
| `data.desc` | Unlocalized string | `A higher accolade for procurement excellence, gold class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2175 |
| `data.desc` | Unlocalized string | `Issued for breakthroughs or distinguished contributions in scientific research.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2187 |
| `data.desc` | Unlocalized string | `A premium tier award for exceptional scientific achievements.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2199 |
| `data.desc` | Unlocalized string | `A Swedish order for military merit.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2211 |
| `data.desc` | Unlocalized string | `A higher insignia or breast star of the Order of the Sword.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2223 |
| `data.desc` | Unlocalized string | `Awarded to infantry for destroying a tank in combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2235 |
| `data.desc` | Unlocalized string | `Acknowledges proficiency and bravery as a tank crew member.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2247 |
| `data.desc` | Unlocalized string | `Awarded to Kriegsmarine U-Boat crews for honorable service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2259 |
| `data.desc` | Unlocalized string | `A higher grade clasp for repeated successful U-Boat operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2271 |
| `data.desc` | Unlocalized string | `Awarded for frontline U-Boat service, silver grade.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2283 |
| `data.desc` | Unlocalized string | `A decoration for exemplary service in the war effort involving combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2295 |
| `data.desc` | Unlocalized string | `A decoration for exemplary service in the war effort without direct combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2307 |
| `data.desc` | Unlocalized string | `A higher class for significant contributions to the war effort.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2319 |
| `data.desc` | Unlocalized string | `A higher class for significant contributions involving combat.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2331 |
| `data.desc` | Unlocalized string | `Awarded in recognition of exceptional contributions to the war effort.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2343 |
| `data.desc` | Unlocalized string | `An even rarer grade for extraordinary combat-related war services.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2355 |
| `data.desc` | Unlocalized string | `Recognition of superior strategic planning in major operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2367 |
| `data.desc` | Unlocalized string | `Acknowledges significant planning roles in key military operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2379 |
| `data.desc` | Unlocalized string | `For essential contributions to tactical or strategic planning.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2391 |
| `data.desc` | Unlocalized string | `Given to members of the Wehrmacht for long service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2403 |
| `data.desc` | Unlocalized string | `Shoot down an enemy plane with a flak gun.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2415 |
| `data.desc` | Unlocalized string | `Shoot down an enemy plane with a flak gun, gold level of distinction.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\1942rp.lua | 2427 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 3 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 15 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 27 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 39 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 51 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 63 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 75 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 87 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 99 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 111 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 123 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 135 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 147 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 159 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 171 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 183 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 195 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 207 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 219 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 231 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 243 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 255 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 267 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 279 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 291 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 303 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 315 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 327 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 339 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 351 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 363 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 375 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 387 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 399 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 411 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 423 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 435 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 447 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 459 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 471 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 483 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 495 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 507 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 519 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 531 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 543 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 555 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 567 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 579 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 591 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 603 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 615 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 627 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 639 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 651 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 663 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 675 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 687 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 699 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 711 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 723 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 735 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 747 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 759 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 771 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 783 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 795 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 807 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 819 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 831 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 843 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 855 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 867 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 879 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 891 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 903 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 915 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 927 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 939 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 951 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 963 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 975 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 987 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 999 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1011 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1023 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1035 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1047 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1059 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1071 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1083 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1095 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1107 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1119 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1131 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1143 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1155 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1167 |
| `data.desc` | Unlocalized string | `Given to members of the Wehrmacht for long service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1179 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1191 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1203 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1215 |
| `data.desc` | Unlocalized string | `Given as a medal award.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\kaiser.lua | 1227 |
| `data.desc` | Unlocalized string | `Awarded for attaining Patrol Level 1 in the LAPD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\lapd.lua | 3 |
| `data.desc` | Unlocalized string | `Awarded for attaining Patrol Level 2 in the LAPD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\lapd.lua | 15 |
| `data.desc` | Unlocalized string | `Awarded for attaining Patrol Level 3 in the LAPD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\lapd.lua | 27 |
| `data.desc` | Unlocalized string | `Awarded for reaching Officer Level 2 in the LAPD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\lapd.lua | 39 |
| `data.desc` | Unlocalized string | `Awarded for reaching Officer Level 3 in the LAPD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\lapd.lua | 51 |
| `data.desc` | Unlocalized string | `Awarded for surpassing Officer Level 3 in the LAPD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\lapd.lua | 63 |
| `data.desc` | Unlocalized string | `Awarded for completing LAPD recruit training.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\lapd.lua | 75 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Sergeant in the LAPD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\lapd.lua | 87 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Sergeant 2 in the LAPD.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\lapd.lua | 99 |
| `data.desc` | Unlocalized string | `Medal given to those whom have passed the bar exam.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\legal.lua | 3 |
| `data.desc` | Unlocalized string | `Awarded to those who are in the democratic party` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\legal.lua | 15 |
| `data.desc` | Unlocalized string | `Awarded to those who display excellence whilst acting as a judge` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\legal.lua | 75 |
| `data.desc` | Unlocalized string | `Awarded to those who have made significant contributions to the Republican Party` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\legal.lua | 123 |
| `data.desc` | Unlocalized string | `Awarded to all police officers` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\nypd.lua | 3 |
| `data.desc` | Unlocalized string | `Awarded to those who are in the Detective Division of the NYPD` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\nypd.lua | 39 |
| `data.desc` | Unlocalized string | `Awarded to those who are first responders` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\nypd.lua | 51 |
| `data.desc` | Unlocalized string | `Awarded to those who are in the ESU Division of the NYPD` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\nypd.lua | 63 |
| `data.desc` | Unlocalized string | `Awarded to those who are in the Forensic Division of the NYPD` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\nypd.lua | 111 |
| `data.desc` | Unlocalized string | `Awarded to those who are in the Internal Affairs Division of the NYPD` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\nypd.lua | 147 |
| `data.desc` | Unlocalized string | `Awarded to those who have displayed long and faithful service to the NYPD` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\nypd.lua | 159 |
| `data.desc` | Unlocalized string | `Awarded to officers who have achieved proficiency with a pistol.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\nypd.lua | 207 |
| `data.desc` | Unlocalized string | `Awarded for service during the Second West Russian War.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 3 |
| `data.desc` | Unlocalized string | `Awarded for 20 years of honorable service in the Soviet Armed Forces.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 15 |
| `data.desc` | Unlocalized string | `Awarded to distinguished tank crew members.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 27 |
| `data.desc` | Unlocalized string | `Awarded to skilled artillerymen.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 39 |
| `data.desc` | Unlocalized string | `Awarded to accomplished military engineers.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 51 |
| `data.desc` | Unlocalized string | `The highest honorary title and the premier distinction of the Soviet Union.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 63 |
| `data.desc` | Unlocalized string | `Awarded for exceptional marksmanship.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 75 |
| `data.desc` | Unlocalized string | `Awarded to Marshals of the Soviet Union.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 87 |
| `data.desc` | Unlocalized string | `Awarded for acts of bravery and valor.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 99 |
| `data.desc` | Unlocalized string | `Awarded to distinguished military medics.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 111 |
| `data.desc` | Unlocalized string | `Awarded to skilled machine gunners.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 123 |
| `data.desc` | Unlocalized string | `Awarded to proficient mortar operators.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 135 |
| `data.desc` | Unlocalized string | `Awarded to mothers bearing and raising a large family.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 147 |
| `data.desc` | Unlocalized string | `Awarded to graduates of Soviet military academies.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 159 |
| `data.desc` | Unlocalized string | `Awarded for outstanding command in battle, 2nd class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 171 |
| `data.desc` | Unlocalized string | `Awarded for outstanding command in battle, 3rd class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 183 |
| `data.desc` | Unlocalized string | `Awarded for personal courage and leadership, 3rd class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 195 |
| `data.desc` | Unlocalized string | `Awarded for outstanding command in battle, 3rd class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 207 |
| `data.desc` | Unlocalized string | `Awarded for personal bravery, 1st class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 219 |
| `data.desc` | Unlocalized string | `Awarded for personal bravery, 2nd class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 231 |
| `data.desc` | Unlocalized string | `Awarded for personal bravery, 3rd class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 243 |
| `data.desc` | Unlocalized string | `One of the highest decorations bestowed by the Soviet Union.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 255 |
| `data.desc` | Unlocalized string | `Awarded for heroic deeds during the Great Patriotic War, 1st class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 267 |
| `data.desc` | Unlocalized string | `Awarded for heroic deeds during the Great Patriotic War, 2nd class.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 279 |
| `data.desc` | Unlocalized string | `Awarded for exceptional military valor.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 291 |
| `data.desc` | Unlocalized string | `The highest military decoration awarded for World War II service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 303 |
| `data.desc` | Unlocalized string | `Awarded for distinguished achievements in military service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 315 |
| `data.desc` | Unlocalized string | `Awarded to skilled reconnaissance personnel.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\sovietrp.lua | 327 |
| `data.desc` | Unlocalized string | `An official recognition for noteworthy accomplishments.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 3 |
| `data.desc` | Unlocalized string | `Award for outstanding leadership in the Imperial Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 15 |
| `data.desc` | Unlocalized string | `A high distinction for exemplary service in the Imperial Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 27 |
| `data.desc` | Unlocalized string | `Demonstration of consistent improvement in Army duties.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 39 |
| `data.desc` | Unlocalized string | `Conferred for exceptional effectiveness in combat operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 51 |
| `data.desc` | Unlocalized string | `Certification for fully-trained Imperial Intelligence Agents.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 63 |
| `data.desc` | Unlocalized string | `Certificate awarded to recognized security officers of the Empire.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 75 |
| `data.desc` | Unlocalized string | `Issued by the Commissioner for acts that significantly improve the Empire.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 87 |
| `data.desc` | Unlocalized string | `A high-level distinction within the Commission for the Preservation of the New Order.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 99 |
| `data.desc` | Unlocalized string | `Recognizes continual progress in COMPNOR duties and responsibilities.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 111 |
| `data.desc` | Unlocalized string | `Awarded to official COMPNOR members meeting required obligations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 123 |
| `data.desc` | Unlocalized string | `Given for dedicated service to COMPNOR.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 135 |
| `data.desc` | Unlocalized string | `Distinguished service within a specific Imperial department.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 147 |
| `data.desc` | Unlocalized string | `High-level recognition for consistent, exemplary conduct.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 159 |
| `data.desc` | Unlocalized string | `Indicates multiple awards or further distinction in service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 171 |
| `data.desc` | Unlocalized string | `Recognizes outstanding performance in Imperial training exercises.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 183 |
| `data.desc` | Unlocalized string | `Presented for exemplary discipline and conduct over time.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 195 |
| `data.desc` | Unlocalized string | `Award for meritorious performance in government administration tasks.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 207 |
| `data.desc` | Unlocalized string | `A special cross for significant contributions to Imperial governance.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 219 |
| `data.desc` | Unlocalized string | `Reflects progressive achievements in government roles.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 231 |
| `data.desc` | Unlocalized string | `Completion of the basic curriculum at the Imperial Academy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 243 |
| `data.desc` | Unlocalized string | `Graduation from the Imperial Academy with honors.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 255 |
| `data.desc` | Unlocalized string | `Issued for ongoing and active participation in Imperial forces.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 267 |
| `data.desc` | Unlocalized string | `Granted for consistent and valued activity within the Empire.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 279 |
| `data.desc` | Unlocalized string | `A medal representing heroic or meritorious achievement, bronze tier.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 291 |
| `data.desc` | Unlocalized string | `Bronze Star with device signifying subsequent awards or achievements.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 303 |
| `data.desc` | Unlocalized string | `Signifies involvement in a recognized Imperial campaign.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 315 |
| `data.desc` | Unlocalized string | `Given to those exemplifying the ideals of Imperial citizenship.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 327 |
| `data.desc` | Unlocalized string | `A prestigious cross for acts of gallantry or exemplary service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 339 |
| `data.desc` | Unlocalized string | `Imperial Cross indicating repeated acts of heroism.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 351 |
| `data.desc` | Unlocalized string | `A medal for distinguished heroism or outstanding achievement, gold tier.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 363 |
| `data.desc` | Unlocalized string | `Gold Star with device for multiple outstanding achievements.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 375 |
| `data.desc` | Unlocalized string | `Recognition for commendable performance of duties.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 387 |
| `data.desc` | Unlocalized string | `The highest Imperial decoration for extraordinary heroism.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 399 |
| `data.desc` | Unlocalized string | `Medal of Honor with device signifying repeated extraordinary deeds.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 411 |
| `data.desc` | Unlocalized string | `Issued to members of the Imperial Medical Department for devoted medical service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 423 |
| `data.desc` | Unlocalized string | `Commemorates attendance and contributions in high-level Imperial meetings.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 435 |
| `data.desc` | Unlocalized string | `For those recognized for distinguished contributions during Imperial meetings.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 447 |
| `data.desc` | Unlocalized string | `Award for consistent involvement and performance over a full Imperial month.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 459 |
| `data.desc` | Unlocalized string | `Issued for successful efforts in recruiting new members into Imperial ranks.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 471 |
| `data.desc` | Unlocalized string | `Conferred for sustained honorable service in the Empire.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 483 |
| `data.desc` | Unlocalized string | `A medal representing heroic or meritorious achievement, silver tier.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 495 |
| `data.desc` | Unlocalized string | `Silver Star with device for repeated recognized achievements.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 507 |
| `data.desc` | Unlocalized string | `Highest recognition for a major victory in Imperial operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 519 |
| `data.desc` | Unlocalized string | `A cross recognizing major achievements crucial to Imperial security.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 531 |
| `data.desc` | Unlocalized string | `Indicates ongoing accomplishments in Imperial Intelligence roles.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 543 |
| `data.desc` | Unlocalized string | `For honorable and effective service within Imperial Intelligence.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 555 |
| `data.desc` | Unlocalized string | `Official recognition highlighting noteworthy performance.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 567 |
| `data.desc` | Unlocalized string | `A general commendation for demonstrating significant merit within the Empire.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 579 |
| `data.desc` | Unlocalized string | `For outstanding support roles or logistical contributions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 591 |
| `data.desc` | Unlocalized string | `Awarded for acts of courage and bravery in dangerous situations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 603 |
| `data.desc` | Unlocalized string | `Cited in official reports for meritorious or gallant service.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 615 |
| `data.desc` | Unlocalized string | `Represents consistent advancement in naval duties and responsibilities.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 627 |
| `data.desc` | Unlocalized string | `Awarded to naval officers for exemplary command leadership.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 639 |
| `data.desc` | Unlocalized string | `One of the highest Imperial Navy decorations for extraordinary heroism.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 651 |
| `data.desc` | Unlocalized string | `An elite decoration for special operations or stealth missions.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 663 |
| `data.desc` | Unlocalized string | `A device denoting repeated successes in special or covert operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 675 |
| `data.desc` | Unlocalized string | `A medal acknowledging critical success in major operations.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 687 |
| `data.desc` | Unlocalized string | `A revered order symbolizing the Emperor` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 699 |
| `data.desc` | Unlocalized string | `An order signifying the Imperial Seal, demonstrating high-level recognition.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 711 |
| `data.desc` | Unlocalized string | `Recognition for individuals officially accepted into the Sith Order.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 723 |
| `data.desc` | Unlocalized string | `Awarded for significant acts of power, cunning, or service within the Sith realm.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 735 |
| `data.desc` | Unlocalized string | `Demonstrates continued growth and dedication within the Sith Order.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 747 |
| `data.desc` | Unlocalized string | `Awarded for loyal service to the Sith cause and leadership.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\starwarsrp.lua | 759 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Airman Basic in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 3 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Airman in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 15 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Airman First Class in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 27 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Senior Airman in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 39 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Staff Sergeant in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 51 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Technical Sergeant in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 63 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Master Sergeant in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 75 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Master Sergeant in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 87 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Senior Master Sergeant in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 99 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Senior Master Sergeant in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 111 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Master Sergeant in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 123 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Master Sergeant in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 135 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Command Chief Master Sergeant in the United States Air Force.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usair.lua | 147 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Private in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 3 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Private First Class in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 15 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Specialist in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 27 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Corporal in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 39 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Sergeant in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 51 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Staff Sergeant in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 63 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Sergeant First Class in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 75 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Master Sergeant in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 87 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of First Sergeant in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 99 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Sergeant Major in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 111 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Command Sergeant Major in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 123 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Sergeant Major in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 135 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Warrant Officer 1 in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 147 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Warrant Officer 2 in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 159 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Warrant Officer 3 in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 171 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Warrant Officer 4 in the United States Army.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usarmy.lua | 183 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Private First Class in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 3 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Lance Corporal in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 15 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Corporal in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 27 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Sergeant in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 39 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Staff Sergeant in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 51 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Gunnery Sergeant in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 63 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Master Sergeant in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 75 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of First Sergeant in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 87 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Master Gunnery Sergeant in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 99 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Sergeant Major in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 111 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Sergeant Major in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 123 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Warrant Officer in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 135 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Warrant Officer 2 in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 147 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Warrant Officer 3 in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 159 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Warrant Officer 4 in the United States Marines.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usmar.lua | 171 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Seaman Recruit in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 3 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Seaman Apprentice in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 15 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Seaman in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 27 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Petty Officer Third Class in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 39 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Petty Officer Second Class in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 51 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Petty Officer First Class in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 63 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Petty Officer in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 75 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Senior Chief Petty Officer in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 87 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Master Chief Petty Officer in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 99 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Master Chief Petty Officer in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 111 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Master Chief Petty Officer in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 123 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Warrant Officer in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 135 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Warrant Officer 2 in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 147 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Warrant Officer 3 in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 159 |
| `data.desc` | Unlocalized string | `Awarded for attaining the rank of Chief Warrant Officer 4 in the United States Navy.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\medals\usnavy.lua | 171 |
| `data.desc` | Unlocalized string | `A comprehensive medal award and display system featuring multiple themed medal packs (1942 RP, US Military branches, Police departments, Star Wars RP), persistent character-based medal storage with rarity tiers (Common, Uncommon, Rare, Exceptionally Rare), staff permissions for medal management, wearable medal slots (up to 5 medals), character profile integration, and admin controls for giving/taking medals with full network synchronization` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\module.lua | 9 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 6
- **Used Net Messages:** 6
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Used But Undefined

None

### Module-Specific Registration Issues

- **Module-Specific But Registered Outside Module:** 0
- **Module-Specific Used But Undefined:** 0

- Note: A message is treated as module-specific when all detected literal usage sites belong to one module.
- Note: Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.

#### Module-Specific But Registered Outside Module

None

#### Module-Specific Used But Undefined

None

### Direction / Flow Issues

Total suspicious patterns: **4**

- `liaAllMedalsData`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:235; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:245; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:297; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:301
  - Receiver sites: None
- `liaGiveMedalToPlayer`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:307
- `liaRequestAllMedals`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:227
- `liaTakeMedalFromPlayer`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:327

---

## Derma Panel Analysis

### Summary
- **Registered Panels:** 0
- **Referenced Panels:** 108
- **Module Panels Outside derma:** 0
- **Registered But Unused:** 0

### Module Panels Outside derma

None

### Registered But Unused Panels

None

---

## Module File Placement Analysis

### Summary
- **Net Handlers Outside netcalls:** 5
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `medals` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/client.lua:697` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\netcalls` | Module net handler is outside the netcalls folder |
| `medals` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:119` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\netcalls` | Module net handler is outside the netcalls folder |
| `medals` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:227` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\netcalls` | Module net handler is outside the netcalls folder |
| `medals` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:307` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\netcalls` | Module net handler is outside the netcalls folder |
| `medals` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/medals/libraries/server.lua:327` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals`

### Module Documentation Report

- **Undocumented Hooks:**
  - `MedalsDataUpdated()`
  - `PlayerCanGiveMedals()`
  - `PlayerCanTakeMedals()`
  - `PlayerMedalsChanged()`

- **Undocumented lia.* Functions:**
  - `lia.medals.getAll()`
  - `lia.medals.getCharacterMedals()`
  - `lia.medals.getIconPath()`
  - `lia.medals.getIconURL()`
  - `lia.medals.registerMedal()`

- **Undocumented Meta Functions:**
  - `playerMeta:canGiveMedals()`
  - `playerMeta:canTakeMedals()`
  - `playerMeta:giveMedal()`
  - `playerMeta:giveMedalWorn()`
  - `playerMeta:medalsID()`
  - `playerMeta:takeMedal()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\medals | 4 | 5 | 6 |

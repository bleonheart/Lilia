## Executive Summary

### Function Documentation
- **Total Functions:** 9
- **Documented:** 0 (0.0%)
- **Missing Functions:** 9 unique (9 total occurrences)
  - **Library Functions:** 9
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 0 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 0

### Localization Analysis
- **Undefined Calls:** 0 unique
- **@xxxxx Patterns:** 0 unique
- **Module Key Conflicts:** 0 keys
- **Argument Mismatches:** 0

### Net Message Analysis
- **Defined Net Messages:** 0
- **Used Net Messages:** 0
- **Defined But Unused:** 0
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 26

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 9 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 9 functions

#### lia.armors
Count: 9 functions

- `lia.armors.equipArmor()`
- `lia.armors.getEquippedArmorData()`
- `lia.armors.getInstalledMods()`
- `lia.armors.getModBonuses()`
- `lia.armors.refreshArmorEffects()`
- `lia.armors.registerArmor()`
- `lia.armors.registerMod()`
- `lia.armors.resolvePlayerModel()`
- `lia.armors.unequipArmor()`

## Hooks Documentation Analysis

_No hooks analysis data available._

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
| `ITEM.desc` | Unlocalized string | `If you have this then you shouldn` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\items\base\armor.lua | 2 |
| `ITEM.desc` | Unlocalized string | `Base item for armor modification modules.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\items\base\mod.lua | 2 |
| `ITEM.name` | Unlocalized string | `Armor Base` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\items\base\armor.lua | 1 |
| `ITEM.name` | Unlocalized string | `Armor Mod Base` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\items\base\mod.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Adds fantasy-themed armors with equippable protection stats, overlays, optional training requirements, and mod support. Features: damage resistance, movement/jump bonuses, fall protection, footstep sounds, armor mod installation/removal, and admin toggletraining command.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\module.lua | 8 |
| `MODULE.name` | Missing key | `Fantasyarmors` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\module.lua | 6 |
| `data.category` | Missing key | `Armor` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\items\base\armor.lua | 6 |
| `data.category` | Unlocalized string | `Armor Mods` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\items\base\mod.lua | 6 |
| `data.category` | Unlocalized string | `Armor Mods` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\libraries\shared.lua | 62 |
| `data.category` | Unlocalized string | `Armor Mods` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\libraries\shared.lua | 108 |
| `data.desc` | Unlocalized string | `Heavy combat armor worn by Combine Elite soldiers, providing superior protection` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\armors.lua | 3 |
| `data.desc` | Unlocalized string | `Standard issue armor worn by Civil Protection officers` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\armors.lua | 18 |
| `data.desc` | Unlocalized string | `Light combat gear used by resistance fighters` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\armors.lua | 33 |
| `data.desc` | Unlocalized string | `Standard combat armor worn by Combine soldiers` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\armors.lua | 48 |
| `data.desc` | Unlocalized string | `Basic protective clothing for civilian males` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\armors.lua | 63 |
| `data.desc` | Unlocalized string | `Basic protective clothing for civilian females` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\armors.lua | 78 |
| `data.desc` | Unlocalized string | `If you have this then you shouldn` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\items\base\armor.lua | 2 |
| `data.desc` | Unlocalized string | `Base item for armor modification modules.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\items\base\mod.lua | 2 |
| `data.desc` | Unlocalized string | `Grant or revoke armor training for a player.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\libraries\client.lua | 19 |
| `data.desc` | Unlocalized string | `Grant or revoke armor training for a player.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\libraries\server.lua | 275 |
| `data.desc` | Unlocalized string | `Increases physical damage resistance.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\mods.lua | 4 |
| `data.desc` | Unlocalized string | `Increases magical damage resistance.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\mods.lua | 14 |
| `data.desc` | Unlocalized string | `Grants health regeneration.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\mods.lua | 24 |
| `data.desc` | Unlocalized string | `Increases movement speed.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\mods.lua | 34 |
| `data.desc` | Unlocalized string | `Increases damage dealt.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\mods.lua | 44 |
| `data.desc` | Unlocalized string | `Adds fantasy-themed armors with equippable protection stats, overlays, optional training requirements, and mod support. Features: damage resistance, movement/jump bonuses, fall protection, footstep sounds, armor mod installation/removal, and admin toggletraining command.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors\module.lua | 8 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

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
- **Net Handlers Outside netcalls:** 0
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

None

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.armors.equipArmor()`
  - `lia.armors.getEquippedArmorData()`
  - `lia.armors.getInstalledMods()`
  - `lia.armors.getModBonuses()`
  - `lia.armors.refreshArmorEffects()`
  - `lia.armors.registerArmor()`
  - `lia.armors.registerMod()`
  - `lia.armors.resolvePlayerModel()`
  - `lia.armors.unequipArmor()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\fantasyarmors | 0 | 9 | 0 |

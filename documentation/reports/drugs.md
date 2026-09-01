## Executive Summary

### Function Documentation
- **Total Functions:** 22
- **Documented:** 0 (0.0%)
- **Missing Functions:** 22 unique (22 total occurrences)
  - **Library Functions:** 22
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
- **Defined Net Messages:** 3
- **Used Net Messages:** 0
- **Defined But Unused:** 3
- **Used But Undefined:** 0

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 47

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 22 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 22 functions

#### lia.drugs
Count: 22 functions

- `lia.drugs.applyDrugEffect()`
- `lia.drugs.clearPlayerDrugEffects()`
- `lia.drugs.collectDrug()`
- `lia.drugs.formatTimeRemaining()`
- `lia.drugs.getActiveDrugEffectInfo()`
- `lia.drugs.getActiveMultiplier()`
- `lia.drugs.getClientMultiplier()`
- `lia.drugs.getEffectDisplayName()`
- `lia.drugs.handleDrugOverdose()`
- `lia.drugs.hasActiveDrugEffect()`
- `lia.drugs.isEffectExpiringSoon()`
- `lia.drugs.isPlayerProducingDrugs()`
- `lia.drugs.processDrug()`
- `lia.drugs.recalcRunSpeed()`
- `lia.drugs.resetAllDrugItems()`
- `lia.drugs.resetDrugProcessors()`
- `lia.drugs.resetPlantedPlants()`
- `lia.drugs.setupBasicUtilityFunctionality()`
- `lia.drugs.setupDrugProcessorFunctionality()`
- `lia.drugs.setupFilledSoilFunctionality()`
- `lia.drugs.setupPotFunctionality()`
- `lia.drugs.startOrRefreshGrowthTimer()`

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
| `ITEM.desc` | Unlocalized string | `A consumable drug.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\items\base\drugs.lua | 2 |
| `ITEM.desc` | Unlocalized string | `A growing` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\libraries\shared.lua | 103 |
| `ITEM.name` | Missing key | `Drug` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\items\base\drugs.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Complete drug economy and gameplay system featuring cultivation (weed planting with growth phases), processing (drug processor machines), consumption with various effects (speed boost, damage reduction, stamina regeneration, melee speed, needs decay reduction, ragdoll recovery), overdose mechanics with configurable chances, addiction system, visual effects HUD, and administrative controls. Includes 6 drug types: Cocaine, Heroin, Weed, Meth, LSD, and MDMA, each with unique properties and processing requirements.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\module.lua | 4 |
| `MODULE.name` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\module.lua | 2 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\module.lua | 10 |
| `Privilege.Name` | Unlocalized string | `Can See Drug Overdose` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\module.lua | 8 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 116 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 124 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 132 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 140 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 147 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 154 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 161 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 170 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 179 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 186 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\libraries\shared.lua | 45 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\libraries\shared.lua | 54 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\libraries\shared.lua | 64 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\libraries\shared.lua | 71 |
| `data.category` | Missing key | `Drugs` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\libraries\shared.lua | 107 |
| `data.desc` | Unlocalized string | `+35% running speed.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 7 |
| `data.desc` | Unlocalized string | `Temporary 75% damage reduction.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 20 |
| `data.desc` | Unlocalized string | `Hunger and thirst decay 50% slower.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 33 |
| `data.desc` | Unlocalized string | `+40% melee attack speed.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 46 |
| `data.desc` | Unlocalized string | `Ragdoll recovery 25% faster.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 59 |
| `data.desc` | Unlocalized string | `+30% stamina regeneration.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 72 |
| `data.desc` | Unlocalized string | `A bag of nutrient-rich soil perfect for growing plants.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 112 |
| `data.desc` | Unlocalized string | `A pot filled with nutrient-rich soil, ready for planting seeds.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 120 |
| `data.desc` | Unlocalized string | `An empty pot ready for planting.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 128 |
| `data.desc` | Unlocalized string | `A machine for processing unprocessed drugs into their final form.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 136 |
| `data.desc` | Unlocalized string | `Enable drug overdose system` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 149 |
| `data.desc` | Unlocalized string | `Show drug effects HUD` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 156 |
| `data.desc` | Unlocalized string | `Time before drug effects become warning (seconds)` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 165 |
| `data.desc` | Unlocalized string | `Time before drug effects become critical (seconds)` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 174 |
| `data.desc` | Unlocalized string | `Prevent multiple drug production at once` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 181 |
| `data.desc` | Unlocalized string | `Enable drug effect stacking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 188 |
| `data.desc` | Unlocalized string | `A consumable drug.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\items\base\drugs.lua | 2 |
| `data.desc` | Unlocalized string | `A growing` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\libraries\shared.lua | 103 |
| `data.desc` | Unlocalized string | `Complete drug economy and gameplay system featuring cultivation (weed planting with growth phases), processing (drug processor machines), consumption with various effects (speed boost, damage reduction, stamina regeneration, melee speed, needs decay reduction, ragdoll recovery), overdose mechanics with configurable chances, addiction system, visual effects HUD, and administrative controls. Includes 6 drug types: Cocaine, Heroin, Weed, Meth, LSD, and MDMA, each with unique properties and processing requirements.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\module.lua | 4 |
| `lia.config.add:name` | Unlocalized string | `Enable Drug Overdose` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 146 |
| `lia.config.add:name` | Unlocalized string | `Show Drug Effects HUD` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 153 |
| `lia.config.add:name` | Unlocalized string | `Drug Effect Warning Time` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 160 |
| `lia.config.add:name` | Unlocalized string | `Drug Effect Critical Time` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 169 |
| `lia.config.add:name` | Unlocalized string | `Prevent Multiple Drug Production` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 178 |
| `lia.config.add:name` | Unlocalized string | `Enable Effect Stacking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs\config\shared.lua | 185 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 3
- **Used Net Messages:** 0
- **Defined But Unused:** 3
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

Total suspicious patterns: **0**

None

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

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs`

### Module Documentation Report

- **Undocumented lia.* Functions:**
  - `lia.drugs.applyDrugEffect()`
  - `lia.drugs.clearPlayerDrugEffects()`
  - `lia.drugs.collectDrug()`
  - `lia.drugs.formatTimeRemaining()`
  - `lia.drugs.getActiveDrugEffectInfo()`
  - `lia.drugs.getActiveMultiplier()`
  - `lia.drugs.getClientMultiplier()`
  - `lia.drugs.getEffectDisplayName()`
  - `lia.drugs.handleDrugOverdose()`
  - `lia.drugs.hasActiveDrugEffect()`
  - `lia.drugs.isEffectExpiringSoon()`
  - `lia.drugs.isPlayerProducingDrugs()`
  - `lia.drugs.processDrug()`
  - `lia.drugs.recalcRunSpeed()`
  - `lia.drugs.resetAllDrugItems()`
  - `lia.drugs.resetDrugProcessors()`
  - `lia.drugs.resetPlantedPlants()`
  - `lia.drugs.setupBasicUtilityFunctionality()`
  - `lia.drugs.setupDrugProcessorFunctionality()`
  - `lia.drugs.setupFilledSoilFunctionality()`
  - `lia.drugs.setupPotFunctionality()`
  - `lia.drugs.startOrRefreshGrowthTimer()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\drugs | 0 | 22 | 0 |

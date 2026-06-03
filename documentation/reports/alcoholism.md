## Executive Summary

### Function Documentation
- **Total Functions:** 0
- **Documented:** N/A
- **Missing Functions:** 0 unique (0 total occurrences)
  - **Library Functions:** 0
  - **Hook Functions:** 0
  - **Meta Functions:** 0

### Hooks Documentation
- **Missing Hooks:** 1 (used but undocumented)
- **Unused Hooks:** 0 (documented but unused)
- **Total Documented Hooks:** 0
- **Total Registered Hooks:** 1

### Localization Analysis
- **Undefined Calls:** 2 unique
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
- **Undefined Inferred Localization Keys:** 217

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 0 unique functions

## Hooks Documentation Analysis

### Summary
- **Missing Hooks:** 1 (used in code but not documented)
- **Documented Hooks:** 0
- **Registered Hooks:** 1
- **Unused Hooks:** 0 (documented but not registered)

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `AddTextField()`

## Localization Analysis

- **Unique Keys:** 36
- **Undefined Calls:** 2
- **Argument Mismatch:** 0

### Undefined Calls

- **liliaplayer** in module.lua:4
  - Context: MODULE.discord = "@liliaplayer"
- **generalinfo** in libraries\client.lua:8
  - Context: hook.Run("AddTextField", L("generalinfo"), "drunkness", L("drunkness"), function() return LocalPlayer():getLocalVar("bac", 0) .. "%" end)

### Argument Mismatches

- **Total Mismatches:** 0

### Undefined or Unlocalized Inferred Localization Values

These string literals are stored in localization-by-convention fields (e.g. `ITEM.name`, `lia.config.add` name arg, `lia.option.add` name/desc) and either reference a missing language key or use plain unlocalized text.

| Field | Issue | Value | File | Line |
|---|---|---|---|---:|
| `ITEM.name` | Unlocalized string | `Alcohol Base` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\items\base\alcohol.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Adds drinkable alcohol that increases a player` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\module.lua | 6 |
| `MODULE.name` | Missing key | `Alcoholism` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\module.lua | 1 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\items\base\alcohol.lua | 6 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 8 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 18 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 28 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 38 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 48 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 58 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 68 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 78 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 88 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 98 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 108 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 118 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 128 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 138 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 148 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 158 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 168 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 178 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 188 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 198 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 208 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 218 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 228 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 238 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 248 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 258 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 268 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 278 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 288 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 298 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 308 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 318 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 328 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 338 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 348 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 358 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 368 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 378 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 388 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 398 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 408 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 418 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 428 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 438 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 448 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 458 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 468 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 478 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 488 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 498 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 508 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 518 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 528 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 538 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 548 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 558 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 568 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 578 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 588 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 598 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 608 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 618 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 628 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 638 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 648 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 658 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 668 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 678 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 688 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 698 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 708 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 718 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 728 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 738 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 748 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 758 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 768 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 778 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 788 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 798 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 808 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 818 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 828 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 838 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 848 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 858 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 868 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 878 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 888 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 898 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 908 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 918 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 928 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 938 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 948 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 958 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 968 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 978 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 988 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 998 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1008 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1018 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1028 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1038 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1048 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1058 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1068 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1078 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1088 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1098 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1108 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1118 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1128 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1138 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1148 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1158 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1168 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1178 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1188 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1198 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1208 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1218 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1228 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1238 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1248 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1258 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1268 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1278 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1288 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1298 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1308 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1318 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1328 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1338 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1348 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1358 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1368 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1378 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1388 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1398 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1408 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1418 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1428 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1438 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1448 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1458 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1468 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1478 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1488 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1498 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1508 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1518 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1528 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1538 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1548 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1558 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1568 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1578 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1588 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1598 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1608 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1618 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1628 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1638 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1648 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1658 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1668 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1678 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1688 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1698 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1708 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1718 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1728 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1738 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1748 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1758 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1768 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1778 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1788 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1798 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1808 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1818 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1828 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1838 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1848 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1858 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1868 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1878 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1888 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1898 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1908 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1918 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1928 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1938 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1948 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1958 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1968 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1978 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1988 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 1998 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2008 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2018 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2028 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2038 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2048 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2058 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2068 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2078 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2088 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2098 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2108 |
| `data.category` | Missing key | `Alcohol` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\libraries\shared.lua | 2118 |
| `data.desc` | Unlocalized string | `Adds drinkable alcohol that increases a player` | D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism\module.lua | 6 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

_No net-message analysis data available._

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism`

### Module Documentation Report

- **Undocumented Hooks:**
  - `AddTextField()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions |
|---|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\metrorp\gitmodules\alcoholism | 1 | 0 |

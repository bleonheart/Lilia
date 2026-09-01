## Executive Summary

### Function Documentation
- **Total Functions:** 30
- **Documented:** 0 (0.0%)
- **Missing Functions:** 30 unique (30 total occurrences)
  - **Library Functions:** 30
  - **Hook Functions:** 0
  - **Meta Functions:** 0

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
- **Defined Net Messages:** 65
- **Used Net Messages:** 63
- **Defined But Unused:** 4
- **Used But Undefined:** 2

### Config Analysis
- **Undefined lia.config.get Keys:** 0
- **Undefined Inferred Localization Keys:** 30

---

## Function Documentation Analysis

### Summary
- **Files Analyzed:** 1
- **Missing Documentation:** 30 unique functions

### Unused in Lilia, Used in lilia_rp
Total: 0 functions

_No cross-gamemode usage detected._

### Missing Library Functions
Total: 30 functions

#### lia.banking
Count: 30 functions

- `lia.banking.AddBankLog()`
- `lia.banking.canCreateAccount()`
- `lia.banking.getNextAccountType()`
- `lia.banking.getRegisteredActions()`
- `lia.banking.openAdminPanel()`
- `lia.banking.openCheckViewer()`
- `lia.banking.openItemBankCL()`
- `lia.banking.openManageMembers()`
- `lia.banking.receiveBankBalance()`
- `lia.banking.refreshBankingUI()`
- `lia.banking.registerAction()`
- `lia.banking.registerCheck()`
- `lia.banking.sendCheck()`
- `lia.banking.showAdminAccountDetails()`
- `lia.banking.showAdminDeleteAccountDialog()`
- `lia.banking.showDeleteAccountDialog()`
- `lia.banking.showMemberPermissions()`
- `lia.banking.showMemberPermissionsDialog()`
- `lia.banking.showPaycheckDepositDialog()`
- `lia.banking.showRedeemCheckDialog()`
- `lia.banking.showRemoveMemberDialog()`
- `lia.banking.showRenameDialog()`
- `lia.banking.showRequestSubPanel()`
- `lia.banking.showTransactionHistory()`
- `lia.banking.showTransferDialog()`
- `lia.banking.showTransferSubPanel()`
- `lia.banking.showViewRequests()`
- `lia.banking.showWithdrawDialog()`
- `lia.banking.viewBankAccountAsAdmin()`
- `lia.banking.writeCheck()`

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
- `BankingAddAccountButtons`
  - module `banking` [standard] in `libraries/client.lua`
- `BankingAddOptions`
  - module `banking` [standard] in `libraries/client.lua`
- `BankingLogEntry`
  - module `banking` [standard] in `libraries/server.lua`
- `BankingPreATMOpen`
  - module `banking` [standard] in `libraries/client.lua`

### Missing Hook Documentation:
These hooks are registered in code but missing from documentation:
- `BankingAddAccountButtons()`
- `BankingAddOptions()`
- `BankingLogEntry()`
- `BankingPreATMOpen()`

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
| `ITEM.desc` | Unlocalized string | `A paper check that can be written and redeemed at an ATM.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\items\base\bankcheck.lua | 2 |
| `ITEM.name` | Unlocalized string | `Bank Check` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\items\base\bankcheck.lua | 1 |
| `MODULE.desc` | Unlocalized string | `Comprehensive banking infrastructure featuring multi-tier account management (free, premium, VIP), physical ATM network with model customization, secure check writing and redemption system, item storage vaults with tiered capacity, automated interest accrual with configurable rates and limits, paycheck integration with direct deposit options, administrative oversight tools for account monitoring and management, faction-based transaction controls, and robust permission system for member access management across joint accounts` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 36 |
| `MODULE.name` | Missing key | `Banking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 34 |
| `Privilege.Category` | Missing key | `Lilia` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\entities\entities\lia_atm\shared.lua | 6 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 42 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 47 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 52 |
| `Privilege.Category` | Missing key | `categoryStaffManagement` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 57 |
| `Privilege.Name` | Unlocalized string | `Banking Admin Access` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 40 |
| `Privilege.Name` | Unlocalized string | `View Bank Account as Admin` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 45 |
| `Privilege.Name` | Unlocalized string | `Override Check Faction Restrictions` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 50 |
| `Privilege.Name` | Unlocalized string | `VIP Banking Access` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 55 |
| `data.category` | Missing key | `Banking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\items\base\bankcheck.lua | 3 |
| `data.category` | Missing key | `banking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\client.lua | 3721 |
| `data.category` | Unlocalized string | `Bank Checks` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\shared.lua | 23 |
| `data.category` | Missing key | `Banking` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\pim.lua | 3 |
| `data.desc` | Unlocalized string | `A paper check that can be written and redeemed at an ATM.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\items\base\bankcheck.lua | 2 |
| `data.desc` | Unlocalized string | `Allows depositing money into the account` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\client.lua | 3132 |
| `data.desc` | Unlocalized string | `Allows withdrawing money from the account` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\client.lua | 3137 |
| `data.desc` | Unlocalized string | `Allows transferring money between accounts` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\client.lua | 3142 |
| `data.desc` | Unlocalized string | `Allows viewing items stored in the item bank` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\client.lua | 3147 |
| `data.desc` | Unlocalized string | `Allows taking items out of the item bank` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\client.lua | 3152 |
| `data.desc` | Unlocalized string | `Allows putting items into the item bank` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\client.lua | 3157 |
| `data.desc` | Unlocalized string | `Allows managing other members` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\client.lua | 3162 |
| `data.desc` | Unlocalized string | `Allows adding new members to the account` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\client.lua | 3167 |
| `data.desc` | Unlocalized string | `Allows removing members from the account` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\client.lua | 3172 |
| `data.desc` | Unlocalized string | `A paper check that can be written and redeemed at an ATM.` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\libraries\shared.lua | 43 |
| `data.desc` | Unlocalized string | `Comprehensive banking infrastructure featuring multi-tier account management (free, premium, VIP), physical ATM network with model customization, secure check writing and redemption system, item storage vaults with tiered capacity, automated interest accrual with configurable rates and limits, paycheck integration with direct deposit options, administrative oversight tools for account monitoring and management, faction-based transaction controls, and robust permission system for member access management across joint accounts` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\module.lua | 36 |
| `entity.contact` | Missing key | `liliaplayer` | D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\entities\entities\lia_atm\shared.lua | 5 |

## Language File Comparison

_No language comparison data available._

## Net Message Analysis

### Summary
- **Defined Net Messages:** 65
- **Used Net Messages:** 63
- **Defined But Unused:** 4
- **Used But Undefined:** 2

### Used But Undefined

- `liaBankingTransferMoney`
  - Used at: net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:371
- `liaBankingValidateAccount`
  - Used at: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:59; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:63; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:46

### Module-Specific Registration Issues

- **Module-Specific But Registered Outside Module:** 0
- **Module-Specific Used But Undefined:** 2

- Note: A message is treated as module-specific when all detected literal usage sites belong to one module.
- Note: Valid in-module registrations include literal `MODULE.NetworkStrings`, `SCHEMA.NetworkStrings`, and `util.AddNetworkString(...)` sites inside that module root.

#### Module-Specific But Registered Outside Module

None

#### Module-Specific Used But Undefined

- `liaBankingTransferMoney` in module `banking`
  - Reason: Used only by module "banking" and not defined anywhere
  - Usage sites: net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:371
- `liaBankingValidateAccount` in module `banking`
  - Reason: Used only by module "banking" and not defined anywhere
  - Usage sites: net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:59; net.Start at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:63; net.Receive at D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:46

### Direction / Flow Issues

Total suspicious patterns: **16**

- `liaBankingAdminTestDeposit`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2945
- `liaBankingAdminTestReceive`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:3037
- `liaBankingAdminTestRequest`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:3013
- `liaBankingAdminTestWithdraw`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2979
- `liaBankingConfigUpdate`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2514
- `liaBankingGetAccountDetails`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2379
- `liaBankingOpenBankerUI`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: client
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1722
- `liaBankingReceiveAccountName`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1296; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1300
  - Receiver sites: None
- `liaBankingReceiveMemberPermissions`
  - Reason: Message has senders but no detected receivers
  - Send sides: server
  - Receive sides: none
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1256
  - Receiver sites: None
- `liaBankingRedeemCheckAtATM`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1650
- `liaBankingRequestConfig`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2462
- `liaBankingRequestMemberPermissions`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1223
- `liaBankingRetrievePaycheck`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:517
- `liaBankingTransferMoney`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:371
- `liaBankingUpdateMember`
  - Reason: Message has receivers but no detected senders
  - Send sides: none
  - Receive sides: server
  - Sender sites: None
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1125
- `liaBankingValidateAccount`
  - Reason: Message appears to send and receive only on the server side
  - Send sides: server
  - Receive sides: server
  - Sender sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:59; D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:63
  - Receiver sites: D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:46

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
- **Net Handlers Outside netcalls:** 61
- **UI / Derma Code Outside derma:** 0

### Net Handlers Outside netcalls

| Module | Location | Expected Folder | Reason |
|---|---|---|---|
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:771` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:776` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:854` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1063` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1191` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1691` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1722` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1727` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1840` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1845` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:1929` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:2528` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:2544` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:2559` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:3528` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:3533` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:3547` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/client.lua:3782` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:39` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:46` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:69` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:169` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:245` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:371` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:469` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:517` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:536` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:654` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:977` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:985` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1019` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1125` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1178` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1223` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1263` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1284` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1306` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1351` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1403` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1650` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1691` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1771` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1820` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:1866` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2056` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2080` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2121` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2379` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2462` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2463` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2514` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2557` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2616` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2672` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2719` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2811` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2843` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2945` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:2979` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:3013` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |
| `banking` | `D:/GMOD/Server/garrysmod/gamemodes/lilia_rp/modules/done/banking/libraries/server.lua:3037` | `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking\netcalls` | Module net handler is outside the netcalls folder |

### UI / Derma Code Outside derma

None

---

## Config: Undefined lia.config.get Keys

_No undefined `lia.config.get` calls detected._

---

# Sam's Modules

---

## Module: `D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking`

### Module Documentation Report

- **Undocumented Hooks:**
  - `BankingAddAccountButtons()`
  - `BankingAddOptions()`
  - `BankingLogEntry()`
  - `BankingPreATMOpen()`

- **Undocumented lia.* Functions:**
  - `lia.banking.AddBankLog()`
  - `lia.banking.canCreateAccount()`
  - `lia.banking.getNextAccountType()`
  - `lia.banking.getRegisteredActions()`
  - `lia.banking.openAdminPanel()`
  - `lia.banking.openCheckViewer()`
  - `lia.banking.openItemBankCL()`
  - `lia.banking.openManageMembers()`
  - `lia.banking.receiveBankBalance()`
  - `lia.banking.refreshBankingUI()`
  - `lia.banking.registerAction()`
  - `lia.banking.registerCheck()`
  - `lia.banking.sendCheck()`
  - `lia.banking.showAdminAccountDetails()`
  - `lia.banking.showAdminDeleteAccountDialog()`
  - `lia.banking.showDeleteAccountDialog()`
  - `lia.banking.showMemberPermissions()`
  - `lia.banking.showMemberPermissionsDialog()`
  - `lia.banking.showPaycheckDepositDialog()`
  - `lia.banking.showRedeemCheckDialog()`
  - `lia.banking.showRemoveMemberDialog()`
  - `lia.banking.showRenameDialog()`
  - `lia.banking.showRequestSubPanel()`
  - `lia.banking.showTransactionHistory()`
  - `lia.banking.showTransferDialog()`
  - `lia.banking.showTransferSubPanel()`
  - `lia.banking.showViewRequests()`
  - `lia.banking.showWithdrawDialog()`
  - `lia.banking.viewBankAccountAsAdmin()`
  - `lia.banking.writeCheck()`

---

# Module Documentation Summary

| Module Path | Undocumented Hooks | Undocumented lia.* Functions | Undocumented Meta Functions |
|---|---:|---:|---:|
| D:\GMOD\Server\garrysmod\gamemodes\lilia_rp\modules\done\banking | 4 | 30 | 0 |

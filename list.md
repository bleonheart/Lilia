# Variable Accessor Usages

Scan the entire codebase and extract **only the usages** of the following variable accessors:

- `setNetVar`
- `getNetVar`
- `SetNW*` (any SetNW variant)
- `GetNW*` (any GetNW variant)

---

## Lilia (Core)

---

## Modules (Addons/Plugins)

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:9
  getNetVar
  if not usingSwep and not speaker:getNetVar("radio_voice", false) then return end
  ```

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:157
  setNetVar
  client:setNetVar("radio_voice", value)
  ```

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:168
  getNetVar
  if not wep:getNetVar("editting") then return end
  ```

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:170
  getNetVar
  timer.Create("radio_animstop_" .. wep:EntIndex(), 1.8, 1, function() if IsValid(wep) and wep:GetClass() == class and wep:getNetVar("editting") then wep:SendWeaponAnim(ACT_VM_RELOAD) end end)
  ```

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:180
  getNetVar
  if wep:getNetVar("editting") then
  ```

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:182
  setNetVar
  wep:setNetVar("editting", false)
  ```

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:183
  Usage: getNetVar
  Context: timer.Simple(1, function() if IsValid(wep) and wep:GetClass() == class and not wep:getNetVar("editting") then wep:SendWeaponAnim(ACT_VM_IDLE) end end)
  ```

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:186
  Usage: setNetVar
  Context: wep:setNetVar("editting", true)
  ```

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:196
  getNetVar
  if not wep:getNetVar("editting") then return end
  ```

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:203
  getNetVar
  if client:GetMoveType() == MOVETYPE_NOCLIP or client:getNetVar("restricted") then return end
  ```

- [ ] ```
  ../metrorp/modules/radio/libraries/server.lua:204
  getNetVar
  local animData = client:getNetVar("animationData", {})
  ```

```
../metrorp/modules/radio/libraries/server.lua:206
Usage: setNetVar
Context: client:setNetVar("animationData", {
```

```
../metrorp/modules/radio/libraries/server.lua:225
Usage: getNetVar
Context: local animData = client:getNetVar("animationData", {})
```

```
../metrorp/modules/radio/libraries/server.lua:238
Usage: setNetVar
Context: client:setNetVar("animationData", {
```

```
../metrorp/modules/done/lockpicking/lua/zlockpick/sv_main.lua:14
Usage: SetNWInt
Context: door:SetNWInt("zlockpickLevel", 0)
```

```
../metrorp/modules/done/lockpicking/lua/zlockpick/sv_main.lua:21
Usage: SetNWInt
Context: door:SetNWInt("zlockpickLevel", 0)
```

```
../metrorp/modules/done/lockpicking/lua/zlockpick/cl_door_locks.lua:21
Usage: GetNWInt
Context: local level = ent:GetNWInt("zlockpickLevel", 0)
```

```
../metrorp/modules/done/lockpicking/lua/zlockpick/cl_main.lua:295
Usage: GetNWInt
Context: if v.Name and ent:GetNWInt("zlockpickLevel", 0) < k then
```

```
../metrorp/modules/done/extraction/entities/entities/lia_flare.lua:25
Usage: GetNW2Bool
Context: if self:GetNW2Bool("ExtractionTriggered", false) then
```

```
../metrorp/modules/done/extraction/entities/entities/lia_flare.lua:52
Usage: SetNW2Bool
Context: self:SetNW2Bool("ExtractionTriggered", true)
```

```
../metrorp/modules/done/cuffs/entities/weapons/lia_medkit/init.lua:5
Usage: SetNWFloat
Context: self:SetNWFloat(self.CooldownNWKey, 0)
```

```
../metrorp/modules/done/cuffs/entities/weapons/lia_medkit/init.lua:29
Usage: GetNWFloat
Context: return CurTime() < self:GetNWFloat(self.CooldownNWKey, 0)
```

```
../metrorp/modules/done/cuffs/entities/weapons/lia_medkit/init.lua:33
Usage: SetNWFloat
Context: self:SetNWFloat(self.CooldownNWKey, CurTime() + self.CooldownTime)
```

```
../metrorp/modules/done/cuffs/entities/weapons/lia_medkit/cl_init.lua:59
Usage: GetNWFloat
Context: local nextUse = self:GetNWFloat(self.CooldownNWKey, 0)
```

```
../metrorp/modules/done/food/addons/zeros-lua-libary/lua/zclib/util/player/sh_player.lua:160
Usage: SetNWString
Context: ent:SetNWString("zclib_Owner", ply:SteamID())
```

```
../metrorp/modules/done/food/addons/zeros-lua-libary/lua/zclib/util/player/sh_player.lua:164
Usage: SetNWString
Context: ent:SetNWString("zclib_Owner", "world")
```

```
../metrorp/modules/done/food/addons/zeros-lua-libary/lua/zclib/util/player/sh_player.lua:170
Usage: GetNWString
Context: return ent:GetNWString("zclib_Owner", "nil")
```

```
../metrorp/modules/done/food/addons/zeros-lua-libary/lua/zclib/util/player/sh_player.lua:187
Usage: GetNWString
Context: local id = ent:GetNWString("zclib_Owner", "nil")
```

```
../metrorp/modules/done/food/addons/zeros-lua-libary/lua/zclib/util/player/sh_player.lua:203
Usage: GetNWString
Context: local id = ent:GetNWString("zclib_Owner", "nil")
```

---

## Gitmodules (External)

```
../metrorp/gitmodules/afk/commands.lua:14
Usage: getNetVar
Context: local isAFK = target:getNetVar("isAFK", false)
```

```
../metrorp/gitmodules/afk/commands.lua:16
Usage: setNetVar
Context: target:setNetVar("isAFK", false)
```

```
../metrorp/gitmodules/afk/commands.lua:17
Usage: setNetVar
Context: target:setNetVar("lastActivity", CurTime())
```

```
../metrorp/gitmodules/afk/commands.lua:21
Usage: setNetVar
Context: target:setNetVar("isAFK", true)
```

```
../metrorp/gitmodules/afk/commands.lua:22
Usage: setNetVar
Context: target:setNetVar("afkTime", CurTime())
```

```
../metrorp/gitmodules/afk/commands.lua:43
Usage: getNetVar
Context: local isAFK = target:getNetVar("isAFK", false)
```

```
../metrorp/gitmodules/afk/commands.lua:44
Usage: getNetVar
Context: local lastActivity = target:getNetVar("lastActivity", 0)
```

```
../metrorp/gitmodules/afk/commands.lua:45
Usage: getNetVar
Context: local afkTime = target:getNetVar("afkTime", 0)
```

```
../metrorp/gitmodules/afk/commands.lua:55
Usage: getNetVar
Context: local isAFK = ply:getNetVar("isAFK", false)
```

```
../metrorp/gitmodules/afk/commands.lua:56
Usage: getNetVar
Context: local lastActivity = ply:getNetVar("lastActivity", 0)
```

```
../metrorp/gitmodules/afk/commands.lua:59
Usage: getNetVar
Context: local afkTime = ply:getNetVar("afkTime", 0)
```

```
../metrorp/gitmodules/afk/libraries/server.lua:4
Usage: setNetVar
Context: client:setNetVar("isAFK", false)
```

```
../metrorp/gitmodules/afk/libraries/server.lua:5
Usage: setNetVar
Context: client:setNetVar("afkTime", CurTime() + lia.config.get("AFKTime", 180))
```

```
../metrorp/gitmodules/afk/libraries/server.lua:6
Usage: setNetVar
Context: client:setNetVar("lastActivity", CurTime())
```

```
../metrorp/gitmodules/afk/libraries/server.lua:68
Usage: setNetVar
Context: client:setNetVar("isAFK", false)
```

```
../metrorp/gitmodules/afk/libraries/server.lua:69
Usage: setNetVar
Context: client:setNetVar("afkTime", CurTime() + lia.config.get("AFKTime", 180))
```

```
../metrorp/gitmodules/afk/libraries/server.lua:70
Usage: setNetVar
Context: client:setNetVar("lastActivity", CurTime())
```

```
../metrorp/gitmodules/afk/libraries/server.lua:78
Usage: getNetVar
Context: local lastActivity = client:getNetVar("lastActivity", 0)
```

```
../metrorp/gitmodules/afk/libraries/server.lua:80
Usage: getNetVar
Context: if currentTime - lastActivity >= lia.config.get("AFKTime", 180) and not client:getNetVar("isAFK") then
```

```
../metrorp/gitmodules/afk/libraries/server.lua:81
Usage: setNetVar
Context: client:setNetVar("isAFK", true)
```

```
../metrorp/gitmodules/afk/libraries/server.lua:82
Usage: setNetVar
Context: client:setNetVar("afkTime", currentTime)
```

```
../metrorp/gitmodules/afk/libraries/server.lua:91
Usage: getNetVar
Context: if target:getNetVar("isAFK") then return false, L("cannotBeRestrained") end
```

```
../metrorp/gitmodules/afk/libraries/server.lua:96
Usage: getNetVar
Context: if target:getNetVar("isAFK") then return false, L("cannotBeUnrestrained") end
```

```
../metrorp/gitmodules/afk/libraries/server.lua:101
Usage: getNetVar
Context: if target:getNetVar("isAFK") then return false, L("cannotBeArrested") end
```

```
../metrorp/gitmodules/afk/libraries/server.lua:106
Usage: getNetVar
Context: if target:getNetVar("isAFK") then return false, L("cannotBeUnarrested") end
```

```
../metrorp/gitmodules/afk/libraries/server.lua:111
Usage: getNetVar
Context: if target:getNetVar("isAFK") then return false, L("cannotBeStunned") end
```

```
../metrorp/gitmodules/afk/libraries/server.lua:116
Usage: getNetVar
Context: if target:getNetVar("isAFK") then return false, L("cannotBeKnockedOut") end
```

```
../metrorp/gitmodules/simple_lockpicking/libraries/server.lua:2
Usage: setNetVar
Context: ply:setNetVar("isPicking", false)
```

```
../metrorp/gitmodules/simple_lockpicking/libraries/client.lua:2
Usage: getNetVar
Context: if client:getNetVar("isPicking") then info[#info + 1] = {"Lockpicking...", Color(255, 100, 100)} end
```

```
../metrorp/gitmodules/simple_lockpicking/libraries/client.lua:6
Usage: getNetVar
Context: if string.find(bind, "+use") and ply:getNetVar("isPicking") or string.find(bind, "+attack" or string.find(bind, "+attack2") and ply:getNetVar("isPicking")) and ply:getNetVar("isPicking") then return true end
```

```
../metrorp/gitmodules/simple_lockpicking/items/lockpick.lua:11
Usage: getNetVar
Context: if not ply:getNetVar("restricted") and IsValid(target) or target:IsVehicle() and target:isLocked() then
```

```
../metrorp/gitmodules/simple_lockpicking/items/lockpick.lua:17
Usage: getNetVar
Context: if not ply or not ply:getNetVar("isPicking") then
```

```
../metrorp/gitmodules/simple_lockpicking/items/lockpick.lua:25
Usage: setNetVar
Context: ply:setNetVar("isPicking", true)
```

```
../metrorp/gitmodules/simple_lockpicking/items/lockpick.lua:33
Usage: setNetVar
Context: ply:setNetVar("isPicking")
```

```
../metrorp/gitmodules/simple_lockpicking/items/lockpick.lua:38
Usage: setNetVar
Context: ply:setNetVar("isPicking")
```

```
../metrorp/gitmodules/raisedweapons/meta/shared.lua:27
Usage: getNetVar
Context: return self:getNetVar("raised", false)
```

```
../metrorp/gitmodules/raisedweapons/meta/shared.lua:32
Usage: getNetVar
Context: local old = self:getNetVar("raised", false)
```

```
../metrorp/gitmodules/raisedweapons/meta/shared.lua:33
Usage: setNetVar
Context: self:setNetVar("raised", state)
```

```
../metrorp/gitmodules/npcspawner/libraries/server.lua:29
Usage: setNetVar
Context: npc:setNetVar("setNetVar", group)
```

```
../metrorp/gitmodules/npcspawner/libraries/server.lua:51
Usage: getNetVar
Context: if IsValid(npc) and npc:getNetVar("setNetVar") == group then
```

```
../metrorp/gitmodules/hud_extras/libraries/client.lua:42
Usage: getNetVar
Context: blurGoal = client:getNetVar("blur", 0) + (hook.Run("AdjustBlurAmount", blurGoal) or 0)
```

```
../metrorp/gitmodules/enhanceddeath/libraries/server.lua:3
Usage: getNetVar
Context: if client:getNetVar("hospitalDeath", false) then
```

```
../metrorp/gitmodules/enhanceddeath/libraries/server.lua:7
Usage: setNetVar
Context: client:setNetVar("hospitalDeath", false)
```

```
../metrorp/gitmodules/enhanceddeath/libraries/server.lua:26
Usage: setNetVar
Context: client:setNetVar("hospitalDeath", true)
```

```
../metrorp/gitmodules/doorkick/commands.lua:7
Usage: getNetVar
Context: if IsValid(ent) and ent:isDoor() and ent:getNetVar("disabled", false) then
```

```
../metrorp/gitmodules/doorkick/commands.lua:23
Usage: getNetVar
Context: if not ent:getNetVar("faction") or ent:getNetVar("faction") ~= FACTION_STAFF then
```

```
../metrorp/gitmodules/alcoholism/meta/sh_player.lua:5
Usage: setNetVar
Context: self:setNetVar("lia_alcoholism_bac", 0)
```

```
../metrorp/gitmodules/alcoholism/meta/sh_player.lua:15
Usage: getNetVar
Context: local oldBac = self:getNetVar("lia_alcoholism_bac", 0)
```

```
../metrorp/gitmodules/alcoholism/meta/sh_player.lua:17
Usage: setNetVar
Context: self:setNetVar("lia_alcoholism_bac", newBac)
```

```
../metrorp/gitmodules/alcoholism/meta/sh_player.lua:31
Usage: getNetVar
Context: return self:getNetVar("lia_alcoholism_bac", 0)
```

```
../metrorp/gitmodules/alcoholism/libraries/server.lua:6
Usage: getNetVar
Context: local bac = client:getNetVar("lia_alcoholism_bac", 0)
```

```
../metrorp/gitmodules/alcoholism/libraries/server.lua:10
Usage: setNetVar
Context: client:setNetVar("lia_alcoholism_bac", newBac)
```

```
../metrorp/gitmodules/alcoholism/libraries/server.lua:23
Usage: getNetVar
Context: local bac = client:getNetVar("lia_alcoholism_bac", 0)
```

```
../metrorp/gitmodules/alcoholism/libraries/server.lua:48
Usage: getNetVar
Context: local bac = client:getNetVar("lia_alcoholism_bac", 0)
```

```
../metrorp/gitmodules/alcoholism/libraries/client.lua:2
Usage: getNetVar
Context: if LocalPlayer():getNetVar("lia_alcoholism_bac", 0) > 0 then DrawMotionBlur(lia.config.get("AlcoholAddAlpha"), LocalPlayer():getNetVar("lia_alcoholism_bac", 0) / 100, lia.config.get("AlcoholEffectDelay")) end
```

```
../metrorp/gitmodules/alcoholism/libraries/client.lua:10
Usage: getNetVar
Context: hook.Run("AddTextField", L("generalinfo"), "drunkness", L("drunkness"), function() return LocalPlayer():getNetVar("lia_alcoholism_bac", 0) .. "%" end)
```

```
../metrorp/gitmodules/afk/libraries/client.lua:49
Usage: getNetVar
Context: if not client:getNetVar("isAFK") then return end
```

```
../metrorp/gitmodules/afk/libraries/client.lua:50
Usage: getNetVar
Context: local afkTime = client:getNetVar("afkTime", 0)
```

```
../metrorp/gitmodules/afk/libraries/client.lua:57
Usage: getNetVar
Context: if not LocalPlayer():getNetVar("isAFK") then return end
```

```
../metrorp/gitmodules/afk/libraries/client.lua:58
Usage: getNetVar
Context: local afkTime = LocalPlayer():getNetVar("afkTime", 0)
```



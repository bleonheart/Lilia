lia.config.add("SwitchCooldownOnAllEntities", L("switchCooldownOnAllEntities"), false, nil, {
    desc = L("switchCooldownOnAllEntitiesDesc"),
    category = L("categoryCharacter"),
    type = "Boolean",
})

lia.config.add("OnDamageCharacterSwitchCooldownTimer", L("onDamageCharacterSwitchCooldownTimer"), 15, nil, {
    desc = L("onDamageCharacterSwitchCooldownTimerDesc"),
    category = L("categoryCharacter"),
    type = "Float",
    min = 0,
    max = 120
})

lia.config.add("CharacterSwitchCooldownTimer", L("characterSwitchCooldownTimer"), 5, nil, {
    desc = L("characterSwitchCooldownTimerDesc"),
    category = L("categoryCharacter"),
    type = "Float",
    min = 0,
    max = 120
})

lia.config.add("ExplosionRagdoll", L("explosionRagdoll"), false, nil, {
    desc = L("explosionRagdollDesc"),
    category = L("categoryQualityOfLife"),
    type = "Boolean",
})

lia.config.add("CarRagdoll", L("carRagdoll"), false, nil, {
    desc = L("carRagdollDesc"),
    category = L("categoryQualityOfLife"),
    type = "Boolean",
})

lia.config.add("NPCsDropWeapons", L("npcsDropWeapons"), false, nil, {
    desc = L("npcsDropWeaponsDesc"),
    category = L("categoryQualityOfLife"),
    type = "Boolean",
})

lia.config.add("TimeUntilDroppedSWEPRemoved", L("timeUntilDroppedSWEPRemoved"), 15, nil, {
    desc = L("timeUntilDroppedSWEPRemovedDesc"),
    category = L("categoryProtection"),
    type = "Float",
    min = 0,
    max = 300
})

lia.config.add("AltsDisabled", L("altsDisabled"), false, nil, {
    desc = L("altsDisabledDesc"),
    category = L("categoryProtection"),
    type = "Boolean",
})

lia.config.add("ActsActive", L("actsActive"), false, nil, {
    desc = L("actsActiveDesc"),
    category = L("categoryProtection"),
    type = "Boolean",
})

lia.config.add("PassableOnFreeze", L("passableOnFreeze"), false, nil, {
    desc = L("passableOnFreezeDesc"),
    category = L("categoryProtection"),
    type = "Boolean",
})

lia.config.add("PlayerSpawnVehicleDelay", L("playerSpawnVehicleDelay"), 30, nil, {
    desc = L("playerSpawnVehicleDelayDesc"),
    category = L("categoryProtection"),
    type = "Float",
    min = 0,
    max = 300
})

lia.config.add("ToolInterval", L("toolInterval"), 0, nil, {
    desc = L("toolIntervalDesc"),
    category = L("categoryProtection"),
    type = "Float",
    min = 0,
    max = 60
})

lia.config.add("DisableLuaRun", L("disableLuaRun"), false, nil, {
    desc = L("disableLuaRunDesc"),
    category = L("categoryProtection"),
    type = "Boolean",
})

lia.config.add("EquipDelay", L("equipDelay"), 0, nil, {
    desc = L("equipDelayDesc"),
    category = L("categoryItems"),
    type = "Float",
    min = 0,
    max = 10
})

lia.config.add("UnequipDelay", L("unequipDelay"), 0, nil, {
    desc = L("unequipDelayDesc"),
    category = L("categoryItems"),
    type = "Float",
    min = 0,
    max = 10
})

lia.config.add("DropDelay", L("dropDelay"), 0, nil, {
    desc = L("dropDelayDesc"),
    category = L("categoryItems"),
    type = "Float",
    min = 0,
    max = 10
})

lia.config.add("TakeDelay", L("takeDelay"), 0, nil, {
    desc = L("takeDelayDesc"),
    category = L("categoryItems"),
    type = "Float",
    min = 0,
    max = 10
})

lia.config.add("ItemGiveSpeed", L("itemGiveSpeed"), 6, nil, {
    desc = L("itemGiveSpeedDesc"),
    category = L("categoryItems"),
    type = "Int",
    min = 1,
    max = 60
})

lia.config.add("ItemGiveEnabled", L("itemGiveEnabled"), true, nil, {
    desc = L("itemGiveEnabledDesc"),
    category = L("categoryItems"),
    type = "Boolean",
})

lia.config.add("DisableCheaterActions", L("disableCheaterActions"), true, nil, {
    desc = L("disableCheaterActionsDesc"),
    category = L("categoryProtection"),
    type = "Boolean",
})

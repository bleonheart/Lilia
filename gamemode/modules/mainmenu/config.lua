lia.config.add("MusicVolume", L("mainMenuMusicVolume"), 0.25, nil, {
    desc = L("mainMenuMusicVolumeDesc"),
    category = L("categoryMainMenu"),
    type = "Float",
    min = 0.0,
    max = 1.0
})

lia.config.add("Music", L("mainMenuMusic"), "", nil, {
    desc = L("mainMenuMusicDesc"),
    category = L("categoryMainMenu"),
    type = "Generic"
})

lia.config.add("BackgroundURL", L("mainMenuBackgroundURL"), "", nil, {
    desc = L("mainMenuBackgroundURLDesc"),
    category = L("categoryMainMenu"),
    type = "Generic"
})

lia.config.add("CenterLogo", L("mainMenuCenterLogo"), "", nil, {
    desc = L("mainMenuCenterLogoDesc"),
    category = L("categoryMainMenu"),
    type = "Generic"
})

lia.config.add("DiscordURL", L("mainMenuDiscordURL"), "https://discord.gg/esCRH5ckbQ", nil, {
    desc = L("mainMenuDiscordURLDesc"),
    category = L("categoryMainMenu"),
    type = "Generic"
})

lia.config.add("Workshop", L("mainMenuWorkshopURL"), "https://steamcommunity.com/sharedfiles/filedetails/?id=3527535922", nil, {
    desc = L("mainMenuWorkshopURLDesc"),
    category = L("categoryMainMenu"),
    type = "Generic"
})

lia.config.add("CharMenuBGInputDisabled", L("mainMenuCharBGInputDisabled"), true, nil, {
    desc = L("mainMenuCharBGInputDisabledDesc"),
    category = L("categoryMainMenu"),
    type = "Boolean"
})

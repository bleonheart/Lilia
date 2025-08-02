lia.config.add("sbWidth", L("sbWidth"), 0.35, nil, {
    desc = L("sbWidthDesc"),
    category = L("moduleScoreboardName"),
    type = "Float",
    min = 0.1,
    max = 1.0
})

lia.config.add("sbHeight", L("sbHeight"), 0.65, nil, {
    desc = L("sbHeightDesc"),
    category = L("moduleScoreboardName"),
    type = "Float",
    min = 0.1,
    max = 1.0
})

lia.config.add("ClassHeaders", L("classHeaders"), true, nil, {
    desc = L("classHeadersDesc"),
    category = L("moduleScoreboardName"),
    type = "Boolean"
})

lia.config.add("UseSolidBackground", L("useSolidBackground"), false, nil, {
    desc = L("useSolidBackgroundDesc"),
    category = L("moduleScoreboardName"),
    type = "Boolean"
})

lia.config.add("ClassLogo", L("classLogo"), false, nil, {
    desc = L("classLogoDesc"),
    category = L("moduleScoreboardName"),
    type = "Boolean"
})

lia.config.add("ScoreboardBackgroundColor", L("scoreboardBackgroundColor"), {
    r = 255,
    g = 100,
    b = 100,
    a = 255
}, nil, {
    desc = L("scoreboardBackgroundColorDesc"),
    category = L("moduleScoreboardName"),
    type = "Color"
})

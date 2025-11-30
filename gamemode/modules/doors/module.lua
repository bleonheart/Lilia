lia.doors = lia.doors or {}
DOOR_OWNER = 3
DOOR_TENANT = 2
DOOR_GUEST = 1
DOOR_NONE = 0
MODULE.name = "doorsModuleName"
MODULE.author = "Samael"
MODULE.discord = "@liliaplayer"
MODULE.desc = "doorSystemDescription"
lia.doors.AccessLabels = {
    [DOOR_NONE] = "doorAccessNone",
    [DOOR_GUEST] = "doorAccessGuest",
    [DOOR_TENANT] = "doorAccessTenant",
    [DOOR_OWNER] = "doorAccessOwner"
}

-- Default door values - only non-default values are stored/synced
lia.doors.defaults = {
    name = "",
    title = "",
    price = 0,
    disabled = false,
    locked = false,
    hidden = false,
    noSell = false,
    factions = {},
    classes = {}
}
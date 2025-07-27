local MODULE = MODULE
local function queryStaffActions(callback)
    lia.db.query([[
        SELECT sa.admin, sa.adminSteamID, lp.userGroup, COUNT(*) AS count
        FROM lia_staffactions AS sa
        LEFT JOIN lia_players AS lp ON lp.steamID = sa.adminSteamID
        GROUP BY sa.adminSteamID, sa.admin
    ]], callback)
end



local playerMeta = FindMetaTable("Player")
function playerMeta:hasPrivilege(privilegeName)
    if not isstring(privilegeName) then
        lia.error(string.format("Privilege name must be a string, got %s", tostring(privilegeName)))
        return false
    end
    return lia.admin.hasAccess(self, privilegeName) or self:hasStaffCharacterPermission(privilegeName)
end

function playerMeta:hasStaffCharacterPermission(privilegeName)
    if not isstring(privilegeName) or not self:isStaffOnDuty() then return false end
    privilegeName = lia.admin.normalizePrivilege(privilegeName)
    local permissions = lia.staffCharacterPermissions or {}
    if SERVER then permissions = lia.data.get("staffCharacterPermissions", {}) end
    local restricted = privilegeName == "manageUsergroups" or lia.admin.privileges[privilegeName] == "superadmin"
    local allowed = not restricted and permissions[privilegeName] == true
    lia.debug("[Permissions]", "Staff character permission check", "player=", tostring(self), "permission=", tostring(privilegeName), "isStaffOnDuty=", tostring(self:isStaffOnDuty()), "enabled=", tostring(allowed), "finalResult=", tostring(allowed))
    return allowed
end

local function groupHasType(groupName, t)
    local groups = lia.admin.groups or {}
    local visited = {}
    t = t:lower()
    while groupName and not visited[groupName] do
        visited[groupName] = true
        local data = groups[groupName]
        if not data then break end
        local info = data._info or {}
        for _, typ in ipairs(info.types or {}) do
            if tostring(typ):lower() == t then return true end
        end

        groupName = info.inheritance
    end
    return false
end

function playerMeta:isStaff()
    return groupHasType(self:GetUserGroup(), "Staff")
end

function playerMeta:isStaffOnDuty()
    return self:Team() == FACTION_STAFF
end

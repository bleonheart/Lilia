local MODULE = MODULE
function MODULE:PostPlayerLoadout(client)
    if client:hasPrivilege("useAdminStick") or client:isStaffOnDuty() then client:Give("adminstick") end
end
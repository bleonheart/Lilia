LiliaVendors = LiliaVendors or {}
ENT.Type = "anim"
ENT.PrintName = L("entityVendorName")
ENT.Category = "Lilia"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.isVendor = true
ENT.NoPhysgun = true
ENT.NoRemover = true
ENT.DrawEntityInfo = true
ENT.IsPersistent = true
function ENT:setupVars()
    if SERVER then
        self:setNetVar("name", "Jane Doe")
        self:setNetVar("preset", "none")
        self.receivers = {}
    end

    self.items = {}
    self.factions = {}
    self.messages = {}
    self.classes = {}
    self.hasSetupVars = true
end

function ENT:Initialize()
    if CLIENT then
        timer.Simple(1, function()
            if not IsValid(self) then return end
            self:setAnim()
        end)
        return
    end

    self:SetModel("models/mossman.mdl")
    self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:DrawShadow(true)
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:setupVars()
    local physObj = self:GetPhysicsObject()
    if IsValid(physObj) then
        physObj:EnableMotion(false)
        physObj:Sleep()
    end

    LiliaVendors[self:EntIndex()] = self
end

function ENT:getMoney()
    return self.money
end

function ENT:getWelcomeMessage()
    return self:getNetVar("welcomeMessage", L("vendorWelcomeMessage"))
end

function ENT:hasMoney(amount)
    local money = self:getMoney()
    if not money then return true end
    return money >= amount
end

function ENT:getStock(uniqueID)
    if self.items[uniqueID] and self.items[uniqueID][VendorMaxStock] then return self.items[uniqueID][VendorStock] or 0, self.items[uniqueID][VendorMaxStock] end
end

function ENT:getMaxStock(itemType)
    if self.items[itemType] then return self.items[itemType][VendorMaxStock] end
end

function ENT:isItemInStock(itemType, amount)
    amount = amount or 1
    assert(isnumber(amount), "amount must be a number")
    local info = self.items[itemType]
    if not info then return false end
    if not info[VendorMaxStock] then return true end
    return info[VendorStock] >= amount
end

function ENT:getPrice(uniqueID, isSellingToVendor)
    local price = lia.item.list[uniqueID] and self.items[uniqueID] and self.items[uniqueID][VendorPrice] or lia.item.list[uniqueID]:getPrice()
    local overridePrice = hook.Run("getPriceOverride", self, uniqueID, price, isSellingToVendor)
    if overridePrice then
        price = overridePrice
    else
        if isSellingToVendor then price = math.floor(price * self:getSellScale()) end
    end
    return price
end

function ENT:getTradeMode(itemType)
    if self.items[itemType] then return self.items[itemType][VendorMode] end
end

function ENT:isClassAllowed(classID)
    local class = lia.class.list[classID]
    if not class then return false end
    local faction = lia.faction.indices[class.faction]
    if faction and self:isFactionAllowed(faction.index) then return true end
    return self.classes[classID]
end

function ENT:isFactionAllowed(factionID)
    return self.factions[factionID]
end

function ENT:getSellScale()
    return self:getNetVar("scale", 0.5)
end

function ENT:getName()
    return self:getNetVar("name", "")
end

function ENT:getPreset()
    return self:getNetVar("preset", "none")
end

function ENT:setAnim()
    for k, v in ipairs(self:GetSequenceList()) do
        if v:lower():find("idle") and v ~= "idlenoise" then return self:ResetSequence(k) end
    end

    if self:GetSequenceCount() > 1 then self:ResetSequence(4) end
end

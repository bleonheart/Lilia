local MODULE = MODULE
function MODULE:OnReloaded()
    if IsValid(lia.gui.score) then lia.gui.score:Remove() end
end

function MODULE:ShouldShowPlayerOnScoreboard(client)
    local faction = lia.faction.indices[client:Team()]
    if faction and faction.scoreboardHidden then return false end
end

function MODULE:ScoreboardHide()
    if IsValid(lia.gui.score) and lia.gui.score:IsVisible() then
        lia.gui.score:SetVisible(false)
        CloseDermaMenus()
        hook.Run("ScoreboardClosed", lia.gui.score)
    end

    gui.EnableScreenClicker(false)
    return true
end

function MODULE:ScoreboardShow()
    if hook.Run("CanPlayerOpenScoreboard", LocalPlayer()) == false then return false end
    local interactions = lia.playerinteract.getInteractions()
    local actions = lia.playerinteract.getActions()
    local hasInteractions = not table.IsEmpty(interactions)
    local hasActions = not table.IsEmpty(actions)
    if not hasInteractions and not hasActions then
        if IsValid(lia.gui.score) then
            if not lia.gui.score:IsVisible() then
                lia.gui.score:SetVisible(true)
                hook.Run("ScoreboardOpened", lia.gui.score)
            end
        else
            vgui.Create("liaScoreboard")
        end
    end

    gui.EnableScreenClicker(true)
    return true
end

function MODULE:InteractionMenuOpened()
    self:ScoreboardHide()
end
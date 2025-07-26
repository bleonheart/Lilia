local MODULE = MODULE
MODULE.Actions = {}
MODULE.Interactions = {}
function AddInteraction(name, data)
    MODULE.Interactions[name] = data
end

function AddAction(name, data)
    MODULE.Actions[name] = data
end

RegisterCommand("gotoCoords", function(source, arg, rawCommand)
    SetEntityCoords(PlayerPedId(), tonumber(arg[1]), tonumber(arg[2]), tonumber(arg[3]), false, false, false, false)
end, false)
--[[
    Author: https://github.com/Fernando-A-Rocha

    Example Implementation (Client-Side)
]]
math.randomseed(os.time())
local godModePlayers = {}
addEvent("collectibles-example:syncGodModePlayers", true)
addEventHandler("collectibles-example:syncGodModePlayers", localPlayer, function(players)
    godModePlayers = players
end)
local function godModeEffect(player)
    local x,y,z = getElementPosition(player)
    fxAddSparks(x+math.random(0.1, 0.3), y+math.random(0.1, 0.2), z+0.5, 1, 1, 1, math.random(1,3), math.random(1,5))
    fxAddSparks(x+math.random(0.3, 0.5), y+math.random(0.3, 0.4), z-0.2, 1, 1, 1, math.random(1,3), math.random(1,5))
end
addEventHandler("onClientPlayerDamage", root, function(attacker, damage_num, bodypart_num, loss_num)
    if not godModePlayers[source] then return end
    godModeEffect(source)
    setTimer(godModeEffect, 500, 1, source)
    cancelEvent()
end)

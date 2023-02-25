--[[
    Author: https://github.com/Fernando-A-Rocha

    Example Implementation (Server-Side)
]]
local function cmdCollectibleStats(thePlayer, cmd)
    local id = exports["collectibles"]:getPlayerIdentity(thePlayer)
    if (not id) then
        outputChatBox("You are not logged in.", thePlayer, 255, 0, 0)
        return
    end
    local counts = exports["collectibles"]:getCollectedCounts(id)
    triggerClientEvent(thePlayer, "collectibles-gui:showStats", thePlayer, counts)
end
addCommandHandler("collectibles", cmdCollectibleStats, false, false)
addCommandHandler("collectiblestats", cmdCollectibleStats, false, false)
local function handleCollect(collectorID, collectibleTarget, theType, count, total)
    local thePlayer = source
    outputChatBox("#ffffffCheck your stats with#00ff00 /collectibles#ffffff.", thePlayer, 255, 255, 255, true)
end
addEventHandler("collectibles:onCollected", root, handleCollect)

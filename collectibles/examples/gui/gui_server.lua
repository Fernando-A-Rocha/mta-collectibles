--[[
    Author: https://github.com/Fernando-A-Rocha

    Example Implementation (Server-Side)
]]
local function cmdCollectibleStats(thePlayer, cmd)
    local account = getPlayerAccount(thePlayer)
    if (not account) or (isGuestAccount(account)) then
        outputChatBox("You are not logged in.", thePlayer, 255, 0, 0)
        return
    end
    local counts = exports["collectibles"]:getCollectedCounts(account)
    triggerClientEvent(thePlayer, "collectibles-gui:showStats", thePlayer, counts)
end
addCommandHandler("collectibles", cmdCollectibleStats)
addCommandHandler("collectiblestats", cmdCollectibleStats)
local function handleCollect(account, accountID, accountName, collectibleTarget, theType, count, total)
    local thePlayer = source
    outputChatBox("#ffffffCheck your stats with#00ff00 /collectibles#ffffff.", thePlayer, 255, 255, 255, true)
end
addEventHandler("collectibles:onCollected", root, handleCollect)

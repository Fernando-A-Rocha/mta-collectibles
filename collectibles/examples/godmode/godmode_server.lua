--[[
    Author: https://github.com/Fernando-A-Rocha

    Example Implementation (Server-Side)
]]
local GOD_MODE_DURATION = 60 * 1000 * 5 -- 5 minutes
local haveGodMode = {}
local function syncGodModeWithClients()
    local playersTable = getElementsByType("player")
    local godModeTable = {}
    for player, timer in pairs(haveGodMode) do
        if isElement(player) then
            godModeTable[player] = true
        end
    end
    for i=1, #playersTable do
        local player = playersTable[i]
        if player then
            triggerClientEvent(player, "collectibles-example:syncGodModePlayers", player, godModeTable)
        end
    end
end
local function handlePickedHeart(collectibleTarget, theType, count, total)
    local thePlayer = source
    if theType ~= "Heart" then return end
    if count ~= total then return end -- Only give godmode when all hearts have been collected
    if isTimer(haveGodMode[thePlayer]) then
        return
    end
    haveGodMode[thePlayer] = setTimer(function()
        haveGodMode[thePlayer] = nil
        if isElement(thePlayer) then
            outputChatBox("#ffff00Your #ffffffGOD #ffff00MODE has expired!", thePlayer, 255, 255, 255, true)
        end
        syncGodModeWithClients()
    end, GOD_MODE_DURATION, 1)
    outputChatBox("#00ff00You have been given #ffffffGOD MODE #00ff00for "..tostring(GOD_MODE_DURATION/1000).." seconds!", thePlayer, 255, 255, 255, true)
    syncGodModeWithClients()
end
addEventHandler("collectibles:onCollected", root, handlePickedHeart)

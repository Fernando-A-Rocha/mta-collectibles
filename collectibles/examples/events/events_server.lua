--[[
    Author: https://github.com/Fernando-A-Rocha

    Example Implementation (Server-Side)
]]
local EVENTS = {
    ["Package"] = {
        friendlyName = "Package Collectibles",
        announce = "#ffffffWhoever finds the most #ffa12e%s#ffffff wins #ffa12e$%d#ffffff. Good luck!",
        rewardMoney = 500000,
        ongoing = false,
        found = {},
    },
}
local function onCollectiblesSpawned(theAdmin, theType, count)
    local event = EVENTS[theType]
    if not event then return end
    local adminName = isElement(theAdmin) and getPlayerName(theAdmin) or theAdmin
    for k, player in ipairs(getElementsByType("player")) do
        triggerClientEvent(player, "collectible-events:announce", player, event, adminName)
    end
    EVENTS[theType].ongoing = true
    EVENTS[theType].found = {}
end
addEventHandler("collectibles:onSpawnedServer", root, onCollectiblesSpawned, false)
local function handlePlayerLogin()
    local player2 = source
    local oneGoingOn = false
    for theType, event in pairs(EVENTS) do
        if event.ongoing then
            oneGoingOn = true
            break
        end
    end
    -- Don't check later if there's no event going on
    -- as new events will be announced anyway
    if not oneGoingOn then return end
    setTimer(function(player)
        if not isElement(player) then return end
        for theType, event in pairs(EVENTS) do
            if event.ongoing then
                triggerClientEvent(player, "collectible-events:announce", player, event)
            end
        end
    end, 10000, 1, player2)
end
addEventHandler("onPlayerLogin", root, handlePlayerLogin)
local function getPlayerWithID(id)
    for k, player in ipairs(getElementsByType("player")) do
        local id2 = exports["collectibles"]:getPlayerIdentity(player)
        if id2 == id then
            return player
        end
    end
end
local function handleCollect(collectorID, collectibleTarget, theType, count, total)
    local thePlayer = source
    local event = EVENTS[theType]
    if not event then return end
    if not event.ongoing then return end
    local now = getRealTime().timestamp
    local i = #event.found+1
    EVENTS[theType].found[i] = { timestamp = now, collectorID = collectorID, playerName = getPlayerName(thePlayer) }

    if #EVENTS[theType].found == total then
        local playerCollectedCounts = {}
        for k, v in ipairs(EVENTS[theType].found) do
            if not playerCollectedCounts[v.collectorID] then
                playerCollectedCounts[v.collectorID] = 1
            else
                playerCollectedCounts[v.collectorID] = playerCollectedCounts[v.collectorID] + 1
            end
        end
        local winnerID = nil
        local winnerCount = 0
        for accountID2, count2 in pairs(playerCollectedCounts) do
            if count2 > winnerCount then
                winnerID = accountID2
                winnerCount = count2
            end
        end
        local winnerName = nil
        for k, v in ipairs(EVENTS[theType].found) do
            if v.collectorID == winnerID then
                winnerName = v.playerName
                break
            end
        end
        local winnerPlayer = getPlayerWithID(collectorID)
        local winnerInfo = {name = winnerName, player = winnerPlayer}
        local rewardMoney = event.rewardMoney
        if winnerPlayer then
            givePlayerMoney(winnerPlayer, rewardMoney)
        else
            outputServerLog(string.format("[Collectibles Event] %s won the %s event, but they are not online to receive $%d.", winnerName, event.friendlyName, rewardMoney))
        end
        for k, player in ipairs(getElementsByType("player")) do
            triggerClientEvent(player, "collectible-events:announce", player, event, false, winnerInfo)
        end
        EVENTS[theType].ongoing = false
        EVENTS[theType].found = {}
    end
end
addEventHandler("collectibles:onCollected", root, handleCollect)

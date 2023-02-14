--[[
    Author: https://github.com/Fernando-A-Rocha

    Collectibles - System [Testing] (Server)

    /!\ Unless you know what you are doing, do not edit this file. /!\
]]

-- TP to where the demo collectibles are spawned
addCommandHandler("bb", function(thePlayer)
    setElementPosition(thePlayer, 0, 0, 3)
    setElementInterior(thePlayer, 0)
    setElementDimension(thePlayer, 0)
end)
addCommandHandler("shop", function(thePlayer)
    setElementPosition(thePlayer, -30.99, -90.74, 1003.6)
    setElementInterior(thePlayer, 18)
    setElementDimension(thePlayer, 0)
end)

addCommandHandler("collectiblesdata", function(thePlayer, cmd, targetAccountID)
    if not canAdminCollectibles(thePlayer) then
        return outputChatBox("You do not have permission to use this command.", thePlayer, 255, 0, 0)
    end
    local targetAccount
    if targetAccountID then
        targetAccountID = tonumber(targetAccountID)
        if not targetAccountID then
            return outputChatBox("Invalid account ID.", thePlayer, 255, 0, 0)
        end
        targetAccount = getAccountByID(targetAccountID)
        if (not targetAccount) then
            return outputChatBox("Invalid account ID.", thePlayer, 255, 0, 0)
        end
        if isGuestAccount(targetAccount) then
            return outputChatBox("Account ID "..targetAccountID.." is not logged in.", thePlayer, 255, 0, 0)
        end
    else
        targetAccount = getPlayerAccount(thePlayer)
        if (not targetAccount) or isGuestAccount(targetAccount) then
            return outputChatBox("You are not logged in.", thePlayer, 255, 0, 0)
        end
    end
    outputChatBox("Check debug console.", thePlayer, 0, 255, 0)
    local dataName = getAccountDataNames().client_counts
    iprint(getAccountData(targetAccount, dataName))
end, false, false)

--[[
    Author: https://github.com/Fernando-A-Rocha

    Example Implementation (Client-Side)
]]
addEvent("collectible-events:announce", true)
local function announceEvent(event, adminName, winner)
    if (winner) then
        outputChatBox(string.format("[Event]#ffffff The #00ff00winner#ffffff of the #ffa12e%s#ffffff event is #36c9ff%s#ffffff!", event.friendlyName, winner.name), 255, 0, 255, true)
        playSound("examples/events/congrats.mp3")
        if winner.player == localPlayer then
            outputChatBox(string.format("[Event]#ffffff You have received #ffa12e$%d#ffffff for #00ff00winning#ffffff the #ffa12e%s#ffffff event!", event.rewardMoney, event.friendlyName), 255, 0, 255, true)
        end
    else
        playSound("examples/events/notification.mp3")
        setTimer(function()
            local announce = string.format(event.announce, event.friendlyName, event.rewardMoney)
            if (adminName) then
                outputChatBox(string.format("[Event]#ffffff A new event has been started by#36c9ff %s#ffffff:", adminName), 255, 0, 255, true)
            else
                outputChatBox(string.format("[Event]#ffffff There is currently an event happening, in which you can participate:", adminName), 255, 0, 255, true)
            end
            outputChatBox(string.format("[Event]#ffffff %s", announce), 255, 0, 255, true)
        end, 1200, 1)
    end
end
addEventHandler("collectible-events:announce", localPlayer, announceEvent, false)

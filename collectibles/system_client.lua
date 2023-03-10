--[[
    Author: https://github.com/Fernando-A-Rocha

    Collectibles - System (Client)

    /!\ Unless you know what you are doing, do not edit this file. /!\
]]

-- Internal Events
addEvent("collectibles:receive", true) -- source: always the local player
addEvent("collectibles:despawn", true) -- source: always the local player
addEvent("collectibles:onCollectVisuals", true) -- source: always the local player
addEvent("collectibles:pickupDenied", true) -- source: always the local player

local SW, SH = guiGetScreenSize()

local receivedCollectibles = {}
local spawnedCollectibles = nil
local lastActionAt = nil
local drawing = nil
local waitingPickup = nil
local CONSTANTS = {}

function getConstants()
    return CONSTANTS
end

local function createOnePickup(theType, spID, spawnpoint)
    local pickup = createPickup(spawnpoint.x, spawnpoint.y, spawnpoint.z, 3, spawnpoint.model)
    if not pickup then
        outputDebugMsg("Failed to create pickup for type '" .. theType .. "' at spawnpoint " .. (spID) .. ".", "ERROR")
        return false
    end
    setElementInterior(pickup, spawnpoint.interior)
    setElementDimension(pickup, spawnpoint.dimension)
    spawnedCollectibles[pickup] = {
        type = theType,
        spID = spID,
    }
    return pickup
end

local function toggleCollectibles(theType)
    local info = receivedCollectibles[theType]
    if not info then
        return
    end
    if (not lastActionAt or getTickCount() - lastActionAt > 500) then
        lastActionAt = getTickCount()
    else
        return
    end
    local pickupsLeft = {}
    for i=1, #info.spawnpoints do
        local spawnpoint = info.spawnpoints[i]
        if spawnpoint and not (spawnpoint.wasCollected) then
            pickupsLeft[#pickupsLeft+1] = spawnpoint
        end
    end
    if #pickupsLeft == 0 then
        oct(gct("You already collected all %s collectibles (total %s).", (string.gsub(theType, "_", " ")), info.total))
        return
    end
    if receivedCollectibles[theType].toggled == false then
        -- Create collectibles
        for i=1, #pickupsLeft do
            local spawnpoint = pickupsLeft[i]
            createOnePickup(theType, spawnpoint.spID, spawnpoint)
        end
        local countCollected = info.total - #pickupsLeft
        oct(gct("You have found %s out of %s %s collectibles so far. Good luck!", countCollected, info.total, (string.gsub(theType, "_", " "))))
        receivedCollectibles[theType].toggled = true
    else
        -- Destroy collectibles
        local countDel = 0
        for pickup, info2 in pairs(spawnedCollectibles) do
            if info2.type == theType then
                destroyElement(pickup)
                countDel = countDel + 1
                spawnedCollectibles[pickup] = nil
            end
        end
        oct(gct("You have hidden %s %s collectible(s).", countDel, (string.gsub(theType, "_", " "))))
        receivedCollectibles[theType].toggled = false
    end
end

local function createCollectibles(initial)
    for theType, info in pairs(receivedCollectibles) do
        if (info.toggled == true) then
            for i=1, #info.spawnpoints do
                local spawnpoint = info.spawnpoints[i]
                if spawnpoint and not (spawnpoint.wasCollected) then
                    createOnePickup(theType, spawnpoint.spID, spawnpoint)
                end
            end
        end
        if (initial == true) then
            if info.toggle_keybind then
                -- outputConsole("Keybind set: "..(string.upper(info.toggle_keybind)))
                bindKey(info.toggle_keybind, "down", function()
                    toggleCollectibles(theType)
                end)
            end
            if info.toggle_command then
                -- outputConsole("Command set: /"..info.toggle_command)
                addCommandHandler(info.toggle_command, function(cmd)
                    toggleCollectibles(theType)
                end, false)
            end
        end
    end
end

local function onPickupHit(thePlayer)
    if thePlayer ~= localPlayer then return end
    if not spawnedCollectibles then return end
    if waitingPickup ~= nil then return end
    if (getElementDimension(localPlayer) ~= getElementDimension(source) or getElementInterior(localPlayer) ~= getElementInterior(source)) then return end
    local collectibleInfo = spawnedCollectibles[source]
    if collectibleInfo then
        -- Client collectible
        waitingPickup = {type = collectibleInfo.type, spID = collectibleInfo.spID, pickup = source}
        triggerServerEvent("collectibles:handlePickedUp", resourceRoot, false, collectibleInfo)
    elseif not isElementLocal(source) then
        -- Server collectible
        triggerServerEvent("collectibles:handlePickedUp", resourceRoot, source, false)
    end
end
addEventHandler("onClientPickupHit", resourceRoot, onPickupHit)

addEventHandler("collectibles:pickupDenied", localPlayer, function(theType, spID)
    if waitingPickup == nil then return end
    if (waitingPickup.type ~= theType or waitingPickup.spID ~= spID) then return end
    waitingPickup = nil
    oct(gct("You can't collect this now."))
end, false)

local function drawCollectible()
    local elapsed = getTickCount() - drawing.startedAt
    if elapsed > 5000 then
        removeEventHandler("onClientRender", root, drawCollectible)
        drawing = nil
        return
    end

    local text_top = drawing.text_top
    local text_bottom = drawing.text_bottom

    local top_text = drawing.text_top_text
    local bottom_text = drawing.text_bottom_text

    local top_font, top_scale, top_alignX, top_alignY, top_color, top_x_left, top_y_top, top_x_right, top_y_bottom, top_outline_color = text_top.font, text_top.scale, text_top.alignX, text_top.alignY, text_top.color, text_top.x_left, text_top.y_top, text_top.x_right, text_top.y_bottom, text_top.outline_color
    local bottom_font, bottom_scale, bottom_alignX, bottom_alignY, bottom_color, bottom_x_left, bottom_y_top, bottom_x_right, bottom_y_bottom, bottom_outline_color = text_bottom.font, text_bottom.scale, text_bottom.alignX, text_bottom.alignY, text_bottom.color, text_bottom.x_left, text_bottom.y_top, text_bottom.x_right, text_bottom.y_bottom, text_bottom.outline_color

    if (top_outline_color) then
        dxDrawText(top_text, top_x_left+1, top_y_top+1, top_x_right + 1, top_y_bottom + 1, top_outline_color, top_scale, top_font, top_alignX, top_alignY, false, false, true, true)
        dxDrawText(top_text, top_x_left+1, top_y_top-1, top_x_right + 1, top_y_bottom - 1, top_outline_color, top_scale, top_font, top_alignX, top_alignY, false, false, true, true)
        dxDrawText(top_text, top_x_left-1, top_y_top+1, top_x_right - 1, top_y_bottom + 1, top_outline_color, top_scale, top_font, top_alignX, top_alignY, false, false, true, true)
        dxDrawText(top_text, top_x_left+1, top_y_top+1, top_x_right - 1, top_y_bottom - 1, top_outline_color, top_scale, top_font, top_alignX, top_alignY, false, false, true, true)
    end
    
    dxDrawText(top_text, top_x_left, top_y_top, top_x_right, top_y_bottom, top_color, top_scale, top_font, top_alignX, top_alignY, false, false, true, true)
    
    if (bottom_outline_color) then
        dxDrawText(bottom_text, bottom_x_left+1, bottom_y_top+1, bottom_x_right + 1, bottom_y_bottom + 1, bottom_outline_color, bottom_scale, bottom_font, bottom_alignX, bottom_alignY, false, false, true, true)
        dxDrawText(bottom_text, bottom_x_left+1, bottom_y_top-1, bottom_x_right + 1, bottom_y_bottom - 1, bottom_outline_color, bottom_scale, bottom_font, bottom_alignX, bottom_alignY, false, false, true, true)
        dxDrawText(bottom_text, bottom_x_left-1, bottom_y_top+1, bottom_x_right - 1, bottom_y_bottom + 1, bottom_outline_color, bottom_scale, bottom_font, bottom_alignX, bottom_alignY, false, false, true, true)
        dxDrawText(bottom_text, bottom_x_left+1, bottom_y_top+1, bottom_x_right - 1, bottom_y_bottom - 1, bottom_outline_color, bottom_scale, bottom_font, bottom_alignX, bottom_alignY, false, false, true, true)
    end

    dxDrawText(bottom_text, bottom_x_left, bottom_y_top, bottom_x_right, bottom_y_bottom, bottom_color, bottom_scale, bottom_font, bottom_alignX, bottom_alignY, false, false, true, true)
end

local function getDefaultOrCustomStyle(theType)
    local text_top, text_bottom
    if type(DRAWING_STYLES.DEFAULT)~="table" then
        outputDebugMsg("Failed to find default drawing style.", "ERROR")
    else
        local default = DRAWING_STYLES.DEFAULT
        local custom = DRAWING_STYLES.CUSTOM or {}
        custom = custom[theType] or {}
        local custom_top, custom_bottom = custom["text_top"], custom["text_bottom"]
        if custom_top then
            text_top = custom_top
        else
            text_top = default.text_top
        end
        if custom_bottom then
            text_bottom = custom_bottom
        else
            text_bottom = default.text_bottom
        end
    end
    return text_top, text_bottom
end

local function actionOnPickedUp(theType, collected, total, visualFx)
    local sound = visualFx.sound
    local sound_volume = visualFx.sound_volume
    if sound then
        local soundElement = playSound(sound, false)
        if not soundElement then
            outputDebugMsg("Failed to play sound '" .. sound .. "'.", "ERROR")
        else
            setSoundVolume(soundElement, sound_volume)
        end
    end
    local text_top, text_bottom = getDefaultOrCustomStyle(theType)
    if text_top then
        local notDrawing = (drawing == nil)
        drawing = {
            startedAt = getTickCount(),
            text_top = text_top,
            text_top_text = text_top.text:format(string.gsub(theType, "_", " ")),
            text_bottom = text_bottom,
            text_bottom_text = text_bottom.text:format(collected, total),
        }
        if (notDrawing == true) then
            addEventHandler("onClientRender", root, drawCollectible)
        end
    end

    if waitingPickup and waitingPickup.type == theType then
        local theIndex
        for i=1, #receivedCollectibles[theType].spawnpoints do
            local sp = receivedCollectibles[theType].spawnpoints[i]
            if sp and sp.spID == waitingPickup.spID then
                theIndex = i
                break
            end
        end
        if theIndex then
            table.remove(receivedCollectibles[theType].spawnpoints, theIndex)
        else
            outputDebugMsg("Failed to find spawnpoint ID '" .. waitingPickup.spID .. "' of type '" .. theType .. "'.", "ERROR")
        end
        -- Destroy the pickup on the client
        if not isElement(waitingPickup.pickup) then
            outputDebugMsg("Pickup element invalid.", "ERROR")
            iprint(waitingPickup)
        else
            destroyElement(waitingPickup.pickup)
            spawnedCollectibles[waitingPickup.pickup] = nil
        end
        waitingPickup = nil
    end
end
addEventHandler("collectibles:onCollectVisuals", localPlayer, actionOnPickedUp, false)

addEventHandler("collectibles:receive", localPlayer, function(list, CONSTANTS_)
    if type(list) ~= "table" then
        return
    end
    if type(CONSTANTS_) ~= "table" then
        return
    end
    receivedCollectibles = list
    CONSTANTS = CONSTANTS_

    local initial = true
    if type(spawnedCollectibles) == "table" then
        initial = false
        for pickup, info in pairs(spawnedCollectibles) do
            destroyElement(pickup)
        end
    end

    spawnedCollectibles = {}
    createCollectibles(initial)

end, false)

addEventHandler("collectibles:despawn", localPlayer, function()
    if type(spawnedCollectibles) ~= "table" then
        return
    end
    for pickup, info in pairs(spawnedCollectibles) do
        destroyElement(pickup)
    end
    spawnedCollectibles = nil
end, false)

addEventHandler("onClientResourceStart", resourceRoot, function()
    triggerLatentServerEvent("collectibles:requestCollectibles", resourceRoot)
end, false)

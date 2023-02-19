--[[
    Author: https://github.com/Fernando-A-Rocha

    Collectible Spawnpoints Randomizer (Client-Side)

    Main command: /crandom
]]
math.randomseed(os.time())
local randomCoords = {}
local cBlips = {}
local cPickups = {}
local iteration = 1
local invisTimer
local SW, SH = guiGetScreenSize()
local numIterations
local startId
local cTypeName
local modelId
local function drawInfo()
    dxDrawText("\n"..cTypeName.."\n"..iteration.."/"..numIterations.."\n(".. math.ceil((iteration*100)/numIterations).."%)", 0, 0, SW, SH, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top")
end
local function savePoints()
    local f = fileCreate("randomCoords.xml")
    if f then
        local str = ""
        local id = startId
        for i, v in ipairs(randomCoords) do
            str = str .. "<spawnpoint type=\""..cTypeName.."\" id=\""..id.."\" model=\""..modelId.."\" x=\""..v[1].."\" y=\""..v[2].."\" z=\""..v[3].."\" />"
            if i ~= #randomCoords then
                str = str .. "\n"
            end
            id = id + 1
        end
        fileWrite(f, str)
        fileClose(f)
        outputChatBox("Saved " .. iteration .. " '"..cTypeName.."' spawnpoints to randomCoords.xml", 0, 255, 0)
    else
        outputChatBox("Failed to save randomCoords.xml", 255, 0, 0)
    end
    iteration = 1
    fadeCamera(true, 1)
    removeEventHandler("onClientRender", root, drawInfo)
    setElementFrozen(localPlayer, false)
end
local function getARandomCoord(minX, maxX, minY, maxY, minZ, maxZ, cTypeName)
    local rx = math.random(minX+3001, maxX+3001)-1
    rx = rx - 3000
    local ry = math.random(minY+3001, maxY+3001)-1
    ry = ry - 3000
    setElementPosition(localPlayer, rx, ry, 0)
    setTimer(function()
        local px, py, pz = getElementPosition(localPlayer)
        local z = getGroundPosition(px, py, pz+1000)
        if z then
            if (z < minZ or z > maxZ) or (not isLineOfSightClear(px, py, z+1, px+0.5, py-0.5, z+1.5, true, false, false, true, false, false, false)) then
                getARandomCoord(minX, maxX, minY, maxY, minZ, maxZ, cTypeName)
                return
            end
            z = z + 1
            randomCoords[iteration] = {px, py, z}
            -- outputChatBox("("..iteration.."/"..numIterations..")#ffffff " .. px .. ", " .. py .. ", " .. z, 255, 255, 0, true)
            cBlips[createBlip(px, py, z, 0, 2, 255, 0, 0, 255, 0, 99999)] = true
            cPickups[createPickup(px, py, z, 3, modelId)] = true
            if iteration == numIterations then
                savePoints()
                return
            else
                iteration = iteration + 1
                getARandomCoord(minX, maxX, minY, maxY, minZ, maxZ, cTypeName)
            end
        else
            outputChatBox("Failed to getGroundPosition", 255, 0, 0)
        end
    end, 50, 1)
end
addCommandHandler("crandom", function(cmd, minX, maxX, minY, maxY, minZ, maxZ, numIterations_, cTypeName_, modelId_, startId_)
    outputChatBox("/"..cmd.." [minX] [maxX] [minY] [maxY] [minZ] [maxZ] [number of points] [collectible type name] [pickup object id] [start spawnpoint id]", 255, 195, 15)
    randomCoords = {}
    iteration = 1
    numIterations = tonumber(numIterations_) or 50
    cTypeName = cTypeName_ or ("NewCollectible"..math.random(1, 999))
    modelId = modelId_ or 1276
    startId = startId_ or 1
    for blip, _  in pairs(cBlips) do
        destroyElement(blip)
    end
    cBlips = {}
    for pickup, _ in pairs(cPickups) do
        destroyElement(pickup)
    end
    cPickups = {}
    fadeCamera(false, 0)
    addEventHandler("onClientRender", root, drawInfo)
    setElementFrozen(localPlayer, true)
    getARandomCoord(
        tonumber(minX) or -3000,
        tonumber(maxX) or 3000,
        tonumber(minY) or -3000,
        tonumber(maxY) or 3000,
        tonumber(minZ) or 0,
        tonumber(maxZ) or 200
    )
end, false)
addCommandHandler("crandomtp", function()
    local it
    if iteration == 1 then
        it = randomCoords[1]
        if not it then
            outputChatBox("No coords to teleport to", 255, 0, 0)
            return
        end
    else
        it = randomCoords[iteration]
        if not it then
            iteration = 1
            it = randomCoords[iteration]
        end
    end
    local x,y,z = unpack(it)
    if isTimer(invisTimer) then killTimer(invisTimer) end
    setElementAlpha(localPlayer, 0)
    invisTimer = setTimer(function()
        setElementAlpha(localPlayer, 255)
    end, 10000, 1)
    setElementPosition(localPlayer, x, y, z)
    outputChatBox("("..iteration..")#ffffff " .. x .. ", " .. y .. ", " .. z, 0, 255, 255, true)
    iteration = iteration + 1
end)
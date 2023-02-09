--[[
    Author: https://github.com/Fernando-A-Rocha

    Example Implementation (Client-Side)
]]
addEvent("collectibles-gui:showStats", true)
local SW, SH = guiGetScreenSize()
local window = nil
local function showCollectibleStats(counts)
    local sCounts, cCounts = counts.server, counts.client
    showCursor(true)
    if isElement(window) then destroyElement(window) end
    local WW, WH = 400, 300
    window = guiCreateWindow(SW/2-WW/2, SH/2-WH/2, WW, WH, "Collectible Stats", false)

    local GX, GY, GW, GH = 5, 25, WW-(5*2), WH-(20*2)-(35)
    local tabPanel, tabClient, tabServer
    local c = 0
    for theType, v in pairs(sCounts) do
        for spID, pickup in pairs(v.spawnedPickups) do
            c = c + 1
        end
    end
    if c > 0 then
        tabPanel = guiCreateTabPanel(0, 20, WW, WH-(20*2)-(35), false, window)
        tabClient = guiCreateTab("Personal", tabPanel)
        tabServer = guiCreateTab("Special", tabPanel)
        GX, GY = 0, 0
        GW, GH = guiGetSize(tabPanel, false)
        GH = GH - 20
    end

    local function addCollectibleRow(grid, theType, v)
        local row = guiGridListAddRow(grid)
        guiGridListSetItemText(grid, row, 1, theType, false, false)
        guiGridListSetItemText(grid, row, 2, v.count, false, true)
        guiGridListSetItemText(grid, row, 3, v.total, false, true)
        if v.count == v.total then
            guiGridListSetItemColor(grid, row, 1, 0, 255, 0)
        else
            guiGridListSetItemColor(grid, row, 1, 255, 255, 0)
        end
    end

    local gridClient
    if tabClient then
        gridClient = guiCreateGridList(GX, GY, GW, GH, false, tabClient)
    else
        gridClient = guiCreateGridList(GX, GY, GW, GH, false, window)
    end
    guiGridListAddColumn(gridClient, "Name", 0.55)
    guiGridListAddColumn(gridClient, "Found", 0.2)
    guiGridListAddColumn(gridClient, "Total", 0.2)
    for theType, v in pairs(cCounts) do
        addCollectibleRow(gridClient, theType, v)
    end

    if tabServer then
        local gridServer = guiCreateGridList(GX, GY, GW, GH, false, tabServer)
        guiGridListAddColumn(gridServer, "Name", 0.55)
        guiGridListAddColumn(gridServer, "Found", 0.2)
        guiGridListAddColumn(gridServer, "Total", 0.2)
        for theType, v in pairs(sCounts) do
            addCollectibleRow(gridServer, theType, v)
        end
    end

    local closeButton = guiCreateButton(0, WH-42, WW, 30, "Close", false, window)
    addEventHandler("onClientGUIClick", closeButton, function()
        showCursor(false)
        destroyElement(window)
        window = nil
    end, false)
end
addEventHandler("collectibles-gui:showStats", localPlayer, showCollectibleStats, false)
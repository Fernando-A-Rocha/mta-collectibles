--[[
    Author: https://github.com/Fernando-A-Rocha

    Collectibles - Settings (Server)
]]

--[[
    ... CUSTOMIZABLE CONSTANTS ...............................................................
]]
CONSTANTS = {

    --[[
        Admin commands
    --]]
    COMMANDS = {
        SPAWN = "cspawn",
        DESTROY = "cdestroy",
        RESETPLAYER = "cresetplayer",
        CREATESPAWN = "ccreatesp",
        REMOVESPAWN = "cremovesp",

        -- For the 'editor' scripts (Optional):
        EDITOR = "ceditor",
        SPAWNPOINTS = "cspawnpoints",
    },

    --[[
        Misc. constants
    ]]
    COLLECTIBLES_FILE = "collectibles.xml",
    STRINGS_FILE = "strings.json",
    BACKUPS_DIRECTORY = "backups/",
}

--[[
    ... CUSTOMIZABLE FUNCTIONS ...............................................................
]]
local preventPicking = {}

--- **(Exported)**
--
-- PS: Valid player account check is elsewhere in the code already
function canCollectPickup(player, account, theType)
    assert(isElement(player) and getElementType(player)=="player", "Bad argument @ canCollectPickup (player expected, got " .. type(player) .. ")")
    return (preventPicking[player] == nil)
end

--- **(Exported)**
function setPlayerPreventPicking(player, interval)
    assert(type(interval) == "number", "Bad argument @ setPlayerPreventPicking (number expected, got " .. type(interval) .. ")")
    assert(interval > 50, "Bad argument @ setPlayerPreventPicking (interval must be greater than 50ms)")
    if isTimer(preventPicking[player]) then killTimer(preventPicking[player]) end
    preventPicking[player] = setTimer(function() preventPicking[player] = nil end, interval, 1)
    return true
end

--- **(Exported)**
function canAdminCollectibles(player)
    assert(isElement(player) and getElementType(player)=="player", "Bad argument @ canAdminCollectibles (player expected, got " .. type(player) .. ")")
    local account = getPlayerAccount(player)
    if (not account) or isGuestAccount(account) then
        return false
    end
    local accountName = getAccountName(account)
    return isObjectInACLGroup("user." .. accountName, aclGetGroup("Admin"))
end
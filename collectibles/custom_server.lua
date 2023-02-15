--[[
    Author: https://github.com/Fernando-A-Rocha

    Collectibles - Custom (Server)
]]

--[[
    ... CUSTOMIZABLE CONSTANTS ...............................................................
]]
CONSTANTS = {

    --[[
        Customizable admin commands
    --]]
    COMMANDS = {
        SPAWN = "spawncollectibles",
        DESTROY = "destroycollectibles",
        RESETPLAYER = "resetplayercollectibles",

        -- For the 'editor' scripts (Optional):
        ADMIN = "admincollectibles",
        SPAWNPOINTS = "collectiblespawns",
    },

    --[[
        Customizable texts (translation possible)
    --]]
    STRINGS = {
        -- Shared:
        ["command_syntax"] = {value = "SYNTAX: /%s %s", rgb={255,255,255}},
        ["ask_to_wait"] = {value = "Please wait a bit before doing this again.", rgb={200,200,200}},
        ["cant_pickup"] = {value="You can't collect this now.", rgb={255, 55, 55}},

        -- Client only:
        ["cant_toggle"] = {value="You can't toggle collectibles now.", rgb={255, 0, 0}},
        ["already_collected"] = {value="You already collected all %s collectibles (total %s).", rgb={255, 0, 0}},
        ["toggle_on"] = {value="You have found %s out of %s %s collectibles so far. Good luck!", rgb={255, 255, 255}},
        ["toggle_off"] = {value="You have hidden %s %s collectible(s).", rgb={255, 255, 255}},
        ["respawned"] = {value="%s collectible #%s has been respawned.", rgb={255, 255, 255}},
        ["reward_money"] = {value="You have earned $%s for collecting this %s.", rgb={55, 255, 55}},

        -- Server only:
        ["admin_no_permission"] = {value="You don't have permission to do this.", rgb={255, 55, 55}},
        ["admin_count_spawned"] = {value="There are currently %s %s collectibles spawned.", rgb={255, 55, 55}},
        ["admin_spawned"] = {value="You have spawned %s %s collectibles on the server.", rgb={5, 255, 5}},
        ["admin_destroyed"] = {value="You have destroyed the existing %s %s collectibles.", rgb={5, 255, 5}},
        ["admin_invalid_collectible_type"] = {value="Collectible type '%s' does not exist.", rgb={255, 0, 0}},
        ["admin_invalid_account_id"] = {value="User account ID %s does not exist.", rgb={255, 0, 0}},
        ["admin_reset_success"] = {value="You have reset and respawned %s client collectibles for %s (ID: %s).", rgb={5, 255, 5}},
        ["admin_reset_success_player"] = {value="An admin has reset and respawned your collectibles (%s).", rgb={88, 255, 88}},
    },
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
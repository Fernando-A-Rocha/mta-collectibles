--[[
    Author: https://github.com/Fernando-A-Rocha

    Collectibles - Custom (Client)
]]

--[[
    Customizable dxDraw style for any collectible types
    
    Most of these settings are not validated, so be careful and test your changes!!
]]

local SW, SH = guiGetScreenSize()

CUSTOM_DRAWING = {
    DEFAULT = {
        ["text_top"] = {
            text = "%s", -- replaced with collectible type name
            font = "pricedown",
            scale = 2,
            alignX = "center",
            alignY = "center",
            color = tocolor(250, 189, 255, 255),
            x_left = 0,
            y_top = 0,
            x_right = SW,
            y_bottom = (SH*0.6)-120,
            outline_color = tocolor(0, 0, 0, 200), -- optional
        },
        ["text_bottom"] = {
            text = "%s of %s", -- replaced with collected count and total count
            font = "pricedown",
            scale = 2,
            alignX = "center",
            alignY = "center",
            color = tocolor(255, 255, 255, 255),
            x_left = 0,
            y_top = 0,
            x_right = SW,
            y_bottom = (SH*0.6),
            outline_color = tocolor(0, 0, 0, 200), -- optional
        },
    },
    CUSTOM = {

        -- Use exact collectible type name as key, and set the same parameters as the default
        ["Hidden_Package"] = {
            ["text_top"] = {
                text = "%s", -- replaced with collectible type name
                font = "pricedown",
                scale = 3,
                alignX = "center",
                alignY = "center",
                color = tocolor(255, 157, 0, 255),
                x_left = 0,
                y_top = 0,
                x_right = SW,
                y_bottom = (SH*0.6)-160,
                outline_color = tocolor(0, 0, 0, 200), -- optional
            },
            ["text_bottom"] = {
                text = "%s of %s", -- replaced with collected count and total count
                font = "pricedown",
                scale = 3,
                alignX = "center",
                alignY = "center",
                color = tocolor(255, 255, 255, 255),
                x_left = 0,
                y_top = 0,
                x_right = SW,
                y_bottom = (SH*0.6),
                outline_color = tocolor(0, 0, 0, 200), -- optional
            },
        },
    }
}
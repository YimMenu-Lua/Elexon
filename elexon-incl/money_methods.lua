
--[[ this is an example]]
return function(recoverymenu, NightClub) -- recoverymenu is the parent menu for Money Methods, NightClub is the Nightclub money loop tab
if not recoverymenu or not NightClub then -- check for nil menus
    log.error("money_methods: menus are nil")
    return
end

------------------------------------------------------------------------------
--[[ Nightclub TP Function ]]--
------------------------------------------------------------------------------


-- nightclub locations table
local nightclubs = {
    [0] = { name = "Mission Row",        x = 345.7519,  y = -978.8848, z = 29.2681 },
    [1] = { name = "Strawberry",         x = -120.906,  y = -1260.49,  z = 29.2088 },
    [2] = { name = "West Vinewood",      x = 5.53709,   y = 221.35,    z = 107.6566 },
    [3] = { name = "Cypress Flats",      x = 871.47,    y = -2099.57,  z = 30.3768 },
    [4] = { name = "LSIA",               x = -676.625,  y = -2458.15,  z = 13.8444 },
    [5] = { name = "Elysian Island",     x = 195.534,   y = -3168.88,  z = 5.7903 },
    [6] = { name = "Downtown Vinewood",  x = 373.05,    y = 252.13,    z = 102.9097 },
    [7] = { name = "Del Perro",          x = -1283.38,  y = -649.916,  z = 26.5198 },
    [8] = { name = "Vespucci Canals",    x = -1174.85,  y = -1152.3,   z = 5.56128 },
    [9] = { name = "La Mesa",            x = 757.009,   y = -1332.32,  z = 27.1802 }
}

-- Helper functions to get nightclub offsets
local function GetOnlineWorkOffset()
    return (1853988 + 1 + self.get_id() + 267)
end
-- Function to get Nightclub Index
function GetNightClubIndex()
    local raw = stats.get_int(MPX() .. "CLUB_PROPERTY_ID")

    if raw == -1 then
        return -1
    end

    log.debug("Nightclub raw value = " .. raw)
        -- convert signed int to unsigned
    local unsigned = raw
    if unsigned < 0 then
        unsigned = unsigned + 0x100000000
    end

    -- extract bits 28–31
    local index = math.floor(unsigned / 0x10000000) % 16

        -- debug log
    log.debug(string.format(
        "Nightclub raw=%d index=%d",
        raw,
        index
    ))

    return index
end

function tpnc()
    if not network.is_session_started() then
        return
    end

    local index = GetNightClubIndex()

    if index == -1 then
        gui.show_message("Nightclub TP", "You do not own a nightclub.")
        return
    end

    local info = nightclubs[index]

    if not info then
        gui.show_message("Nightclub TP", "Unknown nightclub index: " .. index)
        return
    end

    gui.show_message("Nightclub TP", "Teleporting to " .. info.name)

    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(
        PLAYER.PLAYER_PED_ID(),
        info.x,
        info.y,
        info.z,
        false, false, false
    )
end


--[[ Nightclub Money Loop ]]

    SafeAmount = 250000  -- Max nightclub safe amount
    SafeCapacity = 23769 -- NIGHTCLUBMAXSAFEVALUE
    IncomeStart = 23746 -- NIGHTCLUBINCOMEUPTOPOP5
    IncomeEnd = 23765 -- NIGHTCLUBINCOMEUPTOPOP100
    NLCl = 206 + 32 + 19 + 1 -- Local index for triggering nightclub payout in am_mp_nightclub
    
    NCRSCB = NightClub:add_checkbox("Enable Nightclub money loop")
    script.register_looped("nightclubremotelooptest", function(script)
        script:yield()
        if NCRSCB:is_enabled() == true then
            -- Calculate safe value global (adjusted for better accuracy)
           SafeValue = 1845250 + self.get_id() + 260 + 364 + 5
            -- Set income globals to high value for max earnings
            for i = IncomeStart, IncomeEnd do
                globals.set_int(262145 + i, SafeAmount)
            end
            -- Set safe capacity
            globals.set_int(262145 + SafeCapacity, SafeAmount)
            -- Max popularity
            stats.set_int(MPX() .. "CLUB_POPULARITY", 1000)
            -- Reset pay time
            stats.set_int(MPX() .. "CLUB_PAY_TIME_LEFT", -1)
            
            
            -- Set safe value and trigger payout
            globals.set_int(SafeValue, SafeAmount)
            locals.set_int("am_mp_nightclub", NLCl, 1)
            
            -- Clear some globals to prevent issues
            globals.set_int(4516902, 0)
            globals.set_int(4516903, 0)
            globals.set_int(4516904, 0)
            
            script:sleep(2500)  -- 2,5 second delay before next loop seems to work fine
        end
    end)
    
    NightClub:add_separator()

    NightClub:add_button("TP to Nightclub", function()
        tpnc()
    end)

    NightClub:add_sameline()

    NightClub:add_button("TP to Nightclub Safe", function()
        tpnc_safe()
    end)



end
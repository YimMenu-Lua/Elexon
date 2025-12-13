return function(parent_menu)
    if not parent_menu then
        log.error("Parent menu is nil in kd_editor")
        return
    end

    -- KD Editor root tab (child of Recovery)
    local KDS = parent_menu:add_tab("KD Editor")

    local function show_kd_message(title, kd, kills, deaths, frozen)
        gui.show_message(
            title,
            string.format(
                "%sKD: %.2f\nKills: %d\nDeaths: %d",
                frozen and "(Frozen)\n" or "",
                kd,
                kills,
                deaths
            )
        )
    end

    -- Custom KD
    local TypeKd = KDS:add_tab("Custom KD")
    TypeKd:add_text("Set your KD to:")

    local KdValue = TypeKd:add_input_float("Set your KD")

    TypeKd:add_button("Set KD", function()
        local kd = KdValue:get_value()
        local base = 1000000

        local kills, deaths
        if kd == 0 then
            kills = 0
            deaths = base
        else
            kills = math.floor(kd * base)
            deaths = base
        end

        stats.set_int("MPPLY_KILLS_PLAYERS", kills)
        stats.set_int("MPPLY_DEATHS_PLAYER", deaths)

        show_kd_message("KD Change", kd, kills, deaths, false)
    end)

    -- Kills / Deaths Editor
    local KillDeathEdit = KDS:add_tab("KILLS/DEATHS EDITOR")
    local KillValue = KillDeathEdit:add_input_int("Kills")
    local DeathValue = KillDeathEdit:add_input_int("Deaths")

    KillDeathEdit:add_button("Set Kills & Deaths", function()
        local kills = KillValue:get_value()
        local deaths = DeathValue:get_value()
        if deaths <= 0 then deaths = 1 end

        local kd = kills / deaths

        stats.set_int("MPPLY_KILLS_PLAYERS", kills)
        stats.set_int("MPPLY_DEATHS_PLAYER", deaths)

        show_kd_message("KD Change", kd, kills, deaths, false)
    end)

    -- Frozen KD
    local FrozenKD = KDS:add_tab("Frozen K/D Editor")
    FrozenKD:add_text("Set your frozen K/D to:")
    local FrozenKdValue = FrozenKD:add_input_float("Frozen KD")

    FrozenKD:add_button("FROZEN CUSTOM K/D", function()
        local kd = FrozenKdValue:get_value()
        local base = 100000

        local kills, deaths
        if kd == 0 then
            kills = 0
            deaths = base
        else
            kills = math.floor(kd * base)
            deaths = base
        end

        stats.set_int("MPPLY_KILLS_PLAYERS", kills)
        stats.set_int("MPPLY_DEATHS_PLAYER", deaths)

        show_kd_message("KD Change", kd, kills, deaths, true)
    end)
end

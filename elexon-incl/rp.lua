-- Compressed RP table for low ranks as a CSV string
local levelsCSV = "0,800,2100,3800,6100,9500,12500,16000,19800,24000,28500,33400,38700,44200,50200,56400,63000,69900,77100,84700,92500,100700,109200,118000,127100,136500,146200,156200,166500,177100,188000,199200,210700,222400,234500,246800,259400,272300,285500,299000,312700,326800,341000,355600,370500,385600,401000,416600,432600,448800,465200"

-- Parse CSV into a Lua table at runtime
local baseLevels = {}
for v in string.gmatch(levelsCSV, "[^,]+") do
    table.insert(baseLevels, tonumber(v))
end

-- Function to get RP for any rank 1-8000
local function getRPForRank(rank)
    if rank <= #baseLevels then
        return baseLevels[rank]
    end
    -- Quadratic approximation for high ranks
    return math.floor(25*rank^2 + 23575*rank - 1023150)
end

-- Helper function to set RP for player or crew
local function setRankRP(levelValue, isCrew, changeSession)
    if levelValue <= 0 or levelValue > 8000 then
        gui.show_message("ERROR", "Rank "..levelValue.." is out of range (1-8000).")
        return
    end

    local rp = getRPForRank(levelValue)

    if isCrew then
        for i = 0, 4 do
            stats.set_int("MPPLY_CREW_LOCAL_XP_"..i, rp)
        end
        gui.show_message("Crew Rank Editor", "Your Crew Rank is now "..levelValue)
    else
        stats.set_int(MPX() .. "CHAR_SET_RP_GIFT_ADMIN", rp)
        local msg = "Your rank is set to "..levelValue
        if changeSession then
            log.debug("changing session...")

            -- Search new session
            globals.set_int(1575015, 11) -- 1, 11, 6, 10, 3, 2 - newPublic, inviteOnly, closedFriends, solo, crew, closedCrew -- UC
            globals.set_int(1574589, 1)
            globals.set_int(1574589, 0)
        end
        gui.show_message("Rank editor", msg)
    end
end

-- Rank Editor Tab
RankEditor = ranksmenu:add_tab("Custom Rank Editor")
RankEditor:add_text("Set your rank to:")
local rankLevel = RankEditor:add_input_int("rank")

RankEditor:add_button("Set rank and change session", function()
    setRankRP(rankLevel:get_value(), false, true)
end)

-- Crew Rank Editor Tab
CrewRankEditor = ranksmenu:add_tab("Crew Rank Editor")
CrewRankEditor:add_text("Set your Rank to:")
local crewRankLevel = CrewRankEditor:add_input_int("Crew Rank")

CrewRankEditor:add_button("set Crew Rank and change session", function()
    setRankRP(crewRankLevel:get_value(), false, true)
end)
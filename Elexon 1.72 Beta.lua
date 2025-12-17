local function MPX()
	local ONLINE = stats.get_int("MPPLY_LAST_MP_CHAR")
	if ONLINE == 0 then
		return "MP0_"
	elseif ONLINE == 1 then
		return "MP1_"
	else
		return "MP0_"
	end
end

player_male = (ENTITY.GET_ENTITY_MODEL(PLAYER.PLAYER_PED_ID()) == joaat("mp_m_freemode_01"))
player_female = (ENTITY.GET_ENTITY_MODEL(PLAYER.PLAYER_PED_ID()) == joaat("mp_m_freemode_0"))

-- Validate API globals
if not ENTITY then
    print("ENTITY API not found — you might be on an unsupported YimMenu version!")
    return
end

FMISSIONC = "fm_mission_controller"
FMISSIONC2020 = "fm_mission_controller_2020"
HISLANDP = "heist_island_planning"

gui.show_message("TCC & RROCAS", "Love you internet people <3")


log.warning("Enjoy Elexon :D")

    ScriptMainMenu = gui.get_tab("Elexon made by TCC & RROCAS")
    ScriptMainMenu:add_text("Elexon 1.72 Beta")

    recoverymenu = ScriptMainMenu:add_tab("Recovery Menu")
    VehiclesMenu = ScriptMainMenu:add_tab("Vehicle Menu")
    settings = ScriptMainMenu:add_tab("Script Settings")
    settings:add_text("No settings available yet.")

    --[[ will add submenu for stats like KD later and move it to recovery menu ]]


    

require("elexon-incl.kd_editor")(recoverymenu)
require("elexon-incl.rp")(recoverymenu)




--[[ Removed Vehicles Auto-Loader(on session start) ]]
local removed_vehicles = require("elexon-incl.removed_vehicles") -- load the removed vehicles list

local removed_vehicles_triggered = false

script.register_looped("removed_vehicles_auto", function(script)
    script:yield()
    if network.is_session_started() and not removed_vehicles_triggered then
        log.info("[Load Removed Vehicles][DEBUG] Starting auto-trigger for removed vehicles")
        for _, offset in ipairs(removed_vehicles) do -- iterate through each offset
            print("[Load Removed Vehicles][DEBUG] Setting global: " .. tostring(262145 + offset))
            globals.set_int(262145 + offset, 1) -- set the global to 1
        end
        log.info("[Load Removed Vehicles][DEBUG] Finished auto-trigger")
        removed_vehicles_triggered = true
    end
end)


--[[ Missions Menu seems unnecessary for the scripts purpose atm ]]

    MissionEdit = ScriptMainMenu:add_tab("Missions Menu")

    MissionEdit:add_button("Remove dax fooligan missions", function()
	stats.set_int(MPX() .. "XM22JUGGALOWORKCDTIMER", -1)
end)

MissionEdit:add_button("Remove CEO/MC Cooldown", function()
	stats.set_int("MPPLY_VIPGAMEPLAYDISABLEDTIMER", 0)
end)

MissionEdit:add_button("Skip yacht missionsS", function()
	stats.set_int(MPX() .. "YACHT_MISSION_PROG", 0)
	stats.set_int(MPX() .. "YACHT_MISSION_FLOW", 21845)
	stats.set_int(MPX() .. "CASINO_DECORATION_GIFT_1", -1)
end)

MissionEdit:add_separator()


-- MP Helper
local function mp()
    return "MP" .. stats.get_int("MPPLY_LAST_MP_CHAR") .. "_"
end

local packed_unlocks = require("elexon-incl.unlocks")
local stat_unlocks   = require("elexon-incl.unlocks2")

--[[ Generic Unlocker Menu ]]
    LatestUnlock = recoverymenu:add_tab("Unlocker Menu")
-- Removed LCSM Unlocker as it had no functionality. will add into generic unlocks later when bools are known

local unlocks_config = require("elexon-incl.unlocks")

function unlock_packed_bools(from, to)
    for i = from, to do
        stats.set_packed_stat_bool(i, true)
        -- log.info("[DEBUG] Unlocking stat ID:", i) -- prints to YimMenu console. commented out to stop spam and clogging of logs
    end
end

LatestUnlock:add_button("Unlock Everything", function()
    log.info("[DEBUG] Starting to Unlock Everything")

    -- packed bools
    for _, range in ipairs(unlocks_config.generic) do
        unlock_packed_bools(range.from, range.to)
    end

    local gender_ranges = player_male and unlocks_config.male or unlocks_config.female
    for _, range in ipairs(gender_ranges) do
        unlock_packed_bools(range.from, range.to)
    end

    -- normal stats
    stat_unlocks.apply(MPX)

    log.info("[DEBUG] Finished Unlock Everything")
end)



--[[ Risky Money Methods 

-- Hashes might be wrong, nothing gets added in game but logs show its triggered

    local TransactionManager <const> = {};
    TransactionManager.__index = TransactionManager
    
    function TransactionManager.new()
        local instance = setmetatable({}, TransactionManager);
    
        instance.Transactions = {
            {label = "7 MILLION", hash = 0xED97AFC1},
            {label = "3.6 MILLION", hash = 0xB703ED29},
            {label = "3 MILLION", hash = 0x176D9D54},
            {label = "2.5 MILLION", hash = 0x46521174},
            {label = "2.5 MILLION", hash = 0xDBF39508},
            {label = "2 MILLION", hash = 0x8107BB89},
            {label = "2 MILLION", hash = 0x921FCF3C},
            {label = "2 MILLION", hash = 0x4B6A869C},
            {label = "1 MILLION", hash = 0xE9BBC247},
            {label = "1 MILLION", hash = 0x314FB8B0},
            {label = "1 MILLION", hash = 0xBFCBE6B6},
            {label = "680 THOUSAND", hash = 0xACA75AAE},
            {label = "500 THOUSAND", hash = 0x05F2B7EE},
            {label = "310 THOUSAND", hash = 0xEE884170},
            {label = "200 THOUSAND", hash = 0xBA16F44B},
            {label = "200 THOUSAND",  hash = 0x9145F938},
            {label = "200 THOUSAND",    hash = 0xCDCF2380},
            {label = "190 THOUSAND",   hash = 0xFD389995}
        }

        instance.allTriggered = false
    
        return instance;
    end
    
    ---@return Table TransactionList
    function TransactionManager:GetTransactionList()
        return self.Transactions;
    end
    
    ---@return Int32 character
    function TransactionManager:GetCharacter()
        local _, char = STATS.STAT_GET_INT(joaat("MPPLY_LAST_MP_CHAR"), 0, 1)
        return tonumber(char);
    end
    
    ---@param Int32 hash 
    ---@param Int32 category
    ---@return Int32 price
    function TransactionManager:GetPrice(hash)
        return tonumber(NETSHOPPING.NET_GAMESERVER_GET_PRICE(hash, 0x57DE404E, true))
    end
    
     
    ---@param Int32 hash 
    ---@param? Int32 amount 
    function TransactionManager:TriggerTransaction(item_hash)
        script.execute_as_script("shop_controller", function()
            if NETSHOPPING.NET_GAMESERVER_BASKET_IS_ACTIVE() then
                NETSHOPPING.NET_GAMESERVER_BASKET_END()
            end
    
            local price = self:GetPrice(item_hash)
            log.info("[DEBUG] Price for hash " .. string.format("0x%X", item_hash) .. ": " .. tostring(price))
            local status, tranny_id = NETSHOPPING.NET_GAMESERVER_BEGIN_SERVICE(-1, 0x57DE404E, item_hash, 0x562592BB, price, 2)
            log.info("[DEBUG] Begin service status: " .. tostring(status) .. ", tranny_id: " .. tostring(tranny_id))
            if status then
                NETSHOPPING.NET_GAMESERVER_CHECKOUT_START(tranny_id)
                log.info("[DEBUG] Checkout started for tranny_id: " .. tostring(tranny_id))
            else
                log.warning("[DEBUG] Failed to begin service for hash " .. string.format("0x%X", item_hash))
            end
        end)
    end
    
    function TransactionManager:Init()
        local sub_transactionL  = recoverymenu:add_tab("Risky Money Method(Patched)")

        sub_transactionL:add_button("Trigger All Money Transactions(PATCHED)", function()
            if self.allTriggered then
                gui.show_message("Already used this recently..", "Wait a bit before Using again.")
                return
            end
            log.info("[DEBUG] Starting to trigger all money transactions")
            for _, stealth in ipairs(self:GetTransactionList()) do
                log.info("[DEBUG] Triggering transaction: " .. stealth.label)
                self:TriggerTransaction(stealth.hash)
            end
            log.info("[DEBUG] Finished triggering all money transactions")
            gui.show_message("Transactions Triggered", "All money transactions have been triggered.")
            self.allTriggered = true
        end)
    end
    
    
    TransactionManager.new():Init()

    
]]

--[[ Nightclub Money Loop & TP Functions ]]

-- Nightclub property info table
local NightclubPropertyInfo = {
    [1]  = {name = "La Mesa Nightclub",           coords = {x = 757.009,   y =  -1332.32,  z = 27.1802 }},
    [2]  = {name = "Mission Row Nightclub",       coords = {x = 345.7519,  y =  -978.8848, z = 29.2681 }},
    [3]  = {name = "Strawberry Nightclub",        coords = {x = -120.906,  y =  -1260.49,  z = 29.2088 }},
    [4]  = {name = "West Vinewood Nightclub",     coords = {x = 5.53709,   y =  221.35,    z = 107.6566}},
    [5]  = {name = "Cypress Flats Nightclub",     coords = {x = 871.47,    y =  -2099.57,  z = 30.3768 }},
    [6]  = {name = "LSIA Nightclub",              coords = {x = -676.625,  y =  -2458.15,  z = 13.8444 }},
    [7]  = {name = "Elysian Island Nightclub",    coords = {x = 195.534,   y =  -3168.88,  z = 5.7903  }},
    [8]  = {name = "Downtown Vinewood Nightclub", coords = {x = 373.05,    y =  252.13,    z = 102.9097}},
    [9]  = {name = "Del Perro Nightclub",         coords = {x = -1283.38,  y =  -649.916,  z = 26.5198 }},
    [10] = {name = "Vespucci Canals Nightclub",   coords = {x = -1174.85,  y =  -1152.3,   z = 5.56128 }},
}

-- Helper functions to get nightclub offsets
local function GetOnlineWorkOffset()
    return (1853988 + 1 + self.get_id() + 267)
end

local function GetNightClubOffset()
    return (GetOnlineWorkOffset() + 354)
end

local function GetNightClubPropertyID()
    return globals.get_int(GetNightClubOffset())
end

-- Teleport to Nightclub function(doesnt work rn)

function tpnc()
    local property = GetNightClubPropertyID()
    if property ~= 0  then
        local coords = NightclubPropertyInfo[property].coords
        PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), coords.x, coords.y, coords.z)
    end
end

--[[ Nightclub Money Loop ]]
-- Improved: Increased SafeAmount for higher payouts, adjusted timing for better triggering <AI shit still only gives 1.5k

    NightClubMoney = recoverymenu:add_tab("Nightclub money loop")

    SafeAmount = 250000  -- this is the max amount if its over limit it will trigger silent or non silent transaction errors depending on the 3 globals below in --> Clear some globals to prevent issues
    SafeCapacity = 23769 -- NIGHTCLUBMAXSAFEVALUE
    IncomeStart = 23746 -- NIGHTCLUBINCOMEUPTOPOP5
    IncomeEnd = 23765 -- NIGHTCLUBINCOMEUPTOPOP100
    NLCl = 206 + 32 + 19 + 1 -- Local index for triggering nightclub payout in am_mp_nightclub
    
    NCRSCB = NightClubMoney:add_checkbox("Enable Nightclub money loop")
    script.register_looped("nightclubremotelooptest", function(script)
        script:yield()
        if NCRSCB:is_enabled() == true then
            -- Calculate safe value global (adjusted for better accuracy)
            SafeValue = 1845250 + self.get_id() + 260 + 364 + 5  -- More precise offset for nightclub safe
            
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
            
            script:sleep(1000)  -- Reduced sleep for faster triggering
            
            -- Set safe value and trigger payout
            globals.set_int(SafeValue, SafeAmount)
            locals.set_int("am_mp_nightclub", NLCl, 1)
            
            -- Clear some globals to prevent issues
            globals.set_int(4516902, 0)
            globals.set_int(4516903, 0)
            globals.set_int(4516904, 0)
            
            script:sleep(500)  -- Shorter sleep between loops
        end
    end)
    
    NightClubMoney:add_separator()

    NightClubMoney:add_button("TP to Nightclub", function()
        tpnc()
    end)

    NightClubMoney:add_sameline()

    NightClubMoney:add_button("TP to Nightclub Safe", function()
        PED.SET_PED_COORDS_KEEP_VEHICLE(PLAYER.PLAYER_PED_ID(), -1615.6832, -3015.7546, -75.204994)
    end)



--[[ Report Checker & Editor. might add auto session change for applying Later ]] 

    CheckUrReports = recoverymenu:add_tab("Report Checker & Editor")
local function add_editable_report(label, stat_key)
    local current = stats.get_int(stat_key)
    CheckUrReports:add_text(label .. ": " .. current)
    local input = CheckUrReports:add_input_int("New " .. label)
    input:set_value(current)
    CheckUrReports:add_button("Edit " .. label, function()
        stats.set_int(stat_key, input:get_value())
        gui.show_message("Edited", label .. " set to " .. input:get_value())
    end)
end

add_editable_report("GRIEFING", "MPPLY_GRIEFING")
add_editable_report("EXPLOITING", "MPPLY_EXPLOITS")
add_editable_report("ABUSING BUGS", "MPPLY_GAME_EXPLOITS")
add_editable_report("ANNOYING PEOPLE IN TEXT", "MPPLY_TC_ANNOYINGME")
add_editable_report("HATE SPEECH IN TEXT", "MPPLY_TC_HATE")
add_editable_report("ANNOYING PEOPLE IN VOICE", "MPPLY_VC_ANNOYINGME")
add_editable_report("HATE SPEECH IN VOICE", "MPPLY_VC_HATE")
add_editable_report("OFFENSIVE LANGUAGE", "MPPLY_OFFENSIVE_LANGUAGE")
add_editable_report("OFFENSIVE TAGPLATE", "MPPLY_OFFENSIVE_TAGPLATE")
add_editable_report("OFFENSIVE CONTENT", "MPPLY_OFFENSIVE_UGC")
add_editable_report("BAD CREW NAME", "MPPLY_BAD_CREW_NAME")
add_editable_report("BAD CREW MOTTO", "MPPLY_BAD_CREW_MOTTO")
add_editable_report("BAD CREW STATUS", "MPPLY_BAD_CREW_STATUS")
add_editable_report("BAD CREW EMBLEM", "MPPLY_BAD_CREW_EMBLEM")
CheckUrReports:add_separator()
CheckUrReports:add_text("COMMENDS:")
CheckUrReports:add_separator()
add_editable_report("FRIENDLY", "MPPLY_FRIENDLY")
add_editable_report("HELPFUL", "MPPLY_HELPFUL")



local GARAGE_MENU_DATA    = 176 -- 3A ? 42 ? 71 3A ? 42 ? 71 3A ? 42 ? 71 3A ? 42 ? 71 3A ? 42 ? 71 71 +1
local VEHICLE_REWARD_DATA = 129 -- 3A ? 40 ? 5D ? ? ? 2A +1

local should_run_script = false


--[[ Claim Current Vehicle as Personal Vehicle(PV) ]]

local function IS_VEHICLE_VALID_FOR_PV(vehicle_hash)
    return scr_function.call_script_function("freemode", 0x913BB, "bool", {
        { "int", vehicle_hash }
    })
end

local function GIVE_VEHICLE_REWARD(vehicle_id, data, transaction, garage, slot, state)
    return scr_function.call_script_function("am_mp_vehicle_reward", "GVR", "2D 0C 1E 00 00", "bool", {
        { "int", vehicle_id },
        { "ptr", data },
        { "ptr", transaction },
        { "ptr", garage },
        { "ptr", slot },
        { "ptr", state },
        { "bool", false }, -- ???
        { "bool", true },  -- Set as Last PV
        { "bool", true },  -- Display Cancel Error Message
        { "bool", false }, -- Is Podium Vehicle
        { "int", 0 },      -- ???
        { "int", -1 }      -- ???
    })
end

local function RUN_SCRIPT()
    if not ENTITY.DOES_ENTITY_EXIST(self.get_veh()) then
        should_run_script = false
        return
    end

    local menu_data          = locals.get_pointer("am_mp_vehicle_reward", GARAGE_MENU_DATA)
    local transaction_result = locals.get_pointer("am_mp_vehicle_reward", VEHICLE_REWARD_DATA + 4)
    local garage_id          = locals.get_pointer("am_mp_vehicle_reward", VEHICLE_REWARD_DATA + 5)
    local garage_slot        = locals.get_pointer("am_mp_vehicle_reward", VEHICLE_REWARD_DATA + 6)
    local reward_state       = locals.get_pointer("am_mp_vehicle_reward", VEHICLE_REWARD_DATA + 7)
	
    if GIVE_VEHICLE_REWARD(self.get_veh(), menu_data, transaction_result, garage_id, garage_slot, reward_state) then
        if locals.get_int("am_mp_vehicle_reward", VEHICLE_REWARD_DATA + 7) ~= 3 then
            locals.set_int("am_mp_vehicle_reward", VEHICLE_REWARD_DATA + 4, 0)
            locals.set_int("am_mp_vehicle_reward", VEHICLE_REWARD_DATA + 5, 0)
            locals.set_int("am_mp_vehicle_reward", VEHICLE_REWARD_DATA + 6, 0)
            locals.set_int("am_mp_vehicle_reward", VEHICLE_REWARD_DATA + 7, 0)
            should_run_script = false
        end
    end
end

script.register_looped("Vehicle Reward", function()
    if not script.is_active("am_mp_vehicle_reward") then
        should_run_script = false
        return
    end

    if should_run_script then
        RUN_SCRIPT()
    end
end)

VehiclesMenu:add_button("CLAIM CURRENT VEHICLE AS PV", function()
    script.run_in_fiber(function()
        if network.is_session_started() and script.is_active("freemode") and script.is_active("am_mp_vehicle_reward") then
            if PED.IS_PED_IN_ANY_VEHICLE(self.get_ped(), false) then
                if IS_VEHICLE_VALID_FOR_PV(ENTITY.GET_ENTITY_MODEL(self.get_veh())) then
                    should_run_script = true
                else
                    gui.show_error("Vehicle Reward", "This vehicle cannot be saved as a personal vehicle.")
                end
            else
                gui.show_error("Vehicle Reward", "Please get in a vehicle.")
            end
        else
            gui.show_error("Vehicle Reward", "Cannot give vehicle at the moment. Are you online?")
        end
    end)
end)


----------------------------------------------------------------------
------[[ Credits Section (implemented into settings tab) ]]-----------
----------------------------------------------------------------------

ilovecredits = settings:add_tab("Credits <3")

    TCC = ilovecredits:add_tab("TCC - TheCookieTho")
    TCC:add_text("Elexon Main Developer, Script Writer & Tester")
    TCC:add_text("Reach out to me on Discord @njdergeilomat")

    Rrocas = ilovecredits:add_tab("RROCAS - Rrocas")
    Rrocas:add_text("Elexon Co-Developer, Script Writer & Tester")
    

    SpecialThanks = ilovecredits:add_tab("Special Thanks To:")
    SpecialThanks:add_text("INTRXDUCE - For script base(UTHENSIA)")
    SpecialThanks:add_text("ShinyWasabi - For Claiming Vehicle as PV script")
    SpecialThanks:add_text("Alestarov - For Nightclub money loop & tp functions")
    SpecialThanks:add_text("YimMura & YimMenu Collaborators - For YimMenu API")

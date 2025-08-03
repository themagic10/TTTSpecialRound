if engine.ActiveGamemode() != "terrortown" then return end

util.AddNetworkString("SpecialRoundPreparing")
util.AddNetworkString("SpecialRoundStart")

MagicSpecialRound = {}
MagicSpecialRound.name = "TTT Special Round"
MagicSpecialRound.version = "0.1.1"
MagicSpecialRound.author = "Magic_1_0"
MagicSpecialRound.steamcontact = "https://steamcommunity.com/profiles/76561198196016631" 

MagicSpecialRound.utils = include("special_round_utils.lua")

local specialrounds = {}
local files, _ = file.Find("special_rounds/*.lua", "LUA")
for _, filename in ipairs(files) do
    local specialrnd = include("special_rounds/" .. filename)
    if specialrnd != nil then table.insert(specialrounds, specialrnd) end
end

MagicSpecialRound.isSpecialround = false
MagicSpecialRound.WinnerOfSpecialRound = WIN_NONE -- WIN_NONE     WIN_TRAITOR      WIN_INNOCENT --
local ActiveSpecialRound = nil


local function ChooseRandomSpecialRound()
    return table.Random(specialrounds)
end


local function IsLastRound()
    local roundsLeft = GetGlobalInt("ttt_rounds_left", 100000)
    return roundsLeft <= 1
end

-- mainly for debug
hook.Add( "PlayerSay", "forcespecialroundstart", function( ply, text )
	if ( string.lower( text ) == "!forcespecial" and ply:GetUserGroup() == "superadmin") then
        SetGlobalInt("ttt_rounds_left", 1)
        RunConsoleCommand("ttt_roundrestart")
    end
end )


hook.Add("TTTPrepareRound", "PrepareSpecialRound", function()
    if (IsLastRound()) then
        MagicSpecialRound.isSpecialround = true 
        net.Start("SpecialRoundPreparing")
        net.Broadcast()
    end
end)


hook.Add("TTTBeginRound", "StartSpecialRound", function()
    if MagicSpecialRound.isSpecialround then
        ActiveSpecialRound = ChooseRandomSpecialRound()
        ActiveSpecialRound.begin()
        net.Start("SpecialRoundStart")
        net.WriteString(ActiveSpecialRound.title)
        net.Broadcast()
    end
end)


hook.Add("TTTEndRound", "EndSpecialRound", function()
    if MagicSpecialRound.isSpecialround then
        MagicSpecialRound.isSpecialround = false 
        ActiveSpecialRound.restart()
        ActiveSpecialRound = nil 
    end
end)


-- karma is always disabled on special rounds

hook.Add("TTTKarmaGivePenalty", "DisableKarmaPenaltySpecialRound", function()
    if MagicSpecialRound.isSpecialround then return true end
end)


hook.Add("TTTKarmaGiveReward", "DisableKarmaRewardSpecialRound", function()
    if MagicSpecialRound.isSpecialround then return true end
end)

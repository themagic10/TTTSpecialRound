if engine.ActiveGamemode() ~= "terrortown" then return end

local ipairs = ipairs

util.AddNetworkString("SpecialRoundPreparing")
util.AddNetworkString("SpecialRoundStart")

MagicSpecialRound = {}
MagicSpecialRound.name = "TTT Special Round"
MagicSpecialRound.version = "0.4"
MagicSpecialRound.author = "Magic_1_0"
--maybe leave a comment before sending a friend request to let me know you're not a spammer
MagicSpecialRound.steamcontact = "https://steamcommunity.com/profiles/76561198196016631" 

MagicSpecialRound.utils = include("special_round_utils.lua")

local specialrounds = {}
local files, _ = file.Find("special_rounds/*.lua", "LUA")
for _, filename in ipairs(files) do
    local specialrnd = include("special_rounds/" .. filename)
    if specialrnd ~= nil then table.insert(specialrounds, specialrnd) end
end


-- In case other addons need to know some basic information about the special round --

MagicSpecialRound.isSpecialround = false
MagicSpecialRound.hasAlteredWinCondition = false
MagicSpecialRound.TimerRanOut = false
MagicSpecialRound.WinnerOfSpecialRound = WIN_NONE

-- call this hook with hook.Run() if you use some custom win condition not already present in special_round_utils
hook.Add("MagicSpecialRoundAlteredWinCondition", "UpdateGlobalAddonAlteredWinCondition", function() MagicSpecialRound.hasAlteredWinCondition = true end)

-- same as above. no need to call it until the round is actually over, default winner is none (aka round not over)
hook.Add("MagicSpecialRoundWinUpdate", "UpdateGlobalAddonTableInformation", function(winner)
    if winner == WIN_NONE or winner == WIN_TRAITOR or winner == WIN_INNOCENT then
        MagicSpecialRound.WinnerOfSpecialRound = winner
    end
end)

-- call if the timer runs out (it doesn't matter if the traitors or innocent win, just that the timer ran out)
hook.Add("MagicSpecialRoundTimerWin", "UpdateTimerRanOut", function()
    MagicSpecialRound.TimerRanOut = true
end)


--


local ActiveSpecialRound = nil


local function ChooseRandomSpecialRound()
    return specialrounds[1]
    --return table.Random(specialrounds)
end


local function IsLastRound()
    local roundsLeft = GetGlobalInt("ttt_rounds_left", 100000)
    return roundsLeft <= 1
end

-- mainly for debug
hook.Add( "PlayerSay", "forcespecialroundstart", function( ply, text )
	if ( string.StartsWith(string.lower( text ), "!forcespecial") and ply:GetUserGroup() == "superadmin") then
        if not MagicSpecialRound.isSpecialround then
            local args = string.Explode(" ", string.lower(text))
            local target = args[2]
            if target ~= nil then
                for _, round in ipairs(specialrounds) do
                    if round.name == target then
                        ActiveSpecialRound = round
                        break
                    end
                end
            end
            SetGlobalInt("ttt_rounds_left", 1)
            RunConsoleCommand("ttt_roundrestart")
        end 
    end
end )

-- prepare, begin and end special round hooks
hook.Add("TTTPrepareRound", "PrepareSpecialRound", function()
    if (IsLastRound()) then
        MagicSpecialRound.isSpecialround = true
        if ActiveSpecialRound == nil then
            ActiveSpecialRound = ChooseRandomSpecialRound()
        end
        net.Start("SpecialRoundPreparing")
        net.WriteString(ActiveSpecialRound.title)
        net.WriteString(ActiveSpecialRound.desc)
        net.Broadcast()
        timer.Simple(0.1, function()
            ActiveSpecialRound.prepare()
        end)
    end
end)


hook.Add("TTTBeginRound", "StartSpecialRound", function()
    if MagicSpecialRound.isSpecialround then
        ActiveSpecialRound.begin()
        net.Start("SpecialRoundStart")
        net.Broadcast()
    end
end)


hook.Add("TTTEndRound", "EndSpecialRound", function()
    if MagicSpecialRound.isSpecialround then
        timer.Simple(0.1, function() -- probably unneccesary
        MagicSpecialRound.isSpecialround = false 
        ActiveSpecialRound.restart()
        ActiveSpecialRound = nil 
        MagicSpecialRound.hasAlteredWinCondition = false
        MagicSpecialRound.WinnerOfSpecialRound = WIN_NONE
        MagicSpecialRound.TimerRanOut = false
        end)
    end
end)


-- karma is always disabled on special rounds

hook.Add("TTTKarmaGivePenalty", "DisableKarmaPenaltySpecialRound", function()
    if MagicSpecialRound.isSpecialround then return true end
end)


hook.Add("TTTKarmaGiveReward", "DisableKarmaRewardSpecialRound", function()
    if MagicSpecialRound.isSpecialround then return true end
end)

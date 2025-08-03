local example_special_round = {}


example_special_round.name = "myamazingspecialround"


example_special_round.title = "Special round's title"


example_special_round.utils = include("special_round_utils.lua")


example_special_round.begin = function()
    hook.Add("TTTCheckForWin", "TeamDeathmatchWinCondition", function()
        local tcount = teamdeathmatch.utils.getTraitorCount()
        local dcount = teamdeathmatch.utils.getDetectiveCount()
        if (dcount <= 0) then return WIN_TRAITOR elseif (tcount <= 0) then return WIN_INNOCENT else return WIN_NONE end
    end)

    local players = player:GetAll()
    table.Shuffle(players)
    local lastwastraitor = false
    for _, ply in ipairs(players) do
        if lastwastraitor then
            teamdeathmatch.utils.setDetective(ply, true)
            lastwastraitor = false
        else
            teamdeathmatch.utils.setTraitor(ply, true)
            lastwastraitor = true 
        end
    end
    SendFullStateUpdate()

    teamdeathmatch.utils.LimitCredits(1)
end


example_special_round.restart = function()
    hook.Remove("TTTCheckForWin", "TeamDeathmatchWinCondition")
    teamdeathmatch.utils.EnableCredits()
end


-- return example_special_round
-- since this is just an example round we'll just return nil to skip it
return nil

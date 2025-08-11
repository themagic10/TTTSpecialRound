local teamdeathmatch = {}


teamdeathmatch.name = "teamdeathmatch"


teamdeathmatch.title = "Traitors vs Detectives"


teamdeathmatch.desc = "Half the players are traitors, the other half are detective. Last team standing wins"


teamdeathmatch.utils = include("special_round_utils.lua")


teamdeathmatch.prepare = function()
end


teamdeathmatch.begin = function()
    teamdeathmatch.utils.SetAlteredWinCondition()
    teamdeathmatch.utils.SetTimerOnlyWinCheck(true)
    hook.Add("PlayerDeath", "TeamDeathmatchWinCondition", function()
        local tcount = teamdeathmatch.utils.getTraitorCount()
        local dcount = teamdeathmatch.utils.getDetectiveCount()
        if (dcount <= 0) then
            teamdeathmatch.utils.SetWinner(WIN_TRAITOR)
        elseif (tcount <= 0) then
            teamdeathmatch.utils.SetWinner(WIN_INNOCENT)
        end 
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


teamdeathmatch.restart = function()
    hook.Remove("PlayerDeath", "TeamDeathmatchWinCondition")
    teamdeathmatch.utils.EnableCredits()
    teamdeathmatch.utils.UnsetTimerOnlyWinCheck()
end

return teamdeathmatch
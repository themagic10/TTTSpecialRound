local instagib = {}


instagib.name = "instagib"


instagib.title = "INSTAGIB! 1 shot 1 kill"


instagib.desc = "You have one-shotting sniper. Kill everyone else to win"


instagib.utils = include("special_round_utils.lua")


instagib.prepare = function()
    instagib.utils.RemoveMapWeapons()
end


instagib.begin = function()
    instagib.utils.setFFAWinCondition()
    instagib.utils.setAllTraitor()
    instagib.utils.DisableCredits()
    instagib.utils.RemoveAllPlayerWeapons()

    for _, ply in ipairs(player:GetAll()) do
        if IsValid(ply) and ply:Alive() then
            ply:Give("weapon_ttt_instagib")
        end
    end
end


instagib.restart = function()
    instagib.utils.unsetFFAWinCondition()
    instagib.utils.EnableCredits()
end


return instagib
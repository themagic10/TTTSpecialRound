local crowbarffa = {}


crowbarffa.name = "crowbarffa"

crowbarffa.desc = "Kill everyone else to win. You can only use your trusty crowbar"

crowbarffa.title = "Free for all!,Crowbar only"


crowbarffa.utils = include("special_round_utils.lua")


crowbarffa.prepare = function()
    crowbarffa.utils.RemoveMapWeapons()
end


crowbarffa.begin = function()
    crowbarffa.utils.setFFAWinCondition()
    crowbarffa.utils.setAllTraitor()
    crowbarffa.utils.DisableCredits()

    for _, ply in ipairs(player:GetAll()) do
        if IsValid(ply) and ply:Alive() then
            ply:StripWeapons()
            ply:RemoveAllAmmo()
            ply:Give("weapon_zm_improvised", true)
        end
    end
end


crowbarffa.restart = function()
    crowbarffa.utils.unsetFFAWinCondition()
    crowbarffa.utils.EnableCredits()
end

return crowbarffa
local crowbarffa = {}


crowbarffa.name = "crowbarffa"


crowbarffa.title = "Free for all!,Crowbar only"


crowbarffa.utils = include("special_round_utils.lua")


crowbarffa.begin = function()
    crowbarffa.utils.setFFAWinCondition()
    crowbarffa.utils.setAllTraitor()
    crowbarffa.utils.DisableCredits()
    crowbarffa.utils.RemoveMapWeapons()

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
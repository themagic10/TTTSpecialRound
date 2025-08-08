local flyingscoutsman = {}


flyingscoutsman.name = "flyingscoutsman"


flyingscoutsman.title = "Flying Scoutsman"


flyingscoutsman.utils = include("special_round_utils.lua")


flyingscoutsman.begin = function()
    flyingscoutsman.utils.setFFAWinCondition()
    flyingscoutsman.utils.setAllTraitor()
    flyingscoutsman.utils.DisableCredits()
    RunConsoleCommand("sv_gravity", "100")
    flyingscoutsman.utils.RemoveMapWeapons()
    for _, ply in ipairs(player:GetAll()) do
        if IsValid(ply) and ply:Alive() then
            ply:StripWeapons()
            ply:Give("weapon_zm_improvised", true)
            ply:Give("weapon_zm_rifle")
            --dumb paramater order
            ply:GiveAmmo(9999, "357")
        end
    end

end


flyingscoutsman.restart = function()
    flyingscoutsman.utils.unsetFFAWinCondition()
    flyingscoutsman.utils.EnableCredits()
    RunConsoleCommand("sv_gravity", "600")
end


return flyingscoutsman
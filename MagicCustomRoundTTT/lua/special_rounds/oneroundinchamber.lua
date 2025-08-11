local oneshotpistol = {}


oneshotpistol.name = "oneshotpistol"


oneshotpistol.title = "FFA pistols, only 1 bullet. Kill for another shot"


oneshotpistol.desc = "You only have a pistol with 1 bullet, kill a player to earn another round. Last one standing wins (feel free to use your crowbar if you run out of bullets)"


oneshotpistol.utils = include("special_round_utils.lua")


oneshotpistol.prepare = function()
    oneshotpistol.utils.RemoveMapAll()
end


oneshotpistol.begin = function()
    oneshotpistol.utils.setFFAWinCondition()
    oneshotpistol.utils.setAllTraitor()
    oneshotpistol.utils.DisableCredits()
    oneshotpistol.utils.RemoveAllPlayerWeapons()

    for _, ply in ipairs(player:GetAll()) do
        if IsValid(ply) and ply:Alive() then
            ply:StripWeapons()
            ply:RemoveAllAmmo()
            ply:Give("weapon_zm_improvised")
            ply:Give("weapon_zm_pistol", true)
            local wep = ply:GetWeapon("weapon_zm_pistol")
            if wep:IsWeapon() then --probably unnecessary but you never know
                wep:SetClip1(1)
            end
            ply:SetHealth(25)
        end
    end

    hook.Add("PlayerDeath", "SpecialPistolRoundGiveExtraAmmo", function(victim, weapon, killer)
        if killer:IsPlayer() then
            if killer:Alive() then
                local wep = killer:GetWeapon("weapon_zm_pistol")
                if wep:IsWeapon() then
                    timer.Simple(0.1, function() wep:SetClip1(1) end)                    
                end
            end
        end
    end)
end


oneshotpistol.restart = function()
    oneshotpistol.utils.unsetFFAWinCondition()
    oneshotpistol.utils.EnableCredits()
    hook.Remove("PlayerDeath", "SpecialPistolRoundGiveExtraAmmo")
end


return oneshotpistol
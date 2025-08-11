local lifestealffa = {}


lifestealffa.name = "lifestealffa"


lifestealffa.title = "Free for all, vampire edition"


lifestealffa.desc = "Free for all, you gain health by dealing damage to other players (health can go beyond 100)"


lifestealffa.utils = include("special_round_utils.lua")


lifestealffa.prepare = function()
end


lifestealffa.begin = function()
    lifestealffa.utils.setFFAWinCondition()
    lifestealffa.utils.setAllTraitor()
    lifestealffa.utils.DisableCredits()
    hook.Add("EntityTakeDamage", "LifestealFFAGiveHealth", function(target, dmg)
        if target:IsPlayer() then
            local attacker = dmg:GetAttacker()
            if attacker:IsPlayer() then
                local attacker_health = attacker:Health()
                local dmg_amt = dmg:GetDamage()
                attacker:SetHealth(attacker_health + dmg_amt)
            end
            
        end
    end)
end


lifestealffa.restart = function()
    lifestealffa.utils.unsetFFAWinCondition()
    lifestealffa.utils.EnableCredits()
    hook.Remove("EntityTakeDamage", "LifestealFFAGiveHealth")
end

return lifestealffa
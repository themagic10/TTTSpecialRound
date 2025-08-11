local tbl = {}
tbl.cache = {}

tbl.IsValid = IsValid
tbl.GetConVar = GetConVar
tbl.ipairs = ipairs
tbl.GetGlobalFloat = GetGlobalFloat


--[[
    Sets a variable that tells other plugins that the special round has a custom win condition

    only use this function if you're writing a custom win condition not present in this file
]]
tbl.SetAlteredWinCondition = function() hook.Run("MagicSpecialRoundAlteredWinCondition") end


--[[
    sets round winner
    note that calling this function will result in the round ending after a short delay
    another note: please dont use this inside the TTTCheckForWin hook
]]
tbl.SetWinner = function(winner)
    if winner == WIN_TRAITOR or winner == WIN_INNOCENT then
        hook.Run("MagicSpecialRoundWinUpdate", winner)
        timer.Simple(0.25, function() EndRound(winner) end)
    end
end


--[[
    Sets the default TTT win check to only end the round when the timer reaches zero
    call this function if you're creating a custom win condition (make sure NOT to use the TTTCheckForWin hook )

    param traitorwin:   if true when the timers end the traitors will win
                        if false then the innocents will win (like default)
]]
tbl.SetTimerOnlyWinCheck = function(doTraitorWin)
    timer.Pause("winchecker") -- THIS EFFECTIVELY DISABLES THE TTTCheckForWin HOOK
    local function SpecialTimerWin(traitorwin)
        if traitorwin then
            if CurTime() > tbl.GetGlobalFloat("ttt_round_end", 0) then
                hook.Run("MagicSpecialRoundTimerWin")
                hook.Run("MagicSpecialRoundWinUpdate", WIN_TRAITOR)
                tbl.SetWinner(WIN_TRAITOR)
            end
        else
            if CurTime() > tbl.GetGlobalFloat("ttt_round_end", 0) then
                hook.Run("MagicSpecialRoundTimerWin")
                hook.Run("MagicSpecialRoundWinUpdate", WIN_INNOCENT)
                tbl.SetWinner(WIN_INNOCENT)
            end        
        end
    end
    timer.Create( "timeronlywinchecker", 1, 0, function() 
        SpecialTimerWin(doTraitorWin)
    end)
end


--[[
    Removes the TimerOnly check
]]
tbl.UnsetTimerOnlyWinCheck = function()
    timer.Remove("timeronlywinchecker")
    timer.UnPause("winchecker")
end



--[[
    sets the last man standing win condition
    the round ends when only 1 player (or no one) remains alive
]]
tbl.setFFAWinCondition = function()
    tbl.SetAlteredWinCondition()
    tbl.SetTimerOnlyWinCheck(true)
    hook.Add("PlayerDeath", "FFAWinCondition", function()
        local alive = 0
        for _, ply in tbl.ipairs(player.GetAll()) do
            if tbl.IsValid(ply) and ply:Alive() then
                alive = alive + 1
            end
        end
        if alive <= 1 then 
            tbl.SetWinner(WIN_TRAITOR)           
        end 
    end)
end


--[[
    removes the last man standing win condition
]]
tbl.unsetFFAWinCondition = function()
    hook.Remove("PlayerDeath", "FFAWinCondition")
    tbl.UnsetTimerOnlyWinCheck()
end


--[[
    Returns the number of alive players given a role

    -param role: one of the followings ROLE_TRAITOR ROLE_DETECTIVE
]]
tbl.getRoleCount = function(role)
    local counter = 0
    for _, ply in tbl.ipairs(player.GetAll()) do
        if tbl.IsValid(ply) and ply:Alive() and ply:GetRole() == role then
            counter = counter + 1
        end
    end
    return counter
end


--[[
    Returns the number of alive Traitors
]]
tbl.getTraitorCount = function() return tbl.getRoleCount(ROLE_TRAITOR) end


--[[
    Returns the number of alive Detectives
]]
tbl.getDetectiveCount = function() return tbl.getRoleCount(ROLE_DETECTIVE) end


--[[
    Sets player as a traitor
    if noupdate flag is set to true it doesn't update the players of the new roles until SendFullStateUpdate is manually called
    this is mainly for optimization (see setAllTraitor or similar)
]]
tbl.setTraitor = function(ply, noupdate)
    if tbl.IsValid(ply) and ply:Alive() then
        ply:SetRole(ROLE_TRAITOR)
        if noupdate == nil then 
            SendFullStateUpdate()
            return 
        end
        if not noupdate then
            SendFullStateUpdate()
        end
    end
end


--[[
    Sets player as a detective
    if noupdate flag is set to true it doesn't update the players of the new roles until SendFullStateUpdate is manually called
    this is mainly for optimization (see setAllTraitor or similar)
]]
tbl.setDetective = function(ply, noupdate)
    if tbl.IsValid(ply) and ply:Alive() then
        ply:SetRole(ROLE_DETECTIVE)
        if noupdate == nil then 
            SendFullStateUpdate()
            return 
        end
        if not noupdate then
            SendFullStateUpdate()
        end
    end
end


--[[
    sets all players as traitors
    please note that unless you also change the win condition beforhand the round will end immedately!
]]
tbl.setAllTraitor = function()
    for _, ply in tbl.ipairs(player.GetAll()) do
        tbl.setTraitor(ply, true)
        SendFullStateUpdate()
    end
end


--[[
    Limits the amount of credits players have to a certain amount
    Also removes the ability to earn additional credits

    -param amount: the number of credits player will have
]]
tbl.LimitCredits = function(amount)
    --fun fact the ttt wiki on hooks has the wrong paramaters for this
    hook.Add("TTTOnCorpseCreated", "NoCreditsOnCorpses", function(rag, ply)
        CORPSE.SetCredits(rag, 0)
        return rag
    end)
    for _, ply in tbl.ipairs(player.GetAll()) do
        if tbl.IsValid(ply) and ply:Alive() then
            ply:SetCredits(amount)
        end
    end
    --ugly notification
    tbl.GetConVar("ttt_credits_detectivekill"):SetInt(0)
    tbl.GetConVar("ttt_det_credits_traitordead"):SetInt(0)
end


--[[
    Disables the shop for detectives and traitors
    it also disables the possibility to even earn credits
]]
tbl.DisableCredits = function()
    --required from hook.run on GM method
    hook.Add("TTTCanOrderEquipment", "DisableShopSpecialRound", function(ply, id, is_item) return false end)
    tbl.LimitCredits(0)
end


--[[
    (Re)Enables the shop and credit system
]]
tbl.EnableCredits = function()
    -- it's actually GM:TTTCanOrderEquipment, checks for false on hook.run; kinda dumb
    hook.Remove("TTTCanOrderEquipment", "DisableShopSpecialRound") 
    hook.Remove("TTTBodyFound", "NoCreditsFromBodiesSpecialRound")
    tbl.GetConVar("ttt_credits_detectivekill"):SetInt(1)
    tbl.GetConVar("ttt_det_credits_traitordead"):SetInt(1)
end


--[[
    Removes all the weapon from the map
    it removes all random weapons and weapons the map may spawn (for example the easter egg knife in ttt_community_pool)

    it does NOT remove random ammos (mainly for optimization)
]]
tbl.RemoveMapWeapons = function()

    for _, e in tbl.ipairs(ents.GetAll()) do
        if e:IsWeapon() then
            if string.find(e:GetClass(), "weapon_ttt") or string.find(e:GetClass(), "weapon_zm") or e:GetClass() == "ttt_random_weapon" then 
                if not e:GetOwner():IsPlayer() then --if is not nil then a player has it
                    e:Remove()
                end
            end 
        end
    end
end


--[[
    Removes all random weapon and ammo drops from the map
]]
tbl.RemoveMapAll = function()
    tbl.RemoveMapWeapons()
    for _, e in tbl.ipairs(ents.GetAll()) do
        local class = e:GetClass()
        if class == "item_box_buckshot_ttt" or string.StartsWith(class, "item_ammo_") then
            e:Remove()
        end
    end
end


--[[
    Removes all the weapons on all players
]]
tbl.RemoveAllPlayerWeapons = function()
    for _, ply in tbl.ipairs(player:GetAll()) do
        if tbl.IsValid(ply) and ply:Alive() then
            ply:StripWeapons()
            ply:RemoveAllAmmo()
        end
    end
end


return tbl
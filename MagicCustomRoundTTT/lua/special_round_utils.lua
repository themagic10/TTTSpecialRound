local tbl = {}


tbl.IsValid = IsValid


--[[
    sets the last man standing win condition
    the round ends when only 1 player (or no one) remains alive
]]
tbl.setFFAWinCondition = function()
    hook.Add("TTTCheckForWin", "FFAWinCondition", function()
        local alive = 0
            for _, ply in ipairs(player.GetAll()) do
                if tbl.IsValid(ply) and ply:Alive() then
                    alive = alive + 1
                end
            end
            if alive <= 1 then return WIN_TRAITOR else return WIN_NONE end
            return WIN_NONE
    end)
end


--[[
    removes the last man standing win condition
]]
tbl.unsetFFAWinCondition = function()
    hook.Remove("TTTCheckForWin", "FFAWinCondition")
end

--[[
    Returns the number of alive players given a role

    -param role: one of the followings ROLE_TRAITOR ROLE_DETECTIVE
]]
tbl.getRoleCount = function(role)
    local counter = 0
    for _, ply in ipairs(player.GetAll()) do
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
    for _, ply in ipairs(player.GetAll()) do
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
    hook.Add("TTTBodyFound", "NoCreditsFromBodiesSpecialRound", function() return false end)
    for _, ply in ipairs(player.GetAll()) do
        if tbl.IsValid(ply) and ply:Alive() then
            ply:SetCredits(amount)
        end
    end
end


--[[
    Disables the shop for detectives and traitors
    it also disables the possibility to even earn credits
]]
tbl.DisableCredits = function()
    --required from hook.run on GM method
    hook.Add("TTTCanOrderEquipment", "DisableShopSpecialRound", function(ply, id, is_item) return false end)
    hook.Add("TTTBodyFound", "NoCreditsFromBodiesSpecialRound", function() return false end)
    tbl.LimitCredits(0)
end


--[[
    (Re)Enables the shop and credit system
]]
tbl.EnableCredits = function()
    -- it's actually GM:TTTCanOrderEquipment, checks for false on hook.run; kinda dumb
    hook.Remove("TTTCanOrderEquipment", "DisableShopSpecialRound") 
    hook.Remove("TTTBodyFound", "NoCreditsFromBodiesSpecialRound")
end


--[[
    Removes all the weapon from the map
    it removes all random weapons and weapons the map may spawn (for example the easter egg knife in ttt_community_pool)

    it does NOT remove random ammos (mainly for optimization)
]]
tbl.RemoveMapWeapons = function()

    for _, e in ipairs(ents.GetAll()) do
        if e:IsWeapon() then
            if string.find(e:GetClass(), "weapon_ttt") or string.find(e:GetClass(), "weapon_zm") or e:GetClass() == "ttt_random_weapon" then 
                e:Remove()
            end 
        end
    end
end


--[[
    Removes all random weapon and ammo drops from the map
]]
tbl.RemoveMapAll = function()
    tbl.RemoveMapWeapons()
    for _, e in ipairs(ents.GetAll()) do
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
    for _, ply in ipairs(player:GetAll()) do
        if IsValid(ply) and ply:Alive() then
            ply:StripWeapons()
            ply:RemoveAllAmmo()
        end
    end
end


return tbl
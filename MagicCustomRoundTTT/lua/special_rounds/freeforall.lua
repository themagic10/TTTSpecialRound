local ffa = {}


ffa.name = "ffa"


ffa.title = "Free for all!"


ffa.utils = include("special_round_utils.lua")


ffa.begin = function()
    ffa.utils.setFFAWinCondition()
    ffa.utils.setAllTraitor()
    ffa.utils.DisableCredits()
end


ffa.restart = function()
    ffa.utils.unsetFFAWinCondition()
    ffa.utils.EnableCredits()
end


return ffa
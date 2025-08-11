local ffa = {}


ffa.name = "ffa"


ffa.title = "Free for all!"


ffa.desc = "Kill everyone! Last one standing is the winner"


ffa.utils = include("special_round_utils.lua")


ffa.prepare = function()
end


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
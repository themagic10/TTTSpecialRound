local example_special_round = {}


example_special_round.name = "myamazingspecialround"


example_special_round.title = "Special round's title"


example_special_round.desc = "My custom description of the round"


example_special_round.utils = include("special_round_utils.lua")


example_special_round.prepare = function()
    --you can leave this empty
end


example_special_round.begin = function()
    example_special_round.utils.setFFAWinCondition()
    example_special_round.utils.setAllTraitor()
    example_special_round.utils.DisableCredits()
end


example_special_round.restart = function()
    example_special_round.utils.unsetFFAWinCondition()
    example_special_round.utils.EnableCredits()
end


-- return example_special_round
-- since this is just an example round we'll just return nil to skip it
return nil

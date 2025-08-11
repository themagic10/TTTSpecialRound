local low_gravity = {}


low_gravity.name = "lowgravity"


low_gravity.title = "Low Gravity Round"


low_gravity.desc = "Low gravity Round, not much more to say"


low_gravity.prepare = function()
end


low_gravity.begin = function()
    RunConsoleCommand("sv_gravity", "150")
end


low_gravity.restart = function()
    RunConsoleCommand("sv_gravity", "600")
end


return low_gravity
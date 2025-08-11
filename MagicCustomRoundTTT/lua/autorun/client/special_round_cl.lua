net.Receive("SpecialRoundPreparing", function()
    local roundname = net.ReadString()
    local rounddesc = net.ReadString()
    chat.AddText(Color(100, 255, 255), "SPECIAL ROUND!\n")
    chat.AddText(Color(100, 255, 255), roundname)
    chat.AddText(Color(100, 255, 255), rounddesc)
end)

net.Receive("SpecialRoundStart", function()
    
    chat.AddText(Color(100, 255, 255), "Special round started, glhf!")
end)
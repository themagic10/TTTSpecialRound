net.Receive("SpecialRoundPreparing", function()
    chat.AddText(Color(100, 255, 255), "SPECIAL ROUND STARTING!")
end)

net.Receive("SpecialRoundStart", function()
    local roundname = net.ReadString()
    chat.AddText(Color(100, 255, 255), "Current round: " .. roundname)
end)
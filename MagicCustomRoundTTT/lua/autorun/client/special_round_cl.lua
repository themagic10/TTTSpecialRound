surface.CreateFont("specialroundtitlefont", {
    font = "Calibri",
    size = 40,
    weight = 500,
    blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})


surface.CreateFont("specialrounddescfont", {
    font = "Calibri",
    size = 30,
    weight = 500,
    blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})


local infopanel = nil 
local titlelabel = nil 
local desclabel = nil


local drawinfopanel = function(title, desc)
    infopanel = vgui.Create("DPanel")
    infopanel:SetSize(450, 300)
    infopanel:SetPos(10, 10)
    function infopanel:Paint(w, h)
        draw.RoundedBox( 18, 0, 0, w, h, Color(44, 44, 44, 230) )
    end

    titlelabel = vgui.Create("DLabel", mypanel)
    titlelabel:SetSize(450, 100)
    titlelabel:SetText(title)
    titlelabel:SetFont("specialroundtitlefont")
    titlelabel:SetTextColor(Color(243,241,241))
    titlelabel:SetContentAlignment(5) 
    titlelabel:SetPos(20, 20)
    titlelabel:SetHighlight(true)
    titlelabel:SetWrap(true)
    titlelabel:SetAutoStretchVertical(true)


    desclabel = vgui.Create("DLabel", mypanel)
    desclabel:SetSize(450, 170)
    desclabel:SetText(desc)
    desclabel:SetContentAlignment(5) 
    desclabel:SetPos(20, 110)
    desclabel:SetFont("specialrounddescfont")
    desclabel:SetTextColor(Color(192,192,192))
    desclabel:SetWrap(true)
    desclabel:SetAutoStretchVertical(true)


    infopanel:SetVisible(true)
end


local deleteinfopanel = function()
    if infopanel ~= nil then
        titlelabel:Remove()
        desclabel:Remove()
        infopanel:Remove()
    end
end


net.Receive("SpecialRoundPreparing", function()
    local roundname = net.ReadString()
    local rounddesc = net.ReadString()
    chat.AddText(Color(100, 255, 255), "SPECIAL ROUND!\n")
    chat.AddText(Color(100, 255, 255), roundname)
    chat.AddText(Color(100, 255, 255), rounddesc)
    drawinfopanel(roundname, rounddesc)
end)


net.Receive("SpecialRoundStart", function()
    
    chat.AddText(Color(100, 255, 255), "Special round started, glhf!")
end)


net.Receive("SpecialRoundEnd", function()
    deleteinfopanel()
end)
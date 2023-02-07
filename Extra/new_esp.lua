local client = game.Players.LocalPlayer
local chr = client.Character or client.CharacterAdded:Wait()
local root = chr:WaitForChild('HumanoidRootPart') 
local camera = workspace.CurrentCamera
local runservice = game:GetService('RunService')

local v2 = Vector2.new 
local cf = CFrame.new 
local v3 = Vector3.new 

local settings = {
    main_color = Color3.fromRGB(255, 0, 255),
    back_color = Color3.fromRGB(0,0,0),
}

local function Draw(obj, prop)
    local a = Drawing.new(obj)
    
    for i, v in pairs(prop) do 
        a[i] = v 
    end
    
    return a
end

local function main(plr)
    -- // Text \\ -- 
    local text = Draw('Text', {
        Size = 15,
        Text = plr.Name,
        Color = settings.main_color,
        Center = true,
        Outline = true,
        OutlineColor = settings.back_color
    })

    -- // Tracer \\ -- 
    local line = Draw('Line', {
        Thickness = 1,
        Color = settings.main_color,
        ZIndex = 2
    })

    local back_line = Draw('Line', {
        Thickness = 2,
        Color = settings.back_color,
        ZIndex = 1
    })

    -- // Box \\ -- 
    local top = Draw('Line', {
        Thickness = 1,
        Color = settings.main_color,
        ZIndex = 2
    })

    local bottom = Draw('Line', {
        Thickness = 1,
        Color = settings.main_color,
        ZIndex = 2
    })

    local left = Draw('Line', {
        Thickness = 1,
        Color = settings.main_color,
        ZIndex = 2
    })

    local right = Draw('Line', {
        Thickness = 1,
        Color = settings.main_color,
        ZIndex = 2
    })

    local back_top = Draw('Line', {
        Thickness = 2,
        Color = settings.back_color,
        ZIndex = 1
    })

    local back_bottom = Draw('Line', {
        Thickness = 2,
        Color = settings.back_color,
        ZIndex = 1
    })

    local back_left = Draw('Line', {
        Thickness = 2,
        Color = settings.back_color,
        ZIndex = 1
    })

    local back_right = Draw('Line', {
        Thickness = 2,
        Color = settings.back_color,
        ZIndex = 1
    })

    runservice.RenderStepped:Connect(function()
        if plr and plr.Character and plr.Character:FindFirstChild('HumanoidRootPart') and plr.Character:FindFirstChild('Humanoid') and plr.Character.Humanoid.Health > 0 then
            local plr_root = plr.Character.HumanoidRootPart
            local t_pos, onscreen = camera:WorldToViewportPoint((plr_root.CFrame * cf(0,3,0)).p)
            local l_pos = camera:WorldToViewportPoint((plr_root.CFrame * cf(0,-3,0)).p)
            
            local tl = camera:WorldToViewportPoint((plr_root.CFrame  * cf(-2,3,0)).p)
            local tr = camera:WorldToViewportPoint((plr_root.CFrame  * cf(2,3,0)).p)
            local bl = camera:WorldToViewportPoint((plr_root.CFrame  * cf(-2,-3,0)).p)
            local br = camera:WorldToViewportPoint((plr_root.CFrame  * cf(2,-3,0)).p)
            
            text.Position = v2(t_pos.x, t_pos.y) - v2(0, text.TextBounds.y)
            text.Visible = onscreen
            
            line.From = v2(camera.ViewportSize.x / 2, camera.ViewportSize.y / 1)
            line.To = v2(l_pos.x, l_pos.y)
            line.Visible = onscreen
            
            back_line.From = v2(camera.ViewportSize.x / 2, camera.ViewportSize.y / 1)
            back_line.To = v2(l_pos.x, l_pos.y)
            back_line.Visible = onscreen
            
            top.From = v2(tl.x, tl.y)
            top.To = v2(tr.x, tr.y)
            top.Visible = onscreen
            
            bottom.From = v2(bl.x, bl.y)
            bottom.To = v2(br.x, br.y)
            bottom.Visible = onscreen
            
            left.From = v2(tl.x, tl.y)
            left.To = v2(bl.x, bl.y)
            left.Visible = onscreen
            
            right.From = v2(tr.x, tr.y)
            right.To = v2(br.x, br.y)
            right.Visible = onscreen
            --
            back_top.From = v2(tl.x, tl.y)
            back_top.To = v2(tr.x, tr.y)
            back_top.Visible = onscreen
            
            back_bottom.From = v2(bl.x, bl.y)
            back_bottom.To = v2(br.x, br.y)
            back_bottom.Visible = onscreen
            
            back_left.From = v2(tl.x, tl.y)
            back_left.To = v2(bl.x, bl.y)
            back_left.Visible = onscreen
            
            back_right.From = v2(tr.x, tr.y)
            back_right.To = v2(br.x, br.y)
            back_right.Visible = onscreen
        else
            text.Visible = false
            line.Visible = false
            back_line.Visible = false
            
            top.Visible = false
            bottom.Visible = false 
            left.Visible = false 
            right.Visible = false 
            
            back_top.Visible = false
            back_bottom.Visible = false
            back_right.Visible = false
            back_left.Visible = false
        end
    end)
end

for i,v in pairs(game.Players:GetPlayers()) do 
    if v ~= client then 
        main(v)
    end
end

game.Players.PlayerAdded:Connect(function(v)
    main(v)
end)

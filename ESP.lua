-- Credits to https://github.com/Blissful4992 for helping me understand how the boxes work

local client = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runservice = game:GetService('RunService')

local v2 = Vector2.new
local cf = CFrame.new

local library = {}

function library.draw_text(plr)
    local t = Drawing.new('Text')
    t.Center = true 
    t.Outline = true 
    t.Size = 14 
    
    local conn; 
    conn = runservice.RenderStepped:Connect(function()
        if plr and plr.Character and plr.Character:FindFirstChild('HumanoidRootPart') and plr.Character:FindFirstChild('Humanoid') and plr.Character.Humanoid.Health > 0 then 
            local offset = cf(0,3,0)
            local pos, onscreen = camera:WorldToViewportPoint((plr.Character.HumanoidRootPart.CFrame * offset).Position)
            
            t.Position = v2(pos.X, pos.Y) - v2(0, t.TextBounds.y)
            t.Color = Color3.fromRGB(255,255,255)
            t.Text = plr.Name .. '\nHealth: ' .. math.floor(plr.Character.Humanoid.Health)
            
            if onscreen then 
                t.Visible = true
            else
                t.Visible = false
            end
        else
            t.Visible = false
        end
    end)
end

function library.draw_box(plr)
    local Top = Drawing.new('Line')
    Top.Thickness = 1 
    Top.Color = Color3.fromRGB(255,255,255)
    
    local Bottom = Drawing.new('Line')
    Bottom.Thickness = 1 
    Bottom.Color = Color3.fromRGB(255,255,255)
    
    local Left = Drawing.new('Line')
    Left.Thickness = 1 
    Left.Color = Color3.fromRGB(255,255,255)
    
    local Right = Drawing.new('Line')
    Right.Thickness = 1 
    Right.Color = Color3.fromRGB(255,255,255)
    
    local conn; 
    conn = runservice.RenderStepped:Connect(function()
        if plr and plr.Character and plr.Character:FindFirstChild('HumanoidRootPart') and plr.Character:FindFirstChild('Humanoid') and plr.Character.Humanoid.Health > 0 then 
            local posmain, onscreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            local offset_table = {
                TL = (plr.Character.HumanoidRootPart.CFrame * cf(2,3,0)).Position,
                TR = (plr.Character.HumanoidRootPart.CFrame * cf(-2,3,0)).Position,
                BL = (plr.Character.HumanoidRootPart.CFrame * cf(2,-3,0)).Position,
                BR = (plr.Character.HumanoidRootPart.CFrame * cf(-2,-3,0)).Position
            }
            
            local TL_pos, onscreen_TL = camera:WorldToViewportPoint(offset_table.TL)
            local TR_pos, onscreen_TR = camera:WorldToViewportPoint(offset_table.TR)
            local BL_pos, onscreen_BL = camera:WorldToViewportPoint(offset_table.BL)
            local BR_pos, onscreen_BR = camera:WorldToViewportPoint(offset_table.BR)
            
            Top.From = v2(TL_pos.x, TL_pos.y)
            Top.To = v2(TR_pos.x, TR_pos.y)
            
            Left.From = v2(TL_pos.x,TL_pos.y)
            Left.To = v2(BL_pos.x, BL_pos.y)
            
            Right.From = v2(TR_pos.x, TR_pos.y)
            Right.To = v2(BR_pos.x, BR_pos.y)
            
            Bottom.From = v2(BR_pos.x, BR_pos.y)
            Bottom.To = v2(BL_pos.x, BL_pos.y)
            
            if onscreen then
                Top.Visible = true 
                Left.Visible = true 
                Right.Visible = true 
                Bottom.Visible = true
            else
                Top.Visible = false 
                Left.Visible = false 
                Right.Visible = false 
                Bottom.Visible = false
            end
        else
            Top.Visible = false 
            Left.Visible = false 
            Right.Visible = false 
            Bottom.Visible = false
        end
    end)
end

function library.draw_tracer(plr)
    local tracer = Drawing.new('Line')
    tracer.Thickness = 1 
    tracer.Color = Color3.fromRGB(255,255,255)
    
    local conn; 
    conn = runservice.RenderStepped:Connect(function()
        if plr and plr.Character and plr.Character:FindFirstChild('HumanoidRootPart') and plr.Character:FindFirstChild('Humanoid') and plr.Character.Humanoid.Health > 0 then 
            local offset = cf(0,-3,0)
            local pos, onscreen = camera:WorldToViewportPoint((plr.Character.HumanoidRootPart.CFrame * offset).Position)
            
            tracer.From = v2(camera.ViewportSize.X / 2, camera.ViewportSize.y / 1)
            tracer.To = v2(pos.x, pos.y)
            
            if onscreen then 
                tracer.Visible = true
            else
                tracer.Visible = false
            end
        else
            tracer.Visible = false
        end
    end)
end

for i,v in pairs(game.Players:GetPlayers()) do 
    if v ~= client then 
        library.draw_text(v) 
        library.draw_box(v) 
        library.draw_tracer(v)
    end
end

game.Players.PlayerAdded:Connect(function(v)
    library.draw_text(v) 
    library.draw_box(v) 
    library.draw_tracer(v)
end)

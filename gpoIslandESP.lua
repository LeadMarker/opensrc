-- LeadMarker#1219
local islands = getrenv()._G.IslandCFrames
local lplr = game.Players.LocalPlayer
local cam = workspace.CurrentCamera

for i,v in pairs(islands) do 
    local part = Instance.new('Part', workspace)
    part.Name = i 
    part.Size = Vector3.new(1,1,1)
    part.CFrame = v * CFrame.new(0,100,0)
    part.Anchored = true 
    part.Transparency = 1
end

local function esp(v)
    local d = Drawing.new('Text')
    d.Size = 14 
    d.Color = Color3.fromRGB(255,255,255)
    d.Outline = true 
    d.Center = true 
    
    local con 
    con = game:GetService("RunService").Stepped:Connect(function()
        local pos, onscreen = cam:WorldToViewportPoint(v.Position)
        local mag = math.floor((lplr.Character.HumanoidRootPart.Position - v.Position).magnitude) or 0
        local text = v.Name .. '\nDistance: ' .. mag 
        
        d.Text = text 
        d.Position = Vector2.new(pos.x, pos.y) - Vector2.new(0, d.TextBounds.y)
        
        if onscreen then 
            d.Visible = true 
        else
            d.Visible = false 
        end
    end)
end

for i,v in pairs(workspace:GetChildren()) do 
    if islands[v.Name] then 
        esp(v)
    end
end

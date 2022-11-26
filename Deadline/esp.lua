-- game is annoying and cba to fully make it

-- // Vars \\ -- 
local client = game:GetService('Players').LocalPlayer
local characters = game:GetService('Workspace').characters
local random_player, holder = tostring(game:GetService('Workspace').characters:GetChildren()[1])
local camera = game:GetService('Workspace').CurrentCamera

-- // Character Stuff \\ -- 
for i,v in pairs(getgc(true)) do 
    if type(v) == 'table' and rawget(v, random_player) then 
        holder = v 
        break
    end
end

local function sort_table(tab)
    local new_table = {}
    
    for i,v in pairs(tab) do 
        if characters:FindFirstChild(i) then 
            new_table[i] = v
        end
    end
    
    return new_table
end

local plr_table = sort_table(holder)

-- // Esp Stuff \\ --
local function draw(obj, prop)
    local a = Drawing.new(obj)
    
    for i,v in pairs(prop) do 
        a[i] = v 
    end
    
    return a
end

local function esp_main(obj)
    local plr_name = plr_table[obj]
    local text = draw('Text', {Size = 14, Color = Color3.fromRGB(255,255,255), Outline = true})
    local tracer = draw('Line', {Thickness = 1, Color = Color3.fromRGB(255,255,255)})
    
    local loop = game:GetService('RunService').RenderStepped:Connect(function()
        if game:GetService('Players'):FindFirstChild(plr_name) then 
            if characters:FindFirstChild(obj) then 
                local char = characters:FindFirstChild(obj)
                local pos, onscreen = camera:WorldToViewportPoint((char.hitbox.CFrame * CFrame.new(-1,3,0)).p)
                local tracer_pos = camera:WorldToViewportPoint((char.hitbox.CFrame * CFrame.new(-1,-3,0)).p)
                
                text.Text = plr_name
                text.Position = Vector2.new(pos.x, pos.y) - Vector2.new(0, text.TextBounds.y)
                text.Visible = onscreen
                
                tracer.From = Vector2.new(camera.ViewportSize.x / 2, camera.ViewportSize.y / 1)
                tracer.To = Vector2.new(tracer_pos.x, tracer_pos.y)
                tracer.Visible = onscreen
            else
                text:Remove()
                tracer:Remove()
                if loop then loop:Disconnect() end
            end
        else
            text:Remove()
            tracer:Remove()
            if loop then loop:Disconnect() end
        end
    end)
end

for i,v in pairs(plr_table) do 
    esp_main(i)
end

-- // Services \\ -- 
local players = game:GetService('Players')
local workspace = game:GetService('Workspace')
local runservice = game:GetService('RunService')
local userinputservice = game:GetService('UserInputService')

-- // Vars \\ -- 
local client = players.LocalPlayer
local chr = client.Character
local root = chr.HumanoidRootPart
local camera = workspace.CurrentCamera

local get_char, get_root, hit_target; do 
    get_char = function(player)
        return player.Character or false
    end
    
    get_root = function(character)
        return character.HumanoidRootPart or false 
    end
    
    nearest_mouse = function()
        local dist, nearest = math.huge
        local mouse = client:GetMouse()
        for i, v in next, players:GetChildren() do
            if v ~= client and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos = camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                if magnitude < dist then
                    nearest = v
                    dist = magnitude
                end
            end
        end
        
        return nearest
    end
end

local esp_lib = {} do 
    local line_cache = {}
    local current_player
    
    local function draw(obj, props)
        local a = Drawing.new(obj)
        
        for i,v in next, props do 
            a[i] = v 
        end 
        
        return a 
    end
    
    function esp_lib:add_line(player)
        if (line_cache[player]) then return end 
        line_cache[player] = draw('Line', {Thickness = 1, Color = Color3.fromRGB(255,255,255)})
    end
    
    userinputservice.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Q then 
            current_player = nearest_mouse()
            
            for i,v in next, players:GetChildren() do 
                if v ~= client then
                    if line_cache[v] then line_cache[v]:Remove(); line_cache[v] = nil end
                end
            end
            
            esp_lib:add_line(current_player)
        end
    end)
    
    runservice.RenderStepped:Connect(function()
        for player, line in next, line_cache do 
            local char = get_char(player)
            local char_root = get_root(char)
            local mouse_pos = char.BodyEffects.MousePos.Value
            local pos, onscreen = camera:WorldToViewportPoint(char_root.Position)
            local pos_mouse = camera:WorldToViewportPoint(mouse_pos)
            
            if player and char and char:FindFirstChildWhichIsA('Tool') and char:FindFirstChildWhichIsA('Tool'):FindFirstChild('GunScript') then 
                line.From = Vector2.new(pos.x, pos.y)
                line.To = Vector2.new(pos_mouse.x, pos_mouse.y)
                line.Visible = onscreen
            else
                line.Visible = false
            end
        end
    end)
end

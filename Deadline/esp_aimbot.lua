local players = game:GetService('Players')
local runservice = game:GetService('RunService')
local userinputservice = game:GetService('UserInputService')
local workspace = game:GetService('Workspace')

local client = players.LocalPlayer
local chrs = workspace.characters
local camera = workspace.CurrentCamera

local random_char = chrs:GetChildren()[math.random(1, #chrs:GetChildren())]

local security = Color3.fromRGB(66, 135, 245)
local insurgent = Color3.fromRGB(245, 170, 66)

local enemy_chrs, enemy_info, fov_circle
do 
    for i, v in pairs(getgc(true)) do 
        if (type(v) == 'table' and rawget(v, random_char.Name) and type(rawget(v, random_char.Name)) == 'string') then 
            enemy_chrs = v 
        end
        
        if (type(v) == 'table' and rawget(v, random_char.Name) and type(rawget(v, random_char.Name)) == 'table') then
            enemy_info = v
        end
        
        if (enemy_chrs and enemy_info) then break end 
    end
    
    fov_circle = Drawing.new('Circle')
    fov_circle.Radius = getgenv().settings.fov_size
    fov_circle.Color = Color3.fromRGB(255, 255, 255)
    fov_circle.Thickness = 1 
    fov_circle.NumSides = 50
    fov_circle.Visible = true
end

local function grab_char_from_name(player)
    for code, plr in pairs(enemy_chrs) do 
        if (player.Name ~= plr) then continue end 
        local player_found = chrs:FindFirstChild(code)
        
        if (player_found) then 
            return player_found, player
        end
    end
end

local function grab_player_team(player)
    local char_name = grab_char_from_name(player).Name 
    
    for i, v in pairs(enemy_info) do 
        if (i ~= char_name) then continue end 
        local team = rawget(v.replicated_data, 'team')
        
        return (team == 'security' and security) or insurgent
    end
end

local function get_player_mouse()
    local player = nil 
    local dist = fov_circle.Radius
    
    for i, v in pairs(players:GetPlayers()) do 
        if (v ~= client) then 
            local char = grab_char_from_name(v)
            local root = char and char:FindFirstChild('humanoid_root_part')
            
            if (char and root) then 
                local position = camera:WorldToViewportPoint(root.Position)
                local mag = (Vector2.new(position.x, position.y) - userinputservice:GetMouseLocation()).magnitude 
                
                if (mag < dist) then 
                    dist = mag 
                    player = char
                end
            end
        end
    end
    
    return player
end


local esp_lib = {}
do 
    local cache = {}

    function esp_lib:add_text(player)
        if (cache[player]) then return end 

        local drawing = Drawing.new('Text')
        drawing.Size = 14
        drawing.Center = true 
        drawing.Outline = true 

        cache[player] = drawing
    end

    local function on_player()
        for i, v in pairs(players:GetChildren()) do 
            if (v ~= client) then 
                esp_lib:add_text(v)
            end
        end
    end

    on_player()
    players.PlayerAdded:Connect(on_player)
    
    while (true) do 
        for player, text in pairs(cache) do 
            local _text = ''
            local onscreen, position = false
            
            local char = grab_char_from_name(player)
            local root = char and char:FindFirstChild('humanoid_root_part')
            
            if (char and root) then 
                position, onscreen = camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, 3, 0)).Position)
                text.Position = Vector2.new(position.x, position.y) - Vector2.new(0, text.TextBounds.y)
                text.Color = grab_player_team(player)
                
                _text = player.Name
            end
            
            text.Text = _text
            text.Visible = onscreen
        end
        
        fov_circle.Position = userinputservice:GetMouseLocation()
        
        if (get_player_mouse() ~= nil and userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and getgenv().settings.aimbot_enabled) then 
            local position = camera:WorldToViewportPoint(get_player_mouse():FindFirstChild('humanoid_root_part').Position)
            local relative = Vector2.new(position.X, position.Y) - userinputservice:GetMouseLocation()
            mousemoverel(relative.x * 1, relative.y * 1) -- credits to Rileyy for the mousemoverel tut
        end
        
        runservice.Stepped:Wait() 
    end
end

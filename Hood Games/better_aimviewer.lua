local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/3D%20Drawing%20Api.lua"))()

local players = game:GetService('Players') 
local workspace = game:GetService('Workspace')
local userinputservice = game:GetService('UserInputService')

local camera = workspace.CurrentCamera
local client = players.LocalPlayer
local v2 = Vector2.new 
local v3 = Vector3.new 
local cf = CFrame.new

local aim_status = {
    ['safe'] = Color3.fromRGB(0, 255, 0),
    ['danger'] = Color3.fromRGB(255, 0, 0)
}

getgenv().keybind = getgenv().keybind or 'E'

local get_mouse, get_char, get_root, get_player_mouse, is_visible, get_aim_status; do 
    get_mouse = function()
        return userinputservice:GetMouseLocation()
    end
    
    get_char = function(player)
        return player.Character
    end
    
    get_root = function(char)
        if (not char) then return end 
        
        return char:FindFirstChild('HumanoidRootPart') 
    end
    
    get_player_mouse = function()
        local player = nil 
        local dist = math.huge 
        
        for i,v in pairs(players:GetPlayers()) do 
            local t_char = get_char(v)
            local t_root = get_root(t_char)
            
            if (t_char and t_root) then  
                local pos, onscreen = camera:WorldToViewportPoint((t_root.CFrame * cf(0, 2, 0)).Position)
                local mag = (v2(pos.x, pos.y) - get_mouse()).magnitude 
                
                if (mag < dist) then 
                    dist = mag 
                    player = v 
                end
            end
        end
        
        return player
    end
    
    is_visible = function(player)
        local my_char = get_char(client)
        local my_root = get_root(my_char) 
        
        local enemy_char = get_char(player)
        local enemy_root = get_root(enemy_char)
        
        if (my_char and my_root and enemy_char and enemy_root) then 
            local position, onscreen = camera:WorldToViewportPoint(enemy_root.Position)
            local cast = {my_root.Position, enemy_root.Position}
            local ignore = {my_char, enemy_char}
            
            local result = camera:GetPartsObscuringTarget(cast, ignore)
            
            return (onscreen and #result == 0)
        end
        
        return false
    end
    
    get_aim_status = function(player)
        local t_char = get_char(player)
        local body_effects = t_char:FindFirstChild('BodyEffects')
        local mouse_pos = body_effects and body_effects:FindFirstChild('MousePos')
        local t_status = nil
        
        local my_char = get_char(client)
        local my_root = get_root(my_char)
        
        if (t_char and mouse_pos and my_char and my_root) then 
            local pos = camera:WorldToViewportPoint(my_root.Position)
            local pos2 = camera:WorldToViewportPoint(mouse_pos.Value)
            
            local mag = (v2(pos.x, pos.y) - v2(pos2.x, pos2.y)).magnitude 
            
            if (mag < 90) then 
                t_status = 'danger'
            end
        end
        
        return t_status or 'safe'
    end
end


local drawing_stuff = {}
do 
    local current_player = nil
    
    local function draw(obj, props)
        local obj = Drawing.new(obj)
        
        for i,v in pairs(props) do 
            obj[i] = v 
        end
        
        return obj
    end
    
    local function draw3d(props)
        local obj = library:New3DCube()
        
        for i,v in pairs(props) do 
            obj[i] = v 
        end
        
        return obj
    end
    
    local cache = {
        line = {},
        box = {}
    }
    
    function drawing_stuff:add_line(player)
        if (cache.line[player]) then return end
        cache.line[player] = draw('Line', {Thickness = 1, Color = Color3.fromRGB(255, 255, 255)})
    end
    
    function drawing_stuff:add_box(player)
        if (cache.box[player]) then return end 
        cache.box[player] = draw3d({Color = Color3.fromRGB(255, 255, 255), Filled = true, Size = v3(1,1,1), Transparency = .5})
    end
    
    local function on_player(input)
        if (input.KeyCode == Enum.KeyCode[keybind]) then 
            current_player = get_player_mouse()
            
            for i,v in pairs(players:GetPlayers()) do 
                if (cache.line[v]) then 
                    cache.line[v]:Remove()
                    cache.line[v] = nil
                end
                
                if (cache.box[v]) then 
                    cache.box[v]:Remove()
                    cache.box[v] = nil
                end
            end
            
            drawing_stuff:add_line(current_player)
            drawing_stuff:add_box(current_player)
        end
    end
    
    userinputservice.InputBegan:Connect(on_player)
    
    task.spawn(function()
        while (task.wait()) do 
            for player, line in pairs(cache.line) do 
                local t_char = get_char(player)
                local t_root = get_root(t_char)
                local body_effects = t_char:FindFirstChild('BodyEffects')
                local mouse_pos = body_effects and body_effects:FindFirstChild('MousePos')
                local onscreen = false
                
                if (player and is_visible(player) and t_char and mouse_pos and t_char:FindFirstChildWhichIsA('Tool') and t_char:FindFirstChildWhichIsA('Tool'):FindFirstChild('GunScript')) then 
                    pos, onscreen = camera:WorldToViewportPoint(t_root.Position)
                    local m_pos, _ = camera:WorldToViewportPoint(mouse_pos.Value)
                    
                    line.From = v2(pos.x, pos.y)
                    line.To = v2(m_pos.x, m_pos.y)
                    line.Color = aim_status[get_aim_status(player)]
                end
                
                line.Visible = onscreen
            end
        end
    end)
    
    task.spawn(function()
        while (task.wait()) do 
            for player, box in pairs(cache.box) do 
                local t_char = get_char(player)
                local t_root = get_root(t_char)
                local body_effects = t_char:FindFirstChild('BodyEffects')
                local mouse_pos = body_effects and body_effects:FindFirstChild('MousePos')
                local onscreen = false
                
                if (player and is_visible(player) and t_char and mouse_pos and t_char:FindFirstChildWhichIsA('Tool') and t_char:FindFirstChildWhichIsA('Tool'):FindFirstChild('GunScript')) then 
                    pos, onscreen = camera:WorldToViewportPoint(t_root.Position)
                    box.Position = mouse_pos.Value
                    box.Color = aim_status[get_aim_status(player)]
                end
                
                box.Visible = onscreen
            end
        end
    end)
end

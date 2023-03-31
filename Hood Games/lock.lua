local userinputservice = game:GetService('UserInputService')
local players = game:GetService('Players')
local workspace = game:GetService('Workspace')

local tau = 2 * math.pi
local camera = workspace.CurrentCamera
local client = players.LocalPlayer

-- // Fov Circle \\ -- 
do 
    local function draw(obj, prop) 
        local obj = Drawing.new(obj)
        
        for i, v in pairs(prop) do 
            obj[i] = v 
        end
        
        return obj 
    end

    for i = 1, fov_settings.points do 
        fov_settings.drawings[i] = draw('Line', {Color = Color3.fromRGB(255, 255, 255), Visible = true, Thickness = 2})
    end
    
    -- Old Position
    task.spawn(function()
        while (task.wait(1/30)) do 
            local mouse_pos = userinputservice:GetMouseLocation()
            
            for index, drawing in pairs(fov_settings.drawings) do 
                local angle = tau * index / fov_settings.points
                local x_offset = fov_settings.radius * math.cos(angle)
                local y_offset = fov_settings.radius * math.sin(angle)
                local point_pos = Vector2.new(mouse_pos.X + x_offset, mouse_pos.Y + y_offset)
                
                fov_settings.old_mouse[index] = point_pos
            end
        end
    end)
    
    -- New Position
    task.spawn(function()
        while (task.wait()) do 
            local mouse_pos = userinputservice:GetMouseLocation()
            
            for index, drawing in pairs(fov_settings.drawings) do 
                local angle = tau * index / fov_settings.points
                local x_offset = fov_settings.radius * math.cos(angle)
                local y_offset = fov_settings.radius * math.sin(angle)
                local point_pos = Vector2.new(mouse_pos.X + x_offset, mouse_pos.Y + y_offset)
                
                drawing.From = fov_settings.old_mouse[index] or mouse_pos
                drawing.To = point_pos + Vector2.new(1.5, 0)
                drawing.Color = Color3.fromHSV((tick() % 1 - (index / fov_settings.points)) % 1, 0.5, 1) -- liam
            end
        end
    end)
end

-- // Lock \\ -- 
local function get_player_mouse()
    local dist = fov_settings.radius
    local player = nil 
    
    for i, v in pairs(players:GetPlayers()) do 
        if (v == client) then continue end 
        
        local char = v.Character 
        local root = char and char:FindFirstChild('HumanoidRootPart')
        
        if (char and root) then 
            local pos = camera:WorldToViewportPoint(root.Position)
            local mag = (Vector2.new(pos.x, pos.y) - userinputservice:GetMouseLocation()).magnitude
            
            if (mag < dist) then 
                dist = mag 
                player = v 
            end
        end
    end
    
    return player
end

local function anti_detect()
    local target = get_player_mouse()
    
    if (not target) then return end 
    
    local char = target.Character 
    local root = char and char:FindFirstChild('HumanoidRootPart')
    
    if (char and root) then 
        local velo = root.Velocity 
        
        if (velo.x > 50 or velo.y > 50 or velo.z > 50 or velo.x < -50 or velo.y < -50 or velo.z < -50) then 
            return true 
        end
    end
    
    return false
end

local function get_ping()
    local new_ping = (anti_detect() and prediction * 16) or prediction
    return new_ping
end

local function get_prediction()
    local target = get_player_mouse()
    
    if (not target) then return end 
    
    local char = target.Character 
    local root = char and char:FindFirstChild('HumanoidRootPart')
    local humanoid = char and char:FindFirstChild('Humanoid')
    
    if (char and root and humanoid) then 
        local velocity_pred = (root.Position + (root.Velocity * get_ping()))
        local movedirection_pred = (root.Position + (humanoid.MoveDirection * get_ping()))
        
        return (anti_detect() and movedirection_pred) or velocity_pred
    end
end

local index; index = hookmetamethod(game, '__index', function(self, key)
    if (self:IsA('Mouse') and key == 'Hit') then 
        local target = get_player_mouse()
        return (target and CFrame.new(get_prediction())) or index(self, key)
    end
   
    return index(self, key) 
end)

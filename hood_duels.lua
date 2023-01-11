-- // Services \\ -- 
local workspace = game:GetService('Workspace')
local players = game:GetService('Players')
local runservice = game:GetService('RunService')
local userinputservice = game:GetService('UserInputService')

-- // Vars \\ -- 
local client = players.LocalPlayer
local camera = workspace.CurrentCamera 
local fov_circle = nil

-- // ToHex Bypass \\ -- 
hookfunction(math.random, function()
    return 1 
end)

local draw_obj, get_mouse, get_closest_player; do 
    get_mouse = function()
        return Vector2.new(userinputservice:GetMouseLocation().x, userinputservice:GetMouseLocation().y)
    end
    
    draw_obj = function(obj, prop)
        local obj = Drawing.new(obj)
        
        for i,v in pairs(prop) do 
            obj[i] = v 
        end
        
        return obj
    end
    
    get_closest_player = function()
        local dist = settings.fov_radius
        local player = nil
        
        for i,v in pairs(game:GetService('Players'):GetPlayers()) do
            if (i ~= 1 and v.Character and v.Character:FindFirstChild('HumanoidRootPart')) then
                local pos, onscreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character:FindFirstChild('HumanoidRootPart').Position)
                
                local mag = (Vector2.new(pos.x, pos.y) - get_mouse()).magnitude 
                
                if (mag < dist) then 
                    dist = mag 
                    player = v 
                end
            end
        end
        
        return player
    end
end

fov_circle = draw_obj('Circle', {
    Thickness = 1,
    Radius = settings.fov_radius,
    NumSides = 1000,
    Filled = false,
    Color = settings.color,
    Visible = settings.fov_circle
})

draw_obj('Text', {
    Text = 'Made by LeadMarker#1219',
    Size = 30,
    Color = settings.color,
    Visible = true,
    Position = Vector2.new(0,0)
})

local target
runservice.RenderStepped:Connect(function()
    target = get_closest_player()
    
    if (settings.fov_circle) then 
        fov_circle.Position = get_mouse()
    end
end)

local old; old = hookmetamethod(game, '__namecall', function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == 'FireServer' and self.Name == 'MainRemote' and args[1] and rawget(args[1], '31') and rawget(args[1], 'Event') == 'Shoot') then
        for i = 1, #args[1]['31'] do 
            if (target ~= nil and target.Character and target.Character:FindFirstChild('HumanoidRootPart')) then 
                args[1]['31'][i] = target.Character.HumanoidRootPart.Position + (target.Character.HumanoidRootPart.Velocity * settings.prediction)
            end
        end
        
        return self.FireServer(self, unpack(args))
    end
    
    return old(self, ...)
end)

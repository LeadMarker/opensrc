local fov_settings = {
    radius = 150,
    points = 100,
    drawings = {},
    old_mouse = {}
}

local userinputservice = game:GetService('UserInputService')
local tau = 2 * math.pi

local function draw(obj, prop) 
    local obj = Drawing.new(obj)
    
    for i, v in pairs(prop) do 
        obj[i] = v 
    end
    
    return obj 
end

-- // Fov Circle \\ -- 
do 
    for i = 1, fov_settings.points do 
        fov_settings.drawings[i] = draw('Line', {Color = Color3.fromRGB(255, 255, 255), Visible = true, Thickness = 2})
    end
    
    -- Old Position
    task.spawn(function()
        while task.wait(1/30) do 
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
        while task.wait() do 
            local mouse_pos = userinputservice:GetMouseLocation()
            
            for index, drawing in pairs(fov_settings.drawings) do 
                local angle = tau * index / fov_settings.points
                local x_offset = fov_settings.radius * math.cos(angle)
                local y_offset = fov_settings.radius * math.sin(angle)
                local point_pos = Vector2.new(mouse_pos.X + x_offset, mouse_pos.Y + y_offset)
                
                drawing.From = fov_settings.old_mouse[index] or mouse_pos
                drawing.To = point_pos + Vector2.new(1.5, 0)
                drawing.Color = Color3.fromHSV((tick() % 5 / 5 - (index / fov_settings.points)) % 1,.5,1)
            end
        end
    end)
end

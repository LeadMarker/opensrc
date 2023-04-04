-- i got the box calculations off kesh so credits to him

local runservice = game:GetService('RunService')
local workspace = game:GetService('Workspace')
local players = game:GetService('Players')

local client = players.LocalPlayer
local camera = workspace.CurrentCamera
local tan, round, rad = math.tan, math.round, math.rad

getgenv().image_url = 'https://media.discordapp.net/attachments/1091753371016376380/1092865970126729227/image.png?width=157&height=134'

local settings = {
    esp_color = Color3.fromRGB(255, 255, 255),
    border_color = Color3.fromRGB(0, 0, 0)
}

local esplib = {}; do
    local cache = {
        boxes = {},
        outlines = {},
        images = {}
    }
    
    function esplib:add_box(player)
        if (cache.boxes[player]) then return end 
        
        local drawing = Drawing.new('Square')
        drawing.Color = settings.esp_color
        drawing.Thickness = 1 
        drawing.ZIndex = 2
        
        cache.boxes[player] = drawing
    end
    
    function esplib:add_outline(player)
        if (cache.outlines[player]) then return end 
        
        local drawing = Drawing.new('Square')
        drawing.Color = settings.border_color
        drawing.Thickness = 1.5
        drawing.ZIndex = 1
        
        cache.outlines[player] = drawing
    end
    
    function esplib:add_image(player, url)
        if (cache.images[player]) then return end 
        
        local drawing = Drawing.new('Image')
        drawing.Data = game:HttpGet(url)
        
        cache.images[player] = drawing
    end
    
    local function on_player()
        for i, v in pairs(players:GetPlayers()) do 
            if (v == client) then continue end 
            
            esplib:add_box(v)
            esplib:add_outline(v)
            esplib:add_image(v, getgenv().image_url)
        end
    end
    
    on_player()
    players.PlayerAdded:Connect(on_player)

    -- local root_pos, _ = camera:WorldToViewportPoint(t_root.Position)
    -- local scale_factor_point = 1 / (root_pos.Z * tan(rad(camera.FieldOfView / 2)) * 2) * 250

    -- box 
    task.spawn(function()
        while (true) do 
            for player, box in pairs(cache.boxes) do 
                local char = player.Character 
                local root = char and char:FindFirstChild('HumanoidRootPart')
                local onscreen, pos = false
                
                if (char and root) then 
                    pos, onscreen = camera:WorldToViewportPoint(root.Position)
                    local scale_factor = 1 / (pos.Z * tan(rad(camera.FieldOfView / 2)) * 2) * 1000
                    local width, height = round(4 * scale_factor), round(6 * scale_factor)
                    local x, y = round(pos.X), round(pos.Y)
                    
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(round(x - width / 2), round(y - height / 2))
                end
                
                box.Visible = onscreen
            end
           
            runservice.Stepped:Wait() 
        end
    end)
    
    -- outline 
    task.spawn(function()
        while (true) do 
            for player, box in pairs(cache.outlines) do 
                local char = player.Character 
                local root = char and char:FindFirstChild('HumanoidRootPart')
                local onscreen, pos = false
                
                if (char and root) then 
                    pos, onscreen = camera:WorldToViewportPoint(root.Position)
                    local scale_factor = 1 / (pos.Z * tan(rad(camera.FieldOfView / 2)) * 2) * 1000
                    local width, height = round(4 * scale_factor), round(6 * scale_factor)
                    local x, y = round(pos.X), round(pos.Y)
                    
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(round(x - width / 2), round(y - height / 2))
                end
                
                box.Visible = onscreen
            end
            
            runservice.Stepped:Wait() 
        end
    end)
    
    -- images
    task.spawn(function()
        while (true) do 
            for player, box in pairs(cache.images) do 
                local char = player.Character 
                local root = char and char:FindFirstChild('HumanoidRootPart')
                local onscreen, pos = false
                
                if (char and root) then 
                    pos, onscreen = camera:WorldToViewportPoint(root.Position)
                    local scale_factor = 1 / (pos.Z * tan(rad(camera.FieldOfView / 2)) * 2) * 1000
                    local width, height = round(4 * scale_factor), round(6 * scale_factor)
                    local x, y = round(pos.X), round(pos.Y)
                    
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(round(x - width / 2), round(y - height / 2))
                end
                
                box.Visible = onscreen
            end
            
            runservice.Stepped:Wait() 
        end
    end)
end

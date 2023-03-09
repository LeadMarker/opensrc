local key_layout = {
    drawings = {},
    keys = {'w', 'a', 's', 'd'},
}

local camera = workspace.CurrentCamera
local viewport_size = Vector2.new(camera.ViewportSize.x / 15, camera.ViewportSize.y / 2)
local userinputservice = game.UserInputService

do 
    local function draw(obj, prop)
        local obj = Drawing.new(obj)
        
        for i,v in pairs(prop) do 
            obj[i] = v 
        end
        
        return obj 
    end
    
    function key_layout:init_keys()
        local box = {
            Color = Color3.fromRGB(0, 0, 0),
            Transparency = .70,
            Thickness = 1,
            Filled = true, 
            Size = Vector2.new(50, 50),
            Position = viewport_size,
            Visible = true
        }
        
        local drawings = self.drawings
        
        drawings['center'] = draw('Square', {
            Color = Color3.fromRGB(0, 0, 0),
            Transparency = .5,
            Thickness = 1,
            Filled = true, 
            Size = Vector2.new(5, 5),
            Position = viewport_size,
            Visible = false
        })
    
        for i, key in pairs(self.keys) do 
            table.insert(drawings, draw('Square', box))
        end
        
        drawings[1].Position = Vector2.new(drawings.center.Position.x, drawings.center.Position.y - (drawings[1].Size.x + 5))
        drawings[2].Position = Vector2.new(drawings.center.Position.x - (drawings[1].Size.x + 5), drawings.center.Position.y)
        drawings[3].Position = Vector2.new(drawings.center.Position.x, drawings.center.Position.y)
        drawings[4].Position = Vector2.new(drawings.center.Position.x + (drawings[1].Size.x + 5), drawings.center.Position.y)
        
        for i, v in pairs(self.keys) do 
            table.insert(drawings, draw('Text', {
                Text = v:upper(),
                Color = Color3.fromRGB(255, 255, 255),
                Size = drawings[i].Size.x - 20,
                Center = true,
                Outline = false,
                Position = Vector2.new(drawings[i].Position.x + drawings[i].Size.x / 2, drawings[i].Position.y + drawings[i].Size.y / 5),
                Visible = true
            }))
        end
    end
    
    key_layout:init_keys()
    
    while (task.wait()) do 
        for i, key in pairs(key_layout.keys) do 
            if userinputservice:IsKeyDown(Enum.KeyCode[key:upper()]) then 
                key_layout.drawings[i].Color = Color3.fromRGB(255, 255, 255)
                key_layout.drawings[i + 4].Color = Color3.fromRGB(0, 0, 0)
            else
                key_layout.drawings[i].Color = Color3.fromRGB(0, 0, 0)
                key_layout.drawings[i + 4].Color = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end

local players = game:GetService('Players')
local workspace = game:GetService('Workspace')
local userinputservice = game:GetService('UserInputService')
local runservice = game:GetService('RunService')

local client = players.LocalPlayer
local camera = workspace.CurrentCamera

local function get_player_mouse()
    local player = nil 
    local dist = math.huge

    for i, v in pairs(players:GetPlayers()) do 
        if (v ~= client and v.TeamColor ~= client.TeamColor) then 
            local char = v.Character
            local root = char and char:FindFirstChild('HumanoidRootPart')
            local model = char:FindFirstChildWhichIsA('Model')
            local nape = model and model:FindFirstChild('Nape')

            if (char and root and not nape) then 
                local position, onscreen = camera:WorldToViewportPoint(root.Position)
                local mag = (Vector2.new(position.x, position.y) - userinputservice:GetMouseLocation()).magnitude 

                if (mag < dist) then 
                    dist = mag 
                    player = v 
                end
            end
        end
    end

    return player
end

local namecall; namecall = hookmetamethod(game, '__namecall', function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if (method == 'FireServer' and self.Name == 'Fire' and args[1] == client.Character:FindFirstChildWhichIsA('Tool').Name and get_player_mouse() ~= nil) then 
        args[2] = get_player_mouse().Character.HumanoidRootPart.CFrame
        args[3] = get_player_mouse().Character.HumanoidRootPart
        
        return self.FireServer(self, unpack(args)) 
    end
   
    return namecall(self, ...) 
end)

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
            local _text = {}
            local onscreen, position = false

            local char = player.Character 
            local root = char and char:FindFirstChild('HumanoidRootPart')
            local humanoid = char and char:FindFirstChild('Humanoid')

            if (char and root) then 
                position, onscreen = camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, 3, 0)).Position)
                text.Position = Vector2.new(position.x, position.y) - Vector2.new(0, text.TextBounds.y)
                text.Color = player.TeamColor.Color

                local h = math.floor(humanoid.Health / humanoid.MaxHealth * 100)
                table.insert(_text, player.name)
                table.insert(_text, h .. '%')
            end

            text.Text = table.concat(_text, '\n')
            text.Visible = onscreen
        end

        runservice.Stepped:Wait()
    end
end

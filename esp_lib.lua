-- // Services \\ -- 
local players = game:GetService('Players')
local workspace = game:GetService('Workspace')
local runservice = game:GetService('RunService')
local userinputservice = game:GetService('UserInputService')

-- // Vars \\ -- 
local client = players.LocalPlayer
local camera = workspace.CurrentCamera

local v2 = Vector2.new
local cf = CFrame.new
local insert = table.insert
local concat = table.concat

-- // Functions \\ -- 
local draw, get_mouse; do
    draw = function(obj, props)
        local obj = Drawing.new(obj)

        for i,v in pairs(props) do 
            obj[i] = v 
        end

        return obj
    end

    get_mouse = function()
        return v2(userinputservice:GetMouseLocation().x, userinputservice:GetMouseLocation().y)
    end
end

local esp_lib = {
    color = Color3.fromRGB(255, 255, 255),
    toggle = true,
    tracers = 'fixed',
    mag = false,
    health = false,
} 
do 
    esp_lib.cache = {
        text = {},
        line = {},
        box = {}
    }

    function esp_lib:add_text(player)
        if (self.cache.text[player]) then return end 
        self.cache.text[player] = draw('Text', {Size = 15, Outline = true, Center = true})
    end

    function esp_lib:add_line(player) 
        if (self.cache.line[player]) then return end 
        self.cache.line[player] = draw('Line', {Thickness = 1})
    end

    function esp_lib:add_box(player)
        if (self.cache.box[player]) then return end

        local box = {}

        for i = 1, 4 do 
            box[i] = draw('Line', {Thickness = 1})
        end

        self.cache.box[player] = box
    end

    function esp_lib:state(bool)
        self.toggle = bool
    end

    function esp_lib:update_color(col)
        self.color = col
    end

    function esp_lib:update_tracers(tracer_type)
        self.tracers = tracer_type 
    end

    function esp_lib:text_mag(bool)
        self.mag = bool
    end
    
    function esp_lib:text_health(bool)
        self.health = bool
    end

    local function on_player()
        for i, player in pairs(players:GetPlayers()) do 
            if (i ~= 1) then 
                esp_lib:add_text(player)
                esp_lib:add_line(player)
                esp_lib:add_box(player)
            end
        end
    end

    on_player()
    players.PlayerAdded:Connect(on_player)

    players.PlayerRemoving:Connect(function(player)
        if (esp_lib.cache.text[player]) then
            esp_lib.cache.text[player]:Remove()
            esp_lib.cache.line[player]:Remove()

            for i = 1, 4 do 
                esp_lib.cache.box[player][i]:Remove()
                esp_lib.cache.box[player][i] = nil
            end

            esp_lib.cache.text[player] = nil
            esp_lib.cache.line[player] = nil
        end
    end)


    function esp_lib:updater()
        for player, text in pairs(self.cache.text) do 
            if (player ~= nil and player.Character and player.Character:FindFirstChild('HumanoidRootPart') and player.Character:FindFirstChild('Humanoid') and player.Character.Humanoid.Health > 0) then 
                if self.toggle then 
                    local text_ = {player.Name}
                    local pos, onscreen = camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * cf(0, 3, 0)).Position)
                    local mag = (player.Character.HumanoidRootPart.Position - client.Character.HumanoidRootPart.Position).magnitude
                    local health = (player.Character.Humanoid.Health / player.Character.Humanoid.MaxHealth) * 100

                    if (self.mag) then 
                        insert(text_, tostring('Distance: ' .. math.floor(mag)))
                    end

                    if (self.health) then 
                        insert(text_, tostring('Health: ' .. math.floor(health) .. '%'))
                    end

                    text.Text = concat(text_, '\n')
                    text.Position = Vector2.new(pos.x, pos.y) - v2(0, text.TextBounds.y)
                    text.Visible = onscreen
                    text.Color = self.color
                else
                    text.Visible = false
                end
            else
                text.Visible = false
            end
        end

        for player, line in pairs(self.cache.line) do 
            if (player ~= nil and player.Character and player.Character:FindFirstChild('HumanoidRootPart') and player.Character:FindFirstChild('Humanoid') and player.Character.Humanoid.Health > 0) then 
                if self.toggle then 
                    local pos, onscreen = camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * cf(0, -3, 0)).Position)

                    if (self.tracers == 'fixed') then 
                        line.From = v2(camera.ViewportSize.x / 2, camera.ViewportSize.y / 1)
                    else
                        line.From = get_mouse()
                    end

                    line.To = v2(pos.x, pos.y)
                    line.Visible = onscreen
                    line.Color = self.color
                else
                    line.Visible = false 
                end
            else
                line.Visible = false
            end
        end

        for player, box in pairs(self.cache.box) do 
            if (player ~= nil and player.Character and player.Character:FindFirstChild('HumanoidRootPart') and player.Character:FindFirstChild('Humanoid') and player.Character.Humanoid.Health > 0) then 
                if self.toggle then 
                    local pos, onscreen = camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * cf(0, -3, 0)).Position)
                    
                    local p1 = camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * cf(-2, 3, 0)).Position)
                    local p2 = camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * cf(-2, -3, 0)).Position)
                    local p3 = camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * cf(2, 3, 0)).Position)
                    local p4 = camera:WorldToViewportPoint((player.Character.HumanoidRootPart.CFrame * cf(2, -3, 0)).Position)

                    box[1].From = v2(p1.x, p1.y)
                    box[1].To = v2(p2.x, p2.y)

                    box[2].From = v2(p2.x, p2.y)
                    box[2].To = v2(p4.x, p4.y)

                    box[3].From = v2(p4.x, p4.y)
                    box[3].To = v2(p3.x, p3.y)

                    box[4].From = v2(p3.x, p3.y)
                    box[4].To = v2(p1.x, p1.y)

                    for i = 1, 4 do 
                        box[i].Color = self.color
                        box[i].Visible = onscreen
                    end
                else
                    for i = 1, 4 do 
                        box[i].Visible = false
                    end
                end
            else
                for i = 1, 4 do 
                    box[i].Visible = false
                end
            end
        end
    end

    task.spawn(function()
        runservice.RenderStepped:Connect(function()
            esp_lib:updater()
        end)
    end)
end

return esp_lib

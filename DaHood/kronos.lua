local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/matas3535/PoopLibrary/main/Library.lua'))()
local pointers = library.pointers

-- // Services \\ -- 
local workspace = game:GetService('Workspace')
local players = game:GetService('Players')
local userinputservice = game:GetService('UserInputService')
local runservice = game:GetService('RunService')
local httpservice = game:GetService('HttpService')
local stats = game:GetService('Stats')

-- // Variables \\ -- 
local client = players.LocalPlayer
local camera = workspace.CurrentCamera
local req = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request

-- // Functions \\ -- 
local draw, get_char, get_root, get_hum, is_alive; do
    draw = function(obj, props)
        local obj = Drawing.new(obj)

        for i,v in pairs(props) do 
            obj[i] = v
        end

        return obj
    end

    get_char = function(player)
        return player.Character 
    end

    get_root = function(char)
        if (not char) then return end 
        return char:FindFirstChild('HumanoidRootPart')
    end
    
    get_hum = function(char)
        if (not char) then return end 
        return char:FindFirstChild('Humanoid')
    end

    is_alive = function(player)
        local char = get_char(player)
        local root = get_root(char)

        if (char and root and char:FindFirstChild('Humanoid') and char.Humanoid.Health > 0) then 
            return true 
        end

        return false
    end
end

local window = library:New({Name = 'kronos - Dahood | Made by LeadMarker#1219 | discord.gg/8Cj5abGrNv', Accent = Color3.fromRGB(3, 252, 190)})
do
    local main = window:Page({Name = 'Main'}) 
    do 
        local aimbot_main = main:Section({Name = 'Aimbot', Side = 'Left'}) 
        do 
            local camera_aimbot = aimbot_main:Toggle({Name = 'Camera Aimbot', Default = false, Pointer = 'aimbot_main_cam'})
            camera_aimbot:Keybind({Default = 'None', KeybindName = 'Aimbot', Mode = 'Toggle', Pointer = 'aimbot_main_cam_bind', Callback = function()
                camera_aimbot:Set(not pointers['aimbot_main_cam'].current)
            end})
            
            local silent_aim = aimbot_main:Toggle({Name = 'Silent Aim', Default = false, Pointer = 'aimbot_main_silet'})
            silent_aim:Keybind({Default = '', KeybindName = 'Aimbot', Mode = 'Toggle', Pointer = 'aimbot_main_silent_bind', Callback = function()
                silent_aim:Set(not pointers['aimbot_main_silet'].current)
            end})

            aimbot_main:Toggle({Name = 'Wallcheck', Default = false, Pointer = 'wallcheck'})
            
            aimbot_main:Slider({Name = 'Smoothing', Minimum = 0, Maximum = 10, Default = 0, Decimals = .1, Pointer = 'cam_smoothing'})
            
            aimbot_main:Label({Name = '-', Middle = true})
            
            aimbot_main:Toggle({Name = 'Use Prediction', Default = false, Pointer = 'prediction'})
            aimbot_main:Dropdown({Name = 'Prediction Type', Options = {'Velocity', 'MoveDirection'}, Default = 'Prediction Type: None', Pointer = 'pred_type'})
            aimbot_main:Slider({Name = 'Prediction Amount', Minimum = 0, Maximum = 2, Default = 1, Decimals = .05, Pointer = 'pred_rate'})
            aimbot_main:Toggle({Name = 'Ping Compensate', Default = false, Pointer = 'ping_comp'})
            
            aimbot_main:Label({Name = '-', Middle = true})
            
            local fov_toggle = aimbot_main:Toggle({Name = 'Use FOV Circle', Default = false, Pointer = 'fov_circle'})
            fov_toggle:Colorpicker({Pointer = 'fov_color', Default = Color3.fromRGB(255, 255, 255)})
            
            aimbot_main:Slider({Name = 'Fov Radius', Minimum = 30, Maximum = 250, Default = 30, Decimals = 1, Pointer = 'fov_radius'})

            local is_visible, get_mouse, get_player_mouse, grab_ping; do 
                is_visible = function(player)
                    local char = get_char(player)
                    local root = get_root(char)

                    local my_char = get_char(client)
                    local my_root = get_root(my_char)

                    if (char and root and my_char and my_root) then 
                        local position, onscreen = camera:WorldToViewportPoint(root.Position)
                        local cast = {my_root.Position, root.Position}
                        local ignore = {my_char, char}

                        local result = camera:GetPartsObscuringTarget(cast, ignore)

                        return (onscreen and #result == 0) 
                    end

                    return false
                end

                get_mouse = function()
                    return Vector2.new(userinputservice:GetMouseLocation().x, userinputservice:GetMouseLocation().y)
                end

                get_player_mouse = function()
                    local player = nil 
                    local dist = pointers['fov_radius'].current

                    for i, v in pairs(players:GetPlayers()) do 
                        if (v ~= client) then 
                            local char = get_char(v)
                            local root = get_root(char)

                            if (char and root) then 
                                local position, onscreen = camera:WorldToViewportPoint(root.Position)

                                if (onscreen and not pointers['wallcheck'].current or is_visible(v)) then 
                                    local mag = (Vector2.new(position.x, position.y) - get_mouse()).magnitude 

                                    if (mag < dist) then 
                                        dist = mag 
                                        player = v 
                                    end
                                end
                            end
                        end
                    end

                    return player
                end
            end

            local fov_circle = draw('Circle', {
                NumSides = 9e9,
                Thickness = 1
            })

            local function to_color(hsv)
                local h = hsv[1]
                local s = hsv[2] 
                local v = hsv[3] 

                return Color3.fromHSV(h, s, v)
            end

            local target
            task.spawn(function()
                while (library.ended) do 
                    target = get_player_mouse()

                    fov_circle.Radius = pointers['fov_radius'].current
                    fov_circle.Color = to_color(pointers['fov_color'].current)
                    fov_circle.Position = get_mouse()
                    fov_circle.Visible = pointers['fov_circle'].current

                    if (pointers['aimbot_main_cam'].current) then 
                        if (target ~= nil) then
                            local char = get_char(target)
                            local root = get_root(char)
                            local humanoid = get_hum(char)
    
                            if (char and root and humanoid) then 
                                local sens = pointers['cam_smoothing'].current / 10
                                if (pointers['prediction'].current and pointers['pred_type'].current == 'Velocity') then 
                                    camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, root.Position + (root.Velocity * pointers['pred_rate'].current)), sens)
                                elseif (pointers['prediction'].current and pointers['pred_type'].current == 'MoveDirection') then 
                                    camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, root.Position + (humanoid.MoveDirection * (pointers['pred_rate'].current + 1.5))), sens)
                                else
                                    camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, root.Position), sens)
                                end
                            end
                        end
                    end

                    task.wait()
                end

                fov_circle:Remove()
            end)

            local index; index = hookmetamethod(game, '__index', function(self, key)
                if (self:IsA('Mouse') and key == 'Hit' and pointers['aimbot_main_silet'].current) then 
                    if (target ~= nil) then
                        local char = get_char(target)
                        local root = get_root(char)
                        local humanoid = get_hum(char)

                        if (char and root and humanoid) then 
                            if (pointers['prediction'].current and pointers['pred_type'].current == 'Velocity') then 
                                return root.CFrame + (root.Velocity * pointers['pred_rate'].current)
                            elseif (pointers['prediction'].current and pointers['pred_type'].current == 'MoveDirection') then 
                                return root.CFrame + (humanoid.MoveDirection * (pointers['pred_rate'].current + 1.5))
                            else
                                return root.CFrame
                            end
                        end
                    end
                end
                
                return index(self, key)
            end)
        end
        
        local esp_main = main:Section({Name = 'Esp', Side = 'Right'})
        do 
            local esp = esp_main:Toggle({Name = 'Enabled', Default = false, Pointer = 'esp_toggle'})
            esp:Colorpicker({Pointer = 'esp_color', Default = Color3.fromRGB(255, 255, 255)})
            
            esp_main:Toggle({Name = 'Text', Default = false, Pointer = 'esp_text'})
            esp_main:Toggle({Name = 'Tracers', Default = false, Pointer = 'esp_tracer'})
            esp_main:Toggle({Name = 'Box', Default = false, Pointer = 'esp_box'})
            
            esp_main:Label({Name = '-', Middle = true})
            
            esp_main:Toggle({Name = 'Distance', Default = false, Pointer = 'esp_distance'})
            esp_main:Toggle({Name = 'Health', Default = false, Pointer = 'esp_health'})

            local esp_library = {
                default = pointers['esp_color']
            }
            do 
                local cache = {
                    text = {},
                    line = {},
                    box = {}
                }

                function esp_library:add_text(player)
                    if (cache.text[player]) then return end 
                    cache.text[player] = draw('Text', {Size = 15, Outline = true, Center = true})
                end

                function esp_library:add_line(player)
                    if (cache.line[player]) then return end 
                    cache.line[player] = draw('Line', {Thickness = 1})
                end

                function esp_library:add_box(player)
                    if (cache.box[player]) then return end 
                    cache.box[player] = draw('Quad', {Thickness = 1, Filled = false})
                end

                local function on_player()
                    if not (library.ended) then return end 

                    for i, player in pairs(players:GetPlayers()) do 
                        if (player ~= client) then 
                            esp_library:add_text(player)
                            esp_library:add_line(player)
                            esp_library:add_box(player)
                        end
                    end
                end

                on_player()
                players.PlayerAdded:Connect(on_player)
                
                local function to_color(hsv)
                    local h = hsv[1]
                    local s = hsv[2] 
                    local v = hsv[3] 

                    return Color3.fromHSV(h, s, v)
                end

                -- text
                task.spawn(function()
                    while (library.ended) do 
                        for player, text in pairs(cache.text) do 
                            local char = get_char(player)
                            local root = get_root(char)
                            local humanoid = get_hum(char)
                            local text_ = {}
                            local onscreen = false 

                            if (pointers['esp_toggle'].current) then
                                if (player ~= client and char and root and humanoid) then 
                                    local position = camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, 3, 0)).Position)
                                    _, onscreen = camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, 3, 0)).Position)

                                    if (pointers['esp_text'].current) then 
                                        table.insert(text_, player.Name)
                                    end

                                    if (pointers['esp_distance'].current) then 
                                        local my_char = get_char(client)
                                        local my_root = get_root(my_char)

                                        if (is_alive(client)) then 
                                            local mag = math.floor((root.Position - my_root.Position).magnitude)
                                            table.insert(text_, 'Distance: ' .. mag)
                                        end
                                    end

                                    if (pointers['esp_health'].current) then 
                                        local health = math.floor(humanoid.Health / humanoid.MaxHealth * 100)

                                        table.insert(text_, 'Health: ' .. health .. '%')
                                    end

                                    text.Color = to_color(esp_library.default.current)
                                    text.Position = Vector2.new(position.x, position.y) - Vector2.new(0, text.TextBounds.y)
                                end
                            end

                            text.Text = table.concat(text_, '\n')
                            text.Visible = onscreen
                        end

                        task.wait()
                    end

                    for i,v in next, cache.text do
                        v:Remove()
                    end
                end)

                -- line
                task.spawn(function()
                    while (library.ended) do 
                        for player, line in pairs(cache.line) do 
                            local char = get_char(player)
                            local root = get_root(char)
                            local onscreen = false 

                            if (pointers['esp_toggle'].current) then
                                if (player ~= client and char and root and pointers['esp_tracer'].current) then
                                    local position = camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, -3, 0)).Position)
                                    _, onscreen = camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, -3, 0)).Position)
                                    
                                    line.Color = to_color(esp_library.default.current)
                                    line.From = Vector2.new(camera.ViewportSize.x / 2, camera.ViewportSize.y / 1)
                                    line.To = Vector2.new(position.x, position.y)
                                end
                            end
                            
                            line.Visible = onscreen
                        end

                        task.wait()
                    end

                    for i,v in pairs(cache.line) do 
                        v:Remove()
                    end
                end)

                -- box
                task.spawn(function()
                    while (library.ended) do 
                        for player, box in pairs(cache.box) do 
                            local char = get_char(player)
                            local root = get_root(char)
                            local onscreen = false 

                            if (pointers['esp_toggle'].current) then 
                                if (player ~= client and char and root and pointers['esp_box'].current) then 
                                    local pointa, visa = camera:WorldToViewportPoint((root.CFrame * CFrame.new(2, 3, 0)).Position)
                                    local pointb, visb = camera:WorldToViewportPoint((root.CFrame * CFrame.new(-2, 3, 0)).Position)
                                    local pointc, visc = camera:WorldToViewportPoint((root.CFrame * CFrame.new(-2, -3, 0)).Position)
                                    local pointd, visd = camera:WorldToViewportPoint((root.CFrame * CFrame.new(2, -3, 0)).Position)
                                    onscreen = (visa and visb and visc and visd) or false

                                    box.PointA = Vector2.new(pointa.x, pointa.y)
                                    box.PointB = Vector2.new(pointb.x, pointb.y)
                                    box.PointC = Vector2.new(pointc.x, pointc.y)
                                    box.PointD = Vector2.new(pointd.x, pointd.y)
                                    box.Color = to_color(esp_library.default.current)
                                end
                            end

                            box.Visible = onscreen
                        end

                        task.wait()
                    end

                    for i,v in pairs(cache.box) do 
                        v:Remove()
                    end
                end)
            end
        end
        
        local extra_main = main:Section({Name = 'Extra', Side = 'Left'})
        do 
            extra_main:Toggle({Name = 'Money Aura', Default = false, Pointer = 'money_aura'})

            local function get_money()
                local money = nil 
                local dist = math.huge 

                local char = get_char(client)
                local root = get_root(char)

                for i,v in pairs(workspace.Ignored.Drop:GetChildren()) do 
                    if (v.Name == 'MoneyDrop') then 
                        local mag = (root.Position - v.Position).magnitude 

                        if (mag < dist) then 
                            dist = mag 
                            money = v 
                        end
                    end
                end

                return money
            end

            task.spawn(function()
                while (window.ended) do 
                    if (pointers['money_aura'].current) then 
                        local money = get_money()
                        local char = get_char(client)
                        local root = get_root(char)

                        local mag = (root.Position - money.Position).magnitude 

                        if (mag < 12) then 
                            fireclickdetector(money.ClickDetector)
                        end
                    end

                    task.wait()
                end
            end)
        end

        local credit_main = main:Section({Name = 'Credit', Side = 'Right'})
        do 
            credit_main:Label({Name = 'Scripter: LeadMarker#1219', Middle = true})
            credit_main:Button({Name = 'Join Discord', Callback = function()
                setclipboard("discord.gg/8Cj5abGrNv")
                req({
                    Url = 'http://127.0.0.1:6463/rpc?v=1',
                    Method = 'POST',
                    Headers = {
                        ['Content-Type'] = 'application/json',
                        Origin = 'https://discord.com'
                    },
                    Body = httpservice:JSONEncode({
                        cmd = 'INVITE_BROWSER',
                        nonce = httpservice:GenerateGUID(false),
                        args = {code = '8Cj5abGrNv'}
                    })
                })
            end})
        end
    end

    local settings = window:Page({Name = 'Settings'}) 
    do 
        local settings_main = settings:Section({Name = "Main", Side = "Left"}) 
        do
            settings_main:ConfigBox({})
            settings_main:ButtonHolder({Buttons = {{'Load', function() end}, {'Save', function() end}}})
            settings_main:Label({Name = 'Unloading will fully unload\neverything, so save your\nconfig before unloading.', Middle = true})
            settings_main:Button({Name = 'Unload', Callback = function() 
                window:Unload() 
            end})
            
            settings_main:Keybind({Name = 'Toggle UI', Default = Enum.KeyCode.RightShift, KeybindName = 'Toggle UI', Mode = 'Toggle', Callback = function()
                window:Fade()
            end})
        end
    end
end

window:Initialize()

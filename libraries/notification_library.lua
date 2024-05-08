-- made by leadmarker
local library = {accent = Color3.fromRGB(255, 255, 127), noti1 = {}, noti2 = {}}; do 
    library.__index = library
    local tweenservice = game:GetService('TweenService')

    local screen_gui = Instance.new('ScreenGui')
    screen_gui.Parent = gethui and gethui() or game:GetService('CoreGui')
    screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    function library:notify1(name, time)
        local name, time = name or 'Notify1', time or 1

        local frame = Instance.new('Frame')
        frame.Parent = screen_gui
        frame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
        frame.BorderColor3 = Color3.fromRGB(13, 13, 13)
        frame.BorderSizePixel = 2
        frame.Position = UDim2.new(0.00543056615, 0, 0.088089332, #self.noti1 * 30)
        frame.Size = UDim2.new(0, 0, 0, 20)
        frame.ClipsDescendants = true

        local ui_stroke = Instance.new('UIStroke')
        ui_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        ui_stroke.Color = Color3.fromRGB(39, 39, 39)
        ui_stroke.LineJoinMode = Enum.LineJoinMode.Round 
        ui_stroke.Thickness = 1
        ui_stroke.Parent = frame

        local highlight = Instance.new('Frame')
        highlight.Parent = frame
        highlight.BackgroundColor3 = self.accent
        highlight.BorderColor3 = Color3.fromRGB(0, 0, 0)
        highlight.BorderSizePixel = 0
        highlight.Size = UDim2.new(0, 1, 0, 20)

        local label = Instance.new('TextLabel')
        label.Parent = frame
        label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1.000
        label.BorderColor3 = Color3.fromRGB(0, 0, 0)
        label.BorderSizePixel = 0
        label.Position = UDim2.new(0, 7, 0, 0)
        label.Size = UDim2.new(1, -7, 0, 20)
        label.Font = Enum.Font.Code
        label.Text = name
        label.TextColor3 = Color3.fromRGB(235, 235, 235)
        label.TextSize = 12.000
        label.TextStrokeTransparency = 0.000
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.RichText = true

        local new_notify = {
            frame = frame,
            label = label
        }
        table.insert(self.noti1, new_notify)

        function new_notify:set(name)
            self.label.Text = name 
            tweenservice:Create(self.frame, TweenInfo.new(.25), {Size = UDim2.new(0, label.TextBounds.x + 10, 0, 20)}):Play()
        end

        tweenservice:Create(frame, TweenInfo.new(.25), {Size = UDim2.new(0, label.TextBounds.x + 10, 0, 20)}):Play()
        task.delay(time, function()
            local tween = tweenservice:Create(frame, TweenInfo.new(.25), {Size = UDim2.new(0, 0, 0, 20)})
            tween:Play()
            tween.Completed:Wait()
            frame:Destroy()
            table.remove(self.noti1, table.find(self.noti1, new_notify))
            for i, v in pairs(self.noti1) do 
                tweenservice:Create(v.frame, TweenInfo.new(.25), {Position = UDim2.new(0.00543056615, 0, 0.088089332, (i - 1) * 30)}):Play()
            end
        end)

        return new_notify
    end

    function library:notify2(name, time)
        local name, time = name or 'Notify1', time or 1

        local label = Instance.new('TextLabel')
        label.AnchorPoint = Vector2.new(.5, .5)
        label.Parent = screen_gui
        label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1.000
        label.BorderColor3 = Color3.fromRGB(0, 0, 0)
        label.BorderSizePixel = 0
        label.Position = UDim2.new(0.5, 0, 0.9, #self.noti2 * -30)
        label.Size = UDim2.new(0, 0, 0, 20)
        label.Font = Enum.Font.Code
        label.Text = name
        label.TextColor3 = Color3.fromRGB(235, 235, 235)
        label.TextSize = 12.000
        label.TextStrokeTransparency = 0.000
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.RichText = true
        label.ClipsDescendants = true

        local new_notify = {
            label = label
        }
        table.insert(self.noti2, new_notify)

        function new_notify:set(name)
            self.label.Text = name 
            tweenservice:Create(label, TweenInfo.new(.25), {Size = UDim2.new(0, label.TextBounds.x + 10, 0, 20)}):Play()
        end

        tweenservice:Create(label, TweenInfo.new(.25), {Size = UDim2.new(0, label.TextBounds.x + 10, 0, 20)}):Play()
        task.delay(time, function()
            local tween = tweenservice:Create(label, TweenInfo.new(.25), {Size = UDim2.new(0, 0, 0, 20)})
            tween:Play()
            tween.Completed:Wait()
            label:Destroy()
            table.remove(self.noti2, table.find(self.noti2, new_notify))
            for i, v in pairs(self.noti2) do 
                tweenservice:Create(v.label, TweenInfo.new(.25), {Position = UDim2.new(0.5, 0, 0.9, (i - 1) * -30)}):Play()
            end
        end)

        return new_notify
    end
end

return library

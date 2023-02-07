-- Did this to learn oop

-- // Vars \\ -- 
local players = game:GetService('Players')
local client = players.LocalPlayer 
local chr = client.Character 
local root = chr.HumanoidRootPart
local camera = workspace.CurrentCamera

-- // Stuff \\ -- 
local function Draw(obj, props)
    local a = Drawing.new(obj)
    
    for i,v in pairs(props) do 
        a[i] = v 
    end
    
    return a 
end

local points = {'TL', 'TR', 'BL', 'BR'}

local lib = {}
lib.__index = lib 

function lib.create_drawings(player)
    local drawings = {}
    setmetatable(drawings, lib)
    
    drawings.names = Draw('Text', {Color = Color3.fromRGB(255,255,255), Center = true})
    drawings.tracer = Draw('Line', {Color = Color3.fromRGB(255,255,255), Thickness = 1})
    drawings.box = {}
    drawings.player = player

    for i,v in pairs(points) do 
        drawings.box['point' .. v] = Draw('Line', {Color = Color3.fromRGB(255,255,255), Thickness = 1})
    end
    
    return drawings
end

function lib.view(self)
    return camera:WorldToViewportPoint(self.Position)
end

function lib:update()
    local player = self.player
    -- // Names \\ -- 
    
    if player.Character and player.Character:FindFirstChild('HumanoidRootPart') and player.Character:FindFirstChild('Humanoid') and player.Character.Humanoid.Health > 0 then 
        local pos, onscreen = self.view((player.Character:FindFirstChild('HumanoidRootPart').CFrame * CFrame.new(0,4,0)))
        self.names.Text = player.Name 
        self.names.Position = Vector2.new(pos.x, pos.y) - Vector2.new(0, self.names.TextBounds.y)
        self.names.Visible = onscreen
        
        -- // Tracers \\ -- 
        local pos, onscreen = self.view((player.Character:FindFirstChild('HumanoidRootPart').CFrame * CFrame.new(0,-3,0)))
        self.tracer.From = Vector2.new(camera.ViewportSize.x / 2, camera.ViewportSize.y / 1)
        self.tracer.To = Vector2.new(pos.x, pos.y)
        self.tracer.Visible = onscreen
        
        -- // Boxes \\ -- 
        local posTL = lib.view((player.Character:FindFirstChild('HumanoidRootPart').CFrame * CFrame.new(-2,3,0)))
        local posTR = lib.view((player.Character:FindFirstChild('HumanoidRootPart').CFrame * CFrame.new(2,3,0)))
        local posBL = lib.view((player.Character:FindFirstChild('HumanoidRootPart').CFrame * CFrame.new(-2,-3,0)))
        local posBR = lib.view((player.Character:FindFirstChild('HumanoidRootPart').CFrame * CFrame.new(2,-3,0)))
        
        self.box.pointTL.From = Vector2.new(posTL.x, posTL.y)
        self.box.pointTL.To = Vector2.new(posTR.x, posTR.y)
        
        self.box.pointBL.From = Vector2.new(posBL.x, posBL.y)
        self.box.pointBL.To = Vector2.new(posTL.x, posTL.y)
        
        self.box.pointBR.From = Vector2.new(posBR.x, posBR.y)
        self.box.pointBR.To = Vector2.new(posBL.x, posBL.y)
        
        self.box.pointTR.From = Vector2.new(posTR.x, posTR.y)
        self.box.pointTR.To = Vector2.new(posBR.x, posBR.y)
        
        self.box.pointTL.Visible = onscreen
        self.box.pointBL.Visible = onscreen
        self.box.pointBR.Visible = onscreen
        self.box.pointTR.Visible = onscreen
    else
        for i,v in pairs(self) do 
            if type(v) == 'table' then 
                v.Visible = false 
                v.pointTL.Visible = false
                v.pointTR.Visible = false
                v.pointBL.Visible = false
                v.pointBR.Visible = false
            end
        end
    end
end

function lib.new_esp(player)
    local a = lib.create_drawings(player)
    
    game:GetService('RunService').RenderStepped:Connect(function()
        a:update() 
    end)
end

for i,v in pairs(players:GetPlayers()) do 
    lib.new_esp(v)
end

local uiLoader = loadstring(game:HttpGet('https://raw.githubusercontent.com/LeadMarker/OpenSource/main/dollarware.lua'))

local ui = uiLoader({rounding = true, theme = 'blueberry',smoothDragging = false })
ui.autoDisableToggles = true

local window = ui.newWindow({text = 'LeadMarker#1219 - Anime Evolution Simulator',resize = true,size = Vector2.new(550, 376),position = nil})

-- // Variables \\ -- 
local client = game.Players.LocalPlayer 
local chr = client.Character or client.CharacterAdded:Wait() 
local root = chr:WaitForChild('HumanoidRootPart')
getgenv().flags = {}

-- // Functions \\ -- 
local function get_coins()
    for i,v in pairs(workspace.__DROPS:GetChildren()) do 
        v.CanCollide = false
        v.CFrame = root.CFrame
    end
end

local function get_area()
    local dist, area = math.huge
    
    for i,v in pairs(workspace.__CURRENTAREA:GetChildren()) do 
        local mag = (root.Position - v.Position).magnitude 
        
        if mag < dist then 
            dist = mag 
            area = v 
        end
    end
    
    return tostring(area)
end

local all_areas = {} do 
    for i,v in pairs(workspace.__CURRENTAREA:GetChildren()) do 
        table.insert(all_areas, v.Name)
    end
end

local function farming_areas()
    local areas = {}
    
    for i,v in pairs(workspace.__WORKSPACE.Mobs:GetChildren()) do 
        if table.find(flags.chosenareas, v.Name) then 
            table.insert(areas, v)
        end
    end
    
    return areas
end

local function attack(what)
    for i,v in pairs(what:GetChildren()) do
        game:GetService("ReplicatedStorage").Remotes.Client:FireServer({'AttackMob', v, 'Left Arm'})
    end
end

local function get_hit()
    local dist, hit = math.huge 
    
    for i,v in pairs(workspace.__WORKSPACE.Areas:GetChildren()) do 
        if v:IsA('Model') and v:FindFirstChild('HitPart') then 
            local mag = (root.Position - v.HitPart.Position).magnitude 
            
            if mag < dist then 
                dist = mag 
                hit = v
            end
        end
    end
    
    return hit
end

-- // Extras \\ -- 
local label

-- // Ui Functions \\ -- 
do
    local menu_credits = window:addMenu({text = 'Credits'}) do 
        local section = menu_credits:addSection({text = 'Credits', showMinButton = false})
        
        section:addLabel({text = 'Scripter / LeadMarker#1219'})
        section:addLabel({text = 'UI / topit#4057'})
    end
    
    local menu_main = window:addMenu({text = 'Main'}) do 
        local section1 = menu_main:addSection({text = 'Farming'}) do 
            section1:addMultiDropdown({text = 'Select Area(s)', options = all_areas}):bindToEvent('optionClick', function(self)
                flags.chosenareas = self
            end)
            
            section1:addSlider({text = 'Attack Delay (Reduce Lag)', min = 0, max = 1, step = .1, val = .1}):bindToEvent('onNewValue', function(self)
                flags.delay = self
            end):setTooltip('0.5 Recommended')
            
            section1:addToggle({text = 'Autofarm'}):bindToEvent('onToggle', function(self)
                flags.autofarm = self
            end)
            
            section1:addSector()
            
            section1:addToggle({text = 'Collect Coins'}):bindToEvent('onToggle', function(self)
                flags.autocoin = self
            end)
            
            section1:addToggle({text = 'Auto Power'}):bindToEvent('onToggle', function(self)
                flags.autopower = self 
            end)
            
            section1:addToggle({text = 'Farm Door Key'}):bindToEvent('onToggle', function(self)
                flags.doorkey = self 
            end):setTooltip("Go in the yellow circle, if it's not working turn off [Auto Power]")
        end
        
        local section2 = menu_main:addSection({text = 'Info', showMinButton = false, side = 'right'}) do 
            label = section2:addLabel({text = 'Current Area:'}) 
        end
    end
end

-- // Main Script \\ -- 
task.spawn(function()
    while task.wait() do
        if flags.autofarm then 
            for i,v in pairs(farming_areas()) do 
                attack(v)
                wait(flags.delay)
            end
        end
        
        if flags.autocoin then 
            get_coins()
        end
        
        if flags.autopower then 
            game:GetService("ReplicatedStorage").Remotes.Client:FireServer({"PowerTrain"})
        end
        
        if flags.doorkey then 
            game:GetService("ReplicatedStorage").Remotes.Client:FireServer({"PowerTrain", get_hit()})
        end
        
        label:setText('Current Area: ' .. get_area())
    end
end)

local players = game:GetService('Players')
local workspace = game:GetService('Workspace')

local client = players.LocalPlayer
local cars = workspace.Cars 
local random_pos = Vector3.new(math.random(0, 10000), math.random(0, 10000), math.random(0, 10000))
local current = tick()

for i,v in pairs(getconnections(client.Idled)) do 
    v:Disable()
end

local seconds = 300

local part = Instance.new('Part', workspace)
part.Name = 'leadmarker'
part.Position = random_pos
part.Anchored = true 
part.Size = Vector3.new(50, 5, 50)

local get_car, cash_stuff; do 
    get_car = function()
        for i, car in pairs(cars:GetChildren()) do 
            local owner = car:FindFirstChild('Owner')
            
            if (car:IsA('Model') and owner and owner.Value == client) then 
                return car 
            end
        end
    end
    
    cash_stuff = function()
        for i,v in pairs(get_car():GetDescendants()) do 
            if (v.ClassName == 'VectorForce') then 
                v.Force = Vector3.new(500000, 0, 500000)
            end
        end
    end
end

while (task.wait()) do
    local mag = (get_car().PrimaryPart.Position - random_pos).magnitude 
    
    if (tick() - current > seconds) then 
        task.wait(10)
        current = tick()
    else
        if (mag > 250) then 
            get_car():SetPrimaryPartCFrame(CFrame.new(random_pos))
        end
        
        part.CFrame = get_car().PrimaryPart.CFrame * CFrame.new(0, -5, 0)
        cash_stuff()
    end
end

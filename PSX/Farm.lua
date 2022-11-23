local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Design/Libraries/main/Revenant.lua", true))()

-- // Vars \\ --
local client = game.Players.LocalPlayer
local chr = client.Character
local root = chr.HumanoidRootPart
getgenv().flags = {}
local gc = getgc()

local keys = {
    join_coin = '',
    farm_coin = '', 
    farm_coin2 = '',
    collect_coin = ''
}

-- stole this from topit
local isexecclosure = is_synapse_function or 
    is_exec_closure or 
    is_exec_func or 
    is_exec_function or 
    is_executor_closure or 
    is_executor_func or 
    is_executor_function or
    is_our_closure or 
    is_our_func or
    is_our_function or 
    is_synapse_closure or 
    is_synapse_func or 
    is_synapse_function or 
    iselectronfunction or 
    isexecclosure or 
    isexecfunc or 
    isexecfunction or 
    isexecutorclosure or
    isexecutorfunc or 
    isexecutorfunction or
    isfluxusfunction or 
    iskrnlclosure or
    iskrnlfunction or
    isourclosure or 
    isourfunc or
    isourfunction or
    isoxygenfunction
--- 

local library = require(game:GetService("ReplicatedStorage").Framework.Library)
local network = library.Network

local save = library.Save.Get()
local pets = save.Pets 

local e_pets = {} do 
    for i,v in pairs(pets) do 
        if rawget(v, 'e') then 
            table.insert(e_pets, v.uid)
        end
    end
end

-- // Key Grabber \\ -- 
for i,v in next, gc do 
    if type(v) == 'function' and islclosure(v) and not isexecclosure(v) then 
        local constants = getconstants(v)
        
        if getinfo(v).name == 'NetworkUpdate' and table.find(constants, 'Network') and table.find(constants, 'Fire') then 
            keys.farm_coin = getconstant(v, 14)
        elseif table.find(constants, 'Network') and table.find(constants, 'rbxassetid://7004964432') then 
            keys.join_coin = getconstant(v, 28)
            keys.farm_coin2 = getconstant(getproto(v, 5), 7)
        elseif getinfo(v).name == 'Collect' and table.find(constants, 'QueueOrbSound') then 
            keys.collect_coin = getconstant(getproto(v, 1), 3)
        end
    end
end

-- // Functions \\ -- 
local function get_coin()
    local dist, coin = math.huge 
    
    for i,v in next, workspace.__THINGS.Coins:GetChildren() do 
        if v:IsA('Folder') and v:FindFirstChild('Coin') then 
            local mag = (root.Position - v.Coin.Position).magnitude 
            
            if mag < dist then 
                dist = mag 
                coin = v 
            end
        end
    end
    
    return coin 
end

local function collect_coins()
    if #game:GetService("Workspace")["__THINGS"].Orbs:GetChildren() > 0 then 
        for i,v in next, game:GetService("Workspace")["__THINGS"].Orbs:GetChildren() do 
            network.Fire(keys.collect_coin, {v.Name})
        end
    end
end

local function get_coin_radius()
   local coins = {}
    
    for i,v in next, workspace.__THINGS.Coins:GetChildren() do 
        if v:IsA('Folder') and v:FindFirstChild('Coin') then 
            local mag = (root.Position - v.Coin.Position).magnitude 
            
            if mag < 300 then 
                table.insert(coins, v)
            end
        end
    end
    
    return coins 
end

local function break_coin(coin, pets)
    network.Invoke(keys.join_coin, coin:GetAttribute("ID"), pets)
    for i,v in next, pets do 
        network.Fire(keys.farm_coin, v, 'Coin', coin:GetAttribute("ID"))
        network.Fire(keys.farm_coin2, coin:GetAttribute("ID"), v)
        task.wait()
    end
end

do -- // Ui Functions \\ -- 
    local main = ui:Window({Text = "LeadMarker#1219 - PSX"}) do 
        main:Toggle({
            Text = "Farm Nearest Coin",
            Callback = function(self)
                flags.farmcoin = self
                
                while task.wait() and flags.farmcoin do 
                    break_coin(get_coin(), e_pets)
                end
            end
        })
    
        main:Toggle({
            Text = "Farm Area (laggy)",
            Callback = function(self)
                flags.farmarea = self
                
                while task.wait() and flags.farmarea do 
                    for i,v in pairs(get_coin_radius()) do
                        if not flags.farmarea then return end 
                        break_coin(v, e_pets) 
                    end
                end
            end
        })
    
        main:Toggle({
            Text = "Collect Coins",
            Callback = function(self)
                flags.collectcoins = self
                
                while task.wait(.1) and flags.collectcoins do 
                    collect_coins()
                end
            end
        })
    
        main:Button({
            Text = 'Refresh Pets',
            Callback = function()
                table.clear(e_pets) 
                
                for i,v in pairs(pets) do 
                    if rawget(v, 'e') then 
                        table.insert(e_pets, v.uid)
                    end
                end
            end
        })
    
        ui:Notification({
            Text = "Made by LeadMarker#1219",
            Duration = 9e9
        })
    end
end

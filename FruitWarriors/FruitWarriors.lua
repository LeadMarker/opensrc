local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/JRL-lav/Scripts/main/U", true))()
local window = library:CreateWindow('LeadMarker#1219')

local players = game:GetService('Players')
local workspace = game:GetService('Workspace')
local replicatedstorage = game:GetService('ReplicatedStorage')
local http_service = game:GetService('HttpService')

local flags = library.flags
local client = players.LocalPlayer
local mobs = workspace.Mobs
local quests = client.Data.Quests
local req = (syn and syn.request) or (http and http.request) or (KRNL_LOADED and http_request) or (fluxus and fluxus.request) or request -- infinite yiel

for i,v in pairs(getconnections(client.Idled)) do 
    v:Disable()
end

getgenv().isnetworkowner = isnetworkowner or function(part) return part.ReceiveAge == 0 end -- found on githb

local function is_running()
    return library.open
end

local main = window:AddFolder('Main') do 
    local quest_table = {}
    do 
        for i, v in pairs(getgc(true)) do 
            if (type(v) == 'table' and rawget(v, 'Quest') and rawget(v, 'Text')) then 
                table.insert(quest_table, v.Quest)
            end
            
            if (#quest_table == 16) then break end
        end
        
        for i = 1, math.floor(#quest_table/2) do -- stole this from dev forum
            local j = #quest_table - i + 1
            quest_table[i], quest_table[j] = quest_table[j], quest_table[i]
        end
    end
    
    local function get_mob(overwrite)
        local dist = math.huge 
        local mob = nil 
        
        for i,v in pairs(workspace.Mobs:GetChildren()) do
            local m_root = v:FindFirstChild('HumanoidRootPart')
            local m_head = v:FindFirstChild('Head')
            local char = client.Character 
            local root = char and char:FindFirstChild('HumanoidRootPart')
            
            if (not overwrite or v.Name == overwrite and m_root and char and root and m_head and m_head.Transparency == 0) then 
                local mag = (m_root.Position - root.Position).magnitude 
                
                if (mag < dist) then 
                    dist = mag 
                    mob = v 
                end
            end
        end
        
        return mob
    end
    
    local function attack()
        if (client.Backpack:FindFirstChild(flags.chosen_weapon)) then 
            client.Character.Humanoid:EquipTool(client.Backpack:FindFirstChild(flags.chosen_weapon))
        else
            if (get_mob() ~= nil) then 
                game:GetService("ReplicatedStorage").Remotes.Mouse1Combat:FireServer(flags.chosen_weapon, 4)
                game:GetService("ReplicatedStorage").Remotes.M1sDamage:FireServer(flags.chosen_weapon, get_mob())
            end
        end
    end

    local function get_weapons()
        local weap = {}

        for i,v in pairs(client.Backpack:GetChildren()) do
            if (v:IsA('Tool') and v:FindFirstChild('Main') and #v:GetChildren() >= 2) then 
                table.insert(weap, v.Name)
            end
        end

        return weap
    end

    main:AddToggle({text = "Autofarm", flag = "autofarm", state = false})
    main:AddToggle({text = "Farm Nearest", flag = "autofarm_near", state = false})

    main:AddList({text = "Select Weapon", flag = "chosen_weapon", value = get_weapons()[1], values = get_weapons()})
    main:AddList({text = "Select Mob / Quest", flag = "chosen_mob", value = "Bandit (Level 1)", values = quest_table})

    main:AddToggle({text = "Chest Farm", flag = "chest_farm", state = false})
    main:AddToggle({text = 'Hide Name', flag = 'hide_name', state = false})
    
    task.spawn(function()
        while (is_running()) do 
            if (flags.autofarm or flags.autofarm_near) then 
                local char = client.Character 
                local root = char and char:FindFirstChild('HumanoidRootPart')
                
                if (char and root) then 
                    local target = (flags.autofarm and get_mob(flags.chosen_mob)) or get_mob()
                    local hum = target:FindFirstChild('Humanoid')
                    
                    if (quests:GetAttribute('QuestName') ~= flags.chosen_mob) then 
                        game:GetService("ReplicatedStorage").Remotes.QuestRemote:FireServer("AbandonQuest")
                        game:GetService("ReplicatedStorage").Remotes.QuestRemote:FireServer("GetQuest", flags.chosen_mob)
                    else
                        if (isnetworkowner(target:FindFirstChild('HumanoidRootPart')) and hum and hum.Health / hum.MaxHealth * 100 <= 75) then 
                            hum.Health = 0
                        end
                        
                        root.CFrame = CFrame.new(target:FindFirstChild('HumanoidRootPart').Position + Vector3.new(0, 8, 0), target:FindFirstChild('HumanoidRootPart').Position)
                        pcall(attack)
                    end
                end
            end
            
            if (flags.chest_farm) then 
                local char = client.Character 
                local root = char and char:FindFirstChild('HumanoidRootPart')
                local size = #workspace.Chests:GetChildren()
                
                if (size > 1 and char and root) then 
                    for i, chest in pairs(workspace.Chests:GetChildren()) do 
                        local part = chest:FindFirstChild('RootPart')
                        local pa = part and part:FindFirstChild('PromptAttachment')
                        local pp = pa and pa:FindFirstChild('ProximityPrompt') 
                        
                        if (part and pa and pp and flags.chest_farm) then 
                            root.CFrame = part.CFrame 
                            fireproximityprompt(pp)
                        end
                    end
                end
            end
            
            if (flags.hide_name) then 
                local char = client.Character 
                local head = char and char:FindFirstChild('Head')
                local name = head and head:FindFirstChild('MobGUI')
                
                if (char and head and name) then 
                    name:Destroy()
                end
            end
            
            task.wait()
        end
    end)
end

local settings = window:AddFolder('Settings') do 
    settings:AddButton({text = 'Unload', callback = function() library:Close() end}) 
end

window:AddButton({text = 'Join Discord', callback = function()
    setclipboard('discord.gg/8Cj5abGrNv')
    req({
        Url = 'http://127.0.0.1:6463/rpc?v=1',
        Method = 'POST',
        Headers = {
            ['Content-Type'] = 'application/json',
            Origin = 'https://discord.com'
        },
        Body = http_service:JSONEncode({
            cmd = 'INVITE_BROWSER',
            nonce = http_service:GenerateGUID(false),
            args = {code = '8Cj5abGrNv'}
        })
    })
end})

library:Init()

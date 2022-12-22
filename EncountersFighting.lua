--[[
    -- Hit Types: Basic, Special, Unique, Ultimate
    getgenv().hit_type = 'Ultimate'
    loadstring(game:HttpGet('https://raw.githubusercontent.com/LeadMarker/opensrc/main/EncountersFighting.lua'))()
]]

-- // Services \\ -- 
local replicatedstorage = game:GetService('ReplicatedStorage')
local players = game:GetService('Players') 

-- // Vars \\ -- 
local client = players.LocalPlayer 
local network = require(replicatedstorage.SharedModules.Network.Client)
local char_name = client.Character:GetAttribute('BaseName')

while task.wait() do
    for i,v in pairs(players:GetPlayers()) do
        if (v ~= client and v.Character and v.Character:FindFirstChild('HumanoidRootPart')) then
            local args = {
                [1] = "DamageRequest",
                [2] = {
                    ["char"] = game:GetService("Players").LocalPlayer.Character,
                    ["direction"] = Vector3.new(0.1,0.1,0.1),
                    ["charName"] = char_name,
                    ["charhit"] = v.Character,
                    ["attackType"] = hit_type
                }
            }
            
            network:FireServer(unpack(args))
            task.wait()
        end
    end
end

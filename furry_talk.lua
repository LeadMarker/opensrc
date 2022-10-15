getgenv().furry_talk = true 
loadstring(game:HttpGet("https://raw.githubusercontent.com/StepBroFurious/Script/main/Text2Furry.lua"))()
-- https://v3rmillion.net/member.php?action=profile&uid=485191 (StepBroFurious)

local old; old = hookmetamethod(game, '__namecall', function(self, ...)
    local method, args = getnamecallmethod(), {...}
    
    if method == 'FireServer' and self.Name == 'SayMessageRequest' and args[1] and furry_talk then 
        local msg = args[1] 
        args[1] = encode(msg)
        
        return old(self, unpack(args))
    end
    
    return old(self, ...)
end)

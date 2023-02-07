local old;
old = hookmetamethod(game, '__namecall', function(...)
    local self, args = ..., {...}
    local method = getnamecallmethod() 
    
    if method == 'FireServer' and string.find(self.Name, 'mod') then 
        return 
    end
    
    return old(...)
end)

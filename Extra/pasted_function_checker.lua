-- There is a rare chance that this will work since they might just change the names or just localize the functions.

local info_table = { -- Edit your stuff here
    ['get_player'] = {
        constants = {'player not found'},
        upvalues = {}
    },
    ['find_something'] = {
        constants = {},
        upvalues = {'Enemy1'}
    }
}

getrawmetatable(getfenv()).__newindex = function(self, key, value)
    if (info_table[key]) then 
        local constants = getconstants(value)
        local upvalues = getupvalues(value)
        local found = {}
        
        local function check_constants(name, func)
            local constants = getconstants(func)
            
            for i, constant in pairs(constants) do 
                if (table.find(info_table[name].constants, constant) and not table.find(found, name .. ' : pasted')) then 
                    table.insert(found, name .. ' : pasted')
                end
            end
        end
        
        local function check_upvalues(name, func)
            local upvalues = getupvalues(func)
            
            for i, upvalue in pairs(upvalues) do
                if (table.find(info_table[name].upvalues, upvalue) and not table.find(found, name .. ' : pasted')) then 
                    table.insert(found, name .. ' : pasted')
                end
            end
        end
        
        check_constants(key, value)
        check_upvalues(key, value)
        
        if (#found > 0) then 
            local fixed = table.concat(found, '\n')
            print(fixed)
        end
    end
end

-- // Random Functions \\ --
function get_player(player)
    local target_player = player or 'player not found'
    
    for i,v in pairs(game:GetService('Players'):GetPlayers()) do 
        if (v ~= game:GetService('Players').LocalPlayer and v == player) then 
            target_player = player 
        end
    end
    
    return target_player
end

local main_target = 'Enemy1'

function find_something()
    if (game:GetService('Workspace'):FindFirstChild(main_target)) then 
        return true 
    end
    
    return false
end

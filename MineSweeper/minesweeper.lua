local parts = workspace.Flag.Parts
local players = game:GetService('Players')
local client = players.LocalPlayer 

local key
for i,v in pairs(getgc()) do 
    if (type(v) == 'function' and islclosure(v)) then 
        local upvalues = debug.getupvalues(v)

        if (#upvalues == 4 and type(upvalues[1]) == 'function' and debug.getinfo(upvalues[1]).name == 'getRaycastResult') then 
            key = upvalues[4]
        end
    end

    if (key) then break end
end

local function get_num(part)
	return tonumber(part.NumberGui.TextLabel.Text)
end

local function is_hidden(part)
	return (get_num(part) == 0)
end

local function get_radius(part)
	local around = {}

	local origin = part.Position + Vector3.new(0, 5, 0)

	local rays = {
		Ray.new(origin + Vector3.new(0, 0, -3), Vector3.new(0, -5, 0)),
		Ray.new(origin + Vector3.new(0, 0, 3), Vector3.new(0, -5, 0)),
		Ray.new(origin + Vector3.new(3, 0, 0), Vector3.new(0, -5, 0)),
		Ray.new(origin + Vector3.new(-3, 0, 0), Vector3.new(0, -5, 0)),
		Ray.new(origin + Vector3.new(3, 0, -3), Vector3.new(0, -5, 0)),
		Ray.new(origin + Vector3.new(3, 0, 3), Vector3.new(0, -5, 0)),
		Ray.new(origin + Vector3.new(-3, 0, -3), Vector3.new(0, -5, 0)),
		Ray.new(origin + Vector3.new(-3, 0, 3), Vector3.new(0, -5, 0))
	}

	for i,v in pairs(rays) do 
		local test = workspace:FindPartOnRayWithIgnoreList(v, {client.Character})
		if (test ~= nil) then 
			around[i] = test
		end
	end

	return around
end

local function get_hidden_parts(tab)
	local amt = 0;
	local parts = {}

	for i,v in pairs(tab) do 
		if (is_hidden(v)) then 
			amt = amt + 1 
			table.insert(parts, v)
		end
	end

	return amt, parts
end

local function get_flags(part)
	local around = {}

	local origin = part.Position + Vector3.new(0, 11, 0)

	local rays = {
		Ray.new(origin + Vector3.new(0, 0, -5), Vector3.new(0, -11, 0)),
		Ray.new(origin + Vector3.new(0, 0, 5), Vector3.new(0, -11, 0)),
		Ray.new(origin + Vector3.new(5, 0, 0), Vector3.new(0, -11, 0)),
		Ray.new(origin + Vector3.new(-5, 0, 0), Vector3.new(0, -11, 0)),
		Ray.new(origin + Vector3.new(5, 0, -5), Vector3.new(0, -11, 0)),
		Ray.new(origin + Vector3.new(5, 0, 5), Vector3.new(0, -11, 0)),
		Ray.new(origin + Vector3.new(-5, 0, -5), Vector3.new(0, -11, 0)),
		Ray.new(origin + Vector3.new(-5, 0, 5), Vector3.new(0, -11, 0))
	}

	for i,v in pairs(rays) do 
		local test = workspace:FindPartOnRayWithIgnoreList(v, {client.Character})
		
		if (test ~= nil and test.Parent.Name:find('Flag')) then 
			table.insert(around, test)
		end
	end

	return around
end

local function apply_flags(target, num, parts)
	if (num == target) then 
		for i = 1, target do 
			local part = parts[i]
			
			if (not part:FindFirstChildWhichIsA('Model')) then 
				game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FlagEvents"):WaitForChild("PlaceFlag"):FireServer(part, key, true)			
			end
		end
	end
end

while (task.wait(.1)) do
    for i, v in pairs(parts:GetChildren()) do
        local area = get_radius(v)
        local num, hidden_parts = get_hidden_parts(area)
        apply_flags(get_num(v), num, hidden_parts)

        local flags = get_flags(v)

		if (get_num(v) ~= 0 and get_num(v) ~= nil and get_num(v) == #flags) then 
			for _ , touch in pairs(hidden_parts) do 
				firetouchinterest(client.Character.HumanoidRootPart, touch, 0)
				firetouchinterest(client.Character.HumanoidRootPart, touch, 1)
			end
		end
    end
end

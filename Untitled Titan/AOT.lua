-- @leadmarker 

if (not game:IsLoaded()) then 
	task.wait()
end

-- Services 
local players = game:GetService('Players')
local tweenservice = game:GetService('TweenService')

-- Variables
local client = players.LocalPlayer 
local positions = { mission = Vector3.new(1, 1, 235), wave = Vector3.new(234, 1, -1) }
local exp_type = (identifyexecutor() == 'Krnl' and Krnl) or Fluxus

-- Functions
local function moveto(Target, TeleportSpeed)
	if (typeof(Target) == "Instance" and Target:IsA("BasePart")) then Target = Target.Position; end;
	if (typeof(Target) == "CFrame") then Target = Target.p end;

	local HRP = (client.Character and client.Character:FindFirstChild("HumanoidRootPart"));
	if (not HRP) then return; end;

	local StartingPosition = HRP.Position;
	local PositionDelta = (Target - StartingPosition);
	local StartTime = tick();
	local TotalDuration = (StartingPosition - Target).magnitude / TeleportSpeed;

	repeat game:GetService("RunService").Heartbeat:Wait();
		local Delta = tick() - StartTime;
		local Progress = math.min(Delta / TotalDuration, 1);
		local MappedPosition = StartingPosition + (PositionDelta * Progress);
		HRP.Velocity = Vector3.new();
		HRP.CFrame = CFrame.new(MappedPosition);
	until (HRP.Position - Target).magnitude <= TeleportSpeed / 2000;
	HRP.Anchored = false;
	HRP.CFrame = CFrame.new(Target);
end

local function get_titan()
	local titan = nil 
	local dist = math.huge 

	for i, v in pairs(workspace.Entities.Titans:GetChildren()) do 
		if (v:IsA('Model')) then 
			local root = v and v:FindFirstChild('HumanoidRootPart')
			local humanoid = v and v:FindFirstChild('Humanoid')

			local char = client.Character 
			local my_root = char and char:FindFirstChild('HumanoidRootPart')

			if (root and humanoid and my_root) then 
				local mag = (my_root.Position - root.Position).magnitude 
				if (mag > dist) then continue end 

				titan = v 
				dist = mag 
			end
		end
	end

	return titan
end

while (task.wait()) do 
	if (game.PlaceId == 6372960231) then 
		moveto(CFrame.new(positions[settings.mission_type]), settings.tween_speed)

		if (settings.mission_type == 'mission') then 
			game:GetService("ReplicatedStorage").Remotes.VotedMapEvent:FireServer(1)
		end
	else 
		local target = get_titan()
		local root = target and target:FindFirstChild('HumanoidRootPart')
		local humanoid = target and target:FindFirstChild('Humanoid')

		if (root and humanoid) then 
			moveto(root.CFrame * CFrame.new(0, 0, 5), settings.tween_speed)
			game:GetService("ReplicatedStorage").DamageEvent:FireServer(nil, humanoid, '&@&*&@&', target)
		end
	end
end

if (exp_type == 'Fluxus') then 
	Fluxus.queue_on_teleport([[
		getgenv().settings = {
			mission_type = settings.mission_type
			tween_speed = settings.tween_speed
		}

		loadstring(game:HttpGet('https://github.com/LeadMarker/opensrc/blob/main/Untitled%20Titan/AOT.lua'))()
	]])
else
	queue_on_teleport([[
		getgenv().settings = {
			mission_type = settings.mission_type
			tween_speed = settings.tween_speed
		}

		loadstring(game:HttpGet('https://github.com/LeadMarker/opensrc/blob/main/Untitled%20Titan/AOT.lua'))()
	]])
end

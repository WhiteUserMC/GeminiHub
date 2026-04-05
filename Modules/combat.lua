local lplr = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local VIM = game:GetService("VirtualInputManager")

-- [[ CONNECTING TO MAIN UI ]]
local aura = _G.GeminiModules.Combat.List[1]
local hitbox = _G.GeminiModules.Combat.List[2]
local reach = _G.GeminiModules.Combat.List[3]

local function GetNearest()
    local target, nearestDist = nil, aura.Range or 15
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lplr and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local hrp = v.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (lplr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    target = v
                end
            end
        end
    end
    return target
end

task.spawn(function()
    while _G.GeminiActive do
        if aura.Enabled and lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") then
            local target = GetNearest()
            if target and target.Character then
                local tool = lplr.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Reach Logic
                    local targetHrp = target.Character.HumanoidRootPart
                    local mag = (lplr.Character.HumanoidRootPart.Position - targetHrp.Position).Magnitude
                    
                    if mag <= (aura.Range + (reach.Enabled and reach.Distance or 0)) then
                        -- Silent Aim / Face Target
                        if aura.SilentAim then
                            lplr.Character.HumanoidRootPart.CFrame = CFrame.lookAt(lplr.Character.HumanoidRootPart.Position, Vector3.new(targetHrp.Position.X, lplr.Character.HumanoidRootPart.Position.Y, targetHrp.Position.Z))
                        end
                        
                        -- Attack
                        tool:Activate()
                        
                        -- AutoBlock Simulation
                        if aura.AutoBlock then
                            VIM:SendMouseButtonEvent(0, 0, 1, true, game, 0)
                            task.wait(0.05)
                            VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
                        end
                    end
                end
            end
        end
        
        -- Hitbox Logic (Constant Update)
        if hitbox.Enabled then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= lplr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(hitbox.Size, hitbox.Size, hitbox.Size)
                    v.Character.HumanoidRootPart.Transparency = 0.7
                    v.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
        
        task.wait(1 / (aura.CPS or 15))
    end
end)

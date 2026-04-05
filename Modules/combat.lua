local Combat = {}
local lplr = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local function GetNearest()
    local target, nearestDist = nil, _G.GeminiModules.Combat.List[1].Range or 15
    if not lplr.Character or not lplr.Character:FindFirstChild("HumanoidRootPart") then return nil end
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lplr and v.Character then
            local hum = v.Character:FindFirstChild("Humanoid")
            local hrp = v.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local dist = (lplr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < nearestDist then nearestDist = dist; target = v end
            end
        end
    end
    return target
end

task.spawn(function()
    while _G.GeminiActive do
        local aura = _G.GeminiModules.Combat.List[1]
        local aim = _G.GeminiModules.Combat.List[2]
        local hitbox = _G.GeminiModules.Combat.List[3]
        local reach = _G.GeminiModules.Combat.List[4]

        if aura.Enabled and lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") then
            local t = GetNearest()
            if t and t.Character then
                local tool = lplr.Character:FindFirstChildOfClass("Tool")
                local targetHrp = t.Character:FindFirstChild("HumanoidRootPart")
                
                if tool and targetHrp then
                    if hitbox.Enabled then
                        targetHrp.Size = Vector3.new(hitbox.Size, hitbox.Size, hitbox.Size)
                        targetHrp.Transparency = 0.8
                        targetHrp.CanCollide = false
                    end

                    local oldCF = lplr.Character.HumanoidRootPart.CFrame
                    
                    if aura.SilentAim then
                        lplr.Character.HumanoidRootPart.CFrame = CFrame.lookAt(lplr.Character.HumanoidRootPart.Position, targetHrp.Position + Vector3.new(0, -1.8, 0))
                    end

                    if reach.Enabled then
                        lplr.Character.HumanoidRootPart.CFrame = targetHrp.CFrame * CFrame.new(0, 0, reach.Distance)
                    end

                    tool:Activate()

                    if aura.AutoBlock then
                        task.spawn(function()
                            VIM:SendMouseButtonEvent(0, 0, 1, true, game, 0)
                            task.wait(0.05)
                            VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
                        end)
                    end

                    task.wait()
                    lplr.Character.HumanoidRootPart.CFrame = oldCF
                end
                task.wait(1 / (aura.CPS + math.random(-2, 2)))
            else task.wait(0.1) end
        else
            task.wait(0.5)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not _G.GeminiActive then return end
    local aim = _G.GeminiModules.Combat.List[2]
    if aim.Enabled and lplr.Character then
        local t = GetNearest()
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            local pos = t.Character.HumanoidRootPart.Position
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, pos), aim.Smooth or 0.5)
        end
    end
end)

return Combat

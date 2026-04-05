local lplr = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Lấy data từ UI (Đúng thứ tự trong main.lua)
local Combat = _G.GeminiModules.Combat.List
local aura = Combat[1]
local aim = Combat[2]
local velocity = Combat[3]
local reach = Combat[4]

local function GetNearest()
    local target, nearestDist = nil, aura.Range or 18
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lplr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local dist = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                target = v
            end
        end
    end
    return target
end

RunService.Heartbeat:Connect(function()
    if not _G.GeminiActive or not lplr.Character then return end
    local target = GetNearest()
    
    if target and target.Character then
        -- [[ AIM ASSIST ]]
        if aim.Enabled then
            local targetPos = target.Character.HumanoidRootPart.Position
            camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, targetPos), aim.Smoothness or 0.1)
        end

        -- [[ KILLAURA ]]
        if aura.Enabled then
            local tool = lplr.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end

    -- [[ VELOCITY (Anti-Knockback) ]]
    if velocity.Enabled then
        lplr.Character.HumanoidRootPart.Velocity = Vector3.new(
            lplr.Character.HumanoidRootPart.Velocity.X * (velocity.Horizontal / 100),
            lplr.Character.HumanoidRootPart.Velocity.Y * (velocity.Vertical / 100),
            lplr.Character.HumanoidRootPart.Velocity.Z * (velocity.Horizontal / 100)
        )
    end
end)

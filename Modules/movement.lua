local lplr = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local Move = _G.GeminiModules.Movement.List
local speed = Move[1]
local fly = Move[2]
local longjump = Move[3]

RunService.Heartbeat:Connect(function()
    if not _G.GeminiActive or not lplr.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = lplr.Character.HumanoidRootPart
    local hum = lplr.Character.Humanoid

    -- [[ SPEED CFRAME ]]
    if speed.Enabled and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (speed.Value / 50))
    end

    -- [[ FLY ]]
    if fly.Enabled then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 2, hrp.Velocity.Z) -- Giữ độ cao
    end
    
    -- [[ LONG JUMP ]]
    if longjump.Enabled and UIS:IsKeyDown(Enum.KeyCode.Space) then
        hrp.Velocity = hrp.Velocity + (hum.MoveDirection * longjump.Boost)
    end
end)

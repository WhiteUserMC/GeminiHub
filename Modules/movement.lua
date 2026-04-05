local lplr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ CONNECTING TO MAIN UI ]]
local fly = _G.GeminiModules.Movement.List[1]
local speed = _G.GeminiModules.Movement.List[2]
local fakelag = _G.GeminiModules.Movement.List[3]

local tickCount = 0

task.spawn(function()
    while _G.GeminiActive do
        if lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = lplr.Character.HumanoidRootPart
            local hum = lplr.Character:FindFirstChildOfClass("Humanoid")

            -- SPEED LOGIC
            if speed.Enabled then
                local moveDir = hum.MoveDirection
                hrp.Velocity = Vector3.new(moveDir.X * (speed.Value or 35), hrp.Velocity.Y, moveDir.Z * (speed.Value or 35))
            end

            -- FLY LOGIC
            if fly.Enabled then
                local flyVel = Vector3.new(0, 0.9, 0) -- Hover force
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    flyVel = flyVel + Vector3.new(0, fly.Value or 50, 0)
                elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                    flyVel = flyVel + Vector3.new(0, -(fly.Value or 50), 0)
                end
                hrp.Velocity = (hum.MoveDirection * (fly.Value or 50)) + flyVel
            end

            -- FAKELAG LOGIC (LiquidBounce Style Pulse)
            if fakelag.Enabled then
                tickCount = tickCount + 1
                if tickCount <= (fakelag.Limit or 15) then
                    -- Choke Packets
                    sethiddenproperty(lplr, "NetworkSecondaryRegion", hrp.Position + Vector3.new(9e9, 9e9, 9e9))
                else
                    -- Flush Packets
                    sethiddenproperty(lplr, "NetworkSecondaryRegion", hrp.Position)
                    tickCount = 0
                end
            else
                sethiddenproperty(lplr, "NetworkSecondaryRegion", hrp.Position)
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

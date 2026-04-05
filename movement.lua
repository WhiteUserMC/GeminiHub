local Movement = {}
local lplr = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local function CreateGhost(cf)
    local g = Instance.new("Part", workspace)
    g.Size = Vector3.new(2, 2, 1)
    g.CFrame = cf
    g.CanCollide = false
    g.Anchored = true
    g.Material = Enum.Material.Neon
    g.Color = Color3.fromRGB(65, 130, 255)
    g.Transparency = 0.6
    local m = Instance.new("SpecialMesh", g)
    m.MeshType = Enum.SpecialMeshType.Brick
    task.delay(0.15, function()
        TweenService:Create(g, TweenInfo.new(0.2), {Transparency = 1}):Play()
        task.wait(0.2)
        g:Destroy()
    end)
end

task.spawn(function()
    local tickCount = 0
    while _G.GeminiActive do
        local fly = _G.GeminiModules.Movement.List[1]
        local speed = _G.GeminiModules.Movement.List[2]
        local blink = _G.GeminiModules.Movement.List[3]
        local fakelag = _G.GeminiModules.Movement.List[4]

        if lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = lplr.Character.HumanoidRootPart
            local hum = lplr.Character:FindFirstChildOfClass("Humanoid")

            -- FLY LOGIC
            if fly.Enabled then
                local moveDir = hum.MoveDirection
                local flySpeed = fly.Value or 50
                local yVel = 0
                if UIS:IsKeyDown(Enum.KeyCode.Space) then yVel = flySpeed 
                elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then yVel = -flySpeed end
                
                hrp.Velocity = (moveDir * flySpeed) + Vector3.new(0, yVel + 0.9, 0)
                if moveDir.Magnitude == 0 and yVel == 0 then
                    hrp.Velocity = Vector3.new(0, 0.9, 0)
                end
            end

            -- SPEED LOGIC
            if speed.Enabled and not fly.Enabled then
                local moveDir = hum.MoveDirection
                local sVal = speed.Value or 25
                hrp.Velocity = Vector3.new(moveDir.X * sVal, hrp.Velocity.Y, moveDir.Z * sVal)
            end

            -- BLINK & FAKELAG (PACKET CHOKING)
            if fakelag.Enabled or blink.Enabled then
                tickCount = tickCount + 1
                local limit = fakelag.Enabled and (fakelag.Limit or 15) or 9e9
                
                if tickCount < limit then
                    if not hrp:FindFirstChild("GeminiAnchor") then
                        local att = Instance.new("BodyVelocity", hrp)
                        att.Name = "GeminiAnchor"
                        att.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                        att.Velocity = Vector3.new(0, 0, 0)
                    end
                    if tickCount % 5 == 0 then CreateGhost(hrp.CFrame) end
                    sethiddenproperty(lplr, "NetworkSecondaryRegion", hrp.Position + Vector3.new(9e9, 9e9, 9e9))
                else
                    if hrp:FindFirstChild("GeminiAnchor") then hrp.GeminiAnchor:Destroy() end
                    sethiddenproperty(lplr, "NetworkSecondaryRegion", hrp.Position)
                    tickCount = 0
                end
            else
                if hrp:FindFirstChild("GeminiAnchor") then hrp.GeminiAnchor:Destroy() end
                sethiddenproperty(lplr, "NetworkSecondaryRegion", hrp.Position)
                tickCount = 0
            end
        end
        RS.Heartbeat:Wait()
    end
end)

return Movement

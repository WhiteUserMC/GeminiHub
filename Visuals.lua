local Visuals = {}
local lplr = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RS = game:GetService("RunService")

local function CreateESP(target)
    local Box = Drawing.new("Square")
    local Tracer = Drawing.new("Line")
    local Name = Drawing.new("Text")
    local HealthBar = Drawing.new("Line")

    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 255, 255)
    Box.Thickness = 1
    Box.Filled = false

    Tracer.Visible = false
    Tracer.Color = Color3.fromRGB(255, 255, 255)
    Tracer.Thickness = 1

    Name.Visible = false
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Size = 14
    Name.Center = true
    Name.Outline = true
    Name.Font = 2

    HealthBar.Visible = false
    HealthBar.Thickness = 2
    HealthBar.Color = Color3.fromRGB(0, 255, 0)

    local function Update()
        local c
        c = RS.RenderStepped:Connect(function()
            if not _G.GeminiActive or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") or not target.Character:FindFirstChild("Humanoid") or target.Character.Humanoid.Health <= 0 then
                Box.Visible = false; Tracer.Visible = false; Name.Visible = false; HealthBar.Visible = false
                if not _G.GeminiActive then c:Disconnect() end
                return
            end

            local hrp = target.Character.HumanoidRootPart
            local hum = target.Character.Humanoid
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local mod = _G.GeminiModules.Visuals.List

            if onScreen and mod[1].Enabled then
                local sizeY = 4000 / pos.Z
                local sizeX = 2500 / pos.Z
                local x = pos.X - sizeX / 2
                local y = pos.Y - sizeY / 2

                if mod[2].Enabled then
                    Box.Size = Vector2.new(sizeX, sizeY)
                    Box.Position = Vector2.new(x, y)
                    Box.Visible = true
                else Box.Visible = false end

                if mod[3].Enabled then
                    Name.Text = target.Name
                    Name.Position = Vector2.new(pos.X, y - 15)
                    Name.Visible = true
                    
                    HealthBar.From = Vector2.new(x - 5, y + sizeY)
                    HealthBar.To = Vector2.new(x - 5, y + sizeY - (sizeY * (hum.Health / hum.MaxHealth)))
                    HealthBar.Color = Color3.fromRGB(255 - (255 * (hum.Health / 100)), 255 * (hum.Health / 100), 0)
                    HealthBar.Visible = true
                else Name.Visible = false; HealthBar.Visible = false end

                if mod[4].Enabled then
                    Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    Tracer.To = Vector2.new(pos.X, y + sizeY)
                    Tracer.Visible = true
                else Tracer.Visible = false end
            else
                Box.Visible = false; Tracer.Visible = false; Name.Visible = false; HealthBar.Visible = false
            end
        end)
    end
    Update()
end

for _, v in pairs(game.Players:GetPlayers()) do if v ~= lplr then CreateESP(v) end end
game.Players.PlayerAdded:Connect(function(v) if v ~= lplr then CreateESP(v) end end)

return Visuals

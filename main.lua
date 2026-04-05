local lplr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

_G.GeminiActive = true
local Gemini = {
    Modules = {
        Combat = {
            List = {
                {Name = "Killaura", Desc = "Attack players automatically.", Enabled = false, Range = 18, CPS = 14},
                {Name = "AimAssist", Desc = "Smoothly guide aim to targets.", Enabled = false, Smoothness = 0.6},
                {Name = "Velocity", Desc = "Modify your take-back knockback.", Enabled = false, Horizontal = 0, Vertical = 0},
                {Name = "Reach", Desc = "Expand your hit distance.", Enabled = false, Distance = 4}
            }
        },
        Movement = {
            List = {
                {Name = "Speed", Desc = "High-speed movement bypass.", Enabled = false, Value = 25},
                {Name = "Fly", Desc = "Defy gravity and soar.", Enabled = false, Value = 50},
                {Name = "LongJump", Desc = "Jump further than normal.", Enabled = false, Boost = 2}
            }
        },
        Visuals = {
            List = {
                {Name = "ESP", Desc = "Outline players through walls.", Enabled = false},
                {Name = "Tracers", Desc = "Snaplines to every player.", Enabled = false},
                {Name = "Fakelag", Desc = "Ghost-like movement effect.", Enabled = false, Limit = 15}
            }
        }
    }
}
_G.GeminiModules = Gemini.Modules

-- [[ RAVEN B4 UI ENGINE ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local function CreateCategory(name, pos)
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 150, 0, 30)
    Frame.Position = pos
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

    local Title = Instance.new("TextLabel", Frame)
    Title.Text = name; Title.Size = UDim2.new(1, 0, 1, 0); Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBold"; Title.BackgroundTransparency = 1

    local Container = Instance.new("Frame", Frame)
    Container.Size = UDim2.new(1, 0, 0, 0); Container.Position = UDim2.new(0, 0, 1, 2); Container.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Container); Layout.Padding = UDim.new(0, 2)

    -- Logic kéo thả (Raven Style)
    local Dragging, DragInput, DragStart, StartPos
    Frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true; DragStart = i.Position; StartPos = Frame.Position end end)
    Frame.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then DragInput = i end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
    RunService.RenderStepped:Connect(function()
        if Dragging and DragInput then
            local Delta = DragInput.Position - DragStart
            Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)

    return Container
end

-- Hàm tạo Module Button chuẩn Raven
local function AddModule(container, mod)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = mod.Name; btn.TextColor3 = Color3.new(0.8, 0.8, 0.8); btn.Font = "Gotham"; btn.BorderSizePixel = 0
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        mod.Enabled = not mod.Enabled
        TweenService:Create(btn, TweenInfo.new(0.3), {
            BackgroundColor3 = mod.Enabled and Color3.fromRGB(65, 130, 255) or Color3.fromRGB(30, 30, 30),
            TextColor3 = mod.Enabled and Color3.new(1,1,1) or Color3.new(0.8, 0.8, 0.8)
        }):Play()
    end)
    
    container.Size = UDim2.new(1, 0, 0, #container:GetChildren() * 32)
end

-- Khởi tạo các cột (Category)
local CombatCat = CreateCategory("COMBAT", UDim2.new(0, 50, 0, 50))
local MoveCat = CreateCategory("MOVEMENT", UDim2.new(0, 210, 0, 50))
local VisualCat = CreateCategory("VISUALS", UDim2.new(0, 370, 0, 50))

for _, m in pairs(Gemini.Modules.Combat.List) do AddModule(CombatCat, m) end
for _, m in pairs(Gemini.Modules.Movement.List) do AddModule(MoveCat, m) end
for _, m in pairs(Gemini.Modules.Visuals.List) do AddModule(VisualCat, m) end

-- [[ SAFE LOADER ]]
local function SafeLoad(file)
    task.spawn(function()
        local success, content = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/WhiteUserMC/GeminiHub/main/Modules/"..file)
        if success and content then
            local f, e = loadstring(content)
            if f then pcall(f) else warn(e) end
        end
    end)
end

SafeLoad("Combat.lua"); SafeLoad("Movement.lua"); SafeLoad("Visuals.lua")

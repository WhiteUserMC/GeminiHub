local lplr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local Gemini = {
    Binding = nil,
    Active = true,
    CurrentTab = "Combat",
    Notifications = {},
    CurrentTheme = {
        Main = Color3.fromRGB(10, 10, 12),
        Sidebar = Color3.fromRGB(15, 15, 18),
        Accent = Color3.fromRGB(65, 130, 255),
        Card = Color3.fromRGB(22, 22, 26),
        OnHex = "#00FF78",
        OffHex = "#FF3C3C"
    },
    Modules = {
        Combat = {
            List = {
                {Name = "Killaura", Enabled = false, Bind = nil, Range = 15, CPS = 18, SilentAim = true, AutoBlock = true, ShowRange = false},
                {Name = "Aim Assist", Enabled = false, Bind = nil, Smooth = 0.5},
                {Name = "Hitbox", Enabled = false, Bind = nil, Size = 10},
                {Name = "Reach", Enabled = false, Bind = nil, Distance = 6}
            }
        },
        Movement = {
            List = {
                {Name = "Fly", Enabled = false, Bind = nil},
                {Name = "Speed", Enabled = false, Bind = nil},
                {Name = "Blink", Enabled = false, Bind = nil},
                {Name = "Fakelag", Enabled = false, Bind = nil}
            }
        },
        Visuals = {
            List = {
                {Name = "ESP", Enabled = false, Bind = nil},
                {Name = "ESP Box", Enabled = false, Bind = nil},
                {Name = "NameTags", Enabled = false, Bind = nil},
                {Name = "Tracer", Enabled = false, Bind = nil}
            }
        },
        Settings = {
            List = {
                {Name = "Self Destruct", Enabled = false, Bind = nil, IsDestruct = true},
                {Name = "UI Toggle", Enabled = true, Bind = Enum.KeyCode.RightShift}
            }
        }
    }
}

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "GeminiHub"

local function Notify(name, state)
    local color = state and Gemini.CurrentTheme.OnHex or Gemini.CurrentTheme.OffHex
    local statusText = state and "ON" or "OFF"
    local text = name .. " <font color=\""..color.."\">" .. statusText .. "</font>"
    local h, g, b = 80, 12, -110
    for i, v in ipairs(Gemini.Notifications) do
        if v and v.Parent then
            TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -340, 1, b - (i * (h + g)))}):Play()
        end
    end
    local f = Instance.new("Frame", ScreenGui); f.Size = UDim2.new(0, 320, 0, h); f.Position = UDim2.new(1, 20, 1, b); f.BackgroundColor3 = Gemini.CurrentTheme.Main; f.BorderSizePixel = 0; Instance.new("UICorner", f)
    local tl = Instance.new("TextLabel", f); tl.Text = "GeminiHub"; tl.Size = UDim2.new(1, -30, 0, 30); tl.Position = UDim2.new(0, 15, 0, 10); tl.TextColor3 = Gemini.CurrentTheme.Accent; tl.Font = Enum.Font.GothamBold; tl.TextSize = 18; tl.BackgroundTransparency = 1; tl.TextXAlignment = Enum.TextXAlignment.Left
    local t = Instance.new("TextLabel", f); t.RichText = true; t.Text = text; t.Size = UDim2.new(1, -30, 0, 20); t.Position = UDim2.new(0, 15, 0, 42); t.TextColor3 = Color3.new(1, 1, 1); t.Font = Enum.Font.GothamBold; t.TextSize = 14; t.BackgroundTransparency = 1; t.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(Gemini.Notifications, 1, f)
    TweenService:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -340, 1, b)}):Play()
    task.delay(4, function()
        local idx = table.find(Gemini.Notifications, f); if idx then table.remove(Gemini.Notifications, idx) end
        local c = TweenService:Create(f, TweenInfo.new(0.5), {Position = UDim2.new(1, 20, 1, f.Position.Y.Offset)}); c:Play(); c.Completed:Connect(function() f:Destroy() end)
    end)
end

local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 560, 0, 380); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new

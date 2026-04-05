local lplr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

-- [[ Global Configuration & Rise-Style Metadata ]]
_G.GeminiActive = true
local Gemini = {
    Binding = nil,
    Active = true,
    CurrentTab = "Combat",
    Notifications = {},
    CurrentTheme = {
        Main = Color3.fromRGB(10, 10, 12),
        Sidebar = Color3.fromRGB(15, 15, 18),
        Accent = Color3.fromRGB(65, 130, 255), -- Blue Accent like Rise
        Card = Color3.fromRGB(22, 22, 26),
        OnHex = "#00FF78",
        OffHex = "#FF3C3C",
        DescColor = Color3.fromRGB(160, 160, 160)
    },
    Modules = {
        Combat = {
            List = {
                {Name = "Killaura", Desc = "Attack players automatically within range.", Enabled = false, Bind = nil, Range = 15, CPS = 18, SilentAim = true, AutoBlock = true},
                {Name = "Aim Assist", Desc = "Gently snaps your aim to the nearest player.", Enabled = false, Bind = nil, Smooth = 0.5},
                {Name = "Hitbox", Desc = "Increases the size of enemy hitboxes.", Enabled = false, Bind = nil, Size = 10},
                {Name = "Reach", Desc = "Extends your reach distance for melee attacks.", Enabled = false, Bind = nil, Distance = 6}
            }
        },
        Movement = {
            List = {
                {Name = "Fly", Desc = "Allows you to fly and move freely in air.", Enabled = false, Bind = nil},
                {Name = "Speed", Desc = "Boosts your walk speed for faster movement.", Enabled = false, Bind = nil, Value = 25},
                {Name = "Blink", Desc = "Stops outgoing packets to simulate teleporting.", Enabled = false, Bind = nil},
                {Name = "Fakelag", Desc = "Creates a ghost trail and desyncs your position.", Enabled = false, Bind = nil, Limit = 15}
            }
        },
        Visuals = {
            List = {
                {Name = "ESP", Desc = "The master switch for player visualization.", Enabled = false, Bind = nil},
                {Name = "ESP Box", Desc = "Draws a 2D box around visible players.", Enabled = false, Bind = nil},
                {Name = "NameTags", Desc = "Shows names and health above players.", Enabled = false, Bind = nil},
                {Name = "Tracer", Desc = "Draws lines connecting you to targets.", Enabled = false, Bind = nil}
            }
        },
        Settings = {
            List = {
                {Name = "Self Destruct", Desc = "Completely removes the script from memory.", Enabled = false, Bind = nil, IsDestruct = true},
                {Name = "UI Toggle", Desc = "Key to open or close this menu.", Enabled = true, Bind = Enum.KeyCode.RightShift}
            }
        }
    }
}
_G.GeminiModules = Gemini.Modules

-- [[ UI Initialization ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "GeminiHub"

-- [[ Notification System ]]
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
    local t = Instance.new("TextLabel", f); t.RichText = true; t.Text = text; t.Size = UDim2.new(1, -30, 1, 0); t.Position = UDim2.new(0, 15, 0, 0); t.TextColor3 = Color3.new(1, 1, 1); t.Font = Enum.Font.GothamBold; t.TextSize = 14; t.BackgroundTransparency = 1; t.TextXAlignment = Enum.TextXAlignment.Left
    table.insert(Gemini.Notifications, 1, f)
    TweenService:Create(f, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -340, 1, b)}):Play()
    task.delay(3, function()
        local idx = table.find(Gemini.Notifications, f); if idx then table.remove(Gemini.Notifications, idx) end
        local c = TweenService:Create(f, TweenInfo.new(0.5), {Position = UDim2.new(1, 20, 1, f.Position.Y.Offset)}); c:Play(); c.Completed:Connect(function() f:Destroy() end)
    end)
end

-- [[ Main UI Setup ]]
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 580, 0, 400); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.BackgroundColor3 = Gemini.CurrentTheme.Main; Main.Active = true; Instance.new("UICorner", Main)
local DragBar = Instance.new("Frame", Main); DragBar.Size = UDim2.new(1, 0, 0, 50); DragBar.BackgroundTransparency = 1; DragBar.ZIndex = 10
local d, di, ds, sp
DragBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = Main.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end) end end)
DragBar.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement then di = i end end)
UIS.InputChanged:Connect(function(i) if i == di and d then local dl = i.Position - ds; Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y) end end)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 150, 1, 0); Sidebar.BackgroundColor3 = Gemini.CurrentTheme.Sidebar; Sidebar.BorderSizePixel = 0; Instance.new("UICorner", Sidebar)
local Title = Instance.new("TextLabel", Sidebar); Title.Text = "GEMINI"; Title.Size = UDim2.new(1, 0, 0, 60); Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 24; Title.BackgroundTransparency = 1
local TabList = Instance.new("Frame", Sidebar); TabList.Size = UDim2.new(1, 0, 1, -80); TabList.Position = UDim2.new(0, 0, 0, 80); TabList.BackgroundTransparency = 1; Instance.new("UIListLayout", TabList).HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.UIListLayout.Padding = UDim.new(0, 5)

local ContentArea = Instance.new("Frame", Main); ContentArea.Size = UDim2.new(1, -150, 1, 0); ContentArea.Position = UDim2.new(0, 150, 0, 0); ContentArea.BackgroundTransparency = 1
local Content = Instance.new("ScrollingFrame", ContentArea); Content.Size = UDim2.new(1, -30, 1, -40); Content.Position = UDim2.new(0, 15, 0, 20); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 0; Content.AutomaticCanvasSize = Enum.AutomaticSize.Y; Instance.new("UIListLayout", Content).Padding = UDim.new(0, 8)

-- [[ Rise Style Card Creation ]]
function CreateCard(mod)
    local Card = Instance.new("Frame", Content); Card.Size = UDim2.new(1, 0, 0, 65); Card.BackgroundColor3 = Gemini.CurrentTheme.Card; Card.BorderSizePixel = 0; Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)
    local ClickArea = Instance.new("TextButton", Card); ClickArea.Size = UDim2.new(1, 0, 1, 0); ClickArea.BackgroundTransparency = 1; ClickArea.Text = ""
    
    if mod.IsDestruct then
        ClickArea.Text = mod.Name; ClickArea.TextColor3 = Color3.new(1,0.3,0.3); ClickArea.Font = Enum.Font.GothamBold; ClickArea.TextSize = 14
        ClickArea.MouseButton1Click:Connect(function() _G.GeminiActive = false; ScreenGui:Destroy() end); return
    end

    local Name = Instance.new("TextLabel", Card); Name.Text = mod.Name; Name.Size = UDim2.new(1, -100, 0, 20); Name.Position = UDim2.new(0, 15, 0, 15); Name.TextColor3 = mod.Enabled and Gemini.CurrentTheme.Accent or Color3.new(1,1,1); Name.BackgroundTransparency = 1; Name.Font = Enum.Font.GothamBold; Name.TextSize = 15; Name.TextXAlignment = Enum.TextXAlignment.Left
    local Desc = Instance.new("TextLabel", Card); Desc.Text = mod.Desc; Desc.Size = UDim2.new(1, -100, 0, 15); Desc.Position = UDim2.new(0, 15, 0, 35); Desc.TextColor3 = Gemini.CurrentTheme.DescColor; Desc.BackgroundTransparency = 1; Desc.Font = Enum.Font.Gotham; Desc.TextSize = 11; Desc.TextXAlignment = Enum.TextXAlignment.Left; Desc.TextTransparency = 0.4
    
    local BindBtn = Instance.new("TextButton", Card); BindBtn.Size = UDim2.new(0, 50, 0, 22); BindBtn.Position = UDim2.new(1, -65, 0, 21); BindBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40); BindBtn.TextColor3 = Color3.fromRGB(150, 150, 150); BindBtn.Text = mod.Bind and mod.Bind.Name:upper():sub(1,3) or "NONE"; BindBtn.Font = Enum.Font.GothamBold; BindBtn.TextSize = 10; Instance.new("UICorner", BindBtn)

    ClickArea.MouseButton1Click:Connect(function()
        mod.Enabled = not mod.Enabled
        Name.TextColor3 = mod.Enabled and Gemini.CurrentTheme.Accent or Color3.new(1,1,1)
        Notify(mod.Name, mod.Enabled)
    end)
    
    BindBtn.MouseButton1Click:Connect(function()
        Gemini.Binding = mod
        BindBtn.Text = "..."
    end)
    
    RunService.RenderStepped:Connect(function()
        if Gemini.Binding ~= mod then BindBtn.Text = mod.Bind and mod.Bind.Name:upper():sub(1,3) or "NONE" end
    end)
end

-- [[ Tab Loader ]]
function LoadTab(cat)
    for _, v in pairs(Content:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, m in pairs(Gemini.Modules[cat].List) do CreateCard(m) end
end

for _, cat in ipairs({"Combat", "Movement", "Visuals", "Settings"}) do
    local b = Instance.new("TextButton", TabList); b.Size = UDim2.new(1, -20, 0, 35); b.Text = cat; b.BackgroundTransparency = 1; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 13
    b.MouseButton1Click:Connect(function() LoadTab(cat) end)
end

-- [[ Input Handling ]]
UIS.InputBegan:Connect(function(i, p)
    if Gemini.Binding then 
        if i.KeyCode == Enum.KeyCode.Escape then Gemini.Binding = nil else Gemini.Binding.Bind = i.KeyCode; Gemini.Binding = nil end
        return 
    end
    if p then return end
    if i.KeyCode == Gemini.Modules.Settings.List[2].Bind then Main.Visible = not Main.Visible end
    for _, cat in pairs(Gemini.Modules) do for _, m in pairs(cat.List) do if m.Bind and i.KeyCode == m.Bind then m.Enabled = not m.Enabled; Name.TextColor3 = m.Enabled and Gemini.CurrentTheme.Accent or Color3.new(1,1,1); Notify(m.Name, m.Enabled) end end end
end)

-- [[ AUTO-LOAD MODULES FROM YOUR GITHUB ]]
local BaseURL = "https://raw.githubusercontent.com/WhiteUserMC/GeminiHub/main/Modules/"

local function InternalLoad(name)
    local s, err = pcall(function() return loadstring(game:HttpGet(BaseURL .. name .. ".lua"))() end)
    if s then print("GeminiHub: Successfully loaded "..name) else warn("GeminiHub: Error loading "..name.." | "..err) end
end

LoadTab("Combat")
InternalLoad("Combat")
InternalLoad("Movement")
InternalLoad("Visuals")

Notify("GeminiHub Loaded!", true)

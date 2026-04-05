local lplr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

_G.GeminiActive = true
local Gemini = {
    Theme = {
        Main = Color3.fromRGB(15, 15, 18),
        Accent = Color3.fromRGB(65, 130, 255),
        Card = Color3.fromRGB(25, 25, 30),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Modules = {
        Combat = { List = {
            {Name = "Killaura", Desc = "Automatically attack players within range.", Enabled = false, Range = 15, CPS = 12},
            {Name = "Aim Assist", Desc = "Gently snaps your aim to targets.", Enabled = false, Smooth = 0.5},
            {Name = "Hitbox", Desc = "Expand enemy hitboxes for easier hits.", Enabled = false, Size = 10},
            {Name = "Reach", Desc = "Increase your melee attack distance.", Enabled = false, Distance = 6}
        }},
        Movement = { List = {
            {Name = "Fly", Desc = "Allows you to fly and move in the air.", Enabled = false, Value = 50},
            {Name = "Speed", Desc = "Boosts your movement speed significantly.", Enabled = false, Value = 35},
            {Name = "Fakelag", Desc = "Desyncs your position to confuse enemies.", Enabled = false, Limit = 15}
        }},
        Visuals = { List = {
            {Name = "ESP Box", Desc = "Draw 2D boxes around players.", Enabled = false},
            {Name = "Tracers", Desc = "Draw lines connecting you to targets.", Enabled = false},
            {Name = "NameTags", Desc = "Show player names above heads.", Enabled = false}
        }}
    }
}
_G.GeminiModules = Gemini.Modules

-- [[ UI SYSTEM ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 500, 0, 380); Main.Position = UDim2.new(0.5, -250, 0.5, -190); Main.BackgroundColor3 = Gemini.Theme.Main; Main.Visible = true; Main.ClipsDescendants = true; Instance.new("UICorner", Main)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Instance.new("UICorner", Sidebar)
local TabContainer = Instance.new("Frame", Sidebar); TabContainer.Size = UDim2.new(1, 0, 1, -50); TabContainer.Position = UDim2.new(0, 0, 0, 50); TabContainer.BackgroundTransparency = 1; local TabLayout = Instance.new("UIListLayout", TabContainer); TabLayout.Padding = UDim.new(0, 5); TabLayout.HorizontalAlignment = "Center"
local ContentFrame = Instance.new("ScrollingFrame", Main); ContentFrame.Size = UDim2.new(1, -160, 1, -20); ContentFrame.Position = UDim2.new(0, 150, 0, 10); ContentFrame.BackgroundTransparency = 1; ContentFrame.ScrollBarThickness = 0; Instance.new("UIListLayout", ContentFrame).Padding = UDim.new(0, 8)

-- [[ FUNCTIONS ]]
local function CreateModuleCard(mod)
    local Card = Instance.new("Frame", ContentFrame); Card.Size = UDim2.new(1, -10, 0, 60); Card.BackgroundColor3 = Gemini.Theme.Card; Instance.new("UICorner", Card); Card.ClipsDescendants = true
    local Name = Instance.new("TextLabel", Card); Name.Text = mod.Name; Name.Size = UDim2.new(1, 0, 0, 25); Name.Position = UDim2.new(0, 12, 0, 10); Name.TextColor3 = mod.Enabled and Gemini.Theme.Accent or Gemini.Theme.Text; Name.Font = "GothamBold"; Name.TextSize = 14; Name.TextXAlignment = "Left"; Name.BackgroundTransparency = 1
    local Desc = Instance.new("TextLabel", Card); Desc.Text = mod.Desc; Desc.Size = UDim2.new(1, -20, 0, 15); Desc.Position = UDim2.new(0, 12, 0, 28); Desc.TextColor3 = Color3.fromRGB(180, 180, 180); Desc.Font = "Gotham"; Desc.TextSize = 10; Desc.TextXAlignment = "Left"; Desc.BackgroundTransparency = 1; Desc.TextTransparency = 0.4
    
    local Click = Instance.new("TextButton", Card); Click.Size = UDim2.new(1, 0, 1, 0); Click.BackgroundTransparency = 1; Click.Text = ""
    
    Click.MouseButton1Click:Connect(function()
        mod.Enabled = not mod.Enabled
        Name.TextColor3 = mod.Enabled and Gemini.Theme.Accent or Gemini.Theme.Text
        TweenService:Create(Card, TweenInfo.new(0.3), {BackgroundColor3 = mod.Enabled and Color3.fromRGB(30, 35, 45) or Gemini.Theme.Card}):Play()
    end)

    -- Chuột phải để bung bảng chỉnh (Animation)
    local Open = false
    Click.MouseButton2Click:Connect(function()
        Open = not Open
        TweenService:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = Open and UDim2.new(1, -10, 0, 160) or UDim2.new(1, -10, 0, 60)}):Play()
    end)
end

local function SwitchTab(cat)
    for _, v in pairs(ContentFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    if Gemini.Modules[cat] then
        for _, mod in pairs(Gemini.Modules[cat].List) do CreateModuleCard(mod) end
    end
end

for catName, _ in pairs(Gemini.Modules) do
    local b = Instance.new("TextButton", TabContainer); b.Size = UDim2.new(0.9, 0, 0, 35); b.Text = catName; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() SwitchTab(catName) end)
end

SwitchTab("Combat")

-- [[ LOADER ]]
local BaseURL = "https://raw.githubusercontent.com/WhiteUserMC/GeminiHub/main/Modules/"
task.spawn(function()
    pcall(function() loadstring(game:HttpGet(BaseURL.."Combat.lua"))() end)
    pcall(function() loadstring(game:HttpGet(BaseURL.."Movement.lua"))() end)
    pcall(function() loadstring(game:HttpGet(BaseURL.."Visuals.lua"))() end)
end)

UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)

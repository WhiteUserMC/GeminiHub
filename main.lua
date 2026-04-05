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
            {Name = "Killaura", Desc = "Attack players within range.", Enabled = false, Range = 15, CPS = 12},
            {Name = "Hitbox", Desc = "Expand enemy hitboxes.", Enabled = false, Size = 10}
        }},
        Movement = { List = {
            {Name = "Fly", Desc = "Fly freely in the air.", Enabled = false, Value = 50},
            {Name = "Speed", Desc = "Boost movement speed.", Enabled = false, Value = 35}
        }},
        Visuals = { List = {
            {Name = "ESP Box", Desc = "Draw 2D boxes around players.", Enabled = false},
            {Name = "Tracers", Desc = "Draw lines to other players.", Enabled = false},
            {Name = "NameTags", Desc = "Display names above heads.", Enabled = false}
        }}
    }
}
_G.GeminiModules = Gemini.Modules

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 500, 0, 350); Main.Position = UDim2.new(0.5, -250, 0.5, -175); Main.BackgroundColor3 = Gemini.Theme.Main; Main.Visible = false; Instance.new("UICorner", Main)

-- Sidebar & Content (Giữ nguyên logic chuyển Tab)
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Instance.new("UICorner", Sidebar)
local TabContainer = Instance.new("Frame", Sidebar); TabContainer.Size = UDim2.new(1, 0, 1, -50); TabContainer.Position = UDim2.new(0, 0, 0, 50); TabContainer.BackgroundTransparency = 1; local TabLayout = Instance.new("UIListLayout", TabContainer); TabLayout.Padding = UDim.new(0, 5); TabLayout.HorizontalAlignment = "Center"
local ContentFrame = Instance.new("ScrollingFrame", Main); ContentFrame.Size = UDim2.new(1, -160, 1, -20); ContentFrame.Position = UDim2.new(0, 150, 0, 10); ContentFrame.BackgroundTransparency = 1; ContentFrame.ScrollBarThickness = 0; Instance.new("UIListLayout", ContentFrame).Padding = UDim.new(0, 8)

function CreateModuleCard(mod)
    local Card = Instance.new("Frame", ContentFrame); Card.Size = UDim2.new(1, -10, 0, 60); Card.BackgroundColor3 = Gemini.Theme.Card; Instance.new("UICorner", Card)
    local Name = Instance.new("TextLabel", Card); Name.Text = mod.Name; Name.Size = UDim2.new(1, 0, 0, 25); Name.Position = UDim2.new(0, 12, 0, 10); Name.TextColor3 = mod.Enabled and Gemini.Theme.Accent or Gemini.Theme.Text; Name.Font = "GothamBold"; Name.TextSize = 14; Name.TextXAlignment = "Left"; Name.BackgroundTransparency = 1
    local Desc = Instance.new("TextLabel", Card); Desc.Text = mod.Desc; Desc.Size = UDim2.new(1, -20, 0, 15); Desc.Position = UDim2.new(0, 12, 0, 28); Desc.TextColor3 = Color3.fromRGB(180, 180, 180); Desc.Font = "Gotham"; Desc.TextSize = 10; Desc.TextXAlignment = "Left"; Desc.BackgroundTransparency = 1; Desc.TextTransparency = 0.4
    local Click = Instance.new("TextButton", Card); Click.Size = UDim2.new(1, 0, 1, 0); Click.BackgroundTransparency = 1; Click.Text = ""
    Click.MouseButton1Click:Connect(function()
        mod.Enabled = not mod.Enabled
        Name.TextColor3 = mod.Enabled and Gemini.Theme.Accent or Gemini.Theme.Text
        TweenService:Create(Card, TweenInfo.new(0.3), {BackgroundColor3 = mod.Enabled and Color3.fromRGB(30, 35, 45) or Gemini.Theme.Card}):Play()
    end)
    Click.MouseButton2Click:Connect(function() -- Animation mở rộng khi chuột phải
        TweenService:Create(Card, TweenInfo.new(0.4), {Size = Card.Size.Y.Offset == 60 and UDim2.new(1, -10, 0, 150) or UDim2.new(1, -10, 0, 60)}):Play()
    end)
end

function SwitchTab(cat)
    for _, v in pairs(ContentFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, mod in pairs(Gemini.Modules[cat].List) do CreateModuleCard(mod) end
end

for catName, _ in pairs(Gemini.Modules) do
    local b = Instance.new("TextButton", TabContainer); b.Size = UDim2.new(0.9, 0, 0, 35); b.Text = catName; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() SwitchTab(catName) end)
end

SwitchTab("Combat")
UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)

-- Loader
local BaseURL = "https://raw.githubusercontent.com/WhiteUserMC/GeminiHub/main/Modules/"
task.spawn(function()
    loadstring(game:HttpGet(BaseURL.."Combat.lua"))()
    loadstring(game:HttpGet(BaseURL.."Movement.lua"))()
    loadstring(game:HttpGet(BaseURL.."Visuals.lua"))()
end)

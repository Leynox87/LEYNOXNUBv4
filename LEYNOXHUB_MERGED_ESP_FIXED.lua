--[[
    LEYNOXHUB V1 + V2
    LocalScript for YOUR OWN Roblox experience.
    Place in StarterPlayer > StarterPlayerScripts.
    This is a Studio/game-development utility panel, not an executor loader.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local old = playerGui:FindFirstChild("LEYNOXHUB")
if old then old:Destroy() end

local themes = {
    {Name = "Neon Green", Color = Color3.fromRGB(75, 255, 115)},
    {Name = "Purple", Color = Color3.fromRGB(190, 105, 255)},
    {Name = "Cyan", Color = Color3.fromRGB(65, 220, 255)},
    {Name = "Red", Color = Color3.fromRGB(255, 75, 85)},
    {Name = "Orange", Color = Color3.fromRGB(255, 155, 65)},
    {Name = "Pink", Color = Color3.fromRGB(255, 100, 190)},
    {Name = "Blue", Color = Color3.fromRGB(85, 135, 255)},
    {Name = "White", Color = Color3.fromRGB(235, 245, 238)},
}

local cfg = {
    Aim = false, AimDistance = 500, AimFOV = 180, Smoothness = 0.85,
    TargetPart = "Head", VisibleCheck = true, EnemiesOnly = true,
    ESP = true, ESPDistance = 2000, ESPNames = true, ESPHealth = true,
    ESPDistanceText = true, ESPHighlight = true,
    Fly = false, FlySpeed = 55, Noclip = false, WalkSpeed = 16,
    ShowStats = true, ShowFPS = true, ShowPing = true,
    Crosshair = true, FOVCircle = true,
    InfiniteJump = false, AutoShot = false,
    ThemeIndex = 1, Rainbow = false, Transparency = 0.04,
}

local defaults = table.clone(cfg)

local accent = themes[1].Color
local rainbowHue = 0
local palette = {
    bg = Color3.fromRGB(10, 13, 11),
    panel = Color3.fromRGB(17, 22, 18),
    panel2 = Color3.fromRGB(25, 32, 27),
    panel3 = Color3.fromRGB(34, 43, 36),
    text = Color3.fromRGB(238, 245, 239),
    muted = Color3.fromRGB(145, 160, 148),
    red = Color3.fromRGB(255, 75, 75),
    green = Color3.fromRGB(75, 255, 115),
}

local function tw(obj, duration, props)
    local t = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function outline(obj, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or accent
    s.Transparency = transparency or 0.2
    s.Thickness = 1
    s.Parent = obj
    return s
end

local gui = Instance.new("ScreenGui")
gui.Name = "LEYNOXHUB"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(690, 475)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.BackgroundColor3 = palette.bg
main.BackgroundTransparency = cfg.Transparency
main.BorderSizePixel = 0
main.Parent = gui
round(main, 13)
local mainStroke = outline(main, accent, 0.08)

local scale = Instance.new("UIScale")
scale.Parent = main
local function fit()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
    scale.Scale = math.clamp(math.min((vp.X - 18) / 690, (vp.Y - 35) / 475), 0.48, 1)
end
fit()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
end

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 58)
top.BackgroundColor3 = palette.panel
top.BackgroundTransparency = cfg.Transparency
top.BorderSizePixel = 0
top.Parent = main
round(top, 13)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(18, 0)
title.Size = UDim2.new(0, 185, 1, 0)
title.Font = Enum.Font.GothamBlack
title.Text = "LEYNOXHUB"
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = palette.text
title.Parent = top

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(190, 1)
subtitle.Size = UDim2.new(0, 190, 1, 0)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "V1 FEATURES  /  V2 UI"
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextColor3 = accent
subtitle.Parent = top

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(36, 32)
close.Position = UDim2.new(1, -49, 0, 13)
close.BackgroundColor3 = palette.panel3
close.Text = "×"
close.TextColor3 = palette.text
close.TextSize = 22
close.Font = Enum.Font.GothamBold
close.AutoButtonColor = false
close.Parent = top
round(close, 8)

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(0, 58)
sidebar.Size = UDim2.new(0, 158, 1, -58)
sidebar.BackgroundColor3 = palette.panel
sidebar.BackgroundTransparency = cfg.Transparency
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 15)
sidePad.PaddingLeft = UDim.new(0, 10)
sidePad.PaddingRight = UDim.new(0, 10)
sidePad.Parent = sidebar

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 7)
sideLayout.Parent = sidebar

local pageTitle = Instance.new("TextLabel")
pageTitle.BackgroundTransparency = 1
pageTitle.Position = UDim2.fromOffset(180, 69)
pageTitle.Size = UDim2.new(1, -200, 0, 27)
pageTitle.Font = Enum.Font.GothamBold
pageTitle.Text = "AIM"
pageTitle.TextSize = 18
pageTitle.TextColor3 = palette.text
pageTitle.TextXAlignment = Enum.TextXAlignment.Left
pageTitle.Parent = main

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(177, 105)
content.Size = UDim2.new(1, -194, 1, -120)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = accent
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new()
content.Parent = main

local pages, tabButtons, refreshers = {}, {}, {}

local function label(parent, text, size, color, bold)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Text = text
    x.TextColor3 = color or palette.text
    x.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    x.TextSize = size or 12
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.Parent = parent
    return x
end

local function button(parent, text, height)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, height or 34)
    b.BackgroundColor3 = palette.panel2
    b.Text = text
    b.TextColor3 = palette.text
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    b.AutoButtonColor = false
    b.Parent = parent
    round(b, 7)
    b.MouseEnter:Connect(function() tw(b, 0.12, {BackgroundColor3 = palette.panel3}) end)
    b.MouseLeave:Connect(function() tw(b, 0.12, {BackgroundColor3 = palette.panel2}) end)
    b.MouseButton1Down:Connect(function() tw(b, 0.07, {BackgroundColor3 = accent}) end)
    return b
end

local function section(parent, text)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, -4, 0, 50)
    box.AutomaticSize = Enum.AutomaticSize.Y
    box.BackgroundColor3 = palette.panel
    box.BackgroundTransparency = cfg.Transparency
    box.BorderSizePixel = 0
    box.Parent = parent
    round(box, 9)
    outline(box, accent, 0.78)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 11)
    pad.PaddingBottom = UDim.new(0, 11)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = box
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.Parent = box
    local h = label(box, string.upper(text), 10, accent, true)
    h.Size = UDim2.new(1, 0, 0, 17)
    return box
end

local function page(name)
    local p = Instance.new("Frame")
    p.Name = name
    p.Size = UDim2.new(1, -4, 0, 0)
    p.AutomaticSize = Enum.AutomaticSize.Y
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = content
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 10)
    l.Parent = p
    pages[name] = p
    return p
end

local function toggle(parent, text, key)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 29)
    row.BackgroundTransparency = 1
    row.Parent = parent
    local t = label(row, text, 12, palette.text, false)
    t.Size = UDim2.new(1, -58, 1, 0)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(42, 22)
    b.Position = UDim2.new(1, -42, 0.5, -11)
    b.Text = ""
    b.AutoButtonColor = false
    b.BackgroundColor3 = cfg[key] and accent or palette.panel3
    b.Parent = row
    round(b, 20)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(16, 16)
    dot.Position = cfg[key] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.Parent = b
    round(dot, 20)
    local function refresh()
        tw(b, 0.14, {BackgroundColor3 = cfg[key] and accent or palette.panel3})
        tw(dot, 0.14, {Position = cfg[key] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
    end
    table.insert(refreshers, refresh)
    b.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        refresh()
    end)
end

local function slider(parent, text, key, minV, maxV, step)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 51)
    wrap.BackgroundTransparency = 1
    wrap.Parent = parent
    local name = label(wrap, text, 11, palette.text, false)
    name.Size = UDim2.new(1, -60, 0, 18)
    local val = label(wrap, tostring(cfg[key]), 11, accent, true)
    val.Size = UDim2.fromOffset(55, 18)
    val.Position = UDim2.new(1, -55, 0, 0)
    val.TextXAlignment = Enum.TextXAlignment.Right
    local bar = Instance.new("Frame")
    bar.Position = UDim2.fromOffset(0, 29)
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.BackgroundColor3 = palette.panel3
    bar.Parent = wrap
    round(bar, 8)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((cfg[key] - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = accent
    fill.Parent = bar
    round(fill, 8)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(13, 13)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
    knob.BackgroundColor3 = palette.text
    knob.Parent = bar
    round(knob, 10)
    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Size = UDim2.new(1, 0, 0, 25)
    hit.Position = UDim2.fromOffset(0, 20)
    hit.Parent = wrap
    local function setValue(x)
        local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
        local v = math.floor((minV + (maxV - minV) * a) / step + 0.5) * step
        cfg[key] = math.clamp(v, minV, maxV)
        local pct = (cfg[key] - minV) / (maxV - minV)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, 0, 0.5, 0)
        val.Text = tostring(cfg[key])
    end
    local dragging = false
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setValue(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setValue(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    table.insert(refreshers, function()
        local pct = (cfg[key] - minV) / (maxV - minV)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, 0, 0.5, 0)
        val.Text = tostring(cfg[key])
    end)
end

local function choice(parent, text, key, options)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundTransparency = 1
    row.Parent = parent
    local t = label(row, text, 11, palette.text, false)
    t.Size = UDim2.new(0.48, 0, 1, 0)
    local b = button(row, tostring(cfg[key]), 29)
    b.Size = UDim2.new(0.5, 0, 0, 29)
    b.Position = UDim2.new(0.5, 0, 0, 1)
    local function refresh() b.Text = tostring(cfg[key]) end
    table.insert(refreshers, refresh)
    b.MouseButton1Click:Connect(function()
        local i = table.find(options, cfg[key]) or 0
        cfg[key] = options[(i % #options) + 1]
        refresh()
    end)
end

local function showPage(name)
    for n, p in pairs(pages) do p.Visible = n == name end
    for n, b in pairs(tabButtons) do
        local active = n == name
        tw(b, 0.12, {BackgroundColor3 = active and Color3.fromRGB(31, 58, 37) or palette.panel})
        b.TextColor3 = active and accent or palette.muted
    end
    pageTitle.Text = string.upper(name)
    content.CanvasPosition = Vector2.zero
end

local function addTab(name, symbol)
    local b = button(sidebar, symbol .. "   " .. name, 36)
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.TextSize = 12
    b.TextColor3 = palette.muted
    b.BackgroundColor3 = palette.panel
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = b
    tabButtons[name] = b
    b.MouseButton1Click:Connect(function() showPage(name) end)
end

-- AIM PAGE
local aimPage = page("Aim")
local a = section(aimPage, "Aim assist")
toggle(a, "Enable Aim Assist", "Aim")
toggle(a, "Visible Check", "VisibleCheck")
toggle(a, "Enemies Only", "EnemiesOnly")
toggle(a, "FOV Circle", "FOVCircle")
slider(a, "Aim Distance", "AimDistance", 50, 2000, 25)
slider(a, "FOV Radius", "AimFOV", 30, 500, 10)
slider(a, "Aim Sharpness", "Smoothness", 0.01, 1, 0.01)
choice(a, "Target Part", "TargetPart", {"Head", "HumanoidRootPart"})

-- ESP PAGE
local espPage = page("ESP")
local e = section(espPage, "Player ESP")
toggle(e, "Enable ESP", "ESP")
toggle(e, "Highlight", "ESPHighlight")
toggle(e, "Player Names", "ESPNames")
toggle(e, "Health", "ESPHealth")
toggle(e, "Distance", "ESPDistanceText")
slider(e, "ESP Distance", "ESPDistance", 100, 5000, 100)
local espNote = label(e, "Enemies: red  /  Teammates: current theme color", 10, palette.muted, false)
espNote.Size = UDim2.new(1, 0, 0, 20)

-- MOVEMENT PAGE
local movePage = page("Movement")
local m = section(movePage, "Movement")
toggle(m, "Fly", "Fly")
slider(m, "Fly Speed", "FlySpeed", 10, 200, 5)
toggle(m, "Noclip", "Noclip")
slider(m, "Walk Speed", "WalkSpeed", 8, 100, 1)
toggle(m, "Infinite Jump", "InfiniteJump")

local flyHint = label(m, "Mobile: use your movement joystick. Use the on-screen UP / DOWN buttons while flying.", 10, palette.muted, false)
flyHint.Size = UDim2.new(1, 0, 0, 30)
flyHint.TextWrapped = true

-- VISUALS PAGE
local visualPage = page("Visuals")
local v = section(visualPage, "Performance overlay")
toggle(v, "Show performance panel", "ShowStats")
toggle(v, "Show FPS", "ShowFPS")
toggle(v, "Show Ping", "ShowPing")
toggle(v, "Center Crosshair", "Crosshair")

-- THEMES PAGE
local themePage = page("Themes")
local th = section(themePage, "Appearance")
local themeName = label(th, "Theme: " .. themes[cfg.ThemeIndex].Name, 11, accent, true)
themeName.Size = UDim2.new(1, 0, 0, 20)
local themeButton = button(th, "Change Theme Color", 34)
themeButton.MouseButton1Click:Connect(function()
    cfg.ThemeIndex = (cfg.ThemeIndex % #themes) + 1
    accent = themes[cfg.ThemeIndex].Color
    themeName.Text = "Theme: " .. themes[cfg.ThemeIndex].Name
end)
toggle(th, "Rainbow / RGB animation", "Rainbow")
slider(th, "Menu Transparency", "Transparency", 0, 0.65, 0.01)
local transparencyNote = label(th, "Transparency applies to the main panels and cards.", 10, palette.muted, false)
transparencyNote.Size = UDim2.new(1, 0, 0, 18)
local themeHint = label(th, "The accent color also updates the L button, menu borders, controls, FOV and teammate ESP.", 10, palette.muted, false)
themeHint.Size = UDim2.new(1, 0, 0, 36)
themeHint.TextWrapped = true


-- MISC PAGE: V1 utilities
local miscPage = page("Misc")
local miscSection = section(miscPage, "Utilities")
toggle(miscSection, "Auto Shot (equipped Tool)", "AutoShot")

local finderLabel = label(miscSection, "Player Finder: choose a player below", 10, palette.muted, false)
finderLabel.Size = UDim2.new(1, 0, 0, 20)
local selectedPlayer = nil

local playerButton = button(miscSection, "Select Player", 32)
playerButton.MouseButton1Click:Connect(function()
    local list = Players:GetPlayers()
    for _, target in ipairs(list) do
        if target ~= player then
            selectedPlayer = target
            playerButton.Text = target.Name
            finderLabel.Text = "Selected: " .. target.Name
            break
        end
    end
end)

local spectateButton = button(miscSection, "Spectate Selected", 32)
spectateButton.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character then
        local hum = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then camera.CameraSubject = hum end
    end
end)

local stopSpectateButton = button(miscSection, "Stop Spectating", 32)
stopSpectateButton.MouseButton1Click:Connect(function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then camera.CameraSubject = hum end
end)

-- SETTINGS PAGE
local settingsPage = page("Settings")
local st = section(settingsPage, "Interface")
local reset = button(st, "Reset settings", 34)
local settingsInfo = label(st, "Settings are kept for this play session. This panel is intended for your own Roblox experience in Studio.", 10, palette.muted, false)
settingsInfo.Size = UDim2.new(1, 0, 0, 42)
settingsInfo.TextWrapped = true

addTab("Aim", "◎")
addTab("ESP", "◉")
addTab("Movement", "↗")
addTab("Misc", "◇")
addTab("Visuals", "▣")
addTab("Themes", "✧")
addTab("Settings", "⚙")
showPage("Aim")


-- Draggable main window (V1 behavior)
local mainDragging, mainDragStart, mainStartPosition = false, nil, nil
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = true
        mainDragStart = input.Position
        mainStartPosition = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if mainDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mainDragStart
        main.Position = UDim2.new(
            mainStartPosition.X.Scale, mainStartPosition.X.Offset + delta.X,
            mainStartPosition.Y.Scale, mainStartPosition.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = false
    end
end)

-- Floating L button, draggable
local floating = Instance.new("TextButton")
floating.Name = "LEYNOX_TOGGLE"
floating.Size = UDim2.fromOffset(52, 52)
floating.Position = UDim2.new(0, 18, 0.68, 0)
floating.BackgroundColor3 = palette.bg
floating.Text = "L"
floating.TextColor3 = accent
floating.Font = Enum.Font.GothamBlack
floating.TextSize = 24
floating.AutoButtonColor = false
floating.Parent = gui
round(floating, 50)
local floatStroke = outline(floating, accent, 0.05)

local floatDrag, floatMoved, floatStart, floatPosition = false, false, nil, nil
floating.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDrag, floatMoved = true, false
        floatStart, floatPosition = input.Position, floating.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if floatDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - floatStart
        if delta.Magnitude > 5 then floatMoved = true end
        floating.Position = UDim2.new(floatPosition.X.Scale, floatPosition.X.Offset + delta.X, floatPosition.Y.Scale, floatPosition.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then floatDrag = false end
end)

local function hideMenu()
    tw(main, 0.16, {BackgroundTransparency = 1, Size = UDim2.fromOffset(660, 450)})
    task.delay(0.17, function() if main.Parent then main.Visible = false end end)
end
local function showMenu()
    main.Visible = true
    main.Size = UDim2.fromOffset(660, 450)
    tw(main, 0.16, {BackgroundTransparency = cfg.Transparency, Size = UDim2.fromOffset(690, 475)})
end
close.MouseButton1Click:Connect(hideMenu)
floating.MouseButton1Click:Connect(function()
    if floatMoved then return end
    if main.Visible then hideMenu() else showMenu() end
end)

-- FOV and crosshair
local fov = Instance.new("Frame")
fov.Name = "FOVCircle"
fov.AnchorPoint = Vector2.new(0.5, 0.5)
fov.Position = UDim2.fromScale(0.5, 0.5)
fov.Size = UDim2.fromOffset(cfg.AimFOV * 2, cfg.AimFOV * 2)
fov.BackgroundTransparency = 1
fov.Parent = gui
round(fov, 500)
local fovStroke = outline(fov, accent, 0.25)

local cross = Instance.new("Frame")
cross.Size = UDim2.fromOffset(5, 5)
cross.AnchorPoint = Vector2.new(0.5, 0.5)
cross.Position = UDim2.fromScale(0.5, 0.5)
cross.BackgroundColor3 = accent
cross.BorderSizePixel = 0
cross.Parent = gui
round(cross, 10)

-- Performance HUD
local statsBox = Instance.new("Frame")
statsBox.Size = UDim2.fromOffset(145, 48)
statsBox.Position = UDim2.new(1, -158, 0, 14)
statsBox.BackgroundColor3 = palette.bg
statsBox.BackgroundTransparency = cfg.Transparency
statsBox.Parent = gui
round(statsBox, 8)
local statsStroke = outline(statsBox, accent, 0.2)
local statsText = label(statsBox, "FPS: --   PING: --", 11, accent, true)
statsText.Position = UDim2.fromOffset(9, 0)
statsText.Size = UDim2.new(1, -18, 1, 0)

-- Mobile fly controls
local flyControls = Instance.new("Frame")
flyControls.Name = "FlyMobileControls"
flyControls.Size = UDim2.fromOffset(112, 104)
flyControls.Position = UDim2.new(1, -128, 1, -150)
flyControls.BackgroundTransparency = 1
flyControls.Visible = false
flyControls.Parent = gui
local upButton = button(flyControls, "UP", 43)
local downButton = button(flyControls, "DOWN", 43)
downButton.Position = UDim2.fromOffset(0, 50)
local verticalInput = 0
local function bindHold(btn, value)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then verticalInput = value end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if verticalInput == value then verticalInput = 0 end
        end
    end)
end
bindHold(upButton, 1)
bindHold(downButton, -1)

-- Helpers: team-aware ESP and aim target selection
local espItems = {}
local function isEnemy(target)
    if player.Team == nil or target.Team == nil then return target ~= player end
    return target.Team ~= player.Team
end

local function clearESP(target)
    local item = espItems[target]
    if item then
        if item.highlight then item.highlight:Destroy() end
        if item.billboard then item.billboard:Destroy() end
        espItems[target] = nil
    end
end

local function updateESP()
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player then
            local char = target.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local distance = (myRoot and root) and (root.Position - myRoot.Position).Magnitude or math.huge
            local valid = cfg.ESP and myRoot and root and hum and hum.Health > 0 and distance <= cfg.ESPDistance
            if valid then
                local item = espItems[target] or {}
                espItems[target] = item
                local enemy = isEnemy(target)
                local color = enemy and palette.red or accent
                if cfg.ESPHighlight then
                    if not item.highlight then
                        item.highlight = Instance.new("Highlight")
                        item.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        item.highlight.Parent = char
                    end
                    item.highlight.Adornee = char
                    item.highlight.FillColor = color
                    item.highlight.OutlineColor = color
                    item.highlight.FillTransparency = 0.78
                    item.highlight.OutlineTransparency = 0.05
                elseif item.highlight then
                    item.highlight:Destroy()
                    item.highlight = nil
                end
                if cfg.ESPNames or cfg.ESPHealth or cfg.ESPDistanceText then
                    if not item.billboard then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.fromOffset(190, 40)
                        bb.StudsOffset = Vector3.new(0, 3, 0)
                        bb.AlwaysOnTop = true
                        bb.Parent = playerGui
                        local txt = Instance.new("TextLabel")
                        txt.Name = "Info"
                        txt.Size = UDim2.fromScale(1, 1)
                        txt.BackgroundTransparency = 1
                        txt.TextStrokeTransparency = 0.25
                        txt.Font = Enum.Font.GothamBold
                        txt.TextSize = 11
                        txt.Parent = bb
                        item.billboard = bb
                    end
                    local bits = {}
                    if cfg.ESPNames then table.insert(bits, target.Name) end
                    if cfg.ESPHealth then table.insert(bits, "HP " .. math.floor(hum.Health)) end
                    if cfg.ESPDistanceText then table.insert(bits, math.floor(distance) .. "m") end
                    item.billboard.Adornee = root
                    item.billboard.Info.Text = table.concat(bits, "  |  ")
                    item.billboard.Info.TextColor3 = color
                    item.billboard.Enabled = true
                elseif item.billboard then
                    item.billboard.Enabled = false
                end
            else
                clearESP(target)
            end
        end
    end
end

local function canSee(character, part)
    if not cfg.VisibleCheck then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {player.Character, camera}
    params.IgnoreWater = true
    local result = workspace:Raycast(camera.CFrame.Position, part.Position - camera.CFrame.Position, params)
    return result ~= nil and result.Instance:IsDescendantOf(character)
end

local function getAimTarget()
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local best, bestScreen = nil, cfg.AimFOV
    local center = camera.ViewportSize / 2
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and (not cfg.EnemiesOnly or isEnemy(target)) then
            local char = target.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local part = char and char:FindFirstChild(cfg.TargetPart)
            if hum and hum.Health > 0 and part and (part.Position - myRoot.Position).Magnitude <= cfg.AimDistance then
                local point, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen and point.Z > 0 and canSee(char, part) then
                    local d = (Vector2.new(point.X, point.Y) - center).Magnitude
                    if d < bestScreen then bestScreen, best = d, part end
                end
            end
        end
    end
    return best
end


local lastShot = 0
local function tryAutoShot()
    if not cfg.AutoShot or not cfg.Aim then return end
    if os.clock() - lastShot < 0.22 then return end
    local character = player.Character
    local tool = character and character:FindFirstChildOfClass("Tool")
    if tool then
        lastShot = os.clock()
        pcall(function() tool:Activate() end)
    end
end

-- Movement: camera-relative desktop + mobile joystick, with vertical touch buttons.
local flyVelocity, flyGyro, flyConnection
local noclipOriginal = {}
local function stopFly()
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end
    if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    verticalInput = 0
end

local function startFly()
    stopFly()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    flyVelocity = Instance.new("BodyVelocity")
    flyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    flyVelocity.P = 18000
    flyVelocity.Velocity = Vector3.zero
    flyVelocity.Parent = root

    flyGyro = Instance.new("BodyGyro")
    flyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    flyGyro.P = 12000
    flyGyro.CFrame = camera.CFrame
    flyGyro.Parent = root

    flyControls.Visible = UserInputService.TouchEnabled
    flyConnection = RunService.RenderStepped:Connect(function()
        if not cfg.Fly or not root.Parent then stopFly(); return end
        local direction = Vector3.zero
        if UserInputService.TouchEnabled then
            direction = hum.MoveDirection
        else
            local cf = camera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= cf.RightVector end
        end

        local vertical = verticalInput
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vertical = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vertical = -1 end
        direction += Vector3.new(0, vertical, 0)
        if direction.Magnitude > 1 then direction = direction.Unit end
        flyVelocity.Velocity = direction * cfg.FlySpeed
        flyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + camera.CFrame.LookVector)
    end)
end

local function setNoclip()
    if cfg.Noclip then
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    if noclipOriginal[part] == nil then noclipOriginal[part] = true end
                    part.CanCollide = false
                end
            end
        end
    else
        for part, original in pairs(noclipOriginal) do
            if part and part.Parent then part.CanCollide = original end
        end
        table.clear(noclipOriginal)
    end
end

-- Runtime stats
local frameCount, fps, lastFps = 0, 0, os.clock()
local function readPing()
    local ok, result = pcall(function()
        local network = Stats:FindFirstChild("Network")
        local serverStats = network and network:FindFirstChild("ServerStatsItem")
        local pingItem = serverStats and serverStats:FindFirstChild("Data Ping")
        return pingItem and pingItem:GetValueString() or "--"
    end)
    return ok and result or "--"
end

local function applyTheme()
    if cfg.Rainbow then
        rainbowHue = (rainbowHue + 0.0025) % 1
        accent = Color3.fromHSV(rainbowHue, 0.82, 1)
    else
        accent = themes[cfg.ThemeIndex].Color
    end
    main.BackgroundTransparency = cfg.Transparency
    top.BackgroundTransparency = cfg.Transparency
    sidebar.BackgroundTransparency = cfg.Transparency
    floating.TextColor3 = accent
    floatStroke.Color = accent
    mainStroke.Color = accent
    subtitle.TextColor3 = accent
    pageTitle.TextColor3 = palette.text
    content.ScrollBarImageColor3 = accent
    fovStroke.Color = accent
    cross.BackgroundColor3 = accent
    statsStroke.Color = accent
    statsText.TextColor3 = accent
    statsBox.BackgroundTransparency = cfg.Transparency
    for _, obj in ipairs(content:GetDescendants()) do
        if obj:IsA("Frame") and obj.BackgroundColor3 == palette.panel then
            obj.BackgroundTransparency = cfg.Transparency
        elseif obj:IsA("UIStroke") and obj.Color ~= palette.red then
            obj.Color = accent
        elseif obj:IsA("TextLabel") and obj.TextColor3 == themes[1].Color then
            obj.TextColor3 = accent
        end
    end
    for _, refresh in ipairs(refreshers) do refresh() end
end

reset.MouseButton1Click:Connect(function()
    for key, value in pairs(defaults) do
        cfg[key] = value
    end
    themeName.Text = "Theme: " .. themes[cfg.ThemeIndex].Name
    for _, refresh in ipairs(refreshers) do refresh() end
end)

-- Input and main update
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        if main.Visible then hideMenu() else showMenu() end
    end
end)

local lastAimUpdate = 0
RunService.Stepped:Connect(function()
    if cfg.Noclip then setNoclip() end
end)

RunService.RenderStepped:Connect(function(dt)
    camera = workspace.CurrentCamera
    frameCount += 1
    if os.clock() - lastFps >= 1 then
        fps = frameCount
        frameCount = 0
        lastFps = os.clock()
    end

    applyTheme()
    fov.Visible = cfg.Aim and cfg.FOVCircle
    fov.Size = UDim2.fromOffset(cfg.AimFOV * 2, cfg.AimFOV * 2)
    cross.Visible = cfg.Crosshair
    statsBox.Visible = cfg.ShowStats and (cfg.ShowFPS or cfg.ShowPing)
    local pieces = {}
    if cfg.ShowFPS then table.insert(pieces, "FPS: " .. tostring(fps)) end
    if cfg.ShowPing then table.insert(pieces, "PING: " .. readPing()) end
    statsText.Text = table.concat(pieces, "   ")
    flyControls.Visible = cfg.Fly and UserInputService.TouchEnabled

    if cfg.Fly and not flyConnection then startFly() end
    if not cfg.Fly and flyConnection then stopFly() end
    setNoclip()
    updateESP()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and not cfg.Fly then humanoid.WalkSpeed = cfg.WalkSpeed end

    if cfg.Aim and os.clock() - lastAimUpdate > 0.015 then
        lastAimUpdate = os.clock()
        local target = getAimTarget()
        if target then
            local desired = CFrame.lookAt(camera.CFrame.Position, target.Position)
            camera.CFrame = camera.CFrame:Lerp(desired, math.clamp(cfg.Smoothness, 0.01, 1))
            tryAutoShot()
        end
    end
end)


UserInputService.JumpRequest:Connect(function()
    if cfg.InfiniteJump then
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    stopFly()
    if cfg.Fly then startFly() end
end)

Players.PlayerRemoving:Connect(function(target)
    clearESP(target)
    if selectedPlayer == target then
        selectedPlayer = nil
        playerButton.Text = "Select Player"
        finderLabel.Text = "Player Finder: choose a player below"
    end
end)

print("LEYNOXHUB V1 + V2 loaded. RightShift toggles the menu.")

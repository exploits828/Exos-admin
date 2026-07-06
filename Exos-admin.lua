-- ============================================================
--   EXOS ADMIN (v1) — Blue Edition
--   Custom admin panel for SPT / any game
--   Place in StarterPlayerScripts or run via executor
-- ============================================================

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UserInputService= game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService     = game:GetService("HttpService")
local CoreGui         = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local Camera      = workspace.CurrentCamera

-- ============================================================
-- EXECUTOR DETECTION
-- ============================================================
local executorName = "Unknown"
local isBadExecutor = false

pcall(function()
    if identifyexecutor then
        executorName = identifyexecutor() or "Unknown"
    elseif getexecutorname then
        executorName = getexecutorname() or "Unknown"
    elseif syn then
        executorName = "Synapse X"
    elseif KRNL_LOADED then
        executorName = "KRNL"
    end
    local low = executorName:lower()
    if low:find("xeno") or low:find("solara") then
        isBadExecutor = true
    end
end)

-- ============================================================
-- NOTIFICATION SYSTEM (defined early)
-- ============================================================
local notifQueue = {}
local notifActive = false

local function notify(title, msg, duration)
    duration = duration or 4
    table.insert(notifQueue, {title=title, msg=msg, dur=duration})
end

-- ============================================================
-- GUI CONSTRUCTION
-- ============================================================

-- Destroy old instance if reloading
pcall(function()
    if PlayerGui:FindFirstChild("EXOSAdmin") then
        PlayerGui.EXOSAdmin:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EXOSAdmin"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- ============================================================
-- NOTIFICATION FRAME (top-right) — blue accents
-- ============================================================
local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "NotifHolder"
NotifHolder.Size = UDim2.new(0, 280, 1, 0)
NotifHolder.Position = UDim2.new(1, -290, 0, 10)
NotifHolder.BackgroundTransparency = 1
NotifHolder.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifLayout.Parent = NotifHolder

local function showNextNotif()
    if notifActive or #notifQueue == 0 then return end
    notifActive = true
    local data = table.remove(notifQueue, 1)

    local nf = Instance.new("Frame")
    nf.Size = UDim2.new(1, 0, 0, 0)
    nf.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    nf.BorderSizePixel = 0
    nf.ClipsDescendants = true
    nf.Parent = NotifHolder

    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 6)
    nc.Parent = nf

    -- Blue stroke
    local ns = Instance.new("UIStroke")
    ns.Color = Color3.fromRGB(40, 120, 220)   -- blue
    ns.Thickness = 1.5
    ns.Parent = nf

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, 0)
    accent.BackgroundColor3 = Color3.fromRGB(40, 120, 220)   -- blue
    accent.BorderSizePixel = 0
    accent.Parent = nf
    local ac2 = Instance.new("UICorner"); ac2.CornerRadius = UDim.new(0,3); ac2.Parent = accent

    local ntitle = Instance.new("TextLabel")
    ntitle.Size = UDim2.new(1, -16, 0, 16)
    ntitle.Position = UDim2.new(0, 10, 0, 8)
    ntitle.BackgroundTransparency = 1
    ntitle.Text = data.title
    ntitle.TextColor3 = Color3.fromRGB(40, 120, 220)   -- blue
    ntitle.TextSize = 13
    ntitle.Font = Enum.Font.GothamBold
    ntitle.TextXAlignment = Enum.TextXAlignment.Left
    ntitle.Parent = nf

    local nbody = Instance.new("TextLabel")
    nbody.Size = UDim2.new(1, -16, 0, 30)
    nbody.Position = UDim2.new(0, 10, 0, 26)
    nbody.BackgroundTransparency = 1
    nbody.Text = data.msg
    nbody.TextColor3 = Color3.fromRGB(210, 210, 210)
    nbody.TextSize = 12
    nbody.Font = Enum.Font.Gotham
    nbody.TextXAlignment = Enum.TextXAlignment.Left
    nbody.TextWrapped = true
    nbody.Parent = nf

    TweenService:Create(nf, TweenInfo.new(0.2), {Size = UDim2.new(1,0,0,62)}):Play()
    task.wait(data.dur)
    TweenService:Create(nf, TweenInfo.new(0.2), {Size = UDim2.new(1,0,0,0)}):Play()
    task.wait(0.25)
    nf:Destroy()
    notifActive = false
    showNextNotif()
end

RunService.Heartbeat:Connect(function()
    if not notifActive and #notifQueue > 0 then
        showNextNotif()
    end
end)

-- ============================================================
-- OPEN BUTTON (small floating button) — blue
-- ============================================================
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 44, 0, 44)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -22)
OpenBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 200)   -- blue
OpenBtn.BorderSizePixel = 0
OpenBtn.Parent = ScreenGui

local ob_c = Instance.new("UICorner"); ob_c.CornerRadius = UDim.new(0, 8); ob_c.Parent = OpenBtn
local ob_s = Instance.new("UIStroke"); ob_s.Color = Color3.fromRGB(80, 180, 255); ob_s.Thickness = 1.5; ob_s.Parent = OpenBtn

local ob_lbl = Instance.new("TextLabel")
ob_lbl.Size = UDim2.new(1,0,1,0)
ob_lbl.BackgroundTransparency = 1
ob_lbl.Text = "EX"
ob_lbl.TextColor3 = Color3.fromRGB(255,255,255)
ob_lbl.Font = Enum.Font.GothamBlack
ob_lbl.TextSize = 16
ob_lbl.Parent = OpenBtn

-- Drag the open button
do
    local dragging, dragStart, startPos
    OpenBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = inp.Position
            startPos = OpenBtn.Position
        end
    end)
    OpenBtn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                          startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ============================================================
-- MAIN WINDOW — blue theme
-- ============================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 460)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local mf_c = Instance.new("UICorner"); mf_c.CornerRadius = UDim.new(0,10); mf_c.Parent = MainFrame
local mf_s = Instance.new("UIStroke"); mf_s.Color = Color3.fromRGB(40, 120, 220); mf_s.Thickness = 1.5; mf_s.Parent = MainFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
local tb_c = Instance.new("UICorner"); tb_c.CornerRadius = UDim.new(0,10); tb_c.Parent = TitleBar

local tb_fix = Instance.new("Frame")
tb_fix.Size = UDim2.new(1,0,0,10)
tb_fix.Position = UDim2.new(0,0,1,-10)
tb_fix.BackgroundColor3 = Color3.fromRGB(15,15,19)
tb_fix.BorderSizePixel = 0
tb_fix.Parent = TitleBar

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(1,-80,1,0)
TitleLbl.Position = UDim2.new(0,14,0,0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "EXOS ADMIN  (v1)"
TitleLbl.TextColor3 = Color3.fromRGB(255,255,255)
TitleLbl.Font = Enum.Font.GothamBlack
TitleLbl.TextSize = 15
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Parent = TitleBar

local ExecLbl = Instance.new("TextLabel")
ExecLbl.Size = UDim2.new(0,180,1,0)
ExecLbl.Position = UDim2.new(0,200,0,0)
ExecLbl.BackgroundTransparency = 1
ExecLbl.Text = "Executor: "..executorName
ExecLbl.TextColor3 = isBadExecutor and Color3.fromRGB(255,120,40) or Color3.fromRGB(120,200,120)
ExecLbl.Font = Enum.Font.Gotham
ExecLbl.TextSize = 11
ExecLbl.TextXAlignment = Enum.TextXAlignment.Left
ExecLbl.Parent = TitleBar

local CloseBtn2 = Instance.new("TextButton")
CloseBtn2.Size = UDim2.new(0, 26, 0, 26)
CloseBtn2.Position = UDim2.new(1,-34,0,6)
CloseBtn2.BackgroundColor3 = Color3.fromRGB(40, 80, 180)   -- blue
CloseBtn2.BorderSizePixel = 0
CloseBtn2.Text = "✕"
CloseBtn2.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn2.Font = Enum.Font.GothamBold
CloseBtn2.TextSize = 12
CloseBtn2.Parent = TitleBar
local cb2_c = Instance.new("UICorner"); cb2_c.CornerRadius = UDim.new(0,6); cb2_c.Parent = CloseBtn2

-- Drag MainFrame via TitleBar
do
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = inp.Position; startPos = MainFrame.Position
        end
    end)
    TitleBar.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X,
                                            startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end)
end

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1,-20,0,32)
TabBar.Position = UDim2.new(0,10,0,44)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0,6)
TabLayout.Parent = TabBar

-- Content area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1,-20,1,-86)
ContentArea.Position = UDim2.new(0,10,0,82)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local tabs = {}
local activeTab = nil

local function makeTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,42)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(170,170,170)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Parent = TabBar
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,7); bc.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(40, 120, 220)   -- blue
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = ContentArea

    local pl = Instance.new("UIListLayout")
    pl.Padding = UDim.new(0,7)
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    pl.Parent = page

    local pp = Instance.new("UIPadding")
    pp.PaddingTop = UDim.new(0,4)
    pp.PaddingLeft = UDim.new(0,2)
    pp.PaddingRight = UDim.new(0,6)
    pp.Parent = page

    tabs[name] = {btn=btn, page=page}

    btn.MouseButton1Click:Connect(function()
        for tname, tdata in pairs(tabs) do
            tdata.btn.BackgroundColor3 = Color3.fromRGB(35,35,42)
            tdata.btn.TextColor3 = Color3.fromRGB(170,170,170)
            tdata.page.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 100, 200)   -- blue
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        page.Visible = true
        activeTab = name
    end)

    return page
end

-- ============================================================
-- WIDGET HELPERS (with blue accents)
-- ============================================================
local function makeSectionLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-4,0,18)
    lbl.BackgroundTransparency = 1
    lbl.Text = "▸ "..text
    lbl.TextColor3 = Color3.fromRGB(40, 120, 220)   -- blue
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function makeToggle(parent, labelText, defaultOn, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-4,0,30)
    row.BackgroundColor3 = Color3.fromRGB(30,30,38)
    row.BorderSizePixel = 0
    row.Parent = parent
    local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0,7); rc.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-54,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(210,210,210)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local tog = Instance.new("TextButton")
    tog.Size = UDim2.new(0, 38, 0, 20)
    tog.Position = UDim2.new(1,-46,0.5,-10)
    tog.BorderSizePixel = 0
    tog.Text = ""
    tog.Parent = row
    local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1,0); tc.Parent = tog

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,16,0,16)
    knob.Position = UDim2.new(0,2,0.5,-8)
    knob.BorderSizePixel = 0
    knob.Parent = tog
    local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1,0); kc.Parent = knob

    local state = defaultOn or false
    local function update(s)
        state = s
        tog.BackgroundColor3 = s and Color3.fromRGB(40, 120, 220) or Color3.fromRGB(55,55,65)  -- blue when on
        knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = s and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
        }):Play()
        if callback then callback(s) end
    end
    update(state)
    tog.MouseButton1Click:Connect(function() update(not state) end)
    return row, function() return state end, update
end

local function makeButton(parent, labelText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-4,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 80, 180)   -- blue
    btn.BorderSizePixel = 0
    btn.Text = labelText
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Parent = parent
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,7); bc.Parent = btn
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(80, 160, 255)}):Play()
        task.delay(0.12, function()
            TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(40, 80, 180)}):Play()
        end)
        if callback then callback() end
    end)
    return btn
end

local function makeSlider(parent, labelText, minVal, maxVal, defaultVal, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-4,0,46)
    row.BackgroundColor3 = Color3.fromRGB(30,30,38)
    row.BorderSizePixel = 0
    row.Parent = parent
    local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0,7); rc.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7,0,0,18)
    lbl.Position = UDim2.new(0,10,0,4)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(210,210,210)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0.3,-10,0,18)
    valLbl.Position = UDim2.new(0.7,0,0,4)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(defaultVal)
    valLbl.TextColor3 = Color3.fromRGB(40, 120, 220)   -- blue
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 12
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1,-20,0,6)
    track.Position = UDim2.new(0,10,0,30)
    track.BackgroundColor3 = Color3.fromRGB(50,50,60)
    track.BorderSizePixel = 0
    track.Parent = row
    local trc = Instance.new("UICorner"); trc.CornerRadius = UDim.new(1,0); trc.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal-minVal)/(maxVal-minVal),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(40, 120, 220)   -- blue
    fill.BorderSizePixel = 0
    fill.Parent = track
    local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1,0); fc.Parent = fill

    local currentVal = defaultVal
    local sliding = false

    local function setVal(v)
        currentVal = math.clamp(math.round(v), minVal, maxVal)
        local pct = (currentVal-minVal)/(maxVal-minVal)
        fill.Size = UDim2.new(pct,0,1,0)
        valLbl.Text = tostring(currentVal)
        if callback then callback(currentVal) end
    end

    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
        end
    end)
    track.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local trackAbs = track.AbsolutePosition
            local trackWidth = track.AbsoluteSize.X
            local rel = math.clamp((inp.Position.X - trackAbs.X) / trackWidth, 0, 1)
            setVal(minVal + rel*(maxVal-minVal))
        end
    end)

    return row, function() return currentVal end, setVal
end

local function makeInput(parent, placeholder, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-4,0,30)
    row.BackgroundColor3 = Color3.fromRGB(30,30,38)
    row.BorderSizePixel = 0
    row.Parent = parent
    local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0,7); rc.Parent = row
    local rs = Instance.new("UIStroke"); rs.Color = Color3.fromRGB(60,60,70); rs.Thickness = 1; rs.Parent = row

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1,-16,1,0)
    tb.Position = UDim2.new(0,8,0,0)
    tb.BackgroundTransparency = 1
    tb.PlaceholderText = placeholder
    tb.PlaceholderColor3 = Color3.fromRGB(90,90,100)
    tb.Text = ""
    tb.TextColor3 = Color3.fromRGB(230,230,230)
    tb.Font = Enum.Font.Gotham
    tb.TextSize = 13
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.ClearTextOnFocus = false
    tb.Parent = row

    tb.FocusLost:Connect(function(enter)
        if enter and callback then callback(tb.Text) end
        rs.Color = Color3.fromRGB(60,60,70)
    end)
    tb.Focused:Connect(function()
        rs.Color = Color3.fromRGB(40, 120, 220)   -- blue
    end)
    return row, tb
end

local function makeDropdown(parent, labelText, options, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,-4,0,30)
    container.BackgroundColor3 = Color3.fromRGB(30,30,38)
    container.BorderSizePixel = 0
    container.ClipsDescendants = false
    container.ZIndex = 10
    container.Parent = parent
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0,7); cc.Parent = container

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5,0,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(210,210,210)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 10
    lbl.Parent = container

    local selected = options[1] or ""
    local selBtn = Instance.new("TextButton")
    selBtn.Size = UDim2.new(0.46,-8,0,24)
    selBtn.Position = UDim2.new(0.54,0,0.5,-12)
    selBtn.BackgroundColor3 = Color3.fromRGB(50,50,62)
    selBtn.BorderSizePixel = 0
    selBtn.Text = selected.." ▾"
    selBtn.TextColor3 = Color3.fromRGB(230,230,230)
    selBtn.Font = Enum.Font.Gotham
    selBtn.TextSize = 12
    selBtn.ZIndex = 10
    selBtn.Parent = container
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0,5); sc.Parent = selBtn

    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(0.46,-8,0,#options*26+4)
    dropdown.Position = UDim2.new(0.54,0,1,2)
    dropdown.BackgroundColor3 = Color3.fromRGB(40,40,50)
    dropdown.BorderSizePixel = 0
    dropdown.ZIndex = 20
    dropdown.Visible = false
    dropdown.Parent = container
    local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(0,6); dc.Parent = dropdown
    local ds = Instance.new("UIStroke"); ds.Color = Color3.fromRGB(40, 120, 220); ds.Thickness = 1; ds.Parent = dropdown

    local dl = Instance.new("UIListLayout"); dl.Padding = UDim.new(0,2); dl.Parent = dropdown
    local dp = Instance.new("UIPadding"); dp.PaddingTop = UDim.new(0,2); dp.PaddingLeft = UDim.new(0,2); dp.PaddingRight = UDim.new(0,2); dp.Parent = dropdown

    for _, opt in ipairs(options) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1,0,0,22)
        ob.BackgroundTransparency = 1
        ob.Text = opt
        ob.TextColor3 = Color3.fromRGB(210,210,210)
        ob.Font = Enum.Font.Gotham
        ob.TextSize = 12
        ob.ZIndex = 20
        ob.Parent = dropdown
        ob.MouseButton1Click:Connect(function()
            selected = opt
            selBtn.Text = opt.." ▾"
            dropdown.Visible = false
            if callback then callback(opt) end
        end)
        ob.MouseEnter:Connect(function() ob.BackgroundTransparency = 0; ob.BackgroundColor3 = Color3.fromRGB(60,60,75) end)
        ob.MouseLeave:Connect(function() ob.BackgroundTransparency = 1 end)
    end

    selBtn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)

    return container, function() return selected end
end

-- ============================================================
-- BUILD TABS
-- ============================================================
local universalPage = makeTab("Universal")
local gamesPage     = makeTab("Games")
local settingsPage  = makeTab("GUI Settings")
local socialsPage   = makeTab("Socials")

-- Activate first tab
tabs["Universal"].btn.BackgroundColor3 = Color3.fromRGB(40, 100, 200)
tabs["Universal"].btn.TextColor3 = Color3.fromRGB(255,255,255)
tabs["Universal"].page.Visible = true
activeTab = "Universal"

-- ============================================================
-- UNIVERSAL TAB
-- ============================================================

-- Loaders Section
makeSectionLabel(universalPage, "Script Loaders")

makeButton(universalPage, "Load Infinite Yield", function()
    notify("Loading", "Loading Infinite Yield...")
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
end)

makeButton(universalPage, "Load Product Fucker  (esore — old product code only)", function()
    notify("Loading", "Loading Product Fucker...")
    pcall(function()
        -- Placeholder: load your own script if needed
    end)
end)

makeButton(universalPage, "Load Solara Hub", function()
    notify("Loading", "Loading Solara Hub...")
    pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/samuraa1/Solara-Hub/refs/heads/main/SH.lua'))()
    end)
end)

makeButton(universalPage, "Load Dex Explorer", function()
    notify("Loading", "Loading Dex...")
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end)
end)

makeButton(universalPage, "Load RemoteSpy", function()
    if isBadExecutor then
        notify("⚠ Bad Executor", "You are using "..executorName.." — loading limited RemoteSpy version.", 5)
        pcall(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-RemoteSpy-for-Xeno-and-Solara-32578"))()
        end)
    else
        notify("Loading", "Loading RemoteSpy...")
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleRemoteSpy/master/RemoteSpy.lua"))()
        end)
    end
end)

makeButton(universalPage, "Load Emotes", function()
    notify("Loading", "Loading Emotes GUI...")
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))()
    end)
end)

makeButton(universalPage, "Mois7 Loader", function()
    notify("Loading", "Loading Mois7...")
    pcall(function()
        loadstring(game:HttpGet("https://mois7.xyz/loader"))()
    end)
end)

makeButton(universalPage, "Load Fearless Chat Bypasser", function()
    notify("Loading", "Loading Chat Bypasser...")
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/fearlessd3v/TEAM-FEARLESS/refs/heads/main/fearless-chat-bypass"))()
    end)
end)

-- Movement Section
makeSectionLabel(universalPage, "Movement")

-- Speed
local _,getSpeed,setSpeedVal = makeSlider(universalPage,"Walk Speed", 1, 500, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)
do
    local resetRow = Instance.new("Frame")
    resetRow.Size = UDim2.new(1,-4,0,24)
    resetRow.BackgroundTransparency = 1
    resetRow.Parent = universalPage
    makeButton(resetRow, "Reset Speed to 16", function()
        setSpeedVal(16)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
end

-- Jump
local _,getJump,setJumpVal = makeSlider(universalPage,"Jump Power", 1, 500, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end)
do
    local resetRow = Instance.new("Frame")
    resetRow.Size = UDim2.new(1,-4,0,24)
    resetRow.BackgroundTransparency = 1
    resetRow.Parent = universalPage
    makeButton(resetRow, "Reset Jump to 50", function()
        setJumpVal(50)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end)
end

-- Hitbox
makeSlider(universalPage,"Hitbox Size", 1, 20, 1, function(v)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Size = Vector3.new(v,v,v) end
        end
    end
end)

-- Fly
local flyActive = false
local flyConn
local _,_,setFly = makeToggle(universalPage, "Fly", false, function(on)
    flyActive = on
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    if on then
        hum.PlatformStand = true
        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bg.D = 100
        bg.Parent = hrp
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp

        flyConn = RunService.Heartbeat:Connect(function()
            if not flyActive then
                bg:Destroy(); bv:Destroy()
                hum.PlatformStand = false
                flyConn:Disconnect()
                return
            end
            local speed = 40
            local cf = Camera.CFrame
            local vel = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cf.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cf.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel - Vector3.new(0,1,0) end
            bv.Velocity = vel * speed
            bg.CFrame = cf
        end)
    end
end)

-- Inf Jump
local infJumpConn
makeToggle(universalPage, "Infinite Jump", false, function(on)
    if infJumpConn then infJumpConn:Disconnect() end
    if on then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
end)

-- Auto Wall Hop
local wallHopConn
makeToggle(universalPage, "Auto Wall Hop", false, function(on)
    if wallHopConn then wallHopConn:Disconnect() end
    if on then
        wallHopConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- Noclip
local noclipConn
makeToggle(universalPage, "Noclip", false, function(on)
    if noclipConn then noclipConn:Disconnect() end
    if on then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end)

-- Walkfling
makeSectionLabel(universalPage, "Walkfling")
local _,_,getWfPower
local wfRow, wfTb = makeInput(universalPage, "Walkfling Power (default 200)")
local _, getWFPower, setWFPower = makeSlider(universalPage, "Walkfling Force", 10, 2000, 200, function() end)
makeButton(universalPage, "Walkfling (self)", function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity = hrp.CFrame.LookVector * getWFPower()
    bv.Parent = hrp
    game:GetService("Debris"):AddItem(bv, 0.12)
end)

-- Combat / ESP / Aimbot headers
makeSectionLabel(universalPage, "Combat")

-- Aimbot
local aimbotActive = false
local aimbotConn
makeToggle(universalPage, "Aimbot", false, function(on)
    aimbotActive = on
    if aimbotConn then aimbotConn:Disconnect() end
    if on then
        aimbotConn = RunService.RenderStepped:Connect(function()
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
            local closest, closestDist = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local head = p.Character:FindFirstChild("Head")
                    if head then
                        local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                        if onScreen then
                            local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closest = head
                            end
                        end
                    end
                end
            end
            if closest then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
            end
        end)
    end
end)

-- ESP Section
makeSectionLabel(universalPage, "ESP")
local espActive = false
local espHighlights = {}

local espSettings = {
    nametags = true,
    tracers = false,
    distance = true,
    boxes = false,
    health = true,
    color = Color3.fromRGB(40, 120, 220)   -- blue
}

local function clearESP()
    for _, h in pairs(espHighlights) do
        pcall(function() h:Destroy() end)
    end
    espHighlights = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local bb = p.Character:FindFirstChild("EXOS_ESP_BB")
            if bb then bb:Destroy() end
        end
    end
end

local function updateESP()
    if not espActive then clearESP() return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hl = char:FindFirstChild("EXOS_ESP_HL") or Instance.new("Highlight")
            hl.Name = "EXOS_ESP_HL"
            hl.FillColor = espSettings.color
            hl.OutlineColor = espSettings.color
            hl.FillTransparency = 0.6
            hl.Parent = char
            espHighlights[p.Name] = hl

            if espSettings.nametags then
                local head = char:FindFirstChild("Head")
                if head then
                    local bb = char:FindFirstChild("EXOS_ESP_BB") or Instance.new("BillboardGui")
                    bb.Name = "EXOS_ESP_BB"
                    bb.Size = UDim2.new(0,120,0,40)
                    bb.StudsOffset = Vector3.new(0,2.5,0)
                    bb.AlwaysOnTop = true
                    bb.Parent = head

                    local nl = bb:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel")
                    nl.Size = UDim2.new(1,0,0.5,0)
                    nl.BackgroundTransparency = 1
                    nl.Text = p.DisplayName
                    nl.TextColor3 = espSettings.color
                    nl.Font = Enum.Font.GothamBold
                    nl.TextSize = 14
                    nl.TextStrokeTransparency = 0
                    nl.Parent = bb

                    if espSettings.distance then
                        local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local phrp = char:FindFirstChild("HumanoidRootPart")
                        local dl2 = bb:FindFirstChild("DistLbl") or Instance.new("TextLabel")
                        dl2.Name = "DistLbl"
                        dl2.Size = UDim2.new(1,0,0.5,0)
                        dl2.Position = UDim2.new(0,0,0.5,0)
                        dl2.BackgroundTransparency = 1
                        dl2.TextColor3 = Color3.fromRGB(200,200,200)
                        dl2.Font = Enum.Font.Gotham
                        dl2.TextSize = 11
                        dl2.TextStrokeTransparency = 0
                        if lhrp and phrp then
                            dl2.Text = math.floor((lhrp.Position - phrp.Position).Magnitude).."m"
                        end
                        dl2.Parent = bb
                    end
                end
            else
                local bb = char:FindFirstChild("EXOS_ESP_BB")
                if bb then bb:Destroy() end
            end
        end
    end
end

makeToggle(universalPage, "ESP", false, function(on)
    espActive = on
    if not on then clearESP() end
end)

local espSettingsBtn = makeButton(universalPage, "⚙  ESP Settings", function() end)
do
    local espSettingsFrame = Instance.new("Frame")
    espSettingsFrame.Size = UDim2.new(1,-4,0,0)
    espSettingsFrame.BackgroundColor3 = Color3.fromRGB(28,28,35)
    espSettingsFrame.BorderSizePixel = 0
    espSettingsFrame.ClipsDescendants = true
    espSettingsFrame.Parent = universalPage
    local esfc = Instance.new("UICorner"); esfc.CornerRadius = UDim.new(0,7); esfc.Parent = espSettingsFrame
    local esl = Instance.new("UIListLayout"); esl.Padding = UDim.new(0,4); esl.Parent = espSettingsFrame
    local esp2 = Instance.new("UIPadding"); esp2.PaddingTop = UDim.new(0,4); esp2.PaddingLeft = UDim.new(0,6); esp2.PaddingRight = UDim.new(0,6); esp2.Parent = espSettingsFrame

    local espOpen = false
    espSettingsBtn.MouseButton1Click:Connect(function()
        espOpen = not espOpen
        TweenService:Create(espSettingsFrame, TweenInfo.new(0.2), {
            Size = espOpen and UDim2.new(1,-4,0,170) or UDim2.new(1,-4,0,0)
        }):Play()
    end)

    makeToggle(espSettingsFrame, "Nametags", true, function(v) espSettings.nametags = v end)
    makeToggle(espSettingsFrame, "Distance", true, function(v) espSettings.distance = v end)
    makeToggle(espSettingsFrame, "Health", true, function(v) espSettings.health = v end)
    makeToggle(espSettingsFrame, "Boxes (Highlight)", false, function(v) espSettings.boxes = v end)
    makeToggle(espSettingsFrame, "Tracers", false, function(v) espSettings.tracers = v end)
end

-- Super Ring Parts
makeSectionLabel(universalPage, "Misc")
makeButton(universalPage, "Super Ring Parts", function()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name:lower():find("ring") and v:IsA("BasePart") then
            v.Size = Vector3.new(50,50,50)
        end
    end
    notify("Super Ring Parts", "All ring parts enlarged!")
end)

-- ============================================================
-- GAMES TAB — MM2-style (blue accents)
-- ============================================================
makeSectionLabel(gamesPage, "MM2 — ESP")

local mm2ESPActive = false
local mm2ESPConn

local function getMM2Role(player)
    if player.Character then
        for _, v in ipairs(player.Character:GetChildren()) do
            if v:IsA("Tool") then
                if v.Name == "Knife" then return "Murderer"
                elseif v.Name == "Gun" then return "Sheriff" end
            end
        end
    end
    if player.Backpack then
        for _, v in ipairs(player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                if v.Name == "Knife" then return "Murderer"
                elseif v.Name == "Gun" then return "Sheriff" end
            end
        end
    end
    return "Innocent"
end

local function updateMM2ESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local role = getMM2Role(p)
            local color = role == "Murderer" and Color3.fromRGB(220,40,40)
                       or role == "Sheriff"  and Color3.fromRGB(40,120,220)   -- blue for sheriff
                       or                       Color3.fromRGB(40,200,80)

            local hl = char:FindFirstChild("MM2_ESP_HL") or Instance.new("Highlight")
            hl.Name = "MM2_ESP_HL"
            hl.FillColor = color
            hl.OutlineColor = color
            hl.FillTransparency = 0.55
            hl.Parent = char

            local head = char:FindFirstChild("Head")
            if head then
                local bb = char:FindFirstChild("MM2_ESP_BB") or Instance.new("BillboardGui")
                bb.Name = "MM2_ESP_BB"
                bb.Size = UDim2.new(0,130,0,44)
                bb.StudsOffset = Vector3.new(0,2.8,0)
                bb.AlwaysOnTop = true
                bb.Parent = head

                local nl = bb:FindFirstChild("NL") or Instance.new("TextLabel")
                nl.Name = "NL"
                nl.Size = UDim2.new(1,0,0.55,0)
                nl.BackgroundTransparency = 1
                nl.Text = p.DisplayName.." ["..role.."]"
                nl.TextColor3 = color
                nl.Font = Enum.Font.GothamBold
                nl.TextSize = 13
                nl.TextStrokeTransparency = 0
                nl.Parent = bb

                local lhrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local phrp = char:FindFirstChild("HumanoidRootPart")
                local dl = bb:FindFirstChild("DL") or Instance.new("TextLabel")
                dl.Name = "DL"
                dl.Size = UDim2.new(1,0,0.45,0)
                dl.Position = UDim2.new(0,0,0.55,0)
                dl.BackgroundTransparency = 1
                dl.TextColor3 = Color3.fromRGB(210,210,210)
                dl.Font = Enum.Font.Gotham
                dl.TextSize = 11
                dl.TextStrokeTransparency = 0
                if lhrp and phrp then
                    dl.Text = math.floor((lhrp.Position - phrp.Position).Magnitude).."m"
                end
                dl.Parent = bb
            end
        end
    end
end

makeToggle(gamesPage, "MM2 ESP (Red=Murderer, Blue=Sheriff, Green=Innocent)", false, function(on)
    mm2ESPActive = on
    if mm2ESPConn then mm2ESPConn:Disconnect() end
    if not on then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("MM2_ESP_HL")
                if hl then hl:Destroy() end
                local bb = p.Character:FindFirstChild("MM2_ESP_BB")
                if bb then bb:Destroy() end
            end
        end
    else
        mm2ESPConn = RunService.Heartbeat:Connect(updateMM2ESP)
    end
end)

-- Autofarm
makeSectionLabel(gamesPage, "MM2 — Autofarm")

local autofarmActive = false
local autofarmConn
local autofarmOrigin = nil
local autofarmToggleRef

local _, _, setAutofarm
local afRow
afRow, _, setAutofarm = makeToggle(gamesPage, "Autofarm Coins (Tween/Teleport)", false, function(on)
    autofarmActive = on
    if not on then
        if autofarmConn then autofarmConn:Disconnect() end
        if autofarmOrigin then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = autofarmOrigin end
        end
        return
    end

    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then notify("Autofarm", "No character found!") setAutofarm(false) return end
    autofarmOrigin = hrp.CFrame

    autofarmConn = task.spawn(function()
        while autofarmActive do
            local coins = {}
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "coin_server" and v:IsA("BasePart") then
                    table.insert(coins, v)
                end
            end

            if #coins == 0 then
                notify("Autofarm", "No coins left — bag may be full. Returning.")
                setAutofarm(false)
                local hrp2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp2 and autofarmOrigin then hrp2.CFrame = autofarmOrigin end
                break
            end

            for _, coin in ipairs(coins) do
                if not autofarmActive then break end
                local hrp2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp2 then
                    hrp2.CFrame = CFrame.new(coin.Position + Vector3.new(0,2,0))
                    task.wait(0.1)
                end
            end
            task.wait(0.5)
        end
    end)
end)

-- Gun controls
makeSectionLabel(gamesPage, "MM2 — Gun")

makeButton(gamesPage, "Grab Gun (GunDrop → You)", function()
    local gunDrop = workspace:FindFirstChild("GunDrop", true)
    if not gunDrop then
        notify("Grab Gun", "Gun is not dropped.")
        return
    end
    notify("Grab Gun", "Picking up gun...")
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(gunDrop.Position + Vector3.new(0,2,0)) end
end)

local autoGrabActive = false
local autoGrabConn
makeToggle(gamesPage, "Auto Grab Gun", false, function(on)
    autoGrabActive = on
    if autoGrabConn then autoGrabConn:Disconnect() end
    if on then
        autoGrabConn = RunService.Heartbeat:Connect(function()
            local gunDrop = workspace:FindFirstChild("GunDrop", true)
            if gunDrop then
                notify("Auto Grab Gun", "Picking up gun...")
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(gunDrop.Position + Vector3.new(0,2,0)) end
                task.wait(1)
            end
        end)
    end
end)

makeButton(gamesPage, "Shoot Murderer", function()
    local murderer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local role = getMM2Role(p)
            if role == "Murderer" then murderer = p break end
        end
    end
    if not murderer or not murderer.Character then
        notify("Shoot Murderer", "No murderer detected!")
        return
    end

    local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or
                (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun"))
    if not gun then
        notify("Shoot Murderer", "You don't have a gun!")
        return
    end

    notify("Shoot Murderer", "Targeting "..murderer.DisplayName.."...")
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local mHead = murderer.Character:FindFirstChild("Head")
    if hrp and mHead then
        if gun.Parent == LocalPlayer.Backpack then
            LocalPlayer.Character.Humanoid:EquipTool(gun)
        end
        task.wait(0.3)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, mHead.Position)
        hrp.CFrame = CFrame.new(mHead.Position + Vector3.new(0,0,3))
        task.wait(0.2)
        pcall(function() gun:Activate() end)
        task.wait(2.5)
        notify("Shoot Murderer", "Murderer has been shot!")
    end
end)

makeToggle(gamesPage, "Auto Shoot Murderer", false, function(on)
    if on then
        task.spawn(function()
            while on do
                local murderer = nil
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and getMM2Role(p) == "Murderer" then
                        murderer = p break
                    end
                end
                if murderer and murderer.Character then
                    local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or
                                (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun"))
                    if gun then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local mHead = murderer.Character:FindFirstChild("Head")
                        if hrp and mHead then
                            if gun.Parent == LocalPlayer.Backpack then
                                LocalPlayer.Character.Humanoid:EquipTool(gun)
                            end
                            task.wait(0.2)
                            hrp.CFrame = CFrame.new(mHead.Position + Vector3.new(0,0,3))
                            task.wait(0.1)
                            pcall(function() gun:Activate() end)
                            notify("Auto Shoot", "Shot the murderer!")
                            task.wait(3)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

-- Role notify
makeToggle(gamesPage, "Notify My Role on Spawn", false, function(on)
    if on then
        task.spawn(function()
            while on do
                pcall(function()
                    local mainGui = LocalPlayer.PlayerGui:WaitForChild("MainGUI", 3)
                    if mainGui then
                        local roleText = mainGui.Game.RoleSelector.Role.Text
                        if roleText and roleText ~= "" then
                            notify("Your Role", "You are: "..roleText, 5)
                        end
                    end
                end)
                task.wait(5)
            end
        end)
    end
end)

-- Gun Drop notifications
makeToggle(gamesPage, "Gun Drop Notifications", false, function(on)
    if on then
        local wasDropped = false
        task.spawn(function()
            while on do
                local gunDrop = workspace:FindFirstChild("GunDrop", true)
                if gunDrop and not wasDropped then
                    wasDropped = true
                    notify("Gun Alert", "Gun was dropped!")
                elseif not gunDrop and wasDropped then
                    wasDropped = false
                end
                task.wait(1)
            end
        end)
    end
end)

-- ============================================================
-- FLING PANEL (MM2)
-- ============================================================
makeSectionLabel(gamesPage, "Fling Panel")

local flingTargetType = "Player"
local flingTargetName = ""

local _, getFlingType = makeDropdown(gamesPage, "Fling Target", {"Player", "Murderer", "Sheriff", "Innocent"}, function(v)
    flingTargetType = v
end)

local _, flingNameTb
local flingNameRow
flingNameRow, flingNameTb = makeInput(gamesPage, "Player name / display name (for 'Player' mode)")

local function findPlayerByName(query)
    query = query:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            if p.Name:lower():find(query) or p.DisplayName:lower():find(query) then
                return p
            end
        end
    end
    return nil
end

local function flingPlayer(target)
    if not target or not target.Character then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not tHrp then return end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity  = Vector3.new(math.random(-300,300), 800, math.random(-300,300))
    bv.Parent = tHrp
    game:GetService("Debris"):AddItem(bv, 0.15)
end

makeButton(gamesPage, "Fling Selected Target", function()
    local ttype = getFlingType()

    if ttype == "Player" then
        local name = flingNameTb.Text
        if name == "" then notify("Fling", "Enter a player name!") return end
        local p = findPlayerByName(name)
        if not p then notify("Fling", "Player not found: "..name) return end
        flingPlayer(p)
        notify("Fling", "Flung "..p.DisplayName.."!")

    elseif ttype == "Murderer" then
        local found = false
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getMM2Role(p) == "Murderer" then
                flingPlayer(p)
                notify("Fling", "Flung murderer: "..p.DisplayName.."!")
                found = true
            end
        end
        if not found then notify("Fling", "No murderer found!") end

    elseif ttype == "Sheriff" then
        local found = false
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getMM2Role(p) == "Sheriff" then
                flingPlayer(p)
                notify("Fling", "Flung sheriff: "..p.DisplayName.."!")
                found = true
            end
        end
        if not found then notify("Fling", "No sheriff found!") end

    elseif ttype == "Innocent" then
        local count = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and getMM2Role(p) == "Innocent" then
                flingPlayer(p)
                count = count + 1
            end
        end
        notify("Fling", "Flung "..count.." innocent(s)!")
    end
end)

-- ============================================================
-- UNIVERSAL — X-RAY (blue accents)
-- ============================================================
makeSectionLabel(universalPage, "X-Ray")

local xrayActive = false
local xrayHighlights = {}

local xraySettings = {
    fillColor    = Color3.fromRGB(40, 120, 220),   -- blue
    outlineColor = Color3.fromRGB(255, 255, 255),
    fillTrans    = 0.5,
    players      = true,
    parts        = false,
}

local function clearXray()
    for _, hl in pairs(xrayHighlights) do
        pcall(function() hl:Destroy() end)
    end
    xrayHighlights = {}
end

local function applyXray()
    if not xrayActive then clearXray() return end

    if xraySettings.players then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local key = "pl_"..p.Name
                if not xrayHighlights[key] or not xrayHighlights[key].Parent then
                    local hl = Instance.new("Highlight")
                    hl.Name = "EXOS_XRAY"
                    hl.FillColor = xraySettings.fillColor
                    hl.OutlineColor = xraySettings.outlineColor
                    hl.FillTransparency = xraySettings.fillTrans
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = p.Character
                    xrayHighlights[key] = hl
                end
            end
        end
    end
end

local xrayConn
makeToggle(universalPage, "X-Ray (see players through walls)", false, function(on)
    xrayActive = on
    if xrayConn then xrayConn:Disconnect() end
    if not on then
        clearXray()
    else
        xrayConn = RunService.Heartbeat:Connect(applyXray)
        notify("X-Ray", "X-Ray enabled — players visible through walls.")
    end
end)

local xrayBtn = makeButton(universalPage, "⚙  X-Ray Settings", function() end)
do
    local xsf = Instance.new("Frame")
    xsf.Size = UDim2.new(1,-4,0,0)
    xsf.BackgroundColor3 = Color3.fromRGB(28,28,35)
    xsf.BorderSizePixel = 0
    xsf.ClipsDescendants = true
    xsf.Parent = universalPage
    local xsc = Instance.new("UICorner"); xsc.CornerRadius = UDim.new(0,7); xsc.Parent = xsf
    local xsl = Instance.new("UIListLayout"); xsl.Padding = UDim.new(0,4); xsl.Parent = xsf
    local xsp = Instance.new("UIPadding")
    xsp.PaddingTop = UDim.new(0,4); xsp.PaddingLeft = UDim.new(0,6)
    xsp.PaddingRight = UDim.new(0,6); xsp.Parent = xsf

    local xOpen = false
    xrayBtn.MouseButton1Click:Connect(function()
        xOpen = not xOpen
        TweenService:Create(xsf, TweenInfo.new(0.2), {
            Size = xOpen and UDim2.new(1,-4,0,120) or UDim2.new(1,-4,0,0)
        }):Play()
    end)

    makeSlider(xsf, "Fill Transparency (×10)", 0, 10, 5, function(v)
        xraySettings.fillTrans = v / 10
        for _, hl in pairs(xrayHighlights) do
            pcall(function() hl.FillTransparency = xraySettings.fillTrans end)
        end
    end)

    local colorRow = Instance.new("Frame")
    colorRow.Size = UDim2.new(1,-4,0,28)
    colorRow.BackgroundTransparency = 1
    colorRow.Parent = xsf
    local crl = Instance.new("UIListLayout")
    crl.FillDirection = Enum.FillDirection.Horizontal
    crl.Padding = UDim.new(0,5)
    crl.Parent = colorRow

    local colorPresets = {
        {name="Blue",  c=Color3.fromRGB(40,120,220)},
        {name="White", c=Color3.fromRGB(255,255,255)},
        {name="Cyan",  c=Color3.fromRGB(0,200,230)},
        {name="Gold",  c=Color3.fromRGB(255,200,0)},
    }
    for _, preset in ipairs(colorPresets) do
        local pb = Instance.new("TextButton")
        pb.Size = UDim2.new(0,54,1,0)
        pb.BackgroundColor3 = preset.c
        pb.BorderSizePixel = 0
        pb.Text = preset.name
        pb.TextColor3 = Color3.fromRGB(255,255,255)
        pb.Font = Enum.Font.GothamBold
        pb.TextSize = 11
        pb.Parent = colorRow
        local pbc = Instance.new("UICorner"); pbc.CornerRadius = UDim.new(0,5); pbc.Parent = pb
        pb.MouseButton1Click:Connect(function()
            xraySettings.fillColor = preset.c
            xraySettings.outlineColor = preset.c
            clearXray()
            if xrayActive then applyXray() end
        end)
    end

    makeToggle(xsf, "X-Ray: Include Workspace Parts", false, function(v)
        xraySettings.parts = v
    end)
end

-- ============================================================
-- GUI SETTINGS TAB
-- ============================================================
makeSectionLabel(settingsPage, "Appearance")

makeToggle(settingsPage, "Compact Mode (smaller window)", false, function(on)
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        Size = on and UDim2.new(0,480,0,380) or UDim2.new(0,620,0,460)
    }):Play()
end)

makeToggle(settingsPage, "Semi-Transparent Window", false, function(on)
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = on and 0.25 or 0
    }):Play()
end)

makeSectionLabel(settingsPage, "Notifications")

makeToggle(settingsPage, "Enable Notifications", true, function(on)
    _G.EXOS_NOTIFS = on
end)
_G.EXOS_NOTIFS = true

local _origNotify = notify
notify = function(title, msg, dur)
    if _G.EXOS_NOTIFS ~= false then
        _origNotify(title, msg, dur)
    end
end

makeSectionLabel(settingsPage, "About")
do
    local aboutLbl = Instance.new("TextLabel")
    aboutLbl.Size = UDim2.new(1,-4,0,70)
    aboutLbl.BackgroundColor3 = Color3.fromRGB(28,28,35)
    aboutLbl.BorderSizePixel = 0
    aboutLbl.Text = "EXOS ADMIN  v1\n\nCustom admin panel for your game.\nSupports: YUB-X · Xeno · Solara · Delta · Codex · Madium · Velocity\n(Some features limited on Solara/Xeno)"
    aboutLbl.TextColor3 = Color3.fromRGB(170,170,175)
    aboutLbl.Font = Enum.Font.Gotham
    aboutLbl.TextSize = 12
    aboutLbl.TextWrapped = true
    aboutLbl.TextYAlignment = Enum.TextYAlignment.Top
    aboutLbl.Parent = settingsPage
    local alc = Instance.new("UICorner"); alc.CornerRadius = UDim.new(0,7); alc.Parent = aboutLbl
    local alp = Instance.new("UIPadding")
    alp.PaddingTop = UDim.new(0,8); alp.PaddingLeft = UDim.new(0,10)
    alp.PaddingRight = UDim.new(0,10); alp.Parent = aboutLbl
end

-- ============================================================
-- SOCIALS TAB (with blue accent)
-- ============================================================
makeSectionLabel(socialsPage, "Community")

do
    local function makeSocialCard(parent, platform, handle, url)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1,-4,0,52)
        card.BackgroundColor3 = Color3.fromRGB(28,28,35)
        card.BorderSizePixel = 0
        card.Parent = parent
        local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0,8); cc.Parent = card
        local cs = Instance.new("UIStroke"); cs.Color = Color3.fromRGB(60,60,70); cs.Thickness = 1; cs.Parent = card

        local accent = Instance.new("Frame")
        accent.Size = UDim2.new(0,3,1,0)
        accent.BackgroundColor3 = Color3.fromRGB(40, 120, 220)   -- blue
        accent.BorderSizePixel = 0
        accent.Parent = card
        local ac = Instance.new("UICorner"); ac.CornerRadius = UDim.new(0,3); ac.Parent = accent

        local platLbl = Instance.new("TextLabel")
        platLbl.Size = UDim2.new(1,-60,0,20)
        platLbl.Position = UDim2.new(0,14,0,8)
        platLbl.BackgroundTransparency = 1
        platLbl.Text = platform
        platLbl.TextColor3 = Color3.fromRGB(40, 120, 220)   -- blue
        platLbl.Font = Enum.Font.GothamBold
        platLbl.TextSize = 13
        platLbl.TextXAlignment = Enum.TextXAlignment.Left
        platLbl.Parent = card

        local handleLbl = Instance.new("TextLabel")
        handleLbl.Size = UDim2.new(1,-60,0,18)
        handleLbl.Position = UDim2.new(0,14,0,28)
        handleLbl.BackgroundTransparency = 1
        handleLbl.Text = handle
        handleLbl.TextColor3 = Color3.fromRGB(180,180,190)
        handleLbl.Font = Enum.Font.Gotham
        handleLbl.TextSize = 12
        handleLbl.TextXAlignment = Enum.TextXAlignment.Left
        handleLbl.Parent = card

        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0,50,0,26)
        copyBtn.Position = UDim2.new(1,-58,0.5,-13)
        copyBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 180)   -- blue
        copyBtn.BorderSizePixel = 0
        copyBtn.Text = "Copy"
        copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
        copyBtn.Font = Enum.Font.GothamSemibold
        copyBtn.TextSize = 12
        copyBtn.Parent = card
        local cbc = Instance.new("UICorner"); cbc.CornerRadius = UDim.new(0,6); cbc.Parent = copyBtn

        copyBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if setclipboard then setclipboard(url) end
            end)
            copyBtn.Text = "✓"
            task.delay(1.5, function() copyBtn.Text = "Copy" end)
            notify("Copied!", platform.." link copied.")
        end)
    end

    makeSocialCard(socialsPage, "Discord", ".gg/gepJ6Py9bZ", "https://discord.gg/gepJ6Py9bZ")
    makeSocialCard(socialsPage, "YouTube", "DDOfficialRBLX", "https://youtube.com/@DDOfficialRBLX")

    local noteLbl = Instance.new("TextLabel")
    noteLbl.Size = UDim2.new(1,-4,0,44)
    noteLbl.BackgroundColor3 = Color3.fromRGB(28,28,35)
    noteLbl.BorderSizePixel = 0
    noteLbl.Text = "💬  Want more scripts or executor info?\nJoin our Discord — discord.gg/gepJ6Py9bZ"
    noteLbl.TextColor3 = Color3.fromRGB(160,160,170)
    noteLbl.Font = Enum.Font.Gotham
    noteLbl.TextSize = 12
    noteLbl.TextWrapped = true
    noteLbl.TextYAlignment = Enum.TextYAlignment.Center
    noteLbl.Parent = socialsPage
    local nlc = Instance.new("UICorner"); nlc.CornerRadius = UDim.new(0,7); nlc.Parent = noteLbl
    local nlp = Instance.new("UIPadding")
    nlp.PaddingLeft = UDim.new(0,10); nlp.PaddingRight = UDim.new(0,10); nlp.Parent = noteLbl
end

-- ============================================================
-- OPEN / CLOSE LOGIC
-- ============================================================
local guiOpen = false
local function toggleGui()
    guiOpen = not guiOpen
    MainFrame.Visible = guiOpen
    if guiOpen then
        MainFrame.Size = UDim2.new(0,0,0,0)
        MainFrame.Position = UDim2.new(0.5,0,0.5,0)
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0,620,0,460),
            Position = UDim2.new(0.5,-310,0.5,-230)
        }):Play()
    end
end

OpenBtn.MouseButton1Click:Connect(toggleGui)
CloseBtn2.MouseButton1Click:Connect(function()
    guiOpen = false
    TweenService:Create(MainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0),
        Position = UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.delay(0.2, function() MainFrame.Visible = false end)
end)

-- ============================================================
-- GLOBAL ESP HEARTBEAT (Universal ESP)
-- ============================================================
RunService.Heartbeat:Connect(function()
    if espActive then updateESP() end
end)

-- ============================================================
-- WELCOME NOTIFY
-- ============================================================
task.delay(1, function()
    notify("EXOS ADMIN v1", "Loaded! Executor: "..executorName, 5)
    if isBadExecutor then
        task.delay(1.5, function()
            notify("⚠ Warning", executorName.." detected — some features are limited.", 6)
        end)
    end
end)

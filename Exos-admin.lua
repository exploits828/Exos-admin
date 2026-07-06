-- // EXOS HUB (Blue Edition)
-- // WindUI-based multifunctional hub
-- // Original by Yuxtix, translated and recolored

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local HttpService = game:GetService("HttpService")

-- ============================================================
-- CUSTOM THEME – BLUE
-- ============================================================
WindUI:AddTheme({
    Name = "ExosBlue",
    BackgroundTransparency = 1,
    Outline = Color3.fromHex("#FFFFFF"),
    Icon = Color3.fromHex("#FFFFFF"),
    Button = Color3.fromHex("#2878DC"),        -- blue
    Text = Color3.fromHex("#FFFFFF"),
    Accent = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#1E6FD9"), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromHex("#0A3D91"), Transparency = 0.5 },
    }, {
        Rotation = 45,
    }),
})

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local Window = WindUI:CreateWindow({
    Title = "EXOS HUB",
    Icon = "rbxassetid://137966710397131",
    Author = "EXOS",
    Folder = "ExosHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "ExosBlue",
    SideBarWidth = 200,
    Background = "",
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("User clicked")
        end,
    },
})

WindUI:SetTheme("ExosBlue")

-- Customize the floating open button
Window:EditOpenButton({
    Title = "EXOS Hub",
    Icon = "rbxassetid://137966710397131",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("#1E6FD9"),
        Color3.fromHex("#0A3D91")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

WindUI:SetNotificationLower(true)

-- ============================================================
-- TAB: HOME
-- ============================================================
local TabHome = Window:Tab({
    Title = "Home",
    Icon = "hammer",
    Locked = false,
})

local SectionHome = TabHome:Section({
    Title = "Executor Info",
    TextXAlignment = "Left",
    TextSize = 17,
})

TabHome:Paragraph({
    Color = "Blue",
    Title = "Executor Security",
    Desc = "Your executor: " .. identifyexecutor() .. " – 70% secure",
})

TabHome:Section({
    Title = "Game Info",
    TextXAlignment = "Left",
    TextSize = 17,
})

TabHome:Paragraph({
    Title = "Game Name",
    Desc = game.Name,
})

-- ============================================================
-- TAB: UNIVERSAL SCRIPTS
-- ============================================================
local TabUniversal = Window:Tab({
    Title = "Universal",
    Icon = "earth",
    Locked = false,
})

-- Infinite Yield
TabUniversal:Paragraph({
    Title = "Infinite Yield (Admin)",
    Desc = "The best admin panel",
    Thumbnail = "rbxassetid://109542747481756",
    ThumbnailSize = 80,
    Buttons = {
        {
            Icon = "play",
            Title = "Execute",
            Callback = function()
                WindUI:Notify({
                    Title = "Executed",
                    Content = "Enjoy!",
                    Icon = "rbxassetid://10876599977",
                    Duration = 5,
                })
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end,
        }
    }
})

-- Dex Plus
TabUniversal:Paragraph({
    Title = "Dex Plus (Explorer)",
    Thumbnail = "rbxassetid://152367563",
    ThumbnailSize = 100,
    Buttons = {
        {
            Icon = "play",
            Title = "Execute",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/yuxtix/Hub/refs/heads/main/dex%20plus.lua"))()
            end,
        }
    }
})

-- Animation Replacer
TabUniversal:Paragraph({
    Title = "GUI Animation Replacer",
    Thumbnail = "rbxassetid://134862921411582",
    ThumbnailSize = 100,
    Buttons = {
        {
            Icon = "play",
            Title = "Execute",
            Callback = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/yuxtix/Hub/refs/heads/main/Gui%20Animation"))()
            end,
        }
    }
})

-- HTTP Spy
TabUniversal:Button({
    Title = "HTTP Spy",
    Desc = "Capture all HTTP requests",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Ketamine/refs/heads/main/Ketamine.lua"))()
    end
})

-- Find Scripts
TabUniversal:Button({
    Title = "Find Scripts (Solara Hub)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/Solara-Hub/main/SH.lua"))()
    end
})

-- Aimbot
TabUniversal:Button({
    Title = "Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ttwizz/Open-Aimbot/master/source.lua"))()
    end
})

-- Free Camera
TabUniversal:Button({
    Title = "Free Camera (Shift+P)",
    Callback = function()
        loadstring(game:HttpGet("https://zxfolix.github.io/freecamV2.txt"))()
    end
})

-- Telekinesis
TabUniversal:Button({
    Title = "Telekinesis v5",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/Qwerty/refs/heads/main/qwerty11.lua"))()
    end
})

-- Universe Viewer
TabUniversal:Button({
    Title = "Universe Viewer",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EnesXVC/UniverseViewer/main/script"))()
    end
})

-- Buy DevProducts
TabUniversal:Button({
    Title = "Buy DevProducts",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/rndmq/Serverlist/refs/heads/main/Server87"))()
    end
})

-- Chat Spy
TabUniversal:Button({
    Title = "Chat Spy (Low)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yuxtix/Hub/refs/heads/main/Chat.lua"))()
    end
})

-- NPC Hack Controller
TabUniversal:Button({
    Title = "NPC Hack Controller",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yuxtix/Npc-hack-controller/refs/heads/main/Main.lua"))()
    end
})

-- ScriptBlox Search
TabUniversal:Button({
    Title = "ScriptBlox Search",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/ScriptSearcher"))()
    end
})

-- Friends Detector
TabUniversal:Button({
    Title = "Friends Detector",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/6n6A85CR"))()
    end
})

-- Copy Server Join
TabUniversal:Button({
    Title = "Copy Server Join",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/Solara-Hub-Scripts/refs/heads/main/CopyServerJoin.lua"))()
    end
})

-- Catalog Editor (Avatar preview saver)
TabUniversal:Button({
    Title = "Catalog Editor",
    Desc = "Steal avatar preview model",
    Callback = function()
        local Params = {
            RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
            SSI = "saveinstance",
        }
        local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
        local CustomOptions = {
            SaveBytecode = true,
            Object = game:GetService("Players").LocalPlayer.PlayerGui.CatalogGUI.AvatarPreview.ViewportHolder.DraggableNPCVPF.NPC,
            mode = "full",
            noscripts = true
        }
        synsaveinstance(CustomOptions)
    end
})

-- Proximity Prompt 0
TabUniversal:Button({
    Title = "Proximity Prompt 0",
    Desc = "Set all ProximityPrompts to 0 seconds",
    Callback = function()
        while true do
            local modified = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = 0
                    modified = modified + 1
                end
            end
            if modified > 200 then
                wait(8)
                print("Too many objects")
            else
                wait(2)
            end
        end
    end
})

-- ============================================================
-- TELEPORT SECTION
-- ============================================================
TabUniversal:Section({
    Title = "Teleport",
    TextXAlignment = "Left",
    TextSize = 17,
})

local savedPos = "0, 0, 0"
local x, y, z = 0, 0, 0

local function getRoot(char)
    if not char then return nil end
    return char.PrimaryPart or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
end

TabUniversal:Button({
    Title = "Save Position",
    Icon = "clipboard-copy",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local root = getRoot(char)
        if root then
            local pos = root.Position
            x, y, z = math.round(pos.X), math.round(pos.Y), math.round(pos.Z)
            savedPos = x .. ", " .. y .. ", " .. z
            WindUI:Notify({
                Title = "Saved",
                Content = savedPos,
                Icon = "rbxassetid://10876599977",
                Duration = 5,
            })
        end
    end
})

TabUniversal:Keybind({
    Title = "Teleport to Saved",
    Desc = "Keybind to teleport",
    Icon = "move-3d",
    Value = "",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local root = getRoot(char)
        if root then
            root.CFrame = CFrame.new(x, y, z)
            WindUI:Notify({
                Title = "Teleported",
                Content = savedPos,
                Icon = "rbxassetid://10876599977",
                Duration = 5,
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Character not found",
                Icon = "rbxassetid://10876599977",
                Duration = 3,
            })
        end
    end
})

-- ============================================================
-- CONSOLE COPY
-- ============================================================
TabUniversal:Section({
    Title = "Console",
    TextXAlignment = "Left",
    TextSize = 17,
})

TabUniversal:Button({
    Title = "Console Copy",
    Desc = "Copy console output",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yuxtix/Console-copy/refs/heads/main/start.lua"))()
    end
})

-- ============================================================
-- TAB: PRISON LIFE
-- ============================================================
local TabPrison = Window:Tab({
    Title = "Prison Life",
    Icon = "user",
    Locked = false,
})

TabPrison:Button({
    Title = "PrizzLife",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/devguy100/PrizzLife/refs/heads/main/pladmin.lua"))()
    end
})

TabPrison:Button({
    Title = "Rayans Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Sirius/refs/heads/request/prompt.lua"))()
    end
})

-- ============================================================
-- TAB: STEAL A BRAINROT MENU (???)
-- ============================================================
local TabSteal = Window:Tab({
    Title = "Steal Menu",
    Icon = "user",
    Locked = false,
})

TabSteal:Button({
    Title = "TP to Base",
    Callback = function()
        game:GetService("ReplicatedStorage")["TpToBase"]:FireServer()
    end
})

-- ============================================================
-- TAB: SCRIPTBLOX SEARCH
-- ============================================================
local TabScriptBlox = Window:Tab({
    Title = "ScriptBlox Search",
    Icon = "tally-5"
})

local currentPage = 1
local lastQuery = ""
local resultObjects = {}

local function clearResults()
    for _, obj in pairs(resultObjects) do
        obj:Destroy()
    end
    resultObjects = {}
end

local function fetchScripts(query, page)
    if query == "" then return end
    local url = string.format(
        "https://scriptblox.com/api/script/search?q=%s&page=%d&max=10",
        HttpService:UrlEncode(query),
        page
    )
    local success, response = pcall(function() return game:HttpGet(url) end)
    if success then
        local data = HttpService:JSONDecode(response)
        local scripts = data.result.scripts
        if #scripts == 0 then
            WindUI:Notify({ Title = "End", Content = "No more results.", Duration = 3 })
            return
        end
        for _, s in pairs(scripts) do
            local thumbUrl = s.game.imageUrl and ("https://scriptblox.com" .. s.game.imageUrl) or ""
            local scriptImg = s.image and ("https://scriptblox.com" .. s.image) or thumbUrl
            local status = s.isPatched and "❌ PATCHED" or "✅ WORKING"
            local verified = s.verified and " ⭐ Verified" or ""
            local keySystem = s.key and " 🔑 Key Required" or " 🔓 No Key"
            local card = TabScriptBlox:Paragraph({
                Title = s.title .. verified,
                Desc = string.format(
                    "Game: %s\nStatus: %s\nViews: %d | %s%s",
                    s.game.name, status, s.views, s.scriptType, keySystem
                ),
                Image = thumbUrl,
                ImageSize = 25,
                Thumbnail = scriptImg,
                ThumbnailSize = 70,
                Buttons = {
                    {
                        Icon = "play",
                        Title = "Execute",
                        Callback = function()
                            WindUI:Notify({ Title = "Executing...", Content = s.title })
                            local code = game:HttpGet("https://scriptblox.com/api/script/raw/" .. s._id)
                            loadstring(code)()
                        end,
                    },
                    {
                        Icon = "copy",
                        Title = "Copy Link",
                        Callback = function()
                            setclipboard("https://scriptblox.com/script/" .. s.slug)
                            WindUI:Notify({ Title = "Copied", Content = "Link copied to clipboard" })
                        end,
                    }
                }
            })
            table.insert(resultObjects, card)
        end
    end
end

TabScriptBlox:Input({
    Title = "Search",
    Placeholder = "Enter game name...",
    Callback = function(val) lastQuery = val end
})

TabScriptBlox:Button({
    Title = "Search Now",
    Icon = "search-code",
    Callback = function()
        currentPage = 1
        clearResults()
        fetchScripts(lastQuery, currentPage)
    end
})

TabScriptBlox:Button({
    Title = "Load More",
    Icon = "circle-plus",
    Desc = "Get next page",
    Callback = function()
        currentPage = currentPage + 1
        fetchScripts(lastQuery, currentPage)
    end
})

WindUI:Notify({ Title = "Welcome", Content = "ScriptBlox API connected" })

-- ============================================================
-- TAB: VALLEY PRISON TELEPORTS
-- ============================================================
local TabValley = Window:Tab({
    Title = "Valley Prison",
    Icon = "tally-5"
})

TabValley:Keybind({
    Title = "TP to AK47",
    Icon = "move-3d",
    Value = "",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local root = getRoot(char)
        if root then
            root.CFrame = CFrame.new(190, 23, -214)
            WindUI:Notify({ Title = "Teleported", Content = "To AK47", Duration = 5 })
        end
    end
})

TabValley:Keybind({
    Title = "TP to Key Worker",
    Icon = "move-3d",
    Value = "",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local root = getRoot(char)
        if root then
            root.CFrame = CFrame.new(176, 23, -142)
            WindUI:Notify({ Title = "Teleported", Content = "To Key Worker (wait a moment)", Duration = 5 })
        end
    end
})

-- ============================================================
-- TAB: PIANO UNIVERSAL
-- ============================================================
local TabPiano = Window:Tab({
    Title = "Universal Piano",
    Icon = "music",
    Locked = false,
})

TabPiano:Paragraph({
    Title = "Auto Piano",
    Desc = "You don't have permission to execute this (locked by default).",
    Thumbnail = "rbxassetid://4904222288",
    ThumbnailSize = 120,
    Locked = true,   -- locked by original author, keep as is
    Buttons = {
        {
            Icon = "play",
            Title = "Execute",
            Callback = function()
                loadstring(game:HttpGet("https://hellohellohell0.com/talentless-raw/TALENTLESS.lua", true))()
            end,
        }
    }
})

-- ============================================================
-- TAB: HUBS (includes MOIS7)
-- ============================================================
local TabHubs = Window:Tab({
    Title = "Hubs",
    Icon = "app-window"
})

TabHubs:Button({
    Title = "Solara Hub",
    Desc = "----",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/samuraa1/Solara-Hub/main/SH.lua"))()
    end
})

TabHubs:Button({
    Title = "MOIS7 Admin (Command-Based)",
    Desc = "The admin you wanted – exactly like the screenshot",
    Callback = function()
        loadstring(game:HttpGet("https://mois7.xyz/loader"))()
    end
})

TabHubs:Button({
    Title = "Ph4asmo",
    Desc = "----",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end
})

-- ============================================================
-- TAB: BACKDOORS
-- ============================================================
local TabBackdoors = Window:Tab({
    Title = "Backdoors",
    Icon = "server-crash"
})

TabBackdoors:Button({
    Title = "Quicky Cmd",
    Callback = function()
        loadstring(game:HttpGet("https://gist.github.com/someunknowndude/38cecea5be9d75cb743eac8b1eaf6758/raw"))()
    end
})

TabBackdoors:Button({
    Title = "Lalol Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Its-LALOL/LALOL-Hub/main/Backdoor-Scanner/script"))()
    end
})

TabBackdoors:Button({
    Title = "Backdoor.exe",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Backdoor-exe-9413"))()
    end
})

-- ============================================================
-- TAB: VISUAL HIERARCHY (Model Explorer)
-- ============================================================
local TabHierarchy = Window:Tab({
    Title = "Visual Hierarchy",
    Icon = "list-tree",
    Locked = false,
})

TabHierarchy:Section({
    Title = "Model Explorer",
    TextXAlignment = "Left",
    TextSize = 17,
})

local modelPath = ""

TabHierarchy:Input({
    Title = "Model Path",
    Desc = "Example: workspace.Model",
    Placeholder = "Enter path here...",
    InputIcon = "folder",
    Callback = function(input)
        modelPath = input
        WindUI:Notify({ Title = "Path saved", Content = "Model: " .. input, Duration = 3 })
    end
})

local CodeViewer = TabHierarchy:Code({
    Title = "Model Hierarchy",
    Code = "-- Waiting for model...",
})

local function buildTree(instance, level)
    local lines = {}
    local prefix = string.rep(">", level)
    local text = string.format("%s%s -- %s", prefix, instance.Name, instance.ClassName)
    table.insert(lines, text)
    for _, child in ipairs(instance:GetChildren()) do
        local subLines = buildTree(child, level + 1)
        for _, line in ipairs(subLines) do
            table.insert(lines, line)
        end
    end
    return lines
end

TabHierarchy:Button({
    Title = "Show Hierarchy",
    Desc = "Generate tree of the specified model",
    Icon = "tree-palm",
    Callback = function()
        if modelPath == "" then
            WindUI:Notify({ Title = "Error", Content = "Please enter a path first.", Icon = "alert-triangle", Duration = 4 })
            return
        end
        local ok, model = pcall(function()
            return loadstring("return " .. modelPath)()
        end)
        if not ok or model == nil then
            WindUI:Notify({ Title = "Invalid Path", Content = "Model not found: " .. modelPath, Icon = "x-circle", Duration = 5 })
            CodeViewer:SetCode("-- Error: invalid path or model not found.")
            return
        end
        local output = buildTree(model, 0)
        CodeViewer:SetCode(table.concat(output, "\n"))
        WindUI:Notify({ Title = "Hierarchy generated", Content = "Model: " .. model.Name, Icon = "check-circle", Duration = 4 })
    end
})

-- ============================================================
-- TAB: EXPORT PLAYERGUI
-- ============================================================
local TabExport = Window:Tab({
    Title = "Export PlayerGui",
    Icon = "folder-output",
    Locked = false,
})

TabExport:Section({
    Title = "Export Player's GUI",
    TextXAlignment = "Left",
    TextSize = 17,
})

TabExport:Paragraph({
    Title = "Description",
    Desc = "Clones all objects from PlayerGui to Lighting and saves them with SynSaveInstance.",
})

TabExport:Button({
    Title = "Export and Save",
    Desc = "Clone PlayerGui to Lighting and save as file.",
    Icon = "save",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local FolderName = "Exported_PlayerGui"
        local ExportFolder = Lighting:FindFirstChild(FolderName) or Instance.new("Folder")
        ExportFolder.Name = FolderName
        ExportFolder.Parent = Lighting

        for _, child in ipairs(PlayerGui:GetChildren()) do
            local clone = child:Clone()
            clone.Parent = ExportFolder
        end

        local Params = {
            RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
            SSI = "saveinstance",
        }
        local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
        local CustomOptions = {
            SaveBytecode = true,
            Object = game:GetService("Lighting").Exported_PlayerGui,
            mode = "full",
            noscripts = true
        }
        synsaveinstance(CustomOptions)

        WindUI:Notify({
            Title = "Completed",
            Content = "PlayerGui exported and saved successfully.",
            Icon = "check-circle",
            Duration = 5,
        })
    end,
})

-- ============================================================
-- TAB: STEAL SCRIPTS (Xeno Logger)
-- ============================================================
local TabStealScripts = Window:Tab({
    Title = "Steal Scripts",
    Icon = "scroll-text",
    Locked = false,
})

TabStealScripts:Button({
    Title = "Start Logging (Xeno)",
    Icon = "folder-output",
    Desc = "Hook loadstring to save executed scripts",
    Callback = function()
        if not isfolder("LogsXeno") then makefolder("LogsXeno") end
        local subfolder = "LogsXeno/ScriptsEjecutados"
        if not isfolder(subfolder) then makefolder(subfolder) end

        local function getNextIndex()
            local files = listfiles(subfolder)
            local maxIndex = 0
            for _, file in ipairs(files) do
                local name = file:match(".*/(%d+)%.lua$")
                if name then
                    local num = tonumber(name)
                    if num and num > maxIndex then maxIndex = num end
                end
            end
            return maxIndex + 1
        end

        if getgenv().XENO_LOGGER_ACTIVE then
            warn("XENO LOGGER already active")
            return
        end
        getgenv().XENO_LOGGER_ACTIVE = true

        local old_loadstring = loadstring
        getgenv().loadstring = function(code, ...)
            local index = getNextIndex()
            local filename = ("%s/%d.lua"):format(subfolder, index)
            writefile(filename,
                "-- ==== EXECUTED SCRIPT BEGIN ====\n" ..
                "-- ==== Hooked by EXOS Hub ====\n" ..
                code ..
                "\n-- ==== EXECUTED SCRIPT END ====\n"
            )
            return old_loadstring(code, ...)
        end

        WindUI:Notify({
            Title = "Logger Active",
            Content = "All loadstring calls will be saved.",
            Icon = "check-circle",
            Duration = 5,
        })
    end
})

TabStealScripts:Button({
    Title = "Delete Logs",
    Icon = "trash-2",
    Desc = "Delete all saved script logs",
    Callback = function()
        local folder = "LogsXeno/ScriptsEjecutados"
        if isfolder(folder) then
            local files = listfiles(folder)
            for _, file in ipairs(files) do
                if isfile(file) then delfile(file) end
            end
        end
        WindUI:Notify({ Title = "Deleted", Content = "All logs removed.", Duration = 3 })
    end
})

-- ============================================================
-- TAB: TOOL STEALER
-- ============================================================
local TabTools = Window:Tab({
    Title = "Tool Stealer",
    Icon = "wrench",
    Locked = false,
})

TabTools:Section({
    Title = "Found Tools",
    TextXAlignment = "Left",
    TextSize = 17,
})

local function giveTool(obj)
    local player = game.Players.LocalPlayer
    if player and player:FindFirstChild("Backpack") then
        local clone = obj:Clone()
        clone.Parent = player.Backpack
        WindUI:Notify({
            Title = "Tool Obtained",
            Content = "Received: " .. obj.Name,
            Icon = "rbxassetid://10876599977",
            Duration = 3,
        })
    end
end

TabTools:Button({
    Title = "Scan Tools",
    Desc = "Find all tools in the game and create buttons",
    Icon = "refresh-cw",
    Callback = function()
        local found = 0
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("Tool") then
                found = found + 1
                local icon = v.TextureId or ""
                TabTools:Button({
                    Icon = icon,
                    Title = "Get: " .. v.Name,
                    Desc = "Original location: " .. v.Parent.Name,
                    Callback = function()
                        giveTool(v)
                    end
                })
            end
        end
        WindUI:Notify({
            Title = "Scan Complete",
            Content = "Found " .. found .. " tools.",
            Icon = "check-circle",
            Duration = 5,
        })
    end
})

-- ============================================================
-- TAB: SAVE GAME (SynSaveInstance)
-- ============================================================
local TabSave = Window:Tab({
    Title = "Save Game",
    Icon = "save",
    Locked = false,
})

TabSave:Section({
    Title = "SynSaveInstance Settings",
    TextXAlignment = "Left",
    TextSize = 17,
})

local SaveOptions = {
    mode = "full",
    noscripts = false,
    isdecomposed = false,
    removehuat = false,
    noscripts_on_save = false,
    SaveBytecode = false,
    DecompileIgnore = {},
    Object = game
}

TabSave:Dropdown({
    Title = "Save Mode",
    Multi = false,
    AllowNone = false,
    Value = "full",
    Values = {"full", "optimized", "scripts", "terrain"},
    Callback = function(v) SaveOptions.mode = v end
})

TabSave:Toggle({
    Title = "NoScripts",
    Desc = "If enabled, scripts will not be saved.",
    Value = false,
    Callback = function(v) SaveOptions.noscripts = v end
})

TabSave:Toggle({
    Title = "IsDecomposed",
    Desc = "Saves the game in multiple files (folder).",
    Value = false,
    Callback = function(v) SaveOptions.isdecomposed = v end
})

TabSave:Toggle({
    Title = "Remove HUAT",
    Desc = "Removes 'Made by' tags from the file.",
    Value = false,
    Callback = function(v) SaveOptions.removehuat = v end
})

TabSave:Toggle({
    Title = "Save Bytecode",
    Desc = "Attempts to save script bytecode.",
    Value = false,
    Callback = function(v) SaveOptions.SaveBytecode = v end
})

TabSave:Toggle({
    Title = "NoScripts on Save",
    Desc = "Does not save scripts during the save process.",
    Value = false,
    Callback = function(v) SaveOptions.noscripts_on_save = v end
})

TabSave:Button({
    Title = "SAVE GAME NOW!",
    Desc = "Starts downloading the map/scripts.",
    Icon = "download",
    Callback = function()
        WindUI:Notify({
            Title = "Saving...",
            Content = "This may freeze the game. Check your executor's workspace folder.",
            Icon = "rbxassetid://10876599977",
            Duration = 8,
        })
        task.spawn(function()
            local Params = {
                RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
                SSI = "saveinstance",
            }
            local ok, synsaveinstance = pcall(function()
                return loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
            end)
            if ok and synsaveinstance then
                synsaveinstance(SaveOptions)
                WindUI:Notify({
                    Title = "Success",
                    Content = "Game saved to your executor's folder.",
                    Icon = "check-circle",
                    Duration = 5,
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Could not load SynSaveInstance API.",
                    Icon = "x-circle",
                    Duration = 5,
                })
            end
        end)
    end
})

-- ============================================================
-- SELECT FIRST TAB
-- ============================================================
Window:SelectTab(1)

-- Startup notification
WindUI:Notify({
    Title = "EXOS HUB Loaded",
    Content = "Blue Edition – Ready!",
    Duration = 4,
})

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Drag helper
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Create ScreenGui root
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExecutorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Minimized button
local minimizedBtn = Instance.new("TextButton")
minimizedBtn.Name = "MinimizedBtn"
minimizedBtn.Size = UDim2.new(0, 54, 0, 54)
minimizedBtn.Position = UDim2.new(1, -70, 1, -70)
minimizedBtn.BackgroundTransparency = 1
minimizedBtn.BorderSizePixel = 0
minimizedBtn.Text = "🎭"
minimizedBtn.TextScaled = true
minimizedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedBtn.Font = Enum.Font.GothamBold
minimizedBtn.AutoButtonColor = false
minimizedBtn.Parent = screenGui
makeDraggable(minimizedBtn)

-- Main panel (shortened)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 44, 52)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
makeDraggable(mainFrame)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,15)

-- Title
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, -88, 0, 32)
titleLabel.Position = UDim2.new(0, 15, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "UnexpectedHub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22

-- Close button
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -44, 0, 10)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.AutoButtonColor = false
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,10)
closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(200,35,50) end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(220,53,69) end)

-- Minimize button (in-panel)
local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Size = UDim2.new(0, 34, 0, 34)
minimizeBtn.Position = UDim2.new(1, -88, 0, 10)
minimizeBtn.Text = "–"
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 28
minimizeBtn.AutoButtonColor = false
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,10)
minimizeBtn.MouseEnter:Connect(function() minimizeBtn.BackgroundColor3=Color3.fromRGB(130,130,130) end)
minimizeBtn.MouseLeave:Connect(function() minimizeBtn.BackgroundColor3=Color3.fromRGB(100,100,100) end)

-- Helper function to create buttons
local function createButton(parent,text,posY)
    local btn=Instance.new("TextButton",parent)
    btn.Size=UDim2.new(0,260,0,38)
    btn.Position=UDim2.new(0,20,0,posY)
    btn.BackgroundColor3=Color3.fromRGB(33,150,243)
    btn.TextColor3=Color3.new(1,1,1)
    btn.BorderSizePixel=0
    btn.Font=Enum.Font.Gotham
    btn.TextSize=18
    btn.Text=text
    btn.AutoButtonColor=false
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,12)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3=Color3.fromRGB(25,118,210) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3=Color3.fromRGB(33,150,243) end)
    return btn
end

-- Main buttons
local removeBtn = createButton(mainFrame,"Remove",50)
local webhookBtn = createButton(mainFrame,"Webhook",110)

-- Panels
local removePanel = Instance.new("Frame",screenGui)
removePanel.Size=UDim2.new(0,300,0,320)
removePanel.Position=mainFrame.Position
removePanel.AnchorPoint=Vector2.new(0.5,0.5)
removePanel.BackgroundColor3=Color3.fromRGB(40,44,52)
removePanel.BorderSizePixel=0
removePanel.Visible=false
Instance.new("UICorner",removePanel).CornerRadius=UDim.new(0,15)
makeDraggable(removePanel)

local webhookPanel = Instance.new("Frame",screenGui)
webhookPanel.Size=UDim2.new(0,300,0,320)
webhookPanel.Position=mainFrame.Position
webhookPanel.AnchorPoint=Vector2.new(0.5,0.5)
webhookPanel.BackgroundColor3=Color3.fromRGB(40,44,52)
webhookPanel.BorderSizePixel=0
webhookPanel.Visible=false
Instance.new("UICorner",webhookPanel).CornerRadius=UDim.new(0,15)
makeDraggable(webhookPanel)

-- Back buttons
local function addBackButton(panel)
    local back=Instance.new("TextButton",panel)
    back.Size=UDim2.new(0,100,0,34)
    back.Position=UDim2.new(0.5,-50,1,-44)
    back.Text="Back"
    back.Font=Enum.Font.GothamBold
    back.TextSize=18
    back.TextColor3=Color3.new(1,1,1)
    back.BackgroundColor3=Color3.fromRGB(100,100,100)
    Instance.new("UICorner",back).CornerRadius=UDim.new(0,10)
    back.MouseEnter:Connect(function() back.BackgroundColor3=Color3.fromRGB(130,130,130) end)
    back.MouseLeave:Connect(function() back.BackgroundColor3=Color3.fromRGB(100,100,100) end)
    back.MouseButton1Click:Connect(function()
        panel.Visible=false
        mainFrame.Visible=true
    end)
end
addBackButton(removePanel)
addBackButton(webhookPanel)

-- Remove panel buttons
local executeBtn = createButton(removePanel,"Execute",30)
local timedExecuteBtn = createButton(removePanel,"Timed Execute",90)
local stopBtn = createButton(removePanel,"Stop",150)

local timeBox = Instance.new("TextBox",removePanel)
timeBox.Size = UDim2.new(0,260,0,38)
timeBox.Position = UDim2.new(0,20,0,210)
timeBox.PlaceholderText = "Set seconds..."
timeBox.TextColor3 = Color3.new(1,1,1)
timeBox.BackgroundColor3 = Color3.fromRGB(55,61,71)
timeBox.Font = Enum.Font.Gotham
timeBox.TextSize = 18
timeBox.ClearTextOnFocus = false
Instance.new("UICorner",timeBox).CornerRadius = UDim.new(0,12)
makeDraggable(timeBox)

-- Webhook panel elements
local webhookTextBox = Instance.new("TextBox",webhookPanel)
webhookTextBox.Size=UDim2.new(0,260,0,38)
webhookTextBox.Position=UDim2.new(0,20,0,50)
webhookTextBox.PlaceholderText="https://discord.com/api/webhooks/..."
webhookTextBox.Text = "https://discord.com/api/webhooks/1405130155789127690/MADvWJXyb0zKKXnxMDPpV_JjcRBxNj2lyhWDoT5f4VKyJjNYFMWRxq4dtJqclpVgqfA0"
webhookTextBox.TextColor3=Color3.new(1,1,1)
webhookTextBox.BackgroundColor3=Color3.fromRGB(55,61,71)
webhookTextBox.Font=Enum.Font.Gotham
webhookTextBox.TextSize=16
webhookTextBox.ClearTextOnFocus=false
Instance.new("UICorner",webhookTextBox).CornerRadius=UDim.new(0,12)
makeDraggable(webhookTextBox)

local intervalBox = Instance.new("TextBox",webhookPanel)
intervalBox.Size=UDim2.new(0,260,0,38)
intervalBox.Position=UDim2.new(0,20,0,100)
intervalBox.PlaceholderText="Interval in minutes"
intervalBox.TextColor3=Color3.new(1,1,1)
intervalBox.BackgroundColor3=Color3.fromRGB(55,61,71)
intervalBox.Font=Enum.Font.Gotham
intervalBox.TextSize=16
intervalBox.ClearTextOnFocus=false
Instance.new("UICorner",intervalBox).CornerRadius=UDim.new(0,12)
makeDraggable(intervalBox)

local statusToggle = createButton(webhookPanel,"Status: OFF",150)
local testBtn = createButton(webhookPanel,"Send Test Ping",200)
local heartbeatThread=nil
local statusOn=false

-- Units for leaderboard stats
local statUnits = {
    Coins = "Coins",
    Seeds = "Seeds",
    Kills = "Kills",
    Deaths = "Deaths",
    Points = "Points"
}

-- Unified webhook sender
local function sendWebhookMessage(message)
    local url = webhookTextBox.Text
    if not url or url:match("^%s*$") then return end
    local payload = HttpService:JSONEncode({content = message})
    local requestFunction = http_request or request or HttpPost or syn.request
    if requestFunction then
        pcall(function()
            requestFunction({
                Url = url,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = payload
            })
        end)
    else
        warn("HTTP request not supported!")
    end
end

-- Send combined status + full leaderboard stats (reliable GMT+8)
local function sendFullStatusWithStats()
    local username = player.Name

    -- Correct GMT+8 timestamp
    local timestamp = os.date("!%Y-%m-%d %H:%M:%S", os.time() + 8*3600)

    local message = string.format(
        "🟢 Your account is still running: %s\nTime (GMT+8): %s\n\n",
        username, timestamp
    )

    for _, plr in ipairs(Players:GetPlayers()) do
        local statsFolder = plr:FindFirstChild("leaderstats")
        if statsFolder then
            message = message .. "**" .. plr.Name .. "**\n"
            for _, stat in ipairs(statsFolder:GetChildren()) do
                if stat:IsA("IntValue") or stat:IsA("NumberValue") or stat:IsA("StringValue") then
                    local unit = statUnits[stat.Name] or ""
                    if unit ~= "" then
                        message = message .. stat.Name .. ": " .. tostring(stat.Value) .. " " .. unit .. "\n"
                    else
                        message = message .. stat.Name .. ": " .. tostring(stat.Value) .. "\n"
                    end
                end
            end
            message = message .. "\n"
        end
    end

    message = message .. "UnexpectedHub Automatic Notification System"

    sendWebhookMessage(message)
end

-- Status toggle
statusToggle.MouseButton1Click:Connect(function()
    statusOn = not statusOn
    statusToggle.Text = "Status: " .. (statusOn and "ON" or "OFF")
    if statusOn then
        local interval = tonumber(intervalBox.Text) or 5
        heartbeatThread = task.spawn(function()
            while statusOn do
                sendFullStatusWithStats()
                task.wait(interval * 60)
            end
        end)
    else
        if heartbeatThread then task.cancel(heartbeatThread) heartbeatThread = nil end
    end
end)

-- Test ping button
testBtn.MouseButton1Click:Connect(function()
    sendFullStatusWithStats()
end)

-- Main button events
minimizedBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible=true
    minimizedBtn.Visible=false
end)
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible=false
    minimizedBtn.Visible=true
end)
closeBtn.MouseButton1Click:Connect(function()
    if heartbeatThread then task.cancel(heartbeatThread) end
    screenGui:Destroy()
end)
removeBtn.MouseButton1Click:Connect(function() mainFrame.Visible=false removePanel.Visible=true end)
webhookBtn.MouseButton1Click:Connect(function() mainFrame.Visible=false webhookPanel.Visible=true end)

-- Remove panel Execute / Timed Execute / Stop functionality
local timerRunning=false
local timerThread=nil

local function stopTimer()
    timerRunning=false
    if timerThread then task.cancel(timerThread) timerThread=nil end
end

local function runRemoveScript()
    for _,obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") then
            if obj.Name:lower():find("pillar") or obj.Name:lower():find("building") then
                obj.Transparency=1
                obj.CanCollide=false
                obj.Anchored=true
                obj.Size=Vector3.new(0,0,0)
            end
        elseif obj:IsA("Model") then
            for _,part in ipairs(obj:GetDescendants()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    part.Transparency=1
                    part.CanCollide=false
                    part.Anchored=true
                    part.Size=Vector3.new(0,0,0)
                end
            end
        end
    end
end

executeBtn.MouseButton1Click:Connect(function()
    task.spawn(runRemoveScript)
end)

timedExecuteBtn.MouseButton1Click:Connect(function()
    local s = tonumber(timeBox.Text)
    if s and s > 0 and not timerRunning then
        timerRunning = true
        timeBox.ClearTextOnFocus = false
        timerThread = task.spawn(function()
            while timerRunning do
                for i = s, 1, -1 do
                    if not timerRunning then break end
                    timeBox.Text = tostring(i) .. "s"
                    task.wait(1)
                end
                if not timerRunning then break end
                runRemoveScript()
            end
            timeBox.Text = "Set seconds..."
            timeBox.ClearTextOnFocus = true
        end)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    stopTimer()
    timeBox.Text = "Set seconds..."
    timeBox.ClearTextOnFocus = true
end)

-- Start minimized
mainFrame.Visible=false
minimizedBtn.Visible=true

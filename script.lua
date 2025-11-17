local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Config = {
    SavedPosition = nil,
    SpeedEnabled = false,
    FlyEnabled = false,
    OriginalWalkSpeed = 16,
    BoostSpeed = 100,
    FlySpeed = 100,
    NoclipEnabled = false
}

local ScreenGui, Character, HumanoidRootPart, Humanoid

local function CreateGUI()
    if PlayerGui:FindFirstChild("onetwothreeX_GUI") then
        PlayerGui.onetwothreeX_GUI:Destroy()
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "onetwothreeX_GUI"
    ScreenGui.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 400)
    MainFrame.Position = UDim2.new(0, 50, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(80, 80, 120)
    UIStroke.Parent = MainFrame

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "onetwothreeX Control Panel"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Position = UDim2.new(0, 0, 0, 35)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "v1.0.0"
    Subtitle.TextColor3 = Color3.fromRGB(200, 200, 220)
    Subtitle.TextSize = 14
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Parent = Header

    local ButtonsFrame = Instance.new("Frame")
    ButtonsFrame.Size = UDim2.new(1, -20, 1, -80)
    ButtonsFrame.Position = UDim2.new(0, 10, 0, 70)
    ButtonsFrame.BackgroundTransparency = 1
    ButtonsFrame.Parent = MainFrame

    local function CreateButton(text, description, position, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 60)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        Button.BorderSizePixel = 0
        Button.Text = ""
        Button.AutoButtonColor = false
        Button.Parent = ButtonsFrame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Thickness = 1
        ButtonStroke.Color = Color3.fromRGB(70, 70, 100)
        ButtonStroke.Parent = Button
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -20, 0, 25)
        TitleLabel.Position = UDim2.new(0, 10, 0, 8)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = text
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.TextSize = 16
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = Button
        
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, -20, 0, 20)
        DescLabel.Position = UDim2.new(0, 10, 0, 30)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = description
        DescLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        DescLabel.TextSize = 12
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = Button
        
        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(0, 60, 0, 20)
        StatusLabel.Position = UDim2.new(1, -70, 0, 20)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Text = "OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        StatusLabel.TextSize = 12
        StatusLabel.Font = Enum.Font.GothamBold
        StatusLabel.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            callback(StatusLabel)
        end)
        
        return {Button = Button, Status = StatusLabel}
    end

    local buttons = {}

    buttons.save = CreateButton("Save Position", "Store current location for teleport", UDim2.new(0, 0, 0, 0), function(StatusLabel)
        if HumanoidRootPart then
            Config.SavedPosition = HumanoidRootPart.Position
            StatusLabel.Text = "SAVED"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            wait(1)
            StatusLabel.Text = "OFF"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    buttons.load = CreateButton("Load Position", "Teleport to saved location", UDim2.new(0, 0, 0, 70), function(StatusLabel)
        if Config.SavedPosition and HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(Config.SavedPosition)
        end
    end)

    buttons.speed = CreateButton("Speed Boost", "Increase movement speed", UDim2.new(0, 0, 0, 140), function(StatusLabel)
        Config.SpeedEnabled = not Config.SpeedEnabled
        if Config.SpeedEnabled then
            Humanoid.WalkSpeed = Config.BoostSpeed
            StatusLabel.Text = "ON"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            Humanoid.WalkSpeed = Config.OriginalWalkSpeed
            StatusLabel.Text = "OFF"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    buttons.fly = CreateButton("Flight Mode", "Enable aerial movement", UDim2.new(0, 0, 0, 210), function(StatusLabel)
        Config.FlyEnabled = not Config.FlyEnabled
        if Config.FlyEnabled then
            local BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Name = "FlyVelocity"
            BodyVelocity.Parent = HumanoidRootPart
            BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            
            local BodyGyro = Instance.new("BodyGyro")
            BodyGyro.Name = "FlyGyro"
            BodyGyro.Parent = HumanoidRootPart
            BodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
            BodyGyro.P = 1000
            BodyGyro.D = 50
            
            StatusLabel.Text = "ON"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            if HumanoidRootPart:FindFirstChild("FlyVelocity") then
                HumanoidRootPart.FlyVelocity:Destroy()
            end
            if HumanoidRootPart:FindFirstChild("FlyGyro") then
                HumanoidRootPart.FlyGyro:Destroy()
            end
            StatusLabel.Text = "OFF"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    buttons.noclip = CreateButton("Noclip Mode", "Pass through objects", UDim2.new(0, 0, 0, 280), function(StatusLabel)
        Config.NoclipEnabled = not Config.NoclipEnabled
        if Config.NoclipEnabled then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            StatusLabel.Text = "ON"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            StatusLabel.Text = "OFF"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
end

local function InitializeCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    
    Config.OriginalWalkSpeed = Humanoid.WalkSpeed
    CreateGUI()
end

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    wait(1)
    InitializeCharacter()
end)

LocalPlayer.CharacterRemoving:Connect(function()
    if ScreenGui then
        ScreenGui:Destroy()
    end
end)

local flyConnection
flyConnection = RunService.RenderStepped:Connect(function()
    if Config.FlyEnabled and HumanoidRootPart and HumanoidRootPart:FindFirstChild("FlyVelocity") then
        local camera = workspace.CurrentCamera
        local moveVector = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * Config.FlySpeed
        end
        
        HumanoidRootPart.FlyVelocity.Velocity = moveVector
        
        if HumanoidRootPart:FindFirstChild("FlyGyro") then
            HumanoidRootPart.FlyGyro.CFrame = camera.CFrame
        end
    end
end)

InitializeCharacter()

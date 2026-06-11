



if game:GetService("CoreGui"):FindFirstChild("UI") then
    local destroy = Instance.new("BoolValue")
    destroy.Name = "DestroyUi"
    destroy.Parent = game:GetService("CoreGui"):FindFirstChild("UI") 
end;

local library = {}
library.connections = {}
library.destroyed = false

local instance_new = Instance.new
local udim2_new = UDim2.new
local color3_rgb = Color3.fromRGB
local mouse = game:GetService("Players").LocalPlayer:GetMouse()
local tween_service = game:GetService("TweenService")

function library.Tween(self, instance, time, properties, onComplete)
  local Tween = tween_service:Create(instance, TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.In), properties)
  if onComplete then
    Tween.Completed:Connect(onComplete)
  end
  Tween:Play()
end

function library.SwitchTab(self, new)
  if new[1] == library.currentTab[1] then return end
  local oldTab, oldBtn = library.currentTab[1], library.currentTab[2]
  local newTab, newBtn = new[1], new[2]
  oldTab.Visible = false
  oldBtn.TextColor3 = color3_rgb(200, 200, 200)
  if oldBtn:FindFirstChild("TabIcon") then
    oldBtn.TabIcon.ImageColor3 = color3_rgb(200, 200, 200)
  end
  newTab.Visible = true
  newBtn.TextColor3 = color3_rgb(255, 255, 255)
  if newBtn:FindFirstChild("TabIcon") then
    newBtn.TabIcon.ImageColor3 = color3_rgb(255, 255, 255)
  end
  library.currentTab = new
end

function library.Drag(self, objDrag, objHold)
  if not objHold then objHold = objDrag end
  local dragging
  local dragInput
  local dragStart
  local startPos

  local function update(input)
    local delta = input.Position - dragStart
    objDrag.Position = udim2_new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
  end

  objHold.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
      dragging = true
      dragStart = input.Position
      startPos = objDrag.Position
          
      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          dragging = false
        end
      end)
    end
  end)

  objDrag.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
      dragInput = input
    end
  end)

  game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
      update(input)
    end
  end)
end

function library.BindOnClick(self, instance, callback)
  return instance.InputEnded:Connect(function(input)
    if input.UserInputType ~= nil then
      callback(input.UserInputType)
    end
  end)
end

local Library = {}

function library.CreateWindow(self, uiTitle)
  local UI = instance_new("ScreenGui")
  function library.Destroy(self)
    for _, v in next, library.connections do
      v:Disconnect()
    end
    UI:Destroy()
  end
  UI.ChildAdded:Connect(function(child)
    if child.Name == "DestroyUi" then
      task.wait()
      library:Destroy()
    end
  end)
  local DropShadowHolder = instance_new("Frame")
  local Main = instance_new("Frame")
  local MainCorner = instance_new("UICorner")
  local UiTitle = instance_new("TextLabel")
  local MainControls = instance_new("Frame")
  local MainControlsCorner = instance_new("UICorner")
  local Close = instance_new("TextButton")
  local SidebarContainer = instance_new("Frame")
  local SidebarContainerCorner = instance_new("UICorner")
  local Sidebar = instance_new("ScrollingFrame")
  local SidebarListLayout = instance_new("UIListLayout")
  local SidebarPadding = instance_new("UIPadding")
  local Blur = instance_new("Frame")
  local BlurCorner = instance_new("UICorner")
  local TabFolder = instance_new("Frame")
  local TabCorner = instance_new("UICorner")
  local ToggleSide = instance_new("ImageLabel")
  local DropShadow = instance_new("ImageLabel")

  UI.Name = "UI"
  UI.Parent = game:GetService("CoreGui")
  UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  
  DropShadowHolder.Name = "DropShadowHolder"
  DropShadowHolder.Parent = UI
  DropShadowHolder.AnchorPoint = Vector2.new(0.5, 0.5)
  DropShadowHolder.BackgroundTransparency = 1.000
  DropShadowHolder.BorderSizePixel = 0
  DropShadowHolder.Position = udim2_new(0.5, 0, 0.5, 0)
  DropShadowHolder.Size = udim2_new(0, 575, 0, 356)
  DropShadowHolder.ZIndex = 0
  
  Main.Name = "Main"
  Main.Parent = DropShadowHolder
  Main.BackgroundColor3 = color3_rgb(36, 38, 49)
  Main.BorderSizePixel = 0
  Main.Size = udim2_new(0, 575, 0, 356)
  Main.ClipsDescendants = true

  
  MainCorner.CornerRadius = UDim.new(0, 4)
  MainCorner.Name = "MainCorner"
  MainCorner.Parent = Main
  
  UiTitle.Name = "UiTitle"
  UiTitle.Parent = Main
  UiTitle.BackgroundColor3 = color3_rgb(255, 255, 255)
  UiTitle.BackgroundTransparency = 1.000
  UiTitle.Position = udim2_new(0.0765217394, 0, 0, 0)
  UiTitle.Size = udim2_new(0, 466, 0, 36)
  UiTitle.ZIndex = 800
  UiTitle.Font = Enum.Font.GothamBold
  UiTitle.Text = uiTitle
  UiTitle.TextColor3 = color3_rgb(235, 235, 235)
  UiTitle.TextSize = 18.000
  UiTitle.TextXAlignment = Enum.TextXAlignment.Left
  library:Drag(DropShadowHolder, UiTitle)
  
  MainControls.Name = "MainControls"
  MainControls.Parent = Main
  MainControls.BackgroundColor3 = color3_rgb(43, 46, 59)
  MainControls.BorderSizePixel = 0
  MainControls.Position = udim2_new(0, 541, 0, 8)
  MainControls.Size = udim2_new(0, 22, 0, 22)
  MainControls.ZIndex = 800
  
  MainControlsCorner.CornerRadius = UDim.new(0, 4)
  MainControlsCorner.Name = "MainControlsCorner"
  MainControlsCorner.Parent = MainControls
  
  Close.Name = "Close"
  Close.Parent = MainControls
  Close.BackgroundColor3 = color3_rgb(255, 255, 255)
  Close.BackgroundTransparency = 1.000
  Close.BorderSizePixel = 0
  Close.Position = udim2_new(0, 0, 0, 0)
  Close.Size = udim2_new(0, 22, 0, 22)
  Close.ZIndex = 800
  Close.Font = Enum.Font.GothamBold
  Close.Text = "X"
  Close.TextColor3 = color3_rgb(235, 235, 235)
  Close.TextSize = 16.000
  
  SidebarContainer.Name = "SidebarContainer"
  SidebarContainer.Parent = Main
  SidebarContainer.BackgroundColor3 = color3_rgb(43, 46, 59)
  SidebarContainer.BorderSizePixel = 0
  SidebarContainer.Position = udim2_new(0, -200, 0, 36)
  SidebarContainer.Size = udim2_new(0, 130, 0, 312)
  SidebarContainer.ZIndex = 900
  SidebarContainer.Visible = false
  
  SidebarContainerCorner.CornerRadius = UDim.new(0, 4)
  SidebarContainerCorner.Name = "SidebarContainerCorner"
  SidebarContainerCorner.Parent = SidebarContainer
  
  Sidebar.Name = "Sidebar"
  Sidebar.Parent = SidebarContainer
  Sidebar.Active = true
  Sidebar.BackgroundColor3 = color3_rgb(255, 255, 255)
  Sidebar.BackgroundTransparency = 1.000
  Sidebar.BorderSizePixel = 0
  Sidebar.Size = udim2_new(1, 0, 1, 0)
  Sidebar.ZIndex = 800
  Sidebar.ScrollBarThickness = 2
  
  SidebarListLayout.Name = "SidebarListLayout"
  SidebarListLayout.Parent = Sidebar
  SidebarListLayout.SortOrder = Enum.SortOrder.LayoutOrder
  SidebarListLayout.Padding = UDim.new(0, 6)
  
  SidebarPadding.Name = "SidebarPadding"
  SidebarPadding.Parent = Sidebar
  SidebarPadding.PaddingLeft = UDim.new(0, 8)
  SidebarPadding.PaddingTop = UDim.new(0, 8)
  
  Blur.Name = "Blur"
  Blur.Parent = Main
  Blur.BackgroundColor3 = color3_rgb(0, 0, 0)
  Blur.BackgroundTransparency = 0.800
  Blur.BorderSizePixel = 0
  Blur.ClipsDescendants = true
  Blur.Size = udim2_new(0, 575, 0, 356)
  Blur.Visible = false
  Blur.ZIndex = 2
  
  BlurCorner.CornerRadius = UDim.new(0, 4)
  BlurCorner.Name = "BlurCorner"
  BlurCorner.Parent = Blur
  
  TabFolder.Name = "TabFolder"
  TabFolder.Parent = Main
  TabFolder.BackgroundColor3 = color3_rgb(43, 46, 59)
  TabFolder.BorderSizePixel = 0
  TabFolder.Position = udim2_new(0.0139130438, 0, 0.101123594, 0)
  TabFolder.Size = udim2_new(0, 559, 0, 312)
  
  TabCorner.CornerRadius = UDim.new(0, 4)
  TabCorner.Name = "TabCorner"
  TabCorner.Parent = TabFolder

  ToggleSide.Name = "ToggleSide"
  ToggleSide.Parent = Main
  ToggleSide.BackgroundTransparency = 1.000
  ToggleSide.BorderSizePixel = 0
  ToggleSide.Position = udim2_new(0.0139130438, 0, 0, 5)
  ToggleSide.Size = udim2_new(0, 28, 0, 28)
  ToggleSide.ZIndex = 800
  ToggleSide.Image = "http://www.roblox.com/asset/?id=6031097225"
  
  DropShadow.Name = "DropShadow"
  DropShadow.Parent = DropShadowHolder
  DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
  DropShadow.BackgroundTransparency = 1.000
  DropShadow.BorderSizePixel = 0
  DropShadow.Position = udim2_new(0.5, 0, 0.5, 0)
  DropShadow.Size = udim2_new(1, 47, 1, 47)
  DropShadow.ZIndex = 0
  DropShadow.Image = "rbxassetid://6014261993"
  DropShadow.ImageColor3 = color3_rgb(0, 0, 0)
  DropShadow.ImageTransparency = 0.500
  DropShadow.ScaleType = Enum.ScaleType.Slice
  DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

  table.insert(library.connections, Sidebar.ChildAdded:Connect(function()
    Sidebar.CanvasSize = udim2_new(1, 0, 0, ((#Sidebar:GetChildren() - 2) * 38) + 8)
  end))
  
  table.insert(library.connections, library:BindOnClick(Close, function(inputType)
    if inputType == Enum.UserInputType.MouseButton1 then
      library:Destroy()
    end
  end))

  local sideOpen = false
  local function toggleSide()
    sideOpen = not sideOpen
    task.delay(sideOpen and 0 or 0.3, function()
      SidebarContainer.Visible = sideOpen
      Blur.Visible = sideOpen
    end)
    library:Tween(ToggleSide, 0.25, {
      Rotation = (sideOpen and 180 or 0)
    })
    library:Tween(SidebarContainer, 0.25, {
      Position = (sideOpen and udim2_new(0, 8, 0, 36) or udim2_new(0, -200, 0, 36))
    })
    library:Tween(Blur, 0.25, {
      BackgroundTransparency = sideOpen and 0.8 or 1
    })
  end
  table.insert(library.connections, library:BindOnClick(ToggleSide, function(inputType)
    if inputType == Enum.UserInputType.MouseButton1 then
      toggleSide()
    end
  end))

  local window = {}
  function window.CreateTab(self, tabOptions)
    assert(tabOptions.Name, "Missing argument 'Name' from tabOptions")
    local TabBtn = instance_new("TextButton")
    local Tab = instance_new("ScrollingFrame")
    local TabListLayout = instance_new("UIListLayout")
    local TabPadding = instance_new("UIPadding")
    local TabIcon = nil
    
    TabBtn.Name = "TabBtn"
    TabBtn.Parent = Sidebar
    TabBtn.BackgroundColor3 = color3_rgb(255, 255, 255)
    TabBtn.BackgroundTransparency = 1.000
    TabBtn.BorderSizePixel = 0
    TabBtn.Position = udim2_new(-0.0982142836, 1, 0.375, 0)
    TabBtn.Size = udim2_new(0, 118, 0, 32)
    TabBtn.ZIndex = 900
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = (tabOptions.Icon ~= nil and "        " .. tabOptions.Name or " " .. tabOptions.Name)
    TabBtn.TextColor3 = color3_rgb(200, 200, 200)
    TabBtn.TextSize = 15.000
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    if tabOptions.Icon then
      TabIcon = instance_new("ImageLabel")
      TabIcon.Name = "TabIcon"
      TabIcon.Parent = TabBtn
      TabIcon.AnchorPoint = Vector2.new(0, 0.5)
      TabIcon.BackgroundTransparency = 1.000
      TabIcon.BorderSizePixel = 0
      TabIcon.Position = udim2_new(0, 0, 0.5, 0)
      TabIcon.Size = udim2_new(0, 24, 0, 24)
      TabIcon.ImageColor3 = color3_rgb(200, 200, 200)
      TabIcon.ZIndex = 900
      TabIcon.Image = string.format("http://www.roblox.com/asset/?id=%s", tostring(tabOptions.Icon))
    end
    
    Tab.Name = "Tab"
    Tab.Parent = TabFolder
    Tab.Active = true
    Tab.BackgroundColor3 = color3_rgb(255, 255, 255)
    Tab.BackgroundTransparency = 1.000
    Tab.BorderSizePixel = 0
    Tab.Size = udim2_new(0, 559, 0, 312)
    Tab.ScrollBarThickness = 2
    Tab.Visible = false

    TabListLayout.Name = "TabListLayout"
    TabListLayout.Parent = Tab
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)
    
    TabPadding.Name = "TabPadding"
    TabPadding.Parent = Tab
    TabPadding.PaddingTop = UDim.new(0, 8)
    
    table.insert(library.connections, library:BindOnClick(TabBtn, function(inputType)
      if inputType == Enum.UserInputType.MouseButton1 then
        library:SwitchTab({ Tab, TabBtn })
        toggleSide()
      end
    end))

    if not library.currentTab then
      library.currentTab = { Tab, TabBtn }
      Tab.Visible = true
      TabBtn.TextColor3 = color3_rgb(255, 255, 255)
      if TabIcon then 
        TabIcon.ImageColor3 = color3_rgb(255, 255, 255)
      end
    end

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
      Tab.CanvasSize = udim2_new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 18)
    end)

    local tab = {}
    function tab.Button(self, buttonOptions)
      assert(buttonOptions.Name, "Missing argument 'Name' from buttonOptions")
      buttonOptions.Callback = buttonOptions.Callback or function() end

      local ButtonModule = instance_new("Frame")
      local ButtonModuleCorner = instance_new("UICorner")
      local ButtonText = instance_new("TextLabel")

      ButtonModule.Name = "ButtonModule"
      ButtonModule.Parent = Tab
      ButtonModule.BackgroundColor3 = color3_rgb(36, 38, 49)
      ButtonModule.BorderSizePixel = 0
      ButtonModule.Position = udim2_new(0.0143112699, 0, 0, 0)
      ButtonModule.Size = udim2_new(1, -16, 0, 38)
      
      ButtonModuleCorner.CornerRadius = UDim.new(0, 4)
      ButtonModuleCorner.Name = "ButtonModuleCorner"
      ButtonModuleCorner.Parent = ButtonModule
      
      ButtonText.Name = "ButtonText"
      ButtonText.Parent = ButtonModule
      ButtonText.BackgroundColor3 = color3_rgb(255, 255, 255)
      ButtonText.BackgroundTransparency = 1.000
      ButtonText.Position = udim2_new(0.0210000277, 0, 0, 0)
      ButtonText.Size = udim2_new(0, 81, 1, 0)
      ButtonText.ZIndex = 800
      ButtonText.Font = Enum.Font.GothamMedium
      ButtonText.Text = buttonOptions.Name
      ButtonText.TextColor3 = color3_rgb(235, 235, 235)
      ButtonText.TextSize = 16.000
      ButtonText.TextXAlignment = Enum.TextXAlignment.Left      
      
      table.insert(library.connections, library:BindOnClick(ButtonModule, function(inputType)
        if inputType == Enum.UserInputType.MouseButton1 then
          buttonOptions.Callback()
        elseif buttonOptions.Callback2 and inputType == Enum.UserInputType.MouseButton2 then
          buttonOptions.Callback2()
        end
      end))
    end

    function tab.Toggle(self, toggleOptions)
      assert(toggleOptions.Name, "Missing argument 'Name' from toggleOptions")
      toggleOptions.State = toggleOptions.State or false
      local ToggleModule = instance_new("Frame")
      local ToggleModuleCorner = instance_new("UICorner")
      local ToggleTitle = instance_new("TextLabel")
      local ToggleValueBack = instance_new("Frame")
      local ToggleValueBackCorner = instance_new("UICorner")
      local ToggleValue = instance_new("Frame")
      local ToggleValueCorner = instance_new("UICorner")   
      
      ToggleModule.Name = "ToggleModule"
      ToggleModule.Parent = Tab
      ToggleModule.BackgroundColor3 = color3_rgb(36, 38, 49)
      ToggleModule.BorderSizePixel = 0
      ToggleModule.Position = udim2_new(0.0143112699, 0, 0, 0)
      ToggleModule.Size = udim2_new(1, -16, 0, 38)
      
      ToggleModuleCorner.CornerRadius = UDim.new(0, 4)
      ToggleModuleCorner.Name = "ToggleModuleCorner"
      ToggleModuleCorner.Parent = ToggleModule
      
      ToggleTitle.Name = "ToggleTitle"
      ToggleTitle.Parent = ToggleModule
      ToggleTitle.BackgroundColor3 = color3_rgb(255, 255, 255)
      ToggleTitle.BackgroundTransparency = 1.000
      ToggleTitle.Position = udim2_new(0.0210000277, 0, 0, 0)
      ToggleTitle.Size = udim2_new(0, 81, 1, 0)
      ToggleTitle.ZIndex = 800
      ToggleTitle.Font = Enum.Font.GothamMedium
      ToggleTitle.Text = toggleOptions.Name
      ToggleTitle.TextColor3 = color3_rgb(235, 235, 235)
      ToggleTitle.TextSize = 16.000
      ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
      
      ToggleValueBack.Name = "ToggleValueBack"
      ToggleValueBack.Parent = ToggleModule
      ToggleValueBack.AnchorPoint = Vector2.new(0, 0.5)
      ToggleValueBack.BackgroundColor3 = color3_rgb(43, 46, 59)
      ToggleValueBack.Position = udim2_new(0.897198796, 0, 0.5, 0)
      ToggleValueBack.Size = udim2_new(-0.0441988967, 72, 1, -16)
      
      ToggleValueBackCorner.CornerRadius = UDim.new(0, 4)
      ToggleValueBackCorner.Name = "ToggleValueBackCorner"
      ToggleValueBackCorner.Parent = ToggleValueBack
      
      ToggleValue.Name = "ToggleValue"
      ToggleValue.Parent = ToggleValueBack
      ToggleValue.BackgroundColor3 = color3_rgb(255, 97, 97)
      ToggleValue.Size = udim2_new(0, 26, 1, 0)
      
      ToggleValueCorner.CornerRadius = UDim.new(0, 4)
      ToggleValueCorner.Name = "ToggleValueCorner"
      ToggleValueCorner.Parent = ToggleValue      
      
      local toggleFunctions = {}
      local ToggleClosedPosition, ToggleClosedColor = udim2_new(0, 0, 0, 0), color3_rgb(255, 97, 97)
      local ToggleOpenPosition, ToggleOpenColor = udim2_new(1, -26, 0, 0), color3_rgb(69, 255, 168)

      table.insert(library.connections, library:BindOnClick(ToggleModule, function(inputType)
        if inputType == Enum.UserInputType.MouseButton1 then
          toggleFunctions:SetState()
        end
      end))

      function toggleFunctions.SetState(self, bool)
        if bool == nil then
          bool = not toggleFunctions:GetState()
        end
        toggleOptions.State = bool
        library:Tween(ToggleValue, 0.1, {
          Position = (toggleOptions.State and ToggleOpenPosition or ToggleClosedPosition),
          BackgroundColor3 = (toggleOptions.State and ToggleOpenColor or ToggleClosedColor)
        })
        toggleOptions.Callback(toggleOptions.State)
      end

      function toggleFunctions.GetState(self)
        return toggleOptions.State
      end

      return toggleFunctions
    end

    function tab.Textbox(self, textboxOptions)
      assert(textboxOptions.Name, "Missing argument 'Name' from textboxOptions")
      local TextboxModule = instance_new("Frame")
      local TextboxModuleCorner = instance_new("UICorner")
      local TextboxTitle = instance_new("TextLabel")
      local TextInputBack = instance_new("Frame")
      local TextInputBackCorner = instance_new("UICorner")
      local TextInput = instance_new("TextBox")
      
      TextboxModule.Name = "TextboxModule"
      TextboxModule.Parent = Tab
      TextboxModule.BackgroundColor3 = color3_rgb(36, 38, 49)
      TextboxModule.BorderSizePixel = 0
      TextboxModule.Size = udim2_new(1, -16, 0, 38)
      
      TextboxModuleCorner.CornerRadius = UDim.new(0, 4)
      TextboxModuleCorner.Name = "TextboxModuleCorner"
      TextboxModuleCorner.Parent = TextboxModule
      
      TextboxTitle.Name = "TextboxTitle"
      TextboxTitle.Parent = TextboxModule
      TextboxTitle.BackgroundColor3 = color3_rgb(255, 255, 255)
      TextboxTitle.BackgroundTransparency = 1.000
      TextboxTitle.Position = udim2_new(0.0210000277, 0, 0, 0)
      TextboxTitle.Size = udim2_new(0, 81, 1, 0)
      TextboxTitle.ZIndex = 800
      TextboxTitle.Font = Enum.Font.GothamMedium
      TextboxTitle.Text = textboxOptions.Name
      TextboxTitle.TextColor3 = color3_rgb(235, 235, 235)
      TextboxTitle.TextSize = 16.000
      TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left
      
      TextInputBack.Name = "TextInputBack"
      TextInputBack.Parent = TextboxModule
      TextInputBack.AnchorPoint = Vector2.new(0, 0.5)
      TextInputBack.BackgroundColor3 = color3_rgb(43, 46, 59)
      TextInputBack.Position = udim2_new(0.801434517, 0, 0.5, 0)
      TextInputBack.Size = udim2_new(0, 100, 1, -16)
      
      TextInputBackCorner.CornerRadius = UDim.new(0, 4)
      TextInputBackCorner.Name = "TextInputBackCorner"
      TextInputBackCorner.Parent = TextInputBack
      
      TextInput.Name = "TextInput"
      TextInput.Parent = TextInputBack
      TextInput.BackgroundColor3 = color3_rgb(255, 255, 255)
      TextInput.BackgroundTransparency = 1.000
      TextInput.BorderSizePixel = 0
      TextInput.Size = udim2_new(1, 0, 1, 0)
      TextInput.Font = Enum.Font.Gotham
      TextInput.Text = textboxOptions.Default or ""
      TextInput.TextColor3 = color3_rgb(255, 255, 255)
      TextInput.TextSize = 14.000

      local textboxFunctions = {}
      function textboxFunctions.GetValue(self)
        return TextInput.Text
      end

      if textboxOptions.Callback then
        if textboxOptions.CallbackOnChange then
          table.insert(library.connections, TextInput:GetPropertyChangedSignal("Text"):Connect(function()
            textboxOptions.Callback(textboxFunctions:GetValue())
          end))
        else
          table.insert(library.connections, TextInput.FocusLost:Connect(function()
            textboxOptions.Callback(textboxFunctions:GetValue())
            if textboxOptions.ClearOnFocusLost then
              TextInput.Text = ""
            end
          end))
        end
      end

      return textboxFunctions
    end

    function tab.Keybind(self, keybindOptions)
      assert(keybindOptions.Name, "Missing argument 'Name' from keybindOptions")
      assert(keybindOptions.Default, "Missing argument 'Default' from keybindOptions")
      local default = (type(keybindOptions.Default) == "string" and Enum.KeyCode[keybindOptions.Default] or keybindOptions.Default)
      local banned = {
        Return = true;
        Space = true;
        Tab = true;
        Backquote = true;
        CapsLock = true;
        Escape = true;
        Unknown = true;
      }
      local shortNames = {
        RightControl = 'Right Ctrl',
        LeftControl = 'Left Ctrl',
        LeftShift = 'Left Shift',
        RightShift = 'Right Shift',
        Semicolon = ";",
        Quote = '"',
        LeftBracket = '[',
        RightBracket = ']',
        Equals = '=',
        Minus = '-',
        RightAlt = 'Right Alt',
        LeftAlt = 'Left Alt'
      }  

      setmetatable(shortNames, { __index = function(self, index) return index end })

      local bindName = shortNames[default.Name]

      local KeybindModule = instance_new("Frame")
      local KeybindModuleCorner = instance_new("UICorner")
      local KeybindTitle = instance_new("TextLabel")
      local KeybindValueBox = instance_new("Frame")
      local KeybindValueBoxCorner = instance_new("UICorner")
      local KeybindValue = instance_new("TextButton")

      KeybindModule.Name = "KeybindModule"
      KeybindModule.Parent = Tab
      KeybindModule.BackgroundColor3 = color3_rgb(36, 38, 49)
      KeybindModule.BorderSizePixel = 0
      KeybindModule.Position = udim2_new(0.0143112699, 0, 0, 0)
      KeybindModule.Size = udim2_new(1, -16, 0, 38)
      
      KeybindModuleCorner.CornerRadius = UDim.new(0, 4)
      KeybindModuleCorner.Name = "KeybindModuleCorner"
      KeybindModuleCorner.Parent = KeybindModule
      
      KeybindTitle.Name = "KeybindTitle"
      KeybindTitle.Parent = KeybindModule
      KeybindTitle.BackgroundColor3 = color3_rgb(255, 255, 255)
      KeybindTitle.BackgroundTransparency = 1.000
      KeybindTitle.Position = udim2_new(0.0210000277, 0, 0, 0)
      KeybindTitle.Size = udim2_new(0, 81, 1, 0)
      KeybindTitle.ZIndex = 800
      KeybindTitle.Font = Enum.Font.GothamMedium
      KeybindTitle.Text = keybindOptions.Name
      KeybindTitle.TextColor3 = color3_rgb(235, 235, 235)
      KeybindTitle.TextSize = 16.000
      KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left
      
      KeybindValueBox.Name = "KeybindValueBox"
      KeybindValueBox.Parent = KeybindModule
      KeybindValueBox.AnchorPoint = Vector2.new(0, 0.5)
      KeybindValueBox.BackgroundColor3 = color3_rgb(43, 46, 59)
      KeybindValueBox.Position = udim2_new(0.801434517, 0, 0.5, 0)
      KeybindValueBox.Size = udim2_new(0.0515653789, 72, 1, -16)
      
      KeybindValueBoxCorner.CornerRadius = UDim.new(0, 4)
      KeybindValueBoxCorner.Name = "KeybindValueBoxCorner"
      KeybindValueBoxCorner.Parent = KeybindValueBox
      
      KeybindValue.Name = "KeybindValue"
      KeybindValue.Parent = KeybindValueBox
      KeybindValue.BackgroundColor3 = color3_rgb(255, 255, 255)
      KeybindValue.BackgroundTransparency = 1.000
      KeybindValue.BorderSizePixel = 0
      KeybindValue.Size = udim2_new(1, 0, 1, 0)
      KeybindValue.Font = Enum.Font.Gotham
      KeybindValue.Text = bindName
      KeybindValue.TextColor3 = color3_rgb(255, 255, 255)
      KeybindValue.TextSize = 14.000  
      
      table.insert(library.connections, library:BindOnClick(KeybindValue, function(inputType)
        if inputType == Enum.UserInputType.MouseButton1 then
          KeybindValue.Text = "..."
          task.wait()
          local key = game:GetService("UserInputService").InputEnded:Wait()
          if key.UserInputType ~= Enum.UserInputType.Keyboard then
            KeybindValue.Text = bindName
            return
          end
          local keyName = key.KeyCode.Name
          if banned[keyName] then
            KeybindValue.Text = bindName
            return
          end
          bindName = shortNames[keyName]
          KeybindValue.Text = bindName
        end
      end))

      table.insert(library.connections, game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if shortNames[input.KeyCode.Name] ~= bindName then return end
        keybindOptions.Callback(input.KeyCode.Name)
      end))
    end

    function tab.Slider(self, sliderOptions)
      assert(sliderOptions.Name, "Missing argument 'Name' from sliderOptions")
      assert(sliderOptions.Min, "Missing argument 'Min' from sliderOptions")
      assert(sliderOptions.Max, "Missing argument 'Max' from sliderOptions")
      local SliderModule = instance_new("Frame")
      local SliderModuleCorner = instance_new("UICorner")
      local SliderTitle = instance_new("TextLabel")
      local SliderBack = instance_new("Frame")
      local SliderBackCorner = instance_new("UICorner")
      local SliderValue = instance_new("TextBox")
      local SliderPosition = instance_new("Frame")
      local SliderPositionCorner = instance_new("UICorner")
      
      local sliderFunctions = {}
      function sliderFunctions.SetValue(self, value)
        local useTween = (value ~= nil)
        local percent = (mouse.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
        if value then
          percent = (value - sliderOptions.Min) / (sliderOptions.Max - sliderOptions.Min)
        end
        percent = math.clamp(percent, 0, 1)
        local valueEquation = sliderOptions.Min + (sliderOptions.Max - sliderOptions.Min) * percent
        if sliderOptions.Precise then
          value = value or tonumber(string.format("%.1f", tostring(valueEquation)))
        else
          value = value or math.floor(valueEquation)
        end
        SliderValue.Text = tostring(value)
        if useTween then
          library:Tween(SliderPosition, 0.25, {
            Size = udim2_new(percent, 0, 1, 0)
          })  
        else
          SliderPosition.Size = udim2_new(percent, 0, 1, 0)
        end
        
        if sliderOptions.Callback then
          sliderOptions.Callback(value)
        end
      end

      SliderModule.Name = "SliderModule"
      SliderModule.Parent = Tab
      SliderModule.BackgroundColor3 = color3_rgb(36, 38, 49)
      SliderModule.BorderSizePixel = 0
      SliderModule.Position = udim2_new(0.0339892656, 0, -0.0097402595, 0)
      SliderModule.Size = udim2_new(1, -16, 0, 38)
      
      SliderModuleCorner.CornerRadius = UDim.new(0, 4)
      SliderModuleCorner.Name = "SliderModuleCorner"
      SliderModuleCorner.Parent = SliderModule
      
      SliderTitle.Name = "SliderTitle"
      SliderTitle.Parent = SliderModule
      SliderTitle.BackgroundColor3 = color3_rgb(255, 255, 255)
      SliderTitle.BackgroundTransparency = 1.000
      SliderTitle.Position = udim2_new(0.0210000277, 0, 0, 0)
      SliderTitle.Size = udim2_new(0, 81, 1, 0)
      SliderTitle.ZIndex = 800
      SliderTitle.Font = Enum.Font.GothamMedium
      SliderTitle.Text = sliderOptions.Name
      SliderTitle.TextColor3 = color3_rgb(235, 235, 235)
      SliderTitle.TextSize = 16.000
      SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
      
      SliderBack.Name = "SliderBack"
      SliderBack.Parent = SliderModule
      SliderBack.BackgroundColor3 = color3_rgb(43, 46, 59)
      SliderBack.BorderSizePixel = 0
      SliderBack.Position = udim2_new(0.589318573, 0, 0.210526317, 0)
      SliderBack.Size = udim2_new(0, 215, 0, 22)
      
      SliderBackCorner.CornerRadius = UDim.new(0, 4)
      SliderBackCorner.Name = "SliderBackCorner"
      SliderBackCorner.Parent = SliderBack
      
      SliderValue.Name = "SliderValue"
      SliderValue.Parent = SliderBack
      SliderValue.AnchorPoint = Vector2.new(0.5, 0)
      SliderValue.BackgroundColor3 = color3_rgb(255, 255, 255)
      SliderValue.BackgroundTransparency = 1.000
      SliderValue.BorderSizePixel = 0
      SliderValue.Position = udim2_new(0.5, 0, 0, 0)
      SliderValue.Size = udim2_new(0.148837209, 0, 1, 0)
      SliderValue.ZIndex = 2
      SliderValue.Font = Enum.Font.Gotham
      SliderValue.Text = ""
      SliderValue.TextColor3 = color3_rgb(255, 255, 255)
      SliderValue.TextSize = 14.000
      
      SliderPosition.Name = "SliderPosition"
      SliderPosition.Parent = SliderBack
      SliderPosition.BackgroundColor3 = color3_rgb(65, 69, 89)
      SliderPosition.BorderSizePixel = 0
      SliderPosition.Size = udim2_new(0, 0, 1, 0)
      
      SliderPositionCorner.CornerRadius = UDim.new(0, 4)
      SliderPositionCorner.Name = "SliderPositionCorner"
      SliderPositionCorner.Parent = SliderPosition      

      sliderFunctions:SetValue(sliderOptions.Default or sliderOptions.Min)

      local dragging, boxFocused, allowed = false, false, {
        [""] = true,
        ["-"] = true
      }

      table.insert(library.connections, SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
          sliderFunctions:SetValue()
          dragging = true
        end
      end))

      table.insert(library.connections, game:GetService("UserInputService").InputEnded:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
          dragging = false
        end
      end))

      table.insert(library.connections, game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
          sliderFunctions:SetValue()
        end
      end))

      table.insert(library.connections, SliderValue.Focused:Connect(function()
        boxFocused = true
      end))

      table.insert(library.connections, SliderValue.FocusLost:Connect(function ()
        boxFocused = false
        if SliderValue.Text == "" then
          library.flags[flag]:SetValue(sliderOptions.Default or sliderOptions.Min)
        end
      end))
      
      table.insert(library.connections, SliderValue:GetPropertyChangedSignal("Text"):Connect(function()
        if not boxFocused then return end
        SliderValue.Text = SliderValue.Text:gsub("%D+", "")
        
        local text = SliderValue.Text
        
        if not tonumber(text) then
          SliderValue.Text = SliderValue.Text:gsub('%D+', '')
        elseif not allowed[text] then
          if tonumber(text) > sliderOptions.Max then
            text = sliderOptions.Max
            SliderValue.Text = tostring(sliderOptions.Max)
          end
          sliderFunctions:SetValue(tonumber(text))
        end
      end))
      
      return sliderFunctions
    end

    function tab.Dropdown(self, dropdownOptions)
      assert(dropdownOptions.Name, "Missing argument 'Name' from dropdownOptions")
      assert(dropdownOptions.Options, "Missing argument 'Options' from dropdownOptions")

      local DropdownModule = instance_new("Frame")
      local DropdownModuleCorner = instance_new("UICorner")
      local DropdownTitle = instance_new("TextLabel")
      local DropdownObjHolder = instance_new("Frame")
      local DropdownObjHolderListLayout = instance_new("UIListLayout")
      local SelectedOptionBox = instance_new("Frame")
      local SelectedOptionBoxCorner = instance_new("UICorner")
      local SelectedOption = instance_new("TextBox")
      local DropdownToggle = instance_new("TextButton")
      local DropdownBottom = instance_new("Frame")
      local DropdownBottomCorner = instance_new("UICorner")
      local DropdownOptions = instance_new("ScrollingFrame")
      local DropdownOptionsListLayout = instance_new("UIListLayout")

      local DropdownOptionsPadding = instance_new("UIPadding")

      DropdownModule.Name = "DropdownModule"
      DropdownModule.Parent = Tab
      DropdownModule.BackgroundColor3 = color3_rgb(36, 38, 49)
      DropdownModule.BorderSizePixel = 0
      DropdownModule.Position = udim2_new(0.0143112699, 0, 0, 0)
      DropdownModule.Size = udim2_new(1, -16, 0, 38)
      
      DropdownModuleCorner.CornerRadius = UDim.new(0, 4)
      DropdownModuleCorner.Name = "DropdownModuleCorner"
      DropdownModuleCorner.Parent = DropdownModule
      
      DropdownTitle.Name = "DropdownTitle"
      DropdownTitle.Parent = DropdownModule
      DropdownTitle.BackgroundColor3 = color3_rgb(255, 255, 255)
      DropdownTitle.BackgroundTransparency = 1.000
      DropdownTitle.Position = udim2_new(0.0210000277, 0, 0, 0)
      DropdownTitle.Size = udim2_new(0, 81, 1, 0)
      DropdownTitle.ZIndex = 800
      DropdownTitle.Font = Enum.Font.GothamMedium
      DropdownTitle.Text = dropdownOptions.Name
      DropdownTitle.TextColor3 = color3_rgb(235, 235, 235)
      DropdownTitle.TextSize = 16.000
      DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
      
      DropdownObjHolder.Name = "DropdownObjHolder"
      DropdownObjHolder.Parent = DropdownModule
      DropdownObjHolder.BackgroundColor3 = color3_rgb(255, 255, 255)
      DropdownObjHolder.BackgroundTransparency = 1.000
      DropdownObjHolder.BorderSizePixel = 0
      DropdownObjHolder.Position = udim2_new(0.81583792, 0, 0, 0)
      DropdownObjHolder.Size = udim2_new(0, 92, 0, 38)
      
      DropdownObjHolderListLayout.Name = "DropdownObjHolderListLayout"
      DropdownObjHolderListLayout.Parent = DropdownObjHolder
      DropdownObjHolderListLayout.FillDirection = Enum.FillDirection.Horizontal
      DropdownObjHolderListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
      DropdownObjHolderListLayout.SortOrder = Enum.SortOrder.LayoutOrder
      DropdownObjHolderListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
      DropdownObjHolderListLayout.Padding = UDim.new(0, 8)
      
      SelectedOptionBox.Name = "SelectedOptionBox"
      SelectedOptionBox.Parent = DropdownObjHolder
      SelectedOptionBox.AnchorPoint = Vector2.new(0, 0.5)
      SelectedOptionBox.BackgroundColor3 = color3_rgb(43, 46, 59)
      SelectedOptionBox.Position = udim2_new(0.801434517, 0, 0.5, 0)
      SelectedOptionBox.Size = udim2_new(0, 200, 1, -16)
      
      SelectedOptionBoxCorner.CornerRadius = UDim.new(0, 4)
      SelectedOptionBoxCorner.Name = "SelectedOptionBoxCorner"
      SelectedOptionBoxCorner.Parent = SelectedOptionBox
      
      SelectedOption.Name = "SelectedOption"
      SelectedOption.Parent = SelectedOptionBox
      SelectedOption.BackgroundColor3 = color3_rgb(255, 255, 255)
      SelectedOption.BackgroundTransparency = 1.000
      SelectedOption.BorderSizePixel = 0
      SelectedOption.Size = udim2_new(1, 0, 1, 0)
      SelectedOption.Font = Enum.Font.Gotham
      SelectedOption.Text = "Select Options"
      SelectedOption.TextColor3 = color3_rgb(255, 255, 255)
      SelectedOption.TextSize = 14.000
      
      DropdownToggle.Name = "DropdownToggle"
      DropdownToggle.Parent = DropdownObjHolder
      DropdownToggle.BackgroundColor3 = color3_rgb(255, 255, 255)
      DropdownToggle.BackgroundTransparency = 1.000
      DropdownToggle.Size = udim2_new(0, 22, 0, 22)
      DropdownToggle.Font = Enum.Font.Gotham
      DropdownToggle.Text = "+"
      DropdownToggle.TextColor3 = color3_rgb(255, 255, 255)
      DropdownToggle.TextSize = 24.000
      
      DropdownBottom.Name = "DropdownBottom"
      DropdownBottom.Parent = Tab
      DropdownBottom.BackgroundColor3 = color3_rgb(36, 38, 49)
      DropdownBottom.BorderSizePixel = 0
      DropdownBottom.Position = udim2_new(0.0143112699, 0, 0.230263159, 0)
      DropdownBottom.Size = udim2_new(1, -16, 0, 0)
      DropdownBottom.Visible = false
      
      DropdownBottomCorner.CornerRadius = UDim.new(0, 4)
      DropdownBottomCorner.Name = "DropdownBottomCorner"
      DropdownBottomCorner.Parent = DropdownBottom
      
      DropdownOptions.Name = "DropdownOptions"
      DropdownOptions.Parent = DropdownBottom
      DropdownOptions.Active = true
      DropdownOptions.BackgroundColor3 = color3_rgb(255, 255, 255)
      DropdownOptions.BackgroundTransparency = 1.000
      DropdownOptions.Size = udim2_new(1, 0, 1, 0)
      DropdownOptions.ScrollBarThickness = 2
      
      DropdownOptionsListLayout.Name = "DropdownOptionsListLayout"
      DropdownOptionsListLayout.Parent = DropdownOptions
      DropdownOptionsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
      DropdownOptionsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
      DropdownOptionsListLayout.Padding = UDim.new(0, 8)
            
      DropdownOptionsPadding.Name = "DropdownOptionsPadding"
      DropdownOptionsPadding.Parent = DropdownOptions
      DropdownOptionsPadding.PaddingTop = UDim.new(0, 8)

      local dropdownOpen = false

      local setAllVisible = function()
        local options = DropdownOptions:GetChildren() 
        for i=1, #options do
          local option = options[i]
          if option:IsA("Frame") then
            option.Visible = true
          end
        end
      end
  
      local searchDropdown = function(text)
        local options = DropdownOptions:GetChildren()
        for i=1, #options do
          local option = options[i]
          if text == "" then
            setAllVisible()
          else
            if option:IsA("Frame") then
              if option.Name:lower():match(text:lower()) then
                option.Visible = true
              else
                option.Visible = false
              end
            end
          end
        end
      end

      local function resize()
        local sizeToUse = ((#DropdownOptions:GetChildren() - 2) * (38 + 8)) + 8
        library:Tween(DropdownBottom, 0.2, {
          Size = udim2_new(1, -16, 0, math.clamp(sizeToUse, 0, 238))
        })
        DropdownOptions.CanvasSize = udim2_new(0, 0, 0, sizeToUse)       
      end

      DropdownOptionsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if not dropdownOpen then return end
        resize()
      end)

      local toggleDropdown = function()
        dropdownOpen = not dropdownOpen
        DropdownToggle.Text = (dropdownOpen and "-" or "+")
        if dropdownOpen then
          DropdownBottom.Visible = true
          resize()
          setAllVisible()
        else
          library:Tween(DropdownBottom, 0.2, {
            Size = udim2_new(1, -16, 0, 0)
          })
          task.delay(0.21, function()
            DropdownBottom.Visible = false
          end)
        end
      end

      table.insert(library.connections, library:BindOnClick(DropdownToggle, function(inputType)
        if inputType == Enum.UserInputType.MouseButton1 then
          toggleDropdown()
        end
      end))

      table.insert(library.connections, SelectedOption.Focused:Connect(function()
        if not dropdownOpen then toggleDropdown() end
      end))

      SelectedOption:GetPropertyChangedSignal("Text"):Connect(function()
        searchDropdown(SelectedOption.Text)
      end)      

      local dropdownFunctions = {}
      function dropdownFunctions.AddOption(self, optionName)
        local DropdownOption = instance_new("Frame")
        local DropdownOptionCorner = instance_new("UICorner")
        local DropdownOptionText = instance_new("TextLabel")
  
        DropdownOption.Name = tostring(optionName)
        DropdownOption.Parent = DropdownOptions
        DropdownOption.BackgroundColor3 = color3_rgb(43, 46, 59)
        DropdownOption.BorderSizePixel = 0
        DropdownOption.Position = udim2_new(0.0143112699, 0, 0, 0)
        DropdownOption.Size = udim2_new(1, -16, 0, 38)
        
        DropdownOptionCorner.CornerRadius = UDim.new(0, 4)
        DropdownOptionCorner.Name = "DropdownOptionCorner"
        DropdownOptionCorner.Parent = DropdownOption
        
        DropdownOptionText.Name = "DropdownOptionText"
        DropdownOptionText.Parent = DropdownOption
        DropdownOptionText.BackgroundColor3 = color3_rgb(255, 255, 255)
        DropdownOptionText.BackgroundTransparency = 1.000
        DropdownOptionText.Size = udim2_new(1, 0, 1, 0)
        DropdownOptionText.ZIndex = 800
        DropdownOptionText.Font = Enum.Font.GothamMedium
        DropdownOptionText.Text = tostring(optionName)
        DropdownOptionText.TextColor3 = color3_rgb(235, 235, 235)
        DropdownOptionText.TextSize = 16.000

        table.insert(library.connections, library:BindOnClick(DropdownOption, function(inputType)
          if inputType == Enum.UserInputType.MouseButton1 then
            toggleDropdown()
            SelectedOption.Text = tostring(optionName)
            dropdownOptions.Callback(optionName)
          end
        end))
      end

      function dropdownFunctions.ClearOptions(self)
        for _, v in next, DropdownOptions:GetChildren() do
          if v:IsA("Frame") then
            v:Destroy()
          end
        end
      end

      function dropdownFunctions.SetOptions(self, options)
        self:ClearOptions()
        for _, v in next, options do
          self:AddOption(v)
        end
      end

      dropdownFunctions:SetOptions(dropdownOptions.Options)
      
      return dropdownFunctions
    end

    function tab.Label(self, Name)
      assert(Name, "Missing argument 'Name' from labelOptions")
      local Label = instance_new("TextLabel")
      Label.Name = "Label"
      Label.Parent = Tab
      Label.BackgroundColor3 = color3_rgb(255, 255, 255)
      Label.BackgroundTransparency = 1.000
      Label.Position = udim2_new(0.0187835414, 0, 0.381769896, 9)
      Label.Size = udim2_new(0, 538, 0, 17)
      Label.ZIndex = 800
      Label.Font = Enum.Font.GothamMedium
      Label.TextColor3 = color3_rgb(235, 235, 235)
      Label.TextSize = 16.000
      Label.TextXAlignment = Enum.TextXAlignment.Left
      Label.Text = " " ..Name

        return Label
    end
    return tab
  end
  return window
end
return library

--[[
local UI = library:CreateWindow("Silent | 🌳")

local Tab = UI:CreateTab({
    Name    = "Tab",
    IconURL = "",
})

Tab:Button({
    Name     = "Button",
    Callback = function()

    end,
})

Tab:Toggle({
    Name     = "Toggle",
    State    = false,
    Callback = function()

    end,
})

Tab:Textbox({
    Name     = "Text Box",
    Default  = "Text Here",
    Callback = function()

    end,
})

Tab:Keybind({
    Name     = "Key Bind",
    Default  = "F",
    Callback = function()

    end,
})

Tab:Slider({
    Name     = "Slider",
    Default  = 30,
    Min      = 1,
    Max      = 100,
    Callback = function()

    end,
})

Tab:Dropdown({
    Name = "Dropdown",
    Options = game.Players:GetPlayers(),
    Callback = function(Player)
    print(Player)
    end,
})
    ]]

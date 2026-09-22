local Library = {}
Library.Destroyed = false
Library.Connections = {}
Library.Tabs = {}
Library.CurrentTab = nil
Library.CurrentColorPicker = nil
Library.CurrentNoti = nil
local Mouse = game:GetService"Players".LocalPlayer:GetMouse()

---~Funcs~---

local IsSwitchingTab
function SwitchTab(Tab, Holder)
	if IsSwitchingTab then
		return
	end
	
	if Library.CurrentTab and Library.CurrentTab[1] == Tab then
		return
	end
	
	if not Library.CurrentTab then
		Library.CurrentTab = {Tab, Holder}
		Tab.Title.TextTransparency = 0
		Tab.Icon.ImageTransparency = 0
		Holder.Visible = true
		return
	end
	
	IsSwitchingTab = true
	Library.CurrentTab[2].Visible = false
	Tween(Tab.Icon, .2, {ImageTransparency = 0})
	Tween(Tab.Title, .2, {TextTransparency = 0})
	Tween(Library.CurrentTab[1].Icon, .2, {ImageTransparency = 0.65})
	Tween(Library.CurrentTab[1].Title, .2, {TextTransparency = 0.65})
	Holder.Visible = true
	task.wait(.2)
	Library.CurrentTab = {Tab, Holder}
	IsSwitchingTab = false
end

function Drag(frame, hold)
	if not hold then
		hold = frame
	end
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	hold.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
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

function Pop(obj)
	local OldSize = obj.Size
	
	obj.Size = obj.Size - UDim2.new(0, 10, 0, 10)
	
	obj.TextSize = 0
	
	Tween(obj, .2, {Size = OldSize})
	
	Tween(obj, .2, {TextSize = 15})
	
	task.wait(.2)
	
	Tween(obj, .2, {TextSize = 13})
	
end

function Tween(Obj, Duration, Props, ...)
	game:GetService"TweenService":Create(Obj, TweenInfo.new(Duration, ...), Props):Play()
end

---~Library_Source~---

function Library:Create(title)
	assert(title, "A title is required")
	
	local themes = {
		Background = Color3.fromRGB(24, 24, 24),
		Accent = Color3.fromRGB(10, 10, 10),
		LightContrast = Color3.fromRGB(20, 20, 20), 
		DarkContrast = Color3.fromRGB(14, 14, 14),
		TextColor = Color3.fromRGB(255, 255, 255),
		Glow = Color3.fromRGB(0, 0, 0)
	}
		
	if game:GetService"Players".LocalPlayer.PlayerGui:FindFirstChild"Aurora" then
		game:GetService"Players".LocalPlayer.PlayerGui:FindFirstChild"Aurora":Destroy()
	elseif game:GetService"CoreGui":FindFirstChild"Aurora" then
		game:GetService"CoreGui":FindFirstChild"Aurora":Destroy()
	end
	
	local Aurora = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local MainC = Instance.new("UICorner")
	local Top = Instance.new("Frame")
	local TopC = Instance.new("UICorner")
	local Title = Instance.new("TextLabel")
	local TopBar = Instance.new("Frame")
	local Side = Instance.new("Frame")
	local SideC = Instance.new("UICorner")
	local SideBar = Instance.new("Frame")
	local Glow = Instance.new("ImageLabel")
	local TabHolder = Instance.new("ScrollingFrame")
	local TabHolderLL = Instance.new("UIListLayout")

	Aurora.Name = "Aurora"
	Aurora.Parent = game:GetService"RunService" and game:GetService"Players".LocalPlayer:WaitForChild"PlayerGui" or game:WaitForChild"CoreGui"
	Aurora.ResetOnSpawn = false

	Main.Name = "Main"
	Main.Parent = Aurora
	Main.BackgroundColor3 = themes.Background
	Main.BorderSizePixel = 0
	Main.Position = UDim2.new(0.352971852, 0, 0.3160173, 0)
	Main.Size = UDim2.new(0, 564, 0, 340)
	Main.ClipsDescendants = false

	MainC.CornerRadius = UDim.new(0, 5)
	MainC.Name = "MainC"
	MainC.Parent = Main

	Top.Name = "Top"
	Top.Parent = Main
	Top.BackgroundColor3 = themes.Accent
	Top.BorderSizePixel = 0
	Top.Position = UDim2.new(0.000134948292, 0, -0.00162963872, 0)
	Top.Size = UDim2.new(0, 563, 0, 30)
	Top.ZIndex = 3

	TopC.CornerRadius = UDim.new(0, 5)
	TopC.Name = "TopC"
	TopC.Parent = Top

	Title.Name = "Title"
	Title.Parent = Top
	Title.BackgroundColor3 = themes.TextColor
	Title.BackgroundTransparency = 1.000
	Title.BorderSizePixel = 0
	Title.Position = UDim2.new(1.08410582e-07, 0, 0.0333333351, 0)
	Title.Size = UDim2.new(0, 553, 0, 27)
	Title.ZIndex = 3
	Title.Font = Enum.Font.GothamBold
	Title.Text = string.format("  %s", title)
	Title.TextColor3 = themes.TextColor
	Title.TextSize = 15.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	TopBar.Name = "TopBar"
	TopBar.Parent = Main
	TopBar.BackgroundColor3 = themes.Accent
	TopBar.BorderSizePixel = 0
	TopBar.Position = UDim2.new(0.001907998, 0, 0.0513115376, 0)
	TopBar.Size = UDim2.new(0, 562, 0, 12)
	TopBar.ZIndex = 2

	Side.Name = "Side"
	Side.Parent = Main
	Side.BackgroundColor3 = themes.DarkContrast
	Side.BorderSizePixel = 0
	Side.Position = UDim2.new(0.001907998, 0, 0.00311943493, 0)
	Side.Size = UDim2.new(0, 130, 0, 338)

	SideC.CornerRadius = UDim.new(0, 5)
	SideC.Name = "SideC"
	SideC.Parent = Side

	SideBar.Name = "SideBar"
	SideBar.Parent = Main
	SideBar.BackgroundColor3 = themes.DarkContrast
	SideBar.BorderSizePixel = 0
	SideBar.Position = UDim2.new(0.211127862, 0, 0.00311943493, 0)
	SideBar.Size = UDim2.new(0, 12, 0, 338)

	Glow.Name = "Glow"
	Glow.Parent = Main
	Glow.AnchorPoint = Vector2.new(0.5, 0.5)
	Glow.BackgroundTransparency = 1.000
	Glow.BorderSizePixel = 0
	Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
	Glow.Size = UDim2.new(1, 47, 1, 47)
	Glow.ZIndex = 0
	Glow.Image = "rbxassetid://6014261993"
	Glow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Glow.ImageTransparency = 0.500
	Glow.ScaleType = Enum.ScaleType.Slice
	Glow.SliceCenter = Rect.new(49, 49, 450, 450)
	
	TabHolder.Name = "TabHolder"
	TabHolder.Parent = Side
	TabHolder.Active = true
	TabHolder.BackgroundColor3 = themes.TextColor
	TabHolder.BackgroundTransparency = 1.000
	TabHolder.BorderSizePixel = 0
	TabHolder.Position = UDim2.new(0.0384615399, 0, 0.115384616, 0)
	TabHolder.Size = UDim2.new(0, 119, 0, 294)
	TabHolder.ZIndex = 2
	TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabHolder.ScrollBarThickness = 1

	TabHolderLL.Name = "TabHolderLL"
	TabHolderLL.Parent = TabHolder
	TabHolderLL.SortOrder = Enum.SortOrder.LayoutOrder
	TabHolderLL.Padding = UDim.new(0, 10)
	
	function Library:Notify(title, message, options, callback)
		local callback = callback or function() end
		local options = options or false
		assert(title, "A title is required")
		assert(message, "A message is required")
		
		local Notify = Instance.new("Frame")
		local NotifyC = Instance.new("UICorner")
		local Glow = Instance.new("ImageLabel")
		local Text = Instance.new("TextLabel")
		local Title = Instance.new("TextLabel")
		local Accept = Instance.new("ImageButton")
		local Decline = Instance.new("ImageButton")
		local Flash = Instance.new("Frame")
		local FlashC = Instance.new("UICorner")

		Notify.Name = "Notify"
		Notify.Parent = Aurora
		Notify.BackgroundColor3 = themes.Background
		Notify.BorderSizePixel = 0
		Notify.ClipsDescendants = true
		Notify.Position = Library.CurrentNoti and Library.CurrentNoti.Position or UDim2.new(0, 20, 0, 834)
		Notify.Size = UDim2.new(0, 0, 0, 60)

		NotifyC.CornerRadius = UDim.new(0, 5)
		NotifyC.Name = "NotifyC"
		NotifyC.Parent = Notify

		Glow.Name = "Glow"
		Glow.Parent = Notify
		Glow.AnchorPoint = Vector2.new(0.5, 0.5)
		Glow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Glow.BackgroundTransparency = 1.000
		Glow.BorderSizePixel = 0
		Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
		Glow.Size = UDim2.new(1, 47, 1, 47)
		Glow.ZIndex = 0
		Glow.Image = "rbxassetid://6014261993"
		Glow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		Glow.ImageTransparency = 0.500
		Glow.ScaleType = Enum.ScaleType.Slice
		Glow.SliceCenter = Rect.new(49, 49, 450, 450)

		Text.Name = "Text"
		Text.Parent = Notify
		Text.BackgroundTransparency = 1.000
		Text.Position = UDim2.new(0, 10, 1, -24)
		Text.Size = UDim2.new(1, -40, 0, 16)
		Text.ZIndex = 4
		Text.Font = Enum.Font.Gotham
		Text.Text = "Message"
		Text.TextColor3 = themes.TextColor
		Text.TextSize = 12.000
		Text.TextXAlignment = Enum.TextXAlignment.Left

		Title.Name = "Title"
		Title.Parent = Notify
		Title.BackgroundTransparency = 1.000
		Title.Position = UDim2.new(0, 10, 0, 8)
		Title.Size = UDim2.new(1, -40, 0, 16)
		Title.ZIndex = 4
		Title.Font = Enum.Font.GothamMedium
		Title.Text = "Title"
		Title.TextColor3 = themes.TextColor
		Title.TextSize = 14.000
		Title.TextXAlignment = Enum.TextXAlignment.Left
		
		if options then
			Accept.Name = "Accept"
			Accept.Parent = Notify
			Accept.BackgroundTransparency = 1.000
			Accept.Position = UDim2.new(1, -26, 0, 8)
			Accept.Size = UDim2.new(0, 16, 0, 16)
			Accept.ZIndex = 4
			Accept.Image = "rbxassetid://5012538259"

			Decline.Name = "Decline"
			Decline.Parent = Notify
			Decline.BackgroundTransparency = 1.000
			Decline.Position = UDim2.new(1, -26, 1, -24)
			Decline.Size = UDim2.new(0, 16, 0, 16)
			Decline.ZIndex = 4
			Decline.Image = "rbxassetid://5012538583"
		end
		
		Flash.Name = "Flash"
		Flash.Parent = Notify
		Flash.BackgroundColor3 = themes.TextColor
		Flash.BorderSizePixel = 0
		Flash.ClipsDescendants = true
		Flash.Position = UDim2.new(-0.008, 0,-0.014, 0)
		Flash.Size = UDim2.new(0, 0, 0, 60)
		Flash.ZIndex = 4

		FlashC.CornerRadius = UDim.new(0, 5)
		FlashC.Name = "FlashC"
		FlashC.Parent = Flash
		
		Drag(Notify)
		
		local textsize = game:GetService("TextService"):GetTextSize(Text, 12, Enum.Font.Gotham, Vector2.new(math.huge, 16))
		
		local function CloseNoti(Notify, Flash)
			Tween(Flash, .2, {Size = Notify.Size})
			task.wait(.2)
			Tween(Notify, .2, {Size = UDim2.new(0, 0,0, 60)})
			task.wait(.2)
			Notify:Destroy()
			Library.CurrentNoti = nil
		end
		
		if Library.CurrentNoti then
			CloseNoti(Library.CurrentNoti, Library.CurrentNoti.Flash)
		end
		
		Library.CurrentNoti = Notify
		
		Tween(Notify, .3, {Size = UDim2.new(0, textsize.X + 70,0, 60)})
		Tween(Flash, .3, {Size = UDim2.new(0, textsize.X + 70,0, 60)})
		task.wait(.3)
		Tween(Flash, 0.2, {Size = UDim2.new(0, 0, 0, 60)})
		
		if not options then
			task.wait(10)
			CloseNoti(Notify, Flash)
		end
	end
	
	function Library:ProgressBar(name, amount, percentage)
		local percentage = percentage or false
		local amount = amount or 100
		assert(name, "A name is required to create a progress bar")
		
		local ProgressBar = Instance.new("Frame")
		local ProgressBarC = Instance.new("UICorner")
		local Title = Instance.new("TextLabel")
		local Flash = Instance.new("Frame")
		local FlashC = Instance.new("UICorner")
		local Number = Instance.new("TextLabel")
		local Glow = Instance.new("ImageLabel")
		local Inner = Instance.new("Frame")
		local InnerC = Instance.new("UICorner")
		local Fill = Instance.new("Frame")
		local FillC = Instance.new("UICorner")

		ProgressBar.Name = "ProgressBar"
		ProgressBar.Parent = Aurora
		ProgressBar.BackgroundColor3 = themes.Background
		ProgressBar.BorderSizePixel = 0
		ProgressBar.Position = UDim2.new(0, 15, 0, 851)
		ProgressBar.Size = UDim2.new(0, 0, 0, 60)
		ProgressBar.ClipsDescendants = true

		ProgressBarC.CornerRadius = UDim.new(0, 5)
		ProgressBarC.Name = "ProgressBarC"
		ProgressBarC.Parent = ProgressBar

		Title.Name = "Title"
		Title.Parent = ProgressBar
		Title.BackgroundTransparency = 1.000
		Title.Position = UDim2.new(0, 10, 0, 8)
		Title.Size = UDim2.new(0.936842084, -40, 0, 16)
		Title.ZIndex = 4
		Title.Font = Enum.Font.GothamMedium
		Title.Text = name
		Title.TextColor3 = themes.TextColor
		Title.TextSize = 14.000
		Title.TextXAlignment = Enum.TextXAlignment.Left

		Flash.Name = "Flash"
		Flash.Parent = ProgressBar
		Flash.BackgroundColor3 = themes.TextColor
		Flash.BorderSizePixel = 0
		Flash.ClipsDescendants = true
		Flash.Position = UDim2.new(-0.008, 0,-0.014, 0)
		Flash.Size = UDim2.new(0, 0, 0, 60)
		Flash.ZIndex = 5

		FlashC.CornerRadius = UDim.new(0, 5)
		FlashC.Name = "FlashC"
		FlashC.Parent = Flash

		Number.Name = "Number"
		Number.Parent = ProgressBar
		Number.BackgroundTransparency = 1.000
		Number.Position = UDim2.new(0, 156, 0, 8)
		Number.Size = UDim2.new(0.300000012, -40, 0, 16)
		Number.ZIndex = 4
		Number.Font = Enum.Font.GothamMedium
		Number.Text = percentage and "0%" or string.format("0/%s", tostring(amount))
		Number.TextColor3 = themes.TextColor
		Number.TextSize = 14.000
		Number.TextXAlignment = Enum.TextXAlignment.Right

		Glow.Name = "Glow"
		Glow.Parent = ProgressBar
		Glow.AnchorPoint = Vector2.new(0.5, 0.5)
		Glow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Glow.BackgroundTransparency = 1.000
		Glow.BorderSizePixel = 0
		Glow.Position = UDim2.new(0.5, 0, 0.483333319, 0)
		Glow.Size = UDim2.new(1, 47, 1.0333333, 47)
		Glow.ZIndex = 0
		Glow.Image = "rbxassetid://6014261993"
		Glow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		Glow.ImageTransparency = 0.500
		Glow.ScaleType = Enum.ScaleType.Slice
		Glow.SliceCenter = Rect.new(49, 49, 450, 450)

		Inner.Name = "Inner"
		Inner.Parent = ProgressBar
		Inner.BackgroundColor3 = themes.LightContrast
		Inner.Position = UDim2.new(0.0526314974, 0, 0.683333337, 0)
		Inner.Size = UDim2.new(0, 164, 0, 4)
		Inner.BorderSizePixel = 0

		InnerC.CornerRadius = UDim.new(0, 10)
		InnerC.Name = "InnerC"
		InnerC.Parent = Inner

		Fill.Name = "Fill"
		Fill.Parent = Inner
		Fill.BackgroundColor3 = themes.TextColor
		Fill.Position = UDim2.new(-0.00834411383, 0, -0.0666666627, 0)
		Fill.Size = UDim2.new(0, 0, 0, 4)
		Fill.BorderSizePixel = 0

		FillC.CornerRadius = UDim.new(0, 10)
		FillC.Name = "FillC"
		FillC.Parent = Fill
		
		local funcs = {}
		
		local function Animate(Value)
			if Value then
				Tween(ProgressBar, .3, {Size = UDim2.new(0, 190,0, 60)})
				Tween(Flash, .3, {Size = UDim2.new(0, 190, 0, 60)})
				task.wait(.3)
				Tween(Flash, 0.2, {Size = UDim2.new(0, 0, 0, 60)})
			else
				Tween(Flash, 0.2, {Size = UDim2.new(0, 190, 0, 60)})
				task.wait(.2)
				Tween(ProgressBar, .3, {Size = UDim2.new(0, 0, 0, 60)})
				task.wait(.2)
				ProgressBar:Destroy()
			end
		end
		
		Number:GetPropertyChangedSignal("Text"):Connect(function()
			if Number.Text == "100%" or Number.Text == string.format("%s/%s", tostring(amount), tostring(amount)) then
				Animate(false)
			end
		end)
		
		funcs.UpdateProgress = function(self, Value)
			local NewValue = percentage and tonumber(string.split(Number.Text, "%")[1]) + 1 or string.split(Number.Text, "/")[1] + 1
			
			local Percent = NewValue/amount
			
			local Dec = math.floor(Percent * 100)
			
			Percent = math.clamp(Percent, 0, 1)
			
			Fill:TweenSize(UDim2.new(Percent, 0, 0, 4),"Out","Sine", .1, false)
			
			Tween(Fill, .2, {Size = UDim2.new(Percent, 0, 0, 4)})
			
			Number.Text = percentage and  Dec..'%' or string.format("%s/%s", tostring(NewValue), tostring(amount))
		end
		
		funcs.RemoveProgressBar = function()
			Animate(false)
		end
		
		Animate(true)
		
		Drag(ProgressBar)
		
		return funcs
	end
	
	function Library:DestroyUI()
		if Library.Destroyed then
			return 
		end
		Aurora:Destroy()
	end
	
	function Library:ToggleUI()
		Aurora.Enabled = not Aurora.Enabled
	end
	
	Drag(Main, Top)
	
	TabHolderLL:GetPropertyChangedSignal"AbsoluteContentSize":Connect(function()
		TabHolder.CanvasSize = UDim2.new(0, 0, 0, TabHolderLL.AbsoluteContentSize.Y + 12)
	end)
	
	local Tabs = {}
	
	function Tabs:CreateTab(title, icon)
		assert(title, "A title is required to create a tab")
		assert(icon, "An icon is required to create a tab")
		
		local Tab = Instance.new("TextButton")
		local Title = Instance.new("TextLabel")
		local Icon = Instance.new("ImageLabel")
		local Holder = Instance.new("ScrollingFrame")
		local HolderLL = Instance.new("UIListLayout")

		Tab.Name = "Tab"
		Tab.Parent = TabHolder
		Tab.BackgroundTransparency = 1.000
		Tab.BorderSizePixel = 0
		Tab.Size = UDim2.new(1, 0, 0, 26)
		Tab.ZIndex = 3
		Tab.AutoButtonColor = false
		Tab.Font = Enum.Font.Gotham
		Tab.Text = ""
		Tab.TextSize = 14.000

		Title.Name = "Title"
		Title.Parent = Tab
		Title.AnchorPoint = Vector2.new(0, 0.5)
		Title.BackgroundTransparency = 1.000
		Title.Position = UDim2.new(-0.145299152, 40, 0.5, 0)
		Title.Size = UDim2.new(0.145299152, 76, 1, 0)
		Title.ZIndex = 3
		Title.Font = Enum.Font.Gotham
		Title.Text = title
		Title.TextColor3 = themes.TextColor
		Title.TextSize = 12.000
		Title.TextTransparency = 0.650
		Title.TextXAlignment = Enum.TextXAlignment.Left

		Icon.Name = "Icon"
		Icon.Parent = Tab
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundTransparency = 1.000
		Icon.Position = UDim2.new(-0.102564111, 12, 0.5, 0)
		Icon.Size = UDim2.new(0, 17, 0, 17)
		Icon.ZIndex = 3
		Icon.Image = string.format("rbxassetid://%s", icon)
		Icon.ImageTransparency = 0.650
		Icon.ScaleType = Enum.ScaleType.Fit
		Icon.ImageColor3 = themes.TextColor

		Holder.Name = string.format("Holder_%s", title)
		Holder.Parent = Main
		Holder.Active = true
		Holder.BackgroundColor3 = themes.Background
		Holder.BorderSizePixel = 0
		Holder.Position = UDim2.new(0.248226956, 0, 0.120588236, 0)
		Holder.Size = UDim2.new(0, 416, 0, 291)
		Holder.ScrollBarThickness = 1
		Holder.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
		Holder.Visible = false

		HolderLL.Name = "HolderLL"
		HolderLL.Parent = Holder
		HolderLL.SortOrder = Enum.SortOrder.LayoutOrder
		HolderLL.Padding = UDim.new(0, 10)
		
		HolderLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Holder.CanvasSize = UDim2.new(0, 0, 0, HolderLL.AbsoluteContentSize.Y + 1)
		end)
		
		function Library:SelectPage(Page)
			if title == Page then
				SwitchTab(Tab, Holder)
			end
		end
		
		if not Library.CurrentTab then
			SwitchTab(Tab, Holder)
		end
		
		Tab.MouseButton1Click:Connect(function()
			SwitchTab(Tab, Holder)
		end)
		
		local Sections = {}
		
		function Sections:Section(title)
			assert(title, "A title is required to create a section")
			
			local Section = Instance.new("Frame")
			local SectionC = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local SectionLL = Instance.new("UIListLayout")
			local SectionP = Instance.new("UIPadding")

			Section.Name = string.format("Section_%s", title)
			Section.Parent = Holder
			Section.BackgroundColor3 = themes.LightContrast
			Section.BorderSizePixel = 0
			Section.Size = UDim2.new(0, 409, 0, 119)

			SectionC.CornerRadius = UDim.new(0, 4)
			SectionC.Name = "SectionC"
			SectionC.Parent = Section

			Title.Name = "Title"
			Title.Parent = Section
			Title.BackgroundTransparency = 1.000
			Title.BorderSizePixel = 0
			Title.Position = UDim2.new(0.0220048912, 0, -0.0309278332, 0)
			Title.Size = UDim2.new(0.982885063, 0, 0.0182648394, 20)
			Title.ZIndex = 2
			Title.Font = Enum.Font.GothamMedium
			Title.Text = string.format(" %s", title)
			Title.TextColor3 = themes.TextColor
			Title.TextSize = 13.000
			Title.TextXAlignment = Enum.TextXAlignment.Left

			SectionLL.Name = "SectionLL"
			SectionLL.Parent = Section
			SectionLL.SortOrder = Enum.SortOrder.LayoutOrder
			SectionLL.Padding = UDim.new(0, 4)
			SectionLL.HorizontalAlignment = Enum.HorizontalAlignment.Center

			SectionP.Name = "SectionP"
			SectionP.Parent = Section
			SectionP.PaddingTop = UDim.new(0, 4)
			
			SectionLL:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Section.Size = UDim2.new(0, 409, 0, SectionLL.AbsoluteContentSize.Y + 14)
			end)
			
			local SectionHolder = {}
			
			function SectionHolder:Button(name, callback)
				local callback = callback or function() end
				assert(name, "a name is required to create a button")
				
				local Btn = Instance.new("TextButton")
				local BtnC = Instance.new("UICorner")

				Btn.Name = "Btn"
				Btn.Parent = Section
				Btn.BackgroundColor3 = themes.DarkContrast
				Btn.BorderSizePixel = 0
				Btn.Position = UDim2.new(0.0244497284, 0, 0.115571238, 0)
				Btn.Size = UDim2.new(0.975856602, 0, 0, 30)
				Btn.AutoButtonColor = false
				Btn.Font = Enum.Font.Gotham
				Btn.TextColor3 = themes.TextColor
				Btn.TextSize = 13
				Btn.Text = name

				BtnC.CornerRadius = UDim.new(0, 3)
				BtnC.Name = "BtnC"
				BtnC.Parent = Btn
				
				local Debounce = false
				
				Btn.MouseButton1Click:Connect(function()
					if Debounce then
						return
					end
					Debounce = true
					Pop(Btn)
					task.spawn(callback)
					Debounce = false
				end)
				return Btn
			end
			
			function SectionHolder:Label(name)
				assert(name, "A name is required to create a label")
				
				local Label = Instance.new("TextLabel")
				local LabelC = Instance.new("UICorner")
				local LabelP = Instance.new("UIPadding")

				Label.Name = "Label"
				Label.Parent = Section
				Label.BackgroundColor3 = themes.DarkContrast
				Label.BorderSizePixel = 0
				Label.Position = UDim2.new(0.0120716793, 0, 0.340642005, 0)
				Label.Size = UDim2.new(0.975856662, 0, -0.010416667, 30)
				Label.Font = Enum.Font.Gotham
				Label.Text = name
				Label.TextWrapped = true
				Label.TextColor3 = themes.TextColor
				Label.TextSize = 12.000
				Label.TextYAlignment = Enum.TextYAlignment.Top

				LabelC.CornerRadius = UDim.new(0, 3)
				LabelC.Name = "LabelC"
				LabelC.Parent = Label
					
				LabelP.Parent = Label
				LabelP.PaddingLeft = UDim.new(0, 5)
				LabelP.PaddingTop = UDim.new(0, 5)
				LabelP.PaddingRight = UDim.new(0, 5)
				
				Label.Size = UDim2.new(Label.Size.X.Scale, Label.Size.X.Offset, 0, math.huge)
				Label.Size = UDim2.new(Label.Size.X.Scale, Label.Size.X.Offset, 0, Label.TextBounds.Y + 24/2)
				
				return Label
			end
			
			function SectionHolder:Toggle(name, default, callback)
				local callback = callback or function() end
				local default = default or false
				assert(name, "A name is required to create a toggle")
				local Flag = name
				
				local Toggle = Instance.new("TextButton")
				local ToggleC = Instance.new("UICorner")
				local Inner = Instance.new("Frame")
				local InnerC = Instance.new("UICorner")
				local Circle = Instance.new("Frame")
				local CircleC = Instance.new("UICorner")

				Toggle.Name = "Toggle"
				Toggle.Parent = Section
				Toggle.BackgroundColor3 = themes.DarkContrast
				Toggle.BorderSizePixel = 0
				Toggle.Position = UDim2.new(0.0244497284, 0, 0.115571238, 0)
				Toggle.Size = UDim2.new(0.975856602, 0, 0, 30)
				Toggle.AutoButtonColor = false
				Toggle.Font = Enum.Font.Gotham
				Toggle.Text = string.format("  %s", name)
				Toggle.TextColor3 = themes.TextColor
				Toggle.TextSize = 13.000
				Toggle.TextXAlignment = Enum.TextXAlignment.Left

				ToggleC.CornerRadius = UDim.new(0, 3)
				ToggleC.Name = "ToggleC"
				ToggleC.Parent = Toggle

				Inner.Name = "Inner"
				Inner.Parent = Toggle
				Inner.BackgroundColor3 = themes.LightContrast
				Inner.BorderSizePixel = 0
				Inner.Position = UDim2.new(0.877277315, 0, 0.166969255, 0)
				Inner.Size = UDim2.new(0, 41, 0, 19)
				Inner.ZIndex = 3

				InnerC.CornerRadius = UDim.new(1, 0)
				InnerC.Name = "InnerC"
				InnerC.Parent = Inner

				Circle.Name = "Circle"
				Circle.Parent = Inner
				Circle.BackgroundColor3 = themes.TextColor
				Circle.BorderSizePixel = 0
				Circle.Position = UDim2.new(0.100000001, 0, 0.158000007, 0)
				Circle.Size = UDim2.new(0, 13, 0, 13)
				Circle.ZIndex = 3

				CircleC.CornerRadius = UDim.new(5, 0)
				CircleC.Name = "CircleC"
				CircleC.Parent = Circle
				
				local funcs = {}
				local currentstate = default
				
				funcs.SetState = function(self, State)
					if not State then
						State = not currentstate
					end
					
					if State == currentstate then
						return "State is already set"
					end
					
					Tween(Circle, .2, {Position = UDim2.new(State and 0.55 or 0.1, 0,0.158, 0)})
					
					currentstate = State
					
					callback(State)
				end
				
				if default then
					funcs.SetState(true)
				end
				
				Toggle.MouseButton1Click:Connect(function()
					funcs.SetState()
				end)
				
				return funcs
			end
			
			function SectionHolder:TextBox(name, default, callback)
				local callback = callback or function() end
				assert(name, "A name is required to create a textbox")
				assert(default, "Default text is required to create a textbox")
				
				local TextBox = Instance.new("TextButton")
				local TextBoxC = Instance.new("UICorner")
				local Input = Instance.new("TextBox")
				local InputC = Instance.new("UICorner")
				local TextBoxLL = Instance.new("UIListLayout")
				local TextBoxP = Instance.new("UIPadding")

				TextBox.Name = "TextBox"
				TextBox.Parent = Section
				TextBox.BackgroundColor3 = themes.DarkContrast
				TextBox.BorderSizePixel = 0
				TextBox.Position = UDim2.new(0.0244497284, 0, 0.115571238, 0)
				TextBox.Size = UDim2.new(0.975856602, 0, 0, 30)
				TextBox.AutoButtonColor = false
				TextBox.Font = Enum.Font.Gotham
				TextBox.Text = string.format("  %s", name)
				TextBox.TextColor3 = themes.TextColor
				TextBox.TextSize = 13.000
				TextBox.TextXAlignment = Enum.TextXAlignment.Left

				TextBoxC.CornerRadius = UDim.new(0, 3)
				TextBoxC.Name = "TextBoxC"
				TextBoxC.Parent = TextBox

				Input.Name = "Input"
				Input.Parent = TextBox
				Input.BackgroundColor3 = themes.LightContrast
				Input.ClipsDescendants = true
				Input.Position = UDim2.new(0, 280, 0, 7)
				Input.Size = UDim2.new(0, 111, 0, 16)
				Input.ZIndex = 3
				Input.Font = Enum.Font.GothamMedium
				Input.Text = default
				Input.TextColor3 = themes.TextColor
				Input.TextSize = 12.000

				InputC.CornerRadius = UDim.new(0, 3)
				InputC.Name = "InputC"
				InputC.Parent = Input

				TextBoxLL.Name = "TextBoxLL"
				TextBoxLL.Parent = TextBox
				TextBoxLL.HorizontalAlignment = Enum.HorizontalAlignment.Right
				TextBoxLL.SortOrder = Enum.SortOrder.LayoutOrder
				TextBoxLL.VerticalAlignment = Enum.VerticalAlignment.Center

				TextBoxP.Name = "TextBoxP"
				TextBoxP.Parent = TextBox
				TextBoxP.PaddingRight = UDim.new(0, 8)
				
				Input.FocusLost:Connect(function()
					if Input.Text == "" then
						Input.Text = default
					end
					
					callback(Input.Text)
				end)
				
				return TextBox
			end
			
			function SectionHolder:KeyBind(name, default, callback)
				local callback = callback or function() end
				assert(name, "A name is required to create a keybind")
				assert(default, "A default key is required to create a keybind")
				
				local KeyBind = Instance.new("TextButton")
				local TextBoxC = Instance.new("UICorner")
				local Input = Instance.new("TextButton")
				local InputC = Instance.new("UICorner")
				local KeyBindLL = Instance.new("UIListLayout")
				local KeyBindP = Instance.new("UIPadding")

				KeyBind.Name = "KeyBind"
				KeyBind.Parent = Section
				KeyBind.BackgroundColor3 = themes.DarkContrast
				KeyBind.BorderSizePixel = 0
				KeyBind.Position = UDim2.new(0.0244497284, 0, 0.115571238, 0)
				KeyBind.Size = UDim2.new(0.975856602, 0, 0, 30)
				KeyBind.AutoButtonColor = false
				KeyBind.Font = Enum.Font.Gotham
				KeyBind.Text = string.format("  %s", name)
				KeyBind.TextColor3 = themes.TextColor
				KeyBind.TextSize = 13.000
				KeyBind.TextXAlignment = Enum.TextXAlignment.Left

				TextBoxC.CornerRadius = UDim.new(0, 3)
				TextBoxC.Name = "TextBoxC"
				TextBoxC.Parent = KeyBind

				Input.Name = "Input"
				Input.Parent = KeyBind
				Input.BackgroundColor3 = themes.LightContrast
				Input.ClipsDescendants = true
				Input.Position = UDim2.new(0, 280, 0, 7)
				Input.Size = UDim2.new(0, 111, 0, 16)
				Input.ZIndex = 3
				Input.AutoButtonColor = false
				Input.Font = Enum.Font.GothamMedium
				Input.Text = default
				Input.TextColor3 = themes.TextColor
				Input.TextSize = 12.000

				InputC.CornerRadius = UDim.new(0, 3)
				InputC.Name = "InputC"
				InputC.Parent = Input

				KeyBindLL.Name = "KeyBindLL"
				KeyBindLL.Parent = KeyBind
				KeyBindLL.HorizontalAlignment = Enum.HorizontalAlignment.Right
				KeyBindLL.SortOrder = Enum.SortOrder.LayoutOrder
				KeyBindLL.VerticalAlignment = Enum.VerticalAlignment.Center

				KeyBindP.Name = "KeyBindP"
				KeyBindP.Parent = KeyBind
				KeyBindP.PaddingRight = UDim.new(0, 8)
				
				local BannedKeys = {
					Return = true;
					Space = true;
					Tab = true;
					Backquote = true;
					CapsLock = true;
					Escape = true;
					Unknown = true;
				}

				local ShortNames = {
					RightControl = "Right Ctrl",
					LeftControl = "Left Ctrl",
					LeftShift = "Left Shift",
					RightShift = "Right Shift",
					Semicolon = ";",
					Quote = '"',
					LeftBracket = "[",
					RightBracket = "]",
					Equals = "=",
					Minus = "-",
					RightAlt = "Right Alt",
					LeftAlt = "Left Alt"
				}

				local default = (typeof(default) == "string" and Enum.KeyCode[default] or default)
				local bindKey = default
				local keyTxt = (default and (ShortNames[default.Name] or default.Name) or "None")
				
				game:GetService("UserInputService").InputBegan:Connect(function(inp, gpe)
					if Library.Destroyed then
						return
					end
					
					if gpe then
						return
					end
					
					if inp.UserInputType ~= Enum.UserInputType.Keyboard then
						return
					end
					
					if inp.KeyCode ~= bindKey then
						return
					end
					
					callback(bindKey.Name)
				end)
				
				Input.MouseButton1Click:Connect(function()
					Input.Text = "..."
					task.wait()
					local key = game.UserInputService.InputEnded:Wait()
					
					if key.UserInputType ~= Enum.UserInputType.Keyboard then
						Input.Text = keyTxt
						return
					end
					
					if BannedKeys[tostring(key.KeyCode.Name)] then
						Input.Text = keyTxt
						return
					end
					
					bindKey = Enum.KeyCode[tostring(key.KeyCode.Name)]
					Input.Text = ShortNames[tostring(key.KeyCode.Name)] or tostring(key.KeyCode.Name)
				end)
				
				return KeyBind
			end
			
			function SectionHolder:Slider(name, default, min, max, precise, callback)
				local callback = callback or function() end
				local precise = precise or false
				local min = min or 1
				local max = max or 100
				local default = default or min
				assert(name, "A name is required to create a slider")
				
				local Slider = Instance.new("TextButton")
				local SliderC = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local Number = Instance.new("TextBox")
				local Outer = Instance.new("TextLabel")
				local Inner = Instance.new("Frame")
				local InnerC = Instance.new("UICorner")
				local Fill = Instance.new("Frame")
				local FillC = Instance.new("UICorner")
				local Circle = Instance.new("Frame")
				local CircleC = Instance.new("UICorner")

				Slider.Name = "Slider"
				Slider.Parent = Section
				Slider.BackgroundColor3 = themes.DarkContrast
				Slider.BorderSizePixel = 0
				Slider.Position = UDim2.new(-0.0195600521, 0, 0.136772648, 0)
				Slider.Size = UDim2.new(0.976000011, 0, 0, 50)
				Slider.AutoButtonColor = false
				Slider.Font = Enum.Font.Gotham
				Slider.Text = ""
				Slider.TextColor3 = themes.TextColor
				Slider.TextSize = 13.000
				Slider.TextXAlignment = Enum.TextXAlignment.Left

				SliderC.CornerRadius = UDim.new(0, 3)
				SliderC.Name = "SliderC"
				SliderC.Parent = Slider

				Title.Name = "Title"
				Title.Parent = Slider
				Title.BackgroundTransparency = 1.000
				Title.Position = UDim2.new(0, 8, 0, 6)
				Title.Size = UDim2.new(0.740490735, 0, 0, 16)
				Title.ZIndex = 3
				Title.Font = Enum.Font.Gotham
				Title.Text = name
				Title.TextColor3 = themes.TextColor
				Title.TextSize = 13.000
				Title.TextTransparency = 0.100
				Title.TextXAlignment = Enum.TextXAlignment.Left

				Number.Name = "Number"
				Number.Parent = Slider
				Number.BackgroundTransparency = 1.000
				Number.BorderSizePixel = 0
				Number.Position = UDim2.new(1.00250506, -30, 0, 6)
				Number.Size = UDim2.new(0, 20, 0, 16)
				Number.ZIndex = 3
				Number.Font = Enum.Font.GothamMedium
				Number.Text = tostring(default)
				Number.TextColor3 = themes.TextColor
				Number.TextSize = 12.000
				Number.TextXAlignment = Enum.TextXAlignment.Right

				Outer.Name = "Outer"
				Outer.Parent = Slider
				Outer.BackgroundTransparency = 1.000
				Outer.BorderColor3 = Color3.fromRGB(27, 42, 53)
				Outer.Position = UDim2.new(0, 9, 0, 28)
				Outer.Size = UDim2.new(1.00751531, -20, 0, 16)
				Outer.ZIndex = 3
				Outer.Text = ""

				Inner.Name = "Inner"
				Inner.Parent = Outer
				Inner.BackgroundColor3 = themes.LightContrast
				Inner.BorderSizePixel = 0
				Inner.Position = UDim2.new(-0.00263030501, 0, 0.375, 0)
				Inner.Size = UDim2.new(1, 0, 0, 4)
				Inner.ZIndex = 3

				InnerC.CornerRadius = UDim.new(0, 10)
				InnerC.Name = "InnerC"
				InnerC.Parent = Inner

				Fill.Name = "Fill"
				Fill.Parent = Inner
				Fill.BackgroundColor3 = themes.TextColor
				Fill.BorderSizePixel = 0
				Fill.Position = UDim2.new(0.00012392737, 0, 0, 0)
				Fill.Size = UDim2.new(0.379879832, 0, 0, 4)
				Fill.ZIndex = 3

				FillC.CornerRadius = UDim.new(0, 10)
				FillC.Name = "FillC"
				FillC.Parent = Fill

				Circle.Name = "Circle"
				Circle.Parent = Fill
				Circle.BackgroundColor3 = themes.TextColor
				Circle.Position = UDim2.new(0.979818106, 0, -0.75, 0)
				Circle.Size = UDim2.new(0, 10, 0, 10)
				Circle.ZIndex = 3
				Circle.Transparency = 1

				CircleC.CornerRadius = UDim.new(0, 9999)
				CircleC.Name = "CircleC"
				CircleC.Parent = Circle
				
				local funcs = {}
				
				funcs.SetState = function(self, state)
					local percent = (Mouse.X - Inner.AbsolutePosition.X) / Inner.AbsoluteSize.X
					
					if state then
						percent = (state - min) / (max - min)
					end
					
					percent = math.clamp(percent, 0, 1)
					
					if precise then
						state = state or tonumber(string.format("%.1f", tostring(min + (max - min) * percent)))
					else
						state = state or math.floor(min + (max - min) * percent)
					end
					
					Number.Text = tostring(state)
					
					Tween(Fill, .1, {Size = UDim2.new(percent, 0, 1, 0)})
					
					callback(tonumber(state))
				end
				
				funcs:SetState(default)
				
				local dragging, boxFocused, allowed = false, false, {[""] = true, ["-"] = true}
				
				Outer.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Tween(Circle, .2, {Transparency = 0})
						funcs:SetState()
						dragging = true
					end
				end)
				
				game:GetService("UserInputService").InputEnded:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
						task.wait(1)
						if not dragging then
							Tween(Circle, .2, {Transparency = 1})
						end
					end
				end)
				
				game:GetService("UserInputService").InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						funcs:SetState()
					end
				end)
				
				Number.Focused:Connect(function()
					boxFocused = true
				end)
				
				Number.FocusLost:Connect(function()
					if not tonumber(Number.Text) then
						Number.Text = default
					end
					boxFocused = false
				end)
				
				Number:GetPropertyChangedSignal"Text":Connect(function()
					if not boxFocused then
						return
					end
					
					Number.Text = Number.Text:gsub("%D+", "")

					local text = Number.Text

					if not tonumber(text) then
						Number.Text = Number.Text:gsub('%D+', '')
					elseif not allowed[text] then
						if tonumber(text) > max then
							text = max
							Number.Text = tostring(max)
						end
						if tonumber(text) < min then
							text = min
							Number.Text = tostring(min)
						end
					end
					
					if Number.Text == "" then
						return
					end
					
					funcs:SetState(tonumber(text))
				end)
				
				return funcs
			end
			
			function SectionHolder:DropDown(name, options, multi, players, reset, callback)
				local callback = callback or function() end
				local options = options or {}
				local multi = multi or false
				local players = players or false
				local reset = reset or false
				assert(name, "a name is required to create a dropdown")
				
				local DropDown = Instance.new("TextButton")
				local DropDownC = Instance.new("UICorner")
				local Search = Instance.new("TextBox") -- multi and "TextLabel" or
				local Arrow = Instance.new("ImageButton")
				local DropdownHolder = Instance.new("Frame")
				local DropdownHolderC = Instance.new("UICorner")
				local OptionHolder = Instance.new("ScrollingFrame")
				local OptionHolderLL = Instance.new("UIListLayout")

				DropDown.Name = "DropDown"
				DropDown.Parent = Section
				DropDown.BackgroundColor3 = themes.DarkContrast
				DropDown.BorderSizePixel = 0
				DropDown.Position = UDim2.new(0.0244497284, 0, 0.115571238, 0)
				DropDown.Size = UDim2.new(0.975856602, 0, 0, 30)
				DropDown.AutoButtonColor = false
				DropDown.Font = Enum.Font.Gotham
				DropDown.Text = ""
				DropDown.TextColor3 = themes.TextColor
				DropDown.TextSize = 13.000
				DropDown.TextXAlignment = Enum.TextXAlignment.Left

				DropDownC.CornerRadius = UDim.new(0, 3)
				DropDownC.Name = "DropDownC"
				DropDownC.Parent = DropDown

				Search.Name = "Search"
				Search.Parent = DropDown
				Search.AnchorPoint = Vector2.new(0, 0.5)
				Search.BackgroundTransparency = 1.000
				Search.Position = UDim2.new(-0.00751628308, 10, 0.5, 1)
				Search.Size = UDim2.new(1.00501084, -42, 1, 0)
				Search.ZIndex = 3
				Search.Font = Enum.Font.Gotham
				Search.Text = name
				Search.TextColor3 = themes.TextColor
				Search.TextSize = 13.000
				Search.TextTransparency = 0.100
				Search.TextXAlignment = Enum.TextXAlignment.Left

				Arrow.Name = "Arrow"
				Arrow.Parent = DropDown
				Arrow.BackgroundTransparency = 1.000
				Arrow.BorderSizePixel = 0
				Arrow.Position = UDim2.new(1.00501096, -28, 0.5, -9)
				Arrow.Size = UDim2.new(0, 18, 0, 18)
				Arrow.ZIndex = 3
				Arrow.Image = "rbxassetid://5012539403"
				Arrow.SliceCenter = Rect.new(2, 2, 298, 298)
				Arrow.ImageColor3 = themes.TextColor

				DropdownHolder.Name = "DropdownHolder"
				DropdownHolder.Parent = Section
				DropdownHolder.BackgroundColor3 = themes.Background
				DropdownHolder.BorderSizePixel = 0
				DropdownHolder.ClipsDescendants = true
				DropdownHolder.Position = UDim2.new(0.0120000485, 0, 0.430878669, 0)
				DropdownHolder.Size = UDim2.new(0.976000011, 0, 0, 0)
				DropdownHolder.Visible = false

				DropdownHolderC.CornerRadius = UDim.new(0, 3)
				DropdownHolderC.Name = "DropdownHolderC"
				DropdownHolderC.Parent = DropdownHolder

				OptionHolder.Name = "OptionHolder"
				OptionHolder.Parent = DropdownHolder
				OptionHolder.Active = true
				OptionHolder.BackgroundColor3 = themes.TextColor
				OptionHolder.BackgroundTransparency = 1.000
				OptionHolder.BorderSizePixel = 0
				OptionHolder.Position = UDim2.new(0.0100202896, 0, 0.0178573243, 0)
				OptionHolder.Size = UDim2.new(0, 388,0, 132)
				OptionHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
				OptionHolder.ScrollBarThickness = 1
				OptionHolder.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)

				OptionHolderLL.Name = "OptionHolderLL"
				OptionHolderLL.Parent = OptionHolder
				OptionHolderLL.SortOrder = Enum.SortOrder.LayoutOrder
				OptionHolderLL.Padding = UDim.new(0, 4)
				
				local IsOpen, IsSearching, funcs, Selected = false, false, {}, {}
				
				local ShowAll = function()
					for i,v in next, OptionHolder:GetChildren() do
						if v:IsA"TextButton" then
							v.Visible = true
						end
					end
				end
				
				local SearchOption = function(text)
					if text == "" then
						ShowAll()
					end
					for i,v in next, OptionHolder:GetChildren() do
						if v:IsA("TextButton") then
							v.Visible = v.Text:lower():match(text:lower()) and true or false
						end
					end
				end
				
				local Open = function()
					IsOpen = not IsOpen
					
					if IsOpen then
						ShowAll()
						DropdownHolder.Visible = true
					end
					
					Tween(DropdownHolder, .2, {Size = UDim2.new(0.976, 0,0, IsOpen and 140 or 0)})
					
					task.wait(.2)
					
					if not IsOpen then
						DropdownHolder.Visible = false
					end
				end
				
				local PlayerList = function()
					local AllPlayers = {}
					
					for i,v in next, game:GetService"Players":GetChildren() do
						table.insert(AllPlayers, v.Name)
					end
					return AllPlayers
				end
				
				local ReSortList = function()
					local NewList = {}
					
					for i,v in next, Selected do
						table.insert(NewList, v)
					end
					
					for i,v in next, options do
						if not table.find(NewList, v) then
							table.insert(NewList, v)
						end
					end
					return NewList
				end
				
				local function SetSearchText(Search)
					for i,v in next, Selected do
						if i == 1 then
							Search.Text = Search.Text..v
						else
							Search.Text = Search.Text..", "..v
						end
					end
				end
				
				options = players and PlayerList() or options
				
				funcs.AddOption = function(self, text)
					local Option = Instance.new("TextButton")
					local OptionC = Instance.new("UICorner")
					local OptionP = Instance.new("UIPadding")

					Option.Name = "Option"
					Option.Parent = OptionHolder
					Option.BackgroundColor3 = themes.DarkContrast
					Option.BorderSizePixel = 0
					Option.Size = UDim2.new(0.976405919, 0, 0, 30)
					Option.AutoButtonColor = false
					Option.Font = Enum.Font.Gotham
					Option.Text = text
					Option.TextColor3 = themes.TextColor
					Option.TextSize = 13.000
					Option.TextXAlignment = Enum.TextXAlignment.Left
					Option.TextTransparency = table.find(Selected, Option.Text) and 0 or multi and 0.65 or 0

					OptionC.CornerRadius = UDim.new(0, 3)
					OptionC.Name = "OptionC"
					OptionC.Parent = Option
					
					OptionP.Name = "OptionP"
					OptionP.Parent = Option
					OptionP.PaddingLeft = UDim.new(0, 8)
					
					Option.MouseButton1Click:Connect(function()
						if not multi then
							Search.Text = reset and name or Option.Text
							callback(Option.Text)
							Open()
						else
							Search.Text = "Selected - "
							
							if table.find(Selected, Option.Text) then
								table.remove(Selected, table.find(Selected, Option.Text))
							else
								table.insert(Selected, Option.Text)
							end
							
							funcs:SetOptions(ReSortList())
							
							callback(Selected)
							
							if not Selected[1] then
								Search.Text = name
								return
							end
							
							SetSearchText(Search)
							
							if IsSearching then
								IsSearching = false
								ShowAll()
							end
						end
					end)
				end
				
				funcs.SetOptions = function(self, options)
					for i,v in next, OptionHolder:GetChildren() do
						if v:IsA"TextButton" then
							v:Destroy()
						end
					end
					for i,v in next, options do
						funcs:AddOption(v)
					end
				end
				
				Search.Focused:Connect(function()
					IsSearching = true
				end)
				
				Search.FocusLost:Connect(function()
					if Search.Text == "" then
						Search.Text = multi and SetSearchText(Search) or name
					end
					
					if Search.Text:sub(1, 8) == "Selected" then
						return
					end
					
					IsSearching = false
				end)
					
				Search:GetPropertyChangedSignal("Text"):Connect(function()
					if not IsOpen then
						return
					end
						
					if Search.Text == name then
						return
					end
					
					if not IsSearching then
						return
					end
						
					SearchOption(Search.Text)
				end)
				
				OptionHolderLL:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
					OptionHolder.CanvasSize = UDim2.new(0, 0, 0, OptionHolderLL.AbsoluteContentSize.Y + 1)
				end)
				
				Arrow.MouseButton1Click:Connect(function()
					Open()
				end)
				
				funcs:SetOptions(options)
				
				return funcs
			end
			
			function SectionHolder:MultiChoice(name, options, default, callback)
				local callback = callback or function() end
				local options = options or {}
				assert(default, "A default option is required")
				assert(name, "A name is required to create miltiple choices")

				local MultiChoice = Instance.new("TextButton")
				local MultiChoiceC = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local MultiChoiceLL = Instance.new("UIListLayout")
				local MultiChoiceP = Instance.new("UIPadding")

				MultiChoice.Name = "MultiChoice"
				MultiChoice.Parent = Section
				MultiChoice.BackgroundColor3 = themes.DarkContrast
				MultiChoice.BorderSizePixel = 0
				MultiChoice.Position = UDim2.new(0.0120716793, 0, 0.481174529, 0)
				MultiChoice.Size = UDim2.new(0.975856662, 0, 0.096726194, 30)
				MultiChoice.AutoButtonColor = false
				MultiChoice.Font = Enum.Font.Gotham
				MultiChoice.Text = ""
				MultiChoice.TextColor3 = themes.TextColor
				MultiChoice.TextSize = 13.000
				MultiChoice.TextXAlignment = Enum.TextXAlignment.Left

				MultiChoiceC.CornerRadius = UDim.new(0, 3)
				MultiChoiceC.Name = "MultiChoiceC"
				MultiChoiceC.Parent = MultiChoice

				Title.Name = "Title"
				Title.Parent = MultiChoice
				Title.BackgroundTransparency = 1.000
				Title.Position = UDim2.new(0, 7, 0, 5)
				Title.Size = UDim2.new(0.740490675, 0, 0.0666666701, 16)
				Title.ZIndex = 3
				Title.Font = Enum.Font.Gotham
				Title.Text = name
				Title.TextColor3 = themes.TextColor
				Title.TextSize = 13.000
				Title.TextTransparency = 0.100
				Title.TextXAlignment = Enum.TextXAlignment.Left

				MultiChoiceLL.Name = "MultiChoiceLL"
				MultiChoiceLL.Parent = MultiChoice
				MultiChoiceLL.SortOrder = Enum.SortOrder.LayoutOrder
				MultiChoiceLL.Padding = UDim.new(0, 5)

				MultiChoiceP.Name = "MultiChoiceP"
				MultiChoiceP.Parent = MultiChoice
				MultiChoiceP.PaddingLeft = UDim.new(0, 8)
				MultiChoiceP.PaddingTop = UDim.new(0, 5)
				
				local Selected, funcs = nil, {}
				
				local AddOption = function(name)
					local Option = Instance.new("TextButton")
					local Circle = Instance.new("TextButton")
					local CircleC = Instance.new("UICorner")
					local Filler = Instance.new("TextButton")
					local FillerC = Instance.new("UICorner")
					local Title = Instance.new("TextLabel")
					local CircleS = Instance.new("UIStroke")

					Option.Name = "Option"
					Option.Parent = MultiChoice
					Option.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					Option.BackgroundTransparency = 1.000
					Option.BorderSizePixel = 0
					Option.Position = UDim2.new(0.0251125842, 0, 0.211244196, 0)
					Option.Size = UDim2.new(0.975856602, 0, -0.0244709067, 30)
					Option.AutoButtonColor = false
					Option.Font = Enum.Font.Gotham
					Option.Text = ""
					Option.TextColor3 = themes.TextColor
					Option.TextSize = 13.000
					Option.TextXAlignment = Enum.TextXAlignment.Left

					Circle.Name = "Circle"
					Circle.Parent = Option
					Circle.BackgroundColor3 = themes.DarkContrast
					Circle.BorderSizePixel = 0
					Circle.Position = UDim2.new(-0.00110064819, 0, 0.2112443, 0)
					Circle.Size = UDim2.new(0, 14, 0, 14)
					Circle.AutoButtonColor = false
					Circle.Font = Enum.Font.Gotham
					Circle.Text = ""
					Circle.TextColor3 = themes.TextColor
					Circle.TextSize = 13.000
					Circle.TextXAlignment = Enum.TextXAlignment.Left
					
					CircleS.Parent = Circle
					CircleS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					CircleS.Thickness = 1.5
					CircleS.Color = Color3.fromRGB(225, 225, 225)
					CircleS.Color = themes.TextColor

					CircleC.CornerRadius = UDim.new(1, 0)
					CircleC.Name = "CircleC"
					CircleC.Parent = Circle

					Filler.Name = "Filler"
					Filler.Parent = Circle
					Filler.BackgroundColor3 = themes.TextColor
					Filler.BorderSizePixel = 0
					Filler.Position = UDim2.new(0, 3,0.211, 0)
					Filler.Size = UDim2.new(0, 8, 0, 8)
					Filler.AutoButtonColor = false
					Filler.Font = Enum.Font.Gotham
					Filler.Text = ""
					Filler.TextColor3 = themes.TextColor
					Filler.TextSize = 13.000
					Filler.TextXAlignment = Enum.TextXAlignment.Left
					Filler.Visible = false

					FillerC.CornerRadius = UDim.new(1, 0)
					FillerC.Name = "FillerC"
					FillerC.Parent = Filler

					Title.Name = "Title"
					Title.Parent = Option
					Title.BackgroundTransparency = 1.000
					Title.Position = UDim2.new(0, 23, 0, 5)
					Title.Size = UDim2.new(0.740490735, 0, 0, 16)
					Title.ZIndex = 3
					Title.Font = Enum.Font.Gotham
					Title.Text = name
					Title.TextColor3 = themes.TextColor
					Title.TextSize = 13.000
					Title.TextTransparency = 0.100
					Title.TextXAlignment = Enum.TextXAlignment.Left
					
					if Title.Text == default then
						Selected = Circle
						Filler.Visible = true
						callback(Title.Text)
					end
					
					Circle.MouseButton1Click:Connect(function()
						if Selected then
							Selected.Filler.Visible = false
						end
						
						Filler.Visible = true
						Selected = Circle
						callback(Title.Text)
					end)
				end
				
				for i,v in next, options do
					AddOption(v)
				end
				
				MultiChoiceLL:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
					MultiChoice.Size = UDim2.new(0.976, 0, 0, MultiChoiceLL.AbsoluteContentSize.Y + 5)
				end)
				
				return MultiChoice
			end
			
			function SectionHolder:ColorPicker(name, default, callback)
				local callback = callback or function() end
				local default = default or Color3.fromRGB(225, 225, 225)
				assert(name, "A name is required to create a color picker")
				
				local ColorPicker = Instance.new("TextButton")
				local ColorPickerC = Instance.new("UICorner")
				local Color = Instance.new("Frame")
				local ColorC = Instance.new("UICorner")
				local ColorPicker_ = Instance.new("Frame")
				local Title = Instance.new("TextLabel")
				local ColorPickerHolder = Instance.new("Frame")
				local ColorSaturation = Instance.new("ImageLabel")
				local ColorSaturationC = Instance.new("UICorner")
				local SaturationPicker = Instance.new("Frame")
				local SaturationPickerC = Instance.new("UICorner")
				local HUEF = Instance.new("ImageLabel")
				local huepicker = Instance.new("Frame")
				local HUEFC = Instance.new("UICorner")
				local Inputs = Instance.new("Frame")
				local InputsLL = Instance.new("UIListLayout")
				local R = Instance.new("Frame")
				local RC = Instance.new("UICorner")
				local RText = Instance.new("TextLabel")
				local RInput = Instance.new("TextBox")
				local G = Instance.new("Frame")
				local GC = Instance.new("UICorner")
				local GText = Instance.new("TextLabel")
				local GInput = Instance.new("TextBox")
				local B = Instance.new("Frame")
				local BC = Instance.new("UICorner")
				local BText = Instance.new("TextLabel")
				local BInput = Instance.new("TextBox")
				local Submit = Instance.new("TextButton")
				local SubmitC = Instance.new("UICorner")
				local ColorPicker_C = Instance.new("UICorner")

				ColorPicker.Name = "ColorPicker"
				ColorPicker.Parent = Section
				ColorPicker.BackgroundColor3 = themes.DarkContrast
				ColorPicker.BorderSizePixel = 0
				ColorPicker.Position = UDim2.new(0.0244497284, 0, 0.115571238, 0)
				ColorPicker.Size = UDim2.new(0.975856602, 0, 0, 30)
				ColorPicker.AutoButtonColor = false
				ColorPicker.Font = Enum.Font.Gotham
				ColorPicker.Text = "  ColorPicker"
				ColorPicker.TextColor3 = themes.TextColor
				ColorPicker.TextSize = 13.000
				ColorPicker.TextXAlignment = Enum.TextXAlignment.Left

				ColorPickerC.CornerRadius = UDim.new(0, 3)
				ColorPickerC.Name = "ColorPickerC"
				ColorPickerC.Parent = ColorPicker

				Color.Name = "Color"
				Color.Parent = ColorPicker
				Color.BackgroundColor3 = themes.TextColor
				Color.Position = UDim2.new(1.005, -50, 0.5, -7)
				Color.Size = UDim2.new(0, 40, 0, 14)

				ColorC.CornerRadius = UDim.new(0, 3)
				ColorC.Name = "ColorC"
				ColorC.Parent = Color
				
				ColorPicker_.Name = "ColorPicker_"
				ColorPicker_.Parent = Main
				ColorPicker_.BackgroundColor3 = themes.Background
				ColorPicker_.BorderSizePixel = 0
				ColorPicker_.Position = UDim2.new(1.012, 0,0.249, 0)
				ColorPicker_.Size = UDim2.new(0, 162, 0, 169)
				ColorPicker_.Visible = false
				
				ColorPicker_C.CornerRadius = UDim.new(0, 5)
				ColorPicker_C.Name = "ColorPicker_C"
				ColorPicker_C.Parent = ColorPicker_

				Title.Name = "Title"
				Title.Parent = ColorPicker_
				Title.BackgroundTransparency = 1.000
				Title.Position = UDim2.new(0, 7, 0, 8)
				Title.Size = UDim2.new(1, -40, 0, 16)
				Title.ZIndex = 2
				Title.Font = Enum.Font.GothamMedium
				Title.Text = "Glow"
				Title.TextColor3 = themes.TextColor
				Title.TextSize = 14.000
				Title.TextXAlignment = Enum.TextXAlignment.Left

				ColorPickerHolder.Name = "ColorPickerHolder"
				ColorPickerHolder.Parent = ColorPicker_
				ColorPickerHolder.BackgroundColor3 = themes.Background
				ColorPickerHolder.BorderSizePixel = 0
				ColorPickerHolder.Position = UDim2.new(0, 8, 0, 32)
				ColorPickerHolder.Size = UDim2.new(1, -18, 1, -40)

				ColorSaturation.Name = "ColorSaturation"
				ColorSaturation.Parent = ColorPickerHolder
				ColorSaturation.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
				ColorSaturation.Position = UDim2.new(0, 1, 0, 0)
				ColorSaturation.Size = UDim2.new(0.854166687, 0, 0.116279073, 60)
				ColorSaturation.ZIndex = 2
				ColorSaturation.Image = "rbxassetid://8630797271"

				ColorSaturationC.CornerRadius = UDim.new(0, 3)
				ColorSaturationC.Name = "ColorSaturationC"
				ColorSaturationC.Parent = ColorSaturation

				SaturationPicker.Name = "SaturationPicker"
				SaturationPicker.Parent = ColorSaturation
				SaturationPicker.BackgroundColor3 = themes.TextColor
				SaturationPicker.BorderColor3 = themes.TextColor
				SaturationPicker.Position = UDim2.new(0, 20, 0, 20)
				SaturationPicker.Size = UDim2.new(0, 6, 0, 6)
				SaturationPicker.ZIndex = 3

				SaturationPickerC.CornerRadius = UDim.new(1, 12)
				SaturationPickerC.Name = "SaturationPickerC"
				SaturationPickerC.Parent = SaturationPicker

				HUEF.Name = "HUEF"
				HUEF.Parent = ColorPickerHolder
				HUEF.BackgroundColor3 = themes.TextColor
				HUEF.BackgroundTransparency = 1.000
				HUEF.Position = UDim2.new(1.07051337, -24, -0.231185317, 30)
				HUEF.Size = UDim2.new(0, 13, 0, 76)
				HUEF.Image = "rbxassetid://8630799159"
				HUEF.ScaleType = Enum.ScaleType.Crop

				huepicker.Name = "huepicker"
				huepicker.Parent = HUEF
				huepicker.BackgroundColor3 = themes.TextColor
				huepicker.BorderSizePixel = 0
				huepicker.Position = UDim2.new(0, 0, 0, 20)
				huepicker.Size = UDim2.new(1, 0, 0, 2)

				HUEFC.CornerRadius = UDim.new(0, 3)
				HUEFC.Name = "HUEFC"
				HUEFC.Parent = HUEF

				Inputs.Name = "Inputs"
				Inputs.Parent = ColorPickerHolder
				Inputs.BackgroundTransparency = 1.000
				Inputs.Position = UDim2.new(0, 1, 0, 87)
				Inputs.Size = UDim2.new(1, 0, 0, 16)

				InputsLL.Name = "InputsLL"
				InputsLL.Parent = Inputs
				InputsLL.FillDirection = Enum.FillDirection.Horizontal
				InputsLL.SortOrder = Enum.SortOrder.LayoutOrder
				InputsLL.Padding = UDim.new(0, 6)

				R.Name = "R"
				R.Parent = Inputs
				R.BackgroundColor3 = themes.DarkContrast
				R.BorderSizePixel = 0
				R.Position = UDim2.new(0, 0, 2.75, 0)
				R.Size = UDim2.new(0.305000007, 0, 1, 0)

				RC.CornerRadius = UDim.new(0, 3)
				RC.Name = "RC"
				RC.Parent = R

				RText.Name = "RText"
				RText.Parent = R
				RText.BackgroundTransparency = 1.000
				RText.Size = UDim2.new(0.400000006, 0, 1, 0)
				RText.ZIndex = 2
				RText.Font = Enum.Font.Gotham
				RText.Text = "R:"
				RText.TextColor3 = themes.TextColor
				RText.TextSize = 10.000

				RInput.Name = "RInput"
				RInput.Parent = R
				RInput.BackgroundTransparency = 1.000
				RInput.Position = UDim2.new(0.300000012, 0, 0, 0)
				RInput.Size = UDim2.new(0.600000024, 0, 1, 0)
				RInput.ZIndex = 2
				RInput.Font = Enum.Font.Gotham
				RInput.Text = "1"
				RInput.TextColor3 = themes.TextColor
				RInput.TextSize = 10.000
				RInput.ClearTextOnFocus = true

				G.Name = "G"
				G.Parent = Inputs
				G.BackgroundColor3 = themes.DarkContrast
				G.BorderSizePixel = 0
				G.Position = UDim2.new(0, 0, 2.75, 0)
				G.Size = UDim2.new(0.305000007, 0, 1, 0)

				GC.CornerRadius = UDim.new(0, 3)
				GC.Name = "GC"
				GC.Parent = G

				GText.Name = "GText"
				GText.Parent = G
				GText.BackgroundTransparency = 1.000
				GText.Size = UDim2.new(0.400000006, 0, 1, 0)
				GText.ZIndex = 2
				GText.Font = Enum.Font.Gotham
				GText.Text = "G:"
				GText.TextColor3 = themes.TextColor
				GText.TextSize = 10.000

				GInput.Name = "GInput"
				GInput.Parent = G
				GInput.BackgroundTransparency = 1.000
				GInput.Position = UDim2.new(0.300000012, 0, 0, 0)
				GInput.Size = UDim2.new(0.600000024, 0, 1, 0)
				GInput.ZIndex = 2
				GInput.Font = Enum.Font.Gotham
				GInput.Text = "1"
				GInput.TextColor3 = themes.TextColor
				GInput.TextSize = 10.000

				B.Name = "B"
				B.Parent = Inputs
				B.BackgroundColor3 = themes.DarkContrast
				B.BorderSizePixel = 0
				B.Position = UDim2.new(0, 0, 2.75, 0)
				B.Size = UDim2.new(0.305000007, 0, 1, 0)

				BC.CornerRadius = UDim.new(0, 3)
				BC.Name = "BC"
				BC.Parent = B

				BText.Name = "BText"
				BText.Parent = B
				BText.BackgroundTransparency = 1.000
				BText.Size = UDim2.new(0.400000006, 0, 1, 0)
				BText.ZIndex = 2
				BText.Font = Enum.Font.Gotham
				BText.Text = "B:"
				BText.TextColor3 = themes.TextColor
				BText.TextSize = 10.000

				BInput.Name = "BInput"
				BInput.Parent = B
				BInput.BackgroundTransparency = 1.000
				BInput.Position = UDim2.new(0.300000012, 0, 0, 0)
				BInput.Size = UDim2.new(0.600000024, 0, 1, 0)
				BInput.ZIndex = 2
				BInput.Font = Enum.Font.Gotham
				BInput.Text = ""
				BInput.TextColor3 = themes.TextColor
				BInput.TextSize = 10.000

				Submit.Name = "Submit"
				Submit.Parent = ColorPickerHolder
				Submit.BackgroundColor3 = themes.DarkContrast
				Submit.BorderSizePixel = 0
				Submit.Position = UDim2.new(0.00694444776, 0, 0.844961226, 0)
				Submit.Size = UDim2.new(1, 0, 0, 20)
				Submit.AutoButtonColor = false
				Submit.Font = Enum.Font.SourceSans
				Submit.Text = "Submit"
				Submit.TextColor3 = themes.TextColor
				Submit.TextSize = 14.000

				SubmitC.CornerRadius = UDim.new(0, 3)
				SubmitC.Name = "SubmitC"
				SubmitC.Parent = Submit
				
				local IsOpen, funcs = false, {}
				
				local function Open()
					if Library.CurrentColorPicker and IsOpen then
						Library.CurrentColorPicker.Visible = false
						Library.CurrentColorPicker = nil
					end
					
					task.wait()
					
					IsOpen = not IsOpen
					
					Library.CurrentColorPicker = ColorPicker_
					
					ColorPicker_.Visible = IsOpen
				end
				
				ColorPicker.MouseButton1Click:Connect(function()
					Open()
				end)
				
				Submit.MouseButton1Click:Connect(function()
					Open()
				end)
				
				local hue, sat, val = default:ToHSV()
				local slidingHue = false
				local slidingSaturation = false
				local hsv = Color3.fromHSV(hue, sat, val)
				local IsTyping = false
				
				local function updatehue(input)
					local sizeY = 1 - math.clamp((input.Position.Y - HUEF.AbsolutePosition.Y) / HUEF.AbsoluteSize.Y, 0, 1)
					local posY = math.clamp(((input.Position.Y - HUEF.AbsolutePosition.Y) / HUEF.AbsoluteSize.Y) * HUEF.AbsoluteSize.Y, 0, HUEF.AbsoluteSize.Y - 2)
					huepicker.Position = UDim2.new(0, 0, 0, posY)

					hue = sizeY
					hsv = Color3.fromHSV(sizeY, sat, val)

					RInput.Text = math.clamp(math.floor(hsv.R * 255), 0, 255)
					GInput.Text = math.clamp(math.floor(hsv.G * 255), 0, 255)
					BInput.Text = math.clamp(math.floor(hsv.B * 255), 0, 255)

					ColorSaturation.BackgroundColor3 = hsv
					Color.BackgroundColor3 = hsv
					
					callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))	
				end
				
				local function updatesatval(input)
					local sizeX = math.clamp((input.Position.X - ColorSaturation.AbsolutePosition.X) / ColorSaturation.AbsoluteSize.X, 0, 1)
					local sizeY = 1 - math.clamp((input.Position.Y - ColorSaturation.AbsolutePosition.Y) / ColorSaturation.AbsoluteSize.Y, 0, 1)
					local posY = math.clamp(((input.Position.Y - ColorSaturation.AbsolutePosition.Y) / ColorSaturation.AbsoluteSize.Y) * ColorSaturation.AbsoluteSize.Y, 0, ColorSaturation.AbsoluteSize.Y - 4)
					local posX = math.clamp(((input.Position.X - ColorSaturation.AbsolutePosition.X) / ColorSaturation.AbsoluteSize.X) * ColorSaturation.AbsoluteSize.X, 0, ColorSaturation.AbsoluteSize.X - 4)

					SaturationPicker.Position = UDim2.new(0, posX, 0, posY)

					sat = sizeX
					val = sizeY
					hsv = Color3.fromHSV(hue, sizeX, sizeY)

					RInput.Text = math.clamp(math.floor(hsv.R * 255), 0, 255)
					GInput.Text = math.clamp(math.floor(hsv.G * 255), 0, 255)
					BInput.Text = math.clamp(math.floor(hsv.B * 255), 0, 255)

					Color.BackgroundColor3 = hsv

					callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))	
				end
				
				local function set(color)
					if type(color) == "table" then
						color = Color3.fromRGB(unpack(color))
					end

					hue, sat, val = color:ToHSV()
					hsv = Color3.fromHSV(hue, sat, val)

					Color.BackgroundColor3 = hsv
					ColorSaturation.BackgroundColor3 = hsv
					SaturationPicker.Position = UDim2.new(0, (math.clamp(sat * ColorSaturation.AbsoluteSize.X, 0, ColorSaturation.AbsoluteSize.X - 4)), 0, (math.clamp((1 - val) * ColorSaturation.AbsoluteSize.Y, 0, ColorSaturation.AbsoluteSize.Y - 4)))
					huepicker.Position = UDim2.new(0, 0, 0, math.clamp((1 - hue) * ColorSaturation.AbsoluteSize.Y, 0, ColorSaturation.AbsoluteSize.Y - 4))

					RInput.Text = math.clamp(math.floor(hsv.R * 255), 0, 255)
					GInput.Text = math.clamp(math.floor(hsv.G * 255), 0, 255)
					BInput.Text = math.clamp(math.floor(hsv.B * 255), 0, 255)

					callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
				end
				
				set(default)
				
				ColorSaturation.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						slidingSaturation = true
						updatesatval(input)
					end
				end)

				ColorSaturation.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						slidingSaturation = false
					end
				end)

				game.UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if slidingSaturation then
							updatesatval(input)
						end
					end
				end)
				
				HUEF.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						slidingHue = true
						updatehue(input)
					end
				end)

				HUEF.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						slidingHue = false
					end
				end)
				
				game.UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if slidingHue then
							updatehue(input)
						end
					end
				end)
				
				funcs.SetColor = function(self,color)
					set(color)
				end
				
				return funcs
			end
			return SectionHolder
		end
		return Sections
	end
	return Tabs
end
return Library

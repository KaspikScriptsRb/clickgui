local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer

local clickGui = {
	open = true,
	toggleKey = Enum.KeyCode.RightShift,
	activeTab = 1,
	tabs = {},
	notifications = {},
	favorites = {},
	modules = {},
	keybindsHud = nil
}

local theme = {
	bg = Color3.fromRGB(15, 16, 22),
	topbar = Color3.fromRGB(12, 13, 19),
	tabBar = Color3.fromRGB(18, 20, 28),
	card = Color3.fromRGB(22, 24, 33),
	cardBorder = Color3.fromRGB(44, 49, 66),
	cardBorderHover = Color3.fromRGB(68, 76, 102),
	element = Color3.fromRGB(28, 31, 43),
	elementHover = Color3.fromRGB(36, 41, 56),
	dropdownBg = Color3.fromRGB(20, 22, 31),
	dropdownItemHover = Color3.fromRGB(28, 32, 45),
	dropdownItemSelected = Color3.fromRGB(34, 39, 54),
	accent = Color3.fromRGB(124, 92, 252),
	accentLight = Color3.fromRGB(155, 135, 252),
	accentHover = Color3.fromRGB(145, 115, 255),
	text = Color3.fromRGB(245, 246, 252),
	textMuted = Color3.fromRGB(170, 175, 192),
	textDesc = Color3.fromRGB(125, 132, 154),
	textDark = Color3.fromRGB(85, 90, 112),
	switchOff = Color3.fromRGB(40, 44, 60),
	switchKnob = Color3.fromRGB(255, 255, 255),
	starActive = Color3.fromRGB(255, 208, 66),
	starInactive = Color3.fromRGB(80, 86, 108),
	sliderTrack = Color3.fromRGB(34, 38, 52),
	green = Color3.fromRGB(80, 220, 120),
	red = Color3.fromRGB(240, 75, 75)
}

local fonts = {
	bold = Enum.Font.GothamBold,
	medium = Enum.Font.GothamMedium,
	regular = Enum.Font.Gotham
}

local lucideSprites = {
	["swords"] = {16898787671, {256, 256}, {514, 514}},
	["sword"] = {16898787671, {256, 256}, {257, 514}},
	["feather"] = {16898669897, {256, 256}, {0, 514}},
	["user"] = {16898790259, {256, 256}, {0, 0}},
	["users"] = {16898790259, {256, 256}, {514, 0}},
	["eye"] = {16898669897, {256, 256}, {0, 0}},
	["globe"] = {16898672599, {256, 256}, {257, 257}},
	["folder"] = {16898671684, {256, 256}, {257, 0}},
	["settings"] = {16898734421, {256, 256}, {514, 0}},
	["sliders"] = {16898735040, {256, 256}, {257, 257}},
	["sliders-horizontal"] = {16898735040, {256, 256}, {0, 257}},
	["volume"] = {16898790615, {256, 256}, {514, 0}},
	["volume-1"] = {16898790615, {256, 256}, {0, 0}},
	["volume-2"] = {16898790615, {256, 256}, {257, 0}},
	["speaker"] = {16898735455, {256, 256}, {0, 0}},
	["star"] = {16898736776, {256, 256}, {257, 0}},
	["key"] = {16898673616, {256, 256}, {514, 514}},
	["keyboard"] = {16898673794, {256, 256}, {257, 0}},
	["list-filter"] = {16898674482, {256, 256}, {514, 514}},
	["filter"] = {16898670775, {256, 256}, {0, 0}},
	["check"] = {16898617411, {256, 256}, {257, 0}},
	["x"] = {16898791349, {256, 256}, {257, 0}},
	["arrow-right"] = {16898614275, {256, 256}, {514, 0}},
	["chevron-down"] = {16898617411, {256, 256}, {514, 257}},
	["chevron-up"] = {16898617509, {256, 256}, {514, 514}},
	["chevron-left"] = {16898617509, {256, 256}, {0, 257}},
	["chevron-right"] = {16898617509, {256, 256}, {0, 514}},
	["columns"] = {16898619182, {256, 256}, {257, 257}},
	["split"] = {16898735455, {256, 256}, {257, 514}},
	["search"] = {16898734242, {256, 256}, {257, 0}},
	["languages"] = {16898673999, {256, 256}, {257, 0}},
	["bell"] = {16898615428, {256, 256}, {0, 514}},
	["layout-grid"] = {16898674182, {256, 256}, {514, 0}},
	["box"] = {16898616650, {256, 256}, {0, 514}},
	["diamond"] = {16898669042, {256, 256}, {257, 0}},
	["rhombus"] = {16898669042, {256, 256}, {257, 0}},
	["gem"] = {16898672166, {256, 256}, {257, 514}},
	["sparkles"] = {16898735175, {256, 256}, {514, 514}},
	["shield"] = {16898734664, {256, 256}, {257, 0}},
	["zap"] = {16898791349, {256, 256}, {257, 257}},
	["crosshair"] = {16898668482, {256, 256}, {514, 257}},
	["target"] = {16898788248, {256, 256}, {257, 0}},
	["bot"] = {16898616650, {256, 256}, {514, 0}},
	["flame"] = {16898670919, {256, 256}, {0, 257}},
	["heart"] = {16898673271, {256, 256}, {0, 0}},
	["lock"] = {16898674825, {256, 256}, {0, 257}},
	["trash"] = {16898789012, {256, 256}, {514, 0}},
	["palette"] = {16898734421, {256, 256}, {257, 514}},
	["scroll"] = {16898734065, {256, 256}, {0, 514}},
	["scroll-text"] = {16898734065, {256, 256}, {257, 257}},
	["activity"] = {16898612629, {256, 256}, {0, 514}},
	["repeat"] = {16898734242, {256, 256}, {514, 514}},
	["type"] = {16898788461, {256, 256}, {514, 257}},
	["info"] = {16898673434, {256, 256}, {257, 514}},
	["layers"] = {16898674291, {256, 256}, {257, 0}}
}

function clickGui.applyIcon(imageObj, iconName)
	if not iconName or iconName == "" then
		iconName = "box"
	end

	if type(iconName) == "number" or string.match(tostring(iconName), "^%d+$") then
		imageObj.Image = "rbxassetid://" .. tostring(iconName)
		imageObj.ImageRectOffset = Vector2.new(0, 0)
		imageObj.ImageRectSize = Vector2.new(0, 0)
		return
	end

	local str = tostring(iconName)
	if string.sub(str, 1, 13) == "rbxassetid://" or string.sub(str, 1, 4) == "http" then
		imageObj.Image = str
		imageObj.ImageRectOffset = Vector2.new(0, 0)
		imageObj.ImageRectSize = Vector2.new(0, 0)
		return
	end

	local clean = string.lower(str)
	if string.sub(clean, 1, 7) == "lucide:" then
		clean = string.sub(clean, 8)
	end

	local spriteData = lucideSprites[clean]
	if spriteData then
		imageObj.Image = "rbxassetid://" .. tostring(spriteData[1])
		imageObj.ImageRectSize = Vector2.new(spriteData[2][1], spriteData[2][2])
		imageObj.ImageRectOffset = Vector2.new(spriteData[3][1], spriteData[3][2])
	else
		imageObj.Image = "rbxassetid://16898616650"
		imageObj.ImageRectSize = Vector2.new(256, 256)
		imageObj.ImageRectOffset = Vector2.new(0, 514)
	end
end

local function tween(object, info, properties)
	local tw = TweenService:Create(object, info, properties)
	tw:Play()
	return tw
end

local function makeDraggable(topbar, main)
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		local targetPos = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
		TweenService:Create(main, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			Position = targetPos
		}):Play()
	end

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function clickGui:CreateWindow(config)
	config = config or {}
	local logoIcon = config.logo or "diamond"
	local defaultToggleKey = config.toggleKey or Enum.KeyCode.RightShift

	clickGui.toggleKey = defaultToggleKey

	if _G.ClickGuiWindowInstance then
		pcall(function()
			_G.ClickGuiWindowInstance:Destroy()
		end)
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ClickGui_" .. math.random(1000, 9999)
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local getHui = gethui or function()
		return CoreGui
	end

	local success, _ = pcall(function()
		screenGui.Parent = getHui()
	end)
	if not success then
		screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
	end

	_G.ClickGuiWindowInstance = screenGui

	local notifyContainer = Instance.new("Frame")
	notifyContainer.Name = "NotifyContainer"
	notifyContainer.Size = UDim2.new(0, 270, 0, 300)
	notifyContainer.AnchorPoint = Vector2.new(0.5, 0)
	notifyContainer.Position = UDim2.new(0.5, 0, 0.65, 0)
	notifyContainer.BackgroundTransparency = 1
	notifyContainer.ZIndex = 5
	notifyContainer.Parent = screenGui

	local notifyLayout = Instance.new("UIListLayout")
	notifyLayout.FillDirection = Enum.FillDirection.Vertical
	notifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	notifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	notifyLayout.Padding = UDim.new(0, 6)
	notifyLayout.Parent = notifyContainer

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 900, 0, 540)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.BackgroundColor3 = theme.bg
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = false
	mainFrame.ZIndex = 20
	mainFrame.Parent = screenGui

	local mainScale = Instance.new("UIScale")
	mainScale.Scale = 1
	mainScale.Parent = mainFrame

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 10)
	mainCorner.Parent = mainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = theme.cardBorder
	mainStroke.Thickness = 1
	mainStroke.Parent = mainFrame

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 48)
	topBar.BackgroundColor3 = theme.topbar
	topBar.BorderSizePixel = 0
	topBar.ZIndex = 21
	topBar.Parent = mainFrame

	local topBarCorner = Instance.new("UICorner")
	topBarCorner.CornerRadius = UDim.new(0, 10)
	topBarCorner.Parent = topBar

	local topBarBottomCover = Instance.new("Frame")
	topBarBottomCover.Size = UDim2.new(1, 0, 0, 10)
	topBarBottomCover.Position = UDim2.new(0, 0, 1, -10)
	topBarBottomCover.BackgroundColor3 = theme.topbar
	topBarBottomCover.BorderSizePixel = 0
	topBarBottomCover.ZIndex = 21
	topBarBottomCover.Parent = topBar

	local topBarBorder = Instance.new("Frame")
	topBarBorder.Size = UDim2.new(1, 0, 0, 1)
	topBarBorder.Position = UDim2.new(0, 0, 1, 0)
	topBarBorder.BackgroundColor3 = theme.cardBorder
	topBarBorder.BorderSizePixel = 0
	topBarBorder.ZIndex = 22
	topBarBorder.Parent = topBar

	makeDraggable(topBar, mainFrame)

	local logoContainer = Instance.new("Frame")
	logoContainer.Name = "LogoContainer"
	logoContainer.Size = UDim2.new(0, 48, 1, 0)
	logoContainer.BackgroundTransparency = 1
	logoContainer.ZIndex = 22
	logoContainer.Parent = topBar

	local logoImage = Instance.new("ImageLabel")
	logoImage.Size = UDim2.new(0, 18, 0, 18)
	logoImage.Position = UDim2.new(0, 18, 0.5, -9)
	logoImage.BackgroundTransparency = 1
	clickGui.applyIcon(logoImage, logoIcon)
	logoImage.ImageColor3 = theme.accent
	logoImage.ZIndex = 22
	logoImage.Parent = logoContainer

	local tabList = Instance.new("Frame")
	tabList.Name = "TabList"
	tabList.Size = UDim2.new(0, 350, 0, 30)
	tabList.Position = UDim2.new(0.5, -175, 0.5, -15)
	tabList.BackgroundColor3 = theme.tabBar
	tabList.BorderSizePixel = 0
	tabList.ZIndex = 22
	tabList.Parent = topBar

	local tabListCorner = Instance.new("UICorner")
	tabListCorner.CornerRadius = UDim.new(0, 6)
	tabListCorner.Parent = tabList

	local tabListStroke = Instance.new("UIStroke")
	tabListStroke.Color = theme.cardBorder
	tabListStroke.Thickness = 1
	tabListStroke.Parent = tabList

	local tabListLayout = Instance.new("UIListLayout")
	tabListLayout.FillDirection = Enum.FillDirection.Horizontal
	tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabListLayout.Padding = UDim.new(0, 2)
	tabListLayout.Parent = tabList

	local contentContainer = Instance.new("Frame")
	contentContainer.Name = "ContentContainer"
	contentContainer.Size = UDim2.new(1, -20, 1, -60)
	contentContainer.Position = UDim2.new(0, 10, 0, 52)
	contentContainer.BackgroundTransparency = 1
	contentContainer.ZIndex = 20
	contentContainer.Parent = mainFrame

	clickGui.gui = screenGui
	clickGui.mainFrame = mainFrame
	clickGui.tabList = tabList
	clickGui.contentContainer = contentContainer
	clickGui.notifyContainer = notifyContainer

	local isToggling = false
	local function setGuiState(targetState)
		if isToggling then return end
		isToggling = true
		clickGui.open = targetState

		if targetState then
			mainFrame.Visible = true
			mainScale.Scale = 0.8
			local tw = tween(mainScale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Scale = 1
			})
			tw.Completed:Connect(function()
				isToggling = false
			end)
		else
			local tw = tween(mainScale, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				Scale = 0.8
			})
			tw.Completed:Connect(function()
				if not clickGui.open then
					mainFrame.Visible = false
				end
				isToggling = false
			end)
		end
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == clickGui.toggleKey then
			setGuiState(not clickGui.open)
		end
	end)

	local bindsHudFrame = Instance.new("Frame")
	bindsHudFrame.Name = "KeybindsHUD"
	bindsHudFrame.Size = UDim2.new(0, 190, 0, 32)
	bindsHudFrame.Position = UDim2.new(0, 20, 0, 120)
	bindsHudFrame.BackgroundColor3 = theme.card
	bindsHudFrame.BorderSizePixel = 0
	bindsHudFrame.ClipsDescendants = true
	bindsHudFrame.Visible = true
	bindsHudFrame.ZIndex = 5
	bindsHudFrame.Parent = screenGui

	local hudCorner = Instance.new("UICorner")
	hudCorner.CornerRadius = UDim.new(0, 8)
	hudCorner.Parent = bindsHudFrame

	local hudStroke = Instance.new("UIStroke")
	hudStroke.Color = theme.cardBorder
	hudStroke.Thickness = 1
	hudStroke.Parent = bindsHudFrame

	local hudTop = Instance.new("Frame")
	hudTop.Name = "HudTop"
	hudTop.Size = UDim2.new(1, 0, 0, 32)
	hudTop.BackgroundColor3 = theme.topbar
	hudTop.BorderSizePixel = 0
	hudTop.ZIndex = 10
	hudTop.Parent = bindsHudFrame

	local hudTopCorner = Instance.new("UICorner")
	hudTopCorner.CornerRadius = UDim.new(0, 8)
	hudTopCorner.Parent = hudTop

	makeDraggable(hudTop, bindsHudFrame)

	local hudIcon = Instance.new("ImageLabel")
	hudIcon.Size = UDim2.new(0, 16, 0, 16)
	hudIcon.Position = UDim2.new(0, 10, 0.5, -8)
	hudIcon.BackgroundTransparency = 1
	clickGui.applyIcon(hudIcon, "keyboard")
	hudIcon.ImageColor3 = theme.accent
	hudIcon.ZIndex = 11
	hudIcon.Parent = hudTop

	local hudTitle = Instance.new("TextLabel")
	hudTitle.Size = UDim2.new(1, -36, 1, 0)
	hudTitle.Position = UDim2.new(0, 32, 0, 0)
	hudTitle.BackgroundTransparency = 1
	hudTitle.Font = fonts.bold
	hudTitle.Text = "Keybinds"
	hudTitle.TextColor3 = theme.text
	hudTitle.TextSize = 13
	hudTitle.TextXAlignment = Enum.TextXAlignment.Left
	hudTitle.ZIndex = 11
	hudTitle.Parent = hudTop

	local hudList = Instance.new("Frame")
	hudList.Name = "List"
	hudList.Size = UDim2.new(1, 0, 0, 0)
	hudList.Position = UDim2.new(0, 0, 0, 32)
	hudList.BackgroundTransparency = 1
	hudList.ClipsDescendants = true
	hudList.ZIndex = 6
	hudList.Parent = bindsHudFrame

	local hudListLayout = Instance.new("UIListLayout")
	hudListLayout.FillDirection = Enum.FillDirection.Vertical
	hudListLayout.Padding = UDim.new(0, 3)
	hudListLayout.Parent = hudList

	local hudListPadding = Instance.new("UIPadding")
	hudListPadding.PaddingTop = UDim.new(0, 4)
	hudListPadding.PaddingBottom = UDim.new(0, 6)
	hudListPadding.PaddingLeft = UDim.new(0, 10)
	hudListPadding.PaddingRight = UDim.new(0, 10)
	hudListPadding.Parent = hudList

	local hudRows = {}

	local function refreshHud()
		local activeBoundModules = {}
		for _, mod in ipairs(clickGui.modules) do
			if mod.bind and mod.bind ~= Enum.KeyCode.None and mod.state == true then
				table.insert(activeBoundModules, mod)
			end
		end

		for modName, row in pairs(hudRows) do
			local stillActive = false
			for _, m in ipairs(activeBoundModules) do
				if m.name == modName then
					stillActive = true
					break
				end
			end
			if not stillActive then
				hudRows[modName] = nil
				if row and row.Parent then
					local nameLbl = row:FindFirstChild("Name")
					local bindStateLbl = row:FindFirstChild("BindState")
					if nameLbl then
						tween(nameLbl, TweenInfo.new(0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1})
					end
					if bindStateLbl then
						tween(bindStateLbl, TweenInfo.new(0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1})
					end
					local tw = tween(row, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
						Size = UDim2.new(1, 0, 0, 0)
					})
					tw.Completed:Connect(function()
						row:Destroy()
					end)
				end
			end
		end

		local activeCount = #activeBoundModules

		for _, mod in ipairs(activeBoundModules) do
			local row = hudRows[mod.name]
			if not row or not row.Parent then
				row = Instance.new("Frame")
				row.Name = "Row_" .. mod.name
				row.Size = UDim2.new(1, 0, 0, 0)
				row.BackgroundTransparency = 1
				row.ClipsDescendants = true
				row.ZIndex = 7
				row.Parent = hudList

				local nameLbl = Instance.new("TextLabel")
				nameLbl.Name = "Name"
				nameLbl.Size = UDim2.new(1, -55, 1, 0)
				nameLbl.BackgroundTransparency = 1
				nameLbl.Font = fonts.medium
				nameLbl.Text = mod.name
				nameLbl.TextColor3 = theme.text
				nameLbl.TextSize = 12
				nameLbl.TextXAlignment = Enum.TextXAlignment.Left
				nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
				nameLbl.ZIndex = 8
				nameLbl.Parent = row

				local bindStateLbl = Instance.new("TextLabel")
				bindStateLbl.Name = "BindState"
				bindStateLbl.Size = UDim2.new(0, 55, 1, 0)
				bindStateLbl.Position = UDim2.new(1, -55, 0, 0)
				bindStateLbl.BackgroundTransparency = 1
				bindStateLbl.Font = fonts.bold
				bindStateLbl.Text = mod.bind.Name
				bindStateLbl.TextColor3 = theme.accentLight
				bindStateLbl.TextSize = 11
				bindStateLbl.TextXAlignment = Enum.TextXAlignment.Right
				bindStateLbl.ZIndex = 8
				bindStateLbl.Parent = row

				hudRows[mod.name] = row

				tween(row, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, 0, 0, 20)
				})
			else
				tween(row, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, 0, 0, 20)
				})
				local bindStateLbl = row:FindFirstChild("BindState")
				if bindStateLbl then
					bindStateLbl.Text = mod.bind.Name
				end
			end
		end

		local targetTotalH = (activeCount > 0) and (32 + (activeCount * 23) + 10) or 32
		tween(bindsHudFrame, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 190, 0, targetTotalH)
		})
		tween(hudList, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, math.max(0, targetTotalH - 32))
		})
	end

	clickGui.refreshBindsHud = refreshHud

	local window = {
		tabs = {}
	}

	function window:AddTab(tabConfig)
		tabConfig = tabConfig or {}
		local tabName = tabConfig.name or "Tab"
		local tabIcon = tabConfig.icon or "box"
		local tabIndex = #self.tabs + 1

		local tabButton = Instance.new("TextButton")
		tabButton.Name = "TabButton_" .. tabName
		tabButton.Size = UDim2.new(0, 42, 0, 26)
		tabButton.BackgroundTransparency = 1
		tabButton.Text = ""
		tabButton.AutoButtonColor = false
		tabButton.ZIndex = 23
		tabButton.Parent = tabList

		local tabIconImage = Instance.new("ImageLabel")
		tabIconImage.Size = UDim2.new(0, 16, 0, 16)
		tabIconImage.Position = UDim2.new(0.5, -8, 0.5, -8)
		tabIconImage.BackgroundTransparency = 1
		clickGui.applyIcon(tabIconImage, tabIcon)
		tabIconImage.ImageColor3 = (tabIndex == 1) and theme.accent or theme.textDark
		tabIconImage.ZIndex = 24
		tabIconImage.Parent = tabButton

		local activeLine = Instance.new("Frame")
		activeLine.Name = "ActiveLine"
		activeLine.Size = (tabIndex == 1) and UDim2.new(0, 14, 0, 2) or UDim2.new(0, 0, 0, 2)
		activeLine.Position = UDim2.new(0.5, -7, 1, -2)
		activeLine.BackgroundColor3 = theme.accent
		activeLine.BorderSizePixel = 0
		activeLine.Visible = (tabIndex == 1)
		activeLine.ZIndex = 24
		activeLine.Parent = tabButton

		local lineCorner = Instance.new("UICorner")
		lineCorner.CornerRadius = UDim.new(1, 0)
		lineCorner.Parent = activeLine

		local tabPage = Instance.new("ScrollingFrame")
		tabPage.Name = "TabPage_" .. tabName
		tabPage.Size = UDim2.new(1, 0, 1, 0)
		tabPage.BackgroundTransparency = 1
		tabPage.BorderSizePixel = 0
		tabPage.ScrollBarThickness = 2
		tabPage.ScrollBarImageColor3 = theme.accent
		tabPage.Visible = (tabIndex == 1)
		tabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
		tabPage.ZIndex = 21
		tabPage.Parent = contentContainer

		local columnsContainer = Instance.new("Frame")
		columnsContainer.Name = "Columns"
		columnsContainer.Size = UDim2.new(1, 0, 0, 0)
		columnsContainer.AutomaticSize = Enum.AutomaticSize.Y
		columnsContainer.BackgroundTransparency = 1
		columnsContainer.ZIndex = 21
		columnsContainer.Parent = tabPage

		local colPadding = Instance.new("UIPadding")
		colPadding.PaddingLeft = UDim.new(0, 4)
		colPadding.PaddingRight = UDim.new(0, 4)
		colPadding.PaddingTop = UDim.new(0, 4)
		colPadding.PaddingBottom = UDim.new(0, 16)
		colPadding.Parent = columnsContainer

		local totalUsableWidth = 900 - 20 - 8
		local gap = 12
		local columnWidth = math.floor((totalUsableWidth - (gap * 2)) / 3)

		local columns = {}
		for colIdx = 1, 3 do
			local col = Instance.new("Frame")
			col.Name = "Column_" .. colIdx
			col.Size = UDim2.new(0, columnWidth, 1, 0)
			col.Position = UDim2.new(0, (colIdx - 1) * (columnWidth + gap), 0, 0)
			col.BackgroundTransparency = 1
			col.AutomaticSize = Enum.AutomaticSize.Y
			col.ZIndex = 21
			col.Parent = columnsContainer

			local colLayout = Instance.new("UIListLayout")
			colLayout.FillDirection = Enum.FillDirection.Vertical
			colLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			colLayout.SortOrder = Enum.SortOrder.LayoutOrder
			colLayout.Padding = UDim.new(0, 12)
			colLayout.Parent = col

			columns[colIdx] = col
		end

		local tabObject = {
			name = tabName,
			button = tabButton,
			iconImage = tabIconImage,
			activeLine = activeLine,
			page = tabPage,
			columns = columns,
			nextColumn = 1
		}

		local function selectTab()
			for _, otherTab in ipairs(window.tabs) do
				otherTab.page.Visible = false
				tween(otherTab.activeLine, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 2)})
				otherTab.activeLine.Visible = false
				tween(otherTab.iconImage, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageColor3 = theme.textDark})
			end
			tabPage.Visible = true
			activeLine.Visible = true
			tween(activeLine, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 14, 0, 2)})
			tween(tabIconImage, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageColor3 = theme.accent})
			clickGui.activeTab = tabIndex
		end

		tabButton.MouseButton1Click:Connect(selectTab)
		tabButton.MouseEnter:Connect(function()
			if clickGui.activeTab ~= tabIndex then
				tween(tabIconImage, TweenInfo.new(0.15), {ImageColor3 = theme.text})
			end
		end)
		tabButton.MouseLeave:Connect(function()
			if clickGui.activeTab ~= tabIndex then
				tween(tabIconImage, TweenInfo.new(0.15), {ImageColor3 = theme.textDark})
			end
		end)

		function tabObject:AddModule(moduleConfig)
			moduleConfig = moduleConfig or {}
			local modName = moduleConfig.name or "Module"
			local modIcon = moduleConfig.icon or "scroll"
			local modState = moduleConfig.default or false
			local modBind = moduleConfig.keybind or Enum.KeyCode.None
			local modFavorite = moduleConfig.favorite or false
			local targetColIndex = moduleConfig.column or tabObject.nextColumn
			local targetColumn = tabObject.columns[targetColIndex] or tabObject.columns[1]

			if not moduleConfig.column then
				tabObject.nextColumn = (tabObject.nextColumn % 3) + 1
			end

			local cardFrame = Instance.new("Frame")
			cardFrame.Name = "Card_" .. modName
			cardFrame.Size = UDim2.new(1, 0, 0, 0)
			cardFrame.BackgroundColor3 = theme.card
			cardFrame.BorderSizePixel = 0
			cardFrame.AutomaticSize = Enum.AutomaticSize.Y
			cardFrame.ZIndex = 22
			cardFrame.Parent = targetColumn

			local cardCorner = Instance.new("UICorner")
			cardCorner.CornerRadius = UDim.new(0, 8)
			cardCorner.Parent = cardFrame

			local cardStroke = Instance.new("UIStroke")
			cardStroke.Color = theme.cardBorder
			cardStroke.Thickness = 1
			cardStroke.Parent = cardFrame

			local cardPadding = Instance.new("UIPadding")
			cardPadding.PaddingTop = UDim.new(0, 11)
			cardPadding.PaddingBottom = UDim.new(0, 13)
			cardPadding.PaddingLeft = UDim.new(0, 12)
			cardPadding.PaddingRight = UDim.new(0, 12)
			cardPadding.Parent = cardFrame

			local cardLayout = Instance.new("UIListLayout")
			cardLayout.FillDirection = Enum.FillDirection.Vertical
			cardLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
			cardLayout.Padding = UDim.new(0, 9)
			cardLayout.Parent = cardFrame

			local itemOrder = 0

			local headerFrame = Instance.new("Frame")
			headerFrame.Name = "Header"
			headerFrame.Size = UDim2.new(1, 0, 0, 22)
			headerFrame.BackgroundTransparency = 1
			headerFrame.LayoutOrder = 0
			headerFrame.ZIndex = 23
			headerFrame.Parent = cardFrame

			local leftHeader = Instance.new("Frame")
			leftHeader.Name = "Left"
			leftHeader.Size = UDim2.new(1, -110, 1, 0)
			leftHeader.BackgroundTransparency = 1
			leftHeader.ZIndex = 23
			leftHeader.Parent = headerFrame

			local leftLayout = Instance.new("UIListLayout")
			leftLayout.FillDirection = Enum.FillDirection.Horizontal
			leftLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			leftLayout.Padding = UDim.new(0, 8)
			leftLayout.Parent = leftHeader

			local modIconLabel = Instance.new("ImageLabel")
			modIconLabel.Size = UDim2.new(0, 16, 0, 16)
			modIconLabel.BackgroundTransparency = 1
			clickGui.applyIcon(modIconLabel, modIcon)
			modIconLabel.ImageColor3 = theme.textMuted
			modIconLabel.ZIndex = 24
			modIconLabel.Parent = leftHeader

			local titleLabel = Instance.new("TextLabel")
			titleLabel.Size = UDim2.new(1, -26, 1, 0)
			titleLabel.BackgroundTransparency = 1
			titleLabel.Font = fonts.bold
			titleLabel.Text = modName
			titleLabel.TextColor3 = theme.text
			titleLabel.TextSize = 14
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
			titleLabel.ZIndex = 24
			titleLabel.Parent = leftHeader

			local rightHeader = Instance.new("Frame")
			rightHeader.Name = "Right"
			rightHeader.Size = UDim2.new(0, 110, 1, 0)
			rightHeader.Position = UDim2.new(1, -110, 0, 0)
			rightHeader.BackgroundTransparency = 1
			rightHeader.ZIndex = 23
			rightHeader.Parent = headerFrame

			local rightLayout = Instance.new("UIListLayout")
			rightLayout.FillDirection = Enum.FillDirection.Horizontal
			rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			rightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			rightLayout.Padding = UDim.new(0, 6)
			rightLayout.Parent = rightHeader

			local starBtn = Instance.new("ImageButton")
			starBtn.Size = UDim2.new(0, 15, 0, 15)
			starBtn.BackgroundTransparency = 1
			clickGui.applyIcon(starBtn, "star")
			starBtn.ImageColor3 = modFavorite and theme.starActive or theme.starInactive
			starBtn.ZIndex = 24
			starBtn.Parent = rightHeader

			starBtn.MouseButton1Click:Connect(function()
				modFavorite = not modFavorite
				if modFavorite then
					clickGui.favorites[modName] = true
				else
					clickGui.favorites[modName] = nil
				end
				tween(starBtn, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					ImageColor3 = modFavorite and theme.starActive or theme.starInactive
				})
			end)

			local bindBtn = Instance.new("TextButton")
			bindBtn.Size = UDim2.new(0, 48, 0, 19)
			bindBtn.BackgroundColor3 = theme.element
			bindBtn.Text = ""
			bindBtn.AutoButtonColor = false
			bindBtn.ZIndex = 24
			bindBtn.Parent = rightHeader

			local bindCorner = Instance.new("UICorner")
			bindCorner.CornerRadius = UDim.new(0, 4)
			bindCorner.Parent = bindBtn

			local bindStroke = Instance.new("UIStroke")
			bindStroke.Color = theme.cardBorder
			bindStroke.Thickness = 1
			bindStroke.Parent = bindBtn

			local bindIcon = Instance.new("ImageLabel")
			bindIcon.Size = UDim2.new(0, 12, 0, 12)
			bindIcon.Position = UDim2.new(0, 4, 0.5, -6)
			bindIcon.BackgroundTransparency = 1
			clickGui.applyIcon(bindIcon, "keyboard")
			bindIcon.ImageColor3 = theme.textMuted
			bindIcon.ZIndex = 25
			bindIcon.Parent = bindBtn

			local bindLabel = Instance.new("TextLabel")
			bindLabel.Size = UDim2.new(1, -16, 1, 0)
			bindLabel.Position = UDim2.new(0, 14, 0, 0)
			bindLabel.BackgroundTransparency = 1
			bindLabel.Font = fonts.medium
			bindLabel.Text = (modBind == Enum.KeyCode.None) and "None" or modBind.Name
			bindLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
			bindLabel.TextSize = 10
			bindLabel.TextXAlignment = Enum.TextXAlignment.Center
			bindLabel.TextTruncate = Enum.TextTruncate.AtEnd
			bindLabel.ZIndex = 25
			bindLabel.Parent = bindBtn

			local toggleSwitch = Instance.new("TextButton")
			toggleSwitch.Size = UDim2.new(0, 32, 0, 16)
			toggleSwitch.BackgroundColor3 = modState and theme.accent or theme.switchOff
			toggleSwitch.Text = ""
			toggleSwitch.AutoButtonColor = false
			toggleSwitch.ZIndex = 24
			toggleSwitch.Parent = rightHeader

			local switchCorner = Instance.new("UICorner")
			switchCorner.CornerRadius = UDim.new(1, 0)
			switchCorner.Parent = toggleSwitch

			local switchKnob = Instance.new("Frame")
			switchKnob.Size = UDim2.new(0, 12, 0, 12)
			switchKnob.Position = modState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
			switchKnob.BackgroundColor3 = theme.switchKnob
			switchKnob.BorderSizePixel = 0
			switchKnob.ZIndex = 25
			switchKnob.Parent = toggleSwitch

			local knobCorner = Instance.new("UICorner")
			knobCorner.CornerRadius = UDim.new(1, 0)
			knobCorner.Parent = switchKnob

			local moduleObject = {
				name = modName,
				state = modState,
				bind = modBind,
				card = cardFrame,
				callback = moduleConfig.callback or function() end
			}

			table.insert(clickGui.modules, moduleObject)

			local function setToggle(val, silent, fromKeybind)
				moduleObject.state = val
				local targetColor = val and theme.accent or theme.switchOff
				local targetKnobPos = val and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)

				tween(toggleSwitch, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor})
				tween(switchKnob, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetKnobPos})

				if not silent then
					local bName = (fromKeybind and moduleObject.bind ~= Enum.KeyCode.None) and moduleObject.bind.Name or nil
					clickGui:Notify({
						title = modName,
						content = "Module was " .. (val and "enabled." or "disabled."),
						duration = 2.5,
						icon = val and "check" or "x",
						accentColor = val and theme.green or theme.red,
						bindName = bName
					})
				end

				if clickGui.refreshBindsHud then
					clickGui.refreshBindsHud()
				end

				if not silent and moduleObject.callback then
					moduleObject.callback(val)
				end
			end

			toggleSwitch.MouseButton1Click:Connect(function()
				setToggle(not moduleObject.state, false, false)
			end)

			local function unbindKeyFromOthers(targetMod, key)
				if key == Enum.KeyCode.None then return end
				for _, otherMod in ipairs(clickGui.modules) do
					if otherMod ~= targetMod and otherMod.bind == key then
						otherMod.bind = Enum.KeyCode.None
						if otherMod.updateBindLabel then
							otherMod.updateBindLabel("None")
						end
						clickGui:Notify({
							title = "Keybind Replaced",
							content = otherMod.name .. " unbound (" .. key.Name .. " reassigned).",
							duration = 2.5,
							icon = "keyboard",
							accentColor = theme.accentLight
						})
					end
				end
			end

			moduleObject.updateBindLabel = function(txt)
				bindLabel.Text = txt
			end

			if modBind ~= Enum.KeyCode.None then
				unbindKeyFromOthers(moduleObject, modBind)
			end

			local isBinding = false
			bindBtn.MouseButton1Click:Connect(function()
				if isBinding then return end
				isBinding = true
				bindLabel.Text = "..."
				bindLabel.TextColor3 = theme.accent

				local conn
				conn = UserInputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Keyboard then
						if input.KeyCode == Enum.KeyCode.Escape then
							moduleObject.bind = Enum.KeyCode.None
							bindLabel.Text = "None"
						else
							unbindKeyFromOthers(moduleObject, input.KeyCode)
							moduleObject.bind = input.KeyCode
							bindLabel.Text = input.KeyCode.Name
							clickGui:Notify({
								title = "Keybind Set",
								content = moduleObject.name .. " bound to " .. input.KeyCode.Name .. ".",
								duration = 2,
								icon = "keyboard",
								accentColor = theme.accentLight
							})
						end
						bindLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
						isBinding = false
						conn:Disconnect()

						if clickGui.refreshBindsHud then
							clickGui.refreshBindsHud()
						end
					end
				end)
			end)

			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if gameProcessed then return end
				if moduleObject.bind ~= Enum.KeyCode.None and input.KeyCode == moduleObject.bind then
					setToggle(not moduleObject.state, false, true)
				end
			end)

			function moduleObject:SetBind(key)
				if key ~= Enum.KeyCode.None then
					unbindKeyFromOthers(moduleObject, key)
				end
				moduleObject.bind = key
				bindLabel.Text = (key == Enum.KeyCode.None) and "None" or key.Name
				if clickGui.refreshBindsHud then
					clickGui.refreshBindsHud()
				end
			end
			function moduleObject:GetBind()
				return moduleObject.bind
			end
			function moduleObject:Set(val, silent)
				setToggle(val, silent)
			end
			function moduleObject:Get()
				return moduleObject.state
			end
			function moduleObject:SetTitle(newTitle)
				titleLabel.Text = newTitle
				moduleObject.name = newTitle
				if clickGui.refreshBindsHud then clickGui.refreshBindsHud() end
			end

			function moduleObject:AddDropdown(opt)
				opt = opt or {}
				local dName = opt.name or ""
				local dDesc = opt.description or ""
				local dIcon = opt.icon or "list-filter"
				local dList = opt.options or {}
				local isMulti = opt.multi or false
				local dSelected = isMulti and (type(opt.default) == "table" and opt.default or {}) or (opt.default or dList[1] or "")
				local dCallback = opt.callback or function() end

				itemOrder = itemOrder + 1

				local ddContainer = Instance.new("Frame")
				ddContainer.Name = "Dropdown_" .. (dName ~= "" and dName or "Item")
				ddContainer.Size = UDim2.new(1, 0, 0, 0)
				ddContainer.BackgroundTransparency = 1
				ddContainer.LayoutOrder = itemOrder
				ddContainer.AutomaticSize = Enum.AutomaticSize.Y
				ddContainer.ZIndex = 23
				ddContainer.Parent = cardFrame

				local ddLayout = Instance.new("UIListLayout")
				ddLayout.FillDirection = Enum.FillDirection.Vertical
				ddLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ddLayout.Padding = UDim.new(0, 4)
				ddLayout.Parent = ddContainer

				local subOrder = 0
				local ddLabel, ddDescLabel

				if dName ~= "" then
					subOrder = subOrder + 1
					ddLabel = Instance.new("TextLabel")
					ddLabel.Size = UDim2.new(1, 0, 0, 16)
					ddLabel.BackgroundTransparency = 1
					ddLabel.Font = fonts.medium
					ddLabel.Text = dName
					ddLabel.TextColor3 = theme.text
					ddLabel.TextSize = 13
					ddLabel.TextXAlignment = Enum.TextXAlignment.Left
					ddLabel.LayoutOrder = subOrder
					ddLabel.ZIndex = 24
					ddLabel.Parent = ddContainer
				end

				if dDesc ~= "" then
					subOrder = subOrder + 1
					ddDescLabel = Instance.new("TextLabel")
					ddDescLabel.Size = UDim2.new(1, 0, 0, 14)
					ddDescLabel.BackgroundTransparency = 1
					ddDescLabel.Font = fonts.regular
					ddDescLabel.Text = dDesc
					ddDescLabel.TextColor3 = theme.textDesc
					ddDescLabel.TextSize = 11
					ddDescLabel.TextXAlignment = Enum.TextXAlignment.Left
					ddDescLabel.TextTruncate = Enum.TextTruncate.AtEnd
					ddDescLabel.LayoutOrder = subOrder
					ddDescLabel.ZIndex = 24
					ddDescLabel.Parent = ddContainer
				end

				subOrder = subOrder + 1
				local ddWrapper = Instance.new("Frame")
				ddWrapper.Name = "DropdownWrapper"
				ddWrapper.Size = UDim2.new(1, 0, 0, 28)
				ddWrapper.BackgroundColor3 = theme.element
				ddWrapper.BorderSizePixel = 0
				ddWrapper.ClipsDescendants = true
				ddWrapper.LayoutOrder = subOrder
				ddWrapper.ZIndex = 24
				ddWrapper.Parent = ddContainer

				local ddWrapperCorner = Instance.new("UICorner")
				ddWrapperCorner.CornerRadius = UDim.new(0, 6)
				ddWrapperCorner.Parent = ddWrapper

				local ddWrapperStroke = Instance.new("UIStroke")
				ddWrapperStroke.Color = theme.cardBorder
				ddWrapperStroke.Thickness = 1
				ddWrapperStroke.Parent = ddWrapper

				local ddBox = Instance.new("TextButton")
				ddBox.Size = UDim2.new(1, 0, 0, 28)
				ddBox.BackgroundTransparency = 1
				ddBox.Text = ""
				ddBox.AutoButtonColor = false
				ddBox.ZIndex = 25
				ddBox.Parent = ddWrapper

				local ddFilterIcon = Instance.new("ImageLabel")
				ddFilterIcon.Size = UDim2.new(0, 13, 0, 13)
				ddFilterIcon.Position = UDim2.new(0, 9, 0.5, -6)
				ddFilterIcon.BackgroundTransparency = 1
				clickGui.applyIcon(ddFilterIcon, dIcon)
				ddFilterIcon.ImageColor3 = theme.textDesc
				ddFilterIcon.ZIndex = 26
				ddFilterIcon.Parent = ddBox

				local ddValueLabel = Instance.new("TextLabel")
				ddValueLabel.Size = UDim2.new(1, -48, 1, 0)
				ddValueLabel.Position = UDim2.new(0, 28, 0, 0)
				ddValueLabel.BackgroundTransparency = 1
				ddValueLabel.Font = fonts.medium
				ddValueLabel.TextColor3 = theme.text
				ddValueLabel.TextSize = 12
				ddValueLabel.TextXAlignment = Enum.TextXAlignment.Left
				ddValueLabel.TextTruncate = Enum.TextTruncate.AtEnd
				ddValueLabel.ZIndex = 26
				ddValueLabel.Parent = ddBox

				local function getDisplayString()
					if isMulti then
						local activeList = {}
						for optK, isSel in pairs(dSelected) do
							if isSel then table.insert(activeList, optK) end
						end
						return (#activeList > 0) and table.concat(activeList, ", ") or "None"
					else
						return tostring(dSelected)
					end
				end

				ddValueLabel.Text = getDisplayString()

				local ddArrow = Instance.new("ImageLabel")
				ddArrow.Size = UDim2.new(0, 12, 0, 12)
				ddArrow.Position = UDim2.new(1, -18, 0.5, -6)
				ddArrow.BackgroundTransparency = 1
				clickGui.applyIcon(ddArrow, "chevron-down")
				ddArrow.ImageColor3 = theme.textDesc
				ddArrow.ZIndex = 26
				ddArrow.Parent = ddBox

				local ddListFrame = Instance.new("Frame")
				ddListFrame.Name = "OptionsList"
				ddListFrame.Size = UDim2.new(1, 0, 0, 0)
				ddListFrame.Position = UDim2.new(0, 0, 0, 28)
				ddListFrame.BackgroundTransparency = 1
				ddListFrame.BorderSizePixel = 0
				ddListFrame.ClipsDescendants = true
				ddListFrame.ZIndex = 25
				ddListFrame.Parent = ddWrapper

				local listLayout = Instance.new("UIListLayout")
				listLayout.FillDirection = Enum.FillDirection.Vertical
				listLayout.Padding = UDim.new(0, 2)
				listLayout.Parent = ddListFrame

				local listPadding = Instance.new("UIPadding")
				listPadding.PaddingTop = UDim.new(0, 4)
				listPadding.PaddingBottom = UDim.new(0, 4)
				listPadding.PaddingLeft = UDim.new(0, 4)
				listPadding.PaddingRight = UDim.new(0, 4)
				listPadding.Parent = ddListFrame

				local isOpen = false

				local function updateOptions()
					for _, child in ipairs(ddListFrame:GetChildren()) do
						if child:IsA("TextButton") then
							child:Destroy()
						end
					end

					for _, optionName in ipairs(dList) do
						local isSelected = isMulti and (dSelected[optionName] == true) or (optionName == dSelected)

						local optBtn = Instance.new("TextButton")
						optBtn.Size = UDim2.new(1, 0, 0, 24)
						optBtn.BackgroundColor3 = isSelected and theme.dropdownItemSelected or theme.element
						optBtn.BackgroundTransparency = isSelected and 0.15 or 1
						optBtn.Text = ""
						optBtn.AutoButtonColor = false
						optBtn.ZIndex = 26
						optBtn.Parent = ddListFrame

						local optCorner = Instance.new("UICorner")
						optCorner.CornerRadius = UDim.new(0, 4)
						optCorner.Parent = optBtn

						local optText = Instance.new("TextLabel")
						optText.Size = UDim2.new(1, -26, 1, 0)
						optText.Position = UDim2.new(0, 7, 0, 0)
						optText.BackgroundTransparency = 1
						optText.Font = fonts.medium
						optText.Text = tostring(optionName)
						optText.TextColor3 = isSelected and theme.text or theme.textDesc
						optText.TextSize = 12
						optText.TextXAlignment = Enum.TextXAlignment.Left
						optText.ZIndex = 27
						optText.Parent = optBtn

						local optCheck = Instance.new("ImageLabel")
						optCheck.Size = UDim2.new(0, 12, 0, 12)
						optCheck.Position = UDim2.new(1, -18, 0.5, -6)
						optCheck.BackgroundTransparency = 1
						clickGui.applyIcon(optCheck, "check")
						optCheck.ImageColor3 = theme.text
						optCheck.Visible = isSelected
						optCheck.ZIndex = 27
						optCheck.Parent = optBtn

						optBtn.MouseEnter:Connect(function()
							local curSel = isMulti and (dSelected[optionName] == true) or (optionName == dSelected)
							if not curSel then
								tween(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
									BackgroundTransparency = 0.3,
									BackgroundColor3 = theme.dropdownItemHover
								})
								tween(optText, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextColor3 = theme.text})
							end
						end)
						optBtn.MouseLeave:Connect(function()
							local curSel = isMulti and (dSelected[optionName] == true) or (optionName == dSelected)
							if not curSel then
								tween(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
									BackgroundTransparency = 1,
									BackgroundColor3 = theme.element
								})
								tween(optText, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextColor3 = theme.textDesc})
							end
						end)

						optBtn.MouseButton1Click:Connect(function()
							if isMulti then
								dSelected[optionName] = not dSelected[optionName]
								local isNowSelected = (dSelected[optionName] == true)
								ddValueLabel.Text = getDisplayString()

								if isNowSelected then
									tween(optBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
										BackgroundColor3 = theme.dropdownItemSelected,
										BackgroundTransparency = 0.15
									})
									tween(optText, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
										TextColor3 = theme.text
									})
									optCheck.Visible = true
									optCheck.Size = UDim2.new(0, 4, 0, 4)
									tween(optCheck, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
										Size = UDim2.new(0, 12, 0, 12)
									})
								else
									tween(optBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
										BackgroundColor3 = theme.element,
										BackgroundTransparency = 1
									})
									tween(optText, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
										TextColor3 = theme.textDesc
									})
									local checkTw = tween(optCheck, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
										Size = UDim2.new(0, 4, 0, 4)
									})
									checkTw.Completed:Connect(function()
										if not dSelected[optionName] then
											optCheck.Visible = false
										end
									end)
								end

								dCallback(dSelected)
							else
								dSelected = optionName
								ddValueLabel.Text = tostring(optionName)
								isOpen = false
								local targetListH = 0
								tween(ddListFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
									Size = UDim2.new(1, 0, 0, targetListH)
								})
								tween(ddWrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
									Size = UDim2.new(1, 0, 0, 28)
								})
								tween(ddArrow, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = 0})
								updateOptions()
								dCallback(optionName)
							end
						end)
					end
				end

				ddBox.MouseButton1Click:Connect(function()
					isOpen = not isOpen
					local targetListH = isOpen and (#dList * 26 + 8) or 0
					local targetWrapperH = isOpen and (28 + targetListH) or 28

					tween(ddListFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, targetListH)
					})
					tween(ddWrapper, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, targetWrapperH)
					})
					tween(ddArrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = isOpen and 180 or 0})
				end)

				ddBox.MouseEnter:Connect(function()
					tween(ddWrapperStroke, TweenInfo.new(0.15), {Color = theme.cardBorderHover})
				end)
				ddBox.MouseLeave:Connect(function()
					tween(ddWrapperStroke, TweenInfo.new(0.15), {Color = theme.cardBorder})
				end)

				updateOptions()

				local dropdownObj = {}
				function dropdownObj:Set(newVal)
					dSelected = newVal
					ddValueLabel.Text = getDisplayString()
					updateOptions()
					dCallback(newVal)
				end
				function dropdownObj:Get()
					return dSelected
				end
				function dropdownObj:SetOptions(newList)
					dList = newList
					updateOptions()
				end
				function dropdownObj:SetTitle(newTitle)
					if ddLabel then ddLabel.Text = newTitle end
				end
				function dropdownObj:SetDescription(newDesc)
					if ddDescLabel then ddDescLabel.Text = newDesc end
				end
				return dropdownObj
			end

			function moduleObject:AddMultiDropdown(opt)
				opt = opt or {}
				opt.multi = true
				return moduleObject:AddDropdown(opt)
			end

			function moduleObject:AddToggle(opt)
				opt = opt or {}
				local tName = opt.name or "Option"
				local tDesc = opt.description or ""
				local tState = opt.default or false
				local tCallback = opt.callback or function() end

				itemOrder = itemOrder + 1

				local toggleRow = Instance.new("Frame")
				toggleRow.Name = "Toggle_" .. tName
				toggleRow.Size = UDim2.new(1, 0, 0, tDesc ~= "" and 34 or 24)
				toggleRow.BackgroundTransparency = 1
				toggleRow.LayoutOrder = itemOrder
				toggleRow.ZIndex = 23
				toggleRow.Parent = cardFrame

				local textWrap = Instance.new("Frame")
				textWrap.Size = UDim2.new(1, -36, 1, 0)
				textWrap.BackgroundTransparency = 1
				textWrap.ZIndex = 23
				textWrap.Parent = toggleRow

				local textWrapLayout = Instance.new("UIListLayout")
				textWrapLayout.FillDirection = Enum.FillDirection.Vertical
				textWrapLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				textWrapLayout.Padding = UDim.new(0, 1)
				textWrapLayout.Parent = textWrap

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, 0, 0, 16)
				label.BackgroundTransparency = 1
				label.Font = fonts.medium
				label.Text = tName
				label.TextColor3 = theme.text
				label.TextSize = 13
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.ZIndex = 24
				label.Parent = textWrap

				local descLabel
				if tDesc ~= "" then
					descLabel = Instance.new("TextLabel")
					descLabel.Size = UDim2.new(1, 0, 0, 14)
					descLabel.BackgroundTransparency = 1
					descLabel.Font = fonts.regular
					descLabel.Text = tDesc
					descLabel.TextColor3 = theme.textDesc
					descLabel.TextSize = 11
					descLabel.TextXAlignment = Enum.TextXAlignment.Left
					descLabel.TextTruncate = Enum.TextTruncate.AtEnd
					descLabel.ZIndex = 24
					descLabel.Parent = textWrap
				end

				local miniSwitch = Instance.new("TextButton")
				miniSwitch.Size = UDim2.new(0, 26, 0, 14)
				miniSwitch.Position = UDim2.new(1, -26, 0.5, -7)
				miniSwitch.BackgroundColor3 = tState and theme.accent or theme.switchOff
				miniSwitch.Text = ""
				miniSwitch.AutoButtonColor = false
				miniSwitch.ZIndex = 24
				miniSwitch.Parent = toggleRow

				local switchCorner = Instance.new("UICorner")
				switchCorner.CornerRadius = UDim.new(1, 0)
				switchCorner.Parent = miniSwitch

				local switchKnob = Instance.new("Frame")
				switchKnob.Size = UDim2.new(0, 10, 0, 10)
				switchKnob.Position = tState and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
				switchKnob.BackgroundColor3 = theme.switchKnob
				switchKnob.BorderSizePixel = 0
				switchKnob.ZIndex = 25
				switchKnob.Parent = miniSwitch

				local knobCorner = Instance.new("UICorner")
				knobCorner.CornerRadius = UDim.new(1, 0)
				knobCorner.Parent = switchKnob

				local function updateToggle(val, silent)
					tState = val
					local targetColor = val and theme.accent or theme.switchOff
					local targetKnobPos = val and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)

					tween(miniSwitch, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor})
					tween(switchKnob, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetKnobPos})

					if not silent and tCallback then
						tCallback(val)
					end
				end

				miniSwitch.MouseButton1Click:Connect(function()
					updateToggle(not tState)
				end)

				local toggleObj = {}
				function toggleObj:Set(val, silent)
					updateToggle(val, silent)
				end
				function toggleObj:Get()
					return tState
				end
				function toggleObj:SetTitle(newTitle)
					label.Text = newTitle
				end
				function toggleObj:SetDescription(newDesc)
					if descLabel then descLabel.Text = newDesc end
				end
				return toggleObj
			end

			function moduleObject:AddSlider(opt)
				opt = opt or {}
				local sName = opt.name or "Slider"
				local sDesc = opt.description or ""
				local sMin = opt.min or 0
				local sMax = opt.max or 100
				local sDef = math.clamp(opt.default or sMin, sMin, sMax)
				local sSuffix = opt.suffix or ""
				local sDecimals = opt.decimals or 0
				local sCallback = opt.callback or function() end

				itemOrder = itemOrder + 1

				local sliderContainer = Instance.new("Frame")
				sliderContainer.Name = "Slider_" .. sName
				sliderContainer.Size = UDim2.new(1, 0, 0, sDesc ~= "" and 46 or 34)
				sliderContainer.BackgroundTransparency = 1
				sliderContainer.LayoutOrder = itemOrder
				sliderContainer.ZIndex = 23
				sliderContainer.Parent = cardFrame

				local headerRow = Instance.new("Frame")
				headerRow.Size = UDim2.new(1, 0, 0, 16)
				headerRow.BackgroundTransparency = 1
				headerRow.ZIndex = 23
				headerRow.Parent = sliderContainer

				local nameLabel = Instance.new("TextLabel")
				nameLabel.Size = UDim2.new(1, -75, 1, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.Font = fonts.medium
				nameLabel.Text = sName
				nameLabel.TextColor3 = theme.text
				nameLabel.TextSize = 13
				nameLabel.TextXAlignment = Enum.TextXAlignment.Left
				nameLabel.ZIndex = 24
				nameLabel.Parent = headerRow

				local valueLabel = Instance.new("TextLabel")
				valueLabel.Size = UDim2.new(0, 75, 1, 0)
				valueLabel.Position = UDim2.new(1, -75, 0, 0)
				valueLabel.BackgroundTransparency = 1
				valueLabel.Font = fonts.bold
				valueLabel.TextColor3 = theme.accentLight
				valueLabel.TextSize = 13
				valueLabel.TextXAlignment = Enum.TextXAlignment.Right
				valueLabel.ZIndex = 24
				valueLabel.Parent = headerRow

				local formatValue = function(val)
					if sDecimals > 0 then
						local formatted = string.format("%." .. sDecimals .. "f", val)
						return formatted .. sSuffix
					else
						return tostring(math.floor(val + 0.5)) .. sSuffix
					end
				end

				valueLabel.Text = formatValue(sDef)

				local descLabel
				local trackOffset = 24
				if sDesc ~= "" then
					descLabel = Instance.new("TextLabel")
					descLabel.Size = UDim2.new(1, 0, 0, 14)
					descLabel.Position = UDim2.new(0, 0, 0, 16)
					descLabel.BackgroundTransparency = 1
					descLabel.Font = fonts.regular
					descLabel.Text = sDesc
					descLabel.TextColor3 = theme.textDesc
					descLabel.TextSize = 11
					descLabel.TextXAlignment = Enum.TextXAlignment.Left
					descLabel.TextTruncate = Enum.TextTruncate.AtEnd
					descLabel.ZIndex = 24
					descLabel.Parent = sliderContainer

					trackOffset = 34
				end

				local track = Instance.new("TextButton")
				track.Size = UDim2.new(1, 0, 0, 4)
				track.Position = UDim2.new(0, 0, 0, trackOffset)
				track.BackgroundColor3 = theme.sliderTrack
				track.Text = ""
				track.AutoButtonColor = false
				track.ZIndex = 24
				track.Parent = sliderContainer

				local trackCorner = Instance.new("UICorner")
				trackCorner.CornerRadius = UDim.new(1, 0)
				trackCorner.Parent = track

				local initialPercent = (sDef - sMin) / (sMax - sMin)

				local fill = Instance.new("Frame")
				fill.Size = UDim2.new(initialPercent, 0, 1, 0)
				fill.BackgroundColor3 = theme.accent
				fill.BorderSizePixel = 0
				fill.ZIndex = 25
				fill.Parent = track

				local fillCorner = Instance.new("UICorner")
				fillCorner.CornerRadius = UDim.new(1, 0)
				fillCorner.Parent = fill

				local knob = Instance.new("Frame")
				knob.Size = UDim2.new(0, 10, 0, 10)
				knob.AnchorPoint = Vector2.new(0.5, 0.5)
				knob.Position = UDim2.new(initialPercent, 0, 0.5, 0)
				knob.BackgroundColor3 = theme.bg
				knob.BorderSizePixel = 0
				knob.ZIndex = 26
				knob.Parent = track

				local knobCorner = Instance.new("UICorner")
				knobCorner.CornerRadius = UDim.new(1, 0)
				knobCorner.Parent = knob

				local knobStroke = Instance.new("UIStroke")
				knobStroke.Color = theme.accent
				knobStroke.Thickness = 2
				knobStroke.Parent = knob

				local dragging = false
				local currentVal = sDef

				local function updateSlider(input, instant)
					local absPos = track.AbsolutePosition.X
					local absSize = track.AbsoluteSize.X
					local mouseX = input.Position.X
					local percent = math.clamp((mouseX - absPos) / absSize, 0, 1)
					local rawVal = sMin + (sMax - sMin) * percent
					local finalVal = sDecimals > 0 and tonumber(string.format("%." .. sDecimals .. "f", rawVal)) or math.floor(rawVal + 0.5)
					currentVal = finalVal

					if instant then
						fill.Size = UDim2.new(percent, 0, 1, 0)
						knob.Position = UDim2.new(percent, 0, 0.5, 0)
					else
						tween(fill, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
							Size = UDim2.new(percent, 0, 1, 0)
						})
						tween(knob, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
							Position = UDim2.new(percent, 0, 0.5, 0)
						})
					end

					valueLabel.Text = formatValue(finalVal)
					sCallback(finalVal)
				end

				track.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						tween(knob, TweenInfo.new(0.12), {Size = UDim2.new(0, 14, 0, 14)})
						tween(knobStroke, TweenInfo.new(0.12), {Thickness = 2, Color = theme.accentHover})
						tween(valueLabel, TweenInfo.new(0.12), {TextColor3 = theme.accentHover})
						updateSlider(input, false)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
						tween(knob, TweenInfo.new(0.12), {Size = UDim2.new(0, 10, 0, 10)})
						tween(knobStroke, TweenInfo.new(0.12), {Thickness = 2, Color = theme.accent})
						tween(valueLabel, TweenInfo.new(0.12), {TextColor3 = theme.accentLight})
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateSlider(input, false)
					end
				end)

				local sliderObj = {}
				function sliderObj:Set(val, silent)
					val = math.clamp(val, sMin, sMax)
					currentVal = val
					local percent = (val - sMin) / (sMax - sMin)
					tween(fill, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Size = UDim2.new(percent, 0, 1, 0)
					})
					tween(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Position = UDim2.new(percent, 0, 0.5, 0)
					})
					valueLabel.Text = formatValue(val)
					if not silent then sCallback(val) end
				end
				function sliderObj:Get()
					return currentVal
				end
				function sliderObj:SetMin(newMin)
					sMin = newMin
					sliderObj:Set(currentVal, true)
				end
				function sliderObj:SetMax(newMax)
					sMax = newMax
					sliderObj:Set(currentVal, true)
				end
				function sliderObj:SetTitle(newTitle)
					nameLabel.Text = newTitle
				end
				function sliderObj:SetDescription(newDesc)
					if descLabel then descLabel.Text = newDesc end
				end
				return sliderObj
			end

			function moduleObject:AddColorpicker(opt)
				opt = opt or {}
				local cpName = opt.name or "Color"
				local cpDesc = opt.description or ""
				local cpDef = opt.default or Color3.fromRGB(124, 92, 252)
				local cpCallback = opt.callback or function() end

				itemOrder = itemOrder + 1

				local cpContainer = Instance.new("Frame")
				cpContainer.Name = "Colorpicker_" .. cpName
				cpContainer.Size = UDim2.new(1, 0, 0, 0)
				cpContainer.BackgroundTransparency = 1
				cpContainer.LayoutOrder = itemOrder
				cpContainer.AutomaticSize = Enum.AutomaticSize.Y
				cpContainer.ZIndex = 23
				cpContainer.Parent = cardFrame

				local cpLayout = Instance.new("UIListLayout")
				cpLayout.FillDirection = Enum.FillDirection.Vertical
				cpLayout.SortOrder = Enum.SortOrder.LayoutOrder
				cpLayout.Padding = UDim.new(0, 4)
				cpLayout.Parent = cpContainer

				local headerRow = Instance.new("Frame")
				headerRow.Size = UDim2.new(1, 0, 0, cpDesc ~= "" and 34 or 24)
				headerRow.BackgroundTransparency = 1
				headerRow.LayoutOrder = 1
				headerRow.ZIndex = 23
				headerRow.Parent = cpContainer

				local textWrap = Instance.new("Frame")
				textWrap.Size = UDim2.new(1, -36, 1, 0)
				textWrap.BackgroundTransparency = 1
				textWrap.ZIndex = 23
				textWrap.Parent = headerRow

				local textWrapLayout = Instance.new("UIListLayout")
				textWrapLayout.FillDirection = Enum.FillDirection.Vertical
				textWrapLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				textWrapLayout.Padding = UDim.new(0, 1)
				textWrapLayout.Parent = textWrap

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, 0, 0, 16)
				label.BackgroundTransparency = 1
				label.Font = fonts.medium
				label.Text = cpName
				label.TextColor3 = theme.text
				label.TextSize = 13
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.ZIndex = 24
				label.Parent = textWrap

				local descLabel
				if cpDesc ~= "" then
					descLabel = Instance.new("TextLabel")
					descLabel.Size = UDim2.new(1, 0, 0, 14)
					descLabel.BackgroundTransparency = 1
					descLabel.Font = fonts.regular
					descLabel.Text = cpDesc
					descLabel.TextColor3 = theme.textDesc
					descLabel.TextSize = 11
					descLabel.TextXAlignment = Enum.TextXAlignment.Left
					descLabel.ZIndex = 24
					descLabel.Parent = textWrap
				end

				local previewBtn = Instance.new("TextButton")
				previewBtn.Size = UDim2.new(0, 24, 0, 14)
				previewBtn.Position = UDim2.new(1, -24, 0.5, -7)
				previewBtn.BackgroundColor3 = cpDef
				previewBtn.Text = ""
				previewBtn.AutoButtonColor = false
				previewBtn.ZIndex = 24
				previewBtn.Parent = headerRow

				local pCorner = Instance.new("UICorner")
				pCorner.CornerRadius = UDim.new(0, 4)
				pCorner.Parent = previewBtn

				local pStroke = Instance.new("UIStroke")
				pStroke.Color = theme.cardBorder
				pStroke.Thickness = 1
				pStroke.Parent = previewBtn

				local panel = Instance.new("Frame")
				panel.Name = "Panel"
				panel.Size = UDim2.new(1, 0, 0, 0)
				panel.BackgroundColor3 = theme.element
				panel.BorderSizePixel = 0
				panel.ClipsDescendants = true
				panel.LayoutOrder = 2
				panel.ZIndex = 24
				panel.Parent = cpContainer

				local panelCorner = Instance.new("UICorner")
				panelCorner.CornerRadius = UDim.new(0, 6)
				panelCorner.Parent = panel

				local panelStroke = Instance.new("UIStroke")
				panelStroke.Color = theme.cardBorder
				panelStroke.Thickness = 1
				panelStroke.Parent = panel

				local panelPad = Instance.new("UIPadding")
				panelPad.PaddingTop = UDim.new(0, 8)
				panelPad.PaddingBottom = UDim.new(0, 8)
				panelPad.PaddingLeft = UDim.new(0, 8)
				panelPad.PaddingRight = UDim.new(0, 8)
				panelPad.Parent = panel

				local panelLayout = Instance.new("UIListLayout")
				panelLayout.FillDirection = Enum.FillDirection.Vertical
				panelLayout.Padding = UDim.new(0, 6)
				panelLayout.Parent = panel

				local currentHue, currentSat, currentVal = Color3.toHSV(cpDef)
				local currentColor = cpDef

				local presetsRow = Instance.new("Frame")
				presetsRow.Size = UDim2.new(1, 0, 0, 16)
				presetsRow.BackgroundTransparency = 1
				presetsRow.ZIndex = 25
				presetsRow.Parent = panel

				local presetsLayout = Instance.new("UIListLayout")
				presetsLayout.FillDirection = Enum.FillDirection.Horizontal
				presetsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				presetsLayout.Padding = UDim.new(0, 6)
				presetsLayout.Parent = presetsRow

				local presetColors = {
					Color3.fromRGB(124, 92, 252),
					Color3.fromRGB(59, 130, 246),
					Color3.fromRGB(6, 182, 212),
					Color3.fromRGB(16, 185, 129),
					Color3.fromRGB(245, 158, 11),
					Color3.fromRGB(239, 68, 68),
					Color3.fromRGB(236, 72, 153),
					Color3.fromRGB(255, 255, 255)
				}

				local function applyColor(col, silent)
					currentColor = col
					currentHue, currentSat, currentVal = Color3.toHSV(col)
					previewBtn.BackgroundColor3 = col
					if not silent then cpCallback(col) end
				end

				for _, pCol in ipairs(presetColors) do
					local dot = Instance.new("TextButton")
					dot.Size = UDim2.new(0, 14, 0, 14)
					dot.BackgroundColor3 = pCol
					dot.Text = ""
					dot.AutoButtonColor = false
					dot.ZIndex = 26
					dot.Parent = presetsRow

					local dotCorner = Instance.new("UICorner")
					dotCorner.CornerRadius = UDim.new(1, 0)
					dotCorner.Parent = dot

					dot.MouseEnter:Connect(function()
						tween(dot, TweenInfo.new(0.15), {Size = UDim2.new(0, 16, 0, 16)})
					end)
					dot.MouseLeave:Connect(function()
						tween(dot, TweenInfo.new(0.15), {Size = UDim2.new(0, 14, 0, 14)})
					end)
					dot.MouseButton1Click:Connect(function()
						applyColor(pCol, false)
					end)
				end

				local hueTrack = Instance.new("TextButton")
				hueTrack.Size = UDim2.new(1, 0, 0, 8)
				hueTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				hueTrack.Text = ""
				hueTrack.AutoButtonColor = false
				hueTrack.ZIndex = 25
				hueTrack.Parent = panel

				local hueCorner = Instance.new("UICorner")
				hueCorner.CornerRadius = UDim.new(1, 0)
				hueCorner.Parent = hueTrack

				local hueGrad = Instance.new("UIGradient")
				hueGrad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0.0, Color3.fromHSV(0, 1, 1)),
					ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
					ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
					ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
					ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
					ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
					ColorSequenceKeypoint.new(1.0, Color3.fromHSV(1, 1, 1))
				})
				hueGrad.Parent = hueTrack

				local hueKnob = Instance.new("Frame")
				hueKnob.Size = UDim2.new(0, 10, 0, 10)
				hueKnob.AnchorPoint = Vector2.new(0.5, 0.5)
				hueKnob.Position = UDim2.new(currentHue, 0, 0.5, 0)
				hueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				hueKnob.ZIndex = 26
				hueKnob.Parent = hueTrack

				local hueKnobCorner = Instance.new("UICorner")
				hueKnobCorner.CornerRadius = UDim.new(1, 0)
				hueKnobCorner.Parent = hueKnob

				local valTrack = Instance.new("TextButton")
				valTrack.Size = UDim2.new(1, 0, 0, 8)
				valTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				valTrack.Text = ""
				valTrack.AutoButtonColor = false
				valTrack.ZIndex = 25
				valTrack.Parent = panel

				local valCorner = Instance.new("UICorner")
				valCorner.CornerRadius = UDim.new(1, 0)
				valCorner.Parent = valTrack

				local valGrad = Instance.new("UIGradient")
				valGrad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(currentHue, 1, 1))
				})
				valGrad.Parent = valTrack

				local valKnob = Instance.new("Frame")
				valKnob.Size = UDim2.new(0, 10, 0, 10)
				valKnob.AnchorPoint = Vector2.new(0.5, 0.5)
				valKnob.Position = UDim2.new(currentVal, 0, 0.5, 0)
				valKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				valKnob.ZIndex = 26
				valKnob.Parent = valTrack

				local valKnobCorner = Instance.new("UICorner")
				valKnobCorner.CornerRadius = UDim.new(1, 0)
				valKnobCorner.Parent = valKnob

				local draggingHue = false
				local draggingVal = false

				local function updateHue(input)
					local absPos = hueTrack.AbsolutePosition.X
					local absSize = hueTrack.AbsoluteSize.X
					local percent = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
					currentHue = percent
					hueKnob.Position = UDim2.new(percent, 0, 0.5, 0)
					valGrad.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
						ColorSequenceKeypoint.new(1, Color3.fromHSV(currentHue, 1, 1))
					})
					local newCol = Color3.fromHSV(currentHue, math.max(currentSat, 0.8), currentVal)
					applyColor(newCol, false)
				end

				local function updateVal(input)
					local absPos = valTrack.AbsolutePosition.X
					local absSize = valTrack.AbsoluteSize.X
					local percent = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
					currentVal = percent
					valKnob.Position = UDim2.new(percent, 0, 0.5, 0)
					local newCol = Color3.fromHSV(currentHue, math.max(currentSat, 0.8), currentVal)
					applyColor(newCol, false)
				end

				hueTrack.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						draggingHue = true
						updateHue(input)
					end
				end)

				valTrack.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						draggingVal = true
						updateVal(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						draggingHue = false
						draggingVal = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateHue(input)
					elseif draggingVal and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateVal(input)
					end
				end)

				local isOpen = false
				previewBtn.MouseButton1Click:Connect(function()
					isOpen = not isOpen
					local targetH = isOpen and 74 or 0
					tween(panel, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, targetH)
					})
					tween(pStroke, TweenInfo.new(0.2), {
						Color = isOpen and theme.accent or theme.cardBorder
					})
				end)

				local colorObj = {}
				function colorObj:Set(newCol, silent)
					applyColor(newCol, silent)
					hueKnob.Position = UDim2.new(currentHue, 0, 0.5, 0)
					valKnob.Position = UDim2.new(currentVal, 0, 0.5, 0)
				end
				function colorObj:Get()
					return currentColor
				end
				function colorObj:SetTitle(newTitle)
					label.Text = newTitle
				end
				function colorObj:SetDescription(newDesc)
					if descLabel then descLabel.Text = newDesc end
				end
				return colorObj
			end

			function moduleObject:AddTextBox(opt)
				opt = opt or {}
				local tbName = opt.name or "Input"
				local tbDesc = opt.description or ""
				local tbPlaceholder = opt.placeholder or "Type here..."
				local tbDef = opt.default or ""
				local tbCallback = opt.callback or function() end

				itemOrder = itemOrder + 1

				local tbContainer = Instance.new("Frame")
				tbContainer.Name = "TextBox_" .. tbName
				tbContainer.Size = UDim2.new(1, 0, 0, tbDesc ~= "" and 54 or 46)
				tbContainer.BackgroundTransparency = 1
				tbContainer.LayoutOrder = itemOrder
				tbContainer.ZIndex = 23
				tbContainer.Parent = cardFrame

				local subOrder = 0
				local tbLabel, descLabel

				if tbName ~= "" then
					subOrder = subOrder + 1
					tbLabel = Instance.new("TextLabel")
					tbLabel.Size = UDim2.new(1, 0, 0, 16)
					tbLabel.BackgroundTransparency = 1
					tbLabel.Font = fonts.medium
					tbLabel.Text = tbName
					tbLabel.TextColor3 = theme.text
					tbLabel.TextSize = 13
					tbLabel.TextXAlignment = Enum.TextXAlignment.Left
					tbLabel.ZIndex = 24
					tbLabel.Parent = tbContainer
				end

				local offset = 18
				if tbDesc ~= "" then
					descLabel = Instance.new("TextLabel")
					descLabel.Size = UDim2.new(1, 0, 0, 14)
					descLabel.Position = UDim2.new(0, 0, 0, offset)
					descLabel.BackgroundTransparency = 1
					descLabel.Font = fonts.regular
					descLabel.Text = tbDesc
					descLabel.TextColor3 = theme.textDesc
					descLabel.TextSize = 11
					descLabel.TextXAlignment = Enum.TextXAlignment.Left
					descLabel.ZIndex = 24
					descLabel.Parent = tbContainer
					offset = offset + 16
				end

				local boxFrame = Instance.new("Frame")
				boxFrame.Size = UDim2.new(1, 0, 0, 26)
				boxFrame.Position = UDim2.new(0, 0, 0, offset)
				boxFrame.BackgroundColor3 = theme.element
				boxFrame.BorderSizePixel = 0
				boxFrame.ZIndex = 24
				boxFrame.Parent = tbContainer

				local bCorner = Instance.new("UICorner")
				bCorner.CornerRadius = UDim.new(0, 6)
				bCorner.Parent = boxFrame

				local bStroke = Instance.new("UIStroke")
				bStroke.Color = theme.cardBorder
				bStroke.Thickness = 1
				bStroke.Parent = boxFrame

				local boxInput = Instance.new("TextBox")
				boxInput.Size = UDim2.new(1, -16, 1, 0)
				boxInput.Position = UDim2.new(0, 8, 0, 0)
				boxInput.BackgroundTransparency = 1
				boxInput.Font = fonts.medium
				boxInput.PlaceholderText = tbPlaceholder
				boxInput.PlaceholderColor3 = theme.textDark
				boxInput.Text = tbDef
				boxInput.TextColor3 = theme.text
				boxInput.TextSize = 12
				boxInput.TextXAlignment = Enum.TextXAlignment.Left
				boxInput.ClearTextOnFocus = false
				boxInput.ZIndex = 25
				boxInput.Parent = boxFrame

				boxInput.Focused:Connect(function()
					tween(bStroke, TweenInfo.new(0.15), {Color = theme.accent})
				end)
				boxInput.FocusLost:Connect(function(enterPressed)
					tween(bStroke, TweenInfo.new(0.15), {Color = theme.cardBorder})
					tbCallback(boxInput.Text, enterPressed)
				end)

				local boxObj = {}
				function boxObj:Set(newText, silent)
					boxInput.Text = newText
					if not silent then tbCallback(newText, false) end
				end
				function boxObj:Get()
					return boxInput.Text
				end
				function boxObj:SetTitle(newTitle)
					if tbLabel then tbLabel.Text = newTitle end
				end
				function boxObj:SetDescription(newDesc)
					if descLabel then descLabel.Text = newDesc end
				end
				return boxObj
			end

			function moduleObject:AddParagraph(opt)
				opt = opt or {}
				local pTitle = opt.title or "Information"
				local pContent = opt.content or ""

				itemOrder = itemOrder + 1

				local pFrame = Instance.new("Frame")
				pFrame.Name = "Paragraph_" .. pTitle
				pFrame.Size = UDim2.new(1, 0, 0, 0)
				pFrame.BackgroundColor3 = theme.element
				pFrame.BorderSizePixel = 0
				pFrame.AutomaticSize = Enum.AutomaticSize.Y
				pFrame.LayoutOrder = itemOrder
				pFrame.ZIndex = 23
				pFrame.Parent = cardFrame

				local pCorner = Instance.new("UICorner")
				pCorner.CornerRadius = UDim.new(0, 6)
				pCorner.Parent = pFrame

				local pStroke = Instance.new("UIStroke")
				pStroke.Color = theme.cardBorder
				pStroke.Thickness = 1
				pStroke.Parent = pFrame

				local pPad = Instance.new("UIPadding")
				pPad.PaddingTop = UDim.new(0, 8)
				pPad.PaddingBottom = UDim.new(0, 8)
				pPad.PaddingLeft = UDim.new(0, 10)
				pPad.PaddingRight = UDim.new(0, 10)
				pPad.Parent = pFrame

				local pLayout = Instance.new("UIListLayout")
				pLayout.FillDirection = Enum.FillDirection.Vertical
				pLayout.Padding = UDim.new(0, 2)
				pLayout.Parent = pFrame

				local pTitleLbl = Instance.new("TextLabel")
				pTitleLbl.Size = UDim2.new(1, 0, 0, 15)
				pTitleLbl.BackgroundTransparency = 1
				pTitleLbl.Font = fonts.bold
				pTitleLbl.Text = pTitle
				pTitleLbl.TextColor3 = theme.text
				pTitleLbl.TextSize = 12
				pTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
				pTitleLbl.ZIndex = 24
				pTitleLbl.Parent = pFrame

				local pContentLbl = Instance.new("TextLabel")
				pContentLbl.Size = UDim2.new(1, 0, 0, 0)
				pContentLbl.BackgroundTransparency = 1
				pContentLbl.Font = fonts.regular
				pContentLbl.Text = pContent
				pContentLbl.TextColor3 = theme.textDesc
				pContentLbl.TextSize = 11
				pContentLbl.TextWrapped = true
				pContentLbl.AutomaticSize = Enum.AutomaticSize.Y
				pContentLbl.TextXAlignment = Enum.TextXAlignment.Left
				pContentLbl.ZIndex = 24
				pContentLbl.Parent = pFrame

				local paraObj = {}
				function paraObj:SetTitle(newTitle)
					pTitleLbl.Text = newTitle
				end
				function paraObj:SetContent(newContent)
					pContentLbl.Text = newContent
				end
				return paraObj
			end

			function moduleObject:AddButton(opt)
				opt = opt or {}
				local bName = opt.name or "Button"
				local bDesc = opt.description or ""
				local bCallback = opt.callback or function() end

				itemOrder = itemOrder + 1

				local btnWrap = Instance.new("Frame")
				btnWrap.Size = UDim2.new(1, 0, 0, bDesc ~= "" and 44 or 28)
				btnWrap.BackgroundTransparency = 1
				btnWrap.LayoutOrder = itemOrder
				btnWrap.ZIndex = 23
				btnWrap.Parent = cardFrame

				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, 0, 0, 26)
				btn.Position = UDim2.new(0, 0, 0, bDesc ~= "" and 17 or 0)
				btn.BackgroundColor3 = theme.element
				btn.Text = bName
				btn.TextColor3 = theme.text
				btn.Font = fonts.medium
				btn.TextSize = 12
				btn.AutoButtonColor = false
				btn.ZIndex = 24
				btn.Parent = btnWrap

				local btnCorner = Instance.new("UICorner")
				btnCorner.CornerRadius = UDim.new(0, 6)
				btnCorner.Parent = btn

				local btnStroke = Instance.new("UIStroke")
				btnStroke.Color = theme.cardBorder
				btnStroke.Thickness = 1
				btnStroke.Parent = btn

				local descLabel
				if bDesc ~= "" then
					descLabel = Instance.new("TextLabel")
					descLabel.Size = UDim2.new(1, 0, 0, 14)
					descLabel.BackgroundTransparency = 1
					descLabel.Font = fonts.regular
					descLabel.Text = bDesc
					descLabel.TextColor3 = theme.textDesc
					descLabel.TextSize = 11
					descLabel.TextXAlignment = Enum.TextXAlignment.Left
					descLabel.ZIndex = 24
					descLabel.Parent = btnWrap
				end

				btn.MouseEnter:Connect(function()
					tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.elementHover})
				end)
				btn.MouseLeave:Connect(function()
					tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.element})
				end)
				btn.MouseButton1Click:Connect(bCallback)

				local btnObj = {}
				function btnObj:SetTitle(newText)
					btn.Text = newText
				end
				function btnObj:SetDescription(newDesc)
					if descLabel then descLabel.Text = newDesc end
				end
				return btnObj
			end

			function moduleObject:AddKeybind(opt)
				opt = opt or {}
				local kName = opt.name or "Keybind"
				local kDesc = opt.description or ""
				local kDef = opt.default or Enum.KeyCode.None
				local kCallback = opt.callback or function() end

				itemOrder = itemOrder + 1

				local keyRow = Instance.new("Frame")
				keyRow.Name = "Keybind_" .. kName
				keyRow.Size = UDim2.new(1, 0, 0, kDesc ~= "" and 34 or 24)
				keyRow.BackgroundTransparency = 1
				keyRow.LayoutOrder = itemOrder
				keyRow.ZIndex = 23
				keyRow.Parent = cardFrame

				local textWrap = Instance.new("Frame")
				textWrap.Size = UDim2.new(1, -60, 1, 0)
				textWrap.BackgroundTransparency = 1
				textWrap.ZIndex = 23
				textWrap.Parent = keyRow

				local textWrapLayout = Instance.new("UIListLayout")
				textWrapLayout.FillDirection = Enum.FillDirection.Vertical
				textWrapLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				textWrapLayout.Padding = UDim.new(0, 1)
				textWrapLayout.Parent = textWrap

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, 0, 0, 16)
				label.BackgroundTransparency = 1
				label.Font = fonts.medium
				label.Text = kName
				label.TextColor3 = theme.text
				label.TextSize = 13
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.ZIndex = 24
				label.Parent = textWrap

				local descLabel
				if kDesc ~= "" then
					descLabel = Instance.new("TextLabel")
					descLabel.Size = UDim2.new(1, 0, 0, 14)
					descLabel.BackgroundTransparency = 1
					descLabel.Font = fonts.regular
					descLabel.Text = kDesc
					descLabel.TextColor3 = theme.textDesc
					descLabel.TextSize = 11
					descLabel.TextXAlignment = Enum.TextXAlignment.Left
					descLabel.ZIndex = 24
					descLabel.Parent = textWrap
				end

				local pill = Instance.new("TextButton")
				pill.Size = UDim2.new(0, 48, 0, 19)
				pill.Position = UDim2.new(1, -48, 0.5, -9)
				pill.BackgroundColor3 = theme.element
				pill.Text = ""
				pill.AutoButtonColor = false
				pill.ZIndex = 24
				pill.Parent = keyRow

				local pillCorner = Instance.new("UICorner")
				pillCorner.CornerRadius = UDim.new(0, 4)
				pillCorner.Parent = pill

				local pillStroke = Instance.new("UIStroke")
				pillStroke.Color = theme.cardBorder
				pillStroke.Thickness = 1
				pillStroke.Parent = pill

				local pillIcon = Instance.new("ImageLabel")
				pillIcon.Size = UDim2.new(0, 12, 0, 12)
				pillIcon.Position = UDim2.new(0, 4, 0.5, -6)
				pillIcon.BackgroundTransparency = 1
				clickGui.applyIcon(pillIcon, "keyboard")
				pillIcon.ImageColor3 = theme.textMuted
				pillIcon.ZIndex = 25
				pillIcon.Parent = pill

				local pillLabel = Instance.new("TextLabel")
				pillLabel.Size = UDim2.new(1, -16, 1, 0)
				pillLabel.Position = UDim2.new(0, 14, 0, 0)
				pillLabel.BackgroundTransparency = 1
				pillLabel.Font = fonts.medium
				pillLabel.Text = (kDef == Enum.KeyCode.None) and "None" or kDef.Name
				pillLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
				pillLabel.TextSize = 10
				pillLabel.TextXAlignment = Enum.TextXAlignment.Center
				pillLabel.TextTruncate = Enum.TextTruncate.AtEnd
				pillLabel.ZIndex = 25
				pillLabel.Parent = pill

				local listening = false
				pill.MouseButton1Click:Connect(function()
					if listening then return end
					listening = true
					pillLabel.Text = "..."
					pillLabel.TextColor3 = theme.accent

					local conn
					conn = UserInputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Keyboard then
							if input.KeyCode == Enum.KeyCode.Escape then
								kDef = Enum.KeyCode.None
								pillLabel.Text = "None"
							else
								kDef = input.KeyCode
								pillLabel.Text = input.KeyCode.Name
							end
							pillLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
							listening = false
							conn:Disconnect()
							kCallback(kDef)
						end
					end)
				end)

				local keyObj = {}
				function keyObj:Set(newKey, silent)
					kDef = newKey
					pillLabel.Text = (newKey == Enum.KeyCode.None) and "None" or newKey.Name
					if not silent then kCallback(newKey) end
				end
				function keyObj:Get()
					return kDef
				end
				function keyObj:SetTitle(newTitle)
					label.Text = newTitle
				end
				function keyObj:SetDescription(newDesc)
					if descLabel then descLabel.Text = newDesc end
				end
				return keyObj
			end

			return moduleObject
		end

		table.insert(window.tabs, tabObject)
		return tabObject
	end

	return window
end

function clickGui:Notify(config)
	config = config or {}
	local nTitle = config.title or "Notification"
	local nContent = config.content or ""
	local nDuration = config.duration or 2.5
	local nIcon = config.icon or "bell"
	local accentColor = config.accentColor or theme.accent

	if not clickGui.notifyContainer then return end

	local itemHolder = Instance.new("Frame")
	itemHolder.Name = "Holder_" .. math.random(1000, 9999)
	itemHolder.Size = UDim2.new(1, 0, 0, 0)
	itemHolder.BackgroundTransparency = 1
	itemHolder.ClipsDescendants = false
	itemHolder.ZIndex = 5
	itemHolder.Parent = clickGui.notifyContainer

	local notifyFrame = Instance.new("Frame")
	notifyFrame.Name = "Card"
	notifyFrame.Size = UDim2.new(1, 0, 0, 46)
	notifyFrame.Position = UDim2.new(0, 0, 0, 15)
	notifyFrame.BackgroundColor3 = theme.card
	notifyFrame.BorderSizePixel = 0
	notifyFrame.ClipsDescendants = false
	notifyFrame.ZIndex = 6
	notifyFrame.Parent = itemHolder

	local nCorner = Instance.new("UICorner")
	nCorner.CornerRadius = UDim.new(0, 8)
	nCorner.Parent = notifyFrame

	local nStroke = Instance.new("UIStroke")
	nStroke.Color = theme.cardBorder
	nStroke.Thickness = 1
	nStroke.Parent = notifyFrame

	local nIconImg = Instance.new("ImageLabel")
	nIconImg.Size = UDim2.new(0, 16, 0, 16)
	nIconImg.Position = UDim2.new(0, 12, 0.5, -8)
	nIconImg.BackgroundTransparency = 1
	clickGui.applyIcon(nIconImg, nIcon)
	nIconImg.ImageColor3 = accentColor
	nIconImg.ZIndex = 7
	nIconImg.Parent = notifyFrame

	local nTitleLabel = Instance.new("TextLabel")
	nTitleLabel.Size = UDim2.new(1, config.bindName and -80 or -38, 0, 15)
	nTitleLabel.Position = UDim2.new(0, 36, 0, 6)
	nTitleLabel.BackgroundTransparency = 1
	nTitleLabel.Font = fonts.bold
	nTitleLabel.Text = nTitle
	nTitleLabel.TextColor3 = theme.text
	nTitleLabel.TextSize = 13
	nTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	nTitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nTitleLabel.ZIndex = 7
	nTitleLabel.Parent = notifyFrame

	if config.bindName and config.bindName ~= "" and config.bindName ~= "None" then
		local bindBadge = Instance.new("Frame")
		bindBadge.Name = "BindBadge"
		bindBadge.AutomaticSize = Enum.AutomaticSize.X
		bindBadge.Size = UDim2.new(0, 0, 0, 16)
		bindBadge.Position = UDim2.new(1, -10, 0, 5)
		bindBadge.AnchorPoint = Vector2.new(1, 0)
		bindBadge.BackgroundColor3 = theme.element
		bindBadge.BorderSizePixel = 0
		bindBadge.ZIndex = 7
		bindBadge.Parent = notifyFrame

		local badgeCorner = Instance.new("UICorner")
		badgeCorner.CornerRadius = UDim.new(0, 4)
		badgeCorner.Parent = bindBadge

		local badgeStroke = Instance.new("UIStroke")
		badgeStroke.Color = theme.cardBorder
		badgeStroke.Thickness = 1
		badgeStroke.Parent = bindBadge

		local badgePad = Instance.new("UIPadding")
		badgePad.PaddingLeft = UDim.new(0, 4)
		badgePad.PaddingRight = UDim.new(0, 5)
		badgePad.PaddingTop = UDim.new(0, 2)
		badgePad.PaddingBottom = UDim.new(0, 2)
		badgePad.Parent = bindBadge

		local badgeLayout = Instance.new("UIListLayout")
		badgeLayout.FillDirection = Enum.FillDirection.Horizontal
		badgeLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		badgeLayout.Padding = UDim.new(0, 3)
		badgeLayout.Parent = bindBadge

		local arrowImg = Instance.new("ImageLabel")
		arrowImg.Size = UDim2.new(0, 10, 0, 10)
		arrowImg.BackgroundTransparency = 1
		clickGui.applyIcon(arrowImg, "arrow-right")
		arrowImg.ImageColor3 = theme.textDark
		arrowImg.ZIndex = 8
		arrowImg.Parent = bindBadge

		local kbImg = Instance.new("ImageLabel")
		kbImg.Size = UDim2.new(0, 11, 0, 11)
		kbImg.BackgroundTransparency = 1
		clickGui.applyIcon(kbImg, "keyboard")
		kbImg.ImageColor3 = theme.accentLight
		kbImg.ZIndex = 8
		kbImg.Parent = bindBadge

		local bindKeyLbl = Instance.new("TextLabel")
		bindKeyLbl.AutomaticSize = Enum.AutomaticSize.X
		bindKeyLbl.Size = UDim2.new(0, 0, 1, 0)
		bindKeyLbl.BackgroundTransparency = 1
		bindKeyLbl.Font = fonts.bold
		bindKeyLbl.Text = config.bindName
		bindKeyLbl.TextColor3 = theme.accentLight
		bindKeyLbl.TextSize = 10
		bindKeyLbl.ZIndex = 8
		bindKeyLbl.Parent = bindBadge
	end

	local nDescLabel = Instance.new("TextLabel")
	nDescLabel.Size = UDim2.new(1, -38, 0, 14)
	nDescLabel.Position = UDim2.new(0, 36, 0, 22)
	nDescLabel.BackgroundTransparency = 1
	nDescLabel.Font = fonts.regular
	nDescLabel.Text = nContent
	nDescLabel.TextColor3 = theme.textDesc
	nDescLabel.TextSize = 11
	nDescLabel.TextXAlignment = Enum.TextXAlignment.Left
	nDescLabel.ZIndex = 7
	nDescLabel.Parent = notifyFrame

	local progressTrack = Instance.new("Frame")
	progressTrack.Size = UDim2.new(1, -24, 0, 2)
	progressTrack.Position = UDim2.new(0, 12, 1, -6)
	progressTrack.BackgroundColor3 = Color3.fromRGB(30, 33, 44)
	progressTrack.BorderSizePixel = 0
	progressTrack.ZIndex = 8
	progressTrack.Parent = notifyFrame

	local progressTrackCorner = Instance.new("UICorner")
	progressTrackCorner.CornerRadius = UDim.new(1, 0)
	progressTrackCorner.Parent = progressTrack

	local progressFill = Instance.new("Frame")
	progressFill.Size = UDim2.new(1, 0, 1, 0)
	progressFill.BackgroundColor3 = accentColor
	progressFill.BorderSizePixel = 0
	progressFill.ZIndex = 9
	progressFill.Parent = progressTrack

	local progressFillCorner = Instance.new("UICorner")
	progressFillCorner.CornerRadius = UDim.new(1, 0)
	progressFillCorner.Parent = progressFill

	tween(itemHolder, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 0, 46)
	})
	tween(notifyFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0)
	})

	tween(progressFill, TweenInfo.new(nDuration, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 1, 0)
	})

	task.delay(nDuration, function()
		tween(notifyFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Position = UDim2.new(0, 0, 0, -15)
		})
		local hideTween = tween(itemHolder, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Size = UDim2.new(1, 0, 0, 0)
		})
		hideTween.Completed:Connect(function()
			itemHolder:Destroy()
		end)
	end)
end

return clickGui

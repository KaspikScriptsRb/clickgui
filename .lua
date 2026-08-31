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
	modules = {}
}

local theme = {
	bg = Color3.fromRGB(15, 16, 22),
	topbar = Color3.fromRGB(12, 13, 19),
	tabBar = Color3.fromRGB(18, 20, 28),
	card = Color3.fromRGB(22, 24, 33),
	cardBorder = Color3.fromRGB(44, 49, 66),
	cardBorderHover = Color3.fromRGB(70, 78, 105),
	element = Color3.fromRGB(28, 31, 43),
	elementHover = Color3.fromRGB(36, 41, 56),
	dropdownBg = Color3.fromRGB(18, 20, 28),
	dropdownItemHover = Color3.fromRGB(29, 33, 46),
	dropdownItemSelected = Color3.fromRGB(36, 41, 58),
	accent = Color3.fromRGB(124, 92, 252),
	accentLight = Color3.fromRGB(111, 124, 247),
	accentHover = Color3.fromRGB(145, 115, 255),
	text = Color3.fromRGB(245, 246, 252),
	textMuted = Color3.fromRGB(170, 175, 192),
	textDesc = Color3.fromRGB(115, 120, 140),
	textDark = Color3.fromRGB(85, 90, 112),
	switchOff = Color3.fromRGB(40, 44, 60),
	switchKnob = Color3.fromRGB(255, 255, 255),
	starActive = Color3.fromRGB(255, 208, 66),
	starInactive = Color3.fromRGB(80, 86, 108),
	sliderTrack = Color3.fromRGB(34, 38, 52)
}

local fonts = {
	bold = Enum.Font.BuilderSansBold,
	medium = Enum.Font.BuilderSansMedium,
	regular = Enum.Font.BuilderSans
}

local successFont, _ = pcall(function()
	local lbl = Instance.new("TextLabel")
	lbl.Font = fonts.bold
end)
if not successFont then
	fonts.bold = Enum.Font.GothamBold
	fonts.medium = Enum.Font.GothamMedium
	fonts.regular = Enum.Font.Gotham
end

local directIcons = {
	["star"] = "rbxassetid://10734953649",
	["star-filled"] = "rbxassetid://10734953841",
	["volume-2"] = "rbxassetid://10747375434",
	["speaker"] = "rbxassetid://10747375434",
	["chevron-down"] = "rbxassetid://10709790948",
	["chevron-up"] = "rbxassetid://10709791523",
	["chevron-left"] = "rbxassetid://10709790884",
	["chevron-right"] = "rbxassetid://10709791008",
	["list-filter"] = "rbxassetid://10709791143",
	["filter"] = "rbxassetid://10709791143",
	["key"] = "rbxassetid://10723414352",
	["check"] = "rbxassetid://10709790644",
	["diamond"] = "rbxassetid://10734953491",
	["rhombus"] = "rbxassetid://10734953491",
	["sliders-horizontal"] = "rbxassetid://10734952479",
	["sliders"] = "rbxassetid://10734952479",
	["swords"] = "rbxassetid://10709791437",
	["sword"] = "rbxassetid://10709791437",
	["shield"] = "rbxassetid://10723415903",
	["user"] = "rbxassetid://10747373176",
	["feather"] = "rbxassetid://10723387643",
	["eye"] = "rbxassetid://10723387563",
	["folder"] = "rbxassetid://10723387841",
	["search"] = "rbxassetid://10734923549",
	["languages"] = "rbxassetid://10723387971",
	["bell"] = "rbxassetid://10709790426",
	["split"] = "rbxassetid://10709791281",
	["columns"] = "rbxassetid://10709791281",
	["layout-grid"] = "rbxassetid://10709790575",
	["box"] = "rbxassetid://10709790575",
	["zap"] = "rbxassetid://10734954201",
	["bot"] = "rbxassetid://10709790487",
	["repeat"] = "rbxassetid://10734950382",
	["flame"] = "rbxassetid://10723387721",
	["heart"] = "rbxassetid://10723395402",
	["sparkles"] = "rbxassetid://10734953491",
	["trash"] = "rbxassetid://10747373105",
	["lock"] = "rbxassetid://10723414827",
	["crosshair"] = "rbxassetid://10709791053"
}

function clickGui.applyIcon(imageObj, iconName)
	if not iconName or iconName == "" then
		iconName = "box"
	end

	imageObj.ImageRectOffset = Vector2.new(0, 0)
	imageObj.ImageRectSize = Vector2.new(0, 0)

	if type(iconName) == "number" or string.match(tostring(iconName), "^%d+$") then
		imageObj.Image = "rbxassetid://" .. tostring(iconName)
		return
	end

	local str = tostring(iconName)
	if string.sub(str, 1, 13) == "rbxassetid://" or string.sub(str, 1, 4) == "http" then
		imageObj.Image = str
		return
	end

	local clean = string.lower(str)
	if string.sub(clean, 1, 7) == "lucide:" then
		clean = string.sub(clean, 8)
	end

	if directIcons[clean] then
		imageObj.Image = directIcons[clean]
	else
		imageObj.Image = "rbxassetid://10709790575"
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
		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
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

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 900, 0, 540)
	mainFrame.Position = UDim2.new(0.5, -450, 0.5, -270)
	mainFrame.BackgroundColor3 = theme.bg
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = false
	mainFrame.Parent = screenGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 10)
	mainCorner.Parent = mainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = theme.cardBorder
	mainStroke.Thickness = 1.3
	mainStroke.Parent = mainFrame

	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 48)
	topBar.BackgroundColor3 = theme.topbar
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame

	local topBarCorner = Instance.new("UICorner")
	topBarCorner.CornerRadius = UDim.new(0, 10)
	topBarCorner.Parent = topBar

	local topBarBottomCover = Instance.new("Frame")
	topBarBottomCover.Size = UDim2.new(1, 0, 0, 10)
	topBarBottomCover.Position = UDim2.new(0, 0, 1, -10)
	topBarBottomCover.BackgroundColor3 = theme.topbar
	topBarBottomCover.BorderSizePixel = 0
	topBarBottomCover.Parent = topBar

	local topBarBorder = Instance.new("Frame")
	topBarBorder.Size = UDim2.new(1, 0, 0, 1)
	topBarBorder.Position = UDim2.new(0, 0, 1, 0)
	topBarBorder.BackgroundColor3 = theme.cardBorder
	topBarBorder.BorderSizePixel = 0
	topBarBorder.Parent = topBar

	makeDraggable(topBar, mainFrame)

	local logoContainer = Instance.new("Frame")
	logoContainer.Name = "LogoContainer"
	logoContainer.Size = UDim2.new(0, 48, 1, 0)
	logoContainer.BackgroundTransparency = 1
	logoContainer.Parent = topBar

	local logoImage = Instance.new("ImageLabel")
	logoImage.Size = UDim2.new(0, 18, 0, 18)
	logoImage.Position = UDim2.new(0, 18, 0.5, -9)
	logoImage.BackgroundTransparency = 1
	clickGui.applyIcon(logoImage, logoIcon)
	logoImage.ImageColor3 = theme.accent
	logoImage.Parent = logoContainer

	local tabList = Instance.new("Frame")
	tabList.Name = "TabList"
	tabList.Size = UDim2.new(0, 340, 0, 30)
	tabList.Position = UDim2.new(0.5, -170, 0.5, -15)
	tabList.BackgroundColor3 = theme.tabBar
	tabList.BorderSizePixel = 0
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

	local utilityContainer = Instance.new("Frame")
	utilityContainer.Name = "UtilityContainer"
	utilityContainer.Size = UDim2.new(0, 180, 1, 0)
	utilityContainer.Position = UDim2.new(1, -190, 0, 0)
	utilityContainer.BackgroundTransparency = 1
	utilityContainer.Parent = topBar

	local utilityLayout = Instance.new("UIListLayout")
	utilityLayout.FillDirection = Enum.FillDirection.Horizontal
	utilityLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	utilityLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	utilityLayout.Padding = UDim.new(0, 12)
	utilityLayout.Parent = utilityContainer

	local utilityIcons = {
		{icon = "split", tip = "Columns"},
		{icon = "search", tip = "Search"},
		{icon = "languages", tip = "Language"},
		{icon = "bell", tip = "Notifications"},
		{icon = "user", tip = "Profile"}
	}

	for _, util in ipairs(utilityIcons) do
		local utilButton = Instance.new("ImageButton")
		utilButton.Size = UDim2.new(0, 15, 0, 15)
		utilButton.BackgroundTransparency = 1
		clickGui.applyIcon(utilButton, util.icon)
		utilButton.ImageColor3 = theme.textDark
		utilButton.Parent = utilityContainer

		utilButton.MouseEnter:Connect(function()
			tween(utilButton, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageColor3 = theme.text})
		end)
		utilButton.MouseLeave:Connect(function()
			tween(utilButton, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageColor3 = theme.textDark})
		end)
	end

	local contentContainer = Instance.new("Frame")
	contentContainer.Name = "ContentContainer"
	contentContainer.Size = UDim2.new(1, -20, 1, -60)
	contentContainer.Position = UDim2.new(0, 10, 0, 52)
	contentContainer.BackgroundTransparency = 1
	contentContainer.Parent = mainFrame

	local notifyContainer = Instance.new("Frame")
	notifyContainer.Name = "NotifyContainer"
	notifyContainer.Size = UDim2.new(0, 260, 1, -20)
	notifyContainer.Position = UDim2.new(1, -270, 0, 10)
	notifyContainer.BackgroundTransparency = 1
	notifyContainer.ZIndex = 100
	notifyContainer.Parent = screenGui

	local notifyLayout = Instance.new("UIListLayout")
	notifyLayout.FillDirection = Enum.FillDirection.Vertical
	notifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notifyLayout.Padding = UDim.new(0, 8)
	notifyLayout.Parent = notifyContainer

	clickGui.gui = screenGui
	clickGui.mainFrame = mainFrame
	clickGui.tabList = tabList
	clickGui.contentContainer = contentContainer
	clickGui.notifyContainer = notifyContainer

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
		tabButton.Parent = tabList

		local tabIconImage = Instance.new("ImageLabel")
		tabIconImage.Size = UDim2.new(0, 15, 0, 15)
		tabIconImage.Position = UDim2.new(0.5, -7.5, 0.5, -8.5)
		tabIconImage.BackgroundTransparency = 1
		clickGui.applyIcon(tabIconImage, tabIcon)
		tabIconImage.ImageColor3 = (tabIndex == 1) and theme.accent or theme.textDark
		tabIconImage.Parent = tabButton

		local activeLine = Instance.new("Frame")
		activeLine.Name = "ActiveLine"
		activeLine.Size = (tabIndex == 1) and UDim2.new(0, 14, 0, 2) or UDim2.new(0, 0, 0, 2)
		activeLine.Position = UDim2.new(0.5, -7, 1, -2)
		activeLine.BackgroundColor3 = theme.accent
		activeLine.BorderSizePixel = 0
		activeLine.Visible = (tabIndex == 1)
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
		tabPage.Parent = contentContainer

		local columnsContainer = Instance.new("Frame")
		columnsContainer.Name = "Columns"
		columnsContainer.Size = UDim2.new(1, 0, 1, 0)
		columnsContainer.BackgroundTransparency = 1
		columnsContainer.Parent = tabPage

		local colPadding = Instance.new("UIPadding")
		colPadding.PaddingLeft = UDim.new(0, 4)
		colPadding.PaddingRight = UDim.new(0, 4)
		colPadding.PaddingTop = UDim.new(0, 4)
		colPadding.PaddingBottom = UDim.new(0, 12)
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
			local modIcon = moduleConfig.icon or "volume-2"
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
			cardFrame.Parent = targetColumn

			local cardCorner = Instance.new("UICorner")
			cardCorner.CornerRadius = UDim.new(0, 8)
			cardCorner.Parent = cardFrame

			local cardStroke = Instance.new("UIStroke")
			cardStroke.Color = theme.cardBorder
			cardStroke.Thickness = 1.2
			cardStroke.Parent = cardFrame

			local cardPadding = Instance.new("UIPadding")
			cardPadding.PaddingTop = UDim.new(0, 10)
			cardPadding.PaddingBottom = UDim.new(0, 12)
			cardPadding.PaddingLeft = UDim.new(0, 12)
			cardPadding.PaddingRight = UDim.new(0, 12)
			cardPadding.Parent = cardFrame

			local cardLayout = Instance.new("UIListLayout")
			cardLayout.FillDirection = Enum.FillDirection.Vertical
			cardLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
			cardLayout.Padding = UDim.new(0, 8)
			cardLayout.Parent = cardFrame

			local itemOrder = 0

			local headerFrame = Instance.new("Frame")
			headerFrame.Name = "Header"
			headerFrame.Size = UDim2.new(1, 0, 0, 22)
			headerFrame.BackgroundTransparency = 1
			headerFrame.LayoutOrder = 0
			headerFrame.Parent = cardFrame

			local leftHeader = Instance.new("Frame")
			leftHeader.Name = "Left"
			leftHeader.Size = UDim2.new(1, -110, 1, 0)
			leftHeader.BackgroundTransparency = 1
			leftHeader.Parent = headerFrame

			local leftLayout = Instance.new("UIListLayout")
			leftLayout.FillDirection = Enum.FillDirection.Horizontal
			leftLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			leftLayout.Padding = UDim.new(0, 8)
			leftLayout.Parent = leftHeader

			local modIconLabel = Instance.new("ImageLabel")
			modIconLabel.Size = UDim2.new(0, 15, 0, 15)
			modIconLabel.BackgroundTransparency = 1
			clickGui.applyIcon(modIconLabel, modIcon)
			modIconLabel.ImageColor3 = theme.textMuted
			modIconLabel.Parent = leftHeader

			local titleLabel = Instance.new("TextLabel")
			titleLabel.Size = UDim2.new(1, -24, 1, 0)
			titleLabel.BackgroundTransparency = 1
			titleLabel.Font = fonts.bold
			titleLabel.Text = modName
			titleLabel.TextColor3 = theme.text
			titleLabel.TextSize = 12.5
			titleLabel.TextXAlignment = Enum.TextXAlignment.Left
			titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
			titleLabel.Parent = leftHeader

			local rightHeader = Instance.new("Frame")
			rightHeader.Name = "Right"
			rightHeader.Size = UDim2.new(0, 110, 1, 0)
			rightHeader.Position = UDim2.new(1, -110, 0, 0)
			rightHeader.BackgroundTransparency = 1
			rightHeader.Parent = headerFrame

			local rightLayout = Instance.new("UIListLayout")
			rightLayout.FillDirection = Enum.FillDirection.Horizontal
			rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			rightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			rightLayout.Padding = UDim.new(0, 6)
			rightLayout.Parent = rightHeader

			local starBtn = Instance.new("ImageButton")
			starBtn.Size = UDim2.new(0, 14, 0, 14)
			starBtn.BackgroundTransparency = 1
			clickGui.applyIcon(starBtn, "star")
			starBtn.ImageColor3 = modFavorite and theme.starActive or theme.starInactive
			starBtn.Parent = rightHeader

			starBtn.MouseButton1Click:Connect(function()
				modFavorite = not modFavorite
				if modFavorite then
					clickGui.favorites[modName] = true
				else
					clickGui.favorites[modName] = nil
				end
				tween(starBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					ImageColor3 = modFavorite and theme.starActive or theme.starInactive
				})
			end)

			local bindBtn = Instance.new("TextButton")
			bindBtn.Size = UDim2.new(0, 48, 0, 18)
			bindBtn.BackgroundColor3 = theme.element
			bindBtn.Text = ""
			bindBtn.AutoButtonColor = false
			bindBtn.Parent = rightHeader

			local bindCorner = Instance.new("UICorner")
			bindCorner.CornerRadius = UDim.new(0, 4)
			bindCorner.Parent = bindBtn

			local bindStroke = Instance.new("UIStroke")
			bindStroke.Color = theme.cardBorder
			bindStroke.Thickness = 1
			bindStroke.Parent = bindBtn

			local bindIcon = Instance.new("ImageLabel")
			bindIcon.Size = UDim2.new(0, 10, 0, 10)
			bindIcon.Position = UDim2.new(0, 4, 0.5, -5)
			bindIcon.BackgroundTransparency = 1
			clickGui.applyIcon(bindIcon, "key")
			bindIcon.ImageColor3 = theme.textMuted
			bindIcon.Parent = bindBtn

			local bindLabel = Instance.new("TextLabel")
			bindLabel.Size = UDim2.new(1, -16, 1, 0)
			bindLabel.Position = UDim2.new(0, 14, 0, 0)
			bindLabel.BackgroundTransparency = 1
			bindLabel.Font = fonts.medium
			bindLabel.Text = (modBind == Enum.KeyCode.None) and "None" or modBind.Name
			bindLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
			bindLabel.TextSize = 9.5
			bindLabel.TextXAlignment = Enum.TextXAlignment.Center
			bindLabel.TextTruncate = Enum.TextTruncate.AtEnd
			bindLabel.Parent = bindBtn

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
							modBind = Enum.KeyCode.None
							bindLabel.Text = "None"
						else
							modBind = input.KeyCode
							bindLabel.Text = input.KeyCode.Name
						end
						bindLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
						isBinding = false
						conn:Disconnect()
					end
				end)
			end)

			local toggleSwitch = Instance.new("TextButton")
			toggleSwitch.Size = UDim2.new(0, 32, 0, 16)
			toggleSwitch.BackgroundColor3 = modState and theme.accent or theme.switchOff
			toggleSwitch.Text = ""
			toggleSwitch.AutoButtonColor = false
			toggleSwitch.Parent = rightHeader

			local switchCorner = Instance.new("UICorner")
			switchCorner.CornerRadius = UDim.new(1, 0)
			switchCorner.Parent = toggleSwitch

			local switchKnob = Instance.new("Frame")
			switchKnob.Size = UDim2.new(0, 12, 0, 12)
			switchKnob.Position = modState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
			switchKnob.BackgroundColor3 = theme.switchKnob
			switchKnob.BorderSizePixel = 0
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

			local function setToggle(val, silent)
				moduleObject.state = val
				local targetColor = val and theme.accent or theme.switchOff
				local targetKnobPos = val and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)

				tween(toggleSwitch, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor})
				tween(switchKnob, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetKnobPos})

				if not silent and moduleObject.callback then
					moduleObject.callback(val)
				end
			end

			toggleSwitch.MouseButton1Click:Connect(function()
				setToggle(not moduleObject.state)
			end)

			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if gameProcessed then return end
				if modBind ~= Enum.KeyCode.None and input.KeyCode == modBind then
					setToggle(not moduleObject.state)
				end
			end)

			function moduleObject:Set(val)
				setToggle(val, false)
			end

			function moduleObject:AddDropdown(opt)
				opt = opt or {}
				local dName = opt.name or ""
				local dDesc = opt.description or ""
				local dIcon = opt.icon or "list-filter"
				local dList = opt.options or {}
				local dSelected = opt.default or dList[1] or ""
				local dIsOpen = opt.open or false
				local dCallback = opt.callback or function() end

				itemOrder = itemOrder + 1

				local ddContainer = Instance.new("Frame")
				ddContainer.Name = "Dropdown_" .. (dName ~= "" and dName or "Item")
				ddContainer.Size = UDim2.new(1, 0, 0, 0)
				ddContainer.BackgroundTransparency = 1
				ddContainer.LayoutOrder = itemOrder
				ddContainer.AutomaticSize = Enum.AutomaticSize.Y
				ddContainer.Parent = cardFrame

				local ddLayout = Instance.new("UIListLayout")
				ddLayout.FillDirection = Enum.FillDirection.Vertical
				ddLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ddLayout.Padding = UDim.new(0, 3)
				ddLayout.Parent = ddContainer

				local subOrder = 0

				if dName ~= "" then
					subOrder = subOrder + 1
					local ddLabel = Instance.new("TextLabel")
					ddLabel.Size = UDim2.new(1, 0, 0, 14)
					ddLabel.BackgroundTransparency = 1
					ddLabel.Font = fonts.medium
					ddLabel.Text = dName
					ddLabel.TextColor3 = theme.text
					ddLabel.TextSize = 11.5
					ddLabel.TextXAlignment = Enum.TextXAlignment.Left
					ddLabel.LayoutOrder = subOrder
					ddLabel.Parent = ddContainer
				end

				if dDesc ~= "" then
					subOrder = subOrder + 1
					local ddDescLabel = Instance.new("TextLabel")
					ddDescLabel.Size = UDim2.new(1, 0, 0, 12)
					ddDescLabel.BackgroundTransparency = 1
					ddDescLabel.Font = fonts.regular
					ddDescLabel.Text = dDesc
					ddDescLabel.TextColor3 = theme.textDesc
					ddDescLabel.TextSize = 9.5
					ddDescLabel.TextXAlignment = Enum.TextXAlignment.Left
					ddDescLabel.TextTruncate = Enum.TextTruncate.AtEnd
					ddDescLabel.LayoutOrder = subOrder
					ddDescLabel.Parent = ddContainer
				end

				subOrder = subOrder + 1
				local ddBox = Instance.new("TextButton")
				ddBox.Size = UDim2.new(1, 0, 0, 26)
				ddBox.BackgroundColor3 = theme.element
				ddBox.Text = ""
				ddBox.AutoButtonColor = false
				ddBox.LayoutOrder = subOrder
				ddBox.Parent = ddContainer

				local ddBoxCorner = Instance.new("UICorner")
				ddBoxCorner.CornerRadius = UDim.new(0, 6)
				ddBoxCorner.Parent = ddBox

				local ddBoxStroke = Instance.new("UIStroke")
				ddBoxStroke.Color = theme.cardBorder
				ddBoxStroke.Thickness = 1.1
				ddBoxStroke.Parent = ddBox

				local ddFilterIcon = Instance.new("ImageLabel")
				ddFilterIcon.Size = UDim2.new(0, 12, 0, 12)
				ddFilterIcon.Position = UDim2.new(0, 8, 0.5, -6)
				ddFilterIcon.BackgroundTransparency = 1
				clickGui.applyIcon(ddFilterIcon, dIcon)
				ddFilterIcon.ImageColor3 = theme.textDesc
				ddFilterIcon.Parent = ddBox

				local ddValueLabel = Instance.new("TextLabel")
				ddValueLabel.Size = UDim2.new(1, -44, 1, 0)
				ddValueLabel.Position = UDim2.new(0, 26, 0, 0)
				ddValueLabel.BackgroundTransparency = 1
				ddValueLabel.Font = fonts.medium
				ddValueLabel.Text = tostring(dSelected)
				ddValueLabel.TextColor3 = theme.text
				ddValueLabel.TextSize = 11
				ddValueLabel.TextXAlignment = Enum.TextXAlignment.Left
				ddValueLabel.TextTruncate = Enum.TextTruncate.AtEnd
				ddValueLabel.Parent = ddBox

				local ddArrow = Instance.new("ImageLabel")
				ddArrow.Size = UDim2.new(0, 11, 0, 11)
				ddArrow.Position = UDim2.new(1, -18, 0.5, -5.5)
				ddArrow.BackgroundTransparency = 1
				clickGui.applyIcon(ddArrow, dIsOpen and "chevron-up" or "chevron-down")
				ddArrow.ImageColor3 = theme.textDesc
				ddArrow.Parent = ddBox

				subOrder = subOrder + 1
				local ddListFrame = Instance.new("Frame")
				ddListFrame.Name = "OptionsList"
				ddListFrame.Size = UDim2.new(1, 0, 0, 0)
				ddListFrame.BackgroundColor3 = theme.dropdownBg
				ddListFrame.BorderSizePixel = 0
				ddListFrame.ClipsDescendants = true
				ddListFrame.Visible = dIsOpen
				ddListFrame.LayoutOrder = subOrder
				ddListFrame.AutomaticSize = Enum.AutomaticSize.Y
				ddListFrame.Parent = ddContainer

				local listCorner = Instance.new("UICorner")
				listCorner.CornerRadius = UDim.new(0, 6)
				listCorner.Parent = ddListFrame

				local listStroke = Instance.new("UIStroke")
				listStroke.Color = theme.cardBorder
				listStroke.Thickness = 1.1
				listStroke.Parent = ddListFrame

				local listLayout = Instance.new("UIListLayout")
				listLayout.FillDirection = Enum.FillDirection.Vertical
				listLayout.Padding = UDim.new(0, 1)
				listLayout.Parent = ddListFrame

				local listPadding = Instance.new("UIPadding")
				listPadding.PaddingTop = UDim.new(0, 3)
				listPadding.PaddingBottom = UDim.new(0, 3)
				listPadding.PaddingLeft = UDim.new(0, 3)
				listPadding.PaddingRight = UDim.new(0, 3)
				listPadding.Parent = ddListFrame

				local isOpen = dIsOpen

				local function updateOptions()
					for _, child in ipairs(ddListFrame:GetChildren()) do
						if child:IsA("TextButton") then
							child:Destroy()
						end
					end

					for _, optionName in ipairs(dList) do
						local optBtn = Instance.new("TextButton")
						optBtn.Size = UDim2.new(1, 0, 0, 22)
						optBtn.BackgroundColor3 = (optionName == dSelected) and theme.dropdownItemSelected or theme.element
						optBtn.BackgroundTransparency = (optionName == dSelected) and 0.4 or 1
						optBtn.Text = ""
						optBtn.AutoButtonColor = false
						optBtn.Parent = ddListFrame

						local optCorner = Instance.new("UICorner")
						optCorner.CornerRadius = UDim.new(0, 4)
						optCorner.Parent = optBtn

						local optText = Instance.new("TextLabel")
						optText.Size = UDim2.new(1, -26, 1, 0)
						optText.Position = UDim2.new(0, 6, 0, 0)
						optText.BackgroundTransparency = 1
						optText.Font = fonts.medium
						optText.Text = tostring(optionName)
						optText.TextColor3 = (optionName == dSelected) and theme.text or theme.textDesc
						optText.TextSize = 10.5
						optText.TextXAlignment = Enum.TextXAlignment.Left
						optText.Parent = optBtn

						local optCheck = Instance.new("ImageLabel")
						optCheck.Size = UDim2.new(0, 11, 0, 11)
						optCheck.Position = UDim2.new(1, -16, 0.5, -5.5)
						optCheck.BackgroundTransparency = 1
						clickGui.applyIcon(optCheck, "check")
						optCheck.ImageColor3 = theme.text
						optCheck.Visible = (optionName == dSelected)
						optCheck.Parent = optBtn

						optBtn.MouseEnter:Connect(function()
							tween(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
								BackgroundTransparency = 0.5,
								BackgroundColor3 = theme.dropdownItemHover
							})
							tween(optText, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextColor3 = theme.text})
						end)
						optBtn.MouseLeave:Connect(function()
							tween(optBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
								BackgroundTransparency = (optionName == dSelected) and 0.4 or 1,
								BackgroundColor3 = (optionName == dSelected) and theme.dropdownItemSelected or theme.element
							})
							if optionName ~= dSelected then
								tween(optText, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextColor3 = theme.textDesc})
							end
						end)

						optBtn.MouseButton1Click:Connect(function()
							dSelected = optionName
							ddValueLabel.Text = tostring(optionName)
							isOpen = false
							ddListFrame.Visible = false
							clickGui.applyIcon(ddArrow, "chevron-down")
							updateOptions()
							dCallback(optionName)
						end)
					end
				end

				ddBox.MouseButton1Click:Connect(function()
					isOpen = not isOpen
					ddListFrame.Visible = isOpen
					clickGui.applyIcon(ddArrow, isOpen and "chevron-up" or "chevron-down")
				end)

				ddBox.MouseEnter:Connect(function()
					tween(ddBoxStroke, TweenInfo.new(0.15), {Color = theme.cardBorderHover})
				end)
				ddBox.MouseLeave:Connect(function()
					tween(ddBoxStroke, TweenInfo.new(0.15), {Color = theme.cardBorder})
				end)

				updateOptions()

				local dropdownObj = {}
				function dropdownObj:Set(newVal)
					dSelected = newVal
					ddValueLabel.Text = tostring(newVal)
					updateOptions()
					dCallback(newVal)
				end
				function dropdownObj:Refresh(newList)
					dList = newList
					updateOptions()
				end
				return dropdownObj
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
				toggleRow.Size = UDim2.new(1, 0, 0, tDesc ~= "" and 30 or 20)
				toggleRow.BackgroundTransparency = 1
				toggleRow.LayoutOrder = itemOrder
				toggleRow.Parent = cardFrame

				local textWrap = Instance.new("Frame")
				textWrap.Size = UDim2.new(1, -36, 1, 0)
				textWrap.BackgroundTransparency = 1
				textWrap.Parent = toggleRow

				local textWrapLayout = Instance.new("UIListLayout")
				textWrapLayout.FillDirection = Enum.FillDirection.Vertical
				textWrapLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				textWrapLayout.Padding = UDim.new(0, 1)
				textWrapLayout.Parent = textWrap

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, 0, 0, 14)
				label.BackgroundTransparency = 1
				label.Font = fonts.medium
				label.Text = tName
				label.TextColor3 = theme.text
				label.TextSize = 11.5
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = textWrap

				if tDesc ~= "" then
					local descLabel = Instance.new("TextLabel")
					descLabel.Size = UDim2.new(1, 0, 0, 12)
					descLabel.BackgroundTransparency = 1
					descLabel.Font = fonts.regular
					descLabel.Text = tDesc
					descLabel.TextColor3 = theme.textDesc
					descLabel.TextSize = 9.5
					descLabel.TextXAlignment = Enum.TextXAlignment.Left
					descLabel.TextTruncate = Enum.TextTruncate.AtEnd
					descLabel.Parent = textWrap
				end

				local miniSwitch = Instance.new("TextButton")
				miniSwitch.Size = UDim2.new(0, 26, 0, 13)
				miniSwitch.Position = UDim2.new(1, -26, 0.5, -6.5)
				miniSwitch.BackgroundColor3 = tState and theme.accent or theme.switchOff
				miniSwitch.Text = ""
				miniSwitch.AutoButtonColor = false
				miniSwitch.Parent = toggleRow

				local switchCorner = Instance.new("UICorner")
				switchCorner.CornerRadius = UDim.new(1, 0)
				switchCorner.Parent = miniSwitch

				local switchKnob = Instance.new("Frame")
				switchKnob.Size = UDim2.new(0, 9, 0, 9)
				switchKnob.Position = tState and UDim2.new(1, -11, 0.5, -4.5) or UDim2.new(0, 2, 0.5, -4.5)
				switchKnob.BackgroundColor3 = theme.switchKnob
				switchKnob.BorderSizePixel = 0
				switchKnob.Parent = miniSwitch

				local knobCorner = Instance.new("UICorner")
				knobCorner.CornerRadius = UDim.new(1, 0)
				knobCorner.Parent = switchKnob

				local function updateToggle(val, silent)
					tState = val
					local targetColor = val and theme.accent or theme.switchOff
					local targetKnobPos = val and UDim2.new(1, -11, 0.5, -4.5) or UDim2.new(0, 2, 0.5, -4.5)

					tween(miniSwitch, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor})
					tween(switchKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetKnobPos})

					if not silent and tCallback then
						tCallback(val)
					end
				end

				miniSwitch.MouseButton1Click:Connect(function()
					updateToggle(not tState)
				end)

				local toggleObj = {}
				function toggleObj:Set(val)
					updateToggle(val, false)
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
				sliderContainer.Size = UDim2.new(1, 0, 0, sDesc ~= "" and 42 or 30)
				sliderContainer.BackgroundTransparency = 1
				sliderContainer.LayoutOrder = itemOrder
				sliderContainer.Parent = cardFrame

				local headerRow = Instance.new("Frame")
				headerRow.Size = UDim2.new(1, 0, 0, 14)
				headerRow.BackgroundTransparency = 1
				headerRow.Parent = sliderContainer

				local nameLabel = Instance.new("TextLabel")
				nameLabel.Size = UDim2.new(1, -70, 1, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.Font = fonts.medium
				nameLabel.Text = sName
				nameLabel.TextColor3 = theme.text
				nameLabel.TextSize = 11.5
				nameLabel.TextXAlignment = Enum.TextXAlignment.Left
				nameLabel.Parent = headerRow

				local valueLabel = Instance.new("TextLabel")
				valueLabel.Size = UDim2.new(0, 70, 1, 0)
				valueLabel.Position = UDim2.new(1, -70, 0, 0)
				valueLabel.BackgroundTransparency = 1
				valueLabel.Font = fonts.medium
				valueLabel.TextColor3 = theme.accentLight
				valueLabel.TextSize = 11.5
				valueLabel.TextXAlignment = Enum.TextXAlignment.Right
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

				local trackOffset = 18
				if sDesc ~= "" then
					local descLabel = Instance.new("TextLabel")
					descLabel.Size = UDim2.new(1, 0, 0, 12)
					descLabel.Position = UDim2.new(0, 0, 0, 14)
					descLabel.BackgroundTransparency = 1
					descLabel.Font = fonts.regular
					descLabel.Text = sDesc
					descLabel.TextColor3 = theme.textDesc
					descLabel.TextSize = 9.5
					descLabel.TextXAlignment = Enum.TextXAlignment.Left
					descLabel.TextTruncate = Enum.TextTruncate.AtEnd
					descLabel.Parent = sliderContainer

					trackOffset = 28
				end

				local track = Instance.new("TextButton")
				track.Size = UDim2.new(1, 0, 0, 3)
				track.Position = UDim2.new(0, 0, 0, trackOffset)
				track.BackgroundColor3 = theme.sliderTrack
				track.Text = ""
				track.AutoButtonColor = false
				track.Parent = sliderContainer

				local trackCorner = Instance.new("UICorner")
				trackCorner.CornerRadius = UDim.new(1, 0)
				trackCorner.Parent = track

				local initialPercent = (sDef - sMin) / (sMax - sMin)

				local fill = Instance.new("Frame")
				fill.Size = UDim2.new(initialPercent, 0, 1, 0)
				fill.BackgroundColor3 = theme.accent
				fill.BorderSizePixel = 0
				fill.Parent = track

				local fillCorner = Instance.new("UICorner")
				fillCorner.CornerRadius = UDim.new(1, 0)
				fillCorner.Parent = fill

				local knob = Instance.new("Frame")
				knob.Size = UDim2.new(0, 8, 0, 8)
				knob.Position = UDim2.new(initialPercent, -4, 0.5, -4)
				knob.BackgroundColor3 = theme.bg
				knob.BorderSizePixel = 0
				knob.Parent = track

				local knobCorner = Instance.new("UICorner")
				knobCorner.CornerRadius = UDim.new(1, 0)
				knobCorner.Parent = knob

				local knobStroke = Instance.new("UIStroke")
				knobStroke.Color = theme.accent
				knobStroke.Thickness = 2
				knobStroke.Parent = knob

				local dragging = false

				local function updateSlider(input)
					local absPos = track.AbsolutePosition.X
					local absSize = track.AbsoluteSize.X
					local mouseX = input.Position.X
					local percent = math.clamp((mouseX - absPos) / absSize, 0, 1)
					local rawVal = sMin + (sMax - sMin) * percent
					local finalVal = sDecimals > 0 and tonumber(string.format("%." .. sDecimals .. "f", rawVal)) or math.floor(rawVal + 0.5)

					fill.Size = UDim2.new(percent, 0, 1, 0)
					knob.Position = UDim2.new(percent, -4, 0.5, -4)
					valueLabel.Text = formatValue(finalVal)
					sCallback(finalVal)
				end

				track.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						tween(knob, TweenInfo.new(0.12), {Size = UDim2.new(0, 10, 0, 10)})
						updateSlider(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
						tween(knob, TweenInfo.new(0.12), {Size = UDim2.new(0, 8, 0, 8)})
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateSlider(input)
					end
				end)

				local sliderObj = {}
				function sliderObj:Set(val)
					val = math.clamp(val, sMin, sMax)
					local percent = (val - sMin) / (sMax - sMin)
					fill.Size = UDim2.new(percent, 0, 1, 0)
					knob.Position = UDim2.new(percent, -4, 0.5, -4)
					valueLabel.Text = formatValue(val)
					sCallback(val)
				end
				return sliderObj
			end

			function moduleObject:AddButton(opt)
				opt = opt or {}
				local bName = opt.name or "Button"
				local bDesc = opt.description or ""
				local bCallback = opt.callback or function() end

				itemOrder = itemOrder + 1

				local btnWrap = Instance.new("Frame")
				btnWrap.Size = UDim2.new(1, 0, 0, bDesc ~= "" and 38 or 26)
				btnWrap.BackgroundTransparency = 1
				btnWrap.LayoutOrder = itemOrder
				btnWrap.Parent = cardFrame

				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, 0, 0, 24)
				btn.Position = UDim2.new(0, 0, 0, bDesc ~= "" and 14 or 0)
				btn.BackgroundColor3 = theme.element
				btn.Text = bName
				btn.TextColor3 = theme.text
				btn.Font = fonts.medium
				btn.TextSize = 11
				btn.AutoButtonColor = false
				btn.Parent = btnWrap

				local btnCorner = Instance.new("UICorner")
				btnCorner.CornerRadius = UDim.new(0, 6)
				btnCorner.Parent = btn

				local btnStroke = Instance.new("UIStroke")
				btnStroke.Color = theme.cardBorder
				btnStroke.Thickness = 1.1
				btnStroke.Parent = btn

				if bDesc ~= "" then
					local descLabel = Instance.new("TextLabel")
					descLabel.Size = UDim2.new(1, 0, 0, 12)
					descLabel.BackgroundTransparency = 1
					descLabel.Font = fonts.regular
					descLabel.Text = bDesc
					descLabel.TextColor3 = theme.textDesc
					descLabel.TextSize = 9.5
					descLabel.TextXAlignment = Enum.TextXAlignment.Left
					descLabel.Parent = btnWrap
				end

				btn.MouseEnter:Connect(function()
					tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.elementHover})
				end)
				btn.MouseLeave:Connect(function()
					tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.element})
				end)
				btn.MouseButton1Click:Connect(bCallback)
			end

			function moduleObject:AddKeybind(opt)
				opt = opt or {}
				local kName = opt.name or "Keybind"
				local kDesc = opt.description or ""
				local kDef = opt.default or Enum.KeyCode.None
				local kCallback = opt.callback or function() end

				itemOrder = itemOrder + 1

				local keyRow = Instance.new("Frame")
				keyRow.Size = UDim2.new(1, 0, 0, kDesc ~= "" and 30 or 20)
				keyRow.BackgroundTransparency = 1
				keyRow.LayoutOrder = itemOrder
				keyRow.Parent = cardFrame

				local textWrap = Instance.new("Frame")
				textWrap.Size = UDim2.new(1, -60, 1, 0)
				textWrap.BackgroundTransparency = 1
				textWrap.Parent = keyRow

				local textWrapLayout = Instance.new("UIListLayout")
				textWrapLayout.FillDirection = Enum.FillDirection.Vertical
				textWrapLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				textWrapLayout.Padding = UDim.new(0, 1)
				textWrapLayout.Parent = textWrap

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, 0, 0, 14)
				label.BackgroundTransparency = 1
				label.Font = fonts.medium
				label.Text = kName
				label.TextColor3 = theme.text
				label.TextSize = 11.5
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = textWrap

				if kDesc ~= "" then
					local descLabel = Instance.new("TextLabel")
					descLabel.Size = UDim2.new(1, 0, 0, 12)
					descLabel.BackgroundTransparency = 1
					descLabel.Font = fonts.regular
					descLabel.Text = kDesc
					descLabel.TextColor3 = theme.textDesc
					descLabel.TextSize = 9.5
					descLabel.TextXAlignment = Enum.TextXAlignment.Left
					descLabel.Parent = textWrap
				end

				local pill = Instance.new("TextButton")
				pill.Size = UDim2.new(0, 48, 0, 18)
				pill.Position = UDim2.new(1, -48, 0.5, -9)
				pill.BackgroundColor3 = theme.element
				pill.Text = ""
				pill.AutoButtonColor = false
				pill.Parent = keyRow

				local pillCorner = Instance.new("UICorner")
				pillCorner.CornerRadius = UDim.new(0, 4)
				pillCorner.Parent = pill

				local pillStroke = Instance.new("UIStroke")
				pillStroke.Color = theme.cardBorder
				pillStroke.Thickness = 1.1
				pillStroke.Parent = pill

				local pillIcon = Instance.new("ImageLabel")
				pillIcon.Size = UDim2.new(0, 10, 0, 10)
				pillIcon.Position = UDim2.new(0, 4, 0.5, -5)
				pillIcon.BackgroundTransparency = 1
				clickGui.applyIcon(pillIcon, "key")
				pillIcon.ImageColor3 = theme.textMuted
				pillIcon.Parent = pill

				local pillLabel = Instance.new("TextLabel")
				pillLabel.Size = UDim2.new(1, -16, 1, 0)
				pillLabel.Position = UDim2.new(0, 14, 0, 0)
				pillLabel.BackgroundTransparency = 1
				pillLabel.Font = fonts.medium
				pillLabel.Text = (kDef == Enum.KeyCode.None) and "None" or kDef.Name
				pillLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
				pillLabel.TextSize = 9.5
				pillLabel.TextXAlignment = Enum.TextXAlignment.Center
				pillLabel.TextTruncate = Enum.TextTruncate.AtEnd
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
							pillLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
							listening = false
							conn:Disconnect()
							kCallback(kDef)
						end
					end)
				end)
			end

			return moduleObject
		end

		table.insert(window.tabs, tabObject)
		return tabObject
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == clickGui.toggleKey then
			clickGui.open = not clickGui.open
			if clickGui.open then
				mainFrame.Visible = true
				mainFrame.Size = UDim2.new(0, 870, 0, 520)
				tween(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 900, 0, 540)
				})
			else
				local tw = tween(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 870, 0, 520)
				})
				tw.Completed:Connect(function()
					if not clickGui.open then
						mainFrame.Visible = false
					end
				end)
			end
		end
	end)

	return window
end

function clickGui:Notify(config)
	config = config or {}
	local nTitle = config.title or "Notification"
	local nContent = config.content or ""
	local nDuration = config.duration or 3
	local nIcon = config.icon or "bell"

	if not clickGui.notifyContainer then return end

	local notifyFrame = Instance.new("Frame")
	notifyFrame.Size = UDim2.new(1, 0, 0, 48)
	notifyFrame.BackgroundColor3 = theme.card
	notifyFrame.BorderSizePixel = 0
	notifyFrame.BackgroundTransparency = 1
	notifyFrame.Parent = clickGui.notifyContainer

	local nCorner = Instance.new("UICorner")
	nCorner.CornerRadius = UDim.new(0, 8)
	nCorner.Parent = notifyFrame

	local nStroke = Instance.new("UIStroke")
	nStroke.Color = theme.cardBorder
	nStroke.Transparency = 1
	nStroke.Thickness = 1.1
	nStroke.Parent = notifyFrame

	local nIconImg = Instance.new("ImageLabel")
	nIconImg.Size = UDim2.new(0, 16, 0, 16)
	nIconImg.Position = UDim2.new(0, 12, 0.5, -8)
	nIconImg.BackgroundTransparency = 1
	clickGui.applyIcon(nIconImg, nIcon)
	nIconImg.ImageColor3 = theme.accent
	nIconImg.ImageTransparency = 1
	nIconImg.Parent = notifyFrame

	local nTitleLabel = Instance.new("TextLabel")
	nTitleLabel.Size = UDim2.new(1, -40, 0, 16)
	nTitleLabel.Position = UDim2.new(0, 36, 0, 6)
	nTitleLabel.BackgroundTransparency = 1
	nTitleLabel.Font = fonts.bold
	nTitleLabel.Text = nTitle
	nTitleLabel.TextColor3 = theme.text
	nTitleLabel.TextSize = 12
	nTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	nTitleLabel.TextTransparency = 1
	nTitleLabel.Parent = notifyFrame

	local nDescLabel = Instance.new("TextLabel")
	nDescLabel.Size = UDim2.new(1, -40, 0, 14)
	nDescLabel.Position = UDim2.new(0, 36, 0, 24)
	nDescLabel.BackgroundTransparency = 1
	nDescLabel.Font = fonts.regular
	nDescLabel.Text = nContent
	nDescLabel.TextColor3 = theme.textDesc
	nDescLabel.TextSize = 10
	nDescLabel.TextXAlignment = Enum.TextXAlignment.Left
	nDescLabel.TextTransparency = 1
	nDescLabel.Parent = notifyFrame

	tween(notifyFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
	tween(nStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0})
	tween(nIconImg, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageTransparency = 0})
	tween(nTitleLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0})
	tween(nDescLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0})

	task.delay(nDuration, function()
		tween(notifyFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
		tween(nStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 1})
		tween(nIconImg, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageTransparency = 1})
		tween(nTitleLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1})
		local hideTween = tween(nDescLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1})
		hideTween.Completed:Connect(function()
			notifyFrame:Destroy()
		end)
	end)
end

return clickGui

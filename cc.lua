RegisterNetEvent("AC:cleanareavehy")
RegisterNetEvent("AC:cleanareapedsy")
RegisterNetEvent("AC:cleanareaentityy")
RegisterNetEvent("AC:openmenuy")
RegisterNetEvent("AC:adminmenuenabley")
RegisterNetEvent("AC:invalid")
 
local titolo = "~u~AC ~s~Admin Menu"
local pisellone = PlayerId(-1)
local pisello = GetPlayerName(pisellone)
local showblip = false

local showsprite = false
local nameabove = true
local esp = true
local Enabled = true
local verif = false
local verifcheck = 0

TriggerServerEvent('AC:adminmenuenable')

AddEventHandler("AC:adminmenuenabley", function()
	Enabled = false
	showblip = false
	showsprite = false
	nameabove = false
	esp = false
end)

AddEventHandler("AC:invalid", function()
	ForceSocialClubUpdate()
end)



local LR = {}

LR.debug = false

local function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 2000
	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

	return result
end

local menus = {}
local keys = {up = 172, down = 173, left = 174, right = 175, select = 176, back = 177}
local optionCount = 0

local currentKey = nil
local currentMenu = nil

local menuWidth = 0.21
local titleHeight = 0.10
local titleYOffset = 0.03
local titleScale = 0.9
local buttonHeight = 0.040
local buttonFont = 0
local buttonScale = 0.370
local buttonTextXOffset = 0.005
local buttonTextYOffset = 0.005
local acexd = "errrr_ok_anticheat"
local function debugPrint(text)
	if LR.debug then
		Citizen.Trace("[LR] " .. tostring(text))
	end
end

local function setMenuProperty(id, property, value)
	if id and menus[id] then
		menus[id][property] = value
		debugPrint(id .. " menu property changed: { " .. tostring(property) .. ", " .. tostring(value) .. " }")
	end
end

local function isMenuVisible(id)
	if id and menus[id] then
		return menus[id].visible
	else
		return false
	end
end

local function setMenuVisible(id, visible, holdCurrent)
	if id and menus[id] then
		setMenuProperty(id, "visible", visible)

		if not holdCurrent and menus[id] then
			setMenuProperty(id, "currentOption", 1)
		end

		if visible then
			if id ~= currentMenu and isMenuVisible(currentMenu) then
				setMenuVisible(currentMenu, false)
			end

			currentMenu = id
		end
	end
end

local function drawText(text, x, y, font, color, scale, center, shadow, alignRight)
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextFont(font)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropShadow(2, 2, 0, 0, 0)
	end

	if menus[currentMenu] then
		if center then
			SetTextCentre(center)
		elseif alignRight then
			SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
			SetTextRightJustify(true)
		end
	end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

local function drawRect(x, y, width, height, color)
	DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
end

local function drawTitle()
	if menus[currentMenu] then
		local x = menus[currentMenu].x + menuWidth / 2
		local y = menus[currentMenu].y + titleHeight / 2

		if menus[currentMenu].titleBackgroundSprite then
			DrawSprite(
				menus[currentMenu].titleBackgroundSprite.dict,
				menus[currentMenu].titleBackgroundSprite.name,
				x,
				y,
				menuWidth,
				titleHeight,
				0.,
				255,
				255,
				255,
				255
			)
		else
			drawRect(x, y, menuWidth, titleHeight, menus[currentMenu].titleBackgroundColor)
		end

		drawText(
			menus[currentMenu].title,
			x,
			y - titleHeight / 2 + titleYOffset,
			menus[currentMenu].titleFont,
			menus[currentMenu].titleColor,
			titleScale,
			true
		)
	end
end

local function drawSubTitle()
	if menus[currentMenu] then
		local x = menus[currentMenu].x + menuWidth / 2
		local y = menus[currentMenu].y + titleHeight + buttonHeight / 2

		local subTitleColor = {
			r = menus[currentMenu].titleBackgroundColor.r,
			g = menus[currentMenu].titleBackgroundColor.g,
			b = menus[currentMenu].titleBackgroundColor.b,
			a = 255
		}

		drawRect(x, y, menuWidth, buttonHeight, menus[currentMenu].subTitleBackgroundColor)
		drawText(
			menus[currentMenu].subTitle,
			menus[currentMenu].x + buttonTextXOffset,
			y - buttonHeight / 2 + buttonTextYOffset,
			buttonFont,
			subTitleColor,
			buttonScale,
			false
		)

		if optionCount > menus[currentMenu].maxOptionCount then
			drawText(
				tostring(menus[currentMenu].currentOption) .. " / " .. tostring(optionCount),
				menus[currentMenu].x + menuWidth,
				y - buttonHeight / 2 + buttonTextYOffset,
				buttonFont,
				subTitleColor,
				buttonScale,
				false,
				false,
				true
			)
		end
	end
end

local function drawButton(text, subText)
	local x = menus[currentMenu].x + menuWidth / 2
	local multiplier = nil

	if
		menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and
			optionCount <= menus[currentMenu].maxOptionCount
	 then
		multiplier = optionCount
	elseif
		optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and
			optionCount <= menus[currentMenu].currentOption
	 then
		multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
	end

	if multiplier then
		local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
		local backgroundColor = nil
		local textColor = nil
		local subTextColor = nil
		local shadow = false

		if menus[currentMenu].currentOption == optionCount then
			backgroundColor = menus[currentMenu].menuFocusBackgroundColor
			textColor = menus[currentMenu].menuFocusTextColor
			subTextColor = menus[currentMenu].menuFocusTextColor
		else
			backgroundColor = menus[currentMenu].menuBackgroundColor
			textColor = menus[currentMenu].menuTextColor
			subTextColor = menus[currentMenu].menuSubTextColor
			shadow = true
		end

		drawRect(x, y, menuWidth, buttonHeight, backgroundColor)
		drawText(
			text,
			menus[currentMenu].x + buttonTextXOffset,
			y - (buttonHeight / 2) + buttonTextYOffset,
			buttonFont,
			textColor,
			buttonScale,
			false,
			shadow
		)

		if subText then
			drawText(
				subText,
				menus[currentMenu].x + buttonTextXOffset,
				y - buttonHeight / 2 + buttonTextYOffset,
				buttonFont,
				subTextColor,
				buttonScale,
				false,
				shadow,
				true
			)
		end
	end
end

function LR.CreateMenu(id, title)
	-- Default settings
	menus[id] = {}
	menus[id].title = title
	menus[id].subTitle = acexd

	menus[id].visible = false

	menus[id].previousMenu = nil

	menus[id].aboutToBeClosed = false

	menus[id].x = 0.75
	menus[id].y = 0.19

	menus[id].currentOption = 1
	menus[id].maxOptionCount = 10
	menus[id].titleFont = 1
	menus[id].titleColor = {r = 255, g = 255, b = 255, a = 255}
	Citizen.CreateThread(
		function()
			while true do
				Citizen.Wait(0)
				local ra = RGBRainbow(1.0)
				menus[id].titleBackgroundColor = {r = ra.r, g = ra.g, b = ra.b, a = 105}
				menus[id].menuFocusBackgroundColor = {r = ra.r, g = ra.g, b = ra.b, a = 100} 
			end
		end)
	menus[id].titleBackgroundSprite = nil

	menus[id].menuTextColor = {r = 255, g = 255, b = 255, a = 255}
	menus[id].menuSubTextColor = {r = 189, g = 189, b = 189, a = 255}
	menus[id].menuFocusTextColor = {r = 255, g = 255, b = 255, a = 255}
	menus[id].menuBackgroundColor = {r = 0, g = 0, b = 0, a = 100}

	menus[id].subTitleBackgroundColor = {
		r = menus[id].menuBackgroundColor.r,
		g = menus[id].menuBackgroundColor.g,
		b = menus[id].menuBackgroundColor.b,
		a = 255
	}

	menus[id].buttonPressedSound = {name = "~h~~r~> ~s~SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET"}

	debugPrint(tostring(id) .. " menu created")
end

function LR.CreateSubMenu(id, parent, subTitle)
	if menus[parent] then
		LR.CreateMenu(id, menus[parent].title)

		if subTitle then
			setMenuProperty(id, "subTitle", (subTitle))
		else
			setMenuProperty(id, "subTitle", (menus[parent].subTitle))
		end

		setMenuProperty(id, "previousMenu", parent)

		setMenuProperty(id, "x", menus[parent].x)
		setMenuProperty(id, "y", menus[parent].y)
		setMenuProperty(id, "maxOptionCount", menus[parent].maxOptionCount)
		setMenuProperty(id, "titleFont", menus[parent].titleFont)
		setMenuProperty(id, "titleColor", menus[parent].titleColor)
		setMenuProperty(id, "titleBackgroundColor", menus[parent].titleBackgroundColor)
		setMenuProperty(id, "titleBackgroundSprite", menus[parent].titleBackgroundSprite)
		setMenuProperty(id, "menuTextColor", menus[parent].menuTextColor)
		setMenuProperty(id, "menuSubTextColor", menus[parent].menuSubTextColor)
		setMenuProperty(id, "menuFocusTextColor", menus[parent].menuFocusTextColor)
		setMenuProperty(id, "menuFocusBackgroundColor", menus[parent].menuFocusBackgroundColor)
		setMenuProperty(id, "menuBackgroundColor", menus[parent].menuBackgroundColor)
		setMenuProperty(id, "subTitleBackgroundColor", menus[parent].subTitleBackgroundColor)
	else
		debugPrint("Failed to create " .. tostring(id) .. " submenu: " .. tostring(parent) .. " parent menu doesn't exist")
	end
end

function LR.CurrentMenu()
	return currentMenu
end

function LR.OpenMenu(id)
	if id and menus[id] then
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		setMenuVisible(id, true)

		if menus[id].titleBackgroundSprite then
			RequestStreamedTextureDict(menus[id].titleBackgroundSprite.dict, false)
			while not HasStreamedTextureDictLoaded(menus[id].titleBackgroundSprite.dict) do
				Citizen.Wait(0)
			end
		end

		debugPrint(tostring(id) .. " menu opened")
	else
		debugPrint("Failed to open " .. tostring(id) .. " menu: it doesn't exist")
	end
end

function LR.IsMenuOpened(id)
	return isMenuVisible(id)
end

function LR.IsAnyMenuOpened()
	for id, _ in pairs(menus) do
		if isMenuVisible(id) then
			return true
		end
	end

	return false
end

function LR.IsMenuAboutToBeClosed()
	if menus[currentMenu] then
		return menus[currentMenu].aboutToBeClosed
	else
		return false
	end
end

function LR.CloseMenu()
	if menus[currentMenu] then
		if menus[currentMenu].aboutToBeClosed then
			menus[currentMenu].aboutToBeClosed = false
			setMenuVisible(currentMenu, false)
			debugPrint(tostring(currentMenu) .. " menu closed")
			PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			optionCount = 0
			currentMenu = nil
			currentKey = nil
		else
			menus[currentMenu].aboutToBeClosed = true
			debugPrint(tostring(currentMenu) .. " menu about to be closed")
		end
	end
end

function LR.Button(text, subText)
	local buttonText = text
	if subText then
		buttonText = "{ " .. tostring(buttonText) .. ", " .. tostring(subText) .. " }"
	end

	if menus[currentMenu] then
		optionCount = optionCount + 1

		local isCurrent = menus[currentMenu].currentOption == optionCount

		drawButton(text, subText)

		if isCurrent then
			if currentKey == keys.select then
				PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)
				debugPrint(buttonText .. " button pressed")
				return true
			elseif currentKey == keys.left or currentKey == keys.right then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		debugPrint("Failed to create " .. buttonText .. " button: " .. tostring(currentMenu) .. " menu doesn't exist")

		return false
	end
end

function LR.MenuButton(text, id)
	if menus[id] then
		if LR.Button(text) then
			setMenuVisible(currentMenu, false)
			setMenuVisible(id, true, true)

			return true
		end
	else
		debugPrint("Failed to create " .. tostring(text) .. " menu button: " .. tostring(id) .. " submenu doesn't exist")
	end

	return false
end

function LR.CheckBox(text, bool, callback)
	local checked = "~r~~h~OFF"
	if bool then
		checked = "~g~~h~ON"
	end

	if LR.Button(text, checked) then
		bool = not bool
		debugPrint(tostring(text) .. " checkbox changed to " .. tostring(bool))
		callback(bool)

		return true
	end

	return false
end


function LR.ComboBox(text, items, currentIndex, selectedIndex, callback)
	local itemsCount = #items
	local selectedItem = items[currentIndex]
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

	if itemsCount > 1 and isCurrent then
		selectedItem = '← '..tostring(selectedItem)..' →'
	end

	if LR.Button(text, selectedItem) then
		selectedIndex = currentIndex
		callback(currentIndex, selectedIndex)
		return true
	elseif isCurrent then
		if currentKey == keys.left then
			if currentIndex > 1 then
				currentIndex = currentIndex - 1
			else
				currentIndex = itemsCount
			end
		elseif currentKey == keys.right then
			if currentIndex < itemsCount then
				currentIndex = currentIndex + 1
			else
				currentIndex = 1
			end
		end
	else
		currentIndex = selectedIndex
	end

	callback(currentIndex, selectedIndex)
	return false
end

function LR.Display()
	if isMenuVisible(currentMenu) then
		if menus[currentMenu].aboutToBeClosed then
			LR.CloseMenu()
		else
			ClearAllHelpMessages()

			drawTitle()
			drawSubTitle()

			currentKey = nil

			if IsDisabledControlJustPressed(0, keys.down) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menus[currentMenu].currentOption < optionCount then
					menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1
				else
					menus[currentMenu].currentOption = 1
				end
			elseif IsDisabledControlJustPressed(0, keys.up) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menus[currentMenu].currentOption > 1 then
					menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1
				else
					menus[currentMenu].currentOption = optionCount
				end
			elseif IsDisabledControlJustPressed(0, keys.left) then
				currentKey = keys.left
			elseif IsDisabledControlJustPressed(0, keys.right) then
				currentKey = keys.right
			elseif IsDisabledControlJustPressed(0, keys.select) then
				currentKey = keys.select
			elseif IsDisabledControlJustPressed(0, keys.back) then
				if menus[menus[currentMenu].previousMenu] then
					PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					setMenuVisible(menus[currentMenu].previousMenu, true)
				else
					LR.CloseMenu()
				end
			end

			optionCount = 0
		end
	end
end

function LR.SetMenuWidth(id, width)
	setMenuProperty(id, "width", width)
end

function LR.SetMenuX(id, x)
	setMenuProperty(id, "x", x)
end

function LR.SetMenuY(id, y)
	setMenuProperty(id, "y", y)
end

function LR.SetMenuMaxOptionCountOnScreen(id, count)
	setMenuProperty(id, "maxOptionCount", count)
end

function LR.SetTitleColor(id, r, g, b, a)
	setMenuProperty(id, "titleColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleColor.a})
end

function LR.SetTitleBackgroundColor(id, r, g, b, a)
	setMenuProperty(
		id,
		"titleBackgroundColor",
		{["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleBackgroundColor.a}
	)
end

function LR.SetTitleBackgroundSprite(id, textureDict, textureName)
	setMenuProperty(id, "titleBackgroundSprite", {dict = textureDict, name = textureName})
end

function LR.SetSubTitle(id, text)
	setMenuProperty(id, "subTitle", (text))
end


function LR.SetMenuBackgroundColor(id, r, g, b, a)
	setMenuProperty(
		id,
		"menuBackgroundColor",
		{["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuBackgroundColor.a}
	)
end

function LR.SetMenuTextColor(id, r, g, b, a)
	setMenuProperty(id, "menuTextColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuTextColor.a})
end

function LR.SetMenuSubTextColor(id, r, g, b, a)
	setMenuProperty(id, "menuSubTextColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuSubTextColor.a})
end

function LR.SetMenuFocusColor(id, r, g, b, a)
	setMenuProperty(id, "menuFocusColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuFocusColor.a})
end

function LR.SetMenuButtonPressedSound(id, name, set)
	setMenuProperty(id, "buttonPressedSound", {["name"] = name, ["set"] = set})
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		AddTextEntry("FMMC_KEY_TIP1", "")
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		AddTextEntry("FMMC_KEY_TIP1", "")
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

local function getPlayerIds()
	local players = {}
	for i = 0, GetNumberOfPlayers() do
		if NetworkIsPlayerActive(i) then
			players[#players + 1] = i
		end
	end
	return players
end


function DrawText3D(x, y, z, text, r, g, b)
	SetDrawOrigin(x, y, z, 0)
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.0, 0.20)
	SetTextColour(r, g, b, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function math.round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

	return result
end

local function notify(text, param)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(param, false)
end

local ACIcS = "AceG"
local ACIcZ = titolo
local sMX = "SelfMenu"
local sMXS = "MainMenu"
local TRPM = "TeleportMenu"
local advm = "AdvM"
local VMS = "VehicleMenu"
local OPMS = "OnlinePlayerMenu"
local poms = "PlayerOptionsMenu"
local crds = "Credits"
local MSTC = "MiscTriggers"
local espa = "ESPMenu"

local function DrawTxt(text, x, y)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.4)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function RequestModelSync(mod)
    local model = GetHashKey(mod)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
          Citizen.Wait(0)
    end
end




local function teleporttocoords()
	local pizdax = KeyboardInput("Enter X pos", "", 100)
	local pizday = KeyboardInput("Enter Y pos", "", 100)
	local pizdaz = KeyboardInput("Enter Z pos", "", 100)
	if pizdax ~= "" and pizday ~= "" and pizdaz ~= "" then
			if	IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
					entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
			else
					entity = GetPlayerPed(-1)
			end
			if entity then
				SetEntityCoords(entity, pizdax + 0.5, pizday + 0.5, pizdaz + 0.5, 1, 0, 0, 1)
				notify("~g~Teleported to coords!", false)
			end
else
	notify("~b~Invalid coords!", true)
	end
end

local function TeleportToWaypoint()
	if DoesBlipExist(GetFirstBlipInfoId(8)) then
		local blipIterator = GetBlipInfoIdIterator(8)
		local blip = GetFirstBlipInfoId(8, blipIterator)
		WaypointCoords = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
		wp = true
	else
		notify("~b~No waypoint!", true)
	end

	local zHeigt = 0.0
	height = 1000.0
	while wp do
		Citizen.Wait(0)
		if wp then
			if
				IsPedInAnyVehicle(GetPlayerPed(-1), 0) and
					(GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1))
			 then
				entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
			else
				entity = GetPlayerPed(-1)
			end

			SetEntityCoords(entity, WaypointCoords.x, WaypointCoords.y, height)
			FreezeEntityPosition(entity, true)
			local Pos = GetEntityCoords(entity, true)

			if zHeigt == 0.0 then
				height = height - 25.0
				SetEntityCoords(entity, Pos.x, Pos.y, height)
				bool, zHeigt = GetGroundZFor_3dCoord(Pos.x, Pos.y, Pos.z, 0)
			else
				SetEntityCoords(entity, Pos.x, Pos.y, zHeigt)
				FreezeEntityPosition(entity, false)
				wp = false
				height = 1000.0
				zHeigt = 0.0
				notify("~g~Teleported to waypoint!", false)
				break
			end
		end
	end
end

local function spawnvehicle()
	local ModelName = KeyboardInput("Enter Vehicle Spawn Name", "", 100)
	if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
		RequestModel(ModelName)
		while not HasModelLoaded(ModelName) do
			Citizen.Wait(0)
		end
		local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(PlayerPedId(-1)), GetEntityHeading(PlayerPedId(-1)), true, true)
		SetPedIntoVehicle(PlayerPedId(-1), veh, -1)
	else
		notify("~b~~h~Model is not valid!", true)
	end
end

local function repairvehicle()
	SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
	SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0)
	SetVehicleLights(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
	SetVehicleBurnout(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
	Citizen.InvokeNative(0x1FD09E7390A74D54, GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
	SetVehicleUndriveable(vehicle,false)
end


function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

local Spectating = false

function SpectatePlayer(player)
	local playerPed = PlayerPedId(-1)
	Spectating = not Spectating
	local targetPed = GetPlayerPed(player)

	if (Spectating) then
		local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))

		RequestCollisionAtCoord(targetx, targety, targetz)
		NetworkSetInSpectatorMode(true, targetPed)

		notify("Spectating " .. GetPlayerName(player), false)
	else
		local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))

		RequestCollisionAtCoord(targetx, targety, targetz)
		NetworkSetInSpectatorMode(false, targetPed)

		notify("Stopped Spectating " .. GetPlayerName(player), false)
	end
end


function RequestControl(entity)
	local Waiting = 0
	NetworkRequestControlOfEntity(entity)
	while not NetworkHasControlOfEntity(entity) do
		Waiting = Waiting + 100
		Citizen.Wait(100)
		if Waiting > 5000 then
			notify("Hung for 5 seconds, killing to prevent issues...", true)
		end
	end
end

function getEntity(player)
	local result, entity = GetEntityPlayerIsFreeAimingAt(player, Citizen.ReturnResultAnyway())
	return entity
end

function GetInputMode()
	return Citizen.InvokeNative(0xA571D46727E2B718, 2) and "MouseAndKeyboard" or "GamePad"
end



function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end


local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
	
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
	
		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next
	
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumeratePeds()
		return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
		return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function RotationToDirection(rotation)
	local retz = rotation.z * 0.0174532924
	local retx = rotation.x * 0.0174532924
	local absx = math.abs(math.cos(retx))

	return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
end

function OscillateEntity(entity, entityCoords, position, angleFreq, dampRatio)
	if entity ~= 0 and entity ~= nil then
		local direction = ((position - entityCoords) * (angleFreq * angleFreq)) - (2.0 * angleFreq * dampRatio * GetEntityVelocity(entity))
		ApplyForceToEntity(entity, 3, direction.x, direction.y, direction.z + 0.1, 0.0, 0.0, 0.0, false, false, true, true, false, true)
	end
end

Citizen.CreateThread(
	function()
		while Enabled do
			Citizen.Wait(0)

			--DisplayRadar(true)
			if DeleteGun then
                local cB = getEntity(PlayerId(-1))
                if IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
                    notify(
                        '~g~Delete Gun Enabled!~n~~w~Use The ~b~Pistol~n~~b~Aim ~w~and ~b~Shoot ~w~To Delete!'
                    )
                    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_PISTOL'), 999999, false, true)
                    SetPedAmmo(GetPlayerPed(-1), GetHashKey('WEAPON_PISTOL'), 999999)
                    if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey('WEAPON_PISTOL') then
                        if IsPlayerFreeAiming(PlayerId(-1)) then
                            if IsEntityAPed(cB) then
                                if IsPedInAnyVehicle(cB, true) then
                                    if IsControlJustReleased(1, 142) then
                                        SetEntityAsMissionEntity(GetVehiclePedIsIn(cB, true), 1, 1)
                                        DeleteEntity(GetVehiclePedIsIn(cB, true))
                                        SetEntityAsMissionEntity(cB, 1, 1)
                                        DeleteEntity(cB)
                                        notify('~g~Deleted!')
                                    end
                                else
                                    if IsControlJustReleased(1, 142) then
                                        SetEntityAsMissionEntity(cB, 1, 1)
                                        DeleteEntity(cB)
                                        notify('~g~Deleted!')
                                    end
                                end
                            else
                                if IsControlJustReleased(1, 142) then
                                    SetEntityAsMissionEntity(cB, 1, 1)
                                    DeleteEntity(cB)
                                    notify('~g~Deleted!')
                                end
                            end
                        end
                    end
                end
            end



if esp then
	for i=1,128 do
	  if  ((NetworkIsPlayerActive( i )) and GetPlayerPed( i ) ~= GetPlayerPed( -1 )) then
		--local ra = RGB(1.0)
		local pPed = GetPlayerPed(i)
		local cx, cy, cz = table.unpack(GetEntityCoords(PlayerPedId(-1)))
		local x, y, z = table.unpack(GetEntityCoords(pPed))
		local disPlayerNames = 130
		local disPlayerNamesz = 999999
		  if nameabove then
			distance = math.floor(GetDistanceBetweenCoords(cx,  cy,  cz,  x,  y,  z,  true))
			  if ((distance < disPlayerNames)) then
				if NetworkIsPlayerTalking( i ) then
				  DrawText3D(x, y, z+1.2, GetPlayerServerId(i).."  |  "..GetPlayerName(i), ra.r,ra.g,ra.b)
				else
				  DrawText3D(x, y, z+1.2, GetPlayerServerId(i).."  |  "..GetPlayerName(i), 255,255,255)
				end
			  end
		  end
		local message =
		"Name: " ..
		GetPlayerName(i) ..
		"\nServer ID: " ..
		GetPlayerServerId(i) ..
		"\nPlayer ID: " .. i .. "\nDist: " .. math.round(GetDistanceBetweenCoords(cx, cy, cz, x, y, z, true), 1)
		if IsPedInAnyVehicle(pPed, true) then
				 local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(pPed))))
		  message = message .. "\nVeh: " .. VehName
		end
		if ((distance < disPlayerNamesz)) then
		if espinfo and esp then
		  DrawText3D(x, y, z - 1.0, message, ra.r, ra.g, ra.b)
		end
		if espbox and esp then
		  LineOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)
		  LineOneEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
		  LineTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
		  LineTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
		  LineThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
		  LineThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, -0.9)
		  LineFourBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)

		  TLineOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)
		  TLineOneEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
		  TLineTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
		  TLineTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
		  TLineThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
		  TLineThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, 0.8)
		  TLineFourBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)

		  ConnectorOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, 0.8)
		  ConnectorOneEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, -0.9)
		  ConnectorTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
		  ConnectorTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
		  ConnectorThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)
		  ConnectorThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)
		  ConnectorFourBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
		  ConnectorFourEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)

		  DrawLine(
		  LineOneBegin.x,
		  LineOneBegin.y,
		  LineOneBegin.z,
		  LineOneEnd.x,
		  LineOneEnd.y,
		  LineOneEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  LineTwoBegin.x,
		  LineTwoBegin.y,
		  LineTwoBegin.z,
		  LineTwoEnd.x,
		  LineTwoEnd.y,
		  LineTwoEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  LineThreeBegin.x,
		  LineThreeBegin.y,
		  LineThreeBegin.z,
		  LineThreeEnd.x,
		  LineThreeEnd.y,
		  LineThreeEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  LineThreeEnd.x,
		  LineThreeEnd.y,
		  LineThreeEnd.z,
		  LineFourBegin.x,
		  LineFourBegin.y,
		  LineFourBegin.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  TLineOneBegin.x,
		  TLineOneBegin.y,
		  TLineOneBegin.z,
		  TLineOneEnd.x,
		  TLineOneEnd.y,
		  TLineOneEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  TLineTwoBegin.x,
		  TLineTwoBegin.y,
		  TLineTwoBegin.z,
		  TLineTwoEnd.x,
		  TLineTwoEnd.y,
		  TLineTwoEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  TLineThreeBegin.x,
		  TLineThreeBegin.y,
		  TLineThreeBegin.z,
		  TLineThreeEnd.x,
		  TLineThreeEnd.y,
		  TLineThreeEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  TLineThreeEnd.x,
		  TLineThreeEnd.y,
		  TLineThreeEnd.z,
		  TLineFourBegin.x,
		  TLineFourBegin.y,
		  TLineFourBegin.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  ConnectorOneBegin.x,
		  ConnectorOneBegin.y,
		  ConnectorOneBegin.z,
		  ConnectorOneEnd.x,
		  ConnectorOneEnd.y,
		  ConnectorOneEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  ConnectorTwoBegin.x,
		  ConnectorTwoBegin.y,
		  ConnectorTwoBegin.z,
		  ConnectorTwoEnd.x,
		  ConnectorTwoEnd.y,
		  ConnectorTwoEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  ConnectorThreeBegin.x,
		  ConnectorThreeBegin.y,
		  ConnectorThreeBegin.z,
		  ConnectorThreeEnd.x,
		  ConnectorThreeEnd.y,
		  ConnectorThreeEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		  DrawLine(
		  ConnectorFourBegin.x,
		  ConnectorFourBegin.y,
		  ConnectorFourBegin.z,
		  ConnectorFourEnd.x,
		  ConnectorFourEnd.y,
		  ConnectorFourEnd.z,
		  ra.r,
		  ra.g,
		  ra.b,
		  255
		  )
		end
		if esplines and esp then
		  DrawLine(cx, cy, cz, x, y, z, ra.r, ra.g, ra.b, 255)
		end
	  end
	end
  end
  end


if showCoords then
	x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	roundx = tonumber(string.format("%.2f", x))
	roundy = tonumber(string.format("%.2f", y))
	roundz = tonumber(string.format("%.2f", z))

	DrawTxt("~r~X:~s~ "..roundx, 0.05, 0.00)
	DrawTxt("~r~Y:~s~ "..roundy, 0.11, 0.00)
	DrawTxt("~r~Z:~s~ "..roundz, 0.17, 0.00)
end
if Noclip then
	local currentSpeed = 2
	local noclipEntity =
		IsPedInAnyVehicle(PlayerPedId(-1), false) and GetVehiclePedIsUsing(PlayerPedId(-1)) or PlayerPedId(-1)
	FreezeEntityPosition(PlayerPedId(-1), true)
	SetEntityInvincible(PlayerPedId(-1), true)

	local newPos = GetEntityCoords(entity)

	DisableControlAction(0, 32, true)
	DisableControlAction(0, 268, true)

	DisableControlAction(0, 31, true)

	DisableControlAction(0, 269, true)
	DisableControlAction(0, 33, true)

	DisableControlAction(0, 266, true)
	DisableControlAction(0, 34, true) 

	DisableControlAction(0, 30, true)

	DisableControlAction(0, 267, true) 
	DisableControlAction(0, 35, true) 

	DisableControlAction(0, 44, true)
	DisableControlAction(0, 20, true)

	local yoff = 0.0
	local zoff = 0.0

	if GetInputMode() == "MouseAndKeyboard" then
		if IsDisabledControlPressed(0, 32) then
			yoff = 0.5
		end
		if IsDisabledControlPressed(0, 33) then
			yoff = -0.5
		end
		if IsDisabledControlPressed(0, 34) then
			SetEntityHeading(PlayerPedId(-1), GetEntityHeading(PlayerPedId(-1)) + 3.0)
		end
		if IsDisabledControlPressed(0, 35) then
			SetEntityHeading(PlayerPedId(-1), GetEntityHeading(PlayerPedId(-1)) - 3.0)
		end
		if IsDisabledControlPressed(0, 44) then
			zoff = 0.21
		end
		if IsDisabledControlPressed(0, 20) then
			zoff = -0.21
		end
	end

	newPos =
		GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))

	local heading = GetEntityHeading(noclipEntity)
	SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
	SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
	SetEntityHeading(noclipEntity, heading)

	SetEntityCollision(noclipEntity, false, false)
	SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

	FreezeEntityPosition(noclipEntity, false)
	SetEntityInvincible(noclipEntity, false)
	SetEntityCollision(noclipEntity, true, true)
end
end
end)

Citizen.CreateThread(
	function()
		FreezeEntityPosition(entity, false)
		local playerIdxWeapon = 1;
		local showblip = false
		local WeaponTypeSelect = nil
		local WeaponSelected = nil
		local ModSelected = nil
		local currentItemIndex = 1
		local selectedItemIndex = 1
		local powerboost = { 1.0, 2.0, 4.0, 10.0, 512.0, 9999.0 }
		local spawninside = false
		LR.CreateMenu(ACIcS, ACIcZ)
		LR.CreateSubMenu(sMX, ACIcS, acexd)
		LR.CreateSubMenu(TRPM, ACIcS, acexd)
		LR.CreateSubMenu(advm, ACIcS, acexd)
		LR.CreateSubMenu(VMS, ACIcS, acexd)
		LR.CreateSubMenu(OPMS, ACIcS, acexd)
		LR.CreateSubMenu(poms, OPMS, acexd)
		LR.CreateSubMenu(crds, ACIcS, acexd)
		LR.CreateSubMenu(espa, sMX, acexd)


		local SelectedPlayer

		while Enabled do
			if LR.IsMenuOpened(ACIcS) then
				TriggerServerEvent('AC:checkup')
				DrawTxt("errrr - ~r~Menu ~s~- "..pisello, 0.80, 0.9)
				notify("~u~errrr_ok Anti Cheat", false)
				if LR.MenuButton("~h~~p~#~s~ Admin Menu", sMX) then
				elseif LR.MenuButton("~h~~p~#~s~ Online Players", OPMS) then
				elseif LR.MenuButton("~h~~p~#~s~ Teleport Menu", TRPM) then
				elseif LR.MenuButton("~h~~p~#~s~ Vehicle Menu", VMS) then
				elseif LR.MenuButton("~h~~p~#~s~ Server Options", advm) then
				elseif LR.MenuButton("~p~# ~berrrr Community", crds) then
								end

				LR.Display()
			elseif LR.IsMenuOpened(sMX) then
				if LR.MenuButton("~h~~p~#~s~ ESP Menu", espa) then
				elseif LR.Button("~h~~r~Suicide") then
					SetEntityHealth(PlayerPedId(-1), 0)
				elseif LR.Button("~h~~g~Heal/Revive") then
					SetEntityHealth(PlayerPedId(-1), 200)
				elseif LR.Button("~h~~b~Give Armour") then
					SetPedArmour(PlayerPedId(-1), 200)
				elseif LR.CheckBox("~h~Noclip",Noclip,function(enabled)Noclip = enabled end) then	
				elseif LR.CheckBox("~h~Delete Gun",DeleteGun, function(enabled)DeleteGun = enabled end)  then		
				end

				LR.Display()
            elseif LR.IsMenuOpened(OPMS) then
                local playerlist = GetActivePlayers()
                for i = 1, #playerlist do
                  local currPlayer = playerlist[i]
                  if LR.MenuButton("ID: ~y~["..GetPlayerServerId(currPlayer).."] ~s~"..GetPlayerName(currPlayer).." "..(IsPedDeadOrDying(GetPlayerPed(currPlayer), 1) and "~r~DEAD" or "~g~ALIVE"), 'PlayerOptionsMenu') then
                    SelectedPlayer = currPlayer
                  end
                end
		

				LR.Display()
			elseif LR.IsMenuOpened(poms) then
				LR.SetSubTitle(poms, "Player Options [" .. GetPlayerName(SelectedPlayer) .. "]")

				if LR.Button("~h~Spectate", (Spectating and "~g~[SPECTATING]")) then
					SpectatePlayer(SelectedPlayer)

				
				elseif LR.Button("~h~Teleport To") then
				local Entity = IsPedInAnyVehicle(PlayerPedId(-1), false) and GetVehiclePedIsUsing(PlayerPedId(-1)) or PlayerPedId(-1)
				SetEntityCoords(Entity, GetEntityCoords(GetPlayerPed(SelectedPlayer)), 0.0, 0.0, 0.0, false)


				elseif LR.Button("~h~Give ~r~Vehicle") then
					local ped = GetPlayerPed(SelectedPlayer)
					local ModelName = KeyboardInput("Enter Vehicle Spawn Name", "", 100)
					if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
						RequestModel(ModelName)
						while not HasModelLoaded(ModelName) do
						Citizen.Wait(0)
						end
							local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(ped), GetEntityHeading(ped)+90, true, true)
						else
							notify("~b~Model is not valid!", true)
				end
			end



	LR.Display()
elseif IsDisabledControlPressed(0, 121)  then
			TriggerServerEvent('AC:openmenu')

				LR.Display()
			elseif LR.IsMenuOpened(TRPM) then
				if LR.Button("~h~Teleport to ~g~waypoint") then
					TeleportToWaypoint()
				elseif LR.Button("~h~Teleport to ~r~coords") then
					teleporttocoords()
				elseif LR.CheckBox("~h~Show ~g~Coords", showCoords, function (enabled) showCoords = enabled end) then
			end


				LR.Display()
			elseif LR.IsMenuOpened(VMS) then
				if LR.Button("~h~Spawn ~r~Custom ~s~Vehicle") then
					spawnvehicle()
				elseif LR.Button("~h~~r~Delete ~s~Vehicle") then
					DelVeh(GetVehiclePedIsUsing(PlayerPedId(-1)))
				elseif LR.Button("~h~~g~Repair ~s~Vehicle") then
					repairvehicle()
				elseif LR.CheckBox("~h~Vehicle Godmode", VehGod, function(enabled) VehGod = enabled end)then
			end

--------------------------

LR.Display()
elseif LR.IsMenuOpened(advm) then
	if LR.Button("Clean Area","~g~Vehicles") then
		TriggerServerEvent("AC:cleanareaveh")
	elseif LR.Button("Clean Area","~r~Peds") then
		TriggerServerEvent("AC:cleanareapeds")
	elseif LR.Button("Clean Area","~y~Entity") then
		TriggerServerEvent("AC:cleanareaentity")

end

	LR.Display()
	elseif LR.IsMenuOpened(crds) then
		if LR.Button("~h~discord.gg/JhJ2T7R") then
	end


		LR.Display()
	elseif LR.IsMenuOpened(espa) then
	if LR.CheckBox("~h~~r~ESP ~s~MasterSwitch", esp, function(enabled) esp = enabled end) then
	elseif LR.CheckBox("~h~~r~Name", nameabove, function(enabled) nameabove = enabled end) then
	elseif LR.CheckBox("~h~~r~ESP ~s~Box", espbox, function(enabled) espbox = enabled end) then
	elseif LR.CheckBox("~h~~r~ESP ~s~Info", espinfo, function(enabled) espinfo = enabled end) then
	elseif LR.CheckBox("~h~~r~ESP ~s~Lines", esplines, function(enabled) esplines = enabled end) then
	end

		LR.Display()
			end
			Citizen.Wait(0)
		end
	end)



	AddEventHandler("AC:cleanareavehy", function()
		for vehicle in EnumerateVehicles() do
			  SetEntityAsMissionEntity(GetVehiclePedIsIn(vehicle, true), 1, 1)
			  DeleteEntity(GetVehiclePedIsIn(vehicle, true))
			  SetEntityAsMissionEntity(vehicle, 1, 1)
			  DeleteEntity(vehicle)
			end
	end)

	AddEventHandler("AC:cleanareapedsy", function()
		PedStatus = 0
		for ped in EnumeratePeds() do
			PedStatus = PedStatus + 1
			if not (IsPedAPlayer(ped))then
				RemoveAllPedWeapons(ped, true)
				DeleteEntity(ped)
			end
		end
	end)

	AddEventHandler("AC:cleanareaentityy", function()
		objst = 0
		for obj in EnumerateObjects() do
			objst = objst + 1
				DeleteEntity(obj)
		end
	end)

	AddEventHandler("AC:openmenuy", function()
		LR.OpenMenu(ACIcS)
	end)


	if Config.AntiCheat then
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(1000)	
		SetPedInfiniteAmmoClip(PlayerPedId(), false)
		SetPlayerInvincible(PlayerId(), false)
		SetEntityInvincible(PlayerPedId(), false)
		SetEntityCanBeDamaged(PlayerPedId(), true)
		ResetEntityAlpha(PlayerPedId())
			end
		end)
	end

	if Config.AntiGodmode then
		Citizen.CreateThread(function()
			while true do
				 Citizen.Wait(30000)
					local curPed = PlayerPedId()
					local curHealth = GetEntityHealth( curPed )
					SetEntityHealth( curPed, curHealth-2)
					local curWait = math.random(10,150)
					Citizen.Wait(curWait)
					if not IsPlayerDead(PlayerId()) then
						if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
							TriggerServerEvent("FajnyAc", "⚡️ Godmode",true)
						elseif GetEntityHealth(curPed) == curHealth-2 then
							SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
						end
					end
					if GetEntityHealth(PlayerPedId()) > 200 then
						TriggerServerEvent("FajnyAc", "⚡️ Godmode",true)
					end
					if GetPedArmour(PlayerPedId()) < 200 then
						Wait(50)
						if GetPedArmour(PlayerPedId()) == 200 then
							TriggerServerEvent("FajnyAc", "⚡️ Godmode",true)
						end
				end
			end
		end)
	end

if Config.AntiSpectate then
	Citizen.CreateThread(function()
    	while true do
        	Citizen.Wait(1000)
			if NetworkIsInSpectatorMode() then
    			TriggerServerEvent("AC:spectate")
    		end
		end
	end)
end

BlacklistedCmdsxd = {"chocolate","pk","panickey","killmenu","panik","ssssss","brutan","panic","desudo","jd","ham","hammafia","hamhaxia","redstonia, xariesmenu, MainMenu, xaries, SelfMenu, xseira, LuxUI", "rootMenu"}

if Config.AntiBlacklistedCmds then
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1000)
		for _, bcmd in ipairs(GetRegisteredCommands()) do
		for _, bcmds in ipairs(BlacklistedCmdsxd) do
				if bcmd.name == bcmds then
					TriggerServerEvent("FajnyAc","⚡️ Injection detected!",true)
			end
		end
		end
	end
end)
end

if Config.AntiBlips then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			local blipcount = 0
			local playerlist = GetActivePlayers()
				for i = 1, #playerlist do
					if i ~= PlayerId() then
					if DoesBlipExist(GetBlipFromEntity(GetPlayerPed(i))) then
						blipcount = blipcount + 1
					end
				end
					if blipcount > 0 then
						TriggerServerEvent("FajnyAc","⚡️ PlayerBlips Violation",true)
					end
				end
		end
	end)
end

if Config.AntiBlacklistedWeapons then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			for _,theWeapon in ipairs(Config.BlacklistedWeapons) do
				Wait(1)
				if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 then
						RemoveWeaponFromPed(PlayerPedId(),GetHashKey(theWeapon))
						TriggerServerEvent("FajnyAc","⚡️ Blacklisted Weapon: "..theWeapon,Config.AntiBlacklistedWeaponsKick)
				end
			end
		end
	end)
end
	
	local isInvincible = false
local isAdmin = false

Citizen.CreateThread(function()
    while true do
        isInvincible = GetPlayerInvincible(PlayerId())
        isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
        Citizen.Wait(500)
    end
end)

function DrawLabel(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

RegisterNetEvent("sendAcePermissionToClient")
AddEventHandler("sendAcePermissionToClient", function(state)
    isAdmin = state
end)

if Config.PlayerProtection then
	SetEntityProofs(GetPlayerPed(-1), false, true, true, false, false, false, false, false)		
end

if Config.AntiSpeedHack then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			local speed = GetEntitySpeed(PlayerPedId())
			if not IsPedInAnyVehicle(GetPlayerPed(-1), 0) then
			if speed > 80 then
				TriggerServerEvent("FajnyAc","⚡️ SpeedHack",true)
			end
		end
		end
	end)
end

if Config.AntiKey then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if Config.AntiKeyInsert then
				if IsControlJustReleased(0, 121) then
					TriggerServerEvent("FajnyAc","⚡️ Insert Blacklisted Key",true)
				end
			end
			if Config.AntiKeyTabQ then
				if IsDisabledControlPressed(0, 37) and IsDisabledControlPressed(0, 44) then
					TriggerServerEvent("FajnyAc","⚡️ Tab+Q Blacklisted Key",true)
				end
			end
			if Config.AntiKeyShiftG then
				if IsDisabledControlPressed(0, 47) and IsDisabledControlPressed(0, 21) then
					TriggerServerEvent("FajnyAc","⚡️ Shift+G Blacklisted Key",true)
				end
			end
		end
	end)
end
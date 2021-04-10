AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  print(GetCurrentResourceName().." -- Started")
end)
HugeAC = {
  'esx_garba5gejob:pay'
}

lol = {
'Desudo',
'Brutan',
'EulenCheats',
"TAJNEMENUMenu",
"RedEngine",
"Brutan Premium",
"https://dc.xaries.pl",
"SKAZA",
"SKAZA V500",
"redengine",
"lynxmenu",
"xaries",
"xariesgang2",
"xariesgang3",
"xariesv2",
'xariesgang3',
"xaries gang 3*",
"ariesv1.0_1_1",
"BEE_1",
"HamHaxia",
"Ham Mafia",
"https://dc.xaries.pl",
"www.renalua.com",
"Fallen#0811",
"Rena 8",
"HamHaxia",
"Ham Mafia",
"Xanax#0134",
">:D Player Crash",
"34ByTe Community",
"lynxmenu.com",
"Anti-Spartan",
"MainMenu",
"SelfMenu",
"Baran#8992",
"iLostName#7138",
"LynX",
"LynxX",
"stt_prop_stunt_soccer_ball",
"WarMenu",
"INTERHugeACTION MENU",
"ARIES MENU",
"XARIES",
"666 GANG",
"Lynx",
"6666",
"85.190.90.118",
"Melon#1379",
"hammafia.com",
"TITOMODZ",
"xseira",
"rootMenu",
"LuxUI",
"AlphaV ~ 5391",
"Soviet Bear",
"fefev",
"ariesMenu",
"AlikhanCheats",
"ariesMenu",
"werfvtghiouuiowrfetwerfio",
"Lynx8",
"LynxSeven",
"KoGuSzEk",
"lynxunknowncheats",
"BrutanPremium",
"gaybuild",
"TiagoMenu",
"Dopamine",
"Plane",
"MMenu",
"nigmenu0001",
"HamMafia",
"b00mek",
"LynxEvo",
"WarMenu",
}

RegisterServerEvent("HugeAC:cleanareaveh")
RegisterServerEvent("HugeAC:cleanareapeds")
RegisterServerEvent("HugeAC:cleanareaentity")
RegisterServerEvent("HugeAC:enable")
RegisterServerEvent("HugeAC:log")
RegisterServerEvent("HugeAC:spectate")
RegisterServerEvent("HugeAC:openmenu")
RegisterServerEvent("HugeAC:checkup")
RegisterServerEvent("HugeAC:adminmenuenable")
RegisterServerEvent("HugeAC:ViolationDetected")
RegisterServerEvent("HugeAC:askAwake")



function doesPlayerHavePerms(player,perms)
  local allowed = false
  for k,v in ipairs(perms) do
      if IsPlayerAceAllowed(player, v) then
          return true
      end
  end
  return false
end

AddEventHandler('explosionEvent', function(sender, ev)
  local j=GetPlayerName(sender)
  local k=GetPlayerEndpoint(sender)
  local m=GetPlayerIdentifier(sender)
  local gra="EXPLOSIONS"
        local n= {
        {
        ["color"]="8663711",
        ["title"]="HugeAC",
        ["description"]="***```DETECT REASON:".. gra .."```*** \n\n > PLAYER: ***".. j .."***\n > IP ADRESS: ***".. k .."***\n > PLAYER HEX ***".. m .."***",
        ["footer"]=
        {
            ["text"]="https://discord.gg/gT8Gczf"},
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
        }
    }

    PerformHttpRequest(Config.webhook,function(f,o,h)end,'POST',json.encode({username="Cheater",embeds=n}),{['Content-Type']='application/json'})
  CancelEvent()
end)

local ace_perm = "HugeACadmin"
local debug = false

function ProcessAces()
    if GetNumPlayerIndices() > 0 then
        for i=0, GetNumPlayerIndices()-1 do
            player = tonumber(GetPlayerFromIndex(i))
            Citizen.Wait(0)
            if IsPlayerAceAllowed(player, ace_perm) then
                TriggerClientEvent("sendAcePermissionToClient", player, true)
                if debug then print("[DEBUG][" .. GetCurrentResourceName() .. "] ^5Syncronising player aces, sending to client...^0") end
            end
        end
    end
end
RegisterServerEvent('HugeAC:ban')
AddEventHandler('HugeAC:ban', function(argument, powod, typkary)
  argument_ = argument
  if argument_ == source then
  zapiszsql(source, 'Godmode', 'BAN')
  local j=GetPlayerName(source)
  local m=GetPlayerIdentifier(source)
  DropPlayer(source, '⚡️ This server is protected by HugeAC')

  else
  zapiszsql(source, 'Event Triggering: HugeAC:ban', 'BAN')
  local j=GetPlayerName(source)
  local m=GetPlayerIdentifier(source)
  DropPlayer(source, '⚡️ This server is protected by HugeAC')

  end
end)

Citizen.CreateThread(function()
    while true do
        ProcessAces()
        Citizen.Wait(30000)
    end
end)

AddEventHandler("onResourceStart", function(name)
    if name == GetCurrentResourceName() then
        ProcessAces()
        if debug then print("[DEBUG][" .. GetCurrentResourceName() .. "] ^6Resource [ " .. GetCurrentResourceName() .. " ] was (re)started, syncing aces to all players.^0") end
    end
end)

local ListaBanow         = {}
local ListaBanowStatus   = false
local czasreload         = 1000 * 10 * 5

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

CreateThread(function()
  while true do
    Wait(1000)
        if ListaBanowStatus == false then
      LoadBany()
      if ListaBanow ~= {} then
        ListaBanowStatus = true
      end
    end
  end
end)

CreateThread(function()
  while true do
    Wait(czasreload)
    LoadBany()
  end
end)

function LoadBany()
  MySQL.Async.fetchAll(
    'SELECT * FROM HugeACbans',
    {},
    function (identifiers)
      ListaBanow = {}

      for i=1, #identifiers, 1 do
        table.insert(ListaBanow, {
			identifier           = identifiers[i].identifier,
			license              = identifiers[i].license,
			ip                   = identifiers[i].ip,
			discord              = identifiers[i].discord,
			nazwa                = identifiers[i].nazwa,
			powod                = identifiers[i].powod,
			typkary              = identifiers[i].typkary,
			datanadania          = identifiers[i].datanadania,
			liveid               = identifiers[i].liveid,
			xbl                  = identifiers[i].xbl,
          })
      end
    end
  )
end

function zapiszsql(target, powod, typkary, czas)
  local identifier    = nil
  local license       = nil
  local playerip      = nil
  local playerdiscord = nil
  local liveid        = nil
  local xbl       = nil
  local nazwa         = GetPlayerName(target)
  local powod         = tostring(powod)
  local typkary       = typkary
  local datanadania   = os.date("%Y/%m/%d %H:%M")

  for k,v in pairs(GetPlayerIdentifiers(target))do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      identifier = v
    elseif string.sub(v, 1, string.len("license:")) == "license:" then
      license = v
    elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
      xbl  = v
    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
      playerip = v
    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
      playerdiscord = v
    elseif string.sub(v, 1, string.len("live:")) == "live:" then
      liveid = v
    end
  end

  if playerip == nil then
    playerip = GetPlayerEndpoint(target)
    if playerip == nil then
      playerip = 'not found'
    end
  end
  if playerdiscord == nil then
    playerdiscord = 'not found'
  end
  if liveid == nil then
    liveid = 'not found'
  end
  if xbl == nil then
    xbl = 'not found'
  end

  MySQL.Async.execute(
    'INSERT INTO HugeACbans (identifier,license,ip,discord,nazwa,powod,typkary,datanadania,liveid,xbl) VALUES (@identifier,@license,@ip,@discord,@nazwa,@powod,@typkary,@datanadania,@liveid,@xbl)', {
      ['@identifier'] = identifier,
      ['@license'] = license,
      ['@ip'] = playerip,
      ['@discord'] = playerdiscord,
      ['@nazwa'] = nazwa,
      ['@powod'] = powod,
      ['@typkary'] = typkary,
      ['@datanadania'] = datanadania,
      ['@liveid'] = liveid,
      ['@xbl'] = xbl,
    },
    function ()
  end)
end

AddEventHandler('playerConnecting', function (playerName,setKickReason)

  local identifier    = nil
  local license       = nil
  local playerip      = nil
  local playerdiscord = nil
  local liveid        = nil
  local xbl       = nil
  local nazwa         = GetPlayerName(source)

  for k,v in pairs(GetPlayerIdentifiers(source))do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      identifier = v
    elseif string.sub(v, 1, string.len("license:")) == "license:" then
      license = v
    elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
      xbl  = v
    elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
      playerip = v
    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
      playerdiscord = v
    elseif string.sub(v, 1, string.len("live:")) == "live:" then
      liveid = v
    end
  end

  if playerip == nil then
    playerip = GetPlayerEndpoint(source)
    if playerip == nil then
      playerip = 'nie ma'
    end
  end
  if playerdiscord == nil then
    playerdiscord = 'nie ma'
  end
  if liveid == nil then
    liveid = 'nie ma'
  end
  if xbl == nil then
    xbl = 'nie ma'
  end

  if (ListaBanow == {}) then
    Citizen.Wait(1000)
  end

    if identifier == false then
    setKickReason('You need to have open steam to acces this server')
    CancelEvent()
    end
  for i = 1, #ListaBanow, 1 do
    if (tostring(ListaBanow[i].identifier)) == tostring(identifier)
    or (tostring(ListaBanow[i].license)) == tostring(license)
    or (tostring(ListaBanow[i].xbl)) == tostring(xbl)
    or (tostring(ListaBanow[i].liveid)) == tostring(liveid)
    or (tostring(ListaBanow[i].ip)) == tostring(playerip)
    or (tostring(ListaBanow[i].discord)) == tostring(playerdiscord)
    and (tostring(ListaBanow[i].typkary)) == 'BAN' then

      setKickReason('⚡️ This server is protected by HugeAC')
      print('[HugeAC] User: ' .. GetPlayerName(source) .. ' - tried to connect the server being banned')
      CancelEvent()
    end
  end
end)



function HugeAClogkick(source,arg,arg2,skrypt,kick)
  local steamid = "nA"
  local discord = "nA"
  local license = "nA"
  for k,v in ipairs(GetPlayerIdentifiers(source))do
    if string.sub(v, 1, string.len("steam:")) == "steam:" then
      steamid = v
    elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
      discord = v
    elseif string.sub(v, 1, string.len("license:")) == "license:" then
      license = v
    end
  end
 	local j=GetPlayerName(source)
	local k=GetPlayerEndpoint(source)
	local hex=GetPlayerIdentifier(source)
    local n= {
        {
        ["color"]="3596740",
        ["title"]="**Huge AC [WYKRYTO CHEATY]**",
        ["description"]="Cheater: ***".. j .."***\nPowód: ***".. arg .."***\n Steam hex: ***".. hex .."***\n SKRYPT: ***"..skrypt.."***\n",
        ["footer"]=
        {
            ["text"]="🥤HugeAC Ban Room"},
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
        }
    }
    local g= {
        {
        ["color"]="3596740",
        ["title"]="**Huge AC [WYKRYTO CHEATY]**",
        ["description"]="Cheater: ***".. j .."***\nPowód: ***".. arg .."***\n Dokładny powód: ***".. arg2 .. "***\n Steam hex: ***".. hex .."***\n IP: ***".. k .."***\n SKRYPT: ***"..skrypt.."***\n",
        ["footer"]=
        {
            ["text"]="🥤HugeAC Ban Room"},
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
        }
    }

    PerformHttpRequest(Config.webhook,function(f,o,h)end,'POST',json.encode({username="HugeAC LOGS",embeds=n}),{['Content-Type']='application/json'})
	PerformHttpRequest(Config.webhook2,function(f,o,h)end,'POST',json.encode({username="Private",embeds=g}),{['Content-Type']='application/json'})
  
  if kick then
  local j=GetPlayerName(source)
  local m=GetPlayerIdentifier(source)
	DropPlayer(source, arg)
	print("HugeAC LOGS: Cheater Detected")
  end
end

AddEventHandler("HugeAC:ViolationDetected", function(arg,kick)
  if not doesPlayerHavePerms(source,Config.Bypass) then
  HugeAClogkick(source,arg,kick)
  end
end)

AddEventHandler("HugeAC:adminmenuenable", function()
  for k,v in ipairs(Config.OpenMenuAllowed) do
  if not IsPlayerAceAllowed(source, v) then
    TriggerClientEvent('adminmenuenabley',source)
  end
end
end)

AddEventHandler("HugeAC:checkup", function()
  if not doesPlayerHavePerms(source,Config.OpenMenuAllowed) then
    HugeAClogkick(source,"unauthorized AdminMenu Opening")
    end
end)

AddEventHandler("HugeAC:openmenu", function()
  for k,v in ipairs(Config.OpenMenuAllowed) do
  if IsPlayerAceAllowed(source, v) then
    TriggerClientEvent('HugeAC:openmenuy', source)
  end
end
end)


AddEventHandler("HugeAC:cleanareaveh", function()
 if doesPlayerHavePerms(source,Config.ClearAreaAllowed) then
  TriggerClientEvent("HugeAC:cleanareavehy",-1)
else
  HugeAClogkick(source," unauthorized Clear Area",true)
end
end)

AddEventHandler("HugeAC:cleanareapeds", function()
  if doesPlayerHavePerms(source,Config.ClearAreaAllowed) then
    TriggerClientEvent("HugeAC:cleanareapedsy",-1)
  else
    HugeAClogkick(source," unauthorized Clear Area",true)
  end
  end)

AddEventHandler("HugeAC:cleanareaentity", function()
  if doesPlayerHavePerms(source,Config.ClearAreaAllowed) then
    TriggerClientEvent("HugeAC:cleanareaentityy",-1)
  else
    HugeAClogkick(source," unauthorized Clear Area",true)
  end
  end)

AddEventHandler("HugeAC:spectate", function()
  if not doesPlayerHavePerms(source,Config.SpectateAllowed) then
    HugeAClogkick(source," Spectate",true)
end

end)

for i=1, #HugeAC, 1 do
  RegisterServerEvent(HugeAC[i])
    AddEventHandler(HugeAC[i], function()
      local _source = source
	  Citizen.Wait(1000)
      HugeAClogkick(source,"Zły trigger kolego ;)",GetCurrentResourceName(),true)
    end)
end

RegisterServerEvent("foundyou")
AddEventHandler("foundyou", function(reason, reason2, skrypt)
      local _source = source
      HugeAClogkick(source,reason,reason2,skrypt,true)
end)

AddEventHandler('chatMessage', function(source, n, message)
  for k,n in pairs(lol) do
    if string.match(message:lower(),n:lower()) then
      HugeAClogkick(source,"tried to say: "..n,true)
    end
  end
end)

RegisterServerEvent("adminmenu:allowall")
AddEventHandler("adminmenu:allowall", function()
	DropPlayer(source, "Hmmmmmmmmm :0")
end)

local blacklisted = 
    {
        "/ooc kogusz menu! Buy at https://discord.gg/BbDMhJe",
        "/ooc Baggy Menu! Buy at https://discord.gg/AGxGDzg",
        "/ooc Desudo Menu! Buy at https://discord.gg/hkZgrv3",
        "/ooc Yo add me Fallen#0811",
        "/ooc \107\111\103\117\115\122\10 menu! Buy at https://discord.gg/BM5zTvA",
        "BAGGY menu <3 https://discord.gg/AGxGDzg",
        "KoGuSzMENU <3 https://discord.gg/BbDMhJe",
        "KoGuSzMENU <3 https://discord.gg/BM5zTvA",
        "Desudo menu <3 https://discord.gg/hkZgrv3",
        "Yo add me Fallen#0811",
        "Lynx 8 ~ www.lynxmenu.com",
        "Lynx 7 ~ www.lynxmenu.com",
        "lynxmenu.com",
        "www.lynxmenu.com",
        "You got raped by Lynx 8",
        "^0Lynx 8 ~ www.lynxmenu.com",
        "^0AlphaV ~ 5391",
        "^0You got raped by AlphaV",
        "^0TITO MODZ - Cheats and Anti-Cheat",
        "^0https://discord.gg/AGxGDzg",
        "^0https://discord.gg/hkZgrv3",
        "You just got fucked mate",
        "Add me Fallen#0811",
        "Desudo; Plane#000",
        "BAGGY; baggy#6875",
        "SKAZAMENU",
        "skaza",
        "aries",
        "youtube.com"
    }
	

AddEventHandler('chatMessage', function(source, name, message)
    
local name = GetPlayerName(source) -- nick
local ip = GetPlayerEndpoint(source) -- ip chwilowo nie dziala
local steamhex = GetPlayerIdentifier(source) -- hex
local id = GetPlayerLastMsg(source)
  for i , word in ipairs(blacklisted) do
    if string.match(message, word) then
        sendtowebhook()
        DropPlayer(source, 'HugeAC: I think you write the wrong word :)')
        CancelEvent()
        end
    end
end)




local dostali_juz_sourcecode = {}
RegisterNetEvent("something")
AddEventHandler("something", function()
    if not dostali_juz_sourcecode[source] then
	TriggerClientEvent("something", source, source_code)
    dostali_juz_sourcecode[source] = true
  else
    return
    end
end)

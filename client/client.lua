MenuData = {}
TriggerEvent("redemrp_menu_base:getData",function(call)
    MenuData = call
end)

local baitshop = {

    { x= 3027.28, y = 562.45, z = 44.72 }, -- bait shop van horn
	{ x= 2162.21, y = -619.79, z = 42.88 }, -- bait shop lagras
	{ x= 339.87, y = -667.75, z = 42.81 }, -- bait shop stranger house
	
}

local active = false
local ShopPrompt
local hasAlreadyEnteredMarker, lastZone
local currentZone = nil

function SetupShopPrompt()
    Citizen.CreateThread(function()
        local str = 'Open Bait Shop'
        ShopPrompt = PromptRegisterBegin()
        PromptSetControlAction(ShopPrompt, 0xE8342FF2)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(ShopPrompt, str)
        PromptSetEnabled(ShopPrompt, false)
        PromptSetVisible(ShopPrompt, false)
        PromptSetHoldMode(ShopPrompt, true)
        PromptRegisterEnd(ShopPrompt)

    end)
end

AddEventHandler('qb-baitshop:hasEnteredMarker', function(zone)
    currentZone     = zone
end)

AddEventHandler('qb-baitshop:hasExitedMarker', function(zone)
    if active == true then
        PromptSetEnabled(ShopPrompt, false)
        PromptSetVisible(ShopPrompt, false)
        active = false
    end
    WarMenu.CloseMenu()
	currentZone = nil
end)

Citizen.CreateThread(function()
    SetupShopPrompt()
    while true do
        Citizen.Wait(0)
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local isInMarker, currentZone = false

        for k,v in ipairs(baitshop) do
            if (Vdist(coords.x, coords.y, coords.z, v.x, v.y, v.z) < 1.5) then
                isInMarker  = true
                currentZone = 'baitshop'
                lastZone    = 'baitshop'
            end
        end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('qb-baitshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('qb-baitshop:hasExitedMarker', lastZone)
		end

    end
end)

-- menu start
Citizen.CreateThread(function()
    WarMenu.CreateMenu('baitshop', "Bait Shop")
    WarMenu.SetSubTitle('baitshop', 'welcome great hunter')
    WarMenu.CreateSubMenu('buy', 'baitshop', 'welcome great hunter')
    WarMenu.CreateSubMenu('sell', 'baitshop', 'welcome great hunter')

    while true do

        if WarMenu.IsMenuOpened('baitshop') then
            if WarMenu.MenuButton('Buy Bait & Rod', 'buy') then
            end
            if WarMenu.MenuButton('Sell your Fish', 'sell') then
            end
            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('buy') then
            if WarMenu.Button('Buy Fishing Rod for ~pa~10$') then
				TriggerServerEvent("qb-baitshop:buyrod", 10, "WEAPON_FISHINGROD", 1)  
            elseif WarMenu.Button('Buy Bread Bait for ~pa~2$') then
				TriggerServerEvent("qb-baitshop:buybait", 2, "p_baitBread01x", 1)
			elseif WarMenu.Button('Buy Cheese Bait for ~pa~2$') then
				TriggerServerEvent("qb-baitshop:buybait", 2, "p_baitCheese01x", 1)
			elseif WarMenu.Button('Buy Corn Bait for ~pa~2$') then
				TriggerServerEvent("qb-baitshop:buybait", 2, "p_baitCorn01x", 1)
			elseif WarMenu.Button('Buy Cricket Bait for ~pa~2$') then
				TriggerServerEvent("qb-baitshop:buybait", 2, "p_baitCricket01x", 1)
			elseif WarMenu.Button('Buy River Bait for ~pa~2$') then
				TriggerServerEvent("qb-baitshop:buybait", 2, "p_finishedragonfly01x", 1)
			elseif WarMenu.Button('Buy Lake Bait for ~pa~2$') then
				TriggerServerEvent("qb-baitshop:buybait", 2, "p_FinisdFishlure01x", 1)
			elseif WarMenu.Button('Buy Swamp Bait for ~pa~2$') then
				TriggerServerEvent("qb-baitshop:buybait", 2, "p_finishdcrawd01x", 1)
            end
            WarMenu.Display()
			
        elseif WarMenu.IsMenuOpened('sell') then
            if WarMenu.Button('Sell your small fish') then
				TriggerServerEvent("qb-baitshop:sellsmallfish", 1)  
            elseif WarMenu.Button('Sell your medium fish') then
				TriggerServerEvent("qb-baitshop:sellmediumfish", 1)
			elseif WarMenu.Button('Sell your large fish') then
				TriggerServerEvent("qb-baitshop:selllargefish", 1)
            end
            WarMenu.Display()
        
        end
        Citizen.Wait(0)
    end
end)
-- menu stop

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        if currentZone then
            if active == false then
                PromptSetEnabled(ShopPrompt, true)
                PromptSetVisible(ShopPrompt, true)
                active = true
            end
            if PromptHasHoldModeCompleted(ShopPrompt) then
				WarMenu.OpenMenu('baitshop')
                WarMenu.Display()
                PromptSetEnabled(ShopPrompt, false)
                PromptSetVisible(ShopPrompt, false)
                active = false

				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)



RegisterNetEvent('qb-baitshop:alert')	
AddEventHandler('qb-baitshop:alert', function(txt)
    SetTextScale(0.5, 0.5)
    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", txt, Citizen.ResultAsLong())
    Citizen.InvokeNative(0xFA233F8FE190514C, str)
    Citizen.InvokeNative(0xE9990552DEC71600)
end)

RegisterNetEvent('give:weapon')
AddEventHandler('give:weapon', function(weapon)
    Citizen.CreateThread(function()
        local weapon = GetHashKey(weapon)
		local playerPed = PlayerPedId()
        Wait(1000)
		GiveDelayedWeaponToPed(playerPed, weapon, 0, true, 0)
	end, false)
end)
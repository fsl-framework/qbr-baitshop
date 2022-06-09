local blips = {
	{ name = 'Bait Shop', sprite = 2719371534, x= 3027.28, y = 562.45, z = 44.72 }, -- bait shop van horn
	{ name = 'Bait Shop', sprite = 2719371534, x= 2162.21, y = -619.79, z = 42.88 }, -- bait shop lagras
	{ name = 'Bait Shop', sprite = 2719371534, x= 339.87, y = -667.75, z = 42.81 }, -- bait shop stranger house
}

Citizen.CreateThread(function()
	for _, info in pairs(blips) do
        local blip = N_0x554d9d53f696d002(1664425300, info.x, info.y, info.z)
        SetBlipSprite(blip, info.sprite, 1)
		SetBlipScale(blip, 0.2)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip, info.name)
    end  
end)
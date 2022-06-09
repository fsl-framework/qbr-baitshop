local data = {}
TriggerEvent("redemrp_inventory:getData",function(call)
    data = call
end)

RegisterServerEvent('qb-baitshop:buyrod')
AddEventHandler("qb-baitshop:buyrod", function(price, item, lvl)
    TriggerEvent("redemrp:getPlayerFromId", source, function(user)
        local identifier = user.getIdentifier()
		local level = user.getLevel()
        if user.getMoney() >= price then
            if level >= lvl then
                user.removeMoney(price)
				TriggerClientEvent('give:weapon', source, item)
				TriggerClientEvent("redemrp_notification:start", source, "Rented a fishing rod!", 3, "success")
            else 
                TriggerClientEvent('redemrp_gunshop:alert', source, "You are not a high enough level!")
            end
        else
            TriggerClientEvent('redemrp_gunshop:alert', source, "You dont have enough money!")
        end
	end)
end)


RegisterServerEvent('qb-baitshop:buybait')
AddEventHandler("qb-baitshop:buybait", function(price, item, lvl)
    TriggerEvent("redemrp:getPlayerFromId", source, function(user)
        local identifier = user.getIdentifier()
		local level = user.getLevel()
        if user.getMoney() >= price then
            if level >= lvl then
                user.removeMoney(price)
				local ItemData = data.getItem(source, item)
				print(ItemData.ItemAmount)
				ItemData.AddItem(1)
				TriggerClientEvent("redemrp_notification:start", source, "Bought Bait!", 3, "success")
            else 
                TriggerClientEvent('redemrp_gunshop:alert', source, "You are not a high enough level!")
            end
        else
            TriggerClientEvent('redemrp_gunshop:alert', source, "You dont have enough money!")
        end
	end)
end)


RegisterServerEvent('qb-baitshop:sellsmallfish')
AddEventHandler('qb-baitshop:sellsmallfish', function()
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        local ItemData = data.getItem(source, 'smallfish')
		print(ItemData.ItemAmount)
		local totalfish = (ItemData.ItemAmount)
		if totalfish >= 1 then
			local totalmoney = (totalfish * 2)
			local totalxp = (totalfish * 2)
			user.addMoney(totalmoney)
			user.addXP(totalxp)
            ItemData.RemoveItem(totalfish)
            TriggerClientEvent("redemrp_notification:start", _source, "You sold " ..totalfish.. " small fish, for " ..totalmoney.."$ | "..totalxp.."XP", 5)
		else
            TriggerClientEvent("redemrp_notification:start", _source, 'You dont have any small fish to sell', 5)
        end
    end)
end)

RegisterServerEvent('qb-baitshop:sellmediumfish')
AddEventHandler('qb-baitshop:sellmediumfish', function()
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        local ItemData = data.getItem(source, 'mediumfish')
		print(ItemData.ItemAmount)
		local totalfish = (ItemData.ItemAmount)
		if totalfish >= 1 then
			local totalmoney = (totalfish * 5)
			local totalxp = (totalfish * 5)
			user.addMoney(totalmoney)
			user.addXP(totalxp)
            ItemData.RemoveItem(totalfish)
            TriggerClientEvent("redemrp_notification:start", _source, "You sold " ..totalfish.. " medium fish, for " ..totalmoney.."$ | "..totalxp.."XP", 5)
		else
            TriggerClientEvent("redemrp_notification:start", _source, 'You dont have any medium fish to sell', 5)
        end
    end)
end)

RegisterServerEvent('qb-baitshop:selllargefish')
AddEventHandler('qb-baitshop:selllargefish', function()
    local _source = source
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
        local ItemData = data.getItem(source, 'largefish')
		print(ItemData.ItemAmount)
		local totalfish = (ItemData.ItemAmount)
		if totalfish >= 1 then
			local totalmoney = (totalfish * 10)
			local totalxp = (totalfish * 10)
			user.addMoney(totalmoney)
			user.addXP(totalxp)
            ItemData.RemoveItem(totalfish)
            TriggerClientEvent("redemrp_notification:start", _source, "You sold " ..totalfish.. " large fish, for " ..totalmoney.."$ | "..totalxp.."XP", 5)
		else
            TriggerClientEvent("redemrp_notification:start", _source, 'You dont have any large fish to sell', 5)
        end
    end)
end)
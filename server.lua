local pgroup = exports['snappy-phone']

local function secondsToClock(seconds)
	local mSeconds = tonumber(seconds)
	if mSeconds <= 0 then
		return "00:00"
	end
	local minutes = string.format("%02.f", math.floor(mSeconds / 60))
	mSeconds = string.format("%02.f", math.floor(mSeconds - minutes * 60))
	local retString = minutes .. ":" .. mSeconds
	retString = retString .. (minutes == "00" and " seconds" or " minutes")
	return retString
end

local function getRandomItem(table)
	local newchance = math.random(1, 100)
	for item, chance in pairs(table) do
		if newchance >= chance[1] and newchance <= chance[2] then
			return item
		end
	end
end

local function sendNotify(src, msg, type)
	if type == nil then type = 'inform' end
	TriggerClientEvent("ox_lib:notify", src, { description = msg, type = type })
end

local partyTasks = {}
local function updatePartyTasks(cid, id, status)
	local partyId = pgroup:getPlayerPartyId(cid)
	if not partyId then return end
	if not partyTasks[partyId] then return end
	if status ~= partyTasks[partyId][id].status then
		partyTasks[partyId][id].status = status
		pgroup:updatePartyTasks(partyId, partyTasks[partyId])
	end
end

local function sendToPartyMembers(partyId, callback)
	local members = pgroup:getPartyMembers(partyId)
	for _, member in pairs(members) do
		local source = GetSource(member.citizenid)
		if source then
			callback(source)
		end
	end
end

lib.callback.register('mining:hasDrillBits', function(source)
	local count = GetCount(source, 'minedrillbit')
	if count >= 1 then
		return true
	end
	return false
end)

local mineCooldown = {}
RegisterNetEvent('mining:onStoneBreak', function(shouldRemoveDrillbit)
	local source = source
	local cid = GetIdentifer(source)
	if mineCooldown[cid] == nil then mineCooldown[cid] = 0 end
	if mineCooldown[cid] >= Config.StoneBreak.limit then
		TriggerClientEvent("ox_lib:notify", source, { description = "You cannot break more stones", type = "error" })
		return
	end
	if shouldRemoveDrillbit then
		if RemoveItem(source, Config.StoneBreak.drillbit, 1) then
			local item = Config.StoneBreak.item
			local amount = Config.StoneBreak.amount
			AddItem(source, item, amount)
			mineCooldown[cid] = mineCooldown[cid] + 1
			updatePartyTasks(cid, 1, 'done')
			updatePartyTasks(cid, 2, 'current')
		end
	else
		local item = Config.StoneBreak.item
		local amount = Config.StoneBreak.amount
		AddItem(source, item, amount)
		mineCooldown[cid] = mineCooldown[cid] + 1
		updatePartyTasks(cid, 1, 'done')
		updatePartyTasks(cid, 2, 'current')
	end
	if mineCooldown[cid] >= Config.StoneBreak.limit then
		TriggerClientEvent('mining:setCanMine', source, false)
	end
end)

lib.callback.register("mining:checkMineCooldown", function(source)
	local cid = GetIdentifer(source)
	if mineCooldown[cid] then
		if mineCooldown[cid] >= Config.StoneBreak.limit then
			return false
		end
	end
	return true
end)

local sortingMachine = {}
lib.callback.register("mining:checkSortingMachine", function(source)
	local cid = GetIdentifer(source)
	if sortingMachine[cid] then
		return true
	end
	return false
end)

RegisterNetEvent("mining:addSortingMachine", function()
	local source = source
	local cid = GetIdentifer(source)
	local count = GetCount(source, Config.SortingMachine.collect.name)
	if count >= Config.SortingMachine.collect.amount then
		if not sortingMachine[cid] then sortingMachine[cid] = 0 end
		if RemoveItem(source, Config.SortingMachine.collect.name, count) then
			sortingMachine[cid] = sortingMachine[cid] + math.floor(count / Config.SortingMachine.collect.amount)
			updatePartyTasks(cid, 1, 'done')
			updatePartyTasks(cid, 2, 'done')
			updatePartyTasks(cid, 3, 'current')
		end
	else
		TriggerClientEvent("ox_lib:notify", source, { description = "You have nothing to sort", type = "error" })
	end
end)

RegisterNetEvent("mining:collectSortingMachine", function()
	local source = source
	local cid = GetIdentifer(source)
	local failed = false
	if sortingMachine[cid] then
		local amount = sortingMachine[cid]
		for i = 1, amount do
			local item = getRandomItem(Config.SortingMachine.reward)
			if AddItem(source, item, 1) then
				sortingMachine[cid] = sortingMachine[cid] - 1
			else
				failed = true
				break
			end
		end
		if not failed then
			sortingMachine[cid] = nil
		else
			TriggerClientEvent("ox_lib:notify", source,
				{ description = "Recollect once your pockets are empty", type = "error" })
			return
		end
		updatePartyTasks(cid, 1, 'done')
		updatePartyTasks(cid, 2, 'done')
		updatePartyTasks(cid, 3, 'done')
		updatePartyTasks(cid, 4, 'current')
		updatePartyTasks(cid, 5, 'current')
	else
		TriggerClientEvent("ox_lib:notify", source, { description = "You have nothing to collect", type = "error" })
	end
end)

local smeltingMachine = {}
lib.callback.register("mining:isSmeltingMachineActive", function(source)
	local cid = GetIdentifer(source)
	if smeltingMachine[cid] then
		local oldTime = smeltingMachine[cid].time
		local currentTime = os.time()
		if oldTime > currentTime then
			return { true, false }
		else
			return { false, true }
		end
	end
	return { false, false }
end)

RegisterNetEvent("mining:addSmeltingMachine", function()
	local source = source
	local cid = GetIdentifer(source)
	local count = GetCount(source, Config.SmeltingMachine.item)
	if smeltingMachine[cid] and next(smeltingMachine[cid]) then
		TriggerClientEvent("ox_lib:notify", source, { description = "Smelter still active", type = "error" })
		return
	end
	if count >= 1 then
		if RemoveItem(source, Config.SmeltingMachine.item, count) then
			smeltingMachine[cid] = {
				count = count,
				time = os.time() + ((Config.SmeltingMachine.time + count) * 60),
			}
		end
		updatePartyTasks(cid, 4, 'done')
	else
		TriggerClientEvent("ox_lib:notify", source, { description = "You have nothing to smelt", type = "error" })
	end
end)

RegisterNetEvent("mining:checkSmeltingMachine", function()
	local source = source
	local cid = GetIdentifer(source)
	if smeltingMachine[cid] then
		local oldTime = smeltingMachine[cid].time
		local currentTime = os.time()
		if oldTime <= currentTime then
			TriggerClientEvent("ox_lib:notify", source,
				{ description = "Smelting has been finished", type = "error" })
		else
			local minutesPassed = secondsToClock(oldTime - currentTime)
			TriggerClientEvent("ox_lib:notify", source,
				{ description = "Time Left: " .. minutesPassed, type = "error" })
		end
	else
		TriggerClientEvent("ox_lib:notify", source, { description = "Smelter not active", type = "error" })
	end
end)

RegisterNetEvent("mining:collectSmeltingMachine", function()
	local source = source
	local cid = GetIdentifer(source)
	local failed = false
	if smeltingMachine[cid] then
		local oldTime = smeltingMachine[cid].time
		local currentTime = os.time()
		if oldTime > currentTime then
			TriggerClientEvent("ox_lib:notify", source, { description = "Smelter is still active", type = "error" })
			return
		end
		local amount = smeltingMachine[cid].count
		for i = 1, amount do
			local item = getRandomItem(Config.SmeltingMachine.rewards)
			if AddItem(source, item, Config.SmeltingMachine.rewardamount) then
				smeltingMachine[cid].count = smeltingMachine[cid].count - 1
			else
				failed = true
				break
			end
		end
		if not failed then
			smeltingMachine[cid] = nil
		else
			TriggerClientEvent("ox_lib:notify", source,
				{ description = "Recollect once your pockets are empty", type = "error" })
			return
		end
		updatePartyTasks(cid, 7, 'current')
	else
		TriggerClientEvent("ox_lib:notify", source, { description = "You have nothing to collect", type = "error" })
	end
end)

local heatingMachine = {}
lib.callback.register("mining:isHeatingMachineActive", function(source)
	local cid = GetIdentifer(source)
	if heatingMachine[cid] then
		local oldTime = heatingMachine[cid].time
		local currentTime = os.time()
		if oldTime > currentTime then
			return { true, false }
		else
			return { false, true }
		end
	end
	return { false, false }
end)

RegisterNetEvent("mining:addHeatingMachine", function()
	local source = source
	local cid = GetIdentifer(source)
	local count = GetCount(source, Config.HeatingMachine.item)
	if heatingMachine[cid] and next(heatingMachine[cid]) then
		TriggerClientEvent("ox_lib:notify", source, { description = "Heater is still active", type = "error" })
		return
	end
	if count >= 1 then
		if RemoveItem(source, Config.HeatingMachine.item, count) then
			heatingMachine[cid] = {
				count = count,
				time = os.time() + ((Config.HeatingMachine.time + count) * 60),
			}
			updatePartyTasks(cid, 5, 'done')
			updatePartyTasks(cid, 6, 'current')
		end
	else
		TriggerClientEvent("ox_lib:notify", source, { description = "You have nothing to heat", type = "error" })
	end
end)

RegisterNetEvent("mining:checkHeatingMachine", function()
	local source = source
	local cid = GetIdentifer(source)
	if heatingMachine[cid] then
		local oldTime = heatingMachine[cid].time
		local currentTime = os.time()
		if oldTime <= currentTime then
			TriggerClientEvent("ox_lib:notify", source,
				{ description = "Heating has been finished", type = "error" })
		else
			local minutesPassed = secondsToClock(oldTime - currentTime)
			TriggerClientEvent("ox_lib:notify", source,
				{ description = "Time Left: " .. minutesPassed, type = "error" })
		end
	else
		TriggerClientEvent("ox_lib:notify", source, { description = "Heater not active", type = "error" })
	end
end)

RegisterNetEvent("mining:collectHeatingMachine", function()
	local source = source
	local cid = GetIdentifer(source)
	local failed = false
	if heatingMachine[cid] then
		local oldTime = heatingMachine[cid].time
		local currentTime = os.time()
		if oldTime > currentTime then
			TriggerClientEvent("ox_lib:notify", source, { description = "Heater is still active", type = "error" })
			return
		end
		local amount = heatingMachine[cid].count
		for i = 1, amount do
			local item = getRandomItem(Config.HeatingMachine.rewards)
			if AddItem(source, item, Config.HeatingMachine.rewardamount) then
				heatingMachine[cid].count = heatingMachine[cid].count - 1
			else
				failed = true
				break
			end
		end
		if not failed then
			heatingMachine[cid] = nil
		else
			TriggerClientEvent("ox_lib:notify", source,
				{ description = "Recollect once your pockets are empty", type = "error" })
			return
		end
		updatePartyTasks(cid, 7, 'current')
	else
		TriggerClientEvent("ox_lib:notify", source, { description = "You have nothing to collect", type = "error" })
	end
end)

RegisterNetEvent("mining:polishGems", function(item)
	local source = source
	local cid = GetIdentifer(source)
	if Config.GemPolisher[item] then
		local polisheditem = Config.GemPolisher[item].item
		local count = GetCount(source, item)
		if count and count > 0 then
			if RemoveItem(source, item, 1) then
				AddItem(source, polisheditem, 1)
				updatePartyTasks(cid, 6, 'done')
			end
		end
	end
end)

RegisterNetEvent("mining:provideShopItem", function(item, amount, price)
	local source = source
	local count = GetCount(source, 'money')
	if count < price then
		sendNotify(source, "Insufficient Money", "error")
		return
	end
	if AddItem(source, item, amount) then
		RemoveItem(source, "money", price)
	end
end)

RegisterNetEvent("mining:sellItems", function(item, count)
	local source = source
	local cid = GetIdentifer(source)
	if Config.SellMinerItems[item] then
		local price = math.floor(Config.SellMinerItems[item].price * count)
		if RemoveItem(source, item, count) then
			AddItem(source, 'money', price)
			lib.logger(source, 'soldItems', string.format('%s sold %d %s for $%d', cid, count, item, price))
		end
		updatePartyTasks(cid, 7, 'done')
	end
end)

RegisterNetEvent("mining:initiateJob", function()
	local source = source
	local cid = GetIdentifer(source)  -- this will be used to fetch player's data from party (like below)
	local partyId = pgroup:getPlayerPartyId(cid)     -- this gets the partyid of the player if any or else returns false
	if not partyId then
		sendNotify(source, 'You need to be in party to start work')
		return
	end
	local isLeader = pgroup:isPartyLeader(partyId, cid) -- checks if party leader then execute below (start tasks)
	if not isLeader then
		sendNotify(source, 'You are not party leader')
		return
	end
	local partySize = pgroup:getPartySize(partyId)
	if partySize >= Config.Party.minSize and partySize <= Config.Party.maxSize then
		if pgroup:getPartyJob(partyId) == Config.Party.jobName then
			sendNotify(source, 'Already doing work')
			return
		end
		local canSet = pgroup:setPartyJob(partyId, Config.Party.jobName) -- 'miner', 'hunting', 'lumber', etc
		if not canSet.status then
			sendNotify(source, canSet.msg)
			return
		end
		partyTasks[partyId] = {
			{ name = 'Break Stones',             status = 'current' },
			{ name = 'Add stones to sorter',     status = 'pending' },
			{ name = 'Collect stones from sorter', status = 'pending' },
			{ name = 'Smelt Raw Metal Ore',      status = 'pending' },
			{ name = 'Heat Raw Gemstone Ore',    status = 'pending' },
			{ name = 'Polishing',                status = 'pending' },
			{ name = 'Talk to Monica',           status = 'pending' },
		}
		pgroup:updatePartyTasks(partyId, partyTasks[partyId])
		sendToPartyMembers(partyId, function(playerId)
			if playerId then
				TriggerClientEvent("mining:toggleJobClient", playerId, true)
				sendNotify(playerId, 'You started work: ' .. Config.Party.jobName)
			end
		end)
	else
		sendNotify(source, 'Unmet Activity Requirements')
		return
	end
end)

RegisterNetEvent('phone:server:disbandParty', function(source, partyId)
	if partyTasks[partyId] then
		partyTasks[partyId] = nil
	end
end)

RegisterNetEvent("phone:server:leftParty", function(source, data)
	if data.currentJob == Config.Party.jobName then
		TriggerClientEvent("mining:toggleJobClient", source, false)
	end
end)

RegisterNetEvent('phone:server:resumePendingJobs', function(source, data)
	if data.currentJob == Config.Party.jobName then
		TriggerClientEvent("mining:toggleJobClient", source, true)
		sendNotify(source, 'You continued work: ' .. Config.Party.jobName)
	end
end)

pgroup:registerJob({
	name = Config.Party.jobName,
	icon = Config.Party.jobIcon,
	size = Config.Party.jobSize,
	type = Config.Party.jobType
})
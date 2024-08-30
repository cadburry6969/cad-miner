local target = exports[Config.Target]

local SpawnedProps = {}
local ShownTargets = {}
local ShownBlips = {}
local soundId = GetSoundId()
local isMining = false
local canMine = true

local function sendNotify(message, type)
	lib.notify({ description = message, type = type })
end

local function isInParty()
	local data = LocalPlayer.state.partyData
	if data and data.currentJob then
		return data.inParty and (data.currentJob == Config.Party.jobName)
	end
	return false
end

local function loadDrillSound()
	RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET", false)
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", false)
	RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", false)
end

local function unloadDrillSound()
	ReleaseAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET")
	ReleaseAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL")
	ReleaseAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2")
end

local function destroyProp(entity)
	SetEntityAsMissionEntity(entity, true, true)
	Wait(5)
	DetachEntity(entity, true, true)
	Wait(5)
	DeleteObject(entity)
end

local function createProp(data, freeze, synced)
	lib.requestModel(data.prop)
	local prop = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z - 1.03, synced or false,
		synced or false, false)
	SetEntityHeading(prop, data.coords.w + 180.0)
	PlaceObjectOnGroundProperly(prop)
	FreezeEntityPosition(prop, freeze or false)
	return prop
end

local function createBlips()
	for name, data in pairs(Config.JobBlips) do
		ShownBlips[name] = AddBlipForCoord(data.coords)
		SetBlipAsShortRange(ShownBlips[name], true)
		SetBlipSprite(ShownBlips[name], data.sprite)
		SetBlipColour(ShownBlips[name], data.color)
		SetBlipScale(ShownBlips[name], 0.7)
		SetBlipDisplay(ShownBlips[name], 6)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(data.name)
		EndTextCommandSetBlipName(ShownBlips[name])
	end
end

local function endJob()
	if ShownTargets and next(ShownTargets) then
		for k, _ in pairs(ShownTargets) do
			target:removeZone(ShownTargets[k])
		end
	end
	for _, v in pairs(SpawnedProps) do
		DeleteObject(v)
	end
	for _, id in pairs(ShownBlips) do
		RemoveBlip(id)
	end
end

local function recreateStoneZone(name, stone, coords)
	SetEntityAlpha(stone, 0, false)
	target:removeZone(ShownTargets[name])
	ShownTargets[name] = nil
	Wait(math.random(55000, 75000))
	SetEntityAlpha(stone, 255, false)
	ShownTargets[name] =
		target:addSphereZone({
			coords = vec3(coords.x, coords.y, coords.z),
			radius = 1.7,
			options = {
				{
					label = 'Break Stone',
					icon = "fa-solid fa-hammer",
					distance = 3,
					canInteract = function()
						return not isMining and HasItem(Config.StoneBreak.drill, 1) and isInParty() and canMine
					end,
					onSelect = function(data)
						StartDrilling(name, coords, stone)
					end
				},
			},
		})
end

function StartDrilling(name, coords, stone)
	lib.callback('mining:hasDrillBits', false, function(hasDrillbit)
		if not hasDrillbit then
			sendNotify('You dont have drillbits', 'error')
			return
		end
		local playerped = PlayerPedId()
		local plycoords = GetEntityCoords(playerped, true)
		loadDrillSound()
		local dict = "anim@heists@fleeca_bank@drilling"
		local anim = "drill_straight_fail"
		lib.requestAnimDict(dict)
		local drillObj = CreateObject(`hei_prop_heist_drill`, plycoords.x, plycoords.y, plycoords.z, true, true, false)
		AttachEntityToEntity(drillObj, playerped, GetPedBoneIndex(playerped, 57005), 0.14, 0, -0.01, 90.0,
			-90.0, 180.0, true, true, false, true, 1, true)
		local rockcoords = coords
		TaskTurnPedToFaceCoord(playerped, rockcoords.x, rockcoords.y, rockcoords.z, 1500)
		if #(rockcoords - plycoords) > 1.5 then
			TaskGoStraightToCoord(playerped, rockcoords.x, rockcoords.y, rockcoords.z, 0.5, 400, 0.0, 0)
			Wait(400)
		end
		TaskPlayAnim(playerped, dict, anim, 3.0, 3.0, -1, 1, 0, false, false, false)
		Wait(200)
		PlaySoundFromEntity(soundId, "Drill", drillObj, "DLC_HEIST_FLEECA_SOUNDSET", true, 0)
		isMining = true
		lib.requestNamedPtfxAsset('core')
		CreateThread(function()
			while isMining do
				UseParticleFxAsset('core')
				StartNetworkedParticleFxNonLoopedAtCoord("ent_dst_rocks", rockcoords.x, rockcoords.y,
					rockcoords.z, 0.0, 0.0, GetEntityHeading(playerped) - 180.0, 1.0, false, false, false)
				if not IsEntityPlayingAnim(playerped, dict, anim, 3) then
					TaskTurnPedToFaceCoord(playerped, rockcoords.x, rockcoords.y, rockcoords.z, 1500)
					if #(rockcoords - plycoords) > 1.5 then
						TaskGoStraightToCoord(playerped, rockcoords.x, rockcoords.y, rockcoords.z, 0.5, 400, 0.0, 0)
					end
					TaskPlayAnim(playerped, dict, anim, 3.0, 3.0, -1, 1, 0, false, false, false)
				end
				Wait(600)
			end
		end)
		local success = lib.progressBar({
			duration = math.random(15000, 20000),
			label = 'Breaking the stone',
			icon = 'hammer',
			useWhileDead = false,
			canCancel = false,
			disable = {
				move = true,
				combat = true,
			},
			stages = {}
		})
		ClearPedTasks(playerped)
		if success then
			StopAnimTask(playerped, "anim@heists@fleeca_bank@drilling", "drill_straight_fail", 1.0)
			destroyProp(drillObj)
			local removeDrillbit = false
			if math.random(1, 10) <= Config.StoneBreak.drillbitchance then
				local breakId = GetSoundId()
				PlaySoundFromEntity(breakId, "Drill_Pin_Break", playerped, "DLC_HEIST_FLEECA_SOUNDSET", true, 0)
				removeDrillbit = true
			end
			TriggerServerEvent('mining:onStoneBreak', removeDrillbit)
			unloadDrillSound()
			StopSound(soundId)
			isMining = false
			recreateStoneZone(name, stone, coords)
		else
			StopAnimTask(playerped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
			unloadDrillSound()
			StopSound(soundId)
			destroyProp(drillObj)
			isMining = false
		end
	end)
end

local function polishGems()
	local options = {}
	for item, data in pairs(Config.GemPolisher) do
		local count = GetCount(item)
		options[#options + 1] = {
			title = data.label,
			icon = 'gem',
			disabled = count < 1,
			onSelect = function()
				lib.hideContext()
				exports.emotes:playEmoteByCommand('parkingmeter')
				local success = lib.progressBar({
					duration = math.random(10000, 15000),
					label = 'Polishing ' .. data.label,
					icon = 'gem',
					useWhileDead = false,
					canCancel = true,
					disable = {
						move = false,
					},
					stages = {},
				})
				exports.emotes:cancelEmote()
				if success then
					TriggerServerEvent('mining:polishGems', item)
				end
			end
		}
	end
	lib.registerContext({
		id = 'polish_mining_gems',
		title = 'Polish Gems',
		options = options
	})
	lib.showContext('polish_mining_gems')
end

local function initiateJob()
	createBlips()

	for k, v in pairs(Config.StoneBreakLocations) do
		SpawnedProps["Ore" .. k] = createProp({ coords = v, prop = `prop_rock_1_f` }, true, true)
		ShownTargets["Ore" .. k] = target:addSphereZone({
			coords = vec3(v.x, v.y, v.z),
			radius = 1.7,
			debug = Config.Debug,
			options = {
				{
					label = "Break Stone",
					icon = "fa-solid fa-hammer",
					distance = 3,
					canInteract = function()
						return not isMining and HasItem(Config.StoneBreak.drill, 1) and isInParty() and canMine
					end,
					onSelect = function(data)
						StartDrilling("Ore" .. k, vector3(v.x, v.y, v.z), SpawnedProps["Ore" .. k])
					end
				},
			},
		})
	end

	for k, v in pairs(Config.Sorter) do
		ShownTargets["Sorter" .. k] =
			target:addBoxZone({
				coords = v.coords,
				size = v.size,
				rotation = v.rotation,
				debug = Config.Debug,
				options = {
					{
						label = "Use Sorter",
						icon = "fa-solid fa-filter",
						distance = 3,
						canInteract = function()
							return isInParty() and not lib.progressActive()
						end,
						onSelect = function(data)
							local count = GetCount(Config.StoneBreak.item)
							if count < Config.SortingMachine.collect.amount then
								sendNotify('You dont have enough stones')
								return
							end
							exports.emotes:playEmoteByCommand('mechanic2')
							local success = lib.progressBar({
								duration = math.random(20000, 25000),
								label = 'Grabbing stones from pocket',
								icon = 'filter',
								useWhileDead = false,
								canCancel = true,
								disable = {
									move = false,
								},
								stages = {
									{
										label = 'Adding stones to sorter',
										icon = 'filter',
										atTick = 6000,
										onStart = ''
									},
								},
							})
							exports.emotes:cancelEmote()
							if success then
								TriggerServerEvent('mining:addSortingMachine')
							end
						end,
					},
				},
			})
	end
	for k, v in pairs(Config.SorterCollection) do
		ShownTargets["SorterCol" .. k] =
			target:addSphereZone({
				coords = v.coords,
				radius = v.radius,
				debug = Config.Debug,
				options = {
					{
						label = "Collect Sorted Material",
						icon = "fa-solid fa-sort",
						canInteract = function()
							return isInParty() and not lib.progressActive()
						end,
						onSelect = function(data)
							lib.callback('mining:checkSortingMachine', false, function(canCollect)
								if not canCollect then
									sendNotify('You need to add more stones in sorter to collect')
									return
								end
								exports.emotes:playEmoteByCommand('puddle')
								local success = lib.progressBar({
									duration = math.random(15000, 20000),
									label = 'Collecting materials from pile',
									icon = 'sort',
									useWhileDead = false,
									canCancel = true,
									disable = {
										move = false,
									},
									stages = {}
								})
								exports.emotes:cancelEmote()
								if success then
									TriggerServerEvent('mining:collectSortingMachine')
								end
							end)
						end,
					},
				},
			})
	end
	for k, v in pairs(Config.Smelter) do
		ShownTargets["Smelter" .. k] =
			target:addBoxZone({
				coords = v.coords,
				size = v.size,
				rotation = v.rotation,
				debug = Config.Debug,
				options = {
					{
						label = "Smelt Raw Ore",
						icon = "fas fa-fire-burner",
						distance = 3,
						canInteract = function()
							return isInParty() and not lib.progressActive()
						end,
						onSelect = function()
							lib.callback('mining:isSmeltingMachineActive', false, function(data)
								if data[1] then
									sendNotify('Smelter is active')
									return
								end
								if data[2] then
									sendNotify('Items not collected')
									return
								end
								local count = GetCount(Config.SmeltingMachine.item)
								if count < 1 then
									sendNotify('You dont have items for smelting')
									return
								end
								exports.emotes:playEmoteByCommand('parkingmeter')
								local success = lib.progressBar({
									duration = math.random(15000, 20000),
									label = 'Grabbing raw metal ore from pocket',
									icon = 'fire-burner',
									useWhileDead = false,
									canCancel = true,
									disable = {
										move = false,
									},
									stages = {
										{
											label = 'Adding raw metral ore to smelter',
											icon = 'fire-burner',
											atTick = 6000,
											onStart = ''
										},
									},
								})
								exports.emotes:cancelEmote()
								if success then
									TriggerServerEvent('mining:addSmeltingMachine')
								end
							end)
						end,
					},
					{
						label = "Collect",
						icon = "fas fa-fire-burner",
						distance = 3,
						canInteract = function()
							return isInParty() and not lib.progressActive()
						end,
						onSelect = function()
							lib.callback('mining:isSmeltingMachineActive', false, function(data)
								if data[1] then
									sendNotify('Cannot collect')
									return
								end
								if not data[2] then
									sendNotify('Cannot collect')
									return
								end
								exports.emotes:playEmoteByCommand('lookout')
								local success = lib.progressBar({
									duration = math.random(10000, 15000),
									label = 'Collecting metals',
									icon = 'fire-burner',
									useWhileDead = false,
									canCancel = true,
									disable = {
										move = false,
									},
									stages = {},
								})
								exports.emotes:cancelEmote()
								if success then
									TriggerServerEvent('mining:collectSmeltingMachine')
								end
							end)
						end,
					},
					{
						label = "Check Time",
						icon = "fas fa-fire-burner",
						distance = 3,
						canInteract = function()
							return isInParty()
						end,
						onSelect = function(data)
							TriggerServerEvent('mining:checkSmeltingMachine')
						end,
					},
				},
			})
	end
	for k, v in pairs(Config.GemHeater) do
		ShownTargets["GemHeater" .. k] =
			target:addBoxZone({
				coords = v.coords,
				size = v.size,
				rotation = v.rotation,
				debug = Config.Debug,
				options = {
					{
						label = "Heat Raw Ore",
						icon = "fas fa-fire-burner",
						distance = 3,
						canInteract = function()
							return isInParty() and not lib.progressActive()
						end,
						onSelect = function()
							lib.callback('mining:isHeatingMachineActive', false, function(data)
								if data[1] then
									sendNotify('Heater is active')
									return
								end
								if data[2] then
									sendNotify('Items not collected')
									return
								end
								local count = GetCount(Config.HeatingMachine.item)
								if count < 1 then
									sendNotify('You dont have items for heating')
									return
								end
								exports.emotes:playEmoteByCommand('parkingmeter')
								local success = lib.progressBar({
									duration = math.random(15000, 20000),
									label = 'Grabbing raw gemstone ore from pocket',
									icon = 'fire-burner',
									useWhileDead = false,
									canCancel = true,
									disable = {
										move = false,
									},
									stages = {
										{
											label = 'Adding raw gemstone ore to heater',
											icon = 'fire-burner',
											atTick = 6000,
											onStart = ''
										},
									},
								})
								exports.emotes:cancelEmote()
								if success then
									TriggerServerEvent('mining:addHeatingMachine')
								end
							end)
						end,
					},
					{
						label = "Collect",
						icon = "fas fa-fire-burner",
						distance = 3,
						canInteract = function()
							return isInParty() and not lib.progressActive()
						end,
						onSelect = function()
							lib.callback('mining:isHeatingMachineActive', false, function(data)
								if data[1] then
									sendNotify('Cannot collect')
									return
								end
								if not data[2] then
									sendNotify('Cannot collect')
									return
								end
								exports.emotes:playEmoteByCommand('lookout')
								local success = lib.progressBar({
									duration = math.random(10000, 15000),
									label = 'Collecting gems',
									icon = 'fire-burner',
									useWhileDead = false,
									canCancel = true,
									disable = {
										move = false,
									},
									stages = {},
								})
								exports.emotes:cancelEmote()
								if success then
									TriggerServerEvent('mining:collectHeatingMachine')
								end
							end)
						end,
					},
					{
						label = "Check Time",
						icon = "fas fa-fire-burner",
						distance = 3,
						canInteract = function()
							return isInParty()
						end,
						onSelect = function(data)
							TriggerServerEvent('mining:checkHeatingMachine')
						end,
					},
				},
			})
	end
	for k, v in pairs(Config.GemPolish) do
		SpawnedProps["GemPolish" .. k] = createProp({ coords = v.coords, prop = `gr_prop_gr_speeddrill_01b` }, true, true)
		ShownTargets["GemPolish" .. k] =
			target:addSphereZone({
				coords = vec3(v.coords.x, v.coords.y, v.coords.z),
				size = v.size,
				rotation = v.rotation,
				debug = Config.Debug,
				options = {
					{
						label = "Polish Gem",
						icon = "fa-solid fa-gem",
						distance = 3,
						canInteract = function()
							return isInParty() and not lib.progressActive()
						end,
						onSelect = function(data)
							polishGems()
						end,
					},
				},
			})
	end
end

local function sellItems()
	local options = {}
	for item, data in pairs(Config.SellMinerItems) do
		local count = GetCount(item)
		options[#options + 1] = {
			title = data.label,
			description = '$' .. tostring(data.price),
			icon = data.icon,
			disabled = count < 1,
			onSelect = function()
				TriggerServerEvent('mining:sellItems', item, count)
			end
		}
	end
	lib.registerContext({
		id = 'miner_sellitems',
		title = 'Jewel Buyer',
		options = options
	})
	lib.showContext('miner_sellitems')
end

local function openShop()
	local options = {}
	for item, v in pairs(Config.ShopItems) do
		options[#options + 1] = {
			title = v.label,
			description = '$' .. tostring(v.price),
			icon = v.icon,
			onSelect = function()
				local input = lib.inputDialog(v.label, {
					{ type = 'number', label = 'Amount', description = 'how many of them you want to buy?', icon = 'hashtag' },
				})
				if not input[1] then return end
				TriggerServerEvent("mining:provideShopItem", item, input[1], v.price)
			end,
		}
	end
	lib.registerContext({
		id = 'mining_shop',
		title = 'Mining Store',
		options = options
	})
	lib.showContext('mining_shop')
end

CreateThread(function()
	local blip = AddBlipForCoord(2957.07, 2745.01, 43.55)
	SetBlipSprite(blip, 652)
	SetBlipColour(blip, 5)
	SetBlipAsShortRange(blip, true)
	SetBlipScale(blip, 0.6)
	SetBlipDisplay(blip, 6)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Mining')
	EndTextCommandSetBlipName(blip)
	local blip2 = AddBlipForCoord(2 - 594.46, 2082.61, 131.4)
	SetBlipSprite(blip2, 652)
	SetBlipColour(blip2, 5)
	SetBlipAsShortRange(blip2, true)
	SetBlipScale(blip2, 0.6)
	SetBlipDisplay(blip2, 6)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Mining')
	EndTextCommandSetBlipName(blip2)

	CreateModelHide(-596.04, 2089.01, 131.41, 10.5, -1241212535, true)
	for name, data in pairs(Config.Party.jobZones) do
		local targets = {}
		if data.zone == 'job' then
			targets = {
				{
					label = 'Start Work',
					icon = 'fa-solid fa-briefcase',
					canInteract = function()
						return not isInParty()
					end,
					onSelect = function()
						TriggerServerEvent("mining:initiateJob")
					end
				},
				{
					label = 'Shop Items',
					icon = 'fa-solid fa-basket-shopping',
					onSelect = function()
						openShop()
					end
				}
			}
		elseif data.zone == 'buyer' then
			targets = {
				{
					label = 'Talk to Monica',
					icon = 'fa-solid fa-gem',
					onSelect = function()
						sellItems()
					end
				}
			}
		end
		exports['cad-pedspawner']:AddPed(name, {
			model = data.model,
			coords = data.coords,
			type = data.type,
			distance = 10.0,
			states = { freeze = data.freeze, blockevents = data.blockevents, invincible = data.invincible, },
			animation = { scenario = data.scenario },
			target = targets
		})
	end
end)

RegisterNetEvent("mining:toggleJobClient", function(bool)
	if bool then
		initiateJob()
	else
		endJob()
	end
end)

RegisterNetEvent("mining:setCanMine", function(bool)
	canMine = bool
end)

RegisterNetEvent('characters:client:initialised', function(data)
	lib.callback('mining:checkMineCooldown', false, function(bool)
		canMine = bool
	end)
end)

if Config.Debug then
	CreateThread(function()
		Wait(1000)
		initiateJob()
	end)
end

AddEventHandler('onResourceStop', function(resName)
	if resName ~= GetCurrentResourceName() then return end
	for name in pairs(Config.Party.jobZones) do
		exports['cad-pedspawner']:DeletePed(name)
	end
end)

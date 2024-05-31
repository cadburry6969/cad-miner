Config = {}

Config.Debug = false

Config.ShopItems = {
	['minedrill'] = { label = 'Drill', icon = 'hammer', price = 200 },
	['minedrillbit'] = { label = 'Drill Bits', icon = 'screwdriver', price = 5 },
}

Config.StoneBreak = {
	item = 'stone',
	amount = 1,
	limit = 100, -- per server restart, per player
	drill = 'minedrill',
	drillbit = 'minedrillbit',
	drillbitchance = 3 -- break chance [4=40%]
}

Config.StoneBreakLocations = {
	--- Cave
	vector4(-588.49, 2048.05, 129.95 + 0.4, 0.0),
	vector4(-580.10, 2037.82, 128.8 + 0.4, 180.0),
	vector4(-572.28, 2022.37, 127.93 + 0.4, 90.0),
	vector4(-562.8, 2011.85, 127.25 + 0.4, 90.0),
	vector4(-548.99, 1996.56, 127.08 + 0.4, 210.95),
	vector4(-534.22, 1982.9, 126.98 + 0.4, 210.95),
	vector4(-531.43, 1979.08, 127.15 + 0.4, 90.95),
	vector4(-523.71, 1981.21, 126.75 + 0.4, 250.95),
	vector4(-516.25, 1977.32, 126.49 + 0.4, 250.95),
	vector4(-506.58, 1980.66, 126.14 + 0.4, 210.95),
	vector4(-499.52, 1981.87, 125.08 + 0.4, 210.95),
	vector4(-488.44, 1982.74, 124.64 + 0.4, 250.95),
	vector4(-469.78, 1993.57, 123.26 + 0.4, 250.95),
	vector4(-458.53, 2003.33, 123.33 + 0.4, 250.95),
	-- Quarry
	vector4(3000.77, 2754.15, 43.5 + 0.4, 0.0),
	vector4(2990.38, 2750.4, 43.46 + 0.4, 0.0),
	vector4(2985.77, 2751.19, 43.06 + 0.4, 0.0),
	vector4(2980.37, 2748.4, 43.0 + 0.4, 0.0),
	vector4(2977.74, 2741.16, 44.54 + 0.4, 180.0),
	vector4(3004.49, 2761.98, 43.54 + 0.4, 180.0),
	vector4(3006.38, 2768.63, 42.59 + 0.4, 180.0),
	vector4(3005.44, 2773.78, 43.11 + 0.4, 180.0),
	vector4(3006.28, 2778.37, 43.29, 257.64),
	vector4(3004.83, 2783.19, 44.65, 280.49),
	vector4(2998.39, 2795.73, 44.9, 180),
	vector4(2991.73, 2804.62, 44.07, 180),
	vector4(2979.07, 2827.17, 45.99, 180),
	vector4(2973.73, 2836.75, 45.82, 180),
	vector4(2971.13, 2844.6, 46.59, 180),
	vector4(2968.61, 2898.35, 61.53, 180),
	vector4(2973.66, 2902.27, 61.82, 180),
	vector4(2978.94, 2904.34, 60.81, 180),
	vector4(2987.91, 2912.82, 60.89, 180),
	vector4(2991.77, 2919.7, 60.97, 180),
	vector4(3024.18, 2915.9, 64.19, 180),
	vector4(3019.25, 2910.61, 64.42, 180),
	vector4(3009.89, 2904.11, 63.49, 180),
	vector4(2986.72, 2711.05, 55.49, 180),
	vector4(2983.31, 2705.66, 54.75, 180),
	vector4(2976.12, 2697.86, 55.66, 180),
	vector4(2968.56, 2693.34, 54.74, 180),
	vector4(2962.39, 2691.81, 55.06, 180),
	vector4(2954.29, 2693.54, 55.54, 180),
	vector4(2948.28, 2696.74, 55.89, 180),
	vector4(2942.98, 2703.09, 55.28, 180),
	vector4(2936.02, 2710.68, 54.4, 180),
	vector4(2924.95, 2725.11, 53.94, 180),
	vector4(2921.61, 2734.96, 53.78, 180),
	vector4(2917.54, 2741.04, 54.07, 180),
	vector4(2914.06, 2751.33, 53.75, 180),
	vector4(2907.15, 2756.52, 53.9, 180),
	vector4(2903.27, 2761.28, 54.09, 180),
	vector4(2934.29, 2743.72, 44.09, 180),
	vector4(2935.63, 2751.13, 44.54, 180),
	vector4(2930.34, 2758.45, 45.31, 180),
	vector4(2927.63, 2764.32, 44.54, 180),
	vector4(2924.07, 2769.68, 44.89, 180),
	vector4(2919.03, 2774.87, 44.65, 180),
	vector4(2911.74, 2778.28, 45.3, 180),
	vector4(2910.23, 2782.51, 45.97, 180),
	vector4(2907.26, 2787.99, 46.48, 180),
	vector4(2910.22, 2791.25, 45.46, 180),
	vector4(2912.9, 2797.07, 44.3, 180),
	vector4(2914.92, 2804.82, 44.02, 180),
	vector4(2918.4, 2812.1, 47.22, 180),
}

Config.SortingMachine = {
	collect = { name = 'stone', amount = 3 },
	reward = {
		['rawmetalore'] = { 21, 100 },
		['rawgemstoneore'] = { 1, 20 }
	}
}

Config.Sorter = {
	{ coords = vec3(2682.0, 2796.25, 40.5), size = vec3(6.0, 1.0, 1.75), rotation = 0.0 }
}

Config.SorterCollection = {
	{ coords = vec3(2593, 2833, 36.0),     radius = 5.3 },
	{ coords = vec3(2630.0, 2869.0, 39.0), radius = 7 },
	{ coords = vec3(2720.0, 2894.0, 42.0), radius = 7 },
	{ coords = vec3(2725.0, 2870.0, 41.0), radius = 5.5 },
}

Config.SmeltingMachine = {
	item = 'rawmetalore',
	time = 1, -- smelt time in min
	rewardamount = 1,
	rewards = {
		['palladium'] = { 64, 100 },
		['platinum'] = { 51, 70 },
		['gold'] = { 31, 50 },
		['silver'] = { 1, 30 },
	}
}

Config.Smelter = {
	{ coords = vec3(1111.5, -2009.25, 31.5), size = vec3(3.15, 3.0, 3.25), rotation = 234.25 }
}

Config.HeatingMachine = {
	item = 'rawgemstoneore',
	time = 1, -- heat time in min
	rewardamount = 1,
	rewards = {
		['diamond'] = { 96, 100 },
		['ruby'] = { 86, 95 },
		['rosequartz'] = { 66, 85 },
		['emerald'] = { 46, 65 },
		['turquoise'] = { 25, 45 },
		['sapphire'] = { 1, 24 },
	}
}

Config.GemHeater = {
	{ coords = vec3(1086.25, -2003.75, 31.2), size = vec3(4.3, 2.85, 2.25), rotation = 228.25 }
}

Config.GemPolisher = {
	['diamond'] = { label = 'Polish Diamond', item = 'polishdiamond' },
	['ruby'] = { label = 'Polish Ruby', item = 'polishruby' },
	['rosequartz'] = { label = 'Polish Rose Quartz', item = 'polishrosequartz' },
	['emerald'] = { label = 'Polish Emerald', item = 'polishemerald' },
	['turquoise'] = { label = 'Polish Turquoise', item = 'polishturquoise' },
	-- ['sapphire'] = { label = 'Polish Sapphire', item = 'polishsapphire' },
}

Config.GemPolish = {
	{ coords = vector4(245.65, 371.7, 105.74, 160.33), size = vec3(1.25, 1.05, 2.1), rotation = 250.25 }
}

Config.SellMinerItems = {
	['gold'] = { label = 'Gold', price = 65 },
	['silver'] = { label = 'Silver', price = 45 },
	['platinum'] = { label = 'Platinum', price = 90 },
	['palladium'] = { label = 'Palladium', price = 150 },
	['sapphire'] = { label = 'Sapphire', price = 80 },
	['turquoise'] = { label = 'Turquoise', price = 100 },
	['emerald'] = { label = 'Emerald', price = 110 },
	['rosequartz'] = { label = 'Rose Quartz', price = 130 },
	['ruby'] = { label = 'Ruby', price = 300 },
	['diamond'] = { label = 'Diamond', price = 500 },
	-- ['polishsapphire'] = { label = 'Polished Sapphire', price = 100 },
	['polishturquoise'] = { label = 'Polished Turquoise', price = 135 },
	['polishemerald'] = { label = 'Polished Emerald', price = 150 },
	['polishrosequartz'] = { label = 'Polished Rose Quartz', price = 200 },
	['polishruby'] = { label = 'Polished Ruby', price = 450 },
	['polishdiamond'] = { label = 'Polished Diamond', price = 750 },
}

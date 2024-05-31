Config = Config or {}

Config.Party = {
	minSize = 1, -- min members required to start the job
	maxSize = 6, -- max members you can have to start the job
	jobName = 'Miner', -- job name
	jobIcon = 'fas fa-gem', -- icon to show when this job is assigned
	jobType = 'legal', -- Job type: 'legal' , 'illegal'
	jobSize = 10 -- Max parties for this job
	jobZones = {
		['minerwork1'] = {
			model = `s_m_y_construct_01`,
			coords = vector4(2956.48, 2745.03, 43.55, 279.06),
			type = 'male',
			freeze = true,
			blockevents = true,
			invincible = true,
			scenario = 'WORLD_HUMAN_CLIPBOARD',
			zone = 'job'
		},
		['minerwork2'] = {
			model = `s_m_y_construct_01`,
			coords = vector4(-601.0, 2088.98, 132.54, 353.94),
			type = 'male',
			freeze = true,
			blockevents = true,
			invincible = true,
			scenario = 'WORLD_HUMAN_CLIPBOARD',
			zone = 'job'
		},
		['minerwork3'] = {
			model = `s_m_y_construct_01`,
			coords = vector4(1077.69, -1983.4, 31.03, 180.96),
			type = 'male',
			freeze = true,
			blockevents = true,
			invincible = true,
			scenario = 'WORLD_HUMAN_CLIPBOARD',
			zone = 'job'
		},
		['minerwork4'] = {
			model = `s_m_y_construct_01`,
			coords = vector4(244.51, 374.41, 105.74, 163.62),
			type = 'male',
			freeze = true,
			blockevents = true,
			invincible = true,
			scenario = 'WORLD_HUMAN_CLIPBOARD',
			zone = 'job'
		},
		['minerbuyer'] = {
			model = `a_f_y_business_01`,
			coords = vector4(-622.12, -232.21, 38.06, 130.22),
			type = 'female',
			freeze = true,
			blockevents = true,
			invincible = true,
			zone = 'buyer'
		},
	}
}

Config.JobBlips = {
	{ name = 'Mine Area',          coords = vector3(2969.41, 2780.5, 38.84),   sprite = 652, color = 5 },
	{ name = 'Mine Area',          coords = vector3(-601.0, 2088.98, 132.54),  sprite = 652, color = 5 },
	{ name = 'Sorting',            coords = vector3(2681.9, 2796.99, 40.48),   sprite = 657, color = 5 },
	{ name = 'Sort Collection',    coords = vector3(2591.93, 2831.91, 39.47),  sprite = 651, color = 5 },
	{ name = 'Sort Collection',    coords = vector3(2629.12, 2868.43, 43.8),   sprite = 651, color = 5 },
	{ name = 'Sort Collection',    coords = vector3(2720.06, 2895.73, 47.75),  sprite = 651, color = 5 },
	{ name = 'Sort Collection',    coords = vector3(2724.76, 2870.89, 45.16),  sprite = 651, color = 5 },
	{ name = 'Smelting & Heating', coords = vector3(1092.18, -1995.79, 29.55), sprite = 648, color = 5 },
	{ name = 'Polishing',          coords = vector3(245.32, 371.06, 105.74),   sprite = 650, color = 5 },
	{ name = 'Jewel: Monica',      coords = vector3(-622.12, -232.21, 38.06),  sprite = 78,  color = 5 },
}

> ox inventory (ox_inventory/data/items.lua)
```lua
    ['minedrill'] = {
		label = 'Drill',
		description = 'A mining drill used to mine for precious metals and gemstones.',
		weight = 2000,
		degrade = 20160,
		stack = true,
		close = true
	},
	['minedrillbit'] = {
		label = 'Drillbit',
		description = 'A drillbit used to mine for precious metals and gemstones.',
		weight = 500,
		stack = true,
		close = true
	},
	['stone'] = {
		label = 'Stone',
		description = 'A piece of stone.',
		weight = 1000,
		degrade = 1440,
		stack = true,
		close = true
	},
	['rawmetalore'] = {
		label = 'Raw Metal Ore',
		description = 'A piece of raw metal ore.',
		weight = 1000,
		degrade = 120,
		stack = true,
		close = true
	},
	['rawgemstoneore'] = {
		label = 'Raw Gemstone Ore',
		description = 'A piece of raw gemstone ore.',
		weight = 1000,
		degrade = 120,
		stack = true,
		close = true
	},
	['platinum'] = {
		label = 'Platinum',
		description = 'A piece of platinum.',
		weight = 50,
		degrade = 4320,
		stack = true,
		close = true
	},
	['palladium'] = {
		label = 'Palladium',
		description = 'A piece of palladium.',
		weight = 25,
		degrade = 7200,
		stack = true,
		close = true
	},
	['gold'] = {
		label = 'Gold',
		description = 'A piece of gold.',
		weight = 75,
		degrade = 4320,
		stack = true,
		close = true
	},
	['silver'] = {
		label = 'Silver',
		description = 'A piece of silver.',
		weight = 100,
		degrade = 4320,
		stack = true,
		close = true
	},
	['diamond'] = {
		label = 'Diamond',
		description = 'A piece of diamond.',
		weight = 50,
		degrade = 4320,
		stack = true,
		close = true
	},
	['ruby'] = {
		label = 'Ruby',
		description = 'A piece of ruby.',
		weight = 50,
		degrade = 4320,
		stack = true,
		close = true
	},
	['rosequartz'] = {
		label = 'Rosequartz',
		description = 'A piece of rosequartz.',
		weight = 50,
		degrade = 4320,
		stack = true,
		close = true
	},
	['emerald'] = {
		label = 'Emerald',
		description = 'A piece of emerald.',
		weight = 50,
		degrade = 4320,
		stack = true,
		close = true
	},
	['turquoise'] = {
		label = 'Turquoise',
		description = 'A piece of turquoise.',
		weight = 50,
		degrade = 4320,
		stack = true,
		close = true
	},
	['sapphire'] = {
		label = 'Sapphire',
		description = 'A piece of sapphire.',
		weight = 50,
		degrade = 4320,
		stack = true,
		close = true
	},
	['polishdiamond'] = {
		label = 'Polished Diamond',
		description = 'A piece of polished diamond.',
		weight = 50,
		degrade = 7200,
		stack = true,
		close = true
	},
	['polishruby'] = {
		label = 'Polished Ruby',
		description = 'A piece of polished ruby.',
		weight = 50,
		degrade = 7200,
		stack = true,
		close = true
	},
	['polishrosequartz'] = {
		label = 'Polished Rosequartz',
		description = 'A piece of polished rosequartz.',
		weight = 50,
		degrade = 7200,
		stack = true,
		close = true
	},
	['polishemerald'] = {
		label = 'Polished Emerald',
		description = 'A piece of polished emerald.',
		weight = 50,
		degrade = 7200,
		stack = true,
		close = true
	},
	['polishturquoise'] = {
		label = 'Polished Turquoise',
		description = 'A piece of polished turquoise.',
		weight = 50,
		degrade = 7200,
		stack = true,
		close = true
	},
	['polishsapphire'] = {
		label = 'Polished Sapphire',
		description = 'A piece of polished sapphire.',
		weight = 50,
		degrade = 7200,
		stack = true,
		close = true
	},
```

> qb/ps/lj inventory (qb-core/shared/items.lua)

```lua
    minedrill = {
        name = 'minedrill',
        label = 'Drill',
        weight = 2000,
        type = 'item',
        image = 'minedrill.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A mining drill used to mine for precious metals and gemstones.'
    },

    minedrillbit = {
        name = 'minedrillbit',
        label = 'Drillbit',
        weight = 500,
        type = 'item',
        image = 'minedrillbit.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A drillbit used to mine for precious metals and gemstones.'
    },

    stone = {
        name = 'stone',
        label = 'Stone',
        weight = 1000,
        type = 'item',
        image = 'stone.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of stone.'
    },

    rawmetalore = {
        name = 'rawmetalore',
        label = 'Raw Metal Ore',
        weight = 1000,
        type = 'item',
        image = 'rawmetalore.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of raw metal ore.'
    },

    rawgemstoneore = {
        name = 'rawgemstoneore',
        label = 'Raw Gemstone Ore',
        weight = 1000,
        type = 'item',
        image = 'rawgemstoneore.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of raw gemstone ore.'
    },

    platinum = {
        name = 'platinum',
        label = 'Platinum',
        weight = 50,
        type = 'item',
        image = 'platinum.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of platinum.'
    },

    palladium = {
        name = 'palladium',
        label = 'Palladium',
        weight = 25,
        type = 'item',
        image = 'palladium.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of palladium.'
    },

    gold = {
        name = 'gold',
        label = 'Gold',
        weight = 75,
        type = 'item',
        image = 'gold.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of gold.'
    },

    silver = {
        name = 'silver',
        label = 'Silver',
        weight = 100,
        type = 'item',
        image = 'silver.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of silver.'
    },

    diamond = {
        name = 'diamond',
        label = 'Diamond',
        weight = 50,
        type = 'item',
        image = 'diamond.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of diamond.'
    },

    ruby = {
        name = 'ruby',
        label = 'Ruby',
        weight = 50,
        type = 'item',
        image = 'ruby.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of ruby.'
    },

    rosequartz = {
        name = 'rosequartz',
        label = 'Rosequartz',
        weight = 50,
        type = 'item',
        image = 'rosequartz.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of rosequartz.'
    },

    emerald = {
        name = 'emerald',
        label = 'Emerald',
        weight = 50,
        type = 'item',
        image = 'emerald.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of emerald.'
    },

    turquoise = {
        name = 'turquoise',
        label = 'Turquoise',
        weight = 50,
        type = 'item',
        image = 'turquoise.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of turquoise.'
    },

    sapphire = {
        name = 'sapphire',
        label = 'Sapphire',
        weight = 50,
        type = 'item',
        image = 'sapphire.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of sapphire.'
    },

    polishdiamond = {
        name = 'polishdiamond',
        label = 'Polished Diamond',
        weight = 50,
        type = 'item',
        image = 'polishdiamond.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of polished diamond.'
    },

    polishruby = {
        name = 'polishruby',
        label = 'Polished Ruby',
        weight = 50,
        type = 'item',
        image = 'polishruby.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of polished ruby.'
    },

    polishrosequartz = {
        name = 'polishrosequartz',
        label = 'Polished Rosequartz',
        weight = 50,
        type = 'item',
        image = 'polishrosequartz.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of polished rosequartz.'
    },

    polishemerald = {
        name = 'polishemerald',
        label = 'Polished Emerald',
        weight = 50,
        type = 'item',
        image = 'polishemerald.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of polished emerald.'
    },

    polishturquoise = {
        name = 'polishturquoise',
        label = 'Polished Turquoise',
        weight = 50,
        type = 'item',
        image = 'polishturquoise.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of polished turquoise.'
    },

    polishsapphire = {
        name = 'polishsapphire',
        label = 'Polished Sapphire',
        weight = 50,
        type = 'item',
        image = 'polishsapphire.png',
        unique = false,
        useable = false,
        shouldClose = true,
        description = 'A piece of polished sapphire.'
    }
```
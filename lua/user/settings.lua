-- Please check `lua/core/settings.lua` to view the full list of configurable settings
local settings = {}

-- If cannot connect to port 22, set false
settings["use_ssh"] = true

settings["use_copilot"] = false
-- Set it to false if there are no need to format on save.
---@type boolean
settings["format_on_save"] = false

-- Set it to false if the notification after formatting is annoying.
---@type boolean
settings["format_notify"] = false

-- Overwrite colorscheme to onedark
settings["colorscheme"] = "onedark"

-- plug: mason-lspconfig: ensure_installed used
-- @type string[]
settings["lsp_deps"] = function(defaults)
	return {
		"clangd",
		"bashls",
		"jsonls",
		"lua_ls",
	}
end

-- General-purpose sources for none-ls to install during bootstrap.
-- Supported sources: https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins
---@type string[]
settings["null_ls_deps"] = function(defaults)
	return {
		"clang_format",
		"shfmt",
		"stylua",
		"vint",
	}
end

-- settings["transparent_background"] = true
settings["disabled_plugins"] = {
	-- "zbirenbaum/copilot.lua"
	-- "hrsh7th/nvim-cmp"
}
-- Set the dashboard startup image here
-- You can generate the ascii image using: https://github.com/TheZoraiz/ascii-image-converter
-- More info: https://github.com/ayamir/nvimdots/wiki/Issues#change-dashboard-startup-image
---@type string[]
settings["dashboard_image"] = {
	[[                                                ]],
	[[                                   ___          ]],
	[[                               ,-""   `.        ]],
	[[                             ,'  _   e )`-._    ]],
	[[                            /  ,' `-._<.===-'   ]],
	[[                           /  /                 ]],
	[[                          /  ;                  ]],
	[[              _.--.__    /   ;                  ]],
	[[ (`._    _.-""       "--'    |                  ]],
	[[ <_  `-""                     \                 ]],
	[[  <`-                          :                ]],
	[[   (__   <__.                  ;                ]],
	[[     `-.   '-.__.      _.'    /                 ]],
	[[        \      `-.__,-'    _,'                  ]],
	[[         `._    ,    /__,-'                     ]],
	[[            ""._\__,'< <____                    ]],
	[[                 | |  `----.`.                  ]],
	[[                 | |        \ `.                ]],
	[[                 ; |___      \-``               ]],
	[[                 \   --<                        ]],
	[[                  `.`.<                         ]],
	[[                    `-'                         ]],
	[[                                                ]],
	[[                                                ]],
}

return settings

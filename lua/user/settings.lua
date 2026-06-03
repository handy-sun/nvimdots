-- Please check `lua/core/settings.lua` to view the full list of configurable settings
local settings = {}

-- If cannot connect to port 22, set false
settings["use_ssh"] = true

settings["use_copilot"] = true
-- Set it to false if there are no need to format on save.
---@type boolean
settings["format_on_save"] = false

-- Set it to false if the notification after formatting is annoying.
---@type boolean
settings["format_notify"] = false

-- Overwrite colorscheme to onedark
settings["colorscheme"] = "onedark"

settings["neovide_config"] = {
	fullscreen = false,
	remember_window_size = true,
	remember_window_position = true,
}

-- plug: mason-lspconfig: ensure_installed used
-- @type string[]
settings["lsp_deps"] = function()
	return {
		"bashls",
		"jsonls",
	}
end

-- Treesitter parsers to install during bootstrap.
-- Use function to replace the default list (table would be appended, not replaced).
---@type string[]
settings["treesitter_deps"] = function()
	return {
		"asm",
		"bash",
		"c",
		"cpp",
		"css",
		"caddy",
		"cmake",
		"css",
		"csv",
		"cuda",
		"c_sharp",
		"editorconfig",
		"fish",
		"go",
		"glsl",
		"html",
		"ini",
		"javascript",
		"json",
		"json5",
		"just",
		"kdl",
		"latex",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"nasm",
		"nginx",
		"nix",
		"perl",
		"php",
		"powershell",
		"python",
		"rust",
		"sql",
		"ssh_config",
		"tmux",
		"toml",
		"typescript",
		"vim",
		"vimdoc",
		"vue",
		"yaml",
		"zsh",
	}
end

-- General-purpose sources for none-ls to install during bootstrap.
-- Supported sources: https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins
---@type string[]
settings["null_ls_deps"] = function()
	return {
		"shfmt",
		"vint",
	}
end

-- settings["transparent_background"] = true
settings["disabled_plugins"] = {
	--- large version update bad
	"andymass/vim-matchup",
	"hiphish/rainbow-delimiters.nvim",
	--- replaced by petertriho/nvim-scrollbar for git overview marks
	"dstein64/nvim-scrollview",
	--- E704 on nvim 0.12+, replaced by handy-sun fork
	"gelguy/wilder.nvim",
	--- replaced by flash.nvim
	"smoka7/hop.nvim",
	"mfussenegger/nvim-treehopper",
	--- unused cmp sources
	"andersevenrud/cmp-tmux",
	"f3fora/cmp-spell",
	"kdheepak/cmp-latex-symbols",
	--- unused: only format_modifications_only=false, never actually used
	"joechrisellis/lsp-format-modifications.nvim",
	--- unused: paint.nvim provides no meaningful value
	"folke/paint.nvim",
}
-- Set the dashboard startup image here
-- You can generate the ascii image using: https://github.com/TheZoraiz/ascii-image-converter
-- More info: https://github.com/ayamir/nvimdots/wiki/Issues#change-dashboard-startup-image
---@type string[]
settings["dashboard_image"] = {
	[[                                                    ]],
	[[                                                    ]],
	[[                                                    ]],
	[[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
	[[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
	[[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
	[[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
	[[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
	[[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
	[[                                                    ]],
	[[         ██████╗  ██████╗ ████████╗███████╗         ]],
	[[         ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝         ]],
	[[         ██║  ██║██║   ██║   ██║   ███████╗         ]],
	[[         ██║  ██║██║   ██║   ██║   ╚════██║         ]],
	[[         ██████╔╝╚██████╔╝   ██║   ███████║         ]],
	[[         ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝         ]],
	[[                                                    ]],
}

return settings

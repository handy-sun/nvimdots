return function()
	require("scrollbar").setup({
		show = true,
		show_in_active_only = true,
		hide_if_all_visible = true,
		throttle_ms = 100,
		handle = {
			text = " ",
			blend = 45,
			hide_if_all_visible = true,
		},
		marks = {
			GitAdd = {
				text = "│",
				priority = 7,
				highlight = "GitSignsAdd",
			},
			GitChange = {
				text = "│",
				priority = 7,
				highlight = "GitSignsChange",
			},
			GitDelete = {
				text = "_",
				priority = 7,
				highlight = "GitSignsDelete",
			},
		},
		handlers = {
			cursor = true,
			diagnostic = false,
			gitsigns = true,
			handle = true,
			search = false,
			ale = false,
		},
		excluded_buftypes = {
			"terminal",
		},
		excluded_filetypes = {
			"alpha",
			"blink-cmp-menu",
			"cmp_docs",
			"cmp_menu",
			"DressingInput",
			"dropbar_menu",
			"dropbar_menu_fzf",
			"fugitive",
			"git",
			"noice",
			"notify",
			"NvimTree",
			"prompt",
			"TelescopePrompt",
			"toggleterm",
			"undotree",
		},
	})

	require("scrollbar.handlers.gitsigns").setup()
end

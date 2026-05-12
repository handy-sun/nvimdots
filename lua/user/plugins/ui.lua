
local vfn = vim.fn
local ui = {}

ui['preservim/tagbar'] = {
	lazy = true,
	event = { 'BufReadPost' },
	name = 'tagbar',
	init = function()
		local expect_width = vfn.float2nr(vfn.winwidth(0) / 6) + 2
		vim.g.tagbar_width = vfn.max({ 32, expect_width })
		vim.g.tagbar_compact = 2
		vim.g.tagbar_indent = 1
		vim.g.tagbar_iconchars = { '', '▼' }
		vim.g.tagbar_sort = 0
		vim.g.tagbar_position = 'topleft vertical'
	end
}

ui['navarasu/onedark.nvim'] = {
	lazy = true,
	name = 'navarasu-onedark',
	config = function()
		require('onedark').setup {
			style = 'darker',
			toggle_style_key = '<leader>ts',
			code_style = {
				-- comments = 'italic'
			},
			diagnostics = {
				darker = true, -- darker colors for diagnostic
				undercurl = true,-- use undercurl instead of underline for diagnostics
				background = true,
			},
			colors = {
				dg_comment = '#52823f'
			},
			highlights = {
				["@comment"] = {fg = '$dg_comment', fmt = 'italic'},
			}
		}
	end
}

ui['mikavilpas/yazi.nvim'] = {
	lazy = false,
	name = 'yazi.nvim',
	version = "*", -- use the latest stable version
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		-- 👇 in this section, choose your own keymappings!
		{
			"<leader>-",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Open yazi at the current file",
		},
		{
			-- Open in the current working directory
			"<leader>cw",
			"<cmd>Yazi cwd<cr>",
			desc = "Open the file manager in nvim's working directory",
		},
		{
			"<C-t>",
			"<cmd>Yazi toggle<cr>",
			desc = "Resume the last yazi session",
		},
	},
	opts = {
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = false,
		keymaps = {
			show_help = "<f1>",
		},
	},
	-- 👇 if you use `open_for_directories=true`, this is recommended
	init = function()
		-- mark netrw as loaded so it's not loaded at all. More details: https://github.com/mikavilpas/yazi.nvim/issues/802
		vim.g.loaded_netrwPlugin = 1
	end,
}

ui['folke/noice.nvim'] = {
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("noice").setup({
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
			},
			views = {
				cmdline_popup = {
					position = {
						row = "50%",
						col = "50%",
					},
					size = {
						min_width = 60,
						width = "auto",
						height = "auto",
					},
				},
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			popupmenu = {
				enabled = true,
				backend = "cmp",
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = false, -- keep search in the popup cmdline
				command_palette = false, -- keep the cmdline popup centered
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		})
	end,
}

return ui

local tool = {}

tool["junegunn/fzf"] = {
	lazy = true,
	ft = "fzf",
	init = function()
		vim.g.fzf_buffers_jump = 1
	end,
}

tool["folke/which-key.nvim"] = {
	lazy = true,
}

-- Override: remove cond restriction so fzf-lua loads alongside telescope
tool["ibhagwan/fzf-lua"] = {
	lazy = true,
	cond = true,
	cmd = "FzfLua",
	config = require("tool.fzf-lua"),
	dependencies = { "nvim-tree/nvim-web-devicons" },
}

-- tool['ranjithshegde/ccls.nvim'] = {
-- 	lazy = true,
-- 	event = { 'BufReadPost' },
-- 	config = function ()
-- 		require("ccls").setup {
-- 			defaults = {
-- 				win_config = {
-- 					-- Sidebar configuration
-- 					sidebar = {
-- 						size = 50,
-- 						position = "topleft",
-- 						split = "vnew",
-- 						width = 50,
-- 						height = 20,
-- 					},
-- 					-- floating window configuration. check :help nvim_open_win for options
-- 					float = {
-- 						style = "minimal",
-- 						relative = "cursor",
-- 						width = 50,
-- 						height = 20,
-- 						row = 0,
-- 						col = 0,
-- 						border = "rounded",
-- 					},
-- 				},
-- 				filetypes = {"c", "cpp", "cc", "hpp", "objc", "objcpp"},

-- 				-- Lsp is not setup by default to avoid overriding user's personal configurations.
-- 				-- Look ahead for instructions on using this plugin for ccls setup
-- 				lsp = {
-- 					codelens = {
-- 						enabled = false,
-- 						events = {"BufEnter", "BufWritePost"}
-- 					}
-- 				}
-- 			}
-- 		}
-- 	end
-- }

-- Override telescope config to remove project.nvim extension
-- (upstream load_extension("projects") fails when project.nvim is disabled)
tool["nvim-telescope/telescope.nvim"] = {
	lazy = true,
	cmd = "Telescope",
	config = function()
		local icons = { ui = require("modules.utils.icons").get("ui", true) }
		local lga_actions = require("telescope-live-grep-args.actions")

		require("telescope").setup({
			defaults = {
				vimgrep_arguments = {
					"rg", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case",
				},
				initial_mode = "insert",
				prompt_prefix = " " .. icons.ui.Telescope .. " ",
				selection_caret = icons.ui.ChevronRight,
				scroll_strategy = "limit",
				results_title = false,
				layout_strategy = "flex",
				path_display = { "absolute" },
				selection_strategy = "reset",
				color_devicons = true,
				file_ignore_patterns = { ".git/", ".cache", "build/", "%%.class", "%%.pdf", "%%.mkv", "%%.mp4", "%%.zip" },
				layout_config = {
					horizontal = { preview_width = 0.55 },
					vertical = { mirror = false },
					width = 0.85, height = 0.92, preview_cutoff = 120,
				},
				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
				file_sorter = require("telescope.sorters").get_fuzzy_file,
				generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
				buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
			},
			extensions = {
				fzf = { fuzzy = false, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" },
				frecency = { show_scores = true, show_unindexed = true, ignore_patterns = { "*.git/*", "*/tmp/*" } },
				live_grep_args = {
					auto_quoting = true,
					mappings = { i = {
						["<C-k>"] = lga_actions.quote_prompt(),
						["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					} },
				},
				undo = {
					side_by_side = true,
					mappings = { i = {
						["<cr>"] = require("telescope-undo.actions").yank_additions,
						["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
						["<C-cr>"] = require("telescope-undo.actions").restore,
					} },
				},
				advanced_git_search = { diff_plugin = "diffview", git_flags = { "-c", "delta.side-by-side=true" }, entry_default_author_or_date = "author" },
			},
		})

		require("telescope").load_extension("frecency")
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("live_grep_args")
		require("telescope").load_extension("notify")
		require("telescope").load_extension("project")
		require("telescope").load_extension("undo")
		require("telescope").load_extension("zoxide")
		require("telescope").load_extension("persisted")
		require("telescope").load_extension("advanced_git_search")
	end,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
		{ "nvim-telescope/telescope-frecency.nvim" },
		{ "nvim-telescope/telescope-live-grep-args.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "jvgrootveld/telescope-zoxide" },
		{ "debugloop/telescope-undo.nvim" },
		{ "ayamir/search.nvim", config = require("tool.search") },
		{ "aaronhallaert/advanced-git-search.nvim", cmd = { "AdvancedGitSearch" }, dependencies = { "tpope/vim-rhubarb", "tpope/vim-fugitive", "sindrets/diffview.nvim" } },
	},
}

tool["nvim-telescope/telescope-project.nvim"] = {
	dependencies = { "nvim-telescope/telescope.nvim" },
}

return tool

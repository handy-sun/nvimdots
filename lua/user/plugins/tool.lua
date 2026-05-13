local tool = {}

tool['junegunn/fzf'] = {
	lazy = true,
	ft = 'fzf',
	init = function()
		vim.g.fzf_buffers_jump = 1
	end
}

tool["folke/which-key.nvim"] = {
	lazy = true,
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

return tool

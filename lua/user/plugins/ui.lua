
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
			style = 'dark',
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

return ui

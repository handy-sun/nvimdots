---@diagnostic disable: undefined-global
local bind = require("keymap.bind")
local map_cr = bind.map_cr

local mappings = {
	plugins = {
		-- Plugin: iswap.nvim
		["n|<leader>is"] = map_cr("ISwap"):with_silent():with_noremap():with_desc("iswap: Interactively swap two items"),
		["n|<leader>iw"] = map_cr("ISwapWith"):with_silent():with_noremap():with_desc("iswap: Swap cursor item with another"),
		["n|<leader>ir"] = map_cr("ISwapWithRight"):with_silent():with_noremap():with_desc("iswap: Swap cursor item with right"),
		["n|<leader>il"] = map_cr("ISwapWithLeft"):with_silent():with_noremap():with_desc("iswap: Swap cursor item with left"),
		["n|<leader>in"] = map_cr("ISwapNode"):with_silent():with_noremap():with_desc("iswap: Swap two adjacent nodes"),
		["n|<leader>im"] = map_cr("ISwapNodeWithRight"):with_silent():with_noremap():with_desc("iswap: Move node right"),
	},
}

bind.nvim_load_mapping(mappings.plugins)

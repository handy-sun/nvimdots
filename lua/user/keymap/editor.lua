---@diagnostic disable: undefined-global
local bind = require("keymap.bind")
local map_cr = bind.map_cr

return {
	-- Plugin: iswap.nvim (swap)
	["n|<leader>is"] = map_cr("ISwap"):with_silent():with_noremap():with_desc("iswap: Interactively swap two items"),
	["n|<leader>iw"] = map_cr("ISwapWith"):with_silent():with_noremap():with_desc("iswap: Swap cursor item with another"),
	["n|<leader>ir"] = map_cr("ISwapWithRight"):with_silent():with_noremap():with_desc("iswap: Swap cursor item with right"),
	["n|<leader>il"] = map_cr("ISwapWithLeft"):with_silent():with_noremap():with_desc("iswap: Swap cursor item with left"),
	["n|<leader>in"] = map_cr("ISwapNode"):with_silent():with_noremap():with_desc("iswap: Swap two adjacent nodes"),
	["n|<leader>iN"] = map_cr("ISwapNodeWith"):with_silent():with_noremap():with_desc("iswap: Swap cursor node with another"),
	-- Plugin: iswap.nvim (move)
	["n|<leader>im"] = map_cr("IMove"):with_silent():with_noremap():with_desc("iswap: Interactively move item"),
	["n|<leader>iM"] = map_cr("IMoveWith"):with_silent():with_noremap():with_desc("iswap: Move cursor item to another position"),
	["n|<leader>ie"] = map_cr("IMoveWithRight"):with_silent():with_noremap():with_desc("iswap: Move cursor item right"),
	["n|<leader>ib"] = map_cr("IMoveWithLeft"):with_silent():with_noremap():with_desc("iswap: Move cursor item left"),
	["n|<leader>id"] = map_cr("IMoveNode"):with_silent():with_noremap():with_desc("iswap: Move node to another position"),
	["n|<leader>iD"] = map_cr("IMoveNodeWith"):with_silent():with_noremap():with_desc("iswap: Move cursor node to another position"),
}

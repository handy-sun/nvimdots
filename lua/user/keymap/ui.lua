---@diagnostic disable: undefined-global
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

return {
	-- Plugin: vista/tagbar
	["n|gi"] = map_cr("Tagbar"):with_noremap():with_silent():with_desc("split left: Vista tagbar toggle"),
	-- Plugin: bufferline.nvim
	["n|<C-i>"] = map_cr("BufferLineCyclePrev"):with_noremap():with_silent():with_desc("buffer: Switch to prev"),
	["n|<C-o>"] = map_cr("BufferLineCycleNext"):with_noremap():with_silent():with_desc("buffer: Switch to next"),
	["n|<leader><Left>"] = map_cu("exe v:count1 . 'bprevious'"):with_noremap():with_silent():with_desc("buffer: Switch to [count] prev"),
	["n|<leader><Right>"] = map_cu("exe v:count1 . 'bnext'"):with_noremap():with_silent():with_desc("buffer: Switch to [count] next"),
	-- Save and quit
	["n|<leader>w"] = map_cr("w"):with_noremap():with_silent():with_desc("edit: Save file"),
	["n|<leader>q"] = map_cr("q"):with_desc("edit: Quit"),
	["n|<leader><BS>"] = map_cr("wqa"):with_desc("edit: Save All file(s) and quit"),
	["n|<leader>Q"] = map_cr("q!"):with_desc("edit: Force quit"),
	-- Tab
	["n|tc"] = map_cr("tabclose"):with_desc("tab: Close current tab"),
}

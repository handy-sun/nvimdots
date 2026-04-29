---@diagnostic disable: undefined-global
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd

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
	-- Split navigation
	["n|sh"] = map_cmd(":setlocal nosplitright<CR>:vsplit <C-R>=GetAbsFileDir()<CR>"):with_noremap():with_desc("split left and fill absolute path"),
	["n|sl"] = map_cmd(":setlocal splitright<CR>:vsplit <C-R>=GetAbsFileDir()<CR>"):with_noremap():with_desc("split right and fill absolute path"),
	["n|sk"] = map_cmd(":setlocal nosplitbelow<CR>:split <C-R>=GetAbsFileDir()<CR>"):with_noremap():with_desc("split above and fill absolute path"),
	["n|sj"] = map_cmd(":setlocal splitbelow<CR>:split <C-R>=GetAbsFileDir()<CR>"):with_noremap():with_desc("split below and fill absolute path"),
	["n|se"] = map_cmd(":e <C-R>=GetAbsFileDir()<CR>"):with_noremap():with_desc("edit another file fill absolute path"),
	-- Show registers, buffers, marks
	["n|z'"] = map_cr("registers"):with_noremap():with_desc("command: Show all registers"),
	["n|zm"] = map_cr("marks"):with_noremap():with_desc("command: Show all marks"),
	["n|zl"] = map_cmd(":ls<CR>"):with_noremap():with_desc("command: Show all buffers and select one"),
	["n|sd"] = map_cr("bdelete"):with_noremap():with_desc("command: Delete current buffer"),
	-- Quickfix
	["n|z["] = map_cr("exe v:count1 . 'cprevious'"):with_noremap():with_silent():with_desc("quickfix: move [count] prev"),
	["n|z]"] = map_cr("exe v:count1 . 'cnext'"):with_noremap():with_silent():with_desc("quickfix: move [count] next"),
	-- Grep
	["n|<Leader>cp"] = map_cmd(':CpGrep "" <C-R>=GetAbsFileDir()<CR><C-Left><Left><Left>'):with_noremap():with_desc("command: Grep in the current directory"),
	-- Command mode
	["c|<C-t>"] = map_cmd("<C-R>=GetAbsFileDir()<CR>"):with_noremap():with_silent():with_desc("command: Fill absolute path"),
	-- System clipboard
	["n|ss"] = map_cmd('"*y'):with_noremap():with_desc("yank select pattern into system clipboard"),
	["v|<leader><space>"] = map_cmd('"*y'):with_noremap():with_desc("yank select pattern into system clipboard"),
	["n|su"] = map_cmd('"*p'):with_noremap():with_desc("paste from system clipboard"),
	["v|su"] = map_cmd('"*p'):with_noremap():with_desc("paste from system clipboard"),
}

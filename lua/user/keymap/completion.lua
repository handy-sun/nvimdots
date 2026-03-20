local mappings = {}

-- Place global keymaps here.
-- mappings["plug_map"] = {}

-- custom {{{1
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local map_cu = bind.map_cu
-- local et = bind.escape_termcode

mappings["plug_map"] = {
	-- !! Disable these mappings
	["n|<C-s>"] = "",
	["n|<Esc>"] = "",
	-- ["n|<M-h>"] = "",
	-- ["n|<M-l>"] = "",
	-- ["n|<M-j>"] = "",
	-- ["n|<M-k>"] = "",
	["n|<C-q>"] = "",
	["n|<M-S-q>"] = "",
	["v|J"] = "",
	["v|K"] = "",
	-- noh
	["n|<leader>s"] = map_callback(function()
			_flash_esc_or_noh()
		end)
		:with_noremap():with_silent():with_desc("edit: Clear search highlight"),
	["n|<leader>/"] = map_cmd('gcc'):with_silent():with_desc("edit: Toggle comment for line (custom)"),
	["n|gi"] = map_cr("Tagbar"):with_noremap():with_silent():with_desc("split left: Vista tagbar toggle"),
	-- Swap these two origin mappings
	["n|<C-i>"] = map_cr("BufferLineCyclePrev"):with_noremap():with_silent():with_desc("buffer: Switch to prev"),
	["n|<C-o>"] = map_cr("BufferLineCycleNext"):with_noremap():with_silent():with_desc("buffer: Switch to next"),
	-- Select all
	["n|<C-a>"] = map_cmd("ggVG"):with_noremap():with_desc("Select all contents"),
	["n|n"] = map_cmd("'Nn'[v:searchforward]"):with_noremap():with_expr():with_desc("Always search forward"),
	["n|N"] = map_cmd("'nN'[v:searchforward]"):with_noremap():with_expr():with_desc("Always search backward"),
	-- range mapping (v:count1)
	["n|[\\"] = map_cmd(":<C-u>put! =repeat(nr2char(10), v:count1)<CR>'["):with_noremap():with_silent():with_desc("edit: Insert [count] line(s) above the current line"),
	["n|]\\"] = map_cmd(":<C-u>put =repeat(nr2char(10), v:count1)<CR>"):with_noremap():with_silent():with_desc("edit: Append [count] line(s) below the current line"),
	["n|[<space>"] = map_cmd(":<C-u>exe 'normal! i' . repeat(\' \', v:count1)<CR>l"):with_noremap():with_silent():with_desc("edit: Insert [count] space(s) behind the cursor(cursor move with the old colmun)"),
	-- ["n|[<space>"] = map_cu("exe 'normal! i' . repeat(nr2char(32), v:count1)"):with_noremap():with_desc("edit: Insert [count] space(s) behind the cursor(cursor move with the old colmun)"),
	-- TODO: how to use range
	["n|]<space>"] = map_cmd("my:<C-u>exe 'normal! a '<CR>`y"):with_noremap():with_silent():with_desc("edit: Append space after the cursor(cursor postion donnot modify)"),
	["n|<leader>-"] = map_cu("exe v:count1 . 'bprevious'"):with_noremap():with_silent():with_desc("buffer: Switch to [count] prev"),
	["n|<leader>="] = map_cu("exe v:count1 . 'bnext'"):with_noremap():with_silent():with_desc("buffer: Switch to [count] next"),
	["n|z["] = map_cu("exe v:count1 . 'cprevious'"):with_noremap():with_silent():with_desc("quickfix: move [count] prev"),
	["n|z]"] = map_cu("exe v:count1 . 'cnext'"):with_noremap():with_silent():with_desc("quickfix: move [count] next"),
	-- Resize window
	-- Save and quit
	["n|<leader><space>"] = map_cr("w"):with_noremap():with_silent():with_desc("edit: Save file"),
	["n|<leader>q"] = map_cr("wq"):with_desc("edit: Save file and quit"),
	["n|<leader><BS>"] = map_cr("wqa"):with_desc("edit: Save All file(s) and quit"),
	["n|<leader>e"] = map_cr("q!"):with_desc("edit: Force quit"),
	["n|<leader><Tab>"] = map_cmd("@=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>"):with_silent():with_desc("ui: Fold Toggle"),
	-- Quickly copy/paste and search/replace
	["n|sc"] = map_cmd('"ayiw'):with_noremap():with_desc("yank a word into register a"),
	["n|sv"] = map_cmd('viw"ap'):with_noremap():with_desc("paste override a word with register a"),
	["n|sw"] = map_cmd('"byiW'):with_noremap():with_desc("yank WORD into register b"),
	["n|so"] = map_cmd('viW"bp'):with_noremap():with_desc("paste override WORD with register b"),
	["n|s-"] = map_cmd("vg_p"):with_noremap():with_desc("paste until EOL, donnot contain <CR>"),
	["n|sa"] = map_cmd(":%s/<C-R>a/"):with_noremap():with_desc("replace register a"),
	["n|s/"] = map_cmd(":%s/<C-R>//"):with_noremap():with_desc("replace search word"),
	["n|sr"] = map_cmd(":%s/\\<<C-R><C-W>\\>/"):with_noremap():with_desc("replace the word under the cursor"),
	-- split 4 pos window and fill with absolute path of current file
	["n|se"] = map_cmd(":e <C-R>=expand('%:p:h') . '/' <CR>"):with_noremap():with_desc("edit another file fill absolute path"),
	["n|sh"] = map_cmd(":setlocal nosplitright<CR>:vsplit <C-R>=expand('%:p:h') . '/' <CR>"):with_noremap():with_desc("split left and fill absolute path"),
	["n|sl"] = map_cmd(":setlocal splitright<CR>:vsplit <C-R>=expand('%:p:h') . '/' <CR>"):with_noremap():with_desc("split right and fill absolute path"),
	["n|sk"] = map_cmd(":setlocal nosplitbelow<CR>:split <C-R>=expand('%:p:h') . '/' <CR>"):with_noremap():with_desc("split above and fill absolute path"),
	["n|sj"] = map_cmd(":setlocal splitbelow<CR>:split <C-R>=expand('%:p:h') . '/' <CR>"):with_noremap():with_desc("split below and fill absolute path"),
	-- show registers, buffers, marks
	["n|z'"] = map_cr("registers"):with_noremap():with_desc("command: Show all registers"),
	["n|zm"] = map_cr("marks"):with_noremap():with_desc("command: Show all marks"),
	-- not show ls output on nivm 
	-- ["n|zl"] = map_cmd(":ls<CR>:b"):with_noremap():with_desc("command: Show all buffers and select one"),
	-- Edit file
	["n|<leader>W"] = map_cmd(":%s/\\s\\+$//<CR>"):with_noremap():with_desc("edit: Trim EOL trailing space"),
	["n|<leader><CR>"] = map_cmd("i<CR><Esc>k$"):with_noremap():with_desc("edit: Break this line and move right content to next line"),
	["n|<S-Up>"] = map_cu("exe 'move -' . (1 + v:count1)"):with_desc("edit: Move this line [count] up"),
	["n|<S-Down>"] = map_cu("exe 'move +' . v:count1"):with_desc("edit: Move this line [count] down"),
	["n|<leader><Up>"] = map_cmd("yyP"):with_desc("edit: Yank line and paste above"),
	["n|<leader><Down>"] = map_cmd("yyp"):with_desc("edit: Yank line and paste below"),
	["n|<Leader>\""] = map_cmd('viw<ESC>bi"<ESC>ea"<ESC>'):with_noremap():with_desc("edit: Wrap the word with double quote"),
	["n|<Leader>;"] = map_cmd('mzA;<ESC>`z'):with_noremap():with_desc("edit: Append a ';' after EOL"),
	-- Insert mode
	["i|<C-d>"] = map_cmd("<Esc>ddi"):with_noremap():with_silent():with_desc("Clear current line"),
	["i|<C-z>"] = map_cmd("<Esc>ui"):with_noremap():with_silent():with_desc("Undo"),
	-- ["i|<C-u>"]: origin
	["i|<C-k>"] = map_cmd("<C-o>D"):with_noremap():with_silent():with_desc("Delete content behind block"),
	-- Visual mode
	["v|<leader>/"] = map_cmd('gc'):with_silent():with_desc("edit: Toggle comment for line in Visual(custom)"),
	["v|<S-Up>"] = map_cmd(":move '<-2<CR>gv"):with_desc("edit: Move select line(s) up"),
	["v|<S-Down>"] = map_cmd(":move '>+<CR>gv"):with_desc("edit: Move select line(s) down"),
	-- Command mode
	["c|<C-t>"] = map_cmd("<C-R>=expand('%:p:h') . '/' <CR>"):with_noremap():with_silent():with_desc("command: Fill absolute path"),
	-- Copy to system clipboard
	["n|ss"] = map_cmd('"*y'):with_noremap():with_desc("yank select pattern into system clipboard"),
	["v|<leader><space>"] = map_cmd('"*y'):with_noremap():with_desc("yank select pattern into system clipboard"),
	["n|su"] = map_cmd('"*p'):with_noremap():with_desc("paste from system clipboard"),
	["v|su"] = map_cmd('"*p'):with_noremap():with_desc("paste from system clipboard"),
}
-- custom }}}1


-- NOTE: This function is special! Keymaps defined here are ONLY effective in buffers with LSP(s) attached
-- NOTE: Make sure to include `:with_buffer(buf)` to limit the scope of your mappings.
---@param buf number @The effective bufnr
mappings["lsp"] = function(buf)
	return {
		-- Example
		["n|K"] = require("keymap.bind").map_cr("Lspsaga hover_doc"):with_buffer(buf):with_desc("lsp: Show doc"),
	}
end

return mappings

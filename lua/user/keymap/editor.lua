---@diagnostic disable: undefined-global
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cmd = bind.map_cmd

return {
	-- Disable upstream visual line shift (replaced by custom)
	["v|J"] = "",
	["v|K"] = "",
	-- Select all
	["n|<C-a>"] = map_cmd("ggVG"):with_noremap():with_desc("Select all contents"),
	-- Suckless overrides
	["n|n"] = map_cmd("'Nn'[v:searchforward]"):with_noremap():with_expr():with_desc("Always search forward"),
	["n|N"] = map_cmd("'nN'[v:searchforward]"):with_noremap():with_expr():with_desc("Always search backward"),
	-- Hop
	["nv|<leader>2"] = map_cmd("<Cmd>HopWordMW<CR>"):with_noremap():with_desc("jump: Goto word"),
	-- Comment
	["n|<leader>/"] = map_cmd("gcc"):with_silent():with_desc("edit: Toggle comment for line (custom)"),
	["v|<leader>/"] = map_cmd("gc"):with_silent():with_desc("edit: Toggle comment for line in Visual(custom)"),
	-- Paste/format shortcuts
	["n|<leader>W"] = map_cmd(":%s/\\s\\+$//<CR>"):with_noremap():with_desc("edit: Trim EOL trailing space"),
	["n|<leader><CR>"] = map_cmd("i<CR><Esc>k$"):with_noremap():with_desc("edit: Break this line and move right content to next line"),
	["n|<S-Up>"] = map_cr("exe 'move -' . (1 + v:count1)"):with_desc("edit: Move this line [count] up"),
	["n|<S-Down>"] = map_cr("exe 'move +' . v:count1"):with_desc("edit: Move this line [count] down"),
	["v|<S-Up>"] = map_cmd(":move '<-2<CR>gv"):with_desc("edit: Move select line(s) up"),
	["v|<S-Down>"] = map_cmd(":move '>+<CR>gv"):with_desc("edit: Move select line(s) down"),
	["n|<leader><Up>"] = map_cmd("yyP"):with_desc("edit: Yank line and paste above"),
	["n|<leader><Down>"] = map_cmd("yyp"):with_desc("edit: Yank line and paste below"),
	-- Range editing
	["n|[\\"] = map_cmd(":<C-u>put! =repeat(nr2char(10), v:count1)<CR>'["):with_noremap():with_silent():with_desc("edit: Insert [count] line(s) above the current line"),
	["n|]\\"] = map_cmd(":<C-u>put =repeat(nr2char(10), v:count1)<CR>"):with_noremap():with_silent():with_desc("edit: Append [count] line(s) below the current line"),
	["n|[<space>"] = map_cmd(":<C-u>exe 'normal! i' . repeat(' ', v:count1)<CR>l"):with_noremap():with_silent():with_desc("edit: Insert [count] space(s) behind the cursor"),
	["n|]<space>"] = map_cmd("my:<C-u>exe 'normal! a '<CR>`y"):with_noremap():with_silent():with_desc("edit: Append space after the cursor"),
	-- Register operations
	["n|sc"] = map_cmd('"ayiw'):with_noremap():with_desc("yank a word into register a"),
	["n|sv"] = map_cmd('viw"ap'):with_noremap():with_desc("paste override a word with register a"),
	["n|sw"] = map_cmd('"byiW'):with_noremap():with_desc("yank WORD into register b"),
	["n|so"] = map_cmd('viW"bp'):with_noremap():with_desc("paste override WORD with register b"),
	["n|s-"] = map_cmd("vg_p"):with_noremap():with_desc("paste until EOL, without <CR>"),
	["n|sa"] = map_cmd(":%s/<C-R>a/"):with_noremap():with_desc("replace register a"),
	["n|s/"] = map_cmd(":%s/<C-R>//"):with_noremap():with_desc("replace search word"),
	["n|sr"] = map_cmd(":%s/\\<<C-R><C-W>\\>/"):with_noremap():with_desc("replace the word under the cursor"),
	["n|<Leader>\""] = map_cmd('viw<ESC>bi"<ESC>ea"<ESC>'):with_noremap():with_desc("edit: Wrap the word with double quote"),
	["n|<Leader>;"] = map_cmd("mzA;<ESC>`z"):with_noremap():with_desc("edit: Append a ';' after EOL"),
	-- Insert mode overrides
	["i|<C-d>"] = map_cmd("<Esc>ddi"):with_noremap():with_silent():with_desc("Clear current line"),
	["i|<C-z>"] = map_cmd("<Esc>ui"):with_noremap():with_silent():with_desc("Undo"),
	["i|<C-k>"] = map_cmd("<C-o>D"):with_noremap():with_silent():with_desc("Delete content behind block"),
}

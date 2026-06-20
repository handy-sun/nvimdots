local options = {
	cindent = true,
	wrap = true,
	showbreak = "⣿",
	showcmd = true,
	gdefault = true,
	clipboard = "",
	cursorcolumn = false,
	timeoutlen = 700,
	ttimeoutlen = 50,
	cmdwinheight = 7,
	showtabline = 1,
	foldmethod = "manual",
	wildignore = ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**,*build*",
}

if vim.fn.executable("rg") == 1 then
	options["grepprg"] = "rg --hidden --vimgrep --smart-case -- "
else
	options["grepprg"] = "grep --binary-files=without-match -irn $*"
	options["grepformat"] = "%f:%l:%m,%f:%l%m,%f  %l%m"
end

vim.opt.suffixes:append(".a,.1,.class")

vim.cmd([[
command! -nargs=+ -complete=file CpGrep execute 'silent grep! <args>' | copen 9 | redraw!
ca w!! w !sudo tee "%"
]])

local path_sep = vim.fn.has("win32") == 1 and "\\" or "/"
vim.cmd(string.format(
	[[function! GetAbsFileDir()
    return expand('%%:p:h') . '%s'
endfunction]],
	path_sep
))

--- Auto-set cwd to project root using built-in vim.fs.root()
local root_markers = { ".git", "package.json", "Makefile", "pyproject.toml", ".nvim.lua" }
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("AutoRoot", { clear = true }),
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		local root = vim.fs.root(args.buf, root_markers)
		if root and root ~= vim.uv.cwd() then
			vim.cmd.cd(root)
		end
	end,
})

return options

local definitions = {
	bufs = {
		{ "BufRead,BufNew", "tmux*.conf", "setf tmux" },
		{ "BufRead,BufNew", "*.conf", "setf config" },
		{ "BufRead,BufNew", "*.log", "setf messages" },
	},
	ft = {
		{ "FileType", "yaml", "set shiftwidth=2 expandtab commentstring=#\\ %s" },
		-- { "FileType", "lua", "set noexpandtab tabstop=4 softtabstop=0" },
		{ "FileType", "systemd", "setlocal commentstring=#\\ %s" },
		{ "FileType", "crontab", "setlocal nobackup nowritebackup" },
		{ "FileType", "help", "if &buftype != 'quickfix' | wincmd L | vertical resize -10 | endif" },
		{ "FileType", "c,cpp", "lua require('modules.utils.cpp_include').setup_buffer()" },
		{
			"FileType",
			"c,cpp",
			"nnoremap <silent> <buffer> <leader>h <Cmd>LspClangdSwitchSourceHeader<CR>",
		},
	},
}

local tab_close_group = vim.api.nvim_create_augroup("TabCloseDeleteBuffers", { clear = true })
local tab_buffers = {}
local closing_tabpage
local closing_tab_buffers = {}

local function add_tab_buffer(tabpage, buffer)
	if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buflisted then
		tab_buffers[tabpage] = tab_buffers[tabpage] or {}
		tab_buffers[tabpage][buffer] = true
	end
end

local function record_current_tab_buffers()
	local tabpage = vim.api.nvim_get_current_tabpage()
	local buffers = {}
	for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		buffers[#buffers + 1] = vim.api.nvim_win_get_buf(window)
	end
	for _, buffer in ipairs(buffers) do
		add_tab_buffer(tabpage, buffer)
	end
end

local function copy_buffers(buffers)
	local copy = {}
	for buffer in pairs(buffers or {}) do
		copy[buffer] = true
	end
	return copy
end

vim.api.nvim_create_autocmd("BufEnter", {
	group = tab_close_group,
	callback = function(args)
		add_tab_buffer(vim.api.nvim_get_current_tabpage(), args.buf)
	end,
})

vim.api.nvim_create_autocmd("BufDelete", {
	group = tab_close_group,
	callback = function(args)
		for _, buffers in pairs(tab_buffers) do
			buffers[args.buf] = nil
		end
	end,
})

vim.api.nvim_create_autocmd("TabEnter", {
	group = tab_close_group,
	callback = record_current_tab_buffers,
})

record_current_tab_buffers()

-- TabClosed only exposes the closed tab number, so capture its history beforehand.
vim.api.nvim_create_autocmd("TabClosedPre", {
	group = tab_close_group,
	callback = function()
		closing_tabpage = vim.api.nvim_get_current_tabpage()
		closing_tab_buffers = copy_buffers(tab_buffers[closing_tabpage])
		if next(closing_tab_buffers) == nil then
			record_current_tab_buffers()
			closing_tab_buffers = copy_buffers(tab_buffers[closing_tabpage])
		end
	end,
})

vim.api.nvim_create_autocmd("TabClosed", {
	group = tab_close_group,
	callback = function()
		local remaining_tab_buffers = {}
		for tabpage, buffers in pairs(tab_buffers) do
			if tabpage ~= closing_tabpage then
				for buffer in pairs(buffers) do
					remaining_tab_buffers[buffer] = true
				end
			end
		end

		local buffers = closing_tab_buffers
		tab_buffers[closing_tabpage] = nil
		closing_tabpage = nil
		closing_tab_buffers = {}
		for buffer in pairs(buffers) do
			if
				not remaining_tab_buffers[buffer]
				and vim.api.nvim_buf_is_valid(buffer)
				and vim.bo[buffer].buflisted
				and not vim.bo[buffer].modified
			then
				pcall(vim.api.nvim_buf_delete, buffer, { force = false })
			end
		end
	end,
})

return definitions

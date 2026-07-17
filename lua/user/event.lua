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
local closing_tab_buffers = {}

local function get_tab_buffers(tabpage)
	local buffers = {}
	for _, window in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
		buffers[vim.api.nvim_win_get_buf(window)] = true
	end
	return buffers
end

-- TabClosed only exposes the closed tab number, so capture its buffers beforehand.
vim.api.nvim_create_autocmd("TabClosedPre", {
	group = tab_close_group,
	callback = function()
		closing_tab_buffers = get_tab_buffers(0)
	end,
})

vim.api.nvim_create_autocmd("TabClosed", {
	group = tab_close_group,
	callback = function()
		local visible_buffers = {}
		for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
			for buffer in pairs(get_tab_buffers(tabpage)) do
				visible_buffers[buffer] = true
			end
		end

		local buffers = closing_tab_buffers
		closing_tab_buffers = {}
		for buffer in pairs(buffers) do
			if
				not visible_buffers[buffer]
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

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

return definitions

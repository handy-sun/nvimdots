local function highlight_special_files()
	-- Special files keep the normal file color, with only an underline added.
	local normal = vim.api.nvim_get_hl(0, { name = "NvimTreeNormal", link = false })
	if vim.tbl_isempty(normal) then
		normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
	end
	local special = {
		underline = true,
		cterm = { underline = true },
	}

	for _, key in ipairs({ "fg", "bg", "ctermfg", "ctermbg" }) do
		if normal[key] ~= nil then
			special[key] = normal[key]
		end
	end

	vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", special)

	-- nvim-tree normally gives special files precedence over executable files.
	-- Add a combined group so an executable special file keeps both signals.
	local executable = vim.api.nvim_get_hl(0, { name = "NvimTreeExecFile", link = false })
	if vim.tbl_isempty(executable) then
		executable = vim.api.nvim_get_hl(0, { name = "Question", link = false })
	end
	local special_executable = vim.tbl_extend("force", special, executable)
	special_executable.underline = true
	special_executable.cterm = vim.tbl_extend("force", special.cterm, executable.cterm or {})
	special_executable.cterm.underline = true
	vim.api.nvim_set_hl(0, "NvimTreeSpecialExecutableFile", special_executable)
end

return function(opts)
	local file_node = require("nvim-tree.node.file")
	if not file_node._user_special_executable_highlight then
		local highlighted_name = file_node.highlighted_name
		file_node.highlighted_name = function(self)
			local result = highlighted_name(self)
			if self.executable and result.hl[1] == "NvimTreeSpecialFile" then
				result.hl[1] = "NvimTreeSpecialExecutableFile"
			end
			return result
		end
		file_node._user_special_executable_highlight = true
	end

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("NvimTreeUserHighlights", { clear = true }),
		callback = highlight_special_files,
	})

	-- nvim-tree creates its default highlight groups during setup.
	vim.schedule(highlight_special_files)
	return opts
end

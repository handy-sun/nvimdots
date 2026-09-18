local function highlight_special_files()
	-- Special files keep the normal file color, with only an underline added.
	local normal = vim.api.nvim_get_hl(0, { name = "NvimTreeNormal", link = false })
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
end

return function(opts)
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("NvimTreeUserHighlights", { clear = true }),
		callback = highlight_special_files,
	})

	-- nvim-tree creates its default highlight groups during setup.
	vim.schedule(highlight_special_files)
	return opts
end

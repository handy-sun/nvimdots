local mappings = {}

-- Disable upstream editor builtins that conflict with custom workflow
mappings["plug_map"] = {
	-- !! Disable these mappings
	["n|<C-s>"] = "",
	["n|<Esc>"] = "",
	["n|<C-q>"] = "",
	["n|<M-S-q>"] = "",
}

-- NOTE: This function is special! Keymaps defined here are ONLY effective in buffers with LSP(s) attached
-- NOTE: Make sure to include `:with_buffer(buf)` to limit the scope of your mappings.
---@param buf number @The effective bufnr
mappings["lsp"] = function(buf)
	return {}
end

return mappings

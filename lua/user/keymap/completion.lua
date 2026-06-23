local map_callback = require("keymap.bind").map_callback

local mappings = {}

-- Disable upstream editor builtins that conflict with custom workflow
mappings["plug_map"] = {
	-- !! Disable these mappings
	["n|<C-s>"] = "",
	["n|<Esc>"] = "",
	["n|<C-q>"] = "",
	["n|<M-S-q>"] = "",
	-- Toggle cmdline completion
	["n|<leader>tc"] = map_callback(function()
		local toggle = require("user.cmdline_toggle")
		toggle.enabled = not toggle.enabled
		require("cmp").setup.cmdline(":", toggle.get_config())
		vim.notify(
			toggle.enabled and "Cmdline completion enabled" or "Cmdline completion disabled",
			vim.log.levels.INFO
		)
	end):with_noremap():with_silent():with_desc("cmp: Toggle cmdline completion"),
}

-- NOTE: This function is special! Keymaps defined here are ONLY effective in buffers with LSP(s) attached
-- NOTE: Make sure to include `:with_buffer(buf)` to limit the scope of your mappings.
---@param buf number @The effective bufnr
mappings["lsp"] = function(buf)
	return {}
end

return mappings

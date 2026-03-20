local hl_tab = "TabDark"

local hl_rainbow = {
	"DefaultWhite",
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}
local hooks = require("ibl.hooks")

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "TabDark", { fg = "#464247" })
	vim.api.nvim_set_hl(0, "DefaultWhite", { fg = "#a6aab0" })
	vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E16B58" })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#FAC761" })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#85ADD6" })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#ACD1A8" })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C695C6" })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#5FB4B4" })
end)

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

-- vim.g.rainbow_delimiters = { highlight = hl }

return {
	indent = {
		tab_char = "»",
		highlight = hl_tab,
	},
	whitespace = {
		highlight = hl_tab,
		-- remove_blankline_trail = false,
	},
	scope = {
		-- char = "|",
		highlight = hl_rainbow,
	},
}

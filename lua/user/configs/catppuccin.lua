-- local ucolors = require("catppuccin.utils.colors")

return function()
	require("catppuccin").setup({
		color_overrides = {
			mocha = {
				text = "#dfe6f0",
				base = "#302e38",
			},
		},
	})
end

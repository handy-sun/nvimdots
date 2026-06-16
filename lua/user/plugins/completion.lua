local completion = {}

completion["folke/lazydev.nvim"] = {
	lazy = true,
	ft = "lua",
	config = require("user.configs.lazydev"),
}

return completion

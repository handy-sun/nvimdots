local editor = {}

editor["casey/tree-sitter-just"] = {
	branch = "main",
	lazy = true,
	event = "VeryLazy",
	config = require("user.configs.tree-sitter-just"),
}

editor["mizlan/iswap.nvim"] = {
	lazy = true,
	event = "VeryLazy",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = require("user.configs.iswap"),
}

return editor

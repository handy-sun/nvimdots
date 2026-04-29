local editor = {}

editor["casey/tree-sitter-just"] = {
	branch = "main",
	lazy = true,
	event = "VeryLazy",
	config = require("user.configs.tree-sitter-just"),
}

return editor

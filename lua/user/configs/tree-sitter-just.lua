return function()
	-- Register just parser with nvim-treesitter
	-- New nvim-treesitter (main branch) returns parsers as a plain table, not via get_parser_configs()
	local parsers = require("nvim-treesitter.parsers")
	parsers.just = {
		install_info = {
			url = "https://github.com/casey/tree-sitter-just",
			files = { "src/parser.c", "src/scanner.c" },
			branch = "main",
		},
	}

	-- Filetype detection for justfile/Justfile
	vim.filetype.add({
		extension = {
			just = "just",
		},
		filename = {
			["Justfile"] = "just",
			["justfile"] = "just",
			[".Justfile"] = "just",
			[".justfile"] = "just",
		},
	})
end

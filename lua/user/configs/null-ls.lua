local null_ls = require("null-ls")

local function system_exepath(bin)
	local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
	for _, dir in ipairs(vim.split(vim.env.PATH or "", ":", { plain = true, trimempty = true })) do
		local candidate = dir .. "/" .. bin
		if not vim.startswith(candidate, mason_bin) and vim.fn.executable(candidate) == 1 then
			return candidate
		end
	end
	return nil
end

local function formatter_args(formatter_name)
	local ok, args = pcall(require, "user.configs.formatters." .. formatter_name)
	if not ok then
		args = require("completion.formatters." .. formatter_name)
	end
	return args
end

local clang_format = system_exepath("clang-format")
local stylua = system_exepath("stylua")

return function(opts)
	opts.sources = vim.tbl_filter(function(source)
		return source.name ~= "clang_format"
	end, opts.sources or {})

	vim.list_extend(
		opts.sources,
		vim.tbl_filter(function(source)
			return source ~= nil
		end, {
			clang_format and null_ls.builtins.formatting.clang_format.with({
				command = clang_format,
				filetypes = { "c", "cpp", "objc", "objcpp", "cs", "cuda", "proto" },
				extra_args = formatter_args("clang_format"),
			}) or nil,
			stylua and null_ls.builtins.formatting.stylua.with({
				command = stylua,
			}) or nil,
		})
	)

	return opts
end

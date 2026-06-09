local base_opts = {
	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
}
local cpp_include = require("modules.utils.cpp_include")

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

local function switch_source_header(bufnr, client)
	local method_name = "textDocument/switchSourceHeader"
	if not client or not client:supports_method(method_name) then
		local fallback = cpp_include.find_source_header_fallback(bufnr, client)
		if fallback then
			vim.cmd.edit(vim.fn.fnameescape(fallback))
			return
		end

		vim.notify(
			("Method %s is not supported by any active server attached to buffer"):format(method_name),
			vim.log.levels.ERROR,
			{ title = "LSP Error!" }
		)
		return
	end

	local params = vim.lsp.util.make_text_document_params(bufnr)
	client:request(method_name, params, function(err, result)
		if err then
			error(tostring(err))
		end

		if result then
			vim.cmd.edit(vim.fn.fnameescape(vim.uri_to_fname(result)))
			return
		end

		local fallback = cpp_include.find_source_header_fallback(bufnr, client)
		if fallback then
			vim.cmd.edit(vim.fn.fnameescape(fallback))
			return
		end

		vim.notify("corresponding file cannot be determined")
	end, bufnr)
end

local function start_on_filetype(name, config, pattern)
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("UserSystemLsp" .. name, { clear = true }),
		pattern = pattern,
		callback = function(args)
			local root_dir = config.root_dir or vim.fs.root(args.buf, config.root_markers or { ".git" })
			if not root_dir and config.single_file_support ~= true then
				return
			end
			vim.lsp.start(
				vim.tbl_extend("force", config, {
					name = name,
					root_dir = root_dir,
				}),
				{ bufnr = args.buf }
			)
		end,
	})
end

local function nil_show_message_request_handler(err, params, ctx, config)
	if
		params
		and params.message
		and params.message:find("Fetching flake with inputs", 1, true)
		and params.actions
		and params.actions[1]
	then
		return params.actions[1]
	end

	return vim.lsp.handlers["window/showMessageRequest"](err, params, ctx, config)
end

local clangd = system_exepath("clangd")
if clangd then
	local clangd_config = {
		capabilities = vim.tbl_deep_extend("keep", { offsetEncoding = { "utf-16", "utf-8" } }, base_opts.capabilities),
		single_file_support = true,
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
		root_markers = {
			".clangd",
			".clang-tidy",
			".clang-format",
			"compile_commands.json",
			"compile_flags.txt",
			"Makefile",
			"makefile",
			"configure.ac",
			".git",
		},
		cmd = {
			clangd,
			"-j=9",
			"--enable-config",
			"--query-driver=" .. table.concat(
				vim.tbl_filter(function(path)
					return path ~= nil
				end, {
					system_exepath("clang++"),
					system_exepath("clang"),
					system_exepath("gcc"),
					system_exepath("g++"),
				}),
				","
			),
			"--all-scopes-completion",
			"--background-index",
			"--clang-tidy",
			"--completion-parse=auto",
			"--completion-style=bundled",
			"--function-arg-placeholders",
			"--header-insertion-decorators",
			"--header-insertion=iwyu",
			"--limit-references=1000",
			"--limit-results=300",
			"--pch-storage=memory",
		},
		on_attach = function(client, bufnr)
			vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
				switch_source_header(bufnr, client)
			end, { desc = "Switch between source/header" })
		end,
	}
	require("modules.utils").register_server("clangd", clangd_config)
	start_on_filetype("clangd", clangd_config, clangd_config.filetypes)
end

local lua_language_server = system_exepath("lua-language-server")
if lua_language_server then
	local lua_ls_config = vim.tbl_deep_extend("force", base_opts, require("completion.servers.lua_ls"), {
		cmd = { lua_language_server },
		filetypes = { "lua" },
		root_markers = {
			{ ".emmyrc.json", ".luarc.json", ".luarc.jsonc" },
			{ ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
			{ ".git" },
		},
	})
	require("modules.utils").register_server("lua_ls", lua_ls_config)
	start_on_filetype("lua_ls", lua_ls_config, lua_ls_config.filetypes)
end

local nil_ls = system_exepath("nil")
if nil_ls then
	local nil_config = {
		cmd = { nil_ls },
		capabilities = base_opts.capabilities,
		filetypes = { "nix" },
		root_markers = { "flake.nix", ".git" },
		handlers = {
			["window/showMessageRequest"] = nil_show_message_request_handler,
		},
	}
	require("modules.utils").register_server("nil_ls", nil_config)
	start_on_filetype("nil_ls", nil_config, nil_config.filetypes)
end

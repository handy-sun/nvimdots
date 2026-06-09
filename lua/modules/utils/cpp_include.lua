local M = {}

local source_extensions = { c = true, cc = true, cpp = true, cxx = true, m = true, mm = true }
local header_extensions = { h = true, hh = true, hpp = true, hxx = true }
local root_markers = {
	".clangd",
	".clang-tidy",
	".clang-format",
	"compile_commands.json",
	"compile_flags.txt",
	"GNUmakefile",
	"Makefile",
	"makefile",
	"configure.ac",
	".git",
}
local makefile_names = { "GNUmakefile", "Makefile", "makefile" }

local include_arg_flags = {
	["-I"] = true,
	["-isystem"] = true,
	["-iquote"] = true,
	["-idirafter"] = true,
	["--include-directory"] = true,
}

local include_value_vars = {
	CPATH = true,
	C_INCLUDE_PATH = true,
	CPLUS_INCLUDE_PATH = true,
	OBJC_INCLUDE_PATH = true,
}

local function normalize(path, base)
	if not path or path == "" then
		return nil
	end
	path = vim.fn.expand(path)
	if path == "" then
		return nil
	end
	if not vim.startswith(path, "/") then
		path = vim.fs.normalize(vim.fs.joinpath(base, path))
	else
		path = vim.fs.normalize(path)
	end
	return path
end

local function is_inside(path, parent)
	local relative = vim.fs.relpath(parent, path)
	return relative and not vim.startswith(relative, "..")
end

local function add_dir(dirs, seen, dir, base)
	local normalized = normalize(dir, base)
	if normalized and not seen[normalized] and vim.fn.isdirectory(normalized) == 1 then
		seen[normalized] = true
		table.insert(dirs, normalized)
	end
end

local function strip_comment(line)
	local escaped = false
	for idx = 1, #line do
		local char = line:sub(idx, idx)
		if char == "#" and not escaped then
			return vim.trim(line:sub(1, idx - 1))
		end
		escaped = char == "\\" and not escaped
	end
	return vim.trim(line)
end

local function read_make_lines(makefile)
	local raw = vim.fn.readfile(makefile)
	local lines = {}
	local current = ""

	for _, line in ipairs(raw) do
		line = strip_comment(line)
		if line:sub(-1) == "\\" then
			current = current .. line:sub(1, -2) .. " "
		else
			table.insert(lines, current .. line)
			current = ""
		end
	end

	if current ~= "" then
		table.insert(lines, current)
	end

	return lines
end

local function split_words(value)
	return vim.fn.split(value)
end

local function parse_assignments(lines)
	local vars = {
		CURDIR = vim.fn.getcwd(),
		PWD = vim.fn.getcwd(),
	}

	for _, line in ipairs(lines) do
		local name, op, value = line:match("^%s*([%w_.%-]+)%s*([:+?]?=)%s*(.*)$")
		if name then
			if op == "+=" then
				vars[name] = vim.trim((vars[name] or "") .. " " .. value)
			elseif op == "?=" then
				vars[name] = vars[name] or value
			else
				vars[name] = value
			end
		end
	end

	return vars
end

local function expand_vars(value, vars, depth)
	if not value or value == "" then
		return value
	end
	if depth > 8 then
		return value
	end

	local expanded = value:gsub("%$%(([%w_.%-]+)%)", function(name)
		return expand_vars(vars[name] or vim.env[name] or "", vars, depth + 1)
	end)
	expanded = expanded:gsub("%${([%w_.%-]+)}", function(name)
		return expand_vars(vars[name] or vim.env[name] or "", vars, depth + 1)
	end)

	return expanded
end

local function add_include_token(token, dirs, seen, base)
	if vim.startswith(token, "-I") and #token > 2 then
		add_dir(dirs, seen, token:sub(3), base)
		return true
	end

	local eq_flag, eq_value = token:match("^(%-%-include%-directory)=(.+)$")
	if eq_flag and eq_value then
		add_dir(dirs, seen, eq_value, base)
		return true
	end

	return false
end

local function parse_include_dirs_from_makefile(makefile)
	local base = vim.fs.dirname(makefile)
	local lines = read_make_lines(makefile)
	local vars = parse_assignments(lines)

	vars.CURDIR = base
	vars.PWD = base

	local dirs = {}
	local seen = {}

	for name, value in pairs(vars) do
		if include_value_vars[name] then
			for dir in vim.gsplit(expand_vars(value, vars, 0), ":", { plain = true, trimempty = true }) do
				add_dir(dirs, seen, dir, base)
			end
		end
	end

	for _, line in ipairs(lines) do
		local words = split_words(expand_vars(line, vars, 0))
		local idx = 1
		while idx <= #words do
			local word = words[idx]
			if include_arg_flags[word] then
				add_dir(dirs, seen, words[idx + 1], base)
				idx = idx + 2
			else
				add_include_token(word, dirs, seen, base)
				idx = idx + 1
			end
		end
	end

	return dirs
end

local function find_root(bufnr, client)
	local marker_root = vim.fs.root(bufnr, root_markers)
	if client and client.config and client.config.root_dir then
		local client_root = client.config.root_dir
		if marker_root and is_inside(marker_root, client_root) then
			return marker_root
		end
		return client_root
	end
	return marker_root
end

function M.makefile_include_dirs(root)
	if not root then
		return {}
	end

	local dirs = {}
	local seen = {}
	for _, makefile in ipairs(vim.fs.find(makefile_names, { path = root, upward = false, type = "file", limit = 3 })) do
		for _, dir in ipairs(parse_include_dirs_from_makefile(makefile)) do
			add_dir(dirs, seen, dir, root)
		end
	end

	return dirs
end

function M.makefile_fallback_flags(root)
	local flags = {}
	for _, dir in ipairs(M.makefile_include_dirs(root)) do
		table.insert(flags, "-I" .. dir)
	end
	return flags
end

local function file_exists(path)
	return path and vim.fn.filereadable(path) == 1
end

function M.find_include(bufnr, name)
	if not name or name == "" then
		return nil
	end

	name = name:gsub('^[<"]', ""):gsub('[>"]$', "")
	local current = vim.api.nvim_buf_get_name(bufnr)
	local root = find_root(bufnr)
	local current_dir = vim.fs.dirname(current)

	for _, base in ipairs({ current_dir }) do
		local candidate = normalize(name, base)
		if file_exists(candidate) then
			return candidate
		end
	end

	for _, dir in ipairs(M.makefile_include_dirs(root)) do
		local candidate = normalize(name, dir)
		if file_exists(candidate) then
			return candidate
		end
	end

	if root then
		local root_candidate = normalize(name, root)
		if file_exists(root_candidate) then
			return root_candidate
		end
	end

	if root then
		local leaf = vim.fs.basename(name)
		local matches = vim.fs.find(function(candidate_name, path)
			return candidate_name == leaf and vim.endswith(vim.fs.joinpath(path, candidate_name), name)
		end, {
			path = root,
			type = "file",
			limit = 1,
		})
		return matches[1]
	end

	return nil
end

function M.includeexpr(fname)
	return M.find_include(0, fname) or fname
end

function M.find_source_header_fallback(bufnr, client)
	local current = vim.api.nvim_buf_get_name(bufnr)
	local basename = vim.fn.fnamemodify(current, ":t:r")
	local ext = vim.fn.fnamemodify(current, ":e")
	local targets = source_extensions[ext] and header_extensions or source_extensions
	local root = find_root(bufnr, client)

	if not root then
		return nil
	end

	local search_roots = { vim.fs.dirname(current) }
	for _, include_dir in ipairs(M.makefile_include_dirs(root)) do
		table.insert(search_roots, include_dir)
	end
	table.insert(search_roots, root)

	local seen = {}
	for _, search_root in ipairs(search_roots) do
		if search_root and not seen[search_root] then
			seen[search_root] = true
			local matches = vim.fs.find(function(name, path)
				local candidate_ext = name:match("%.([^.]+)$")
				return vim.fn.fnamemodify(name, ":r") == basename
					and targets[candidate_ext] == true
					and vim.fs.joinpath(path, name) ~= current
			end, {
				path = search_root,
				type = "file",
				limit = 1,
			})

			if matches[1] then
				return matches[1]
			end
		end
	end

	return nil
end

function M.setup_buffer(bufnr)
	bufnr = bufnr or 0
	if vim.b[bufnr].cpp_include_configured then
		return
	end
	vim.b[bufnr].cpp_include_configured = true

	local root = find_root(bufnr)
	local dirs = M.makefile_include_dirs(root)

	if #dirs > 0 then
		vim.bo[bufnr].path = vim.bo[bufnr].path .. "," .. table.concat(vim.tbl_map(vim.fn.fnameescape, dirs), ",")
	end

	vim.bo[bufnr].includeexpr = "v:lua.require'modules.utils.cpp_include'.includeexpr(v:fname)"
	vim.bo[bufnr].suffixesadd = vim.bo[bufnr].suffixesadd .. ",.h,.hh,.hpp,.hxx"
end

return M

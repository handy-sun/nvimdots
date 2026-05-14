--- Bootstrap module for first-time plugin installation.
--- Equivalent to `vim +PlugInstall +qall` from the vim-plug era.
---
--- Usage:
---   nvim --headless -c "lua require('user.bootstrap')()"
---
--- This will:
---   1. Clone lazy.nvim if not present
---   2. Load plugin specs (upstream + user overrides)
---   3. Install all missing plugins via lazy.nvim sync
---   4. Quit Neovim automatically when done
local fn, api = vim.fn, vim.api
local global = require("core.global")
local settings = require("core.settings")

local data_dir = global.data_dir
local lazy_path = data_dir .. "lazy/lazy.nvim"
local vim_path = global.vim_path
local modules_dir = vim_path .. "/lua/modules"
local user_config_dir = vim_path .. "/lua/user"

--- Aggregate plugin specs from both upstream and user plugin directories.
---@return table[] lazy.nvim spec list
local function load_plugins()
	local plugins = {}

	-- Extend package.path so `require` can resolve config modules
	package.path = package.path
		.. string.format(
			";%s;%s;%s",
			modules_dir .. "/configs/?.lua",
			modules_dir .. "/configs/?/init.lua",
			user_config_dir .. "/?.lua"
		)

	-- Collect plugin declaration files from both directories
	local upstream = vim.split(fn.glob(modules_dir .. "/plugins/*.lua"), "\n")
	local user = vim.split(fn.glob(user_config_dir .. "/plugins/*.lua"), "\n", { trimempty = true })
	vim.list_extend(upstream, user)

	for _, f in ipairs(upstream) do
		-- Derive the require-able module name from the file path
		local mod = f:find(modules_dir) and f:sub(#modules_dir - 6, -1) or f:sub(#user_config_dir - 3, -1)
		local ok, mods = pcall(require, mod:sub(0, #mod - 4))
		if ok and type(mods) == "table" then
			for name, conf in pairs(mods) do
				plugins[#plugins + 1] = vim.tbl_extend("force", { name }, conf)
			end
		end
	end

	-- Append disabled plugin entries
	for _, name in ipairs(settings.disabled_plugins) do
		plugins[#plugins + 1] = { name, enabled = false }
	end

	return plugins
end

--- Main bootstrap entry point.
local function bootstrap()
	-- Clone lazy.nvim if not present
	if not vim.uv.fs_stat(lazy_path) then
		local lazy_repo = settings.use_ssh and "git@github.com:folke/lazy.nvim.git "
			or "https://github.com/folke/lazy.nvim.git "
		api.nvim_command("!git clone --filter=blob:none --branch=stable " .. lazy_repo .. lazy_path)
	end

	local plugins = load_plugins()

	-- Determine git URL format
	local clone_prefix = settings.use_ssh and "git@github.com:%s.git" or "https://github.com/%s.git"

	-- Register LazySync callback to quit after installation completes
	api.nvim_create_autocmd("User", {
		pattern = "LazySync",
		once = true,
		callback = function()
			vim.cmd("qall!")
		end,
	})

	vim.opt.rtp:prepend(lazy_path)
	require("lazy").setup(plugins, {
		root = data_dir .. "lazy",
		git = {
			timeout = 300,
			url_format = clone_prefix,
		},
		install = {
			missing = true,
			colorscheme = { settings.colorscheme },
		},
		-- Minimal UI — we're running headless anyway
		ui = { border = "rounded" },
		performance = {
			reset_packpath = true,
			rtp = {
				reset = true,
				paths = {},
				disabled_plugins = {
					"editorconfig",
					"spellfile",
					"matchit",
					"matchparen",
					"tohtml",
					"gzip",
					"tarPlugin",
					"zipPlugin",
				},
			},
		},
	})

	-- Trigger sync (install + update + clean)
	vim.cmd("LazySync")
end

return bootstrap

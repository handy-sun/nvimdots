--- Bootstrap module for first-time plugin installation.
--- Equivalent to `vim +PlugInstall +qall` from the vim-plug era.
---
--- Usage:
---   nvim --headless -c "lua require('user.bootstrap')()"
---
--- This will:
---   1. Sync all lazy.nvim plugins (install missing, update, clean)
---   2. Quit Neovim automatically when done
---
--- NOTE: This module runs via `-c` AFTER init.lua has already set up lazy.nvim.
--- Do NOT call `require("lazy").setup()" again — it triggers
--- "Re-sourcing your config is not supported" and prevents sync from working.

local DEFAULT_TIMEOUT = 900 -- minimum fallback (seconds)
local LATENCY_MULTIPLIER = 10 -- each plugin ~= N × single-request latency

--- Estimate a reasonable timeout based on network latency and plugin count.
--- Measures GitHub responsiveness via `git ls-remote`, then scales by
--- plugin count. Falls back to DEFAULT_TIMEOUT if the probe fails.
local function estimate_timeout()
	local ok, lazy = pcall(require, "lazy")
	if not ok then
		print(("[bootstrap] lazy.nvim not available, using default timeout %ds"):format(DEFAULT_TIMEOUT))
		return DEFAULT_TIMEOUT
	end

	local plugin_count = #lazy.plugins()

	-- Probe GitHub with a lightweight `git ls-remote` to gauge network speed
	local start = vim.uv.hrtime()
	local result = vim.system(
		{ "git", "ls-remote", "--heads", "https://github.com/folke/lazy.nvim" },
		{ timeout = 15000 }
	)
		:wait()
	local latency = (vim.uv.hrtime() - start) / 1e9

	if result.code ~= 0 then
		print(("[bootstrap] network probe failed, using default timeout %ds"):format(DEFAULT_TIMEOUT))
		return DEFAULT_TIMEOUT
	end

	-- A git clone involves multiple round-trips + potential build steps,
	-- so each plugin is estimated at LATENCY_MULTIPLIER × single-request latency.
	local estimated = math.ceil(plugin_count * latency * LATENCY_MULTIPLIER)
	local timeout = math.max(DEFAULT_TIMEOUT, estimated)

	print(
		("[bootstrap] latency=%.1fs  plugins=%d  estimated=%ds  timeout=%ds"):format(
			latency,
			plugin_count,
			estimated,
			timeout
		)
	)

	return timeout
end

local function bootstrap()
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazySync",
		once = true,
		callback = function()
			vim.cmd("qall!")
		end,
	})

	-- "LazySync" is NOT an editor command — lazy.nvim uses `:Lazy sync`
	-- (sub-command syntax). Call the Lua API instead.
	require("lazy").sync()

	-- Dynamic timeout failsafe: force quit if callbacks never fire
	local timeout = estimate_timeout()
	local timer = vim.uv.new_timer()
	timer:start(timeout * 1000, 0, function()
		timer:stop()
		timer:close()
		vim.cmd("qall!")
	end)
end

return bootstrap

-- Returning a function gives full control over cmp setup.
-- We add lazydev as an extra source and wire up cmdline toggle support.
return function(opts)
	table.insert(opts.sources, { name = "lazydev", group_index = 0 })

	-- 首次进入时应用配置
	vim.api.nvim_create_autocmd("CmdlineEnter", {
		once = true,
		callback = function()
			local toggle = require("user.cmdline_toggle")
			require("cmp").setup.cmdline(":", toggle.get_config())
		end,
	})

	return opts
end

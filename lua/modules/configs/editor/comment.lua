return function()
	local ts_pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
	local ft = require("Comment.ft")

	ft.set("caddy", "#%s")
	ft.set("config", "#%s")
	ft.set("just", "#%s")
	ft.set("nasm", ";%s")
	ft.set("nginx", "#%s")
	ft.set("ssh_config", "#%s")
	ft.set("sshconfig", "#%s")
	ft.set("systemd", "#%s")

	local function fallback_commentstring(ctx)
		local cstr = ft.get(vim.bo.filetype, ctx.ctype)
		if cstr then
			return cstr
		end

		return vim.bo.commentstring
	end

	require("modules.utils").load_plugin("Comment", {
		ignore = "^$",
		pre_hook = function(ctx)
			local ok, cstr = pcall(ts_pre_hook, ctx)
			if ok and cstr then
				return cstr
			end

			return fallback_commentstring(ctx)
		end,
	})
end

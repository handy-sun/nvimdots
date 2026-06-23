-- ponytail: 独立状态模块，避免循环依赖
local M = {}

M.enabled = true

function M.get_config()
	return {
		enabled = function()
			if not M.enabled then
				return false
			end
			local ok, parsed = pcall(vim.api.nvim_parse_cmd, vim.fn.getcmdline(), {})
			return not (ok and parsed.bang and parsed.cmd == "edit")
		end,
		mapping = require("cmp").mapping.preset.cmdline(),
		sources = {
			{ name = "path" },
			{ name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
		},
	}
end

return M

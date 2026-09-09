-- ponytail: 独立状态模块，避免循环依赖
local M = {}

M.enabled = true

-- 由 user/configs/blink.lua 的 cmdline.sources 覆盖在每次补全触发时咨询:
-- 开关关闭或正在补全 `edit!`(其补全会把 ! 吃进路径)时返回 true。
function M.is_disabled()
	if not M.enabled then
		return true
	end
	if vim.fn.getcmdtype() ~= ":" then
		return false
	end
	local ok, parsed = pcall(vim.api.nvim_parse_cmd, vim.fn.getcmdline(), {})
	return ok and parsed.bang and parsed.cmd == "edit"
end

return M

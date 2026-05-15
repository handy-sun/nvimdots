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

local stylua = system_exepath("stylua")

return {
	sources = vim.tbl_filter(function(source)
		return source ~= nil
	end, {
		stylua and null_ls.builtins.formatting.stylua.with({
			command = stylua,
		}) or nil,
	}),
}

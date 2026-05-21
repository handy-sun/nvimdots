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

return function()
	local rust_analyzer = system_exepath("rust-analyzer")

	vim.g.rustaceanvim = vim.tbl_deep_extend("force", vim.g.rustaceanvim or {}, {
		server = {
			cmd = function()
				if not rust_analyzer then
					error("System rust-analyzer not found outside Mason", 0)
				end
				return { rust_analyzer }
			end,
		},
	})
end

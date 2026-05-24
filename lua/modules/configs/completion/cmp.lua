return function()
	local icons = {
		kind = require("modules.utils.icons").get("kind"),
		type = require("modules.utils.icons").get("type"),
		cmp = require("modules.utils.icons").get("cmp"),
	}

	local border = function(hl)
		return {
			{ "┌", hl },
			{ "─", hl },
			{ "┐", hl },
			{ "│", hl },
			{ "┘", hl },
			{ "─", hl },
			{ "└", hl },
			{ "│", hl },
		}
	end

	local compare = require("cmp.config.compare")
	compare.lsp_scores = function(entry1, entry2)
		local diff
		if entry1.completion_item.score and entry2.completion_item.score then
			diff = (entry2.completion_item.score * entry2.score) - (entry1.completion_item.score * entry1.score)
		else
			diff = entry2.score - entry1.score
		end
		return (diff < 0)
	end

	local comparators = vim.list_extend(require("core.settings").use_copilot and {
		require("copilot_cmp.comparators").prioritize,
		require("copilot_cmp.comparators").score,
	} or {}, {
		compare.offset, -- Items closer to cursor will have lower priority
		compare.exact,
		-- compare.scopes,
		compare.lsp_scores,
		compare.sort_text,
		compare.score,
		compare.recently_used,
		-- compare.locality, -- Items closer to cursor will have higher priority, conflicts with `offset`
		require("cmp-under-comparator").under,
		compare.kind,
		compare.length,
		compare.order,
	})

	local cmp = require("cmp")
	local disabled_bang_cmds = {
		edit = true,
	}

	local count_unescaped = function(text, target)
		local count = 0
		local escaped = false

		for i = 1, #text do
			local char = text:sub(i, i)
			if escaped then
				escaped = false
			elseif char == "\\" then
				escaped = true
			elseif char == target then
				count = count + 1
			end
		end

		return count
	end

	local is_disabled_bang_cmdline = function()
		if vim.fn.getcmdtype() ~= ":" then
			return false
		end

		local ok, parsed = pcall(vim.api.nvim_parse_cmd, vim.fn.getcmdline(), {})
		return ok and parsed.bang and disabled_bang_cmds[parsed.cmd] == true
	end

	local is_substitute_replace_cmdline = function()
		if vim.fn.getcmdtype() ~= ":" then
			return false
		end

		local cmdline = vim.fn.getcmdline():sub(1, vim.fn.getcmdpos() - 1)
		local ok, parsed = pcall(vim.api.nvim_parse_cmd, cmdline, {})
		if not ok or parsed.cmd ~= "substitute" then
			return false
		end

		-- `:s` only needs completion before the second delimiter. Afterwards we are editing the replacement text.
		local _, delimiter_pos, _, delimiter = cmdline:find("([%a]+)([^%w%s])")
		if not delimiter_pos or delimiter == "\\" then
			return false
		end

		return count_unescaped(cmdline:sub(delimiter_pos), delimiter) == 2
	end

	local is_disabled_cmdline_completion = function()
		return is_disabled_bang_cmdline() or is_substitute_replace_cmdline()
	end

	require("modules.utils").load_plugin("cmp", {
		enabled = function()
			local disabled = false
			disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
			disabled = disabled or (vim.fn.reg_recording() ~= "")
			disabled = disabled or (vim.fn.reg_executing() ~= "")
			disabled = disabled or is_disabled_cmdline_completion()
			return not disabled
		end,
		preselect = cmp.PreselectMode.None,
		window = {
			completion = {
				border = border("PmenuBorder"),
				winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:PmenuSel",
				scrollbar = false,
			},
			documentation = {
				border = border("CmpDocBorder"),
				winhighlight = "Normal:CmpDoc",
			},
		},
		sorting = {
			priority_weight = 2,
			comparators = comparators,
		},
		formatting = {
			fields = { "abbr", "kind", "menu" },
			format = function(entry, vim_item)
				local lspkind_icons = vim.tbl_deep_extend("force", icons.kind, icons.type, icons.cmp)
				-- load lspkind icons
				vim_item.kind =
					string.format(" %s  %s", lspkind_icons[vim_item.kind] or icons.cmp.undefined, vim_item.kind or "")

				-- set up labels for completion entries
				vim_item.menu = setmetatable({
					copilot = "[CPLT]",
					buffer = "[BUF]",
					orgmode = "[ORG]",
					nvim_lsp = "[LSP]",
					path = "[PATH]",
					luasnip = "[SNIP]",
				}, {
					__index = function()
						return "[BTN]" -- builtin/unknown source names
					end,
				})[entry.source.name]

				-- cut down long results
				local label = vim_item.abbr
				local truncated_label = vim.fn.strcharpart(label, 0, 80)
				if truncated_label ~= label then
					vim_item.abbr = truncated_label .. "..."
				end

				-- deduplicate results from nvim_lsp
				if entry.source.name == "nvim_lsp" then
					vim_item.dup = 0
				end

				return vim_item
			end,
		},
		matching = {
			disallow_partial_fuzzy_matching = false,
		},
		performance = {
			async_budget = 1,
			max_view_entries = 120,
		},
		-- You can set mappings if you want
		mapping = cmp.mapping.preset.insert({
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-w>"] = cmp.mapping.abort(),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				elseif require("luasnip").expand_or_locally_jumpable() then
					require("luasnip").expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
				elseif require("luasnip").jumpable(-1) then
					require("luasnip").jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<CR>"] = cmp.mapping({
				i = function(fallback)
					if cmp.visible() and cmp.get_active_entry() then
						cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })
					else
						fallback()
					end
				end,
				s = cmp.mapping.confirm({ select = true }),
				c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
			}),
		}),
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		-- You should specify your *installed* sources.
		sources = {
			{ name = "nvim_lsp", max_item_count = 350 },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "orgmode" },
			{
				name = "buffer",
				option = {
					get_bufnrs = function()
						return vim.api.nvim_buf_line_count(0) < 15000 and vim.api.nvim_list_bufs() or {}
					end,
				},
			},
			{ name = "copilot" },
		},
		experimental = {
			ghost_text = {
				hl_group = "Whitespace",
			},
		},
	})

	vim.api.nvim_create_autocmd("CmdlineChanged", {
		group = vim.api.nvim_create_augroup("_cmp_close_disabled_cmdline", { clear = true }),
		pattern = ":",
		callback = function()
			if is_disabled_cmdline_completion() then
				cmp.close()
			end
		end,
	})

	for _, cmdtype in ipairs({ "/", "?" }) do
		cmp.setup.cmdline(cmdtype, {
			completion = { autocomplete = false },
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})
	end

	cmp.setup.cmdline(":", {
		enabled = function()
			return not is_disabled_cmdline_completion()
		end,
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{
				name = "cmdline",
				option = {
					ignore_cmds = { "Man", "!" },
				},
			},
		}),
	})
end

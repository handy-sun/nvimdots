-- 在上游 blink.cmp 默认配置之上恢复合并前(nvim-cmp 时代)的 cmdline 手感。
-- 返回 function 而非 table:table 会经 tbl_recursive_merge 合并,list 字段是追加
-- 而不是替换(keymap 命令表、menu.draw.columns 都会翻倍),function 直接改写 opts。

-- Whether an item is a directory. Only the path source is trusted here: it tags
-- directories with kind=Folder and data.type=="directory" (cmdline completes via
-- cmdline+path, and the cmdline source is dropped for path completion below).
local function is_directory_item(item)
	if not item then
		return false
	end
	if item.data and item.data.type == "directory" then
		return true
	end
	local ok, types = pcall(require, "blink.cmp.types")
	return ok and item.kind == types.CompletionItemKind.Folder
end

return function(opts)
	-- nvim-cmp 时代:菜单打开无预选,首次 <C-n>/<Tab> 选中第 1 项并插入
	-- (SelectBehavior.Insert);上游默认 preselect=true 导致首次按键跳到第 2 项。
	opts.cmdline.completion.list.selection = { preselect = false, auto_insert = true }

	opts.cmdline.keymap = {
		preset = "inherit",
		-- <CR> on a selected directory means "descend into it": accept the item
		-- (appending the trailing /), then immediately re-trigger completion to list
		-- its contents, so you can keep drilling down. Everything else keeps the
		-- nvim-cmp era behavior and executes the command as typed: no selection, a
		-- file item, or a non-path completion.
		-- To open the directory itself, hit <CR> once more -- the freshly shown menu
		-- has no preselected item.
		["<CR>"] = {
			function(cmp)
				if not cmp.is_menu_visible() or not is_directory_item(cmp.get_selected_item()) then
					return false
				end
				return cmp.accept({
					callback = function()
						cmp.show()
					end,
				})
			end,
			"fallback",
		},
		-- 菜单可见时下一项/上一项,隐藏时手动唤出(对应 preset.cmdline 的 select/complete 二合一)
		["<Tab>"] = { "select_next", "show", "fallback" },
		["<S-Tab>"] = { "select_prev", "show", "fallback" },
		["<C-space>"] = { "show", "fallback" },
		["<C-y>"] = { "select_and_accept", "fallback" },
		["<C-e>"] = { "cancel", "fallback" },
		-- 以下恢复原生行为:blink 的 cmdline preset 把方向键劫持为候选切换,
		-- <C-w> 在菜单打开时会先关菜单而不是删单词
		["<Right>"] = false,
		["<Left>"] = false,
		["<C-w>"] = false,
	}

	-- blink 内置 cmdline 源把所有补全项硬编码为 kind "Property"
	-- (sources/cmdline/init.lua),与 path 源同时补全文件时会多出带 Property
	-- 标签的重复项。路径/文件补全只留 path 源(有正确的 Folder/File 类型),
	-- cmdline 源在补全路径时丢弃其全部条目,命令、选项等补全不受影响。
	opts.sources.providers.cmdline = {
		transform_items = function(_, items)
			local ok, utils = pcall(require, "blink.cmp.sources.cmdline.utils")
			if not ok then
				return items
			end
			local ctype = utils.get_completion_type("cmdline")
			if utils.is_path_completion(ctype, vim.fn.getcmdline()) then
				return {}
			end
			return items
		end,
	}

	-- Keep hidden entries available for explicit path completion, such as `.ca`.
	-- The path prefix still filters the list down to matching entries.
	opts.sources.providers.path = vim.tbl_deep_extend("force", opts.sources.providers.path or {}, {
		opts = { show_hidden_files_by_default = true },
	})

	-- 接回 <leader>tc 开关(user.cmdline_toggle)和 edit! 禁补全逻辑,
	-- sources 是每次触发时调用的函数,改状态立即生效,无需重新 setup
	local upstream_sources = opts.cmdline.sources
	opts.cmdline.sources = function()
		if require("user.cmdline_toggle").is_disabled() then
			return {}
		end
		return upstream_sources()
	end

	-- 剩余 cmdline 源条目(命令/选项等)的 kind 文字一律是误导性的 "Property",
	-- 去掉 kind 文字列只留图标
	opts.cmdline.completion.menu.draw.columns = {
		{ "label", "label_description", gap = 1 },
		{ "kind_icon" },
		{ "source_name" },
	}

	return opts
end

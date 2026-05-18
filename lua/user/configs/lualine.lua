local icons = require("modules.utils.icons")

local function cwd_section_color()
	local theme = require("lualine.utils.loader").load_theme(vim.g.colors_name) or require("lualine.themes.auto")
	local normal = theme.normal or {}
	local cwd_section = normal.y or normal.b or {}

	return {
		fg = cwd_section.fg,
		bg = cwd_section.bg,
		gui = "bold",
	}
end

local function file_progress()
	local cursorline = vim.fn.line(".")
	local filelines = vim.fn.line("$")

	if cursorline == 1 then
		return "Top"
	elseif cursorline == filelines then
		return "Bot"
	end

	return string.format("%2d%%%%", math.floor(cursorline / filelines * 100))
end

local custom = {
	sep = {
		function()
			return "|"
		end,
		padding = { left = 1 },
	},

	shift_width = {
		function()
			return "󰘶 " .. vim.bo.shiftwidth
		end,
		padding = 1,
	},

	expand_flag = {
		function()
			if vim.bo.expandtab == 1 then
				return "•"
			else
				return "»"
			end
		end,
		padding = 0,
	},

	file_location = {
		function()
			local cursorline = vim.fn.line(".")
			local virtual_col = vim.fn.virtcol(".")
			local real_col = vim.fn.col(".")
			local filelines = vim.fn.line("$")

			if real_col == virtual_col then
				return string.format("%3d/%d,%2d", cursorline, filelines, real_col)
			else
				return string.format("%3d/%d,%2d-%-2d", cursorline, filelines, real_col, virtual_col)
			end
		end,
	},

	file_progress = {
		file_progress,
		color = cwd_section_color,
		padding = { left = 1, right = 1 },
	},

	watch_icon = {
		function()
			return icons.get("misc", true).Watch
		end,
		padding = { left = 1 },
	},
}

local BLUE_END = "#79a0ee"

local function custom_theme()
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("LualineColorScheme", { clear = true }),
		pattern = "*",
		callback = function()
			require("lualine").setup({ options = { theme = custom_theme() } })
		end,
	})

	local theme = require("lualine.utils.loader").load_theme(vim.g.colors_name) or require("lualine.themes.auto")
	local colors = require("modules.utils").get_palette()
	local default_normal_bg = theme.normal and theme.normal.a and theme.normal.a.bg or colors.green
	local mode_bgs = {
		normal = BLUE_END,
		insert = default_normal_bg,
	}

	for mode, bg in pairs(mode_bgs) do
		theme[mode] = theme[mode] or vim.deepcopy(theme.normal or {})
		theme[mode].a = vim.tbl_extend("force", vim.deepcopy(theme[mode].a or {}), { bg = bg, gui = "bold" })
	end

	return theme
end

return {
	options = {
		theme = custom_theme(),
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_b = function(defaults)
			return {
				{
					"filename",
					file_status = false,
					-- Display new file status (new file means no write after created)
					newfile_status = false,
					-- 0: Just the filename 1: Relative path 2: Absolute path 3: Absolute path, with tilde as the home directory
					-- 4: Filename and parent dir, with tilde as the home directory
					path = 1,
					shorting_target = 30,
				},
				defaults[1], -- { filetype, ... }
				defaults[2], -- components.file_status
				defaults[3], -- { conditionals.has_git() and conditionals.has_comp_before() }
			}
		end,

		lualine_x = function(defaults)
			return {
				defaults[1], -- components.chat_progress
				defaults[2], -- { "encoding", show_bomb = true, fmt = string.upper, padding = { left = 1 }, cond = conditionals.has_enough_room, }
				defaults[3], -- { "fileformat", ... LF,CRLF,CR ... }
				custom.sep,
				custom.shift_width,
				custom.expand_flag,
				defaults[4], -- components.tabwidth(tabstop)
			}
		end,

		lualine_z = function()
			return {
				custom.file_location,
				custom.file_progress,
			}
		end,
	},
}
-- end

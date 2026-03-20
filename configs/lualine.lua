local icons = require("modules.utils.icons")

local custom = {
	sep = {
		function()
			return "|"
		end,
		padding = { left = 1 }
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
			local position

			if cursorline == 1 then
				position = "Top"
			elseif cursorline == filelines then
				position = "Bot"
			else
				position = string.format("%2d%%%%", math.floor(cursorline / filelines * 100))
			end

			if real_col == virtual_col then
				return string.format("%3d/%d,%2d %s", cursorline, filelines, real_col, position)
			else
				return string.format("%3d/%d,%2d-%-2d %s", cursorline, filelines, real_col, virtual_col, position)
			end
		end,
	},

	watch_icon = {
		function ()
			return icons.get('misc', true).Watch
		end,
		padding = { left = 1 }
	},
}

return {
	sections = {
		lualine_b = function(defaults)
			return {
				{
					'filename',
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
				custom.watch_icon,
				{
					'datetime',
					style = '%H:%M',
					padding = { right = 1 },

				},
			}
		end,
	},
}
-- end


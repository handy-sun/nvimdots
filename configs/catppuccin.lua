local ucolors = require("catppuccin.utils.colors")

return function()
	require("catppuccin").setup({
		color_overrides = {
			all = {
				-- text = "#d5e2ee",
				-- base = "#282c34",
			},
			mocha = {
				text = "#dfe6f0",
				base = "#302e38",
			},
			-- light
			latte = {
				-- base = "#293334",
				-- mantle = "#242424",
				-- crust = "#474747",
			},
			macchiato = {
				-- base = "#28282a",
				-- crust = "#474747",
			}
		},

		highlight_overrides = {
			-- all = function(colors)
			-- 	return {
			-- 		NvimTreeNormal = { fg = colors.none, bg = "#1f1f1f" },
					-- CmpBorder = { fg = "#3E4145" },
			-- 	}
			-- end,
		-- 	latte = function(latte)
		-- 		return {
		-- 			Normal = { fg = ucolors.darken(latte.base, 0.7, latte.mantle) },
		-- 		}
		-- 	end,
		-- 	frappe = function(frappe)
		-- 		return {
		-- 			["@comment"] = { fg = frappe.surface2, style = { "italic" } },
		-- 			Normal = { bg = "#2B3039" },
		-- 		}
		-- 	end,
		-- 	macchiato = function(macchiato)
		-- 		return {
		-- 			LineNr = { fg = macchiato.overlay1 },
		-- 		}
		-- 	end,
		-- 	mocha = function(mocha)
		-- 		return {
		-- 			Comment = { fg = mocha.flamingo },
		-- 		}
		-- 	end,
		},
	})
end

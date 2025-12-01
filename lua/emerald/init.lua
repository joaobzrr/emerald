local color = require("emerald.color")

local M = { config = {} }

local function generate_shades(base_color, count, factor, mode, prefix)
	local shades = {}
	local fn = mode == "lighten" and base_color.lightened or base_color.darkened
	for i = 1, count do
		shades[prefix .. i] = fn(base_color, i * factor)
	end
	return shades
end

local function make_colors(base)
	local palette = {}
	for k, v in pairs(base) do
		palette[k] = color.new(v)
	end

	return vim.tbl_extend(
		"keep",
		palette,
		generate_shades(palette.fg, 5, 16, "darken", "fg"),
		generate_shades(palette.bg, 5, 2, "lighten", "bg"),
		generate_shades(color.new("#000000"), 10, 10, "lighten", "gray")
	)
end

function M.get_config()
	return M.config
end

function M.set_colorset(colorset)
	M.setup({ colorset = colorset })
    vim.cmd.colorscheme('emerald')
end

function M.setup(config)
	if config ~= nil and type(config) ~= "table" then
		error("setup expectes a table or nil")
	end

	config = config or {}
	config.colorset = config.colorset or "lime_whisper"

	M.config = config

	local colorset = require("emerald.colorsets." .. config.colorset)
	local colors = make_colors(colorset)

	local highlights = {
		Normal = { fg = colors.fg, bg = colors.bg },
		Identifier = { fg = colors.fg },
		Keyword = { fg = colors.primary },
		Statement = { fg = colors.primary },
		Function = { fg = colors.accent },
		Type = { fg = colors.secondary },
		Operator = { fg = colors.fg },
		String = { fg = colors.emphasis },
		Special = { fg = colors.emphasis },
		Constant = { fg = colors.highlight },
		PreProc = { fg = colors.info },
		Comment = { fg = colors.muted },
		StatusLine = { fg = colors.fg, bg = colors.bg5 },
		StatusLineNC = { fg = colors.fg2, bg = colors.gray3 },
	}

	for group, opts in pairs(highlights) do
		for k, v in pairs(opts) do
			if type(v) == "table" and v.hex then
				opts[k] = v.hex
			end
		end
		vim.api.nvim_set_hl(0, group, opts)
	end
end

return M

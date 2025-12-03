local color = require("emerald.color")

local M = { config = {} }

function M.generate_shades(c1, c2, steps, prefix)
    local t_min = 0.05
    local t_max = 0.95
    local shades = {}
    for i = 1, steps do
        local t = t_min + ((i - 1) / (steps - 1)) * (t_max - t_min)
        shades[prefix .. i] = color.interpolate(c1, c2, t)
    end
    return shades
end

local function make_colors(base)
	local palette = {}
	for k, v in pairs(base) do
		palette[k] = color.new(v)
	end

    local shades = M.generate_shades(palette.bg, palette.fg, 11, "shade")

    return vim.tbl_extend("keep", palette, shades)
	--return vim.tbl_extend(
	--	"keep",
	--	palette,
	--	generate_shades(palette.fg, 6, 16, "darken", "fg"),
	--	generate_shades(palette.bg, 6, 2, "lighten", "bg"),
	--	generate_shades(color.new("#000000"), 10, 10, "lighten", "gray")
	--)
end

function M.get_config()
	return M.config
end

function M.set_colorset(colorset)
	M.setup({ colorset = colorset })
	vim.cmd.colorscheme("emerald")
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
        -- Syntax
		Normal = { fg = colors.fg, bg = colors.bg },
		Identifier = { fg = colors.fg },
		Keyword = { fg = colors.primary },
		Statement = { fg = colors.primary },
		Function = { fg = colors.accent },
		Type = { fg = colors.secondary },
		Operator = { fg = colors.fg },
		String = { fg = colors.highlight },
		Special = { fg = colors.emphasis },
		Constant = { fg = colors.highlight },
		PreProc = { fg = colors.primary },
		Comment = { fg = colors.muted },

        -- Annotations
        AnnotationTODO = { fg = color.new('#ffffff'), bg = color.new_from_hsl({ h = 20, s = 80, l = 35 }) },
        AnnotationNOTE = { fg = color.new('#ffffff'), bg = color.new_from_hsl({ h = 250, s = 80, l = 35 }) },

        -- UI
		CursorLine = { bg = colors.shade1 },
		StatusLine = { fg = colors.fg, bg = colors.highlight:darkened(42) },
		StatusLineNC = { fg = colors.fg, bg = colors.highlight:desaturated(25):darkened(35) },
		WinSeparator = { fg = colors.shade2, bg = "NONE" },
		NormalFloat = { fg = colors.fg, bg = colors.bg },
		FloatBorder = { fg = colors.shade3, bg = colors.bg },
        Pmenu = { fg = colors.fg, bg = colors.bg },
        PmenuBorder = { fg = colors.shade3, bg = colors.bg },
        PmenuSel = { bg = colors.shade2 },
        PmenuMatch = { fg = colors.highlight },
        PmenuKind = { fg = colors.primary },
        PmenuExtra = { fg = colors.secondary },

		-- Diff
		DiffAdd = { bg = colors.bg:with_overlay("#00ff00", 10) },
		DiffDelete = { bg = colors.bg:with_overlay("#ff0000", 10) },

		-- mini.pick
		MiniPickNormal = { fg = colors.fg, bg = colors.bg },
		MiniPickBorder = { fg = colors.shade3, bg = colors.bg },
		MiniPickBorderBusy = { fg = colors.shade5, bg = colors.bg },
		MiniPickBorderText = { fg = colors.shade7 },
		MiniPickPrompt = { fg = colors.fg },
		MiniPickMatchRanges = { fg = colors.highlight },

		-- Oil
		OilDir = { fg = colors.accent },
		OilCreate = { fg = colors.primary },
        OilCopy = { fg = colors.primary },
        OilRestore = { fg = colors.primary },
        OilMove = { fg = colors.primary },
        OilChange = { fg = colors.primary },
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

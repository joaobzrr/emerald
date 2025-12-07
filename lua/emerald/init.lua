local color = require("emerald.color")

local M = { config = {} }

local current_file = vim.fs.normalize(debug.getinfo(1, "S").source:sub(2))

local current_dir = current_file:match("(.+[\\/])")
current_dir = current_dir:gsub("[\\/]+$", "")

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

local function make_colors(colorset)
	local palette = {}
	for k, v in pairs(colorset.get_colors()) do
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

function M.load_highlights(colors)
    local module_paths = vim.fn.glob(current_dir .. '/highlights/*.lua', false, true)

    local highlights = {}
    for _, file in pairs(module_paths) do
        local module_name = vim.fs.normalize(file)
            :gsub('^.*/lua/', '')
            :gsub('%.lua$', '')
            :gsub('/', '.')

        local module = require(module_name)
        highlights = vim.tbl_extend('keep', highlights, module.highlights(colors))
    end

    return highlights
end

-- TODO: This function should just setup the config.
-- Loading should happen when vim.cmd.colorscheme is called.
function M.setup(config)
	if config ~= nil and type(config) ~= "table" then
		error("setup expectes a table or nil")
	end

	config = config or {}
	config.colorset = config.colorset or "lime_whisper"

	M.config = config

	local colorset = require("emerald.colorsets." .. config.colorset)
	local colors = make_colors(colorset)

    local highlights = M.load_highlights(colors)

	for group, opts in pairs(highlights) do
		for k, v in pairs(opts) do
			if type(v) == "table" and v.hex then
				opts[k] = v.hex
			end
		end
		vim.api.nvim_set_hl(0, group, opts)
	end
end

function M.get_config()
	return M.config
end

function M.set_colorset(colorset)
	M.setup({ colorset = colorset })
	vim.cmd.colorscheme("emerald")
end

return M

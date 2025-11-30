local color = require('emerald.color')

local uv = vim.loop

local M = {}

local scheme = "emerald"

-- Get path of current file (init.lua)
local file = debug.getinfo(1, "S").source:sub(2)
file = uv.fs_realpath(file)

local root = vim.fs.normalize(file:match("(.*)\\lua\\emerald\\init%.lua$"))

-- Reload colorscheme
function M.reload()
    for name, _ in pairs(package.loaded) do
        if vim.startswith(name, scheme) then
            package.loaded[name] = nil
        end
    end

    vim.cmd("colorscheme default")
    vim.cmd("colorscheme " .. scheme)
end

if not vim.g.emerald_reload_autocmd then
    vim.g.emerald_reload_autocmd = vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = root .. "/**/*.lua",
        callback = function()
            M.reload()
        end,
    })
end

--local colorset = {
--    bg = "#141c11",
--    fg = "#e8f4e1",
--    bright_green = "#afff82",
--    bright_aqua = "#ceffd7",
--    neutral_green = "#e0d9ab",
--    accent_green = "#b4e48f",
--    neutral_teal = "#92d8be",
--    neutral_cyan = "#b9ecd7",
--    dark_green = "#545f38",
--    deep_teal = "#2b5642",
--}

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

    return vim.tbl_extend('keep', palette,
        generate_shades(palette.fg, 5, 16, "darken", "fg"),
        generate_shades(palette.bg, 5, 2, "lighten", "bg"),
        generate_shades(color.new("#000000"), 10, 10, "lighten", "gray")
    )
end

function M.setup(colorset_name)
    colorset_name = colorset_name or "lime_whisper"
    local colorset = require('emerald.colorsets.' .. colorset_name)
    local colors = make_colors(colorset)

	local highlights = {
		Normal = { fg = colors.fg, bg = colors.bg },
        Operator = { fg = colors.fg },
        Identifier = { fg = colors.fg },
        Keyword = { fg = colors.primary },
        Function = { fg = colors.accent },
        Type = { fg = colors.secondary },
        String = { fg = colors.emphasis },
        Special = { fg = colors.emphasis },
        Constant = { fg = colors.highlight },
        PreProc =  { fg = colors.info },
        Comment = { fg = colors.muted  },
        StatusLine = { fg = colors.fg, bg = colors.bg5 },
        StatusLineNC = { fg = colors.fg2, bg = colors.gray3 }
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

local M = {}

function M.highlights(colors)
    return {
        -- Syntax
        Normal = { fg = colors.fg, bg = colors.bg },
        Identifier = { fg = colors.fg },
        Keyword = { fg = colors.keyword },
        Statement = { fg = colors.keyword },
        Function = { fg = colors.func },
        Type = { fg = colors.type },
        Operator = { fg = colors.fg },
        String = { fg = colors.constant },
        Special = { fg = colors.emphasis },
        Constant = { fg = colors.constant },
        PreProc = { fg = colors.keyword },
        Comment = { fg = colors.comment },

        -- UI
		CursorLine = { bg = colors.shade1 },
		StatusLine = { fg = colors.fg, bg = colors.constant:darkened(42) },
		StatusLineNC = { fg = colors.fg, bg = colors.constant:desaturated(25):darkened(45) },
		WinSeparator = { fg = colors.shade2, bg = "NONE" },
		NormalFloat = { fg = colors.fg, bg = colors.bg },
		FloatBorder = { fg = colors.shade3, bg = colors.bg },
        Pmenu = { fg = colors.fg, bg = colors.bg },
        PmenuBorder = { fg = colors.shade3, bg = colors.bg },
        PmenuSel = { bg = colors.shade2 },
        PmenuMatch = { fg = colors.constant },
        PmenuKind = { fg = colors.keyword },
        PmenuExtra = { fg = colors.type },

    }
end

return M

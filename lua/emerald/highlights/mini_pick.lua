local M = {}

function M.highlights(colors)
    return {
        MiniPickNormal = { fg = colors.fg, bg = colors.bg },
        MiniPickBorder = { fg = colors.shade3, bg = colors.bg },
        MiniPickBorderBusy = { fg = colors.shade5, bg = colors.bg },
        MiniPickBorderText = { fg = colors.shade7 },
        MiniPickPrompt = { fg = colors.fg },
        MiniPickMatchRanges = { fg = colors.constant },
    }
end

return M

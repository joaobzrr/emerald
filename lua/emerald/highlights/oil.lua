local M = {}

function M.highlights(colors)
    return {
		OilDir = { fg = colors.func },
		OilCreate = { fg = colors.keyword },
        OilCopy = { fg = colors.keyword },
        OilRestore = { fg = colors.keyword },
        OilMove = { fg = colors.keyword },
        OilChange = { fg = colors.keyword },
    }
end

return M

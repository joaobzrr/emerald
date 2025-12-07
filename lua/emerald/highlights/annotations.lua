local color = require("emerald.color")

local M = {}

function M.highlights(_)
    local white = color.new('#ffffff')
    local red = color.new_from_hsl({ h = 20, s = 80, l = 35 })
    local blue = color.new_from_hsl({ h = 250, s = 80, l = 35 })

    return {
        AnnotationTODO = { fg = white, bg = red },
        AnnotationNOTE = { fg = white, bg = blue },
    }
end

return M

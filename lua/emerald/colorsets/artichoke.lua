local M = {}

function M.get_colors()
    local charcoal = "#1a1d1a"
    local pearl =  "#d4d8cf"
    local sage = "#9bbd6f"
    local olive = "#969966"
    local seafoam = "#78a98f"
    local lavender = "#ada0c4"
    local moss = "#6c7162"
    local pink = "#c4a0c1"


    return {
        charcoal = charcoal,
        pearl = pearl,
        sage = sage,
        olive = olive,
        seafom = seafoam,
        lavender = lavender,
        moss = moss,
        pink = pink,

        bg = charcoal,
        fg = pearl,
        keyword = sage,
        func = olive,
        type = seafoam,
        constant = lavender,
        comment = moss,
    }
end

return M

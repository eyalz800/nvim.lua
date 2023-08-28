local m = {}
local cmd = require 'vim.cmd'.silent

m.git_blame_current_line = function()
    cmd 'Gitsigns blame_line'
end

m.config = function()
    return {
        signs = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '┃' },
            untracked    = { text = '┆' },
        }
    }
end

return m

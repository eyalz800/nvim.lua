local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

m.setup = function()
    require 'gitsigns'.setup(m.config())
end

m.git_blame_current_line = function()
    cmd 'Gitsigns blame_line'
end

m.prev_hunk = function()
    cmd 'Gitsigns prev_hunk'
end

m.next_hunk = function()
    cmd 'Gitsigns next_hunk'
end

m.config = function()
    return {
        sign_priority = 100,
        signs = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '┃' },
            untracked    = { text = '┆' },
        },
        on_attach = function()
            if v.b.large_file then
                return false
            end
            return true
        end,
    }
end

return m

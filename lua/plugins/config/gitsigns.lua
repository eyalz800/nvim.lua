local m = {}
local user = require 'user'
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

local sign_prefix = user.settings.signcolumn_config.git_prefix or ''

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
            add          = { text = sign_prefix .. '┃' },
            change       = { text = sign_prefix .. '┃' },
            delete       = { text = sign_prefix .. '_' },
            topdelete    = { text = sign_prefix .. '‾' },
            changedelete = { text = sign_prefix .. '┃' },
            untracked    = { text = sign_prefix .. '┆' },
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

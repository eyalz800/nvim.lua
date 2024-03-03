local m = {}
local v = require 'vim'

m.config = function()
    return {
        panel = {
            enabled = true,
            auto_refresh = true,
            keymap = {
                jump_prev = '[[',
                jump_next = ']]',
                accept = "<CR>",
                refresh = 'gr',
                open = "<leader>gp"
            },
            layout = {
                position = 'bottom', -- | top | left | right
                ratio = 0.4
            },
        },
        suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 75,
            keymap = {
                accept = '<C-k>',
                accept_word = false,
                accept_line = false,
                next = '<C-h>',
                prev = '<C-l>',
                dismiss = '<C-j>',
            },
        },
        filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ['.'] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
    }
end

m.setup = function()
    local hide_on_cmp = false
    if hide_on_cmp then
        -- hide copilot suggestions when cmp menu is open
        -- to prevent odd behavior/garbled up suggestions
        local cmp_status_ok, cmp = pcall(require, 'cmp')
        if cmp_status_ok then
            cmp.event:on('menu_opened', function()
                v.b.copilot_suggestion_hidden = true
            end)

            cmp.event:on('menu_closed', function()
                v.b.copilot_suggestion_hidden = false
            end)
        end
    end
end

return m

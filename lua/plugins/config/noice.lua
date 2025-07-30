local m = {}
local v = require 'vim'

m.setup = function()
    require 'noice'.setup(m.config())
    v.keymap.set('n', '<leader>`', ':Noice dismiss<cr>', { desc = 'Dismiss Noice', noremap = true, silent = true })
    v.keymap.set('n', '<leader>nd', ':Noice disable<cr>', { desc = 'Disable Noice', noremap = true, silent = true })
    v.keymap.set('n', '<leader>ne', ':Noice enable<cr>', { desc = 'Enable Noice', noremap = true, silent = true })
    v.keymap.set('n', '<leader>nh', ':Noice history<cr>', { desc = 'Noice history', noremap = true, silent = true })
end

m.config = function()
    return {
        views = {
            -- notify = {
            --     replace = 'true',
            -- }
        },
        lsp = {
            progress = {
                enabled = true,
                format = 'lsp_progress',
                format_done = 'lsp_progress_done',
                throttle = 1000 / 30,
                -- view = 'notify',
            },
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = false,
        },
        health = {
            checker = false,
        },
        throttle = 1000 / 30,
    }
end

return m

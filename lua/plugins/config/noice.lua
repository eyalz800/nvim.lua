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
        routes = {
            {
                filter = { event = 'msg_show', kind = { 'shell_out', 'shell_err' } },
                view = 'cmdline_popup',
                opts = {
                    level = 'info',
                    skip = false,
                    replace = false,
                    enter = true,
                    close = {
                        keys = { 'q', '<esc>', },
                    },
                    position = {
                        row = 0.5,
                        col = 0.5,
                    },
                    focusable = true,

                        win_options = {
                            foldenable = false,
                            cursorline = true,
                        },
                },
            },
            {
                filter = {
                    event = 'msg_show', kind = { 'confirm' } },
                view = 'confirm',
                opts = {
                    level = 'info',
                    skip = false,
                    replace = false,
                    position = {
                        row = 0.5,
                        col = 0.5,
                    },
                },
            },
        },
        throttle = 1000 / 30,
    }
end

return m

local m = {}
local user = require 'user'

m.setup = function()
    require 'noice'.setup(m.config())
    vim.keymap.set('n', '<leader>nq', ':Noice dismiss<cr>', { desc = 'Dismiss Noice', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>nd', ':Noice disable<cr>', { desc = 'Disable Noice', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>ne', ':Noice enable<cr>', { desc = 'Enable Noice', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>nh', ':Noice history<cr>', { desc = 'Noice history', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>na', ':Noice all<cr>', { desc = 'Noice all messages', noremap = true, silent = true })
end

m.config = function()
    return {
        views = {
            split = {
                enter = true,
                win_options = {
                    winhighlight = {
                        Normal = 'NoiceSplit',
                        FloatBorder = 'NoiceSplitBorder',
                        LineNr = 'NoiceSplit',
                        StatusLine = 'NoiceSplit',
                        StatusLineNC = 'NoiceSplit',
                        SignColumn = 'NoiceSplit',
                        SignColumnNC = 'NoiceSplit',
                        NormalNC = 'NoiceSplit',
                    },
                },
            }
        },
        lsp = {
            progress = {
                enabled = not user.settings.fidget,
                format = 'lsp_progress',
                format_done = 'lsp_progress_done',
                throttle = 1000 / 30,
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
                filter = {
                    event = 'msg_show',
                    kind = {
                        'shell_out',
                        'shell_err',
                    },
                    min_height = 30,
                },
                view = 'split',
                opts = {
                    enter = true,
                }
            },
            {
                filter = {
                    event = 'msg_show',
                    min_height = 30,
                },
                view = 'split',
            },
            {
                filter = {
                    event = 'msg_show',
                    kind = 'bufwrite',
                },
                view = 'notify',
                opts = {
                    level = 'info',
                },
            },
            {
                filter = {
                    event = 'msg_show',
                    kind = 'lua_print',
                    find = '^Running healthchecks%.%.%.'
                },
                opts = { skip = true, },
            },
            {
                filter = {
                    event = 'msg_show',
                    find = '^Exited Visual%-Multi%.',
                },
                opts = { skip = true, },
            },
            {
                filter = {
                    event = 'msg_show',
                    find = '^VM has started with warnings%.',
                },
                opts = { skip = true, },
            },
            {
                filter = {
                    event = 'msg_show',
                    kind = 'emsg',
                    find = '^Error in decoration provider',
                },
                opts = { skip = true, },
            },
            {
                filter = {
                    event = 'msg_show',
                    kind = {
                        'shell_out',
                        'shell_err',
                    }
                },
                view = 'notify',
                opts = {
                    level = 'info',
                },
            },
            {
                filter = {
                    event = 'msg_history_show',
                },
                view = 'split',
                opts = {
                    level = 'info',
                    enter = true,
                    close = {
                        keys = { 'q', '<esc>', },
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

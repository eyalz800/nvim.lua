local m = {}
local user = require 'user'

m.setup = function()
    local oil = require 'oil'
    oil.setup(m.config())
    vim.keymap.set('n', '<c-w>i', oil.open ,{ noremap = true, silent = true, desc = 'Open Oil file explorer (oil.open)' })
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('init.lua.oil-timeout-zero', {}),
        pattern = 'oil_preview',
        callback = function(ev)
            local prev_timeout = vim.o.timeoutlen
            local prev_ttimeout = vim.o.ttimeoutlen
            local buf = ev.buf
            local win = vim.api.nvim_get_current_win()

            local restored = false
            local restore = function()
                if not restored then
                    restored = true
                    if prev_timeout ~= 0 then
                        vim.o.timeoutlen = prev_timeout
                    end
                    if prev_ttimeout ~= 0 then
                        vim.o.ttimeoutlen = prev_ttimeout
                    end
                end
            end

            if prev_timeout ~= 0 then
                vim.o.timeoutlen = 0
            end

            if prev_ttimeout ~= 0 then
                vim.o.ttimeoutlen = 0
            end

            vim.api.nvim_create_autocmd('BufLeave', {
                buffer = buf,
                once = true,
                callback = restore,
            })

            vim.api.nvim_create_autocmd('WinClosed', {
                pattern = tostring(win),
                once = true,
                callback = restore,
            })
        end,
    })
end

m.config = function()
    return {
        default_file_explorer = user.settings.nvim_explorer == 'oil',
        view_options = {
            show_hidden = true,
            is_always_hidden = function(name)
                return name == '..'
            end,
        },
        win_options = {
            winhighlight = 'OilFileHidden:OilFile,OilDirHidden:OilDir',
        },
        keymaps = {
            ['g?'] = { 'actions.show_help', mode = 'n' },
            ['<CR>'] = 'actions.select',

            ['<C-s>'] = false,
            ['gv'] = { 'actions.select', opts = { vertical = true } },

            ['<C-h>'] = false,
            ['gh'] = { 'actions.select', opts = { horizontal = true } },

            ['<C-t>'] = { 'actions.select', opts = { tab = true } },

            ['<C-p>'] = false,
            ['gp'] = 'actions.preview',

            ['<C-c>'] = { 'actions.close', mode = 'n' },
            ['gq'] = { 'actions.close', mode = 'n' },

            ['<C-l>'] = false,
            ['gr'] = { 'actions.refresh', mode = 'n', nowait = true },


            ['-'] = false,
            ['cu'] = { 'actions.parent', mode = 'n' },

            ['_'] = { 'actions.open_cwd', mode = 'n' },
            ['<C-w>i'] = { 'actions.open_cwd', mode = 'n' },
            ['cd'] = { 'actions.cd', mode = 'n' },
            ['`'] = { 'actions.cd', mode = 'n' },
            ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
            ['gs'] = { 'actions.change_sort', mode = 'n' },
            ['gx'] = 'actions.open_external',
            ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
            ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
        },
    }
end

return m

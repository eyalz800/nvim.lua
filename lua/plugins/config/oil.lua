local m = {}
local user = require 'user'

m.setup = function()
    local oil = require 'oil'
    oil.setup(m.config())
    vim.keymap.set('n', '<c-w>i', oil.open ,{ noremap = true, silent = true, desc = 'Open Oil file explorer (oil.open)' })
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('init.lua.oil-timeout-zero', {}),
        pattern = 'oil_preview',
        callback = function()
            vim.opt_local.timeoutlen = 0
            vim.opt_local.ttimeoutlen = 0
        end,
    })
    local disable_dim = function()
        for _, group in ipairs(vim.fn.getcompletion('Oil', 'highlight')) do
            local base = group:match('^(Oil.+)Hidden$')
            if base then
                vim.api.nvim_set_hl(0, group, { link = base })
            end
        end
    end
    disable_dim()
    vim.api.nvim_create_autocmd('colorscheme', {
        group = vim.api.nvim_create_augroup('init.lua.colorscheme-oil', {}),
        callback = function()
            disable_dim()
        end
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

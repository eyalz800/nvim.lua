local m = {}
local user = require 'user'

m.lazy = function()
    return {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        config = function()
            local opts = {
                bigfile = {
                    enabled = true,
                },
                image = {
                    enabled = true,
                },
                dashboard = {
                    enabled = true,
                    preset = {
                        pick = nil,
                        keys = {
                            { icon = ' ', key = 'p', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
                            { icon = ' ', key = 'n', desc = 'New File', action = ":ene" },
                            { icon = ' ', key = 'r', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
                            { icon = ' ', key = 'f', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
                            { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                            { icon = ' ', key = 'q', desc = 'Quit', action = ":qa" },
                        },
                    },
                    sections = {
                        { section = 'header' },
                        {
                            section = 'keys',
                            gap = 1,
                            padding = 1,
                        },
                        { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = { 2, 2 } },
                        { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 2 },
                        { section = 'startup' },
                    },
                },
                explorer = {
                    enabled = true,
                },
                indent = { enabled = user.settings.indent_guides == 'snacks' },
                input = { enabled = true },
                notifier = {
                    enabled = user.settings.notifier == 'snacks',
                    timeout = 3000,
                },
                picker = {
                    enabled = true,
                },
                quickfile = { enabled = true },
                scope = { enabled = true },
                scroll = { enabled = false },
                statuscolumn = { enabled = true },
                words = { enabled = true },
                styles = {
                    notification = {
                        -- wo = { wrap = true } -- Wrap notifications
                    }
                },
            }

            require 'snacks'.setup(opts)

            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'snacks_picker_input', 'snacks_input' },
                callback = function()
                    vim.keymap.set('i', '<esc>', '<c-o>:q!<cr>', { noremap = true, silent = true, buffer = true })
                end,
            })
        end,
        keys = {
            { '<leader>.', function() m.snacks().scratch() end, desc = 'Toggle Scratch Buffer' },
            { '<leader>S', function() m.snacks().scratch.select() end, desc = 'Select Scratch Buffer' },
            { '<leader>cR', function() m.snacks().rename.rename_file() end, desc = 'Rename File' },
            { '<leader>ee', function() m.snacks().explorer.reveal() end, desc = 'Open snacks explorer' },
            { 'gB', function() m.snacks().gitbrowse() end, desc = 'Git Browse', mode = { 'n', 'v' } },
            { '<c-/>', function() Snacks.terminal() end,  desc = 'Toggle snacks terminal' },
            { '<c-_>', function() Snacks.terminal() end,  desc = 'which_key_ignore' },
            { ']]', function() m.snacks().words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
            { '[[', function() m.snacks().words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
            user.settings.notifier == 'snacks' and { '<leader>nh', function() m.snacks().notifier.show_history() end, desc = 'Notification History' } or nil,
        },
        init = function()
            vim.api.nvim_create_autocmd('User', {
                pattern = 'VeryLazy',
                callback = function()
                    local snacks = m.snacks()
                    snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>ts')
                    snacks.toggle.diagnostics():map('grt')
                    snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map('<leader>tc')
                    snacks.toggle.inlay_hints():map('<leader>th')
                    snacks.toggle.indent():map('<leader>ti')
                end,
            })
        end,
        cond = user.settings.snacks,
    }
end

m.snacks = function()
    return Snacks
end

m.explorer = function()
    local explorer = {}

    explorer.open = function()
        m.snacks().explorer.reveal()
    end

    explorer.close = function()
        m.snacks().explorer.reveal()
        vim.api.nvim_win_close(0, false)
    end

    explorer.is_open = function()
        return false
    end

    explorer.toggle = function()
        m.snacks().explorer.reveal()
    end

    explorer.open_current_directory = function()
    end

    return explorer
end

return m

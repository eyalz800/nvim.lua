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
                        pick = user.settings.finder == 'fzf-lua' and function(cmd, opts) require 'fzf-lua'[cmd](opts) end or nil,
                        keys = {
                            { icon = ' ', key = 'n', desc = 'New File', action = ':ene' },
                            { icon = '󰁯 ', key = 'o', desc = 'Last File', action = function() vim.api.nvim_feedkeys('2' .. vim.api.nvim_replace_termcodes('<c-o>', true, false, true), 'n', false) end },
                            { icon = ' ', key = 'p', desc = 'Find File', action = require 'plugins.finder'.find_file },
                            { icon = '󰘓 ', key = ']', desc = 'Find In All Files ', action = require 'plugins.finder'.find_file_hidden },
                            { icon = ' ', key = 't', desc = 'Find Text', action = require 'plugins.finder'.find_in_files },
                            { icon = ' ', key = 'r', desc = 'Recent Files', action = require 'plugins.finder'.recent_files },
                            { icon = ' ', key = 's', desc = 'Settings', action = ':n ' .. vim.fn.stdpath('config') .. '/lua/user/settings.lua'},
                            { icon = ' ', key = 'c', desc = 'Config Files', action = function() require 'plugins.finder'.find_file({ cwd = vim.fn.stdpath('config') }) end },
                            { icon = ' ', key = 'C', desc = 'Config Text', action = function() require 'plugins.finder'.find_in_files({ cwd = vim.fn.stdpath('config') }) end },
                            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                            { icon = ' ', key = 'q', desc = 'Quit', action = ":qa" },
                        },
                    },
                    sections = {
                        { section = 'header' },
                        {
                            pane = 2,
                            section = 'terminal',
                            cmd = 'colorscript -e square',
                            height = 5,
                            padding = 1,
                        },
                        { section = 'keys', gap = 1, padding = 1 },
                        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
                        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
                        {
                            pane = 2,
                            icon = ' ',
                            title = 'Git Status',
                            section = 'terminal',
                            enabled = function()
                                return m.snacks().git.get_root() ~= nil
                            end,
                            cmd = 'git status --short --branch --renames',
                            height = 5,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        },
                        { section = 'startup' },
                    },
                },
                indent = { enabled = user.settings.indent_guides == 'snacks' },
                input = { enabled = true },
                notifier = {
                    enabled = user.settings.notifier == 'snacks',
                    timeout = 3000,
                },
                picker = {
                    enabled = true,
                    sources = {
                        explorer = {
                            layout = {
                                cycle = false,
                            },
                            replace_netrw = user.settings.nvim_explorer == 'snacks',
                        },
                    },
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
            { '<leader>da', function() m.snacks().dashboard.open() end, desc = 'Open Dashboard' },
            { '<leader>bi', function() m.snacks().picker.icons() end, desc = 'Browse Icons' },
            { '<leader>.', function() m.snacks().scratch() end, desc = 'Toggle Scratch Buffer' },
            { '<leader>S', function() m.snacks().scratch.select() end, desc = 'Select Scratch Buffer' },
            { '<leader>cR', function() m.snacks().rename.rename_file() end, desc = 'Rename File' },
            { '<leader>ee', function() m.snacks().explorer.reveal() end, desc = 'Open snacks explorer' },
            { 'gB', function() m.snacks().gitbrowse() end, desc = 'Git Browse', mode = { 'n', 'v' } },
            -- { '<c-/>', function() m.snacks().terminal() end,  desc = 'Toggle snacks terminal' },
            -- { '<c-_>', function() m.snacks().terminal() end,  desc = 'which_key_ignore' },
            { '<leader>st', function() m.snacks().terminal() end,  desc = 'Toggle snacks terminal' },
            { ']]', function() m.snacks().words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n' } },
            { '[[', function() m.snacks().words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n' } },
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
    -- TODO: this is not working

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

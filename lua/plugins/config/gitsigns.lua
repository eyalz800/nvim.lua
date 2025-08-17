local m = {}
local user = require 'user'
local cmd = require 'vim.cmd'.silent

local sign_prefix = user.settings.signcolumn_config.git_prefix or ''

m.setup = function()
    require 'gitsigns'.setup(m.config())
end

m.git_blame_current_line = function()
    cmd 'Gitsigns blame_line'
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
        on_attach = function(bufnr)
            if vim.b.large_file then
                return false
            end

            local gitsigns = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gitsigns.next_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gitsigns.prev_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            -- Actions
            map({'n', 'x'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
            map({'n', 'x'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
            map('n', '<leader>hS', gitsigns.stage_buffer)
            map('n', '<leader>hu', gitsigns.undo_stage_hunk)
            map('n', '<leader>hR', gitsigns.reset_buffer)
            map('n', '<leader>hp', gitsigns.preview_hunk)
            map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
            map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
            map('n', '<leader>hd', gitsigns.diffthis)
            map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
            map('n', '<leader>td', gitsigns.toggle_deleted)

            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
    }
end

return m

local m = {}
local cmd = require 'vim.cmd'.silent

vim.g.fugitive_summary_format = "%as (%cr) %an <%ae> : %s"

m.setup = function()
    vim.api.nvim_create_autocmd('filetype', {
        pattern = 'fugitiveblame',
        group = vim.api.nvim_create_augroup('init.lua.fugitive-diffview', {}),
        callback = function()
            -- Map 'q' to quit the buffer locally
            vim.keymap.set('n', 'q', '<cmd>q<cr>', { buffer = true, silent = true, desc = 'Quit FugitiveBlame buffer' })

            -- Map 'd' to yank the commit hash and open DiffviewFileHistory
            vim.keymap.set('n', 'd', function()
                -- Execute normal mode command to yank commit hash into register 'x'
                cmd [=[ exec 'norm! 0eb"xye' ]=]

                -- Move to the window to the right
                cmd 'wincmd l'

                -- Get the yanked commit hash from register 'x'
                local commit_hash_range = vim.fn.getreg('x')

                -- Get the current buffer's file path
                local current_file = vim.fn.expand('%')

                -- Move to the blame again
                cmd 'wincmd h'

                -- Open DiffviewFileHistory for the current file with the yanked commit hash range
                cmd('DiffviewFileHistory ' .. current_file .. ' --range=' .. commit_hash_range)
            end, { buffer = true, silent = true, desc = 'Open DiffviewFileHistory with commit hash' })

            -- Map '<leader>d' to diff the commit itself and open Diffview with all files in the commit
            vim.keymap.set('n', '<leader>d', function()
                -- Execute normal mode command to yank commit hash into register 'x'
                cmd [=[ exec 'norm! 0eb"xye' ]=]

                -- Get the yanked commit hash from register 'x'
                local commit_hash = vim.fn.getreg('x')

                -- Open Diffview for the yanked commit hash (shows all files in commit)
                cmd('DiffviewOpen ' .. commit_hash .. '^!')
            end, { buffer = true, silent = true, desc = 'DiffviewOpen for the commit' })
        end,
    })
end

return m

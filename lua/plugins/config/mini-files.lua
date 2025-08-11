local m = {}

m.setup = function()
    local mini_files = require 'mini.files'
    mini_files.setup(m.config())
    vim.keymap.set('n', '<c-w>f', '<cmd>lua MiniFiles.open()<CR>', { desc = 'Toggle mini file explorer' })
    vim.keymap.set('n', '<c-w>u', function()
        mini_files.open(vim.api.nvim_buf_get_name(0), false)
        mini_files.reveal_cwd()
    end, { desc = "Toggle into currently opened file" })
end

m.config = function()
    return {
        mappings = {
            go_in = '<CR>',
            go_in_plus = 'L',
            go_out = '-',
            go_out_plus = 'H',
        },
    }
end

return m

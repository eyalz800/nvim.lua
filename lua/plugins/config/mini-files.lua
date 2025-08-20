local m = {}
local user = require 'user'

m.setup = function()
    local mini_files = require 'mini.files'
    vim.api.nvim_create_autocmd('filetype', {
        group = vim.api.nvim_create_augroup('init.lua.plugins.mini-files', {}),
        pattern = 'minifiles',
        callback = function()
            vim.keymap.set({ 'n', 'i' }, '<c-s>', mini_files.synchronize, { buffer = true, desc = 'Synchronize mini file explorer' })
        end,
    })
    mini_files.setup(m.config())
    vim.keymap.set('n', '<c-w>f', mini_files.open, { desc = 'Open mini file explorer' })
    vim.keymap.set('n', '<c-w>u', function()
        local current_file_path = vim.api.nvim_buf_get_name(0)
        local ok, _ = pcall(mini_files.open, current_file_path, false)
        if not ok then
            ok, _ = pcall(mini_files.open, vim.fs.dirname(current_file_path), false)
            if not ok then
                mini_files.open()
            end
        end
        mini_files.reveal_cwd()
    end, { desc = 'Open mini file explorer and focus on current file' })
end

m.config = function()
    return {
        options = {
            use_as_default_explorer = user.settings.nvim_explorer == 'mini',
        },
        mappings = {
            go_in = 'L',
            go_in_plus = '<cr>',
            go_out = '-',
            go_out_plus = 'H',
        },
    }
end

return m

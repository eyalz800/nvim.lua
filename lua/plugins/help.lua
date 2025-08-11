local m = {}

m.setup = function()
    vim.api.nvim_create_autocmd('filetype', {
        pattern = 'help',
        group = vim.api.nvim_create_augroup('init.lua.help', {}),
        callback = require 'plugins.help'.on_open
    })

    vim.api.nvim_create_autocmd('bufwinenter', {
        group = vim.api.nvim_create_augroup('init.lua.help-buftype', {}),
        callback = function()
            if vim.bo.buftype == 'help' and vim.bo.filetype ~= 'help' then
                require 'plugins.help'.on_open()
            end
        end
    })
end

m.on_open = function()
    vim.keymap.set('n', 'q', ':<c-u>q<cr>', { silent=true, buffer=true })
    vim.keymap.set('n', 'a', ':wincmd L<cr>', { silent=true, buffer=true })
    vim.opt_local.conceallevel = 0
end

return m

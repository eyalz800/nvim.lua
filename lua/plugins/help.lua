local m = {}
m.on_open = function()
    vim.keymap.set('n', 'q', ':<c-u>q<cr>', { silent=true, buffer=true })
    vim.keymap.set('n', 'a', ':wincmd L<cr>', { silent=true, buffer=true })
    vim.opt_local.conceallevel = 0
end

return m

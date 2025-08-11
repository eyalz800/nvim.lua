local m = {}
local cmd = require 'vim.cmd'.silent

m.doc_patterns = {'*.doc', '*.docx', '*.rtf', '*.odp', '*.odt'}

m.setup = function()
    vim.api.nvim_create_autocmd('bufreadpost', {
        pattern = m.doc_patterns,
        group = vim.api.nvim_create_augroup('init.lua.pandoc-readpost', {}),
        callback = m.on_buf_read_post
    })
end

m.on_buf_read_post = function()
    if not vim.o.bin then
        cmd '%!pandoc "%" -tmarkdown -o /dev/stdout'
        vim.opt.ft = 'markdown'
        vim.bo.readonly = true
    end
end

return m

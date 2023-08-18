local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

m.doc_patterns = {'*.doc', '*.docx', '*.rtf', '*.odp', '*.odt'}
m.on_buf_read_post = function()
    if not v.o.bin then
        cmd '%!pandoc "%" -tmarkdown -o /dev/stdout'
        v.opt.ft = 'markdown'
        v.bo.readonly = true
    end
end

return m

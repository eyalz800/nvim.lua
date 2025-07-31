local m = {}
local echo = require 'vim.echo'.echo
local cmd = require 'vim.cmd'.silent

m.binary_view = function()
    if vim.o.mod then
        echo 'Buffer has changed, please save or undo before proceeding.'
        return
    end

    if not vim.o.bin then
        vim.o.bin = true
    else
        vim.o.bin = false
    end
    cmd 'e'
end

m.on_buf_read_post = function()
    if vim.o.bin then
        vim.opt.ft = 'xxd'
        cmd '%!xxd'
    end
end

m.on_buf_write_pre = function()
    if vim.o.bin then
        vim.opt.ft = 'xxd'
        cmd '%!xxd -r'
    end
end

m.on_buf_write_post = function()
    if vim.o.bin then
        vim.opt.ft = 'xxd'
        cmd '%!xxd'
    end
end

return m

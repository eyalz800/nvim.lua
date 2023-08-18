local m = {}
local v = require 'vim'
local echo = require 'vim.echo'.echo
local cmd = require 'vim.cmd'.silent

m.binary_view = function()
    if v.o.mod then
        echo 'Buffer has changed, please save or undo before proceeding.'
        return
    end

    if not v.o.bin then
        v.o.bin = true
    else
        v.o.bin = false
    end
    cmd 'e'
end

m.on_buf_read_post = function()
    if v.o.bin then
        v.opt.ft = 'xxd'
        cmd '%!xxd'
    end
end

m.on_buf_write_pre = function()
    if v.o.bin then
        v.opt.ft = 'xxd'
        cmd '%!xxd -r'
    end
end

m.on_buf_write_post = function()
    if v.o.bin then
        v.opt.ft = 'xxd'
        cmd '%!xxd'
    end
end

return m

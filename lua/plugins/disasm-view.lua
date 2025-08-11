local m = {}
local echo = require 'vim.echo'.echo
local cmd = require 'vim.cmd'.silent
local user = require 'user'
local whitespace = require 'plugins.whitespace'
local expand = vim.fn.expand

m.disasm_view = function()
    if vim.b.disasm_view then
        vim.bo.readonly = false
        vim.b.disasm_view = false
        cmd 'e!'
        return
    end

    if vim.o.mod then
        echo 'Buffer has changed, please save or undo before proceeding.'
        return
    end

    local objdump = 'objdump'
    if user.settings.binaries and user.settings.binaries.objdump then
        objdump = user.settings.binaries.objdump
    end
    cmd('%!' .. objdump .. ' -M intel -s -C -D ' .. expand('%'))
    vim.bo.readonly = true
    whitespace.disable()
    vim.opt.ft = 'asm'
    vim.o.mod = false
    vim.b.disasm_view = true
end

return m


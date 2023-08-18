local m = {}
local v = require 'vim'
local echo = require 'vim.echo'.echo
local cmd = require 'vim.cmd'.silent
local user = require 'user'
local whitespace = require 'plugins.whitespace'
local expand = v.fn.expand

m.disasm_view = function()
    if v.b.disasm_view then
        v.bo.readonly = false
        v.b.disasm_view = false
        return
    end

    if v.o.mod then
        echo 'Buffer has changed, please save or undo before proceeding.'
        return
    end

    local objdump = 'objdump'
    if user.settings.binaries and user.settings.binaries.objdump then
        objdump = user.settings.binaries.objdump
    end
    cmd('%!' .. objdump .. ' -M intel -s -C -D ' .. expand('%'))
    v.bo.readonly = true
    whitespace.disable()
    v.opt.ft = 'asm'
    v.o.mod = false
    v.b.disasm_view = true
end

return m


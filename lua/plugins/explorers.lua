local m = {}
local v = require 'vim'
local echo = require 'vim.echo'.echo
local expand = v.fn.expand
local cmd = require 'vim.cmd'.silent
local file_readable = require 'vim.file_readable'.file_readable

m.file = require 'plugins.file_explorer'
m.code = require 'plugins.code_explorer'

m.display_current_file = function()
    if m.file.is_open() and file_readable(expand('%')) then
        m.file.open({ focus=false })
    end
    echo(v.fn.expand('%:p'))
end

m.display_current_directory = function()
    if m.file.is_open() then
        m.file.open_current_directory({ focus=false })
    end
    echo(v.fn.getcwd())
end

m.close = function()
    m.file.close()
    m.code.close()
    cmd 'cclose'
end

return m

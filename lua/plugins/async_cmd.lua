local m = {}
local v = require 'vim'
local exists = require 'vim.exists'.exists
local system = v.fn.system
local echo = require 'vim.echo'.echo
local cmd = require 'vim.cmd'.silent
local quickfix = require 'plugins.quickfix'

v.g.asyncrun_open = 0

m.async_cmd = function(command, options)
    options = options or {}

    if exists ':AsyncRun'  then
        if options.visible then
            quickfix.open({ focus = options.focus, expand = true })
        end
        cmd('AsyncRun ' .. command)
    else
        if options.visible then
            echo("Executing '" .. command .. "'...")
        end
        system(command)
    end
end

return m

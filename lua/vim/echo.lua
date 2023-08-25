local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

m.echo = function(message)
    cmd "redraw"
    v.api.nvim_echo({{ message }}, true, {})
end

m.inspect = function(message)
    m.echo(v.inspect(message))
end

return m

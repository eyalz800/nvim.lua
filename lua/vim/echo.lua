local m = {}
local cmd = require 'vim.cmd'.silent

m.echo = function(message)
    cmd "redraw"
    vim.api.nvim_echo({{ message }}, true, {})
end

m.inspect = function(message)
    m.echo(vim.inspect(message))
end

return m

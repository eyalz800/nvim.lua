local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

m.echo = function(str)
    cmd "redraw"
    v.api.nvim_echo({ { str, "Bold" } }, true, {})
end

return m

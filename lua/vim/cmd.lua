local m = {}
local v = require 'vim'

m.cmd = v.cmd

m.silent = function(str)
    v.cmd('silent ' .. str)
end

return m

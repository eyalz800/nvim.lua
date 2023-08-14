local m = {}
local v = require 'vim'

m.executable = function(str)
    return v.fn.executable(str) ~= 0
end

return m

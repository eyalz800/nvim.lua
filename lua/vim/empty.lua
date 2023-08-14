local m = {}
local v = require 'vim'

m.empty = function(str)
    return v.fn.empty(str) ~= 0
end

return m

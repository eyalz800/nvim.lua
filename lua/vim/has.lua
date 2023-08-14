local m = {}
local v = require 'vim'

m.has = function(str)
    return v.fn.has(str) ~= 0
end

return m

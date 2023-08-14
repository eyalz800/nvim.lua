local m = {}
local v = require 'vim'

m.exists = function(str)
    return v.fn.exists(str) ~= 0
end

return m

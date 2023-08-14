local m = {}
local v = require 'vim'

m.is_directory = function(str)
    return v.fn.isdirectory(str) ~= 0
end

return m

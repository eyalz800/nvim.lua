local m = {}
local v = require 'vim'

m.file_readable = function(str)
    return v.fn.filereadable(str) ~= 0
end

return m

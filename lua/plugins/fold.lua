local m = {}
local v = require 'vim'

m.toggle = function()
    if v.o.foldlevel == 0 then
        v.o.foldlevel = 1000
    else
        v.o.foldlevel = 0
    end
end

return m

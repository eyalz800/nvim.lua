local m = {}
local v = require 'vim'

m.setup = function()
    if v.env.IS_INSIDE_VIM == '1' then
        m.is_nested = true
    else
        v.env.IS_INSIDE_VIM = '1'
        m.is_nested = false
    end
end

return m

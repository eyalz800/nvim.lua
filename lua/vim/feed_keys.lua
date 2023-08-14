local m = {}
local v = require 'vim'

m.feed_keys = function(keys)
    v.api.nvim_feedkeys(v.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
end

m.plug = function(plug)
    m.feed_keys('<plug>(' .. plug .. ')')
end

return m

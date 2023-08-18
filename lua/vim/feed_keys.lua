local m = {}
local v = require 'vim'

m.feed_keys = function(keys, mode)
	mode = mode or 'n'
    v.api.nvim_feedkeys(v.api.nvim_replace_termcodes(keys, true, false, true), mode, false)
end

m.plug = function(plug)
    m.feed_keys('<plug>(' .. plug .. ')')
end

return m

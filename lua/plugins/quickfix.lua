local m = {}
local v = require 'vim'

m.on_open = function()
    v.keymap.set('n', 'q', ':<C-u>q<cr>', { silent=true, buffer=true })
end

return m

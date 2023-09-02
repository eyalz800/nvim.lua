local m = {}
local v = require 'vim'

m.on_open = function()
    v.keymap.set('n', 'q', ':<c-u>q<cr>', { silent=true, buffer=true })
    v.keymap.set('n', 'a', ':wincmd L<cr>', { silent=true, buffer=true })
end

return m

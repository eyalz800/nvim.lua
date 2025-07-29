local m = {}
local v = require 'vim'

m.setup = function()
    require 'Comment'.setup(m.config())
    v.keymap.del('x', 'gcb')
end

m.config = function()
    return {
        toggler = {
            line = 'gcc',
            block = 'gcb',
        },
        opleader = {
            line = 'gc',
            block = 'gcb',
        },
    }
end

return m


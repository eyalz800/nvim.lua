local m = {}
local user = require 'user'

m.setup = function()
    require 'nvim-treesitter.configs'.setup(m.config())
end

m.config = function()
    return {
        textobjects = {
            select = {
                enable = true,
            },
        },
    }
end

return m

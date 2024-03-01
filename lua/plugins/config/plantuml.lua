local m = {}
local v = require 'vim'

v.g.plantuml_set_makeprg = 0 -- plantuml-syntax disable plugin

m.config = function()
    return {
        renderer = {
            type = 'text',
            options = {
                split_cmd = 'split',
            }
        },
        render_on_write = true,
    }
end

return m

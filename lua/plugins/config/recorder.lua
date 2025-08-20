local m = {}

m.setup = function()
    require 'recorder'.setup(m.config())
end

m.config = function()
    return {
        slots = { 'a', 's', 'd', 'w' },
    }
end

return m

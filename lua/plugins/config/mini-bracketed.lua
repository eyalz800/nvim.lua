local m = {}

m.setup = function()
    require 'mini.bracketed'.setup(m.config())
end

m.config = function()
    return {}
end

return m

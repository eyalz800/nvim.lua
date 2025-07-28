local m = {}

m.setup = function()
    require 'render-markdown'.setup(m.config())
end

m.config = function()
    return {}
end

return m

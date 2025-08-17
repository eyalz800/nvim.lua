local m = {}

m.setup = function()
    require 'mini.ai'.setup(m.config())
end

m.config = function()
    return {}
end

return m

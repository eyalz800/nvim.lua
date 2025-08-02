local m = {}

m.setup = function()
    require 'guess-indent'.setup(m.config())
end

m.config = function()
    return {}
end

return m

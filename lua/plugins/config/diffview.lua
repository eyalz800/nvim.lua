local m = {}

m.setup = function()
    require 'diffview'.setup(m.config())
end

m.config = function()
    return {}
end

return m

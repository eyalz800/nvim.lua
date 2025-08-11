local m = {}

m.setup = function()
    require 'mini.bufremove'.setup(m.config())
end

m.config = function()
    return {
        silent = true,
    }
end

return m

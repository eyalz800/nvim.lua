local m = {}

m.setup = function()
    require 'render-markdown'.setup(m.config())
end

m.config = function()
    return {
        enabled = true,
        render_modes = { 'n', 'c', 't', 'i' },
    }
end

return m

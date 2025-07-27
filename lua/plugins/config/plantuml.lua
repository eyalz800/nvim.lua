local m = {}

m.setup = function()
    require 'plantuml'.setup(m.config())
end

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

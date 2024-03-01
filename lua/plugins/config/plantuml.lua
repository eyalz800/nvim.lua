local m = {}

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

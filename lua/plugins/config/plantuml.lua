local m = {}

m.config = function()
    return {
        renderer = {
            type = 'text',
            options = {
                split_cmd = 'vsplit',
            }
        },
        render_on_write = true,
    }
end

return m

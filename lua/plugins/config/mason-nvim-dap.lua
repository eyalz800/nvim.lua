local m = {}

m.config = function()
    return {
        handlers = {},
        ensure_installed = {
            'codelldb',
            'python'
        },
    }
end

return m

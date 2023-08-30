local m = {}

m.config = function()
    return {
        handlers = {},
        ensure_installed = {
            'codelldb',
            'cpptools',
            --'python',
        },
    }
end

return m

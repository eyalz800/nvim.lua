local m = {}

m.config = function()
    return {
        handlers = {},
        ensure_installed = {
            'codelldb',
            'cppdbg',
            --'python',
        },
    }
end

return m

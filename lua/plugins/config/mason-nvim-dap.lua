local m = {}

m.setup = function()
    require 'mason-nvim-dap'.setup(m.config())
end

m.config = function()
    return {
        handlers = {},
        ensure_installed = {
            'codelldb',
            'cppdbg',
            'python',
        },
    }
end

return m

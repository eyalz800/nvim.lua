local m = {}

m.setup = function()
    require 'lazydev'.setup(m.config())
end

m.config = function()
    return {
        library = {
            {
                path = '${3rd}/luv/library',
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                --words = { 'vim%.uv' }
            },
        },
    }
end

return m


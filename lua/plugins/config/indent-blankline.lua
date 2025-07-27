local m = {}

m.setup = function()
    require 'ibl'.setup(m.config())
end

m.config = function()
    return {
        indent = {
            char = '│',
            smart_indent_cap = false,
        },
        scope = {
            enabled = true,
            char = '│',
            show_start = false,
            show_end = false,
            highlight = { 'NonText' },
        },
    }
end

return m


local m = {}

m.setup = function()
    require 'toggleterm'.setup(m.config())
end

m.config = function()
    return {
        size = 40,
        direction = 'vertical',
        winbar = { enabled = false },
        persist_mode = false,
        terminal_mappings = false,
    }
end

return m

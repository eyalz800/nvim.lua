local m = {}

m.setup = function()
    local dropbar = require 'dropbar'
    local dropbar_api = require('dropbar.api')
    dropbar.setup(m.config())
    vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
    vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
    vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
end

m.config = function()
    return {
        bar = {
            hover = false,
        }
    }
end

return m

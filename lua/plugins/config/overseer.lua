local m = {}

local overseer = {}

m.setup = function()
    overseer = require 'overseer'
    require 'overseer'.setup(m.config())

    overseer.add_template_hook({}, function(task_defn, util)
        util.add_component(task_defn, { 'on_output_quickfix', open = true })
        util.remove_component(task_defn, 'on_complete_notify')
    end)

    vim.keymap.set({ 'n', 'x' }, '<c-n>', function()
        overseer.run_template()
    end, { noremap = true, silent = true, desc = 'Run task (overseer.run_template)' })
    vim.keymap.set('n', '<c-/>', function() overseer.toggle() end,
        { noremap = true, silent = true, desc = 'Toggle Overseer task manager (overseer.toggle)' })
    vim.keymap.set('n', '<c-_>', function() overseer.toggle() end,
        { noremap = true, silent = true, desc = 'which_key_ignore' })
end

m.config = function()
    return {
        dap = true,
        strategy = 'jobstart',
        task_list = {
            direction = 'right',
        },
    }
end

return m

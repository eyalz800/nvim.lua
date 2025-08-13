local m = {}

m.setup = function()
    require 'diffview'.setup(m.config())
end

m.config = function()
    local actions = require 'diffview.actions'
    return {
        file_panel = {
            win_config = {
                width = 30,
                win_opts = {},
            },
        },
        view = {
            merge_tool = {
                layout = 'diff3_mixed',
            },
        },
        keymaps = {
            file_panel = {
                { 'n', 'L', false }, -- Disable default mapping for open commit log
                { 'n', '<leader>l', actions.open_commit_log, { desc = 'Open the commit log panel' } },
            },
        },
    }
end

return m

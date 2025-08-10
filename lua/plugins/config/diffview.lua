local m = {}

m.setup = function()
    require 'diffview'.setup(m.config())
end

m.config = function()
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
    }
end

return m

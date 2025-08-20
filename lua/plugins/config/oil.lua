local m = {}
local user = require 'user'

m.setup = function()
    require 'oil'.setup(m.config())
end

m.config = function()
    return {
        default_file_explorer = user.settings.nvim_explorer == 'oil',
    }
end

return m

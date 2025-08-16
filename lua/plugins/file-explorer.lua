local m = {}
local user = require 'user'

if user.settings.file_explorer == 'nerdtree' then
    return require 'plugins.config.nerdtree'
elseif user.settings.file_explorer == 'nvim-tree' then
    return require 'plugins.config.nvim-tree'
elseif user.settings.file_explorer == 'snacks' then
    return require 'plugins.config.snacks'.explorer()
else
    m.open = function() end
    m.close = function() end
    m.is_open = function() end
    m.toggle = function() end
    m.open_current_directory = function() end
end

return m

local m = {}
local user = require 'user'

if user.settings.code_explorer == 'tagbar' then
    return require 'plugins.config.tagbar'
elseif user.settings.code_explorer == 'symbols-outline' then
    return require 'plugins.config.symbols-outline'
else
    m.open = function() end
    m.close = function() end
    m.is_open = function() end
    m.toggle = function() end
end

return m


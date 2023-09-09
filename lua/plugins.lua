local m = {}
local user = require 'user'

m.setup = function()
    require 'plugins.config'.setup()
    require 'plugins.line'.setup()
    if user.settings.pin_bars == 'pin' then
        require 'plugins.pin'.setup()
    end
    require 'plugins.lazy'.setup()
end

return m

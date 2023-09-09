local m = {}
local user = require 'user'

m.setup = function()
    require 'plugins.config'
    require 'plugins.line'
    if user.settings.pin_bars == 'pin' then
        require 'plugins.pin'.setup()
    end
    require 'plugins.lazy'.start()
end

return m

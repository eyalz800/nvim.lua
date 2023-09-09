local m = {}
local user = require 'user'

m.setup = function()
    if user.settings.line == 'airline' then
        return require 'plugins.config.airline'
    else
        -- From here onwards those are loaded automatically
    end
end

return m

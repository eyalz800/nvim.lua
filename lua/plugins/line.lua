local m = {}
local user = require 'user'

if user.settings.line == 'airline' then
    return require 'plugins.config.airline'
else
    -- From here onwards those are loaded automatically
end

return m

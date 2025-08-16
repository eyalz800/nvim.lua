local m = {}
local user = require 'user'

m.setup = function()
    require 'plugins.line'.setup()
    if user.settings.pin_bars == 'pin' then
        require 'plugins.pin'.setup()
    end
    require 'plugins.colors'.setup()
    require 'plugins.large-files'.setup()
    require 'plugins.quickfix'.setup()
    require 'plugins.help'.setup()
    require 'plugins.doc-reader'.setup()
    require 'plugins.syntax'.setup()
    require 'plugins.code-explorer'.setup()
    require 'plugins.zip'.setup()
    require 'plugins.lazy'.setup()
end

return m

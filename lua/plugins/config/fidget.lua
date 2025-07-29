local m = {}
local user = require 'user'

local progress_ignore = nil

m.setup = function()
    if not user.settings.fidget then
        progress_ignore = { '*' }
    end
    require 'fidget'.setup(m.config())
end

m.config = function()
    return {
        progress = {
            ignore = progress_ignore,
        }
    }
end

return m


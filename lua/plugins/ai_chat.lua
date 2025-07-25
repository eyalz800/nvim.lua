local m = {}
local v = require 'vim'
local user = require 'user'

m.open = function()
    if user.settings.codecompanion then
        require 'codecompanion'.chat()
    end
end

return m

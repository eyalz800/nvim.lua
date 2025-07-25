local m = {}
local v = require 'vim'
local user = require 'user'

m.toggle = function()
    if user.settings.codecompanion then
        require 'codecompanion'.toggle()
    end
end

return m

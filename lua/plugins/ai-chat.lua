local m = {}
local user = require 'user'
local cmd = require 'vim.cmd'.silent

m.toggle = function()
    if user.settings.codecompanion then
        require 'codecompanion'.toggle()
        cmd 'horizontal wincmd ='
    end
end

return m

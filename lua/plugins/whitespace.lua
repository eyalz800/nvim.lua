local m = {}
local cmd = require 'vim.cmd'.silent

m.enable = function()
    cmd 'EnableWhitespace'
end

m.disable = function()
    cmd 'DisableWhitespace'
end

m.toggle = function()
    cmd 'ToggleWhitespace'
end

m.strip = function()
    cmd 'StripWhitespace'
end

return m

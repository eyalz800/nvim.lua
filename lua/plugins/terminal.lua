local m = {}
local cmd = require 'vim'.cmd

m.open_floating_terminal = function(command)
    cmd('FloatermNew --height=0.9 --width=0.9 --autoclose=2 ' .. command)
end

return m

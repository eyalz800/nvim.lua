local m = {}
local cmd = require 'vim.cmd'.silent

m.exec_detach = function(what)
    cmd('call timer_start(0, {tid->execute("' .. what .. '")})')
end

return m


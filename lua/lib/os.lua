local m = {}
local v = require 'vim'

if v.loop.os_uname().sysname == "Windows_NT" then
    m.os = "Windows"
else
    m.os = v.fn.substitute(v.fn.system('uname'), '\n', '', '')
end

return m

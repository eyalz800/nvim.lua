local m = {}
local os = require 'lib.os'.os

if os == 'Darwin' then
    m.sed = 'gsed'
else
    m.sed = 'sed'
end

return m


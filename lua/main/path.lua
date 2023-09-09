local m = {}
local v = require 'vim'

local stdpath = v.fn.stdpath
local env = v.env

m.setup = function()
    local data_path = stdpath 'data'

    env.PATH = '' ..
        data_path .. '/installation/bin/programs' .. ':' ..
        data_path .. '/mason/bin' .. ':' ..
        data_path .. '/mason/packages/cpptools/extension/debugAdapters/lldb-mi/bin' .. ':' ..
        v.env.PATH
 end

return m

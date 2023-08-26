local m = {}
local v = require 'vim'

local stdpath = v.fn.stdpath

local data_path = stdpath 'data'

v.env.PATH = data_path .. '/installation/bin/programs' .. ':' ..
             data_path .. '/mason/bin' .. ':' ..
             v.env.PATH

return m

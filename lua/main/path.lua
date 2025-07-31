local m = {}
local stdpath = vim.fn.stdpath
local env = vim.env

m.setup = function()
    local data_path = stdpath 'data'

    env.PATH = '' ..
        data_path .. '/installation/bin/programs' .. ':' ..
        data_path .. '/mason/bin' .. ':' ..
        data_path .. '/mason/packages/cpptools/extension/debugAdapters/lldb-mi/bin' .. ':' ..
        vim.env.PATH
 end

return m

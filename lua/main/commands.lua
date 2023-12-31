local m = {}
local v = require 'vim'
local cmd = v.api.nvim_create_user_command

m.setup = function()
    local config_path = v.fn.stdpath 'config'

    -- Settings
    cmd('Settings', 'n ' .. config_path .. '/lua/user/settings.lua', {})

    -- Mappings
    cmd('Mappings', 'n ' .. config_path .. '/lua/main/mappings.lua', {})
    cmd('UserMappings', 'n ' .. config_path .. '/lua/user/mappings.lua', {})

    -- Quit vim
    cmd('Q', 'q', {})
    cmd('Q', 'q!', {bang = true})
    cmd('Qa', 'qa', {})
    cmd('Qa', 'qa!', {bang = true})
    cmd('QA', 'qa', {})
    cmd('QA', 'qa!', {bang = true})

    -- Sudo
    cmd('SudoWrite', 'w !sudo tee > /dev/null %', {})
end

return m

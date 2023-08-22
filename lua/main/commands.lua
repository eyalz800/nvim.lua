local m = {}
local v = require 'vim'
local echo = require 'vim.echo'.echo
local cmd = v.api.nvim_create_user_command
local config_path = v.fn.stdpath('config')

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

-- Syntax information
cmd('SyntaxInfo', function()
    local s = v.fn.synID(v.fn.line('.'), v.fn.col('.'), 1)
    echo(v.fn.synIDattr(s, 'name') ..
         ' -> ' .. v.fn.synIDattr(v.fn.synIDtrans(s), 'name'))
end, {})

return m

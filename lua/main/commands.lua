local m = {}
local v = require 'vim'
local echo = require 'vim.echo'.echo
local cmd = v.api.nvim_create_user_command

-- Settings
cmd('Settings', 'n ~/.config/nvim/lua/user/settings.lua', {})

-- Quit vim
cmd('Q', 'q', {})
cmd('Q', 'q!', {bang = true})
cmd('Qa', 'qa', {})
cmd('Qa', 'qa!', {bang = true})
cmd('QA', 'qa', {})
cmd('QA', 'qa!', {bang = true})

-- Sudo
cmd('InitLuaSudoW', 'w !sudo tee > /dev/null %', {})

-- Syntax information
cmd('InitLuaSyntaxInfo', function()
    local s = v.fn.synID(v.fn.line('.'), v.fn.col('.'), 1)
    echo(v.fn.synIDattr(s, 'name') ..
         ' -> ' .. v.fn.synIDattr(v.fn.synIDtrans(s), 'name'))
end, {})

return m

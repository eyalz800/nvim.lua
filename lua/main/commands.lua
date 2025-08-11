local m = {}
local cmd = vim.api.nvim_create_user_command

m.setup = function()
    local config_path = vim.fn.stdpath 'config'

    -- Settings
    cmd('Settings', 'n ' .. config_path .. '/lua/user/settings.lua', {})

    -- Mappings
    cmd('Mappings', 'n ' .. config_path .. '/lua/main/mappings.lua', {})

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

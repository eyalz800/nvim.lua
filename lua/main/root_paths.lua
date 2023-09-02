local m = {}
local v = require 'vim'
local echo = require 'vim.echo'.echo
local file_readable = require 'vim.file_readable'.file_readable
local is_directory = require 'vim.is_directory'.is_directory
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local getcwd = v.fn.getcwd

m.root = v.env.PWD

m.switch_to_root = function()
    cmd('cd ' .. m.root)
end

m.switch_to_project_root = function()
    local directory = v.fn.expand '%:p:h'
    if #directory == 0 then
        directory = getcwd()
    end

    local current_path = directory
    local limit = 100
    local iteration = 0

    while iteration < limit do
        if current_path == '/' then
            echo "Project root not found!"
            cmd('cd ' .. directory)
            return
        end

        for _, root_path in ipairs(user.settings.root_paths) do
            local abs_path = current_path .. '/' .. root_path

            if not file_readable(abs_path) and not is_directory(abs_path) then
                goto continue
            end

            cmd('cd ' .. current_path)
            do return end
            ::continue::
        end

        current_path = v.fn.fnamemodify(current_path, ':h')
        iteration = iteration + 1
    end

    echo "Project root not found!"
    cmd('cd ' .. directory)
end

return m

local m = {}
local echo = require 'vim.echo'.echo
local file_readable = require 'vim.file-readable'.file_readable
local is_directory = require 'vim.is-directory'.is_directory
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local getcwd = vim.fn.getcwd

m.setup = function()
    m.root = vim.env.PWD
    m.root_paths = user.settings.root_paths
end

m.switch_to_root = function()
    cmd('cd ' .. m.root)
end

m.find_root = function(directory, root_paths)
    if not directory or #directory == 0 then
        directory = getcwd()
    end

    local current_path = directory
    local limit = 100
    local iteration = 0

    while iteration < limit do
        for _, root_path in ipairs(root_paths) do
            local abs_path = current_path .. '/' .. root_path

            if not file_readable(abs_path) and not is_directory(abs_path) then
                goto continue
            end

            do return current_path end
            ::continue::
        end

        if current_path == '/' then
            return nil
        end

        current_path = vim.fn.fnamemodify(current_path, ':h')
        iteration = iteration + 1
    end

    return nil
end

m.git_root = function(directory)
    return m.find_root(directory, { '.git' })
end

m.project_root = function(directory)
    return m.find_root(directory, m.root_paths)
end

m.switch_to_project_root = function()
    local directory = m.project_root(vim.fn.expand '%:p:h')
    if directory then
        cmd('cd ' .. directory)
    else
        echo "Project root not found!"
    end
end

return m

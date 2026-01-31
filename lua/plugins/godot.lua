local m = {}

m.setup = function()
    local project_file = vim.fn.getcwd() .. '/project.godot'
    if vim.fn.filereadable(project_file) ~= 0 then
        vim.fn.serverstart('./godothost')
    end
end

return m

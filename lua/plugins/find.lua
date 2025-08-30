local m = {}
local executable = require 'vim.executable'.executable

if executable 'fdfind' then
    m.file_cmd = 'fdfind -tf'
    m.dir_cmd = 'fdfind -td'
    m.options = { exclude_git = '--exclude .git'}
elseif executable 'fd' then
    m.file_cmd = 'fd -tf'
    m.dir_cmd = 'fd -td'
    m.options = { exclude_git = '--exclude .git'}
else
    m.file_cmd = 'rg --files'
    m.options = { exclude_git = '-g "!.git"'}
end

return m

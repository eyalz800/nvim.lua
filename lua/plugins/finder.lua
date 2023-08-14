local m = {}
local user = require 'user'

if user.settings.finder == 'fzf' then
    return require 'plugins.config.fzf'
else
    m.find_file = function() end
    m.find_file_hidden = function() end
    m.find_in_files = function() end
    m.find_line = function() end
    m.find_content_in_files = function() end
    m.find_folder = function() end
end

return m

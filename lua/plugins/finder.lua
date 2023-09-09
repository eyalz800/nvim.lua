local m = {}
local user = require 'user'

if user.settings.finder == 'fzf-lua' then
    return require 'plugins.config.fzf-lua'
elseif user.settings.finder == 'fzf' then
    return require 'plugins.config.fzf'
else
    m.find_file = function() end
    m.find_file_hidden = function() end
    m.find_line = function() end
    m.find_in_files = function() end
    m.find_in_files_precise = function() end
    m.find_in_files_precise_native = function() end
    m.find_current_in_files = function() end
    m.find_current_in_files_native = function() end
    m.find_current_in_files_precise_native = function() end
    m.find_folder = function() end
    m.find_file_list = function() end
    m.find_file_list_invalidate = function() end
    m.find_file_list_hidden = function() end
    m.find_file_list_hidden_invalidate = function() end
    m.custom_grep = function() end
    m.color_picker = function() end
    m.keymaps = function() end
end

return m

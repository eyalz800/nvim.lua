local m = {}
local user = require 'user'

if user.settings.lsp == 'coc' then
    require 'plugins.config.ultisnips'
end

return m

local m = {}
local user = require 'user'

m.init = function()
    vim.g.UltiSnipsSnippetDirectories = {'UltiSnips', 'vim-ultisnips'}
    if user.settings.lsp ~= 'coc' then
        vim.g.UltiSnipsExpandTrigger = '<c-d>'
    end
end

return m

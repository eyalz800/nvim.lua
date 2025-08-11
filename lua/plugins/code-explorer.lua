local m = {}
local user = require 'user'
local explorer_winhls = {
    none = nil,
    ['edge-window'] = 'EndOfBuffer:NvimTreeEndOfBuffer,CursorLine:NvimTreeCursorLine,CursorLineNr:NvimTreeCursorLineNr,LineNr:NvimTreeLineNr,WinSeparator:NvimTreeWinSeparator,StatusLine:NvimTreeStatusLine,StatusLineNC:NvimTreeStatuslineNC,SignColumn:NvimTreeSignColumn,Normal:NvimTreeNormal,NormalNC:NvimTreeNormalNC,NormalFloat:NvimTreeNormalFloat,FloatBorder:NvimTreeNormalFloatBorder',
}
local explorer_winhl = explorer_winhls[user.settings.code_explorer_config.winhl or 'none']

local explorer = {}
if user.settings.code_explorer == 'tagbar' then
    explorer = require 'plugins.config.tagbar'
elseif user.settings.code_explorer == 'symbols-outline' then
    explorer = require 'plugins.config.symbols-outline'
else
    explorer.open = function(_) end
    explorer.close = function() end
    explorer.is_open = function() end
    explorer.toggle = function() end
end

m.setup = function()
    if user.settings.code_explorer == 'symbols-outline' then
        vim.api.nvim_create_autocmd('filetype', {
            pattern = 'Outline',
            group = vim.api.nvim_create_augroup('init.lua.code-explorer.symbols-outline', {}),
            callback = m.on_open
        })
    end
end

m.open = explorer.open
m.close = explorer.close
m.is_open = explorer.is_open
m.toggle = explorer.toggle
m.on_open = function()
    vim.opt_local.winhl = explorer_winhl
end

return m


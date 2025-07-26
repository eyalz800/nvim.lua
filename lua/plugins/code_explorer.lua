local m = {}
local user = require 'user'
local v = require 'vim'
local explorer_winhls = {
    none = nil,
    ['edge-window'] = 'WinSeparator:NvimTreeWinSeparator,Normal:NvimTreeNormal,SignColumn:NvimTreeSignColumn',
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

m.open = explorer.open
m.close = explorer.close
m.is_open = explorer.is_open
m.toggle = explorer.toggle
m.on_open = function()
    v.opt_local.winhl = explorer_winhl
end

return m


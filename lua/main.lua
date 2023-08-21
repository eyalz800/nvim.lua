local m = {}

local startup = function()
    require 'builtins.nested'
    require 'main.root_paths'
    require 'main.path'
    require 'main.basic'
    require 'main.plugin_manager'.create()
    require 'plugins'
    require 'main.mappings'
    require 'main.commands'
    require 'main.autocmd'
    require 'plugins.colors'.set()
end

if not require 'main.install'.installed() then
    require 'main.install'.install({ on_finish = startup })
else
    startup()
end

return m

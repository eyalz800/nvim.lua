local m = {}

local startup = function()
    require 'builtins.nested'.setup()
    require 'main.root_paths'.setup()
    require 'main.path'.setup()
    require 'main.basic'.setup()
    require 'main.plugin_manager'.create()
    require 'plugins'.setup()
    require 'main.mappings'.setup()
    require 'main.commands'.setup()
    require 'main.autocmd'.setup()
    require 'plugins.colors'.set()
end

if not require 'main.install'.installed() then
    require 'main.install'.setup({ on_finish = startup })
else
    startup()
end

return m

local m = {}
local user = require 'user'

if user.settings.debugger == 'vimspector' then
    return require 'plugins.config.vimspector'
else
    m.launch_settings = function() end
    m.launch = function() end
    m.continue = function() end
    m.restart = function() end
    m.pause = function() end
    m.stop = function() end
    m.breakpoint = function() end
    m.breakpoint_cond = function() end
    m.breakpoint_function = function() end
    m.clear_breakpoints = function() end
    m.step_over = function() end
    m.step_into = function() end
    m.step_out = function() end
    m.run_to_cursor = function() end
    m.disassemble = function() end
    m.eval_window = function() end
    m.reset = function() end
end

return m

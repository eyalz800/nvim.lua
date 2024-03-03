local m = {}
local v = require 'vim'

m.config = function()
    return {
        panel = {
            enabled = true,
            auto_refresh = true,
        },
        suggestion = {
            enabled = true,
            -- use the built-in keymapping for "accept" (<M-l>)
            auto_trigger = true,
            accept = false,         -- disable built-in keymapping
        },
    }
end

m.setup = function()
    -- hide copilot suggestions when cmp menu is open
    -- to prevent odd behavior/garbled up suggestions
    local cmp_status_ok, cmp = pcall(require, 'cmp')
    if cmp_status_ok then
        cmp.event:on('menu_opened', function()
            v.b.copilot_suggestion_hidden = true
        end)

        cmp.event:on('menu_closed', function()
            v.b.copilot_suggestion_hidden = false
        end)
    end
end

return m

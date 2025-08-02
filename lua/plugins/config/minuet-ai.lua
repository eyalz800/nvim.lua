local m = {}
local user = require 'user'

m.setup = function()
    require 'minuet'.setup(m.config())
end

m.config = function()
    return {
        provider = user.settings.minuet_config.provider or 'openai',
        provider_options = user.settings.minuet_config.provider_options,
        request_timeout = user.settings.minuet_config.request_timeout or 2.5,
        n_completions = user.settings.minuet_config.n_completions or 3,
        throttle = user.settings.minuet_config.throttle or nil, -- Increase to reduce costs and avoid rate limits
        debounce = user.settings.minuet_config.debounce or nil, -- Increase to reduce costs and avoid rate limits
        virtualtext = {
            auto_trigger_ft = user.settings.minuet_config.virtualtext_auto_ft or { '*' },
            auto_trigger_ignore_ft = {},
            keymap = {
                accept = '<C-l>',
                next = '<C-j>',
                prev = '<C-k>',
                dismiss = '<C-h>',

                accept_line = nil,
                accept_n_lines = nil,
            },
            show_on_completion_menu = true,
        },
        cmp = {
            enable_auto_complete = false,
        },
        blink = {
            enable_auto_complete = false,
        },
        lsp = {
            enabled_ft = {},
        },
        notify = false,
        proxy = nil,
    }
end

return m

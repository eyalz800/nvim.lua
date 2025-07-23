local m = {}
local user = require 'user'

m.config = function()
    return {
        provider = user.settings.minuet_config.provider or 'openai',
        provider_options = user.settings.minuet_config.provider_options,
        request_timeout = user.settings.minuet_config.request_timeout or 2.5,
        throttle = user.settings.minuet_config.throttle or 1500, -- Increase to reduce costs and avoid rate limits
        debounce = user.settings.minuet_config.debounce or 600, -- Increase to reduce costs and avoid rate limits
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
        show_on_completion_menu = true,
        notify = false,
        proxy = nil,

        default_system = {
            template = '...',
            prompt = '...',
            guidelines = '...',
            n_completion_template = '...',
        },
        default_system_prefix_first = {
            template = '...',
            prompt = '...',
            guidelines = '...',
            n_completion_template = '...',
        },
        default_fim_template = {
            prompt = '...',
            suffix = '...',
        },
        default_few_shots = { '...' },
        default_chat_input = { '...' },
        default_few_shots_prefix_first = { '...' },
        default_chat_input_prefix_first = { '...' },
    }
end

return m

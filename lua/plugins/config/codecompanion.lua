local m = {}
local user = require 'user'

m.setup = function()
    require 'codecompanion'.setup(m.config())
    require 'plugins.codecompanion-progress':init()
end

m.config = function()
    local adapters = user.settings.codecompanion_config.adapters or {}
    local interactions = user.settings.codecompanion_config.interactions or {}

    interactions.chat = interactions.chat or {}
    interactions.chat.keymaps = interactions.chat.keymaps or {}
    interactions.chat.keymaps.send = interactions.chat.keymaps.send or {
        modes = { n = { '<CR>', '<C-s>' }, i = '<C-s>' },
        index = 2,
        callback = function(chat)
            vim.cmd('stopinsert')
            chat:submit()
        end,
        description = '[Request] Send response',
    }

    interactions.inline = interactions.inline or {}

    if not interactions.inline.keymaps then
        interactions.inline.keymaps = {
            accept_change = {
                modes = { n = 'gra' },
                description = 'Accept the suggested change',
            },
            reject_change = {
                modes = { n = 'grd' },
                description = 'Reject the suggested change',
            },
        }
    end

    return {
        adapters = adapters,
        interactions = interactions,
        --opts = { log_level = 'TRACE' },
        display = {
            chat = {
                window = {
                    layout = 'vertical', -- float|vertical|horizontal|buffer
                    position = 'right', -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
                    border = "single",
                    height = 0.8,
                    width = 0.45,
                    relative = "editor",
                    full_height = false, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
                    opts = {
                        breakindent = true,
                        cursorcolumn = false,
                        cursorline = false,
                        foldcolumn = "0",
                        linebreak = true,
                        list = false,
                        numberwidth = 1,
                        signcolumn = "no",
                        spell = false,
                        wrap = user.settings.codecompanion_config.wrap or true,
                    },
                }
            },
        }
    }
end

return m

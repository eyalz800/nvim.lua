local m = {}
local user = require 'user'

m.config = function()
    return {
        adapters = user.settings.codecompanion_config.adapters,
        strategies = user.settings.codecompanion_config.strategies,
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
                        wrap = true,
                    },
                }
            }
        }
    }
end

m.setup = function()
    require 'plugins.codecompanion-fidget':init()
end

return m

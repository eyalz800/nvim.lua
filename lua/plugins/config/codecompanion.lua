local m = {}
local user = require 'user'

--- `<CR>|<C-s>` to send a message to the LLM
-- - `<C-c>` to close the chat buffer
-- - `q` to stop the current request
-- - `ga` to change the adapter for the currentchat
-- - `gc` to insert a codeblock in the chat buffer
-- - `gd` to view/debug the chat buffer’s contents
-- - `gf` to fold any codeblocks in the chat buffer
-- - `gp` to pin a reference to the chat buffer
-- - `gw` to watch a referenced buffer
-- - `gr` to regenerate the last response
-- - `gR` to go to the file under cursor. If the file is already opened, it’ll jump
--     to the existing window. Otherwise, it’ll be opened in a new tab.
-- - `gs` to toggle the system prompt on/off
-- - `gS` to show copilot usage stats
-- - `gta` to toggle auto tool mode
-- - `gx` to clear the chat buffer’s contents
-- - `gy` to yank the last codeblock in the chat buffer
-- - `[[` to move to the previous header
-- - `]]` to move to the next header
-- - `{` to move to the previous chat
-- - `}` to move to the next chat
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
            },
        }
    }
end

m.setup = function()
    require 'plugins.codecompanion-fidget':init()
end

return m

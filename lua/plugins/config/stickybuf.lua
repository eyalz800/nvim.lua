local m = {}
local v = require 'vim'

m.config = function()
    m.stickybuf = require 'stickybuf'
    local pin_filetypes = {
        'fugitiveblame',
        'NvimTree',
        'Outline',
    }

    return {
        get_auto_pin = function(bufnr)
            local buftype = v.bo[bufnr].buftype
            local filetype = v.bo[bufnr].filetype
            local bufname = v.api.nvim_buf_get_name(bufnr)
            if buftype == 'help' or buftype == 'quickfix' then
                return 'buftype'
            elseif buftype == 'prompt' or v.startswith(bufname, 'DAP ') then
                return 'bufnr'
            elseif v.tbl_contains(pin_filetypes, filetype) then
                return 'filetype'
            end
        end
    }
end

return m

local m = {}
m.setup = function()
    require 'stickybuf'.setup(m.config())
end

m.config = function()
    m.stickybuf = require 'stickybuf'
    local pin_filetypes = {
        'fugitiveblame',
        'NvimTree',
        'Outline',
    }

    return {
        get_auto_pin = function(bufnr)
            local buftype = vim.bo[bufnr].buftype
            local filetype = vim.bo[bufnr].filetype
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if buftype == 'help' or buftype == 'quickfix' then
                return 'buftype'
            elseif buftype == 'prompt' or vim.startswith(bufname, 'DAP ') then
                return 'bufnr'
            elseif vim.tbl_contains(pin_filetypes, filetype) then
                return 'filetype'
            end
        end
    }
end

return m

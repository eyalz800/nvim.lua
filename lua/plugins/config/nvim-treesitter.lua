local m = {}
local v = require 'vim'

m.config = function()
    return {
        ensure_installed = { 'c', 'cpp', 'lua', 'vim', 'vimdoc', 'python', 'query', 'gitcommit' },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            disable = function(lang, buf)
                local disabled_langs = {}
                if disabled_langs[lang] then
                    return true
                end

                local max_filesize = 10 * 1024 * 1024
                local ok, stats = pcall(v.loop.fs_stat, v.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            additional_vim_regex_highlighting = false,
        },
    }
end

return m

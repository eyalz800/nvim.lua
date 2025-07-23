local m = {}
local v = require 'vim'
local user = require 'user'

m.config = function()
    return {
        ensure_installed = { 'c', 'cpp', 'lua', 'vim', 'vimdoc', 'python', 'query', 'gitcommit', 'gitignore', 'gitattributes',
            'markdown', 'markdown_inline', 'make', 'cmake', 'ninja', 'json', 'asm', 'nasm', 'rust', 'xml', 'kconfig', 'diff', 'bash',
            'yaml', 'html', 'css', 'javascript', 'typescript', 'dockerfile', 'toml', 'go', 'java' },
        sync_install = false,
        auto_install = user.settings.treesitter_auto_install,
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

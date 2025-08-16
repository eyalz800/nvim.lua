local m = {}
local user = require 'user'

m.setup = function()
    require 'nvim-treesitter.configs'.setup(m.config())
end

m.config = function()
    return {
        ensure_installed = { 'c', 'cpp', 'lua', 'vim', 'vimdoc', 'python', 'query', 'gitcommit', 'gitignore', 'gitattributes',
            'markdown', 'markdown_inline', 'make', 'cmake', 'ninja', 'json', 'asm', 'nasm', 'rust', 'xml', 'ini', 'kconfig', 'diff', 'bash',
            'yaml', 'html', 'css', 'javascript', 'typescript', 'dockerfile', 'toml', 'go', 'java', 'latex', 'norg', 'scss', 'svelte', 'tsx',
            'typst', 'vue', 'regex',
        },
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
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            additional_vim_regex_highlighting = false,
        },
    }
end

return m

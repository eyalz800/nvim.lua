local m = {}
local v = require 'vim'
local fzf_lua = nil
local cmd = require 'vim.cmd'.silent

local expand = v.fn.expand

m.find_file = function()
    fzf_lua.files({
        cmd = 'rg --files --color=never --hidden -g "!.git"',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_file_hidden = function()
    fzf_lua.files({
        cmd = 'rg --files --no-ignore-vcs --color=never --hidden',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_file_list = function()
    fzf_lua.files({
        cmd = 'if [ -f .files ]; then cat .files; else rg --files --color=never --hidden -g "!.git" | tee .files; fi;',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_file_list_invalidate = function()
    fzf_lua.files({
        cmd = 'rm -rf .files; rg --files --color=never --hidden -g "!.git" | tee .files',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_file_list_hidden = function()
    fzf_lua.files({
        cmd = 'if [ -f .files ]; then cat .files; else rg --files --no-ignore-vcs --hidden | tee .files; fi;',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_file_list_hidden_invalidate = function()
    fzf_lua.files({
        cmd = 'rm -rf .files; rg --files --color=never --no-ignore-vcs --hidden | tee .files',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_line = function()
    if v.bo.filetype == 'qf' then
        cmd 'BLines'
    else
        fzf_lua.blines({
            fzf_colors = v.g.fzf_colors,
        })
    end
end

m.find_in_files = function()
    fzf_lua.grep_project({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_in_files_precise = function()
    fzf_lua.live_grep({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_in_files_precise_native = function()
    fzf_lua.live_grep_native({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_current_in_files = function()
    fzf_lua.grep_cword({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_current_in_files_precise = function()
    fzf_lua.live_grep({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        search = expand '<cword>',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_current_in_files_precise_native = function()
    fzf_lua.live_grep_native({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        search = expand '<cword>',
        fzf_colors = v.g.fzf_colors,
    })
end

m.find_buffer = function()
    fzf_lua.buffers({
        search = expand '<cword>',
        fzf_colors = v.g.fzf_colors,
    })
end

m.lsp_capable = true

m.lsp_definitions = function()
    fzf_lua.lsp_definitions({
        fzf_colors = v.g.fzf_colors,
    })
end

m.lsp_references = function()
    fzf_lua.lsp_references({
        fzf_colors = v.g.fzf_colors,
    })
end

m.lsp_diagnostics = function()
    fzf_lua.diagnostics_document({
        fzf_colors = v.g.fzf_colors,
    })
end

m.color_picker = function()
    fzf_lua.colorschemes({
        fzf_colors = v.g.fzf_colors,
        ignore_patterns   = { '^blue$', '^darkblue$', '^default$', '^delek$', '^desert$', '^elflord$', '^evening$', '^habamax$', '^industry$', '^koehler$', '^lunaperche$', '^morning$', '^murphy$', '^pablo$', '^peachpuff$', '^quiet$', '^retrobox$', '^ron$', '^shine$', '^slate$', '^sorbet$', '^torte$', '^wildcharm$', '^zaibatsu$', '^zellner$',
                              '^tokyonight$',
                              '^catppuccin$',
                            },
    })
end

m.custom_grep = function(command)
    fzf_lua.grep_project({
        cmd = command,
        fzf_colors = v.g.fzf_colors,
    })
end

m.keymaps = function()
    fzf_lua.keymaps({
        fzf_colors = v.g.fzf_colors,
    })
end

m.config = function()
    fzf_lua = require 'fzf-lua'
    return {}
end

return m


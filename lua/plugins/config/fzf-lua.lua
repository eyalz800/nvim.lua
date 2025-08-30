local m = {}
local fzf_lua = {}
local cmd = require 'vim.cmd'.silent

local expand = vim.fn.expand

m.setup = function()
    fzf_lua = require 'fzf-lua'
    fzf_lua.setup(m.config())
end

m.find_file = function(opts)
    opts = opts or {}
    fzf_lua.files({
        cwd = opts.cwd or nil,
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_file_rg = function(opts)
    opts = opts or {}
    fzf_lua.files({
        cmd = 'rg --files --color=never --hidden -g "!.git"',
        cwd = opts.cwd or nil,
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_file_hidden = function(opts)
    opts = opts or {}
    fzf_lua.files({
        hidden = true,
        no_ignore = false,
        cwd = opts.cwd or nil,
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_file_hidden_rg = function(opts)
    opts = opts or {}
    fzf_lua.files({
        cmd = 'rg --files --no-ignore-vcs --color=never --hidden',
        cwd = opts.cwd or nil,
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_file_list = function()
    fzf_lua.files({
        cmd = 'if [ -f .files ]; then cat .files; else rg --files --color=never --hidden -g "!.git" | tee .files; fi;',
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_file_list_invalidate = function()
    fzf_lua.files({
        cmd = 'rm -rf .files; rg --files --color=never --hidden -g "!.git" | tee .files',
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_file_list_hidden = function()
    fzf_lua.files({
        cmd = 'if [ -f .files ]; then cat .files; else rg --files --no-ignore-vcs --hidden | tee .files; fi;',
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_file_list_hidden_invalidate = function()
    fzf_lua.files({
        cmd = 'rm -rf .files; rg --files --color=never --no-ignore-vcs --hidden | tee .files',
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_line = function()
    if vim.bo.filetype == 'qf' then
        cmd 'BLines'
    else
        fzf_lua.blines({
            fzf_colors = vim.g.fzf_colors,
        })
    end
end

m.find_in_files = function(opts)
    opts = opts or {}
    fzf_lua.grep_project({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        cwd = opts.cwd or nil,
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_in_files_precise = function(opts)
    opts = opts or {}
    fzf_lua.live_grep({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        cwd = opts.cwd or nil,
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_in_files_precise_native = function(opts)
    opts = opts or {}
    fzf_lua.live_grep_native({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        cwd = opts.cwd or nil,
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_current_in_files = function()
    fzf_lua.grep_cword({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_current_in_files_precise = function()
    fzf_lua.live_grep({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        search = expand '<cword>',
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_current_in_files_precise_native = function()
    fzf_lua.live_grep_native({
        cmd = 'rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        search = expand '<cword>',
        fzf_colors = vim.g.fzf_colors,
    })
end

m.find_buffer = function()
    fzf_lua.buffers({
        fzf_colors = vim.g.fzf_colors,
    })
end

m.lsp_capable = true

m.lsp_definitions = function()
    fzf_lua.lsp_definitions({
        fzf_colors = vim.g.fzf_colors,
    })
end

m.lsp_references = function()
    fzf_lua.lsp_references({
        fzf_colors = vim.g.fzf_colors,
    })
end

m.lsp_diagnostics = function()
    fzf_lua.diagnostics_document({
        fzf_colors = vim.g.fzf_colors,
    })
end

m.color_picker = function()
    fzf_lua.colorschemes({
        fzf_colors = vim.g.fzf_colors,
        ignore_patterns = { '^blue$', '^darkblue$', '^default$', '^delek$', '^desert$', '^elflord$', '^evening$',
            '^habamax$', '^industry$', '^koehler$', '^lunaperche$', '^morning$', '^murphy$', '^pablo$', '^peachpuff$',
            '^quiet$', '^retrobox$', '^ron$', '^shine$', '^slate$', '^sorbet$', '^torte$', '^wildcharm$', '^zaibatsu$',
            '^zellner$', '^vim$', '^unokai$',
            '^tokyonight$',
            '^catppuccin$',
        },
    })
end

m.custom_grep = function(command)
    fzf_lua.grep_project({
        cmd = command,
        fzf_colors = vim.g.fzf_colors,
    })
end

m.keymaps = function()
    fzf_lua.keymaps({
        fzf_colors = vim.g.fzf_colors,
    })
end

m.browse_help = function()
    require 'fzf-lua'.help_tags ({
        fzf_colors = vim.g.fzf_colors,
        actions = {
            default = fzf_lua.actions.help_vert,
        },
    })
end

m.command_history = function()
    fzf_lua.command_history({
        fzf_colors = vim.g.fzf_colors,
    })
end

m.lsp_workspace_symbols = function()
    fzf_lua.lsp_workspace_symbols({
        fzf_colors = vim.g.fzf_colors,
    })
end

m.recent_files = function()
    fzf_lua.oldfiles({
        fzf_colors = vim.g.fzf_colors,
    })
end

m.config = function()
    return {
        previewers = {
            builtin = {
                snacks_image = {
                    render_inline = false,
                },
            },
        },
    }
end

return m


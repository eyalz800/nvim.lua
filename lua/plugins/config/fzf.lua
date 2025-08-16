local m = {}
local user = require 'user'
local sed = require 'lib.os-bin'.sed
local cmd = require 'vim.cmd'.silent

local expand = vim.fn.expand
local fnameescape = vim.fn.fnameescape

m.init = function()
    vim.g.fzf_layout = { window={width=0.9, height=0.85, border='sharp'} }
    vim.opt.rtp:append '~/.fzf'

    if user.settings.finder ~= 'fzf-lua' then
        vim.g.fzf_colors = {
            fg =      {'fg', 'Normal'},
            bg =      {'bg', 'Normal'},
            hl =      {'fg', 'SpecialKey'},
            ['fg+'] = {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
            ['bg+'] = {'bg', 'CursorLine', 'CursorColumn'},
            ['hl+'] = {'fg', 'String'},
            info =    {'fg', 'Comment'},
            border =  {'fg', 'Ignore'},
            prompt =  {'fg', 'StorageClass'},
            pointer = {'fg', 'Error'},
            marker =  {'fg', 'Keyword'},
            spinner = {'fg', 'Label'},
            header =  {'fg', 'Comment'}
        }
    end
end

m.find_file = function()
    vim.env.FZF_DEFAULT_COMMAND = 'rg --files'
    cmd 'Files'
end

m.find_file_hidden = function()
    vim.env.FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden'
    cmd 'Files'
end

m.find_file_list = function()
    vim.env.FZF_DEFAULT_COMMAND = 'if [ -f .files ]; then cat .files; else rg --files | tee .files; fi;'
    cmd 'Files'
end

m.find_file_list_invalidate = function()
    vim.env.FZF_DEFAULT_COMMAND = 'rm -rf .files ; rg --files | tee .files'
    cmd 'Files'
end

m.find_file_list_hidden = function()
    vim.env.FZF_DEFAULT_COMMAND = 'if [ -f .files ]; then cat .files; else rg --files --no-ignore-vcs --hidden | tee .files; fi;'
    cmd 'Files'
end

m.find_file_list_hidden_invalidate = function()
    vim.env.FZF_DEFAULT_COMMAND = 'rm -rf .files ; rg --files --no-ignore-vcs --hidden | tee .files'
    cmd 'Files'
end

m.find_line = function()
    vim.fn.Init_lua_lines_preview()
end

m.find_in_files = function()
    cmd 'Rg'
end

m.find_in_files_precise = function()
    m.rg(false)
end

m.find_in_files_precise_native = function()
    m.rg(false)
end

m.find_buffer = function()
    cmd 'Buffers'
end

m.color_picker = function()
    cmd 'Colors'
end

m.find_current_in_files = m.find_in_files
m.find_current_in_files_precise = m.find_in_files_precise
m.find_current_in_files_precise_native = m.find_in_files_precise_native

m.custom_grep = function(command, options)
    options = options or {}

    local fzf_color_option = vim.split(vim.fn["fzf#wrap"]()["options"], " ")[1]
    local fzf_opts = { options = fzf_color_option .. ' --prompt "> "' }
    if options.preview then
        fzf_opts = vim.fn['fzf#vim#with_preview'](fzf_opts)
    end

    return vim.fn['fzf#vim#grep'](command, 0, fzf_opts, 0)
end

m.keymaps = function() end

m.browse_help = function()
    cmd 'Helptags'
end

m.command_history = function()
    cmd 'Commands'
end

m.lsp_workspace_symbols = function() end

m.rg = function(fullscreen)
    local initial_command = 'rg --column --line-number --no-heading --color=always --smart-case . '
    local reload_command =
                  [=[ echo {q} | ]=] .. sed .. [=[ "s/^\(type:\)\([A-Za-z0-9]*\) */-t \2 /g" ]=] ..
                  [=[ | ]=] .. sed .. [=[ "s/^\(pattern:\)\([A-Za-z0-9*.]*\) */-g \"\2\" /g" ]=] ..
                  [=[ | ]=] .. sed .. [=[ "s/^\(-[gt] *[A-Za-z0-9*.\"]* \)\\?\(.*\)/\1\"\2\"/g" ]=] ..
                  [=[ | xargs rg --column --line-number --no-heading --color=always --smart-case || true ]=]

    local spec = {options = {'--phony', '--bind', 'change:reload:' .. reload_command}}
    vim.fn['fzf#vim#grep'](initial_command, 1, vim.fn['fzf#vim#with_preview'](spec), fullscreen)
end

m.lines_preview = function()
    if not vim.loop.fs_stat(expand('%')) or vim.b.objdump_view or vim.b.binary_mode then
        cmd 'BLines'
    else
        vim.fn['fzf#vim#grep'](
            'rg --with-filename --column --line-number --no-heading --smart-case . ' .. fnameescape(expand('%:p')),
            1,
            vim.fn['fzf#vim#with_preview'](
                {
                    options = '--keep-right --delimiter : --nth 4.. --preview "bat -p --color always {}"' ..
                    ' --bind "ctrl-/:toggle-preview"'
                },
                'right:50%'
            )
        )
    end
end

return m

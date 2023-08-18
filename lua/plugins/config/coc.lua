local m = {}
local v = require 'vim'
local user = require 'user'
local cmd = require 'vim.cmd'.silent

local enabled = true
local settings = user.settings.lsp_config.coc or {}

v.g.coc_global_extensions = settings.plugins or {}

local check_back_space = function()
    local col = v.fn.col('.') - 1
    return col == 0 or v.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

m.show_documentation = function()
    local cw = v.fn.expand('<cword>')
    if v.fn.index({'v', 'help'}, v.bo.filetype) >= 0 then
        v.api.nvim_command('h ' .. cw)
    elseif v.api.nvim_eval('coc#rpc#ready()') then
        v.fn.CocActionAsync('doHover')
    else
        v.api.nvim_command('!' .. v.o.keywordprg .. ' ' .. cw)
    end
end

m.goto_definition = function() v.fn.Init_lua_lsp_jump('Definition') end
m.goto_definition_sync = function() v.fn.CocAction('jumpDefinition') end
m.show_references = function() v.fn.Init_lua_lsp_jump('References') end
m.code_action = '<plug>(coc-codeaction-cursor)'
m.quick_fix = '<plug>(coc-fix-current)'
m.type_definition = '<plug>(coc-type-definition)'
m.switch_source_header = function() cmd 'CocCommand clangd.switchSourceHeader' end
m.prev_diagnostic = '<plug>(coc-diagnostic-prev)'
m.next_diagnostic = '<plug>(coc-diagnostic-next)'
m.rename = '<plug>(coc-rename)'
m.format_selected = '<plug>(coc-format-selected)'
m.expand_snippets = '<plug>(coc-snippets-expand)'
m.select_snippets = '<plug>(coc-snippets-select)'
m.list_diagnostics = function() cmd 'CocDiagnostics' end

m.is_enabled = function() return enabled end
m.enable = function()
    cmd 'CocEnable'
    enabled = true
end
m.disable = function()
    cmd 'CocDisable'
    enabled = false
end

m.tab = function()
    if v.fn['coc#pum#visible']() ~= 0 then
        return v.fn['coc#pum#next'](1)
    end
    if not settings.tab_trigger or check_back_space() then
        return "<tab>"
    end
    return v.fn['coc#refresh']()
end
m.shift_tab = function()
    if v.fn['coc#pum#visible']() ~= 0 then
        return v.fn['coc#pum#prev'](1)
    end
    return '<s-tab>'
end
m.enter = function()
    return '<c-g>u<cr><c-r>=coc#on_enter()<cr>'
end

v.g.tagfunc = 'CocTagFunc'
v.g.coc_fzf_preview = 'right:50%'

v.cmd [=[

function! Init_lua_lsp_jump(jump_type)
    if a:jump_type == 'definition'
        let jump_type = 'Definition'
    else
        let jump_type = a:jump_type
    endif
    if CocActionAsync('jump' . jump_type)
        return 1
    endif
    return 0
endfunction

]=]

return m

local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'

m.configure = function()
    if v.o.background == 'light' then
        v.opt.background = 'dark'
        v.schedule(function() cmd 'color codedark' end)
        return false
    end

    v.env.BAT_THEME = 'Monokai Extended Origin'

    v.cmd [=[
        " Terminal ansi colors
        let g:terminal_color_0 = '#1e1e1e'
        let g:terminal_color_1 = '#f44747'
        let g:terminal_color_2 = '#6a9955'
        let g:terminal_color_3 = '#ffaf00'
        let g:terminal_color_4 = '#0a7aca'
        let g:terminal_color_5 = '#c586c0'
        let g:terminal_color_6 = '#4ec9b0'
        let g:terminal_color_7 = '#d4d4d4'
        let g:terminal_color_8 = '#303030'
        let g:terminal_color_9 = '#d16969'
        let g:terminal_color_10 = '#6a9955'
        let g:terminal_color_11 = '#ce9178'
        let g:terminal_color_12 = '#569cd6'
        let g:terminal_color_13 = '#c586c0'
        let g:terminal_color_14 = '#4ec9b0'
        let g:terminal_color_15 = '#51504f'

        let s:cterm00 = "00"
        let s:cterm03 = "08"
        let s:cterm05 = "07"
        let s:cterm07 = "15"
        let s:cterm08 = "01"
        let s:cterm0A = "03"
        let s:cterm0B = "02"
        let s:cterm0C = "06"
        let s:cterm0D = "04"
        let s:cterm0E = "05"
        if exists('base16colorspace') && base16colorspace == "256"
          let s:cterm01 = "18"
          let s:cterm02 = "19"
          let s:cterm04 = "20"
          let s:cterm06 = "21"
          let s:cterm09 = "16"
          let s:cterm0F = "17"
        else
          let s:cterm01 = "00"
          let s:cterm02 = "08"
          let s:cterm04 = "07"
          let s:cterm06 = "07"
          let s:cterm09 = "06"
          let s:cterm0F = "03"
        endif

        function! Init_lua_codedark_highlight(group, fg, bg, attr, sp)
            if !empty(a:fg)
                exec "hi " . a:group . " guifg=" . a:fg.gui . " ctermfg=" . (g:codedark_term256 ? a:fg.cterm256 : a:fg.cterm)
            endif
            if !empty(a:bg)
                exec "hi " . a:group . " guibg=" . a:bg.gui . " ctermbg=" . (g:codedark_term256 ? a:bg.cterm256 : a:bg.cterm)
            endif
            if a:attr != ""
                exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
            endif
            if !empty(a:sp)
                exec "hi " . a:group . " guisp=" . a:sp.gui
            endif
        endfunction

        let s:cdBack = {'gui': '#1E1E1E', 'cterm': s:cterm00, 'cterm265': '234'}
        let s:cdLightBlue = {'gui': '#9CDCFE', 'cterm': s:cterm0C, 'cterm256': '117'}
        let s:cdMidBlue = {'gui': '#519aba', 'cterm': s:cterm0D, 'cterm256': '75'}
        let s:cdBlue = {'gui': '#569CD6', 'cterm': s:cterm0D, 'cterm256': '75'}
        let s:cdDarkBlue = {'gui': '#223E55', 'cterm': s:cterm0D, 'cterm256': '73'}
        let s:cdYellow = {'gui': '#DCDCAA', 'cterm': s:cterm0A, 'cterm256': '187'}
        let s:cdYellowOrange = {'gui': '#D7BA7D', 'cterm': s:cterm0A, 'cterm256': '179'}
        let s:cdPink = {'gui': '#C586C0', 'cterm': s:cterm0E, 'cterm256': '176'}
        let s:cdBlueGreen = {'gui': '#4EC9B0', 'cterm': s:cterm0F, 'cterm256': '43'}
        let s:cdGreen = {'gui': '#6A9955', 'cterm': s:cterm0B, 'cterm256': '65'}
        let s:cdLightGreen = {'gui': '#B5CEA8', 'cterm': s:cterm09, 'cterm256': '151'}
        let s:cdOrange = {'gui': '#CE9178', 'cterm': s:cterm0F, 'cterm256': '173'}
        let s:cdVividOrange = {'gui': '#FFAF00', 'cterm': s:cterm0A, 'cterm256': '214'}
        let s:cdLightRed = {'gui': '#D16969', 'cterm': s:cterm08, 'cterm256': '167'}
        let s:cdRed = {'gui': '#F44747', 'cterm': s:cterm08, 'cterm256': '203'}
        let s:cdViolet = {'gui': '#646695', 'cterm': s:cterm04, 'cterm256': '60'}
        let s:cdVividBlue = {'gui': '#0A7ACA', 'cterm': s:cterm0D, 'cterm256': '32'}
        let s:cdFront = {'gui': '#D4D4D4', 'cterm': s:cterm05, 'cterm256': '188'}
        let s:cdWhite = {'gui': '#FFFFFF', 'cterm':  s:cterm07, 'cterm256': '15'}

        let s:cdIconGreyOrTermFront = {'gui': '#6d8086', 'cterm': s:cterm05, 'cterm256': '188'}
        let s:cdIconYellowOrTermFront = {'gui': '#cbcb41', 'cterm': s:cterm05, 'cterm256': '188'}

        " Codedark colors defined
        let s:codedark_colors_defined = 1

        " C++
        call Init_lua_codedark_highlight('cCustomAccessKey', s:cdBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('cppModifier', s:cdBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('cppExceptions', s:cdBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('cOperator', s:cdBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('cppStatement', s:cdBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('cppSTLType', s:cdBlueGreen, {}, 'none', {})
        call Init_lua_codedark_highlight('cppSTLnamespace', s:cdBlueGreen, {}, 'none', {})
        call Init_lua_codedark_highlight('cCustomClassName', s:cdBlueGreen, {}, 'none', {})
        call Init_lua_codedark_highlight('cCustomClass', s:cdBlueGreen, {}, 'none', {})
        call Init_lua_codedark_highlight('cppSTLexception', s:cdBlueGreen, {}, 'none', {})
        call Init_lua_codedark_highlight('cppSTLconstant', s:cdLightBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('cppSTLvariable', s:cdLightBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('cCustomMemVar', s:cdLightBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('cppSTLfunction', s:cdYellow, {}, 'none', {})
        call Init_lua_codedark_highlight('cCustomOperator', s:cdYellow, {}, 'none', {})
        call Init_lua_codedark_highlight('cConstant', s:cdPink, {}, 'none', {})
        call Init_lua_codedark_highlight('cppNew', s:cdPink, {}, 'none', {})
        call Init_lua_codedark_highlight('cppDelete', s:cdPink, {}, 'none', {})
        call Init_lua_codedark_highlight('cppUsing', s:cdPink, {}, 'none', {})
        "call Init_lua_codedark_highlight('cRepeat', s:cdPink, {}, 'none', {})
        "call Init_lua_codedark_highlight('cConditional', s:cdPink, {}, 'none', {})
        "call Init_lua_codedark_highlight('cStatement', s:cdPink, {}, 'none', {})

        " Python
        call Init_lua_codedark_highlight('pythonBuiltin', s:cdBlueGreen, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonExceptions', s:cdBlueGreen, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonBuiltinObj', s:cdLightBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonRepeat', s:cdPink, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonConditional', s:cdPink, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonException', s:cdPink, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonInclude', s:cdPink, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonImport', s:cdPink, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonStatement', s:cdPink, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonOperator', s:cdBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonDef', s:cdBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonLambda', s:cdBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonFunction', s:cdYellow, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonDecorator', s:cdYellow, {}, 'none', {})
        call Init_lua_codedark_highlight('pythonBuiltinFunc', s:cdYellow, {}, 'none', {})

        " Gitgutter
        call Init_lua_codedark_highlight('GitGutterAdd', s:cdGreen, {}, 'none', {})
        call Init_lua_codedark_highlight('GitGutterChange', s:cdFront, {}, 'none', {})
        call Init_lua_codedark_highlight('GitGutterDelete', s:cdRed, {}, 'none', {})

        " NERDTree
        call Init_lua_codedark_highlight('NERDTreeOpenable', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('NERDTreeClosable', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('NERDTreeHelp', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('NERDTreeDir', s:cdFront, {}, 'none', {})
        call Init_lua_codedark_highlight('NERDTreeUp', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('NERDTreeDirSlash', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('NERDTreeFile', s:cdFront, {}, 'none', {})
        call Init_lua_codedark_highlight('NERDTreeExecFile', s:cdFront, {}, 'none', {})
        call Init_lua_codedark_highlight('NERDTreeLinkFile', s:cdBlueGreen, {}, 'none', {})
        call Init_lua_codedark_highlight('NERDTreeCWD', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('NERDTreeFlags', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('WebDevIconsDefaultFolderSymbol', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('WebDevIconsDefaultOpenFolderSymbol', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('nerdtreeExactMatchIcon_makefile', s:cdIconGreyOrTermFront, {}, 'none', {})
        call Init_lua_codedark_highlight('nerdtreeExactMatchIcon_license', s:cdIconYellowOrTermFront, {}, 'none', {})
        call Init_lua_codedark_highlight('nerdtreeFileExtensionIcon_json', s:cdIconYellowOrTermFront, {}, 'none', {})
        call Init_lua_codedark_highlight('nerdtreeFileExtensionIcon_h', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('nerdtreeFileExtensionIcon_c', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('nerdtreeFileExtensionIcon_cpp', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('nerdtreeFileExtensionIcon_py', s:cdMidBlue, {}, 'none', {})
        let g:NERDTreeExtensionHighlightColor = {}
        let g:NERDTreeExtensionHighlightColor['json'] = ''
        let g:NERDTreeExtensionHighlightColor['h'] = ''
        let g:NERDTreeExtensionHighlightColor['c'] = ''
        let g:NERDTreeExtensionHighlightColor['cpp'] = ''
        let g:NERDTreeExtensionHighlightColor['py'] = ''

        " Tagbar
        call Init_lua_codedark_highlight('TagbarFoldIcon', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('TagbarKind', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('TagbarScope', s:cdMidBlue, {}, 'none', {})
        call Init_lua_codedark_highlight('TagbarSignature', s:cdFront, {}, 'none', {})
        call Init_lua_codedark_highlight('TagbarHelp', s:cdMidBlue, {}, 'none', {})

        " Vim
        call Init_lua_codedark_highlight('VimOperError', s:cdRed, {}, 'none', {})
        call Init_lua_codedark_highlight('vimFunction', s:cdYellow, {}, 'none', {})

        " Json
        call Init_lua_codedark_highlight('jsonCommentError', s:cdGreen, {}, 'none', {})
        call Init_lua_codedark_highlight('jsonString', s:cdOrange, {}, 'none', {})
        call Init_lua_codedark_highlight('jsonNumber', s:cdLightGreen, {}, 'none', {})

        " Yaml
        call Init_lua_codedark_highlight('yamlBlockCollectionItemStart', s:cdFront, {}, 'none', {})
        call Init_lua_codedark_highlight('yamlKeyValueDelimiter', s:cdFront, {}, 'none', {})
        call Init_lua_codedark_highlight('yamlPlainScalar', s:cdOrange, {}, 'none', {})
        call Init_lua_codedark_highlight('yamlBlockMappingKey', s:cdLightBlue, {}, 'none', {})

        " Plant Uml
        call Init_lua_codedark_highlight('plantumlPreviewMethodCallParen', s:cdFront, {}, 'none', {})
        call Init_lua_codedark_highlight('plantumlPreviewMethodCall', s:cdYellow, {}, 'none', {})

        " Cursor line
        highlight CursorLine ctermbg=235 guibg=#262626

        " Sign Column
        highlight SignColumn guifg=#bbbbbb guibg=NONE
    ]=]

    if user.settings.finder == 'fzf' then
        v.g.fzf_colors = {
            fg = { 'fg', 'Normal' },
            bg = { 'bg', 'Normal' },
            hl = { 'fg', 'SpecialKey' },
            ['fg+'] = { 'fg', 'CursorLine', 'CursorColumn', 'Normal' },
            ['bg+'] = { 'bg', 'CursorLine', 'CursorColumn' },
            ['hl+'] = { 'fg', 'String' },
            info = { 'fg', 'Comment' },
            border = { 'fg', 'CursorLine' },
            prompt = { 'fg', 'StorageClass' },
            pointer = { 'fg', 'Error' },
            marker = { 'fg', 'Keyword' },
            spinner = { 'fg', 'Label' },
            header = { 'fg', 'Comment' }
        }
    end

    if user.settings.status_line == 'airline' then
        v.cmd [=[
            function! Init_lua_codedark_airline_theme_patch(palette)
                if g:airline_theme != 'codedark'
                    return
                endif

                let airline_error = ['#FFFFFF', '#F44747', 0, 0]
                let airline_warning = ['#FFFFFF', '#F44747', 0, 0]

                let a:palette.normal.airline_warning = airline_warning
                let a:palette.normal.airline_error = airline_error
                let a:palette.normal_modified.airline_warning = airline_warning
                let a:palette.normal_modified.airline_error = airline_error
                let a:palette.insert.airline_warning = airline_warning
                let a:palette.insert.airline_error = airline_error
                let a:palette.insert_modified.airline_warning = airline_warning
                let a:palette.insert_modified.airline_error = airline_error
                let a:palette.replace.airline_warning = airline_warning
                let a:palette.replace.airline_error = airline_error
                let a:palette.replace_modified.airline_warning = airline_warning
                let a:palette.replace_modified.airline_error = airline_error
                let a:palette.visual.airline_warning = airline_warning
                let a:palette.visual.airline_error = airline_error
                let a:palette.visual_modified.airline_warning = airline_warning
                let a:palette.visual_modified.airline_error = airline_error
                let a:palette.inactive.airline_warning = airline_warning
                let a:palette.inactive.airline_error = airline_error
                let a:palette.inactive_modified.airline_warning = airline_warning
                let a:palette.inactive_modified.airline_error = airline_error
            endfunction
        ]=]
        v.g.airline_theme_patch_func = 'Init_lua_codedark_airline_theme_patch'
    end

    return true
end

return m

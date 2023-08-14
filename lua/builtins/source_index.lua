local m = {}
local v = require 'vim'

local async_cmd = require 'builtins.async_cmd'.async_cmd
local cmd = require 'vim.cmd'.silent
local expand = v.fn.expand
local sed = require 'lib.os_bin'.sed

local ctags_file_patterns = '-g "*.c" -g "*.cc" -g "*.cpp" -g "*.cxx" -g "*.h" -g "*.hh" -g "*.hpp"'
local other_file_patterns = '-g "*.py" -g "*.te" -g "*.S" -g "*.asm" -g "*.mk" -g "*.md" -g "makefile" -g "Makefile"'
local source_file_patterns = '-g "*.c" -g "*.cc" -g "*.cpp" -g "*.cxx" -g "*.h" -g "*.hh" -g "*.hpp" -g "*.py" -g "*.go" -g "*.java" -g "*.cs" -g "*.te" -g "*.S" -g "*.asm" -g "*.mk" -g "*.md" -g "makefile" -g "Makefile"'
local ctags_everything_options = '--c++-kinds=+p --fields=+iaSn --extra=+q --sort=foldcase --tag-relative --recurse=yes'
local ctags_options = '--languages=C,C++ --c++-kinds=+p --fields=+iaSn --extra=+q --sort=foldcase --tag-relative --recurse=yes'
local opengrok_file_patterns = "-I '*.cpp' -I '*.c' -I '*.cc' -I '*.cxx' -I '*.h' -I '*.hh' -I '*.hpp' -I '*.S' -I '*.s' -I '*.asm' -I '*.py' -I '*.go' -I '*.java' -I '*.cs' -I '*.mk' -I '*.te' -I makefile -I Makefile"
local opengrok_jar = expand('~/.vim/bin/opengrok/lib/opengrok.jar')
local opengrok_ctags = '~/.vim/bin/ctags-exuberant/ctags/ctags'
local generate_files_command = 'rg --files ' ..
    ctags_file_patterns ..
    ' > cscope.files && if ! [ -f .files ]; then cp cscope.files .files && rg --files ' ..
    other_file_patterns .. ' >> .files'
local generate_cpp_command = 'cscope -bq'
local generate_opengrok_command = 'java -Xmx2048m -jar ' .. opengrok_jar .. ' -q -c ' ..
        opengrok_ctags .. ' -s . -d .opengrok ' .. opengrok_file_patterns .. ' -P -S -G -W .opengrok/configuration.xml'
local generate_tags_command = 'echo ' .. ctags_options .. ' > .gutctags && ' .. sed .. " -i 's/ /\\n/g' .gutctags && ctags " .. ctags_options
local generate_all_tags_command = 'echo ' .. ctags_everything_options .. ' > .gutctags && ' .. sed .. " -i 's/ /\\n/g' .gutctags && ctags " .. ctags_options

m.generate_cpp = function()
    async_cmd(generate_files_command .. ' && ' .. generate_cpp_command, { visible=true })
end

m.generate_tags = function()
    async_cmd(generate_tags_command, { visible=true })
end

m.generate_all_tags = function()
    async_cmd(generate_all_tags_command, { visible=true })
end

m.generate_opengrok = function()
    async_cmd(generate_files_command .. ' && ' .. generate_opengrok_command, { visible=true })
end

m.generate_cpp_and_opengrok = function()
    async_cmd(generate_files_command .. ' && ' .. generate_cpp_command .. ' && ' .. generate_opengrok_command, { visible=true })
end

m.generate_source_files_list = function()
    async_cmd('rg --files ' .. source_file_patterns .. ' > .files', { visible=true })
end

m.generate_all_files_list = function()
    async_cmd('rg --files --no-ignore-vcs --hidden  > .files', { visible=true })
end

m.goto_symbol_definition = function()
    cmd('call Init_lua_goto_symbol(' .. expand('<cword>') .. '"definition")')
end

m.goto_symbol_declaration = function()
    cmd('call Init_lua_goto_symbol(' .. expand('<cword>') .. '"declaration")')
end

m.goto_symbol_definition_input = function()
    cmd('call Init_lua_goto_symbol_input("definition")')
end

m.goto_symbol_declaration_input = function()
    cmd('call Init_lua_goto_symbol_input("declaration")')
end

m.goto_definition = function()
    cmd('call Init_lua_goto_definition()')
end

-- TODO: Remove mappings

v.cmd [=[

" Tag stack {{{
" nnoremap <silent> <leader>o :pop<CR>
" nnoremap <silent> <leader>i :tag<CR>

function! Init_lua_tagstack_push_current(name)
    return Init_lua_tagstack_push(a:name, getcurpos(), bufnr())
endfunction

function! Init_lua_tagstack_push(name, pos, buf)
    let curpos = a:pos
    let curpos[0] = a:buf
    let item = {'tagname': a:name, 'from': curpos}
    let tagstack = gettagstack()
    let curidx = tagstack['curidx']

    if curidx == (tagstack['length'] + 1)
        call add(tagstack['items'], item)
        let tagstack['length'] = curidx
    else
        let tagstack['items'][curidx - 1] = item
    endif
    let tagstack['curidx'] = curidx + 1

    call settagstack(winnr(), tagstack, 'r')
endfunction

" Go to definition {{{
"nnoremap <silent> gs :call Init_lua_goto_symbol(expand('<cword>'), 'definition')<CR>
"nnoremap <silent> gS :call Init_lua_goto_symbol(expand('<cword>'), 'declaration')<CR>
"nnoremap <silent> <leader>zd :call Init_lua_goto_symbol(expand('<cword>'), 'definition')<CR>
"nnoremap <silent> <leader>zD :call Init_lua_goto_symbol(expand('<cword>'), 'declaration')<CR>
"nnoremap <silent> <leader>gs :call Init_lua_goto_symbol_input('definition')<CR>
"nnoremap <silent> <leader>gS :call Init_lua_goto_symbol_input('declaration')<CR>
"nnoremap <silent> <leader><leader>zd :call Init_lua_goto_symbol_input('definition')<CR>
"nnoremap <silent> <leader><leader>zD :call Init_lua_goto_symbol_input('declaration')<CR>
"nnoremap <silent> gz :call Init_lua_goto_definition()<CR>
"nnoremap <silent> <leader>zg :call Init_lua_goto_definition()<CR>

function! Init_lua_goto_symbol_input(type)
    call inputsave()
    let symbol = input('Symbol: ')
    call inputrestore()
    normal :<ESC>
    call Init_lua_goto_symbol(symbol, a:type)
endfunction

function! Init_lua_goto_definition()
    if g:lsp_jump_function && Init_lua_lsp_jump('definition')
        return 1
    endif
    return Init_lua_goto_symbol(expand('<cword>'), 'definition')
endfunction

function! Init_lua_fzf_string_preview(string)
    let name = expand('<cword>')
    let pos = getcurpos()
    let buf = bufnr()

    let result = fzf#vim#grep('echo -e ' . shellescape(a:string),
        \ 0, fzf#vim#with_preview({ 'options': split(fzf#wrap()['options'])[0] . ' --prompt "> "'}), 0)

    if len(result) != 0
        if buf == bufnr() && pos[1] == getcurpos()[1]
            return 1
        endif
        call Init_lua_tagstack_push(name, pos, buf)
        return 1
    endif
    return 0
endfunction

function! Init_lua_goto_symbol(symbol, type)
    if a:symbol == ''
        echom "Empty symbol!"
        return 0
    endif

    let overall_limit = 2000
    let limit = 200
    let ctags_tag_types = []
    let opengrok_query_type = 'f'
    let cscope_query_type = '0'
    let file_line_separator = ': '
    if a:type == 'definition'
        let ctags_tag_types = ['f', 'c', 's', 't', 'd', 'm', 'e', 'g', 'v']
        let opengrok_query_type = 'd'
    elseif a:type == 'declaration'
        let ctags_tag_types = ['p', 'd']
        let opengrok_query_type = 'f'
    endif

    " CScope
    if filereadable('cscope.out')
        let awk_program =
            \    '{ x = $1; $1 = ""; z = $3; $3 = ""; ' .
            \    'printf "%s:%s:%s\n", x,z,$0; }'
        let cscope_command =
            \    'cscope -dL' . cscope_query_type . " " . shellescape(a:symbol) .
            \    " | awk '" . awk_program . "'"
        let results = split(system(cscope_command), '\n')

        if len(results) <= overall_limit
            let files_to_results = {}

            for result in results
                let file_line = split(trim(split(result, file_line_separator)[0]), ':')
                if has_key(files_to_results, file_line[0])
                    call add(files_to_results[file_line[0]][0], file_line[1])
                    call add(files_to_results[file_line[0]][1], result)
                else
                    let files_to_results[file_line[0]] = [[file_line[1]], [result]]
                endif
            endfor

            if len(files_to_results) <= limit
                let valid_results = []
                let valid_jumps = []

                for [file_path, file_results] in items(files_to_results)
                    let [file_lines, results] = file_results
                    for [target_line, target_column] in Init_lua_get_target_symbol_jump_if_ctag_type(a:symbol, file_path, file_lines, ctags_tag_types)
                        call add(valid_jumps, [file_path, target_line, target_column])
                        call add(valid_results, results[index(file_lines, target_line)])
                    endfor
                endfor

                if len(valid_jumps) == 1
                    call Init_lua_tagstack_push_current(a:symbol)
                    call Init_lua_jump_to_location(valid_jumps[0][0], valid_jumps[0][1], valid_jumps[0][2])
                    return 1
                elseif len(valid_jumps) > 1
                    return Init_lua_fzf_string_preview(join(valid_results, '\r\n'))
                endif
            endif
        endif

        if !filereadable('.opengrok/configuration.xml') || !filereadable(g:opengrok_jar)
            return Init_lua_cscope(cscope_query_type, a:symbol, 1)
        endif
    endif

    " Opengrok
    if filereadable('.opengrok/configuration.xml') && filereadable(g:opengrok_jar)
        let awk_program =
            \    '{ x = $1; $1 = ""; z = $3; $3 = ""; ' .
            \    'printf "%s:%s:%s\n", x,z,$0; }'
        let opengrok_command =
            \    "java -Xmx2048m -cp ~/.vim/bin/opengrok/lib/opengrok.jar org.opensolaris.opengrok.search.Search -R .opengrok/configuration.xml -" .
            \    opengrok_query_type . " " . shellescape(a:symbol) . "| grep \"^/.*\" | " . s:sed . " 's@</\\?.>@@g' | " . s:sed . " 's/&amp;/\\&/g' | " . s:sed . " 's/-\&gt;/->/g'" .
            \    " | awk '" . awk_program . "'"

        let results = split(system(opengrok_command), '\n')
        if len(results) > overall_limit
            return Init_lua_og_query(opengrok_query_type, a:symbol, 1)
        endif

        let files_to_results = {}

        for result in results
            let file_line = split(trim(split(result, file_line_separator)[0]), ':')
            if has_key(files_to_results, file_line[0])
                call add(files_to_results[file_line[0]][0], file_line[1])
                call add(files_to_results[file_line[0]][1], result)
            else
                let files_to_results[file_line[0]] = [[file_line[1]], [result]]
            endif
        endfor

        if len(files_to_results) > limit
            return Init_lua_og_query(opengrok_query_type, a:symbol, 1)
        endif

        let valid_results = []
        let valid_jumps = []

        for [file_path, file_results] in items(files_to_results)
            let [file_lines, results] = file_results
            for [target_line, target_column] in Init_lua_get_target_symbol_jump_if_ctag_type(a:symbol, file_path, file_lines, ctags_tag_types)
                call add(valid_jumps, [file_path, target_line, target_column])
                call add(valid_results, results[index(file_lines, target_line)])
            endfor
        endfor

        if len(valid_jumps) == 1
            call Init_lua_tagstack_push_current(a:symbol)
            call Init_lua_jump_to_location(valid_jumps[0][0], valid_jumps[0][1], valid_jumps[0][2])
            return 1
        elseif len(valid_jumps) > 1
            return Init_lua_fzf_string_preview(join(valid_results, '\r\n'))
        endif
    endif

    echom "Could not find " . a:type . " of '" . a:symbol . "'"
    return 0
endfunction

function! Init_lua_get_target_symbol_jump_if_ctag_type(symbol, file, lines, ctags_tag_types)
    let ctags = split(system("ctags -o - " . g:ctagsEverythingOptions . " " . shellescape(a:file)
        \ . " 2>/dev/null | rg " . shellescape(a:symbol)), '\n')
    let lines_and_columns = []
    for ctag in ctags
        let ctag = split(ctag, '\t')
        let ctag_field_name = ctag[0]
        if ctag_field_name != a:symbol
            continue
        endif
        let ctag_field_type = ''
        let ctag_field_line = ''
        let ctag_field_column = 0
        for ctag_field in ctag
            if ctag_field_type == '' && len(ctag_field) == 1
                let ctag_field_type = ctag_field
            elseif ctag_field_line == '' && stridx(ctag_field, 'line:') == 0
                let ctag_field_line = split(ctag_field, ':')[1]
            elseif ctag_field_column == 0 && stridx(ctag_field, '/^') == 0 && stridx(ctag_field, a:symbol) != -1
                let ctag_field_column = stridx(ctag_field, a:symbol) - 1
            endif
        endfor

        if index(a:ctags_tag_types, ctag_field_type) != -1 && ctag_field_line != '' && index(a:lines, ctag_field_line) != -1
            call add(lines_and_columns, [ctag_field_line, ctag_field_column])
        endif
    endfor
    return lines_and_columns
endfunction
" }}}

" Cscope {{{
nnoremap <silent> <leader>cA :call Init_lua_cscope('9', expand('<cword>'), 0)<CR>
nnoremap <silent> <leader>cC :call Init_lua_cscope('3', expand('<cword>'), 0)<CR>
nnoremap <silent> <leader>cD :call Init_lua_cscope('2', expand('<cword>'), 0)<CR>
nnoremap <silent> <leader>cE :call Init_lua_cscope('6', expand('<cword>'), 0)<CR>
nnoremap <silent> <leader>cF :call Init_lua_cscope('7', expand('<cword>'), 0)<CR>
nnoremap <silent> <leader>cG :call Init_lua_cscope('1', expand('<cword>'), 0)<CR>
nnoremap <silent> <leader>cI :call Init_lua_cscope('8', expand('<cword>'), 0)<CR>
nnoremap <silent> <leader>cS :call Init_lua_cscope('0', expand('<cword>'), 0)<CR>
nnoremap <silent> <leader>cT :call Init_lua_cscope('4', expand('<cword>'), 0)<CR>
nnoremap <silent> <leader><leader>fA :call Init_lua_cscope_query('9', 0)<CR>
nnoremap <silent> <leader><leader>fC :call Init_lua_cscope_query('3', 0)<CR>
nnoremap <silent> <leader><leader>fD :call Init_lua_cscope_query('2', 0)<CR>
nnoremap <silent> <leader><leader>fE :call Init_lua_cscope_query('6', 0)<CR>
nnoremap <silent> <leader><leader>fF :call Init_lua_cscope_query('7', 0)<CR>
nnoremap <silent> <leader><leader>fG :call Init_lua_cscope_query('1', 0)<CR>
nnoremap <silent> <leader><leader>fI :call Init_lua_cscope_query('8', 0)<CR>
nnoremap <silent> <leader><leader>fS :call Init_lua_cscope_query('0', 0)<CR>
nnoremap <silent> <leader><leader>cT :call Init_lua_cscope_query('4', 0)<CR>
nnoremap <silent> <leader><leader>cA :call Init_lua_cscope_query('9', 0, 1)<CR>
nnoremap <silent> <leader><leader>cC :call Init_lua_cscope_query('3', 0, 1)<CR>
nnoremap <silent> <leader><leader>cD :call Init_lua_cscope_query('2', 0, 1)<CR>
nnoremap <silent> <leader><leader>cE :call Init_lua_cscope_query('6', 0, 1)<CR>
nnoremap <silent> <leader><leader>cF :call Init_lua_cscope_query('7', 0, 1)<CR>
nnoremap <silent> <leader><leader>cG :call Init_lua_cscope_query('1', 0, 1)<CR>
nnoremap <silent> <leader><leader>cI :call Init_lua_cscope_query('8', 0, 1)<CR>
nnoremap <silent> <leader><leader>cS :call Init_lua_cscope_query('0', 0, 1)<CR>
nnoremap <silent> <leader><leader>cT :call Init_lua_cscope_query('4', 0, 1)<CR>

nnoremap <silent> <leader>ca :call Init_lua_cscope('9', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader>cc :call Init_lua_cscope('3', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader>cd :call Init_lua_cscope('2', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader>ce :call Init_lua_cscope('6', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader>cf :call Init_lua_cscope('7', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader>cg :call Init_lua_cscope('1', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader>ci :call Init_lua_cscope('8', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader>cs :call Init_lua_cscope('0', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader>ct :call Init_lua_cscope('4', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader><leader>fa :call Init_lua_cscope_query('9', 1)<CR>
nnoremap <silent> <leader><leader>fc :call Init_lua_cscope_query('3', 1)<CR>
nnoremap <silent> <leader><leader>fd :call Init_lua_cscope_query('2', 1)<CR>
nnoremap <silent> <leader><leader>fe :call Init_lua_cscope_query('6', 1)<CR>
nnoremap <silent> <leader><leader>ff :call Init_lua_cscope_query('7', 1)<CR>
nnoremap <silent> <leader><leader>fg :call Init_lua_cscope_query('1', 1)<CR>
nnoremap <silent> <leader><leader>fi :call Init_lua_cscope_query('8', 1)<CR>
nnoremap <silent> <leader><leader>fs :call Init_lua_cscope_query('0', 1)<CR>
nnoremap <silent> <leader><leader>ct :call Init_lua_cscope_query('4', 1)<CR>
nnoremap <silent> <leader><leader>ca :call Init_lua_cscope_query('9', 1, 1)<CR>
nnoremap <silent> <leader><leader>cc :call Init_lua_cscope_query('3', 1, 1)<CR>
nnoremap <silent> <leader><leader>cd :call Init_lua_cscope_query('2', 1, 1)<CR>
nnoremap <silent> <leader><leader>ce :call Init_lua_cscope_query('6', 1, 1)<CR>
nnoremap <silent> <leader><leader>cf :call Init_lua_cscope_query('7', 1, 1)<CR>
nnoremap <silent> <leader><leader>cg :call Init_lua_cscope_query('1', 1, 1)<CR>
nnoremap <silent> <leader><leader>ci :call Init_lua_cscope_query('8', 1, 1)<CR>
nnoremap <silent> <leader><leader>cs :call Init_lua_cscope_query('0', 1, 1)<CR>
nnoremap <silent> <leader><leader>ct :call Init_lua_cscope_query('4', 1, 1)<CR>

function! Init_lua_cscope(option, query, preview, ...)
    let l:ignorecase = get(a:, 2, 0)
    if l:ignorecase
      let realoption = "C" . a:option
    else
      let realoption = a:option
    endif
    let awk_program =
        \    '{ x = $1; $1 = ""; z = $3; $3 = ""; ' .
        \    'printf "%s:%s:%s\n", x,z,$0; }'
    let grep_command =
        \    'cscope -dL' . realoption . " " . shellescape(a:query) .
        \    " | awk '" . awk_program . "'"
    let fzf_color_option = split(fzf#wrap()['options'])[0]
    let opts = { 'options': fzf_color_option . ' --prompt "> "'}
    if a:preview
        let opts = fzf#vim#with_preview(opts)
    endif

    let name = expand('<cword>')
    let pos = getcurpos()
    let buf = bufnr()

    let result = fzf#vim#grep(grep_command, 0, opts, 0)

    if len(result) != 0
        if buf == bufnr() && pos[1] == getcurpos()[1]
            return 1
        endif
        call Init_lua_tagstack_push(name, pos, buf)
        return 1
    endif
    return 0
endfunction

function! Init_lua_cscope_query(option, preview, ...)
    call inputsave()
    if a:option == '9'
        let query = input('Assignments to: ')
    elseif a:option == '3'
        let query = input('Functions calling: ')
    elseif a:option == '2'
        let query = input('Functions called by: ')
    elseif a:option == '6'
        let query = input('Egrep: ')
    elseif a:option == '7'
        let query = input('File: ')
    elseif a:option == '1'
        let query = input('Definition: ')
    elseif a:option == '8'
        let query = input('Files #including: ')
    elseif a:option == '0'
        let query = input('Symbol: ')
    elseif a:option == '4'
        let query = input('Text: ')
    else
        echo "Invalid option!"
        return
    endif
    call inputrestore()
    if query != ""
        let l:ignorecase = get(a:, 2, 0)
        if l:ignorecase
            call Init_lua_cscope(a:option, query, a:preview, 1)
        else
            call Init_lua_cscope(a:option, query, a:preview)
        endif
    else
        echom "Cancelled Search!"
    endif
endfunction
" }}}

" Opengrok {{{
nnoremap <silent> gw :call Init_lua_og_query('f', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader>gw :call Init_lua_og_query('f', input('Text: '), 1)<CR>
nnoremap <silent> gW :call Init_lua_og_query('d', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader>gW :call Init_lua_og_query('d', input('Text: '), 1)<CR>
nnoremap <silent> <leader>zo :call Init_lua_og_query('f', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader><leader>zo :call Init_lua_og_query('f', input('Text: '), 1)<CR>
nnoremap <silent> <leader>zO :call Init_lua_og_query('d', expand('<cword>'), 1)<CR>
nnoremap <silent> <leader><leader>zO :call Init_lua_og_query('d', input('Text: '), 1)<CR>

function! Init_lua_og_query(option, query, preview)
    let awk_program =
        \    '{ x = $1; $1 = ""; z = $3; $3 = ""; ' .
        \    'printf "%s:%s:%s\n", x,z,$0; }'
    let grep_command =
        \    "java -Xmx2048m -cp ~/.vim/bin/opengrok/lib/opengrok.jar org.opensolaris.opengrok.search.Search -R .opengrok/configuration.xml -" .
        \    a:option . " " . shellescape(a:query) . "| grep \"^/.*\" | " . s:sed . " 's@</\\?.>@@g' | " . s:sed . " 's/&amp;/\\&/g' | " . s:sed . " 's/-\&gt;/->/g'" .
        \    " | awk '" . awk_program . "'"

    let fzf_color_option = split(fzf#wrap()['options'])[0]
    let opts = { 'options': fzf_color_option . ' --prompt "> "'}
    if a:preview
        let opts = fzf#vim#with_preview(opts)
    endif

    let name = expand('<cword>')
    let pos = getcurpos()
    let buf = bufnr()

    let result = fzf#vim#grep(grep_command, 0, opts, 0)

    if len(result) != 0
        if buf == bufnr() && pos[1] == getcurpos()[1]
            return 1
        endif
        call Init_lua_tagstack_push(name, pos, buf)
        return 1
    endif
    return 0
endfunction
" }}}

]=]

return m

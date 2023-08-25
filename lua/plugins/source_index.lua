local m = {}
local v = require 'vim'

local cmd = require 'vim.cmd'.silent
local async_cmd = require 'plugins.async_cmd'.async_cmd
local sed = require 'lib.os_bin'.sed
local echo = require 'vim.echo'.echo
local finder = require 'plugins.finder'

local split = v.split
local bufnr = v.api.nvim_get_current_buf
local winnr = v.fn.winnr
local expand = v.fn.expand
local input = v.fn.input
local stdpath = v.fn.stdpath
local getcurpos = v.fn.getcurpos
local settagstack = v.fn.settagstack
local gettagstack = v.fn.gettagstack
local shellescape = v.fn.shellescape
local system = v.fn.system
local index = v.fn.index
local trim = v.fn.trim
local fnameescape = v.fn.fnameescape

local bin_path = stdpath 'data' .. '/installation/bin'

local ctags_file_patterns = '-g "*.c" -g "*.cc" -g "*.cpp" -g "*.cxx" -g "*.h" -g "*.hh" -g "*.hpp"'
local other_file_patterns = '-g "*.py" -g "*.te" -g "*.S" -g "*.asm" -g "*.mk" -g "*.md" -g "makefile" -g "Makefile"'
local source_file_patterns = '-g "*.c" -g "*.cc" -g "*.cpp" -g "*.cxx" -g "*.h" -g "*.hh" -g "*.hpp" -g "*.py" -g "*.go" -g "*.java" -g "*.cs" -g "*.te" -g "*.S" -g "*.asm" -g "*.mk" -g "*.md" -g "makefile" -g "Makefile"'
local ctags_everything_options = '--c++-kinds=+p --fields=+iaSn --extras=+q --sort=foldcase --tag-relative --recurse=yes'
local ctags_options = '--languages=C,C++ --c++-kinds=+p --fields=+iaSn --extras=+q --sort=foldcase --tag-relative --recurse=yes'
local opengrok_file_patterns = "-I '*.cpp' -I '*.c' -I '*.cc' -I '*.cxx' -I '*.h' -I '*.hh' -I '*.hpp' -I '*.S' -I '*.s' -I '*.asm' -I '*.py' -I '*.go' -I '*.java' -I '*.cs' -I '*.mk' -I '*.te' -I makefile -I Makefile"
local opengrok_jar = bin_path .. '/opengrok/lib/opengrok.jar'
local opengrok_ctags = bin_path .. '/ctags-exuberant/ctags/ctags'
local generate_files_command = 'rg --files ' ..
    ctags_file_patterns ..
    ' > cscope.files && if ! [ -f .files ]; then cp cscope.files .files; fi && rg --files ' ..
    other_file_patterns .. ' >> .files'
local generate_cpp_command = 'cscope -bq'
local generate_opengrok_command = 'java -Xmx2048m -jar ' .. opengrok_jar .. ' -q -c ' ..
        opengrok_ctags .. ' -s . -d .opengrok ' .. opengrok_file_patterns .. ' -P -S -G -W .opengrok/configuration.xml'
local generate_tags_command = 'echo ' .. ctags_options .. ' > .gutctags && ' .. sed .. " -i 's/ /\\n/g' .gutctags && ctags " .. ctags_options
local generate_all_tags_command = 'echo ' .. ctags_everything_options .. ' > .gutctags && ' .. sed .. " -i 's/ /\\n/g' .gutctags && ctags " .. ctags_options
local generate_flags_command = 'echo -std=c++20 > compile_flags.txt' ..
    ' && echo -x >> compile_flags.txt' ..
    ' && echo c++ >> compile_flags.txt' ..
    ' && set +e ; find . -type d -name inc -or -name include -or -name Include | grep -v \"/\\.\" | ' ..
    sed .. ' s@^@-isystem\\\\n@g >> compile_flags.txt ; set -e'

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

m.generate_flags = function()
    async_cmd(generate_flags_command, { visible=true })
end

m.goto_symbol_definition = function()
    m.lib.goto_symbol(expand '<cword>', 'definition')
end

m.goto_symbol_declaration = function()
    m.lib.goto_symbol(expand '<cword>', 'declaration')
end

m.goto_symbol_definition_input = function()
    m.lib.goto_symbol_input 'definition'
end

m.goto_symbol_declaration_input = function()
    m.lib.goto_symbol_input 'declaration'
end

m.cscope_input = function(option)
    m.lib.cscope_query(option, 1)
end

m.cscope = function(option)
    m.lib.cscope(option, expand '<cword>', 1)
end

m.clean = function()
    async_cmd('rm -rf cscope.files cscope.in.out cscope.out cscope.po.out .opengrok .gutctags .files', { visible=true })
end

m.cscope_assignments = function() return m.cscope('9') end
m.cscope_function_calling = function() return m.cscope('3') end
m.cscope_functions_called_by = function() return m.cscope('2') end
m.cscope_egrep = function() return m.cscope('6') end
m.cscope_file = function() return m.cscope('7') end
m.cscope_definition = function() return m.cscope('1') end
m.cscope_files_including = function() return m.cscope('8') end
m.cscope_symbol = function() return m.cscope('0') end
m.cscope_text = function() return m.cscope('4') end

m.cscope_input_assignments = function() return m.cscope_input('9') end
m.cscope_input_function_calling = function() return m.cscope_input('3') end
m.cscope_input_functions_called_by = function() return m.cscope_input('2') end
m.cscope_input_egrep = function() return m.cscope_input('6') end
m.cscope_input_file = function() return m.cscope_input('7') end
m.cscope_input_definition = function() return m.cscope_input('1') end
m.cscope_input_files_including = function() return m.cscope_input('8') end
m.cscope_input_symbol = function() return m.cscope_input('0') end
m.cscope_input_text = function() return m.cscope_input('4') end

m.opengrok_query = function(kind)
    return m.lib.og_query(kind, expand '<cword>', 1)
end

m.opengrok_query_input = function(kind)
    return m.lib.og_query(kind, input 'Text: ', 1)
end

m.opengrok_query_f = function() return m.opengrok_query('f') end
m.opengrok_query_d = function() return m.opengrok_query('d') end

m.opengrok_query_input_f = function() return m.opengrok_query_input('f') end
m.opengrok_query_input_d = function() return m.opengrok_query_input('d') end

m.lib = {}

m.lib.tagstack_push_current = function(name)
    return m.lib.tagstack_push(name, getcurpos(), bufnr())
end

m.lib.tagstack_push = function(name, pos, buf)
    local curpos = pos
    curpos[1] = buf
    local item = { tagname = name, from = curpos }
    local tagstack = gettagstack()
    local curidx = tagstack.curidx

    if curidx == (tagstack.length + 1) then
        table.insert(tagstack.items, item)
        tagstack.length = curidx
    else
        tagstack.items[curidx] = item
    end
    tagstack.curidx = curidx + 1

    settagstack(winnr(), tagstack, 'r')
end

m.lib.goto_symbol_input = function(type)
    local symbol = input('Symbol: ')
    m.lib.goto_symbol(symbol, type)
end

m.lib.string_preview = function(string)
    local name = expand '<cword>'
    local pos = getcurpos()
    local buf = bufnr()

    local result = finder.custom_grep('echo ' .. shellescape(string))
    if result and #result ~= 0 then
        if buf == bufnr() and pos[2] == getcurpos()[2] then
            return 1
        end
        m.lib.tagstack_push(name, pos, buf)
        return 1
    end
    return 0
end

m.lib.goto_symbol = function(symbol, type)
    if symbol == '' then
        echo 'Empty Symbol!'
        return 0
    end

    local overall_limit = 2000
    local limit = 200
    local ctags_tag_types = {}
    local opengrok_query_type = 'f'
    local cscope_query_type = '0'
    local file_line_separator = ': '

    if type == 'definition' then
        ctags_tag_types = {'f', 'c', 's', 't', 'd', 'm', 'e', 'g', 'v', 'n'}
        opengrok_query_type = 'd'
    elseif type == 'declaration' then
        ctags_tag_types = {'p', 'd'}
        opengrok_query_type = 'f'
    end

    -- CScope
    if v.loop.fs_stat 'cscope.out'  then
        local awk_program = [=[{ x = $1; $1 = ""; z = $3; $3 = ""; printf "%s:%s:%s\n", x,z,$0; }]=]
        local cscope_command = 'cscope -dL' .. cscope_query_type .. " " .. shellescape(symbol) .. " | awk '" .. awk_program .. "'"

        local results = split(system(cscope_command), '\n')

        if #results <= overall_limit then
            local files_to_results = {}

            for _, result in ipairs(results) do
                local file_line = split(trim(split(result, file_line_separator)[1]), ':')
                if files_to_results[file_line[1]] then
                    table.insert(files_to_results[file_line[1]][1], file_line[2])
                    table.insert(files_to_results[file_line[1]][2], result)
                else
                    files_to_results[file_line[1]] = {{file_line[2]}, {result}}
                end
            end

            if #files_to_results <= limit then
                local valid_results = {}
                local valid_jumps = {}

                for file_path, file_results in pairs(files_to_results) do
                    local file_lines, result_lines = file_results[1], file_results[2]
                    for _, line_to_column in ipairs(m.lib.get_target_symbol_jump_if_ctag_type(symbol, file_path, file_lines, ctags_tag_types)) do
                        local line, column = line_to_column[1], line_to_column[2]
                        table.insert(valid_jumps, {file_path, line, column})
                        table.insert(valid_results, result_lines[index(file_lines, line) + 1])
                    end
                end

                if #valid_jumps == 1 then
                    m.lib.tagstack_push_current(symbol)
                    m.lib.jump_to_location(valid_jumps[1][1], valid_jumps[1][2], valid_jumps[1][3])
                    return 1
                elseif #valid_jumps > 1 then
                    return m.lib.string_preview(table.concat(valid_results, '\r\n'))
                end
            end
        end

        if not v.loop.fs_stat '.opengrok/configuration.xml' or not v.loop.fs_stat(opengrok_jar) then
            return m.lib.cscope(cscope_query_type, symbol, 1)
        end
    end

    -- Opengrok
    if v.loop.fs_stat '.opengrok/configuration.xml'  and v.loop.fs_stat(opengrok_jar) then
        local awk_program = [=[{ x = $1; $1 = ""; z = $3; $3 = ""; printf "%s:%s:%s\n", x,z,$0; }]=]
        local opengrok_command =
            "java -Xmx2048m -cp " .. opengrok_jar .. " org.opensolaris.opengrok.search.Search -R .opengrok/configuration.xml -" ..
            opengrok_query_type .. " " .. shellescape(symbol) ..
            "| grep \"^/.*\" | " .. sed .. " 's@</\\?.>@@g' | " .. sed .. " 's/&amp;/\\&/g' | " .. sed .. " 's/-\\&gt;/->/g'" ..
            " | awk '" .. awk_program .. "'"

        local results = split(system(opengrok_command), '\n')
        if #results > overall_limit then
            return m.lib.og_query(opengrok_query_type, symbol, 1)
        end

        local files_to_results = {}

        for _, result in ipairs(results) do
            local file_line = split(trim(split(result, file_line_separator)[1]), ':')
            if files_to_results[file_line[1]] then
                table.insert(files_to_results[file_line[1]][1], file_line[2])
                table.insert(files_to_results[file_line[1]][2], result)
            else
                files_to_results[file_line[1]] = {{file_line[2]}, {result}}
            end
        end

        if #files_to_results > limit then
            return m.lib.og_query(opengrok_query_type, symbol, 1)
        end

        local valid_results = {}
        local valid_jumps = {}

        for file_path, file_results in pairs(files_to_results) do
            local file_lines, result_lines = file_results[1], file_results[2]
            for _, line_to_column in ipairs(m.lib.get_target_symbol_jump_if_ctag_type(symbol, file_path, file_lines, ctags_tag_types)) do
                local line, column = line_to_column[1], line_to_column[2]
                table.insert(valid_jumps, {file_path, line, column})
                table.insert(valid_results, result_lines[index(file_lines, line_to_column[1]) + 1])
            end
        end

        if #valid_jumps == 1 then
            m.lib.tagstack_push_current(symbol)
            m.lib.jump_to_location(valid_jumps[1][1], valid_jumps[1][2], valid_jumps[1][3])
            return 1
        elseif #valid_jumps > 1 then
            return m.lib.string_preview(table.concat(valid_results, '\r\n'))
        end
    end

    echo('Could not find ' .. type .. ' of "' .. symbol .. '"')
    return 0
end

m.lib.get_target_symbol_jump_if_ctag_type = function(symbol, file, lines, ctags_tag_types)
    local ctags_output = io.popen("ctags -o - " .. ctags_everything_options .. ' ' ..
                                   shellescape(file) .. " 2>/dev/null | rg " .. shellescape(symbol))
    local ctags = {}
    if ctags_output then
        for line in ctags_output:lines() do
            table.insert(ctags, line)
        end
        ctags_output:close()
    end

    local lines_and_columns = {}
    for _, ctag in ipairs(ctags) do
        local ctag_fields = split(ctag, '\t')
        local ctag_field_name = ctag_fields[1]

        if #ctag_field_name < #symbol or string.sub(ctag_field_name, -#symbol) ~= symbol then
            goto continue
        end

        local ctag_field_type = nil
        local ctag_field_line = nil
        local ctag_field_column = 0
        for _, ctag_field in ipairs(ctag_fields) do
            if not ctag_field_type and #ctag_field == 1 then
                ctag_field_type = ctag_field
            elseif not ctag_field_line and ctag_field:find('line:') == 1 then
                ctag_field_line = split(ctag_field, ':')[2]
            elseif ctag_field_column == 0 and ctag_field:find('/^') == 1 and ctag_field:find(symbol) then
                ctag_field_column = ctag_field:find(symbol) - 2
            end
        end

        if index(ctags_tag_types, ctag_field_type) ~= -1 and ctag_field_line and index(lines, ctag_field_line) ~= -1 then
            if index(lines_and_columns, {ctag_field_line, ctag_field_column}) == -1 then
                table.insert(lines_and_columns, {ctag_field_line, ctag_field_column})
            end
        end

        ::continue::
    end

    return lines_and_columns
end

m.lib.cscope = function(_, query, preview, options)
    options = options or {}

    local ignorecase = options.ignorecase and 1 or 0

    local awk_program = [=[{ x = $1; $1 = ""; z = $3; $3 = ""; printf("%s:%s:%s\n", x, z, $0); }]=]
    local grep_command = 'cscope -dL' .. ignorecase .. " " .. shellescape(query) .. " | awk '" .. awk_program .. "'"

    local name = expand '<cword>'
    local pos = getcurpos()
    local buf = bufnr()

    local result = finder.custom_grep(grep_command, { preview=preview })
    if result and #result ~= 0 then
        if buf == bufnr() and pos[2] == getcurpos()[2] then
            return 1
        end
        m.lib.tagstack_push(name, pos, buf)
        return 1
    end
    return 0
end

m.lib.cscope_query = function(option, preview, options)
    options = options or {}

    local queries = {
        ['9'] = 'Assignments to: ',
        ['3'] = 'Functions calling: ',
        ['2'] = 'Functions called by: ',
        ['6'] = 'Egrep: ',
        ['7'] = 'File: ',
        ['1'] = 'Definition: ',
        ['8'] = 'Files #including: ',
        ['0'] = 'Symbol: ',
        ['4'] = 'Text: ',
    }

    local query = queries[option]
    if not query then
        echo 'Invalid option!'
        return
    end

    query = input(query)

    if query ~= '' then
        if options.ignorecase then
            m.lib.cscope(option, query, preview, { ignorecase=true })
        else
            m.lib.cscope(option, query, preview)
        end
    else
        echo 'Cancelled Search!'
    end
end

m.lib.og_query = function(option, query, preview)
    local awk_program = [=[{ x = $1; $1 = ""; z = $3; $3 = ""; printf("%s:%s:%s\n", x, z, $0); }]=]
    local grep_command =
        "java -Xmx2048m -cp " .. opengrok_jar .. " org.opensolaris.opengrok.search.Search -R .opengrok/configuration.xml -" ..
        option .. " " .. shellescape(query) ..
        " | grep \"^/.*\" | " .. sed .. " 's@</\\?.>@@g' | " .. sed .. " 's/&amp;/\\&/g' | " .. sed .. " 's/-\\&gt;/->/g'" ..
        " | awk '" .. awk_program .. "'"

    local name = expand('<cword>')
    local pos = getcurpos()
    local buf = bufnr()

    local result = finder.custom_grep(grep_command, { preview=preview })
    if result and #result ~= 0 then
        if buf == bufnr() and pos[2] == getcurpos()[2] then
            return 1
        end
        m.lib.tagstack_push(name, pos, buf)
        return 1
    end
    return 0
end

m.lib.jump_to_location = function(file, line, column)
    cmd('edit ' .. fnameescape(file))
    cmd(':' .. line)
    if column ~= 0 then
        cmd(':normal! ' .. column .. '|')
    end
    cmd 'normal! zz'
end

return m

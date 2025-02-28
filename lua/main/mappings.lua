local m = {}
local v = require 'vim'
local expand = v.fn.expand
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local root_paths = require 'main.root_paths'
local paste = require 'builtins.paste'
local clipboard = require 'builtins.clipboard'

m.setup = function()
    local source_index = require 'plugins.source_index'
    local lsp = require 'plugins.lsp'
    local finder = require 'plugins.finder'
    local whitespace = require 'plugins.whitespace'
    local tmux_navigator = require 'plugins.config.tmux_navigator'
    local git = require 'plugins.git'
    local explorers = require 'plugins.explorers'
    local zoom = require 'plugins.zoom'
    local fold = require 'plugins.fold'
    local buffers = require 'plugins.buffers'
    local binary_view = require 'plugins.binary_view'
    local disasm_view = require 'plugins.disasm_view'
    local tasks = require 'plugins.tasks'
    local debugger = require 'plugins.debugger'
    local jump = require 'plugins.jump'
    local indent_guides = require 'plugins.indent_guides'
    local quickfix = require 'plugins.quickfix'
    local terminal = require 'plugins.terminal'
    local pin = require 'plugins.pin'

    local keys = require 'which-key'

    local mappings = {
        n = {
            { '<space>?', '<cmd>WhichKey<cr>', desc = 'Show key bindings' },
            { 'g?', finder.keymaps, desc = 'Search key bindings' },
            { 'Y', 'y$', desc = 'Yank to end of line', },
            { 'g[', '0', desc = 'Go to beginning of line', },
            { 'g]', '$', desc = 'Go to end of line', },
            { '`', '<cmd>noh<cr>', desc = 'Turn off highlights', },
            { '<c-q>', '<c-v>', desc = 'Visual block', },
            { '<c-w>w', '<cmd>q<cr>', desc = 'Close window', },
            { '<c-w>g', explorers.file.open, desc = 'Open file explorer', },
            { '<c-w>;', explorers.code.open, desc = 'Open code explorer', },
            { '<c-w>e', explorers.close, desc = 'Close all explorers', },
            { '<c-w><space>', explorers.toggle, desc = 'Toggle all explorers', },
            { '<c-w><cr>', explorers.arrange, desc = 'Arrange explorers', },
            { '<c-s>', '<cmd>w<cr>', desc = 'Save file', },
            { '<leader>=', '<c-a>', desc = 'Increment', },
            { '<leader>-', '<c-x>', desc = 'Decrement', },
            { '<c-a>', 'ggVG', desc = 'Select all', },
            { '<c-v>', clipboard.paste, desc = 'Paste', },
            { '<s-f8>', paste.toggle, desc = 'Paste mode', },
            { '<f20>', paste.toggle, desc = 'Paste mode', },
            { 'L', '<cmd>vertical resize +1<cr>', desc = 'Resize vertically', },
            { 'H', '<cmd>vertical resize -1<cr>', desc = 'Resize vertically', },
            { '<c-w>z', zoom.toggle_zoom, desc = 'Toggle zoom', },
            { '<c-w>b', terminal.open_below, desc = 'New terminal below', },
            { '<c-w>B', terminal.split_below, desc = 'Split terminal below', },
            { '<c-w>t', terminal.open_split, desc = 'New terminal on right side', },
            { '<c-l>', indent_guides.refresh_trigger('20zl', { expr = false }), desc = 'Side scrolling', },
            { '<c-h>', indent_guides.refresh_trigger('20zh', { expr = false }), desc = 'Side scrolling', },
            { '<leader>rw', whitespace.strip, desc = 'Strip whitespace', },
            { '<leader>tw', whitespace.toggle, desc = 'Toggle whitespace', },
            { '<leader>ts', ':set spell! spelloptions=camel spelllang=en<cr>', desc = 'Toggle spell', },
            { 'cro', root_paths.switch_to_root, desc = 'Switch to root', },
            { 'cp', root_paths.switch_to_project_root, desc = 'Switch to project root', },
            { '<leader>ef', explorers.display_current_file, desc = 'Echo current file', },
            { 'cq', explorers.display_current_directory, desc = 'Echo current directory', },
            { 'cd', function() cmd('cd ' .. expand('%:p:h')) end, desc = 'Enter current file directory', },
            { 'cu', function() cmd('cd ..') end, desc = 'Go up one directory', },
            { 'gb', git.git_blame, desc = 'Git blame', },
            { 'gv', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diff view currnent file', },
            { 'gV', '<cmd>DiffviewFileHistory<cr>', desc = 'Diff view currnent branch', },
            { 'gl', git.show_git, desc = 'Show git', },
            { 'gm', git.show_staging_buffer, desc = 'Show git staging buffer', },
            { '[c', git.prev_hunk, desc = 'Git prev hunk', },
            { ']c', git.next_hunk, desc = 'Git next hunk', },
            { 'gs', source_index.goto_symbol_definition, desc = 'Goto indexed symbol prefer definition', },
            { 'gS', source_index.goto_symbol_declaration, desc = 'Goto indexed symbol prefer declaration', },
            { 'gd', lsp.goto_definition, desc = 'Goto definition', },
            { '<leader>gd', lsp.show_definitions, desc = 'Browse definitions', },
            { 'gD', lsp.goto_declaration, desc = 'Goto declaration lsp', },
            { '<leader><leader>gd', lsp.goto_definition_sync, desc = 'Goto definition synchronously', },
            { 'gr', lsp.show_references, desc = 'Browse references lsp', },
            { 'ga', lsp.code_action, desc = 'Code action', },
            { '<leader>qf', lsp.quick_fix, desc = 'Quick fix using lsp', },
            { '<leader>gy', lsp.type_definition, desc = 'Goto type definition', },
            { 'go', lsp.switch_source_header, desc = 'Switch between source and header', },
            { 'K', lsp.show_documentation, desc = 'Show documentation', },
            { '[d', lsp.prev_diagnostic, desc = 'Show previous diagnostic', },
            { ']d', lsp.next_diagnostic, desc = 'Show next diagnostic', },
            { '<leader>rn', lsp.rename, desc = 'Rename symbol', },
            { '<leader>ld', lsp.list_diagnostics, desc = 'List diagnostics', },
            { '<leader><leader><tab>', finder.find_buffer, desc = 'Find buffer', },
            { '<c-p>', finder.find_file, desc = 'Find file', },
            { '<leader><c-p>', finder.find_file_list, desc = 'Find file with cache while populating files list for later use.', },
            { '<leader><leader><c-p>', finder.find_file_list_invalidate, desc = 'Similar to previous but invalidate cache.', },
            { '<c-]>', finder.find_file_hidden, desc = 'Find file include hidden files', },
            { '<leader><c-]>', finder.find_file_list_hidden, desc = 'Find file include hidden files with cache while populating files list for later use.', },
            { '<leader><leader><c-]>', finder.find_file_list_hidden_invalidate, desc = 'Similar to previous but invalidate cache.', },
            { '<c-g>', finder.find_in_files, desc = 'Search in all files fuzzy', },
            { '<c-\\>', finder.find_in_files_precise, desc = 'Search in all files precisely', },
            { '<leader><c-\\>', finder.find_in_files_precise_native, desc = 'Search in all files precisely (may be faster)', },
            { 'g<c-g>', finder.find_current_in_files, desc = 'Search in all files fuzzy', },
            { 'g<c-\\>', finder.find_current_in_files_precise, desc = 'Search in all files precisely', },
            { 'g<leader><c-\\>', finder.find_current_in_files_precise_native, desc = 'Search in all files precisely (may be faster)', },
            { '//', finder.find_line, desc = 'Find a line in current file', },
            { '<c-w>h', tmux_navigator.tmux_navigate_left, desc = 'Navigate left', },
            { '<c-w>j', tmux_navigator.tmux_navigate_down, desc = 'Navigate down', },
            { '<c-w>k', tmux_navigator.tmux_navigate_up, desc = 'Navigate right', },
            { '<c-w>l', tmux_navigator.tmux_navigate_right, desc = 'Navigate up', },
            { '<c-w><left>', tmux_navigator.tmux_navigate_left, desc = 'Navigate left', },
            { '<c-w><down>', tmux_navigator.tmux_navigate_down, desc = 'Navigate down', },
            { '<c-w><up>', tmux_navigator.tmux_navigate_up, desc = 'Navigate right', },
            { '<c-w><right>', tmux_navigator.tmux_navigate_right, desc = 'Navigate up', },
            { '<leader>u', fold.toggle, desc = 'Toggle fold', },
            { '<c-w>,', desc = 'Previous buffer', },
            { '<c-w>.', buffers.next_buffer, desc = 'Next buffer', },
            { '<s-tab>', buffers.prev_buffer, desc = 'Previous buffer', },
            { '<tab>', buffers.next_buffer, desc = 'Next buffer', },
            { '<c-w>d', buffers.delete_buffer, desc = 'Close buffer', },
            { '<leader>1', buffers.switch_to_buffer(1), desc = 'Switch buffer 1', },
            { '<leader>2', buffers.switch_to_buffer(2), desc = 'Switch buffer 2', },
            { '<leader>3', buffers.switch_to_buffer(3), desc = 'Switch buffer 3', },
            { '<leader>4', buffers.switch_to_buffer(4), desc = 'Switch buffer 4', },
            { '<leader>5', buffers.switch_to_buffer(5), desc = 'Switch buffer 5', },
            { '<leader>6', buffers.switch_to_buffer(6), desc = 'Switch buffer 6', },
            { '<leader>7', buffers.switch_to_buffer(7), desc = 'Switch buffer 7', },
            { '<leader>8', buffers.switch_to_buffer(8), desc = 'Switch buffer 8', },
            { '<leader>9', buffers.switch_to_buffer(9), desc = 'Switch buffer 9', },
            { '<leader>0', buffers.switch_to_buffer(0), desc = 'Switch buffer 10', },
            { '<leader><tab>', buffers.pick_buffer, desc = 'Pick buffer', },
            { '<c-w>p', ':below copen<cr>', desc = 'Quickfix open below', },
            { '<c-w>m', quickfix.map_open, desc = 'Go to quickfix', },
            { '<c-w>q', ':cclose<cr>', desc = 'Quickfix close', },
            { '-', ':setlocal wrap! lbr!<cr>', desc = 'Wrap words', },
            { 'cr', '<plug>(abolish-coerce-word)', desc = 'Change word case (s/m/c/u/-/.)', },
            { '<leader>bv', binary_view.binary_view, desc = 'Binary view with xxd', },
            { '<leader>dv', disasm_view.disasm_view, desc = 'Disassembly view', },
            { '<f7>', tasks.build_project, desc = 'Build project', },
            { '<c-f5>', tasks.run_project, desc = 'Run project', },
            { '<f29>', tasks.run_project, desc = 'Run project', },
            { '<s-f7>', tasks.clean_project, desc = 'Clean project', },
            { '<f19>', tasks.clean_project, desc = 'Clean project', },
            { '<c-f7>', tasks.run_project, desc = 'Run project', },
            { '<f31>', tasks.build_config, desc = 'Build config', },
            { '<leader>dl', debugger.launch_settings, desc = 'Debug launch settings', },
            { '<leader>dj', debugger.launch_settings, desc = 'Debug launch settings (json)', },
            { '<leader>dd', debugger.launch, desc = 'Debug launch', },
            { '<leader>dc', debugger.continue, desc = 'Debug continue', },
            { '<f5>', debugger.continue, desc = 'Debug continue', },
            { '<leader>dr', debugger.restart, desc = 'Debug restart', },
            { '<s-f5>', debugger.restart, desc = 'Debug restart', },
            { '<f17>', debugger.restart, desc = 'Debug restart', },
            { '<leader>dp', debugger.pause, desc = 'Debug pause', },
            { '<f6>', debugger.pause, desc = 'Debug pause', },
            { '<leader>ds', debugger.stop, desc = 'Debug stop', },
            { '<s-f6>', debugger.stop, desc = 'Debug stop', },
            { '<f18>', debugger.stop, desc = 'Debug stop', },
            { '<leader>db', debugger.breakpoint, desc = 'Debug breakpoint', },
            { '<f9>', debugger.breakpoint, desc = 'Debug breakpoint', },
            { '<leader><leader>db', debugger.breakpoint_cond, desc = 'Debug conditional breakpoint', },
            { '<s-f9>', debugger.breakpoint_cond, desc = 'Debug conditional breakpoint', },
            { '<f21>', debugger.breakpoint_cond, desc = 'Debug conditional breakpoint', },
            { '<leader>df', debugger.breakpoint_function, desc = 'Debug function breakpoint', },
            { '<leader><f9>', debugger.breakpoint_function, desc = 'Debug function breakpoint', },
            { '<leader>dB', debugger.clear_breakpoints, desc = 'Debug clear breakpoints', },
            { '<leader><leader><f9>', debugger.clear_breakpoints, desc = 'Debug clear breakpoints', },
            { '<leader>dn', debugger.step_over, desc = 'Debug step over', },
            { '<f10>', debugger.step_over, desc = 'Debug step over', },
            { '<leader>di', debugger.step_into, desc = 'Debug step into', },
            { '<F11>', debugger.step_into, desc = 'Debug step into', },
            { '<leader>do', debugger.step_out, desc = 'Debug step out', },
            { '<s-f11>', debugger.step_out, desc = 'Debug step out', },
            { '<f23>', debugger.step_out, desc = 'Debug step out', },
            { '<leader>dN', debugger.run_to_cursor, desc = 'Debug run to cursor', },
            { '<C-F10>', debugger.run_to_cursor, desc = 'Debug run to cursor', },
            { '<f34>', debugger.run_to_cursor, desc = 'Debug run to cursor', },
            { '<leader>dD', debugger.disassemble, desc = 'Debug disassemble', },
            { '<leader>de', debugger.eval_window, desc = 'Debug eval window', },
            { '<leader>du', debugger.reset_ui, desc = 'Debugger reset UI', },
            { '<leader>dU', debugger.toggle_ui, desc = 'Debugger toggle UI', },
            { '<leader>dq', debugger.reset, desc = 'Debug close', },
            { '<leader>ca', source_index.cscope_assignments, desc = 'CScope assignments', },
            { '<leader>cc', source_index.cscope_function_calling, desc = 'CScope function calling', },
            { '<leader>cd', source_index.cscope_functions_called_by, desc = 'CScope functions called by', },
            { '<leader>ce', source_index.cscope_egrep, desc = 'CScope egrep', },
            { '<leader>cf', source_index.cscope_file, desc = 'CScope file', },
            { '<leader>cg', source_index.cscope_definition, desc = 'CScope definition', },
            { '<leader>ci', source_index.cscope_files_including, desc = 'CScope files including', },
            { '<leader>cs', source_index.cscope_symbol, desc = 'CScope symbol', },
            { '<leader>ct', source_index.cscope_text, desc = 'CScope text', },
            { '<leader><leader>ca', source_index.cscope_assignments, desc = 'CScope assignments', },
            { '<leader><leader>cc', source_index.cscope_input_function_calling, desc = 'CScope function calling (input)', },
            { '<leader><leader>cd', source_index.cscope_input_functions_called_by, desc = 'CScope functions called by (input)', },
            { '<leader><leader>ce', source_index.cscope_input_egrep, desc = 'CScope egrep (input)', },
            { '<leader><leader>cf', source_index.cscope_input_file, desc = 'CScope file (input)', },
            { '<leader><leader>cg', source_index.cscope_input_definition, desc = 'CScope definition (input)', },
            { '<leader><leader>ci', source_index.cscope_input_files_including, desc = 'CScope files including (input)', },
            { '<leader><leader>cs', source_index.cscope_input_symbol, desc = 'CScope symbol (input)', },
            { '<leader><leader>ct', source_index.cscope_input_text, desc = 'CScope text (input)', },
            { 'gw', source_index.opengrok_query_f, desc = 'Opengrok query symbol', },
            { 'gW', source_index.opengrok_query_d, desc = 'Opengrok query symbol defintiion', },
            { '<leader>gw', source_index.opengrok_query_input_f, desc = 'Opengrok query symbol (input)', },
            { '<leader>gW', source_index.opengrok_query_input_d, desc = 'Opengrok query symbol defintiion (input)', },
            { '<leader>o', ':pop<cr>', desc = 'Pop tag stack', },
            { '<leader>i', ':tag<cr>', desc = 'Unpop tag stack', },
            { '<leader>gcp', source_index.generate_cpp, desc = 'Generate cpp index', },
            { '<leader>gt', source_index.generate_tags, desc = 'Generate common tags', },
            { '<leader>gT', source_index.generate_all_tags, desc = 'Generate all tags', },
            { '<leader>gf', source_index.generate_source_files_list, desc = 'Generate source files list/cache', },
            { '<leader>gF', source_index.generate_all_files_list, desc = 'Generate all files list/cache', },
            { '<leader>gcf', source_index.generate_flags, desc = 'Generate flags', },
            { '<leader>go', source_index.generate_opengrok, desc = 'Generate opengrok', },
            { '<leader>ga', source_index.generate_cpp_and_opengrok, desc = 'Generate cpp and opengrok', },
            { '<leader><leader>gc', source_index.clean, desc = 'Clean', },
            { '<leader>cp', finder.color_picker, desc = 'Pick color', },
            { '<leader>p', '<cmd>YankHistoryRgPaste<cr>', desc = 'Paste from history', },
            { '<f1>', '<cmd>set relativenumber!<cr>', desc = 'Relative number', },
            { '<f2>', '<cmd>set number!<cr>', desc = 'Number', },
            { '<leader>bt', '<cmd>lua require "barbecue.ui".toggle()<cr>', desc = 'Toggle barbecue bar', },
            { '<leader><leader>lf', '<cmd>lua require "plugins.large_files".set()<cr>', desc = 'Set large file', },
            { 'gp', '<cmd>lua require("goto-preview").goto_preview_definition()<CR>', desc = 'Goto definition preview', },
            { '<leader>gp', '<cmd>lua require("goto-preview").close_all_win()<CR>', desc = 'Close preview windows', },
            { '<leader><leader>p', pin.pin, desc = 'Pin window' },
            { '<leader><leader>P', pin.unpin, desc = 'Unpin window' },
            { 'ms', '<plug>(VM-Find-Under)', desc = 'Multicursor Select Word' },
            { 'mm', '<plug>(VM-Add-Cursor-At-Pos)', desc = 'Multicursor Add Cursor' },
            { 'mA', '<plug>(VM-Select-All)', desc = 'Multicursor Select All' },
            { 'm/', '<plug>(VM-Start-Regex-Search)', desc = 'Multicursor Search' },
            { '<c-j>', '<plug>(VM-Add-Cursor-Down)', desc = 'Add cursor down', },
            { '<c-k>', '<plug>(VM-Add-Cursor-Up)', desc = 'Add cursor down', },
        },
        x = {
            { '<tab>', '%', desc = 'Jump to matching pairs', },
            { '<leader>=', '<c-a>', desc = 'Increment', },
            { '<leader>-', '<c-x>', desc = 'Decrement', },
            { '<c-a>', '<esc>ggVG', desc = 'Select all', },
            { '<c-c>', clipboard.copy, desc = 'Copy', },
            { '<c-x>', clipboard.cut, desc = 'Cut', },
            { '<c-l>', indent_guides.refresh_trigger('20zl', { expr = false }), desc = 'Side scrolling', },
            { '<c-h>', indent_guides.refresh_trigger('20zh', { expr = false }), desc = 'Side scrolling', },
            { 'gf', lsp.format_selected, desc = 'Format selected', },
            { '<c-r>', lsp.select_snippets, desc = 'Select snippets', },
            { '<f1>', ':set relativenumber!<cr>', desc = 'Relative number', },
            { '<f2>', ':set number!<cr>', desc = 'Number', },
            { 'ms', '<plug>(VM-Find-Subword-Under)', desc = 'Multicursor Select Subword', },
            { 'mf', '<plug>(VM-Visual-Find)', desc = 'Multicursor Visual Find', },
            { 'mc', '<plug>(VM-Visual-Cursors)', desc = 'Multicursor Visual Cursors', },
            { 'ma', '<plug>(VM-Visual-Add)', desc = 'Multicursor Add Region', },
            { 'mA', '<plug>(VM-Visual-All)', desc = 'Multicursor Select All', },
            { 'm/', '<plug>(VM-Visual-Regex)', desc = 'Multicursor Search', },
        },
        v = {
        },
        i = {
            { '<c-s>', '<c-o>:w<cr>', desc = 'Save file', },
            { '<c-a>', '<esc>ggVG', desc = 'Select all', },
            { '<c-v>', clipboard.paste, desc = 'Paste', },
            { '<f7>', tasks.build_project, desc = 'Build project task', },
            { '<c-f5>', tasks.run_project, desc = 'Run project task', },
            { '<f29>', tasks.run_project, desc = 'Run project task', },
            { '<s-f7>', tasks.clean_project, desc = 'Clean project task', },
            { '<f19>', tasks.clean_project, desc = 'Clean project task', },
            { '<c-f7>', tasks.run_project, desc = 'Configure project task', },
            { '<f31>', tasks.build_config, desc = 'Build config', },
            { '<c-d>', lsp.expand_snippets, desc = 'Expand snippets (with nvim-lsp just use tab to select then enter)', },
        },
        t = {
            { '<c-w>w', '<c-\\><c-n>:q<cr>', desc = 'Close terminal', },
            { '<c-w>n', '<c-\\><c-n>', desc = 'Terminal normal mode', },
            { '<c-w>h', tmux_navigator.tmux_navigate_left, desc = 'Navigate left', },
            { '<c-w>j', tmux_navigator.tmux_navigate_down, desc = 'Navigate down', },
            { '<c-w>k', tmux_navigator.tmux_navigate_up, desc = 'Navigate right', },
            { '<c-w>l', tmux_navigator.tmux_navigate_right, desc = 'Navigate up', },
            { '<c-w><left>', tmux_navigator.tmux_navigate_left, desc = 'Navigate left', },
            { '<c-w><down>', tmux_navigator.tmux_navigate_down, desc = 'Navigate down', },
            { '<c-w><up>', tmux_navigator.tmux_navigate_up, desc = 'Navigate right', },
            { '<c-w><right>', tmux_navigator.tmux_navigate_right, desc = 'Navigate up', },
        },
        c = {
            { '<c-k>', '<plug>CmdlineCompleteBackward', desc = 'Complete prev in vim command mode', },
            { '<c-j>', '<plug>CmdlineCompleteForward', desc = 'Complete next in vim command mode', },
        },
    }

    local documentation = {
        n = {
        },
        x = {
        },
        v = {
        },
        i = {
        },
        t = {
        },
        c = {
        },
    }

    for _, entry in ipairs({ mappings, documentation }) do
        keys.add({ mode = {'n'}, entry.n })
        keys.add({ mode = {'x'}, entry.x })
        keys.add({ mode = {'v'}, entry.v })
        keys.add({ mode = {'i'}, entry.i })
        keys.add({ mode = {'t'}, entry.t })
        keys.add({ mode = {'c'}, entry.c })
    end

    -- Internal mappings

    keys.add({
            mode = {'n', 'x'}, expr = true,
            {'<scrollwheelleft>', indent_guides.refresh_trigger('<scrollwheelleft>', { expr = true }), desc = 'Refresh indent guides on horizontal scroll', },
            {'<scrollwheelright>', indent_guides.refresh_trigger('<scrollwheelright>', { expr = true }), desc = 'Refresh indent guides on horizontal scroll', },
        })

    keys.add({
        mode = {'t'},
        {'<scrollwheelleft>', '<nop>', desc = 'Disable terminal horizontal scrolling', },
        {'<scrollwheelright>', '<nop>', desc = 'Disable terminal horizontal scrolling', },
        {'<mousemove>', '<nop>', desc = 'Disable terminal mouse move', },
    })

    if jump.needs_mapping then
        local jump_mappings = {
            n = {
                { 's', jump.search_jump, desc = 'Search and jump to location', },
                { 'f', jump.find_jump, desc = 'Find and jump to location', },
                { 'F', jump.find_jump_back, desc = 'Find backwards and jump to location', },
                { 't', jump.till_jump, desc = 'Find and jump until location', },
                { 'T', jump.till_jump_back, desc = 'Find backwards and jump until location', },
            },
            x = {
                { 's', jump.search_jump_visual, desc = 'Search and jump to location', },
                { 'S', jump.search_jump_back_visual, desc = 'Search backwards and jump to location', },
                { 'f', jump.find_jump, desc = 'Find and jump to location', },
                { 'F', jump.find_jump_back, desc = 'Find backwards and jump to location', },
                { 't', jump.till_jump, desc = 'Find and jump until location', },
                { 'T', jump.till_jump_back, desc = 'Find backwards and jump until location', },
            }
        }
        keys.add({ mode = {'n'}, jump_mappings.n })
        keys.add({ mode = {'x'}, jump_mappings.x })
    end

    if lsp.completion_mappings then
        keys.add({
            mode = {'i'}, expr = true,
            {'<tab>', lsp.tab, desc = 'Lsp complete', },
            {'<s-tab>', lsp.shift_tab, desc = ' Lsp prev complete', },
            {'<cr>', lsp.enter, desc = 'Lsp enter', },
        })
    end

    if user.settings.pairs == 'pear-tree' then
        keys.add({
            mode = {'i'},
            {'<bs>', '<plug>(PearTreeBackspace)', desc = 'Pear tree internal backspace processing', },
        })
        if user.settings.lsp ~= 'coc' and user.settings.format_on_pairs then
            keys.add({
                mode = {'i'},
                {'<cr>', '<plug>(PearTreeExpand)', desc = 'Pear tree internal enter processing', },
            })
        end
    end
end

return m

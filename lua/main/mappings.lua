local m = {}
local v = require 'vim'
local expand = v.fn.expand
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local root_paths = require 'main.root_paths'
local paste = require 'builtins.paste'
local clipboard = require 'builtins.clipboard'
local map = v.keymap.set

local keys = {}
keys.register = function(map_entries, options)
    local mode = options.mode
    local map_opts = { silent = true, noremap = true, expr = false, nowait = false, buffer = nil }
    for opt, val in pairs(map_opts) do
        if options[opt] ~= nil then
            map_opts[opt] = val
        end
    end
    for map_key, map_value in pairs(map_entries) do
        map_opts.desc = map_value[2]
        map(mode, map_key, map_value[1], map_opts)
    end
end

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
    local ai_chat = require 'plugins.ai_chat'
    local _ = require 'which-key'

    local mappings = {
        n = {
            ['<space>?'] = { '<cmd>WhichKey<cr>', 'Show key bindings' },
            ['g?'] = { finder.keymaps, 'Search key bindings' },
            ['Y'] = { 'y$', 'Yank to end of line', },
            ['g['] = { '0', 'Go to beginning of line', },
            ['g]'] = { '$', 'Go to end of line', },
            ['`'] = { '<cmd>noh<cr>', 'Turn off highlights', },
            ['<c-q>'] = { '<c-v>', 'Visual block', },
            ['<c-w>w'] = { '<cmd>q<cr>', 'Close window', },
            ['<c-w>g'] = { explorers.file.open, 'Open file explorer', },
            ['<c-w>;'] = { explorers.code.open, 'Open code explorer', },
            ['<c-w>e'] = { explorers.close, 'Close all explorers', },
            ['<c-w><space>'] = { explorers.toggle, 'Toggle all explorers', },
            ['<c-w><cr>'] = { explorers.arrange, 'Arrange explorers', },
            ['<c-s>'] = { '<cmd>w<cr>', 'Save file', },
            ['<leader>='] = { '<c-a>', 'Increment', },
            ['<leader>-'] = { '<c-x>', 'Decrement', },
            ['<c-a>'] = { 'ggVG', 'Select all', },
            ['<c-v>'] = { clipboard.paste, 'Paste', },
            ['<s-f8>'] = { paste.toggle, 'Paste mode', },
            ['<f20>'] = { paste.toggle, 'Paste mode', },
            ['L'] = { '<cmd>vertical resize +1<cr>', 'Resize vertically', },
            ['H'] = { '<cmd>vertical resize -1<cr>', 'Resize vertically', },
            ['<c-w>z'] = { zoom.toggle_zoom, 'Toggle zoom', },
            ['<c-w>b'] = { terminal.open_below, 'New terminal below', },
            ['<c-w>B'] = { terminal.split_below, 'Split terminal below', },
            ['<c-w>t'] = { terminal.open_split, 'New terminal on right side', },
            ['<c-w>a'] = { ai_chat.toggle, 'Toggle AI chat', },
            ['<c-l>'] = { indent_guides.refresh_trigger('20zl', { expr = false }), 'Side scrolling', },
            ['<c-h>'] = { indent_guides.refresh_trigger('20zh', { expr = false }), 'Side scrolling', },
            ['<leader>rw'] = { whitespace.strip, 'Strip whitespace', },
            ['<leader>tw'] = { whitespace.toggle, 'Toggle whitespace', },
            ['<leader>ts'] = { ':set spell! spelloptions=camel spelllang=en<cr>', 'Toggle spell', },
            ['cro'] = { root_paths.switch_to_root, 'Switch to root', },
            ['cp'] = { root_paths.switch_to_project_root, 'Switch to project root', },
            ['<leader>ef'] = { explorers.display_current_file, 'Echo current file', },
            ['cq'] = { explorers.display_current_directory, 'Echo current directory', },
            ['cd'] = { function() cmd('cd ' .. expand('%:p:h')) end, 'Enter current file directory', },
            ['cu'] = { function() cmd('cd ..') end, 'Go up one directory', },
            ['gb'] = { git.git_blame, 'Git blame', },
            ['gv'] = { '<cmd>DiffviewFileHistory %<cr>', 'Diff view currnent file', },
            ['gV'] = { '<cmd>DiffviewFileHistory<cr>', 'Diff view currnent branch', },
            ['gl'] = { git.show_git, 'Show git', },
            ['gm'] = { git.show_staging_buffer, 'Show git staging buffer', },
            ['[c'] = { git.prev_hunk, 'Git prev hunk', },
            [']c'] = { git.next_hunk, 'Git next hunk', },
            ['gs'] = { source_index.goto_symbol_definition, 'Goto indexed symbol prefer definition', },
            ['gS'] = { source_index.goto_symbol_declaration, 'Goto indexed symbol prefer declaration', },
            ['gd'] = { lsp.goto_definition, 'Goto definition', },
            ['<leader>gd'] = { lsp.show_definitions, 'Browse definitions', },
            ['gD'] = { lsp.goto_declaration, 'Goto declaration lsp', },
            ['<leader><leader>gd'] = { lsp.goto_definition_sync, 'Goto definition synchronously', },
            ['grr'] = { lsp.show_references, 'Browse references lsp', },
            ['ga'] = { lsp.code_action, 'Code action', },
            ['<leader>qf'] = { lsp.quick_fix, 'Quick fix using lsp', },
            ['<leader>gy'] = { lsp.type_definition, 'Goto type definition', },
            ['go'] = { lsp.switch_source_header, 'Switch between source and header', },
            ['K'] = { lsp.show_documentation, 'Show documentation', },
            ['[d'] = { lsp.prev_diagnostic, 'Show previous diagnostic', },
            [']d'] = { lsp.next_diagnostic, 'Show next diagnostic', },
            ['<leader>rn'] = { lsp.rename, 'Rename symbol', },
            ['<leader>ld'] = { lsp.list_diagnostics, 'List diagnostics', },
            ['<leader><leader><tab>'] = { finder.find_buffer, 'Find buffer', },
            ['<c-p>'] = { finder.find_file, 'Find file', },
            ['<leader><c-p>'] = { finder.find_file_list,
                'Find file with cache while populating files list for later use.', },
            ['<leader><leader><c-p>'] = { finder.find_file_list_invalidate, 'Similar to previous but invalidate cache.', },
            ['<c-]>'] = { finder.find_file_hidden, 'Find file include hidden files', },
            ['<leader><c-]>'] = { finder.find_file_list_hidden,
                'Find file include hidden files with cache while populating files list for later use.', },
            ['<leader><leader><c-]>'] = { finder.find_file_list_hidden_invalidate,
                'Similar to previous but invalidate cache.', },
            ['<c-g>'] = { finder.find_in_files, 'Search in all files fuzzy', },
            ['<c-\\>'] = { finder.find_in_files_precise, 'Search in all files precisely', },
            ['<leader><c-\\>'] = { finder.find_in_files_precise_native, 'Search in all files precisely (may be faster)', },
            ['g<c-g>'] = { finder.find_current_in_files, 'Search in all files fuzzy', },
            ['g<c-\\>'] = { finder.find_current_in_files_precise, 'Search in all files precisely', },
            ['g<leader><c-\\>'] = { finder.find_current_in_files_precise_native,
                'Search in all files precisely (may be faster)', },
            ['//'] = { finder.find_line, 'Find a line in current file', },
            ['<c-w>h'] = { tmux_navigator.tmux_navigate_left, 'Navigate left', },
            ['<c-w>j'] = { tmux_navigator.tmux_navigate_down, 'Navigate down', },
            ['<c-w>k'] = { tmux_navigator.tmux_navigate_up, 'Navigate right', },
            ['<c-w>l'] = { tmux_navigator.tmux_navigate_right, 'Navigate up', },
            ['<c-w><left>'] = { tmux_navigator.tmux_navigate_left, 'Navigate left', },
            ['<c-w><down>'] = { tmux_navigator.tmux_navigate_down, 'Navigate down', },
            ['<c-w><up>'] = { tmux_navigator.tmux_navigate_up, 'Navigate right', },
            ['<c-w><right>'] = { tmux_navigator.tmux_navigate_right, 'Navigate up', },
            ['<leader>u'] = { fold.toggle, 'Toggle fold', },
            ['<c-w>,'] = { 'Previous buffer', },
            ['<c-w>.'] = { buffers.next_buffer, 'Next buffer', },
            ['<s-tab>'] = { buffers.prev_buffer, 'Previous buffer', },
            ['<tab>'] = { buffers.next_buffer, 'Next buffer', },
            ['<c-w>d'] = { buffers.delete_buffer, 'Close buffer', },
            ['<leader>1'] = { buffers.switch_to_buffer(1), 'Switch buffer 1', },
            ['<leader>2'] = { buffers.switch_to_buffer(2), 'Switch buffer 2', },
            ['<leader>3'] = { buffers.switch_to_buffer(3), 'Switch buffer 3', },
            ['<leader>4'] = { buffers.switch_to_buffer(4), 'Switch buffer 4', },
            ['<leader>5'] = { buffers.switch_to_buffer(5), 'Switch buffer 5', },
            ['<leader>6'] = { buffers.switch_to_buffer(6), 'Switch buffer 6', },
            ['<leader>7'] = { buffers.switch_to_buffer(7), 'Switch buffer 7', },
            ['<leader>8'] = { buffers.switch_to_buffer(8), 'Switch buffer 8', },
            ['<leader>9'] = { buffers.switch_to_buffer(9), 'Switch buffer 9', },
            ['<leader>0'] = { buffers.switch_to_buffer(0), 'Switch buffer 10', },
            ['<leader><tab>'] = { buffers.pick_buffer, 'Pick buffer', },
            ['<c-w>p'] = { ':below copen<cr>', 'Quickfix open below', },
            ['<c-w>m'] = { quickfix.map_open, 'Go to quickfix', },
            ['<c-w>q'] = { ':cclose<cr>', 'Quickfix close', },
            ['-'] = { ':setlocal wrap! lbr!<cr>', 'Wrap words', },
            ['cr'] = { '<plug>(abolish-coerce-word)', 'Change word case (s/m/c/u/-/.)', },
            ['<leader>bv'] = { binary_view.binary_view, 'Binary view with xxd', },
            ['<leader>dv'] = { disasm_view.disasm_view, 'Disassembly view', },
            ['<f7>'] = { tasks.build_project, 'Build project', },
            ['<c-f5>'] = { tasks.run_project, 'Run project', },
            ['<f29>'] = { tasks.run_project, 'Run project', },
            ['<s-f7>'] = { tasks.clean_project, 'Clean project', },
            ['<f19>'] = { tasks.clean_project, 'Clean project', },
            ['<c-f7>'] = { tasks.run_project, 'Run project', },
            ['<f31>'] = { tasks.build_config, 'Build config', },
            ['<leader>dl'] = { debugger.launch_settings, 'Debug launch settings', },
            ['<leader>dj'] = { debugger.launch_settings, 'Debug launch settings (json)', },
            ['<leader>dd'] = { debugger.launch, 'Debug launch', },
            ['<leader>dc'] = { debugger.continue, 'Debug continue', },
            ['<f5>'] = { debugger.continue, 'Debug continue', },
            ['<leader>dr'] = { debugger.restart, 'Debug restart', },
            ['<s-f5>'] = { debugger.restart, 'Debug restart', },
            ['<f17>'] = { debugger.restart, 'Debug restart', },
            ['<leader>dp'] = { debugger.pause, 'Debug pause', },
            ['<f6>'] = { debugger.pause, 'Debug pause', },
            ['<leader>ds'] = { debugger.stop, 'Debug stop', },
            ['<s-f6>'] = { debugger.stop, 'Debug stop', },
            ['<f18>'] = { debugger.stop, 'Debug stop', },
            ['<leader>db'] = { debugger.breakpoint, 'Debug breakpoint', },
            ['<f9>'] = { debugger.breakpoint, 'Debug breakpoint', },
            ['<leader><leader>db'] = { debugger.breakpoint_cond, 'Debug conditional breakpoint', },
            ['<s-f9>'] = { debugger.breakpoint_cond, 'Debug conditional breakpoint', },
            ['<f21>'] = { debugger.breakpoint_cond, 'Debug conditional breakpoint', },
            ['<leader>df'] = { debugger.breakpoint_function, 'Debug function breakpoint', },
            ['<leader><f9>'] = { debugger.breakpoint_function, 'Debug function breakpoint', },
            ['<leader>dB'] = { debugger.clear_breakpoints, 'Debug clear breakpoints', },
            ['<leader><leader><f9>'] = { debugger.clear_breakpoints, 'Debug clear breakpoints', },
            ['<leader>dn'] = { debugger.step_over, 'Debug step over', },
            ['<f10>'] = { debugger.step_over, 'Debug step over', },
            ['<leader>di'] = { debugger.step_into, 'Debug step into', },
            ['<F11>'] = { debugger.step_into, 'Debug step into', },
            ['<leader>do'] = { debugger.step_out, 'Debug step out', },
            ['<s-f11>'] = { debugger.step_out, 'Debug step out', },
            ['<f23>'] = { debugger.step_out, 'Debug step out', },
            ['<leader>dN'] = { debugger.run_to_cursor, 'Debug run to cursor', },
            ['<C-F10>'] = { debugger.run_to_cursor, 'Debug run to cursor', },
            ['<f34>'] = { debugger.run_to_cursor, 'Debug run to cursor', },
            ['<leader>dD'] = { debugger.disassemble, 'Debug disassemble', },
            ['<leader>de'] = { debugger.eval_window, 'Debug eval window', },
            ['<leader>du'] = { debugger.reset_ui, 'Debugger reset UI', },
            ['<leader>dU'] = { debugger.toggle_ui, 'Debugger toggle UI', },
            ['<leader>dq'] = { debugger.reset, 'Debug close', },
            ['<leader>ca'] = { source_index.cscope_assignments, 'CScope assignments', },
            ['<leader>cc'] = { source_index.cscope_function_calling, 'CScope function calling', },
            ['<leader>cd'] = { source_index.cscope_functions_called_by, 'CScope functions called by', },
            ['<leader>ce'] = { source_index.cscope_egrep, 'CScope egrep', },
            ['<leader>cf'] = { source_index.cscope_file, 'CScope file', },
            ['<leader>cg'] = { source_index.cscope_definition, 'CScope definition', },
            ['<leader>ci'] = { source_index.cscope_files_including, 'CScope files including', },
            ['<leader>cs'] = { source_index.cscope_symbol, 'CScope symbol', },
            ['<leader>ct'] = { source_index.cscope_text, 'CScope text', },
            ['<leader><leader>ca'] = { source_index.cscope_assignments, 'CScope assignments', },
            ['<leader><leader>cc'] = { source_index.cscope_input_function_calling, 'CScope function calling (input)', },
            ['<leader><leader>cd'] = { source_index.cscope_input_functions_called_by,
                'CScope functions called by (input)', },
            ['<leader><leader>ce'] = { source_index.cscope_input_egrep, 'CScope egrep (input)', },
            ['<leader><leader>cf'] = { source_index.cscope_input_file, 'CScope file (input)', },
            ['<leader><leader>cg'] = { source_index.cscope_input_definition, 'CScope definition (input)', },
            ['<leader><leader>ci'] = { source_index.cscope_input_files_including, 'CScope files including (input)', },
            ['<leader><leader>cs'] = { source_index.cscope_input_symbol, 'CScope symbol (input)', },
            ['<leader><leader>ct'] = { source_index.cscope_input_text, 'CScope text (input)', },
            ['gw'] = { source_index.opengrok_query_f, 'Opengrok query symbol', },
            ['gW'] = { source_index.opengrok_query_d, 'Opengrok query symbol defintiion', },
            ['<leader>gw'] = { source_index.opengrok_query_input_f, 'Opengrok query symbol (input)', },
            ['<leader>gW'] = { source_index.opengrok_query_input_d, 'Opengrok query symbol defintiion (input)', },
            ['<leader>o'] = { ':pop<cr>', 'Pop tag stack', },
            ['<leader>i'] = { ':tag<cr>', 'Unpop tag stack', },
            ['<leader>gcp'] = { source_index.generate_cpp, 'Generate cpp index', },
            ['<leader>gt'] = { source_index.generate_tags, 'Generate common tags', },
            ['<leader>gT'] = { source_index.generate_all_tags, 'Generate all tags', },
            ['<leader>gf'] = { source_index.generate_source_files_list, 'Generate source files list/cache', },
            ['<leader>gF'] = { source_index.generate_all_files_list, 'Generate all files list/cache', },
            ['<leader>gcf'] = { source_index.generate_flags, 'Generate flags', },
            ['<leader>go'] = { source_index.generate_opengrok, 'Generate opengrok', },
            ['<leader>ga'] = { source_index.generate_cpp_and_opengrok, 'Generate cpp and opengrok', },
            ['<leader><leader>gc'] = { source_index.clean, 'Clean', },
            ['<leader>cp'] = { finder.color_picker, 'Pick color', },
            ['<leader>p'] = { '<cmd>YankHistoryRgPaste<cr>', 'Paste from history', },
            ['<f1>'] = { '<cmd>set relativenumber!<cr>', 'Relative number', },
            ['<f2>'] = { '<cmd>set number!<cr>', 'Number', },
            ['<leader>bt'] = { '<cmd>lua require "barbecue.ui".toggle()<cr>', 'Toggle barbecue bar', },
            ['<leader><leader>lf'] = { '<cmd>lua require "plugins.large_files".set()<cr>', 'Set large file', },
            ['gp'] = { '<cmd>lua require("goto-preview").goto_preview_definition()<CR>', 'Goto definition preview', },
            ['<leader>gp'] = { '<cmd>lua require("goto-preview").close_all_win()<CR>', 'Close preview windows', },
            ['<leader><leader>p'] = { pin.pin, 'Pin window' },
            ['<leader><leader>P'] = { pin.unpin, 'Unpin window' },
            ['ms'] = { '<plug>(VM-Find-Under)', 'Multicursor Select Word' },
            ['mm'] = { '<plug>(VM-Add-Cursor-At-Pos)', 'Multicursor Add Cursor' },
            ['mA'] = { '<plug>(VM-Select-All)', 'Multicursor Select All' },
            ['m/'] = { '<plug>(VM-Start-Regex-Search)', 'Multicursor Search' },
            ['<c-j>'] = { '<plug>(VM-Add-Cursor-Down)', 'Add cursor down', },
            ['<c-k>'] = { '<plug>(VM-Add-Cursor-Up)', 'Add cursor down', },
        },
        x = {
            ['<tab>'] = { '%', 'Jump to matching pairs', },
            ['<leader>='] = { '<c-a>', 'Increment', },
            ['<leader>-'] = { '<c-x>', 'Decrement', },
            ['<c-a>'] = { '<esc>ggVG', 'Select all', },
            ['<c-c>'] = { clipboard.copy, 'Copy', },
            ['<c-x>'] = { clipboard.cut, 'Cut', },
            ['<c-l>'] = { indent_guides.refresh_trigger('20zl', { expr = false }), 'Side scrolling', },
            ['<c-h>'] = { indent_guides.refresh_trigger('20zh', { expr = false }), 'Side scrolling', },
            ['gf'] = { lsp.format_selected, 'Format selected', },
            ['<c-r>'] = { lsp.select_snippets, 'Select snippets', },
            ['<f1>'] = { ':set relativenumber!<cr>', 'Relative number', },
            ['<f2>'] = { ':set number!<cr>', 'Number', },
            ['ms'] = { '<plug>(VM-Find-Subword-Under)', 'Multicursor Select Subword' },
            ['mf'] = { '<plug>(VM-Visual-Find)', 'Multicursor Visual Find' },
            ['mc'] = { '<plug>(VM-Visual-Cursors)', 'Multicursor Visual Cursors' },
            ['ma'] = { '<plug>(VM-Visual-Add)', 'Multicursor Add Region' },
            ['mA'] = { '<plug>(VM-Visual-All)', 'Multicursor Select All' },
            ['m/'] = { '<plug>(VM-Visual-Regex)', 'Multicursor Search' },
        },
        v = {
        },
        i = {
            ['<c-s>'] = { '<c-o>:w<cr>', 'Save file', },
            ['<c-a>'] = { '<esc>ggVG', 'Select all', },
            ['<c-v>'] = { clipboard.paste, 'Paste', },
            ['<f7>'] = { tasks.build_project, 'Build project task', },
            ['<c-f5>'] = { tasks.run_project, 'Run project task', },
            ['<f29>'] = { tasks.run_project, 'Run project task', },
            ['<s-f7>'] = { tasks.clean_project, 'Clean project task', },
            ['<f19>'] = { tasks.clean_project, 'Clean project task', },
            ['<c-f7>'] = { tasks.run_project, 'Configure project task', },
            ['<f31>'] = { tasks.build_config, 'Build config', },
            ['<c-d>'] = { lsp.expand_snippets, 'Expand snippets (with nvim-lsp just use tab to select then enter)', },
            ['<c-w>'] = { '<nop>', 'Window motion', },
            ['<c-w>h'] = { function() cmd 'stopinsert'; tmux_navigator.tmux_navigate_left() end, 'Navigate left', },
            ['<c-w>j'] = { function() cmd 'stopinsert'; tmux_navigator.tmux_navigate_down() end, 'Navigate down', },
            ['<c-w>k'] = { function() cmd 'stopinsert'; tmux_navigator.tmux_navigate_up() end, 'Navigate right', },
            ['<c-w>l'] = { function() cmd 'stopinsert'; tmux_navigator.tmux_navigate_right() end, 'Navigate up', },
        },
        t = {
            ['<c-w>w'] = { '<c-\\><c-n>:q<cr>', 'Close terminal', },
            ['<c-w>n'] = { '<c-\\><c-n>', 'Terminal normal mode', },
            ['<c-w>h'] = { tmux_navigator.tmux_navigate_left, 'Navigate left', },
            ['<c-w>j'] = { tmux_navigator.tmux_navigate_down, 'Navigate down', },
            ['<c-w>k'] = { tmux_navigator.tmux_navigate_up, 'Navigate right', },
            ['<c-w>l'] = { tmux_navigator.tmux_navigate_right, 'Navigate up', },
            ['<c-w><left>'] = { tmux_navigator.tmux_navigate_left, 'Navigate left', },
            ['<c-w><down>'] = { tmux_navigator.tmux_navigate_down, 'Navigate down', },
            ['<c-w><up>'] = { tmux_navigator.tmux_navigate_up, 'Navigate right', },
            ['<c-w><right>'] = { tmux_navigator.tmux_navigate_right, 'Navigate up', },
        },
        c = {
            ['<c-k>'] = { '<plug>CmdlineCompleteBackward', 'Complete prev in vim command mode', },
            ['<c-j>'] = { '<plug>CmdlineCompleteForward', 'Complete next in vim command mode', },
        },
    }

    keys.register(mappings.n, { mode = 'n' })
    keys.register(mappings.x, { mode = 'x' })
    keys.register(mappings.v, { mode = 'v' })
    keys.register(mappings.i, { mode = 'i' })
    keys.register(mappings.t, { mode = 't' })
    keys.register(mappings.c, { mode = 'c' })

    -- Internal mappings

    keys.register(
        {
            ['<scrollwheelleft>'] = { indent_guides.refresh_trigger('<scrollwheelleft>', { expr = true }),
                'Refresh indent guides on horizontal scroll' },
            ['<scrollwheelright>'] = { indent_guides.refresh_trigger('<scrollwheelright>', { expr = true }),
                'Refresh indent guides on horizontal scroll' },
        }, { mode = 'n', expr = true })
    keys.register(
        {
            ['<scrollwheelleft>'] = { indent_guides.refresh_trigger('<scrollwheelleft>', { expr = true }),
                'Refresh indent guides on horizontal scroll' },
            ['<scrollwheelright>'] = { indent_guides.refresh_trigger('<scrollwheelright>', { expr = true }),
                'Refresh indent guides on horizontal scroll' },
        }, { mode = 'x', expr = true })

    keys.register({

        ['<scrollwheelleft>'] = { '<nop>', 'Disable terminal horizontal scrolling', },
        ['<scrollwheelright>'] = { '<nop>', 'Disable terminal horizontal scrolling', },
        ['<mousemove>'] = { '<nop>', 'Disable terminal mouse move', },
    }, { mode = 't' })

    if jump.needs_mapping then
        local jump_mappings = {
            n = {
                ['s'] = { jump.search_jump, 'Search and jump to location' },
                ['f'] = { jump.find_jump, 'Find and jump to location' },
                ['F'] = { jump.find_jump_back, 'Find backwards and jump to location' },
                ['t'] = { jump.till_jump, 'Find and jump until location' },
                ['T'] = { jump.till_jump_back, 'Find backwards and jump until location' },
            },
            x = {
                ['s'] = { jump.search_jump_visual, 'Search and jump to location' },
                ['S'] = { jump.search_jump_back_visual, 'Search backwards and jump to location' },
                ['f'] = { jump.find_jump, 'Find and jump to location' },
                ['F'] = { jump.find_jump_back, 'Find backwards and jump to location' },
                ['t'] = { jump.till_jump, 'Find and jump until location' },
                ['T'] = { jump.till_jump_back, 'Find backwards and jump until location' },
            }
        }
        keys.register(jump_mappings.n, { mode = 'n' })
        keys.register(jump_mappings.x, { mode = 'x' })
    end

    if lsp.completion_mappings then
        keys.register({
            ['<tab>'] = { lsp.tab, 'Lsp complete' },
            ['<s-tab>'] = { lsp.shift_tab, ' Lsp prev complete' },
            ['<cr>'] = { lsp.enter, 'Lsp enter' },
        }, { mode = 'i', expr = true })
    end

    if user.settings.pairs == 'pear-tree' then
        keys.register({
            ['<bs>'] = { '<plug>(PearTreeBackspace)', 'Pear tree internal backspace processing' },
        }, { mode = 'i' })
        if user.settings.lsp ~= 'coc' and user.settings.format_on_pairs then
            keys.register({
                ['<cr>'] = { '<plug>(PearTreeExpand)', 'Pear tree internal enter processing' },
            }, { mode = 'i' })
        end
    end
end

return m

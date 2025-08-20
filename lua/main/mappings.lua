local m = {}
local expand = vim.fn.expand
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local root_paths = require 'main.root-paths'
local paste = require 'builtins.paste'
local clipboard = require 'builtins.clipboard'
local map = vim.keymap.set

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
    local source_index = require 'plugins.source-index'
    local lsp = require 'plugins.lsp'
    local finder = require 'plugins.finder'
    local whitespace = require 'plugins.whitespace'
    local tmux_navigator = require 'plugins.config.tmux-navigator'
    local git = require 'plugins.git'
    local explorers = require 'plugins.explorers'
    local zoom = require 'plugins.zoom'
    local fold = require 'plugins.fold'
    local buffers = require 'plugins.buffers'
    local binary_view = require 'plugins.binary-view'
    local disasm_view = require 'plugins.disasm-view'
    local tasks = require 'plugins.tasks'
    local debugger = require 'plugins.debugger'
    local jump = require 'plugins.jump'
    local indent_guides = require 'plugins.indent-guides'
    local quickfix = require 'plugins.quickfix'
    local terminal = require 'plugins.terminal'
    local pin = require 'plugins.pin'
    local ai_chat = require 'plugins.ai-chat'
    local _ = require 'which-key'

    local mappings = {
        n = {
            ['<space>?'] = { '<cmd>WhichKey<cr>', 'Show all key bindings (which-key)' },
            ['g?'] = { finder.keymaps, 'Search key bindings (finder.keymaps)' },
            ['Y'] = { 'y$', 'Yank to end of line (y$)' },
            ['g['] = { '0', 'Go to beginning of line (0)' },
            ['g]'] = { '$', 'Go to end of line ($)' },
            ['`'] = { '<cmd>noh<cr>', 'Clear search highlights (nohlsearch)' },
            ['<leader><c-q>'] = { '<c-v>', 'Visual block mode' },
            ['<c-w>w'] = { '<cmd>q<cr>', 'Close current window (quit)' },
            ['<c-w>g'] = { explorers.file.open, 'Open file explorer (explorers.file.open)' },
            ['<c-w>;'] = { explorers.code.open, 'Open code explorer (explorers.code.open)' },
            ['<c-w>e'] = { explorers.close, 'Close all explorers (explorers.close)' },
            ['<c-w><space>'] = { explorers.toggle, 'Toggle all explorers (explorers.toggle)' },
            ['<c-w><cr>'] = { explorers.arrange, 'Arrange explorers (explorers.arrange)' },
            ['<c-s>'] = { '<cmd>w<cr>', 'Save file (write)' },
            ['<leader>='] = { '<c-a>', 'Increment number under cursor (Ctrl-A)' },
            ['<leader>-'] = { '<c-x>', 'Decrement number under cursor (Ctrl-X)' },
            ['<c-a>'] = { 'ggVG', 'Select all text (ggVG)' },
            ['<c-v>'] = { clipboard.paste, 'Paste from clipboard (clipboard.paste)' },
            ['<s-f8>'] = { paste.toggle, 'Toggle paste mode (paste.toggle)' },
            ['<f20>'] = { paste.toggle, 'Toggle paste mode (paste.toggle)' },
            ['L'] = { '<cmd>vertical resize +5<cr>', 'Increase window width (vertical resize +5)' },
            ['H'] = { '<cmd>vertical resize -5<cr>', 'Decrease window width (vertical resize -5)' },
            ['zk'] = { '<cmd>horizontal resize +3<cr>', 'Increase window height (horizontal resize +3)' },
            ['zj'] = { '<cmd>horizontal resize -3<cr>', 'Decrease window height (horizontal resize -3)' },
            ['<c-w>z'] = { zoom.toggle_zoom, 'Toggle window zoom (zoom.toggle_zoom)' },
            ['<c-w>b'] = { terminal.open_below, 'Open terminal below (terminal.open_below)' },
            ['<c-w>B'] = { terminal.split_below, 'Split terminal below (terminal.split_below)' },
            ['<c-w>t'] = { terminal.open_split, 'Open terminal right (terminal.open_split)' },
            ['<c-w>a'] = { ai_chat.toggle, 'Toggle AI chat window (ai_chat.toggle)' },
            ['<c-l>'] = { indent_guides.refresh_trigger('20zl', { expr = false }), 'Scroll right 20 columns (indent guides refresh)' },
            ['<c-h>'] = { indent_guides.refresh_trigger('20zh', { expr = false }), 'Scroll left 20 columns (indent guides refresh)' },
            ['<leader>rw'] = { whitespace.strip, 'Remove trailing whitespace (whitespace.strip)' },
            ['<leader>tw'] = { whitespace.toggle, 'Toggle whitespace visibility (whitespace.toggle)' },
            ['<leader>ts'] = { ':set spell! spelloptions=camel spelllang=en<cr>', 'Toggle spell checking (set spell)' },
            ['cro'] = { root_paths.switch_to_root, 'Change directory to project root (root_paths.switch_to_root)' },
            ['cp'] = { root_paths.switch_to_project_root, 'Change directory to project root (root_paths.switch_to_project_root)' },
            ['<leader>ef'] = { explorers.display_current_file, 'Show current file path (explorers.display_current_file)' },
            ['<leader>cq'] = { explorers.display_current_directory, 'Show current directory path (explorers.display_current_directory)' },
            ['cd'] = { function() cmd('cd ' .. expand('%:p:h')) end, 'Change directory to current file location (cd %:p:h)' },
            ['cu'] = { function() cmd('cd ..') end, 'Change directory up one level (cd ..)' },
            ['gb'] = { git.git_blame, 'Show git blame for current file (git.git_blame)' },
            ['grd'] = { '<cmd>DiffviewOpen<cr>', 'Show diff view (DiffViewOpen)' },
            ['grq'] = { '<cmd>DiffviewClose<cr>', 'Close diff view (DiffViewClose)' },
            ['grf'] = { '<cmd>DiffviewFileHistory %<cr>', 'Show diff view for current file (DiffviewFileHistory %)' },
            ['grh'] = { '<cmd>DiffviewFileHistory<cr>', 'Show diff view for current branch (DiffviewFileHistory)' },
            ['gl'] = { git.show_git, 'Show git status (git.show_git)' },
            ['gm'] = { git.show_staging_buffer, 'Show git staging buffer (git.show_staging_buffer)' },
            ['gs'] = { source_index.goto_symbol_definition, 'Go to indexed symbol definition (source_index.goto_symbol_definition)' },
            ['gS'] = { source_index.goto_symbol_declaration, 'Go to indexed symbol declaration (source_index.goto_symbol_declaration)' },
            ['<leader>gs'] = { source_index.goto_symbol_definition_input, 'Go to indexed symbol definition (prompt for input) (source_index.goto_symbol_definition_input)' },
            ['<leader>gS'] = { source_index.goto_symbol_declaration_input, 'Go to indexed symbol declaration (prompt for input) (source_index.goto_symbol_declaration_input)' },
            ['gd'] = { lsp.goto_definition, 'Go to LSP definition (lsp.goto_definition)' },
            ['<leader>gd'] = { lsp.show_definitions, 'Show all LSP definitions (lsp.show_definitions)' },
            ['gD'] = { lsp.goto_declaration, 'Go to LSP declaration (lsp.goto_declaration)' },
            ['<leader><leader>gd'] = { lsp.goto_definition_sync, 'Go to LSP definition (sync) (lsp.goto_definition_sync)' },
            ['grr'] = { lsp.show_references, 'Show LSP references (lsp.show_references)' },
            ['gra'] = { lsp.code_action, 'Show LSP code actions (lsp.code_action)' },
            ['<leader>qf'] = { lsp.quick_fix, 'Apply LSP quick fix (lsp.quick_fix)' },
            ['<leader>gy'] = { lsp.type_definition, 'Go to LSP type definition (lsp.type_definition)' },
            ['grs'] = { lsp.switch_source_header, 'Switch between source/header (lsp.switch_source_header)' },
            ['go'] = { lsp.switch_source_header, 'Switch between source/header (lsp.switch_source_header)' },
            ['K'] = { lsp.show_documentation, 'Show documentation (hover) (lsp.show_documentation)' },
            ['[d'] = { lsp.prev_diagnostic, 'Go to previous diagnostic (lsp.prev_diagnostic)' },
            [']d'] = { lsp.next_diagnostic, 'Go to next diagnostic (lsp.next_diagnostic)' },
            ['<leader>rn'] = { lsp.rename, 'Rename symbol (LSP rename)' },
            ['<leader>ld'] = { lsp.list_diagnostics, 'List all diagnostics (lsp.list_diagnostics)' },
            ['<leader><leader><tab>'] = { finder.find_buffer, 'Find buffer (finder.find_buffer)' },
            ['<c-p>'] = { finder.find_file, 'Find file (fuzzy) (finder.find_file)' },
            ['<leader><c-p>'] = { finder.find_file_list, 'Find file with cache (finder.find_file_list)' },
            ['<leader><leader><c-p>'] = { finder.find_file_list_invalidate, 'Find file (invalidate cache) (finder.find_file_list_invalidate)' },
            ['<c-]>'] = { finder.find_file_hidden, 'Find hidden file (finder.find_file_hidden)' },
            ['<leader><c-]>'] = { finder.find_file_list_hidden, 'Find hidden file with cache (finder.find_file_list_hidden)' },
            ['<leader><leader><c-]>'] = { finder.find_file_list_hidden_invalidate, 'Find hidden file (invalidate cache) (finder.find_file_list_hidden_invalidate)' },
            ['<c-g>'] = { finder.find_in_files, 'Search in all files (fuzzy) (finder.find_in_files)' },
            ['<c-\\>'] = { finder.find_in_files_precise, 'Search in all files (precise) (finder.find_in_files_precise)' },
            ['<leader><c-\\>'] = { finder.find_in_files_precise_native, 'Search in all files (native, precise) (finder.find_in_files_precise_native)' },
            ['g<c-g>'] = { finder.find_current_in_files, 'Search in current file (fuzzy) (finder.find_current_in_files)' },
            ['g<c-\\>'] = { finder.find_current_in_files_precise, 'Search in current file (precise) (finder.find_current_in_files_precise)' },
            ['g<leader><c-\\>'] = { finder.find_current_in_files_precise_native, 'Search in current file (native, precise) (finder.find_current_in_files_precise_native)' },
            ['//'] = { finder.find_line, 'Find line in current file (finder.find_line)' },
            ['??'] = { finder.browse_help, 'Browse help (finder.browse_help)' },
            ['<leader>:'] = { finder.command_history, 'Command history (finder.command_history) '},
            ['<leader>ss'] = { finder.lsp_workspace_symbols, 'LSP workspace symbols (finder.lsp_workspace_symbols)' },
            ['<c-w>h'] = { tmux_navigator.tmux_navigate_left, 'Navigate left (tmux/vim window)' },
            ['<c-w>j'] = { tmux_navigator.tmux_navigate_down, 'Navigate down (tmux/vim window)' },
            ['<c-w>k'] = { tmux_navigator.tmux_navigate_up, 'Navigate up (tmux/vim window)' },
            ['<c-w>l'] = { tmux_navigator.tmux_navigate_right, 'Navigate right (tmux/vim window)' },
            ['<c-w><left>'] = { tmux_navigator.tmux_navigate_left, 'Navigate left (tmux/vim window)' },
            ['<c-w><down>'] = { tmux_navigator.tmux_navigate_down, 'Navigate down (tmux/vim window)' },
            ['<c-w><up>'] = { tmux_navigator.tmux_navigate_up, 'Navigate up (tmux/vim window)' },
            ['<c-w><right>'] = { tmux_navigator.tmux_navigate_right, 'Navigate right (tmux/vim window)' },
            ['<leader>u'] = { fold.toggle, 'Toggle code fold (fold.toggle)' },
            ['<c-w>,'] = { buffers.prev_buffer, 'Previous buffer (buffers.prev_buffer)' },
            ['<c-w>.'] = { buffers.next_buffer, 'Next buffer (buffers.next_buffer)' },
            ['<s-tab>'] = { buffers.prev_buffer, 'Previous buffer (buffers.prev_buffer)' },
            ['<tab>'] = { buffers.next_buffer, 'Next buffer (buffers.next_buffer)' },
            ['<c-w>d'] = { buffers.delete_buffer, 'Close buffer (buffers.delete_buffer)' },
            ['<leader>1'] = { buffers.switch_to_buffer(1), 'Switch to buffer 1 (buffers.switch_to_buffer(1))' },
            ['<leader>2'] = { buffers.switch_to_buffer(2), 'Switch to buffer 2 (buffers.switch_to_buffer(2))' },
            ['<leader>3'] = { buffers.switch_to_buffer(3), 'Switch to buffer 3 (buffers.switch_to_buffer(3))' },
            ['<leader>4'] = { buffers.switch_to_buffer(4), 'Switch to buffer 4 (buffers.switch_to_buffer(4))' },
            ['<leader>5'] = { buffers.switch_to_buffer(5), 'Switch to buffer 5 (buffers.switch_to_buffer(5))' },
            ['<leader>6'] = { buffers.switch_to_buffer(6), 'Switch to buffer 6 (buffers.switch_to_buffer(6))' },
            ['<leader>7'] = { buffers.switch_to_buffer(7), 'Switch to buffer 7 (buffers.switch_to_buffer(7))' },
            ['<leader>8'] = { buffers.switch_to_buffer(8), 'Switch to buffer 8 (buffers.switch_to_buffer(8))' },
            ['<leader>9'] = { buffers.switch_to_buffer(9), 'Switch to buffer 9 (buffers.switch_to_buffer(9))' },
            ['<leader>0'] = { buffers.switch_to_buffer(0), 'Switch to buffer 10 (buffers.switch_to_buffer(0))' },
            ['<leader><tab>'] = { buffers.pick_buffer, 'Pick buffer interactively (buffers.pick_buffer)' },
            ['<c-w>p'] = { ':below copen<cr>', 'Open quickfix list below (copen)' },
            ['<c-w>m'] = { quickfix.map_open, 'Go to quickfix entry (quickfix.map_open)' },
            ['<c-w>q'] = { ':cclose<cr>', 'Close quickfix list (cclose)' },
            ['-'] = { ':setlocal wrap! lbr!<cr>', 'Toggle word wrap (setlocal wrap lbr)' },
            ['cr'] = { '<plug>(abolish-coerce-word)', 'Change word case (abolish-coerce-word)' },
            ['<leader>bv'] = { binary_view.binary_view, 'Show binary view (xxd) (binary_view.binary_view)' },
            ['<leader>dv'] = { disasm_view.disasm_view, 'Show disassembly view (disasm_view.disasm_view)' },
            ['<f7>'] = { tasks.build_project, 'Build project (tasks.build_project)' },
            ['<c-f5>'] = { tasks.run_project, 'Run project (tasks.run_project)' },
            ['<f29>'] = { tasks.run_project, 'Run project (tasks.run_project)' },
            ['<s-f7>'] = { tasks.clean_project, 'Clean project (tasks.clean_project)' },
            ['<f19>'] = { tasks.clean_project, 'Clean project (tasks.clean_project)' },
            ['<c-f7>'] = { tasks.run_project, 'Run project (tasks.run_project)' },
            ['<f31>'] = { tasks.build_config, 'Build project config (tasks.build_config)' },
            ['<leader>as'] = { tasks.stop, 'Stop task (tasks.stop) '},
            ['<leader>dl'] = { debugger.launch_settings, 'Debug: launch settings (debugger.launch_settings)' },
            ['<leader>dj'] = { debugger.launch_settings, 'Debug: launch settings (json) (debugger.launch_settings)' },
            ['<leader>dd'] = { debugger.launch, 'Debug: launch (debugger.launch)' },
            ['<leader>dc'] = { debugger.continue, 'Debug: continue (debugger.continue)' },
            ['<f5>'] = { debugger.continue, 'Debug: continue (debugger.continue)' },
            ['<leader>dr'] = { debugger.restart, 'Debug: restart (debugger.restart)' },
            ['<s-f5>'] = { debugger.restart, 'Debug: restart (debugger.restart)' },
            ['<f17>'] = { debugger.restart, 'Debug: restart (debugger.restart)' },
            ['<leader>dp'] = { debugger.pause, 'Debug: pause (debugger.pause)' },
            ['<f6>'] = { debugger.pause, 'Debug: pause (debugger.pause)' },
            ['<leader>ds'] = { debugger.stop, 'Debug: stop (debugger.stop)' },
            ['<s-f6>'] = { debugger.stop, 'Debug: stop (debugger.stop)' },
            ['<f18>'] = { debugger.stop, 'Debug: stop (debugger.stop)' },
            ['<leader>db'] = { debugger.breakpoint, 'Debug: toggle breakpoint (debugger.breakpoint)' },
            ['<f9>'] = { debugger.breakpoint, 'Debug: toggle breakpoint (debugger.breakpoint)' },
            ['<leader><leader>db'] = { debugger.breakpoint_cond, 'Debug: conditional breakpoint (debugger.breakpoint_cond)' },
            ['<s-f9>'] = { debugger.breakpoint_cond, 'Debug: conditional breakpoint (debugger.breakpoint_cond)' },
            ['<f21>'] = { debugger.breakpoint_cond, 'Debug: conditional breakpoint (debugger.breakpoint_cond)' },
            ['<leader>df'] = { debugger.breakpoint_function, 'Debug: function breakpoint (debugger.breakpoint_function)' },
            ['<leader><f9>'] = { debugger.breakpoint_function, 'Debug: function breakpoint (debugger.breakpoint_function)' },
            ['<leader>dB'] = { debugger.clear_breakpoints, 'Debug: clear all breakpoints (debugger.clear_breakpoints)' },
            ['<leader><leader><f9>'] = { debugger.clear_breakpoints, 'Debug: clear all breakpoints (debugger.clear_breakpoints)' },
            ['<leader>dn'] = { debugger.step_over, 'Debug: step over (debugger.step_over)' },
            ['<f10>'] = { debugger.step_over, 'Debug: step over (debugger.step_over)' },
            ['<leader>di'] = { debugger.step_into, 'Debug: step into (debugger.step_into)' },
            ['<f11>'] = { debugger.step_into, 'Debug: step into (debugger.step_into)' },
            ['<leader>do'] = { debugger.step_out, 'Debug: step out (debugger.step_out)' },
            ['<s-f11>'] = { debugger.step_out, 'Debug: step out (debugger.step_out)' },
            ['<f23>'] = { debugger.step_out, 'Debug: step out (debugger.step_out)' },
            ['<leader>dN'] = { debugger.run_to_cursor, 'Debug: run to cursor (debugger.run_to_cursor)' },
            ['<c-f10>'] = { debugger.run_to_cursor, 'Debug: run to cursor (debugger.run_to_cursor)' },
            ['<f34>'] = { debugger.run_to_cursor, 'Debug: run to cursor (debugger.run_to_cursor)' },
            ['<leader>dD'] = { debugger.disassemble, 'Debug: disassemble (debugger.disassemble)' },
            ['<leader>de'] = { debugger.eval_window, 'Debug: eval window (debugger.eval_window)' },
            ['<leader>du'] = { debugger.reset_ui, 'Debug: reset UI (debugger.reset_ui)' },
            ['<leader>dU'] = { debugger.toggle_ui, 'Debug: toggle UI (debugger.toggle_ui)' },
            ['<leader>dq'] = { debugger.reset, 'Debug: close/reset (debugger.reset)' },
            ['grc'] = { '<nop>', 'CScope action' },
            ['grca'] = { source_index.cscope_assignments, 'CScope: find assignments (cscope_assignments)' },
            ['grcc'] = { source_index.cscope_function_calling, 'CScope: find function calling (cscope_function_calling)' },
            ['grcd'] = { source_index.cscope_functions_called_by, 'CScope: find functions called by (cscope_functions_called_by)' },
            ['grce'] = { source_index.cscope_egrep, 'CScope: egrep (cscope_egrep)' },
            ['grcf'] = { source_index.cscope_file, 'CScope: find file (cscope_file)' },
            ['grcg'] = { source_index.cscope_definition, 'CScope: find definition (cscope_definition)' },
            ['grci'] = { source_index.cscope_files_including, 'CScope: find files including (cscope_files_including)' },
            ['grcs'] = { source_index.cscope_symbol, 'CScope: find symbol (cscope_symbol)' },
            ['grct'] = { source_index.cscope_text, 'CScope: find text (cscope_text)' },
            ['<leader>ca'] = { source_index.cscope_input_assignments, 'CScope: find assignments (input) (cscope_assignments)' },
            ['<leader>cc'] = { source_index.cscope_input_function_calling, 'CScope: find function calling (input) (cscope_input_function_calling)' },
            ['<leader>cd'] = { source_index.cscope_input_functions_called_by, 'CScope: find functions called by (input) (cscope_input_functions_called_by)' },
            ['<leader>ce'] = { source_index.cscope_input_egrep, 'CScope: egrep (input) (cscope_input_egrep)' },
            ['<leader>cf'] = { source_index.cscope_input_file, 'CScope: find file (input) (cscope_input_file)' },
            ['<leader>cg'] = { source_index.cscope_input_definition, 'CScope: find definition (input) (cscope_input_definition)' },
            ['<leader>ci'] = { source_index.cscope_input_files_including, 'CScope: find files including (input) (cscope_input_files_including)' },
            ['<leader>cs'] = { source_index.cscope_input_symbol, 'CScope: find symbol (input) (cscope_input_symbol)' },
            ['<leader>ct'] = { source_index.cscope_input_text, 'CScope: find text (input) (cscope_input_text)' },
            ['gw'] = { source_index.opengrok_query_f, 'Opengrok: query symbol (opengrok_query_f)' },
            ['gW'] = { source_index.opengrok_query_d, 'Opengrok: query symbol definition (opengrok_query_d)' },
            ['gro'] = { '<nop>', 'Opengrok action' },
            ['grow'] = { source_index.opengrok_query_f, 'Opengrok: query symbol (opengrok_query_f)' },
            ['grod'] = { source_index.opengrok_query_d, 'Opengrok: query symbol definition (opengrok_query_d)' },
            ['groi'] = { source_index.opengrok_query_input_f, 'Opengrok: query symbol (input) (opengrok_query_input_f)' },
            ['<leader>gw'] = { source_index.opengrok_query_input_f, 'Opengrok: query symbol (input) (opengrok_query_input_f)' },
            ['<leader>gW'] = { source_index.opengrok_query_input_d, 'Opengrok: query symbol definition (input) (opengrok_query_input_d)' },
            ['<leader>o'] = { ':pop<cr>', 'Pop tag stack (pop)' },
            ['<leader>i'] = { ':tag<cr>', 'Unpop tag stack (tag)' },
            ['grx'] = { '<nop>', 'Create/update a source index' },
            ['grxa'] = { source_index.generate_cpp_and_opengrok, 'Generate C++ and opengrok index (generate_cpp_and_opengrok)' },
            ['grxp'] = { source_index.generate_cpp, 'Generate C++ index (generate_cpp)' },
            ['grxt'] = { source_index.generate_tags, 'Generate tags (generate_tags)' },
            ['grxT'] = { source_index.generate_all_tags, 'Generate all tags (generate_all_tags)' },
            ['grxf'] = { source_index.generate_source_files_list, 'Generate source files list/cache (generate_source_files_list)' },
            ['grxF'] = { source_index.generate_all_files_list, 'Generate all files list/cache (generate_all_files_list)' },
            ['grxcf'] = { source_index.generate_flags, 'Generate flags (generate_flags)' },
            ['grxo'] = { source_index.generate_opengrok, 'Generate opengrok index (generate_opengrok)' },
            ['<leader><leader>gc'] = { source_index.clean, 'Clean source index (clean)' },
            ['<leader>cp'] = { finder.color_picker, 'Pick color (color_picker)' },
            ['<leader>p'] = { '<cmd>YankHistoryRgPaste<cr>', 'Paste from yank history (YankHistoryRgPaste)' },
            ['<f1>'] = { '<cmd>set relativenumber!<cr>', 'Toggle relative line numbers (set relativenumber)' },
            ['<f2>'] = { '<cmd>set number!<cr>', 'Toggle absolute line numbers (set number)' },
            ['<leader>bt'] = { '<cmd>lua require "barbecue.ui".toggle()<cr>', 'Toggle barbecue bar (barbecue.ui.toggle)' },
            ['<leader><leader>lf'] = { '<cmd>lua require "plugins.large-files".set()<cr>', 'Set large file mode (plugins.large_files.set)' },
            ['gp'] = { '<cmd>lua require "goto-preview".goto_preview_definition()<CR>', 'Preview definition (goto-preview)' },
            ['<leader>gp'] = { '<cmd>lua require "goto-preview".close_all_win()<CR>', 'Close all preview windows (goto-preview)' },
            ['<leader><leader>p'] = { pin.pin, 'Pin window (pin.pin)' },
            ['<leader><leader>P'] = { pin.unpin, 'Unpin window (pin.unpin)' },
            ['ms'] = { '<plug>(VM-Find-Under)', 'Multicursor: select word (VM-Find-Under)' },
            ['mm'] = { '<plug>(VM-Add-Cursor-At-Pos)', 'Multicursor: add cursor at position (VM-Add-Cursor-At-Pos)' },
            ['mA'] = { '<plug>(VM-Select-All)', 'Multicursor: select all (VM-Select-All)' },
            ['m/'] = { '<plug>(VM-Start-Regex-Search)', 'Multicursor: regex search (VM-Start-Regex-Search)' },
            ['<c-j>'] = { '<plug>(VM-Add-Cursor-Down)', 'Multicursor: add cursor down (VM-Add-Cursor-Down)' },
            ['<c-k>'] = { '<plug>(VM-Add-Cursor-Up)', 'Multicursor: add cursor up (VM-Add-Cursor-Up)' },
            ['<leader>rm'] = { ':RenderMarkdown toggle<cr>', 'Toggle markdown rendering (RenderMarkdown)' },
        },
        x = {
            ['<tab>'] = { '%', 'Jump to matching pair (visual mode)' },
            ['<leader>='] = { '<c-a>', 'Increment number (visual mode)' },
            ['<leader>-'] = { '<c-x>', 'Decrement number (visual mode)' },
            ['<c-a>'] = { '<esc>ggVG', 'Select all text (visual mode)' },
            ['<c-c>'] = { clipboard.copy, 'Copy selection to clipboard (clipboard.copy)' },
            ['<c-x>'] = { clipboard.cut, 'Cut selection to clipboard (clipboard.cut)' },
            ['<c-l>'] = { indent_guides.refresh_trigger('20zl', { expr = false }), 'Scroll right 20 columns (visual mode, indent guides)' },
            ['<c-h>'] = { indent_guides.refresh_trigger('20zh', { expr = false }), 'Scroll left 20 columns (visual mode, indent guides)' },
            ['gf'] = { lsp.format_selected, 'Format selected text (LSP format)' },
            ['<c-r>'] = { lsp.select_snippets, 'Select snippets (LSP)' },
            ['<f1>'] = { ':set relativenumber!<cr>', 'Toggle relative line numbers (visual mode)' },
            ['<f2>'] = { ':set number!<cr>', 'Toggle absolute line numbers (visual mode)' },
            ['ms'] = { '<plug>(VM-Find-Subword-Under)', 'Multicursor: select subword (VM-Find-Subword-Under)' },
            ['mf'] = { '<plug>(VM-Visual-Find)', 'Multicursor: visual find (VM-Visual-Find)' },
            ['mc'] = { '<plug>(VM-Visual-Cursors)', 'Multicursor: visual cursors (VM-Visual-Cursors)' },
            ['ma'] = { '<plug>(VM-Visual-Add)', 'Multicursor: add region (VM-Visual-Add)' },
            ['mA'] = { '<plug>(VM-Visual-All)', 'Multicursor: select all (visual mode)' },
            ['m/'] = { '<plug>(VM-Visual-Regex)', 'Multicursor: regex search (visual mode)' },
        },
        v = {
        },
        i = {
            ['<c-s>'] = { '<c-o>:w<cr>', 'Save file (insert mode)' },
            ['<c-a>'] = { '<esc>ggVG', 'Select all text (insert mode)' },
            ['<c-v>'] = { clipboard.paste, 'Paste from clipboard (insert mode)' },
            ['<f7>'] = { tasks.build_project, 'Build project (insert mode)' },
            ['<c-f5>'] = { tasks.run_project, 'Run project (insert mode)' },
            ['<f29>'] = { tasks.run_project, 'Run project (insert mode)' },
            ['<s-f7>'] = { tasks.clean_project, 'Clean project (insert mode)' },
            ['<f19>'] = { tasks.clean_project, 'Clean project (insert mode)' },
            ['<c-f7>'] = { tasks.run_project, 'Configure project (insert mode)' },
            ['<f31>'] = { tasks.build_config, 'Build config (insert mode)' },
            ['<c-d>'] = { lsp.expand_snippets, 'Expand snippets (LSP, insert mode)' },
            ['<c-w>'] = { '<nop>', 'Window motion (insert mode)' },
            ['<c-w>h'] = { function() cmd 'stopinsert'; tmux_navigator.tmux_navigate_left() end, 'Navigate left (insert mode, tmux/vim window)' },
            ['<c-w>j'] = { function() cmd 'stopinsert'; tmux_navigator.tmux_navigate_down() end, 'Navigate down (insert mode, tmux/vim window)' },
            ['<c-w>k'] = { function() cmd 'stopinsert'; tmux_navigator.tmux_navigate_up() end, 'Navigate up (insert mode, tmux/vim window)' },
            ['<c-w>l'] = { function() cmd 'stopinsert'; tmux_navigator.tmux_navigate_right() end, 'Navigate right (insert mode, tmux/vim window)' },
        },
        t = {
            ['<c-w>w'] = { '<c-\\><c-n>:q<cr>', 'Close terminal window (terminal mode)' },
            ['<c-w>n'] = { '<c-\\><c-n>', 'Switch to normal mode (terminal mode)' },
            ['<c-w>h'] = { tmux_navigator.tmux_navigate_left, 'Navigate left (terminal mode, tmux/vim window)' },
            ['<c-w>j'] = { tmux_navigator.tmux_navigate_down, 'Navigate down (terminal mode, tmux/vim window)' },
            ['<c-w>k'] = { tmux_navigator.tmux_navigate_up, 'Navigate up (terminal mode, tmux/vim window)' },
            ['<c-w>l'] = { tmux_navigator.tmux_navigate_right, 'Navigate right (terminal mode, tmux/vim window)' },
            ['<c-w><left>'] = { tmux_navigator.tmux_navigate_left, 'Navigate left (terminal mode, tmux/vim window)' },
            ['<c-w><down>'] = { tmux_navigator.tmux_navigate_down, 'Navigate down (terminal mode, tmux/vim window)' },
            ['<c-w><up>'] = { tmux_navigator.tmux_navigate_up, 'Navigate up (terminal mode, tmux/vim window)' },
            ['<c-w><right>'] = { tmux_navigator.tmux_navigate_right, 'Navigate right (terminal mode, tmux/vim window)' },
        },
        c = {
            ['<c-k>'] = { '<plug>CmdlineCompleteBackward', 'Command-line: complete previous (CmdlineCompleteBackward)' },
            ['<c-j>'] = { '<plug>CmdlineCompleteForward', 'Command-line: complete next (CmdlineCompleteForward)' },
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
                'Refresh indent guides on horizontal scroll (scrollwheelleft)' },
            ['<scrollwheelright>'] = { indent_guides.refresh_trigger('<scrollwheelright>', { expr = true }),
                'Refresh indent guides on horizontal scroll (scrollwheelright)' },
        }, { mode = 'n', expr = true })
    keys.register(
        {
            ['<scrollwheelleft>'] = { indent_guides.refresh_trigger('<scrollwheelleft>', { expr = true }),
                'Refresh indent guides on horizontal scroll (visual mode, scrollwheelleft)' },
            ['<scrollwheelright>'] = { indent_guides.refresh_trigger('<scrollwheelright>', { expr = true }),
                'Refresh indent guides on horizontal scroll (visual mode, scrollwheelright)' },
        }, { mode = 'x', expr = true })

    keys.register({
        ['<scrollwheelleft>'] = { '<nop>', 'Disable terminal horizontal scrolling (scrollwheelleft)' },
        ['<scrollwheelright>'] = { '<nop>', 'Disable terminal horizontal scrolling (scrollwheelright)' },
        ['<mousemove>'] = { '<nop>', 'Disable terminal mouse move (mousemove)' },
    }, { mode = 't' })

    if jump.needs_mapping then
        local jump_mappings = {
            n = {
                ['s'] = { jump.search_jump, 'Jump: search and jump to location (jump.search_jump)' },
                ['f'] = { jump.find_jump, 'Jump: find and jump to location (jump.find_jump)' },
                ['F'] = { jump.find_jump_back, 'Jump: find backwards and jump to location (jump.find_jump_back)' },
                ['t'] = { jump.till_jump, 'Jump: find and jump until location (jump.till_jump)' },
                ['T'] = { jump.till_jump_back, 'Jump: find backwards and jump until location (jump.till_jump_back)' },
            },
            x = {
                ['s'] = { jump.search_jump_visual, 'Jump: search and jump to location (visual mode, jump.search_jump_visual)' },
                ['S'] = { jump.search_jump_back_visual, 'Jump: search backwards and jump to location (visual mode, jump.search_jump_back_visual)' },
                ['f'] = { jump.find_jump, 'Jump: find and jump to location (visual mode, jump.find_jump)' },
                ['F'] = { jump.find_jump_back, 'Jump: find backwards and jump to location (visual mode, jump.find_jump_back)' },
                ['t'] = { jump.till_jump, 'Jump: find and jump until location (visual mode, jump.till_jump)' },
                ['T'] = { jump.till_jump_back, 'Jump: find backwards and jump until location (visual mode, jump.till_jump_back)' },
            }
        }
        keys.register(jump_mappings.n, { mode = 'n' })
        keys.register(jump_mappings.x, { mode = 'x' })
    end

    if lsp.completion_mappings then
        keys.register({
            ['<tab>'] = { lsp.tab, 'LSP: complete (tab)' },
            ['<s-tab>'] = { lsp.shift_tab, 'LSP: previous completion (shift-tab)' },
            ['<cr>'] = { lsp.enter, 'LSP: confirm completion (enter)' },
        }, { mode = 'i', expr = true })
    end

    if user.settings.pairs == 'pear-tree' then
        keys.register({
            ['<bs>'] = { '<plug>(PearTreeBackspace)', 'Pear Tree: backspace (PearTreeBackspace)' },
        }, { mode = 'i' })
        if user.settings.lsp ~= 'coc' and user.settings.format_on_pairs then
            keys.register({
                ['<cr>'] = { '<plug>(PearTreeExpand)', 'Pear Tree: expand (enter) (PearTreeExpand)' },
            }, { mode = 'i' })
        end
    end
end

return m


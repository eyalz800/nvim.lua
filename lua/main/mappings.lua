local m = {}
local v = require 'vim'
local root_paths = require 'main.root_paths'
local cmd = require 'vim.cmd'.silent
local source_index = require 'plugins.source_index'
local lsp = require 'plugins.lsp'
local finder = require 'plugins.finder'
local whitespace = require 'plugins.whitespace'
local tmux_navigator = require 'plugins.config.tmux_navigator'
local paste = require 'builtins.paste'
local clipboard = require 'builtins.clipboard'
local git = require 'plugins.git'
local explorers = require 'plugins.explorers'
local zoom = require 'plugins.zoom'
local fold = require 'plugins.fold'
local buffers = require 'plugins.buffers'
local binary_view = require 'plugins.binary_view'
local disasm_view = require 'plugins.disasm_view'
local tasks = require 'plugins.tasks'
local debugger = require 'plugins.debugger'
local search = require 'plugins.search'
local indent_guides = require 'plugins.indent_guides'
local map = v.keymap.set
local expand = v.fn.expand

map('n', 'Y', 'y$', { silent=true }) -- Yank to end of line
map('v', '<tab>', '%', { silent=true }) -- Jump to matching pairs
map('n', 'g[', '0', { silent=true }) -- Go to beginning of line
map('n', 'g]', '$', { silent=true }) -- Go to end of line
map('n', '`', ':noh<cr>', { silent=true }) -- Turn off highlights
map('n', '<c-q>', '<c-v>', { silent=true }) -- Visual block
map('n', '<c-w>w', ':q<cr>', { silent=true }) -- Close window
map('n', '<c-w>g', explorers.file.open, { silent=true }) -- Open file explorer
map('n', '<c-w>;', explorers.code.open, { silent=true }) -- Open code explorer
map('n', '<c-w>e', explorers.close, { silent=true }) -- Close all explorers
map('n', '<c-s>', ':w<cr>', { silent=true }) -- Save file
map('i', '<c-s>', '<c-o>:w<cr>', { silent=true }) -- Save file
map({'n', 'v'}, '<leader>=', '<c-a>', { silent=true }) -- Increment
map({'n', 'v'}, '<leader>-', '<c-x>', { silent=true }) -- Decrement
map('n', '<c-a>', 'ggVG', { silent=true }) -- Select all
map({'v', 'i'}, '<c-a>', '<esc>ggVG', { silent=true }) -- Select all
map('v', '<c-c>', clipboard.copy, { silent=true }) -- Copy
map('v', '<c-x>', clipboard.cut, { silent=true }) -- Cut
map({'n', 'i'}, '<c-v>', clipboard.paste, { silent=true }) -- Paste
map('n', '<f8>', paste.toggle, { silent=true }) -- Paste mode
map('n', 'L', ':vertical resize +1<cr>', { silent=true }) -- Resize vertically
map('n', 'H', ':vertical resize -1<cr>', { silent=true }) -- Resize vertically
map('n', '<c-w>=', ':resize +1<cr>', { silent=true }) -- Resize horizontal window
map('', '<c-w>z', zoom.toggle_zoom, { silent=true }) -- Toggle zoom
map('n', '<c-w>b', ':below 10new +terminal<cr>a', { silent=true }) -- New terminal below
map('n', '<c-w>t', ':vert rightb new +terminal<cr>a', { silent=true }) -- New terminal on right side
map('t', '<c-w>w', '<c-\\><c-n>:q<cr>', { silent=true }) -- Close terminal
map('t', '<c-w>n', '<c-\\><c-n>', { silent=true }) -- Terminal normal mode
map({'n', 'x'}, '<c-l>', indent_guides.refresh_trigger('20zl', { expr=false }), { silent=true }) -- Side scrolling
map({'n', 'x'}, '<c-h>', indent_guides.refresh_trigger('20zh', { expr=false }), { silent=true }) -- Side scrolling
map('n', '<leader>rw', whitespace.strip, { silent=true }) -- Strip whitespace
map('n', '<leader>tw', whitespace.toggle, { silent=true }) -- Toggle whitespace
map('n', 'cro', root_paths.switch_to_root, { silent=true }) -- Switch to root
map('n', 'cp', root_paths.switch_to_project_root, { silent=true }) -- Switch to project root
map('n', 'cf', explorers.display_current_file, { silent=true }) -- Echo current file
map('n', 'cq', explorers.display_current_directory, { silent=true }) -- Echo current directory
map('n', 'cd', function() cmd('cd ' .. expand('%:p:h')) end, { silent = true }) -- Enter current file directory
map('n', 'cu', function() cmd('cd ..') end, { silent = true }) -- Go up one directory
map('n', 'gb', git.git_blame, { silent=true }) -- Git blame
map('n', 'gv', git.git_commits, { silent=true }) -- Git commits
map('n', 'gl', git.show_git, { silent=true }) -- Show git
map('n', 'gm', git.show_staging_buffer, { silent=true }) -- Show git staging buffer
map('n', 'gs', source_index.goto_symbol_definition, { silent=true }) -- Goto indexed symbol prefer definition
map('n', 'gS', source_index.goto_symbol_declaration, { silent=true }) -- Goto indexed symbol prefer declaration
map('n', 'gz', source_index.goto_definition, { silent=true }) -- Goto defiinition by lsp and fall back to by index
map('n', 'gd', lsp.goto_definition, { silent=true }) -- Goto definition lsp
map('n', '<leader>gd', lsp.show_definitions, { silent=true }) -- Browse definitions lsp
map('n', 'gD', lsp.goto_declaration, { silent=true }) -- Goto declaration lsp synchronously
map('n', '<leader><leader>gd', lsp.goto_definition_sync, { silent=true }) -- Goto definition lsp synchronously
map('n', 'gr', lsp.show_references, { silent=true }) -- Browse references lsp
map('n', 'ga', lsp.code_action, { silent=true }) -- Code action
map('n', '<leader>qf', lsp.quick_fix, { silent=true }) -- Quick fix using lsp
map('n', '<leader>gy', lsp.type_definition, { silent=true }) -- Goto type definition
map('n', 'go', lsp.switch_source_header, { silent=true }) -- Switch between source and header
map('n', 'K', lsp.show_documentation, { silent=true }) -- Show documentation
map('n', '[g', lsp.prev_diagnostic, { silent=true }) -- Show previous diagnostic
map('n', ']g', lsp.next_diagnostic, { silent=true }) -- Show next diagnostic
map('n', '<leader>rn', lsp.rename, { silent=true }) -- Rename symbol
map('x', 'gf', lsp.format_selected, { silent=true }) -- Format selected
map('i', '<c-d>', lsp.expand_snippets, { silent=true }) -- Expand snippets (with nvim-lsp just use tab to select then enter)
map('x', '<c-r>', lsp.select_snippets, { silent=true }) -- Select snippets
map('n', 'gL', lsp.list_diagnostics, { silent=true }) -- List diagnostics
map('n', '<leader><c-l>', finder.find_buffer, { silent=true }) -- Find buffer
map('n', '<c-p>', finder.find_file, { silent=true }) -- Find file
map('n', '<leader><c-p>', finder.find_file_list, { silent=true }) -- Find file with cache while populating files list for later use.
map('n', '<leader><leader><c-p>', finder.find_file_list_invalidate, { silent=true }) -- Similar to previous but invalidate cache.
map('n', '<c-]>', finder.find_file_hidden, { silent=true }) -- Find file include hidden files
map('n', '<leader><c-]>', finder.find_file_list_hidden, { silent=true }) -- Find file include hidden files with cache while populating files list for later use.
map('n', '<leader><leader><c-]>', finder.find_file_list_hidden_invalidate, { silent=true }) -- Similar to previous but invalidate cache.
map('n', '<c-g>', finder.find_in_files, { silent=true }) -- Search in all files fuzzy
map('n', '<c-\\>', finder.find_in_files_precise, { silent=true }) -- Search in all files precisely
map('n', '<leader><c-\\>', finder.find_in_files_precise_native, { silent=true }) -- Search in all files precisely (may be faster)
map('n', '//', finder.find_line, { silent=true }) -- Find a line in current file
map('n', '<c-j>', '<plug>(VM-Add-Cursor-Down)', { silent=true }) -- Add cursor down
map('n', '<c-k>', '<plug>(VM-Add-Cursor-Up)', { silent=true }) -- Add cursor down
map({'n', 't'}, '<c-w>h', tmux_navigator.tmux_navigate_left, { silent=true }) -- Navigate left
map({'n', 't'}, '<c-w>j', tmux_navigator.tmux_navigate_down, { silent=true }) -- Navigate down
map({'n', 't'}, '<c-w>k', tmux_navigator.tmux_navigate_up, { silent=true }) -- Navigate right
map({'n', 't'}, '<c-w>l', tmux_navigator.tmux_navigate_right, { silent=true }) -- Navigate up
map('n', '<leader>u', fold.toggle, { silent=true }) -- Toggle fold
map('n', '<c-w>,', buffers.prev_buffer, { silent=true }) -- Previous buffer
map('n', '<c-w>.', buffers.next_buffer, { silent=true }) -- Next buffer
map('n', '<c-w>d', buffers.delete_buffer, { silent=true }) -- Close buffer
map('n', '<c-w>p', ':below copen<cr>', { silent=true }) -- Quickfix open below
map('n', '<c-w>m', ':below copen<cr>', { silent=true }) -- Quickfix open below
map('n', '<c-w>q', ':cclose<cr>', { silent=true }) -- Quickfix close
map('i', '<bs>', '<plug>(PearTreeBackspace)', { silent=true }) -- Pear tree internal backspace processing
map('c', '<c-k>', '<plug>CmdlineCompleteBackward', { silent=true }) -- Complete prev in vim command mode
map('c', '<c-j>', '<plug>CmdlineCompleteForward', { silent=true }) -- Complete next in vim command mode
map('n', '-', ':setlocal wrap! lbr!<cr>', { silent=true }) -- Wrap words
map('n', 'cr', '<plug>(abolish-coerce-word)', { silent=true }) -- Change word case (s-snake_case, m-MixedCase, c-camelCase, u-UPPER, -/. dash/dot)
map('n', '<leader>bv', binary_view.binary_view, { silent=true }) -- Binary view with xxd
map('n', '<leader>dv', disasm_view.disasm_view, { silent=true }) -- Disassembly view
map({'n', 'i'}, '<f7>', tasks.build_project, { silent=true }) -- Build project
map({'n', 'i'}, '<c-f5>', tasks.run_project, { silent=true }) -- Run project
map({'n', 'i'}, '<f29>', tasks.run_project, { silent=true }) -- Run project
map({'n', 'i'}, '<s-f7>', tasks.clean_project, { silent=true }) -- Clean project
map({'n', 'i'}, '<f19>', tasks.clean_project, { silent=true }) -- Clean project
map({'n', 'i'}, '<c-f7>', tasks.run_project, { silent=true }) -- Run project
map({'n', 'i'}, '<f31>', tasks.build_config, { silent=true }) -- Build config
map('n', '<leader>dl', debugger.launch_settings, { silent=true }) -- Debug launch settings
map('n', '<leader>dd', debugger.launch, { silent=true }) -- Debug launch
map('n', '<leader>dc', debugger.continue, { silent=true }) -- Debug continue
map('n', '<F5>', debugger.continue, { silent=true }) -- Debug continue
map('n', '<leader>dr', debugger.restart, { silent=true }) -- Debug restart
map('n', '<S-F5>', debugger.restart, { silent=true }) -- Debug restart
map('n', '<F17>', debugger.restart, { silent=true }) -- Debug restart
map('n', '<leader>dp', debugger.pause, { silent=true }) -- Debug pause
map('n', '<F6>', debugger.pause, { silent=true }) -- Debug pause
map('n', '<leader>ds', debugger.stop, { silent=true }) -- Debug stop
map('n', '<S-F6>', debugger.stop, { silent=true }) -- Debug stop
map('n', '<F18>', debugger.stop, { silent=true }) -- Debug stop
map('n', '<leader>db', debugger.breakpoint, { silent=true }) -- Debug breakpoint
map('n', '<F9>', debugger.breakpoint, { silent=true }) -- Debug breakpoint
map('n', '<leader><leader>db', debugger.breakpoint_cond, { silent=true }) -- Debug conditional breakpoint
map('n', '<S-F9>', debugger.breakpoint_cond, { silent=true }) -- Debug conditional breakpoint
map('n', '<F21>', debugger.breakpoint_cond, { silent=true }) -- Debug conditional breakpoint
map('n', '<leader>df', debugger.breakpoint_function, { silent=true }) -- Debug function breakpoint
map('n', '<leader><F9>', debugger.breakpoint_function, { silent=true }) -- Debug function breakpoint
map('n', '<leader>dB', debugger.clear_breakpoints, { silent=true }) -- Debug clear breakpoints
map('n', '<leader><leader><F9>', debugger.clear_breakpoints, { silent=true }) -- Debug clear breakpoints
map('n', '<leader>dn', debugger.step_over, { silent=true }) -- Debug step over
map('n', '<F10>', debugger.step_over, { silent=true }) -- Debug step over
map('n', '<leader>di', debugger.step_into, { silent=true }) -- Debug step into
map('n', '<F11>', debugger.step_into, { silent=true }) -- Debug step into
map('n', '<leader>do', debugger.step_out, { silent=true }) -- Debug step out
map('n', '<S-F11>', debugger.step_out, { silent=true }) -- Debug step out
map('n', '<F23>', debugger.step_out, { silent=true }) -- Debug step out
map('n', '<leader>dN', debugger.run_to_cursor, { silent=true }) -- Debug run to cursor
map('n', '<C-F10>', debugger.run_to_cursor, { silent=true }) -- Debug run to cursor
map('n', '<F34>', debugger.run_to_cursor, { silent=true }) -- Debug run to cursor
map('n', '<leader>dD', debugger.disassemble, { silent=true }) -- Debug disassemble
map({'n', 'x'}, '<leader>de', debugger.eval_window, { silent=true }) -- Debug eval window
map('n', '<leader>dq', debugger.reset, { silent=true }) -- Debug close
map('n', 's', search.search_jump, { silent=true }) -- Search and jump to location
map('x', 's', search.search_jump_visual, { silent=true }) -- Search and jump to location
map('n', 'S', search.search_jump_back, { silent=true }) -- Search backwards and jump to location
map('x', 'S', search.search_jump_back_visual, { silent=true }) -- Search backwards and jump to location
map({'n', 'x'}, 'f', search.find_jump, { silent=true }) -- Find and jump to location
map({'n', 'x'}, 'F', search.find_jump_back, { silent=true }) -- Find backwards and jump to location
map({'n', 'x'}, 't', search.till_jump, { silent=true }) -- Find and jump to until location
map({'n', 'x'}, 'T', search.till_jump_back, { silent=true }) -- Find backwards and jump until location
map('n', '<leader>ca', source_index.cscope_assignments, { silent=true }) -- CScope assignments
map('n', '<leader>cc', source_index.cscope_function_calling, { silent=true }) -- CScope function calling
map('n', '<leader>cd', source_index.cscope_functions_called_by, { silent=true }) -- CScope functions called by
map('n', '<leader>ce', source_index.cscope_egrep, { silent=true }) -- CScope egrep
map('n', '<leader>cf', source_index.cscope_file, { silent=true }) -- CScope file
map('n', '<leader>cg', source_index.cscope_definition, { silent=true }) -- CScope definition
map('n', '<leader>ci', source_index.cscope_files_including, { silent=true }) -- CScope files including
map('n', '<leader>cs', source_index.cscope_symbol, { silent=true }) -- CScope symbol
map('n', '<leader>ct', source_index.cscope_text, { silent=true }) -- CScope text
map('n', '<leader><leader>ca', source_index.cscope_assignments, { silent=true }) -- CScope assignments
map('n', '<leader><leader>cc', source_index.cscope_input_function_calling, { silent=true }) -- CScope function calling (input)
map('n', '<leader><leader>cd', source_index.cscope_input_functions_called_by, { silent=true }) -- CScope functions called by (input)
map('n', '<leader><leader>ce', source_index.cscope_input_egrep, { silent=true }) -- CScope egrep (input)
map('n', '<leader><leader>cf', source_index.cscope_input_file, { silent=true }) -- CScope file (input)
map('n', '<leader><leader>cg', source_index.cscope_input_definition, { silent=true }) -- CScope definition (input)
map('n', '<leader><leader>ci', source_index.cscope_input_files_including, { silent=true }) -- CScope files including (input)
map('n', '<leader><leader>cs', source_index.cscope_input_symbol, { silent=true }) -- CScope symbol (input)
map('n', '<leader><leader>ct', source_index.cscope_input_text, { silent=true }) -- CScope text (input)
map('n', 'gw', source_index.opengrok_query_f, { silent=true }) -- Opengrok query symbol
map('n', 'gW', source_index.opengrok_query_d, { silent=true }) -- Opengrok query symbol defintiion
map('n', '<leader>gw', source_index.opengrok_query_input_f, { silent=true }) -- Opengrok query symbol (input)
map('n', '<leader>gW', source_index.opengrok_query_input_d, { silent=true }) -- Opengrok query symbol defintiion (input)
map('n', '<leader>o', ':pop<cr>', { silent=true }) -- Pop tag stack
map('n', '<leader>i', ':tag<cr>', { silent=true }) -- Unpop tag stack
map('n', '<leader>gcp', source_index.generate_cpp, { silent=true }) -- Generate cpp index
map('n', '<leader>gt', source_index.generate_tags, { silent=true }) -- Generate common tags
map('n', '<leader>gT', source_index.generate_all_tags, { silent=true }) -- Generate all tags
map('n', '<leader>gf', source_index.generate_source_files_list, { silent=true }) -- Generate source files list
map('n', '<leader>gF', source_index.generate_all_files_list, { silent=true }) -- Generate all files list
map('n', '<leader>gcf', source_index.generate_flags, { silent=true }) -- Generate flags
map('n', '<leader>go', source_index.generate_opengrok, { silent=true }) -- Generate opengrok
map('n', '<leader>ga', source_index.generate_cpp_and_opengrok, { silent=true }) -- Generate cpp and opengrok
map('t', '<scrollwheelleft>', '<nop>', { silent=true }) -- Disable terminal horizontal scrolling
map('t', '<scrollwheelright>', '<nop>', { silent=true }) -- Disable terminal horizontal scrolling
map({'n', 'x'}, '<scrollwheelleft>', indent_guides.refresh_trigger('<scrollwheelleft>', { expr=true }), { silent=true, expr=true }) -- Refresh indent guides on horizontal scroll
map({'n', 'x'}, '<scrollwheelright>', indent_guides.refresh_trigger('<scrollwheelright>', { expr=true }), { silent=true, expr=true }) -- Refresh indent guides on horizontal scroll
map('n', '<leader>cp', finder.color_picker, { silent=true }) -- Pick color

-- Additional mappings
--   * 'gc' - :h commentary -- Comment selected code
--   * 'ysw' / 'csXY' - :h surround - Surround / change surrounding

-- Internal mappings
if lsp.completion_mappings then
    map('i', '<tab>', lsp.tab, { silent=true, expr=true }) -- Lsp complete
    map('i', '<s-tab>', lsp.shift_tab, { silent=true, expr=true}) -- Lsp prev complete
    map('i', '<cr>', lsp.enter, { silent=true, expr=true }) -- Lsp enter
end

require 'user.mappings'
return m

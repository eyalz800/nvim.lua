local m = {}
local user = require 'user'

m.setup = function()
    require 'noice'.setup(m.config())
    vim.keymap.set('n', '<leader>nq', ':Noice dismiss<cr>', { desc = 'Dismiss Noice', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>nd', ':Noice disable<cr>', { desc = 'Disable Noice', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>ne', ':Noice enable<cr>', { desc = 'Enable Noice', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>na', ':Noice all<cr>', { desc = 'Noice all messages', noremap = true, silent = true })
    if user.settings.notifier == 'noice' then
        vim.keymap.set('n', '<leader>nh', ':Noice history<cr>', { desc = 'Noice history', noremap = true, silent = true })
    end
    if user.settings.noice_config.custom_incsearch then
        m.setup_noice_incsearch()
    end
end

m.config = function()
    return {
        views = {
            split = {
                enter = true,
                win_options = {
                    winhighlight = {
                        Normal = 'NoiceSplit',
                        FloatBorder = 'NoiceSplitBorder',
                        LineNr = 'NoiceSplit',
                        StatusLine = 'NoiceSplit',
                        StatusLineNC = 'NoiceSplit',
                        SignColumn = 'NoiceSplit',
                        SignColumnNC = 'NoiceSplit',
                        NormalNC = 'NoiceSplit',
                    },
                },
            }
        },
        lsp = {
            progress = {
                enabled = not user.settings.fidget,
                format = 'lsp_progress',
                format_done = 'lsp_progress_done',
                throttle = 1000 / 30,
            },
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = false,
        },
        health = {
            checker = false,
        },
        routes = {
            {
                filter = {
                    event = 'msg_show',
                    kind = {
                        'shell_out',
                        'shell_err',
                    },
                    min_height = 30,
                },
                view = 'split',
                opts = {
                    enter = true,
                }
            },
            {
                filter = {
                    event = 'msg_show',
                    min_height = 30,
                },
                view = 'split',
            },
            {
                filter = {
                    event = 'msg_show',
                    kind = 'bufwrite',
                },
                view = 'notify',
                opts = {
                    level = 'info',
                },
            },
            {
                filter = {
                    event = 'msg_show',
                    kind = 'lua_print',
                    find = '^Running healthchecks%.%.%.'
                },
                opts = { skip = true, },
            },
            {
                filter = {
                    event = 'msg_show',
                    kind = 'emsg',
                    find = '^Error in decoration provider',
                },
                opts = { skip = true, },
            },
            {
                filter = {
                    event = 'msg_show',
                    kind = {
                        'shell_out',
                        'shell_err',
                    }
                },
                view = 'notify',
                opts = {
                    level = 'info',
                },
            },
            {
                filter = {
                    event = 'msg_history_show',
                },
                view = 'split',
                opts = {
                    level = 'info',
                    enter = true,
                    close = {
                        keys = { 'q', '<esc>', },
                    },
                    focusable = true,
                    win_options = {
                        foldenable = false,
                        cursorline = true,
                    },
                },
            },
            {
                filter = {
                    event = 'msg_show', kind = { 'confirm' } },
                view = 'confirm',
                opts = {
                    level = 'info',
                    replace = false,
                    position = {
                        row = 0.5,
                        col = 0.5,
                    },
                },
            },
        },
        throttle = 1000 / 30,
    }
end

m.setup_noice_incsearch = function()
    local ns = vim.api.nvim_create_namespace('init.lua.noice-incsearch-ns')
    local group = vim.api.nvim_create_augroup('init.lua.noice-incsearch-group', {})
    local start_pos = nil
    local top_line = nil
    local matches = {}
    local cur_idx = 1
    local pat = ''
    local search_cmds = { ['/'] = true, ['?'] = true }
    local search_cmd = nil
    local accept = false
    local is_noice_running = require 'noice.config'.is_running

    vim.keymap.set('c', '<cr>', function()
        if search_cmd then
            accept = true
        end
        return '<cr>'
    end, { noremap = false, expr = true })

    local function get_matches(pattern)
        if pattern == '' then return {} end
        local result = {}
        local save_pos = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_win_set_cursor(0, { 1, 0 })

        while true do
            local pos = vim.fn.searchpos(pattern, 'W')
            local row, col = pos[1], pos[2]
            if row == 0 then break end
            table.insert(result, { row, col - 1 })
            if not pcall(vim.api.nvim_win_set_cursor, 0, { row, col }) then break end
            vim.api.nvim_win_set_cursor(0, { row, col })
        end

        vim.api.nvim_win_set_cursor(0, save_pos)
        return result
    end

    local function match_index()
        local best_match_idx = nil

        if search_cmd == '/' then
            for i, match in ipairs(matches) do
                local m_row, m_col = match[1], match[2]
                if m_row > start_pos[1] or (m_row == start_pos[1] and m_col >= start_pos[2]) then
                    best_match_idx = i
                    break
                end
            end
            if best_match_idx == nil then
                best_match_idx = 1
            end
        elseif search_cmd == '?' then
            for i = #matches, 1, -1 do
                local match = matches[i]
                local m_row, m_col = match[1], match[2]
                if m_row < start_pos[1] or (m_row == start_pos[1] and m_col < start_pos[2]) then
                    best_match_idx = i
                    break
                end
            end
            if best_match_idx == nil then
                best_match_idx = #matches
            end
        end

        return best_match_idx
    end

    local function highlight()
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
        for i, match in ipairs(matches) do
            local hl = (i == cur_idx) and 'IncSearch' or 'Search'
            pcall(vim.api.nvim_buf_set_extmark, 0, ns, match[1] - 1, match[2], { hl_group = hl, end_col = match[2] + #pat })
        end
    end

    local function jump()
        local match = matches[cur_idx]
        if match then
            vim.api.nvim_win_set_cursor(0, { top_line, 0 })
            vim.cmd('normal! zt')
            vim.api.nvim_win_set_cursor(0, { match[1], match[2] })
        end
    end

    local function jump_final()
        if not accept then
            vim.api.nvim_win_set_cursor(0, start_pos)
            return
        end
        local match = matches[cur_idx]
        if match then
            local line = match[1]
            local col = match[2]
            if #matches > 1 then
                if search_cmd == '/' then
                    if col == 0 and line ~= 0 then
                        line = line - 1
                    else
                        col = col - 1
                    end
                elseif search_cmd == '?' then
                    if col ~= #(vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]) then
                        col = col + 1
                    else
                        if line + 1 <= vim.api.nvim_buf_line_count(0) then
                            line = line + 1
                        else
                            line = 1
                        end
                        col = 0
                    end
                end
            end
            vim.api.nvim_win_set_cursor(0, { top_line, 0 })
            vim.cmd('normal! zt')
            vim.api.nvim_win_set_cursor(0, { line, col })
        end
    end

    vim.api.nvim_create_autocmd('CmdlineEnter', {
        group = group,
        pattern = '/,?',
        callback = function()
            local cmd_type = vim.fn.getcmdtype()
            if search_cmds[cmd_type] == nil or not is_noice_running() then return end
            if vim.o.incsearch == false then
                return
            end
            vim.o.incsearch = false
            start_pos = vim.api.nvim_win_get_cursor(0)
            top_line = vim.fn.line('w0')
            accept = false
            matches = {}
            cur_idx = 1
            pat = ''
            search_cmd = cmd_type
        end,
    })

    vim.api.nvim_create_autocmd('CmdlineChanged', {
        group = group,
        pattern = '/,?',
        callback = function()
            if not search_cmd then return end
            pat = vim.fn.getcmdline()
            vim.fn.setreg('/', pat)

            matches = get_matches(pat)
            if #matches == 0 then
                vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
                return
            end

            cur_idx = match_index()
            jump()

            highlight()
        end,
    })

    vim.api.nvim_create_autocmd('CmdlineLeave', {
        group = group,
        pattern = '/,?',
        callback = function()
            if not search_cmd then return end
            vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
            jump_final()
            start_pos = nil
            top_line = nil
            accept = false
            matches = {}
            vim.o.incsearch = true
            search_cmd = nil
        end,
    })
end

return m

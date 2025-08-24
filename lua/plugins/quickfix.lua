local m = {}
local cmd = require 'vim.cmd'.silent
local explorers = require 'plugins.explorers'
local user = require 'user'
local terminal = require 'plugins.terminal'

local win_getid = vim.fn.win_getid
local win_gotoid = vim.fn.win_gotoid
local getqflist = vim.fn.getqflist
local uv = vim.loop
local quickfix_winhls = {
    none = nil,
    ['edge-window'] =
    'EndOfBuffer:NvimTreeEndOfBuffer,LineNr:NvimTreeLineNr,WinSeparator:NvimTreeWinSeparator,StatusLine:NvimTreeStatusLine,StatusLineNC:NvimTreeStatuslineNC,SignColumn:NvimTreeSignColumn,Normal:NvimTreeNormal,NormalNC:NvimTreeNormalNC,NormalFloat:NvimTreeNormalFloat,FloatBorder:NvimTreeNormalFloatBorder',
}
local quickfix_winhl = quickfix_winhls[user.settings.quickfix_config.winhl or 'none']
local is_wsl = nil

m.setup = function()
    is_wsl = vim.loop.fs_stat("/mnt/c/Windows") ~= nil

    vim.api.nvim_create_autocmd('filetype', {
        pattern = 'qf',
        group = vim.api.nvim_create_augroup('init.lua.quickfix', {}),
        callback = require 'plugins.quickfix'.on_open
    })
end

m.open = function(options)
    options = options or {}

    local return_win = win_getid()

    local qf_winid = getqflist({ winid = 0 }).winid
    if qf_winid > 0 then
        if options.focus then
            win_gotoid(qf_winid)
        end
        return
    end

    cmd 'below copen'

    if options.focus == false then
        win_gotoid(return_win)
    end

    if options.expand and user.settings.quickfix_expand then
        explorers.arrange()
    end
end

m.map_open = function()
    m.open({ focus = true, expand = true })
end

m.on_open = function()
    vim.o.relativenumber = false
    vim.keymap.set('n', 'q', ':<C-u>q<cr>', { silent = true, buffer = true })
    vim.keymap.set('n', 'a', explorers.arrange, { silent = true, buffer = true })
    vim.keymap.set('n', 'C', terminal.open_below, { silent = true, buffer = true })
    vim.keymap.set('n', 'ge', m.goto_error, { silent = true, buffer = true, desc = 'Go to error (quickfix.goto_error)' })
    vim.keymap.set('n', '<cr>', function() pcall(m.goto_error) end, { silent = true, buffer = true, })
    vim.keymap.set('n', '<2-leftmouse>', function() pcall(m.goto_error) end, { silent = true, buffer = true, })

    if quickfix_winhl and #vim.opt_local.winhighlight == 0 then
        vim.opt_local.winhighlight = quickfix_winhl
    end
end

local normalize_path = function(path)
    if not path or path == "" then return path end
    path = tostring(path)
    if not is_wsl then return path end
    if path:match("^/") then return path end

    local drive, rest = path:match("^([A-Za-z]):[\\/](.*)")
    if drive and rest then
        local drv = drive:lower()
        local unix_rest = rest:gsub("\\", "/")
        local candidate = "/mnt/" .. drv .. "/" .. unix_rest
        if uv.fs_stat(candidate) then
            if uv.fs_stat("/mnt/" .. drv .. vim.fn.stdpath('config') .. '/install/success') then
                return "/" .. unix_rest
            end
            return candidate
        end
        return candidate
    end

    if not uv.fs_stat(path) then
        return path:gsub('\\([^ ])', '/%1')
    end

    return path
end

local open_at = function(path, lnum, col)
    path = tostring(path or '')
    lnum = tonumber(lnum) or 1
    col  = tonumber(col) or 1
    pcall(cmd, 'edit ' .. vim.fn.fnameescape(path))
    local bufnr = vim.fn.bufnr(path, true)
    if bufnr < 0 then return end
    local winid = vim.fn.bufwinid(bufnr)
    if winid == -1 then
        pcall(cmd, 'edit ' .. vim.fn.fnameescape(path))
        winid = vim.fn.bufwinid(bufnr)
    end
    if winid == -1 then winid = vim.api.nvim_get_current_win() end
    local last = vim.api.nvim_buf_line_count(bufnr)
    local l = math.max(1, math.min(last, lnum))
    local col0 = math.max(0, col - 1)
    pcall(vim.api.nvim_win_set_cursor, winid, { l, col0 })
    pcall(vim.api.nvim_set_current_win, winid)
    pcall(cmd, 'normal! zz')
end

local extract_candidates_from_text = function(text)
    text = tostring(text or '')
    local candidates = {}

    local function is_path_char(c)
        return c:match("[%w_./\\~+-]")
    end

    local function is_extended_path_char(c)
        return c:match("[%w_./\\~+-%%s()]")
    end

    local add_candidate = function(fname, lnum, col)
        fname = fname and fname:match("^%s*(.-)%s*$") -- trim
        if fname and fname ~= "" then
            table.insert(candidates, {
                path = normalize_path(fname),
                lnum = tonumber(lnum) or 1,
                col  = tonumber(col) or 1,
            })
        end
    end

    -- Pattern for (line,col) or (line)
    for pos, lnum, col in text:gmatch("()%((%d+),(%d+)%)") do
        local start_pos = pos - 1
        -- walk backward to extract file path
        local i = start_pos
        for _, check_char in ipairs({ is_path_char, is_extended_path_char }) do
            while i > 0 and check_char(text:sub(i, i)) do i = i - 1 end
            local fname = text:sub(i + 1, start_pos)
            local drive = text:sub(i - 1, i)
            if drive:match("^[A-Za-z]:$") then
                fname = drive .. fname
            end
            add_candidate(fname, lnum, col)
        end
    end

    for pos, lnum in text:gmatch("()%((%d+)%)") do
        local start_pos = pos - 1
        local i = start_pos
        for _, check_char in ipairs({ is_path_char, is_extended_path_char }) do
            while i > 0 and check_char(text:sub(i, i)) do i = i - 1 end
            local fname = text:sub(i + 1, start_pos)
            local drive = text:sub(i - 1, i)
            if drive:match("^[A-Za-z]:$") then
                fname = drive .. fname
            end
            add_candidate(fname, lnum, 1)
        end
    end

    -- Pattern for filename:line:col
    for fname, lnum, col in text:gmatch("([%w%._/\\~+-]+):(%d+):(%d+)") do
        add_candidate(fname, lnum, col)
    end

    -- Pattern for filename:line
    for fname, lnum in text:gmatch("([%w%._/\\~+-]+):(%d+)") do
        add_candidate(fname, lnum, 1)
    end

    -- deduplicate
    local seen, uniq = {}, {}
    for _, c in ipairs(candidates) do
        if not seen[c.path] then
            seen[c.path] = true
            table.insert(uniq, c)
        end
    end

    return uniq
end

m.goto_error = function()
    -- snapshot before attempting builtin jump
    local pre_buf   = vim.api.nvim_get_current_buf()
    local pre_win   = vim.api.nvim_get_current_win()

    local idx = vim.api.nvim_win_get_cursor(0)[1]

    -- set qf index (so :cc will jump to that index)
    pcall(vim.fn.setqflist, {}, 'a', { idx = idx })

    -- try builtin quickfix jump
    pcall(cmd, ('cc %d'):format(idx))

    -- snapshot after
    local post_buf  = vim.api.nvim_get_current_buf()
    local post_win  = vim.api.nvim_get_current_win()

    -- if anything meaningful changed, assume cc worked
    if pre_buf ~= post_buf or pre_win ~= post_win then
        return
    end

    -- fallback to smarter parser/jump
    local text = vim.api.nvim_buf_get_lines(pre_buf, idx - 1, idx, false)[1] or ""
    local candidates = extract_candidates_from_text(text)
    if #candidates == 0 then return end

    -- Step 1: separate resolved absolute, unresolved relative
    local resolved, unresolved = {}, {}
    for _, c in ipairs(candidates) do
        local is_absolute = c.path:match("^/")

        if uv.fs_stat(c.path) then
            table.insert(resolved, c)
        elseif not is_absolute then
            table.insert(unresolved, c)
        end
    end

    -- Step 2: jump immediately if exactly one resolved path
    if #resolved == 1 then
        local r = resolved[1]
        local others_included = true
        if #unresolved > 0 then
            for _, u in ipairs(unresolved) do
                if not r.path:find(u.path) then
                    others_included = false
                    break
                end
            end
        end
        if others_included then
            open_at(r.path, r.lnum, r.col)
            return
        end
    end

    -- Step 3: user chooses file from the options
    if #resolved > 0 or #unresolved > 0 then
        local print_table = {}
        for _, item in ipairs(resolved) do
            table.insert(print_table, vim.fn.shellescape(item.path) .. ':' .. item.lnum .. ':' .. item.col .. ':')
        end
        local print_cmd = 'printf ' .. (#print_table > 0 and (table.concat(print_table, [[\\n]]) .. [[\\n]]) or '')

        local rg_table = {}
        for _, item in ipairs(unresolved) do
            table.insert(rg_table, string.format('rg --files -g %s | xargs -I{} echo {}:%d:%d:',
                vim.fn.shellescape(vim.fs.basename(item.path)), item.lnum, item.col))
        end
        local rg_cmd = table.concat(rg_table, ';')
        require 'fzf-lua'.grep_project({ prompt = 'Files❯ ', cmd = print_cmd .. ';' .. rg_cmd, })
    end
end

return m

local m = {}
local cmd = require 'vim.cmd'.silent
local user = require 'user'
local finder = require 'plugins.finder'
local exists = require 'vim.exists'.exists

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local lsp = vim.lsp
local diagnostic = vim.diagnostic

local settings = user.settings.lsp_config.nvim
local sign_prefix = user.settings.signcolumn_config.lsp_prefix or ''

m.show_documentation = function() return lsp.buf.hover() end
m.goto_definition = lsp.buf.definition
m.show_definitions = finder.lsp_definitions or lsp.buf.definition
m.goto_definition_sync = lsp.buf.definition
m.goto_declaration = lsp.buf.declaration
m.show_declarations = finder.lsp_declarations or lsp.buf.declaration
m.show_references = finder.lsp_references or lsp.buf.references
m.code_action = lsp.buf.code_action
m.type_definition = lsp.buf.type_definition
m.prev_diagnostic = function()
    diagnostic.jump({ count = -1 })
end
m.next_diagnostic = function()
    diagnostic.jump({ count = 1 })
end
m.rename = lsp.buf.rename
m.list_diagnostics = finder.lsp_diagnostics or diagnostic.open_float
m.format_selected = function() lsp.buf.format({ async = true }) end

m.quick_fix = m.code_action

m.semantic_highlighting = true

if settings.diagnostic_hover then
    m.diagnostic_hover = function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
                return
            end
        end

        local close_events = {
            "CursorMoved",
            "CursorMovedI",
            "BufHidden",
            "InsertCharPre",
            "WinLeave",
        }

        local _, winid = diagnostic.open_float({}, {
            scope = "cursor",
            focusable = false,
        })

        if winid then
            autocmd(close_events, {
                buffer = vim.api.nvim_get_current_buf(),
                group = augroup('init.lua.lsp.diagnostic-hover.close', { clear = false }),
                once = true,
                callback = function()
                    if winid and vim.api.nvim_win_is_valid(winid) then
                        pcall(vim.api.nvim_win_close, winid, true)
                        winid = nil
                    end
                end
            })
        end
    end
end

m.switch_source_header = function()
    if exists ':ClangdSwitchSourceHeader' then
        cmd 'ClangdSwitchSourceHeader'
    end
end
m.expand_snippets = function() end
m.select_snippets = function() end

m.setup = function()
    m.navic = require 'nvim-navic'
    local virtual_text = nil
    if settings.virtual_text then
        virtual_text = {
            enabled = settings.virtual_text,
            source = 'if_many',
            spacing = 4,
            prefix = '■',
        }
    end

    diagnostic.config({
        signs = {
            text = {
                [diagnostic.severity.ERROR] = sign_prefix .. '',
                [diagnostic.severity.WARN] = sign_prefix .. '',
                [diagnostic.severity.INFO]  = sign_prefix .. '',
                [diagnostic.severity.HINT]  = sign_prefix .. '󰌶',
            },
            -- linehl = {
            --     [diagnostic.severity.ERROR] = 'DiagnosticSignError',
            --     [diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            --     [diagnostic.severity.INFO]  = 'DiagnosticSignInfo',
            --     [diagnostic.severity.HINT]  = 'DiagnosticSignHint',
            -- },
        },
        update_in_insert = false,
        underline = true,
        virtual_text = virtual_text or false,
        severity_sort = true,
        float = {
            border = 'rounded',
            source = true,
            header = '',
            prefix = '',
        },
    })

    m.servers = {}

    for _, server in pairs(settings.servers) do
        if server then
            m.servers[server.name or server] = server.name and server or {}
        end
    end

    m.capabilities = require 'cmp_nvim_lsp'.default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )

    local on_attach = function(...) end

    if user.settings.bar == 'barbecue' then
        local prev_attach = on_attach
        on_attach = function(client, bufnr)
            prev_attach(client, bufnr)
            if client.server_capabilities['documentSymbolProvider'] then
                if not m.navic.is_available(bufnr) then
                    m.navic.attach(client, bufnr)
                end
            end
        end
    end

    vim.lsp.config('*', {
        capabilities = m.capabilities,
        on_init = m.on_init,
    })

    for server_name, server in pairs(m.servers) do
        vim.lsp.config(server_name, {
            cmd = server.cmd,
            capabilities = server.capabilities,
            settings = server.settings or {},
            filetypes = server.filetypes,
            on_attach = on_attach,
        })
        vim.lsp.enable(server_name)
    end

    local mason_lspconfig = require 'mason-lspconfig'
    local mason_lspconfig_automatic_enable = nil
    if user.settings.mason_lspconfig_autoenable == true then
        mason_lspconfig_automatic_enable = true
    elseif user.settings.mason_lspconfig_autoenable == 'if-not-defined' then
        mason_lspconfig_automatic_enable = { exclude = vim.tbl_keys(m.servers) }
    else
        mason_lspconfig_automatic_enable = false
    end

    mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(m.servers),
        automatic_enable = mason_lspconfig_automatic_enable,
    }

    require 'plugins.config.cmp'.setup()
end

return m

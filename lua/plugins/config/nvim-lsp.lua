local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'
local finder = require 'plugins.finder'
local exists = require 'vim.exists'.exists

local lsp = v.lsp
local diagnostic = v.diagnostic

local settings = user.settings.lsp_config.nvim

m.show_documentation = function() return lsp.buf.hover() end
m.goto_definition = lsp.buf.definition
m.show_definitions = finder.lsp_definitions or lsp.buf.definition
m.goto_definition_sync = lsp.buf.definition
m.goto_declaration = lsp.buf.declaration
m.show_declarations = finder.lsp_declarations or lsp.buf.declaration
m.show_references = finder.lsp_references or lsp.buf.references
m.code_action = lsp.buf.code_action
m.type_definition = lsp.buf.type_definition
m.prev_diagnostic = diagnostic.goto_prev
m.next_diagnostic = diagnostic.goto_next
m.rename = lsp.buf.rename
m.list_diagnostics = finder.lsp_diagnostics or diagnostic.open_float
m.format_selected = function() lsp.buf.format({ async = true }) end

m.quick_fix = m.code_action

m.semantic_highlighting = true

if settings.diagnostic_hover then
    m.diagnostic_hover = function()
        for _, winid in pairs(v.api.nvim_tabpage_list_wins(0)) do
            if v.api.nvim_win_get_config(winid).zindex then
                return
            end
        end

        diagnostic.open_float({}, {
            scope = "cursor",
            focusable = false,
            close_events = {
                "CursorMoved",
                "CursorMovedI",
                "BufHidden",
                "InsertCharPre",
                "WinLeave",
            },
        })
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
    local sign = function(opts)
        v.fn.sign_define(opts.name, {
            texthl = opts.name,
            text = opts.text,
            numhl = ''
        })
    end

    sign({ name = 'DiagnosticSignInfo', text = '' })
    sign({ name = 'DiagnosticSignHint', text = '󰌶' })
    sign({ name = 'DiagnosticSignWarn', text = '' })
    sign({ name = 'DiagnosticSignError', text = '' })

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
        signs = true,
        update_in_insert = false,
        underline = true,
        virtual_text = virtual_text or false,
        severity_sort = true,
        float = {
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
        },
    })

    m.servers = {}

    for _, server in pairs(settings.servers) do
        if server then
            m.servers[server.name or server] = server.settings or {}
        end
    end

    m.capabilities = require 'cmp_nvim_lsp'.default_capabilities(
        v.lsp.protocol.make_client_capabilities()
    )

    local lspconfig = require 'lspconfig'
    local mason_lspconfig = require 'mason-lspconfig'
    mason_lspconfig.setup {
        ensure_installed = v.tbl_keys(m.servers),
    }

    mason_lspconfig.setup_handlers {
        function(server_name)
            local server_settings = m.servers[server_name]

            local on_attach = function() end

            if user.settings.bar == 'barbecue' then
                local prev_attach = on_attach
                on_attach = function(client, bufnr)
                    prev_attach()
                    if client.server_capabilities['documentSymbolProvider'] then
                        require 'nvim-navic'.attach(client, bufnr)
                    end
                end
            end

            lspconfig[server_name].setup {
                cmd = (server_settings or {}).cmd,
                capabilities = m.capabilities,
                settings = server_settings,
                filetypes = (server_settings or {}).filetypes,
                on_attach = on_attach,
            }
        end
    }

    require 'plugins.config.cmp'.setup()
end

return m

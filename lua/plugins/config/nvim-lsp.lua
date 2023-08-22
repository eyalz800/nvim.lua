local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'
local finder = require 'plugins.finder'
local exists = require 'vim.exists'.exists

local lsp = v.lsp
local diagnostic = v.diagnostic

local settings = user.settings.lsp_config.nvim

m.show_documentation = lsp.buf.hover
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

m.switch_source_header = function()
    if exists ':ClangdSwitchSourceHeader' then
        cmd 'ClangdSwitchSourceHeader'
    end
end
m.expand_snippets = function() end
m.select_snippets = function() end

m.setup = function()
    local servers = {}

    local sign = function(opts)
        v.fn.sign_define(opts.name, {
            texthl = opts.name,
            text = opts.text,
            numhl = ''
        })
    end

    sign({name = 'DiagnosticSignInfo', text = ''})
    sign({name = 'DiagnosticSignHint', text = '󰌶'})
    sign({name = 'DiagnosticSignWarn', text = ''})
    sign({name = 'DiagnosticSignError', text = ''})

    diagnostic.config({
        signs = true,
        update_in_insert = false,
        underline = true,
        virtual_text = {
            enabled = settings.virtual_text,
            source = 'if_many',
            spacing = 4,
            prefix = '■',
        },
        severity_sort = true,
        float = {
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
        },
    })

    if settings.servers.clangd then
        servers.clangd = {}
    end

    if settings.servers.python then
        servers.pyright = {}
    end

    if settings.servers.lua then
        servers.lua_ls = {
            Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        }
    end

    local capabilities = v.lsp.protocol.make_client_capabilities()
    capabilities = require 'cmp_nvim_lsp' .default_capabilities(capabilities)

    local lspconfig = require 'lspconfig'
    local mason_lspconfig = require 'mason-lspconfig'
    mason_lspconfig.setup {
        ensure_installed = v.tbl_keys(servers),
    }

    mason_lspconfig.setup_handlers {
        function(server_name)
            local config = servers[server_name]
            lspconfig[server_name].setup {
                capabilities = capabilities,
                settings = config,
                filetypes = (config or {}).filetypes,
            }
        end
    }

    require 'plugins.config.cmp'.config()
end

return m

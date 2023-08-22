local m = {}
local user = require 'user'

if user.settings.lsp == 'coc' then
    return require 'plugins.config.coc'
elseif user.settings.lsp == 'nvim' then
    return require 'plugins.config.nvim-lsp'
else
    m.goto_definition = function() end
    m.goto_declaration = function() end
    m.show_definitions = function() end
    m.show_declarations = function() end
    m.goto_definition_sync = function() end
    m.show_references = function() end
    m.code_action = function() end
    m.quick_fix = function() end
    m.type_definition = function() end
    m.switch_source_header = function() end
    m.show_documentation = function() end
    m.prev_diagnostic = function() end
    m.next_diagnostic = function() end
    m.rename = function() end
    m.format_selected = function() end
    m.expand_snippets = function() end
    m.select_snippets = function() end
    m.list_diagnostics = function() end
    m.is_enabled = function() end
    m.enable = function() end
    m.disable = function() end
    m.completion_mappings = false
end

return m

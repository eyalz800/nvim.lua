local m = {}

require 'builtins.nested'
require 'main.root_paths'
require 'main.path'
require 'main.basic'
require 'main.mappings'
require 'main.commands'
require 'main.autocmd'
require 'main.plugin_manager' .create()
require 'plugins'
require 'plugins.colors'.set()

return m

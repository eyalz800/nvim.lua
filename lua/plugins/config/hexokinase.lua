local m = {}
local v = require 'vim'

v.g.Hexokinase_highlighters = {'backgroundfull'}
v.g.Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names'
v.g.Hexokinase_refreshEvents = {'BufRead', 'BufWrite', 'TextChanged', 'InsertLeave', 'InsertEnter'}
v.g.Hexokinase_ftOptInPatterns = {
     cpp = 'rgb,rgba,hsl,hsla,colour_names',
     c = 'rgb,rgba,hsl,hsla,colour_names',
     python = 'rgb,rgba,hsl,hsla,colour_names',
}

return m

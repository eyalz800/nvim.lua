local m = {}

m.setup = function()
    m.diff = require 'mini.diff'
    m.diff.setup(m.config())
end

m.config = function()
    return {
        -- Disabled by default
        source = m.diff.gen_source.none(),
    }
end

return m


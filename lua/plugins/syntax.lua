local m = {}
local lsp = require 'plugins.lsp'

vim.g.python_highlight_all = 1
vim.g.python_highlight_operators = 0

m.apply_c_and_cpp_syntax = function()
    if lsp.semantic_highlighting then
        return
    end

    vim.cmd [=[
        syntax match cCustomDot "\." contained
        syntax match cCustomPtr "->" contained
        syntax match cCustomParen "(" contained contains=cParen contains=cCppParen " )
        syntax match cCustomBracket "\[" contained contains=cBracket " ]
        syntax match cCurlyBrace "{" contained " }

        syntax match cCustomFunc "\h\w*(" contains=cCustomParen " )
        hi def link cCustomFunc Function
        syntax keyword cIntegerType uint8_t
        syntax keyword cIntegerType uint16_t
        syntax keyword cIntegerType uint32_t
        syntax keyword cIntegerType uint64_t
        syntax keyword cIntegerType uintmax_t
        syntax keyword cIntegerType uintptr_t
        syntax keyword cIntegerType int8_t
        syntax keyword cIntegerType int16_t
        syntax keyword cIntegerType int32_t
        syntax keyword cIntegerType int64_t
        syntax keyword cIntegerType intmax_t
        syntax keyword cIntegerType intptr_t
        syntax keyword cIntegerType ptrdiff_t
        syntax keyword cIntegerType size_t
        syntax keyword cIntegerType byte
        hi def link cIntegerType cCustomClass
        syntax keyword cCharType char8_t
        syntax keyword cCharType char16_t
        syntax keyword cCharType char32_t
        hi def link cCharType cType
        syntax match cCompoundObject "\h\w*\(\.\|\->\)" contains=cCustomDot,cCustomPtr
        hi def link cCompoundObject cCustomMemVar
        syntax match cArrayObject "\h\w*\(\[\)" contains=cCustomBracket " ]
        hi def link cArrayObject cCompoundObject
        syntax match cCustomMemVar "\(\.\|->\)\h\w*" containedin=cCompoundObject contains=cCustomDot,cCustomPtr
        hi def link cCustomMemVar Function
        hi! link cCustomClass Type

        if &ft == 'cpp'
            syntax keyword cppNew new
            hi def link cppNew cppStatement
            syntax keyword cppDelete delete
            hi def link cppDelete cppStatement
            syntax keyword cppThis this
            hi def link cppThis cppStatement
            syntax keyword cppUsing using
            hi def link cppUsing cppStatement
            syntax match cppMemberFunction "\(\.\|\->\)\h\w*(" containedin=cCustomMemVar contains=cCustomDot,cCustomPtr,cCustomParen " )
            hi def link cppMemberFunction cCustomFunc
            syntax match cppVariable "\h\w*\({\)" contains=cCurlyBrace " }
            hi def link cppVariable cCustomMemVar
            syntax keyword cppSTLbool same_as
            hi! link cppStructure Type
        endif
    ]=]
end

m.apply_py_syntax = function()
    if lsp.semantic_highlighting then
        return
    end

    vim.cmd [=[
        syntax keyword pythonLambda lambda
        hi def link pythonLambda pythonStatement
        syntax keyword pythonDef def
        hi def link pythonDef pythonStatement
        syntax keyword pythonBuiltinType type
        hi link pythonRun pythonComment
    ]=]
end

return m

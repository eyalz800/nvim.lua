local m = {}
local v = require 'vim'

v.g.SignatureMarkTextHL = 'Normal'
v.g.SignatureMap = {
    ['Leader']             =  'm',
    ['PlaceNextMark']      =  'm,',
    ['ToggleMarkAtLine']   =  'm.',
    ['PurgeMarksAtLine']   =  'm-',
    ['DeleteMark']         =  'dm',
    ['PurgeMarks']         =  'm<Space>',
    ['PurgeMarkers']       =  'm<BS>',
    ['GotoNextLineAlpha']  =  '',
    ['GotoPrevLineAlpha']  =  '',
    ['GotoNextSpotAlpha']  =  '',
    ['GotoPrevSpotAlpha']  =  '',
    ['GotoNextLineByPos']  =  '',
    ['GotoPrevLineByPos']  =  '',
    ['GotoNextSpotByPos']  =  '',
    ['GotoPrevSpotByPos']  =  '',
    ['GotoNextMarker']     =  '',
    ['GotoPrevMarker']     =  '',
    ['GotoNextMarkerAny']  =  '',
    ['GotoPrevMarkerAny']  =  '',
    ['ListBufferMarks']    =  'm/',
    ['ListBufferMarkers']  =  'm?'
}

return m

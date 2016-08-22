/*
---------------------------------------------------------------------------
Function:
    To style tooltip and optionally use as user interface.
---------------------------------------------------------------------------
*/

class ToolTipUI {
    __New( _FontFace, _FontOptions ) {
        if ( ( _FontFace ) AND ( _FontOptions ) ) {
            this.FontFace := _FontFace
            this.FontOptions := _FontOptions
            Gui, ToolTipUI:Font, % this.FontOptions, % this.FontFace
            Gui, ToolTipUI:Add, Text, hwnd_hwnd, `.
            SendMessage, 0x31, 0, 0,, ahk_id %_hwnd%
        }
        this.Font := ErrorLevel
    }
    Create( _Message, _PosX = "", _PosY = "", _WhichToolTip = 1, _Keys = "", _Period = 0 ) {
        this.ToolTip[_WhichToolTip] := { KeyPressed: False, Timed: _Period }
        Tooltip, % _Message, % _PosX, % _PosY, % _WhichToolTip
        SendMessage, 0x30, % this.Font, 1,, ahk_class tooltips_class32
        if ( _Period ) {
            _Timer := this.Destroy.bind(this, _WhichToolTip)
            SetTimer, % _Timer, % -_Period
        }
        if ( !_Keys )
            return
        _HKCheck := this.Check.bind(this, _WhichToolTip)
        Loop, Parse, _Keys, |
            Hotkey, % A_LoopField, % _HKCheck, On
        While ( !this.ToolTip[_WhichToolTip]["KeyPressed"] )
            Sleep, 10
        ToolTip,,,, % _WhichToolTip
        Loop, Parse, _Keys, |
            Hotkey, % A_LoopField, % _HKCheck, Off
        return this.KeyPressed
    }
    Check( _WhichToolTip ) {
        this.ToolTip[_WhichToolTip]["KeyPressed"] := true
        this.KeyPressed := A_ThisHotkey
    }
    Destroy( _WhichToolTip ) {
        if ( this.ToolTip[_WhichToolTip]["Timed"] )
            this.ToolTip[_WhichToolTip]["KeyPressed"] := True
        ToolTip,,,, % _WhichToolTip
    }
}

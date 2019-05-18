/*
---------------------------------------------------------------------------
Function:
    To show defined GUI control help tooltips on hover.
---------------------------------------------------------------------------
*/

HelpToolTips( _Delay = 300, _Duration = 0, _Messages = "" ) {
    _fn := Func( "HelpToolTips__WM_MOUSEMOVE" ).Bind( _Delay, _Duration, _Messages )
    OnMessage( 0x200, _fn )
}

HelpToolTips__WM_MOUSEMOVE( _Delay = 300, _Duration = 0, _Messages = "" ) {
    static CurrControl, PrevControl, Messages
    CurrControl := A_GuiControl
    Messages := _Messages

    if ( CurrControl != PrevControl ) {
        SetTimer, DisplayToolTip, % - _Delay

        if ( _Duration )
            SetTimer, RemoveToolTip, % - ( _Delay + _Duration )

        PrevControl := CurrControl
    }

    return

    DisplayToolTip:
        try {
            if Messages
                ToolTip, % Messages[ CurrControl ],,, 20
            else
                ToolTip, % %CurrControl%_TT,,, 20
        }
        catch
            ToolTip,,,, 20
    return

    RemoveToolTip:
        ToolTip,,,, 20
    return
}

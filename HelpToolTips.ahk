/*
---------------------------------------------------------------------------
Function:
    To show defined GUI control help tooltips on hover.
---------------------------------------------------------------------------
*/

HelpToolTips( _Delay = 300, _Duration = 0 ) {
    _fn := Func( "HelpToolTips__WM_MOUSEMOVE" ).Bind( _Delay, _Duration )
    OnMessage( 0x200, _fn )
}

HelpToolTips__WM_MOUSEMOVE( _Delay = 300, _Duration = 0 ) {
    static CurrControl, PrevControl
    CurrControl := A_GuiControl

    if ( CurrControl != PrevControl ) {
        SetTimer, DisplayToolTip, % - _Delay

        if ( _Duration )
            SetTimer, RemoveToolTip, % - ( _Delay + _Duration )

        PrevControl := CurrControl
    }

    return

    DisplayToolTip:
        try
            ToolTip, % %CurrControl%_TT,,, 20
        catch
            ToolTip,,,, 20
    return

    RemoveToolTip:
        ToolTip,,,, 20
    return
}

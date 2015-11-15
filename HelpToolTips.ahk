/*
---------------------------------------------------------------------------
Function:
	To show defined GUI control help tooltips on hover.
---------------------------------------------------------------------------
*/

HelpToolTips( _Delay = 300, _Duration = 0 ) {
	_fn := Func( "WM_MOUSEMOVE" ).Bind( _Delay, _Duration )
	OnMessage( 0x200, _fn )
}

WM_MOUSEMOVE( _Delay = 300, _Duration = 0 ) {
	static CurrControl, PrevControl, _TT
	CurrControl := A_GuiControl
	if ( CurrControl != PrevControl ) {
		SetTimer, DisplayToolTip, % _Delay
		if ( _Duration )
			SetTimer, RemoveToolTip, % _Delay + _Duration
		PrevControl := CurrControl
	}
	return

	DisplayToolTip:
		SetTimer, DisplayToolTip, Off
		try
			ToolTip % %CurrControl%_TT
		catch
			ToolTip
	return

	RemoveToolTip:
		SetTimer, RemoveToolTip, Off
		ToolTip
	return
}

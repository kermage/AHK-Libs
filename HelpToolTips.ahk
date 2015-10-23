/*
---------------------------------------------------------------------------
Function:
	To show defined GUI control help tooltips on hover.
---------------------------------------------------------------------------
*/

HelpToolTips( _Delay = 300, _Duration = 0 ) {
	global HelpToolTips_Delay, HelpToolTips_Duration
	HelpToolTips_Delay := _Delay
	HelpToolTips_Duration := _Duration
	OnMessage( 0x200, "WM_MOUSEMOVE" )
}

WM_MOUSEMOVE() {
	global HelpToolTips_Delay, HelpToolTips_Duration
	static CurrControl, PrevControl, _TT
	CurrControl := A_GuiControl
	if ( CurrControl != PrevControl ) {
		SetTimer, DisplayToolTip, %HelpToolTips_Delay%
		PrevControl := CurrControl
	}
	return

	DisplayToolTip:
		SetTimer, DisplayToolTip, Off
		try
			ToolTip % %CurrControl%_TT
		catch
			ToolTip
		if ( HelpToolTips_Duration )
			SetTimer, RemoveToolTip, %HelpToolTips_Duration%
	return

	RemoveToolTip:
		SetTimer, RemoveToolTip, Off
		ToolTip
	return
}

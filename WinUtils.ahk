/*
---------------------------------------------------------------------------
Function:
	To get the path of the active window or all the open windows.
---------------------------------------------------------------------------
*/

WinGetPath( _Option = "All" ) {
	if ( _Option = "Active" ) {
		WinGetClass, _WinClass, A
		if ( _WinClass != "CabinetWClass" )
			return
		WinGet, _WinClass, ID, A
		return WinPath( _WinClass )
	}
	else if ( _Option = "All" ) {
		WinGet, AllWinsHwnd, List
		Loop, % AllWinsHwnd
		{
			if not IsWindow( AllWinsHwnd%A_Index% )
				continue
			WinGetClass, _WinClass, % "ahk_id " AllWinsHwnd%A_Index%
			if ( _WinClass != "CabinetWClass" )
				continue
			_WinPath .=  WinPath( AllWinsHwnd%A_Index% ) " "
		}
		StringTrimRight, _WinPath, _WinPath, 1
		return _WinPath
	}
}

IsWindow( _Hwnd ) {
	WinGet, _S, Style, ahk_id %_Hwnd%
	return _S & 0xC00000 ? (_S & 0x80000000 ? 0 : 1) : 0
}

WinPath( _Hwnd ) {
	WinGetText, _WinText, ahk_id %_Hwnd%
	Loop, Parse, _WinText, `n, `r
	{
		_WinPath := A_LoopField
		StringReplace, _WinPath, _WinPath, % "Address: "
		break
	}
	return _WinPath
}

/*
---------------------------------------------------------------------------
Function:
	SetTimer functionality for functions
---------------------------------------------------------------------------
*/

TimedFunction( _Label, _Params = 0, _Period = 250 ) {
	static _List := []
	if IsFunc( _Label ) {
		if _List.HasKey( _Label )
		{
			_Func := _List[_Label]
			_Timer := _Func.TID
			if ( _Period = "Off" ) {
				SetTimer, % _Timer, OFF
				_List.Remove( _Label )
				return
			}
			else
				return _List[ _Label ]
		}
		_Timer := Func( _Label ).Bind( _Params* )
		SetTimer, % _Timer, % _Period
		return _List[_Label] := { Function: _Label, Parameters: _Params, Period: _Period, TID: _Timer }
	}
}

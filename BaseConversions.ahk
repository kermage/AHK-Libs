/*
---------------------------------------------------------------------------
Function:
	Base to Decimal and Decimal to Base conversion.
---------------------------------------------------------------------------
*/

Dec2Base( _Number, _Base = 16 ) {
	Loop % _BaseLen := _Base<10 ? Ceil( ( 10/_Base ) * Strlen( _Number ) ) : Strlen( _Number )
		_D := Floor( _Number/( T := _Base**( _BaseLen-A_index ) ) ), _B .= !_D ? 0: ( _D>9 ? Chr( _D + 87 ) : _D ), _Number := _Number - _D * T
	return Ltrim( _B, "0" )
}

Base2Dec( _Number, _Base = 16 ) {
	Loop, Parse, _Number
		_N += ( ( A_LoopField * 1 = "" ) ? Asc( A_LoopField ) - 87 : A_LoopField ) * _Base**( Strlen( _Number ) - A_index )
	return _N
}

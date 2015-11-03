/*
---------------------------------------------------------------------------
Function:
	To load configuration settings file.
---------------------------------------------------------------------------
*/

LoadSettings( _File = "Settings.ini" ) {
	local Var, Val
	Loop, Read, %_File%
	{
		if ( ( InStr(A_LoopReadLine, "[") = 0 ) AND StrLen( A_LoopReadLine ) > 2 ) {
			local Ans := InStr( A_LoopReadLine, "=" )
			StringLeft, Var, A_LoopReadLine, Ans - 1
			StringRight, Val, A_LoopReadLine, StrLen( A_LoopReadLine ) - Ans
			%Var% := Val
		}
	}
}

/*
---------------------------------------------------------------------------
Function:
    To load configuration settings file.
---------------------------------------------------------------------------
*/

LoadSettings( _File = "Settings.ini" ) {
    local Var, Val, Secs, Cont

    IniRead, Secs, % _File

    Loop, Parse, Secs, `n
    {
        local Name := A_LoopField
        IniRead, Cont, % _File, % Name

        Loop, Parse, Cont, `n
        {
            local Ans := InStr( A_LoopField, "=" )
            StringLeft, Var, A_LoopField, Ans - 1
            StringRight, Val, A_LoopField, StrLen( A_LoopField ) - Ans
            Var := RegExReplace( Var, "\W", "_" )
            %Var% := Val
        }
    }
}

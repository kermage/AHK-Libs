/*
---------------------------------------------------------------------------
Function:
    To load configuration settings file.
---------------------------------------------------------------------------
*/

LoadSettings( _File = "Settings.ini", _Section = "", _Multi = false ) {
    Settings := []

    if ( _Section ) {
        SectionNames := _Section
    } else {
        IniRead, SectionNames, % _File
    }

    if ( StrSplit( SectionNames, "`n" ).MaxIndex() == 1 ) {
        _Section := SectionNames
    }

    Loop, Parse, SectionNames, `n
    {
        SectionName := A_LoopField

        if _Multi
            Settings[ SectionName ] := []
        else
            Prefix := ( _Section ? "" : SectionName . "_" )

        IniRead, SectionContent, % _File, % SectionName

        Loop, Parse, SectionContent, `n
        {
            KeyLine  := InStr( A_LoopField, "=" )
            Variable := SubStr( A_LoopField, 1,  KeyLine - 1 )
            Value    := SubStr( A_LoopField, KeyLine + 1, StrLen( A_LoopField ) - KeyLine )
            Variable := RegExReplace( Variable, "\W", "_" )

            if _Multi
                Settings[ SectionName ][ Variable ] := Value
            else
                Settings[ Prefix . Variable ] := Value
        }
    }

    return Settings
}

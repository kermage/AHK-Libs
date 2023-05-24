/*
---------------------------------------------------------------------------
Function:
    To load configuration settings file.
---------------------------------------------------------------------------
*/

LoadSettings( _File := "Settings.ini", _Multi := true, _Section := "" ) {
    local Settings := Map()

    if ( _Section ) {
        local SectionNames := _Section
    } else {
        local SectionNames := IniRead( _File )
    }

    if ( StrSplit( SectionNames, "`n" ).Length == 1 ) {
        _Section := SectionNames
    }

    Loop Parse SectionNames, "`n"
    {
        local SectionName := A_LoopField

        if _Multi
            Settings[ SectionName ] := Map()
        else
            local Prefix := ( _Section ? "" : SectionName . "_" )

        local SectionContent := IniRead( _File, SectionName )

        Loop Parse SectionContent, "`n"
        {
            local KeyLine  := InStr( A_LoopField, "=" )
            local Variable := SubStr( A_LoopField, 1,  KeyLine - 1 )
            local Value    := SubStr( A_LoopField, KeyLine + 1, StrLen( A_LoopField ) - KeyLine )
            Variable := RegExReplace( Variable, "\W", "_" )

            if _Multi
                Settings[ SectionName ][ Variable ] := Value
            else
                Settings[ Prefix . Variable ] := Value
        }
    }

    return Settings
}

/*
---------------------------------------------------------------------------
Function:
    To check for Administrator rights then elevate if needed.
---------------------------------------------------------------------------
*/

RunAsAdmin() {
    if ( A_IsAdmin ) {
        return
    }

    _Params := ""

    Loop A_Args.Length {
        _Params .= A_Space . A_Args[ A_Index ]
    }

    DllCall( "shell32\ShellExecute", "UInt", 0, "Str", "RunAs", "Str", ( A_IsCompiled ? A_ScriptFullPath : A_AhkPath ), "Str", ( A_IsCompiled ? "" : Chr( 34 ) . A_ScriptFullPath . Chr( 34 ) . A_Space ) _Params, "Str", A_WorkingDir, "Int", 1 )
    ExitApp
}

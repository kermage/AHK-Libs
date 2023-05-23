/*
---------------------------------------------------------------------------
Function:
    To parse command-line arguments.
---------------------------------------------------------------------------
*/

ParseArguments() {
    argv := Map()

    Loop A_Args.Length
    {
        argument := A_Args[ A_Index ]

        if ( SubStr( argument, 1, 1 ) != "-" && SubStr( argument, 1, 1 ) != "/" ) {
            continue
        }

        key := SubStr( argument, 2 )
        value := A_Index + 1 > A_Args.Length ? "" : A_Args[ A_Index + 1 ]

        if ( SubStr( argument, 1, 1 ) == "-" && SubStr( key, 1, 1 ) == "-" ) {
            key := SubStr( key, 2 )
        }

        if ( ! value || SubStr( value, 1, 1 ) == "-" || SubStr( value, 1, 1 ) == "/" ) {
            value := true
        }

        temp := StrSplit( key, "=",, 2 )

        if ( temp.Has( 2 ) ) {
            key := temp[1]
            value := temp[2]
        }

        argv[ key ] := value
    }

    return argv
}

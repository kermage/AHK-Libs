/*
---------------------------------------------------------------------------
Function:
    To parse command-line arguments.
---------------------------------------------------------------------------
*/

ParseArguments() {
    argv := []

    Loop % A_Args.Length()
    {
        argument := A_Args[ A_Index ]
        switch := SubStr( argument, 1, 1 )

        if switch not in -,/
            continue

        index := A_Index
        key := SubStr( argument, 2 )
        value := A_Args[ ++index ]

        if ( SubStr( key, 1, 1 ) == "-" ) {
            key := SubStr( key, 2 )
        }

        if ( ! value || SubStr( value, 1, 1 ) == "-" || SubStr( value, 1, 1 ) == "/" ) {
            value := true
        }

        argv[ key ] := value
    }

    return argv
}

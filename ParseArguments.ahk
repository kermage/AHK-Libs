/*
---------------------------------------------------------------------------
Function:
    To parse command-line arguments.
---------------------------------------------------------------------------
*/

ParseArguments() {
    global argv := []

    Loop % A_Args.Length()
    {
        argument := A_Args[ A_Index ]
        switch := SubStr( argument, 1, 1 )

        if switch not in -,/
            continue

        index := A_Index
        key := SubStr( argument, 2 )
        value := A_Args[ ++index ]
        argv[ key ] := value
    }
}

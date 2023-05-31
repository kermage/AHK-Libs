/*
---------------------------------------------------------------------------
Function:
    Parse URL
---------------------------------------------------------------------------
*/


ParseURL( _URL, _Component := "" ) {
    local Parsed := {}

    if ( ! RegExMatch( _URL, "^((?<SCHEME>.*)://)?(?<HOST>[^/:?#]+)(:(?<PORT>\d+))?(?<PATH>/[^?]*)?(?<QUERY>\?[^#]*)?(?<FRAGMENT>#.*)?$", &Parsed ) ) {
        return
    }

    local RetVal := {
        SCHEME: Parsed.SCHEME,
        HOST: Parsed.HOST,
        PORT: Parsed.PORT,
        PATH: Parsed.PATH,
        QUERY: LTrim( Parsed.QUERY, "?" ),
        FRAGMENT: LTrim( Parsed.FRAGMENT, "#" ),
    }

    if ( RetVal.HasProp( _Component ) ) {
        return RetVal.%_Component%
    }

    return RetVal
}

/*
---------------------------------------------------------------------------
Function:
    JSON Stringify
---------------------------------------------------------------------------
*/

JSONStringify( _Data ) {
    static fType := VerCompare( A_AhkVersion, "2.0" ) < 0 ? Func( "Type" ) : ""

    if IsObject( _Data ) && ( ! fType ? ObjGetCapacity( _Data ) != "" : fType.Call( _Data ) == "Object" )
    {
        string := ""
        isArray := true

        for key, value in _Data
        {
            if ( key == A_Index )
                continue

            isArray := false
            break
        }

        for key, value in _Data
            string .= ( isArray ? "" : JSONStringify__Escape( key ) ":" ) JSONStringify( value ) ","

        string := RTrim( string, "," )

        return ( isArray ? "[" string "]" : "{" string "}" )
    }
    else if _Data is number
        return _Data
    else
        return JSONStringify__Escape( _Data )
}

JSONStringify__Escape( _Value ) {
    _Value := StrReplace( _Value, Chr( 34 ), "\" . Chr( 34 ) )

    _Value := StrReplace( _Value, "`n", "\n" )
    _Value := StrReplace( _Value, "`r", "\r" )
    _Value := StrReplace( _Value, "`t", "\t" )

    _Value := StrReplace( _Value,  "\", "\\" )
    _Value := StrReplace( _Value,  "/", "\/" )

    return Chr( 34 ) _Value Chr( 34 )
}

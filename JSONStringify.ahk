/*
---------------------------------------------------------------------------
Function:
    JSON Stringify
---------------------------------------------------------------------------
*/

JSONStringify( _Data ) {
    if IsObject( _Data )
    {
        string := ""
        isArray := true

        for key in _Data
        {
            if ( key == A_Index )
                continue

            isArray := false
            break
        }

        for key, value in _Data
            string .= ( isArray ? "" : """" key """:" ) JSONStringify( value ) ","

        string := RTrim( string, "," )

        return ( isArray ? "[" string "]" : "{" string "}" )
    }
    else if _Data is number
        return _Data
    else
        return """" _Data """"
}

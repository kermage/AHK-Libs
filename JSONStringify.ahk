/*
---------------------------------------------------------------------------
Function:
    JSON Stringify
---------------------------------------------------------------------------
*/

JSONStringify( _Data ) {
    Escape( _Value ) {
        static Quote := Chr( 34 )
        _Value := StrReplace( _Value, Quote, "\" . Quote )

        _Value := StrReplace( _Value, "`n", "\n" )
        _Value := StrReplace( _Value, "`r", "\r" )
        _Value := StrReplace( _Value, "`t", "\t" )

        _Value := StrReplace( _Value,  "\", "\\" )
        _Value := StrReplace( _Value,  "/", "\/" )

        return Quote . _Value . Quote
    }

    if ( IsObject( _Data ) ) {
        local dType := Type( _Data )
        local output := ""

        local key, value

        for key, value in ( dType == "Array" || dType == "Map" || dType == "Enumerator" ) ? _Data : _Data.OwnProps() {
            output .= dType == "Array" ? "" : ( Escape( key ) . ":" ) ; key
            output .= JSONStringify( value ) . ","                    ; value
        }

        output := RTrim( output, "," )

        return ( dType == "Array" ? "[" output "]" : "{" output "}" )
    } else if ( IsNumber( _Data ) ) {
        return _Data
    }

    return Escape( _Data )
}

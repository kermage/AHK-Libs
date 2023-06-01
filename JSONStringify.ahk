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

    if ( ComObjType( _Data ) ) {
        return ""
    }

    if ( IsObject( _Data ) ) {
        local isArray := Type( _Data ) == "Array"
        local output := ""

        local key, value

        for key, value in _Data.HasProp( "__Enum" ) ? _Data : _Data.OwnProps() {
            output .= isArray  ? "" : ( Escape( key ) . ":" ) ; key
            output .= JSONStringify( value ) . ","            ; value
        }

        output := RTrim( output, "," )

        return ( isArray  ? "[" output "]" : "{" output "}" )
    } else if ( IsNumber( _Data ) ) {
        return _Data
    }

    return Escape( _Data )
}

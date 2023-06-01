/*
---------------------------------------------------------------------------
Function:
    Build Query
---------------------------------------------------------------------------
*/

BuildQuery( _Data ) {
    static HTML := ""

    if ( HTML == "" ) {
        HTML := ComObject( "HTMLFile" )
        HTML.write( "<meta http-equiv='X-UA-Compatible' content='IE=edge'>" )
    }

    Encode( _Value ) {
        return HTML.parentWindow.encodeURIComponent( _Value )
    }

    local output := ""

    if ( IsObject( _Data ) ) {
        local isArray := Type( _Data ) == "Array"

        local key, value

        for key, value in _Data.HasProp( "__Enum" ) ? _Data : _Data.OwnProps() {
            output .= Encode( isArray ? ( key - 1 ) : key ) . "=" ; key
            output .= Encode( value ) . "&"                       ; value
        }

        output := RTrim( output, "&" )
    } else {
        output := Encode( _Data )
    }

    return output
}

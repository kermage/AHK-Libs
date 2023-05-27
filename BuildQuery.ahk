/*
---------------------------------------------------------------------------
Function:
    Build Query
---------------------------------------------------------------------------
*/

BuildQuery( _Data ) {
    static HTML := ComObject( "HTMLFile" )

    HTML.write( "<meta http-equiv='X-UA-Compatible' content='IE=edge'>" )

    Encode( _Value ) {
        return HTML.parentWindow.encodeURIComponent( _Value )
    }

    local output := ""

    if ( IsObject( _Data ) ) {
        local dType := Type( _Data )

        local key, value

        for key, value in ( dType == "Array" || dType == "Map" || dType == "Enumerator" ) ? _Data : _Data.OwnProps() {
            output .= Encode( dType == "Array" ? ( key - 1 ) : key ) . "=" ; key
            output .= Encode( value ) . "&"                                ; value
        }

        output := RTrim( output, "&" )
    } else {
        output := Encode( _Data )
    }

    return output
}

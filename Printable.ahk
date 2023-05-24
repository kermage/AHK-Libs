/*
---------------------------------------------------------------------------
Function:
    For pretty printing texts
---------------------------------------------------------------------------
*/

#Include <JSONStringify>

class Printable {
    __New( _Data ) {
        this.Data := _Data
    }

    Normal() {
        if ( IsObject( this.Data ) ) {
            return JSONStringify( this.Data )
        }

        return this.Data
    }

    Bold() {
        return this._Print( 0x1D400, 0x1D41A, 0x1D7CE )
    }

    Italic() {
        return this._Print( 0x1D434, 0x1D44E )
    }

    BoldItalic() {
        return this._Print( 0x1D468, 0x1D482, 0x1D7CE )
    }


    _Print( _Upper, _Lower, _Numeric := "" ) {
        local output := ""

        Loop Parse this.Normal() {
            local character := Ord( A_LoopField )

            if ( character >= 0x41 && character <= 0x5A ) {
                character += ( _Upper - 0x41 )
            } else if ( character >= 0x61 && character <= 0x7A ) {
                character += ( _Lower - 0x61 )
            } else if ( _Numeric && character >= 0x30 && character <= 0x39 ) {
                character += ( _Numeric - 0x30 )
            }

            output .= Chr( character )
        }

        return output
    }
}

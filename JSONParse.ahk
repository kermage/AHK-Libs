/*
---------------------------------------------------------------------------
Function:
    JSON Parse
---------------------------------------------------------------------------
*/

JSONParse( _String ) {
    static HTML := ""

    if ( HTML == "" ) {
        HTML := ComObject( "HTMLFile" )
        HTML.write( "<meta http-equiv='X-UA-Compatible' content='IE=edge'>" )
    }

    Type( _Value ) {
        return HTML.parentWindow.Object.prototype.toString.call( _Value )
    }

    Eval( _Parsed ) {
        if ( Type( _Parsed ) == "[object Array]" ) {
            local output := Array()

            Loop _Parsed.length {
                output.Push( _Parsed.%A_Index - 1% )
            }
        } else if ( Type( _Parsed ) == "[object Object]" ) {
            local output := Map()
            local keys := HTML.parentWindow.Object.keys( _Parsed )

            Loop keys.length {
                local key := keys.%A_Index - 1%

                output.Set( key, Eval( _Parsed.%key% ) )
            }
        } else {
            local output := _Parsed
        }

        return output
    }

    HTML.write( "<meta http-equiv='X-UA-Compatible' content='IE=edge'>" )

    return Eval( HTML.parentWindow.JSON.parse( _String ) )
}

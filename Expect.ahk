/*
---------------------------------------------------------------------------
Function:
    Basic class for expectations
---------------------------------------------------------------------------
*/

class Expect
{
    __New( _Value ) {
        this.Comparable := Comparable( _Value )
    }

    __Call( _Method, _Params ) {
        MethodName := StrReplace( _Method, "ToBe", "Is" )

        if ( ! HasMethod( this.Comparable, MethodName ) ) {
            throw Error( "Unknown method named " Chr( 34 ) _Method Chr( 34 ) )
        }

        if ( ! ObjBindMethod( this.Comparable, MethodName, _Params* )() ) {
            throw Error( "Expectation failed " Chr( 34 ) _Method Chr( 34 ) )
        }
    }
}

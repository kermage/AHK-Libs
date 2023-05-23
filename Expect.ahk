/*
---------------------------------------------------------------------------
Function:
    Basic class for expectations
---------------------------------------------------------------------------
*/

#Include <Comparable>
#Include <Printable>

class Expect
{
    __New( _Value ) {
        this.Comparable := Comparable( _Value )
    }

    __Call( _Method, _Params ) {
        MethodName := StrReplace( _Method, "Is", "_" )
        MethodName := StrReplace( MethodName, "ToBe", "Is" )

        if ( ! HasMethod( this.Comparable, MethodName ) ) {
            throw Error( "Unknown method named " Printable( Chr( 34 ) . _Method . Chr( 34 ) ).Normal() )
        }

        if ( ! ObjBindMethod( this.Comparable, MethodName, _Params* )() ) {
            _Method := Expect.ToWords( _Method )
            _Params := _Params.Length ? Printable( _Params[ 1 ] ).Normal() : ""

            throw Error( Trim( Format( "Expected {1} {2} {3}", Printable( this.Comparable.Value ).Normal(), _Method, _Params ) ) )
        }

        return this
    }

    static ToWords( _Method ) {
        _Method := StrReplace( _Method, "Is", "To", 1 )
        _Method := RegExReplace( _Method, "([A-Z])", " $1" )
        _Method := LTrim( StrLower( _Method ) )

        return _Method
    }
}

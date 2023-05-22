/*
---------------------------------------------------------------------------
Function:
    Basic class for expectations
---------------------------------------------------------------------------
*/

#Include <JSONStringify>
#Include <Comparable>

class Expect
{
    __New( _Value ) {
        this.Comparable := Comparable( _Value )
    }

    __Call( _Method, _Params ) {
        MethodName := StrReplace( _Method, "Is", "_" )
        MethodName := StrReplace( MethodName, "ToBe", "Is" )

        if ( ! HasMethod( this.Comparable, MethodName ) ) {
            throw Error( "Unknown method named " _Method )
        }

        if ( ! ObjBindMethod( this.Comparable, MethodName, _Params* )() ) {
            _Method := StrReplace( _Method, "Is", "To", 1 )
            _Method := RegExReplace( _Method, "([A-Z])", " $1" )
            _Method := LTrim( StrLower( _Method ) )
            _Params := _Params.Length ? Expect.Printable( _Params[ 1 ] ) : ""

            throw Error( Trim( Format( "Expected {1} {2} {3}", Expect.Printable( this.Comparable.Value ), _Method, _Params ) ) )
        }

        return this
    }


    static Printable( _Data ) {
        expected := Comparable( _Data )

        if ( expected.IsType( "Object" ) || expected.IsType( "Array" ) || expected.IsType( "Map" ) ) {
            return JSONStringify( _Data )
        }

        return _Data
    }
}

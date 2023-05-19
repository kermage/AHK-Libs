/*
---------------------------------------------------------------------------
Function:
    Basic class for comparisons
---------------------------------------------------------------------------
*/

class Comparable
{
    __New( _Value ) {
        this.Value := _Value
    }


    Is( _Expected ) {
        return this.Value == _Expected
    }

    IsDefined() {
        return ! this.Is( "" )
    }

    IsUndefined() {
        return ! this.IsDefined()
    }

    IsTruthy() {
        return this.Is( true )
    }

    IsFalsy() {
        return this.Is( false )
    }


    IsGreaterThan( _Expected ) {
        return this.Value > _Expected
    }

    IsGreaterThanOrEqual( _Expected ) {
        return this.IsGreaterThan( _Expected ) || this.Is( _Expected )
    }

    IsLessThan( _Expected ) {
        return this.Value < _Expected
    }

    IsLessThanOrEqual( _Expected ) {
        return this.IsLessThan( _Expected ) || this.Is( _Expected )
    }


    IsType( _Expected ) {
        return Comparable( Type( this.Value ) ).Is( _Expected )
    }


    ToHave( _Expected ) {
        if ( this.IsType( "Object" ) || this.IsType( "Array" ) || this.IsType( "Map" ) ) {
            props := this.IsType( "Object" ) ? this.Value.OwnProps() : this.Value

            for index, value in props {
                if ( Comparable( this.IsType( "Array" ) ? value : index ).Is( _Expected ) ) {
                    return true
                }
            }

            return false
        }

        return !! InStr( this.Value, _Expected, true )
    }

    ToContain( _Expected ) {
        if ( this.IsType( "Object" ) || this.IsType( "Array" ) || this.IsType( "Map" ) ) {
            props := this.IsType( "Object" ) ? this.Value.OwnProps() : this.Value

            for index, value in props {
                if ( Comparable( value ).Is( _Expected ) ) {
                    return true
                }
            }

            return false
        }

        return this.ToHave( _Expected )
    }
}

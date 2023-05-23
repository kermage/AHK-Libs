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

    IsInt( _Strict := false ) {
        return _Strict ? this.IsType( "Integer" ) : IsInteger( this.Value )
    }

    IsFloat( _Strict := false ) {
        return _Strict ? this.IsType( "Float" ) : IsFloat( this.Value )
    }

    IsNumeric( _Strict := false ) {
        return _Strict ? ( this.IsInt( true ) || this.IsFloat( true ) ) : IsNumber( this.Value )
    }

    IsObject( _Strict := true ) {
        return _Strict ? this.IsType( "Object" ) : IsObject( this.Value )
    }

    IsArray() {
        return this.IsType( "Array" )
    }

    IsMap() {
        return this.IsType( "Map" )
    }

    IsEnumerable() {
        return this.IsArray() || this.IsMap()
    }

    IsAssociative() {
        return this.IsObject() || this.IsMap()
    }


    ToHave( _Expected ) {
        if ( this.IsObject() || this.IsEnumerable() ) {
            props := this.IsObject() ? this.Value.OwnProps() : this.Value

            for index, value in props {
                if ( Comparable( index ).Is( _Expected ) ) {
                    return true
                }
            }

            return false
        }

        return !! InStr( this.Value, _Expected, true )
    }

    ToContain( _Expected ) {
        if ( this.IsObject() || this.IsEnumerable() ) {
            props := this.IsObject() ? this.Value.OwnProps() : this.Value

            for index, value in props {
                if ( Comparable( value ).Is( _Expected ) ) {
                    return true
                }
            }

            return false
        }

        return this.ToHave( _Expected )
    }


    ToEqual( _Expected ) {
        expected := Comparable( _Expected )

        if ( this.IsAssociative() && expected.IsAssociative() ) {
            return expected.ToContainEqual( this.Value )
        }

        return this.Is( _Expected )
    }

    ToContainEqual( _Expected ) {
        _Value := Comparable( this.Value )
        expected := Comparable( _Expected )

        if ( ! this.IsAssociative() || ! expected.IsAssociative() ) {
            return false
        }

        props := expected.IsObject() ? _Expected.OwnProps() : _Expected

        for index, value in props {
            if ( _Value.ToHave( index ) && _Value.ToContain( value ) ) {
                continue
            }

            return false
        }

        return true
    }
}

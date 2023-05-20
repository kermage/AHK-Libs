/*
---------------------------------------------------------------------------
Function:
    Base to Decimal and Decimal to Base conversion.
---------------------------------------------------------------------------
*/

Base2Dec( _Number, _Base := 16 ) {
    if ( ! _Number ) {
        return 0
    }

    if ( _Base <= 1 || _Base > 36 ) {
        return ""
    }

    result := 0
    multiplier := 1

    Loop Parse, _Number
    {
        digit := Ord( A_LoopField )

        if ( digit >= 48 && digit <= 57 ) {
            digit := digit - 48
        } else if ( digit >= 65 && digit <= 90 ) {
            digit := digit - 55
        } else if ( digit >= 97 && digit <= 122 ) {
            digit := digit - 87
        } else {
            return ""
        }

        if ( digit >= _Base ) {
            return ""
        }

        result := result * _Base + digit
        multiplier := multiplier * _Base
    }

    return result
}

Dec2Base( _Number, _Base := 16 ) {
    if ( ! _Number ) {
        return "0"
    }

    if ( _Base <= 1 || _Base > 36 ) {
        return ""
    }

    result := ""

    while ( _Number > 0 ) {
        remainder := Mod( _Number, _Base )
        _Number := ( _Number - remainder ) / _Base

        if ( remainder < 10 ) {
            result := Chr( remainder + 48 ) . result
        } else {
            result := Chr( remainder + 55 ) . result
        }
    }

    return result
}

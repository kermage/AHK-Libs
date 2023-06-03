/*
---------------------------------------------------------------------------
Function:
    For getting data type sizes
        https://learn.microsoft.com/en-us/cpp/cpp/fundamental-types-cpp?view=msvc-170
---------------------------------------------------------------------------
*/

class DataType extends Buffer {
    ; standard
    static bool := 1
    static char := 1
    static int := 4
    static float := 4
    static double := 8


    ; builtin
    static __int8 := 1
    static char8_t := 1
    static __int16 := 2
    static char16_t := 2
    static __wchar_t := 2
    static wchar_t := 2
    static char32_t := 4
    static __int32 := 4
    static __int64 := 8

    static signed__int8 := 1
    static signed__int16 := 2
    static signed__int32 := 4
    static signed__int64 := 8
    static unsigned__int8 := 1
    static unsigned__int16 := 2
    static unsigned__int32 := 4
    static unsigned__int64 := 8

    ; static char := 1
    static signed_char := 1
    static unsigned_char := 1

    static short := 2
    static short_int := 2
    static signed_short := 2
    static signed_short_int := 2
    static unsigned_short := 2
    static unsigned_short_int := 2

    ; static int := 4
    static signed := 4
    static signed_int := 4
    static unsigned := 4
    static unsigned_int := 4

    static long := 4
    static long_int := 4
    static signed_long := 4
    static signed_long_int := 4
    static unsigned_long := 4
    static unsigned_long_int := 4

    static long_double := 8
    static long_long := 8
    static long_long_int := 8
    static signed_long_long := 8
    static signed_long_long_int := 8
    static unsigned_long_long := 8
    static unsigned_long_long_int := 8


    __New( _Data, _Fill := 0 ) {
        Parse( _Value ) {
            if ( IsNumber( _Value ) ) {
                return _Value
            }

            _Value := StrReplace( _Value, A_Space, "_" )
            local maybeMax := StrSplit( _Value, "_" )[ 1 ]

            if ( IsNumber( maybeMax ) ) {
                _Value := StrReplace( _Value, maybeMax "_", "" )
            } else {
                maybeMax := 1
            }

            return DataType.%_Value% * maybeMax
        }

        this.Data := Map()

        local index, value

        for index, value in _Data.OwnProps() {
            this.Data[ index ] := Parse( value )
        }

        super.__New( this.Size, _Fill )
    }


    Size[ _Field := "" ] {
        get {
            if ( _Field == "" ) {
                local index, value, size := 0

                for index, value in this.Data {
                    size += value
                }

                return size
            }

            return this.Data.Has( _Field ) ? this.Data[ _Field ] : 0
        }
    }

    Offset( _Field ) {
        if ( ! this.Size[ _Field ] ) {
            return -1
        }

        local index, value, offset := 0

        for index, value in this.Data {
            if ( _Field == index ) {
                break
            }

            offset += value
        }

        return offset
    }
}

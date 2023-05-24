/*
---------------------------------------------------------------------------
Function:
    Basic Pixel Window Class
---------------------------------------------------------------------------
*/

class PixelWindow {
    __New( _ID ) {
        this.PWID := _ID
        this.Device := DllCall( "GetDC", "UInt", _ID )
        this.Context := DllCall( "CreateCompatibleDC", "UInt", this.Device )

        local X, Y, Width, Height

        WinGetPos( &X, &Y, &Width, &Height, "ahk_id " this.PWID )

	    this.Buffer := DllCall( "CreateCompatibleBitmap", "UInt", this.Device, "UInt", Width, "UInt", Height )

        DllCall( "SelectObject", "UInt", this.Context, "UInt", this.Buffer )
        DllCall( "PrintWindow", "UInt", this.PWID, "UInt", this.Context, "UInt", 0 )
    }

    __Delete() {
        DllCall( "ReleaseDC", "UInt", this.PWID, "UInt", this.Device )
        DllCall( "DeleteDC", "UInt", this.Context )
        DllCall( "DeleteObject", "UInt", this.Buffer )
    }

    GetColor( _X, _Y, _RGB := 0 ) {
        local _Color := DllCall( "GetPixel", "UInt", this.Context, "UInt", _X, "UInt", _Y )

        return _RGB ? this.ToRGB( _Color ) : _Color
    }

    Search( _X1, _Y1, _X2, _Y2, _Color, _RGB := 0 ) {
        local X := _X1

        Loop ( _X2 - _X1 ) {
            local Y := _Y1

            Loop ( _Y2 - _Y1 ) {
                if ( _Color == this.GetColor( X, Y, _RGB ) ) {
                    return { X: X, Y: Y }
                }

                Y++
            }

            X++
        }

        return false
    }

    ToRGB( _Color ) {
        local _Red := ( _Color >> 16 ) & 0xFF
        local _Green := ( _Color >> 8 ) & 0xFF
        local _Blue := ( _Color >> 0 ) & 0xFF

        return ( _Blue << 16 ) | ( _Green << 8 ) | ( _Red << 0 )
    }
}

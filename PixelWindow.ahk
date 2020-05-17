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

        WinGetPos,,, Width, Height, % "ahk_id " this.PWID
        
	    this.Buffer := DllCall( "CreateCompatibleBitmap", "UInt", this.Device, "UInt", Width, "UInt", Height )

        DllCall( "SelectObject", "UInt", this.Context, "UInt", this.Buffer )
        DllCall( "PrintWindow", "UInt", this.PWID, "UInt", this.Context, "UInt", 0 )
    }

    __Delete() {
        DllCall( "ReleaseDC", "UInt", this.PWID, "UInt", this.Device )
        DllCall( "DeleteDC", "UInt", this.Context )
        DllCall( "DeleteObject", "UInt", this.Buffer )
    }

    GetColor( _X, _Y ) {
        return DllCall( "GetPixel", "UInt", this.Context, "UInt", _X, "UInt", _Y )
    }
}

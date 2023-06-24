/*
---------------------------------------------------------------------------
Function:
    Basic GDI+ Class
---------------------------------------------------------------------------
*/

class GDIPlus {
    __New( _ID ) {
        this.GPID := _ID
        this.Device := DllCall( "GetDC", "UInt", _ID )
        this.Context := DllCall( "CreateCompatibleDC", "UInt", this.Device )

        local X, Y, Width, Height

        WinGetPos( &X, &Y, &Width, &Height, "ahk_id " this.GPID )

        local bitmapInfo := Buffer( 44, 0 ) ; header size

        NumPut( "UInt", bitmapInfo.Size, bitmapInfo, 0 )
        NumPut( "Int", Width, bitmapInfo, 4 )
        NumPut( "Int", Height, bitmapInfo, 8 )
        NumPut( "UShort", 1, bitmapInfo, 12 )
        NumPut( "UShort", 32, bitmapInfo, 14 ) ; bpp
        NumPut( "UInt", 0, bitmapInfo, 16 ) ; BI_RGB

        local ppvBits := 0

        this.DIB := DllCall( "CreateDIBSection", "UPtr", this.Device, "Ptr", bitmapInfo, "UInt", 0, "UPtr*", &ppvBits, "Ptr", 0, "Int", 0 )

        DllCall( "SelectObject", "UInt", this.Context, "UInt", this.DIB )
        DllCall( "PrintWindow", "UInt", this.GPID, "UInt", this.Context, "UInt", 0 )

        local pBitmap := 0

	    DllCall( "gdiplus\GdipCreateBitmapFromHBITMAP", "UPtr", this.DIB, "UPtr", 0, "UPtr*", &pBitmap )

        this.Bitmap := pBitmap
    }

    __Delete() {
        DllCall( "gdiplus\GdipDisposeImage", "UPtr", this.Bitmap )
        DllCall( "ReleaseDC", "UInt", this.GPID, "UInt", this.Device )
        DllCall( "DeleteDC", "UInt", this.Context )
        DllCall( "DeleteObject", "UInt", this.DIB )
    }

    GetColor( _X, _Y ) {
        local ARGB := 0

        DllCall( "gdiplus\GdipBitmapGetPixel", "UPtr", this.Bitmap, "UInt", _X, "UInt", _Y, "UInt*", &ARGB )

        return ARGB
    }

    Search( _X1, _Y1, _X2, _Y2, _Color ) {
        local X := _X1

        Loop Abs( _X2 - _X1 ) {
            local Y := _Y1

            Loop Abs( _Y2 - _Y1 ) {
                if ( _Color == this.GetColor( X, Y ) ) {
                    return { X: X, Y: Y }
                }

                if ( _Y2 > _Y1 ) {
                    Y++
                } else {
                    Y--
                }
            }

            if ( _X2 > _X1 ) {
                X++
            } else {
                X--
            }
        }

        return false
    }


    static __New() {
        DllCall( "LoadLibraryW", "WStr", "gdiplus" )

        local token := 0
        local sInput := Buffer( 20 ) ; *input struct

        NumPut( "UInt", 1, sInput, 0 ) ; version
        NumPut( "Ptr", 0, sInput, 4 )  ; null
        NumPut( "Int", 0, sInput, 12 ) ; false
        NumPut( "Int", 0, sInput, 16 ) ; false

        local Result := DllCall( "gdiplus\GdiplusStartup", "UPtr*", &token, "Ptr", sInput, "Ptr", 0 )

        if ( Result ) {
            throw Error( "GdiplusStartup() errored out", -1, Result )
        }
    }
}

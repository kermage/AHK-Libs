/*
---------------------------------------------------------------------------
Function:
    Basic Process Memory Class
---------------------------------------------------------------------------
*/

class ProcessMemory {
    __New( _PID, _Privilege = 0x1F0FFF ) {
        this.HWND := DllCall( "OpenProcess", "UInt", _Privilege, "UInt", 0, "UInt", _PID )

        WinGet, cID, ID, % "ahk_pid " _PID

        this.BaseAddress := DllCall( A_PtrSize = 4 ? "GetWindowLong" : "GetWindowLongPtr", "Ptr", cID, "Int", -6, A_Is64bitOS ? "Int64" : "UInt" )
        this.BytesRead := DllCall( "GlobalAlloc", "UInt", 0x0040, "Ptr", A_PtrSize, "Ptr" )
        this.BytesWrite := DllCall( "GlobalAlloc", "UInt", 0x0040, "Ptr", A_PtrSize, "Ptr" )
    }

    __Delete() {
        return DllCall( "CloseHandle", "UInt", this.HWND )
    }

    Read( _Address, _Type = "UInt*", _Length = 4 ) {
        DllCall( "ReadProcessMemory", "Ptr", this.HWND, "Ptr", _Address, _Type, _Value, "Ptr", _Length, "Ptr", this.BytesRead )

        return _Value
    }

    Read_String( _Address ) {
        Buffer := ""

        Loop {
            Value := this.Read( _Address, "Str", 1 )

            if ( ! Value ) {
                break
            }

            Buffer .= Value
            _Address++
        }

        return Buffer
    }

    Write( _Address, _Value, _Type = "UInt*", _Length = 4 ) {
        return DllCall( "WriteProcessMemory", "Ptr", this.HWND, "Ptr", _Address, _Type, _Value, "Ptr", _Length, "Ptr", this.BytesWrite )
    }

    Write_String( _Address, _Value ) {
        Loop, Parse, % _Value
        {
            this.Write( _Address, A_LoopField, "Str" )
            _Address++
        }
    }

    Pointer( _Base, _Type = "Int*", _Offsets* ) {
        for index, offset in _Offsets
            _Base := this.Read( _Base, _Type ) + offset

        Return this.Read( _Base, _Type )
    }
}

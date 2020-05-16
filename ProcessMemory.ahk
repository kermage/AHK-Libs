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

    Read( _Address, _Type = "UInt", _Length = 4 ) {
        DllCall( "ReadProcessMemory", "Ptr", this.HWND, "Ptr", _Address, _Type "*", _Value, "Ptr", _Length, "Ptr", this.BytesRead )

        return _Value
    }

    Read_String( _Address, _Length = 4 ) {
        VarSetCapacity( Buffer, _Length, 0 )
        DllCall( "ReadProcessMemory", "Ptr", this.HWND, "Ptr", _Address, "Ptr", &Buffer, "Ptr", _Length, "Ptr", this.BytesRead )

        return StrGet( &Buffer, "UTF-8" )
    }

    Write( _Address, _Value, _Type = "UInt", _Length = 4 ) {
        return DllCall( "WriteProcessMemory", "Ptr", this.HWND, "Ptr", _Address, _Type "*", _Value, "Ptr", _Length, "Ptr", this.BytesWrite )
    }

    Write_String( _Address, _Value, _Length = 4 ) {
        VarSetCapacity( Buffer, _Length, 0 )
        StrPut( _Value, &Buffer, StrLen( _Value ) + 1, "UTF-8" )

        return DllCall( "WriteProcessMemory", "Ptr", this.HWND, "Ptr", _Address, "Ptr", &Buffer, "Ptr", _Length, "Ptr", this.BytesWrite )
    }

    Pointer( _Base, _Type = "UInt", _Offsets* ) {
        for index, offset in _Offsets
            _Base := this.Read( _Base, _Type ) + offset

        return this.Read( _Base, _Type )
    }

    Trace( _Address, _Offsets* ) {
        return _Offsets.Remove() + this.Pointer( _Address, "UInt", _Offsets* )
    }
}

/*
---------------------------------------------------------------------------
Function:
    Basic Process Memory Class
---------------------------------------------------------------------------
*/

class ProcessMemory {
    __New( _PID, _Privilege := 0x1F0FFF ) {
        this.HWND := DllCall( "OpenProcess", "UInt", _Privilege, "UInt", 0, "UInt", _PID )
        this.BaseAddress := DllCall( A_PtrSize = 4 ? "GetWindowLong" : "GetWindowLongPtr", "Ptr", WinGetID( "ahk_pid " _PID ), "Int", -6, A_Is64bitOS ? "Int64" : "UInt" )
        this.BytesRead := DllCall( "GlobalAlloc", "UInt", 0x0040, "Ptr", A_PtrSize, "Ptr" )
        this.BytesWrite := DllCall( "GlobalAlloc", "UInt", 0x0040, "Ptr", A_PtrSize, "Ptr" )
    }

    __Delete() {
        DllCall( "GlobalFree", "Ptr", this.BytesRead )
        DllCall( "GlobalFree", "Ptr", this.BytesWrite )

        return DllCall( "CloseHandle", "UInt", this.HWND )
    }

    Read( _Address, _Type := "UInt", _Length := 4 ) {
        local _Buffer := Buffer( _Length, 0 )

        DllCall( "ReadProcessMemory", "Ptr", this.HWND, "Ptr", _Address, "Ptr", _Buffer, "Ptr", _Length, "Ptr", this.BytesRead )

        return NumGet( _Buffer, 0, _Type )
    }

    Read_String( _Address, _Length := 4, _Encoding := "UTF-8" ) {
        local _Buffer := Buffer( _Length, 0 )

        DllCall( "ReadProcessMemory", "Ptr", this.HWND, "Ptr", _Address, "Ptr", _Buffer, "Ptr", _Length, "Ptr", this.BytesRead )

        return StrGet( _Buffer, _Encoding )
    }

    Write( _Address, _Value, _Type := "UInt", _Length := 4 ) {
        local _Buffer := Buffer( _Length, 0 )

        NumPut( _Type, _Value, _Buffer )

        return DllCall( "WriteProcessMemory", "Ptr", this.HWND, "Ptr", _Address, "Ptr", _Buffer, "Ptr", _Length, "Ptr", this.BytesWrite )
    }

    Write_String( _Address, _Value, _Length := 4, _Encoding := "UTF-8" ) {
        local _Buffer := Buffer( _Length, 0 )

        StrPut( _Value, _Buffer, StrLen( _Value ) + 1, _Encoding )

        return DllCall( "WriteProcessMemory", "Ptr", this.HWND, "Ptr", _Address, "Ptr", _Buffer, "Ptr", _Length, "Ptr", this.BytesWrite )
    }

    Pointer( _Base, _Offsets* ) {
        local index, offset, _Type := "UInt"

        _Base += this.BaseAddress

        if ( _Offsets.Length > 0 && Type( _Offsets.Get( _Offsets.Length ) ) == "String" ) {
            _Type := _Offsets.Pop()
        }

        for index, offset in _Offsets
            _Base := this.Read( _Base ) + offset

        return this.Read( _Base, _Type )
    }

    Trace( _Address, _Offsets* ) {
        return _Offsets.Pop() + this.Pointer( _Address, _Offsets* )
    }
}

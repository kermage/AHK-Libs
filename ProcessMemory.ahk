/*
---------------------------------------------------------------------------
Function:
    Basic Process Memory Class
---------------------------------------------------------------------------
*/

class ProcessMemory {
    __New( _PID, _Privilege = 0x1F0FFF ) {
        this.HWND := DllCall( "OpenProcess", "UInt", _Privilege, "UInt", 0, "UInt", _PID )
    }

    Close() {
        return DllCall( "CloseHandle", "UInt", this.HWND )
    }

    Read( _Address, _Type = "Int", _Length = 4, _Offset = 0 ) {
        _Value := this.Read_Raw( _Address, _Type, _Length, _Offset )

        return NumGet( _Value, 0, _Type )
    }

    Read_Raw( _Address, _Type = "Int", _Length = 4, _Offset = 0 ) {
        VarSetCapacity( _Value, _Length, 0 )
        DllCall( "ReadProcessMemory", "UInt", this.HWND, "UInt", _Address + _Offset, "Str", _Value, "UInt", _Length, "UInt *", 0 )

        return _Value
    }

    Read_String( _Address ) {
        Buffer := ""

        Loop {
            Value := this.Read_Raw( _Address, "Str", 1 )

            if ( ! Value ) {
                break
            }

            Buffer .= Value
            _Address++
        }

        return Buffer
    }

    Write( _Address, _Value, _Type = "Int", _Length = 4, _Offset = 0 ) {
        VarSetCapacity( Value, _Length, 0 )
        NumPut( _Value, Value, 0, _Type )

        return DllCall( "WriteProcessMemory", "UInt", this.HWND, "UInt", _Address + _Offset, "UInt", &Value, "UInt", _Length, "UInt *", 0 )
    }
}

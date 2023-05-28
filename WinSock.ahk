/*
---------------------------------------------------------------------------
Function:
    Basic Windows Socket Class
---------------------------------------------------------------------------
*/

#Include <DataType>

class WinSock {
    static WM_NUMBER := 0x400
    static FD_READ := 1
    static FD_WRITE := 2
    static FD_ACCEPT := 8
    static FD_CLOSE := 32
    static FIONREAD := 0x4004667F

    __New( _Socket ) {
        this.Socket := _Socket
    }

    static Startup( _VersionRequired := 0x0202 ) {
        local Data := DataType( {
            aVersion: "unsigned short",
            bHighVersion: "unsigned short",
            clpVendorInfo: "char",
        } )

        local Result := DllCall( "Ws2_32\WSAStartup", "UShort", _VersionRequired, "Ptr", Data.Buffer )

        if ( Result ) {
            throw Error( "WSAStartup() errored out", -1, Result )
        }
    }

    static Create( _Type := 1, _Protocol := 6, _AddressFamily := 2 ) {
        local Socket := DllCall( "Ws2_32\socket", "Int", _AddressFamily, "Int", _Type, "Int", _Protocol )

        if ( Socket == -1 ) {
            throw Error( "socket() returned invalid descriptor", -1, WinSock.LastError() )
        }

        return WinSock( Socket )
    }

    static LastError() {
        return DllCall( "Ws2_32\WSAGetLastError" )
    }

    static Cleanup(*) {
        if ( DllCall( "Ws2_32\WSACleanup" ) ) {
            throw Error( "Unsuccessful WSACleanup()", -1, WinSock.LastError() )
        }
    }

    __Delete() {
        this.Close()
    }

    GetAddress( _Host, _Port ) {
        local Data := DataType( {
            asin_family: "short",
            bsin_port: "unsigned short",
            csin_addr: "unsigned long",
            csin_zero: "8 char",
        } )

        NumPut( "Short", 2, Data.Buffer, Data.Offset( "asin_family" ) )
        NumPut( "UShort", DllCall( "Ws2_32\htons", "UShort", _Port ), Data.Buffer, Data.Offset( "bsin_port" ) )
        NumPut( "UInt", DllCall( "Ws2_32\inet_addr", "Str", _Host ), Data.Buffer, Data.Offset( "csin_addr" ) )

        return Data
    }

    Listen( _Host, _Port, _Callback ) {
        local Address := this.GetAddress( _Host, _Port )

        if ( DllCall( "Ws2_32\bind", "UInt", this.Socket, "Ptr", Address.Buffer, "UInt", Address.Size() ) ) {
            throw Error( "Unsuccessful socket bind()", -1, WinSock.LastError() )
        }

        if ( DllCall( "Ws2_32\listen", "UInt", this.Socket, "Str", "SOMAXCONN" ) ) {
            throw Error( "Unsuccessful socket listen()", -1, WinSock.LastError() )
        }

        if ( DllCall( "Ws2_32\WSAAsyncSelect", "UInt", this.Socket, "UInt", A_ScriptHwnd, "UInt", WinSock.WM_NUMBER, "Int", WinSock.FD_ACCEPT | WinSock.FD_CLOSE ) ) {
            throw Error( "Unsuccessful WSAAsyncSelect()", -1, WinSock.LastError() )
        }

        this.OnAccept := _Callback

        OnMessage( WinSock.WM_NUMBER, ObjBindMethod( this, "WM_USER" ) )
    }

    WM_USER( wParam, lParam, msg, hwnd ) {
        if ( wParam != this.Socket || msg != WinSock.WM_NUMBER || hwnd != A_ScriptHwnd ) {
            return
        }

        if ( lParam & WinSock.FD_ACCEPT ) {
            local Socket := DllCall( "Ws2_32\accept", "UInt", wParam, "Ptr", 0, "Ptr", 0 )

            if ( Socket == -1 ) {
                throw Error( "accept() returned invalid descriptor", -1, WinSock.LastError() )
            }

            if ( DllCall( "Ws2_32\WSAAsyncSelect", "UInt", Socket, "UInt", hwnd, "UInt", WinSock.WM_NUMBER, "Int", WinSock.FD_READ | WinSock.FD_CLOSE ) ) {
                throw Error( "Unsuccessful WSAAsyncSelect()", -1, WinSock.LastError() )
            }

            this.OnAccept.Call( WinSock( Socket ) )
        }
    }

    Send( _Value, _Encoding := "UTF-8" ) {
        local Data := Buffer( StrPut( _Value, _Encoding ) )
        local Length := StrPut( _Value, Data, _Encoding )
        local Result := DllCall( "Ws2_32\send", "UInt", this.Socket, "Ptr", Data, "Int", Length, "Int", 0 )

        if ( Result == -1 ) {
            throw Error( "Unsuccessful send()", -1, WinSock.LastError() )
        }
    }

	ToRead() {
        local Data := Buffer( 4 )

		if ( DllCall( "Ws2_32\ioctlsocket", "UInt", this.Socket, "Int", WinSock.FIONREAD, "Ptr", Data ) == -1 ) {
            throw Error( "Unsuccessful ioctlsocket()", -1, WinSock.LastError() )
        }

		return NumGet( Data, 0, "Int" )
	}

    Receive( _Length := 0, _Encoding := "UTF-8" ) {
        if ( ! this.ToRead() ) {
            return ""
        }

        if ( ! _Length ) {
            _Length := this.ToRead()
        }

        local Data := Buffer( _Length )
        local Result := DllCall( "Ws2_32\recv", "UInt", this.Socket, "Ptr", Data, "Int", _Length, "Int", 0 )

        if ( Result == -1 ) {
            throw Error( "Unsuccessful recv()", -1, WinSock.LastError() )
        }

        return StrGet( Data, _Length, _Encoding )
    }

    Close() {
        if ( DllCall( "Ws2_32\closesocket", "UInt", this.Socket ) ) {
            throw Error( "Unsuccessful closesocket()", -1, WinSock.LastError() )
        }
    }
}

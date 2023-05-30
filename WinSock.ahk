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
    static Descriptors := Map()


    __New( _Socket, _Callback ) {
        this.Descriptor := _Socket
        this.Callback := _Callback

        WinSock.Descriptors[ _Socket ] := this
    }

    __Delete() {
        if ( WinSock.Descriptors.Has( this.Descriptor ) ) {
            this.Close()
        }
    }


    static __New( _VersionRequired := 0x0202 ) {
        local WSADATA := DataType( {
            aVersion: "unsigned short",
            bHighVersion: "unsigned short",
            clpVendorInfo: "char",
        } )
        local lpWSAData := Buffer( WSADATA.Size )
        local Result := DllCall( "Ws2_32\WSAStartup", "UShort", _VersionRequired, "Ptr", lpWSAData )

        if ( Result ) {
            throw Error( "WSAStartup() errored out", -1, Result )
        }

        if ( NumGet( lpWSAData, WSADATA.Offset( "bVersion" ), "UShort" ) < _VersionRequired ) {

            throw Error( Format( "WinSock version {1} is not available", _VersionRequired ), -1 )
        }

        OnMessage( WinSock.WM_NUMBER, ObjBindMethod( this, "WM_USER" ) )
    }

    static Create( _Callback, _Type := 1, _Protocol := 6, _AddressFamily := 2 ) {
        local Socket := DllCall( "Ws2_32\socket", "Int", _AddressFamily, "Int", _Type, "Int", _Protocol )

        if ( Socket == -1 ) {
            throw Error( "socket() returned invalid descriptor", -1, WinSock.LastError() )
        }

        return WinSock( Socket, _Callback )
    }

    static Notify( _Socket, _Event ) {
        if ( DllCall( "Ws2_32\WSAAsyncSelect", "UInt", _Socket, "UInt", A_ScriptHwnd, "UInt", WinSock.WM_NUMBER, "Int", _Event ) ) {
            throw Error( "Unsuccessful WSAAsyncSelect()", -1, WinSock.LastError() )
        }
    }

    static LastError() {
        return DllCall( "Ws2_32\WSAGetLastError" )
    }


    Handle( _Action, _Host, _Port ) {
        local sockaddr := DataType( {
            a_sa_family: "short",
            b_sa_data: "16 char",
        } )
        local ADDRINFOW := DataType( {
            a_ai_flags: "int",
            b_ai_family: "int",
            c_ai_sockettype: "int",
            d_ai_protocol: "int",
            e_ai_addrlen: A_Is64bitOS ? "__int64" : "unsigned long",
            ; f_ai_canonname: "wchar_t",
            g_ai_addr: sockaddr.Size,
        } )
        local Data := 0
        local Result := DllCall( "Ws2_32\GetAddrInfoW", "WStr", _Host, "WStr", _Port, "Ptr", 0, "Ptr*", &Data )

        if ( Result ) {
            throw Error( "GetAddrInfoW() errored out", -1, Result )
        }

        ADDRINFOW.Ptr := Data

        if ( DllCall( "Ws2_32\" _Action, "UInt", this.Descriptor, "Ptr", NumGet( ADDRINFOW, ADDRINFOW.Offset( "g_ai_addr" ), "UPtr" ), "UInt", NumGet( ADDRINFOW, ADDRINFOW.Offset( "e_ai_addrlen" ), "UPtr" ) ) ) {
            throw Error( Format( "Unsuccessful socket {1}()", _Action ), -1, WinSock.LastError() )
        }

        DllCall( "Ws2_32\FreeAddrInfoW", "Ptr", ADDRINFOW.Ptr )
    }

    Listen( _Host, _Port ) {
        this.Handle( "bind", _Host, _Port )

        if ( DllCall( "Ws2_32\listen", "UInt", this.Descriptor, "Str", "SOMAXCONN" ) ) {
            throw Error( "Unsuccessful socket listen()", -1, WinSock.LastError() )
        }

        WinSock.Notify( this.Descriptor, WinSock.FD_ACCEPT | WinSock.FD_CLOSE )
    }

    Connect( _Host, _Port ) {
        this.Handle( "connect", _Host, _Port )

        WinSock.Notify( this.Descriptor, WinSock.FD_READ | WinSock.FD_CLOSE )
    }

    static WM_USER( wParam, lParam, msg, hwnd ) {
        local _Critical := Critical( "On" )

        if ( ! hwnd || ! WinSock.Descriptors.Has( wParam ) || msg != WinSock.WM_NUMBER ) {
            return
        }

        local Callback := WinSock.Descriptors[ wParam ].Callback

        if ( lParam & WinSock.FD_ACCEPT ) {
            local Socket := DllCall( "Ws2_32\accept", "UInt", wParam, "Ptr", 0, "Ptr", 0 )

            if ( Socket == -1 ) {
                throw Error( "accept() returned invalid descriptor", -1, WinSock.LastError() )
            }

            WinSock.Notify( Socket, WinSock.FD_READ | WinSock.FD_CLOSE )
            WinSock( Socket, Callback )

            wParam := Socket
        }

        Callback.Call( WinSock.Descriptors[ wParam ] )

        Critical( _Critical )
    }

    Send( _Value, _Encoding := "UTF-8" ) {
        local Data := Buffer( StrPut( _Value, _Encoding ) )
        local Length := StrPut( _Value, Data, _Encoding )
        local Result := DllCall( "Ws2_32\send", "UInt", this.Descriptor, "Ptr", Data, "Int", Length, "Int", 0 )

        if ( Result == -1 ) {
            throw Error( "Unsuccessful send()", -1, WinSock.LastError() )
        }
    }

	ToRead() {
        local Data := Buffer( 4 )

		if ( DllCall( "Ws2_32\ioctlsocket", "UInt", this.Descriptor, "Int", WinSock.FIONREAD, "Ptr", Data ) == -1 ) {
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
        local Result := DllCall( "Ws2_32\recv", "UInt", this.Descriptor, "Ptr", Data, "Int", _Length, "Int", 0 )

        if ( Result == -1 ) {
            throw Error( "Unsuccessful recv()", -1, WinSock.LastError() )
        }

        return StrGet( Data, _Length, _Encoding )
    }

    Close() {
        if ( DllCall( "Ws2_32\closesocket", "UInt", this.Descriptor ) ) {
            throw Error( "Unsuccessful closesocket()", -1, WinSock.LastError() )
        }

        WinSock.Descriptors.Delete( this.Descriptor )
    }
}

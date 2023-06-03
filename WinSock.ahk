/*
---------------------------------------------------------------------------
Function:
    Basic Windows Socket Class
---------------------------------------------------------------------------
*/

#Include <DataType>

class WinSock {
    static WM_NUMBER := 0x800
    static FD_READ := 1
    static FD_WRITE := 2
    static FD_ACCEPT := 8
    static FD_CLOSE := 32
    static Descriptors := Map()


    __New( _Socket, _Callback ) {
        this.Descriptor := _Socket
        this.Callback := _Callback

        WinSock.Descriptors[ _Socket ] := ObjPtrAddRef( this )
    }

    __Delete() {
        if ( WinSock.Descriptors.Has( this.Descriptor ) ) {
            this.Close()
        }
    }


    static __New() {
        DllCall( "LoadLibraryW", "WStr", "Ws2_32" )

        local lpWSAData := DataType( {
            aVersion: "unsigned short",
            bHighVersion: "unsigned short",
            clpVendorInfo: "char",
        } )
        local Result := DllCall( "Ws2_32\WSAStartup", "UShort", 0x0202, "Ptr", lpWSAData )

        if ( Result ) {
            throw Error( "WSAStartup() errored out", -1, Result )
        }

        if ( NumGet( lpWSAData.Address( "aVersion" ), "UShort" ) < 0x0202 ) {
            throw Error( "WinSock version 2.2 is not available", -1 )
        }

        WinSock.WM_NUMBER := DllCall( "RegisterWindowMessage", "Str", "WINSOCK_" A_ScriptHwnd, "UInt" )

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
            b_sa_data: "14 char",
        } )
        local ADDRINFOW := DataType( {
            a_ai_flags: "int",
            b_ai_family: "int",
            c_ai_sockettype: "int",
            d_ai_protocol: "int",
            e_ai_addrlen: A_PtrSize,
            f_ai_canonname: A_PtrSize,
            g_ai_addr: sockaddr.Size,
        } )
        local Data := 0
        local Result := DllCall( "Ws2_32\GetAddrInfoW", "WStr", _Host, "WStr", _Port, "Ptr", 0, "Ptr*", &Data )

        if ( Result ) {
            throw Error( "GetAddrInfoW() errored out", -1, Result )
        }

        if ( DllCall( "Ws2_32\" _Action, "UInt", this.Descriptor, "Ptr", NumGet( Data, ADDRINFOW.Offset( "g_ai_addr" ), "UPtr" ), "UInt", NumGet( Data, ADDRINFOW.Offset( "e_ai_addrlen" ), "UPtr" ) ) ) {
            throw Error( Format( "Unsuccessful socket {1}()", _Action ), -1, WinSock.LastError() )
        }

        DllCall( "Ws2_32\FreeAddrInfoW", "Ptr", Data )
    }

    Listen( _Host, _Port ) {
        this.Handle( "bind", _Host, _Port )

        if ( DllCall( "Ws2_32\listen", "UInt", this.Descriptor, "Str", "SOMAXCONN" ) ) {
            throw Error( "Unsuccessful socket listen()", -1, WinSock.LastError() )
        }

        WinSock.Notify( this.Descriptor, WinSock.FD_ACCEPT | WinSock.FD_CLOSE )

        this.Connections := Array()
    }

    Connect( _Host, _Port ) {
        this.Handle( "connect", _Host, _Port )

        WinSock.Notify( this.Descriptor, WinSock.FD_READ | WinSock.FD_CLOSE )
    }


    static WM_USER( wParam, lParam, msg, hwnd ) {
        if ( ! hwnd || ! WinSock.Descriptors.Has( wParam ) || msg != WinSock.WM_NUMBER || hwnd != A_ScriptHwnd ) {
            return
        }

        local Socket := ObjFromPtrAddRef( WinSock.Descriptors[ wParam ] )

        if ( EventName( lParam ) == "Accept" ) {
            local Descriptor := DllCall( "Ws2_32\accept", "UInt", wParam, "Ptr", 0, "Ptr", 0 )

            if ( Descriptor == -1 ) {
                throw Error( "accept() returned invalid descriptor", -1, WinSock.LastError() )
            }

            WinSock.Notify( Descriptor, WinSock.FD_READ | WinSock.FD_WRITE | WinSock.FD_CLOSE )

            Socket.Connections.Push( Descriptor )
            Socket := WinSock( Descriptor, Socket.Callback )
        } else if ( EventName( lParam ) == "Close" ) { ; WSAECONNABORTED
            WinSock.Notify( wParam, 0 )
            Socket.Close()
        }

        SetTimer( () => Socket.Callback.Call( Socket, EventName( lParam ) ), -1 )

        EventName( _Value ) {
            _Value &= 0xFFFF

            static Names := {
                1: "Read",
                2: "Write",
                4: "OOB",
                8: "Accept",
                16: "Connect",
                32: "Close",
                64: "QOS",
                128: "GroupQOS",
                256: "RoutingInterfaceChange",
                512: "AddressListChange",
            }

            return Names.HasProp( _Value ) ? Names.%_Value% : _Value >> 16
        }
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
        local Data := 0

		if ( DllCall( "Ws2_32\ioctlsocket", "UInt", this.Descriptor, "Int", 0x4004667F, "UInt*", &Data ) == -1 ) { ; FIONREAD
            throw Error( "Unsuccessful ioctlsocket()", -1, WinSock.LastError() )
        }

		return Data
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

        if ( this.HasOwnProp( "Connections" ) ) {
            while ( this.Connections.Length ) {
                local Descriptor := this.Connections.Pop()

                if ( ! WinSock.Descriptors.Has( Descriptor ) ) {
                    continue
                }

                local Socket := ObjFromPtrAddRef( WinSock.Descriptors[ Descriptor ] )

                Socket.Close()
            }
        }

        ObjRelease( WinSock.Descriptors[ this.Descriptor ] )
        WinSock.Descriptors.Delete( this.Descriptor )
    }
}

/*
---------------------------------------------------------------------------
Function:
    Basic Web Socket Class
---------------------------------------------------------------------------
*/

#Include <ParseURL>

class WebSock {
    __New( _Callback, _Size := 4096 ) {
        this.Callback := _Callback
        this.Data := Buffer( _Size, 0 )

        this.Session := DllCall( "Winhttp\WinHttpOpen", "Ptr", 0, "UInt", 0, "Ptr", 0, "Ptr", 0, "UInt", 0x10000000 ) ; WINHTTP_FLAG_ASYNC

        if ( ! this.Session ) {
            throw Error( "WinHttpOpen() returned invalid session handle", -1, A_LastError )
        }

        if ( ! DllCall( "Winhttp\WinHttpSetTimeouts", "Ptr", this.Session, "Int", 60, "Int", 30, "Int", 15, "Int", 15 ) ) {
            throw Error( "WinHttpSetTimeouts() errored out", -1, A_LastError )
        }
    }


    Connect( _Url, _Headers := {} ) {
        local ParsedURL := ParseURL( _URL )

        if ( ! ParsedURL.HOST ) {
            throw Error( "Supplied URL is invalid", -1 )
        }

        if ( ! IsObject( _Headers ) || ComObjType( _Headers ) ) {
            throw Error( "Supplied Headers is invalid", -1 )
        }

        if ( ! ParsedURL.PORT ) {
            ParsedURL.PORT := ParsedURL.SCHEME == "wss" ? 443 : 80
        }

        local hConnect := DllCall( "Winhttp\WinHttpConnect", "Ptr", this.Session, "WStr", ParsedURL.HOST, "UInt", ParsedURL.PORT, "UInt", 0 )

        if ( ! hConnect ) {
            throw Error( "WinHttpConnect() returned invalid connection handle", -1, A_LastError )
        }

        local hRequest := DllCall( "Winhttp\WinHttpOpenRequest", "Ptr", hConnect, "WStr", "GET", "WStr", ParsedURL.PATH, "Ptr", 0, "Ptr", 0, "Ptr", 0, "UInt", ParsedURL.PORT == 443 ? 0x800000 : 0 ) ; WINHTTP_FLAG_SECURE

        if ( ! hRequest ) {
            throw Error( "WinHttpOpenRequest() returned invalid request handle", -1, A_LastError )
        }

        local key, value, headers := ""

        for key, value in ( _Headers.HasProp( "__Enum" ) ? _Headers : _Headers.OwnProps() ) {
            headers .= key ": " value "`r`n"
        }

        if ( headers ) {
            if ( ! DllCall( "Winhttp\WinHttpAddRequestHeaders", "Ptr", hRequest, "WStr", headers, "UInt", -1, "UInt", 0x20000000 ) ) { ; WINHTTP_ADDREQ_FLAG_ADD
                throw Error( "WinHttpAddRequestHeaders() errored out", -1, A_LastError )
            }
        }

        if ( ! DllCall( "Winhttp\WinHttpSetOption", "Ptr", hRequest, "UInt", 114, "Ptr", 0, "UInt", 0 ) ) { ; WINHTTP_OPTION_UPGRADE_TO_WEB_SOCKET
            throw Error( "WinHttpSetOption() errored out", -1, A_LastError )
        }

        if ( ! DllCall( "Winhttp\WinHttpSendRequest", "Ptr", hRequest, "Ptr", 0, "UInt", 0, "Ptr", 0, "UInt", 0, "UInt", 0, "UPtr", 0 ) ) {
            throw Error( "WinHttpSendRequest() errored out", -1, A_LastError )
        }

        if ( ! DllCall( "Winhttp\WinHttpReceiveResponse", "Ptr", hRequest, "Ptr", 0 ) ) {
            throw Error( "WinHttpReceiveResponse() errored out", -1, A_LastError )
        }

        local status := Buffer( 8 )

        if ( ! DllCall( "Winhttp\WinHttpQueryHeaders", "Ptr", hRequest, "UInt", 19, "Ptr", 0, "Ptr", status, "UInt*", status.Size, "Ptr", 0 ) ) { ; WINHTTP_QUERY_STATUS_CODE
            throw Error( "WinHttpQueryHeaders() errored out", -1, A_LastError )
        }

        status := StrGet( status, "UTF-16" )

        if ( status != "101" ) {
            throw Error( "Invalid status code: " status, -1 )
        }

        local hSocket := DllCall( "Winhttp\WinHttpWebSocketCompleteUpgrade", "Ptr", hRequest, "Ptr", 0 )

        if ( ! hSocket ) {
            throw Error( "WinHttpWebSocketCompleteUpgrade() errored out", -1, A_LastError )
        }

        WebSock.Close( hRequest )
        WebSock.Close( hConnect )
        WebSock.Close( this.Session )

        this.Handle := hSocket
        local dwOption := Buffer( A_PtrSize )

        NumPut( "UPtr", ObjPtrAddRef( this ), dwOption )

        if ( ! DllCall( "Winhttp\WinHttpSetOption", "Ptr", hSocket, "UInt", 45, "Ptr", dwOption, "UInt", dwOption.Size ) ) { ; WINHTTP_OPTION_CONTEXT_VALUE
            throw Error( "WinHttpSetOption() errored out", -1, A_LastError )
        }

        local callback := CallbackCreate( this.Async, "", 5 )

		if ( DllCall( "Winhttp\WinHttpSetStatusCallback", "Ptr", hSocket, "Ptr", callback, "UInt", 0x00080000, "Ptr", 0 ) == -1 ) { ; WINHTTP_CALLBACK_STATUS_READ_COMPLETE
            throw Error( "WinHttpSetStatusCallback() errored out", -1, A_LastError )
        }

        this.Event( "Open" )
        SetTimer( () => DllCall( "Winhttp\WinHttpWebSocketReceive", "Ptr", this.Handle, "Ptr", this.Data, "UInt", this.Data.Size, "Ptr", 0, "Ptr", 0 ), -1 )
    }

    __Delete() {
        this.Close()
    }


    Send( _Value ) {
        local Data := Buffer( StrPut( _Value, "UTF-8" ), 0 )
        local Length := StrPut( _Value, Data, "UTF-8" )

        local Result := DllCall( "Winhttp\WinHttpWebSocketSend", "Ptr", this.Handle, "UInt", 2, "Ptr", Data, "UInt", Length ) ; WINHTTP_WEB_SOCKET_UTF8_MESSAGE_BUFFER_TYPE

        if ( Result && Result != 4317 ) { ; ERROR_INVALID_OPERATION
            this.Event( "Error", Result )
        }
    }

    Close() {
        DllCall( "Winhttp\WinHttpWebSocketShutdown", "Ptr", this.Handle, "UShort", 1000, "Ptr", 0, "UInt", 0 )
        DllCall( "Winhttp\WinHttpWebSocketClose", "Ptr", this.Handle, "UShort", 1000, "Ptr", 0, "UInt", 0 )
        WebSock.Close( this.Handle )
    }


    static Close( _Socket ) {
        if ( ! DllCall( "Winhttp\WinHttpCloseHandle", "Ptr", _Socket ) ) {
            throw Error( "Unsuccessful close()", -1, A_LastError )
        }
    }


    Async( hSession, nFlag, sInfo, infoLen ) {
        if ( nFlag != 524288 ) { ; WINHTTP_CALLBACK_STATUS_READ_COMPLETE
            return
        }

        local Socket := ObjFromPtrAddRef( hSession )
        local BytesRead := NumGet( sInfo, 0, "UInt" )
        local BufferType := NumGet( sInfo, 4, "UInt" )

        if ( BufferType == 4 ) { ; WINHTTP_WEB_SOCKET_CLOSE_BUFFER_TYPE
            local Reason := Buffer( 123 ) ; WINHTTP_WEB_SOCKET_MAX_CLOSE_REASON_LENGTH
            local Status := 0
            local Length := 0

            DllCall( "Winhttp\WinHttpWebSocketQueryCloseStatus", "Ptr", Socket.Handle, "UShort*", &Status, "Ptr", Reason, "UInt", Reason.Size, "UInt*", &Length )

            Socket.Event( "Close", {
                code: Status,
                reason: StrGet( Reason, Length, "UTF-8" ),
            } )
        } else  {
            Socket.Event( "Message", StrGet( Socket.Data, BytesRead, "UTF-8" ) )
            SetTimer( () => DllCall( "Winhttp\WinHttpWebSocketReceive", "Ptr", Socket.Handle, "Ptr", Socket.Data, "UInt", Socket.Data.Size, "Ptr", 0, "Ptr", 0 ), -1 )
        }
    }

    Event( _Type, _Data := "" ) {
        static UnixStart := 116444736000000000
        local FileTime := 0

        DllCall( "GetSystemTimeAsFileTime", "Int64P", &FileTime )
        SetTimer( () => this.Callback.Call( this, {
            type: _Type,
            data: _Data,
            timestamp: ( FileTime - UnixStart ) // 10000000,
        } ), -1 )
    }
}

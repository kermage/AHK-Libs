/*
---------------------------------------------------------------------------
Function:
    Basic Web Socket Class
---------------------------------------------------------------------------
*/

#Include <ParseURL>

class WebSock {
    __New( _URL ) {
        local ParsedURL := ParseURL( _URL )

        if ( ! ParsedURL.HOST ) {
            throw Error( "Supplied URL is invalid", -1 )
        }

        if ( ! ParsedURL.PORT ) {
            ParsedURL.PORT := ParsedURL.SCHEME == "wss" ? 443 : 80
        }

        this.Session := DllCall( "Winhttp\WinHttpOpen", "Ptr", 0, "UInt", 0, "Ptr", 0, "Ptr", 0, "UInt", 0 )

        if ( ! this.Session ) {
            throw Error( "WinHttpOpen() returned invalid session handle", -1, A_LastError )
        }

        local hConnect := DllCall( "Winhttp\WinHttpConnect", "Ptr", this.Session, "WStr", ParsedURL.HOST, "UInt", ParsedURL.PORT, "UInt", 0 )

        if ( ! hConnect ) {
            throw Error( "WinHttpConnect() returned invalid connection handle", -1, A_LastError )
        }

        local hRequest := DllCall( "Winhttp\WinHttpOpenRequest", "Ptr", hConnect, "WStr", "GET", "WStr", ParsedURL.PATH, "Ptr", 0, "Ptr", 0, "Ptr", 0, "UInt", ParsedURL.PORT == 443 ? 0x800000 : 0 ) ; WINHTTP_FLAG_SECURE

        if ( ! hRequest ) {
            throw Error( "WinHttpOpenRequest() returned invalid request handle", -1, A_LastError )
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

        this.Socket := hSocket
    }

    __Delete() {
        this.Close()
    }


    Send( _Value ) {
        local Data := Buffer( StrPut( _Value, "UTF-8" ), 0 )
        local Length := StrPut( _Value, Data, "UTF-8" )

        if ( DllCall( "Winhttp\WinHttpWebSocketSend", "Ptr", this.Socket, "UInt", 2, "Ptr", Data, "UInt", Length ) ) { ; WINHTTP_WEB_SOCKET_UTF8_MESSAGE_BUFFER_TYPE
            throw Error( "Unsuccessful send()", -1, A_LastError )
        }
    }

    Receive( _Length := 4096 ) {
        local Data := Buffer( _Length, 0 )
        local bytesRead := 0
        local bufferType := 0
        local Result := DllCall( "Winhttp\WinHttpWebSocketReceive", "Ptr", this.Socket, "Ptr", Data, "UInt", _Length, "UInt*", &bytesRead, "UInt*", &bufferType )

        if ( Result ) {
            throw Error( "Unsuccessful receive()", -1, A_LastError )
        }

        return StrGet( Data, bytesRead, "UTF-8" )
    }

    Close() {
        WebSock.Close( this.Socket )
    }


    static Close( _Socket ) {
        if ( ! DllCall( "Winhttp\WinHttpCloseHandle", "Ptr", _Socket ) ) {
            throw Error( "Unsuccessful close()", -1, A_LastError )
        }
    }
}

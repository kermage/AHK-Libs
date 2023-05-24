/*
---------------------------------------------------------------------------
Function:
    Basic Script Control Class
---------------------------------------------------------------------------
*/

class ScriptControl {
    __New( _PID ) {
        local _DetectHiddenWindows := DetectHiddenWindows( true )

        this.PID := _PID
        this.cPID := WinGetPID( "ahk_id " A_ScriptHwnd )
        this.gotValue := ""

        DetectHiddenWindows( _DetectHiddenWindows )
        OnMessage( 0x004A, ObjBindMethod( this, "Receive" ) )
    }

	call( _Name, _Params* ) {
        this.Send( this.Compose( "call", _Name, this.cPID, _Params* ), this.PID )

        return this.gotValue
    }

	get( _Name ) {
        this.Send( this.Compose( "get", _Name, this.cPID ), this.PID )

        return this.gotValue
    }

	set( _Name, _Value ) {
        return this.Send( this.Compose( "set", _Name, _Value ), this.PID )
    }

    Compose( _Params* ) {
        local index, param
        local Message := ""

        for index, param in _Params
            Message .= StrReplace( param, ";", ";;" ) " `;#; "

        return SubStr( Message, 1, -5 )
    }

    Send( _String, _PID ) {
        local SizeBytes := ( StrLen( _String ) + 1 ) * 2
        local CopyDataStruct := Buffer( 3 * A_PtrSize + SizeBytes, 0 )

        NumPut( "UPtr", SizeBytes, CopyDataStruct, A_PtrSize )
        NumPut( "UPtr", StrPtr( _String ), CopyDataStruct, 2 * A_PtrSize )

        return SendMessage( 0x004A, 0, CopyDataStruct,, "ahk_pid " _PID,,,, 0 )
    }

    Receive( wParam, lParam, msg, hwnd ) {
        global
        local Params, index, param, Action, value

        Params := StrSplit( StrGet( NumGet( lParam, 2 * A_PtrSize, "UPtr" ) ), " `;#; " )

        for index, param in Params
            Params[ index ] := StrReplace( param, ";;", ";" )

        Action := Params.RemoveAt( 1 )

        if ( "call" == Action && Type( %Params[1]% ) == "Func" ) {
            Action := Params.RemoveAt( 1 )
            index := Params.RemoveAt( 1 )
            value := %Action%.Call( Params* )

            this.Send( this.Compose( "callback", value ), index )
        } else if ( "get" == Action ) {
            value := Params[1]

            this.Send( this.Compose( "callback", %value% ), Params[2] )
        } else if ( "callback" == Action ) {
            this.gotValue := Params[1]
        } else if ( "set" == Action ) {
            value := Params[1]
            %value% := Params[2]
        }
    }
}

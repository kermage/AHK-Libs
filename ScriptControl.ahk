/*
---------------------------------------------------------------------------
Function:
    Basic Script Control Class
---------------------------------------------------------------------------
*/

class ScriptControl {
    __New( _PID ) {
        this.PID := _PID
        _DetectHiddenWindows := A_DetectHiddenWindows

        OnMessage( 0x004A, ObjBindMethod( this, "Receive" ) )
        DetectHiddenWindows, On
        WinGet, cPID, PID, % "ahk_id " A_ScriptHwnd
        DetectHiddenWindows, % _DetectHiddenWindows

        this.cPID := cPID
    }

	run( _Name ) {
        return this.Send( this.Compose( "run", _Name ), this.PID )
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
        Message := ""

        for index, param in _Params
            Message .= StrReplace( param, ";", ";;" ) " `;#; "

        return SubStr( Message, 1, -5 )
    }

    Send( _String, _PID ) {
        SizeBytes := ( StrLen( _String ) + 1 ) * ( A_IsUnicode ? 2 : 1 )

        VarSetCapacity( CopyDataStruct, 3 * A_PtrSize + SizeBytes, 0 )
        NumPut( SizeBytes, CopyDataStruct, A_PtrSize )
        NumPut( &_String, CopyDataStruct, 2 * A_PtrSize )

        SendMessage, 0x004A, 0, &CopyDataStruct,, % "ahk_pid " _PID,,,, 0

        return ErrorLevel
    }

    Receive( wParam, lParam ) {
        Local Params, index, param, Action, value

        Params := StrSplit( StrGet( NumGet( lParam + 2 * A_PtrSize ) ), " `;#; " )

        for index, param in Params
            Params[ index ] := StrReplace( param, ";;", ";" )

        Action := Params.RemoveAt( 1 )

        if ( "run" == Action && IsLabel( Params[1] ) ) {
            Gosub, % Params[1]
        } else if ( "call" == Action && IsFunc( Params[1] ) ) {
            Action := Params.RemoveAt( 1 )
            index := Params.RemoveAt( 1 )
            value := Func( Action ).Call( Params* )

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

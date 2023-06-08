/*
---------------------------------------------------------------------------
Function:
    Basic Script Control Class
---------------------------------------------------------------------------
*/

class ScriptControl {
    static Handles := Map()

    __New( _PID ) {
        this.PID := _PID
        this.cPID := WinGetPID( "ahk_id " A_ScriptHwnd )
        ScriptControl.Handles[ A_ScriptHwnd ] := ""
    }


	call( _Name, _Params* ) {
        ScriptControl.Send( ScriptControl.Compose( "call", _Name, this.cPID, _Params* ), this.PID )

        return ScriptControl.Handles[ A_ScriptHwnd ]
    }

	get( _Name ) {
        ScriptControl.Send( ScriptControl.Compose( "get", _Name, this.cPID ), this.PID )

        return ScriptControl.Handles[ A_ScriptHwnd ]
    }

	set( _Name, _Value ) {
        return ScriptControl.Send( ScriptControl.Compose( "set", _Name, _Value ), this.PID )
    }


    static Compose( _Params* ) {
        local index, param
        local Message := ""

        for index, param in _Params
            Message .= StrReplace( param, ";", ";;" ) " `;#; "

        return SubStr( Message, 1, -5 )
    }

    static Send( _String, _PID ) {
        if ( ! ProcessExist( _PID ) ) {
            return 0
        }

        local SizeBytes := ( StrLen( _String ) + 1 ) * 2
        local CopyDataStruct := Buffer( 3 * A_PtrSize + SizeBytes, 0 )

        NumPut( "UPtr", SizeBytes, CopyDataStruct, A_PtrSize )
        NumPut( "UPtr", StrPtr( _String ), CopyDataStruct, 2 * A_PtrSize )

        local _DetectHiddenWindows := DetectHiddenWindows( true )
        local Result := SendMessage( 0x004A, 0, CopyDataStruct,, "ahk_pid " _PID,,,, 0 )

        DetectHiddenWindows( _DetectHiddenWindows )

        return Result
    }

    static Receive( wParam, lParam, msg, hwnd ) {
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

            ScriptControl.Send( ScriptControl.Compose( "callback", value ), index )
        } else if ( "get" == Action ) {
            value := Params[1]

            ScriptControl.Send( ScriptControl.Compose( "callback", %value% ), Params[2] )
        } else if ( "callback" == Action ) {
            ScriptControl.Handles[ A_ScriptHwnd ] := Params[1]
        } else if ( "set" == Action ) {
            value := Params[1]
            %value% := Params[2]
        }
    }

    static __New() {
        OnMessage( 0x004A, ObjBindMethod( this, "Receive" ) )
    }
}

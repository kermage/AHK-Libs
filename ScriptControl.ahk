/*
---------------------------------------------------------------------------
Function:
    Basic Script Control Class
---------------------------------------------------------------------------
*/

class ScriptControl {
    __New( _HWND ) {
        this.HWND := _HWND

        OnMessage( 0x004A, ObjBindMethod( this, "Receive" ) )
    }

	run( _Name ) {
        return this.Send( "run", _Name )
    }

	get( _Name ) {
        this.Send( "get", _Name )

        return this.gotValue
    }

	set( _Name, _Value ) {
        return this.Send( "set", _Name, _Value )
    }

    Send( _Params* ) {
        StringParams := ""

        for index, param in _Params
            StringParams .= StrReplace( param, ";", ";;" ) " `;#; "

        StringParams := SubStr( StringParams, 1, -5 )
        SizeBytes := ( StrLen( StringParams ) + 1 ) * ( A_IsUnicode ? 2 : 1 )

        VarSetCapacity( CopyDataStruct, 3 * A_PtrSize + SizeBytes, 0 )
        NumPut( SizeBytes, CopyDataStruct, A_PtrSize )
        NumPut( &StringParams, CopyDataStruct, 2 * A_PtrSize )

        SendMessage, 0x004A, 0, &CopyDataStruct,, % "ahk_id " this.HWND,,,, 0

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
        } else if ( "get" == Action ) {
            value := Params[1]

            this.Send( "callback", %value% )
        } else if ( "callback" == Action ) {
            this.gotValue := Params[1]
        } else if ( "set" == Action ) {
            value := Params[1]
            %value% := Params[2]
        }
    }
}

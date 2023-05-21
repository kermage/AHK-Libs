/*
---------------------------------------------------------------------------
Function:
    Basic class for testings
---------------------------------------------------------------------------
*/

#Include <Expect>

class Test {
    __New( _Name, _Expectations* ) {
        TestGui := Gui( "", _Name )
        Headers := [ "Have", "Comparator", "Want", "Status", "Message" ]
        LV := TestGui.AddListView( "NoSortHdr -Redraw R" _Expectations.Length, Headers )

        for item in _Expectations {
            try {
                item( Test.Expect( LV, A_Index ) )
                LV.Modify( A_Index, "Col4", "OK" )
            } catch Error as e {
                LV.Modify( A_Index, "Col4", "Failed", e.Message )
            }
        }

        LV.GetPos( &x, &y, &w, &h )

        w := x / 2

        Loop Headers.Length {
            LV.ModifyCol( A_Index, "AutoHDR" )

            w += SendMessage( 0x101D, A_Index - 1, 0, LV )
        }

        LV.Move( x, y, w, h )
        LV.Opt( "+Redraw" )
        TestGui.Show( "AutoSize" )
    }

    class Expect {
        __New( _Test, _Index ) {
            this.Test := _Test
            this.Index := _Index
        }

        Call( _Value, _ID := "" ) {
            this.Value := _Value
            this.Test.Add( "", _ID ? _ID : _Value )

            return this
        }

        __Call( _Method, _Params ) {
            this.Test.Modify( this.Index, "Col2", _Method, _Params.Length ? _Params[ 1 ] : "" )

            return ObjBindMethod( Expect( this.Value ), _Method, _Params* )()
        }
    }
}

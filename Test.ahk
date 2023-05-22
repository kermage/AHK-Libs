/*
---------------------------------------------------------------------------
Function:
    Basic class for testings
---------------------------------------------------------------------------
*/

#Include <Expect>
#Include <Printable>

class Test {
    __New( _Name, _Expectations* ) {
        TestGui := Gui( "", _Name )
        Headers := [ "Have", "Comparator", "Want", "Status" ]
        LV := TestGui.AddListView( "NoSortHdr -Redraw", Headers )

        LV.Messages := Map( "Name", _Name )

        for item in _Expectations {
            item( Test.Expect( LV ) )
        }

        LV.OnEvent( "ItemSelect", ObjBindMethod( Test.Expect, "ItemSelected" ) )
        LV.GetPos( &x, &y, &w, &h )

        w := x / 2
        h := LV.GetCount() * 20

        Loop Headers.Length {
            LV.ModifyCol( A_Index, "AutoHDR" )

            w += SendMessage( 0x101D, A_Index - 1, 0, LV )
        }

        LV.Move( x, y, w, h )
        LV.Opt( "+Redraw" )
        TestGui.Show( "AutoSize" )
    }

    class Expect {
        __New( _Test ) {
            this.Test := _Test
        }

        Call( _Value, _ID := "" ) {
            this.Value := _Value
            this.ID := _ID

            return this
        }

        __Call( _Method, _Params ) {
            this.Test.Add(
                "",
                Printable( this.ID ? this.ID : this.Value ).Normal(),
                _Method,
                _Params.Length ? Printable( _Params[ 1 ] ).Normal() : ""
            )

            _Index := this.Test.GetCount()

            try {
                ObjBindMethod( Expect( this.Value ), _Method, _Params* )()
                this.Test.Modify( _Index, "Col4", "OK" )
            } catch Error as e {
                this.Test.Modify( _Index, "Col4", "Failed" )
                this.Test.Messages[ _Index ] := e.Message
            }

            return this
        }

        static ItemSelected( GuiCtrlObj, Item, Selected ) {
            if ( Selected && GuiCtrlObj.Messages.Has( Item ) ) {
                MsgBox( GuiCtrlObj.Messages[ Item ], GuiCtrlObj.Messages["Name"] ": Expectation #" Item, "IconX" )
            }
        }
    }
}

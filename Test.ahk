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
        h := ( LV.GetCount() + 4 ) * 16

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
            _Have := Printable( this.ID ? this.ID : this.Value ).Normal()
            _Want := _Params.Length ? Printable( _Params[ 1 ] ).Normal() : ""
            _Index := this.Test.GetCount() + 1

            this.Test.Add( "", _Have, _Method, _Want )

            try {
                ObjBindMethod( Expect( this.Value ), _Method, _Params* )()
                this.Test.Modify( _Index, "Col4", "OK" )
            } catch Error as e {
                this.Test.Modify( _Index, "Col4", "FAILED" )

                if ( InStr( e.Message, "Expected", true ) == 1 ) {
                    this.Test.Messages[ _Index ] := Format( "{1} {2} {3}", Printable( _Have ).Bold(), Expect.ToWords( _Method ), Printable( _Want ).Bold() )
                } else {
                    this.Test.Messages[ _Index ] := StrReplace( e.Message, _Method, Printable( _Method ).Bold() )
                }
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

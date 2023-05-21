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
        LV := TestGui.AddListView( "NoSortHdr", ["Have", "Comparator", "Want", "Status"])

        for item in _Expectations {
            try {
                item( Test.Expect( LV, A_Index ) )
                LV.Modify( A_Index, "Col4", "OK" )
            } catch Error as e {
                LV.Modify( A_Index, "Col4", "Failed" )
            }
        }

        TestGui.Show()
    }

    class Expect {
        __New( _Test, _Index ) {
            this.Test := _Test
            this.Index := _Index
        }

        Call( _Value ) {
            this.Value := _Value
            this.Test.Add( "", _Value )

            return this
        }

        __Call( _Method, _Params ) {
            this.Test.Modify( this.Index, "Col2", _Method, _Params.Length ? _Params[ 1 ] : "" )

            return ObjBindMethod( Expect( this.Value ), _Method, _Params* )()
        }
    }
}

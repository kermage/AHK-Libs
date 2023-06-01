#Requires AutoHotkey v2.0
#Warn All

#Include <BuildQuery>
#Include <Test>

TestValue1 := "p%s/n#q?a*e!&s p+q=e"
TestValue2 := "percent%slash/number#question?asterisk*exclamate!space plus+end"
TestValue3 := Map( TestValue1, TestValue2 )
TestValue4 := Array( TestValue1, TestValue2 )

Test( "BuildQuery",
    ( expect ) => expect( BuildQuery( "" ) ).ToBe( "" ),
    ( expect ) => expect( BuildQuery( " " ) ).ToBe( "%20" ),
    ( expect ) => expect( BuildQuery( "&" ) ).ToBe( "%26" ),
    ( expect ) => expect( BuildQuery( "=" ) ).ToBe( "%3D" ),
    ( expect ) => expect( BuildQuery( TestValue1 ) ).ToBe( "p%25s%2Fn%23q%3Fa*e!%26s%20p%2Bq%3De" ),
    ( expect ) => expect( BuildQuery( TestValue2 ) ).ToBe( "percent%25slash%2Fnumber%23question%3Fasterisk*exclamate!space%20plus%2Bend" ),
    ( expect ) => expect( BuildQuery( TestValue3 ) ).ToBe( "p%25s%2Fn%23q%3Fa*e!%26s%20p%2Bq%3De=percent%25slash%2Fnumber%23question%3Fasterisk*exclamate!space%20plus%2Bend" ),
    ( expect ) => expect( BuildQuery( TestValue4 ) ).ToBe( "0=p%25s%2Fn%23q%3Fa*e!%26s%20p%2Bq%3De&1=percent%25slash%2Fnumber%23question%3Fasterisk*exclamate!space%20plus%2Bend" ),
    ( expect ) => expect( BuildQuery( ComObject( "HTMLFile" ) ), "ComObject(HTMLFile)" ).ToBe( "" ),
)

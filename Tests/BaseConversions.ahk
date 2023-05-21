#Requires AutoHotkey v2.0
#Warn All

#Include <BaseConversions>
#Include <Test>

Test( "Dec2Base 16",
    ( expect ) => expect( Dec2Base( 0 ), 0 ).ToBe( "0" ),
    ( expect ) => expect( Dec2Base( 1 ), 1 ).ToBe( "1" ),
    ( expect ) => expect( Dec2Base( 9 ), 9 ).ToBe( "9" ),
    ( expect ) => expect( Dec2Base( 10 ), 10 ).ToBe( "A" ),
    ( expect ) => expect( Dec2Base( 15 ), 15 ).ToBe( "F" ),
    ( expect ) => expect( Dec2Base( 255 ), 255 ).ToBe( "FF" ),
)

Test( "16 Base2Dec",
    ( expect ) => expect( Base2Dec( "0" ), "0" ).ToBe( 0 ),
    ( expect ) => expect( Base2Dec( "1" ), "1" ).ToBe( 1 ),
    ( expect ) => expect( Base2Dec( "9" ), "9" ).ToBe( 9 ),
    ( expect ) => expect( Base2Dec( "A" ), "A" ).ToBe( 10 ),
    ( expect ) => expect( Base2Dec( "F" ), "F" ).ToBe( 15 ),
    ( expect ) => expect( Base2Dec( "FF" ), "FF" ).ToBe( 255 ),
)

Test( "Dec2Base 8",
    ( expect ) => expect( Dec2Base( 1, 8 ), 1 ).ToBe( "1" ),
    ( expect ) => expect( Dec2Base( 7, 8 ), 7 ).ToBe( "7" ),
    ( expect ) => expect( Dec2Base( 8, 8 ), 8 ).ToBe( "10" ),
    ( expect ) => expect( Dec2Base( 15, 8 ), 15 ).ToBe( "17" ),
    ( expect ) => expect( Dec2Base( 975, 8 ), 975 ).ToBe( "1717" ),
)

Test( "8 Base2Dec",
    ( expect ) => expect( Base2Dec( 1, 8 ), 1 ).ToBe( 1 ),
    ( expect ) => expect( Base2Dec( 7, 8 ), 7 ).ToBe( 7 ),
    ( expect ) => expect( Base2Dec( 10, 8 ), 10 ).ToBe( 8 ),
    ( expect ) => expect( Base2Dec( 17, 8 ), 17 ).ToBe( 15 ),
    ( expect ) => expect( Base2Dec( 1717, 8 ), 1717 ).ToBe( 975 ),
)

Test( "Dec2Base 2",
    ( expect ) => expect( Dec2Base( 1, 2 ), 1 ).ToBe( "1" ),
    ( expect ) => expect( Dec2Base( 2, 2 ), 2 ).ToBe( "10" ),
    ( expect ) => expect( Dec2Base( 3, 2 ), 3 ).ToBe( "11" ),
    ( expect ) => expect( Dec2Base( 4, 2 ), 4 ).ToBe( "100" ),
    ( expect ) => expect( Dec2Base( 5, 2 ), 5 ).ToBe( "101" ),
    ( expect ) => expect( Dec2Base( 8, 2 ), 8 ).ToBe( "1000" ),
    ( expect ) => expect( Dec2Base( 9, 2 ), 9 ).ToBe( "1001" ),
)

Test( "2 Base2Dec",
    ( expect ) => expect( Base2Dec( "1", 2 ), "1" ).ToBe( 1 ),
    ( expect ) => expect( Base2Dec( "10", 2 ), "10" ).ToBe( 2 ),
    ( expect ) => expect( Base2Dec( "11", 2 ), "11" ).ToBe( 3 ),
    ( expect ) => expect( Base2Dec( "100", 2 ), "100" ).ToBe( 4 ),
    ( expect ) => expect( Base2Dec( "101", 2 ), "101" ).ToBe( 5 ),
    ( expect ) => expect( Base2Dec( "1000", 2 ), "1000" ).ToBe( 8 ),
    ( expect ) => expect( Base2Dec( "1001", 2 ), "1001" ).ToBe( 9 ),
)

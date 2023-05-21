#Requires AutoHotkey v2.0
#Warn All

#Include <BaseConversions>
#Include <Test>

Test( "DecToBase 16",
    ( expect ) => expect( DecToBase( 0 ), 0 ).ToBe( "0" ),
    ( expect ) => expect( DecToBase( 1 ), 1 ).ToBe( "1" ),
    ( expect ) => expect( DecToBase( 9 ), 9 ).ToBe( "9" ),
    ( expect ) => expect( DecToBase( 10 ), 10 ).ToBe( "A" ),
    ( expect ) => expect( DecToBase( 15 ), 15 ).ToBe( "F" ),
    ( expect ) => expect( DecToBase( 255 ), 255 ).ToBe( "FF" ),
)

Test( "16 BaseToDec",
    ( expect ) => expect( BaseToDec( "0" ), "0" ).ToBe( 0 ),
    ( expect ) => expect( BaseToDec( "1" ), "1" ).ToBe( 1 ),
    ( expect ) => expect( BaseToDec( "9" ), "9" ).ToBe( 9 ),
    ( expect ) => expect( BaseToDec( "A" ), "A" ).ToBe( 10 ),
    ( expect ) => expect( BaseToDec( "F" ), "F" ).ToBe( 15 ),
    ( expect ) => expect( BaseToDec( "FF" ), "FF" ).ToBe( 255 ),
)

Test( "DecToBase 8",
    ( expect ) => expect( DecToBase( 1, 8 ), 1 ).ToBe( "1" ),
    ( expect ) => expect( DecToBase( 7, 8 ), 7 ).ToBe( "7" ),
    ( expect ) => expect( DecToBase( 8, 8 ), 8 ).ToBe( "10" ),
    ( expect ) => expect( DecToBase( 15, 8 ), 15 ).ToBe( "17" ),
    ( expect ) => expect( DecToBase( 975, 8 ), 975 ).ToBe( "1717" ),
)

Test( "8 BaseToDec",
    ( expect ) => expect( BaseToDec( 1, 8 ), 1 ).ToBe( 1 ),
    ( expect ) => expect( BaseToDec( 7, 8 ), 7 ).ToBe( 7 ),
    ( expect ) => expect( BaseToDec( 10, 8 ), 10 ).ToBe( 8 ),
    ( expect ) => expect( BaseToDec( 17, 8 ), 17 ).ToBe( 15 ),
    ( expect ) => expect( BaseToDec( 1717, 8 ), 1717 ).ToBe( 975 ),
)

Test( "DecToBase 2",
    ( expect ) => expect( DecToBase( 1, 2 ), 1 ).ToBe( "1" ),
    ( expect ) => expect( DecToBase( 2, 2 ), 2 ).ToBe( "10" ),
    ( expect ) => expect( DecToBase( 3, 2 ), 3 ).ToBe( "11" ),
    ( expect ) => expect( DecToBase( 4, 2 ), 4 ).ToBe( "100" ),
    ( expect ) => expect( DecToBase( 5, 2 ), 5 ).ToBe( "101" ),
    ( expect ) => expect( DecToBase( 8, 2 ), 8 ).ToBe( "1000" ),
    ( expect ) => expect( DecToBase( 9, 2 ), 9 ).ToBe( "1001" ),
)

Test( "2 BaseToDec",
    ( expect ) => expect( BaseToDec( "1", 2 ), "1" ).ToBe( 1 ),
    ( expect ) => expect( BaseToDec( "10", 2 ), "10" ).ToBe( 2 ),
    ( expect ) => expect( BaseToDec( "11", 2 ), "11" ).ToBe( 3 ),
    ( expect ) => expect( BaseToDec( "100", 2 ), "100" ).ToBe( 4 ),
    ( expect ) => expect( BaseToDec( "101", 2 ), "101" ).ToBe( 5 ),
    ( expect ) => expect( BaseToDec( "1000", 2 ), "1000" ).ToBe( 8 ),
    ( expect ) => expect( BaseToDec( "1001", 2 ), "1001" ).ToBe( 9 ),
)

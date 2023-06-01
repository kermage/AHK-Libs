#Requires AutoHotkey v2.0
#Warn All

#Include <Test>

ObjectValue := { foo: "bar", baz: "qux" }
ArrayValue := [ "spam", "ham" ]
MapValue := Map( "top", 3, "bottom", 2 )

Test( "Comparable",
    ( expect ) => expect( ObjectValue ).ToBeObject(),
    ( expect ) => expect( ObjectValue ).ToBeAssociative(),
    ( expect ) => expect( ObjectValue ).ToHave( "foo" ),
    ( expect ) => expect( ObjectValue ).ToContain( "bar" ),
    ( expect ) => expect( ObjectValue ).ToHave( "baz" ),
    ( expect ) => expect( ObjectValue ).ToContain( "qux" ),
    ( expect ) => expect( ObjectValue ).ToBe( { foo: "bar", baz: "qux" } ),
    ( expect ) => expect( ObjectValue ).ToEqual( { foo: "bar", baz: "qux" } ),
    ( expect ) => expect( ObjectValue ).ToContainEqual( { foo: "bar" } ),
    ( expect ) => expect( ObjectValue ).ToContainEqual( { baz: "qux" } ),
    ( expect ) => expect( ArrayValue ).ToBeArray(),
    ( expect ) => expect( ArrayValue ).ToBeEnumerable(),
    ( expect ) => expect( ArrayValue ).ToHave( 1 ),
    ( expect ) => expect( ArrayValue ).ToContain( "spam" ),
    ( expect ) => expect( ArrayValue ).ToHave( 2 ),
    ( expect ) => expect( ArrayValue ).ToContain( "ham" ),
    ( expect ) => expect( ArrayValue ).ToBe( [ "spam", "ham" ] ),
    ( expect ) => expect( ArrayValue ).ToEqual( [ "spam", "ham" ] ),
    ( expect ) => expect( ArrayValue ).ToContainEqual( [ "spam" ] ),
    ( expect ) => expect( ArrayValue ).ToContainEqual( [ "ham" ] ),
    ( expect ) => expect( MapValue ).ToBeMap(),
    ( expect ) => expect( MapValue ).ToBeAssociative(),
    ( expect ) => expect( MapValue ).ToBeEnumerable(),
    ( expect ) => expect( MapValue ).ToHave( "top" ),
    ( expect ) => expect( MapValue ).ToContain( 3 ),
    ( expect ) => expect( MapValue ).ToHave( "bottom" ),
    ( expect ) => expect( MapValue ).ToContain( 2 ),
    ( expect ) => expect( MapValue ).ToBe( Map( "top", 3, "bottom", 2 ) ),
    ( expect ) => expect( MapValue ).ToEqual( Map( "top", 3, "bottom", 2 ) ),
    ( expect ) => expect( MapValue ).ToContainEqual( Map( "top", 3 ) ),
    ( expect ) => expect( MapValue ).ToContainEqual( Map( "bottom", 2 ) ),
    ( expect ) => expect( Comparable( 1 ) ).ToBe( Comparable( 1 ) ),
    ( expect ) => expect( Comparable( 1 ) ).ToEqual( Comparable( 1 ) ),
    ( expect ) => expect( Comparable( ComObject( "HTMLFile" ) ), "ComObject(HTMLFile)" ).ToBeEnumerable(),
)

#Requires AutoHotkey v2.0
#Warn All

#Include <JSONStringify>
#Include <Test>

ObjectValue := { foo: "bar", baz: "qux" }
ArrayValue := [ "spam", "ham", "eggs" ]
MapValue := Map( "top", 3, "bottom", 2, "special", "1" )

Test( "JSONStringify",
    ( expect ) => expect( JSONStringify( "" ) ).ToBe( Chr( 34 ) . "" . Chr( 34 ) ),
    ( expect ) => expect( JSONStringify( "ahk" ) ).ToBe( Chr( 34 ) . "ahk" . Chr( 34 ) ),
    ( expect ) => expect( JSONStringify( 1 ) ).ToBe( 1 ),
    ( expect ) => expect( JSONStringify( "1" ) ).ToBe( 1 ),
    ( expect ) => expect( JSONStringify( ObjectValue ) ).ToBeDefined(),
    ( expect ) => expect( JSONStringify( ObjectValue ) ).ToBeType( "String" ),
    ( expect ) => expect( JSONStringify( ObjectValue ) ).ToHave( "{" ),
    ( expect ) => expect( JSONStringify( ObjectValue ) ).ToHave( "," ),
    ( expect ) => expect( JSONStringify( ObjectValue ) ).ToHave( "}" ),
    ( expect ) => expect( JSONStringify( ObjectValue ) ).ToHave( "foo" ),
    ( expect ) => expect( JSONStringify( ObjectValue ) ).ToHave( "bar" ),
    ( expect ) => expect( JSONStringify( ObjectValue ) ).ToHave( "baz" ),
    ( expect ) => expect( JSONStringify( ObjectValue ) ).ToHave( "qux" ),
    ( expect ) => expect( JSONStringify( ArrayValue ) ).ToBeDefined(),
    ( expect ) => expect( JSONStringify( ArrayValue ) ).ToBeType( "String" ),
    ( expect ) => expect( JSONStringify( ArrayValue ) ).ToHave( "[" ),
    ( expect ) => expect( JSONStringify( ArrayValue ) ).ToHave( "," ),
    ( expect ) => expect( JSONStringify( ArrayValue ) ).ToHave( "]" ),
    ( expect ) => expect( JSONStringify( ArrayValue ) ).ToHave( "spam" ),
    ( expect ) => expect( JSONStringify( ArrayValue ) ).ToHave( "ham" ),
    ( expect ) => expect( JSONStringify( ArrayValue ) ).ToHave( "eggs" ),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToBeDefined(),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToBeType( "String" ),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToHave( "{" ),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToHave( "," ),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToHave( "}" ),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToHave( "top" ),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToHave( 3 ),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToHave( "bottom" ),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToHave( 2 ),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToHave( "special" ),
    ( expect ) => expect( JSONStringify( MapValue ) ).ToHave( 1 ),
)

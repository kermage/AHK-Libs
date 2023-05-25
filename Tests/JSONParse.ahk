#Requires AutoHotkey v2.0
#Warn All

#Include <JSONParse>
#Include <Test>

FlatValue := '{"title":"this","body":"that","user":1}'
NestedValue := '{"roles":["admin","editor"],"meta":{"key":"value","status":3}}'

Test( "JSONParse",
    ( expect ) => expect( JSONParse( '""' ) ).ToBeUndefined(),
    ( expect ) => expect( JSONParse( 1 ) ).ToBe( 1 ),
    ( expect ) => expect( JSONParse( FlatValue ) ).ToHave( "title" ),
    ( expect ) => expect( JSONParse( FlatValue ) ).ToContain( "this" ),
    ( expect ) => expect( JSONParse( FlatValue ) ).ToHave( "body" ),
    ( expect ) => expect( JSONParse( FlatValue ) ).ToContain( "that" ),
    ( expect ) => expect( JSONParse( FlatValue ) ).ToHave( "user" ),
    ( expect ) => expect( JSONParse( FlatValue ) ).ToContain( "1" ),
    ( expect ) => expect( JSONParse( NestedValue ) ).ToHave( "roles" ),
    ( expect ) => expect( JSONParse( NestedValue ) ).ToContain( [ "admin", "editor" ] ),
    ( expect ) => expect( JSONParse( NestedValue ) ).ToHave( "meta" ),
    ( expect ) => expect( JSONParse( NestedValue ) ).ToContain( { key: "value", status: 3 } ),
)

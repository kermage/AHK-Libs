#Requires AutoHotkey v2.0
#Warn All

#Include <LoadSettings>
#Include <Test>

AL := LoadSettings()

Test( "LoadSettings",
    ( expect ) => expect( AL, "AL" ).ToBeDefined(),
    ( expect ) => expect( AL, "AL" ).ToBeType( "Map" ),
    ( expect ) => expect( AL, "AL" ).ToHave( "Excel" ),
    ( expect ) => expect( AL, "AL" ).ToHave( "Word" ),
    ( expect ) => expect( AL, "AL" ).ToHave( "Log" ),
    ( expect ) => expect( AL["Excel"], "AL[Excel]" ).ToBeEnumerable(),
    ( expect ) => expect( AL["Word"], "AL[Word]" ).ToBeEnumerable(),
    ( expect ) => expect( AL["Log"], "AL[Log]" ).ToBeEnumerable(),
    ( expect ) => expect( AL["Excel"], "AL[Excel]" ).ToHave( "Title" ),
    ( expect ) => expect( AL["Word"], "AL[Word]" ).ToContain( "CAFE.docx" ),
    ( expect ) => expect( AL["Log"]["Index"], "AL[Log][Index]" ).ToBe( 2 ),
)

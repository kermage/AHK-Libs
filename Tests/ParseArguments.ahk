#Requires AutoHotkey v2.0
#Warn All

#Include <ParseArguments>
#Include <Test>

if ( ! A_Args.Length ) {
    Run( A_ScriptFullPath " -short --long /slash //double -shorty=this --longy=that /slashy=here //doubley=there /-dash=escaped" )
    ExitApp
}

args := ParseArguments()

Test( "ParseArguments",
    ( expect ) => expect( args, "args" ).ToBeDefined(),
    ( expect ) => expect( args, "args" ).ToBeType( "Map" ),
    ( expect ) => expect( args["short"], "args[short]" ).ToBe( true ),
    ( expect ) => expect( args["long"], "args[long]" ).ToBe( true ),
    ( expect ) => expect( args["slash"], "args[slash]" ).ToBe( true ),
    ( expect ) => expect( args["/double"], "args[/double]" ).ToBe( true ),
    ( expect ) => expect( args["shorty"], "args[shorty]" ).ToBe( "this" ),
    ( expect ) => expect( args["longy"], "args[longy]" ).ToBe( "that" ),
    ( expect ) => expect( args["slashy"], "args[slashy]" ).ToBe( "here" ),
    ( expect ) => expect( args["/doubley"], "args[/doubley]" ).ToBe( "there" ),
    ( expect ) => expect( args["-dash"], "args[-dash]" ).ToBe( "escaped" ),
)

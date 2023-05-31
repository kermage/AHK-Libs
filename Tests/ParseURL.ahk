#Requires AutoHotkey v2.0
#Warn All

#Include <ParseURL>
#Include <Test>

TestScheme := "http"
TestHost := "test.com"
TestPort := "8080"
TestPath := "here"
TestQuery := "is=true"
TestFragment := "ahk"
TestComplete := TestScheme . "://" . TestHost . ":" . TestPort . "/" . TestPath . "?" . TestQuery . "#" . TestFragment

Test( "ParseArguments",
    ( expect ) => expect( ParseURL( TestHost ), TestHost ).ToContainEqual( {
        SCHEME: "",
        HOST: TestHost,
        PORT: "",
        PATH: "",
        QUERY: "",
        FRAGMENT: "",
    } ),
    ( expect ) => expect( ParseURL( TestScheme . "://" . TestHost ), TestScheme . "://" . TestHost ).ToContainEqual( {
        SCHEME: TestScheme,
        HOST: TestHost,
        PORT: "",
        PATH: "",
        QUERY: "",
        FRAGMENT: "",
    } ),
    ( expect ) => expect( ParseURL( TestHost . ":" . TestPort ), TestHost . ":" . TestPort ).ToContainEqual( {
        SCHEME: "",
        HOST: TestHost,
        PORT: TestPort,
        PATH: "",
        QUERY: "",
        FRAGMENT: "",
    } ),
    ( expect ) => expect( ParseURL( TestHost . "/" . TestPath ), TestHost . "/" . TestPath ).ToContainEqual( {
        SCHEME: "",
        HOST: TestHost,
        PORT: "",
        PATH: "/" . TestPath,
        QUERY: "",
        FRAGMENT: "",
    } ),
    ( expect ) => expect( ParseURL( TestHost . "?" . TestQuery ), TestHost . "?" . TestQuery ).ToContainEqual( {
        SCHEME: "",
        HOST: TestHost,
        PORT: "",
        PATH: "",
        QUERY: TestQuery,
        FRAGMENT: "",
    } ),
    ( expect ) => expect( ParseURL( TestHost . "#" . TestFragment ), TestHost . "#" . TestFragment ).ToContainEqual( {
        SCHEME: "",
        HOST: TestHost,
        PORT: "",
        PATH: "",
        QUERY: "",
        FRAGMENT: TestFragment,
    } ),
    ( expect ) => expect( ParseURL( TestComplete ), TestComplete ).ToContainEqual( {
        SCHEME: TestScheme,
        HOST: TestHost,
        PORT: TestPort,
        PATH: "/" . TestPath,
        QUERY: TestQuery,
        FRAGMENT: TestFragment,
    } ),
    ( expect ) => expect( ParseURL( TestComplete, "SCHEME" ), "Parsed[SCHEME]" ).ToBe( TestScheme ),
    ( expect ) => expect( ParseURL( TestComplete, "Host" ), "Parsed[Host]" ).ToBe( TestHost ),
    ( expect ) => expect( ParseURL( TestComplete, "port" ), "Parsed[port]" ).ToBe( TestPort ),
    ( expect ) => expect( ParseURL( TestComplete, "pAth" ), "Parsed[pAth]" ).ToBe( "/" . TestPath ),
    ( expect ) => expect( ParseURL( TestComplete, "qUERY" ), "Parsed[qUERY]" ).ToBe( TestQuery ),
    ( expect ) => expect( ParseURL( TestComplete, "FrAgMeNt" ), "Parsed[FrAgMeNt]" ).ToBe( TestFragment ),
)

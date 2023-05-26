#Requires AutoHotkey v2.0
#Warn All

#Include <JSONParse>
#Include <Test>

; https://api.github.com/repos/kermage/AHK-Libs
JSONFile := "Parse.json"
FileValue := FileRead( JSONFile )
ParsedValues := JSONParse( FileValue )
FileID := Format( "{1}\{2} contents", A_ScriptDir, JSONFile )
licenseObject := {
    key: "mit",
    name: "MIT License",
    spdx_id: "MIT",
    url: "https://api.github.com/licenses/mit",
    node_id: "MDc6TGljZW5zZTEz"
}

Test( "JSONParse",
    ( expect ) => expect( JSONParse( '""' ) ).ToBeUndefined(),
    ( expect ) => expect( JSONParse( 1 ) ).ToBe( 1 ),
    ( expect ) => expect( ParsedValues, FileID ).ToHave( "full_name" ),
    ( expect ) => expect( ParsedValues, FileID ).ToContain( "kermage/AHK-Libs" ),
    ( expect ) => expect( ParsedValues, FileID ).ToContainEqual( { full_name: "kermage/AHK-Libs" } ),
    ( expect ) => expect( ParsedValues, FileID ).ToHave( "license" ),
    ( expect ) => expect( ParsedValues, FileID ).ToContain( licenseObject ),
    ( expect ) => expect( ParsedValues, FileID ).ToContainEqual( { license: licenseObject } ),
    ( expect ) => expect( ParsedValues, FileID ).ToContainEqual( {
        id: 44791310,
        private: false,
        has_wiki: true,
        default_branch: "master",
        temp_clone_token: "", ; null
    } ),
    ( expect ) => expect( ParsedValues["mirror_url"], "ParsedValues[mirror_url]", ).ToBeUndefined(),
    ( expect ) => expect( ParsedValues["allow_forking"], "ParsedValues[allow_forking]", ).ToBeTruthy(),
    ( expect ) => expect( ParsedValues["is_template"], "ParsedValues[is_template]", ).ToBeFalsy(),
)

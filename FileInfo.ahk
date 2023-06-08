/*
---------------------------------------------------------------------------
Function:
    For getting file icon, name, and type
---------------------------------------------------------------------------
*/

FileInfo( _File ) {
    static SHGFI_ICON := 0x000000100
    static SHGFI_DISPLAYNAME := 0x000000200
    static SHGFI_TYPENAME := 0x000000400

    static SHFO := DataType( {
        a_hIcon: A_PtrSize,
        b_iIcon: "int",
        c_dwAttributes: "unsigned long",
        d_szDisplayName: "260 wchar_t", ; MAX_PATH
        e_szTypeName: "80 char",
    } )

    local result := DllCall( "Shell32\SHGetFileInfoW", "Str", _File, "UInt", 0, "Ptr", SHFO, "UInt", SHFO.Size, "UInt", SHGFI_ICON|SHGFI_DISPLAYNAME|SHGFI_TYPENAME )

    return {
        icon: NumGet( SHFO.Address( "a_hIcon" ), "Ptr" ),
        name: StrGet( SHFO.Address( "d_szDisplayName" ) ),
        type: StrGet( SHFO.Address( "e_szTypeName" ) ),
    }
}

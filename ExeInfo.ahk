/*
---------------------------------------------------------------------------
Function:
    For getting exe information
---------------------------------------------------------------------------
*/

class ExeInfo {
	__New( _File ) {
		local InfoSize := DllCall( "version\GetFileVersionInfoSize", "Str", _File, "UInt*", 0, "UInt" )
		local Translation := 0

		this.VersionInfo := Buffer( InfoSize )

		DllCall( "version\GetFileVersionInfo", "Str", _File, "UInt", 0, "UInt", InfoSize, "Ptr", this.VersionInfo )
		DllCall( "version\VerQueryValue", "Ptr", this.VersionInfo, "Str", "\VarFileInfo\Translation", "Ptr*", &Translation, "UInt", 0 )

		this.ID := Format( "{:04X}{:04X}", NumGet( Translation, 0, "UShort" ), NumGet( Translation, 2, "UShort" ) )
	}

	__Get( _Name, _Params ) {
		local Field := 0
		local Encoding := 0

		DllCall( "version\VerQueryValue", "Ptr", this.VersionInfo, "Str", "\StringFileInfo\" this.ID "\" _Name, "Ptr*", &Field, "UInt*", &Encoding )

		return StrGet( Field, Encoding )
	}
}
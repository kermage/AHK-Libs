/*
---------------------------------------------------------------------------
Function:
	To check for Administrator rights then elevate if needed.
---------------------------------------------------------------------------
*/

RunAsAdmin() {
	IfEqual, A_IsAdmin, 1, Return 0
	Loop, %0%
		params .= A_Space . %A_Index%
	DllCall( "shell32\ShellExecute" ( A_IsUnicode ? "":"A" ), uint, 0, str, "RunAs", str, ( A_IsCompiled ? A_ScriptFullPath : A_AhkPath ), str, ( A_IsCompiled ? "" : """" . A_ScriptFullPath . """" . A_Space ) params, str, A_WorkingDir, int, 1 )
	ExitApp
}

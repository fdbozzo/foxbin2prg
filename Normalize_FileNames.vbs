'---------------------------------------------------------------------------------------------------
'	Normalize_FileNames.vbs - 06/01/2014 - Fernando D. Bozzo (fdbozzo@gmail.com)
'---------------------------------------------------------------------------------------------------
'	ENGLISH:
'		Create a shortcut on user's "SendTo" folder and configure CAPS on filename_caps.cfg
'
'	ESPAÑOL:
'		Cree un acceso directo en la carpeta "SendTo" del usuario y configure las Capitalizaciones en filename_caps.cfg
'---------------------------------------------------------------------------------------------------
Const ForReading = 1 
Dim WSHShell, FileSystemObject
Dim oVFP9, nExitCode, cEXETool, cCMD, nDebug, cConvertType, aExtensions(8), filename_caps_log, nRet
Dim i, x, str_cfg, aConf
Set WSHShell = WScript.CreateObject("WScript.Shell")
Set FileSystemObject = WScript.CreateObject("Scripting.FileSystemObject")
Set oVFP9 = CreateObject("VisualFoxPro.Application.9")
filename_caps_log	= Replace(WScript.ScriptFullName, WScript.ScriptName, "filename_caps.log")
nExitCode = 0
'---------------------------------------------------------------------------------------------------
nDebug = 13		'Cumulative Flags: 0=OFF, 1=Create filename_caps LOG, 2=Only show script calls, 4=Don't show filename_caps error modal messages, 8=Show end of process message
'---------------------------------------------------------------------------------------------------

If WScript.Arguments.Count = 0 Then
	nExitCode = 1
	cErrMsg = "nDebug = " & nDebug
	If GetBit(nDebug, 1) Then
		cErrMsg	= cErrMsg & Chr(13) & "Bit 0 ON: (1) Create filename_caps LOG"
	End If
	If GetBit(nDebug, 2) Then
		cErrMsg	= cErrMsg & Chr(13) & "Bit 1 ON: (2) Only show script calls"
	End If
	If GetBit(nDebug, 3) Then
		cErrMsg	= cErrMsg & Chr(13) & "Bit 2 ON: (4) Don't show filename_caps error modal messages"
	End If
	If GetBit(nDebug, 4) Then
		cErrMsg	= cErrMsg & Chr(13) & "Bit 3 ON: (8) Show End of Process message"
	End If
	MsgBox cErrMsg, 64, "No parameters - Debug Status"
Else
	cEXETool	= Replace(WScript.ScriptFullName, WScript.ScriptName, "filename_caps.exe")
	If GetBit(nDebug, 1) And Not GetBit(nDebug, 2) And Not FileSystemObject.FileExists( filename_caps_log ) Then
		FileSystemObject.CreateTextFile( filename_caps_log )
	End If
	
	For i = 0 To WScript.Arguments.Count-1
		scanDirs( WScript.Arguments(i) )
	Next

	If GetBit(nDebug, 4) Then
		MsgBox "End of Process!", 64, WScript.ScriptName
	End If
End If

WScript.Quit(nExitCode)


Private Sub scanDirs( tcArgument )
	Dim omFolder, oFolder
	If FileSystemObject.FolderExists( tcArgument ) Then
		'-- Es un directorio
		Set omFolder = FileSystemObject.GetFolder( tcArgument )
		For Each oFile IN omFolder.Files
			evaluateFile( oFile.Path )
		Next
		For Each oFolder IN omFolder.SubFolders
			scanDirs( oFolder.Path )
		Next
	Else
		'-- Es un archivo
		evaluateFile( tcArgument )
	End If
End Sub


Private Sub evaluateFile( tcFile )
	cFlagGenerateLog			= "'0'"
	cFlagDontShowErrMsg			= "'0'"
	cFlagShowCall				= "'0'"

	If GetBit(nDebug, 1) Then
		cFlagGenerateLog	= "'1'"
	End If
	If GetBit(nDebug, 2) Then
		cFlagJustShowCall	= "1"
	End If
	If GetBit(nDebug, 3) Then
		cFlagDontShowErrMsg	= "'1'"
	End If
	
	cCMD	= "DO '" & cEXETool & "' WITH '" & tcFile & "','','F','',.F.," & cFlagDontShowErrMsg
	If cFlagJustShowCall = "1" Then
		MsgBox cCMD, 0, "PARAMETERS"
	Else
		nRet = oVFP9.DoCmd( cCMD )
		'nExitCode = oVFP9.Eval("_SCREEN.ExitCode")
	End If
End Sub


Function GetBit(lngValue, BitNum)
     Dim BitMask
     If BitNum < 32 Then BitMask = 2 ^ (BitNum - 1) Else BitMask = "&H80000000"
     GetBit = CBool(lngValue AND BitMask)
End Function

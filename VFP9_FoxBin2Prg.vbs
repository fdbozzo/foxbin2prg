'---------------------------------------------------------------------------------------------------
'	VFP9_FoxBin2Prg.vbs (VFPx: https://vfpx.codeplex.com/wikipage?title=FoxBin2Prg)
'	08/10/2014 - Fernando D. Bozzo (fdbozzo@gmail.com - Blog: http://fdbozzo.blogspot.com.es/)
'
'---------------------------------------------------------------------------------------------------
'	ENGLISH:
'		- Copy this file in the same directory of FoxBin2prg and create a shortcut
'		on user's "SendTo" folder
'		- Now you can select files or directories, right click and "SendTo" FoxBin2prg for batch conversion
'
'	ESPAÑOL:
'		- Copie este archivo en el mismo directorio que FoxBin2prg y cree un acceso directo
'		en la carpeta "SendTo" del usuario
'		- Ahora puede seleccionar archivos o directorios, pulsar click derecho y "Enviar a" FoxBin2prg para conversiones batch
'---------------------------------------------------------------------------------------------------
Dim WSHShell, FileSystemObject
Dim nExitCode, cEXETool, cEXETool2, nDebug
Set wshShell = CreateObject( "WScript.Shell" )
Set FileSystemObject = WScript.CreateObject("Scripting.FileSystemObject")
Set oVFP9 = CreateObject("VisualFoxPro.Application.9")
nExitCode = 0
'---------------------------------------------------------------------------------------------------
'Cumulative Flags:
' 0=OFF
' 1=Create FoxBin2prg LOG
' 2=Only show script calls (for testing without executing)
' 4=Don't show FoxBin2prg error modal messages
' 8=Show end of process message
' 16=Empty timestamps
nDebug = 1+0+4+8
'---------------------------------------------------------------------------------------------------

If WScript.Arguments.Count = 0 Then
	'SIN PARÁMETROS
	nExitCode = 1
	cErrMsg = "nDebug = " & nDebug
	If GetBit(nDebug, 1) Then
		cErrMsg	= cErrMsg & Chr(13) & "Bit 0 ON: (1) Create FoxBin2prg LOG"
	End If
	If GetBit(nDebug, 2) Then
		cErrMsg	= cErrMsg & Chr(13) & "Bit 1 ON: (2) Only show script calls"
	End If
	If GetBit(nDebug, 3) Then
		cErrMsg	= cErrMsg & Chr(13) & "Bit 2 ON: (4) Don't show FoxBin2prg error modal messages"
	End If
	If GetBit(nDebug, 4) Then
		cErrMsg	= cErrMsg & Chr(13) & "Bit 3 ON: (8) Show End of Process message"
	End If
	If GetBit(nDebug, 5) Then
		cErrMsg	= cErrMsg & Chr(13) & "Bit 4 ON: (16) Empty timestamps"
	End If
	MsgBox cErrMsg, 64, "No parameters - Debug Status"

ElseIf WScript.Arguments.Count > 1 Then
	MsgBox cErrMsg, 64, "You can select just ONE file with this script!"
	
Else
	'CON PARÁMETROS
	cEXETool	= Replace(WScript.ScriptFullName, WScript.ScriptName, "foxbin2prg.exe")
	nFile_Count = 0
	oVFP9.DoCmd( "SET PROCEDURE TO '" & cEXETool & "'" )
	oVFP9.DoCmd( "PUBLIC oFoxBin2prg" )
	oVFP9.DoCmd( "oFoxBin2prg = CREATEOBJECT('c_foxbin2prg')" )
	oVFP9.DoCmd( "oFoxBin2prg.EvaluarConfiguracion( '1', '1' )" )
	
	cFlagGenerateLog		= "'0'"
	cFlagDontShowErrMsg		= "'0'"
	cFlagShowCall			= "'0'"
	cFlagRecompile			= "'1'"

	If GetBit(nDebug, 1) Then
		cFlagGenerateLog	= "'1'"
	End If
	If GetBit(nDebug, 2) Then
		cFlagJustShowCall	= "1"
	End If
	If GetBit(nDebug, 3) Then
		cFlagDontShowErrMsg	= "'1'"
	End If
	If GetBit(nDebug, 5) Then
		cNoTimestamps	= "'1'"
	End If
	
	cFlagRecompile	= "'" & FileSystemObject.GetParentFolderName( WScript.Arguments(0) ) & "'"

	If nDebug = 0 Or nDebug = 2 Then
		cCMD	= "oFoxBin2prg.ejecutar( '" & WScript.Arguments(0) & "' )"
	Else
		cCMD	= "oFoxBin2prg.ejecutar(  '" & WScript.Arguments(0) & "','0','0','0'," _
			& cFlagDontShowErrMsg & "," & cFlagGenerateLog & ",'1','','',.F.,''," _
			& cFlagRecompile & "," & cNoTimestamps & " )"
	End If
	If cFlagJustShowCall = "1" Then
		MsgBox cCMD, 64, "PARAMETERS"
	Else
		oVFP9.DoCmd( cCMD )
		nExitCode = oVFP9.Eval("_SCREEN.ExitCode")
	End If

	If GetBit(nDebug, 4) Then
		If oVFP9.Eval("oFoxBin2prg.l_Error") Then
			MsgBox "End of Process! (with errors)", 48, WScript.ScriptName
			cErrFile = oVFP9.Eval("FORCEPATH('FoxBin2Prg.LOG',GETENV('TEMP') )")
			oVFP9.DoCmd("STRTOFILE( oFoxBin2prg.c_ErrorLog, '" & cErrFile & "' )")
			WSHShell.run cErrFile
		Else
			MsgBox "End of Process!", 64, WScript.ScriptName
		End If
	End If

	oVFP9.DoCmd( "oFoxBin2prg = NULL" )
	oVFP9.DoCmd( "CLEAR ALL" )
	Set oVFP9 = Nothing
End If

WScript.Quit(nExitCode)


Function GetBit(lngValue, BitNum)
     Dim BitMask
     If BitNum < 32 Then BitMask = 2 ^ (BitNum - 1) Else BitMask = "&H80000000"
     GetBit = CBool(lngValue AND BitMask)
End Function

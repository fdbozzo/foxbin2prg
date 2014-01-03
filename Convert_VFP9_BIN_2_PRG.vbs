'---------------------------------------------------------------------------------------------------
'	Convert_VFP9_BIN_2_PRG.vbs - 03/01/2014 - Fernando D. Bozzo (fdbozzo@gmail.com)
'---------------------------------------------------------------------------------------------------
'	ENGLISH:
'		USE: Copy this file in the same directory of FoxBin2prg and create a shortcut
'			 on user's "SendTo" folder
'
'	ESPAÑOL:
'		USO: Copie este archivo en el mismo directorio que FoxBin2prg y cree un acceso directo
'			 en la carpeta "SendTo" del usuario
'---------------------------------------------------------------------------------------------------
Const ForReading = 1 
Dim WSHShell, FileSystemObject
Dim oVFP9, nExitCode, cEXETool, cCMD, nDebug, cConvertType, aExtensions(8), foxbin2prg_cfg
Dim i, x, str_cfg, aConf
Set WSHShell = WScript.CreateObject("WScript.Shell")
Set FileSystemObject = WScript.CreateObject("Scripting.FileSystemObject")
Set oVFP9 = CreateObject("VisualFoxPro.Application.9")
cConvertType	= "BIN2PRG"
foxbin2prg_cfg	= Replace(WScript.ScriptFullName, WScript.ScriptName, "foxbin2prg.cfg")
nExitCode = 0
'---------------------------------------------------------------------------------------------------
nDebug = 1		'0=OFF, 1=Create FoxBin2prg LOG, 2=Only show calls, 3=Only show calls of the LOG call
'---------------------------------------------------------------------------------------------------

If cConvertType	= "BIN2PRG" Then
	aExtensions(1)	= "PJX"
	aExtensions(2)	= "VCX"
	aExtensions(3)	= "SCX"
	aExtensions(4)	= "FRX"
	aExtensions(5)	= "LBX"
	aExtensions(6)	= "DBF"
	aExtensions(7)	= "DBC"
	aExtensions(8)	= "MNX"
Else
	'-- Extensiones TXT por defecto
	aExtensions(1)	= "PJ2"
	aExtensions(2)	= "VC2"
	aExtensions(3)	= "SC2"
	aExtensions(4)	= "FR2"
	aExtensions(5)	= "LB2"
	aExtensions(6)	= "DB2"
	aExtensions(7)	= "DC2"
	aExtensions(8)	= "MN2"

	If FileSystemObject.FileExists( foxbin2prg_cfg ) Then
		'-- Existe el archivo de configuración foxbin2prg.cgf
		Set objTextFile = FileSystemObject.OpenTextFile( foxbin2prg_cfg, ForReading ) 

		Do Until objTextFile.AtEndOfStream 
			strNextLine = objTextFile.Readline 
			arrFb2p_CFG = Split(strNextLine , ",") 
			For i = 0 to Ubound(arrFb2p_CFG) 
			    If Left( arrFb2p_CFG(i), 10 ) = "extension:" Then
					'Wscript.Echo "CFG line: " & arrFb2p_CFG(i)
					aConf = Split( arrFb2p_CFG(i), ":" )		'Obtengo la separación de "extensión:" y "ext:equiv"
					str_cfg = UCase( Trim( aConf(1) ) )
					aConf = Split( str_cfg, "=" )				'Obtengo la separación de extensión y equivalencia (vc2=vca)
					'Wscript.Echo "[" & aConf(0) & "] [" & aConf(1) & "]"
					
					For x = 1 TO 8
						If aExtensions(x) = aConf(0) Then
							aExtensions(x) = UCase( aConf(1) )
							Exit For
						End If
					Next
				Else
					'Wscript.Echo "Saltear: " & arrFb2p_CFG(i)
				End If
			Next 
		Loop 
	End If
End if

If WScript.Arguments.Count = 0 Then
	nExitCode = 1
	MsgBox "Sin parametros"
Else
	cEXETool	= Replace(WScript.ScriptFullName, WScript.ScriptName, "foxbin2prg.exe")
	
	For i = 0 To WScript.Arguments.Count-1
		scanDirs( WScript.Arguments(i) )
	Next
End If

WScript.Quit(nExitCode)


Private Sub scanDirs( tcArgument )
	Dim omFolder, oFolder
	If FileSystemObject.FolderExists( tcArgument ) Then
		'-- Es un directorio
		'WScript.Echo "Argument: " & "[" & tcArgument & "]"
		Set omFolder = FileSystemObject.GetFolder( tcArgument )
		'WScript.Echo "Dir: " & "[" & omFolder.Path & "]"
		For Each oFile IN omFolder.Files
			'WScript.Echo "File: " & "[" & oFile.Path & "]"
			evaluateFile( oFile.Path )
		Next
		For Each oFolder IN omFolder.SubFolders
			'WScript.Echo "SubDir: " & "[" & oFolder.Name & "] [" & oFolder.Path & "]"
			scanDirs( oFolder.Path )
		Next
	Else
		'-- Es un archivo
		evaluateFile( tcArgument )
	End If
End Sub


Private Sub evaluateFile( tcFile )
	For x = 1 TO 8
		If aExtensions(x) = UCase( FileSystemObject.GetExtensionName( tcFile ) ) Then
			If nDebug = 1 OR nDebug = 3 Then
				cCMD	= "DO " & chr(34) & cEXETool & chr(34) & " WITH '" & tcFile & "','0','0','0','0','1'" 
			Else
				cCMD	= "DO " & chr(34) & cEXETool & chr(34) & " WITH " & chr(34) & tcFile & chr(34)
			End If
			If nDebug = 2 Or nDebug = 3 Then
				MsgBox cCMD, 0, "PARAMETROS ENVIADOS"
			Else	'nDebug = 0 Or nDebug = 2
				oVFP9.DoCmd( cCMD )
				nExitCode = oVFP9.Eval("_SCREEN.ExitCode")
			End If
			Exit For
		End If
	Next
End Sub

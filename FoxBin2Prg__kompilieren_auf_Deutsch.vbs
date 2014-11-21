'---------------------------------------------------------------------------------------------------
'	FoxBin2Prg__kompilieren_auf_Deutsch.vbs - 10/08/2014 - Fernando D. Bozzo (fdbozzo@gmail.com)
'---------------------------------------------------------------------------------------------------
'		- Führen Sie einfach auf FoxBin2Prg Hauptverzeichnis, und Sie erhalten eine EXE-Datei mit Texten übersetzt bekommen
'---------------------------------------------------------------------------------------------------
Const ForReading = 1 
Dim WSHShell, FileSystemObject
Dim oVFP9, nExitCode, cOrigFile, cDestFile
Dim nRet
Set WSHShell = WScript.CreateObject("WScript.Shell")
Set FileSystemObject = WScript.CreateObject("Scripting.FileSystemObject")
Set oVFP9 = CreateObject("VisualFoxPro.Application.9")
foxbin2prg_exe	= Replace(WScript.ScriptFullName, WScript.ScriptName, "foxbin2prg.exe")
nExitCode = 0
cOrigFile	= Replace(WScript.ScriptFullName, WScript.ScriptName, "foxbin2prg_de.h")
cDestFile	= Replace(WScript.ScriptFullName, WScript.ScriptName, "foxbin2prg.h")
cPath		= FileSystemObject.GetParentFolderName( cOrigFile )
nRet		= FileSystemObject.CopyFile( cOrigFile, cDestFile, True )
oVFP9.DoCmd( "SET DEFAULT TO '" & cPath & "'" )
oVFP9.DoCmd( "BUILD EXE foxbin2prg.exe FROM foxbin2prg.pjx RECOMPILE" )
WSHShell.run foxbin2prg_exe
WScript.Quit(nExitCode)

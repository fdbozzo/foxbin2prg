'---------------------------------------------------------------------------------------------------
'	FoxBin2Prg__Compilar_en_Español.vbs - 10/08/2014 - Fernando D. Bozzo (fdbozzo@gmail.com)
'---------------------------------------------------------------------------------------------------
'		- FoxBin2Prg ya viene en Español por defecto, pero si lo llega a necesitar, solo ejecute este script.
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
cOrigFile	= Replace(WScript.ScriptFullName, WScript.ScriptName, "foxbin2prg.h")
cPath		= FileSystemObject.GetParentFolderName( cOrigFile )
nRet		= FileSystemObject.DeleteFile( cOrigFile, True )
oVFP9.DoCmd( "SET DEFAULT TO '" & cPath & "'" )
oVFP9.DoCmd( "BUILD EXE foxbin2prg.exe FROM foxbin2prg.pjx RECOMPILE" )
WSHShell.run foxbin2prg_exe
WScript.Quit(nExitCode)

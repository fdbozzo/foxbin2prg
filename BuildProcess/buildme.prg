*BuildMe.prg for [add your application]
*
* This program should perform any build tasks necessary for the project, such
* as updating version numbers in code or include files. This program can use the public
* variables discussed in the documentation as necessary.
LOCAL;
	lcVerno   as String,;
	lnProject as Integer,;
	llFound   as Boolean,;
	loProject as Project
	
*Get FoxBin2Prg verno from FoxBin2Prg.prg
lcVerno = "VERNO"
DO foxbin2prg.prg WITH lcVerno

*Set Thor verno
pcVersion = m.lcVerno
pcPJXFile = "foxbin2prg.pjx"
*Set FoxBin2Prg.exe verno
For lnProject = 1 To _vfp.Projects.Count
	If Upper(Fullpath(m.pcPJXFile))==Upper(_vfp.Projects(m.lnProject).Name) Then
		_vfp.Projects(m.lnProject).VersionNumber = m.lcVerno
		llFound = .T.
		Exit

	Endif &&Upper(Fullpath(m.pcPJXFile))==Upper(_vfp.Projects(m.lnProject).Name)
Endfor &&lnProject

If !m.llFound
	If _Vfp.Projects.Count>0
		loProject = _vfp.ActiveProject
	Endif &&_Vfp.Projects.Count>0
	
	MODIFY PROJECT (Fullpath(m.pcPJXFile)) Noshow Nowait Noprojecthook
	_vfp.ActiveProject.VersionNumber = m.lcVerno
	_vfp.ActiveProject.Close

	If _Vfp.Projects.Count>0
		_vfp.ActiveProject = m.loProject
	Endif &&_Vfp.Projects.Count>0
Endif &&!m.llFound

* ToDo
llFound = FILE(Fullpath("FOXBIN2PRG.CFG"))
If m.llFound
	rename FOXBIN2PRG.CFG to FOXBIN2PRG.CFG.tmp
Endif &&m.llFound

strtofile("Language: EN","FOXBIN2PRG.CFG")
DO foxbin2prg.prg WITH "-c", "foxbin2prg.cfg.txt"
DO foxbin2prg.prg WITH "-t", "foxbin2prg.dbf.cfg.txt"
delete file FOXBIN2PRG.CFG

If m.llFound
	rename FOXBIN2PRG.CFG.tmp to FOXBIN2PRG.CFG
Endif &&m.llFound

*set english on
*export foxbin2prg.cfg.txt and foxbin2prg.dbf.cfg.txt
*set english off

return

*Stuff we can do:
* - get version number (pcVersion) from an include file
* - set version number (pcVersion) to an include file
* - set version number to pjx used
* - set debug info off in pjx or include file
* - If FoxBin2Prg internal to VFPXDeployment is not fitting, run own way
* - create pcFullVersion like you use in the .VersionNumber of Version*.txt file for use in README.md
*   (else it will use pcVersion)
*   like the example in the Version text template:
pcFullVersion = pcVersion+' - ' + pcJulian
* - copy files to ../InstalledFiles subfolder
* - modify documentation

LPARAMETERS;
 tcDirectory

*set step on
tcDirectory = EXECSCRIPT(_SCREEN.cThorDispatcher, 'Thor_Proc_GetFoxBin2PrgFolder')
DO CASE
 CASE VARTYPE(tcDirectory)#'C'
 CASE !INLIST(UPPER(tcDirectory),'?','/?','-?','/Help','-Help')
 OTHERWISE
  tcDirectory = JUSTFNAME(SYS(16))
  InfoScreen(tcDirectory)
  RETURN
ENDCASE

ADDPROPERTY(_SCREEN,'gvX1',tcDirectory)

CLEAR ALL

LOCAL;
 lcDir,;
 lcExt,;
 lcErr,;
 lcOldPath,;
 lcDirectory,;
 llNewGUID,;
 lcResult


lcDirectory = _SCREEN.gvX1
REMOVEPROPERTY(_SCREEN,'gvX1')

lcOldPath = FULLPATH(CURDIR())

DO CASE
 CASE EMPTY(lcDirectory)
  lcDir = ''
 CASE !DIRECTORY(lcDirectory) AND !FILE(lcDirectory)
  lcDir = ''
 CASE DIRECTORY(lcDirectory)
  lcDir = ADDBS(lcDirectory)
 OTHERWISE
  MESSAGEBOX('Nicht unterstützter Dateityp.')
  RETURN
ENDCASE

IF EMPTY(lcDir) THEN
 CLEAR
 lcDir = GETDIR('','','',64)
 IF ALLTRIM(lcDir)=='' THEN
  RETURN
 ENDIF &&ALLTRIM(lcDir)==''
ENDIF &&EMPTY(lcDir)

PUBLIC;
 poRegExp

*!*	poRegExp = CREATEOBJECT('VBScript.RegExp')
*!*	WITH poRegExp
*!*	 .IgnoreCase = .T.
*!*	 .GLOBAL     = .T.
*!*	 .MultiLine  = .T.
*!*	ENDWITH &&poRegExp

lcErr = ''
lcResult = ''
ScanDir(lcDir,@lcErr,lcDir,@lcResult)
_CLIPTEXT = lcResult

IF !EMPTY(lcErr) THEN
 MESSAGEBOX('Fehler in der Zwischenablage gespeichert',0+48)
 _CLIPTEXT = SUBSTR(lcErr,3)
ENDIF &&!EMPTY(lcErr)
poRegExp = .NULL.
RELEASE;
 poRegExp

CD (lcOldPath)

RETURN lcResult

PROCEDURE InfoScreen
 LPARAMETERS;
  tcProgram

 LOCAL;
  lcTemp     AS CHARACTER,;
  lnOldMemoW AS INTEGER

 TEXT TO lcTEMP NOSHOW textmerge
<<tcProgram>>
Creates a list of files in a given subdirectory with subdirectories.
Usage:
<<tcProgram>> [/?] [cDirectory]
 /?         Displays this text
 cDirectory optional directory to start from, subdirectories will be included
Return is in clipboard
 ENDTEXT

 lnOldMemoW = SET("Memowidth")
 SET MEMOWIDTH TO 100
 ?lcTemp FONT 'Courier',6
 SET MEMOWIDTH TO lnOldMemoW
ENDPROC &&InfoScreen

PROCEDURE ScanDir
 LPARAMETERS;
  tcDir,;
  tcErr,;
  tcDir2,;
  tcResult

 LOCAL;
  lnLoop1,;
  lcOldDir

 LOCAL ARRAY;
  laDir(1)

* SET STEP ON
 lcOldDir = FULLPATH(CURDIR())
 CD (tcDir)
 FOR lnLoop1 = 1 TO ADIR(laDir,'','D')
  IF INLIST(laDir(lnLoop1,1),'.','..') THEN
   LOOP
  ENDIF &&INLIST(laDir(lnLoop1,1),'.','..')
  ScanDir(ADDBS(tcDir+laDir(lnLoop1,1)),@tcErr,tcDir2,@tcResult)
 ENDFOR &&lnLoop1
 Dir_Action(tcDir,@tcErr,tcDir2,@tcResult)

 CD (lcOldDir)
ENDPROC &&ScanDir

PROCEDURE Dir_Action
 LPARAMETERS;
  tcDir,;
  tcErr,;
  tcDir2,;
  tcResult

 LOCAL;
  lnStart AS INTEGER

 LOCAL ARRAY;
  laDir(1)

 tcDir2 = STRTRAN(tcDir,tcDir2,'')

 FOR lnStart = 1 TO ADIR(laDir,'*.*')
  tcResult = tcResult+0h0d0a+laDir(lnStart,1)
 ENDFOR &&lnStart

 RETURN
ENDPROC &&Dir_Action

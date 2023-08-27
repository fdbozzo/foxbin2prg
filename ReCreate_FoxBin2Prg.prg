*ReCreate all FoxBin2Prg files from there text representation and compile
LOCAL ARRAY;
 laDir[1]

LOCAL;
 llReplace

IF ADIR(laDir,'FoxBin2Prg.cfg')>0 THEN
 DELETE FILE xFoxBin2Prg.cfg
 RENAME FoxBin2Prg.cfg TO xFoxBin2Prg.cfg
 llReplace = .T.
ENDIF &&ADIR(laDir,,'FoxBin2Prg.cfg')>0

COPY FILE Create_FoxBin2Prg.cfg TO FoxBin2Prg.cfg

*!*	DO FoxBin2Prg.PRG WITH JUSTPATH(FULLPATH("","")),"Prg2Bin",,,,,,,,,FULLPATH("","")+"Create_FoxBin2Prg.cfg"
DO FoxBin2Prg.PRG WITH JUSTPATH(FULLPATH("","")),"Prg2Bin"

BUILD PROJECT FoxBin2Prg.EXE FROM FoxBin2Prg.pjx RECOMPILE

CD Fb2P_Diff
BUILD PROJECT Fb2P_Diff.EXE FROM Fb2P_Diff.pjx RECOMPILE
COPY FILE Fb2P_Diff.EXE TO ..\Fb2P_Diff.EXE

CD ..\FileName_Caps
BUILD PROJECT FileName_Caps.EXE FROM FileName_Caps.pjx RECOMPILE
COPY FILE FileName_Caps.EXE TO ..\FileName_Caps.EXE
CD ..

DELETE FILE FoxBin2Prg.cfg
IF m.llReplace THEN
 RENAME xFoxBin2Prg.cfg TO FoxBin2Prg.cfg
ENDIF &&llReplace

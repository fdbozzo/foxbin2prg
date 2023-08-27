LOCAL ARRAY;
 laDir[1]

LOCAL;
 llReplace

IF ADIR(laDir,'FoxBin2Prg.cfg')>0 THEN
 DELETE FILE xFoxBin2Prg.cfg
 RENAME FoxBin2Prg.cfg TO xFoxBin2Prg.cfg
 llReplace = .T.
ENDIF &&ADIR(laDir,,'FoxBin2Prg.cfg')>0

COPY FILE Create_Config.cfg TO FoxBin2Prg.cfg

*Create config templates
*!*	DO FoxBin2Prg.prg WITH "-c","foxbin2prg.cfg.txt",FULLPATH("","")+"Create_FoxBin2Prg.cfg"
*!*	DO FoxBin2Prg.prg WITH "-t","foxbin2prg.dbc.txt",FULLPATH("","")+"Create_FoxBin2Prg.cfg"
DO FoxBin2Prg.prg WITH "-c","foxbin2prg.cfg.txt"
DO FoxBin2Prg.prg WITH "-t","foxbin2prg.dbc.txt"

*Create all FoxBin2Prg files to there text to commit them

DELETE FILE FoxBin2Prg.cfg
COPY FILE Create_FoxBin2Prg.cfg TO FoxBin2Prg.cfg

*!*	DO FOXBIN2PRG.PRG WITH JUSTPATH(FULLPATH("","")),"Bin2Prg",,,,,,,,,FULLPATH("","")+"Create_FoxBin2Prg.cfg"
DO FOXBIN2PRG.PRG WITH JUSTPATH(FULLPATH("","")),"Bin2Prg"

DELETE FILE FoxBin2Prg.cfg
IF m.llReplace THEN
 RENAME xFoxBin2Prg.cfg TO FoxBin2Prg.cfg
ENDIF &&llReplace

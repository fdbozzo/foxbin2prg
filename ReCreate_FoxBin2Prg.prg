*ReCreate all FoxBin2Prg files from there text representation and compile

DO FoxBin2Prg.PRG WITH JUSTPATH(FULLPATH("","")),"Prg2Bin",,,,,,,,,FULLPATH("Create_FoxBin2Prg.cfg","")

BUILD PROJECT FoxBin2Prg.EXE FROM FoxBin2Prg.pjx RECOMPILE

CD Fb2P_Diff
BUILD PROJECT Fb2P_Diff.EXE FROM Fb2P_Diff.pjx RECOMPILE
COPY FILE Fb2P_Diff.EXE TO ..\Fb2P_Diff.EXE

CD ..\FileName_Caps
BUILD PROJECT FileName_Caps.EXE FROM FileName_Caps.pjx RECOMPILE
COPY FILE FileName_Caps.EXE TO ..\FileName_Caps.EXE
CD ..


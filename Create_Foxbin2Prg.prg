*Create all FoxBin2Prg files from there text representation and compile
DO FOXBIN2PRG.PRG WITH JUSTPATH(FULLPATH("","")),"Prg2Bin",,,,,,,,,FULLPATH("","")+"foxbin2prg_self.cfg"
BUILD PROJECT FoxBin2Prg.exe FROM FoxBin2Prg.pjx RECOMPILE
CD Fb2P_Diff
BUILD PROJECT Fb2P_Diff.exe FROM Fb2P_Diff.pjx RECOMPILE
COPY FILE Fb2P_Diff.exe TO ..\Fb2P_Diff.exe
CD ..\FileName_Caps
BUILD PROJECT FileName_Caps.exe FROM FileName_Caps.pjx RECOMPILE
COPY FILE FileName_Caps.exe TO ..\FileName_Caps.exe
CD ..

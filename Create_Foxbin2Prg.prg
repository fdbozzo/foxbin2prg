*Create config templates
DO FoxBin2Prg.prg WITH "-c","foxbin2prg.cfg.txt",FULLPATH("Create_FoxBin2Prg.cfg","")
DO FoxBin2Prg.prg WITH "-t","foxbin2prg.dbf.cfg.txt",FULLPATH("Create_FoxBin2Prg.cfg","")

*create binaries 
DO FOXBIN2PRG.PRG WITH JUSTPATH(FULLPATH("","")),"Bin2Prg",,,,,,,,,FULLPATH("Create_FoxBin2Prg.cfg","")

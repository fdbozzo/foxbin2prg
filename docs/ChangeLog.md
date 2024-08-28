# FoxBin2Prg Change log
Documentation of FoxBin2Prg - A Binary to Text converter for MS Visual Foxpro 9

## Purpose of this document
List of Changes, Bugfixes and modifications.

For settings, API and other realted stuff see [Internals](./FoxBin2Prg_Internals.md).

The original document was created by [Fernando D. Bozzo](https://github.com/fdbozzo) whom I like to thank for the great project.   
Pictures are taken from the original project.  
As far as possible these are the original documents. Changes are added where functionality is changed.

----
## Table of contents
- [Remark](#remark)
- [Full Change History](#full-change-history)

For recent verisons see 
![Picture](./pictures/FoxBin2Prg_Full_Change_History_vfpxreleasesmall.png) [FoxBin2PRG](https://github.com/fdbozzo/foxbin2prg)   

## Full Change History
This page is not only to get the history of the changes, but to keep a permanent list of people that have contributed to enhance FoxBin2Prg and that I feel as part of the ADN of this tool.

It's my way of thanking them for their contribution.

_**Note:** you can click on the version number for downloading this version from GitHub, or you can get all the code history directly from the GitHub repository, which is more easy to search._

| Rel.Date | Developer | Version | Details |
| - | - | - | - |
| 2024/08/26 | DHennig | v1.21.04 | **Enhancement**: Added support for BodyDevInfo = 2 in CFG file to prevent both DevInfo and ObjRev from being written to PJ2 file |
| 2024/04/24 | LScheffler | [v1.21.03](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.21.03) | **Bug Fix**: Text To Bin with Fieldcaption = "NULL" (misnomer. it's the field name); #106; #106 (griessbach14943) |
| 2024/01/03 | LScheffler | [v1.21.02](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.21.02) | **Bug Fix**: Problems regenerating single classes and forms from text files in class-per-file form; #105 (LScheffler) |
| 2023/11/19 | LScheffler | [v1.21.01](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.21.01) | **Enhancement**: Source files not longer included in Thor. The file you will found are old and will be removed with subsequent installs. (LScheffler) |
| 2023/11/19 | LScheffler | [v1.21.01](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.21.01) | **Bug Fix**: Problems regenerating databases with splited contents due to the removed Spanish characters in comment. (LScheffler) |
| 2023/10/20 | LScheffler | [v1.21.00](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.21.00) | **Bug Fix**: Problems with Spanish characters in comment. (ccantrell72) |
| 2023/09/06 | LScheffler | [v1.20.07](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.20.07) | **Enhancement**: Option to block processing of directories. If file ".FoxBin2Prg_Ignore" is existing, this directories and all subdirectries will be ignored. (Mainly set up to ignore local GoFish settings) (LScheffler) |
| 2023/09/06 | LScheffler | [v1.20.06](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.20.06) | **Bug Fix**: Problems recreating tables (LScheffler) |
| 2023/09/03 | LScheffler | [v1.20.05](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.20.05) | **Bug Fix**: Problems recreating menu files (introduced with codepage) (LScheffler) |
| | | | **Enhancement:** Inserted options to allow splitting of SCX handling from VCX. |
| 2023/09/01 | LScheffler | [v1.20.04](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.20.04) | **Enhancement**: New option "tcDebug" for get_DirSettings method. |
| | | | **Enhancement:** For better clearance, renamed setting AllowInheritance to InhibitInheritance. |
| | | | **Enhancement:** The debug option set via parameter has precedence over value from config file. |
| | | | **Enhancement:** For debug option set via parameter only first valid call is used. |
| 2023/08/31 | LScheffler | [v1.20.03](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.20.03) | **Enhancement**: New option "tcCFG_File" for get_DirSettings method. |
| 2023/08/31 | LScheffler | [v1.20.02](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.20.02) | New option for parameter set config file to control the use of "regular" config files enhanced |
| 2023/08/30 | LScheffler | [v1.20.01](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.20.01) | **Bug Fix**: Some values of config file would not be read, if the inline comment "&&" was not in the line (LScheffler) |
| | | | **Bug Fix**: Bug Fix: config file set by parameter would be ignored, if the folder contains FoxBin2Prg.cfg (LScheffler) |
| | | | **Bug Fix**: Bug Fix: Fixed problems with table config files (LScheffler) |
| | | | **Enhancement**: For config file template new options to set config file and debug added |
| | | | **Enhancement**: New option for parameter set config file to control the use of "regular" config files |
| 2023/08/27 | LScheffler | [v1.20.00](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.20.00) | **Enhancement**: Source now ships without binary source files. See [README.md](../README.md) how to regenerate. |
| 2023/08/26 | LScheffler | [v1.20.00](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.20.00) | **Bug Fix**: Issues with form charsets ( national letters in form and controls Caption field) (KestasL) <br /> This fixes also: Forms with ole controls conversion error (also: any vcx) #95 (KestasL) |
| | | | **Enhancement**: Added option to return version number |
| | | | **Bug Fix**: Bug Fix: codepage is lost on recreation, issue #96, fixes issue #95 (OLE) as well (KestasL) |
| | | | Since all files will be rewritten due to the codepage stored, it's a good time to change version number too. |
| 2023/03/20 | LScheffler | [v1.19.78](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.78) | **Enhancement**: Text2Bin on PJX errors out for projects with an attach icon that has a drive letter on its path. #93 (ericbarte) |
|  |  |  | **Enhancement**: Documentation enhanced |
| 2023/03/16 | LScheffler | [v1.19.77](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.77) | **Bug Fix**: Bin2Txt Operation on VCX loses leading spaces in Property Values #90  (JoergSchneider) |
|  |  |  | **Bug Fix**: Txt2Bin Operation on VCX looses double ampersand in Property Values #91 (LScheffler) |
| 2022/11/09 | LScheffler | Docu | **Enhancement**: Documentation for git on handling line endings |
| 2022/06/13 | LScheffler | [v1.19.76](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.76) | **Bug Fix**: On operation per folder, change of folder must change configuration (JoergSchneider) |
| 2022/06/08 | LScheffler | [v1.19.75](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.75) | **Bug Fix**: Multiple text2bin and bin2text conversion on MNX causes space grow (JoergSchneider) |
|  |  |  | **Enhancement**: Typo in German (JoergSchneider) |
| 2022/05/13 | bjornhoeksel | [v1.19.74](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.74) | **Bug Fix**: Fix menu bars with shortcuts keys like KEY F6, "F6"; are lost. (DanLauer) |
| 2022/04/08 | LScheffler | [v1.19.73](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.73) | **Bug Fix**: Problem converting trailing spaces on line end in memo (again) (bjornhoeksel) |
| 2022/04/07 | LScheffler | [v1.19.72](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.72) | **Bug Fix**: Problem converting trailing spaces on line end in memo (bjornhoeksel) |
|  |  |  | **Bug Fix**: Problem converting intentionally trailing spaces to VarChar/VarBinary (LScheffler) |
|  |  |  | **Bug Fix**: Bug Fix: Problem on using "DBF_Conversion_Support" on table configuration file (LScheffler) |
|  |  |  | **Enhancement**: Documentation in config file enhanced |
|  |  |  | **Enhancement**: Added parameter "?" to show interactive help ("interactive" still works) |
| 2022/03/30 | bjornhoeksel | [v1.19.71](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.71) | **Bug Fix**: Convert menu mn2 to mnx with skip for that contains a string with ; sign is missing part after that sign in mnx. (bjornhoeksel) |
| 2022/03/16 | LScheffler | [v1.19.70](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.70) | **Bug Fix**: Last bar in menu files are in some situations not converted correctly back in the mnx file. (bjornhoeksel) |
| | | | **Enhancement**: Buglist internal of FoxBin2Prg reordered |
| | | | **Enhancement**: Enhancement to documentation |
| 2022/02/25 | LScheffler | [v1.19.69](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.69) | **Bug Fix**: Missing class when building text file from corrupted VCX (bjornhoeksel) |
| 2022/02/23 | LScheffler | [v1.19.69](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.69) | **Bug Fix**: Recreating a class while an object with same name exists in VCX fails (bjornhoeksel) |
| | | | **Enhancement**: Template configuration files FOXBIN2PRG.DBF.TXT and FOXBIN2PRG.DBF.CFG.TXT in English |
| | | | **Enhancement**: Examples and template for config files enhanced |
| | | | **Enhancement**: Notice in contribution file to creating files above in English |
| | | | **Enhancement**: Started reworking double documentation |
| 2022/01/18 | LScheffler | [v1.19.68](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.68) | **Bug Fix**: Converting MN2 to MNX ignores the programmer-defined "Pad Name" found in "Prompt Options" screen (Jimrnelson) |
| | | | **Enhancement**: Minor links in readme.html |
| 2021/08/20 | LScheffler | [v1.19.67](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.67) | **Bug Fix**: Double classes in VCX (LScheffler) |
| | | | **Enhancement**: Templates and documentation for config files reworked |
| 2021/08/20 | LScheffler | [v1.19.66](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.66) | **Bug Fix**: Incorrect version showing for v1.19.65 (siara-cc) |
| | | | **Enhancement**: Incorrect links on documentation (siara-cc) |
| 2021/05/20 | LScheffler | [v1.19.65](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.65) | **Bug Fix**: Parameters -cCt not working from command line. (LScheffler) |
| 2021/04/22 | LScheffler | [v1.19.64](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.64) | **Bug Fix**: onverting MN2 to MNX ignores the programmer-defined bar # found in "Prompt Options" screen. (Jimrnelson) |
| | | | **Bug Fix**: Converting MN2 to MNX ignores the programmer-defined Pad Name found in "Prompt Options" screen. (LScheffler) |
| 2021/04/12 | LScheffler | [v1.19.63](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.63) | **Bug Fix**: Tables without indexes cause an error that the __Table ## is not marked as belonging to the ## database.__ (jstagerGH) |
| 2021/03/30 | LScheffler | [v1.19.62](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.62) | **Enhancement**: Debug logging, level of config file. |
| | | | **Bug Fix**: *_Conversion_Support options not read from config file. |
| | | | **Bug Fix**: Extension shift options not read from config file. (Sergej s-s-a) |
| | | | **Bug Fix**: RedirectFilePerDBCToMain option was defined wrong in configuration example |
| 2021/03/23 | LScheffler | [v1.19.61](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.61) | **Bug Fix**: Missnamed property. |
| 2021/03/22 | LScheffler | [v1.19.60](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.60) | **Enhancement**: FoxBin2Prg template and debug output: Completed and ordered, order synched, grouped and groups named at template. |
| | | | **Enhancement**: Option BackgroundImage was read, but not in template |
| | | | **Enhancement**: -cC options learned to create default FoxBin2Prg._cfg file |
| | | | **Enhancement**: -t Option learned to create default  \<tablename\>._cfg file, if table is open. |
| | | | **Enhancement**: Handling of additional non structural index per DBF in Bin2Text and Text2Bin. See [Config per DBF](./FoxBin2Prg_Internals.md#configuration-per-table). |
| | | | **Enhancement**: Debug-Logging for Index |
| | | | **Bug Fix**: DBF_Conversion_Condition was read, but never used |
| | | | **Bug Fix**: DBF_Conversion_Order sets an index that later would be stored as structural index |
| | | | **Bug Fix**: config options with text value fail, if line comment is set |
| | | | **Bug Fix**: issue #53 Variable lnFileCount in get_filesfromdirectory (msueping) |
| 2021/03/09 | LScheffler | v1.19.59 | **Feature**: Logging of settings as settings object passed to execute method (Option debug > 0) |
| | | | **Feature**: Added option to create config file template based on current values of a directory |
| | | | **Bug Fix**: RedirectClassType = 2, Path was set wrong in special config |
| | | | **Bug Fix**: RedirectClassType = 2, UseClassPerFile = 2 failed |
| | | | **Doc**: Improved, Better description of ClassPerFileCheck, tcOutputFolder. |
| 2021/03/04 | Doug Hennig | [v1.19.58](https://github.com/fdbozzo/foxbin2prg/releases/tag/v1.19.58) | **Feature**: Added support for writing to a different folder than the source code using a new tcOutputFolder parameter |
| | | | **Feature**: Added a configuration option: HomeDir, which determines if HomeDir is saved in PJ2 files (the default is 1 for Yes) |
| 2021/03/05 | LScheffler | v1.19.57 | **Bug Fix**: RedirectClassType = 2 mixed up PATH |
| | | | **Doc**: Improved |
| 2021/03/04 | LScheffler | v1.19.56 | **Feature**: New value 2 for option RedirectClassType = 2, just process the single class for input in form file[.baseclass].class.vc2 |
| | | | **Bug Fix**:<br>Inputfile in form classlib.class.vc2 AND RedirectClassType = 1  and Execute param tcRecompile = 1<br>generates classlib.class.vcx and tries to recompile classlib.vcx<br>fails silent if classlib.vcx exists (compiles wrong lib), with message if not. |
| 2021/03/03 | LScheffler | v1.19.55 | **Doc**: Documentation from CodePlex integrated |
| | | | **Feature**: added option to create config file template |
| | | | **Doc**: Info screen-doc improved |
| | | | **Doc**: German translation improved |
| 2021/03/03 | LScheffler | v1.19.54 | **Bug Fix**: DBF_Conversion_Condition, problem with macro expansion |
| 2021/02/20 | LScheffler | | **Feature**: inserted option DBF_IncludeDeleted to allow including deleted records of DBF |
| 2021/02/19 | LScheffler | | **Feature**: inserted option DBF_BinChar_Base64 to allow processing of NoCPTrans fields in non base64 way |
| 2021/02/15 | LScheffler | | **Feature**: inserted option ItemPerDBCCheck to split DBC processing from vcx / scx |
| | | | **Feature**: inserted option RedirectFilePerDBCToMain to split DBC processing from vcx / scx |
| 2021/02/14 | LScheffler | | **Feature**: inserted option UseFilesPerDBC to split DBC processing from vcx / scx |
| 2021/02/23 | LScheffler | v1.19.53 | **Doc**: For Info screen  and config-template, usage of MEM and FRX added |
| | | | **Bug Fix**: conversion prg -> vcx, files per class could create one class multiple times |
| 2021/02/15 | | | **Bug Fix**: processing directory, flush log file after loop instead of file |
| 2021/02/14 | LScheffler | v1.19.52 | **Bug Fix**: conversion prg -> dbf, fields with .NULL. value are incorectly recreated |
| | | | **Doc**: minor translations |
| | | | **Bug Fix**: conversion dbf -> prg, error if only test mode (toFoxBin2Prg.l_ProcessFiles is false) |
| 2020/04/01 | FDBOZZO | [v1.19.51.6](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.51.6) | Add some fixes to existent ut_tests |
| | | | **Bug Fix**: At least one of the class-per-file files do not have CR_LF at the end, then when assembling the class or form some structures (ENDIF/ENDCASE/ENDDEF/etc) can be joined with the next, making them erroneous (Ryan Harris) |
| | | | **Bug Fix**: Incompatible with VFPA (#36) (Eric Selje) |
| | | | **Bug Fix**: DBF conversion fails if some field name is a reserved keyword like UNIQUE (DAJU78) |
| | | | **Bug Fix**: VCX/SCX properties named "note" are not properly converted (Tracy Pearson) |
| | DH | |  **Bug Fix**: Manejo de AutoIncrement incompatible con Project Explorer (Dan Lauer) [Fixed by Doug Hennig] |
| 2019/02/24 | FDBOZZO | [v1.19.51.5](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.51.5) | **Feature**: Issue#32  Make FoxBin2Prg more COM friendly when using ESC key (Tracy Pearson) |
| 2018/07/31 | FDBOZZO | [v1.19.51.4](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.51.4) | **Bug Fix**: Issue#26  The alphabetic ordering of ADD OBJECT's objects can cause that some objects be created in erroneous order, causing unexpected behavior (Jochen Kauz) |
| 2018/07/09 | FDBOZZO | [v1.19.51.3](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.51.3) | **Bug Fix**: Error 1098, Cannot find ... [ENDT] that closes ... [TEXT] Issue#26 when there is a field named TEXT as first line-word (KIRIDES) |
| 2018/06/20 | FDBOZZO | [v1.19.51.2](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.51.2) | **Bug Fix**: When converting to text a DBF that belongs to a DBC with events disabled, conversion fails (Jairo Argüelles / Juan C. Perdomo) |
| 2018/05/12 | FDBOZZO | [v1.19.51.1](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.51.1) | **Bug Fix**: If capitalization is used on a DBC view info, then related information is not exported correctly or entirely, so could be lost (SkySurfer1) |
| 2018/03/26 | FDBOZZO | [v1.19.51](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.51) | Add LOG info about config.fpw used and CodePage |
| | | | Enhanced HELP dialog info when running FoxBin2Prg with double-click |
| | | | **Feature**: FKY file structure support (MACRO file exporting only to text fk2) |
| | | | **Feature**: MEM file structure support (MEMORY file exporting only to text me2) |
| | | | **Feature**: Added automatic default language recognition for the supported ones (FR,DE,ES,EN) |
| 2018/03/15 | FDBOZZO | [v1.19.50.3](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.50.3) | **Bug Fix**: When adding some non-VFP text files like html,css,etc, in the text section of the project, FoxBin2Prg does not keep this selection when regenerating the PJX, leaving them in the files section (Darko Kezic) |
| 2018/03/13 | FDBOZZO | [v1.19.50.2](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.50.2) | **Bug Fix**: Regenerating pjm,"*" when CFG's extension:pj2=pjm does not regenerate all pjx included files (Darko Kezic) |
| 2018/03/12 | FDBOZZO | [v1.19.50.1](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.50.1) | **Bug Fix**: When using the CFG configuration "extension: pj2=pjm" treat the pjm as pj2 and not as SourceSafe-compatible pjm (Darko Kezic) |
| 2018/03/06 | FDBOZZO | [v1.19.50](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.50) | Added a new CFG "BodyDevInfo" switch to control the DevInfo body data of PJX. It is disabled by default because DevInfo normally have compiled data that can be regenerated and causes many differences on source control tools |
| | | | New PRG_Compat_Level CFG value to make generated SC2/VC2 code more PRG compatible |
| | | | **Bug Fix**: PJX homedir related fields do not always are sincronized |
| | | | Workaround to export DBF metadata without the security part of the DBC blocking it, when DBCEvents are enabled. |
| 2018/02/03 | FDBOZZO | [v1.19.49.8](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.49.8) | **Bug Fix**: When converting a VCX corrupted with duplicated objects to text, "The specified key already exists" error is thrown (Kirides) |
| 2018/01/11 | FDBOZZO | [v1.19.49.7](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.49.7) | **Bug Fix**: When converting a DBF an error is thrown if there is a field called X or I (Francisco Prieto) |
| 2018/01/04 | FDBOZZO | [v1.19.49.6](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.49.6) | **BugFix vcx/scx**: FoxBin2Prg should ignore the records that VFP Designer ignores (Doug Hennig / https://github.com/fdbozzo/foxbin2prg/issues/15) |
| | | | **BugFix vcx/scx**: FoxBin2Prg encodes MemberData property with CR/LF, which can cause "property '_memberdata' value is too long" error (Doug Hennig / https://github.com/fdbozzo/foxbin2prg/issues/16) |
| 2017/12/20 | FDBOZZO | [v1.19.49.5](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.49.5) | **BugFix DBF**: When FoxBin2PRG converts a DB2 file to a DBF file and imports the data (using DBF_Conversion_Support = 8), tabs at the start of lines in memo fields are lost (Doug Hennig / https://github.com/fdbozzo/foxbin2prg/issues/13) |
| 2017/12/04 | FDBOZZO | [v1.19.49.4](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.49.4) | **Bug Fix VCX**: When using ClassPerFile in API Mode and importing single classes, sometimes their names get unquoted, throwing errors / Reported by Lutz Scheffler (https://github.com/fdbozzo/foxbin2prg/issues/11) |
| 2017/12/03 | FDBOZZO | [v1.19.49.3](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.49.3) | **Bug Fix**: "Double" field types are explicitly defined with 0 decimals when no decimals are defined (Jerry Stager) |
| 2017/12/03 | FDBOZZO | [v1.19.49.2](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.49.2) | **Bug Fix**: ClassPerFile export didn't work correctly starting from v1.19.49 / Reported by Lutz Scheffler (https://github.com/fdbozzo/foxbin2prg/issues/9) |
| 2017/06/25 | FDBOZZO | [v1.19.49.1](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.49.1) | **Bug Fix**: DEVINFO field is only used when doing PJX conversions. On other files throw errors |
| 2017/04/26 | FDBOZZO | [v1.19.49](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.49) | Replace Scripting.FileSystemObject MoveFile with Win32API equivalent |
| | | | Added support for using temporal CFG file for low-level API operations |
| | | | **Bug Fix**: Single-class export with "classlib.vcx::classname" syntax did not export (Lutz Scheffler) |
| | | | Added single-class import support ("library.vcx::classname::import") |
| | | | Added new single-class export syntax ("library.vcx::classname::export") |
| | | | Both single-class syntaxes doesn't require a CFG configuration |
| | | | **Bug Fix**: Partially corrupted frx/lbx info generated when using "&&" string inside field expressions (Alejandro A Sosa) |
| | | | sys(2023) secure temp: When sys(2023) points to "program files", then getenv("temp") is used |
| | | | Add more options to config.fpw to minimize interference from existent configs |
| | | | **Feature**: Save the contents of User field (Doug Hennig). Note: DevInfo is already supported |
| 2016/07/24 | FDBOZZO | [v1.19.48](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.48) | **Bug Fix**: ControlSource of OLE Objects containing quotes are not well regenerated from FR2 (Nathan Brown) |
| | FDBOZZO | Preview-5 | **Bug Fix**: When a binary is regenerated from a PJ2 file containing files with parenthesis and spaces, the error "Error 36, Command contains unrecognized phrase/keyword" occurs (Nathan Brown) |
| | FDBOZZO | Preview-4 | **Defect Fix**: When fixing the multi-line memo bug, introduced a new defect on which a single-line memo is not decoded correctly (Nathan Brown)  |
| | FDBOZZO | Preview-3 | **Bug Fix**: Bug Fix db2: When reading a miltuline-memo with old db2 data, an index out of range error occurs  |
| | FDBOZZO || **Bug Fix** db2: When using ExcludeDBFAutoincNextval: 1 setting in FoxBin2Prg.cfg and at the same time the data import with an AutoInc field, then error "Error 2088, Field <FIELD> is read-only" occurs (Nathan Brown)  |
|| FDBOZZO | Preview-2 | **Bug Fix**: DBF conversion restrictions are not always respected when using particular CFGs for DBFs (Nathan Brown)  |
|| AndyGK63 | Preview-1 | **Bug Fix**: Error message 'variable tcOutputFile not found' (german version) (Andy Kasper)  |
|| AndyGK63 || **Bug Fix**: Menu location 'Before' always changed to 'after' when convert (Andy Kasper)  |
| 2016/06/09 | FDBOZZO | [v1.19.47](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.47) | **Bug Fix**: Added multi-line support for memo data when importing/exporting  |
|| FDBOZZO || **Feature**: Added support for appending data from DB2 to DBF with the new value DBFConversionSupport=8. All datatypes except General. (Walter Nicholls)  |
|| DougHennig || **Bug Fix**: Added variable declaration in vbs scripy (Doug Hennig)  |
|| DougHennig || **Bug Fix**: Fixed incorrectly named variable in vbs script (Doug Hennig)  |
|| DougHennig || **Bug Fix**: Added missing assignment in vbs script (Doug Hennig)  |
|| DougHennig || **Enhancement**: Put double quotes around path in case in contains single quote in vbs scripts (Doug Hennig)  |
|| FDBOZZO || **Bug Fix**: Added "+16" to Debug flags to maintain internal defaults to not generate timestamps on xx2 files in vbs scripts  |
|| FDBOZZO || **Bug Fix**: When a filename "\*" is specified with a type "\*", an automatic regeneration of all binary files is made from text files (Alejandro Sosa)  |
| 2016/02/07 | FDBOZZO | [v1.19.46](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.46) | **Bug Fix**: set\_UserValue() method causes error when trying to get information about another error and the VFP binary table can not be opened (ie, because corrupted memo)  |
|||| **Feature**: Added internal support for querying directory cfg information, with a new optional parameter, for API methods that require it (ie: get\_Ext2FromExt, hasSupport\*)  |
|||| **Feature**: Convert FUNCTION to PROCEDURE for maintaining compatibility with the way that VFP save methods on binaries  |
|||| **New fb2p\_diff.exe**: Allow a quick Diff of VFP9 binaries, for those that don't need converting to text manually  |
|||| **Bug Fix**: When processing a directory or a project with all the files, sometimes an "Alias already in use" error may occur (Dave Crozier)  |
|||| **Bug Fix mnx**: When menu options contains '&&' in their texts, menu binary is corrupted when regenerated (Walter Nichols)  |
|||| **Bug Fix fb2p\_diff.exe**: When calling fb2p\_diff.exe from a directory out of FoxBin2Prg dir, an error is thrown because FoxBin2Prg is not found (Mike Potjer)  |
|||| **Feature**: In some environments and under some conditions WSscript.Shell object can cause problems, so now it's replaced with Win32 native functions (Aurélien Dellieux)  |
|||| **Bug Fix frx/lbx**: Ordering of report objects changes the ZOrder of near objects that can overlap, which can cause bad visualization and printing (Ryan Harris)  |
|||| **Bug Fix frx/lbx**: When regenerating reports or labels with multiline texts center or right aligned, alignment is not completely right (Ryan Harris)  |
|||| **Bug Fix frx/lbx**: When grouping objects in design mode, generating text and regenerating binary cause the lost of the grouping (does not affect data) (Lutz Scheffler)  |
|| RALFXWAGNER || **Bug Fix Pjx**: SPR and MPR files are not correctly identified in the PJX Project info (Ralf Wagner)  |
|||| **Bug Fix Pj2**: An error is thrown when regenerating a PJX from a PJ2 when some file have parenthesis in it's name (EddieC)  |
|||| **Feature (dbf)**: New ExcludeDBFAutoincNextval parameter for minimizing DB2 differences (edyshor)  |
|||| **Bug Fix**: When processing a file on root dir, a 2062 error occurs (Aurélien Dellieux)  |
| 2015/06/21 | FDBOZZO | [v1.19.45](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.45) | **Bug Fix mnx**: When a menu that uses single quotes or an expression in the option's MESSAGE is exported to text, when regenerating the menu from the text there are parts of the message that are cut off (Mike Potjer)  |
|||| **Bug Fix**: When processing multiple PJ2 files, an error "variable llError not defined" can occur (Lutz Scheffler)  |
|||| **Bug Fix pjx/pj2**: PJX/PJ2 projects that references files from other disk units throw errors for those files when processing with "\*" or "\*-" options (Matt Slay)  |
|||| **Bug Fix**: When processing multiple-files, sometimes encountered errores are not reported  |
|||| **Feature (API-PJX)**: New loadModule() method that returns the internal FoxBin2Prg Project object when the full name of an existent project file is specified  |
|||| **Feature (API-PJX)**: New getFilesNotFound() method for the FoxBin2Prg's Project object, that returns the count of files referenced in the project that are not found on disk and an array with all the existence state of each file  |
| 2015/05/31 | FDBOZZO | [v1.19.44](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.44) | **Bug Fix**: In certain PCs FoxBin2Prg does not return error codes when called from an external program, so another terminating method is implemented (Ralf Wagner)  |
|||| **Feature**: Allow exporting DBF data when using DBF\_Conversion\_Support:1 and optional individual CFG files  |
|||| **Bug Fix**: A previous bug fix on cascading errors management caused reseting the error status, making that sometimes errors don't get reported  |
| 2015/05/10 | FDBOZZO | [v1.19.43](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.43) | **Feature**: Added new CFG setting "RemoveZOrderSetFromProps" for removing ZOrderSet property when you want to maintain the original class ZOrder always, avoid unnecesary differences and fix some visual on top/on bottom control problems (Ryan Harris)  |
|||| **Feature**: Do not allow progressbar window become the default output window of ? command (Lutz Scheffler)  |
|||| **Bug Fix**: Fixed VFP9 SP1 validation message  |
|||| **Bug Fix**: FoxBin2Prg PRG2BIN does not return error codes (Ralf Wagner)  |
|||| **Bug Fix**: FoxBin2Prg sometimes generates an OLE error when executed for second time on a file with problems (Fidel Charny)  |
|||| Some enhancements in security of DLL declarations and On Escape management  |
|||| **Defect Fix**: Accesing DataSessionID property throws an error because of the change of internal classes between custom and session  |
|||| **Bug Fix**: When a form have AutoCenter=.T., there are times that when regenerating the binary and executing it does not shows centered (Esteban Herrero)  |
| 2015/04/16 | FDBOZZO | [v1.19.42](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.42) | **Feature**: Added VFP 9 SP1 runtime validation  |
|||| **Bug Fix**: Broken SourceSafe compatibility because an error is thrown when querying for file support (Tuvia Vinitsky)  |
|||| **Bug Fix scx/vcx**: Process only one TEXT/ENDTEXT nesting level because TEXT/ENDTEXT can't be nested (Lutz Scheffler)  |
|||| **Feature**: Make some error descriptions more informative and precise (Lutz Scheffler)  |
|||| **Feature (API)**: Allow specifying inputFile with relative path (Lutz Scheffler)  |
|||| **Bug Fix scx**: Metadata of Dataenvironment not properly generated when Dataenvironment is renamed  |
|||| **Bug Fix**: Added PJX/PJ2 generation when specifying "file.pjx", "\*" (Lutz Scheffler)  |
|||| Some enhancements in german translations (Lutz Scheffler)  |
|||| **Feature**: Added multiprocessing of projects (\*.pjx, \*.pj2) when specifying "file.pjx", "\*" (Lutz Scheffler)  |
|||| Change FoxBin2Prg base class from custom to session (Lutz Scheffler)  |
|||| **Feature**: Allow processing all project files without converting the PJX/2, with "\*-" (Lutz Scheffler)  |
|||| **Bug Fix pjx/pj2**: If end of line (CR+LF) is used on pjx's "Build" properties data, generated pj2 is malformed  |
|||| **Feature**: Default foxbin2prg.cfg configuration file renamed to foxbin2prg.cfg.txt to no overwrite user cfg (Lutz Scheffler)  |
|||| **Feature**: Added DOS errOut output support and implemented in writeErrorLog when logging errors  |
|||| **Feature**: Added full support for \*? file masks for multi-processing files of the same extension  |
|||| **Feature (API)**: Added new parameter to allow alternative main CFG (Lutz Scheffler)  |
|||| **Feature (API)**: Added new get\_Processed() method for obtaining information about processed files (Lutz Scheffler)  |
|||| **Feature**: Added new file processing output to DOS stdOut (Lutz Scheffler)  |
|||| **Bug Fix**: Fixed processing cancelation with Esc key  |
|||| **Feature**: Sort table/view fields alphabetically to facilitate diffing and merging, while maintaining a list with the original field order for correct DBC regeneration (Ryan Harris)  |
|||| **Feature**: Apply ClassPerFile to DBC connections, tables, views and SPs (Ryan Harris)  |
|||| **Bug Fix mnx**: Empty Pad name is not kept when regenerating a menu defined with and empty Pad name (Lutz Scheffler)  |
|||| **Feature (API)**: New property "lProcessFiles" that allow setting to .F. when using foxbin2prg as object to get Processing file info with getProcessed method without actual processing  |
|||| **Bug Fix frx/lbx**: Trimmed some extra CR,LF,TAB from FR2/LB2 tag that where included in previous versions (Ryan Harris)  |
|||| **Bug Fix scx/vcx/dbc**: Delete ERR files when processing with UseClassPerFile switch (Ryan Harris)  |
|||| **Feature**: Implemented CFG inheritance between directories  |
|||| **Feature (API)**: New method get\_DirSettings() that returns the CFG settings object for the indicated directory (Lutz Scheffler)  |
|||| **Feature**: Allow generation of text for a single class of a librery when using ClassPerFile (Lutz Scheffler)  |
|||| **Feature (API)**: Renowned method names to English to facilitate international understanding (Mike Potjer)  |
| 2015/01/18 | FDBOZZO | [v1.19.41](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.41) | **Bug Fix db2**: Erroneous detection of Invalid Table when size is less than 328 bytes. Lower limit was changed to 65 bytes.  |
|||| **Bug Fix vcx/scx**: Erroneous detection of PROCEDURE/ENDPROC structures when used as parameters of LPARAMETERS and start in new line (Ryan Harris)  |
| 2015/01/11 | FDBOZZO | [v1.19.40](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.40) | **Enhancement frx/lbx**: Clean ASCII 0 from expression field for Dataenvironment, Cursors and Relations  |
|||| **Bug fix frx/lbx**: When using Dataenvironment with more than one cursor, remaining cursors are lost  |
|||| **Feature**: Added new configuration "ShowProgressbar:2" to activate the progressbar only when a directory is selected and deactivate it for individual files (Jim Nelson)  |
|||| **Bug fix dbf**: Error 12, variable "tcOutputFile" is not found when DBFConversionSupport=4 and output file is the same as existent one (Mike Potjer)  |
|||| **Feature scx/vcx/sc2/vc2**: Added new code checking to find duplicated object names for the same class and container to notify those cases of file corruption  |
|||| **Bug Fix**: "Error 2183: Operation requires that SET MULTILOCKS is set to ON" in some DBF convertions  |
| 2015/01/01 | FDBOZZO | [v1.19.39](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.39) | **Bug fix vbs**: vbs scripts does not show FoxBin2Prg process errors correctly  |
|||| When using BIN2PRG or PRG2BIN keywords with FoxBin2Prg command line, allow processing one file (Mike Potjer)  |
|||| Add keyword SHOWMSG and use INTERACTIVE keyword for an interactive dialog (Mike Potjer)  |
|||| When processing a directory from commandline with foxbin2prg alone and the INTERACTIVE keyword, show a dialog to ask what to process (Mike Potjer)  |
|||| **Bug fix dc2**: DisplayClass and DisplayClassLibrary values got the wrong value "Default" and not the corresponding own values (Christopher Kurth/Ryan Harris)  |
|||| Deleted recompilation scripts for language, because it is an automatic selection now  |
| 2014/12/13 | FDBOZZO | [v1.19.38](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.38) | **Feature**: Now is possible to use FoxBin2Prg for batch conversions directly from the File Explorer (see README.txt), without the need of vbs scripts, that sometimes can make trouble or are not permitted by IT department (Francisco Prieto)  |
|||| **Feature**: Enhanced Multilanguage support by 3 ways: 1-Automatic DEFAULT (depending on VERSION(3)); 2-By parameter, using the new method ChangeLanguage(); 3-Using the new setting "Language" in foxbin2prg.cfg  |
|||| **Feature**: Detection of duplicated methods on vc2/sc2 files to notify those cases of vcx/scx file corruption (Álvaro Castrillón)  |
| 2014/11/30 | FDBOZZO | [v1.19.37](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.37) | **Feature**: Added Class per file support, configurable with UseClassPerFile:1 (Ryan Harris/Lutz Scheffler/Álvaro Castrillón)  |
|||| **Feature**: foxbin2prg.cfg configuration options can now have "&&" comments at the right of the values (edyshor)  |
|||| **Feature**: Added support for the new "ClearDBFLastUpdate" setting in FoxBin2Prg.cfg, activated by default to minimize DB2 differences (edyshor)  |
|||| **Feature**: Enhanced progressbar indication, with more detailed information  |
|||| **Feature**: vcx/scx broken properties autofix because an erroneous manual user edition on the vcx/scx  |
|||| **Feature**: vcx/scx autofix por Hidden and Protected duplicated properties (some type of corruption or bad manual user edit)  |
|||| **Feature**: Added a validation for FRX to notify the user if it is not a VFP 9 REPORT  |
|||| **Feature**: Batch convertions can now be interrupted with the Esc key  |
|||| **Bug Fix dbf**: "Error 1903, String is too long to fit" when converting long DBF files with "DBFConversionSupport:4" to text (edyshor)  |
|||| **Bug Fix vcx/scx**: Sometimes some properties get the description of a similarly named property  |
|||| **Bug Fix vcx/scx**: Hidden and Protected properties are not ordered alphabetically  |
|||| Various Code Optimizations for enhancing processing performance  |
| 2014/10/08 | FDBOZZO | [v1.19.36](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.36) | **Bug fix mnx**: When generating mn2 text view, menu all pad IDs are generated as \_000000000 (bug introduced in v1.19.35)  |
|||| **Enhancement**: New "VFP9\_FoxBin2Prg.vbs" script for "SendTo" menu, that replaces FoxBin2Prg.exe in this menu and adds a process status message  |
| 2014/10/05 | FDBOZZO | [v1.19.35](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.35) | **Enhancement**: Always generate the same Timestamp and UniqueID for binaries, for minimizing differences when regenerating them (Marcio Gomez G.)  |
| 2014/09/19 | FDBOZZO | [v1.19.34](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.34) | **Bug Fix**: If run from VFP Command Window and there is a file in use, an error is thrown because can't capitalize source file (Jim Nelson)  |
| 2014/08/29 | FDBOZZO | [v1.19.33](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.33) | **Bug Fix mnx**: Menu doesn't generate well when there is a Bar of #BAR type without a name (Peter Hipp)  |
|||| **Bug Fix mnx**: If a menu option have an associated Procedure with 1 line of code, the Procedure is converted to Command (Peter Hipp)  |
| 2014/08/26 | FDBOZZO | [v1.19.32](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.32) | If exists a property called "text" it is confused with a text/endtext structure (Peter Hipp)  |
| 2014/08/22 | FDBOZZO | [v1.19.31](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.31) | Trash cleanup code on binary methods, normally added by tools like ReFox and others  |
|||| Added EXE version number when generating a debug LOG file  |
|||| Enhanced recognition of #IF..#ENDIF instructions when there are spaces between # symbol and the command name  |
|||| Added capitalization normalization for input files  |
|||| Added new c\_Language property for querying actual compiled language (EN,ES,DE,etc)  |
| 2014/08/10 | FDBOZZO | [v1.19.30](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.30) | **Bug Fix vcx/scx**: Bad EndText (from Text/EndText block) detection when the previous line ends with "," or ";" (Jim Nelson)  |
|||| Bug Fix vcx/scx: Some methods are not alphabetically sorted in some inheritance situations (Ryan Harris)  |
|||| Added FoxUnit test cases to bug fix confirmation of both  |
| 2014/08/01 | FDBOZZO | [v1.19.29](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.29) | **Bug Fix vcx/scx**: Bad Text (from Text/EndText block) detection when there is a line that begins with a "text" field and previous line end with "," in regards of ";" (M\_N\_M)  |
|||| Optimizations and refactoring  |
| 2014/07/26 | FDBOZZO | [v1.19.28](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.28) | **Feature**: Added new options in foxbin2prg.cfg (DBF_Conversion_Included, DBF_Conversion_Excluded) and in filename.dbf.cfg (DBF\_Conversion\_Order, DBF\_Conversion\_Condition) for exporting DBFs data to text when DBF_Conversion_Support is 4 (Edyshor)  |
| 2014/07/18 | DH/FDBOZZO | [v1.19.27](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.27) | **Feature**: Added support for exporting DBF data for DIFF when using DBF\_Conversion\_Support: 4 in foxbin2prg.cfg (It's intended just for DIFF small DBFs, as config ones, not for true Data export. Binary fields are not exported and there is not an Import Data feature) (Doug Hennig)  |
| 2014/07/06 | FDBOZZO | [v1.19.26](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.26) | **Feature**: Take out asterisks between "ENDPROC" and "PROCEDURE", analyzed in that exact order, to regenerate binary without errors. (Daniel Sánchez)  |
|||| **Feature**: Add the l\_DropNullCharsFromCode configuration option, enabled by default, to allow taking out NULLs from source code. (Matt Slay)  |
|||| **Bug Fix cfg**: ExtraBackupLevel does not work when using multi-configuration  |
| 2014/06/25 | FDBOZZO | [v1.19.25](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.25) | When processing one or multiple files with vbs scripts, show a message indicating the status of the generation, and show the error log if any error occurs (Pedro Gutiérrez M.)  |
|||| Code cleaning and normalization  |
|||| ClearUniqueID is True by default for tx2 files  |
|||| OptimizeByFilestamp is False by default, to avoid possible automatic modifications made by VFP when opening a form or a classlib  |
|||| New AllowMultiConfig switch enabled by default, that allow a foxbin2prg.CFG file per directory, overriding main CFG (Mario Peschke)  |
| 2014/06/15 | FDBOZZO | [v1.19.24](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.24) | **Bug Fix scx/vcx**: The absence of AGAIN keyword on some USE commands throws "tabla in use" error if used the PRG version from VFP command window (Matt Slay)  |
|||| **Bug Fix scx/vcx**: A table field called "text" that begins the line can be confused with the TEXT/ENDTEXT structure and can wrong recognize the rest of the code (Mario Peschke)  |
|||| **Bug Fix scx/vcx**: GetTimeStamp internal method throwse an error when day or month have just 1 digit (happen from v1.19.23)  |
|||| New "run\_aftercreate\_db2" event that permits execution of an external program when using FoxBin2Prg as object (for example, to export table data)  |
|||| New FoxUnit Unit Tests to verify new functionality and "text" bug fix  |
|||| Added foxbin2prg\_de.h file translation of most messages to German (Mario Peschke)  |
| 2014/06/07 | FDBOZZO | [v1.19.23](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.23) | Timestamps and UniqueIds values are back on binaries, and they are just cleaned up on tx2 files if NoTimestamps and ClearUniqueID flags are set. This minimizes some differences on the binary side  |
|||| Added sccdata default value when regenerating PJX binary (which is automatically completed on the PJX when opened anyway)  |
|||| Fixed timestamp evaluation for "OptimizeByFilestamp" optimization that evaluates just .??X files, and now .??T (memo) filestamps are evaluated too  |
|||| Fixed missing BorderColor property on props\_optiongroup.txt file  |
|||| Fixed missing Stretch property on props\_image.txt file (Kenny Vermassen)  |
|||| Fixed missing Enabled property on props\_image.txt file  |
| 2014/05/17 | FDBOZZO | [v1.19.22](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.22) | **Bug Fix vcx/scx**: Picture property of a form class does not show the image. Does not happen with control pictures (Fidel Charny)  |
|||| **Bug Fix scx/vcx**: Incorrect detection of PROCEDURE/ENDPROC/TEXT/ENDTEXT that can cause lost of some methods in some circunstantes (Andres Mendoza)  |
|||| **Bug Fix scx/vcx**: Some options from the optiongroup control loose there width when subclassed from a class with autosize=.T. (Miguel Duran)  |
|||| Added evaluation and generation of properties by classtype, when applicable  |
|||| Added support of property evaluation from external file (props\_\*.txt)  |
|||| Added enhanced Unit Tests of bitmap comparisons of screen captures before/after (the original is compared with the regenerated of the regenerated binary, for more accuracy)  |
|||| A lot of garbage collect optimizations all over the code  |
|||| Added Unit Testing of configuration by defaults, by file and by parameters  |
|||| Added Unit Testing for checking the generation of classes, forms, reports and menus  |
|||| Added new switch OptimizeByFilestamp (active by default) for making possible deactivation of this regeneration optimization by file timestamp, in case someone wants to force regeneration allways  |
| 2014/05/01 | FDBOZZO | [v1.19.21](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.21) | Added support to convert to text or binary all files of a project from pjx or pj2 (Matt Slay)  |
|||| Added optimization on the search of the capitalization program when processing projects  |
|||| Added keyword AGAIN on table openings, for enhancing concurrence (Jim Nelson)  |
|||| Added optimization based on file timestamps for regenerating only newer binaries and tx2 files (Matt Slay)  |
|||| Added English translation in foxbin2prg\_en.h for the LOG message of new timestamp optimization  |
|||| <DefinedPropArrayMethod> section simplification: Methods and arrays doesn't require preceding \* and ^ symbols anymore.  |
| 2014/04/17 | FDBOZZO | [v1.19.20](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.20) | **New**: CDX filename in DB2 files have relative paths now. This help show less differences when regenerating DB2 files from different paths  |
| 2014/04/02 | FDBOZZO | [v1.19.19](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.19) | **New**: DBF Hook run\_AfterCreateTable that let intercalate a personalized process between DBF creation and index creation when processing a DB2 file (example program in tests\demo\_hook\_dbf.prg included) (Fidel Charny)  |
| 2014/03/25 | FDBOZZO | [v1.19.18](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.18) | **Bug Fix vcx/scx**: Image controls with stretched icons or images, get redimensioned to original size when regenerating binary (Arturo Ramos)  |
|||| Bug Fix vcx/scx: Library level comments are not kept (Ryan Harris)  |
| 2014/03/16 | FDBOZZO | [v1.19.17](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.17) | **Bug Fix frx/lbx**: Double-quoted expressiones make fx2/lb2 files corrupt (Ryan Harris)  |
|||| **Bug Fix frx/lbx**: Multiline Comments are lost (Ryan Harris)  |
|||| **frx/lbx tag2 field enhance**: when used for tooltips, real values are shown in regards of b64 normal encoding  |
|||| **Bug Fix mnx**: Multiline Comments on Bars/Pads makes MN2 file corrupt (Ryan Harris)  |
|||| **Bug Fix mnx**: Some procedures doesn't generate correctly (Ryan Harris)  |
|||| English translation file foxbin2prg\_en.h syntax corrected (Ryan Harris)  |
|||| **Bug Fix vcx/scx**: Lowercase saved Dataenvironment property causes Reserved2 value to be not calculated  |
|||| **Bug Fix frx**: <CR> character on print condition on field makes fr2 file corrupt  |
|||| **Bug Fix mnx**: Using double-quotes on prompt option fields makes mn2 file invalid (Ryan Harris)  |
| 2014/03/10 | FDBOZZO | [v1.19.16](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.16) | **Bug Fix vcx/scx**: properties loose there hidden/protected visibility when no default value assigned (Ryan Harris)  |
|||| **Bug Fix vcx/scx**: character value with length >255 in addobject property regenerates with tag <fb2p\_value> included (Ryan Harris)  |
|||| **Bug Fix vcx/scx**: When regenerating binari file with empty procedure makes FoxPro crash when trying to modify it on IDE  |
|||| **Bug Fix scx/vcx**: Binary can be corrupted if the class have a multiline comment (Tested on: Ffc\\_frxcursor.vcx)  |
|||| **Bug Fix**: If \_memberdata contains CR inside there values, they can be lost when regenerating tx2 text files  |
|||| **Bug Fix**: Property values with spaces at the right loose this spaces  |
|||| **Bug Fix**: When 2 or more methods share the same name (ej: met and met2) tx2 text file gets corrupted (Ryan Harris)  |
| 2014/03/04 | FDBOZZO | [v1.19.15](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.15) | **Bug Fix**: OLE information cleared when a legacy TX2 is processed  |
|||| Bug Fix: Default value of NoTimestamp = 0 ==> Now is 1, as should be  |
|||| Bug Fix: DBFs backlink info cleared when DBC is recreated (Ryan Harris)  |
|||| Feature: Lowercase capitalization in tx2 filename headers to minimize differences  |
| 2014/03/01 | FDBOZZO | [v1.19.14](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.14) | Load of configuration is optimized (foxbin2prg.cfg) to read cfg only once for a massive processing of multiple conversions  |
|||| .vbs scripts have been modified to respect the conversion support configuration defined in foxbin2prg.cfg configuration file  |
|||| 2 new functions where added to enhance and encapsulate the external use of the evaluation of the conversion support (requires previous call to EvaluarConfiguracion()). Used on .vbs scripts  |
|||| ExtraBackupLevels Regression: when no defined value, no backup is made  |
|||| New default value ClearUniqueID = 1 in foxbin2prg.cfg for minimizing differences in the SCM  |
| 2014/02/26 | FDBOZZO | [v1.19.13](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.13) | **Bug Fix**: If NoTimestamp setting of foxbin2prg.cfg is changed, opposite value is evaluated (Ryan Harris)  |
|||| Encapsulated foxbin2prg.cfg file for enhancing FoxUnit automated testing  |
|||| Internal change of property l\_UseTimestamps by l\_NoTimestamps  |
|||| With ExtraBackupLevels setting you can now deactivate backups if setting to 0 (Ryan Harris proposal)  |
|||| foxbin2prg.log file checking dropped, to activate the log file use foxbin2prg.cfg setting Debug=1  |
|||| In TX2 header files show the file without path, because genereting it from different places makes unnecesary differences in Diff (Ryan Harris proposal)  |
|||| Created a lot of FoxUnit automated tests to check all settings of foxbin2prg.cfg configuration file  |
| 2014/02/23 | FDBOZZO | [v1.19.12](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.12) | Generation of VC2/SC2 with new header metadata <OBJECTDATA> for centralizing uniqueid, timestamp and ZOrder and big reduce of differences in a diff/merge (enhancement proposed by Ryan Harris)  |
|||| BINARY regeneration from the new metadata <OBJECTDATA> header (remains compatible with old VC2/SC2)  |
|||| FoxUnit test cases fixed for the new functionality  |
|||| Cleaning, Refactorization and optimization of Code  |
|||| Presentation enhancement of VC2/SC2 file headers  |
| 2014/02/13 | FDBOZZO | [v1.19.11](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.11) | WITH/ENDWITH optimizations with a conversion performance gain up to 16% more fast  |
|||| Bug Fix: Just one level of #IF was contemplated, throwing an error if more levels are nested  |
|||| Bug Fix: When regenerating the PJX, default home directory not always was correct  |
|||| New FoxUnit automated test added to check bug fix of nested #IF  |
| 2014/02/09 | FDBOZZO | [v1.19.10](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.10) | Added parametrization to enable configuration support for each kind of binary (0=None, 1=Only TX2, 2=TX2 and Binary)  |
|||| Fixed default NoTimestamps setting  |
|||| Adjusted some FoxUnit test cases  |
|||| EXPERIMENTAL: Added new configuration parameter "ClearUniqueID" in foxbin2prg.cfg for Clearing UniqueID in binaries and text versions. Works well and apparently FoxProdoesn't make use of it, but more testing is required  |
| 2014/02/08 | FDBOZZO | [v1.19.9](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.9) | New configuration items in foxbin2prg.cfg  |
|||| Localization Bug: When recompiling with localization file foxbin2prg\_en.h renamed to foxbin2prg.h, syntax error occurs  |
|||| Debug information of .LOG files enhanced  |
|||| New parametrization for the number of backups, now just one .BAK by default (earlier was 10)  |
|||| Enabled configuration file foxbin2prg.cfg by default  |
|||| Change in default behavior: Now Timestamps are disabled by default. You can change this on foxbin2prg.cfg  |
| 2014/02/03 | FDBOZZO | [v1.19.8](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.8-pública) | **Bug fix**: ActivePage error when executing a regenerated binary with a PageFrame / New FoxUnit test to test solution  |
|||| Added cNoTimestamps='1' to batch conversion vbs scripts  |
| 2014/02/02 | FDBOZZO | [v1.19.7](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.7-pública) | Added Ole encapsulation in just 1 place  |
|||| Adjusted Blocksize of generated binaries  |
|||| New cNoTimestamps parameter. If '1' is given, then no timestamps are generated (useful for diff/merge)  |
| 2014/01/31 | FDBOZZO | [v1.19.6](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.6-pública) | Added SourceSafe support (SCCAPI) for Diff and Merge  |
|||| SCX bug fix: Dataenvironment sometimes doesn't regenerates correctly  |
|||| Functionality change: Automatic recompilation enabled by default again because some methods doesn't show on form edit. Can be deactivated passing '0' to cRecompile param  |
| 2014/01/26 | FDBOZZO | [v1.19.5](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.5-pública) | Added Multilanguage support and Localization file for English. To use it rename the new file foxbin2prg\_en.h to foxbin2prg.h and recompile  |
| 2014/01/24 | FDBOZZO | [v1.19.4](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.4-pública) | New "Recompile" parameter for recompiling from PJX directory (if provided)  |
|||| **Functionality change**: Now FoxBin2Prg does not recompile bins for default, because it do on bin dir and that can throw compilation errors. Use new parameter if needed or recompile by your own  |
|||| DBC: Added support for multiline "comment" property  |
|||| VBS Batch scripts: Added progress bar  |
| 2014/01/18 | FDBOZZO | [v1.19.3](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.3-pública) | Change on TXT timestamps to preserve empty values that can save a lot of differences when diff/merging. Previously empty timestamps get converted to datetime  |
|||| Optimization on TXT generation of ZOrders  |
| 2014/01/13 | FDBOZZO | [v1.19.2](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.2-pública) | Fix on PJX regeneration caused for something missing in the last change of "Autor" to "Author"  |
| 2014/01/08 | FDBOZZO | [v1.19.1](https://github.com/fdbozzo/foxbin2prg/tree/v1.19.1-pública) | Small change on TX2 headers to drop the "Generated" timestamp that causes innecesary differences / Updated the EXE version with the correct one  |
| 2014/01/08 | FDBOZZO | [v1.19](https://github.com/fdbozzo/foxbin2prg/tree/v1.19-pública) | Added new debug flag on .vbs scripts to show a "End process" message for batch processing  |
|||| **Bug Fix**: scx/vcx Improper order of Reserved3 props cause event access to not fire  |
|||| **Bug Fix**: dbf Improper index generated when the type is Candidate  |
|||| Added support for converting SourceSafe PJM to FoxBin PJ2  |
|||| Added validation for Menus when converting from older versions, so user can convert it to VFP 9 format first  |
|||| Change in MN2 property: "Autor" was changed to "Author". You can add the missing letter to MN2 or regenerate  |
| 2014/01/07 | FDBOZZO | [v1.18.1](https://github.com/fdbozzo/foxbin2prg/tree/v1.18.1) | Added a vbs script (NormalizeFileNames.vbs) for FileNames normalizing in batch mode, and updated FileNameCaps.exe and the call on FoxBin2Prg  |
| 2014/01/06 | FDBOZZO | [v1.18](https://github.com/fdbozzo/foxbin2prg/tree/v1.18-pública) | **bug fix**: mnx Generation of DO Procedure or Command when no Procedure or Command available to call when empty option is created (Fidel Charny)  |
|||| Added support for DBFs earlier than VFP 9 for generating DB2 text, but DBF regeneration is in VFP 9 version!  |
|||| dbf bug fix: DBFs linked to a DBC that use long field names throw error when regenerating DBFs  |
|||| dbf bug fix: Some view info is lost when generating text from DBC  |
| 2014/01/03 | FDBOZZO | [v1.17](https://github.com/fdbozzo/foxbin2prg/tree/v1.17-pública) | **bug fix**: mnx Location value is lost and some menus doesn't render properly (Fidel Charny)  |
|||| Added 2 VB scripts (ConvertVFP9BIN2PRG.vbs and ConvertVFP9PRG2BIN.vbs) for batch converting of dirs and files if a shortcut is placed on "SendTo" user folder  |
|||| Added new Unit Testing cases for menus  |
| 2014/01/02 | FDBOZZO | [v1.16](https://github.com/fdbozzo/foxbin2prg/tree/v1.16-pública) | Added support for Menus (MNX)  |
| 2013/12/18 | FDBOZZO | [v1.15](https://github.com/fdbozzo/foxbin2prg/tree/v1.15-pública) | Added support for DBF, DBC and CDX binaries  |
| 2013/12/15 | FDBOZZO | [v1.14](https://github.com/fdbozzo/foxbin2prg/tree/v1.14-pública) | **bug fix**: scx autocenter property do nothing (Arturo Ramos)  |
|||| scx bug fix: Last COMMENT record is lost (Fidel Charny)  |
| 2013/12/08 | FDBOZZO | [v1.13](https://github.com/fdbozzo/foxbin2prg/tree/v1.13---pública) | **bug fix**: frx/lbx "Error 1924, TOREG is not an object" on some reports (Fidel Charny)  |
| 2013/12/08 | FDBOZZO | [v1.12](https://github.com/fdbozzo/foxbin2prg/tree/v1.12---pública) | Added support for Reports (FRX) and Labels (LBX)  |
| 2013/12/08 | FDBOZZO | [v1.11](https://github.com/fdbozzo/foxbin2prg/tree/v1.11---pública) | **bug fix**: vcx/scx \_memberdata value corrupted when the value is a long one (Edgar Kummers)  |
| 2013/12/07 | FDBOZZO | [v1.10](https://github.com/fdbozzo/foxbin2prg/tree/v1.10---pública) | **bug fix**: vcx/scx when there are methods with the same name, there code is assigned to erroneous objects (Fidel Charny)  |
| 2013/12/07 | FDBOZZO | [v1.9](https://github.com/fdbozzo/foxbin2prg/tree/v1.9---pública) | **bug fix**: vcx/scx last fix keep loosing some properties (Fidel Charny)  |
| 2013/12/06 | FDBOZZO | [v1.8](https://github.com/fdbozzo/foxbin2prg/tree/v1.8---pública) | **bug fix**: vcx/scx last fix keep loosing some properties (Fidel Charny)  |
|||| sort function encapsulated and reused on BIN and TXT generation for safety  |
| 2013/12/03 | FDBOZZO | [v1.7](https://github.com/fdbozzo/foxbin2prg/tree/v1.7---pública) | **bug fix**: vcx/scx some properties get lost and picture clause is not displayed if "Name" is not the last property on memo (Fidel Charny)  |
|||| Added verification of readOnly files and report this to Log file in debug mode  |
| 2013/12/02 | FDBOZZO | [v1.6](https://github.com/fdbozzo/foxbin2prg/tree/v1.6---pública) | Complete refactoring of BIN and TXT generation  |
|||| Changes of various algorithms  |
|||| scx/vcx bug fix: Array properties didn't save (Fidel Charny)  |
|||| Unit testing cases with FoxUnit  |
| 2013/11/27 | FDBOZZO | [v1.5](https://github.com/fdbozzo/foxbin2prg/tree/v1.5---pública) | **Bug fix**: On some forms dataenvironment didn't regenerate appropiately (Luis Martínez)  |
| 2013/11/27 | FDBOZZO | [v1.4](https://github.com/fdbozzo/foxbin2prg/tree/v1.4---pública) | Added mask support  |
|||| Added support for extension configuration on file foxbin2prg.cfg, so one can use "vca" instead of "vc2", etc  |
|||| Added support for a new parameter for Log generation  |
| 2013/11/24 | FDBOZZO | [v1.3](https://github.com/fdbozzo/foxbin2prg/tree/v1.3---pública) | Bug fixes, code cleaning, refactoring  |
| 2013/11/24 | FDBOZZO | [v1.2](https://github.com/fdbozzo/foxbin2prg/tree/v1.2---pública) | Bug fixes, code cleaning, refactoring  |
| 2013/11/22 | FDBOZZO | [v1.1](https://github.com/fdbozzo/foxbin2prg/tree/v1.1---pública) | Bug fixes  |
| 2013/11/22 | FDBOZZO | [v1.0](https://github.com/fdbozzo/foxbin2prg/tree/v1.0---pública) | Initial creation of clases on prg and support of VCX/SCX/PJX files  |

----
![VFPX logo](https://vfpx.github.io/images/vfpxbanner_small.gif)   
This project is part of [VFPX](https://vfpx.github.io/).   

----
Last changed: _2024/08/26_ ![Picture](./pictures/vfpxpoweredby_alternative.gif)
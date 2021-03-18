# Usage in object style
Documentation of FoxBin2Prg - A Binary to Text converter for MS Visual Foxpro 9

## Purpose of this document
FoxBin2Prg might be used as an EXE either from Windows or VFP, or as as prg from inside VFP in a [command line](./FoxBin2Prg_Run.md) way.  
This document deals with the integration as an VFP Object using VFP based objects.

For settings, API and other realted stuff see [Internals](./FoxBin2Prg_Internals.md).

The original document was created by [Fernando D. Bozzo](https://github.com/fdbozzo) whom I like to thank for the great project.   
Pictures are taken from the original project.  
As far as possible these are the original documents. Changes are added where functionality is changed.

----
## Table of contents
- [Usage](#usage)
   - [Instantiating](#instantiating)
   - [Execute](#execute)
- [Return values](#return-values)

----
## Usage
### Instantiating
Basically, the instantiating of FoxBinPrg is straight forward:
```
*-- Instancing directly from the EXE (fastest way, only EXE needed)
LOCAL loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG"
SET PROCEDURE TO "<Path>\FOXBIN2PRG.EXE"
loCnv = CREATEOBJECT("c_foxbin2prg")
loCnv.execute( <params> )
```
-or this way also-
```
*-- Instancing from the PRG (you also need various files, like the 27 props*.txt)
LOCAL loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG"
loCnv = NEWOBJECT("c_foxbin2prg", "<Path>\FOXBIN2PRG.PRG")
loCnv.execute( <params> )
```

### Execute
Transforming file(s) works like   
`obj.execute(cInputFile [,cType [,cTextName [,lGenText [,cDontShowErrors [,cDebug [,cDontShowProgress [,oModule [,oEx [,lRelanzarError [,cOriginalFileName [,cRecompile [,cNoTimestamps [,cBackupLevels [,cClearUniqueID [,cOptimizeByFilestamp [,cCFG_File] ] ] ] ] ] ] ] ] ] ] ] ] ] ])`   
A lot of the parameters are the same as calling the [command line](./FoxBin2Prg_Run.md),
some additional are added and some are not string type.   
Some settings will overwrite configuration. Using an object as cCFG_File will overwrite all configuration.

| Parameter | Value (_Default_) | Description |
| ----- | ----- | ----- |
| cInputFile | fullpath | Full name of the file to convert or directory name to process <br/> without any other parameter given, the extension (and the config) defines the operation|
| | _FileName::ClassName_ | If option UseClassPerFile is 1 or 2, a class-file will be extracted from the lib |
| cType | empty | Fileextension of _cInputFile_ defines operation |
| | BIN2PRG | _cInputFile_ is processed for generating a _Text_ representation. |
| | PRG2BIN | _cInputFile_ is processed for generating the _Binary_ file(s). |
| | INTERACTIVE | A confirmation dialog will be shown when processing a directory asking what to convert. <br/> This option overrides the _BIN2PRG_ and _PRG2BIN_ parameters. <br/> Can be used with or without _PRG2BIN_ or _BIN2PRG_ |
| | SHOWMSG | A status message will be shown on termination. |
| | * | If _cInputFile_ is a project (pj[x2]) all files of the project, **including** the pjx, will be processed. The extension defines direction of operation. |
| | \*\- | If _cInputFile_ is a project (pj[x2]) all files of the project, **excluding** the pjx, will be processed. The extension defines direction of operation. |
| | d, D, K, B, M, R, V | SCCAPI (SCCTEXT.PRG) compatibility mode, query the conversion support for the file type specified <br /> Types: d=DBC, D=DBF, K=Form, B=Label, M=Menu, R=Report, V=Class |
| | -C | Create configuration file \<cInputFile\> or, if first parameter is empty, FoxBin2Prg._cfg in default folder. With recent values. |
| | -c | Create configuration file template \<cInputFile\> or, if first parameter is empty, FoxBin2Prg._cfg in default folder. With inactive default values. |
| | -t | Create per-table configuration file template <cInputFile> or, if first parameter is empty and a table open, \<tablename\>._cfg in table folder. With inactive default values. |
| cTextName | Text filename. | Only for SCCAPI (SCCTEXT.PRG) compatibility mode. File to use. |
| lGenText | .T., .F. | Only for SCCAPI (SCCTEXT.PRG) compatibility mode. .T.=Generates Text, .F.=Generates Binary. <br/> **Note:** _cType_ have predominance over _lGenText_ |
| cDontShowErrors | _0_, 1 | '1' for NOT showing errors in MESSAGEBOX |
| cDebug | _0_, 1, 2 | '0 'no debug, '1' for generating process LOGs, stop on errors, '2' like '1' and special log. |
| cDontShowProgress | 0, _1_, 2 | '0' show progress, '1' for **not** showing the process window, '2' Show only for multi-file processing |
| oModule | | Internal use for Unit Testing |
| oEx | | Exception object, return for errorhandling |
| lRelanzarError | .T.. _.F._ | Throw error to caller of _.Execute()_ |
| cOriginalFileName | text | used in those cases in which inputFile is a temporary filename and you want to generate the correct filename on the header of the text version |
| cRecompile | 0, _1_ | Indicates recompile ('1') the binary once generated. <br/> True if called from SCCAPI (SCCTEXT.PRG) compatibility mode. |
|  | path | The binary is compiled from this path |
| cNoTimestamps | 0, _1_ | Indicates if timestamp must be cleared ('1' or empty) or not ('0') |
| cBackupLevels | 0, _1_, .. | "0" no Bakup, "1", one level _filename_.bak, "n" n levels of Backup _filename_.n.bak |
| cClearUniqueID | 0, _1_ | 0=Keep UniqueID in text files, 1=Clear Unique ID. Useful for Diff and Merge |
| cOptimizeByFilestamp | _0_, 1 | 1=Optimize file regeneration depending on file timestamp.<br/><span style="background-color: gold;">Dangerous while working with branches!</span> |
| cCFG_File | filename | Indicates a CFG filename for not using the default on foxbin2prg directory or path. |
|  | object | An object containing configuration options to use. See [Internals](./FoxBin2Prg_Internals.md) for object creation. |

#### cOutputFolder
The procedural call of FoxBin2Prg like
`FoxBin2Prg.EXE cInputFile ...` exposes a parameter _cOutputFolder_.
This parameter is not available in this call. To set _cOutputFolder_:   
````
obj.cOutputFolder = cOutputFolder
obj.execute(...)
````   

#### Note
The _BIN2PRG, PRG2BIN, INTERACTIVE, SHOWMSG_ cTypes might be mixed freely like:   
`PRG2BIN-INTERACTIVE`   
`BIN2PRG-INTERACTIVE-SHOWMSG`

#### Note
- The swap of _cInputFile_ and _cType_ is not possible here.
- If cType is -cCt, then only the first both parameters are allowed.
- Setting _cInputFile_ and _cType_ appropriate, info screen and generation of configuration templates is possible too. See [command line](./FoxBin2Prg_Run.md#usage_1)
- While possibe, the SCCAPI (SCCTEXT.PRG) compatibility mode is more an idea of the [command line](./FoxBin2Prg_Run.md).

## Return values
Return value is 0=OK, 1=Error.

----
![VFPX logo](https://vfpx.github.io/images/vfpxbanner_small.gif)   
This project is part of [VFPX](https://vfpx.github.io/).   

----
Last changed: _2021/03/18_ ![Picture](./pictures/vfpxpoweredby_alternative.gif)
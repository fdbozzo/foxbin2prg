# Purpose of this document
This document is an attempt to recreate the original documentation of FoxBin2Prg out of CodePlex.  
I found the documentation on [foxbin2prg](https://github.com/fdbozzo/foxbin2prg/blob/master/README.md) a bit brief. For a short what and why, see there.

The original document was created by [Fernando D. Bozzo](https://github.com/fdbozzo) whom I like to thank for the great project. Pictures are taken from the original project.  
As far as possible these are the original documents. Changes are added where functionality is changed.

----
![VFPX logo](https://vfpx.github.io/images/vfpxbanner_small.gif)   
This project is part of VFPX. 

----
# FoxBin2Prg - Usage in command line style
FoxBin2Prg might be used as an EXE either from Windows or VFP, or as as prg from inside VFP.
Since the EXE is basically the prg packed with some controling files, the way to call it ist mostly similar.
The knowledge of differences in calling, DO .. WITH syntax separating parameters with ","  and the DOS way off calling will be assumed.
Do to the similarity of the call, the prg version takes all parameters as strings too.
## Main differences
### EXE
The exe contains the mos controling structures and the program itself.
Alongside the _FoxBin2Prg.exe_ must be _FileName_Caps.exe_ .
It is recomended to have a general _FoxBin2Prg.cfg_ configuration file, but it will run without.
### PRG
The prg is just the program and needs to find the controling structures. In particular:
- _FileName_Caps.exe_
- _Props*.txt_
- _FileName_Caps.exe_
- _FoxBin2Prg.cfg_ is recomended
#### Note
All mentioned files need to be in the same folder. You can't use just the PRG without the rest of the mentioned files.
## Parameters
`FoxBin2Prg.EXE ...`   
could be used from VFP command line as   
`DO FoxBin2Prg.EXE WITH ...`   
or   
`DO FoxBin2Prg.prg WITH ...`  
or via _RUN_ or more sophisticated ways.   
Remember that using the prg style, parameters must be wrapped in string delimiters.  
#### Note
Do to the compatibility with VSS the usage of _cInputFile_ and _cType_ is odd.
#### Important note:
<div style="background-color: gold;"> When you process a directory, it is used as the base for the compilation of binaries,
and because of this, never process more than one directory in the same process,
because the compilation may not be ok. To process more than one directory (or project),
just select and process each one independently, in parallel if you like, but in different processes.</div>

### Usage #1
`FoxBin2Prg.EXE [-c cOutputFile] [-t cOutputFile]`

| Parameter | Description |
| ----- | ----- |
| none | Call Info screen |
| -c | creates a template config-file _cOutputFile_ ( like FOXBIN2PRG.CFG ) |
| -t | creates a template table-config-file _cOutputFile_ ( like _Tabellenname_.dbf.cfg ) |
### Usage #2
`FoxBin2Prg.EXE cInputFile [,cType [,cTextName [,lGenText [,cDontShowErrors [,cDebug [,cDontShowProgress [,cOriginalFileName [,cRecompile [,cNoTimestamps [,cCFG_File] ] ] ] ] ] ] ] ] ] ]`

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
| cTextName | Text filename. | Only for SCCAPI (SCCTEXT.PRG) compatibility mode. File to use. |
| lGenText | .T., .F. | Only for SCCAPI (SCCTEXT.PRG) compatibility mode. .T.=Generates Text, .F.=Regenerates Binary. <br/> **Note:** _cType_ have predominance over _lGenText_ |
| cDontShowErrors | _0_, 1 | '1' for NOT showing errors in MESSAGEBOX |
| cDebug | _0_, 1, 2 | '0 'no debug, '1' for generating process LOGs, stop on errors, '2' like '1' and special log. |
| cDontShowProgress | 0, _1_, 2 | '0' show progress, '1' for **not** showing the process window, '2' Show only for multi-file processing |
| cOriginalFileName | text | used in those cases in which inputFile is a temporary filename and you want to generate the correct filename on the header of the text version |
| cRecompile | 0, _1_ | Indicates recompile ('1') the binary once regenerated. <br/> True if called from SCCAPI (SCCTEXT.PRG) compatibility mode. |
|  | path | The binary is compiled from this path |
| cNoTimestamps | 0, _1_ | Indicates if timestamp must be cleared ('1' or empty) or not ('0') |
| cCFG_File | 0, _1_ | Indicates a CFG filename for not using the default on foxbin2prg directory or path. |
#### Note #1
The _BIN2PRG, PRG2BIN, INTERACTIVE, SHOWMSG_ cTypes might be mixed freely like:   
`PRG2BIN-INTERACTIVE`   
`BIN2PRG-INTERACTIVE-SHOWMSG`
#### Note #2
On any combination of (_BIN2PRG_, _PRG2BIN_, _INTERACTIVE_, _SHOWMSG_) separated by a "-", _cType_ and _cInputFile_ parameters can be swapped.   
This is useful when used as EXE dealing with Windows shortcuts,
on which fixed parameters must be in the shortcut.   
The filename is an external variable parameter received when SendingTo FoxBin2Prg with right-click on File Manager.
## Examples
### Using the "EXE" version: (useful for calling from 3rd.party programs)

| command | description |
| - | - |
| `FOXBIN2PRG.EXE "<path>\file.scx"` |	enerates the Text version |
| `FOXBIN2PRG.EXE "<path>\file.sc2"` | Regenerates the Binary version |
| `FOXBIN2PRG.EXE "<path>\proj.pjx" "*"` | Generates the Text files for all the files in the PJX, including the PJX |
| `FOXBIN2PRG.EXE "<path>\proj.pj2" "*"` | Regenerates the Binary files for all the files in the PJ2 |
| `FOXBIN2PRG.EXE "<path>\proj.pjx" "*-"` | Generates the Text files for all the files in the PJX, excluding the PJX |
| `FOXBIN2PRG.EXE "<path>\file.vcx::cus_client"` | Regenerates only the Text version of the individual class cus_client of file.vcx (with UseClassPerFile:1 or 2) |
| `FOXBIN2PRG.EXE "<path>\proj.pj2" "*" \| find /V ""` | Regenerates the Binary files for all the files in the PJ2 and outputs to stdOut |
### Using the "PRG" version:

| command | description |
| - | - |
| `DO FOXBIN2PRG.PRG WITH "<path>\file.scx"` | Generates the Text version |
| `DO FOXBIN2PRG.PRG WITH "<path>\file.sc2"` | Regenerates the Binary version |
| `DO FOXBIN2PRG.PRG WITH "<path>\proj.pjx", "*"` | Generates the Text files for all the files in the PJX, including the PJX |
| `DO FOXBIN2PRG.PRG WITH "<path>\proj.pj2", "*"` | Regenerates the Binary files for all the files in the PJ2 |
| `DO FOXBIN2PRG.PRG WITH "<path>\proj.pjx", "*-"` | Generates the Text files for all the files in the PJX, excluding the PJX |
| `DO FOXBIN2PRG.PRG WITH "<path>\file.vcx::cus_client"` | Regenerates only the Text version of the individual class cus_client of file.vcx (with UseClassPerFile:1 or 2) |
### Explorer SenTo:
To use _FoxBin2Prg_ from the File Explorer, you can create 3 shortcuts of FoxBin2Prg.exe and move them to "SendTo" folder on your Windows profile.   
Hint: **type _shell:sendto_ in File Explorer's address bar and it will open send to folder**,
so you can "send" the selected file (pjx,pj2,etc) to the selected option,
and make on-the-fly conversions,
then rename and edit those shortcuts as this (make sure you can see system file extensions):
```
Name------------------------  Right-click/Properties/destination-----------
FoxBin2Prg - Binary2Text.lnk  <path>\foxbin2prg.exe "BIN2PRG-SHOWMSG"
FoxBin2Prg - Text2Binary.lnk  <path>\foxbin2prg.exe "PRG2BIN-SHOWMSG"
FoxBin2Prg.lnk                <path>\foxbin2prg.exe "INTERACTIVE-SHOWMSG"
```
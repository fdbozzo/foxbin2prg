The purpose of FoxBin2Prg is to facilitate the Diff and Merge of Visual FoxPro 9 binaries, which are not natively supported by any source control tool. Traditionally FoxPro comes with a tool named SccText.prg who can make a text representation exporting the source code contained in FoxPro tables with a DBF structure. An enhanced version is available on VFPx named SccTextX, but like his ancestor, have some  design limitations, as:

* It doesn't generate PRG like code
* It doesn't allow modification of the txa (text) files generated
* Scctext's txa (text) files generated can't be used for merge with SCM tools, they are readonly
* Timestamps and ZOrder fields generate a lot of unnecesary differences all over the text file

FoxBin2Prg is designed to bring a solution for all of this, and a few more things, which makes tx2 (text) files with PRG-style and enhances compatibility with SCCAPI (SourceSafe) and other SCM tools, like PlasticSCM, Git, Subversion, and the like.

Special remark on Merge operation is made, because it is the most difficult and more used operation when working with SCM tools, and this require that generated text files can be manipulated manually or automatically.


_**Note: You came from Visual SourceSafe and have the .pjm but not the real pjx project?**_

No problem, just convert the .pjm to .pjx/.pjt sending to FoxBin2Prg, and it generates the real project again.




# These are the FoxBin2Prg.cfg configuration file settings and their meaning
----

| **FoxBin2Prg.cfg keywords and Defaults** | **Description** |
| ----- | ----- |
| extension: xx2 | FoxBin2Prg extensions ends in '2' (pj2, vc2, sc2, etc), but you can change that. For example you can change pj2 to pja using this: +{"extension: pj2=pja"}+ for making it SourceSafe (sccapi v1) compatible |
| DontShowProgress: 0 | Deprecated. Replaced by ShowProgressbar option from v1.19.40 |
| ShowProgressbar: 1 | 1=Always show a progress bar, 2=Only show it when processing multiple-files, 0=Don't show progressbar |
| DontShowErrors: 0 | By default, show message errors in a modal messagebox. Specify "1" if don't want to show errors |
| NoTimestamps: 1 | By default, timestamp fields are cleared on tx2 files, because a lot of differencies are generated on binaries and tx2 files with Timestamps activated. This timestamp field is part of the vcx, scx and other Foxpro binary source code files |
| Debug: 0 | By default, don't generate individual <file>.Log with process hints. Activate with "1" to find possible error causes and for debugging |
| ExtraBackupLevels: 1 | By default, one .BAK file is created. With this setting you can make more .N.BAK files, or none at all using 0 |
| ClearUniqueID: 1 | 0=Keep UniqueID, 1=Clear Unique ID. Very useful for Diff and Merge. By default, UniqueID fields are cleared on tx2 files, because a lot of differencies are generated with UniqueID activated |
| OptimizeByFilestamp: 0 | 0=Don't optimize (always regenerate), 1=Optimize (regenerate only when destination filestamp es older). By default this optimization is deactivated, and it is not recommended if using for merge, so bin and tx2 files can be modified seperately |
| RemoveNullCharsFromCode: 1 | 1=Drop NULL chars from source code / 0=Leave NULLs in source code |
| RemoveZOrderSetFromProps: 0 | 1=Remove ZOrderSet from the properties / 0=Leave ZOrderSet in the properties |
| {"XXX_Conversion_Support: N"} | Where N is: 0=No support, 1=Generate TXT only (Diff), 2=Generate TXT and BIN (Merge), 4=Generate TXT with DATA for DIFF (DBF only) |
| {"PJX_Conversion_Support: 2"} | Default value is 2 - Bidirectional (tx2 and bin) support activated |
| {"VCX_Conversion_Support: 2"} | Default value is 2 - Bidirectional (tx2 and bin) support activated |
| {"SCX_Conversion_Support: 2"} | Default value is 2 - Bidirectional (tx2 and bin) support activated |
| {"FRX_Conversion_Support: 2"} | Default value is 2 - Bidirectional (tx2 and bin) support activated |
| {"LBX_Conversion_Support: 2"} | Default value is 2 - Bidirectional (tx2 and bin) support activated |
| {"MNX_Conversion_Support: 2"} | Default value is 2 - Bidirectional (tx2 and bin) support activated |
| {"DBC_Conversion_Support: 2"} | Default value is 2 - Bidirectional (tx2 and bin) support activated |
| {"DBF_Conversion_Support: 1"} | Default value is 1 - just tx2 support activated. The support for regenerating DBFs structures (value = 2) are disabled by default to not overrite data accidentally. When activating bidirectional support, keep in mind that Data is not restored, just the structure and indexes!. A value of 4 is used to export Structure and Data, but exported data is not imported again. A value of 8 is used for bidirectional support (No General fields!). |
| UseClassPerFile: 0 | 0=One library tx2 file, 1=Multiple file.class.tx2 files, 2=Multiple file.baseclass.class.tx2 files, including DBC members |
| RedirectClassPerFileToMain: 0 | 0=Don't redirect to file.tx2, 1=Redirect to file.tx2 when selecting file.class.tx2 |
| ClassPerFileCheck: 0 | 0=Don't check file.class.tx2 inclusion, 1=Check file.class.tx2 inclusion |
| ClearDBFLastUpdate: 1 | 0=Keep DBF LastUpdate, 1=Clear DBF LastUpdate. Useful for Diff, minimizes differences. |
| Language: (auto) | Language of shown messages and LOGs. EN=English, FR=French, ES=Español, DE=German, Not defined = AUTOMATIC {"[DEFAULT](DEFAULT)"} (using VERSION(3)) |



# FoxBin2Prg Internals
----

## ZOrder

In TX2 files and starting from v1.19.12, the ZOrder, that determines the order on which objects are instantiated and which one is on top, is maintained in a more intuitive and optimal way compared to traditional stored numerical values.
TX2 files keep lists of objects and their metadata in a special OBJECTDATA tag, in which the order of the list is the ZOrder of the object, like this example:

{{DEFINE CLASS cnt_controls AS container 		&& "cnt_controls" class description
 	*< CLASSDATA: Baseclass="container" Timestamp="" Scale="Pixels" Uniqueid="" />

	*-- OBJECTDATA items order determines ZOrder 
	*< OBJECTDATA: ObjPath="Check2" UniqueID="" Timestamp="" />
	*< OBJECTDATA: ObjPath="Check4" UniqueID="" Timestamp="" />
	*< OBJECTDATA: ObjPath="Label_h" UniqueID="" Timestamp="" />
	*< OBJECTDATA: ObjPath="Textbox_h" UniqueID="" Timestamp="" />
	*< OBJECTDATA: ObjPath="Check1" UniqueID="" Timestamp="" />
	*< OBJECTDATA: ObjPath="Check3" UniqueID="" Timestamp="" />
}}

This way, you can rearrange the items to alter their ZOrder, and this does auto-renumbering when regenerating binaries.


## RemoveZOrderSetFromProps setting

_**Note:** The ZOrderSet property is not shown in VFP Properties editor_

Starting at v1.19.43 there is a new configuration setting named RemoveZOrderSetFromProps, that can be used to automatically remove this property from the objects, if enabled with 1.

This property keep the order of the inherited controls used on visual classes using a numeric value like the Tabstop property, but this property is not shown to the user and sometimes their value is duplicated, causing that every time you save a visual class or form, some control(s) get their order swapped, so when reopening the visual class some objects that should appear on top are on botton and vice versa.


_**VFP ZOrder bug and fix:** Sometimes you can see that some objects are reordered every time you save a visual form/class and regenerate the tx2 file. This is caused because in some situations VFP can loose the tracking to some ZOrders, and duplicate them. To **fix** this problem, you just need to open your visual form/class, reorder manually the offending objects to force VFP to assign a new ZOrder value and regenerate the tx2 file. You can see (only in the tx2 file or inside the vcx/vct) that the property is called ZOrderSet and have a repeated value before fixing it. Another solution, starting at v1.19.43, is using RemoveZOrderSetFromProps:1 in foxbin2prg.cfg file to remove this from the properties. A better solution is using this setting only in a specific directory used to fix this kind of problems. In any case, for this setting to work properly, you need to regenerate the binary_



## DBC ordered fields

Starting from v1.19.42 the members of the DBC are ordered alphabetically, including fields of DBFs and Views, Connections, Tables, Views and Relations. All this to minimize the differences when diffing DBCs that have constant changes.

{{<FIELD_ORDER>
    depto
    descrip
</FIELD_ORDER>
}}


## PAM Section

Ths section is generated for classes and forms, it is delimited with the <DefinedPropArrayMethod> tag, and have the definition of Properties, Arrays and Methods, with their comments, like this example:

{{DEFINE CLASS c1 AS custom OLEPUBLIC        && Description of "c1" class
    *<DefinedPropArrayMethod>
        *m: emptymethod_with_comments        && This method have no code, just comments!
        *m: mymethod        && My Method
        *p: prop1        && My prop 1
        *p: special_prop_with_cr
        *p: special_prop_with_crlf        && Should have CR+LF
        *a: array_1_d[1,0](1,0)        && 1 dimension array (1)
        *a: array_2_d[1,2](1,2)        && 2 dimension array (1,2)
        *p: _memberdata        && XML Metadata for customizable properties
    *</DefinedPropArrayMethod>
}}

Starting from v1.19.21 arrays don't need to be preceded with "^" symbol, and methods don't need to be preceded with "*" symbol, whick makes this section more easy to maintain.



## Property Ordering

On TX2 files is easy, ordering for methods and properties is done in alphabetical way, like scctext does with methods. This makes comparisons easier and with less differences.

On binaries, property ordering is a very different thing. No documentation is available about this, so the only guideline is trying to make it as FoxPro does, but this is not always possible because there are two extreme cases, and variants between the them:

1) The best and easy one, is when defining a class (or control) with his properties: In this case, each class have a phisical record on the scx/vcx table, and all the properties of it are keep toghether, so this ordering can be easily duplicated (look at "{"TESTS\DATOS_READONLY\f_form_aa.scx file"}" on foxbin2prg project and open it as a table to see the class per record)

2) The worst and most difficult case, is when there is a container with controls subclassed, and properties are changed on the instance: In this case FoxPro makes a big and unique list of properties of all objects in just one phisical record, so there is no way to know which property corresponds to which class. For this case, I've made a unique list composed of all properties of all classes, ordered according to most common orderings (look at "{"TESTS\DATOS_READONLY\f_form_aa2.scx file"}" on foxbin2prg project and open it as a table to see all the properties of all the classes of the same earlier example, in just one record)

For these two cases, and starting from v1.19.22, I've created several {"props_*"} files with ordering by class for the 1st case, and a list with all in it ({"props_all.txt"}) for the second case, so in case of any problems, rearranging some props will be an easy thing.

_**Warning:** These {"props_**"} files are necessary in the foxbin2prg install directory. It's recommended to use the EXE version that have all files included and is faster._

Several Unit Tests (in TESTS directory) are made to make the best effort to cover the most typical use cases. There is also an Excel spreedsheet with the compilation of properties of each class with the order that FoxPro uses internally, and a tab with the all-in-one order for the worst case.



## Timestamps and UniqueIDs

Timestamp field are used in VFP to track changes with 3rd party tools and UniqueId is used to identify classes inside binaries, but, AFAIK, they are not used by VFP itself. There are 2 switches, enabled by default, that are used to clear this values (ClearUniqueId and NoTimestamps), so no differences are shown for this values constantly changing.
Starting from v1.19.23 this values are just cleared on tx2 files, and regenerated on the binaries, as well the sccdata field, because this way there are no differences when opening/closing certain files, as a PJX, which by default fill some of this fields even if no modifications are made, which causes that SCM tools detect those changes. Having them prefilled, then no changes are detected.



## DBF Data Export/Import for Diff/Merge

Starting at version v1.19.21, and thanks to Doug Hennig proposal and coding, FoxBin2Prg can export DBFs Data, specially intended for small DBFs, as config ones, on which sometimes is needed to track the changes. It is deactivated by default, but can be activated with **{"DBF_Conversion_Support: 4"}** in foxbin2prg.cfg
Since version v1.19.47, importing of Data can be activated with **{"DBF_Conversion_Support: 8"}** in foxbin2prg.cfg

If you want to export the data of just some tables and not for all of them, one way is moving the tables for data export to another directory, or even a subdirectory of main data files, and write a foxbin2prg.cfg with **{"DBF_Conversion_Support: 4 or 8"}** for this diretory only, taking advantage of multi-configuration capability introduced on v1.19.25

A much better option that join the best of the two worlds, available from v1.19.44, could be using the default setting **{"DBF_Conversion_Support: 1"}** and using **individual cfg files** for each table (table.dbf.cfg) on which you want to export their data, so this way you can have only the structure in DB2 files and some tables with their data exported for easy diffing with previous versions, or even use **{"DBF_Conversion_Support: 8"}** (available since v1.19.47) for bidirectional support of data import/export.

**FoxBin2prg.cfg (Main CFG or Directory CFG)**
New foxbin2prg.cfg options for filtering tables from conversion using one or multiple conbinations of filemasks.

**Syntax:**
{"DBF_Conversion_Included: <filemask>[ ,<filemask> [ , ... ](-,_filemask_-[-,-...-) ]"}
{"DBF_Conversion_Excluded: <filemask>[ ,<filemask> [ , ... ](-,_filemask_-[-,-...-) ]"}

Example of multiple file masks (separte with ","):

{"DBF_Conversion_Included: PET**.**, ??ME.DBF, ???.DBF, ?.**"}

.

**New <filename.dbf.cfg> configuration options**
These options can be used in any combination inside a dbf particular cfg file, if you create a text file using your dbf filename and adding ".cfg".

**Syntax for filename.dbf.cfg contents:**
{"DBF_Conversion_Support: <4 for export only or 8 for bidirectional support>"}
{"DBF_Conversion_Order: <C_Expression>"}
{"DBF_Conversion_Condition: <C_Expression>"}

**Example: customers.dbf.cfg**
{"DBF_Conversion_Support: 4"}
{"DBF_Conversion_Order: cust_no"}
{"DBF_Conversion_Condition: cust_no > 10"}




## DBF/DB2 Convertion Hooks

From version v1.19.19 there is a new property "{"run_AfterCreateTable"}" and from version v1.19.24 "{"run_AfterCreate_DB2"}". The purpose of both properties is to allow the execution of an external program each time a DBF is converted to DB2 or a DB2 is converted to DBF.
The main purpose of FoxBin2Prg is to be used for Diff and Merge with a SCM tool, so in this scenario the data is not needed, but there are use cases where exporting, importing or manipulating data is needed while making the conversions, and for those cases are this properties.

This is a sample program:

{{
*-- DEMO HOOK FOR PROCESSING DBFs AND DB2
LOCAL oFB AS 'c_foxbin2prg' OF 'c:\desa\foxbin2prg\foxbin2prg.prg'
oFB = NEWOBJECT( 'c_foxbin2prg', 'c:\desa\foxbin2prg\foxbin2prg.prg' )
oFB.DBF_Conversion_Support	= 2
oFB.run_AfterCreateTable 	= 'p_AfterCreateTable'
oFB.run_AfterCreate_DB2 	= 'p_AfterCreate_DB2'
oFB.execute( 'C:\DESA\foxbin2prg\TESTS\DATOS_TEST\fb2p_dbc.dc2' )
oFB.execute( 'C:\DESA\foxbin2prg\TESTS\DATOS_TEST\fb2p_dbf.db2' )
oFB.execute( 'C:\DESA\foxbin2prg\TESTS\DATOS_TEST\fb2p_dbf.dbf' )
oFB	= NULL
RETURN


PROCEDURE p_AfterCreateTable
	LPARAMETERS lnDataSessionID, tc_OutputFile, toTable
	MESSAGEBOX( 'Actual Datasession: ' + TRANSFORM(SET("Datasession")) + CHR(13) ;
		+ 'lnDataSessionID: ' + TRANSFORM(lnDataSessionID) )
	*-- You can fill the table <tc_OutputFile> here.
	INSERT INTO fb2p_dbf (nombre,edad,depto) VALUES ('Fer', 45, 'dpto')
ENDPROC


PROCEDURE p_AfterCreate_DB2
	LPARAMETERS lnDataSessionID, tc_OutputFile, toTable
	MESSAGEBOX( 'Actual Datasession: ' + TRANSFORM(SET("Datasession")) + CHR(13) ;
		+ 'lnDataSessionID: ' + TRANSFORM(lnDataSessionID) )
	*-- You can export the data here.
	STRTOFILE( nombre + STR(edad,3) + depto, 'c:\temp\data.txt', 1)
ENDPROC
}}



## Language Support for messages

As for version v1.19.38 FoxBin2Prg messages are available natively on Spanish, English, German and French.

_**Note:** The messages on vbs scripts are not translated (are very few), just the FoxPro ones, which have +90% of the messages._

**Want to collaborate translating the messages to your language so others can use it?**
Just copy the english translation CASE in the final section in FoxBin2Prg.PRG to a new CASE with your country code and translate the messages (can be done in 20 minutes or less), and send it to me. I will include it in the next release ;-)

_**Note:** .h language files are not supported anymore, and are now implemented inside foxbin2prg, in the {"C_LANG"} class at the end of the PRG_



## Multi-config (config per directory)

Starting at version v1.19.25 FoxBin2Prg allow configuration per directory, overriding the main configuration of FoxBin2Prg directory. The override is by each setting, so you can reconfigure one or more settings and the remaining settings are inherited from main CFG.

_**New:**_ From v1.19.42 CFGs are inherited between directories from parent to child, so if you have all your developments under, let's say, {"c:\devs"} directory and subdirs, de CFG in {"c:\devs"} will be inherited on subdirs, and settings can be overriden one by one if you want to. This inheritance saves a lot of time and minimizes the CFGs needed {":)"}



## File Capitalization

FoxBin2Prg takes care of file capitalization (their extension, specifically), using another program called ({"filename_caps.exe"}) for capitalizing input files and output files. This is because some SCM and DVCS tools are multiplatform, and if you add a "file.ext" and later add a "file.EXT" or "File.Ext", the SCM can interpret them as different files, because on Unix, Linux, Mac and other sistems, they are.

If you want a special capitalization (ie: capitalize the full name of the file), you can configure this behaviour in {"filename_caps.cfg"} configuration file, which includes syntax examples.

File capitalization occurs when you convert a file, but in the case that the input file can't be converted, no message error ir thrown (ie: when using the PRG version from VFP Command Line with the form to be converted opened)



## Conversion processes Logging

If you want detailed process logging of FoxBin2Prg conversions, to see all internal processes, decisions and used optimizations, you can enable debugging using +debug:1+ in foxbin2prg.cfg configuration file, and a full log is generated on FoxBin2Prg installation directory.
Debug messages are translated (+90% of debug messages), but capitalization process messages are not, and are available just in Spanish (-10% of debug messages).



## Create Class-Per-File

Starting at v1.19.37 you can configure foxbin2prg to generate one class per file using TwoFox naming style "basefile.class.tx2" with the value "1"
To configure this, you must first enable it in foxbin2prg.cfg file:

_**{"UseClassPerFile: 1"}**_   && 0=One library tx2 file, 1=Multiple file.class.tx2 files, 2=Multiple file.baseclass.class.tx2 files, including DBC members |

In example, if you have a classlib "mylib.vcx" with 3 classes inside ({"cl_1, cl_2, cl_3"}) then this files are generated:

{{
mylib.vc2 => Header file, with all conforming classes annotated inside
mylib.cl_1.vc2
mylib.cl_2.vc2
mylib.cl_3.vc2
}}

_**Recommended new setting:**_ Starting at v1.19.42 you can configure foxbin2prg to generate one class per file using the naming style "basefile._baseclass_.class.tx2" with the new value "2" and including DBC members as well.
To configure this, you must first enable it in foxbin2prg.cfg file:

_**{"UseClassPerFile: 2"}**_   && 0=One library tx2 file, 1=Multiple file.class.tx2 files, 2=Multiple file.baseclass.class.tx2 files, including DBC members

In example, if you have a classlib "mylib.vcx" with 3 classes inside ({"cl_1, cl_2, cl_3"}) then this files are generated:

{{
mylib.vc2 => Header file, with all conforming classes annotated inside
mylib.custom.cl_1.vc2
mylib.form.cl_2.vc2
mylib.textbox.cl_3.vc2
}}

And if you convert mydbc DBC file to text:

{{
mydbc.dc2 => Header file, with all conforming members annotated inside
mydbc.connection.cnx_oracle.dc2
mydbc.table.customers.dc2
mydbc.view.vw_products.dc2
}}

**Complementary options for the UseClassPerFile setting**

_**RedirectClassPerFileToMain**:_ Configuring this setting to 1 will redirect any selection of file.class.tx2 to the main file.tx2 file, which will not let you generate individual vcx files by mistake.

_**ClassPerFileCheck**:_  Configuring this setting to 1 will check the inclusion of all file.class.tx2 files annotated on file.tx2 main file, otherwise no checking is made and when reconstructing the vcx/scx all files containing the file.class.ext naming will be included in the binary (useful when you want to add external classes to the library) |

_**Note:** If you dont use the Redirect setting, an individual vcx/scx file will be generated. This can be useful if you want to divide a big library in smaller pieces_



## FoxBin2Prg API

With v1.19.42 version started an enhanced API support, making public methods that where only for internal use up to now.

When using FoxBin2Prg as an object, you can access low level functionalities not available when using as external program, that allow you to implement your own tools, like the VFP tools I've implemented for working with PlasticSCM.

The return value of execute() method, is an error code, where 0 means No errors.
You can also get an Exception reference in case of errors, passing extra parameters as in the next examples.

First you instantiate foxbin2prg as object, using this syntax:

{{
LOCAL loCnv AS c_foxbin2prg OF "<Path>\FOXBIN2PRG.PRG"  && For Intellisense
SET PROCEDURE TO "<Path>\FOXBIN2PRG.EXE"
loCnv = CREATEOBJECT("c_foxbin2prg")
}}

Now some examples:

Convert a file.vcx to text:
{{
loCnv.execute( "<Path>\file.vcx" )
}}

Regenerate the binary classlib from the text file.vc2:
{{
loCnv.execute( "<Path>\file.vc2" )
}}

Convert all files of a project.pjx to text:
{{
loCnv.execute( "<Path>\project.pjx", "*" )
}}

Return a laProc array of processed forms _**after**_ processing a project:
{{
DIMENSION laProcs(1,6)
lnErr = loCnv.execute("C:\DESA\foxbin2prg\TESTS\DATOS_TEST\fb2p_test.pjx", "*", "", "", "1", "0", "1")
lnCnt = loCnv.get_Processed(@laProcs, "*.scx")
}}

Return a laProc array of processed classlibs _**before**_ processing a project (almost no file processing here, just minimal header reading):
{{
DIMENSION aProcs(1,6)
loCnv.l_ProcessFiles = .F.
lnErr = loCnv.execute("C:\DESA\foxbin2prg\TESTS\DATOS_TEST\fb2p_test.pjx", "*", "", "", "1", "0", "1")
lnCnt = loCnv.get_Processed(@aProcs, "*.vcx")
}}

Check if a file has support for converting to text:
{{
loCnv.evaluateConfiguration( '', '', '', '', '', '', '', '', <Path>, 'D' )
? loCnv.hasSupport_Bin2Prg("<Path>\file.vcx")
? loCnv.hasSupport_Bin2Prg("<Path>\file.ppt")
}}
_**Note:** If you query for support in different subdirectories, then you need to call {"evaluateConfiguration()"} method for refreshing the CFG info that is used by those methods._


Clear the cache of processed files for allowing reprocessing a file:
{{
loCnv.clearProcessedFiles()
}}

Get a CFG object with the settings that will be applied to a directory
{{
oCFG = loCnv.get_DirSettings( "c:\developments\projects\myproj_1" )
? oCFG.n_UseClassPerFile
? oCFG.DBF_Conversion_Support
}}
_**Note:** {"get_DirSettings()"} method internally calls {"evaluateConfiguration()"} method for refreshing the CFG info before returning the CFG object._


Check if a file was processed:
{{
? loCnv.wasProcessed( "c:\developments\projects\myfile.vcx" )
}}


Get the internal FoxBin2Prg's Project project of a given PJX and return an array with existence of files on disk:
{{
STORE null TO oMod, oEx
DIMENSION aFiles(1,2) && col.1=Name, col.2=File exist on disk
loCnv.loadModule("c:\developments\projects\myfile.pjx", @oMod, @oEx, .F. )
nFilesNotFound = oMod.getFilesNotFound(@aFiles)
FOR I = 1 TO oMod.Count && oMod.Count is the total count of files in the PJX
   ? aFiles(1,2), aFiles(1,1)
ENDFOR
}}


This is a list of available methods and properties:

|| Method()/Property || Syntax || Description ||
| {"execute"} | {"loCnv.execute( cInputFile [,cType [,cTextName [,lGenText [,cDontShowErrors [,cDebug [,cDontShowProgress [,oModule [,oEx [,lRelanzarError [,cOriginalFileName [,cRecompile [,cNoTimestamps [,cBackupLevels [,cClearUniqueID [,cOptimizeByFilestamp [,cCFG_File](,cType-[,cTextName-[,lGenText-[,cDontShowErrors-[,cDebug-[,cDontShowProgress-[,oModule-[,oEx-[,lRelanzarError-[,cOriginalFileName-[,cRecompile-[,cNoTimestamps-[,cBackupLevels-[,cClearUniqueID-[,cOptimizeByFilestamp-[,cCFG_File) ] ] ] ] ] ] ] ] ] ] ] ] ] ] )"} | Main execution method to start a conversion |
| {"conversionSupportType"} | {"loCnv.conversionSupportType( cFilename )"} | Return de code of the support type (0,1,2,4,8) |
| {"get_DBF_Configuration"} | {"loCnv.get_DBF_Configuration( cInputFile, @oOutDbfCfg )"} | Returns 1 if a CFG is found for the indicated DBF, or 0 if not  |
| {"hasSupport_Bin2Prg"} | {"loCnv.hasSupport_Bin2Prg( cFilename.ext | cExt )"} | Returns .T. if there is support for converting the file or filetype indicated to text |
| {"hasSupport_Prg2Bin"} | {"loCnv.hasSupport_Prg2Bin( cFilename.ext | cExt )"} | Returns .T. if there is support for converting the file or filetype indicated to binary |
| {"evaluateConfiguration"} | {"loCnv.evaluateConfiguration( cDontShowProgress [,cDontShowErrors [,cNoTimestamps [,cDebug [,cRecompile [,cBackupLevels [,cClearUniqueID [,cOptimizeByFilestamp [,cInputFile [,cInputFileTypeType [,cCFG_File](,cDontShowErrors-[,cNoTimestamps-[,cDebug-[,cRecompile-[,cBackupLevels-[,cClearUniqueID-[,cOptimizeByFilestamp-[,cInputFile-[,cInputFileTypeType-[,cCFG_File) ] ] ] ] ] ] ] ] )"} | Forces foxbin to process the directory indicated in the cInputFile and update any CFG in the directory or their parents |
| {"loadProgressbarForm"} | {"loCnv.loadProgressbarForm()"} | Load and show the progressbar form as upper level window |
| {"unloadProgressbarForm"} | {"loCnv.unloadProgressbarForm()"} | Hide and unload the progressbar form |
| {"updateProgressbar"} | {"loCnt.updateProgressbar( cText, nValue, nTotal, nType )"} | Update the progressbar and the message. nType indicates which progressbar to update, being 0=1st PB and 1=2nd PB |
| {"get_DirSettings"} | {"loCnv.get_DirSettings( cDir )"} | Returns a CFG object with the settings that are applied on the indicated directory |
| {"get_Ext2FromExt"} | {"loCnv.get_Ext2FromExt( cExt )"} | Returns the text extension corresponding to the binary extension indicated |
| {"get_Processed"} | {"loCnv.get_Processed( @aProcessed, cFileMask )"} | Returns an array with the status of the files being processed or that will be processed in no-real-process-mode if you set {"l_ProcessFiles=.F."} before the call. Columns returned are 6: {"cFile, cInOutType, cProcessed, cHasErrors, cSupported, cExpanded"} |
| {"clearProcessedFiles"} | {"loCnv.clearProcessedFiles()"} | Clear the statistics and the cache about processed files. If a file was processed and is already processed, being not cached will force to process it again |
| {"wasProcessed"} | {"loCnv.wasProcessed( cFile )"} | Returns .T. if the fullpath-file was processed, searching in the internal cache |

This is the translation table of old method names up to v1.19.41 and the new names:

|| Old name || New name ||
| {"Ejecutar"} | {"Execute"} |
| {"TieneSoporte_**"} | {"hasSupport_**"} |
| {"EvaluarConfiguracion"} | {"EvaluateConfiguration"} |
| {"AvanceDelProceso"} | {"updateProgressbar"} |
| {"cargar_frm_avance"} | {"loadProgressbarForm"} |
| {"descargar_frm_avance"} | {"unloadProgressbarForm"} |

_**Note:** Any method or property not documented in this help, could be renamed, changed or deleted, so please, do not use it_



## Log to StdOut

When running from a DOS window, you can get the output to console (same order as array obtained with {"get_Processed"} method, except that element 1 {"[filename](filename)"} is shown last):

**{"C:\DESA\foxbin2prg>foxbin2prg.exe "tests\datos_test\fb2p_dbc.dbc" | find /V """}**
{{I,P1,E0,S1,X0,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.dbc
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.dc2
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.connection.remote_connection_dbf.dc2
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.connection.remote_connection_oracle.dc2
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.table.fb2p_depto.dc2
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.table.nombrelargodeldbf.dc2
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.view.rv_db_debug_setup.dc2
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.view.vista_local.dc2
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.view.vw_local_encuestas.dc2
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.view.vw_ora_convenios.dc2
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.view.vw_ora_dual.dc2
O,P1,E0,S1,X1,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.database.storedproceduressource.dc2
}}

The last line means:
Output file (**O**), Processed (**P1**), Without Errors (**E0**), Supported (**S1**), Not Extended file (**X0**) and the Full path filename



# How to use with a SCM tool
----

Here we need to identify 2 distinct operations: checkin because a binary modification with the IDE and checkin because a merge operation.


## Checkin because a binary modification within the IDE

When you work with the VFP 9 IDE, you modify the binary files (forms, classlib and the like), then you checkin your modifications, but before doing this you regenerate the tx2 files +just for the changed binaries+, and once you have all the boundles of bins/tx2, you checkin them.

_**Note:** If any binary doesn't have the corresponding tx2 file, it can be because it is in use (close opened bin and clear all at VFP command window), or because you really haven't made any changes to the code, in which case you should undo the changes to the binaries that don't have their tx2 files using the "undo" option for these files of your SCM tool._


## Checkin because a merge operation

When you merge a branch, you work on tx2 files seeing and merging differences manually or automatically. When you have done with the merge you need to checkin, but before this, you need to regenerate the binaries (forms, classlib, etc) just from the tx2 files merged, to sync their code. Once you have done, then you checkin the boundle of bins/tx2.

_**Note:** If at the end of a merge operation there are binaries left, you need to choose the "workspace binaries", because anyway you will regenerate them later from their tx2 files._

For options on integrating FoxBin2Prg with SCM tools, look at this topic:
**> [FoxBin2Prg and use with SCM tools](FoxBin2Prg-and-use-with-SCM-tools)**

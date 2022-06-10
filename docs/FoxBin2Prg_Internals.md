# Internals
Documentation of FoxBin2Prg - A Binary to Text converter for MS Visual Foxpro 9

## Purpose of this document
This document shows some internal functions and ideas how to use of FoxBin2Prg.

The original document was created by [Fernando D. Bozzo](https://github.com/fdbozzo) whom I like to thank for the great project.   
Pictures are taken from the original project.  
As far as possible these are the original documents. Changes are added where functionality is changed.

----
## Table of contents
- [Why to use this tool](#why-to-use-this-tool)
- [Limitations](#limitations)
- [Configuration file](#configuration-file)
- [Configuration file per table](#configuration-file-per-table)
- [FoxBin2Prg Internals](#foxbin2prg-internals)
   - [ZOrder](#zorder)
      - [RemoveZOrderSetFromProps setting](#removezordersetfromprops-setting)
      - [VFP ZOrder bug and fix](#vfp-zorder-bug-and-fix)
   - [DBC ordered fields](#dbc-ordered-fields)
   - [PAM Section](#pam-section)
   - [Property Ordering](#property-ordering)
   - [Timestamps and UniqueIDs](#timestamps-and-uniqueids)
   - [DBF Data Export/Import for Diff/Merge](#dbf-data-export/import-for-diff/merge)
   - [Order and range of records](#order-and-range-of-records)
   - [Configuration per table](#configuration-per-table)
   - [DBF/DB2 Convertion Hooks](#dbf/db2-convertion-hooks)
   - [Language Support for messages](#language-support-for-messages)
   - [Multi-config](#multi-config)
   - [File Capitalization](#file-capitalization)
   - [Conversion processes Logging](#conversion-processes-logging)
   - [Create Class-Per-File](#create-class-per-file)
      - [Complementary options for the UseClassPerFile setting](#complementary-options-for-the-useclassperfile-setting)
         - [RedirectClassPerFileToMain](#redirectclassperfiletomain)
         - [ClassPerFileCheck](#classperfilecheck)
   - [Create File-Per-DBC](#create-file-per-dbc)
      - [Complementary options for the UseFilesPerDBC setting](#complementary-options-for-the-usefilesperdbc-setting)
         - [RedirectFilePerDBCToMain](#redirectfileperdbctomain)
         - [ItemPerDBCCheck](#itemperdbccheck)
   - [FoxBin2Prg API](#foxbin2prg-api)
      - [PEM](#pem)
      - [Renamed](#renamed)
   - [Log to StdOut](#log-to-stdout)
- [How to use with a SCM tool](#how-to-use-with-a-scm-tool)

## Why to use this tool
The purpose of FoxBin2Prg is to facilitate the Diff and Merge of Visual FoxPro 9 _Binaries_,
which are not natively supported by any source control tool.
Traditionally FoxPro comes with a tool named SccText.prg who can make a text representation exporting the source code
contained in FoxPro tables with a DBF structure. An enhanced version is available on VFPx named SccTextX,
but like his ancestor, have some  design limitations, as:

* It doesn't generate PRG like code
* It doesn't allow modification of the txa (text) files generated
* Scctext's txa (text) files generated can't be used for merge with SCM tools, they are readonly
* Timestamps and ZOrder fields generate a lot of unnecesary differences all over the text file

FoxBin2Prg is designed to bring a solution for all of this, and a few more things,
which makes _Text_ files with PRG-style and enhances compatibility with SCCAPI (SourceSafe) and other SCM tools,
like PlasticSCM, Git, Subversion, and the like.   
Special remark on Merge operation is made, because it is the most difficult and more used operation when working with SCM tools,
and this require that generated text files can be manipulated manually or automatically.

#### Note
**You came from Visual SourceSafe and have the .pjm but not the real pjx project?**   

No problem, just convert the .pjm to .pjx/.pjt sending to FoxBin2Prg, and it generates the real project again.

## Limitations
Most of the files look like prg or XML data. Please note, those files are only look alike.
The parsing to generate the binary depends highly on the position of data.
So if a file is defined like 
```
	<FIELDS>
		<FIELD>
			<Name>I1</Name>
```
this
```
	<FIELDS><FIELD><Name>I1</Name>.
```
will be nice XML, but not readable to FoxBin2Prg. This is a line by line parser.   
Leading and trailing spaces are mostly no problem.

You might freely change and merge code inside the text files, or data in a table-XML,
but the result must be compilable and keep the structure.   
All limitations that occur to a binary format must be kept on the text representation -
the definition of a HEADER class to a VCX will fail.


## Configuration file
It is possible to create a template or a config with all options and comments via   
```
DO FOXBIN2PRG.PRG WITH "-c","template.cfg"    &&==> Generates a template for FoxBin2Prg.cfg config file with newest settings
DO FOXBIN2PRG.PRG WITH "-C","config.cfg"      &&==> Generates a config file like FoxBin2Prg.cfg with recent settings of path of second parameter
```
See [command line](./FoxBin2Prg_Run.md#usage-2).   
The config file is used to move local setting to a different comupter or for changes while branching.
 
The options in the template (or in the config that ships with FoxBin2Prg) are commented out.
To activate an option remove the asterix and set appropriate value.   
These are the FoxBin2Prg.cfg configuration file settings and their meaning:

| FoxBin2Prg.cfg keywords | Value (_Default_) | Description |
| ----- | ----- | ----- |
| Language | _(auto)_, EN, FR, ES, DE | Language of templates, shown messages and LOGs. EN=English, FR=French, ES=Español, DE=German, Not defined = AUTOMATIC (using VERSION(3)) ||
| DontShowProgress | 0 | **Deprecated**. Replaced by ShowProgressbar option from v1.19.40 |
| ShowProgressbar | 0, _1_, 2 | 0=Don't show progressbar,<br/>1=Always show a progress bar,<br/>2=Only show it when processing multiple-files |
| DontShowErrors | _0_, 1 | 0=show message errors in a modal messagebox. (default)<br/>1=don't show errors |
| ExtraBackupLevels | 0, _1_, n | <br/>0=No backup<br/>1=One backupfile _\_filename\_.BAK_ (default)<br/>n=n levels of backup in style _\_filename\_.n.BAK_ |
| Debug | _0_, 1, 2 | 0=Off<br/>1=Normal<br/>2=Extended<br/>By default, don't generate individual <file>.Log with process hints.<br/>Activate with "1" to find possible error causes and for debugging,<br/>"2" is special logging |
| BackgroundImage | <cFile> | Backgroundimage for process form |
| HomeDir | 0, _1_ | 0=don't save HomeDir in PJ2,<br/>1=save HomeDir in PJ2.<br/>Setting this to 0 prevents the PJ2 file from changing just because two developers have the project in different folders |
|||
| XXX_Conversion_Support | n | Defines the conversion operation per filetype |
| | | For code:<br/> 0=No support,<br/>1=Generate _Text_ (Diff),<br/>2=Generate _Text_ and _Bin_ (Merge) |
| | | For complex data:<br/> (PJX / DBC / DBF): 0=No support,<br/>1=Generate Header _Text_ only (Diff),<br/>2=Generate Header _Text_ and _Bin_ (Merge/Only Structure!),<br/>4=Generate _Text_ with DATA (Diff),<br/>8=Export and Import DATA (Merge/Structure & Data) |
| PJX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional ((Merge/Only Structure!),<br/>4=Generate _Text_ with DATA (Diff), 8=Export and Import DATA (Merge/Structure & Data) and _bin_) support activated |
| VCX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| SCX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| FRX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| LBX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| MNX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| DBC_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| DBF_Conversion_Support | 0, _1_, 2, 4, 8 | Default value is 1 - just _Text_ support activated.<br/>The support for regenerating DBFs structures (value = 2) are disabled by default to not overrite data accidentally. When activating bidirectional support, keep in mind that Data is not restored, just the structure and indexes!.<br/>A value of 4 is used to export Structure and Data, but exported data is not imported again.<br/>A value of 8 is used for bidirectional support (No General fields!). <br/> **Note:** This can be [changed per table](#configuration-file-per-table). |
| FKY_Conversion_Support | 0, _1_ | Default value is 1 - _Text_ support activated |
| MEM_Conversion_Support | 0, _1_ | Default value is 1 - _Text_ support activated |
|||
| UseClassPerFile | _0_, 1, 2 | 0=One library _Text_ file,<br/>1=Multiple file.class.vc2 files,<br/>2=Multiple file.baseclass.class.vc2 files<br/>See [Create Class-Per-File](#create-class-per-file) |
| [RedirectClassPerFileToMain:](#redirectclassperfiletomain:) | _0_, 1 | 0=Don't redirect to file.vc2,<br/>1=Redirect to file.vc2 when selecting file.class.vc2<br/>RedirectClassType: 1 precedes this setting |
| RedirectClassType | _0_, 1, 2 | For classes created with UseClassPerFile>0 in the form file[.baseclass].class.tx2 (vcx only) |
| | | 0=creates / refresh class in file.VCX and add / replace all other classes of this library |
| | | 1=creates / refresh class file[.baseclass].class.VCX and do not touch file.VCX |
| | | 2=creates / refresh class in file.VCX and do not touch other classes of file.VCX |
| [ClassPerFileCheck](#classperfilecheck) | _0_, 1 | 0=Don't check file.class.vc2 inclusion,<br/>1=Check file.class.vc2 inclusion<br/>Only used if import file is in file[.baseclass].class.tx2 syntax.<br/>Ignored for RedirectClassType: 2 |
|||
| OldFilesPerDBC | _0_, 1 | 0=Old Style,<br/>1=New style<br/>This controls the use of the _UseFilesPerDBC_, _RedirectFilePerDBCToMain_ and _ItemPerDBCCheck_ options.<br/>Only if this option is set, the options will be read. |
| | | 0=New version inactive, options follow:<br/>UseFilesPerDBC=UseClassPerFile<br/>RedirectFilePerDBCToMain=RedirectClassPerFileToMain<br/>ItemPerDBCCheck=ClassPerFileCheck |
| | | 1=New version active, options active |
| | | Note: The options will be set to old style, if option is turned off. |
| UseFilesPerDBC | _0_, 1 | 0=One database dc2 file,<br/>1=Multiple file.\*.\*.dc2 files.<br/>See [Create File-Per-DBC](#create file-per-dbc)<br/>**Only if OldFilesPerDBC is 1** |
| | | 0=creates only a file.dc2 with all DBC (file) data |
| | | 1=creates a file.dc2 with DBC properties |
| | | and additional DBC files per DBC item (stored-proc, table, ..) |
| | | Note: recration only if RedirectFilePerDBCToMain is 1 |
| [RedirectFilePerDBCToMain](#redirectfileperdbctomain) | _0_, 1 | 0=Don't redirect to file.dc2,<br/>1=Redirect to file.tx2 when selecting file.item.*.dc2<br/>**Only if OldFilesPerDBC is 1** |
| [ItemPerDBCCheck](#itemperdbccheck) | _0_, 1 | 0=Don't check file.item.*.dc2 inclusion,<br/> 1=Check file.item.*.dc2 inclusion<br/>**Only if OldFilesPerDBC is 1**|
|||
| NoTimestamps | 0, _1_ | 0=Do not clear<br/>1=Clear<br/>By default, timestamp fields are cleared on _Text_ files, because a lot of differencies are generated on _Binaries_ and _Text_ files with Timestamps activated. This timestamp field is part of the vcx, scx and other Foxpro binary source code files. |
| ClearUniqueID | 0, _1_ | 0=Keep UniqueID,<br/>1=Clear Unique ID.<br/>Very useful for Diff and Merge.<br/>By default, UniqueID fields are cleared on _Text_ files, because a lot of differencies are generated with UniqueID activated |
| OptimizeByFilestamp | _0_, 1 | 0=Don't optimize (always generate),<br/>1=Optimize (generate only when destination filestamp es older). By default this optimization is deactivated, and it is not recommended if using for merge, so _Bin_ and _Text_ files can be modified seperately.<br/><span style="background-color: gold;">Dangerous while working with branches!</span> |
| RemoveNullCharsFromCode | 0, _1_ | 1=Drop NULL chars from source code,<br/>0=Leave NULL chars in source code |
| RemoveZOrderSetFromProps | _0_, 1 | 1=Remove ZOrderSet from the properties,<br/>0=Leave ZOrderSet in the properties |
|||
| ClearDBFLastUpdate | 0, _1_ | 0=Keep DBF LastUpdate,<br/>1=Clear DBF LastUpdate.<br/>Useful for Diff, minimizes differences. |
| ExcludeDBFAutoincNextval | _0_, 1 | 0=Do not exclude this value from db2,<br/>1=Exclude this value from db2 |
| DBF_Conversion_Included | * | If DBF_Conversion_Support:4, you can specify multiple filemasks: www,fb2p_free.dbf.<br/>See [Order and range of records](#order-and-range-of-records).<br/>**Note:** This can be [changed per table](#configuration-file-per-table). |
| DBF_Conversion_Excluded | | If DBF_Conversion_Support:4, you can specify multiple filemasks: www,fb2p_free.dbf.<br/>See [Order and range of records](#order-and-range-of-records).<br/>**Note:** This can be [changed per table](#configuration-file-per-table). |
| DBF_BinChar_Base64 | 0, _1_ | 0=For character type fields, if NoCPTrans 0=do not transform,<br/>1=use Base64 transform (default)<br/>**Note:** This can be [changed per table](#configuration-file-per-table). |
| DBF_IncludeDeleted | _0_, 1 | 0=Do not include deleted records (default),<br/>1=Include deleted records<br/>**Note:** This can be [changed per table](#configuration-file-per-table). |
| | |  **Note:**<br/>This is only true for tables. Generating DBC to _Text_ and back to _Binary_ will act as PACK DATABASE.<br/>The data added by _DBF_IncludeDeleted: 1_ will be ignored by old versions generating _Binary_ files. |
|||
| extension: xx2 | | FoxBin2Prg extensions ends in '2' (pj2, vc2, sc2, etc), but you can change that. |
| extension: pj2= | \<extension\> | Text file for project PJX |
| extension: vc2= | \<extension\> | Text file for classlibray VCX, or a class out of a VCX |
| extension: sc2= | \<extension\> | Text file for form SCX, or a class out of a SCX (Form; Dataenbironment) |
| extension: fr2= | \<extension\> | Text file for report FRX |
| extension: lb2= | \<extension\> | Text file for label LBX |
| extension: mn2= | \<extension\> | Text file for menu MNX |
| extension: db2= | \<extension\> | Text file for table DBF, free or DBC bound |
| extension: dc2= | \<extension\> | Text file for database container DBC, or records from database container DBC |
| extension: fk2= | \<extension\> | Text file for macro file FKY |
| extension: me2= | \<extension\> | Text file for variable memory MEM, created with SAVE TO |
|  | | **Example for for making it SourceSafe (sccapi v1) compatible:**<br/>extension: pj2=pja<br/>extension: vc2=vca<br/>extension: sc2=sca<br/>extension: fr2=fra<br/>extension: lb2=lba<br/>extension: mn2=mna<br/>extension: db2=dba<br/>extension: dc2=dca  |

### Note
The options will be read outside in, top to down. See [Multi-config](#multi-config)

## Configuration file per table
Those configuration files are valid for a single table only. The idea is to have special settings for single tables.   
It is possible to create a template with all options and comments via
```
DO FOXBIN2PRG.PRG WITH "-t","template.dbf.cfg"  &&==> Generates a template for table.dbf.cfg per table config file with newest settings
```

See [command line](./FoxBin2Prg_Run.md#usage-2).   
The options in the template (or in the config that ships with FoxBin2Prg) are commented out.
To activate an option remove the asterix and set appropriate value.   
These are the Table.dbf.cfg configuration file settings and their meaning:

| FoxBin2Prg.cfg keywords | Value | per<br/>file | Description |
| ----- | ----- | ----- | ----- |
| DBF_Conversion_Support | 0, 1, 2, 4, 8 | | 0=No support,<br/>1=Generate Header _Text_ only (Diff),<br/>2=Generate Header _Text_ and _Bin_ (Merge/Only Structure!),<br/>4=Generate _Text_ with DATA (Diff),<br/>8=Export and Import DATA (Merge/Structure & Data) |
| DBF_Conversion_Order | c_Expression | x | Field expresion (For _INDEX ON_). ie: name+str(age,3),<br/>Empty means no sort order. <br/> usefull only if _DBF_Conversion_Support_>0 |
| DBF_Conversion_Condition | c_Expression | x | Logical expression (For _SCAN FOR_). ie: age > 10 AND NOT DELETED(),<br/>empty means all records, except _DBF_IncludeDeleted_ <br/> usefull only if _DBF_Conversion_Support_>0  |
| DBF_IndexList | c_FileList | x | A comma delimited list of additional index files ( cdx or idx ). **Not the structural index file.** |
| DBF_BinChar_Base64 | 0, 1 | | 0=For character type fields, if NoCPTrans 0=do not transform,<br/>1=use Base64 transform <br/> usefull only if _DBF_Conversion_Support_>2  |
| DBF_IncludeDeleted | 0, 1 | | 0=Do not include deleted records,<br/>1=Include deleted records <br/> usefull only if _DBF_Conversion_Support_>2  |

Setting **per file** could only be used via this configuration file.
For defaults, see [Configuration file](#configuration-file).
 
## FoxBin2Prg Internals
### ZOrder
In _Text_ files and starting from v1.19.12, the ZOrder,
that determines the order on which objects are instantiated and which one is on top,
is maintained in a more intuitive and optimal way compared to traditional stored numerical values.
_Text_ files keep lists of objects and their metadata in a special OBJECTDATA tag,
in which the order of the list is the ZOrder of the object, like this example:
````
DEFINE CLASS cnt_controls AS container 		&& "cnt_controls" class description
 *< CLASSDATA: Baseclass="container" Timestamp="" Scale="Pixels" Uniqueid="" />

 *-- OBJECTDATA items order determines ZOrder 
 * < OBJECTDATA: ObjPath="Check2" UniqueID="" Timestamp="" />
 * < OBJECTDATA: ObjPath="Check4" UniqueID="" Timestamp="" />
 * < OBJECTDATA: ObjPath="Label_h" UniqueID="" Timestamp="" />
 * < OBJECTDATA: ObjPath="Textbox_h" UniqueID="" Timestamp="" />
 * < OBJECTDATA: ObjPath="Check1" UniqueID="" Timestamp="" />
 * < OBJECTDATA: ObjPath="Check3" UniqueID="" Timestamp="" />
````
This way, you can rearrange the items to alter their ZOrder, and this does auto-renumbering when generating _Binaries_.

### RemoveZOrderSetFromProps setting
#### Note:
The ZOrderSet property is not shown in VFP Properties editor.
   
Starting at v1.19.43 there is a new configuration setting named RemoveZOrderSetFromProps,
that can be used to automatically remove this property from the objects, if enabled with 1.   
This property keep the order of the inherited controls used on visual classes using a numeric value like the Tabstop property,
but this property is not shown to the user and sometimes their value is duplicated, causing that every time you save a visual class
or form, some control(s) get their order swapped, so when reopening the visual class some objects that should appear on top
are on botton and vice versa.

#### VFP ZOrder bug and fix
Sometimes you can see that some objects are reordered every time you save a visual form/class
and generate the _Text_ file. This is caused because in some situations VFP can loose the tracking to some ZOrders,
and duplicate them. To **fix** this problem, you just need to open your visual form/class,
reorder manually the offending objects to force VFP to assign a new ZOrder value and generate the _Text_ file.
You can see (only in the _Text_ file or inside the vcx/vct) that the property is called ZOrderSet and have a repeated value
before fixing it. Another solution, starting at v1.19.43, is using RemoveZOrderSetFromProps:1 in foxbin2prg.cfg file to
remove this from the properties. A better solution is using this setting only in a specific directory used to fix this
kind of problems. In any case, for this setting to work properly, you need to generate the _Binary_

### DBC ordered fields
Starting from v1.19.42 the members of the DBC are ordered alphabetically, including fields of DBFs and Views, Connections, Tables,
Views and Relations. All this to minimize the differences when diffing DBCs that have constant changes.
````
<FIELD_ORDER>
    depto
    descrip
</FIELD_ORDER>
````
### PAM Section
This section is generated for classes and forms, it is delimited with the <DefinedPropArrayMethod> tag,
	and have the definition of Properties, Arrays and Methods, with their comments, like this example:
````
DEFINE CLASS c1 AS custom OLEPUBLIC        && Description of "c1" class
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
````
Starting from v1.19.21 arrays don't need to be preceded with "^" symbol, and methods don't need to be preceded with "*" symbol,
which makes this section more easy to maintain.

### Property Ordering
On _Text_ files is easy, ordering for methods and properties is done in alphabetical way, like scctext does with methods.
This makes comparisons easier and with less differences.   
On _Binaries_, property ordering is a very different thing. No documentation is available about this,
so the only guideline is trying to make it as FoxPro does, but this is not always possible because there are two extreme cases,
and variants between the them:   
1. The best and easy one, is when defining a class (or control) with his properties: In this case,
each class have a phisical record on the scx/vcx table, and all the properties of it are keep toghether,
so this ordering can be easily duplicated (look at "TESTS\DATOS_READONLY\f_form_aa.scx file" on FoxBin2Prg project
and open it as a table to see the class per record)
2. The worst and most difficult case, is when there is a container with controls subclassed,
and properties are changed on the instance: In this case FoxPro makes a big and unique list of properties of all objects
in just one phisical record, so there is no way to know which property corresponds to which class. For this case,
I've made a unique list composed of all properties of all classes,
ordered according to most common orderings (look at "TESTS\DATOS_READONLY\f_form_aa2.scx file" on FoxBin2Prg project
and open it as a table to see all the properties of all the classes of the same earlier example, in just one record)

For these two cases, and starting from v1.19.22, I've created several "props_*" files with ordering by class for the 1st case,
and a list with all in it ("props_all.txt") for the second case, so in case of any problems,
rearranging some props will be an easy thing.   

#### Warning
These "props_**" files are necessary in the FoxBin2Prg install directory.

It's recommended to use the EXE version that have all files included and is faster._   
Several Unit Tests (in TESTS directory) are made to make the best effort to cover the most typical use cases.
There is also an Excel spreedsheet with the compilation of properties of each class with the order that FoxPro uses internally,
and a tab with the all-in-one order for the worst case.

### Timestamps and UniqueIDs
Timestamp field are used in VFP to track changes with 3rd party tools and UniqueId is used to identify classes inside _Binaries_,
but, AFAIK, they are not used by VFP itself. There are 2 switches, enabled by default,
that are used to clear this values (ClearUniqueId and NoTimestamps),
so no differences are shown for this values constantly changing.
Starting from v1.19.23 this values are just cleared on _Text_ files, and generated on the _Binaries_,
as well the sccdata field, because this way there are no differences when opening/closing certain files, as a PJX,
which by default fill some of this fields even if no modifications are made, which causes that SCM tools detect those changes.
Having them prefilled, then no changes are detected.

### DBF Data Export/Import for Diff/Merge
Starting at version v1.19.21, and thanks to Doug Hennig proposal and coding, FoxBin2Prg can export DBFs Data,
specially intended for small DBFs, as config ones, on which sometimes is needed to track the changes.
It is deactivated by default, but can be activated with **"DBF_Conversion_Support: 4"** in foxbin2prg.cfg
Since version v1.19.47, importing of Data can be activated with **"DBF_Conversion_Support: 8"** in foxbin2prg.cfg   
If you want to export the data of just some tables and not for all of them, one way is moving the tables
for data export to another directory, or even a subdirectory of main data files,
and write a foxbin2prg.cfg with **"DBF_Conversion_Support: 4 or 8"** for this diretory only,
taking advantage of multi-configuration capability introduced on v1.19.25    
A much better option that join the best of the two worlds, available from v1.19.44,
could be using the default setting **"DBF_Conversion_Support: 1"** and using **individual cfg files** for each table
(table.dbf.cfg) on which you want to export their data, so this way you can have only the structure in DB2 files
and some tables with their data exported for easy diffing with previous versions,
or even use **"DBF_Conversion_Support: 8"** (available since v1.19.47) for bidirectional support of data import/export.   

### Order and range of records
**FoxBin2Prg.cfg (Main CFG, Directory CFG or Table CFG)**  
New foxbin2prg.cfg options for filtering tables from conversion using one or multiple conbinations of filemasks.

#### Syntax
````
"DBF_Conversion_Included: <filemask>[ ,<filemask> [ , ... ](-,_filemask_-[-,-...-) ]"
"DBF_Conversion_Excluded: <filemask>[ ,<filemask> [ , ... ](-,_filemask_-[-,-...-) ]"
````

Example of multiple file masks (separte with ","):
````
"DBF_Conversion_Included: PET**.**, ??ME.DBF, ???.DBF, ?.**"
````

### Configuration per table
New <filename.dbf.cfg> configuration options. See [Configuration file per table](#configuration-file-per-table).
	
These options can be used in any combination inside a dbf particular cfg file,
if you create a text file using your dbf filename and adding ".cfg".

#### Syntax for filename.dbf.cfg contents
````
"DBF_Conversion_Support: <4 for export only or 8 for bidirectional support>"
"DBF_Conversion_Order: <C_Expression>"
"DBF_Conversion_Condition: <C_Expression>"
````

#### Example: customers.dbf.cfg
````
"DBF_Conversion_Support: 4"
"DBF_Conversion_Order: cust_no"
"DBF_Conversion_Condition: cust_no > 10"
````

### DBF/DB2 Convertion Hooks
From version v1.19.19 there is a new property "run_AfterCreateTable" and from version v1.19.24 "run_AfterCreate_DB2".
The purpose of both properties is to allow the execution of an external program each time a DBF is converted to DB2 or a DB2
is converted to DBF.
The main purpose of FoxBin2Prg is to be used for Diff and Merge with a SCM tool, so in this scenario the data is not needed,
but there are use cases where exporting, importing or manipulating data is needed while making the conversions, and for those cases are this properties.

#### This is a sample program
````
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
````
### Language Support for messages
As for version v1.19.38 FoxBin2Prg messages are available natively on Spanish, English, German and French.   

#### Note
The messages on vbs scripts are not translated (are very few), just the FoxPro ones,
which have +90% of the messages.

**Want to collaborate translating the messages to your language so others can use it?**
Just copy the english translation CASE in the final section in FoxBin2Prg.PRG to a new CASE
with your country code and translate the messages (can be done in 20 minutes or less),
and send it to me. I will include it in the next release ;-)    

#### Note
.h language files are not supported anymore, and are now implemented inside FoxBin2Prg,
in the "C_LANG" class at the end of the PRG_

### Multi-config
Starting at version v1.19.25 FoxBin2Prg allow configuration per directory,
overriding the main configuration of FoxBin2Prg directory.
The override is by each setting, so you can reconfigure one or more settings and the
remaining settings are inherited from main CFG.   

From v1.19.42 CFGs are inherited between directories from parent to child,
so if you have all your developments under, let's say, "c:\devs" directory and subdirs,
de CFG in "c:\devs" will be inherited on subdirs, and settings can be overriden one by one if you want to.
This inheritance saves a lot of time and minimizes the CFGs needed \:\)

##### Note
Options will be read outside in, top to down.   
If an option is defined multiple times, even in the same file, last occurance wins.   
This exception is the group controlling the new style to split DBC files.
The options _UseFilesPerDBC_, _RedirectFilePerDBCToMain_ and _ItemPerDBCCheck_ will be ignored,
if _OldFilesPerDBC_ is set to 0.   
If _OldFilesPerDBC_ is set to 0 after it was active, the values of the three options are rejected at all.

### File Capitalization
FoxBin2Prg takes care of file capitalization (their extension, specifically),
using another program called ("filename_caps.exe") for capitalizing input files and output files.
This is because some SCM and DVCS tools are multiplatform, and if you add a "file.ext"
and later add a "file.EXT" or "File.Ext", the SCM can interpret them as different files,
because on Unix, Linux, Mac and other sistems, they are.   
If you want a special capitalization (ie: capitalize the full name of the file),
you can configure this behaviour in "filename_caps.cfg" configuration file, which includes syntax examples.   
File capitalization occurs when you convert a file, but in the case that the input file can't be converted,
no message error ir thrown (ie: when using the PRG version from VFP Command Line with the form to be converted opened)

### Conversion processes Logging
If you want detailed process logging of FoxBin2Prg conversions,
to see all internal processes, decisions and used optimizations, you can enable debugging using
+debug:1+ in foxbin2prg.cfg configuration file, and a full log is generated on FoxBin2Prg installation directory.
Debug messages are translated (+90% of debug messages), but capitalization process messages are not,
and are available just in Spanish (-10% of debug messages).

### Create Class-Per-File
Starting at v1.19.37 you can configure FoxBin2Prg to generate one class per file using TwoFox naming style "basefile.class.vc2"
with the value "1"
To configure this, you must first enable it in foxbin2prg.cfg file:
````
*UseClassPerFile: 1   && 0=One library _Text_ file, 1=Multiple file.class.vc2 files, 2=Multiple file.baseclass.class.vc2 files
````
In example, if you have a classlib "mylib.vcx" with 3 classes inside ( "cl_1, cl_2, cl_3") then this files are generated:

- mylib.vc2 => Header file, with all conforming classes annotated inside
  - mylib.cl_1.vc2
  - mylib.cl_2.vc2
  - mylib.cl_3.vc2
#### Important note
The settings of UseClassPerFile and related options are sensible. If changed the wrong way it's easy to destroy classlibs.

#### Recommended new setting
Starting at v1.19.42 you can configure FoxBin2Prg to generate one class per file.
Using the naming style "basefile._baseclass_.class.vc2" with the new value "2".

To configure this, you must first enable it in foxbin2prg.cfg file:
````
*UseClassPerFile: 2  && 0=One library _Text_ file, 1=Multiple file.class.vc2 files, 2=Multiple file.baseclass.class.vc2 files,
including DBC members
````
In example, if you have a classlib "mylib.vcx" with 3 classes inside ( "cl_1, cl_2, cl_3") then this files are generated:

- mylib.vc2 => Header file, with all conforming classes annotated inside
  - mylib.custom.cl_1.vc2
  - mylib.form.cl_2.vc2
  - mylib.textbox.cl_3.vc2
#### Complementary options for the UseClassPerFile setting
##### RedirectClassPerFileToMain:
Configuring this setting to 1 will redirect any selection of file[.baseclass].class.vc2
to the main file.vc2 file, which will not let you generate individual vcx files by mistake.   
RedirectClassType: 1 precedes this setting for files in the 


##### ClassPerFileCheck
Configuring this setting to 1 will check the inclusion of all file[.baseclass].class.vc2 files
annotated on file.vc2 main file, otherwise no checking is made and when reconstructing the vcx/scx all files
containing the file.class.ext naming will be included in the _Binary_ (useful when you want to add external classes to the library).    
This is only used, if import file is in file[.baseclass].class.tx2 syntax.   
Ignored for RedirectClassType: 2

#### Note
If you don't use the redirect setting, an individual vcx/scx file will be generated.
This can be useful if you want to divide a big library in smaller pieces.

#### Note
This is true for SCX files as well. SCX files may contain a form and a dataenvironment.
It will create sc2 files.

### Create File-Per-DBC
Starting at 1.19.55 you can configure FoxBin2Prg to generate one _Text_ file per dbc item using naming style "DatabaseName.item.name.dc2"
with the value "1"
To configure this, you must first enable it in foxbin2prg.cfg file:
````
*UseFilesPerDBC: 0              && 0=One database dc2 file, 1=Multiple file.*.*.dc2 files
````
In example, if you have a classlib "MyData.dbc" with 3 tables inside ( "tl_1, tl_2, tl_3") and stored procedures.
Then this files are generated:

- MyData.vc2 => Header file, with all database settings and conforming items annotated inside
  - MyData.database.storedproceduressource.dc2 -> stored procedures
  - MyData.table.tl_1.dc2
  - MyData.table.tl_2.dc2
  - MyData.table.tl_3.dc2

#### Complementary options for the UseFilesPerDBC setting
##### RedirectFilePerDBCToMain
`*RedirectFilePerDBCToMain 0     && 0=Don't redirect to file.dc2, 1=Redirect to file.tx2 when selecting file.item.*.dc2`   
Configuring this setting to 1 will redirect any selection of DataBaseName.*.dc2
to the main DataBaseName.dc2 file, which will not let you generate individual DBC files by mistake.   

##### ItemPerDBCCheck
`*ItemPerDBCCheck: 0             && 0=Don't check file.item.*.dc2 inclusion, 1=Check file.item.*.dc2 inclusion`   
Configuring this setting to 1 will check the inclusion of all DataBaseName.*.dc2 files
annotated on DataBaseName.dc2 main file, otherwise no checking is made and when reconstructing the dbc files

#### Note
If you don't use the Redirect setting, an individual dbc file will be generated.
There is no real use of this.

### FoxBin2Prg API
With v1.19.42 version started an enhanced API support, making public methods that where only for internal use up to now.   
When using FoxBin2Prg as an object, you can access low level functionalities not available when using as external program,
that allow you to implement your own tools, like the VFP tools I've implemented for working with PlasticSCM.   

The return value of `execute()` method, is an error code, where 0 means *No errors*.
You can also get an Exception reference in case of errors, passing extra parameters as in the next examples.

First you instantiate FoxBin2Prg as object, using this syntax:
````
LOCAL loCnv AS c_foxbin2prg OF "<Path>\FOXBIN2PRG.PRG"  && For Intellisense
SET PROCEDURE TO "<Path>\FOXBIN2PRG.EXE"
loCnv = CREATEOBJECT("c_foxbin2prg")
````
Now some examples:

Convert a file.vcx to text:
````
loCnv.execute( "<Path>\file.vcx" )
````
Generate the _Binary_ classlib from the text file.vc2:
````
loCnv.execute( "<Path>\file.vc2" )
````
Convert all files of a project.pjx to text:
````
loCnv.execute( "<Path>\project.pjx", "*" )
````
Return a `laProc` array of processed forms _**after**_ processing a project:
````
DIMENSION laProcs(1,6)
lnErr = loCnv.execute("C:\DESA\foxbin2prg\TESTS\DATOS_TEST\fb2p_test.pjx", "*", "", "", "1", "0", "1")
lnCnt = loCnv.get_Processed(@laProcs, "*.scx")
````
Return a laProc array of processed classlibs _**before**_ processing a project
(almost no file processing here, just minimal header reading):
````
DIMENSION aProcs(1,6)
loCnv.l_ProcessFiles = .F.
lnErr = loCnv.execute("C:\DESA\foxbin2prg\TESTS\DATOS_TEST\fb2p_test.pjx", "*", "", "", "1", "0", "1")
lnCnt = loCnv.get_Processed(@aProcs, "*.vcx")
````
Check if a file has support for converting to text:
````
loCnv.evaluateConfiguration( '', '', '', '', '', '', '', '', <Path>, 'D' )
? loCnv.hasSupport_Bin2Prg("<Path>\file.vcx")
? loCnv.hasSupport_Bin2Prg("<Path>\file.ppt")
````
#### Note
If you query for support in different subdirectories,
then you need to call `evaluateConfiguration()` method for refreshing the CFG info that is used by those methods.

Clear the cache of processed files for allowing reprocessing a file:
````
loCnv.clearProcessedFiles()
````
Get a CFG object with the settings that will be applied to a directory
````
oCFG = loCnv.get_DirSettings( "c:\developments\projects\myproj_1" )
? oCFG.n_UseClassPerFile
? oCFG.DBF_Conversion_Support
````
#### Note
`get_DirSettings()` method internally calls `evaluateConfiguration()`
method for refreshing the CFG info before returning the CFG object.


Check if a file was processed:
````
? loCnv.wasProcessed( "c:\developments\projects\myfile.vcx" )
````
Get the internal FoxBin2Prg's Project project of a given PJX and return an array with existence of files on disk:
````
STORE null TO oMod, oEx
DIMENSION aFiles(1,2) && col.1=Name, col.2=File exist on disk
loCnv.loadModule("c:\developments\projects\myfile.pjx", @oMod, @oEx, .F. )
nFilesNotFound = oMod.getFilesNotFound(@aFiles)
FOR I = 1 TO oMod.Count && oMod.Count is the total count of files in the PJX
   ? aFiles(1,2), aFiles(1,1)
ENDFOR
````

#### PEM
This is a list of available methods and properties:

| Method()/Property<br/>Syntax | Description |
| -| - |
| **execute**<br/>loCnv.execute( cInputFile [,cType [,cTextName [,lGenText [,cDontShowErrors [,cDebug [,cDontShowProgress [,oModule [,oEx [,lRelanzarError [,cOriginalFileName [,cRecompile [,cNoTimestamps [,cBackupLevels [,cClearUniqueID [,cOptimizeByFilestamp [,cCFG_File](,cType-[,cTextName-[,lGenText-[,cDontShowErrors-[,cDebug-[,cDontShowProgress-[,oModule-[,oEx-[,lRelanzarError-[,cOriginalFileName-[,cRecompile-[,cNoTimestamps-[,cBackupLevels-[,cClearUniqueID-[,cOptimizeByFilestamp-[,cCFG_File ] ] ] ] ] ] ] ] ] ] ] ] ] ] ) | Main execution method to start a conversion<br/> See [Object version](./FoxBin2Prg_Object.md#execute) |
| **conversionSupportType**<br/>loCnv.conversionSupportType( cFilename ) | Return the code of the support type (0,1,2,4,8) |
| **get_DBF_Configuration**<br/>loCnv.get_DBF_Configuration( cInputFile, @oOutDbfCfg ) | Returns 1 if a CFG is found for the indicated DBF, or 0 if not  |
| **hasSupport_Bin2Prg**<br/>loCnv.hasSupport_Bin2Prg( cFilename.ext )<br/>loCnv.hasSupport_Bin2Prg( cExt ) | Returns .T. if there is support for converting the file or filetype indicated to _text_ |
| **hasSupport_Prg2Bin**<br/>loCnv.hasSupport_Prg2Bin( cFilename.ext )<br/>loCnv.hasSupport_Prg2Bin( cExt ) | Returns .T. if there is support for converting the file or filetype indicated to _Binary_ |
| **evaluateConfiguration**<br/>loCnv.evaluateConfiguration( cDontShowProgress [,cDontShowErrors [,cNoTimestamps [,cDebug [,cRecompile [,cBackupLevels [,cClearUniqueID [,cOptimizeByFilestamp [,cInputFile [,cInputFileTypeType [,cCFG_File](,cDontShowErrors-[,cNoTimestamps-[,cDebug-[,cRecompile-[,cBackupLevels-[,cClearUniqueID-[,cOptimizeByFilestamp-[,cInputFile-[,cInputFileTypeType-[,cCFG_File) ] ] ] ] ] ] ] ] ) | Forces FoxBin2Prg to process the directory indicated in the cInputFile and update any CFG in the directory or their parents |
| **loadProgressbarForm**<br/>loCnv.loadProgressbarForm() | Load and show the progressbar form as upper level window |
| **unloadProgressbarForm**<br/>loCnv.unloadProgressbarForm() | Hide and unload the progressbar form |
| **updateProgressbar**<br/>loCnt.updateProgressbar( cText, nValue, nTotal, nType ) | Update the progressbar and the message. nType indicates which progressbar to update, being 0=1st PB and 1=2nd PB |
| **get_DirSettings**<br/>loCnv.get_DirSettings( cDir ) | Returns a CFG object with the settings that are applied on the indicated directory |
| **get_Ext2FromExt**<br/>loCnv.get_Ext2FromExt( cExt ) | Returns the _text extension_ corresponding to the _Binary_ extension indicated |
| **get_Processed**<br/>loCnv.get_Processed( @aProcessed, cFileMask ) | Returns an array with the status of the files being processed or that will be processed in no-real-process-mode if you set `l_ProcessFiles=.F.` before the call. Columns returned are 6: "cFile, cInOutType, cProcessed, cHasErrors, cSupported, cExpanded"` |
| **clearProcessedFiles**<br/>loCnv.clearProcessedFiles() | Clear the statistics and the cache about processed files. If a file was processed and is already processed, being not cached will force to process it again |
| **wasProcessed**<br/>loCnv.wasProcessed( cFile ) | Returns .T. if the fullpath-file was processed, searching in the internal cache |

#### Renamed
This is the translation table of old method names up to v1.19.41 and the new names:

| Old name | New name |
| -| - |
| Ejecutar | Execute |
| TieneSoporte_** | hasSupport_** |
| EvaluarConfiguracion | EvaluateConfiguration |
| AvanceDelProceso | updateProgressbar |
| cargar_frm_avance | loadProgressbarForm |
| descargar_frm_avance | unloadProgressbarForm |

#### Note
Any method or property not documented in this help, could be renamed, changed or deleted, so please, do not use it_

### Log to StdOut
When running from a DOS window, you can get the output to console (same order as array obtained with get_Processed method,
except that element 1 \[filename\] is shown last):

````
C:\DESA\foxbin2prg>foxbin2prg.exe "tests\datos_test\fb2p_dbc.dbc" | find /V
````

````
I,P1,E0,S1,X0,c:\desa\foxbin2prg\tests\datos_test\fb2p_dbc.dbc
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
````

#### First line
The first line means:   
Input file (**I**), Processed (**P1**), Without Errors (**E0**), Supported (**S1**), Not Extended file (**X0**) and the full path filename. 

#### Last line
The last line means:   
Output file (**O**), Processed (**P1**), Without Errors (**E0**), Supported (**S1**), Extended file (**X1**) and the full path filename. 

## How to use with a SCM tool
### Note
This chapter is without function if the only the _Text_ files are in the source control.

Here we need to identify 2 distinct operations: checkin because a _Binary_ modification with the IDE
and checkin because a merge operation.

### Checkin because a _Binary_ modification within the IDE
When you work with the VFP 9 IDE, you modify the _Binary_ files (forms, classlib and the like),
then you checkin your modifications, but before doing this you generate the _Text_ files +just for the changed _Binaries_+,
and once you have all the boundles of _Binaries_/_Text_, you checkin them.   
#### Note:
If any _Binary_ doesn't have the corresponding _Text_ file,
it can be because it is in use (close opened _Binariy_ and CLEAR ALL at VFP command window),
or because you really haven't made any changes to the code,
in which case you should undo the changes to the _Binaries_ that don't have their _Text_ files using the "undo" option
for these files of your SCM tool.


### Checkin because a merge operation
When you merge a branch, you work on _Text_ files seeing and merging differences manually or automatically.
When you have done with the merge you need to checkin, but before this,
you need to generate the _Binaries_ (forms, classlib, etc) just from the _Text_ files merged, to sync their code.
Once you have done, then you checkin the boundle of _Binaries_/_Text_.   
#### Note
If at the end of a merge operation there are _Binaries_ left, you need to choose the "workspace binaries",
because anyway you will generate them later from their _Text_ files.


For options on integrating FoxBin2Prg with SCM tools, look at this topic:
**> [FoxBin2Prg and use with SCM tools](./FoxBin2Prg_SCM.md)**

## How to use with _git_
See [FoxBin2Prg and use with git](./FoxBin2Prg_git.md)

----
![VFPX logo](https://vfpx.github.io/images/vfpxbanner_small.gif)   
This project is part of [VFPX](https://vfpx.github.io/).    

----
Last changed: _2022/06/10_ ![Picture](./pictures/vfpxpoweredby_alternative.gif)
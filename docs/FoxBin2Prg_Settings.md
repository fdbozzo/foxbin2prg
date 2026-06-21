# FoxBin2Prg Configuration
Documentation of FoxBin2Prg - A Binary to Text converter for MS Visual Foxpro 9

## Purpose of this document
This document shows the use of configuration files and the varius setrtings on FoxBin2Prg.

----
## Table of contents
- [Configuration file](#configuration-file)
  - [Multi config](#multi-configuration)
  - [Example](#example)
- [Configuration file per table](#configuration-file-per-table)
- [Excluding directories](#excluding-directories)

## Configuration file
The configuration how to run FoxBin2Prg is stored in configuration files, FoxBin2Prg.cfg for general settings, and [Configuration file per table](#configuration-file-per-table).

It is possible to create a template or a config with all options and comments via   
```
DO FOXBIN2PRG.PRG WITH "-c","template.cfg"    &&==> Generates a template for FoxBin2Prg.cfg config file with newest settings
DO FOXBIN2PRG.PRG WITH "-C","config.cfg"      &&==> Generates a config file like FoxBin2Prg.cfg with recent settings of path of second parameter
```

An example of a template is given in [Example](#example)
See [command line](./FoxBin2Prg_Run.md#usage-2).   
The config file is used to move local setting to a different comupter or for changes while branching.
 
The options in the template (or in the config that ships with FoxBin2Prg) are commented out.
To activate an option remove the asterix and set appropriate value.   

There is a [Multi config](#multi-configuration), that allows to have global settings with specific local settings.
If a setting does not follow inheritance, it is mentioned in the table below.

These are the FoxBin2Prg.cfg configuration file settings and their meaning.
The second line in the keyword column is the name of the respective property (if there is one)
in the settings object returned by get_DirSettings method of the API object. See [PEM](./FoxBin2Prg_Internals.md#pem).

| FoxBin2Prg.cfg keywords<br/>Property of settings object | Value (_Default_) | Description |
| ----- | ----- | ----- |
| Language | _(auto)_,<br/>EN, FR, ES, DE | Language of templates, shown messages and LOGs. EN=English, FR=French, ES=Español, DE=German, Not defined = AUTOMATIC (using VERSION(3)) ||
| DontShowProgress<br/>n_ShowProgressbar | 0 | **Deprecated**. Replaced by ShowProgressbar option from v1.19.40, see below.<br/>The values of 0 and 1 are inverted to ShowProgressbar. |
| ShowProgressbar<br/>n_ShowProgressbar | 0, _1_, 2 | 0=Don't show progressbar,<br/>1=Always show a progress bar,<br/>2=Only show it when processing multiple-files.<br/>**If set via parameter _cDontShowProgress_, this is ignored.<br/>_cDontShowProgress_ has value "0","1" inverted to the property.** |
| DontShowErrors<br/>n/a | _0_, 1 | 0=show message errors in a modal messagebox. (default)<br/>1=don't show errors<br/>**If set via parameter _cDontShowErrors_, this is ignored.**<br/>**There is no inheritance for this setting. First occurance wins.** |
| ExtraBackupLevels<br/>n/a | 0, _1_, n | <br/>0=No backup<br/>1=One backupfile _\_filename\_.BAK_ (default)<br/>n=n levels of backup in style _\_filename\_.n.BAK_<br/>**There is no inheritance for this setting. First occurance wins.** |
| Debug<br/>n_Debug | _0_, 1, 2 | 0=Off<br/>1=Normal<br/>2=Extended<br/>By default, don't generate individual \<file\>.Log with process hints.<br/>Activate with "1" to find possible error causes and for debugging,<br/>"2" is special logging.<br/>**If set via parameter _cDebug_, this is ignored.** |
| BackgroundImage<br/>c_BackgroundImage | \<cFile\> | Backgroundimage for process form |
| HomeDir<br/>n_HomeDir | 0, _1_ | 0=don't save HomeDir in PJ2,<br/>1=save HomeDir in PJ2.<br/>Setting this to 0 prevents the PJ2 file from changing just because two developers have the project in different folders |
| BodyDevInfo<br/>n_BodyDevInfo | _0_, 1, 2 | 0=Don't keep DevInfo for body pjx records, 1=Keep DevInfo, 2 = Don't keep DevInfo or ObjRev.<br/>Setting this to 2 prevents the PJ2 file from changing just because two developers built the project on their machines |
|||
| InhibitInheritance<br/>n_InhibitInheritance | _0_, 1, 2, 3 | **This settings is for config file via parameter only**. See [Multi config](#multi-configuration).<br/>Settings for config file via parameter only0=Allow scanning "regular" config files (file via parameter is just additional default)<br/>1=Only read tree from root of the file given by parameter, not FoxBin2Prg default<br/>2=Only read folder and subfolder of the file given by parameter<br/>3=Read no other file<br/>This is like<br/>0 Default \| Parameter file \| Default near FoxBin2Prg \| all other config files<br/>1 Default \| Parameter file \| Inheritance from root to parent of folder \| folder and subdirs<br/>2 Default \| Parameter file \| folder and subdirs<br/>3 Default \| Parameter file |
|||
| XXX_Conversion_Support | n | Defines the conversion operation per filetype |
| | | For code:<br/> 0=No support,<br/>1=Generate _Text_ (Diff),<br/>2=Generate _Text_ and _Bin_ (Merge) |
| | | For complex data:<br/> (PJX / DBC / DBF): 0=No support,<br/>1=Generate Header _Text_ only (Diff),<br/>2=Generate Header _Text_ and _Bin_ (Merge/Only Structure!),<br/>4=Generate _Text_ with DATA (Diff),<br/>8=Export and Import DATA (Merge/Structure & Data) |
| PJX_Conversion_Support<br/>.n_PJX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional ((Merge/Only Structure!),<br/>4=Generate _Text_ with DATA (Diff), 8=Export and Import DATA (Merge/Structure & Data) and _bin_) support activated |
| VCX_Conversion_Support<br/>.n_VCX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| SCX_Conversion_Support<br/>.n_SCX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| FRX_Conversion_Support<br/>.n_FRX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| LBX_Conversion_Support<br/>.n_LBX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| MNX_Conversion_Support<br/>.n_MNX_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| DBC_Conversion_Support<br/>.n_DBC_Conversion_Support | 0, 1, _2_ | Default value is 2 - Bidirectional (_Text_ and _bin_) support activated |
| DBF_Conversion_Support<br/>.n_DBF_Conversion_Support | 0, _1_, 2, 4, 8 | Default value is 1 - just _Text_ support activated.<br/>The support for regenerating DBFs structures (value = 2) are disabled by default to not overrite data accidentally. When activating bidirectional support, keep in mind that Data is not restored, just the structure and indexes!.<br/>A value of 4 is used to export Structure and Data, but exported data is not imported again.<br/>A value of 8 is used for bidirectional support (No General fields!). <br/> **Note:** This can be [changed per table](#configuration-file-per-table). |
| FKY_Conversion_Support<br/>.n_FKY_Conversion_Support | 0, _1_ | Default value is 1 - _Text_ support activated |
| MEM_Conversion_Support<br/>.n_MEM_Conversion_Support | 0, _1_ | Default value is 1 - _Text_ support activated |
|||
| CheckFileInPath<br/>n_CheckFileInPath | _0_, 1, 2, 3 |Determines how 2Txt deals with files not in the subfolders of the PJX. No handler for UNC paths.<br />0 = Ignore. Default<br />1 = Check and error out if file is not on same structure (for source control)<br />2 = Create absolute path if file is on different drive.<br />3 = Create absolute path if file is not in structure<br />See [Storing paths for pjx](./FoxBin2Prg_Internals.md#storing-paths-for-pjx) |
|||
| UseClassPerFile<br/>n_UseClassPerFile | _0_, 1, 2 | 0=One library _Text_ file,<br/>1=Multiple file.class.vc2 files,<br/>2=Multiple file.baseclass.class.vc2 files<br/>See [Create Class-Per-File](./FoxBin2Prg_Internals.md#create-class-per-file) |
| [RedirectClassPerFileToMain:](./FoxBin2Prg_Internals.md#redirectclassperfiletomain:)<br/>l_RedirectClassPerFileToMain | _0_, 1 | 0=Don't redirect to file.vcx,<br/>1=Redirect to file.vcx when selecting file.class.vc2<br/>RedirectClassType: 1 precedes this setting |
| RedirectClassType<br/>n_RedirectClassType | _0_, 1, 2 | For classes created with UseClassPerFile>0 in the form file[.baseclass].class.tx2 (vcx only) |
| | | 0=creates / refresh class in file.VCX and add / replace all other classes of this library |
| | | 1=creates / refresh class file[.baseclass].class.VCX and do not touch file.VCX |
| | | 2=creates / refresh class in file.VCX and do not touch other classes of file.VCX |
| [ClassPerFileCheck](./FoxBin2Prg_Internals.md#classperfilecheck)<br/>l_ClassPerFileCheck | _0_, 1 | 0=Don't check file.class.vc2 inclusion,<br/>1=Check file.class.vc2 inclusion<br/>Only used if import file is in file[.baseclass].class.tx2 syntax.<br/>Ignored for RedirectClassType: 2 |
|||
| [UseFormSettings](./FoxBin2Prg_Internals.md#create-file-per-form)<br/>l_UseFormSettings | _0_, 1 | 0=Old Style, like the class settings<br/>1=Form style, special for form<br/>This controls the use of the _UseFormPerFile_, _RedirectFormPerFileToMain_, _RedirectFormType_ and _FormPerFileCheck_ options.<br/>Only if this option is set, the options will be read. |
| UseFormPerFile<br/>n_UseFormPerFile | _0_, 1, 2 | 0=One library _Text_ file,<br/>1=Multiple Form.Object.sc2 files,<br/>2=Multiple Form.baseclass.Object.sc2 files<br/>See [Create Class-Per-File](./FoxBin2Prg_Internals.md#create-class-per-file) |
| [RedirectFormPerFileToMain](./FoxBin2Prg_Internals.md#redirectclassperfiletomain)<br/>l_RedirectFormPerFileToMain | _0_, 1 | 0=Don't redirect to Form.scx,<br/>1=Redirect to Form.scx when selecting Form.Object.sc2<br/>RedirectClassType: 1 precedes this setting |
| RedirectFormType<br/>n_RedirectFormType | _0_, 1, 2 | For classes created with UseClassPerFile>0 in the form Form[.baseclass].Object.sx2 (scx only) |
| | | 0=creates / refresh class in Form.SCX and add / replace all other classes of this library |
| | | 1=creates / refresh class Form[.baseclass].Object.SCX and do not touch Form.SCX |
| | | 2=creates / refresh class in Form.SCX and do not touch other classes of Form.SCX |
| [FormPerFileCheck](./FoxBin2Prg_Internals.md#classperfilecheck)<br/>l_FormPerFileCheck | _0_, 1 | 0=Don't check Form.Object.sc2 inclusion,<br/>1=Check Form.Object.sc2 inclusion<br/>Only used if import file is in Form[.baseclass].Object.sc2 syntax.<br/>Ignored for RedirectClassType: 2 |
|||
| OldFilesPerDBC<br/>l_OldFilesPerDBC | _0_, 1 | 0=Old Style,<br/>1=New style<br/>This controls the use of the _UseFilesPerDBC_, _RedirectFilePerDBCToMain_ and _ItemPerDBCCheck_ options.<br/>Only if this option is set, the **Form** options below will be read. |
| | | 0=New version inactive, options follow:<br/>UseFilesPerDBC=UseClassPerFile<br/>RedirectFilePerDBCToMain=RedirectClassPerFileToMain<br/>ItemPerDBCCheck=ClassPerFileCheck |
| | | 1=New version active, options active |
| | | Note: The options will be set to old style, if option is turned off. |
| UseFilesPerDBC<br/>n_UseFilesPerDBC | _0_, 1 | 0=One database dc2 file,<br/>1=Multiple file.\*.\*.dc2 files.<br/>See [Create File-Per-DBC](./FoxBin2Prg_Internals.md#create file-per-dbc)<br/>**Only if OldFilesPerDBC is 1** |
| | | 0=creates only a file.dc2 with all DBC (file) data |
| | | 1=creates a file.dc2 with DBC properties |
| | | and additional DBC files per DBC item (stored-proc, table, ..) |
| | | Note: recration only if RedirectFilePerDBCToMain is 1 |
| [RedirectFilePerDBCToMain](./FoxBin2Prg_Internals.md#redirectfileperdbctomain)<br/>l_RedirectFilePerDBCToMain | _0_, 1 | 0=Don't redirect to file.dc2,<br/>1=Redirect to file.tx2 when selecting file.item.*.dc2<br/>**Only if OldFilesPerDBC is 1** |
| [ItemPerDBCCheck](./FoxBin2Prg_Internals.md#itemperdbccheck)<br/>l_ItemPerDBCCheck | _0_, 1 | 0=Don't check file.item.*.dc2 inclusion,<br/> 1=Check file.item.*.dc2 inclusion<br/>**Only if OldFilesPerDBC is 1**|
|||
| NoTimestamps<br/>n/a | 0, _1_ | 0=Do not clear<br/>1=Clear<br/>By default, timestamp fields are cleared on _Text_ files, because a lot of differencies are generated on _Binaries_ and _Text_ files with Timestamps activated. This timestamp field is part of the vcx, scx and other Foxpro binary source code files.<br/>**If set via parameter _cNoTimestamps_, this is ignored.**<br/>**There is no inheritance for this setting. First occurance wins.** |
| ClearUniqueID<br/>n/a | 0, _1_ | 0=Keep UniqueID,<br/>1=Clear Unique ID.<br/>Very useful for Diff and Merge.<br/>By default, UniqueID fields are cleared on _Text_ files, because a lot of differencies are generated with UniqueID activated.<br/>**If set via parameter _cClearUniqueID_, this is ignored.**<br/>**There is no inheritance for this setting. First occurance wins.** |
| OptimizeByFilestamp<br/>n/a | _0_, 1 | 0=Don't optimize (always generate),<br/>1=Optimize (generate only when destination filestamp es older). By default this optimization is deactivated, and it is not recommended if using for merge, so _Bin_ and _Text_ files can be modified seperately.<br/><span style="background-color: gold;">Dangerous while working with branches!</span>.<br/>**If set via parameter _cOptimizeByFilestamp_, this is ignored.**<br/>**There is no inheritance for this setting. First occurance wins.** |
| RemoveNullCharsFromCode<br/>l_RemoveNullCharsFromCode | 0, _1_ | 1=Drop NULL chars from source code,<br/>0=Leave NULL chars in source code |
| RemoveZOrderSetFromProps<br/>l_RemoveZOrderSetFromProps | _0_, 1 | 1=Remove ZOrderSet from the properties,<br/>0=Leave ZOrderSet in the properties |
|||
| PRG_Compat_Level<br/>n_PRG_Compat_Level | _0_, 1 | 0=Legacy,<br/>1=Use HELPSTRING as Class Procedure comment. |
| ClearDBFLastUpdate<br/>l_ClearDBFLastUpdate | 0, _1_ | 0=Keep DBF LastUpdate,<br/>1=Clear DBF LastUpdate.<br/>Useful for Diff, minimizes differences. |
| ExcludeDBFAutoincNextval<br/>n_ExcludeDBFAutoincNextval | _0_, 1 | 0=Do not exclude this value from db2,<br/>1=Exclude this value from db2 |
| DBF_Conversion_Included<br/>c_DBF_Conversion_Included | * | If DBF_Conversion_Support:4, you can specify multiple filemasks: www,fb2p_free.dbf.<br/>See [Order and range of records](./FoxBin2Prg_Internals.md#order-and-range-of-records).<br/>**Note:** This can be [changed per table](./FoxBin2Prg_Internals.md#configuration-file-per-table). |
| DBF_Conversion_Excluded<br/>c_DBF_Conversion_Excluded | | If DBF_Conversion_Support:4, you can specify multiple filemasks: www,fb2p_free.dbf.<br/>See [Order and range of records](./FoxBin2Prg_Internals.md#order-and-range-of-records).<br/>**Note:** This can be [changed per table](./FoxBin2Prg_Internals.md#configuration-file-per-table). |
| DBF_BinChar_Base64<br/>l_DBF_BinChar_Base64 | 0, _1_ | 0=For character type fields, if NoCPTrans 0=do not transform,<br/>1=use Base64 transform (default)<br/>**Note:** This can be [changed per table](./FoxBin2Prg_Internals.md#configuration-file-per-table). |
| DBF_IncludeDeleted<br/>l_DBF_IncludeDeleted | _0_, 1 | 0=Do not include deleted records (default),<br/>1=Include deleted records<br/>**Note:** This can be [changed per table](./FoxBin2Prg_Internals.md#configuration-file-per-table). |
| | |  **Note:**<br/>This is only true for tables. Generating DBC to _Text_ and back to _Binary_ will act as PACK DATABASE.<br/>The data added by _DBF_IncludeDeleted: 1_ will be ignored by old versions generating _Binary_ files. |
|||
| extension: xx2 | | FoxBin2Prg extensions ends in '2' (pj2, vc2, sc2, etc), but you can change that. |
| extension: pj2=<br/>c_pj2 | \<extension\> | Extension for text file representing project PJX |
| extension: vc2=<br/>c_vc2 | \<extension\> | Extension for text file representing classlibray VCX, or a class out of a VCX |
| extension: sc2=<br/>c_sc2 | \<extension\> | Extension for text file representing form SCX, or a class out of a SCX (Form; Dataenbironment) |
| extension: fr2=<br/>c_fr2 | \<extension\> | Extension for text file representing report FRX |
| extension: lb2=<br/>c_lb2 | \<extension\> | Extension for text file representing label LBX |
| extension: mn2=<br/>c_mn2 | \<extension\> | Extension for text file representing menu MNX |
| extension: db2=<br/>c_db2 | \<extension\> | Extension for text file representing table DBF, free or DBC bound |
| extension: dc2=<br/>c_dc2 | \<extension\> | Extension for text file representing database container DBC, or records from database container DBC |
| extension: fk2=<br/>c_fk2 | \<extension\> | Extension for text file representing macro file FKY |
| extension: me2=<br/>c_me2 | \<extension\> | Extension for text file representing variable memory MEM, created with SAVE TO |
|  | | **Example for for making it SourceSafe (sccapi v1) compatible:**<br/>extension: pj2=pja<br/>extension: vc2=vca<br/>extension: sc2=sca<br/>extension: fr2=fra<br/>extension: lb2=lba<br/>extension: mn2=mna<br/>extension: db2=dba<br/>extension: dc2=dca  |

### Note
The options will be read outside in, top to down. See [Multi config](#multi-configuration)

#### Multi configuration
Starting at version v1.19.25 FoxBin2Prg allow configuration per directory,
overriding the main configuration of FoxBin2Prg directory.
The override is by each setting, so you can reconfigure one or more settings and the
remaining settings are inherited from main CFG.   

From v1.19.42 CFGs are inherited between directories from parent to child,
so if you have all your developments under, let's say, "c:\devs" directory and subdirs,
de CFG in "c:\devs" will be inherited on subdirs, and settings can be overriden one by one if you want to.
This inheritance saves a lot of time and minimizes the CFGs needed \:\)

The order is:
1. An optional configuration file given by the parameters [program / executable](./FoxBin2Prg_Run.md#usage-1) or [API, Execute method](./FoxBin2Prg_Object.md#execute)
2. An optional default configuration file next to the prg/exe
3. Any configuration file drive root up to current folder
3. Folder and subfolder of current folder. *This is, if called for a pjx, not only the pjx folder, any subfolder could have configuration file, valid for the files of this subfolder and it's subfolders.*

If the _optional configuration file given by the parameter_ sets `InhibitInheritance` on a different value the 0, the chain of inheritance will be different, see above.

##### Note
Options will be read outside in, top to down.   
If an option is defined multiple times, even in the same file, last occurance wins. There are some exceptions, see below.   

A different exception are the group controlling the new style to split DBC files and the one for forms.   
The options _UseFilesPerDBC_, _RedirectFilePerDBCToMain_ and _ItemPerDBCCheck_ will be ignored for DBC,
if _OldFilesPerDBC_ is set to 0.   
Setting _OldFilesPerDBC_ to 1 will inhertit the values from the \*class\* options.   
If _OldFilesPerDBC_ is set to 0 after it was active, the values of the three options are rejected at all and reset to the corresponding \*class\* values.   
For Forms, options _UseFormPerFile_, _RedirectFormPerFileToMain_, _RedirectFormType_ and _FormPerFileCheck_ will be ignored,
if _UseFormSettings_ is set to 0.   
Setting _UseFormSettings_ to 1 will inhertit the values from the \*class\* options.   
If _UseFormSettings_ is set to 0 after it was active, the values of the four options are rejected at all and reset to the corresponding \*class\* values.

###  Example
This is a template of a configuration file as created with
```
DO FOXBIN2PRG.PRG WITH "-c","template.cfg"    &&==> Generates a template for FoxBin2Prg.cfg config file with newest settings
```

```
*################################################################################################################
*FOXBIN2PRG.CFG configuration options: (If no values given, these are the DEFAULTS)
*Version: v1.21.05
*****************************************************************************************************************

* Note, configuration files will follow an inheritance.
* 1.  Default values
* 2., optional FOXBIN2PRG.CFG in folder of FOXBIN2PRG.EXE
*  or, if defined, a config file given by a parameter calling FOXBIN2PRG
*      if used, the InhibitInheritance setting controls if other config files will be evaluated (default). See below.
* 3., optional FOXBIN2PRG.CFG in root of working directory
* 4., optional FOXBIN2PRG.CFG in every folder up to the working directory
* 5., optional Special settings per single DBF's (Syntax: <TableName>.dbf.cfg in tables folder)

* Some Parameter calling FOXBIN2PRG.EXE overturn this settings (except Defaults)
*****************************************************************************************************************

*-- Settings for internal work, not processing
*Language: (auto)               && Language of shown messages and LOGs. EN=English, FR=French, ES=Español, DE=German, Not defined = AUTOMATIC [DEFAULT]
*ShowProgressbar: 1             && 0=Don't show, 1=Allways show, 2=Show only for multi-file processing
*                               && Note: This setting will be ignored, if cDontShowProgress parameter is set. 
*DontShowErrors: 0              && Show message errors by default
*                               && Note: This setting will be ignored, if cDontShowError parameter is set. 
*                               && Note: There is no inheritance for this setting. First occurance wins. 
*ExtraBackupLevels: 1           && By default 1 BAK is created. With this you can make more .N.BAK, or none
*                               && Note: There is no inheritance for this setting. First occurance wins. 
*Debug: 0                       && 0=Don't Activate individual <file>.Log by default
*                               && 1=Activate individual <file>.Log by default
*                               && 2=???
*                               && Only valid if not controlled by parameter cDebug
*BackgroundImage: <cFile>       && Backgroundimage for process form. Empty for empty Background. File not found uses default.
*HomeDir: 1                     && Home directory in PJX
*                               && 0 don't save HomeDir in PJ2
*                               && 1 save HomeDir in PJ2
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*-- Settings for config file via parameter only
*InhibitInheritance: 0          && 0=Allow scanning "regular" config files (file via parameter is just additional default)
*                               && 1=Only read tree from root of the file given by parameter, not FoxBin2Prg default
*                               && 2=Only read folder and subfolder of the file given by parameter
*                               && 3=Read no other file
*                               && This is like
*                               && 0 Default | Parameter file | Default near FoxBin2Prg | all other config files
*                               && 1 Default | Parameter file | Inheritance from root to parent of folder | folder and subdirs
*                               && 2 Default | Parameter file | folder and subdirs
*                               && 3 Default | Parameter file
*----------------------------------------------------------------------------------------------------------------

*-- Conversion operation by type
*PJX_Conversion_Support: 2      && 0=No support, 1=Generate TXT only (Diff), 2=Generate TXT and BIN (Merge)
*VCX_Conversion_Support: 2      && 0=No support, 1=Generate TXT only (Diff), 2=Generate TXT and BIN (Merge)
*SCX_Conversion_Support: 2      && 0=No support, 1=Generate TXT only (Diff), 2=Generate TXT and BIN (Merge)
*FRX_Conversion_Support: 2      && 0=No support, 1=Generate TXT only (Diff), 2=Generate TXT and BIN (Merge)
*LBX_Conversion_Support: 2      && 0=No support, 1=Generate TXT only (Diff), 2=Generate TXT and BIN (Merge)
*MNX_Conversion_Support: 2      && 0=No support, 1=Generate TXT only (Diff), 2=Generate TXT and BIN (Merge)
*DBC_Conversion_Support: 2      && 0=No support, 1=Generate TXT only (Diff), 2=Generate TXT and BIN (Merge)
*DBF_Conversion_Support: 1      && 0=No support, 1=Generate Header TXT only (Diff), 2=Generate Header TXT and BIN (Merge/Only Structure!), 4=Generate TXT with DATA (Diff), 8=Export and Import DATA (Merge/Structure & Data)
*FKY_Conversion_Support: 1      && 0=No support, 1=Generate TXT only (Diff)
*MEM_Conversion_Support: 1      && 0=No support, 1=Generate TXT only (Diff)
*----------------------------------------------------------------------------------------------------------------

*Setting for pjx files
*CheckFileInPath: 0             && Determines 2Txt deals with files not in the subfolders of the PJX. No handler for UNC paths.
*                               && 0 Ignore. Default
*                               && 1 Check and error out if file is not on same structure (for source control)
*                               && 2 Create absolute path if file is on different drive.
*                               && 3 Create absolute path if file is not in structure
*----------------------------------------------------------------------------------------------------------------

*Setting for container files (not pjx)
*-- CLASS (, FORM and DBC) options (tx2 is to read as vc2 or sc2, VCX might be SCX)
*-- FORM and DBC options default to this settings, if not set otherwise. See below.
*- Class per file options (UseClassPerFile: 1)
*UseClassPerFile: 0             && Determines how a library (or form) will handle included class (or, for forms, objects)
*                               && 0 One library.tx2 file
*                               && 1 Multiple file.class.tx2 files
*                               && 2 Multiple file.baseclass.class.tx2 files
*RedirectClassPerFileToMain: 0  && When regenerating binary files, determine target file
*                               && 0 Don't redirect to file.vcx/scx
*                               && 1 Redirect to file.vcx/scx when selecting file[.baseclass].class.tx2
*                               &&   RedirectClassType: 1 has precedence
*RedirectClassType: 0           && For classes created with UseClassPerFile>0 in the form file[.baseclass].class.tx2
*                               && Those files could be imported like file.tx2::Class::import or like file[.baseclass].class.tx2
*                               && For the second form:
*                               && 0 Redirect file[.baseclass].class.tx2 to file.VCX and add / replace all other classes of this library
*                               && 1 Redirect file[.baseclass].class.tx2 to file[.baseclass].class.VCX and do not touch file.VCX
*                               && 2 Redirect file[.baseclass].class.tx2 to file.VCX and do not touch other classes of file.VCX
*ClassPerFileCheck: 0           && Check, if files listed in the main file of a library or form will be included
*                               && 0 Don't check file inclusion
*                               && 1 Check file[.baseclass].class.tx2 inclusion
*                               &&   Only used if import file is in file[.baseclass].class.tx2 syntax
*                               &&   Ignored for RedirectClassType: 2
*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

*-- FORM options
*- Form per file options (UseFormSettings: 1)
*UseFormSettings: 0             && 1=Turns the File per SCX options on, 0 uses the old UseClassPerFile etc settings.
*                               &&   Options below will only read if UseFormSettings is set 1 before!
*                               &&   If UseFormSettings is set 0 later, all setting will be lost
*UseFormPerFile: 0              && Determines how a form will handle included objects
*                               && 0 One Form.sc2 file
*                               && 1 Multiple Form.Obj.sc2 files
*                               && 2 Multiple Form.baseclass.Obj.sc2 files
*RedirectFormPerFileToMain: 0   && When regenerating binary files, determine target file
*                               && 0 Don't redirect to Form.scx
*                               && 1 Redirect to Form.scx when selecting Form[.baseclass].Obj.sc2
*                               &&   RedirectFormType: 1 has precedence
*RedirectFormType: 0            && For classes created with UseFormPerFile>0 in the form Form[.baseclass].Obj.sc2
*                               && Those files could be imported like Form.sc2::Class::import or like Form[.baseclass].Obj.sc2
*                               && For the second form:
*                               && 0 Redirect Form[.baseclass].Obj.sc2 to Form.SCX and add / replace all other classes of this library
*                               && 1 Redirect Form[.baseclass].Obj.sc2 to Form[.baseclass].Obj.SCX and do not touch Form.SCX
*                               && 2 Redirect Form[.baseclass].Obj.sc2 to Form.SCX and do not touch other classes of Form.SCX
*FormPerFileCheck: 0            && Check, if files listed in the main file of a library or form will be included
*                               && 0 Don't check file inclusion
*                               && 1 Check Form[.baseclass].Obj.sc2 inclusion
*                               &&   Only used if import file is in Form[.baseclass].Obj.sc2 syntax
*                               &&   Ignored for RedirectFormType: 2
*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

*-- DBC options
*- File per DBC options (UseFilesPerDBC: 1)
*OldFilesPerDBC: 0              && 1=Turns the File per DBC options on, 0 uses the old UseClassPerFile etc settings.
*                               &&   Options below will only read if OldFilesPerDBC is set 1 before!
*                               &&   If OldFilesPerDBC is set 0 later, all setting will be lost
*UseFilesPerDBC: 0              && 0=One database dc2 file, 1=Multiple file.*.*.dc2 files
*                               && 0 creates only a file.dc2 with all DBC (file) data
*                               && 1 creates a file.dc2 with DBC properties
*                               &&   and additional DBC files per DBC item (stored-proc, table, ..)
*                               &&   Note: recration only if RedirectFilePerDBCToMain is 1
*RedirectFilePerDBCToMain: 0    && 0=Don't redirect to file.dc2, 1=Redirect to file.tx2 when selecting file.item.*.dc2
*ItemPerDBCCheck: 0             && 0=Don't check file.item.*.dc2 inclusion, 1=Check file.item.*.dc2 inclusion
*----------------------------------------------------------------------------------------------------------------

*-- General files
*NoTimestamps: 1                && Clear timestamps of several file types by default for minimize text-file differences
*                               && Note: This setting will be ignored, if cNoTimestamps parameter is set. 
*                               && Note: There is no inheritance for this setting. First occurance wins. 
*ClearUniqueID: 1               && 0=Keep UniqueID in text files, 1=Clear Unique ID. Useful for Diff and Merge
*                               && Note: There is no inheritance for this setting. First occurance wins. 
*OptimizeByFilestamp: 0         && 1=Optimize file regeneration depending on file timestamp. Dangerous while working with branches!
*                               && Note: There is no inheritance for this setting. First occurance wins. 
*RemoveNullCharsFromCode: 1     && 1=Drop .Null. chars from source code
*RemoveZOrderSetFromProps: 0    && 0=Do not remove ZOrderSet property from object, 1=Remove ZOrderSet property from object
*PRG_Compat_Level: 0            && 0=Legacy, 1=Use HELPSTRING as Class Procedure comment
*----------------------------------------------------------------------------------------------------------------

*-- PJX special
*BodyDevInfo: 0                 && 0=Don't keep DevInfo for body pjx records, 1=Keep DevInfo, 2 = Don't keep DevInfo or ObjRev
*----------------------------------------------------------------------------------------------------------------

*-- DBF special
*ClearDBFLastUpdate: 1          && 0=Keep DBF LastUpdate, 1=Clear DBF LastUpdate. Useful for Diff.
*ExcludeDBFAutoincNextval: 0    && 0=Do not exclude this value from db2, 1=Exclude this value from db2
*DBF_Conversion_Included: *     && If DBF_Conversion_Support:4, you can specify multiple filemasks: www,fb2p_free.dbf
*DBF_Conversion_Excluded:       && If DBF_Conversion_Support:4, you can specify multiple filemasks: www,fb2p_free.dbf
*DBF_BinChar_Base64: 1          && For character type fields, if NoCPTrans 0=do not transform, 1=use Base64 transform (default)
*DBF_IncludeDeleted: 0          && 0=Do not include deleted records (default), 1=Include deleted records
*----------------------------------------------------------------------------------------------------------------

*-- Text file extensions
*extension: tx2=newext          && Specify extensions to use. Default FoxBin2Prg extensions ends in '2' (see at the bottom)
*-- Example configuration for SourceSafe compatibility:
*extension: pj2=pja             && Text file to PJX
*extension: vc2=vca             && Text file to VCX
*extension: sc2=sca             && Text file to SCX
*extension: fr2=fra             && Text file to FRX
*extension: lb2=lba             && Text file to LBX
*extension: mn2=mna             && Text file to MNX
*extension: db2=dba             && Text file to DBF
*extension: dc2=dca             && Text file to DBC
*-- Additional extensions
*extension: fk2=fkx             && Text file to FKY
*extension: me2=fkx             && Text file to MEM
*
```

## Configuration file per table
Those configuration files are valid for a single table only. The idea is to have special settings for single tables.   

It is possible to create a template with all options and comments via
```
DO FOXBIN2PRG.PRG WITH "-t","template.dbf.cfg"  &&==> Generates a template for table.dbf.cfg per table config file with newest settings.
```

See [command line](./FoxBin2Prg_Run.md#usage-2).   
The options in the template (or in the config that ships with FoxBin2Prg) are commented out.
To activate an option remove the asterix and set appropriate value.   
These are the Table.dbf.cfg configuration file settings and their meaning:

| FoxBin2Prg.cfg keywords | Value | per<br/>file | Description |
| ----- | ----- | ----- | ----- |
| DBF_Conversion_Support | 0, 1, 2, 4, 8 | | 0=No support,<br/>1=Generate Header _Text_ only (Diff),<br/>2=Generate Header _Text_ and _Bin_ (Merge/Only Structure!),<br/>4=Generate _Text_ with DATA (Diff),<br/>8=Export and Import DATA (Merge/Structure & Data) |
| DBF_Conversion_Order | c_Expression | x | Field expresion (For _INDEX ON_). ie: name+str(age,3),<br/>Empty means no sort order. <br/> usefull only if *DBF_Conversion_Support* >0 |
| DBF_Conversion_Condition | c_Expression | x | Logical expression (For _SCAN FOR_). ie: age > 10 AND NOT DELETED(),<br/>empty means all records, except *DBF_IncludeDeleted* <br/> usefull only if *DBF_Conversion_Support* >0  |
| DBF_IndexList | c_FileList | x | A comma delimited list of additional index files ( cdx or idx ). __Not the structural index file.__ |
| DBF_BinChar_Base64 | 0, 1 | | 0=For character type fields, if NoCPTrans 0=do not transform,<br/>1=use Base64 transform <br/> usefull only if *DBF_Conversion_Support* > 2  |
| DBF_IncludeDeleted | 0, 1 | | 0=Do not include deleted records,<br/>1=Include deleted records <br/> usefull only if *DBF_Conversion_Support* > 2  |

Setting *per file** could only be used via this configuration file.
For defaults, see [Configuration file](#configuration-file).
 
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

## Excluding directories
It is possible to exclude directory structures from processing. Placing a **.FoxBin2Prg_Ignore** file into a directory will stop FoxBin2Prg from processing any file in this directory and it's subdirectories. The file must just exist and could otherwise be empty.   
The difference to setting all *XXX_Conversion_Support to 0* is, that it could not be turned on again down the directory structure.

This was set up to ignore the local GoFish_ settings and history folder, the file will be automatically created by GoFish starting with version 6.2.004.

----
![VFPX logo](https://vfpx.github.io/images/vfpxbanner_small.gif)   
This project is part of [VFPX](https://vfpx.github.io/).    

----
Last changed: _2026/06/21_ ![Picture](./pictures/vfpxpoweredby_alternative.gif)
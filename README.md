# FoxBin2Prg v1.19.57
**Binary/Text Converting program for Microsoft Visual FoxPro**

## Lutz Scheffler
![VFPX Logo](https://vfpx.github.io/images/vfpxbanner_small.gif)

## Why this fork?
This is a fork of [Fernando D. Bozzo](https://github.com/fdbozzo) [foxbin2prg](https://github.com/fdbozzo/foxbin2prg/).  
It's main purpose it's to fix some bugs and add some new functions. It looks like Fernando does not longer maintain FoxBin2Prg,
 so, with his permission, I introduce this fork to [VFPX](https://vfpx.github.io/) ![VFPX Picture](./pictures/vfpxpoweredby_alternative.gif).

I do not maintain the spanish documentation - it would fade. So just check Fernados repo for this information.   
A quick run is [introduced](#use-foxbin2prg), more [complex](./Documentacion/github/FoxBin2prg_Run.md#usage-1), and a large [documentation](./Documentacion/github/FoxBin2prg.md) exists too.
Remember yourself to compile the exe first.   
For a quick few of the changes made by the fork, see [Changes by the fork](#changes-by-the-fork).

---
---


If you like to see Fernandos blog, or value his work:   
- Blog: http://fdbozzo.blogspot.com.es/
- [![DONATE!](http://www.pngall.com/wp-content/uploads/2016/05/PayPal-Donate-Button-PNG-File-180x100.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&amp;business=fdbozzo%40gmail%2ecom&amp;lc=ES&amp;item_name=FoxBin2Prg&amp;item_number=FoxBin2Prg&amp;currency_code=USD&amp;bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted) 

    Thank you for your support!

---
---
If you like to value my work, support the Geeks at https://virtualfoxfest.com/ or www.swfox.net.  
I also do not reject invitations to beer, Next autumn in Gilbert.

---
---

## What is FOXBIN2PRG?
It is a program intended to be used with **SCM tools** (Source Code Managers, like VSS, CVS, SVN)
and *DVCS tools* (Version Control Systems such as Git, Mercurial, Plastic, and others),
or as **standalone** program for **Diff** (viewing differences) and **Merge** operations.
Foxbin2prg can substitute for **SccText/X**, **TwoFox** and others,
and enhance their functionality, generating bidirectional PRG-Style versions of Foxpro binary files that allow recreating the original binary file.

## Advantages:

* It generates "PRG" _style_ text files from Foxpro binary files for use in SCM and VCS systems and for visual comparison.

    (it's not really a prg, and can not be compiled, but it reads like one to Foxpro developers.)
* It enables the change of the Text version as easy as modifying a PRG.
* All the program code for any binary file (a form, a report, a class) is in just one text file, to simplify its maintainability.
* You can regenerate the original binaries from the text files, so it is useful as backup
* The extensions are configurable if you create a FOXBIN2PRG.CFG file
* Inheritance of CFG configuration files between directories
* Methods and properties of Text versions are alphabetically sorted for easy comparison
* You can set the "UseClassPerFile" setting to create individual files by class or DBC member. 

    (Which violates number three above, but it may be what you want.) 
* Takes advantage of the Win32 API using foxbin2prg as an object
* It has compatibility with SccText/X at the parameter level so that it can be used as substitute for SccText with SourceSafe. (Not that we recommend SourceSafe.)
* Productivity: You can create a shortcut in the "SendTo" folder on your user Windows Profile, so you can "send" the selected file (pjx,pj2,etc) to Foxbin2prg.exe and make on-the-fly conversions
* You can modify the TX2 Prg-Style versions of your objects with MODIFY COMMAND (without compile) to see colored syntax, or even use the Document View to navigate the procedures
* Get back your SourceSafe projects (.pjx) from their .pjm file

The program supports conversions between PJX,SCX,VCX,FRX,LBX,DBC,DBF and MNX files, for which it generates TEXT versions with extension PJ2,SC2,VC2,FR2,LB2,DC2,DB2 and MN2. If you want, the created text file extensions can be reconfigured to be compatibilize with SourceSafe.

## Examples
### Redefine extensions of _Text_ 
Here is an example of a FOXBIN2PRG.CFG configuration file if you need to change extensions for using it with a specific VSS (SourceSafe)
```
extension: SC2=SCA
extension: VC2=VCA
extension: PJ2=PJA
extension: MN2=MNA
extension: FR2=FRA
extension: LB2=LBA
extension: DB2=DBA
extension: DC2=DCA
```

### Use FoxBin2Prg
```
DO FOXBIN2PRG.PRG WITH "<path>\archivo.scx"     ==> Generates the TEXT version sc2 extension
DO FOXBIN2PRG.PRG WITH "<path>\archivo.sc2"     ==> Regenerates the binary version with scx extension

DO FOXBIN2PRG.PRG WITH "-c","template.cfg"      ==> Generates a template for FoxBin2Prg.cfg config file with newest settings
DO FOXBIN2PRG.PRG WITH "-t","template.dbf.cfg"  ==> Generates a template for table.dbf.cfg per table config file with newest settings
```

### Use with MS Windows SendTo
You can create up to three different shortcuts pointing to FoxBin2Prg.exe and in your "SendTo" folder in your Windows profile. This allows you to "send" a selected file (pjx,pj2,etc) to the selected option, and make on-the-fly conversions. (Make sure you have the option for seeing known file extensions turned on!):

#### Process directories or individual files to _Text_
- Name:  
  `FoxBin2Prg - Binary2Text.lnk`   
- Right-click/Properties/destination_    
  `<path>\foxbin2prg.exe "BIN2PRG-SHOWMSG"` 
#### Process directories or individual files to _Binary_
- Name:  
  `FoxBin2Prg - Text2Binary.lnk`   
- Right-click/Properties/destination_    
  `<path>\foxbin2prg.exe "PRG2BIN-SHOWMSG"` 
#### Process individual files or directories asking what to convert
- Name:  
  `FoxBin2Prg.lnk`   
- Right-click/Properties/destination_    
  `<path>\foxbin2prg.exe "INTERACTIVE-SHOWMSG"` 

##### How to use the links
Select a file, right-click, SendTo -> FoxBin2Prg

## LOCALIZATION:
Is automatic starting at v1.19.38 (Languages: EN,ES,FR,DE)


## FINAL NOTE:
This program is Open Source and "libre", and I don't make any guaranties that it fulfills your expectations or that it will be free of bugs.
I will try to fix bugs if my obligations let me do it.

## Project info and updates: 

Fernando D. Bozzo's repository at Github: https://github.com/fdbozzo/foxbin2prg   
Lutz Scheffler's repository at Github: https://github.com/lscheffler/foxbin2prg

## LICENCE:
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.

---
---
## Changes by this fork (1.19.55)
To get the new settings in config file, use the new create-a-template function:

```
DO FOXBIN2PRG.PRG WITH "-c","template.cfg"      ==> Generates a template for FoxBin2Prg.cfg config file with newest settings
DO FOXBIN2PRG.PRG WITH "-t","template.dbf.cfg"  ==> Generates a template for table.dbf.cfg per table config file with newest settings
```

### Exe file
Removed exe file. Just a bloat of teh repo, any disciple of the Fox know how to create, if in need.
The prg works anyway.

### Split of container files
VCX, SCX and DBC are container that hold different items. There is was a single option to split them.   
The split of DBC the same way like VCX/SCX might not be the best choice under all circumstances.  
New option _OldFilesPerDBC_ is set 1, _UseFilesPerDBC_, _RedirectFilePerDBCToMain_ and _ItemPerDBCCheck_ might be used to set the handling of the DBC.   
Note that those options will be ignored, if _OldFilesPerDBC_ is 0 (default).   
**Check that changes will be reflected on running projects.**   
See [Internals](./Documentacion/github/FoxBin2prg_Internals.md#configuration-file).  

### Tanscoding of table fields with NoCPTrans
The function _DBF_BinChar_Base64: 0_ must be handled with care too.
Tables must converted to _Text_ according. **It's not recommended for running projects. Handle with extra care otherwise.**

### Inclusion of deleted records
Sometimes information left in deleted (table) records is still valuable information.
The new option _DBF_IncludeDeleted_ allows to keep those records throug conversion.   
The data added by _DBF_IncludeDeleted: 1_ will be ignored by old versions generating _Binary_ files.

#### Recomendation
It's a good idea to have the _FoxBin2Prg.cfg_ per projekt and and source control,
old commits / versions would have the old config.  
So the settings would fit the data and FoxBin2Prg could generate according to it.
	
### Fixes
Fixes only are in the fork branch of this repo.

| Details |
| - |
| Added MEM and FKY options to config template and internal documentation |
| Conversion prg -> vcx, files per class could create one class multiple times |
| Processing directory, flush log file after loop instead of file |
| Conversion prg -> dbf, fields with .NULL. value are incorectly recreated |
| Minor translations |
| Conversion dbf -> prg, error if only test mode (toFoxBin2Prg.l_ProcessFiles is false) |
| DBF_Conversion_Condition, problem with macro expansion |
| Bug on special setting for import in form file[.baseclass].class.vc2 |
| Bug on RedirectClassType = 2 mixed up PATH |
| Bug on RedirectClassType = 2, UseClassPerFile = 2 failed |

### Features

| Details |
| - |
| [Documentation](./Documentacion/github/FoxBin2prg.md) reworked. |
| German translation improved |
| Info screen-doc improved |
| Inserted option DBF_IncludeDeleted to allow including deleted records of DBF |
| Inserted option DBF_BinChar_Base64 to allow processing of NoCPTrans fields in non base64 way |
| Inserted option OldFilesPerDBC to control split of DBC, the options below are controled by this |
| Inserted option UseFilesPerDBC to split DBC processing from vcx / scx |
| Inserted option RedirectFilePerDBCToMain to split DBC processing from vcx / scx |
| Inserted option ItemPerDBCCheck to split DBC processing from vcx / scx |
| added option to create config file template |
| New value 2 for option RedirectClassType. Alter single class for input form file[.baseclass].class.vc2 |


---
---
# Folder information
Project to generate text representations of VFP binary sources for source control

## ./
This folder containes the files necessary to run FoxBin2Prg.prg or to create the FoxBin2Prg.exe

For usage see [documentation](./Documentacion/github/FoxBin2prg.md)

----
Last changed: _2021/03/05_ ![Picture](./pictures/vfpxpoweredby_alternative.gif)
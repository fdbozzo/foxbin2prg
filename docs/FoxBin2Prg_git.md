# Use with git
Documentation of FoxBin2Prg - A Binary to Text converter for MS Visual Foxpro 9

## Purpose of this document
Using FoxBin2Prg with git.   
See [Use with SCM tools](./FoxBin2Prg_SCM.md)

----
## Table of contents
- [Introduction](#introduction)
- [Requirements](#requirements)
- [Tools](#tools)
- [Recomendations](#recomendations)
   - [git settings](#git-settings)
   - [settings per project](#settings-per-project)
     - [gitignore](#gitignore)
     - [gitattributes](#gitattributes)
     - [config](#foxbin2prg-config)

## Introduction
As we all know, there is a whole bunch of tools that we might use to colaborate and to version our work.  
Since I use git I try to point out what I do to do as fast and comfortable work.   
This document gives no workflow, in special not a workflow of git. There is no wrong or right.   
If you are not familar with git, please read through this first, there are minor settings that might help a bit on later work.

Please note, if you come from a SCM system, git feels very odd. It's a complete different idea of thinking.
Do yourself the favour, on [git-scm](https://git-scm.com/doc) you find _pro git_. Read and work at least through the first three chapters.
**No matter, if you are using git on bash or GUI**

There is a bunch of common traps to avoid - like storing credentials to github - I recommend [Oh my git!](https://ohmygit.org/) too.

For almost anything you don't need a server, even for colaborating a storage is enough.
I use a server - a self hosted copy of gitlab - but this basically for access restrictions and remote work. 

Do not hesitate to try anything. Always remember, git is just a couple of files inside your project folder.
CTRL+C, CTRL+V on Explorer might save the day. ;)

## Requirements
### #1
A copy of FoxBin2Prg.   
Or Install via [Thor](https://github.com/VFPX/Thor/blob/master/Docs/Thor_install.md), this keeps you on the latest version.

### #2
It might be a good idea to have a copy of git.   
If you [download](https://git-scm.org) a setup or clone the code and compile yourself is up to you.
I prefer the setup - it's a nice package with all bells and whistles one might need on command line.
See [git settings](#git-settings) for stuff to set during setup.

### #3
I prefer it on the bash. Some of the reasons
- It's complex. If a GUI does something wrong, you need to go to the bash anyway.
   - Note, every git-GUI is simple a tool that needs git to run original commands.
- It's simple. For day to day work, it's some easy to learn commands.
- The little visual need I have, and yes, some commands too, run on gitk, what ships with git for windows
- bash, because all help out of the web comes in 'nix style, rethink to the windows world is to much work.
- working on the command line gives ideas of doing the stuff using the Fox, and we are programmmers, are we?
- since we have those extra step to create _Text_ and _Binary_ around the git repo, any GUI is awkward.

The use of git on the command line is not a taste all like.
So if you need a GUI tool, it's your choice. [git-scm.org](https://git-scm.org) list a lot, and there might be more out.   
Or use the Fox and build your own - it's nothing then some commands and handling text files.

## Tools
To integrate git into the Fox [VFPX](https://vfpx.github.io/) lists some tools.   
I'm somehow into the [Bin 2 Text extension](https://github.com/lscheffler/bin2text), but then I know this best.   

A nice graphical compare / mergetool is nice too have - check if and how to integrate first,
and also if the code monkey creating the interface understands git.
Some try to use it like SCM, what ends up odd.

## Recomendations
#### Short about git
The first one must understand here, git is set up to deal with text based files.
It's a Linux tool developed to deal with Linux - the Kernel code.  
Highly sophisticated, neat, fast.  
So storing binaries into it is something one should avoid as far as possible.

There is stuff where one might not circumvent it - like pictures.

#### Text representation of VFP's binaries
And there is the oddness of VFP sources. Storing those to git is as wrong as it could be.
- Bloat of the repo
- No trace of changes
- Not mergeable

And if there is one what is realy cool on skipping locking servers, it's colaboarting.
Even on VCX's.

#### Solution
With thanks to Fernando **FoxBin2Prg** comes into play.  
One might be reluctant to dropping the binaries - but I do for years and it works like a charm.
Do not play around with text-to-look-up-changes ideas storing both _Text_ and _Binary_.
Just merge, compare like a normal text based language.   
The only thing one must learn (and remember, even after odd merges) is to run FoxBin2Prg wrapping any git operation.

git would even allow to hook FoxBin2Prg to run after some git operations, but this might be a killer.

I try to show what to set to keep it running as _Text_ - only storage.

#### Class libraries
I know there is a lot how to store a class. Microseconds here and there. 
Folks, hardware is cheap. There is no sense in counting ticks and bits any more. I'm grown up that way, but.  
Dealing with the FoxBin2Prg.prg is the limit.
If I imagine to have one of my larger vcx's like this in a merge view - no.

Just split up the vcx's into single classes using FoxBin2Prg for git purposes. It's like a charm on merge and diff.
Also on blame.   
If you go for the _lib.baseclass.classname.vc2_ or _lib.classname.vc2_ style is a matter of taste.
I can see baseclass on classname, so there is not much value, other might think different.
But split into classes makes life easy.   
This is to be done in the [config file](#foxbin2prg-config), setting _UseClassPerFile_ option to 1 or 2.

#### Forms
Side effect of splitting VCX is that SCX will be split into 3 files too.
I have no idea if there is some use of it - I just do classes.
If you like it separated from VCX - let me know.

#### Databases
Splitting DBC is possible too. My approach does not touch the DBC _structure_ (it's meta data only) in the source over decades,
so there is little use. 
So I've added an option to inhibit splitting DBC while splitting VCX/SCX.   

#### Tables
Since nobody brought up the .NULL. problem, it looks like it's not commonly used. It works for me for a while now and I found no problems so far.

##### Note
I do DBF / DBC to text and vice versa for a while now, but still with the binaries. I found no problem yet, except the binaries are a pain on merges.
What I see is that a synthetic PK is helpfull, not all the lookups had one. So I added one just for the purpose of merging.

#### Others
All the other table-based-sources of VFP work seamless as _Text_. No fuzz.

### git settings
Those settings are mainly per user (in _git_ terms **global**)

----
Assuming you do a fresh install of git, you will be asked questions over questions. The most you left unchanged.   
The one I recommend is the dealing with line endings. You know all the odd uses of LF and CR. 
_git_ offers to alter this while dealing with your files. I recommend not.
Just "Check in as is, check out as is" while installing _git for windows_.
This will keep your files, and any modern editor or WEB UI will not care anyway.   
If you missed on install - just install again.   

Do not forget to set up username, email and a ssh key. The following script sets up git and creates the key.
It will copy the public key to _clipboard_ too - ready to paste into github. Anyway, you allways can copy the contents of `~/.ssh/id_rsa.pub`.
Note, this will clear data, so do not run twice or on the wrong comp. A key overwritten is lost!
````
#!/bin/sh
#--------------------------------------------
#  create_rsa.sh
#
#	Abstract:
#   create an rsa ssh key an ~/.ssh
#   with options to git
#
#   set email and domain in this file
#
#   Written by SF
#   May 2018
#--------------------------------------------

user=="your name"
email="$user@$domain"

cd ~
if test -d .ssh
then
 cd .ssh
 rm id_rsa.*
 rm id_rsa
else
 mkdir .ssh
 cd .ssh
fi

ssh-keygen -t rsa -b 4096 -C "$email"
cat ~/.ssh/id_rsa.pub | clip
 
git config --global user.name "$user"
git config --global user.email "$email"
````
Depending on your needs you might set a password or not.

#### Note
For some odd reasons, the people on git-scm are going the way of evil. If you start the Setup of git, all depends who you are.
If you not check _Run as Adminstrator_, it will install into your user folder. Even if installed in Programs folder earlier!

### Settings per project
Those settings are mainly per project (in _git_ terms **local**). One can argue to put the one or other in different levels.
I recommend those inside the project to keep the repository as self contained as possible.
#### gitignore
The _.gitignore_ file controls which files **go not** into the git repository by default. It goes by folder with inheritance.
If you understand the inheritance of .gitignore, you grok [FoXBin2Prg.cfg](#foxbin2prg-config) and vice versa. Very close.

But git would not be git if one could not teach .gitignore to define the files **included**.
Again, see pro-git.

Creating the file might be a bit odd on MS Windows (Windows dislikes just extension). Created once, most editors will not complain.
In case, just open the bash in your projects base folder (Explorer, context menu) and enter `touch .gitignore`.

An example for _Text_ only use.
````
#.gitignore
#exclude general
*.*

#include general
#dbx data
!*.dbf
!*.cdx
!*.fpt

!*.dbc
!*.dc[tx]

#grafics
!*.bmp
!*.msk
!*.ico
!*.cdr
!*.cur

#programms
!*.prg
!*.fpw

#header
!*.h

#libs (by FoxBin2Prg)
#!*.vc[xt]
#!*.pj[xt]
#!*.fr[xt]
#!*.mn[xt]
#!*.sc[xt]
#!*.lb[xt]

#FoxBin2Prg
!*.vc2
!*.pj2
!*.fr2
!*.mn2
!*.sc2
!*.lb2
#!*.d[bc]2

#include special
#default git
!*.gitignore
!*.gitattributes
!/desktop.ini
#desktop.ini. usless? no! it keeeps the folder icon!

#diverse
!*.reg
!/FoxBin2Prg.cfg
!README.md

#exclude special again
foxuser.*
_command.prg
````
As you see, this assumes that tables and databases are stored as binary.  
I think I will swap to use them as _Text_ too, since version 1.19.55 of FoxBin2Prg eleminates some problems with this idea.

Also this approach ignores any bak / log / tmp / err files by default.

#### gitattributes
The _.gitattributes_ file controls some things that might be set to as local computer / user / repository (via _git config_),
but should be constant to the repository, no matter the local settings. This file is included into the repository.   
for VFP purposes, it controls the processing of line ending on commit / checkout.   
As mentioned [above](#git-settings) git might manipulate CRLF and LF. If the settings are different on different computers ,
it might checkout with LF instead of CRLF. This creates useless files in the commit, but also might create havoc using the files.
See [this](https://github.com/VFPX/GoFish/issues/27) for an example.   
To solve this, add a _.gitattributes_ file to any of your projects, next to the _.gitignore_ file. It should look like this:
````
#.gitattributes
# disable newline conversion on checkout with no conversion on check-in for all files
* -text
````
If you have a project running, check the line endings and make shure they follow DOS standard CRLF.

#### FoxBin2Prg config
The config of FoxBin2Prg using FoxBin2Prg.cfg files is relative simple. As you might see above, I carry the file within the repo.   
The good on this is, if I change my mind and alter settings in it, FoxBin2Prg will find the setting that fit to the data on each commit.
If I have to checkout old stuff - the setting will fit.

````
*################################################################################################################
*FOXBIN2PRG.CFG configuration options: (If no values given, these are the DEFAULTS)
*Version: v1.19.69
*****************************************************************************************************************

* Note, configuration files will follow an inheritance.
* 1.  Default values
* 2., optional FOXBIN2PRG.CFG in folder of FOXBIN2PRG.EXE
* 3., optional FOXBIN2PRG.CFG in root of working directory
* 4., optional FOXBIN2PRG.CFG in every folder up to the working directory
* 5., optional Special settings per aingle DBF's Syntax: <Tabellenname>.dbf.cfg in tables folder)
* 6., Parameter calling FOXBIN2PRG.EXE.

* Some Parameter calling FOXBIN2PRG.EXE overturn this settings (except Defaults)
*****************************************************************************************************************

*-- Settings for internal work, not processing
*Language: (auto)               && Language of shown messages and LOGs. EN=English, FR=French, ES=Español, DE=German, Not defined = AUTOMATIC [DEFAULT]
*ShowProgressbar: 1             && 0=Don't show, 1=Allways show, 2= Show only for multi-file processing
*DontShowErrors: 0              && Show message errors by default
*ExtraBackupLevels: 1           && By default 1 BAK is created. With this you can make more .N.BAK, or none
*Debug: 0                       && Don't Activate individual <file>.Log by default
*BackgroundImage: <cFile>       && Backgroundimage for process form. Empty for empty Background. File not found uses default.
*HomeDir: 1                     && Home Directory in PJX
*                               && 0 don't save HomeDir in PJ2
*                               && 1 save HomeDir in PJ2
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

*Setting for container files (not pjx)
*-- CLASS and FORM options (tx2 is to read as vc2 or sc2, VCX might be SCX)
*- Class per file options (UseClassPerFile: 1)
*UseClassPerFile: 0             && Determines how a library (or form) will handle included class (or, for forms, objects)
*                               && 0 One library.tx2 file
*                               && 1 Multiple file.class.tx2 files
*                               && 2 Multiple file.baseclass.class.tx2 files
*RedirectClassPerFileToMain: 0  && When regenerating binary files, determine target file
*                               && 0 Don't redirect to file.tx2
*                               && 1 Redirect to file.tx2 when selecting file[.baseclass].class.tx2
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

*-- DBC options
*- File per DBC options (UseFilesPerDBC: 1)
*OldFilesPerDBC: 0              && 1=Turns the File per DBC options on, 0 uses the old UseClassPerFile etc settings.
*                               &&   Options below will only read if OldFilesPerDBC is set 1 before!
*                               &&   If OldFilesPerDBC is set 0 later, alle setting will be lost
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
*ClearUniqueID: 1               && 0=Keep UniqueID in text files, 1=Clear Unique ID. Useful for Diff and Merge
*OptimizeByFilestamp: 0         && 1=Optimize file regeneration depending on file timestamp. Dangerous while working with branches!
*RemoveNullCharsFromCode: 1     && 1=Drop NULL chars from source code
*RemoveZOrderSetFromProps: 0    && 0=Do not remove ZOrderSet property from object, 1=Remove ZOrderSet property from object
*PRG_Compat_Level: 0            && 0=Legacy, 1=Use HELPSTRING as Class Procedure comment
*----------------------------------------------------------------------------------------------------------------

*-- PJX special
*BodyDevInfo: 0                 && 0=Don't keep DevInfo for body pjx records, 1=Keep DevInfo
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
*Settings changed
*----------------
UseClassPerFile: 2              && 0=One library tx2 file, 1=Multiple file.class.tx2 files, 2=Multiple file.baseclass.class.tx2 files
RedirectClassPerFileToMain: 1   && 0=Don't redirect to file.tx2, 1=Redirect to file.tx2 when selecting file.class.tx2
DBF_Conversion_Support: 0       && 0=No support, 1=Generate Header TXT only (Diff), 2=Generate Header TXT and BIN (Merge/Only Structure!), 4=Generate TXT with DATA (Diff), 8=Export and Import DATA (Merge/Structure & Data)
DBC_Conversion_Support: 0       && 0=No support, 1=Generate TXT only (Diff), 2=Generate TXT and BIN (Merge)
````
All use off this are the last four lines. But I like to keep the template (recent as version 1.19.69).
- Using single classes - because it's much more easy to merge a single class then a whole library.
- A single class selected might be added to the VCX
- Turn off DBC and DBF conversion

----
![VFPX logo](https://vfpx.github.io/images/vfpxbanner_small.gif)   
This project is part of [VFPX](https://vfpx.github.io/).   

----
Last changed: _2022/11/09_ ![Picture](./pictures/vfpxpoweredby_alternative.gif)
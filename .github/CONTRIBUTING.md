# How to contribute to FoxBin2Prg

## Bug report?
- Please check  [issues](https://github.com/fdbozzo/foxbin2prg/issues) if the bug is reported
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.
- Please add your current configuration creating a config file via   
```
CD 'path-to-source'
DO FOXBIN2PRG.PRG WITH '-C','FoxBin.cfg'
```   
**Do not include your normal config**

### Did you write a patch that fixes a bug?
- Open a new GitHub merge request with the patch.
- Ensure the PR description clearly describes the problem and solution.
  - Include the relevant version number if applicable.
- See [New version](#new-version) for additional tasks

## Coding conventions
Start reading our code and you'll get the hang of it. We optimize for readability:

- Beautification is done like:
  - Keywords: Mixed case 
  - Symbols: First occurence
  - Indentation Tabs, 1
  - Indent anything then comments
- Please do not run BeautifyX with mDots insertion against the code. 
- We ALWAYS put spaces after list items and method parameters (`[1, 2, 3]`, not `[1,2,3]`), around operators (`x = 1`, not `x=1`).
- This is open source software. Consider the people who will read your code, and make it look nice for them. It's sort of like driving a car: Perhaps you love doing donuts when you're alone, but with passengers the goal is to make the ride as smooth as possible.
- Please kindly add comments where and what you change

## New version
Please note, there are some tasks to set up a new version.
Stuff is a bit scattered, so this is where to look up.
- New fork
  1. Please create a fork at github
     - See this [guide](https://www.dataschool.io/how-to-contribute-on-github/) for setting up and using a fork
  2. clone your fork to your computer
- Existing fork
  1. If allready forked, gather the recent state of the master to your fork (for example: "Sync fork" in github on top of your repository)
  2. Pull the recent state,
  3. or get most recent version otherwise.
**Note: You must run FoxBin2Prg against itself to create the binaries and exes:**
```
CD "path_to_FoxBin2Prg"
*This uses a special configuration
DO ReCreate_FoxBin2Prg.prg
```   
**Note: Do not run FoxBin2Prg.prg directly.**   
3. Do your changes
4. On top of _FoxBin2Prg.prg_ there are two version numbers:   
```
#DEFINE DN_FB2PRG_VERSION       1.21
#DEFINE DC_FB2PRG_VERSION_REAL '1.21.01'
```   
5. Please set the **minor** part of _DC_FB2PRG_VERSION_REAL_ to a new number.   
   **Do not** alter the **1.21** part. This is written to the text files.
   Alteration might force that the files must be newly commited, what is not everybodies taste.   
   The value might be altered, if the file structure of the text files is changed.
6. Add a meaningfull description of the change in the changes list on top of _FoxBin2Prg.prg_.
   The most recent entries for changes in the middle of this section around _* </HISTORIAL DE CAMBIOS Y NOTAS IMPORTANTES>_,   
   The most recent bugs are listed above _* </TESTEO Y REPORTE DE BUGS (AGRADECIMIENTOS)>_
7. Alter version in _README.md_
8. Add a description to _docs\ChangeLog.md_
9. If a change to the config files is made, please add the description to the various properties (multi lang)
   - _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_cfg:_ for general settings
   - _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_tab_cfg:_ for settings per table
10. If a change to the parameters is made, change _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_ properties.
11. For changed functionality, add descriptive text on the appropriate _.md_ file in _docs_ folder.
13. Please alter the footer of \*.md files touched to recent date.
14. Alter the version number of the EXE to the version used above.
15. Create the text representation of the binary sources running like
```
CD "path_to_FoxBin2Prg"
*This uses a special configuration
DO Create_FoxBin2Prg.prg
```   
**Note: Do not run FoxBin2Prg.prg directly.**   
16. **The following steps are not neccesary, if you use *VPXDeployment* to create a new version that is applicable for Thor use.**   
17. Compile to EXE **in VFP9 SP2**   
18. Change Thor ([see below](#thor-conventions))   
19. commit   
20. push to your fork   
21. Create a pull request

## Thor conventions
This project is part of [VFPX](https://vfpx.github.io/) and published via [Thor](https://github.com/VFPX/Thor).   
Some steps must be done to create the information for Thor
### Using VFPXDeployment
The standard procedure to create the Thor files is runing VFPXDeployment via Thor.   
1. If you add or remove files to FoxBin2Prg, that you need in the release: 
  - alter *BuildProcess/installedfiles.txt*, see [here](https://github.com/VFPX/VFPXDeployment/blob/main/docs/Documentation.md#installedfilestxt)
  - open the *Helper/Clean_ThorFolder.prg* file
  - navigate to *Get_CompareFiles procedure*
  - alter the TEXT .. ENDTEXT section to remove all files deleted and add new files, check the block for examples.
  - There is a programm *Helper/GetRevisions.prg* to create the list, but this need to run VFPXDeployment one time to create the INSTALLEDFILES directory before.
2. Run VFPXDeployment. It will set version number to EXE, compile, set several documentation and create the files for Thor.
3. commit
4. push to your fork
5. create a pull request

### Without VFPXDeployment
If you do not use VFPXDeployment
There are some considerations to make to add a new version to Thor.   
Please check [Supporting Thor Updater](https://vfpx.github.io/thorupdate/)
In special:
- Update _Project.txt_, in special the version number
- update the *Helper/Clean_ThorFolder.prg* file, see above
- add files to _FoxBin2Prg.zip_, namely
  - FoxBin2Prg.prg,
  - FoxBin2Prg.exe,
  - the config files templates
  - Clean_ThorFolder.prg
- Update the version number in _FoxBin2PrgVersion.txt_
- Update the changelog in _FoxBin2PrgVersion.txt_
- The use of CreateThorUpdate.ps1 is not longer recommended.

Thanks

----
Last changed: _2023/11/26_ ![Picture](../docs/pictures/vfpxpoweredby_alternative.gif)

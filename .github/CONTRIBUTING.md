# How to contribute to FoxBin2Prg

## Bug report?
- Please check  [issues](https://github.com/fdbozzo/foxbin2prg/issues) if the bug is reported
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.
- Please add your current configuration creating a config file via

```
DO FOXBIN2PRG.PRG WITH '-C','path-to-source\FoxBin.cfg'
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
  - Indent anything then Comments
- Please do not run BeautifyX with mDots insertion against the code. 
- We ALWAYS put spaces after list items and method parameters (`[1, 2, 3]`, not `[1,2,3]`), around operators (`x = 1`, not `x=1`).
- This is open source software. Consider the people who will read your code, and make it look nice for them. It's sort of like driving a car: Perhaps you love doing donuts when you're alone, but with passengers the goal is to make the ride as smooth as possible.
- Please kindly add comments where and what you change

## New version
Please note, there are some tasks to set up a new version.
Stuff is a bit scattered, so this is where to look up.
1. Please create a fork at github
   - See this [guide](https://www.dataschool.io/how-to-contribute-on-github/) for setting up and using a fork
   - If already forked, pull the recent state, or get most recent version otherwise.
2. On top of _FoxBin2Prg.prg_ there are two version numbers:   
`#DEFINE DN_FB2PRG_VERSION      1.20`    
`#DEFINE DC_FB2PRG_VERSION_REAL '1.20.00'`
3. Please set the **minor** part of _DC_FB2PRG_VERSION_REAL_ to a new number.   
   **Do not** alter the **1.20** part. This is written to the text files.
   Alteration might force that the files must be newly commited, what is not everybodies taste.
4. Add a meaningful description of the change in the changes list on top of _FoxBin2Prg.prg_.
   The most recent entries for changes in the middle of this section around _* </HISTORIAL DE CAMBIOS Y NOTAS IMPORTANTES>_,   
   The most recent bugs are listed above _* </TESTEO Y REPORTE DE BUGS (AGRADECIMIENTOS)>_
5. Alter version in _README.md_
6. Add a description to _docs\Change_Log.md_
7. Please alter the footer of *.md files touched to recent date.
8. If a change to the config files is made please add the description to the various properties (multi lang)
   - _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_cfg:_ for general settings
   - _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_tab_cfg:_ for settings per table
9. Create a template _foxbin2prg.cfg.txt_ for general settings or _foxbin2prg.dbf.cfg.txt_ for the settings per table.
   - Do this even if no change to the setting to change the version number inside this files.
   - Or change version number in those files manually
   - **Note**. If you are not on an English comp, set the value _Language: EN_ in your local _foxbin2prg.cfg_ to create English files.
   - run like:
   ```
   CD Path_Top_Project
   DO FoxBin2Prg.prg WITH "-c","foxbin2prg.cfg.txt"
   DO FoxBin2Prg.prg WITH "-t","foxbin2prg.dbc.txt"
   ```
10. If a change to the parameters is made, change _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_ properties.
11. For changed functionality, add descriptive text on the appropriate _.md_ file in _docs_ folder.
12. Alter the version number for the EXE to the version used above.
13. Compile to EXE **in VFP9 SP2**
14. Change Thor ([see below](#thor-conventions))
15. Commit
16. Push to your fork
17. Create a pull request

## Thor conventions
This project is part of [VFPX](https://vfpx.github.io/) and published via [Thor](https://github.com/VFPX/Thor).   
There are some considerations to make to add a new version to Thor.   
Please check [Supporting Thor Updater](https://vfpx.github.io/thorupdate/)
In special:
- Update _Project.txt_, in special the version number
- and run the script included, or 
   - add files to _FoxBin2Prg.zip_, namely
     - FoxBin2Prg.prg,
     - FoxBin2Prg.exe,
     - the config files templates
   - Update the version number in _FoxBin2PrgVersion.txt_

- Right-click CreateThorUpdate.ps1 in the ThorUpdater folder and choose Run with PowerShell

## Updating from @lshceffler's fork

- Quit any code / IDE working on your FoxBin2Prg directory
- Create a file in the FoxBin2Prg folder named get_fork.sh with the following content:

```
#!/bin/sh
############################################################
#
#get_fork.sh
#
#get a second branch to work in parallel
#because we can not simple merge
#
#Lutz Scheffler 2023-09-03
#
############################################################

#create a new remote to fork lscheffler
git remote add sf git@github.com:lscheffler/foxbin2prg.git
#read lscheffler
git fetch sf

#create a new branch "lutz" and switch into it
git switch -c lutz
#reset this branch to the last common anchestor between lscheffler/fork_mod and fdbozzo/master
git reset --hard c31b8106652

#connect the new branch with lscheffler/fork_mod
git branch --set-upstream-to=sf/fork_mod lutz
#set branch to top of his remote branch
git pull

#switch back to master
git switch master
#create a new folder on drive, that shows the lscheffler data
git worktree add ../FoxBin2Prg_Lutz lutz

#you can now work in the one and in the other directory
#that means you can copy files from the one to the other via normal function
#or you can pick data from the one to the other like

#for example FoxBin2Prg.prg
#git checkout lutz FoxBin2Prg.prg

#the file is not in the index, you can alter and then add and commit
```

- Right-click the FoxBin2Prg directory, and choose Git Bash Here
- Run "./get_fork.sh"

This will create a new directory "FoxBin2Prg_Lutz" in the parent of "FoxBin2Prg", with the recent state of my fork. You can work in this folder exactly the same way as in "FoxBin2Prg" (if you need the exe files, notice the README.md), only the branch is different. Those are two branches of the same repo, so one can work with git commands.

Now you can work / copy the files via explorer, or, as suggested in the file attached, you can tell git to do the work.

Open the bash in "FoxBin2Prg" directory, and run:

```
git checkout lutz <file_to_get_from_lutz_branch>
```

Then follow the earlier instructions for committing.

----
Last changed: _2023/09/04_ ![Picture](../docs/pictures/vfpxpoweredby_alternative.gif)

# How to contribute to FoxBin2Prg

## Bug report?
- Please check  [issues](https://github.com/lscheffler/foxbin2prg/issues) if the bug is reported
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
  - Keywords: UPPER case 
  - Symbols: First occurence
  - Indentation Space, 1
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
   - If allready forked, pull the recent state, or get most recent version otherwise.
2. clonr from https://github.com/lscheffler/foxbin2prg.   
**Note: If you have cloned the project, you must run it against itself to create the binaries and exes.**
```
CD "path_to_FoxBin2Prg"
*This uses a special configuration
DO ReCreate_FoxBin2Prg.prg
```   
**Note: Do not run FoxBin2Prg.prg directly.**
3. On top of _FoxBin2Prg.prg_ there are two version numbers:   
`#DEFINE DN_FB2PRG_VERSION      1.20`    
`#DEFINE DC_FB2PRG_VERSION_REAL '1.20.00'`
4. Please set the **minor** part of _DC_FB2PRG_VERSION_REAL_ to a new number.   
   **Do not** alter the **1.20** part. This is written to the text files.
   Alteration might force that the files must be newly commited, what is not everybodies taste.
5. Add a meaningfull description of the change in the changes list on top of _FoxBin2Prg.prg_.
   The most recent entries for changes in the middle of this section around _* </HISTORIAL DE CAMBIOS Y NOTAS IMPORTANTES>_,   
   The most recent bugs are listed above _* </TESTEO Y REPORTE DE BUGS (AGRADECIMIENTOS)>_
6. Alter version in _README.md_
7. Add a description to _docs\ChangeLog.md_
8. If a change to the config files is made please add the description to the various properties (multi lang)
   - _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_cfg:_ for general settings
   - _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_tab_cfg:_ for settings per table
9. If a change to the parameters is made, change _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_ properties.
1. For changed functionality, add descriptive text on the appropriate _.md_ file in _docs_ folder.
11. Please alter the footer of \*.md files touched to recent date.
12. Alter the version number for the EXE to the version used above.
13. Create the text representation of the binary sources running like
```
CD "path_to_FoxBin2Prg"
*This uses a special configuration
DO Create_FoxBin2Prg.prg
```   
**Note: Do not run FoxBin2Prg.prg directly.**
14. commit
15. push to your fork
16. create a pull request

Thanks

----
Last changed: _2023/08/30_

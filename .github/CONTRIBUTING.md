# How to contribute to FoxBin2Prg
## Bug report?
- Please check  [issues](https://github.com/fdbozzo/foxbin2prg/issues) if the bug is reported
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.
### Did you write a patch that fixes a bug?
- Open a new GitHub merge request with the patch.
- Ensure the PR description clearly describes the problem and solution.
  - Include the relevant version number if applicable.

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
0. In _FoxBin2prg.prg_ there are two version numbers in properties:   
`n_FB2PRG_Version      = 1.19`    
`c_FB2PRG_Version_Real = '1.19.60'`
1. Please set the **minor** part of _c_FB2PRG_Version_Real_ to a new number.   
   **Do not** alter the **1.19** part. This is written to the text files.
   Alteration might force that the files must be newly commited, what is not everybodies taste.
3. Add a meaningfull description of the change in the changes list on top of _FoxBin2prg.prg_.
4. Add a description to _FoxBin2Prg_Changes.md_
4. If a change to the config files is made please add the description to the various properties (multi lang)
   - _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_cfg:_ for general settings
   - _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_tab_cfg:_ for settings per table
   - Create a template _foxbin2prg.cfg.txt_ for general settings or _foxbin2prg.dbf.cfg.txt_ for the settings per table.
5. If a change to the parameters is made, change _C_FOXBIN2PRG_SYNTAX_INFO_EXAMPLE_LOC_ properties.
4. For changed functionality, add descriptive text on the appropriate _.md_ file.
4. Highlight the change on _README.md_ in projects root
2. Alter the version number for the EXE to the version used above.
0. Compile to EXE
1. Change Thor (see below)

## Thor conventions
This project is part of [VFPX](https://vfpx.github.io/) and published via [Thor](https://github.com/VFPX/Thor).   
There are some considerations to make to add a new version to Thor.   
Please check [Supporting Thor Updater](https://vfpx.github.io/thorupdate/)
In special:
- Update _Project.txt_, in special the version number
- Run the script included, or 
   - add files to _FoxBin2Prg.zip_, namly FoxBin2Prg.prg, FoxBin2Prg.exe and the config files templates
   - Update the version number in _FoxBin2PrgVersion.txt_

Thanks
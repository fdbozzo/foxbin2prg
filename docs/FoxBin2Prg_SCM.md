# Use with SCM
Documentation of FoxBin2Prg - A Binary to Text converter for MS Visual Foxpro 9

## Purpose of this document
Using FoxPin2Prg with SCM.   
See [use with git](./FoxBin2Prg_git.md)

The original document was created by [Fernando D. Bozzo](https://github.com/fdbozzo) whom I like to thank for the great project.   
Pictures are taken from the original project.  
As far as possible these are the original documents. Changes are added where functionality is changed.

----
## Table of contents
- [Remark](#remark)
- [A short mention on SourceSafe](#a-short-mention-on-sourcesafe)

## Remark
**This is article is a stub.**   

If you like to use this tool with non SCM tools like [_git_](git-scm.com/),
have a look on [VFPX](https://vfpx.github.io/projects/), there are some that integrate _git_ and _FoxBin2Prg_ into VFP IDE.

## A short mention on SourceSafe
For those who keep using it, I recommend running away from it to any other modern SCM out there.
Main reason is that Microsoft doesn't support it anymore,
which last version was released in 2005 (Visual SourceSafe 2005, that many people didn't know of) and a lot of people keep using the version that came with Visual Studio 6, released in 1998! (more or less).   
(It was nice in the time there was nothing different on Win, in special not this tool.)

It have a big scalability problem, doesn't guarantee the history integrity and it is not client-server,
which is crucial on any modern SCM.
It's simply too easy to mess with the history and delete files from it manually,
or have a corrupted database because a number of reasons, as virus on some client PC,
hardware problems or network problems, and in many cases this errors are irrecoverable.   
Try to run it on a cheap NAS, it's nothing then a pain.

If, despite the warning, you have no other choice that keep using it,
then you must know that FoxBin2Prg have integration with it,
thanks to the configuration file foxbin2prg.cfg and the capability to change default extensions from tx2 to txa (sc2>sca, and so on).
In fact you can merge binaries as you probably have never seen :-)

----
People that came from SourceSafe, often tends to think of SCM tools as repositories of code,
because of the limitations everybody that used SourceSafe knows,
but the reality is that a SCM tool is much more than a repository of code,
using a SCM tool with FoxBin2Prg you:

* Can Manage the life cycle of an application
* Can compare the binaries, using prg-style representations, to know what have changed at any time in the history of the application
* Can know who have changed what at a code line level
* Can have various stats, as how many changes have been done between past release and this release, even by component
* Can have a team of developers that can work on the same components (forms, classlibs, menus, etc) and can concurrently merge there code and get a functional binary of this merge without blocking each other
* Can work on parallel versions (this release, next release, many releases, patches) using branches
* I reapeat: You can use branches as other languages can do from many years, but FoxPro couldn't, up until now
* Can have the option to develop in geographically distributed projects. This allows that you can work on your house and I in mine and we can share the repository, ie, using GitHub or BitBucket as intermediary
* Can have the option to synchronize the source code repository with other repositories, for backup purposes or other reasons
* Can have the option to "undo" a merge using a substractive-merge that affects various components, with safety
* Can be free of privative formats and use something else that can be used with more than one SCM tool. SourceSafe is the only that understand SourceSafe, so you are a prisoner
* In summary, you are in control of all aspects of a VFP system and there releases and changes

This documentation is to help configure FoxBin2Prg with some modern SCM tools,
beginning with the SCM tool I'm using (PlasticSCM) from middle 2013
and that I personally think is the most advanced SCM tool y know until now.

In this first quick-guide I will explain what is PlasticSCM,
how to configure and how to begin working with Visual FoxPro 9 projects using branch-per-task.

**Part of this guide can be used with any modern SCM tool, and over time I can add documentation or links for using FoxBin2Prg with other SCM tools.**

If you already are using FoxBin2Prg with another SCM tool,
feel free to share how you are using it so others can benefit.

- [Using FoxBin2Prg with PlasticSCM](Using-FoxBin2Prg-with-PlasticSCM)

----
![VFPX logo](https://vfpx.github.io/images/vfpxbanner_small.gif)   
This project is part of [VFPX](https://vfpx.github.io/).   

----
Last changed: _2021/03/03_ ![Picture](./pictures/vfpxpoweredby_alternative.gif)
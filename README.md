## FoxBin2Prg v1.19.xx - Binary/Text Conversor for Microsoft Visual FoxPro 9

### Fernando D. Bozzo

![](https://vfpx.github.io/images/vfpxbanner_small.gif)

Blog: http://fdbozzo.blogspot.com.es/

[![DONATE!](http://www.pngall.com/wp-content/uploads/2016/05/PayPal-Donate-Button-PNG-File-180x100.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&amp;business=fdbozzo%40gmail%2ecom&amp;lc=ES&amp;item_name=FoxBin2Prg&amp;item_number=FoxBin2Prg&amp;currency_code=USD&amp;bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)  

Thank you for your support!


## ENGLISH/ESPAÑOL 

### ENGLISH

### What is FOXBIN2PRG?
It is a program intended to be used with **SCM tools** (Source Code Managers, like VSS, CVS, SVN) and *DVCS tools* (Version Control Systems such as Git, Mercurial, Plastic, and others), or as **standalone** program for **Diff** (viewing differences) and **Merge** operations. Foxbin2prg can substitute for **SccText/X**, **TwoFox** and others, and enhance their functionality, generating bidirectional PRG-Style versions of Foxpro binary files that allow recreating the original binary file.

**Advantages:**

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

__Here is an example of a FOXBIN2PRG.CFG configuration file if you need to change extensions for using it with a specific VSS (SourceSafe)__
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

### USE:
```dbase
DO FOXBIN2PRG.PRG WITH "<path>\archivo.scx"		==> Generates the TEXT version sc2 extension
DO FOXBIN2PRG.PRG WITH "<path>\archivo.sc2"		==> Regenerates the binary version with scx extension
```

### USEFUL SETUP:
You can create up to three different shortcuts pointing to FoxBin2Prg.exe and in your "SendTo" folder in your Windows profile. This allows you to "send" a selected file (pjx,pj2,etc) to the selected option, and make on-the-fly conversions. (Make sure you have the option for seeing known file extensions turned on!):

Shortcut Name                | Right-click/Properties/destination          | What you can do with this option
---------------------------- | ------------------------------------------- | --------------------------------
FoxBin2Prg - Binary2Text.lnk | <path>\foxbin2prg.exe "BIN2PRG-SHOWMSG"     | Process directories or individual files
FoxBin2Prg - Text2Binary.lnk | <path>\foxbin2prg.exe "PRG2BIN-SHOWMSG"     | Process directories or individual files
FoxBin2Prg.lnk               | <path>\foxbin2prg.exe "INTERACTIVE-SHOWMSG" | Process individual files or directories asking what to convert

*How to use them*: Select a file, right-click, SendTo -> FoxBin2Prg

### LOCALIZATION:
Is automatic starting at v1.19.38 (Languages: EN,ES,FR,DE)


### FINAL NOTE:
This program is Open Source and "libre", and I don't make any guaranties that it fulfills your expectations or that it will be free of bugs. I will try to fix bugs if my obligations let me do it.

### Project info and updates: 

Fernando D. Bozzo's repository at Github: https://github.com/fdbozzo/foxbin2prg

### Update History

#### 2021-03-02

* Added support for writing to a different folder than the source code
* Added a new HomeDir configuration setting: 0 = don't save HomeDir in PJ2, 1 (the default) = save HomeDir in PJ2
* Changed version to 1.20.00

### LICENCE:
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.

## ESPAÑOL
---

### ¿Que es FOXBIN2PRG?
Es un programa pensado para ser utilizado con herramientas SCM (Administradores de Control de Código Fuente, como VSS, CVS, SVN) y herramientas DVCS (como Git, Mercurial, Plastic, and others), o como programa independiente, para hacer operaciones de Diff (ver diferencias) y Merge (mezclar cambios), que pretende sustituir a SccText/X y TwoFox y mejorar sus funcionalidades, generando versiones de texto estilo-PRG que permiten recrear el binario original.

**Ventajas:**

* Genera archivos estilo "PRG" (no compilables), para comparación visual
* Permite hacer cambios en la versión Texto tan fácil como modificar PRG
* Todo el código de programa está en un solo PRG, para simplificar su mantenimiento
* Con las versiones Texto puedes regenerar los binarios originales, así que es útil como backup
* Las extensiones usadas son configurables si se crea el archivo FOXBIN2PRG.CFG
* Los métodos y propiedades de la versión Texto son ordenados alfabéticamente para acilitar su comparación
* Puede usar el seteo "UseClassPerFile" para crear archivos individuales por clase o miembro de DBC
* Aproveche la API usando foxbin2prg como un objeto
* Tiene compatibilidad con el SccText/X a nivel de parámetros, así puede ser usado como sustituto con SourceSafe
* Productividad: Puedes crear un acceso directo en la carpeta "SendTo" de tu Perfil de Windows, así puedes "enviar" el archivo seleccionado (pjx,pj2,etc) a Foxbin2prg.exe y a los scripts vbs incluidos, y hacer conversiones al vuelo
* Modifique los archivos TX2 estilo-prg con MODIFY COMMAND (sin compilar) para ver la sintaxis coloreada, o incluso usar el Document View para navegar los procedimientos
* Recupere sus proyectos SourceSafe (.pjx) desde sus archivos .pjm 

Actualmente soporta las conversiones de archivos PJX,SCX,VCX,FRX,LBX,DBC,DBF y MNX para los que genera las versiones TEXTO con extensión PJ2,SC2,VC2,FR2,LB2,DC2,DB2 y MN2, que pueden reconfigurarse para compatibilizar con SourceSafe. 

__Ejemplo del archivo de configuración FOXBIN2PRG.CFG si se necesitan cambiar las extensiones para VSS (SourceSafe)__
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

### USO:
```
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.scx" ==> Genera la versión TEXTO con extensión sc2 
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.sc2" ==> Regenera la versión binaria con extensión scx 
```

### CONFIGURACIÓN UTIL:
Se puede crear 3 accesos directos de FoxBin2Prg.exe y moverlos a la carpeta "SendTo" de su perfil de usuario Windows, para poder "enviar" el archivo elegido (pjx,pj2,etc) a la opción seleccionada, y así hacer conversiones al vuelo, luego puede renombrar y modificar esos accesos directos como sigue (asegúrese de que puede ver las extensiones del sistema): 


Nombre                       | Click-Derecho/Propiedades/destino           | Qué puede hacer con esta opción
---------------------------- | ------------------------------------------- | -------------------------------
FoxBin2Prg - Binary2Text.lnk | <ruta>\foxbin2prg.exe "BIN2PRG-SHOWMSG"     | Procesar directorios o archivos individuales
FoxBin2Prg - Text2Binary.lnk | <ruta>\foxbin2prg.exe "PRG2BIN-SHOWMSG"     | Procesar directorios o archivos individuales
FoxBin2Prg.lnk               | <ruta>\foxbin2prg.exe "INTERACTIVE-SHOWMSG" | Procesar archivos individuales o directorios preguntando qué convertir


Por ejemplo: Seleccionar un archivo, click-derecho, Enviar A -> FoxBin2Prg 


### LOCALIZACIÓN:
Es automática desde la v1.19.38 (Lenguajes: EN,ES,FR,DE) 


### NOTA FINAL:
Este programa es Open Source y "libre", y como tal no ofrezco garantías de que cumpla con sus espectativas o de que está libre de fallos, que intentaré solucionar si me reporta y mis obligaciones me lo permiten. 

<p>Información del proyecto y actualizaciones: <a href="https://vfpx.codeplex.com/wikipage?title=FoxBin2Prg">https://vfpx.codeplex.com/wikipage?title=FoxBin2Prg</a></p>


### LICENCIA:
Esta obra está sujeta a la licencia Reconocimiento-CompartirIgual 4.0 Internacional de Creative Commons. Para ver una copia de esta licencia, visite http://creativecommons.org/licenses/by-sa/4.0/deed.es_ES.


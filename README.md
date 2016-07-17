## FoxBin2Prg v1.19 - Binary/Text Conversor for Microsoft Visual FoxPro 9

### Fernando D. Bozzo

Blog: http://fdbozzo.blogspot.com.es/  -  Project info: https://vfpx.codeplex.com/wikipage?title=FoxBin2Prg

<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&amp;business=fdbozzo%40gmail%2ecom&amp;lc=ES&amp;item_name=FoxBin2Prg&amp;item_number=FoxBin2Prg&amp;currency_code=USD&amp;bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"> <img src="http://download-codeplex.sec.s-msft.com/Download?ProjectName=vfpx&amp;DownloadId=1591726" alt="Donate!" /> </a>

Thank you for your support!
<br/>
### ENGLISH/ESPAÑOL
<br/>
<br/>
### ENGLISH
<hr/>

### What is FOXBIN2PRG?
It is a program intended to be used with **SCM tools** (Source Code Managers, like VSS, CVS, SVN) and *DVCS tools* (like Git, Mercurial, Plastic, and others), or as **standalone** program for **Diff** (viewing differences) and **Merge** operations, that pretends to substitute **SccText/X**, **TwoFox** and others, and enhance their functionality, generating bidirectional PRG-Style versions that allow recreating the original binary file

**Advantages:**

* It generates "PRG" style programs (not compilable), for visual comparison
* It enables the change of the Text version as easy as modifying a PRG
* All the program code is in just one PRG, to simplify its maintainability
* With Text versions you can regenerate the original binaries, so it is useful as backup
* The extensions are configurable if you create the FOXBIN2PRG.CFG file
* Inheritance of CFG configuration files between directories
* Methods and properties of Text version are alphabetically sorted for easy comparison
* Can set "UseClassPerFile" setting to create individual files by class or DBC member
* Takes advantage of the API using foxbin2prg as an object
* It has compatibility with SccText/X at parameter level so can be used as substitute with SourceSafe
* Productivity: You can create a shortcut in the "SendTo" folder on your user Windows Profile, so you can "send" the selected file (pjx,pj2,etc) to Foxbin2prg.exe and make on-the-fly conversions
* Modify TX2 Prg-Style versions with MODIFY COMMAND (without compile) to see colored syntax, or even use the Document View to navigate the procedures
* Get back your SourceSafe projects (.pjx) from their .pjm file


Actually supports conversions between PJX,SCX,VCX,FRX,LBX,DBC,DBF and MNX files, for which it generates TEXT versions with extension PJ2,SC2,VC2,FR2,LB2,DC2,DB2 and MN2 that can be reconfigured to compatibilize with SourceSafe.

__Example of FOXBIN2PRG.CFG configuration file if need to change extensions for using with VSS (SourceSafe)__
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
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.scx"		==> Generates the TEXT version sc2 extension
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.sc2"		==> Regenerates the binary version with scx extension
```

### USEFUL SETUP:
You can create 3 shortcuts of FoxBin2Prg.exe and move them to "SendTo" folder on your Windows profile, so you can "send" the selected file (pjx,pj2,etc) to the selected option, and make on-the-fly conversions, then rename them as this (make sure you can see system file extensions):


Name                         | Right-click/Properties/destination          | What you can do with this option
---------------------------- | ------------------------------------------- | --------------------------------
FoxBin2Prg - Binary2Text.lnk | <path>\foxbin2prg.exe "BIN2PRG-SHOWMSG"     | Process directories or individual files
FoxBin2Prg - Text2Binary.lnk | <path>\foxbin2prg.exe "PRG2BIN-SHOWMSG"     | Process directories or individual files
FoxBin2Prg.lnk               | <path>\foxbin2prg.exe "INTERACTIVE-SHOWMSG" | Process individual files or directories asking what to convert

In example: Select a file, right-click, SendTo -> FoxBin2Prg


### LOCALIZATION:
Is automatic starting at v1.19.38 (Languages: EN,ES,FR,DE)


### FINAL NOTE:
This program is Open Source and "libre", and I don't make any garanties that it fulfills your espectations or that it will be free of bugs, that I will try to fix if my obligations let me do it.

<p>Project info and updates: <a href="https://vfpx.codeplex.com/wikipage?title=FoxBin2Prg">https://vfpx.codeplex.com/wikipage?title=FoxBin2Prg</a></p>


### LICENCE:
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.

<br/>
<br/>
### ESPAÑOL
<hr/>

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


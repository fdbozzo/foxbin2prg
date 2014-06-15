26/01/2014		FOXBIN2PRG v1.19 FOR VISUAL FOXPRO 9 BINARIES		Fernando D. Bozzo (fdbozzo@gmail.com)
Blog: http://fdbozzo.blogspot.com.es/
Project info: https://vfpx.codeplex.com/wikipage?title=FoxBin2Prg

ENGLISH/ESPAÑOL


ENGLISH --------------------------------------------------------------------------------------------

What is FOXBIN2PRG?
It is a program intended to be used with SCM tools (Source Code Managers), that pretends to sustitute
SCCTEXT and enhance it, generating bidirectional TEXT versions that permits to recreate the original
binary file.

Advantages:
- It generates "PRG" style programas (no compilables), for visual comparison
- It enables the the change of the TEXT version as easy as modifying a PRG
- All the program code is in just one PRG, to simplify its copy and maintainability
- With TEXT versions you can regenerate the original binaries, so it is useful as backup
- The extensions are configurable if you create the FOXBIN2PRG.CFG file
- Methods and properties of TEXT version are alphabetically sorted for easy comparison
- It has compatibility with SCCTEXT at parameter level so can be used as sustitute with SourceSafe

Actually supports conversions between PJX,SCX,VCX,FRX,LBX,DBC,DBF and MNX files, for which it generates
TEXT versions with extension PJ2,SC2,VC2,FR2,LB2,DC2,DB2 and MN2 that can be reconfigured to compatibilize
with SourceSafe.

Structure of configuration file FOXBIN2PRG.CFG
extension: SC2=SCA
extension: VC2=VCA
extension: PJ2=PJA

USE:
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.scx"		==> Generates the TEXT version sc2 extension
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.sc2"		==> Regenerates the binary version with scx extension

USEFUL TRICK:
You can create a shortcut in the "SendTo" folder on your user Windows Profile, so you can "send"
the selected file (pjx,pj2,etc) to Foxbin2prg.exe, and make on-the-fly conversions.

LOCALIZATION:
If file [foxbin2prg.h] is created, texts to other languages can be translated. En example
file [foxbin2prg_en.h] is attached with english translation.
Recompiling is necesary to update the strings from the include file.


FINAL NOTE:
This program is Open Source and "libre", and I don't make any garanties that it fulfills your espectations
or that it will be free of bugs, that I will try to fix if my obligations let me do it.
Project info and updated: https://vfpx.codeplex.com/wikipage?title=FoxBin2Prg


LICENCE:
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.




ESPAÑOL --------------------------------------------------------------------------------------------

¿Que es FOXBIN2PRG?
Es un programa pensado para ser usado con herramientas SCM (Source Code Managers) que pretende
sustituir a SCCTEXT y mejorarlo, generando versiones TEXTO bidireccionales que permiten volver
a generar el archivo binario original.

Ventajas:
- Genera versiones tipo "PRG" (no compilables), para comparación visual
- Permite modificar la versión TEXTO tan fácilmente como si se modificara un PRG
- Todo el código del programa está en un solo PRG, para simplificar su copia y mantenimiento
- Con las versiones TEXTO se pueden volver a generar los binarios, lo que sirve como backup
- Las extensiones son configurables si se crea un archivo FOXBIN2PRG.CFG
- Los métodos y propiedades de la versión TEXTO se ordenan alfabéticamente para facilitar su comparación
- Tiene compatibilidad con SCCTEXT a nivel de parámetros para usarlo como sustituto en SourceSafe

Actualmente soporta las conversiones de archivos PJX,SCX,VCX,FRX,LBX,DBC,DBF y MNX para los que genera las
versiones TEXTO con extensión PJ2,SC2,VC2,FR2,LB2,DC2,DB2 y MN2, que pueden reconfigurarse para compatibilizar
con SourceSafe.

Estructura del archivo de configuración FOXBIN2PRG.CFG
extension: SC2=SCA
extension: VC2=VCA
extension: PJ2=PJA

USO:
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.scx"		==> Genera la versión TEXTO con extensión sc2
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.sc2"		==> Regenera la versión binaria con extensión scx

TRUCO UTIL:
Se puede crear un acceso directo en la carpeta "SendTo" del perfil del usuario, para poder "enviar"
el archivo elegido (pjx,pj2,etc) a Foxbin2prg.exe, y así se hacen conversiones al vuelo.

LOCALIZACIÓN:
Si se crea un archivo [foxbin2prg.h], se pueden trasladar los textos a otros idiomas. Se adjunta
un archivo de ejemplo [foxbin2prg_en.h] con la traslación al inglés.
Es necesario recompilar el programa para que se actualicen los textos con el archivo include.


NOTA FINAL:
Este programa es Open Source y "libre", y como tal no ofrezco garantías de que cumpla con sus espectativas
o de que está libre de fallos, que intentaré solucionar si me reporta y mis obligaciones me lo permiten.
Información del proyecto y actualizaciones: https://vfpx.codeplex.com/wikipage?title=FoxBin2Prg_es


LICENCIA:
Esta obra está sujeta a la licencia Reconocimiento-CompartirIgual 4.0 Internacional de Creative Commons.
Para ver una copia de esta licencia, visite http://creativecommons.org/licenses/by-sa/4.0/deed.es_ES.




02/12/2013		FOXBIN2PRG VER.1.7 FOR VISUAL FOXPRO 9		Fernando D. Bozzo (fdbozzo@gmail.com)

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

Actualmente soporta las conversiones de archivos SCX, VCX y PJX, para los que genera las versiones TEXTO
con extensión SC2,VC2 y PJ2, que pueden reconfigurarse para compatibilizar con SourceSafe.

Estructura del archivo de configuración FOXBIN2PRG.CFG
extension: SC2=SCA
extension: VC2=VCA
extension: PJ2=PJA

USO:
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.scx"		==> Genera la versión TEXTO con extensión sc2
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.sc2"		==> Regenera la versión binaria con extensión scx


NOTA FINAL:
Este programa es Open Source y "libre", y como tal no ofrezco garantías de que cumpla con sus espectativas
o de que esté libre de fallos, que intentaré solucionar si me reporta y mis obligaciones me lo permiten.


LICENCIA:
Esta obra está sujeta a la licencia Reconocimiento-CompartirIgual 4.0 Internacional de Creative Commons.
Para ver una copia de esta licencia, visite http://creativecommons.org/licenses/by-sa/4.0/deed.es_ES.



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

Actually supports conversions between SCX, VCX and PJX files, for which it generates TEXT versions
with extension SC2,VC2 and PJ2, that can be reconfigured to compatibilize with SourceSafe.

Structure of configuration file FOXBIN2PRG.CFG
extension: SC2=SCA
extension: VC2=VCA
extension: PJ2=PJA

USE:
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.scx"		==> Generates the TEXT version sc2 extension
DO FOXBIN2PRG.PRG WITH "<ruta>\archivo.sc2"		==> Regenerates the binary version with scx extension


FINAL NOTE:
This program is Open Source and "libre", and I don't make any garanties that it fulfills your espectations
or that it will be free of bugs, that I will try to fix if my obligations let me do it.


LICENCE:
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.

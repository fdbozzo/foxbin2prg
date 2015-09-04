*---------------------------------------------------------------------------------------------------
* Módulo.........: main_fb2p_diff.prg - PARA VISUAL FOXPRO 9.0
* Autor..........: Fernando D. Bozzo (mailto:fdbozzo@gmail.com) - http://fdbozzo.blogspot.com
* Project info...: https://vfpx.codeplex.com/wikipage?title=FoxBin2Prg
* Fecha creación.: 27/07/2015
*
* LICENCE:
* This work is licensed under the Creative Commons Attribution 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.
*
* LICENCIA:
* Esta obra está sujeta a la licencia Reconocimiento-CompartirIgual 4.0 Internacional de Creative Commons.
* Para ver una copia de esta licencia, visite http://creativecommons.org/licenses/by-sa/4.0/deed.es_ES.
*
*---------------------------------------------------------------------------------------------------
* DESCRIPCIÓN....: PERMITE COMPARAR 2 ARCHIVOS BINARIOS DE VISUAL FOXPRO 9 (SCX,VCX,MNX,FRX,LBX,DBF,DBC).
*
*	USO/USE:
*		DO MAIN_FB2P_DIFF.PRG WITH "<path>\File1.vcx" "<path>\File.vcx"
*---------------------------------------------------------------------------------------------------
* <TESTEO, REPORTE DE BUGS Y MEJORAS (AGRADECIMIENTOS)>
* 04/09/2015	Mike Potjer		Reporte de Bug: Cuando se llama al programa fb2p_diff.exe desde un directorio distinto al de FoxBin2Prg, da un error por no encontrar al conversor (Arreglado en v1.1)
* </TESTEO Y REPORTE DE BUGS (AGRADECIMIENTOS)>
*---------------------------------------------------------------------------------------------------
LPARAMETERS tcFilename1, tcFilename2

LOCAL lnResp, lcSys16, lcOldPath
PRIVATE poFrm as Form
lnResp		= 0
lcSys16		= SYS(16)
lcOldPath	= SET("Path")
SET PATH TO (JUSTPATH(lcSys16)) ADDITIVE

DO FORM FB2P_DIFF.SCX NAME poFrm LINKED NOSHOW
poFrm.filename1 = EVL(tcFilename1, '')
poFrm.filename2 = EVL(tcFilename2, '')
poFrm.initialize()
poFrm.show()
READ EVENTS

STORE NULL TO poFrm
SET PATH TO (lcOldPath)
RELEASE poFrm

IF _VFP.STARTMODE <> 4 OR NOT SYS(16) == SYS(16,0) && 4 = Visual FoxPro was started as a distributable .app or .exe file.
	RETURN lnResp	&& lnResp contiene un código de error, pero invocado desde SourceSafe puede contener el tipo de soporte de archivo (0,1,2).
ENDIF

IF EMPTY(lnResp)
	QUIT
ENDIF

*-- Muy útil para procesos batch que capturan el código de error
DECLARE INTEGER OpenProcess IN Win32API INTEGER dwDesiredAccess, INTEGER bInheritHandle, INTEGER dwProcessID
lnHandle = OpenProcess(1, 1, _VFP.PROCESSID)
DECLARE INTEGER TerminateProcess IN Win32API INTEGER hProcess, INTEGER uExitCode
=TerminateProcess(lnHandle,1)

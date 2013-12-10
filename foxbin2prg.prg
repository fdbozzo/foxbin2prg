*---------------------------------------------------------------------------------------------------
* Módulo.........: FOXBIN2PRG.PRG - PARA VISUAL FOXPRO 9.0
* Autor..........: Fernando D. Bozzo (mailto:fdbozzo@gmail.com)
* Fecha creación.: 04/11/2013
*
* LICENCIA:
* Esta obra está sujeta a la licencia Reconocimiento-CompartirIgual 4.0 Internacional de Creative Commons.
* Para ver una copia de esta licencia, visite http://creativecommons.org/licenses/by-sa/4.0/deed.es_ES.
*
* LICENCE:
* This work is licensed under the Creative Commons Attribution 4.0 International License.
* To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.
*
*---------------------------------------------------------------------------------------------------
* DESCRIPCIÓN....: CONVIERTE EL ARCHIVO VCX/SCX/PJX INDICADO A UN "PRG HÍBRIDO" PARA POSTERIOR RECONVERSIÓN.
*                  * EL PRG HÍBRIDO ES UN PRG CON ALGUNAS SECCIONES BINARIAS (OLE DATA, ETC)
*                  * EL OBJETIVO ES PODER USARLO COMO REEMPLAZO DEL SCCTEXT.PRG, PODER HACER MERGE
*                  DEL CÓDIGO DIRECTAMENTE SOBRE ESTE NUEVO PRG Y GUARDARLO EN UNA HERRAMIENTA DE SCM
*                  COMO CVS O SIMILAR SIN NECESIDAD DE GUARDAR LOS BINARIOS ORIGINALES.
*                  * EXTENSIONES GENERADAS: VC2, SC2, PJ2   (...o VCA, SCA, PJA con archivo conf.)
*                  * CONFIGURACIÓN: SI SE CREA UN ARCHIVO FOXBIN2PRG.CFG, SE PUEDEN CAMBIAR LAS EXTENSIONES
*                    PARA PODER USARLO CON SOURCESAFE PONIENDO LAS EQUIVALENCIAS ASÍ:
*
*                        extension: VC2=VCA
*                        extension: SC2=SCA
*                        extension: PJ2=PJA
*
*	USO/USE:
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.VCX"	&& Genera "<path>\FILE.VC2" (BIN TO PRG CONVERSION)
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.VC2"	&& Genera "<path>\FILE.VCX" (PRG TO BIN CONVERSION)
*
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.SCX"	&& Genera "<path>\FILE.SC2" (BIN TO PRG CONVERSION)
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.SC2"	&& Genera "<path>\FILE.SCX" (PRG TO BIN CONVERSION)
*
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.PJX"	&& Genera "<path>\FILE.PJ2" (BIN TO PRG CONVERSION)
*		DO FOXBIN2PRG.PRG WITH "<path>\FILE.PJ2"	&& Genera "<path>\FILE.PJX" (PRG TO BIN CONVERSION)
*
*---------------------------------------------------------------------------------------------------
* Historial de cambios y notas importantes
* 04/11/2013	FDBOZZO		v1.0 Creación inicial de las clases y soporte de los archivos VCX/SCX/PJX
* 22/11/2013	FDBOZZO		v1.1 Corrección de bugs
* 23/11/2013	FDBOZZO		v1.2 Corrección de bugs, limpieza de código y refactorización
* 24/11/2013	FDBOZZO		v1.3 Corrección de bugs, limpieza de código y refactorización
* 27/11/2013	FDBOZZO		v1.4 Agregado soporte comodines *.VCX, configuración de extensiones (vca), parámetro p/log
* 27/11/2013	FDBOZZO		v1.5 Arreglo bug que no generaba form completo
* 01/12/2013	FDBOZZO		v1.6 Refactorización completa generación BIN y PRG, cambio de algoritmos, arreglo de bugs, Unit Testing con FoxUnit
* 02/12/2013	FDBOZZO		v1.7 Arreglo bug "Name", barra de progreso, agregado mensaje de ayuda si se llama sin parámetros, verificación y logueo de archivos READONLY con debug activa
* 03/12/2013	FDBOZZO		v1.8 Arreglo bug "Name" (otra vez), sort encapsulado y reutilizado para versiones TEXTO y BIN por seguridad
* 06/12/2013	FDBOZZO		v1.9 Arreglo bug pérdida de propiedades causado por una mejora anterior
* 06/12/2013	FDBOZZO		v1.10 Arreglo del bug de mezcla de métodos de una clase con la siguiente
* 07/12/2013	FDBOZZO		v1.11 Arreglo del bug de _amembers detectado por Edgar K.con la clase BlowFish.vcx (http://www.tortugaproductiva.galeon.com/docs/blowfish/index.html)
* 07/12/2013    FDBOZZO     v1.12 Agregado soporte preliminar de conversión de reportes y etiquetas (FRX/LBX)
* 08/12/2013	FDBOZZO		v1.13 Arreglo bug "Error 1924, TOREG is not an object"
* 08/12/2013	FDBOZZO		v1.14 Agregado soporte preliminar de conversión de tablas, índices y bases de datos (DBF,CDX,DBC)
*
*---------------------------------------------------------------------------------------------------
* TESTEO Y REPORTE DE BUGS (AGRADECIMIENTOS)
* 23/11/2013	Luis Martínez	REPORTE BUG: En algunos forms solo se generaba el dataenvironment (arreglado en v.1.5)
* 27/11/2013	Fidel Charny	REPORTE BUG: Error en el guardado de ciertas propiedades de array (arreglado en v.1.6)
* 02/12/2013	Fidel Charny	REPORTE BUG: Se pierden algunas propiedades y no muestra picture si "Name" no es la última (arreglado en v.1.7)
* 03/12/2013	Fidel Charny	REPORTE BUG: Se siguen perdiendo algunas propiedades por implementación defectuosa del arreglo anterior (arreglado en v.1.8)
* 03/12/2013	Fidel Charny	REPORTE BUG: Se siguen perdiendo algunas propiedades por implementación defectuosa de una mejora anterior (arreglado en v.1.9)
* 06/12/2013	Fidel Charny	REPORTE BUG: Cuando hay métodos que tienen el mismo nombre, aparecen mezclados en objetos a los que no corresponden (arreglado en v.1.10)
* 07/12/2013	Edgar Kummers	REPORTE BUG: Cuando se parsea una clase con un _memberdata largo, se parsea mal y se corrompe el valor (arreglado en v.1.11)
* 08/12/2013	Fidel Charny	REPORTE BUG: Cuando se convierten algunos reportes da "Error 1924, TOREG is not an object" (arreglado en v.1.13)
*
*---------------------------------------------------------------------------------------------------
* TRAMIENTOS ESPECIALES DE ASIGNACIONES DE PROPIEDADES:
*	PROPIEDAD				ARREGLO Y EJEMPLO
*-------------------------	--------------------------------------------------------------------------------------
*	_memberdata				Se separan las definiciones en lineas para evitar una sola muy larga
*
*---------------------------------------------------------------------------------------------------
* PARÁMETROS:				!=Obligatorio, ?=Opcional, @=Pasar por referencia, v=Pasar por valor (IN/OUT)
* tc_InputFile				(v! IN    ) Nombre completo (fullpath) del archivo a convertir
* tcType_na					(         ) Por ahora se mantiene por compatibilidad con SCCTEXT.PRG
* tcTextName_na				(         ) Por ahora se mantiene por compatibilidad con SCCTEXT.PRG
* tlGenText_na				(         ) Por ahora se mantiene por compatibilidad con SCCTEXT.PRG
* tcDontShowErrors			(v? IN    ) '1' para NO mostrar errores con MESSAGEBOX
* tcDebug					(v? IN    ) '1' para depurar en el sitio donde ocurre el error (solo modo desarrollo)
* tcDontShowProgress		(v? IN    ) '1' para NO mostrar la ventana de progreso
*
*							Ej: DO FOXBIN2PRG.PRG WITH "C:\DESA\INTEGRACION\LIBRERIA.VCX"
*---------------------------------------------------------------------------------------------------
LPARAMETERS tc_InputFile, tcType_na, tcTextName_na, tlGenText_na, tcDontShowErrors, tcDebug, tcDontShowProgress

*-- Internacionalización / Internationalization
*-- Fin / End

*-- NO modificar! / Do NOT change!
#DEFINE C_CMT_I				'*--'
#DEFINE C_CMT_F				'--*'
#DEFINE C_METADATA_I		'*< CLASSDATA:'
#DEFINE C_METADATA_F		'/>'
#DEFINE C_LEN_METADATA_I	LEN(C_METADATA_I)
#DEFINE C_OLE_I				'*< OLE:'
#DEFINE C_OLE_F				'/>'
#DEFINE C_LEN_OLE_I			LEN(C_OLE_I)
#DEFINE C_DEFINED_PAM_I		'*<DefinedPropArrayMethod>'
#DEFINE C_DEFINED_PAM_F		'*</DefinedPropArrayMethod>'
#DEFINE C_LEN_DEFINED_PAM_I	LEN(C_DEFINED_PAM_I)
#DEFINE C_LEN_DEFINED_PAM_F	LEN(C_DEFINED_PAM_F)
#DEFINE C_END_OBJECT_I		'*< END OBJECT:'
#DEFINE C_END_OBJECT_F		'/>'
#DEFINE C_LEN_END_OBJECT_I	LEN(C_END_OBJECT_I)
#DEFINE C_FB2PRG_META_I		'*< FOXBIN2PRG:'
#DEFINE C_FB2PRG_META_F		'/>'
#DEFINE C_DEFINE_CLASS		'DEFINE CLASS'
#DEFINE C_ENDDEFINE			'ENDDEFINE'
#DEFINE C_TEXT				'TEXT'
#DEFINE C_ENDTEXT			'ENDTEXT'
#DEFINE C_PROCEDURE			'PROCEDURE'
#DEFINE C_ENDPROC			'ENDPROC'
#DEFINE C_SRV_HEAD_I		'*<ServerHead>'
#DEFINE C_SRV_HEAD_F		'*</ServerHead>'
#DEFINE C_SRV_DATA_I		'*<ServerData>'
#DEFINE C_SRV_DATA_F		'*</ServerData>'
#DEFINE C_DEVINFO_I			'*<DevInfo>'
#DEFINE C_DEVINFO_F			'*</DevInfo>'
#DEFINE C_BUILDPROJ_I		'*<BuildProj>'
#DEFINE C_BUILDPROJ_F		'*</BuildProj>'
#DEFINE C_PROJPROPS_I		'*<ProjectProperties>'
#DEFINE C_PROJPROPS_F		'*</ProjectProperties>'
#DEFINE C_FILE_META_I		'*< FileMetadata:'
#DEFINE C_FILE_META_F		'/>'
#DEFINE C_FILE_CMTS_I		'*<FileComments>'
#DEFINE C_FILE_CMTS_F		'*</FileComments>'
#DEFINE C_FILE_EXCL_I		'*<ExcludedFiles>'
#DEFINE C_FILE_EXCL_F		'*</ExcludedFiles>'
#DEFINE C_FILE_TXT_I		'*<TextFiles>'
#DEFINE C_FILE_TXT_F		'*</TextFiles>'
#DEFINE C_FB2P_VALUE_I		'<fb2p_value>'
#DEFINE C_FB2P_VALUE_F		'</fb2p_value>'
#DEFINE C_LEN_FB2P_VALUE_I	LEN(C_FB2P_VALUE_I)
#DEFINE C_LEN_FB2P_VALUE_F	LEN(C_FB2P_VALUE_F)
#DEFINE C_VFPDATA_I			'<VFPData>'
#DEFINE C_VFPDATA_F			'</VFPData>'
#DEFINE C_MEMBERDATA_I		C_VFPDATA_I
#DEFINE C_MEMBERDATA_F		C_VFPDATA_F
#DEFINE C_LEN_MEMBERDATA_I	LEN(C_MEMBERDATA_I)
#DEFINE C_LEN_MEMBERDATA_F	LEN(C_MEMBERDATA_F)
#DEFINE C_DATA_I			'<![CDATA['
#DEFINE C_DATA_F			']]>'
#DEFINE C_TAG_REPORTE		'Reportes'
#DEFINE C_TAG_REPORTE_I		'<' + C_TAG_REPORTE + '>'
#DEFINE C_TAG_REPORTE_F		'</' + C_TAG_REPORTE + '>'
#DEFINE C_DBF_HEAD_I		'<DBF'
#DEFINE C_DBF_HEAD_F		'/>'
#DEFINE C_LEN_DBF_HEAD_I	LEN(C_DBF_HEAD_I)
#DEFINE C_LEN_DBF_HEAD_F	LEN(C_DBF_HEAD_F)
#DEFINE C_FIELD_I			'<Field'
#DEFINE C_FIELD_F			'/>'
#DEFINE C_LEN_FIELD_I		LEN(C_FIELD_I)
#DEFINE C_LEN_FIELD_F		LEN(C_FIELD_F)
#DEFINE C_INDEX_I			'<Index'
#DEFINE C_INDEX_F			'/>'
#DEFINE C_CDX_I				'<IndexFile>'
#DEFINE C_CDX_F				'</IndexFile>'
#DEFINE C_LEN_CDX_I			LEN(C_CDX_I)
#DEFINE C_LEN_CDX_F			LEN(C_CDX_F)
#DEFINE C_LEN_INDEX_I		LEN(C_INDEX_I)
#DEFINE C_LEN_INDEX_F		LEN(C_INDEX_F)
#DEFINE C_TAB				CHR(9)
#DEFINE C_CR				CHR(13)
#DEFINE C_LF				CHR(10)
#DEFINE CR_LF				C_CR + C_LF
#DEFINE C_MPROPHEADER		REPLICATE( CHR(1), 517 )
*-- Fin / End

*-- From FOXPRO.H
*-- File Object Type Property
#DEFINE FILETYPE_DATABASE          "d"  && Database (.DBC)
#DEFINE FILETYPE_FREETABLE         "D"  && Free table (.DBF)
#DEFINE FILETYPE_QUERY             "Q"  && Query (.QPR)
#DEFINE FILETYPE_FORM              "K"  && Form (.SCX)
#DEFINE FILETYPE_REPORT            "R"  && Report (.FRX)
#DEFINE FILETYPE_LABEL             "B"  && Label (.LBX)
#DEFINE FILETYPE_CLASSLIB          "V"  && Class Library (.VCX)
#DEFINE FILETYPE_PROGRAM           "P"  && Program (.PRG)
#DEFINE FILETYPE_APILIB            "L"  && API Library (.FLL)
#DEFINE FILETYPE_APPLICATION       "Z"  && Application (.APP)
#DEFINE FILETYPE_MENU              "M"  && Menu (.MNX)
#DEFINE FILETYPE_TEXT              "T"  && Text (.TXT, .H., etc.)
#DEFINE FILETYPE_OTHER             "x"  && Other file types not enumerated above

*-- Server Object Instancing Property
#DEFINE SERVERINSTANCE_SINGLEUSE     1  && Single use server
#DEFINE SERVERINSTANCE_NOTCREATABLE  2  && Instances creatable only inside Visual FoxPro
#DEFINE SERVERINSTANCE_MULTIUSE      3  && Multi-use server
*-- Fin / End

TRY
	LOCAL lcSys16, I, lcPath, lnResp, lcFileSpec, lcFile, laFiles(1,5), laConfig(1), lcConfigFile, lcExt ;
		, llExisteConfig, llShowProgress, lcConfData, lnFileCount ;
		, loEx AS EXCEPTION

	PUBLIC goFrm_Avance AS frm_avance OF 'FOXBIN2PRG.PRG' ;
		, goCnv AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
	lnResp	= 0

	SET DELETED ON
	SET DATE YMD
	SET HOURS TO 24
	SET CENTURY ON
	SET SAFETY OFF
	SET TABLEPROMPT OFF

	IF _VFP.STARTMODE > 0
		SET ESCAPE OFF
	ENDIF

	DO CASE
	CASE VERSION(5) < 900
		lnResp	= 1
		MESSAGEBOX( 'FOXBIN2PRG es solo para Visual FoxPro 9.0!', 0+64+4096, 'FOXBIN2PRG: SINTAXIS INFO', 60000 )

	CASE EMPTY(tc_InputFile)
		lnResp	= 1
		MESSAGEBOX( 'FOXBIN2PRG <cFileSpec.Ext>  [cType_NA  cTextName_NA  cGenText_NA  cDontShowErrors  cDebug]' + CR_LF + CR_LF ;
			+ 'Ejemplo para generar los TXT de todos los VCX de c:\desa\clases, sin mostrar ventana de error y generando LOG: ' + CR_LF ;
			+ '   FOXBIN2PRG "c:\desa\clases\*.vcx"  "0"  "0"  "0"  "1"  "1"' + CR_LF + CR_LF ;
			+ 'Ejemplo para generar los VCX de todos los TXT de c:\desa\clases, sin mostrar ventana de error y sin LOG: ' + CR_LF ;
			+ '   FOXBIN2PRG "c:\desa\clases\*.vc2"  "0"  "0"  "0"  "1"  "0"' ;
			, 0+64+4096, 'FOXBIN2PRG: SINTAXIS INFO', 60000 )
	OTHERWISE
		lcSys16	= SYS(16)
		lcPath	= SET("Path")
		*SET PATH TO (JUSTPATH(lcSys16))
		SET PATH TO
		llShowProgress		= NOT (TRANSFORM(tcDontShowProgress)=='1')
		goCnv	= CREATEOBJECT("c_foxbin2prg")
		goCnv.l_Debug		= (TRANSFORM(tcDebug)=='1')
		goCnv.l_ShowErrors	= NOT (TRANSFORM(tcDontShowErrors) == '1')

		IF llShowProgress
			goFrm_Avance	= CREATEOBJECT("frm_avance")
		ENDIF

		*-- Configuración
		lcConfigFile	= FORCEEXT( lcSys16, 'CFG' )
		llExisteConfig	= FILE( lcConfigFile )

		IF llExisteConfig
			FOR I = 1 TO ALINES( laConfig, FILETOSTR( lcConfigFile ), 1+4 )
				IF LOWER( LEFT( laConfig(I), 10 ) ) == 'extension:'
					lcConfData	= ALLTRIM( SUBSTR( laConfig(I), 11 ) )
					lcExt		= 'c_' + ALLTRIM( GETWORDNUM( lcConfData, 1, '=' ) )
					IF PEMSTATUS( goCnv, lcExt, 5 )
						goCnv.ADDPROPERTY( lcExt, UPPER( ALLTRIM( GETWORDNUM( lcConfData, 2, '=' ) ) ) )
					ENDIF
				ENDIF
			ENDFOR
		ENDIF


		*-- Evaluación de FileSpec de entrada
		DO CASE
		CASE '*' $ JUSTEXT( tc_InputFile ) OR '?' $ JUSTEXT( tc_InputFile )
			MESSAGEBOX( 'No se admiten extensiones * o ? porque es peligroso (se pueden pisar binarios con archivo xx2 vacíos).' ;
				, 0+48+4096, 'FOXBIN2PRG: ERROR!!', 10000 )

		CASE '*' $ JUSTSTEM( tc_InputFile )
			*-- Se quieren todos los archivos de una extensión
			lcFileSpec	= FULLPATH( tc_InputFile )
			CD (JUSTPATH(lcFileSpec))
			goCnv.c_LogFile	= ADDBS( JUSTPATH( lcFileSpec ) ) + STRTRAN( JUSTFNAME( lcFileSpec ), '*', '_ALL' ) + '.LOG'

			IF goCnv.l_Debug
				IF FILE( goCnv.c_LogFile )
					ERASE ( goCnv.c_LogFile )
				ENDIF
				goCnv.writeLog( lcSys16 + ' - FileSpec: ' + EVL(tc_InputFile,'') )
				IF llExisteConfig
					goCnv.writeLog( 'ConfigFile: ' + lcConfigFile )
				ENDIF
			ENDIF

			lnFileCount	= ADIR( laFiles, lcFileSpec )

			IF llShowProgress
				goFrm_Avance.nMAX_VALUE	= lnFileCount
			ENDIF

			FOR I = 1 TO lnFileCount
				lcFile	= FORCEPATH( laFiles(I,1), JUSTPATH( lcFileSpec ) )
				goFrm_Avance.lbl_TAREA.CAPTION = 'Procesando archivo ' + lcFile + '...'
				goFrm_Avance.nVALUE = I

				IF llShowProgress
					goFrm_Avance.SHOW()
				ENDIF

				IF FILE( lcFile )
					lnResp = goCnv.Convertir( lcFile )
				ENDIF
			ENDFOR

		OTHERWISE
			*-- Un archivo individual
			IF FILE(tc_InputFile)
				CD (JUSTPATH(tc_InputFile))
				goCnv.c_LogFile	= tc_InputFile + '.LOG'

				IF goCnv.l_Debug
					IF FILE( goCnv.c_LogFile )
						ERASE ( goCnv.c_LogFile )
					ENDIF
					goCnv.writeLog( lcSys16 + ' - FileSpec: ' + EVL(tc_InputFile,'') )
				ENDIF

				lnResp = goCnv.Convertir( tc_InputFile )
			ENDIF
		ENDCASE

	ENDCASE

CATCH TO loEx
	IF llExisteConfig
		goCnv.writeLog( 'ERROR: ' + TRANSFORM(loEx.ERRORNO) + ', ' + loEx.MESSAGE + CR_LF ;
			+ loEx.PROCEDURE + ', line ' + TRANSFORM(loEx.LINENO) + CR_LF ;
			+ loEx.DETAILS )
	ENDIF

FINALLY
	goFrm_Avance.HIDE()
	goFrm_Avance.RELEASE()
	STORE NULL TO goCnv, goFrm_Avance
	RELEASE goCnv, goFrm_Avance
	CD (JUSTPATH(lcSys16))
	SET PATH TO (lcPath)
ENDTRY

IF _VFP.STARTMODE > 0
	QUIT
ENDIF

RETURN lnResp


*******************************************************************************************************************
DEFINE CLASS c_foxbin2prg AS CUSTOM
	#IF .F.
		LOCAL THIS AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
		+ [<memberdata name="exception2str" type="method" display="Exception2Str"/>] ;
		+ [<memberdata name="writelog" type="method" display="writeLog"/>] ;
		+ [<memberdata name="l_debug" type="property" display="l_Debug"/>] ;
		+ [<memberdata name="l_test" type="property" display="l_Test"/>] ;
		+ [<memberdata name="l_showerrors" type="property" display="l_ShowErrors"/>] ;
		+ [<memberdata name="l_methodsort_enabled" type="property" display="l_MethodSort_Enabled"/>] ;
		+ [<memberdata name="l_propsort_enabled" type="property" display="l_PropSort_Enabled"/>] ;
		+ [<memberdata name="l_reportsort_enabled" type="property" display="l_ReportSort_Enabled"/>] ;
		+ [<memberdata name="c_curdir" type="property" display="c_CurDir"/>] ;
		+ [<memberdata name="c_inputfile" type="property" display="c_InputFile"/>] ;
		+ [<memberdata name="c_outputfile" type="property" display="c_OutputFile"/>] ;
		+ [<memberdata name="c_logfile" type="property" display="c_LogFile"/>] ;
		+ [<memberdata name="c_vc2" type="property" display="c_VC2"/>] ;
		+ [<memberdata name="c_sc2" type="property" display="c_SC2"/>] ;
		+ [<memberdata name="c_pj2" type="property" display="c_PJ2"/>] ;
		+ [<memberdata name="c_mn2" type="property" display="c_MN2"/>] ;
		+ [<memberdata name="c_fr2" type="property" display="c_FR2"/>] ;
		+ [<memberdata name="c_lb2" type="property" display="c_LB2"/>] ;
		+ [<memberdata name="c_db2" type="property" display="c_DB2"/>] ;
		+ [<memberdata name="c_cd2" type="property" display="c_CD2"/>] ;
		+ [<memberdata name="c_dc2" type="property" display="c_DC2"/>] ;
		+ [<memberdata name="o_conversor" type="property" display="o_Conversor"/>] ;
		+ [<memberdata name="n_fb2prg_version" type="property" display="n_FB2PRG_Version"/>] ;
		+ [</VFPData>]

	c_CurDir				= ''
	c_InputFile				= ''
	c_LogFile				= ''
	c_OutputFile			= ''
	l_Debug					= .F.
	l_Test					= .F.
	l_ShowErrors			= .F.
	l_MethodSort_Enabled	= .T.	&& Para Unit Testing se puede cambiar a .F. para buscar diferencias
	l_PropSort_Enabled		= .T.	&& Para Unit Testing se puede cambiar a .F. para buscar diferencias
	l_ReportSort_Enabled	= .T.	&& Para Unit Testing se puede cambiar a .F. para buscar diferencias
	lFileMode				= .F.
	nClassTimeStamp			= ''
	n_FB2PRG_Version		= 1.14
	o_Conversor				= NULL
	c_VC2					= 'VC2'
	c_SC2					= 'SC2'
	c_PJ2					= 'PJ2'
	c_MN2					= 'MN2'
	c_FR2					= 'FR2'
	c_LB2					= 'LB2'
	c_DB2					= 'DB2'
	c_CD2					= 'CD2'
	c_DC2					= 'DC2'


	*******************************************************************************************************************
	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF
		SET TABLEPROMPT OFF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		TRY
			LOCAL lcFileCDX
			lcFileCDX	= FORCEPATH( "TABLABIN.CDX", THIS.c_CurDir )
			IF FILE( lcFileCDX )
				ERASE ( lcFileCDX )
			ENDIF
		CATCH
		ENDTRY

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS tc_InputFile, toModulo, toEx AS EXCEPTION, tlRelanzarError

		TRY
			LOCAL lnCodError, lcErrorInfo
			lnCodError			= 0
			THIS.c_InputFile	= FULLPATH( tc_InputFile )
			THIS.c_CurDir		= JUSTPATH( THIS.c_InputFile )
			THIS.o_Conversor	= NULL

			IF NOT FILE(THIS.c_InputFile)
				ERROR 'El archivo [' + THIS.c_InputFile + '] no existe'
			ENDIF

			IF FILE( THIS.c_InputFile + '.ERR' )
				TRY
					ERASE ( THIS.c_InputFile + '.ERR' )
				CATCH
				ENDTRY
			ENDIF

			DO CASE
			CASE JUSTEXT(THIS.c_InputFile) = 'VCX'
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, THIS.c_VC2 )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_vcx_a_prg' )

			CASE JUSTEXT(THIS.c_InputFile) = 'SCX'
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, THIS.c_SC2 )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_scx_a_prg' )

			CASE JUSTEXT(THIS.c_InputFile) = 'PJX'
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, THIS.c_PJ2 )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_pjx_a_prg' )

			CASE JUSTEXT(THIS.c_InputFile) = 'FRX'
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, THIS.c_FR2 )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_frx_a_prg' )

			CASE JUSTEXT(THIS.c_InputFile) = 'LBX'
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, THIS.c_LB2 )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_frx_a_prg' )

			CASE JUSTEXT(THIS.c_InputFile) = 'DBF'
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, THIS.c_DB2 )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_dbf_a_prg' )

			CASE JUSTEXT(THIS.c_InputFile) = 'DBC'
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, THIS.c_DC2 )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_dbc_a_prg' )

			CASE JUSTEXT(THIS.c_InputFile) = THIS.c_VC2
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, 'VCX' )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_prg_a_vcx' )

			CASE JUSTEXT(THIS.c_InputFile) = THIS.c_SC2
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, 'SCX' )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_prg_a_scx' )

			CASE JUSTEXT(THIS.c_InputFile) = THIS.c_PJ2
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, 'PJX' )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_prg_a_pjx' )

			CASE JUSTEXT(THIS.c_InputFile) = THIS.c_FR2
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, 'FRX' )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_prg_a_frx' )

			CASE JUSTEXT(THIS.c_InputFile) = THIS.c_LB2
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, 'LBX' )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_prg_a_frx' )

			CASE JUSTEXT(THIS.c_InputFile) = THIS.c_DB2
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, 'DBF' )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_prg_a_dfb' )

			CASE JUSTEXT(THIS.c_InputFile) = THIS.c_DC2
				THIS.c_OutputFile					= FORCEEXT( THIS.c_InputFile, 'DBC' )
				THIS.o_Conversor					= CREATEOBJECT( 'c_conversor_prg_a_dfc' )

			OTHERWISE
				ERROR 'El archivo [' + THIS.c_InputFile + '] no está soportado'

			ENDCASE

			THIS.o_Conversor.c_InputFile			= THIS.c_InputFile
			THIS.o_Conversor.c_OutputFile			= THIS.c_OutputFile
			THIS.o_Conversor.c_LogFile				= THIS.c_LogFile
			THIS.o_Conversor.l_Debug				= THIS.l_Debug
			THIS.o_Conversor.l_Test					= THIS.l_Test
			THIS.o_Conversor.n_FB2PRG_Version		= THIS.n_FB2PRG_Version
			THIS.o_Conversor.l_MethodSort_Enabled	= THIS.l_MethodSort_Enabled
			THIS.o_Conversor.l_PropSort_Enabled		= THIS.l_PropSort_Enabled
			THIS.o_Conversor.l_ReportSort_Enabled	= THIS.l_ReportSort_Enabled
			*--
			THIS.o_Conversor.Convertir( @toModulo )
			THIS.o_Conversor	= NULL

		CATCH TO toEx
			lnCodError	= toEx.ERRORNO
			lcErrorInfo	= THIS.Exception2Str(toEx) + CR_LF + CR_LF + 'Fuente: ' + THIS.c_InputFile

			TRY
				STRTOFILE( lcErrorInfo, THIS.c_InputFile + '.ERR' )
			CATCH TO loEx2
			ENDTRY

			IF THIS.l_Debug
				IF _VFP.STARTMODE = 0
					SET STEP ON
				ENDIF
				THIS.writeLog( lcErrorInfo )
			ENDIF
			IF THIS.l_Debug AND THIS.l_ShowErrors
				MESSAGEBOX( lcErrorInfo, 0+16+4096, 'FOXBIN2PRG: ERROR!!', 10000 )
			ENDIF
			IF tlRelanzarError	&& Usado en Unit Testing
				THROW
			ENDIF
		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE writeLog
		LPARAMETERS tcText

		IF THIS.l_Debug
			TRY
				STRTOFILE( TTOC(DATETIME(),3) + '  ' + EVL(tcText,'') + CR_LF, THIS.c_LogFile, 1 )
			CATCH
			ENDTRY
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	HIDDEN PROCEDURE Exception2Str
		LPARAMETERS toEx AS EXCEPTION
		LOCAL lcError
		lcError		= 'Error ' + TRANSFORM(toEx.ERRORNO) + ', ' + toEx.MESSAGE + CR_LF ;
			+ toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) + CR_LF ;
			+ toEx.LINECONTENTS + CR_LF + CR_LF ;
			+ EVL(toEx.USERVALUE,'')
		RETURN lcError
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS frm_avance AS FORM
	HEIGHT = 79
	WIDTH = 628
	SHOWWINDOW = 2
	DOCREATE = .T.
	AUTOCENTER = .T.
	BORDERSTYLE = 2
	CAPTION = "Avance del proceso"
	CONTROLBOX = .F.
	BACKCOLOR = RGB(255,255,255)
	nMAX_VALUE = 100
	nVALUE = 0
	NAME = "FRM_AVANCE"


	ADD OBJECT shp_base AS SHAPE WITH ;
		TOP = 40, ;
		LEFT = 12, ;
		HEIGHT = 21, ;
		WIDTH = 601, ;
		CURVATURE = 15, ;
		NAME = "shp_base"


	ADD OBJECT shp_avance AS SHAPE WITH ;
		TOP = 40, ;
		LEFT = 12, ;
		HEIGHT = 21, ;
		WIDTH = 36, ;
		CURVATURE = 15, ;
		BACKCOLOR = RGB(255,255,128), ;
		BORDERCOLOR = RGB(255,0,0), ;
		NAME = "shp_Avance"


	ADD OBJECT lbl_TAREA AS LABEL WITH ;
		BACKSTYLE = 0, ;
		CAPTION = ".", ;
		HEIGHT = 17, ;
		LEFT = 12, ;
		TOP = 20, ;
		WIDTH = 604, ;
		NAME = "lbl_Tarea"


	PROCEDURE nvalue_assign
		LPARAMETERS vNewVal

		WITH THIS
			.nVALUE = m.vNewVal
			.shp_avance.WIDTH = m.vNewVal * .shp_base.WIDTH / .nMAX_VALUE
		ENDWITH
	ENDPROC


	PROCEDURE INIT
		THIS.nVALUE = 0
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_base AS SESSION
	#IF .F.
		LOCAL THIS AS c_conversor_base OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarasignacion_tag_indicado" type="method" display="analizarAsignacion_TAG_Indicado"/>] ;
		+ [<memberdata name="buscarobjetodelmetodopornombre" type="method" display="buscarObjetoDelMetodoPorNombre"/>] ;
		+ [<memberdata name="comprobarexpresionvalida" type="method" display="comprobarExpresionValida"/>] ;
		+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
		+ [<memberdata name="decode_specialcodes_1_31" type="method" display="decode_SpecialCodes_1_31"/>] ;
		+ [<memberdata name="desnormalizarasignacion" type="method" display="desnormalizarAsignacion"/>] ;
		+ [<memberdata name="desnormalizarvalorpropiedad" type="method" display="desnormalizarValorPropiedad"/>] ;
		+ [<memberdata name="desnormalizarvalorxml" type="method" display="desnormalizarValorXML"/>] ;
		+ [<memberdata name="dobackup" type="method" display="doBackup"/>] ;
		+ [<memberdata name="encode_specialcodes_1_31" type="method" display="encode_SpecialCodes_1_31"/>] ;
		+ [<memberdata name="exception2str" type="method" display="Exception2Str"/>] ;
		+ [<memberdata name="filetypedescription" type="method" display="fileTypeDescription"/>] ;
		+ [<memberdata name="filetypecode" type="method" display="fileTypeCode"/>] ;
		+ [<memberdata name="getdbfmetadata" type="method" display="getDBFmetadata"/>] ;
		+ [<memberdata name="getnext_bak" type="method" display="getNext_BAK"/>] ;
		+ [<memberdata name="get_separatedlineandcomment" type="method" display="get_SeparatedLineAndComment"/>] ;
		+ [<memberdata name="get_separatedpropandvalue" type="method" display="get_SeparatedPropAndValue"/>] ;
		+ [<memberdata name="identificarbloquesdeexclusion" type="method" display="identificarBloquesDeExclusion"/>] ;
		+ [<memberdata name="lineisonlycommentandnometadata" type="method" display="lineIsOnlyCommentAndNoMetadata"/>] ;
		+ [<memberdata name="normalizarasignacion" type="method" display="normalizarAsignacion"/>] ;
		+ [<memberdata name="normalizarvalorpropiedad" type="method" display="normalizarValorPropiedad"/>] ;
		+ [<memberdata name="normalizarvalorxml" type="method" display="normalizarValorXML"/>] ;
		+ [<memberdata name="sortpropsandvalues" type="method" display="sortPropsAndValues"/>] ;
		+ [<memberdata name="writelog" type="method" display="writeLog"/>] ;
		+ [<memberdata name="c_curdir" type="property" display="c_CurDir"/>] ;
		+ [<memberdata name="c_inputfile" type="property" display="c_InputFile"/>] ;
		+ [<memberdata name="c_logfile" type="property" display="c_LogFile"/>] ;
		+ [<memberdata name="c_outputfile" type="property" display="c_OutputFile"/>] ;
		+ [<memberdata name="c_type" type="property" display="c_Type"/>] ;
		+ [<memberdata name="l_debug" type="property" display="l_Debug"/>] ;
		+ [<memberdata name="l_test" type="property" display="l_Test"/>] ;
		+ [<memberdata name="l_methodsort_enabled" type="property" display="l_MethodSort_Enabled"/>] ;
		+ [<memberdata name="l_propsort_enabled" type="property" display="l_PropSort_Enabled"/>] ;
		+ [<memberdata name="l_reportsort_enabled" type="property" display="l_ReportSort_Enabled"/>] ;
		+ [<memberdata name="n_fb2prg_version" type="property" display="n_FB2PRG_Version"/>] ;
		+ [</VFPData>]


	l_Debug					= .F.
	l_Test					= .F.
	c_InputFile				= ''
	c_OutputFile			= ''
	lFileMode				= .T.
	nClassTimeStamp			= ''
	n_FB2PRG_Version		= 1.0
	c_Type					= ''
	c_CurDir				= ''
	c_LogFile				= ''
	l_MethodSort_Enabled	= .T.
	l_PropSort_Enabled		= .T.
	l_ReportSort_Enabled	= .T.


	*******************************************************************************************************************
	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF
		SET TABLEPROMPT OFF

		PUBLIC C_FB2PRG_CODE
		C_FB2PRG_CODE	= ''	&& Contendrá todo el código generado
		THIS.c_CurDir	= SYS(5) + CURDIR()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		C_FB2PRG_CODE	= ''
		USE IN (SELECT("TABLABIN"))

		THIS.writeLog( 'Descarga del conversor' )
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarAsignacion_TAG_Indicado
		*-- DETALLES: Este método está pensado para leer los tags FB2P_VALUE y MEMBERDATA, que tienen esta sintaxis:
		*
		*	_memberdata = <VFPData>
		*		<memberdata name="mimetodo" display="miMetodo"/>
		*		</VFPData>		&& XML Metadata for customizable properties
		*
		*	<fb2p_value>Este es un&#13;valor especial</fb2p_value>
		*
		*--------------------------------------------------------------------------------------------------------------
		* tcPropName				(!v IN    ) Nombre de la propiedad
		* tcValue					(!v IN    ) Valor (o inicio del valor) de la propiedad
		* taProps					(!@ IN    ) El array con las líneas del código donde buscar
		* tnProp_Count				(!@ IN    ) Cantidad de líneas de código
		* I							(!@ IN    ) Línea actualmente evaluada
		* tcTAG_I					(!v IN    ) TAG de inicio	<tag>
		* tcTAG_F					(!v IN    ) TAG de fin		</tag>
		* tnLEN_TAG_I				(!v IN    ) Longitud del tag de inicio
		* tnLEN_TAG_F				(!v IN    ) Longitud del tag de fin
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS tcPropName, tcValue, taProps, tnProp_Count, I, tcTAG_I, tcTAG_F, tnLEN_TAG_I, tnLEN_TAG_F
		EXTERNAL ARRAY taProps
		LOCAL llBloqueEncontrado, loEx AS EXCEPTION

		TRY
			IF LEFT( tcValue, tnLEN_TAG_I) == tcTAG_I
				llBloqueEncontrado	= .T.
				LOCAL lcLine, lnArrayCols

				*-- Propiedad especial
				IF tcTAG_F $ tcValue		&& El fin de tag está "inline"
					THIS.desnormalizarValorPropiedad( @tcPropName, @tcValue, '' )
					EXIT
				ENDIF

				tcValue			= ''
				lnArrayCols		= ALEN(taProps,2)

				FOR I = I + 1 TO tnProp_Count
					IF lnArrayCols = 0
						lcLine = LTRIM( taProps(I), 0, ' ', CHR(9) )	&& Quito espacios y TABS de la izquierda
					ELSE
						lcLine = LTRIM( taProps(I,1), 0, ' ', CHR(9) )	&& Quito espacios y TABS de la izquierda
					ENDIF

					DO CASE
					CASE LEFT( lcLine, tnLEN_TAG_F ) == tcTAG_F
						*-- <EndTag>
						tcValue	= tcTAG_I + SUBSTR( tcValue, 3 ) + tcTAG_F
						THIS.desnormalizarValorPropiedad( @tcPropName, @tcValue, '' )
						I = I + 1
						EXIT

					CASE tcTAG_F $ lcLine
						*-- Data-Data-Data-<EndTag>
						tcValue	= tcTAG_I + SUBSTR( tcValue, 3 ) + LEFT( lcLine, AT( tcTAG_F, lcLine )-1 ) + tcTAG_F
						THIS.desnormalizarValorPropiedad( @tcPropName, @tcValue, '' )
						I = I + 1
						EXIT

					OTHERWISE
						*-- Data
						tcValue	= tcValue + CR_LF + lcLine
					ENDCASE
				ENDFOR

				I = I - 1

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE buscarObjetoDelMetodoPorNombre
		LPARAMETERS tcNombreObjeto, toClase
		*-- Caso 1: Un método de un objeto de la clase
		*-- 	buscarObjetoDelMetodoPorNombre( 'command1', loClase )
		*-- Caso 2: Un método de un objeto heredado que no está definido en esta librería
		*-- 	buscarObjetoDelMetodoPorNombre( 'cnt_descripcion.Cntlista.cmgAceptarCancelar.cmdCancelar', loClase )
		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnObjeto, I, X, N, lcRutaDelNombre ;
				, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
			STORE 0 TO N, lnObjeto

			*--   El método puede pertenecer a esta clase, a un objeto de esta clase,
			*-- o a un objeto heredado que no está definido en esta clase, sino en otra,
			*-- y para la cual la ruta a buscar es parcial.
			*--   Por ejemplo, el caso 2 puede que el objeto que hay sea 'cnt_descripcion.Cntlista'
			*-- y el botón sea heredado, pero se le haya redefinido su método Click aquí.
			FOR X = OCCURS( '.', tcNombreObjeto + '.' ) TO 1 STEP -1
				N	= N + 1
				lcRutaDelNombre	= LEFT( tcNombreObjeto, RAT( '.', tcNombreObjeto + '.', N ) - 1 )
				FOR I = 1 TO toClase._AddObject_Count
					loObjeto	= toClase._AddObjects(I)

					*-- Busco tanto el [nombre] del método como [class.nombre]+[nombre] del método
					IF LOWER(loObjeto._Nombre) == LOWER(toClase._ObjName) + '.' + lcRutaDelNombre ;
							OR LOWER(loObjeto._Nombre) == lcRutaDelNombre
						lnObjeto	= I
						EXIT
					ENDIF
				ENDFOR
				IF lnObjeto > 0
					EXIT
				ENDIF
			ENDFOR

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lnObjeto
	ENDPROC


	*******************************************************************************************************************
	FUNCTION comprobarExpresionValida( tcAsignacion, tnCodError, tcExpNormalizada )
		LOCAL llError, loEx AS EXCEPTION

		TRY
			tcExpNormalizada	= NORMALIZE( tcAsignacion )

		CATCH TO loEx
			llError		= .T.
			tnCodError	= loEx.ERRORNO
		ENDTRY

		RETURN NOT llError
	ENDFUNC


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		THIS.writeLog( '' )
		THIS.writeLog( 'Convirtiendo archivo ' + THIS.c_OutputFile + '...' )
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE decode_SpecialCodes_1_31
		LPARAMETERS tcText
		LOCAL I
		FOR I = 0 TO 31
			tcText	= STRTRAN( tcText, '{' + TRANSFORM(I) + '}', CHR(I) )
		ENDFOR
		RETURN tcText
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE desnormalizarAsignacion
		LPARAMETERS tcAsignacion
		LOCAL lcPropName, lcValor, lnCodError, lcExpNormalizada, lnPos, lcComentario
		THIS.get_SeparatedPropAndValue( @tcAsignacion, @lcPropName, @lcValor )
		lcComentario	= ''
		THIS.desnormalizarValorPropiedad( @lcPropName, @lcValor, @lcComentario )
		tcAsignacion	= lcPropName + ' = ' + lcValor

		RETURN tcAsignacion
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE desnormalizarValorPropiedad
		LPARAMETERS tcProp, tcValue, tcComentario
		LOCAL lnCodError, lnPos, lcValue
		tcComentario	= ''

		*-- Ajustes de algunos casos especiales
		DO CASE
		CASE tcProp == '_memberdata'
			*-- Me quedo con lo importante y quito los CHR(0) y longitud que a veces agrega al inicio
			lcValue	= ''

			FOR I = 1 TO OCCURS( '/>', tcValue )
				TEXT TO lcValue TEXTMERGE ADDITIVE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<STREXTRACT( tcValue, '<memberdata ', '/>', I, 1+4 )>>
				ENDTEXT
			ENDFOR

			TEXT TO tcValue TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<VFPData>
				<<SUBSTR( lcValue, 3)>>
				</VFPData>
			ENDTEXT

			tcValue	= C_MPROPHEADER + STR( LEN(tcValue), 8 ) + tcValue

		CASE LEFT( tcValue, C_LEN_FB2P_VALUE_I ) == C_FB2P_VALUE_I
			*-- Valor especial Fox con cabecera CHR(1): Debo agregarla y desnormalizar el valor
			tcValue	= STRTRAN( STRTRAN( STREXTRACT( tcValue, C_FB2P_VALUE_I, C_FB2P_VALUE_F, 1, 1 ), '&#13;', C_CR ), '&#10;', C_LF  )
			tcValue	= C_MPROPHEADER + STR( LEN(tcValue), 8 ) + tcValue

		ENDCASE

		RETURN tcValue
	ENDFUNC


	*******************************************************************************************************************
	PROCEDURE desnormalizarValorXML
		LPARAMETERS tcValor
		*-- DESNORMALIZA EL TEXTO INDICADO, EXPANDIENDO LOS SÍMBOLOS XML ESPECIALES.
		LOCAL lnPos, lnPos2, lnAscii
		tcValor	= STRTRAN(tcValor, CHR(38)+'gt;', '>')			&&	>
		tcValor	= STRTRAN(tcValor, CHR(38)+'lt;', '<')			&&	<
		tcValor	= STRTRAN(tcValor, CHR(38)+'quot;', CHR(34))	&&	"
		tcValor	= STRTRAN(tcValor, CHR(38)+'apos;', CHR(39))	&&	'
		tcValor	= STRTRAN(tcValor, CHR(38)+'amp;', CHR(38))		&&	&

		*-- Obtengo los Hex
		DO WHILE .T.
			lnPos	= AT( CHR(38)+'#x', tcValor )
			IF lnPos = 0
				EXIT
			ENDIF
			lnPos2	= lnPos + 1 + AT( ';', SUBSTR( tcValor, lnPos + 2, 4 ) )
			lnAscii	= EVALUATE( '0' + SUBSTR( tcValor, lnPos + 3, lnPos2 - lnPos - 3 ) )
			tcValor	= STUFF(tcValor, lnPos, lnPos2 - lnPos + 1, CHR(lnAscii))		&&	ASCII
		ENDDO

		*-- Obtengo los Dec
		DO WHILE .T.
			lnPos	= AT( CHR(38)+'#', tcValor )
			IF lnPos = 0
				EXIT
			ENDIF
			lnPos2	= lnPos + 1 + AT( ';', SUBSTR( tcValor, lnPos + 2, 4 ) )
			lnAscii	= EVALUATE( SUBSTR( tcValor, lnPos + 2, lnPos2 - lnPos - 2 ) )
			tcValor	= STUFF(tcValor, lnPos, lnPos2 - lnPos + 1, CHR(lnAscii))		&&	ASCII
		ENDDO

		RETURN tcValor
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE doBackup
		LPARAMETERS toEx, tlRelanzarError, tcBakFile_1, tcBakFile_2, tcBakFile_3

		TRY
			LOCAL lcNext_Bak, lcExt_1, lcExt_2, lcExt_3
			STORE '' TO tcBakFile_1, tcBakFile_2, tcBakFile_3
			lcNext_Bak	= THIS.getNext_BAK( THIS.c_OutputFile )
			lcExt_1		= JUSTEXT( THIS.c_OutputFile )
			tcBakFile_1	= FORCEEXT(THIS.c_OutputFile, lcExt_1 + lcNext_Bak)

			DO CASE
			CASE lcExt_1 = 'DBF'
				*-- DBF
				lcExt_2		= 'FPT'
				lcExt_3		= 'CDX'
				tcBakFile_2	= FORCEEXT(THIS.c_OutputFile, lcExt_2 + lcNext_Bak)
				tcBakFile_3	= FORCEEXT(THIS.c_OutputFile, lcExt_3 + lcNext_Bak)

			CASE lcExt_1 = 'DBC'
				*-- DBC
				lcExt_2		= 'DCT'
				lcExt_3		= 'DCX'
				tcBakFile_2	= FORCEEXT(THIS.c_OutputFile, lcExt_2 + lcNext_Bak)
				tcBakFile_3	= FORCEEXT(THIS.c_OutputFile, lcExt_3 + lcNext_Bak)

			OTHERWISE
				*-- PJX, VCX, SCX, FRX, LBX, MNX
				lcExt_2		= LEFT(lcExt_1,2) + 'T'
				tcBakFile_2	= FORCEEXT(THIS.c_OutputFile, lcExt_2 + lcNext_Bak)

			ENDCASE

			IF NOT EMPTY(lcExt_1) AND FILE( FORCEEXT(THIS.c_OutputFile, lcExt_1) )
				IF EMPTY(lcExt_3)
					THIS.writeLog( 'backup de: ' + FORCEEXT(THIS.c_OutputFile,lcExt_1) + '/' + lcExt_2 )
				ELSE
					THIS.writeLog( 'backup de: ' + FORCEEXT(THIS.c_OutputFile,lcExt_1) + '/' + lcExt_2 + '/' + lcExt_3 )
				ENDIF

				*COPY FILE ( FORCEEXT(THIS.c_OutputFile, lcExt_1) ) TO ( FORCEEXT(THIS.c_OutputFile, lcExt_1 + lcNext_Bak) )
				RENAME ( FORCEEXT(THIS.c_OutputFile, lcExt_1) ) TO ( tcBakFile_1 )

				IF NOT EMPTY(lcExt_2) AND FILE( FORCEEXT(THIS.c_OutputFile, lcExt_2) )
					*COPY FILE ( FORCEEXT(THIS.c_OutputFile, lcExt_2) ) TO ( FORCEEXT(THIS.c_OutputFile, lcExt_2 + lcNext_Bak) )
					RENAME ( FORCEEXT(THIS.c_OutputFile, lcExt_2) ) TO ( tcBakFile_2 )
				ENDIF

				IF NOT EMPTY(lcExt_3) AND FILE( FORCEEXT(THIS.c_OutputFile, lcExt_3) )
					*COPY FILE ( FORCEEXT(THIS.c_OutputFile, lcExt_3) ) TO ( FORCEEXT(THIS.c_OutputFile, lcExt_3 + lcNext_Bak) )
					RENAME ( FORCEEXT(THIS.c_OutputFile, lcExt_3) ) TO ( tcBakFile_3 )
				ENDIF
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			IF tlRelanzarError
				THROW
			ENDIF

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE encode_SpecialCodes_1_31
		LPARAMETERS tcText
		LOCAL I
		FOR I = 0 TO 31
			tcText	= STRTRAN( tcText, CHR(I), '{' + TRANSFORM(I) + '}' )
		ENDFOR
		RETURN tcText
	ENDPROC


	*******************************************************************************************************************
	HIDDEN PROCEDURE Exception2Str
		LPARAMETERS toEx AS EXCEPTION
		LOCAL lcError
		lcError		= 'Error ' + TRANSFORM(toEx.ERRORNO) + ', ' + toEx.MESSAGE + CHR(13) + CHR(13) ;
			+ toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) + CHR(13) + CHR(13) ;
			+ toEx.LINECONTENTS
		RETURN lcError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE fileTypeDescription
		*---------------------------------------------------------------------------------------------------
		* PARÁMETROS:				!=Obligatorio, ?=Opcional, @=Pasar por referencia, v=Pasar por valor (IN/OUT)
		* tn_HexFileType			(@? IN    ) Tipo de archivo en hexadecimal (Está detallado en la ayuda de Fox)
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tn_HexFileType
		LOCAL lcFileType

		DO CASE
		CASE tn_HexFileType = 0x02
			lcFileType	= 'FoxBASE / dBase II'
		CASE tn_HexFileType = 0x03
			lcFileType	= 'FoxBASE+ / FoxPro /dBase III PLUS / dBase IV, no memo'
		CASE tn_HexFileType = 0x30
			lcFileType	= 'Visual FoxPro'
		CASE tn_HexFileType = 0x31
			lcFileType	= 'Visual FoxPro, autoincrement enabled'
		CASE tn_HexFileType = 0x32
			lcFileType	= 'Visual FoxPro, Varchar, Varbinary, or Blob-enabled'
		CASE tn_HexFileType = 0x43
			lcFileType	= 'dBASE IV SQL table files, no memo'
		CASE tn_HexFileType = 0x63
			lcFileType	= 'dBASE IV SQL system files, no memo'
		CASE tn_HexFileType = 0x83
			lcFileType	= 'FoxBASE+/dBASE III PLUS, with memo'
		CASE tn_HexFileType = 0x8B
			lcFileType	= 'dBASE IV with memo'
		CASE tn_HexFileType = 0xCB
			lcFileType	= 'dBASE IV SQL table files, with memo'
		CASE tn_HexFileType = 0xF5
			lcFileType	= 'FoxPro 2.x (or earlier) with memo'
		CASE tn_HexFileType = 0xFB
			lcFileType	= 'FoxBASE (?)'
		OTHERWISE
			lcFileType	= 'Unknown'
		ENDCASE

		RETURN lcFileType
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE fileTypeCode
		LPARAMETERS tcExtension
		tcExtension	= UPPER(tcExtension)
		RETURN ICASE( tcExtension = 'DBC', 'd' ;
			, tcExtension = 'DBF', 'D' ;
			, tcExtension = 'QPR', 'Q' ;
			, tcExtension = 'SCX', 'K' ;
			, tcExtension = 'FRX', 'R' ;
			, tcExtension = 'LBX', 'B' ;
			, tcExtension = 'VCX', 'V' ;
			, tcExtension = 'PRG', 'P' ;
			, tcExtension = 'FLL', 'L' ;
			, tcExtension = 'APP', 'Z' ;
			, tcExtension = 'EXE', 'Z' ;
			, tcExtension = 'MNX', 'M' ;
			, tcExtension = 'TXT', 'T' ;
			, tcExtension = 'FPW', 'T' ;
			, tcExtension = 'H', 'T' ;
			, 'x' )
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE getNext_BAK
		LPARAMETERS tcOutputFileName
		LOCAL lcNext_Bak, I
		lcNext_Bak = ''

		FOR I = 0 TO 99
			IF I = 0
				IF NOT FILE( tcOutputFileName + '.BAK' )
					lcNext_Bak	= '.BAK'
					EXIT
				ENDIF
			ELSE
				IF NOT FILE( tcOutputFileName + '.' + PADL(I,2,'0') + '.BAK' )
					lcNext_Bak	= '.' + PADL(I,2,'0') + '.BAK'
					EXIT
				ENDIF
			ENDIF
		ENDFOR

		lcNext_Bak	= EVL( lcNext_Bak, '.100.BAK' )	&& Para que no quede nunca vacío

		RETURN lcNext_Bak
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE getDBFmetadata
		*---------------------------------------------------------------------------------------------------
		* PARÁMETROS:				!=Obligatorio, ?=Opcional, @=Pasar por referencia, v=Pasar por valor (IN/OUT)
		* tc_FileName				(v! IN    ) Nombre del DBF a analizar
		* tn_HexFileType			(@?    OUT) Tipo de archivo en hexadecimal (Está detallado en la ayuda de Fox)
		* tl_FileHasCDX				(@?    OUT) Indica si el archivo tiene CDX asociado
		* tl_FileHasMemo			(@?    OUT) Indica si el archivo tiene archivo MEMO asociado
		* tl_FileIsDBC				(@?    OUT) Indica si el archivo es un DBC (base de datos)
		* tcDBC_Name				(@?    OUT) Si tiene DBC, contiene el nombre del DBC asociado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tc_FileName, tn_HexFileType, tl_FileHasCDX, tl_FileHasMemo, tl_FileIsDBC, tcDBC_Name

		TRY
			LOCAL lnHandle, lcStr, lnDataPos, lnFieldCount, loEx AS EXCEPTION
			tn_HexFileType	= 0
			tcDBC_Name		= ''
			lnHandle		= FOPEN(tc_FileName,0)

			IF lnHandle = -1
				EXIT
			ENDIF

			lcStr			= FREAD(lnHandle,1)		&& File type
			tn_HexFileType	= EVALUATE( TRANSFORM(ASC(lcStr),'@0') )
			lcStr			= FREAD(lnHandle,3)		&& Last update (YYMMDD)
			lcStr			= FREAD(lnHandle,4)		&& Number of records in file
			lcStr			= FREAD(lnHandle,2)		&& Position of first data record
			lnDataPos		= CTOBIN(lcStr,"2RS")
			lnFieldCount	= (lnDataPos - 296) / 32
			lcStr			= FREAD(lnHandle,2)		&& Length of one data record, including delete flag
			lcStr			= FREAD(lnHandle,16)	&& Reserved
			lcStr			= FREAD(lnHandle,1)		&& Table flags: 0x01=Has CDX, 0x02=Has Memo, 0x04=Id DBC (flags acumulativos)
			tl_FileHasCDX	= ( BITAND( EVALUATE(TRANSFORM(ASC(lcStr),'@0')), 0x01 ) > 0 )
			tl_FileHasMemo	= ( BITAND( EVALUATE(TRANSFORM(ASC(lcStr),'@0')), 0x02 ) > 0 )
			tl_FileIsDBC	= ( BITAND( EVALUATE(TRANSFORM(ASC(lcStr),'@0')), 0x04 ) > 0 )
			lcStr			= FREAD(lnHandle,1)		&& Code page mark
			lcStr			= FREAD(lnHandle,2)		&& Reserved, contains 0x00
			lcStr			= FREAD(lnHandle,32 * lnFieldCount)		&& Field subrecords (los salteo)
			lcStr			= FREAD(lnHandle,1)		&& Header Record Terminator (0x0D)
			lcStr			= FREAD(lnHandle,263)	&& Backlink (relative path of an associated database (.dbc) file)
			tcDBC_Name		= RTRIM(lcStr,0,CHR(0))	&& DBC Name (si tiene)

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			FCLOSE(lnHandle)
		ENDTRY

		RETURN lnHandle
	ENDPROC


	*******************************************************************************************************************
	FUNCTION GetTimeStamp(tnTimeStamp)
		*-- CONVIERTE UN DATO TIMESTAMP NUMERICO USADO POR LOS ARCHIVOS SCX/VCX/etc. EN TIPO DATETIME
		TRY
			LOCAL lcTimeStamp,lnYear,lnMonth,lnDay,lnHour,lnMinutes,lnSeconds,lcTime,lnHour,ltTimeStamp,lnResto ;
				,lcTimeStamp_Ret, laDir[1,5], loEx AS EXCEPTION

			lcTimeStamp_Ret	= ''

			IF EMPTY(tnTimeStamp)
				IF THIS.lFileMode
					IF ADIR(laDir,THIS.c_InputFile)=0
						EXIT
					ENDIF

					*-- Esto fuerza la conversión a formato 12 hs, que no me interesa.
					*lcTime=laDir[1,4]
					*lnHour=VAL(lcTime)
					*IF lnHour<12
					*	lcTime=ALLTRIM(STR(IIF(lnHour=0,12,lnHour),2))+SUBSTR(lcTime,3)+" AM"
					*ELSE
					*	lcTime=ALLTRIM(STR(IIF(lnHour=12,24,lnHour)-12,2))+SUBSTR(lcTime,3)+" PM"
					*ENDIF
					*IF VAL(lcTime)<10
					*	lcTime="0"+lcTime
					*ENDIF
					*lcTimeStamp_Ret	= DTOC(laDir[1,3])+" "+lcTime

					ltTimeStamp	= EVALUATE( '{^' + DTOC(laDir(1,3)) + ' ' + TRANSFORM(laDir(1,4)) + '}' )

					*-- En mi arreglo, si la hora pasada tiene 32 segundos o más, redondeo al siguiente minuto, ya que
					*-- la descodificación posterior de GetTimeStamp tiene ese margen de error.
					IF SEC(m.ltTimeStamp) >= 32
						ltTimeStamp	= m.ltTimeStamp + 28
					ENDIF

					lcTimeStamp_Ret	= TTOC( ltTimeStamp )
					EXIT
				ENDIF

				tnTimeStamp = THIS.nClassTimeStamp

				IF EMPTY(tnTimeStamp)
					EXIT
				ENDIF
			ENDIF

			*-- YYYY YYYM MMMD DDDD HHHH HMMM MMMS SSSS
			lnResto		= tnTimeStamp
			lnYear		= INT( lnResto / 2**25 + 1980)
			lnResto		= lnResto % 2**25
			lnMonth		= INT( lnResto / 2**21 )
			lnResto		= lnResto % 2**21
			lnDay		= INT( lnResto / 2**16 )
			lnResto		= lnResto % 2**16
			lnHour		= INT( lnResto / 2**11 )
			lnResto		= lnResto % 2**11
			lnMinutes	= INT( lnResto / 2**5 )
			lnResto		= lnResto % 2**5
			lnSeconds	= lnResto

			lcTimeStamp	= STR(lnYear,4) + "/" + STR(lnMonth,2) + "/" + STR(lnDay,2) + " " ;
				+ STR(lnHour,2) + ":" + STR(lnMinutes,2) + ":" + STR(lnSeconds,2)

			ltTimeStamp	= EVALUATE( "{^" + lcTimeStamp + "}" )

			lcTimeStamp_Ret	= TTOC( ltTimeStamp )

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcTimeStamp_Ret
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_SeparatedLineAndComment
		LPARAMETERS tcLine, tcComment
		LOCAL ln_AT_Cmt
		tcComment	= ''

		IF '&'+'&' $ tcLine
			ln_AT_Cmt	= AT( '&'+'&', tcLine)
			tcComment	= LTRIM( SUBSTR( tcLine, ln_AT_Cmt + 2 ) )
			tcLine		= RTRIM( LEFT( tcLine, ln_AT_Cmt - 1 ), 0, ' ', CHR(9) )	&& Quito espacios y TABS
		ENDIF

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_SeparatedPropAndValue
		*-- Devuelve el valor separado de la propiedad.
		*-- Si se indican más de 3 parámetros, evalúa el valor completo a través de las líneas de código
		*--------------------------------------------------------------------------------------------------------------
		* taCodeLines				(!@ IN    ) El array con las líneas del código donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de líneas de código
		* taBloquesExclusion		(!@ IN    ) Array con las posiciones de inicio/fin de los bloques de exclusion
		* tnBloquesExclusion		(!@ IN    ) Cantidad de bloques de exclusión
		* toModulo					(?@    OUT) Objeto con toda la información del módulo analizado
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS tcAsignacion, tcPropName, tcValue, toClase, taCodeLines, tnCodeLines, I
		LOCAL ln_AT_Cmt
		STORE '' TO tcPropName, tcValue

		*-- EVALUAR UNA ASIGNACIÓN ESPECÍFICA INLINE
		IF '=' $ tcAsignacion
			ln_AT_Cmt	= AT( '=', tcAsignacion)
			tcPropName	= ALLTRIM( LEFT( tcAsignacion, ln_AT_Cmt - 2 ), 0, ' ', CHR(9) )	&& Quito espacios y TABS
			tcValue		= ALLTRIM( SUBSTR( tcAsignacion, ln_AT_Cmt + 2 ) )

			IF PCOUNT() > 3
				*-- EVALUAR UNA ASIGNACIÓN QUE PUEDE SER MULTILÍNEA (memberdata, fb2p_value, etc)
				DO CASE
				CASE THIS.analizarAsignacion_TAG_Indicado( @tcPropName, @tcValue, @taCodeLines, tnCodeLines, @I ;
						, C_FB2P_VALUE_I, C_FB2P_VALUE_F, C_LEN_FB2P_VALUE_I, C_LEN_FB2P_VALUE_F )
					*-- FB2P_VALUE

				CASE THIS.analizarAsignacion_TAG_Indicado( @tcPropName, @tcValue, @taCodeLines, tnCodeLines, @I ;
						, C_MEMBERDATA_I, C_MEMBERDATA_F, C_LEN_MEMBERDATA_I, C_LEN_MEMBERDATA_F )
					*-- MEMBERDATA

				OTHERWISE
					*-- Propiedad normal
					THIS.desnormalizarValorPropiedad( @tcPropName, @tcValue, '' )

				ENDCASE
			ENDIF
		ENDIF

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toModulo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE lineaExcluida
		LPARAMETERS tn_Linea, tnBloquesExclusion, taBloquesExclusion

		EXTERNAL ARRAY taBloquesExclusion
		LOCAL X, llExcluida

		FOR X = 1 TO tnBloquesExclusion
			IF BETWEEN( tn_Linea, taBloquesExclusion(X,1), taBloquesExclusion(X,2) )
				llExcluida	= .T.
				EXIT
			ENDIF
		ENDFOR

		RETURN llExcluida
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE lineIsOnlyCommentAndNoMetadata
		LPARAMETERS tcLine, tcComment
		LOCAL lllineIsOnlyCommentAndNoMetadata, ln_AT_Cmt

		THIS.get_SeparatedLineAndComment( @tcLine, @tcComment )

		DO CASE
		CASE LEFT(tcLine,2) == '*<'
			tcComment	= tcLine

		CASE EMPTY(tcLine) OR LEFT(tcLine, 1) == '*' OR LEFT(tcLine + ' ', 5) == 'NOTE ' && Vacía o Comentarios
			lllineIsOnlyCommentAndNoMetadata = .T.

		ENDCASE

		RETURN lllineIsOnlyCommentAndNoMetadata
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE normalizarAsignacion
		LPARAMETERS tcAsignacion, tcComentario
		LOCAL lcPropName, lcValor, lnCodError, lcExpNormalizada, lnPos
		THIS.get_SeparatedPropAndValue( @tcAsignacion, @lcPropName, @lcValor )
		tcComentario	= ''
		THIS.normalizarValorPropiedad( @lcPropName, @lcValor, @tcComentario )
		tcAsignacion	= lcPropName + ' = ' + lcValor
		RETURN tcAsignacion
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE normalizarValorPropiedad
		LPARAMETERS tcProp, tcValue, tcComentario
		LOCAL lcValue, I
		tcComentario	= ''

		*-- Ajustes de algunos casos especiales
		DO CASE
		CASE tcProp == '_memberdata'
			lcValue	= ''

			FOR I = 1 TO OCCURS( '/>', tcValue )
				TEXT TO lcValue TEXTMERGE ADDITIVE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>><<C_TAB>><<STREXTRACT( tcValue, '<memberdata ', '/>', I, 1+4 )>>
				ENDTEXT
			ENDFOR

			TEXT TO tcValue TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<VFPData>
				<<SUBSTR( lcValue, 3)>>
				<<C_TAB>><<C_TAB>></VFPData>
			ENDTEXT

		CASE LEFT( tcValue, C_LEN_FB2P_VALUE_I ) == C_FB2P_VALUE_I
			*-- Valor especial Fox con cabecera CHR(1): Debo quitarla y normalizar el valor
			tcValue	= C_FB2P_VALUE_I ;
				+ STRTRAN( STRTRAN( STRTRAN( STRTRAN( ;
				STREXTRACT( tcValue, C_FB2P_VALUE_I, C_FB2P_VALUE_F, 1, 1 ) ;
				, CR_LF, '&#13+10;' ), C_CR, '&#13;' ), C_LF, '&#10;' ), '&#13+10;', CR_LF ) ;
				+ C_FB2P_VALUE_F


		ENDCASE

		RETURN tcValue
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE normalizarValorXML
		LPARAMETERS tcValor
		*-- NORMALIZA EL TEXTO INDICADO, COMPRIMIENDO LOS SÍMBOLOS XML ESPECIALES.
		tcValor = STRTRAN(tcValor, CHR(38), CHR(38) + 'amp;')	&& reemplaza &  por  &amp;		&&
		tcValor = STRTRAN(tcValor, CHR(39), CHR(38) + 'apos;')	&& reemplaza '  por  &apos;		&&
		tcValor = STRTRAN(tcValor, CHR(34), CHR(38) + 'quot;')	&& reemplaza "  por  &quot;		&&
		tcValor = STRTRAN(tcValor, '<', CHR(38) + 'lt;') 		&&  reemplaza <  por  &lt;		&&
		tcValor = STRTRAN(tcValor, '>', CHR(38) + 'gt;')		&&  reemplaza >  por  &gt;		&&
		tcValor = STRTRAN(tcValor, CHR(13)+CHR(10), CHR(10))	&& reeemplaza CR+LF por LF
		tcValor = CHRTRAN(tcValor, CHR(13), CHR(10))			&& reemplaza CR por LF

		RETURN tcValor
	ENDPROC


	*******************************************************************************************************************
	FUNCTION RowTimeStamp(ltDateTime)
		* Generate a FoxPro 3.0-style row timestamp
		*-- CONVIERTE UN DATO TIPO DATETIME EN TIMESTAMP NUMERICO USADO POR LOS ARCHIVOS SCX/VCX/etc.
		LOCAL lcTimeValue, tnTimeStamp

		IF VARTYPE(m.ltDateTime) <> 'T'
			m.ltDateTime		= DATETIME()
		ENDIF

		tnTimeStamp = ( YEAR(m.ltDateTime) - 1980) * 2^25 ;
			+ MONTH(m.ltDateTime) * 2^21 ;
			+ DAY(m.ltDateTime) * 2^16 ;
			+ HOUR(m.ltDateTime) * 2^11 ;
			+ MINUTE(m.ltDateTime) * 2^5 ;
			+ SEC(m.ltDateTime)
		RETURN INT(tnTimeStamp)
	ENDFUNC


	*******************************************************************************************************************
	PROCEDURE sortPropsAndValues
		* KNOWLEDGE BASE:
		* 02/12/2013	FDBOZZO		Fidel Charny me pasó un ejemplo donde se pierden propiedades físicamente
		*							si se ordenan alfabéticamente en un ADD OBJECT. Pierde "picture" y otras más.
		*							Pareciera que la última debe ser "Name".
		*--------------------------------------------------------------------------------------------------------------
		* PARÁMETROS:				!=Obligatorio, ?=Opcional, @=Pasar por referencia, v=Pasar por valor (IN/OUT)
		* taPropsAndValues			(!@ IN    ) El array con las propiedades y valores del objeto o clase
		* tnPropsAndValues_Count	(!v IN    ) Cantidad de propiedades
		* tnSortType				(!v IN    ) Tipo de sort:
		*											0=Solo separar propiedades de clase y de objetos (.)
		*											1=Sort completo de propiedades (para la versión TEXTO)
		*											2=Sort completo de propiedades con "Name" al final (para la versión BIN)
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS taPropsAndValues, tnPropsAndValues_Count, tnSortType
		EXTERNAL ARRAY taPropsAndValues

		TRY
			LOCAL I, X, lnArrayCols, laPropsAndValues(1,2)
			lnArrayCols	= ALEN( taPropsAndValues, 2 )
			DIMENSION laPropsAndValues( tnPropsAndValues_Count, lnArrayCols )
			ACOPY( taPropsAndValues, laPropsAndValues )

			IF m.tnSortType >= 1
				* CON SORT:
				* - A las que no tienen '.' les pongo 'A' por delante, y al resto 'B' por delante para que queden al final
				FOR I = 1 TO m.tnPropsAndValues_Count
					IF '.' $ laPropsAndValues(I,1)
						IF m.tnSortType = 2 AND JUSTEXT( laPropsAndValues(I,1) ) == 'Name'
							laPropsAndValues(I,1)	= JUSTSTEM( laPropsAndValues(I,1) ) + '.' + CHR(255) + 'Name'
						ENDIF

						laPropsAndValues(I,1)	= 'B' + laPropsAndValues(I,1)
					ELSE
						IF m.tnSortType = 2 AND laPropsAndValues(I,1) == 'Name'
							laPropsAndValues(I,1)	= CHR(255) + 'Name'
						ENDIF

						laPropsAndValues(I,1)	= 'A' + laPropsAndValues(I,1)
					ENDIF
				ENDFOR

				IF THIS.l_PropSort_Enabled
					ASORT( laPropsAndValues, 1, -1, 0, 1)
				ENDIF


				FOR I = 1 TO m.tnPropsAndValues_Count
					taPropsAndValues(I,1)	= SUBSTR( laPropsAndValues(I,1), 2 )	&& Quitar el carácter agregado
					taPropsAndValues(I,2)	= laPropsAndValues(I,2)
					IF lnArrayCols >= 3
						taPropsAndValues(I,3)	= laPropsAndValues(I,3)
					ENDIF

					DO CASE
					CASE m.tnSortType <> 2
						*-- Saltear
					CASE taPropsAndValues(I,1) == CHR(255) + 'Name'
						taPropsAndValues(I,1)	= 'Name'
					CASE JUSTEXT( taPropsAndValues(I,1) ) == CHR(255) + 'Name'
						taPropsAndValues(I,1)	= JUSTSTEM( taPropsAndValues(I,1) ) + '.Name'
					ENDCASE
				ENDFOR

			ELSE	&& m.tnSortType = 0
				*-- SIN SORT: Creo 2 arrays, el bueno y el temporal, y al terminar agrego el temporal al bueno.
				*-- Debo separar las props.normales de las de los objetos (ocurre cuando es un ADD OBJECT)
				X	= 0

				*-- PRIMERO las que no tienen punto
				FOR I = 1 TO m.tnPropsAndValues_Count
					IF EMPTY( laPropsAndValues(I,1) )
						LOOP
					ENDIF

					IF NOT '.' $ laPropsAndValues(I,1)
						X	= X + 1
						taPropsAndValues(X,1)	= laPropsAndValues(I,1)
						taPropsAndValues(X,2)	= laPropsAndValues(I,2)
						IF lnArrayCols >= 3
							taPropsAndValues(X,3)	= laPropsAndValues(I,3)
						ENDIF
					ENDIF
				ENDFOR

				*-- LUEGO las demás props.
				FOR I = 1 TO m.tnPropsAndValues_Count
					IF EMPTY( laPropsAndValues(I,1) )
						LOOP
					ENDIF

					IF '.' $ laPropsAndValues(I,1)
						X	= X + 1
						taPropsAndValues(X,1)	= laPropsAndValues(I,1)
						taPropsAndValues(X,2)	= laPropsAndValues(I,2)
						IF lnArrayCols >= 3
							taPropsAndValues(X,3)	= laPropsAndValues(I,3)
						ENDIF
					ENDIF
				ENDFOR
			ENDIF

			*-- VER ESTO SI HACE FALTA, SOBRE LO DE PONER LOS METODOS AL FINAL Y ADAPTAR
			*-- Agregar propiedades primero
			*FOR I = 1 TO m.tnPropsAndValues_Count
			*	*-- SI HACE FALTA QUE LOS MÉTODOS ESTÉN AL FINAL, DESCOMENTAR ESTO (Y EL DE MÁS ARRIBA)
			*	*IF LEFT(taPropsAndValues(I), 1) == '*'	&& Only Reserved3 have this
			*	*	lcMethods	= m.lcMethods + m.taPropsAndValues(I,1) + ' = ' + m.taPropsAndValues(I,2) + CR_LF
			*	*	LOOP
			*	*ENDIF

			*	tcSortedMemo	= m.tcSortedMemo + m.laPropsAndValues(I,1) + ' = ' + m.laPropsAndValues(I,2) + CR_LF
			*ENDFOR

			*-- Agregar métodos al final
			*tcSortedMemo	= m.tcSortedMemo + m.lcMethods

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE writeLog
		LPARAMETERS tcText

		IF THIS.l_Debug
			TRY
				STRTOFILE( TTOC(DATETIME(),3) + '  ' + EVL(tcText,'') + CR_LF, THIS.c_LogFile, 1 )
			CATCH
			ENDTRY
		ENDIF
	ENDPROC


ENDDEFINE



*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_bin AS c_conversor_base
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_bin OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarbloque_add_object" type="method" display="analizarBloque_ADD_OBJECT"/>] ;
		+ [<memberdata name="analizarbloque_defined_pam" type="method" display="analizarBloque_DEFINED_PAM"/>] ;
		+ [<memberdata name="analizarbloque_define_class" type="method" display="analizarBloque_DEFINE_CLASS"/>] ;
		+ [<memberdata name="analizarbloque_enddefine" type="method" display="analizarBloque_ENDDEFINE"/>] ;
		+ [<memberdata name="analizarbloque_foxbin2prg" type="method" display="analizarBloque_FoxBin2Prg"/>] ;
		+ [<memberdata name="analizarbloque_hidden" type="method" display="analizarBloque_HIDDEN"/>] ;
		+ [<memberdata name="analizarbloque_include" type="method" display="analizarBloque_INCLUDE"/>] ;
		+ [<memberdata name="analizarbloque_metadata" type="method" display="analizarBloque_METADATA"/>] ;
		+ [<memberdata name="analizarbloque_ole_def" type="method" display="analizarBloque_OLE_DEF"/>] ;
		+ [<memberdata name="analizarbloque_procedure" type="method" display="analizarBloque_PROCEDURE"/>] ;
		+ [<memberdata name="analizarbloque_protected" type="method" display="analizarBloque_PROTECTED"/>] ;
		+ [<memberdata name="analizarlineasdeprocedure" type="method" display="analizarLineasDeProcedure"/>] ;
		+ [<memberdata name="classmethods2memo" type="method" display="classMethods2Memo"/>] ;
		+ [<memberdata name="classprops2memo" type="method" display="classProps2Memo"/>] ;
		+ [<memberdata name="createclasslib" type="method" display="createClasslib"/>] ;
		+ [<memberdata name="createclasslib_recordheader" type="method" display="createClasslib_RecordHeader"/>] ;
		+ [<memberdata name="createform" type="method" display="createForm"/>] ;
		+ [<memberdata name="createform_recordheader" type="method" display="createForm_RecordHeader"/>] ;
		+ [<memberdata name="createproject" type="method" display="createProject"/>] ;
		+ [<memberdata name="createproject_recordheader" type="method" display="createProject_RecordHeader"/>] ;
		+ [<memberdata name="createreport" type="method" display="createReport"/>] ;
		+ [<memberdata name="defined_pam2memo" type="method" display="defined_PAM2Memo"/>] ;
		+ [<memberdata name="emptyrecord" type="method" display="emptyRecord"/>] ;
		+ [<memberdata name="escribirarchivobin" type="method" display="escribirArchivoBin"/>] ;
		+ [<memberdata name="evaluate_pam" type="method" display="Evaluate_PAM"/>] ;
		+ [<memberdata name="evaluardefiniciondeprocedure" type="method" display="evaluarDefinicionDeProcedure"/>] ;
		+ [<memberdata name="getclassmethodcomment" type="method" display="getClassMethodComment"/>] ;
		+ [<memberdata name="getclasspropertycomment" type="method" display="getClassPropertyComment"/>] ;
		+ [<memberdata name="get_listnameswithvaluesfrom_inline_metadatatag" type="method" display="get_ListNamesWithValuesFrom_InLine_MetadataTag"/>] ;
		+ [<memberdata name="get_valuebyname_fromlistnameswithvalues" type="method" display="get_ValueByName_FromListNamesWithValues"/>] ;
		+ [<memberdata name="hiddenandprotected_pam" type="method" display="hiddenAndProtected_PAM"/>] ;
		+ [<memberdata name="identificarbloquesdeexclusion" type="method" display="identificarBloquesDeExclusion"/>] ;
		+ [<memberdata name="insert_allobjects" type="method" display="insert_AllObjects"/>] ;
		+ [<memberdata name="insert_object" type="method" display="insert_Object"/>] ;
		+ [<memberdata name="objectmethods2memo" type="method" display="objectMethods2Memo"/>] ;
		+ [<memberdata name="set_line" type="method" display="set_Line"/>] ;
		+ [<memberdata name="strip_dimensions" type="method" display="strip_Dimensions"/>] ;
		+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )
	ENDPROC


	*******************************************************************************************************************
	FUNCTION get_ValueByName_FromListNamesWithValues
		*-- ASIGNO EL VALOR DEL ARRAY DE DATOS Y VALORES PARA LA PROPIEDAD INDICADA
		LPARAMETERS tcPropName, tcValueType, taPropsAndValues
		LOCAL lnPos, luPropValue

		lnPos	= ASCAN( taPropsAndValues, tcPropName, 1, 0, 1, 1+2+4+8)

		IF lnPos = 0 OR EMPTY( taPropsAndValues( lnPos, 2 ) )
			*-- Valores no encontrados o vacíos
			luPropValue	= ''
		ELSE
			luPropValue	= taPropsAndValues( lnPos, 2 )
		ENDIF

		DO CASE
		CASE tcValueType = 'I'
			luPropValue	= CAST( luPropValue AS INTEGER )

		CASE tcValueType = 'N'
			luPropValue	= CAST( luPropValue AS DOUBLE )

		CASE tcValueType = 'T'
			luPropValue	= CAST( luPropValue AS DATETIME )

		CASE tcValueType = 'D'
			luPropValue	= CAST( luPropValue AS DATE )

		CASE tcValueType = 'E'
			luPropValue	= EVALUATE( luPropValue )

		OTHERWISE && Asumo 'C' para lo demás
			luPropValue	= luPropValue

		ENDCASE

		RETURN luPropValue
	ENDFUNC


	*******************************************************************************************************************
	PROCEDURE get_ListNamesWithValuesFrom_InLine_MetadataTag
		*-- OBTENGO EL ARRAY DE DATOS Y VALORES DE LA LINEA DE METADATOS INDICADA
		*-- NOTA: Los valores NO PUEDEN contener comillas dobles en su valor, ya que generaría un error al parsearlos.
		*-- Ejemplo:
		*< FileMetadata: Type="V" Cpid="1252" Timestamp="1131901580" ID="1129207528" ObjRev="544" />
		*< OLE: Nombre="frm_form.Pageframe1.Page1.Cnt_controles_h.Olecontrol1" Parent="frm_form.Pageframe1.Page1.Cnt_controles_h" ObjName="Olecontrol1" Checksum="1685567300" Value="0M8R4KGxGuEAAAAAAAAAAAAAAAAAAAAAPg...ADAP7AAAA==" />
		*--------------------------------------------------------------------------------------------------------------
		* PARÁMETROS:				!=Obligatorio, ?=Opcional, @=Pasar por referencia, v=Pasar por valor (IN/OUT)
		* tcLineWithMetadata		(@! IN    ) Línea con metadatos y un tag de metadatos
		* taPropsAndValues			(@!    OUT) Array a devolver con las propiedades y valores encontrados
		* tnPropsAndValues_Count	(@!    OUT) Cantidad de propiedades encontradas
		* tcLeftTag					(v! IN    ) TAG de inicio de los metadatos
		* tcRightTag				(v! IN    ) TAG de fin de los metadatos
		*--------------------------------------------------------------------------------------------------------------
		LPARAMETERS tcLineWithMetadata, taPropsAndValues, tnPropsAndValues_Count, tcLeftTag, tcRightTag
		EXTERNAL ARRAY taPropsAndValues

		LOCAL lcMetadatos, I, X, lnEqualSigns, lcNextVar, lcStr, lcVirtualMeta, lnPos1, lnPos2, lnLastPos, lnCantComillas
		STORE '' TO lcVirtualMeta
		STORE 0 TO lnPos1, lnPos2, lnLastPos, tnPropsAndValues_Count, I, X

		lcMetadatos		= ALLTRIM( STREXTRACT( tcLineWithMetadata, tcLeftTag, tcRightTag, 1, 1) )
		lnCantComillas	= OCCURS( '"', lcMetadatos )

		IF lnCantComillas % 2 <> 0	&& Valido que las comillas "" sean pares
			ERROR "Error de datos: No se puede parsear porque las comillas no son pares en la línea [" + lcMetadatos + "]"
		ENDIF

		lnLastPos	= 1
		DIMENSION taPropsAndValues( lnCantComillas / 2, 2 )

		*-------------------------------------------------------------------------------------
		* IMPORTANTE!!
		* ------------
		* SI SE SEPARAN LAS IGUALDADES CON ESPACIOS, ÉSTAS DEJAN DE RECONOCERSE!!  (prop = "valor" en vez de prop="valor")
		* TENER EN CUENTA AL GENERAR EL TEXTO O AL MODIFICARLO MANUALMENTE AL MERGEAR
		*-------------------------------------------------------------------------------------
		FOR I = 1 TO lnCantComillas STEP 2
			X	= X + 1

			*  Type="V" Cpid="1252"
			*       ^ ^					=> Posiciones del par de comillas dobles
			lnPos1	= AT( '"', lcMetadatos, I )
			lnPos2	= AT( '"', lcMetadatos, I + 1 )

			*  Type="V" Cpid="1252"
			*          ^     ^    ^			=> LastPos, lnPos1 y lnPos2
			taPropsAndValues(X,1)	= ALLTRIM( GETWORDNUM( SUBSTR( lcMetadatos, lnLastPos, lnPos1 - lnLastPos ), 1, '=' ) )
			taPropsAndValues(X,2)	= SUBSTR( lcMetadatos, lnPos1 + 1, lnPos2 - lnPos1 - 1 )

			lnLastPos = lnPos2 + 1
		ENDFOR

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeExclusion
		LPARAMETERS taCodeLines, tnCodeLines, ta_ID_Bloques, taBloquesExclusion, tnBloquesExclusion
		* LOS BLOQUES DE EXCLUSIÓN SON AQUELLOS QUE TIENEN TEXT/ENDTEXT OF #IF .F./#ENDIF Y SE USAN PARA NO BUSCAR
		* INSTRUCCIONES COMO "DEFINE CLASS" O "PROCEDURE" EN LOS MISMOS.
		*--------------------------------------------------------------------------------------------------------------
		* PARÁMETROS:				!=Obligatorio, ?=Opcional, @=Pasar por referencia, v=Pasar por valor (IN/OUT)
		* taCodeLines				(!@ IN    ) El array con las líneas del código de texto donde buscar
		* tnCodeLines				(?@ IN    ) Cantidad de líneas de código
		* ta_ID_Bloques				(?@ IN    ) Array de pares de identificadores (2 cols). Ej: '#IF .F.','#ENDI' ; 'TEXT','ENDTEXT' ; etc
		* taBloquesExclusion		(?@    OUT) Array con las posiciones de los bloques (2 cols). Ej: 3,14 ; 23,58 ; etc
		* tnBloquesExclusion		(?@    OUT) Cantidad de bloques de exclusión
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY ta_ID_Bloques, taBloquesExclusion

		TRY
			LOCAL lnBloques, I, X, lnPrimerID, lnLen_IDFinBQ
			DIMENSION taBloquesExclusion(1,2)
			STORE 0 TO tnBloquesExclusion, lnPrimerID, I, X, lnLen_IDFinBQ

			IF tnCodeLines > 1
				IF EMPTY(ta_ID_Bloques)
					DIMENSION ta_ID_Bloques(2,2)
					ta_ID_Bloques(1,1)	= '#IF .F.'
					ta_ID_Bloques(1,2)	= '#ENDI'
					ta_ID_Bloques(2,1)	= C_TEXT
					ta_ID_Bloques(2,2)	= C_ENDTEXT
				ENDIF

				*-- Búsqueda del ID de inicio de bloque
				FOR I = 1 TO tnCodeLines
					lcLine = LTRIM( STRTRAN( STRTRAN( CHRTRAN( taCodeLines(I), CHR(9), ' ' ), '  ', ' ' ), '  ', ' ' ) )	&& Reduzco los espacios. Ej: '#IF  .F. && cmt' ==> '#IF .F.&&cmt'

					IF THIS.lineIsOnlyCommentAndNoMetadata( @lcLine )
						LOOP
					ENDIF

					lnPrimerID	= ASCAN( ta_ID_Bloques, lcLine, 1, 0, 1, 1+8 )

					IF lnPrimerID > 0	&& Se ha identificado un ID de bloque excluyente
						tnBloquesExclusion		= tnBloquesExclusion + 1
						lnLen_IDFinBQ			= LEN( ta_ID_Bloques(lnPrimerID,2) )
						DIMENSION taBloquesExclusion(tnBloquesExclusion,2)
						taBloquesExclusion(tnBloquesExclusion,1)	= I

						* Búsqueda del ID de fin de bloque
						FOR I = I + 1 TO tnCodeLines
							lcLine = LTRIM( STRTRAN( STRTRAN( CHRTRAN( taCodeLines(I), CHR(9), ' ' ), '  ', ' ' ), '  ', ' ' ) )	&& Reduzco los espacios. Ej: '#IF  .F. && cmt' ==> '#IF .F.&&cmt'

							IF THIS.lineIsOnlyCommentAndNoMetadata( @lcLine )
								LOOP
							ENDIF

							IF LEFT( lcLine, lnLen_IDFinBQ ) == ta_ID_Bloques(lnPrimerID,2)	&& Fin de bloque encontrado (#ENDI, ENDTEXT, etc)
								taBloquesExclusion(tnBloquesExclusion,2)	= I
								EXIT
							ENDIF
						ENDFOR

						*-- Validación
						IF EMPTY(taBloquesExclusion(tnBloquesExclusion,2))
							ERROR 'No se ha encontrado el marcador de fin [' + ta_ID_Bloques(lnPrimerID,2) ;
								+ '] que cierra al marcador de inicio [' + ta_ID_Bloques(lnPrimerID,1) ;
								+ '] de la línea ' + TRANSFORM(taBloquesExclusion(tnBloquesExclusion,1))
						ENDIF
					ENDIF
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_FoxBin2Prg
		*------------------------------------------------------
		*-- Analiza el bloque <FOXBIN2PRG>
		*------------------------------------------------------
		LPARAMETERS toModulo, tcLine, taCodeLines, I, tnCodeLines

		LOCAL llBloqueEncontrado, laPropsAndValues(1,2), lnPropsAndValues_Count

		IF LEFT( tcLine + ' ', LEN(C_FB2PRG_META_I) + 1 ) == C_FB2PRG_META_I + ' '
			llBloqueEncontrado	= .T.

			*-- Metadatos del módulo
			THIS.get_ListNamesWithValuesFrom_InLine_MetadataTag( @tcLine, @laPropsAndValues, @lnPropsAndValues_Count, C_FB2PRG_META_I, C_FB2PRG_META_F )
			toModulo._Version		= THIS.get_ValueByName_FromListNamesWithValues( 'Version', 'N', @laPropsAndValues )
			toModulo._SourceFile	= THIS.get_ValueByName_FromListNamesWithValues( 'SourceFile', 'C', @laPropsAndValues )
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createProject

		CREATE TABLE (THIS.c_OutputFile) ;
			( NAME			M ;
			, TYPE			C(1) ;
			, ID			N(10) ;
			, TIMESTAMP		N(10) ;
			, OUTFILE		M ;
			, HOMEDIR		M ;
			, EXCLUDE		L ;
			, MAINPROG		L ;
			, SAVECODE		L ;
			, DEBUG			L ;
			, ENCRYPT		L ;
			, NOLOGO		L ;
			, CMNTSTYLE		N(1) ;
			, OBJREV		N(5) ;
			, DEVINFO		M ;
			, SYMBOLS		M ;
			, OBJECT		M ;
			, CKVAL			N(6) ;
			, CPID			N(5) ;
			, OSTYPE		C(4) ;
			, OSCREATOR		C(4) ;
			, COMMENTS		M ;
			, RESERVED1		M ;
			, RESERVED2		M ;
			, SCCDATA		M ;
			, LOCAL			L ;
			, KEY			C(32) ;
			, USER			M )

		USE (THIS.c_OutputFile) ALIAS TABLABIN AGAIN SHARED

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createProject_RecordHeader
		LPARAMETERS toProject

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		INSERT INTO TABLABIN ;
			( NAME ;
			, TYPE ;
			, TIMESTAMP ;
			, OUTFILE ;
			, HOMEDIR ;
			, SAVECODE ;
			, DEBUG ;
			, ENCRYPT ;
			, NOLOGO ;
			, CMNTSTYLE ;
			, OBJREV ;
			, DEVINFO ;
			, OBJECT ;
			, RESERVED1 ;
			, RESERVED2 ;
			, LOCAL ;
			, KEY ) ;
			VALUES ;
			( UPPER(THIS.c_OutputFile) ;
			, 'H' ;
			, 0 ;
			, '<Source>' + CHR(0) ;
			, toProject._HomeDir + CHR(0) ;
			, toProject._SaveCode ;
			, toProject._Debug ;
			, toProject._Encrypted ;
			, toProject._NoLogo ;
			, toProject._CmntStyle ;
			, 260 ;
			, toProject.getRowDeviceInfo() ;
			, toProject._HomeDir + CHR(0) ;
			, UPPER(THIS.c_OutputFile) ;
			, toProject._ServerHead.getRowServerInfo() ;
			, .T. ;
			, UPPER( JUSTSTEM( THIS.c_OutputFile) ) )

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createClasslib

		CREATE TABLE (THIS.c_OutputFile) ;
			( PLATFORM		C(8) ;
			, UNIQUEID		C(10) ;
			, TIMESTAMP		N(10) ;
			, CLASS			M ;
			, CLASSLOC		M ;
			, BASECLASS		M ;
			, OBJNAME		M ;
			, PARENT		M ;
			, PROPERTIES	M ;
			, PROTECTED		M ;
			, METHODS		M ;
			, OBJCODE		M NOCPTRANS ;
			, OLE			M ;
			, OLE2			M ;
			, RESERVED1		M ;
			, RESERVED2		M ;
			, RESERVED3		M ;
			, RESERVED4		M ;
			, RESERVED5		M ;
			, RESERVED6		M ;
			, RESERVED7		M ;
			, RESERVED8		M ;
			, USER			M )

		USE (THIS.c_OutputFile) ALIAS TABLABIN AGAIN SHARED

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createClasslib_RecordHeader

		INSERT INTO TABLABIN ;
			( PLATFORM ;
			, UNIQUEID ;
			, RESERVED1 ) ;
			VALUES ;
			( 'COMMENT' ;
			, 'Class' ;
			, 'VERSION =   3.00' )

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createForm

		CREATE TABLE (THIS.c_OutputFile) ;
			( PLATFORM		C(8) ;
			, UNIQUEID		C(10) ;
			, TIMESTAMP		N(10) ;
			, CLASS			M ;
			, CLASSLOC		M ;
			, BASECLASS		M ;
			, OBJNAME		M ;
			, PARENT		M ;
			, PROPERTIES	M ;
			, PROTECTED		M ;
			, METHODS		M ;
			, OBJCODE		M NOCPTRANS ;
			, OLE			M ;
			, OLE2			M ;
			, RESERVED1		M ;
			, RESERVED2		M ;
			, RESERVED3		M ;
			, RESERVED4		M ;
			, RESERVED5		M ;
			, RESERVED6		M ;
			, RESERVED7		M ;
			, RESERVED8		M ;
			, USER			M )

		USE (THIS.c_OutputFile) ALIAS TABLABIN AGAIN SHARED

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createForm_RecordHeader

		INSERT INTO TABLABIN ;
			( PLATFORM ;
			, UNIQUEID ;
			, RESERVED1 ) ;
			VALUES ;
			( 'COMMENT' ;
			, 'Screen' ;
			, 'VERSION =   3.00' )

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createReport

		CREATE TABLE (THIS.c_OutputFile) ;
			( 'PLATFORM'	C(8) ;
			, 'UNIQUEID'	C(10) ;
			, 'TIMESTAMP'	N(10) ;
			, 'OBJTYPE'		N(2) ;
			, 'OBJCODE'		N(3) ;
			, 'NAME'		M ;
			, 'EXPR'		M ;
			, 'VPOS'		N(9,3) ;
			, 'HPOS'		N(9,3) ;
			, 'HEIGHT'		N(9,3) ;
			, 'WIDTH'		N(9,3) ;
			, 'STYLE'		M ;
			, 'PICTURE'		M ;
			, 'ORDER'		M NOCPTRANS ;
			, 'UNIQUE'		L ;
			, 'COMMENT'		M ;
			, 'ENVIRON'		L ;
			, 'BOXCHAR'		C(1) ;
			, 'FILLCHAR'	C(1) ;
			, 'TAG'			M ;
			, 'TAG2'		M NOCPTRANS ;
			, 'PENRED'		N(5) ;
			, 'PENGREEN'	N(5) ;
			, 'PENBLUE'		N(5) ;
			, 'FILLRED'		N(5) ;
			, 'FILLGREEN'	N(5) ;
			, 'FILLBLUE'	N(5) ;
			, 'PENSIZE'		N(5) ;
			, 'PENPAT'		N(5) ;
			, 'FILLPAT'		N(5) ;
			, 'FONTFACE'	M ;
			, 'FONTSTYLE'	N(3) ;
			, 'FONTSIZE'	N(3) ;
			, 'MODE'		N(3) ;
			, 'RULER'		N(1) ;
			, 'RULERLINES'	N(1) ;
			, 'GRID'		L ;
			, 'GRIDV'		N(2) ;
			, 'GRIDH'		N(2) ;
			, 'FLOAT'		L ;
			, 'STRETCH'		L ;
			, 'STRETCHTOP'	L ;
			, 'TOP'			L ;
			, 'BOTTOM'		L ;
			, 'SUPTYPE'		N(1) ;
			, 'SUPREST'		N(1) ;
			, 'NOREPEAT'	L ;
			, 'RESETRPT'	N(2) ;
			, 'PAGEBREAK'	L ;
			, 'COLBREAK'	L ;
			, 'RESETPAGE'	L ;
			, 'GENERAL'		N(3) ;
			, 'SPACING'		N(3) ;
			, 'DOUBLE'		L ;
			, 'SWAPHEADER'	L ;
			, 'SWAPFOOTER'	L ;
			, 'EJECTBEFOR'	L ;
			, 'EJECTAFTER'	L ;
			, 'PLAIN'		L ;
			, 'SUMMARY'		L ;
			, 'ADDALIAS'	L ;
			, 'OFFSET'		N(3) ;
			, 'TOPMARGIN'	N(3) ;
			, 'BOTMARGIN'	N(3) ;
			, 'TOTALTYPE'	N(2) ;
			, 'RESETTOTAL'	N(2) ;
			, 'RESOID'		N(3) ;
			, 'CURPOS'		L ;
			, 'SUPALWAYS'	L ;
			, 'SUPOVFLOW'	L ;
			, 'SUPRPCOL'	N(1) ;
			, 'SUPGROUP'	N(2) ;
			, 'SUPVALCHNG'	L ;
			, 'SUPEXPR'		M ;
			, 'USER'		M )

		USE (THIS.c_OutputFile) ALIAS TABLABIN AGAIN SHARED

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE emptyRecord
		LOCAL loReg
		SCATTER MEMO BLANK NAME loReg
		RETURN loReg
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toModulo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE classProps2Memo
		*-- ARMA EL MEMO DE PROPERTIES CON LAS PROPIEDADES Y SUS VALORES
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		*-- ESTRUCTURA A ANALIZAR: Propiedades normales, con CR codificado (<fb2p_value>) y con CR+LF (<fb2p_value>)
		#IF .F.
			HEIGHT =   2.73
			NAME = "c1"
			prop1 = .F.		&& Mi prop 1
			prop_especial_cr = <fb2p_value>Este es el valor 1&#10;Este el 2&#10;Y Este bajo Shift_Enter el 3</fb2p_value>
			prop_especial_crlf = <fb2p_value>
			Este es el valor 1
			Este el 2
			Y Este bajo Shift_Enter el 3
			</fb2p_value>
			WIDTH =  27.40
			_MEMBERDATA = <VFPData>
			<memberdata NAME="mimetodo" DISPLAY="miMetodo"/>
			<memberdata NAME="mimetodo2" DISPLAY="miMetodo2"/>
			</VFPData>		&& XML Metadata for customizable properties
		#ENDIF
		*-- Fin: ESTRUCTURA A ANALIZAR:

		TRY
			LOCAL lcDefinedPAM, lnPos, lnPos2, laProps(1,2), lcLine, lcPropName, lcValue, I, lcAsignacion, lcMemo ;
				, laPropsAndValues(1,2), lnPropsAndValues_Count
			lcMemo	= ''

			IF toClase._Prop_Count > 0
				DIMENSION laPropsAndValues( toClase._Prop_Count, 3 )
				ACOPY( toClase._Props, laPropsAndValues )
				lnPropsAndValues_Count	= toClase._Prop_Count

				*-- REORDENO LAS PROPIEDADES
				THIS.sortPropsAndValues( @laPropsAndValues, lnPropsAndValues_Count, 2 )


				*-- ARMO EL MEMO A DEVOLVER
				FOR I = 1 TO lnPropsAndValues_Count
					lcMemo	= lcMemo + laPropsAndValues(I,1) + ' = ' + laPropsAndValues(I,2) + CR_LF
				ENDFOR

			ENDIF && laProps > 0

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE objectProps2Memo
		*-- ARMA EL MEMO DE PROPERTIES CON LAS PROPIEDADES Y SUS VALORES
		LPARAMETERS toObjeto, toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I, laPropsAndValues(1,2), lcPropName, lcValue
		lcMemo	= ''

		IF toObjeto._Prop_Count > 0
			DIMENSION laPropsAndValues( toObjeto._Prop_Count, 2 )
			ACOPY( toObjeto._Props, laPropsAndValues )


			*-- REORDENO LAS PROPIEDADES
			THIS.sortPropsAndValues( @laPropsAndValues, toObjeto._Prop_Count, 2 )


			*-- ARMO EL MEMO A DEVOLVER
			FOR I = 1 TO toObjeto._Prop_Count
				lcMemo	= lcMemo + laPropsAndValues(I,1) + ' = ' + laPropsAndValues(I,2) + CR_LF
			ENDFOR

		ENDIF

		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE classMethods2Memo
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I, X, lcNombreObjeto ;
			, loProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		lcMemo	= ''

		*-- Recorrer los métodos
		FOR I = 1 TO toClase._Procedure_Count
			loProcedure	= NULL
			loProcedure	= toClase._Procedures(I)

			IF '.' $ loProcedure._Nombre
				*-- cboNombre.InteractiveChange ==> No debe acortarse por ser método modificado de combobox heredado de la clase
				*-- cntDatos.txtEdad.Valid		==> Debe acortarse si cntDatos es un objeto existente
				lcNombreObjeto	= LEFT( loProcedure._Nombre, AT('.', loProcedure._Nombre) - 1 )

				IF THIS.buscarObjetoDelMetodoPorNombre( lcNombreObjeto, toClase ) = 0
					TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
						<<C_PROCEDURE>> <<loProcedure._Nombre>>
					ENDTEXT
				ELSE
					TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
						<<C_PROCEDURE>> <<SUBSTR( loProcedure._Nombre, AT('.', loProcedure._Nombre) + 1 )>>
					ENDTEXT
				ENDIF
			ELSE
				TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					<<C_PROCEDURE>> <<loProcedure._Nombre>>
				ENDTEXT
			ENDIF

			*-- Incluir las líneas del método
			FOR X = 1 TO loProcedure._ProcLine_Count
				TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<loProcedure._ProcLines(X)>>
				ENDTEXT
			ENDFOR

			TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_ENDPROC>>

			ENDTEXT
		ENDFOR

		loProcedure	= NULL
		RELEASE loProcedure
		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE objectMethods2Memo
		LPARAMETERS toObjeto, toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I, X, lcNombreObjeto ;
			, loProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		lcMemo	= ''

		*-- Recorrer los métodos
		FOR I = 1 TO toObjeto._Procedure_Count
			loProcedure	= NULL
			loProcedure	= toObjeto._Procedures(I)

			TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<<C_PROCEDURE>> <<loProcedure._Nombre>>
			ENDTEXT

			*-- Incluir las líneas del método
			FOR X = 1 TO loProcedure._ProcLine_Count
				TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<loProcedure._ProcLines(X)>>
				ENDTEXT
			ENDFOR

			TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_ENDPROC>>

			ENDTEXT
		ENDFOR

		loProcedure	= NULL
		RELEASE loProcedure
		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE getClassPropertyComment
		*-- Devuelve el comentario (columna 2 del array toClase._Props) de la propiedad indicada,
		*-- buscándola en la columna 2 por su nombre.
		LPARAMETERS tcPropName AS STRING, toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL I, lcComentario
		lcComentario	= ''

		FOR I = 1 TO toClase._Prop_Count
			IF RTRIM( GETWORDNUM( toClase._Props(I,1), 1, '=' ) ) == tcPropName
				lcComentario	= toClase._Props( I, 2 )
				EXIT
			ENDIF
		ENDFOR

		RETURN lcComentario
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE getClassMethodComment
		LPARAMETERS tcMethodName AS STRING, toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL I, lcComentario ;
			, loProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		lcComentario	= ''

		FOR I = 1 TO toClase._Procedure_Count
			loProcedure	= toClase._Procedures(I)

			IF loProcedure._Nombre == tcMethodName
				lcComentario	= loProcedure._Comentario
				EXIT
			ENDIF
		ENDFOR

		RETURN lcComentario
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE getTextFrom_BIN_FileStructure
		TRY
			LOCAL lcStructure, lnSelect
			lnSelect	= SELECT()
			SELECT 0
			USE (THIS.c_InputFile) AGAIN SHARED ALIAS _TABLABIN
			COPY STRUCTURE EXTENDED TO ( FORCEPATH( '_FRX_STRUC.DBF', ADDBS( SYS(2023) ) ) )
			**** CONTINUAR SI ES NECESARIO - SIN USO POR AHORA

		CATCH TO loEx
			THROW

		FINALLY
			USE IN (SELECT("_TABLABIN"))
			SELECT (lnSelect)
		ENDTRY

		RETURN lcStructure
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE defined_PAM2Memo
		LPARAMETERS toClase
		RETURN toClase._Defined_PAM
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE strip_Dimensions
		LPARAMETERS tcSeparatedCommaVars
		LOCAL lnPos1, lnPos2, I

		FOR I = OCCURS( '[', tcSeparatedCommaVars ) TO 1 STEP -1
			lnPos1	= AT( '[', tcSeparatedCommaVars, I )
			lnPos2	= AT( ']', tcSeparatedCommaVars, I )
			tcSeparatedCommaVars	= STUFF( tcSeparatedCommaVars, lnPos1, lnPos2 - lnPos1 + 1, '' )
		ENDFOR
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE hiddenAndProtected_PAM
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I, lcPAM, lcComentario
		lcMemo	= ''

		THIS.Evaluate_PAM( @lcMemo, toClase._ProtectedProps, 'property', 'protected' )
		THIS.Evaluate_PAM( @lcMemo, toClase._HiddenProps, 'property', 'hidden' )
		THIS.Evaluate_PAM( @lcMemo, toClase._ProtectedMethods, 'method', 'protected' )
		THIS.Evaluate_PAM( @lcMemo, toClase._HiddenMethods, 'method', 'hidden' )

		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Evaluate_PAM
		LPARAMETERS tcMemo AS STRING, tcPAM AS STRING, tcPAM_Type AS STRING, tcPAM_Visibility AS STRING

		LOCAL lcPAM, I

		FOR I = 1 TO OCCURS( ',', tcPAM + ',' )
			lcPAM	= ALLTRIM( GETWORDNUM( tcPAM, I, ',' ) )

			IF NOT EMPTY(lcPAM)
				IF EVL(tcPAM_Visibility, 'normal') == 'hidden'
					lcPAM	= lcPAM + '^'
				ENDIF

				TEXT TO tcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					<<lcPAM>>

				ENDTEXT
			ENDIF
		ENDFOR
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE insert_Object
		LPARAMETERS toClase, toObjeto

		IF NOT THIS.l_Test
			*-- Inserto el objeto
			INSERT INTO TABLABIN ;
				( PLATFORM ;
				, UNIQUEID ;
				, TIMESTAMP ;
				, CLASS ;
				, CLASSLOC ;
				, BASECLASS ;
				, OBJNAME ;
				, PARENT ;
				, PROPERTIES ;
				, PROTECTED ;
				, METHODS ;
				, OLE ;
				, OLE2 ;
				, RESERVED1 ;
				, RESERVED2 ;
				, RESERVED3 ;
				, RESERVED4 ;
				, RESERVED5 ;
				, RESERVED6 ;
				, RESERVED7 ;
				, RESERVED8 ;
				, USER) ;
				VALUES ;
				( 'WINDOWS' ;
				, toObjeto._UniqueID ;
				, toObjeto._TimeStamp ;
				, toObjeto._Class ;
				, toObjeto._ClassLib ;
				, toObjeto._BaseClass ;
				, toObjeto._ObjName ;
				, toObjeto._Parent ;
				, THIS.objectProps2Memo( toObjeto, toClase ) ;
				, '' ;
				, THIS.objectMethods2Memo( toObjeto, toClase ) ;
				, toObjeto._Ole ;
				, toObjeto._Ole2 ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, '' ;
				, toObjeto._User )
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE insert_AllObjects
		*-- Recorro primero los objetos con ZOrder definido, y luego los demás
		*-- NOTA: Como consecuencia de una integración de código, puede que se hayan agregado objetos nuevos (desconocidos),
		*--	      pero todo lo demás tiene un ZOrder definido, que es el número de registro original * 100.
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL N, X, lcObjName, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'

			IF toClase._AddObject_Count > 0
				N	= 0

				*-- Armo array con el orden Z de los objetos
				DIMENSION laObjNames( toClase._AddObject_Count, 2 )

				FOR X = 1 TO toClase._AddObject_Count
					loObjeto			= toClase._AddObjects( X )
					laObjNames( X, 1 )	= loObjeto._Nombre
					laObjNames( X, 2 )	= loObjeto._ZOrder
				ENDFOR

				ASORT( laObjNames, 2, -1, 0, 1 )


				*-- Escribo los objetos en el orden Z
				FOR X = 1 TO toClase._AddObject_Count
					lcObjName	= laObjNames( X, 1 )

					FOR EACH loObjeto IN toClase._AddObjects FOXOBJECT
						*-- Verifico que sea el objeto que corresponde
						IF loObjeto._WriteOrder = 0 AND loObjeto._Nombre == lcObjName
							N	= N + 1
							loObjeto._WriteOrder	= N
							THIS.insert_Object( toClase, loObjeto )
							EXIT
						ENDIF
					ENDFOR
				ENDFOR


				*-- Recorro los objetos Desconocidos
				FOR EACH loObjeto IN toClase._AddObjects FOXOBJECT
					IF loObjeto._WriteOrder = 0
						THIS.insert_Object( toClase, loObjeto )
					ENDIF
				ENDFOR

			ENDIF	&& toClase._AddObject_Count > 0

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE set_Line
		LPARAMETERS tcLine, taCodeLines, I
		tcLine 	= LTRIM( taCodeLines(I), 0, ' ', CHR(9) )
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarLineasDeProcedure
		LPARAMETERS toClase, toObjeto, tcLine, taCodeLines, I, tnCodeLines, tcProcedureAbierto, tc_Comentario ;
			, taBloquesExclusion, tnBloquesExclusion
		EXTERNAL ARRAY taCodeLines

		#IF .F.
			LOCAL toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llEsProcedureDeClase, loProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'

			IF '.' $ tcProcedureAbierto AND VARTYPE(toObjeto) = 'O' AND toObjeto._Procedure_Count > 0
				loProcedure	= toObjeto._Procedures(toObjeto._Procedure_Count)
			ELSE
				llEsProcedureDeClase	= .T.
				loProcedure	= toClase._Procedures(toClase._Procedure_Count)
			ENDIF

			WITH THIS
				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					IF NOT .lineaExcluida( I, tnBloquesExclusion, @taBloquesExclusion ) ;
							AND NOT .lineIsOnlyCommentAndNoMetadata( @tcLine, @tc_Comentario )

						DO CASE
						CASE LEFT( tcLine, 8 ) + ' ' == C_ENDPROC + ' ' && Fin del PROCEDURE
							tcProcedureAbierto	= ''
							EXIT

						CASE LEFT( tcLine + ' ', 10 ) == C_ENDDEFINE + ' '	&& Fin de bloque (ENDDEFINE) encontrado
							IF llEsProcedureDeClase
								ERROR 'Error de anidamiento de estructuras. Se esperaba ENDPROC y se encontró ENDDEFINE en la clase ' ;
									+ toClase._Nombre + ' (' + loProcedure._Nombre + ')' ;
									+ ', línea ' + TRANSFORM(I) + ' del archivo ' + THIS.c_InputFile
							ELSE
								ERROR 'Error de anidamiento de estructuras. Se esperaba ENDPROC y se encontró ENDDEFINE en la clase ' ;
									+ toClase._Nombre + ' (' + toObjeto._Nombre + '.' + loProcedure._Nombre + ')' ;
									+ ', línea ' + TRANSFORM(I) + ' del archivo ' + THIS.c_InputFile
							ENDIF
						ENDCASE
					ENDIF

					*-- Quito 2 TABS de la izquierda (si se puede y si el integrador/desarrollador no la lió quitándolos)
					DO CASE
					CASE LEFT( taCodeLines(I),2 ) = C_TAB + C_TAB
						loProcedure.add_Line( SUBSTR(taCodeLines(I), 3) )
					CASE LEFT( taCodeLines(I),1 ) = C_TAB
						loProcedure.add_Line( SUBSTR(taCodeLines(I), 2) )
					OTHERWISE
						loProcedure.add_Line( taCodeLines(I) )
					ENDCASE
				ENDFOR
			ENDWITH && THIS

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ADD_OBJECT
		LPARAMETERS toModulo, toClase, tcLine, I, taCodeLines, tnCodeLines

		EXTERNAL ARRAY taCodeLines

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
			LOCAL toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado

			IF LEFT( tcLine, 11 ) == 'ADD OBJECT '
				*-- Estructura a reconocer: ADD OBJECT 'frm_a.Check1' AS check [WITH]
				llBloqueEncontrado	= .T.
				LOCAL laPropsAndValues(1,2), lnPropsAndValues_Count, Z, lcProp, lcValue
				tcLine		= CHRTRAN( tcLine, ['], ["] )

				IF EMPTY(toClase._Fin_Cab)
					toClase._Fin_Cab	= I-1
					toClase._Ini_Cuerpo	= I
				ENDIF

				toObjeto			= NULL
				toObjeto			= CREATEOBJECT('CL_OBJETO')
				toClase.add_Object( toObjeto )
				toObjeto._Nombre	= ALLTRIM( CHRTRAN( STREXTRACT(tcLine, 'ADD OBJECT ', ' AS ', 1, 1), ['"], [] ) )

				IF '.' $ toObjeto._Nombre
					toObjeto._ObjName	= JUSTEXT( toObjeto._Nombre )
					toObjeto._Parent	= toClase._ObjName + '.' + JUSTSTEM( toObjeto._Nombre )
				ELSE
					toObjeto._ObjName	= toObjeto._Nombre
					toObjeto._Parent	= toClase._ObjName
				ENDIF

				toObjeto._Nombre	= toObjeto._Parent + '.' + toObjeto._ObjName
				toObjeto._Class		= ALLTRIM( STREXTRACT(tcLine + ' WITH', ' AS ', ' WITH', 1, 1) )


				*-- Propiedades del ADD OBJECT
				WITH THIS
					FOR I = I + 1 TO tnCodeLines
						.set_Line( @tcLine, @taCodeLines, I )

						IF LEFT( tcLine, C_LEN_END_OBJECT_I) == C_END_OBJECT_I && Fin del ADD OBJECT y METADATOS
							*< END OBJECT: baseclass = "olecontrol" Uniqueid = "_3X50L3I7V" OLEObject = "C:\WINDOWS\system32\FOXTLIB.OCX" checksum = "4101493921" />

							.get_ListNamesWithValuesFrom_InLine_MetadataTag( @tcLine, @laPropsAndValues, @lnPropsAndValues_Count ;
								, C_END_OBJECT_I, C_END_OBJECT_F )

							toObjeto._ClassLib			= .get_ValueByName_FromListNamesWithValues( 'ClassLib', 'C', @laPropsAndValues )
							toObjeto._BaseClass			= .get_ValueByName_FromListNamesWithValues( 'BaseClass', 'C', @laPropsAndValues )
							toObjeto._UniqueID			= .get_ValueByName_FromListNamesWithValues( 'UniqueID', 'C', @laPropsAndValues )
							toObjeto._Ole2				= .get_ValueByName_FromListNamesWithValues( 'OLEObject', 'C', @laPropsAndValues )
							toObjeto._ZOrder			= .get_ValueByName_FromListNamesWithValues( 'ZOrder', 'I', @laPropsAndValues )
							toObjeto._TimeStamp			= INT( .RowTimeStamp( .get_ValueByName_FromListNamesWithValues( 'TimeStamp', 'T', @laPropsAndValues ) ) )

							IF NOT EMPTY( toObjeto._Ole2 )	&& Le agrego "OLEObject = " delante
								toObjeto._Ole2		= 'OLEObject = ' + toObjeto._Ole2 + CR_LF
							ENDIF

							*-- Ubico el objeto ole por su nombre (parent+objname), que no se repite.
							IF toModulo.existeObjetoOLE( toObjeto._Nombre, @Z )
								toObjeto._Ole	= toModulo._Ole_Objs(Z)._Value
							ENDIF

							EXIT
						ENDIF

						IF RIGHT(tcLine, 3) == ', ;'	&& VALOR INTERMEDIO CON ", ;"
							*toObjeto.add_Property( .desnormalizarAsignacion( LEFT(tcLine, LEN(tcLine) - 3) ) )
							.get_SeparatedPropAndValue( LEFT(tcLine, LEN(tcLine) - 3), @lcProp, @lcValue )
							toObjeto.add_Property( @lcProp, @lcValue )
						ELSE	&& VALOR FINAL SIN ", ;" (JUSTO ANTES DEL <END OBJECT>)
							*toObjeto.add_Property( .desnormalizarAsignacion( RTRIM(tcLine) ) )
							.get_SeparatedPropAndValue( RTRIM(tcLine), @lcProp, @lcValue )
							toObjeto.add_Property( @lcProp, @lcValue )
						ENDIF

					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_DEFINED_PAM
		*-- ESTRUCTURA A ANALIZAR:
		*<DefinedPropArrayMethod>
		*m: *metodovacio_con_comentarios		&& Este método no tiene código, pero tiene comentarios. A ver que pasa!
		*m: *mimetodo		&& Mi metodo
		*p: prop1		&& Mi prop 1
		*p: prop_especial_cr		&&
		*a: ^array_1_d[1,0]		&& Array 1 dimensión (1)
		*a: ^array_2_d[1,2]		&& Array una dimension (1,2)
		*p: _memberdata		&& XML Metadata for customizable properties
		*</DefinedPropArrayMethod>
		LPARAMETERS toClase, tcLine, taCodeLines, tnCodeLines, I

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcDefinedPAM, lnPos, lnPos2, lcPAM_Name

			IF LEFT( tcLine, C_LEN_DEFINED_PAM_I) == C_DEFINED_PAM_I
				llBloqueEncontrado	= .T.
				lcDefinedPAM		= ''

				WITH THIS
					FOR I = I + 1 TO tnCodeLines
						.set_Line( @tcLine, @taCodeLines, I )

						DO CASE
						CASE LEFT( tcLine, C_LEN_DEFINED_PAM_F ) == C_DEFINED_PAM_F
							I = I + 1
							EXIT

						OTHERWISE
							lnPos			= AT( ' ', tcLine, 1 )
							lnPos2			= AT( '&'+'&', tcLine )

							IF lnPos2 > 0
								*-- Con comentarios
								lcPAM_Name		= RTRIM( SUBSTR( tcLine, lnPos+1, lnPos2 - lnPos - 1 ), 0, ' ', CHR(9) )
								lcDefinedPAM	= lcDefinedPAM ;
									+ lcPAM_Name + ' ' + SUBSTR( tcLine, lnPos2 + 3 ) ;
									+ CR_LF
							ELSE
								*-- Sin comentarios
								lcPAM_Name		= RTRIM( SUBSTR( tcLine, lnPos+1 ), 0, ' ', CHR(9) )
								lcDefinedPAM	= lcDefinedPAM ;
									+ lcPAM_Name + IIF(ISALPHA(lcPAM_Name), '', ' ') ;
									+ CR_LF
							ENDIF
						ENDCASE
					ENDFOR
				ENDWITH && THIS

				toClase._Defined_PAM	= lcDefinedPAM
				I = I - 1
			ENDIF

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_DEFINE_CLASS
		LPARAMETERS toModulo, toClase, tcLine, taCodeLines, I, tnCodeLines, tcProcedureAbierto ;
			, taBloquesExclusion, tnBloquesExclusion, tc_Comentario

		EXTERNAL ARRAY taCodeLines, tnBloquesExclusion, taBloquesExclusion

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		IF LEFT(tcLine + ' ', 13) == C_DEFINE_CLASS + ' '
			TRY
				llBloqueEncontrado = .T.
				LOCAL Z, lcProp, lcValue, loEx AS EXCEPTION ;
					, llMETADATA_Completed, llPROTECTED_Completed, llHIDDEN_Completed, llDEFINED_PAM_Completed ;
					, llINCLUDE_Completed, llCLASS_PROPERTY_Completed ;
					, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'

				STORE '' TO tcProcedureAbierto
				toClase					= CREATEOBJECT('CL_CLASE')
				toClase._Nombre			= ALLTRIM( STREXTRACT( tcLine, 'DEFINE CLASS ', ' AS ', 1, 1 ) )
				toClase._ObjName		= toClase._Nombre
				toClase._Definicion		= ALLTRIM( tcLine )
				IF NOT ' OF ' $ UPPER(tcLine)	&& Puede no tener "OF libreria.vcx"
					toClase._Class			= ALLTRIM( CHRTRAN( STREXTRACT( tcLine + ' OLEPUBLIC', ' AS ', ' OLEPUBLIC', 1, 1 ), ["'], [] ) )
				ELSE
					toClase._Class			= ALLTRIM( CHRTRAN( STREXTRACT( tcLine + ' OF ', ' AS ', ' OF ', 1, 1 ), ["'], [] ) )
				ENDIF
				toClase._ClassLoc		= ALLTRIM( CHRTRAN( STREXTRACT( tcLine + ' OLEPUBLIC', ' OF ', ' OLEPUBLIC', 1, 1 ), ["'], [] ) )
				toClase._OlePublic		= ' OLEPUBLIC' $ UPPER(tcLine)
				toClase._Comentario		= tc_Comentario
				toClase._Inicio			= I
				toClase._Ini_Cab		= I + 1

				toModulo.add_Class( toClase )

				*-- Ubico el objeto ole por su nombre (parent+objname), que no se repite.
				IF toModulo.existeObjetoOLE( toClase._Nombre, @Z )
					toClase._Ole	= toModulo._Ole_Objs(Z)._Value
				ENDIF

				* Búsqueda del ID de fin de bloque (ENDDEFINE)
				WITH THIS
					FOR I = toClase._Ini_Cab TO tnCodeLines
						tc_Comentario	= ''
						.set_Line( @tcLine, @taCodeLines, I )

						DO CASE
						CASE .lineIsOnlyCommentAndNoMetadata( @tcLine, @tc_Comentario )
							LOOP

						CASE .analizarBloque_PROCEDURE( @toModulo, @toClase, @loObjeto, @tcLine, @taCodeLines, @I, @tnCodeLines ;
								, @tcProcedureAbierto, @tc_Comentario, @taBloquesExclusion, @tnBloquesExclusion )
							*-- OJO: Esta se analiza primero a propósito, solo porque no puede estar detrás de PROTECTED y HIDDEN
							llCLASS_PROPERTY_Completed = .T.
							llPROTECTED_Completed	= .T.
							llHIDDEN_Completed	= .T.
							llINCLUDE_Completed	= .T.
							llMETADATA_Completed	= .T.
							llDEFINED_PAM_Completed	= .T.


						CASE NOT llPROTECTED_Completed AND .analizarBloque_PROTECTED( @toClase, @tcLine )
							llPROTECTED_Completed	= .T.


						CASE NOT llHIDDEN_Completed AND .analizarBloque_HIDDEN( @toClase, @tcLine )
							llHIDDEN_Completed	= .T.


						CASE NOT llINCLUDE_Completed AND .c_Type <> "SCX" AND .analizarBloque_INCLUDE( @toModulo, @toClase, @tcLine, @taCodeLines ;
								, @I, @tnCodeLines, @tcProcedureAbierto )
							llINCLUDE_Completed	= .T.


						CASE NOT llMETADATA_Completed AND .analizarBloque_METADATA( @toClase, @tcLine )
							llMETADATA_Completed	= .T.


						CASE NOT llDEFINED_PAM_Completed AND .analizarBloque_DEFINED_PAM( @toClase, @tcLine, @taCodeLines, tnCodeLines, @I )
							llDEFINED_PAM_Completed	= .T.


						CASE .analizarBloque_ADD_OBJECT( @toModulo, @toClase, @tcLine, @I, @taCodeLines, @tnCodeLines )
							llCLASS_PROPERTY_Completed = .T.
							llPROTECTED_Completed	= .T.
							llHIDDEN_Completed	= .T.
							llINCLUDE_Completed	= .T.
							llMETADATA_Completed	= .T.
							llDEFINED_PAM_Completed	= .T.


						CASE .analizarBloque_ENDDEFINE( @toClase, @tcLine, @I, @tcProcedureAbierto )
							EXIT


						CASE NOT llCLASS_PROPERTY_Completed AND EMPTY( toClase._Fin_Cab )
							*-- Propiedades de la CLASE
							*--
							*-- NOTA: Las propiedades se agregan tal cual, incluso aunque estén separadas en
							*--       varias líneas (memberdata y fb2p_value), ya que luego se ensamblan en classProps2Memo().
							*
							*toClase.add_Property( THIS.desnormalizarAsignacion( RTRIM(tcLine) ), RTRIM(tc_Comentario) )
							.get_SeparatedPropAndValue( RTRIM(tcLine), @lcProp, @lcValue, @toClase, @taCodeLines, tnCodeLines, @I )
							toClase.add_Property( @lcProp, @lcValue, RTRIM(tc_Comentario) )


						OTHERWISE
							*-- Las líneas que pasan por aquí deberían estar vacías y ser de relleno del embellecimiento

						ENDCASE

					ENDFOR
				ENDWITH && THIS

				*-- Validación
				IF EMPTY( toClase._Fin )
					ERROR 'No se ha encontrado el marcador de fin [ENDDEFINE] ' ;
						+ 'que cierra al marcador de inicio [DEFINE CLASS] ' ;
						+ 'de la línea ' + TRANSFORM( toClase._Inicio ) + ' ' ;
						+ 'para el identificador [' + toClase._Nombre + ']'
				ENDIF

				toClase._PROPERTIES		= THIS.classProps2Memo( toClase )
				toClase._PROTECTED		= THIS.hiddenAndProtected_PAM( toClase )
				toClase._METHODS		= THIS.classMethods2Memo( toClase )
				toClase._RESERVED1		= IIF( THIS.c_Type = 'SCX', '', 'Class' )
				toClase._RESERVED2		= IIF( THIS.c_Type = 'VCX' OR toClase._Nombre == 'Dataenvironment', TRANSFORM( toClase._AddObject_Count + 1 ), '' )
				toClase._RESERVED3		= THIS.defined_PAM2Memo( toClase )
				toClase._RESERVED4		= toClase._ClassIcon
				toClase._RESERVED5		= toClase._ProjectClassIcon
				toClase._RESERVED6		= toClase._Scale
				toClase._RESERVED7		= toClase._Comentario
				toClase._RESERVED8		= toClase._includeFile

			CATCH TO loEx
				IF THIS.l_Debug AND _VFP.STARTMODE = 0
					SET STEP ON
				ENDIF

				THROW

			ENDTRY
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ENDDEFINE
		LPARAMETERS toClase, tcLine, I, tcProcedureAbierto

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		IF LEFT( tcLine + ' ', 10 ) == C_ENDDEFINE + ' '	&& Fin de bloque (ENDDEF / ENDPROC) encontrado
			llBloqueEncontrado	= .T.
			toClase._Fin		= I

			IF EMPTY( toClase._Ini_Cuerpo )
				toClase._Ini_Cuerpo	= I-1
			ENDIF

			toClase._Fin_Cuerpo	= I-1

			IF EMPTY( toClase._Fin_Cab )
				toClase._Fin_Cab	= I-1
			ENDIF

			STORE '' TO tcProcedureAbierto
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_HIDDEN
		LPARAMETERS toClase, tcLine

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		IF LEFT(tcLine, 7) == 'HIDDEN '
			llBloqueEncontrado	= .T.
			toClase._HiddenProps		= ALLTRIM( SUBSTR( tcLine, 8 ) )
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_INCLUDE
		LPARAMETERS toModulo, toClase, tcLine, taCodeLines, I, tnCodeLines, tcProcedureAbierto
		LOCAL llBloqueEncontrado

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		IF LEFT(tcLine, 9) == '#INCLUDE '
			llBloqueEncontrado		= .T.
			IF THIS.c_Type = 'SCX'
				toModulo._includeFile	= ALLTRIM( CHRTRAN( SUBSTR( tcLine, 10 ), ["'], [] ) )
			ELSE
				toClase._includeFile	= ALLTRIM( CHRTRAN( SUBSTR( tcLine, 10 ), ["'], [] ) )
			ENDIF
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_METADATA
		LPARAMETERS toClase, tcLine

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		IF LEFT(tcLine, C_LEN_METADATA_I) == C_METADATA_I	&& METADATA de la CLASE
			*< CLASSDATA: Baseclass="custom" Timestamp="2013/11/19 11:51:04" Scale="Foxels" Uniqueid="_3WF0VSTN1" ProjectClassIcon="container.ico" ClassIcon="toolbar.ico" />
			LOCAL laPropsAndValues(1,2), lnPropsAndValues_Count
			llBloqueEncontrado	= .T.
			WITH THIS
				.get_ListNamesWithValuesFrom_InLine_MetadataTag( @tcLine, @laPropsAndValues, @lnPropsAndValues_Count, C_METADATA_I, C_METADATA_F )

				toClase._BaseClass			= .get_ValueByName_FromListNamesWithValues( 'BaseClass', 'C', @laPropsAndValues )
				toClase._TimeStamp			= INT( .RowTimeStamp(  .get_ValueByName_FromListNamesWithValues( 'TimeStamp', 'T', @laPropsAndValues ) ) )
				toClase._Scale				= .get_ValueByName_FromListNamesWithValues( 'Scale', 'C', @laPropsAndValues )
				toClase._UniqueID			= .get_ValueByName_FromListNamesWithValues( 'UniqueID', 'C', @laPropsAndValues )
				toClase._ProjectClassIcon	= .get_ValueByName_FromListNamesWithValues( 'ProjectClassIcon', 'C', @laPropsAndValues )
				toClase._ClassIcon			= .get_ValueByName_FromListNamesWithValues( 'ClassIcon', 'C', @laPropsAndValues )
				toClase._Ole2				= .get_ValueByName_FromListNamesWithValues( 'OLEObject', 'C', @laPropsAndValues )
			ENDWITH && THIS

			IF NOT EMPTY( toClase._Ole2 )	&& Le agrego "OLEObject = " delante
				toClase._Ole2	= 'OLEObject = ' + toClase._Ole2 + CR_LF
			ENDIF
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_OLE_DEF
		LPARAMETERS toModulo, tcLine, taCodeLines, I, tnCodeLines, tcProcedureAbierto
		LOCAL llBloqueEncontrado

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		IF LEFT( tcLine + ' ', C_LEN_OLE_I + 1 ) == C_OLE_I + ' '
			llBloqueEncontrado	= .T.
			*-- Se encontró una definición de objeto OLE
			*< OLE: Nombre="frm_d.ole_ImageControl2" parent="frm_d" objname="ole_ImageControl2" checksum="4171274922" value="b64-value" />
			LOCAL laPropsAndValues(1,2), lnPropsAndValues_Count ;
				, loOle AS CL_OLE OF 'FOXBIN2PRG.PRG'
			loOle			= NULL
			loOle			= CREATEOBJECT('CL_OLE')

			WITH THIS
				.get_ListNamesWithValuesFrom_InLine_MetadataTag( @tcLine, @laPropsAndValues, @lnPropsAndValues_Count, C_OLE_I, C_OLE_F )

				loOle._Nombre		= .get_ValueByName_FromListNamesWithValues( 'Nombre', 'C', @laPropsAndValues )
				loOle._Parent		= .get_ValueByName_FromListNamesWithValues( 'Parent', 'C', @laPropsAndValues )
				loOle._ObjName		= .get_ValueByName_FromListNamesWithValues( 'ObjName', 'C', @laPropsAndValues )
				loOle._CheckSum		= .get_ValueByName_FromListNamesWithValues( 'CheckSum', 'C', @laPropsAndValues )
				loOle._Value		= STRCONV( .get_ValueByName_FromListNamesWithValues( 'Value', 'C', @laPropsAndValues ), 14 )
			ENDWITH

			toModulo.add_OLE( loOle )

			IF EMPTY( loOle._Value )
				*-- Si el objeto OLE no tiene VALUE, es porque hay otro con el mismo contenido y no se duplicó para preservar espacio.
				*-- Busco el VALUE del duplicado que se guardó y lo asigno nuevamente
				FOR Z = 1 TO toModulo._Ole_Obj_count - 1
					IF toModulo._Ole_Objs(Z)._CheckSum == loOle._CheckSum AND NOT EMPTY( toModulo._Ole_Objs(Z)._Value )
						loOle._Value	= toModulo._Ole_Objs(Z)._Value
						EXIT
					ENDIF
				ENDFOR
			ENDIF

			loOle	= NULL
			RELEASE loOle
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_PROCEDURE
		LPARAMETERS toModulo, toClase, toObjeto, tcLine, taCodeLines, I, tnCodeLines, tcProcedureAbierto ;
			, tc_Comentario, taBloquesExclusion, tnBloquesExclusion

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
			LOCAL toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		DO CASE
		CASE LEFT( tcLine, 20 ) == 'PROTECTED PROCEDURE '
			*-- Estructura a reconocer: PROTECTED PROCEDURE nombre_del_procedimiento
			llBloqueEncontrado	= .T.
			tcProcedureAbierto	= ALLTRIM( SUBSTR( tcLine, 21 ) )
			THIS.evaluarDefinicionDeProcedure( @toClase, I, @tc_Comentario, tcProcedureAbierto, 'protected', @toObjeto )


		CASE LEFT( tcLine, 17 ) == 'HIDDEN PROCEDURE '
			*-- Estructura a reconocer: HIDDEN PROCEDURE nombre_del_procedimiento
			llBloqueEncontrado	= .T.
			tcProcedureAbierto	= ALLTRIM( SUBSTR( tcLine, 18 ) )
			THIS.evaluarDefinicionDeProcedure( @toClase, I, @tc_Comentario, tcProcedureAbierto, 'hidden', @toObjeto )

		CASE LEFT( tcLine, 10 ) == 'PROCEDURE '
			*-- Estructura a reconocer: PROCEDURE [objeto.]nombre_del_procedimiento
			llBloqueEncontrado	= .T.
			tcProcedureAbierto	= ALLTRIM( SUBSTR( tcLine, 11 ) )
			THIS.evaluarDefinicionDeProcedure( @toClase, I, @tc_Comentario, tcProcedureAbierto, 'normal', @toObjeto )

		ENDCASE

		IF llBloqueEncontrado
			*-- Evalúo todo el contenido del PROCEDURE
			THIS.analizarLineasDeProcedure( @toClase, @toObjeto, @tcLine, @taCodeLines, @I, @tnCodeLines, @tcProcedureAbierto ;
				, @tc_Comentario, @taBloquesExclusion, @tnBloquesExclusion )
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_PROTECTED
		LPARAMETERS toClase, tcLine

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL llBloqueEncontrado

		IF LEFT(tcLine, 10) == 'PROTECTED '
			llBloqueEncontrado	= .T.
			toClase._ProtectedProps		= ALLTRIM( SUBSTR( tcLine, 11 ) )
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE evaluarDefinicionDeProcedure
		LPARAMETERS toClase, tnX, tc_Comentario, tcProcName, tcProcType, toObjeto
		*--------------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lcNombreObjeto, lnObjProc ;
				, loProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'

			IF EMPTY(toClase._Fin_Cab)
				toClase._Fin_Cab	= tnX-1
				toClase._Ini_Cuerpo	= tnX
			ENDIF

			loProcedure		= CREATEOBJECT("CL_PROCEDURE")
			loProcedure._Nombre			= tcProcName
			loProcedure._ProcType		= tcProcType
			loProcedure._Comentario		= tc_Comentario

			*-- Anoto en HiddenMethods y ProtectedMethods según corresponda
			DO CASE
			CASE loProcedure._ProcType == 'hidden'
				toClase._HiddenMethods	= toClase._HiddenMethods + ',' + tcProcName

			CASE loProcedure._ProcType == 'protected'
				toClase._ProtectedMethods	= toClase._ProtectedMethods + ',' + tcProcName

			ENDCASE

			*-- Agrego el objeto Procedimiento a la clase, o a un objeto de la clase.
			IF '.' $ tcProcName
				*-- Procedimiento de objeto
				lcNombreObjeto	= LOWER( JUSTSTEM( tcProcName ) )

				*-- Busco el objeto al que corresponde el método
				lnObjProc	= THIS.buscarObjetoDelMetodoPorNombre( lcNombreObjeto, toClase )

				IF lnObjProc = 0
					*-- Procedimiento de clase
					toClase.add_Procedure( loProcedure )
					toObjeto	= NULL
				ELSE
					*-- Procedimiento de objeto
					toObjeto	= toClase._AddObjects( lnObjProc )
					toObjeto.add_Procedure( loProcedure )
				ENDIF
			ELSE
				*-- Procedimiento de clase
				toClase.add_Procedure( loProcedure )
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			STORE NULL TO loProcedure
			RELEASE loProcedure

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toModulo
		*--------------------------------------------------------------------------------------------------------------
		* taCodeLines				(!@ IN    ) El array con las líneas del código donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de líneas de código
		* taBloquesExclusion		(!@ IN    ) Array con las posiciones de inicio/fin de los bloques de exclusion
		* tnBloquesExclusion		(!@ IN    ) Cantidad de bloques de exclusión
		* toModulo					(?@    OUT) Objeto con toda la información del módulo analizado
		*
		* NOTA:
		* Como identificador se usa el nombre de clase o de procedimiento, según corresponda.
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY taCodeLines, taBloquesExclusion

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, loEx AS EXCEPTION ;
				, llFoxBin2Prg_Completed, llOLE_DEF_Completed, llINCLUDE_SCX_Completed ;
				, lc_Comentario, lcProcedureAbierto, lcLine ;
				, loClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'

			STORE '' TO lcProcedureAbierto

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_OutputFile))

			IF tnCodeLines > 1

				*-- Defino el objeto de módulo y sus propiedades
				toModulo	= NULL
				toModulo	= CREATEOBJECT('CL_MODULO')

				*-- Búsqueda del ID de inicio de bloque (DEFINE CLASS / PROCEDURE)
				WITH THIS
					FOR I = 1 TO tnCodeLines
						STORE '' TO lc_Comentario
						.set_Line( @lcLine, @taCodeLines, I )

						DO CASE
						CASE THIS.lineaExcluida( I, tnBloquesExclusion, @taBloquesExclusion ) ;
								OR .lineIsOnlyCommentAndNoMetadata( @lcLine, @lc_Comentario ) && Excluida, vacía o solo Comentarios

						CASE NOT llFoxBin2Prg_Completed AND .analizarBloque_FoxBin2Prg( toModulo, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFoxBin2Prg_Completed	= .T.

						CASE NOT llOLE_DEF_Completed AND .analizarBloque_OLE_DEF( @toModulo, @lcLine, @taCodeLines ;
								, @I, tnCodeLines, @lcProcedureAbierto )
							*-- Puede haber varios

						CASE NOT llINCLUDE_SCX_Completed AND .c_Type = 'SCX' AND .analizarBloque_INCLUDE( @toModulo, @loClase, @lcLine ;
								, @taCodeLines, @I, tnCodeLines, @lcProcedureAbierto )
							* Específico para SCX que lo tiene al inicio
							llINCLUDE_SCX_Completed	= .T.

						CASE .analizarBloque_DEFINE_CLASS( @toModulo, @loClase, @lcLine, @taCodeLines, @I, tnCodeLines ;
								, @lcProcedureAbierto, @taBloquesExclusion, @tnBloquesExclusion, @lc_Comentario )
							*-- Puede haber varias

						ENDCASE

					ENDFOR
				ENDWITH	&& THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			STORE NULL TO loClase
			RELEASE loClase
		ENDTRY

		RETURN
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_vcx AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_vcx OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="escribirarchivobin" type="method" display="escribirArchivoBin"/>] ;
		+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion, I
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			THIS.doBackup( .F., .T. )

			*-- Creo la librería
			THIS.createClasslib()

			*-- Identifico los TEXT/ENDTEXT, #IF .F./#ENDIF
			THIS.identificarBloquesDeExclusion( @laCodeLines, lnCodeLines, .F., @laBloquesExclusion, @lnBloquesExclusion )

			*-- Identifico el inicio/fin de bloque, definición, cabecera y cuerpo de cada clase
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @toModulo )

			THIS.escribirArchivoBin( @toModulo )


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toModulo
		*-- Estructura del objeto toModulo generado:
		*-- -----------------------------------------------------------------------------------------------------------
		*-- Version					Versión usada para generar la versión PRG analizada
		*-- SourceFile				Nombre original del archivo fuente de la conversión
		*-- Ole_Obj_Count			Cantidad de objetos definidos en el array ole_objs[]
		*-- Ole_Objs[1]				Array de objetos OLE definidos como clases
		*--		ObjName					Nombre del objeto OLE (OLE2)
		*--		Parent					Nombre del objeto Padre
		*--		CheckSum				Suma de verificación
		*--		Value					Valor del campo OLE
		*-- Clases_Count				Array con las posiciones de los addobjects, definicion y propiedades
		*-- Clases[1]				Array con los datos de las clases, definicion, propiedades y métodos
		*-- 	Nombre					El nombre de la clase (ej: "miClase")
		*--		ObjName					Nombre del objeto
		*--		Parent					Nombre del objeto Padre
		*-- 	Class					Clase de la que hereda la definición
		*-- 	Classloc				Librería donde está la definición de la clase
		*--		Ole						Información campo ole
		*--		Ole2					Información campo ole2
		*--		OlePublic				Indica si la clase es OLEPublic o no (.T. / .F.)
		*-- 	Uniqueid				ID único
		*-- 	Comentario				El comentario de la clase (ej: "&& Mis comentarios")
		*-- 	MetaData				Información de metadata de la clase (baseclass, timestamp, scale)
		*-- 	BaseClass				Clase de base de la clase
		*-- 	TimeStamp				Timestamp de la clase
		*-- 	Scale					Scale de la clase (pixels, foxels)
		*-- 	Definicion				La definición de la clase (ej: "AS Custom OF LIBRERIA.VCX")
		*-- 	Inicio/Fin				Línea de inicio/fin de la clase (DEFINE CLASS/ENDDEFINE)
		*-- 	Ini_Cab/Fin_Cab			Línea de inicio/fin de la cabecera (def.propiedades, Hidden, Protected, #Include, CLASSDATA, DEFINED_PAM)
		*-- 	Ini_Cuerpo/Fin_Cuerpo	Línea de inicio/fin del cuerpo (ADD OBJECTs y PROCEDURES)
		*-- 	HiddenProps				Propiedades definidas como HIDDEN (ocultas)
		*-- 	ProtectedProps			Propiedades definidas como PROTECTED (protegidas)
		*-- 	Defined_PAM				Propiedades, eventos o métodos definidos por el usuario
		*-- 	IncludeFile				Nombre del archivo de inclusión
		*-- 	Props_Count				Cantidad de propiedades de la clase definicas en el array props[]
		*-- 	Props[1,2]				Array con todas las propiedades de la clase y sus valores. (col.1=Nombre, col.2=Comentario)
		*-- 	AddObject_Count			Cantidad de objetos definidos en el array addobjects[]
		*-- 	AddObjects[1]			Array con las posiciones de los addobjects, definicion y propiedades
		*-- 		Nombre					Nombre del objeto
		*--			ObjName					Nombre del objeto
		*--			Parent					Nombre del objeto Padre
		*-- 		Clase					Clase del objeto
		*-- 		ClassLib				Librería de clases de la que deriva la clase
		*-- 		Baseclass				Clase de base del objeto
		*-- 		Uniqueid				ID único
		*--			Ole						Información campo ole
		*--			Ole2					Información campo ole2
		*--			ZOrder					Orden Z del objeto
		*-- 		Props_Count				Cantidad de propiedades del objeto
		*-- 		Props[1]				Array con todas las propiedades del objeto y sus valores
		*-- 		Procedure_count			Cantidad de procedimientos definidos en el array procedures[]
		*-- 		Procedures[1]			Array con las posiciones de los procedures, definicion y comentarios
		*-- 			Nombre					Nombre del procedure
		*-- 			ProcType				Tipo de procedimiento (normal, hidden, protected)
		*-- 			Comentario				Comentario el procedure
		*-- 			ProcLine_Count			Cantidad de líneas del procedimiento
		*-- 			ProcLines[1]			Líneas del procedimiento
		*-- 	Procedure_count			Cantidad de procedimientos definidos en el array procedures[]
		*-- 	Procedures[1]			Array con las posiciones de los procedures, definicion y comentarios
		*-- 		Nombre					Nombre del procedure
		*-- 		ProcType				Tipo de procedimiento (normal, hidden, protected)
		*-- 		Comentario				Comentario el procedure
		*-- 		ProcLine_Count			Cantidad de líneas del procedimiento
		*-- 		ProcLines[1]			Líneas del procedimiento
		*-- -----------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lcObjName, lnCodError, I, X, loEx AS EXCEPTION ;
				, loClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'

			*-- Creo el registro de cabecera
			THIS.createClasslib_RecordHeader()


			*-- Recorro las CLASES
			FOR I = 1 TO toModulo._Clases_Count

				loClase	= toModulo._Clases(I)

				*-- Inserto la clase
				INSERT INTO TABLABIN ;
					( PLATFORM ;
					, UNIQUEID ;
					, TIMESTAMP ;
					, CLASS ;
					, CLASSLOC ;
					, BASECLASS ;
					, OBJNAME ;
					, PARENT ;
					, PROPERTIES ;
					, PROTECTED ;
					, METHODS ;
					, OLE ;
					, OLE2 ;
					, RESERVED1 ;
					, RESERVED2 ;
					, RESERVED3 ;
					, RESERVED4 ;
					, RESERVED5 ;
					, RESERVED6 ;
					, RESERVED7 ;
					, RESERVED8 ;
					, USER) ;
					VALUES ;
					( 'WINDOWS' ;
					, loClase._UniqueID ;
					, loClase._TimeStamp ;
					, loClase._Class ;
					, loClase._ClassLoc ;
					, loClase._BaseClass ;
					, loClase._ObjName ;
					, loClase._Parent ;
					, loClase._PROPERTIES ;
					, loClase._PROTECTED ;
					, loClase._METHODS ;
					, loClase._Ole ;
					, loClase._Ole2 ;
					, loClase._RESERVED1 ;
					, loClase._RESERVED2 ;
					, loClase._RESERVED3 ;
					, loClase._ClassIcon ;
					, loClase._ProjectClassIcon ;
					, loClase._Scale ;
					, loClase._Comentario ;
					, loClase._includeFile ;
					, loClase._User )


				THIS.insert_AllObjects( @loClase )


				*-- Inserto el COMMENT
				INSERT INTO TABLABIN ;
					( PLATFORM ;
					, UNIQUEID ;
					, TIMESTAMP ;
					, CLASS ;
					, CLASSLOC ;
					, BASECLASS ;
					, OBJNAME ;
					, PARENT ;
					, PROPERTIES ;
					, PROTECTED ;
					, METHODS ;
					, OLE ;
					, OLE2 ;
					, RESERVED1 ;
					, RESERVED2 ;
					, RESERVED3 ;
					, RESERVED4 ;
					, RESERVED5 ;
					, RESERVED6 ;
					, RESERVED7 ;
					, RESERVED8 ;
					, USER) ;
					VALUES ;
					( 'COMMENT' ;
					, 'RESERVED' ;
					, loClase._TimeStamp ;
					, '' ;
					, '' ;
					, '' ;
					, loClase._ObjName ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, IIF(loClase._OlePublic, 'OLEPublic', '') ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' ;
					, '' )

			ENDFOR	&& I = 1 TO toModulo._Clases_Count

			USE IN (SELECT("TABLABIN"))
			COMPILE CLASSLIB (THIS.c_OutputFile)


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN lnCodError

	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_scx AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_scx OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="escribirarchivobin" type="method" display="escribirArchivoBin"/>] ;
		+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion, I
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			THIS.doBackup( .F., .T. )

			*-- Creo el form
			THIS.createForm()

			*-- Identifico los TEXT/ENDTEXT, #IF .F./#ENDIF
			THIS.identificarBloquesDeExclusion( @laCodeLines, lnCodeLines, .F., @laBloquesExclusion, @lnBloquesExclusion )

			*-- Identifico el inicio/fin de bloque, definición, cabecera y cuerpo de cada clase
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @toModulo )

			THIS.escribirArchivoBin( @toModulo )


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toModulo
		*-- Estructura del objeto toModulo generado:
		*-- -----------------------------------------------------------------------------------------------------------
		*-- Version					Versión usada para generar la versión PRG analizada
		*-- SourceFile				Nombre original del archivo fuente de la conversión
		*-- Ole_Obj_Count			Cantidad de objetos definidos en el array ole_objs[]
		*-- Ole_Objs[1]				Array de objetos OLE definidos como clases
		*--		ObjName					Nombre del objeto OLE (OLE2)
		*--		Parent					Nombre del objeto Padre
		*--		CheckSum				Suma de verificación
		*--		Value					Valor del campo OLE
		*-- Clases_Count				Array con las posiciones de los addobjects, definicion y propiedades
		*-- Clases[1]				Array con los datos de las clases, definicion, propiedades y métodos
		*-- 	Nombre					El nombre de la clase (ej: "miClase")
		*--		ObjName					Nombre del objeto
		*--		Parent					Nombre del objeto Padre
		*-- 	Class					Clase de la que hereda la definición
		*-- 	Classloc				Librería donde está la definición de la clase
		*--		Ole						Información campo ole
		*--		Ole2					Información campo ole2
		*--		OlePublic				Indica si la clase es OLEPublic o no (.T. / .F.)
		*-- 	Uniqueid				ID único
		*-- 	Comentario				El comentario de la clase (ej: "&& Mis comentarios")
		*-- 	MetaData				Información de metadata de la clase (baseclass, timestamp, scale)
		*-- 	BaseClass				Clase de base de la clase
		*-- 	TimeStamp				Timestamp de la clase
		*-- 	Scale					Scale de la clase (pixels, foxels)
		*-- 	Definicion				La definición de la clase (ej: "AS Custom OF LIBRERIA.VCX")
		*-- 	Inicio/Fin				Línea de inicio/fin de la clase (DEFINE CLASS/ENDDEFINE)
		*-- 	Ini_Cab/Fin_Cab			Línea de inicio/fin de la cabecera (def.propiedades, Hidden, Protected, #Include, CLASSDATA, DEFINED_PAM)
		*-- 	Ini_Cuerpo/Fin_Cuerpo	Línea de inicio/fin del cuerpo (ADD OBJECTs y PROCEDURES)
		*-- 	HiddenProps				Propiedades definidas como HIDDEN (ocultas)
		*-- 	ProtectedProps			Propiedades definidas como PROTECTED (protegidas)
		*-- 	Defined_PAM				Propiedades, eventos o métodos definidos por el usuario
		*-- 	IncludeFile				Nombre del archivo de inclusión
		*-- 	Props_Count				Cantidad de propiedades de la clase definicas en el array props[]
		*-- 	Props[1,2]				Array con todas las propiedades de la clase y sus valores. (col.1=Nombre, col.2=Comentario)
		*-- 	AddObject_Count			Cantidad de objetos definidos en el array addobjects[]
		*-- 	AddObjects[1]			Array con las posiciones de los addobjects, definicion y propiedades
		*-- 		Nombre					Nombre del objeto
		*--			ObjName					Nombre del objeto
		*--			Parent					Nombre del objeto Padre
		*-- 		Clase					Clase del objeto
		*-- 		ClassLib				Librería de clases de la que deriva la clase
		*-- 		Baseclass				Clase de base del objeto
		*-- 		Uniqueid				ID único
		*--			Ole						Información campo ole
		*--			Ole2					Información campo ole2
		*--			ZOrder					Orden Z del objeto
		*-- 		Props_Count				Cantidad de propiedades del objeto
		*-- 		Props[1]				Array con todas las propiedades del objeto y sus valores
		*-- 		Procedure_count			Cantidad de procedimientos definidos en el array procedures[]
		*-- 		Procedures[1]			Array con las posiciones de los procedures, definicion y comentarios
		*-- 			Nombre					Nombre del procedure
		*-- 			ProcType				Tipo de procedimiento (normal, hidden, protected)
		*-- 			Comentario				Comentario el procedure
		*-- 			ProcLine_Count			Cantidad de líneas del procedimiento
		*-- 			ProcLines[1]			Líneas del procedimiento
		*-- 	Procedure_count			Cantidad de procedimientos definidos en el array procedures[]
		*-- 	Procedures[1]			Array con las posiciones de los procedures, definicion y comentarios
		*-- 		Nombre					Nombre del procedure
		*-- 		ProcType				Tipo de procedimiento (normal, hidden, protected)
		*-- 		Comentario				Comentario el procedure
		*-- 		ProcLine_Count			Cantidad de líneas del procedimiento
		*-- 		ProcLines[1]			Líneas del procedimiento
		*-- -----------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lcObjName, lnCodError, loEx AS EXCEPTION ;
				, loClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'

			*-- Creo el registro de cabecera
			THIS.createForm_RecordHeader()

			*-- El SCX tiene el INCLUDE en el primer registro
			IF NOT EMPTY(toModulo._includeFile)
				REPLACE RESERVED8 WITH toModulo._includeFile
			ENDIF


			*-- Recorro las CLASES
			FOR I = 1 TO toModulo._Clases_Count

				loClase	= toModulo._Clases(I)

				*-- Inserto la clase
				INSERT INTO TABLABIN ;
					( PLATFORM ;
					, UNIQUEID ;
					, TIMESTAMP ;
					, CLASS ;
					, CLASSLOC ;
					, BASECLASS ;
					, OBJNAME ;
					, PARENT ;
					, PROPERTIES ;
					, PROTECTED ;
					, METHODS ;
					, OLE ;
					, OLE2 ;
					, RESERVED1 ;
					, RESERVED2 ;
					, RESERVED3 ;
					, RESERVED4 ;
					, RESERVED5 ;
					, RESERVED6 ;
					, RESERVED7 ;
					, RESERVED8 ;
					, USER) ;
					VALUES ;
					( 'WINDOWS' ;
					, loClase._UniqueID ;
					, loClase._TimeStamp ;
					, loClase._Class ;
					, loClase._ClassLoc ;
					, loClase._BaseClass ;
					, loClase._ObjName ;
					, loClase._Parent ;
					, loClase._PROPERTIES ;
					, loClase._PROTECTED ;
					, loClase._METHODS ;
					, loClase._Ole ;
					, loClase._Ole2 ;
					, loClase._RESERVED1 ;
					, loClase._RESERVED2 ;
					, loClase._RESERVED3 ;
					, loClase._ClassIcon ;
					, loClase._ProjectClassIcon ;
					, loClase._Scale ;
					, loClase._Comentario ;
					, loClase._includeFile ;
					, loClase._User )


				THIS.insert_AllObjects( @loClase )


				IF .F. &&NOT loClase._BaseClass == 'dataenvironment'
					*-- Inserto el COMMENT
					INSERT INTO TABLABIN ;
						( PLATFORM ;
						, UNIQUEID ;
						, TIMESTAMP ;
						, CLASS ;
						, CLASSLOC ;
						, BASECLASS ;
						, OBJNAME ;
						, PARENT ;
						, PROPERTIES ;
						, PROTECTED ;
						, METHODS ;
						, OLE ;
						, OLE2 ;
						, RESERVED1 ;
						, RESERVED2 ;
						, RESERVED3 ;
						, RESERVED4 ;
						, RESERVED5 ;
						, RESERVED6 ;
						, RESERVED7 ;
						, RESERVED8 ;
						, USER) ;
						VALUES ;
						( 'COMMENT' ;
						, 'RESERVED' ;
						, loClase._TimeStamp ;
						, '' ;
						, '' ;
						, '' ;
						, loClase._ObjName ;
						, '' ;
						, '' ;
						, '' ;
						, '' ;
						, '' ;
						, '' ;
						, '' ;
						, IIF(loClase._OlePublic, 'OLEPublic', '') ;
						, '' ;
						, '' ;
						, '' ;
						, '' ;
						, '' ;
						, '' ;
						, '' )
				ENDIF

			ENDFOR	&& I = 1 TO toModulo._Clases_Count

			USE IN (SELECT("TABLABIN"))
			COMPILE FORM (THIS.c_OutputFile)


		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN

	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_pjx AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_pjx OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="escribirarchivobin" type="method" display="escribirArchivoBin"/>] ;
		+ [<memberdata name="analizarbloque_buildproj" type="method" display="analizarBloque_BuildProj"/>] ;
		+ [<memberdata name="analizarbloque_devinfo" type="method" display="analizarBloque_DevInfo"/>] ;
		+ [<memberdata name="analizarbloque_excludedfiles" type="method" display="analizarBloque_ExcludedFiles"/>] ;
		+ [<memberdata name="analizarbloque_filecomments" type="method" display="analizarBloque_FileComments"/>] ;
		+ [<memberdata name="analizarbloque_serverhead" type="method" display="analizarBloque_ServerHead"/>] ;
		+ [<memberdata name="analizarbloque_serverdata" type="method" display="analizarBloque_ServerData"/>] ;
		+ [<memberdata name="analizarbloque_textfiles" type="method" display="analizarBloque_TextFiles"/>] ;
		+ [<memberdata name="analizarbloque_projectproperties" type="method" display="analizarBloque_ProjectProperties"/>] ;
		+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion, I
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			THIS.doBackup( .F., .T. )

			*-- Creo solo la cabecera del proyecto
			THIS.createProject()

			*-- Identifico los TEXT/ENDTEXT, #IF .F./#ENDIF
			*THIS.identificarBloquesDeExclusion( @laCodeLines, .F., @laBloquesExclusion, @lnBloquesExclusion )

			*-- Identifico el inicio/fin de bloque, definición, cabecera y cuerpo de cada clase
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @toProject )

			THIS.escribirArchivoBin( @toProject )


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toProject
		*-- -----------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL loReg, lnCodError, loEx AS EXCEPTION ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG' ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			*-- Creo solo el registro de cabecera del proyecto
			THIS.createProject_RecordHeader( toProject )

			lcMainProg	= ''

			IF NOT EMPTY(toProject._MainProg)
				lcMainProg	= LOWER( SYS(2014, toProject._MainProg, ADDBS(JUSTPATH(toProject._HomeDir)) ) )
			ENDIF

			*-- Si hay ProjectHook de proyecto, lo inserto
			IF NOT EMPTY(toProject._ProjectHookLibrary)
				INSERT INTO TABLABIN ;
					( NAME ;
					, TYPE ;
					, EXCLUDE ;
					, KEY ;
					, RESERVED1 ) ;
					VALUES ;
					( toProject._ProjectHookLibrary + CHR(0) ;
					, 'W' ;
					, .T. ;
					, UPPER(JUSTSTEM(toProject._ProjectHookLibrary)) ;
					, toProject._ProjectHookClass + CHR(0) )
			ENDIF

			*-- Si hay ICONO de proyecto, lo inserto
			IF NOT EMPTY(toProject._Icon)
				INSERT INTO TABLABIN ;
					( NAME ;
					, TYPE ;
					, LOCAL ;
					, KEY ) ;
					VALUES ;
					( SYS(2014, toProject._Icon, ADDBS(JUSTPATH(toProject._HomeDir))) + CHR(0) ;
					, 'i' ;
					, .T. ;
					, UPPER(JUSTSTEM(toProject._Icon)) )
			ENDIF

			*-- Agrego los ARCHIVOS
			FOR EACH loFile IN toProject FOXOBJECT
				INSERT INTO TABLABIN ;
					( NAME ;
					, TYPE ;
					, EXCLUDE ;
					, MAINPROG ;
					, COMMENTS ;
					, LOCAL ;
					, CPID ;
					, ID ;
					, TIMESTAMP ;
					, OBJREV ;
					, KEY ) ;
					VALUES ;
					( loFile._Name + CHR(0) ;
					, THIS.fileTypeCode(JUSTEXT(loFile._Name)) ;
					, loFile._Exclude ;
					, (loFile._Name == lcMainProg) ;
					, loFile._Comments ;
					, .T. ;
					, loFile._CPID ;
					, loFile._ID ;
					, loFile._TimeStamp ;
					, loFile._ObjRev ;
					, UPPER(JUSTSTEM(loFile._Name)) )
			ENDFOR


			USE IN (SELECT("TABLABIN"))


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toProject
		*--------------------------------------------------------------------------------------------------------------
		* taCodeLines				(!@ IN    ) El array con las líneas del código donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de líneas de código
		* taBloquesExclusion		(!@ IN    ) Array con las posiciones de inicio/fin de los bloques de exclusion
		* tnBloquesExclusion		(!@ IN    ) Cantidad de bloques de exclusión
		* toProject					(?@    OUT) Objeto con toda la información del proyecto analizado
		*
		* NOTA:
		* Como identificador se usa el nombre de clase o de procedimiento, según corresponda.
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY taCodeLines, taBloquesExclusion

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lc_Comentario, lcLine, llBuildProj_Completed, llDevInfo_Completed ;
				, llServerHead_Completed, llFileComments_Completed, llFoxBin2Prg_Completed ;
				, llExcludedFiles_Completed, llTextFiles_Completed, llProjectProperties_Completed
			STORE 0 TO I

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_OutputFile))

			IF tnCodeLines > 1
				toProject			= CREATEOBJECT('CL_PROJECT')
				toProject._HomeDir	= ADDBS(JUSTPATH(THIS.c_OutputFile))

				WITH THIS
					FOR I = 1 TO tnCodeLines
						.set_Line( @lcLine, @taCodeLines, I )

						IF .lineIsOnlyCommentAndNoMetadata( @lcLine, @lc_Comentario ) && Vacía o solo Comentarios
							LOOP
						ENDIF

						DO CASE
						CASE NOT llFoxBin2Prg_Completed AND .analizarBloque_FoxBin2Prg( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFoxBin2Prg_Completed	= .T.

						CASE NOT llDevInfo_Completed AND .analizarBloque_DevInfo( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llDevInfo_Completed	= .T.

						CASE NOT llServerHead_Completed AND .analizarBloque_ServerHead( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llServerHead_Completed	= .T.

						CASE .analizarBloque_ServerData( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							*-- Puede haber varios servidores, por eso se siguen valuando

						CASE NOT llBuildProj_Completed AND .analizarBloque_BuildProj( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llBuildProj_Completed	= .T.

						CASE NOT llFileComments_Completed AND .analizarBloque_FileComments( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFileComments_Completed	= .T.

						CASE NOT llExcludedFiles_Completed AND .analizarBloque_ExcludedFiles( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llExcludedFiles_Completed	= .T.

						CASE NOT llTextFiles_Completed AND .analizarBloque_TextFiles( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llTextFiles_Completed	= .T.

						CASE NOT llProjectProperties_Completed AND .analizarBloque_ProjectProperties( toProject, @lcLine, @taCodeLines, @I, tnCodeLines )
							llProjectProperties_Completed	= .T.

						ENDCASE

					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_BuildProj
		*------------------------------------------------------
		*-- Analiza el bloque <BuildProj>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcComment, lcMetadatos, luValor ;
				, laPropsAndValues(1,2), lnPropsAndValues_Count ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_BUILDPROJ_I) ) == C_BUILDPROJ_I
				llBloqueEncontrado	= .T.
				STORE NULL TO loProject, loFile

				WITH THIS
					FOR I = I + 1 TO tnCodeLines
						lcComment	= ''
						.set_Line( @tcLine, @taCodeLines, I )

						DO CASE
						CASE LEFT( tcLine, LEN(C_BUILDPROJ_F) ) == C_BUILDPROJ_F
							I = I + 1
							EXIT

						CASE .lineIsOnlyCommentAndNoMetadata( @tcLine, @lcComment )
							LOOP	&& Saltear comentarios

						CASE UPPER( LEFT( tcLine, 14 ) ) == 'BUILD PROJECT '
							LOOP

						CASE UPPER( LEFT( tcLine, 5 ) ) == '.ADD('
							* loFile: NAME,TYPE,EXCLUDE,COMMENTS
							tcLine			= CHRTRAN( tcLine, ["] + '[]', "'''" )	&& Convierto "[] en '
							loFile			= CREATEOBJECT('CL_PROJ_FILE')
							loFile._Name	= ALLTRIM( STREXTRACT( tcLine, ['], ['] ) )

							*-- Obtengo metadatos de los comentarios de FileMetadata:
							*< FileMetadata: Type="V" Cpid="1252" Timestamp="1131901580" ID="1129207528" ObjRev="544" />
							.get_ListNamesWithValuesFrom_InLine_MetadataTag( @lcComment, @laPropsAndValues ;
								, @lnPropsAndValues_Count, C_FILE_META_I, C_FILE_META_F )

							loFile._Type		= .get_ValueByName_FromListNamesWithValues( 'Type', 'C', @laPropsAndValues )
							loFile._CPID		= .get_ValueByName_FromListNamesWithValues( 'CPID', 'I', @laPropsAndValues )
							loFile._TimeStamp	= .get_ValueByName_FromListNamesWithValues( 'Timestamp', 'I', @laPropsAndValues )
							loFile._ID			= .get_ValueByName_FromListNamesWithValues( 'ID', 'I', @laPropsAndValues )
							loFile._ObjRev		= .get_ValueByName_FromListNamesWithValues( 'ObjRev', 'I', @laPropsAndValues )

							toProject.ADD( loFile, loFile._Name )
						ENDCASE
					ENDFOR
				ENDWITH && THIS

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_DevInfo
		*------------------------------------------------------
		*-- Analiza el bloque <DevInfo>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_DEVINFO_I) ) == C_DEVINFO_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_DEVINFO_F) ) == C_DEVINFO_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						toProject.setParsedProjInfoLine( @tcLine )
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ServerHead
		*------------------------------------------------------
		*-- Analiza el bloque <ServerHead>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_SRV_HEAD_I) ) == C_SRV_HEAD_I
				llBloqueEncontrado	= .T.

				STORE NULL TO loServerHead, loServerData
				loServerHead	= toProject._ServerHead

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_SRV_HEAD_F) ) == C_SRV_HEAD_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						loServerHead.setParsedHeadInfoLine( @tcLine )
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ServerData
		*------------------------------------------------------
		*-- Analiza el bloque <ServerData>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG' ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_SRV_DATA_I) ) == C_SRV_DATA_I
				llBloqueEncontrado	= .T.

				STORE NULL TO loServerHead, loServerData
				loServerHead	= toProject._ServerHead
				loServerData	= loServerHead.getServerDataObject()

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_SRV_DATA_F) ) == C_SRV_DATA_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						loServerHead.setParsedInfoLine( loServerData, @tcLine )
					ENDCASE
				ENDFOR

				loServerHead.add_Server( loServerData )
				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_FileComments
		*------------------------------------------------------
		*-- Analiza el bloque <FileComments>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		EXTERNAL ARRAY toProject
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcFile, lcComment ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_FILE_CMTS_I) ) == C_FILE_CMTS_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_FILE_CMTS_F) ) == C_FILE_CMTS_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						lcFile				= LOWER( ALLTRIM( STRTRAN( CHRTRAN( NORMALIZE( STREXTRACT( tcLine, ".ITEM(", ")", 1, 1 ) ), ["], [] ), 'lcCurDir+', '', 1, 1, 1) ) )
						lcComment			= ALLTRIM( CHRTRAN( STREXTRACT( tcLine, "=", "", 1, 2 ), ['], [] ) )
						loFile				= toProject( lcFile )
						loFile._Comments	= lcComment
						loFile				= NULL
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ExcludedFiles
		*------------------------------------------------------
		*-- Analiza el bloque <ExcludedFiles>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		EXTERNAL ARRAY toProject
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcFile, llExclude ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_FILE_EXCL_I) ) == C_FILE_EXCL_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_FILE_EXCL_F) ) == C_FILE_EXCL_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						lcFile			= LOWER( ALLTRIM( STRTRAN( CHRTRAN( NORMALIZE( STREXTRACT( tcLine, ".ITEM(", ")", 1, 1 ) ), ["], [] ), 'lcCurDir+', '', 1, 1, 1) ) )
						llExclude		= EVALUATE( ALLTRIM( CHRTRAN( STREXTRACT( tcLine, "=", "", 1, 2 ), ['], [] ) ) )
						loFile			= toProject( lcFile )
						loFile._Exclude	= llExclude
						loFile			= NULL
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_TextFiles
		*------------------------------------------------------
		*-- Analiza el bloque <TextFiles>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		EXTERNAL ARRAY toProject
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcFile, lcType ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_FILE_TXT_I) ) == C_FILE_TXT_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_FILE_TXT_F) ) == C_FILE_TXT_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						lcFile			= LOWER( ALLTRIM( STRTRAN( CHRTRAN( NORMALIZE( STREXTRACT( tcLine, ".ITEM(", ")", 1, 1 ) ), ["], [] ), 'lcCurDir+', '', 1, 1, 1) ) )
						lcType			= ALLTRIM( CHRTRAN( STREXTRACT( tcLine, "=", "", 1, 2 ), ['], [] ) )
						loFile			= toProject( lcFile )
						loFile._Type	= lcType
						loFile			= NULL
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_ProjectProperties
		*------------------------------------------------------
		*-- Analiza el bloque <ProjectProperties>
		*------------------------------------------------------
		LPARAMETERS toProject, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcLine

			IF LEFT( tcLine, LEN(C_PROJPROPS_I) ) == C_PROJPROPS_I
				llBloqueEncontrado	= .T.

				FOR I = I + 1 TO tnCodeLines
					.set_Line( @tcLine, @taCodeLines, I )

					DO CASE
					CASE LEFT( tcLine, LEN(C_PROJPROPS_F) ) == C_PROJPROPS_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyCommentAndNoMetadata( @tcLine )
						LOOP	&& Saltear comentarios

					CASE LEFT( tcLine ,2 ) == '*<'
						*--- Se asigna con EVALUATE() tal cual está en el PJ2, pero quitando el marcador *< />
						lcLine		= STUFF( ALLTRIM( STREXTRACT( tcLine, '*<', '/>' ) ), 2, 0, '_' )
						toProject.setParsedProjInfoLine( lcLine )

					CASE UPPER( LEFT( tcLine, 9 ) ) == '.SETMAIN('
						*-- Cambio "SetMain()" por "_MainProg ="
						lcLine		= '._MainProg = ' + LOWER( STREXTRACT( ALLTRIM( tcLine), '.SetMain(', ')', 1, 1 ) )
						toProject.setParsedProjInfoLine( lcLine )

					OTHERWISE
						*--- Se asigna con EVALUATE() tal cual está en el PJ2
						lcLine		= STUFF( ALLTRIM( tcLine), 2, 0, '_' )
						toProject.setParsedProjInfoLine( lcLine )
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_frx AS c_conversor_prg_a_bin
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_frx OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="escribirarchivobin" type="method" display="escribirArchivoBin"/>] ;
		+ [<memberdata name="analizarbloque_cdata_inline" type="method" display="analizarBloque_CDATA_inline"/>] ;
		+ [<memberdata name="analizarbloque_platform" type="method" display="analizarBloque_platform"/>] ;
		+ [<memberdata name="analizarbloque_reportes" type="method" display="analizarBloque_Reportes"/>] ;
		+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, loReg, lcLine, laCodeLines(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laBloquesExclusion(1,2), lnBloquesExclusion, I ;
				, loReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_InputFile )
			lnCodeLines			= ALINES( laCodeLines, C_FB2PRG_CODE )

			THIS.doBackup( .F., .T. )

			*-- Creo el reporte
			THIS.createReport()

			*-- Identifico el inicio/fin de bloque, definición, cabecera y cuerpo del reporte
			THIS.identificarBloquesDeCodigo( @laCodeLines, lnCodeLines, @laBloquesExclusion, lnBloquesExclusion, @loReport )

			THIS.escribirArchivoBin( @loReport )


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE escribirArchivoBin
		LPARAMETERS toReport
		*-- -----------------------------------------------------------------------------------------------------------
		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL loReg, I, lcFieldType, lnFieldLen, lnFieldDec, lnNumCampo, laFieldTypes(1,18) ;
				, luValor, lnCodError, loEx AS EXCEPTION
			SELECT TABLABIN
			AFIELDS( laFieldTypes )

			*-- Agrego los registros
			FOR EACH loReg IN toReport FOXOBJECT

				*-- Ajuste de los tipos de dato
				FOR I = 1 TO AMEMBERS(laProps, loReg, 0)
					lnNumCampo	= ASCAN( laFieldTypes, laProps(I), 1, -1, 1, 1+2+4+8 )

					IF lnNumCampo = 0
						ERROR 'No se encontró el campo [' + laProps(I) + '] en la estructura del archivo ' + DBF("TABLABIN")
					ENDIF

					lcFieldType	= laFieldTypes(lnNumCampo,2)
					lnFieldLen	= laFieldTypes(lnNumCampo,3)
					lnFieldDec	= laFieldTypes(lnNumCampo,4)
					luValor		= EVALUATE('loReg.' + laProps(I))

					DO CASE
					CASE INLIST(lcFieldType, 'B')	&& Double
						ADDPROPERTY( loReg, laProps(I), CAST( luValor AS &lcFieldType. (lnFieldPrec) ) )

					CASE INLIST(lcFieldType, 'F', 'N', 'Y')	&& Float, Numeric, Currency
						ADDPROPERTY( loReg, laProps(I), CAST( luValor AS &lcFieldType. (lnFieldLen, lnFieldDec) ) )

					CASE INLIST(lcFieldType, 'W', 'G', 'M', 'Q', 'V', 'C')	&& Blob, General, Memo, Varbinary, Varchar, Character
						ADDPROPERTY( loReg, laProps(I), luValor )

					OTHERWISE	&& Demás tipos
						ADDPROPERTY( loReg, laProps(I), CAST( luValor AS &lcFieldType. (lnFieldLen) ) )

					ENDCASE

				ENDFOR

				INSERT INTO TABLABIN FROM NAME loReg
				loReg	= NULL
			ENDFOR

			USE IN (SELECT("TABLABIN"))

			IF THIS.c_Type = 'FRX'
				COMPILE REPORT (THIS.c_OutputFile)
			ELSE
				COMPILE LABEL (THIS.c_OutputFile)
			ENDIF


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		LPARAMETERS taCodeLines, tnCodeLines, taBloquesExclusion, tnBloquesExclusion, toReport
		*--------------------------------------------------------------------------------------------------------------
		* taCodeLines				(!@ IN    ) El array con las líneas del código donde buscar
		* tnCodeLines				(!@ IN    ) Cantidad de líneas de código
		* taBloquesExclusion		(?@ IN    ) Sin uso
		* tnBloquesExclusion		(?@ IN    ) Sin uso
		* toReport					(?@    OUT) Objeto con toda la información del reporte analizado
		*
		* NOTA:
		* Como identificador se usa el nombre de clase o de procedimiento, según corresponda.
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY taCodeLines, taBloquesExclusion

		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lc_Comentario, lcLine, llFoxBin2Prg_Completed
			STORE 0 TO I

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_OutputFile))

			IF tnCodeLines > 1
				toReport			= NULL
				toReport			= CREATEOBJECT('CL_REPORT')

				WITH THIS
					FOR I = 1 TO tnCodeLines
						.set_Line( @lcLine, @taCodeLines, I )

						IF .lineIsOnlyCommentAndNoMetadata( @lcLine, @lc_Comentario ) && Vacía o solo Comentarios
							LOOP
						ENDIF

						DO CASE
						CASE NOT llFoxBin2Prg_Completed AND .analizarBloque_FoxBin2Prg( toReport, @lcLine, @taCodeLines, @I, tnCodeLines )
							llFoxBin2Prg_Completed	= .T.

						CASE .analizarBloque_Reportes( toReport, @lcLine, @taCodeLines, @I, tnCodeLines )

						ENDCASE
					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_CDATA_inline
		*------------------------------------------------------
		*-- Analiza el bloque <picture>
		*------------------------------------------------------
		LPARAMETERS toReport, tcLine, taCodeLines, I, tnCodeLines, toReg, tcPropName

		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcValue, loEx AS EXCEPTION

			IF LEFT(tcLine, 1 + LEN(tcPropName) + 1 + 9) == '<' + tcPropName + '>' + C_DATA_I
				llBloqueEncontrado	= .T.

				IF C_DATA_F $ tcLine
					lcValue	= STREXTRACT( tcLine, C_DATA_I, C_DATA_F )
					ADDPROPERTY( toReg, tcPropName, lcValue )
					EXIT
				ENDIF

				*-- Tomo la primera parte del valor
				lcValue	= STREXTRACT( tcLine, C_DATA_I )

				*-- Recorro las fracciones del valor
				FOR I = I + 1 TO tnCodeLines
					tcLine	= taCodeLines(I)

					IF C_DATA_F $ tcLine	&& Fin del valor
						lcValue	= lcValue + CR_LF + STREXTRACT( tcLine, '', C_DATA_F )
						ADDPROPERTY( toReg, tcPropName, lcValue )
						EXIT

					ELSE	&& Otra fracción del valor
						lcValue	= lcValue + CR_LF + tcLine
					ENDIF
				ENDFOR

			ENDIF

		CATCH TO loEx
			IF loEx.ERRORNO = 1470	&& Incorrect property name.
				loEx.USERVALUE	= 'PropName=[' + TRANSFORM(tcPropName) + '], Value=[' + TRANSFORM(lcValue) + ']'
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_platform
		*------------------------------------------------------
		*-- Analiza el bloque <platform=>
		*------------------------------------------------------
		LPARAMETERS toReport, tcLine, taCodeLines, I, tnCodeLines, toReg

		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, X, lnPos, lnPos2, lcValue, lnLenPropName, laProps(1) ;
				, lcComment, lcMetadatos, luValor ;
				, laPropsAndValues(1,2), lnPropsAndValues_Count

			IF LOWER( LEFT(tcLine, 10) ) == 'platform="'
				llBloqueEncontrado	= .T.
				lnLastPos			= 1
				tcLine				= ' ' + tcLine

				FOR X = 1 TO AMEMBERS( laProps, toReg, 0 )
					laProps(X)	= ' ' + laProps(X)
					lnPos		= AT( LOWER(laProps(X)) + '="', tcLine )

					IF lnPos > 0
						lnLenPropName	= LEN(laProps(X))
						lnPos2			= AT( '"', SUBSTR( tcLine, lnPos + lnLenPropName + 2 ) )
						lcValue			= SUBSTR( tcLine, lnPos + lnLenPropName + 2, lnPos2 - 1 )

						ADDPROPERTY( toReg, laProps(X), lcValue )
					ENDIF
				ENDFOR

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE analizarBloque_Reportes
		*------------------------------------------------------
		*-- Analiza el bloque <reportes>
		*------------------------------------------------------
		LPARAMETERS toReport, tcLine, taCodeLines, I, tnCodeLines

		#IF .F.
			LOCAL toReport AS CL_REPORT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, lcComment, lcMetadatos, luValor ;
				, laPropsAndValues(1,2), lnPropsAndValues_Count ;
				, loReg

			IF LEFT( tcLine, LEN(C_TAG_REPORTE) + 1 ) == '<' + C_TAG_REPORTE + ''
				llBloqueEncontrado	= .T.
				loReg	= THIS.emptyRecord()

				WITH THIS
					FOR I = I + 1 TO tnCodeLines
						lcComment	= ''
						.set_Line( @tcLine, @taCodeLines, I )

						DO CASE
						CASE LEFT( tcLine, LEN(C_TAG_REPORTE_F) ) == C_TAG_REPORTE_F
							I = I + 1
							EXIT

						CASE .lineIsOnlyCommentAndNoMetadata( @tcLine, @lcComment )
							LOOP	&& Saltear comentarios

						CASE .analizarBloque_platform( toReport, @tcLine, @taCodeLines, @I, @tnCodeLines, @loReg )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'picture' )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'tag' )
							*-- ARREGLO ALGUNOS VALORES CAMBIADOS AL TEXTUALIZAR
							DO CASE
							CASE loReg.ObjType == "1"
								loReg.TAG	= THIS.decode_SpecialCodes_1_31( loReg.TAG )
							CASE loReg.ObjType == "25"
								loReg.TAG	= SUBSTR(loReg.TAG,3)	&& Quito el ENTER agregado antes
							OTHERWISE
								loReg.TAG	= THIS.decode_SpecialCodes_1_31( loReg.TAG )
							ENDCASE

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'tag2' )
							*-- ARREGLO ALGUNOS VALORES CAMBIADOS AL TEXTUALIZAR
							loReg.TAG2	= STRCONV( loReg.TAG2,14 )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'penred' )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'style' )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'expr' )

						CASE .analizarBloque_CDATA_inline( toReport, @tcLine, @taCodeLines, @I, tnCodeLines, @loReg, 'user' )

						ENDCASE

					ENDFOR
				ENDWITH && THIS

				I = I - 1
				toReport.ADD( loReg )
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_bin_a_prg AS c_conversor_base
	#IF .F.
		LOCAL THIS AS c_conversor_bin_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
		+ [<memberdata name="exception2str" type="method" display="Exception2Str"/>] ;
		+ [<memberdata name="get_add_object_methods" type="method" display="get_ADD_OBJECT_METHODS"/>] ;
		+ [<memberdata name="get_nombresobjetosolepublic" type="method" display="get_NombresObjetosOLEPublic"/>] ;
		+ [<memberdata name="get_propsfrom_protected" type="method" display="get_PropsFrom_PROTECTED"/>] ;
		+ [<memberdata name="get_propsandcommentsfrom_reserved3" type="method" display="get_PropsAndCommentsFrom_RESERVED3"/>] ;
		+ [<memberdata name="get_propsandvaluesfrom_properties" type="method" display="get_PropsAndValuesFrom_PROPERTIES"/>] ;
		+ [<memberdata name="indentarmemo" type="method" display="IndentarMemo"/>] ;
		+ [<memberdata name="memoinoneline" type="method" display="MemoInOneLine"/>] ;
		+ [<memberdata name="normalizarasignacion" type="method" display="normalizarAsignacion"/>] ;
		+ [<memberdata name="set_multilinememowithaddobjectproperties" type="method" display="set_MultilineMemoWithAddObjectProperties"/>] ;
		+ [<memberdata name="sortmethod" type="method" display="SortMethod"/>] ;
		+ [<memberdata name="write_add_objects_withproperties" type="method" display="write_ADD_OBJECTS_WithProperties"/>] ;
		+ [<memberdata name="write_all_object_methods" type="method" display="write_ALL_OBJECT_METHODS"/>] ;
		+ [<memberdata name="write_cabecera_reporte" type="method" display="write_CABECERA_REPORTE"/>] ;
		+ [<memberdata name="write_class_methods" type="method" display="write_CLASS_METHODS"/>] ;
		+ [<memberdata name="write_class_properties" type="method" display="write_CLASS_PROPERTIES"/>] ;
		+ [<memberdata name="write_dataenvironment_reporte" type="method" display="write_DATAENVIRONMENT_REPORTE"/>] ;
		+ [<memberdata name="write_dbc_header" type="method" display="write_DBC_HEADER"/>] ;
		+ [<memberdata name="write_dbc_connections" type="method" display="write_DBC_CONNECTIONS"/>] ;
		+ [<memberdata name="write_dbc_tables" type="method" display="write_DBC_TABLES"/>] ;
		+ [<memberdata name="write_dbc_views" type="method" display="write_DBC_VIEWS"/>] ;
		+ [<memberdata name="write_dbc_relations" type="method" display="write_DBC_RELATIONS"/>] ;
		+ [<memberdata name="write_dbf_header" type="method" display="write_DBF_HEADER"/>] ;
		+ [<memberdata name="write_dbf_fields" type="method" display="write_DBF_FIELDS"/>] ;
		+ [<memberdata name="write_dbf_indexes" type="method" display="write_DBF_INDEXES"/>] ;
		+ [<memberdata name="write_detalle_reporte" type="method" display="write_DETALLE_REPORTE"/>] ;
		+ [<memberdata name="write_defined_pam" type="method" display="write_DEFINED_PAM"/>] ;
		+ [<memberdata name="write_define_class" type="method" display="write_DEFINE_CLASS"/>] ;
		+ [<memberdata name="write_define_class_comments" type="method" display="write_Define_Class_COMMENTS"/>] ;
		+ [<memberdata name="write_definicionobjetosole" type="method" display="write_DefinicionObjetosOLE"/>] ;
		+ [<memberdata name="write_enddefine_sicorresponde" type="method" display="write_ENDDEFINE_SiCorresponde"/>] ;
		+ [<memberdata name="write_hidden_properties" type="method" display="write_HIDDEN_Properties"/>] ;
		+ [<memberdata name="write_include" type="method" display="write_INCLUDE"/>] ;
		+ [<memberdata name="write_metadata" type="method" display="write_METADATA"/>] ;
		+ [<memberdata name="write_program_header" type="method" display="write_PROGRAM_HEADER"/>] ;
		+ [<memberdata name="write_protected_properties" type="method" display="write_PROTECTED_Properties"/>] ;
		+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_ADD_OBJECT_METHODS
		LPARAMETERS toRegObj, toRegClass, tcMethods, taMethods, taCode, tnMethodCount

		TRY
			THIS.SortMethod( toRegObj.METHODS, @taMethods, @taCode, '', @tnMethodCount )

			*-- Ubico los métodos protegidos y les cambio la definición.
			*-- Los métodos se deben generar con la ruta completa, porque si no es imposible saber a que objeto corresponden,
			*-- o si son de la clase.
			IF tnMethodCount > 0 THEN
				FOR I = 1 TO tnMethodCount
					IF EMPTY(toRegObj.PARENT)
						tcMethodName	= toRegObj.OBJNAME + '.' + taMethods(I,1)
					ELSE
						DO CASE
						CASE '.' $ toRegObj.PARENT
							tcMethodName	= SUBSTR(toRegObj.PARENT, AT('.', toRegObj.PARENT) + 1) + '.' + toRegObj.OBJNAME + '.' + taMethods(I,1)

						CASE LEFT(toRegObj.PARENT + '.', LEN( toRegClass.OBJNAME + '.' ) ) == toRegClass.OBJNAME + '.'
							tcMethodName	= toRegObj.OBJNAME + '.' + taMethods(I,1)

						OTHERWISE
							tcMethodName	= toRegObj.PARENT + '.' + toRegObj.OBJNAME + '.' + taMethods(I,1)

						ENDCASE
					ENDIF

					*-- Genero el método SIN indentar, ya que se hace luego
					*tcMethods2	= tcMethods
					*TEXT TO tcMethods2 ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					*	<<'PROCEDURE'>> <<tcMethodName>>
					*	<<THIS.IndentarMemo( taCode(taMethods(I,2)) )>>
					*	<<'ENDPROC'>>
					*ENDTEXT
					*-- Sustituyo el TEXT/ENDTEXT aquí porque a veces quita espacios de la derecha, y eso es peligroso
					tcMethods	= tcMethods + CR_LF + 'PROCEDURE ' + tcMethodName
					tcMethods	= tcMethods + CR_LF + THIS.IndentarMemo( taCode(taMethods(I,2)) )
					tcMethods	= tcMethods + CR_LF + 'ENDPROC'
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_NombresObjetosOLEPublic
		LPARAMETERS ta_NombresObjsOle
		*-- Obtengo los objetos "OLEPublic"
		SELECT PADR(OBJNAME,100) OBJNAME ;
			FROM TABLABIN ;
			WHERE TABLABIN.PLATFORM = "COMMENT" AND TABLABIN.RESERVED2 == "OLEPublic" ;
			ORDER BY 1 ;
			INTO ARRAY ta_NombresObjsOle
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_PropsAndCommentsFrom_RESERVED3
		*-- Sirve para el memo RESERVED3
		*---------------------------------------------------------------------------------------------------
		* PARÁMETROS:				!=Obligatorio, ?=Opcional, @=Pasar por referencia, v=Pasar por valor (IN/OUT)
		* tcMemo					(v! IN    ) Contenido de un campo MEMO
		* tlSort					(v? IN    ) Indica si se deben ordenar alfabéticamente los nombres
		* taPropsAndComments		(@!    OUT) Array con las propiedades y comentarios
		* tnPropsAndComments_Count	(@!    OUT) Cantidad de propiedades
		* tcSortedMemo				(@?    OUT) Contenido del campo memo ordenado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcMemo, tlSort, taPropsAndComments, tnPropsAndComments_Count, tcSortedMemo
		EXTERNAL ARRAY taPropsAndComments

		TRY
			LOCAL laLines(1), I, lnPos, loEx AS EXCEPTION
			tcSortedMemo	= ''
			tnPropsAndComments_Count	= ALINES(laLines, tcMemo, 1+4)

			IF tnPropsAndComments_Count <= 1 AND EMPTY(laLines)
				tnPropsAndComments_Count	= 0
				EXIT
			ENDIF

			DIMENSION taPropsAndComments(tnPropsAndComments_Count,2)

			FOR I = 1 TO tnPropsAndComments_Count
				lnPos			= AT(' ', laLines(I))	&& Un espacio separa la propiedad de su comentario (si tiene)

				IF lnPos = 0
					taPropsAndComments(I,1)	= laLines(I)
					taPropsAndComments(I,2)	= ''
				ELSE
					taPropsAndComments(I,1)	= LEFT( laLines(I), lnPos - 1 )
					taPropsAndComments(I,2)	= SUBSTR( laLines(I), lnPos + 1 )
				ENDIF
			ENDFOR

			IF tlSort AND THIS.l_PropSort_Enabled
				ASORT( taPropsAndComments, 1, -1, 0, 1 )
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_PropsAndValuesFrom_PROPERTIES
		*-- Sirve para el memo PROPERTIES
		*---------------------------------------------------------------------------------------------------
		* KNOWLEDGE BASE:
		* 29/11/2013	FDBOZZO		En un pageframe, si las props.nativas del mismo no están antes que las de
		*							los objetos contenidos, causa un error. Se deben ordenar primero las
		*							props.nativas (sin punto) y luego las de los objetos (con punto)
		*
		*---------------------------------------------------------------------------------------------------
		* PARÁMETROS:				!=Obligatorio, ?=Opcional, @=Pasar por referencia, v=Pasar por valor (IN/OUT)
		* tcMemo					(v! IN    ) Contenido de un campo MEMO
		* tnSort					(v? IN    ) Indica si se deben ordenar alfabéticamente los objetos y props (1), o no (0)
		* taPropsAndValues			(@!    OUT) Array con las propiedades y comentarios
		* tnPropsAndValues_Count	(@!    OUT) Cantidad de propiedades
		* tcSortedMemo				(@?    OUT) Contenido del campo memo ordenado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcMemo, tnSort, taPropsAndValues, tnPropsAndValues_Count, tcSortedMemo
		EXTERNAL ARRAY taPropsAndValues
		TRY
			LOCAL laItems(1), I, X, lnLenAcum, lnPosEQ, lcPropName, lnLenVal, lcValue, lcMethods
			tcSortedMemo			= ''
			tnPropsAndValues_Count	= 0

			IF NOT EMPTY(m.tcMemo)
				lnItemCount = ALINES(laItems, m.tcMemo, 0, CR_LF)	&& Específicamente CR+LF para que no reconozca los CR o LF por separado
				X	= 0

				IF lnItemCount <= 1 AND EMPTY(laItems)
					lnItemCount	= 0
					EXIT
				ENDIF


				*-- 1) OBTENCIÓN Y SEPARACIÓN DE PROPIEDADES Y VALORES
				*-- Crear un array con los valores especiales que pueden estar repartidos entre varias lineas
				FOR I = 1 TO m.lnItemCount
					IF EMPTY( laItems(I) )
						LOOP
					ENDIF

					X	= X + 1
					DIMENSION taPropsAndValues(X,2)

					IF C_MPROPHEADER $ laItems(I)
						*-- Solo entrará por aquí cuando se evalúe una propiedad de PROPERTIES con un valor especial (largo)
						lnLenAcum	= 0
						lnPosEQ		= AT( '=', laItems(I) )
						lcPropName	= LEFT( laItems(I), lnPosEQ - 2 )
						lnLenVal	= INT( VAL( SUBSTR( laItems(I), lnPosEQ + 2 + 517, 8) ) )
						lcValue		= SUBSTR( laItems(I), lnPosEQ + 2 + 517 + 8 )

						IF LEN( lcValue ) < lnLenVal
							*-- Como el valor es multi-línea, debo agregarle los CR_LF que le quitó el ALINES()
							FOR I = I + 1 TO m.lnItemCount
								lcValue	= lcValue + CR_LF + laItems(I)

								IF LEN( lcValue ) >= lnLenVal
									EXIT
								ENDIF
							ENDFOR

							lcValue	= C_FB2P_VALUE_I + CR_LF + lcValue + CR_LF + C_FB2P_VALUE_F
						ELSE
							lcValue	= C_FB2P_VALUE_I + lcValue + C_FB2P_VALUE_F
						ENDIF

						*-- Es un valor especial, por lo que se encapsula en un marcador especial
						taPropsAndValues(X,1)	= lcPropName
						taPropsAndValues(X,2)	= THIS.normalizarValorPropiedad( lcPropName, lcValue, '' )

					ELSE
						*-- Propiedad normal
						*-- SI HACE FALTA QUE LOS MÉTODOS ESTÉN AL FINAL, DESCOMENTAR ESTO (Y EL DE MÁS ABAJO)
						*IF LEFT(laItems(I), 1) == '*'	&& Only Reserved3 have this
						*	LOOP
						*ENDIF

						lnPosEQ					= AT( '=', laItems(I) )
						taPropsAndValues(X,1)	= LEFT( laItems(I), lnPosEQ - 2 )
						taPropsAndValues(X,2)	=  THIS.normalizarValorPropiedad( taPropsAndValues(X,1), LTRIM( SUBSTR( laItems(I), lnPosEQ + 2 ) ), '' )
					ENDIF
				ENDFOR


				tnPropsAndValues_Count	= X
				lcMethods	= ''


				*-- 2) SORT
				THIS.sortPropsAndValues( @taPropsAndValues, tnPropsAndValues_Count, tnSort )


				*-- Agregar propiedades primero
				FOR I = 1 TO m.tnPropsAndValues_Count
					*-- SI HACE FALTA QUE LOS MÉTODOS ESTÉN AL FINAL, DESCOMENTAR ESTO (Y EL DE MÁS ARRIBA)
					*IF LEFT(taPropsAndValues(I), 1) == '*'	&& Only Reserved3 have this
					*	lcMethods	= m.lcMethods + m.taPropsAndValues(I,1) + ' = ' + m.taPropsAndValues(I,2) + CR_LF
					*	LOOP
					*ENDIF

					tcSortedMemo	= m.tcSortedMemo + m.taPropsAndValues(I,1) + ' = ' + m.taPropsAndValues(I,2) + CR_LF
				ENDFOR

				*-- Agregar métodos al final
				tcSortedMemo	= m.tcSortedMemo + m.lcMethods

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_PropsFrom_PROTECTED
		*-- Sirve para el memo PROTECTED
		*---------------------------------------------------------------------------------------------------
		* PARÁMETROS:				!=Obligatorio, ?=Opcional, @=Pasar por referencia, v=Pasar por valor (IN/OUT)
		* tcMemo					(v! IN    ) Contenido de un campo MEMO
		* tlSort					(v? IN    ) Indica si se deben ordenar alfabéticamente los nombres
		* taProtected				(@!    OUT) Array con las propiedades y comentarios
		* tnProtected_Count			(@!    OUT) Cantidad de propiedades
		* tcSortedMemo				(@?    OUT) Contenido del campo memo ordenado
		*---------------------------------------------------------------------------------------------------
		LPARAMETERS tcMemo, tlSort, taProtected, tnProtected_Count, tcSortedMemo
		EXTERNAL ARRAY taProtected

		tcSortedMemo		= ''
		tnProtected_Count	= ALINES(taProtected, tcMemo, 1+4)

		IF tnProtected_Count <= 1 AND EMPTY(taProtected)
			tnProtected_Count	= 0
		ELSE
			IF tlSort AND THIS.l_PropSort_Enabled
				ASORT( taProtected, 1, -1, 0, 1 )
			ENDIF

			FOR I = 1 TO tnProtected_Count
				tcSortedMemo	= tcSortedMemo + taProtected(I) + CR_LF
			ENDFOR
		ENDIF

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE IndentarMemo
		LPARAMETERS tcMethod, tcIndentation
		*-- INDENTA EL CÓDIGO DE UN MÉTODO DADO Y QUITA LA CABECERA DE MÉTODO (PROCEDURE/ENDPROC) SI LA ENCUENTRA
		TRY
			LOCAL I, X, lcMethod, llProcedure, lnInicio, lnFin, laLineas(1)
			lcMethod		= ''
			llProcedure		= ( LEFT(tcMethod,10) == 'PROCEDURE ' ;
				OR LEFT(tcMethod,17) == 'HIDDEN PROCEDURE ' ;
				OR LEFT(tcMethod,20) == 'PROTECTED PROCEDURE ' )
			lnInicio		= 1
			lnFin			= ALINES(laLineas, tcMethod)
			IF VARTYPE(tcIndentation) # 'C'
				tcIndentation	= ''
			ENDIF

			*-- Quito las líneas en blanco luego del final del ENDPROC
			X	= 0
			FOR I = lnFin TO 1 STEP -1
				IF NOT EMPTY(laLineas(I))	&& Última línea de código
					IF LEFT( laLineas(I), 10 ) <> C_ENDPROC
						ERROR 'Procedimiento sin cerrar. La última línea de código debe ser ENDPROC. [' + laLineas(1) + ']'
					ENDIF
					EXIT
				ENDIF
				X	= X + 1
			ENDFOR

			IF X > 0
				lnFin	= lnFin - X
				DIMENSION laLineas(lnFin)
			ENDIF


			*-- Si encuentra la cabecera de un PROCEDURE, la saltea
			IF llProcedure
				lnInicio	= 2
				lnFin		= lnFin - 1
			ENDIF

			FOR I = lnInicio TO lnFin
				*-- TEXT/ENDTEXT aquí da error 2044 de recursividad. No usar.
				lcMethod	= lcMethod + CR_LF + tcIndentation + laLineas(I)
			ENDFOR

			lcMethod	= SUBSTR(lcMethod,3)	&& Quito el primer ENTER (CR+LF)

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN lcMethod
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE MemoInOneLine( tcMethod )
		TRY
			LOCAL lcLine, I
			lcLine	= ''

			IF NOT EMPTY(tcMethod)
				FOR I = 1 TO ALINES(laLines, m.tcMethod, 0)
					lcLine	= lcLine + ', ' + laLines(I)
				ENDFOR

				lcLine	= SUBSTR(lcLine, 3)
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN lcLine
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE set_MultilineMemoWithAddObjectProperties
		LPARAMETERS taPropsAndValues, tnPropCount, tcLeftIndentation, tlNormalizeLine
		EXTERNAL ARRAY taPropsAndValues

		TRY
			LOCAL lcLine, I, lcComentarios, laLines(1), lcFinDeLinea_Coma_PuntoComa_CR
			lcLine			= ''
			lcFinDeLinea	= ', ;' + CR_LF

			IF tnPropCount > 0
				IF VARTYPE(tcLeftIndentation) # 'C'
					tcLeftIndentation	= ''
				ENDIF

				FOR I = 1 TO tnPropCount
					lcLine			= lcLine + tcLeftIndentation + taPropsAndValues(I,1) + ' = ' + taPropsAndValues(I,2) + lcFinDeLinea
				ENDFOR

				*-- Quito el ", ;<CRLF>" final
				lcLine	= tcLeftIndentation + SUBSTR(lcLine, 1 + LEN(tcLeftIndentation), LEN(lcLine) - LEN(tcLeftIndentation) - LEN(lcFinDeLinea))
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN lcLine
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE SortMethod
		LPARAMETERS tcMethod, taMethods, taCode, tcSorted, tnMethodCount
		*-- 29/10/2013	Fernando D. Bozzo
		*-- Se tiene en cuenta la posibilidad de que haya un PROC/ENDPROC dentro de un TEXT/ENDTEXT
		*-- cuando es usado en un generador de código o similar.
		EXTERNAL ARRAY taMethods, taCode

		*-- ESTRUCTURA DE LOS ARRAYS CREADOS:
		*-- taMethods[1,3]
		*--		Nombre Método
		*--		Posición Original
		*--		Tipo (HIDDEN/PROTECTED/NORMAL)
		*-- taCode[1]
		*--		Bloque de código del método en su posición original
		TRY
			LOCAL lnLineCount, laLine(1), I, lnTextNodes, tcSorted
			LOCAL loEx AS EXCEPTION
			DIMENSION taMethods(1,3)
			STORE '' TO taMethods, m.tcSorted, taCode
			tnMethodCount	= 0

			IF NOT EMPTY(m.tcMethod) AND LEFT(m.tcMethod,9) == "ENDPROC"+CHR(13)+CHR(10)
				tcMethod	= SUBSTR(m.tcMethod,10)
			ENDIF

			IF NOT EMPTY(m.tcMethod)
				DIMENSION laLine(1), taMethods(1,3)
				STORE '' TO laLine, taMethods, taCode
				STORE 0 TO tnMethodCount, lnTextNodes
				lnLineCount	= ALINES(laLine, m.tcMethod)	&& NO aplicar nungún formato ni limpieza, que es el CÓDIGO FUENTE

				*-- Delete beginning empty lines before first "PROCEDURE", that is the first not empty line.
				FOR I = 1 TO lnLineCount
					IF NOT EMPTY(laLine(I))
						IF I > 1
							FOR X = I-1 TO 1 STEP -1
								ADEL(laLine, X)
							ENDFOR
							lnLineCount	= lnLineCount - I + 1
							DIMENSION laLine(lnLineCount)
						ENDIF
						EXIT
					ENDIF
				ENDFOR

				*-- Delete ending empty lines after last "ENDPROC", that is the last not empty line.
				FOR I = lnLineCount TO 1 STEP -1
					IF EMPTY(laLine(I))
						ADEL(laLine, I)
					ELSE
						IF I < lnLineCount
							lnLineCount	= I
							DIMENSION laLine(lnLineCount)
						ENDIF
						EXIT
					ENDIF
				ENDFOR

				*-- Analyze and count line methods, get method names and consolidate block code
				FOR I = 1 TO lnLineCount
					DO CASE
					CASE LEFT(laLine(I), 4) == C_TEXT
						lnTextNodes	= lnTextNodes + 1
						taCode(tnMethodCount)	= taCode(tnMethodCount) + laLine(I) + CR_LF

					CASE LEFT(laLine(I), 7) == C_ENDTEXT
						lnTextNodes	= lnTextNodes - 1
						taCode(tnMethodCount)	= taCode(tnMethodCount) + laLine(I) + CR_LF

					CASE lnTextNodes = 0 AND LEFT(laLine(I), 10) == 'PROCEDURE '
						tnMethodCount	= tnMethodCount + 1
						DIMENSION taMethods(tnMethodCount, 3), taCode(tnMethodCount)
						taMethods(tnMethodCount, 1)	= RTRIM( SUBSTR(laLine(I), 11) )
						taMethods(tnMethodCount, 2)	= tnMethodCount
						taMethods(tnMethodCount, 3)	= ''
						taCode(tnMethodCount)		= laLine(I) + CR_LF

					CASE lnTextNodes = 0 AND LEFT(laLine(I), 17) == 'HIDDEN PROCEDURE '
						tnMethodCount	= tnMethodCount + 1
						DIMENSION taMethods(tnMethodCount, 3), taCode(tnMethodCount)
						taMethods(tnMethodCount, 1)	= RTRIM( SUBSTR(laLine(I), 18) )
						taMethods(tnMethodCount, 2)	= tnMethodCount
						taMethods(tnMethodCount, 3)	= 'HIDDEN '
						taCode(tnMethodCount)		= laLine(I) + CR_LF

					CASE lnTextNodes = 0 AND LEFT(laLine(I), 20) == 'PROTECTED PROCEDURE '
						tnMethodCount	= tnMethodCount + 1
						DIMENSION taMethods(tnMethodCount, 3), taCode(tnMethodCount)
						taMethods(tnMethodCount, 1)	= RTRIM( SUBSTR(laLine(I), 21) )
						taMethods(tnMethodCount, 2)	= tnMethodCount
						taMethods(tnMethodCount, 3)	= 'PROTECTED '
						taCode(tnMethodCount)		= laLine(I) + CR_LF

					CASE lnTextNodes = 0 AND LEFT(laLine(I), 7) == 'ENDPROC'
						taCode(tnMethodCount)	= taCode(tnMethodCount) + laLine(I) + CR_LF

					CASE tnMethodCount = 0	&& Skip empty lines before methods begin

					OTHERWISE && Method Code
						taCode(tnMethodCount)	= taCode(tnMethodCount) + laLine(I) + CR_LF

					ENDCASE
				ENDFOR

				*-- Alphabetical ordering of methods
				IF THIS.l_MethodSort_Enabled
					ASORT(taMethods,1,-1,0,1)
				ENDIF

				FOR I = 1 TO tnMethodCount
					m.tcSorted	= m.tcSorted + taCode(taMethods(I,2))
				ENDFOR

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC	&& SordMethod


	*******************************************************************************************************************
	PROCEDURE write_ADD_OBJECTS_WithProperties
		LPARAMETERS toRegObj

		#IF .F.
			LOCAL toRegObj AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lcMemo, laPropsAndValues(1,2), lnPropsAndValues_Count

			*-- Defino los objetos a cargar
			THIS.get_PropsAndValuesFrom_PROPERTIES( toRegObj.PROPERTIES, 1, @laPropsAndValues, @lnPropsAndValues_Count, @lcMemo )
			*lcMemo	= THIS.set_MultilineMemoWithAddObjectProperties( lcMemo, C_TAB + C_TAB, .T. )
			lcMemo	= THIS.set_MultilineMemoWithAddObjectProperties( @laPropsAndValues, @lnPropsAndValues_Count, C_TAB + C_TAB, .T. )

			IF '.' $ toRegObj.PARENT
				*-- Este caso: clase.objeto.objeto ==> se quita clase
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>>ADD OBJECT '<<SUBSTR(toRegObj.Parent, AT('.', toRegObj.Parent)+1)>>.<<toRegObj.objName>>' AS <<ALLTRIM(toRegObj.Class)>> <<>>
				ENDTEXT
			ELSE
				*-- Este caso: objeto
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>>ADD OBJECT '<<toRegObj.objName>>' AS <<ALLTRIM(toRegObj.Class)>> <<>>
				ENDTEXT
			ENDIF

			IF NOT EMPTY(lcMemo)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					WITH ;
					<<lcMemo>>
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB + C_TAB>><<C_END_OBJECT_I>> <<>>
			ENDTEXT

			IF NOT EMPTY(toRegObj.CLASSLOC)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					ClassLib="<<toRegObj.ClassLoc>>" <<>>
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
				BaseClass="<<toRegObj.Baseclass>>" UniqueID="<<toRegObj.Uniqueid>>"
				Timestamp="<<THIS.getTimeStamp(toRegObj.Timestamp)>>" ZOrder="<<TRANSFORM(toRegObj._ZOrder)>>" <<>>
			ENDTEXT

			*-- Agrego metainformación para objetos OLE
			IF toRegObj.BASECLASS == 'olecontrol'
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					OLEObject="<<STREXTRACT(toRegObj.ole2, 'OLEObject = ', CHR(13)+CHR(10), 1, 1+2)>>" CheckSum="<<SYS(2007, toRegObj.ole, 0, 1)>>" <<>>
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<<C_END_OBJECT_F>>

			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_ALL_OBJECT_METHODS
		LPARAMETERS tcMethods

		*-- Finalmente, todos los métodos los ordeno y escribo juntos
		LOCAL laMethods(1), laCode(1), lnMethodCount, I, lcMethods, lcMethods2

		IF NOT EMPTY(tcMethods)
			STORE '' TO lcMethods, lcMethods2
			DIMENSION laMethods(1,3)
			THIS.SortMethod( @tcMethods, @laMethods, @laCode, '', @lnMethodCount )

			FOR I = 1 TO lnMethodCount
				*-- Genero los métodos indentados
				*TEXT TO lcMethods2 ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				*	<<C_TAB>><<laMethods(I,3)>>PROCEDURE <<laMethods(I,1)>>
				*	<<THIS.IndentarMemo( laCode(laMethods(I,2)), CHR(9) + CHR(9) )>>
				*	<<C_TAB>>ENDPROC

				*ENDTEXT
				*-- Sustituyo el TEXT/ENDTEXT aquí porque a veces quita espacios de la derecha, y eso es peligroso
				lcMethods	= lcMethods + CR_LF + C_TAB + laMethods(I,3) + C_PROCEDURE + ' ' + laMethods(I,1)
				lcMethods	= lcMethods + CR_LF + THIS.IndentarMemo( laCode(laMethods(I,2)), CHR(9) + CHR(9) )
				lcMethods	= lcMethods + CR_LF + C_TAB + C_ENDPROC
				lcMethods	= lcMethods + CR_LF
			ENDFOR

			C_FB2PRG_CODE	= C_FB2PRG_CODE + lcMethods
		ENDIF

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_CLASS_METHODS
		LPARAMETERS tnMethodCount, taMethods, taCode, taProtected, taPropsAndComments
		*-- DEFINIR MÉTODOS DE LA CLASE
		*-- Ubico los métodos protegidos y les cambio la definición
		EXTERNAL ARRAY taMethods, taCode, taProtected, taPropsAndComments

		TRY
			LOCAL lcMethod, lnProtectedItem, lnCommentRow, lcProcDef, lcMethods, lcMethods2
			STORE '' TO lcMethod, lcProcDef, lcMethods, lcMethods2

			IF tnMethodCount > 0 THEN
				FOR I = 1 TO tnMethodCount
					lcMethod			= CHRTRAN( taMethods(I,1), '^', '' )
					lnProtectedItem		= ASCAN( taProtected, taMethods(I,1), 1, 0, 0, 0)
					lnCommentRow		= ASCAN( taPropsAndComments, '*' + lcMethod, 1, 0, 1, 8)

					DO CASE
					CASE lnProtectedItem = 0
						*-- Método común
						lcProcDef	= 'PROCEDURE'

					CASE taProtected(lnProtectedItem) == taMethods(I,1)
						*-- Método protegido
						lcProcDef	= 'PROTECTED PROCEDURE'

					CASE taProtected(lnProtectedItem) == taMethods(I,1) + '^'
						*-- Método oculto
						lcProcDef	= 'HIDDEN PROCEDURE'

					ENDCASE

					*-- Nombre del método
					TEXT TO lcMethods ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<C_TAB>><<lcProcDef>> <<taMethods(I,1)>>
					ENDTEXT

					*-- Comentarios del método (si tiene)
					IF lnCommentRow > 0 AND NOT EMPTY(taPropsAndComments(lnCommentRow,2))
						TEXT TO lcMethods ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
							<<C_TAB>><<C_TAB>>&& <<taPropsAndComments(lnCommentRow,2)>>
						ENDTEXT
					ENDIF

					*-- Código del método
					*TEXT TO lcMethods2 ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					*	<<THIS.IndentarMemo( taCode(taMethods(I,2)), CHR(9) + CHR(9) )>>
					*	<<C_TAB>>ENDPROC

					*ENDTEXT
					*-- Sustituyo el TEXT/ENDTEXT aquí porque a veces quita espacios de la derecha, y eso es peligroso
					lcMethods	= lcMethods + CR_LF + THIS.IndentarMemo( taCode(taMethods(I,2)), C_TAB + C_TAB )
					lcMethods	= lcMethods + CR_LF + C_TAB + 'ENDPROC'
					lcMethods	= lcMethods + CR_LF
				ENDFOR

				*TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				*	<<lcMethods>>
				*ENDTEXT
				C_FB2PRG_CODE	= C_FB2PRG_CODE + C_TAB + lcMethods &&+ CR_LF

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_CLASS_PROPERTIES
		LPARAMETERS toRegClass, taPropsAndValues, taPropsAndComments, taProtected

		EXTERNAL ARRAY taPropsAndValues, taPropsAndComments

		TRY
			LOCAL lnPropsAndValues_Count, lcHiddenProp, lcProtectedProp, lcPropsMethodsDefd, lnPropsAndComments_Count, I ;
				, lcPropName, lnProtectedItem, lcComentarios

			WITH THIS
				*-- DEFINIR PROPIEDADES ( HIDDEN, PROTECTED, *DEFINED_PAM )
				DIMENSION taProtected(1)
				STORE '' TO lcHiddenProp, lcProtectedProp, lcPropsMethodsDefd
				THIS.get_PropsAndValuesFrom_PROPERTIES( toRegClass.PROPERTIES, 1, @taPropsAndValues, @lnPropsAndValues_Count, '' )
				THIS.get_PropsAndCommentsFrom_RESERVED3( toRegClass.RESERVED3, .T., @taPropsAndComments, @lnPropsAndComments_Count, '' )
				THIS.get_PropsFrom_PROTECTED( toRegClass.PROTECTED, .T., @taProtected, 0, '' )

				IF lnPropsAndValues_Count > 0 THEN
					*-- Recorro las propiedades (campo Properties) para ir conformando
					*-- las definiciones HIDDEN y PROTECTED
					FOR I = 1 TO lnPropsAndValues_Count
						IF EMPTY(taPropsAndValues(I,1))
							LOOP
						ENDIF

						lnProtectedItem	= ASCAN(taProtected, taPropsAndValues(I,1), 1, 0, 0, 0)

						DO CASE
						CASE lnProtectedItem = 0
							*-- Propiedad común

						CASE taProtected(lnProtectedItem) == taPropsAndValues(I,1)
							*-- Propiedad protegida
							lcProtectedProp	= lcProtectedProp + ',' + taPropsAndValues(I,1)

						CASE taProtected(lnProtectedItem) == taPropsAndValues(I,1) + '^'
							*-- Propiedad oculta
							lcHiddenProp	= lcHiddenProp + ',' + taPropsAndValues(I,1)

						ENDCASE
					ENDFOR

					THIS.write_DEFINED_PAM( @taPropsAndComments, lnPropsAndComments_Count )

					THIS.write_HIDDEN_Properties( @lcHiddenProp )

					THIS.write_PROTECTED_Properties( @lcProtectedProp )

					*-- Escribo las propiedades de la clase y sus comentarios (los comentarios aquí son redundantes)
					FOR I = 1 TO ALEN(taPropsAndValues, 1)
						TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<C_TAB>><<taPropsAndValues(I,1)>> = <<taPropsAndValues(I,2)>>
						ENDTEXT

						lnComment	= ASCAN( taPropsAndComments, taPropsAndValues(I,1), 1, 0, 1, 8)

						IF lnComment > 0 AND NOT EMPTY(taPropsAndComments(lnComment,2))
							TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
							<<C_TAB>><<C_TAB>>&& <<taPropsAndComments(lnComment,2)>>
							ENDTEXT
						ENDIF
					ENDFOR

					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2

					ENDTEXT
				ENDIF
			ENDWITH && THIS

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DEFINED_PAM
		*-- Escribo propiedades DEFINED (Reserved3) en este formato:

		*<DefinedPropArrayMethod>
		*m: *metodovacio_con_comentarios		&& Este método no tiene código, pero tiene comentarios. A ver que pasa!
		*m: *mimetodo		&& Mi metodo
		*p: prop1		&& Mi prop 1
		*p: prop_especial_cr		&&
		*a: ^array_1_d[1,0]		&& Array 1 dimensión (1)
		*a: ^array_2_d[1,2]		&& Array una dimension (1,2)
		*p: _memberdata		&& XML Metadata for customizable properties
		*</DefinedPropArrayMethod>

		LPARAMETERS taPropsAndComments, tnPropsAndComments_Count

		IF tnPropsAndComments_Count > 0
			LOCAL I, lcPropsMethodsDefd
			lcPropsMethodsDefd	= ''

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>><<C_DEFINED_PAM_I>>
			ENDTEXT

			FOR I = 1 TO tnPropsAndComments_Count
				IF EMPTY(taPropsAndComments(I,1))
					LOOP
				ENDIF

				lcType	= LEFT( taPropsAndComments(I,1), 1 )
				lcType	= ICASE( lcType == '*', 'm' ;
					, lcType == '^', 'a' ;
					, 'p' )

				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>><<C_TAB>>*<<lcType>>: <<taPropsAndComments(I,1)>>
				ENDTEXT

				IF NOT EMPTY(taPropsAndComments(I,2))
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
						<<C_TAB>><<C_TAB>><<'&'>><<'&'>> <<taPropsAndComments(I,2)>>
					ENDTEXT
				ENDIF
			ENDFOR

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
			<<C_TAB>><<C_DEFINED_PAM_F>>
			ENDTEXT

		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DEFINE_CLASS
		LPARAMETERS ta_NombresObjsOle, toRegClass

		LOCAL lcOF_Classlib, llOleObject
		lcOF_Classlib	= ''
		llOleObject		= ( ASCAN( ta_NombresObjsOle, toRegClass.OBJNAME, 1, 0, 1, 8) > 0 )

		IF NOT EMPTY(toRegClass.CLASSLOC)
			lcOF_Classlib	= 'OF "' + ALLTRIM(toRegClass.CLASSLOC) + '" '
		ENDIF

		*-- DEFINICIÓN DE LA CLASE ( DEFINE CLASS 'className' AS 'classType' [OF 'classLib'] [OLEPUBLIC] )
		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
			<<'DEFINE CLASS'>> <<ALLTRIM(toRegClass.ObjName)>> AS <<ALLTRIM(toRegClass.Class)>> <<lcOF_Classlib + IIF(llOleObject, 'OLEPUBLIC', '')>>
		ENDTEXT

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DEFINE_CLASS_COMMENTS
		LPARAMETERS toRegClass
		*-- Comentario de la clase
		IF NOT EMPTY(toRegClass.RESERVED7) THEN
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<<C_TAB>><<C_TAB>><<'&'+'&'>> <<toRegClass.Reserved7>>
			ENDTEXT
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_ENDDEFINE_SiCorresponde
		LPARAMETERS tnLastClass
		IF tnLastClass = 1
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<'ENDDEFINE'>>

			ENDTEXT
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_INCLUDE
		LPARAMETERS toReg
		*-- #INCLUDE
		IF NOT EMPTY(toReg.RESERVED8) THEN
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>>#INCLUDE "<<toReg.Reserved8>>"
			ENDTEXT
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_METADATA
		LPARAMETERS toRegClass

		*-- Agrego Metadatos de la clase (Baseclass, Timestamp, Scale, Uniqueid)
		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2

		ENDTEXT

		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+8
			<<C_TAB>><<C_METADATA_I>>
			Baseclass="<<toRegClass.Baseclass>>"
			Timestamp="<<THIS.getTimeStamp(toRegClass.Timestamp)>>"
			Scale="<<toRegClass.Reserved6>>"
			Uniqueid="<<EVL(toRegClass.Uniqueid,SYS(2015))>>"
		ENDTEXT

		IF NOT EMPTY(toRegClass.OLE2)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+4+8
				OLEObject="<<STREXTRACT(toRegClass.ole2, 'OLEObject = ', CHR(13)+CHR(10), 1, 1+2)>>" CheckSum="<<SYS(2007, toRegClass.ole, 0, 1)>>" <<>>
			ENDTEXT
		ENDIF

		IF NOT EMPTY(toRegClass.RESERVED5)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+4+8
				ProjectClassIcon="<<toRegClass.Reserved5>>"
			ENDTEXT
		ENDIF

		IF NOT EMPTY(toRegClass.RESERVED4)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+4+8
				ClassIcon="<<toRegClass.Reserved4>>"
			ENDTEXT
		ENDIF

		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+4+8
			<<C_METADATA_F>>
		ENDTEXT
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_HIDDEN_Properties
		*-- Escribo la definición HIDDEN de propiedades
		LPARAMETERS tcHiddenProp

		IF NOT EMPTY(tcHiddenProp)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
			<<C_TAB>>HIDDEN <<SUBSTR(tcHiddenProp,2)>>
			ENDTEXT
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_PROGRAM_HEADER
		*-- Cabecera del PRG e inicio de DEF_CLASS
		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
			*--------------------------------------------------------------------------------------------------------------------------------------------------------
			* (ES) AUTOGENERADO - ¡¡ATENCIÓN!! - ¡¡NO PENSADO PARA EJECUTAR!! USAR SOLAMENTE PARA INTEGRAR CAMBIOS Y ALMACENAR CON HERRAMIENTAS SCM!!
			* (EN) AUTOGENERATED - ATTENTION!! - NOT INTENDED FOR EXECUTION!! USE ONLY FOR MERGING CHANGES AND STORING WITH SCM TOOLS!!
			*--------------------------------------------------------------------------------------------------------------------------------------------------------
			<<C_FB2PRG_META_I>> Version="<<TRANSFORM(THIS.n_FB2PRG_Version)>>" SourceFile="<<THIS.c_InputFile>>" Generated="<<TTOC(DATETIME())>>" <<C_FB2PRG_META_F>> (Para uso con Visual FoxPro 9.0)
			*
		ENDTEXT
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_PROTECTED_Properties
		*-- Escribo la definición PROTECTED de propiedades
		LPARAMETERS tcProtectedProp

		IF NOT EMPTY(tcProtectedProp)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
			<<C_TAB>>PROTECTED <<SUBSTR(tcProtectedProp,2)>>
			ENDTEXT
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_CABECERA_REPORTE
		LPARAMETERS toReg

		TRY
			LOCAL lc_TAG_REPORTE, loEx as Exception
			lc_TAG_REPORTE_I	= '<' + C_TAG_REPORTE + ' '
			lc_TAG_REPORTE_F	= '</' + C_TAG_REPORTE + '>'

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_I>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>>platform="WINDOWS " uniqueid="<<EVL(toReg.UniqueID,SYS(2015))>>" timestamp="<<toReg.TimeStamp>>" objtype="<<toReg.ObjType>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				objcode="<<toReg.ObjCode>>" name="<<toReg.Name>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				vpos="<<toReg.vpos>>" hpos="<<toReg.hpos>>" height="<<toReg.height>>" width="<<toReg.width>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				order="<<toReg.order>>" unique="<<toReg.unique>>" comment="<<toReg.comment>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				environ="<<toReg.environ>>" boxchar="<<toReg.boxchar>>" fillchar="<<toReg.fillchar>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				pengreen="<<toReg.pengreen>>" penblue="<<toReg.penblue>>" fillred="<<toReg.fillred>>" fillgreen="<<toReg.fillgreen>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fillblue="<<toReg.fillblue>>" pensize="<<toReg.pensize>>" penpat="<<toReg.penpat>>" fillpat="<<toReg.fillpat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fontface="<<toReg.fontface>>" fontstyle="<<toReg.fontstyle>>" fontsize="<<toReg.fontsize>>" mode="<<toReg.mode>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				ruler="<<toReg.ruler>>" rulerlines="<<toReg.rulerlines>>" grid="<<toReg.grid>>" gridv="<<toReg.gridv>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				gridh="<<toReg.gridh>>" float="<<toReg.float>>" stretch="<<toReg.stretch>>" stretchtop="<<toReg.stretchtop>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				top="<<toReg.top>>" bottom="<<toReg.bottom>>" suptype="<<toReg.suptype>>" suprest="<<toReg.suprest>>" norepeat="<<toReg.norepeat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				resetrpt="<<toReg.resetrpt>>" pagebreak="<<toReg.pagebreak>>" colbreak="<<toReg.colbreak>>" resetpage="<<toReg.resetpage>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				general="<<toReg.general>>" spacing="<<toReg.spacing>>" double="<<toReg.double>>" swapheader="<<toReg.swapheader>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				swapfooter="<<toReg.swapfooter>>" ejectbefor="<<toReg.ejectbefor>>" ejectafter="<<toReg.ejectafter>>" plain="<<toReg.plain>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				summary="<<toReg.summary>>" addalias="<<toReg.addalias>>" offset="<<toReg.offset>>" topmargin="<<toReg.topmargin>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				botmargin="<<toReg.botmargin>>" totaltype="<<toReg.totaltype>>" resettotal="<<toReg.resettotal>>" resoid="<<toReg.resoid>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				curpos="<<toReg.curpos>>" supalways="<<toReg.supalways>>" supovflow="<<toReg.supovflow>>" suprpcol="<<toReg.suprpcol>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				supgroup="<<toReg.supgroup>>" supvalchng="<<toReg.supvalchng>>" supexpr="<<toReg.supexpr>>" >
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>><picture><![CDATA[<<toReg.picture>>]]>
				<<C_TAB>><tag><![CDATA[<<THIS.encode_SpecialCodes_1_31( toReg.tag )>>]]>
				<<C_TAB>><tag2><![CDATA[<<STRCONV( toReg.tag2,13 )>>]]>
				<<C_TAB>><penred><![CDATA[<<toReg.penred>>]]>
				<<C_TAB>><style><![CDATA[<<toReg.style>>]]>
				<<C_TAB>><expr><![CDATA[<<toReg.expr>>]]>
				<<C_TAB>><user><![CDATA[<<toReg.user>>]]>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_F>>
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DETALLE_REPORTE
		LPARAMETERS toReg

		TRY
			LOCAL lc_TAG_REPORTE, loEx as Exception
			lc_TAG_REPORTE_I	= '<' + C_TAG_REPORTE + ' '
			lc_TAG_REPORTE_F	= '</' + C_TAG_REPORTE + '>'

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_I>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>>platform="WINDOWS " uniqueid="<<EVL(toReg.UniqueID,SYS(2015))>>" timestamp="<<toReg.TimeStamp>>" objtype="<<toReg.ObjType>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				objcode="<<toReg.ObjCode>>" name="<<toReg.Name>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				vpos="<<toReg.vpos>>" hpos="<<toReg.hpos>>" height="<<toReg.height>>" width="<<toReg.width>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				order="<<toReg.order>>" unique="<<toReg.unique>>" comment="<<toReg.comment>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				environ="<<toReg.environ>>" boxchar="<<toReg.boxchar>>" fillchar="<<toReg.fillchar>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				pengreen="<<toReg.pengreen>>" penblue="<<toReg.penblue>>" fillred="<<toReg.fillred>>" fillgreen="<<toReg.fillgreen>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fillblue="<<toReg.fillblue>>" pensize="<<toReg.pensize>>" penpat="<<toReg.penpat>>" fillpat="<<toReg.fillpat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fontface="<<toReg.fontface>>" fontstyle="<<toReg.fontstyle>>" fontsize="<<toReg.fontsize>>" mode="<<toReg.mode>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				ruler="<<toReg.ruler>>" rulerlines="<<toReg.rulerlines>>" grid="<<toReg.grid>>" gridv="<<toReg.gridv>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				gridh="<<toReg.gridh>>" float="<<toReg.float>>" stretch="<<toReg.stretch>>" stretchtop="<<toReg.stretchtop>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				top="<<toReg.top>>" bottom="<<toReg.bottom>>" suptype="<<toReg.suptype>>" suprest="<<toReg.suprest>>" norepeat="<<toReg.norepeat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				resetrpt="<<toReg.resetrpt>>" pagebreak="<<toReg.pagebreak>>" colbreak="<<toReg.colbreak>>" resetpage="<<toReg.resetpage>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				general="<<toReg.general>>" spacing="<<toReg.spacing>>" double="<<toReg.double>>" swapheader="<<toReg.swapheader>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				swapfooter="<<toReg.swapfooter>>" ejectbefor="<<toReg.ejectbefor>>" ejectafter="<<toReg.ejectafter>>" plain="<<toReg.plain>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				summary="<<toReg.summary>>" addalias="<<toReg.addalias>>" offset="<<toReg.offset>>" topmargin="<<toReg.topmargin>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				botmargin="<<toReg.botmargin>>" totaltype="<<toReg.totaltype>>" resettotal="<<toReg.resettotal>>" resoid="<<toReg.resoid>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				curpos="<<toReg.curpos>>" supalways="<<toReg.supalways>>" supovflow="<<toReg.supovflow>>" suprpcol="<<toReg.suprpcol>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				supgroup="<<toReg.supgroup>>" supvalchng="<<toReg.supvalchng>>" supexpr="<<toReg.supexpr>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>><picture><![CDATA[<<toReg.picture>>]]>
				<<C_TAB>><tag><![CDATA[<<THIS.encode_SpecialCodes_1_31( toReg.tag )>>]]>
				<<C_TAB>><tag2><![CDATA[<<STRCONV( toReg.tag2,13 )>>]]>
				<<C_TAB>><penred><![CDATA[<<toReg.penred>>]]>
				<<C_TAB>><style><![CDATA[<<toReg.style>>]]>
				<<C_TAB>><expr><![CDATA[<<toReg.expr>>]]>
				<<C_TAB>><user><![CDATA[<<toReg.user>>]]>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_F>>
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DATAENVIRONMENT_REPORTE
		LPARAMETERS toReg

		TRY
			LOCAL lc_TAG_REPORTE, loEx as Exception
			lc_TAG_REPORTE_I	= '<' + C_TAG_REPORTE + ' '
			lc_TAG_REPORTE_F	= '</' + C_TAG_REPORTE + '>'

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_I>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>>platform="WINDOWS " uniqueid="<<EVL(toReg.UniqueID,SYS(2015))>>" timestamp="<<toReg.TimeStamp>>" objtype="<<toReg.ObjType>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				objcode="<<toReg.ObjCode>>" name="<<toReg.Name>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				vpos="<<toReg.vpos>>" hpos="<<toReg.hpos>>" height="<<toReg.height>>" width="<<toReg.width>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				order="<<toReg.order>>" unique="<<toReg.unique>>" comment="<<toReg.comment>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				environ="<<toReg.environ>>" boxchar="<<toReg.boxchar>>" fillchar="<<toReg.fillchar>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				pengreen="<<toReg.pengreen>>" penblue="<<toReg.penblue>>" fillred="<<toReg.fillred>>" fillgreen="<<toReg.fillgreen>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fillblue="<<toReg.fillblue>>" pensize="<<toReg.pensize>>" penpat="<<toReg.penpat>>" fillpat="<<toReg.fillpat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				fontface="<<toReg.fontface>>" fontstyle="<<toReg.fontstyle>>" fontsize="<<toReg.fontsize>>" mode="<<toReg.mode>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				ruler="<<toReg.ruler>>" rulerlines="<<toReg.rulerlines>>" grid="<<toReg.grid>>" gridv="<<toReg.gridv>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				gridh="<<toReg.gridh>>" float="<<toReg.float>>" stretch="<<toReg.stretch>>" stretchtop="<<toReg.stretchtop>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				top="<<toReg.top>>" bottom="<<toReg.bottom>>" suptype="<<toReg.suptype>>" suprest="<<toReg.suprest>>" norepeat="<<toReg.norepeat>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				resetrpt="<<toReg.resetrpt>>" pagebreak="<<toReg.pagebreak>>" colbreak="<<toReg.colbreak>>" resetpage="<<toReg.resetpage>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				general="<<toReg.general>>" spacing="<<toReg.spacing>>" double="<<toReg.double>>" swapheader="<<toReg.swapheader>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				swapfooter="<<toReg.swapfooter>>" ejectbefor="<<toReg.ejectbefor>>" ejectafter="<<toReg.ejectafter>>" plain="<<toReg.plain>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				summary="<<toReg.summary>>" addalias="<<toReg.addalias>>" offset="<<toReg.offset>>" topmargin="<<toReg.topmargin>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				botmargin="<<toReg.botmargin>>" totaltype="<<toReg.totaltype>>" resettotal="<<toReg.resettotal>>" resoid="<<toReg.resoid>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				curpos="<<toReg.curpos>>" supalways="<<toReg.supalways>>" supovflow="<<toReg.supovflow>>" suprpcol="<<toReg.suprpcol>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				supgroup="<<toReg.supgroup>>" supvalchng="<<toReg.supvalchng>>" supexpr="<<toReg.supexpr>>" <<>>
			ENDTEXT

			* NOTA: En el DataEnvironment el TAG2 es el TAG compilado, que se recompila con COMPILE REPORT <nombre>
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>><picture><![CDATA[<<toReg.picture>>]]>
				<<C_TAB>><tag><![CDATA[<<CR_LF>><<toReg.tag>>]]>
				<<C_TAB>><tag2><![CDATA[]]>
				<<C_TAB>><penred><![CDATA[<<toReg.penred>>]]>
				<<C_TAB>><style><![CDATA[<<toReg.style>>]]>
				<<C_TAB>><expr><![CDATA[<<toReg.expr>>]]>
				<<C_TAB>><user><![CDATA[<<toReg.user>>]]>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<lc_TAG_REPORTE_F>>
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DBF_HEADER
		LPARAMETERS tn_HexFileType, tl_FileHasCDX, tl_FileHasMemo, tl_FileIsDBC, tc_DBC_Name
		TRY
			LOCAL laFields(1,18), loEx as Exception

			*FOR I = 1 TO AFIELDS(laFields)
			*	IF INLIST( laFields(I,2), 'M', 'Q', 'V', 'W' )
			*		ll_FileHasMemo	= .T.
			*		EXIT
			*	ENDIF
			*ENDFOR

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2

				*-- TABLE INFO

			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+8
				<<C_DBF_HEAD_I>>
				memofile="<<IIF( tl_FileHasMemo, FORCEEXT(THIS.c_InputFile, 'FPT'), '' )>>"
				codepage="<<CPDBF('TABLABIN')>>"
				database="<<tc_DBC_Name>>"
				filetype="<<TRANSFORM(tn_HexFileType, '@0')>>"
				filetype_descrip="<<THIS.fileTypeDescription(tn_HexFileType)>>"
				<<C_DBF_HEAD_F>>
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DBF_FIELDS
		TRY
			LOCAL I, laFields(1,18), loEx as Exception

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2

				*-- FIELDS
				<<>>
			ENDTEXT

			FOR I = 1 TO AFIELDS(laFields)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+8
					<<C_FIELD_I>>
					name="<<laFields(I,1)>>"
					type="<<laFields(I,2)>>"
					width="<<laFields(I,3)>>"
					decimals="<<laFields(I,4)>>"
					null="<<laFields(I,5)>>"
					cptran="<<laFields(I,6)>>"
					field_valid_exp="<<laFields(I,7)>>"
					field_valid_text="<<laFields(I,8)>>"
					field_default_value="<<laFields(I,9)>>"
					table_valid_exp="<<laFields(I,10)>>"
					table_valid_text="<<laFields(I,11)>>"
					longtablename="<<laFields(I,12)>>"
					ins_trig_exp="<<laFields(I,13)>>"
					upd_trig_exp="<<laFields(I,14)>>"
					del_trig_exp="<<laFields(I,15)>>"
					tablecomment="<<laFields(I,16)>>"
					autoinc_nextval="<<laFields(I,17)>>"
					autoinc_step="<<laFields(I,18)>>"
					<<C_FIELD_F>>
				ENDTEXT

				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<>>
				ENDTEXT
			ENDFOR

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DBF_INDEXES
		TRY
			LOCAL I, loEx as Exception

			IF TAGCOUNT() > 0
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2

					*-- INDEXES
					<<C_CDX_I>><<CDX(1)>><<C_CDX_F>>
					<<>>
				ENDTEXT

				FOR I = 1 TO TAGCOUNT()
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+8
						<<C_INDEX_I>>
						tagname="<<TAG(I)>>"
						collate="<<IDXCOLLATE(I)>>"
						key="<<KEY(I)>>"
						descending="<<DESCENDING(I)>>"
						for_exp="<<SYS(2021,I)>>"
						<<C_INDEX_F>>
					ENDTEXT

					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>
					ENDTEXT
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DBC_HEADER
		TRY
			LOCAL I, lcText, lcDBC, loEx as Exception
			lcText	= ''
			lcDBC	= JUSTSTEM(DBC())

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2


				*-----------------------------------------------------------------------------------
				*-- DATABASE INFO
				*-----------------------------------------------------------------------------------
			ENDTEXT

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<DATABASE>
				<<>>	<Name><<lcDBC>></Name>
				<<>>	<Comment><<DBGETPROP(lcDBC,"DATABASE","Comment")>></Comment>
				<<>>	<Version><<DBGETPROP(lcDBC,"DATABASE","Version")>></Version>
				<<>>	<DBCEvents><<DBGETPROP(lcDBC,"DATABASE","DBCEvents")>></DBCEvents>
				<<>>	<DBCEventFilename><<DBGETPROP(lcDBC,"DATABASE","DBCEventFilename")>></DBCEventFilename>
				</DATABASE>
			ENDTEXT

			C_FB2PRG_CODE	= C_FB2PRG_CODE + lcText

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DBC_CONNECTIONS
		LPARAMETERS taConnections, tnConnection_Count

		EXTERNAL ARRAY taConnections

		TRY
			LOCAL I, lcText, lcDBC, loEx as Exception
			lcText	= ''
			lcDBC	= JUSTSTEM(DBC())

			DIMENSION taConnections(1)
			tnConnection_Count	= ADBOBJECTS( taConnections,"CONNECTION" )
			ASORT( taConnections, 1, -1, 0, 1 )

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2


				*-----------------------------------------------------------------------------------
				*-- CONNECTIONS INFO
				*-----------------------------------------------------------------------------------
			ENDTEXT

			FOR I = 1 TO tnConnection_Count

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<CONNECTION>
					<<>>	<Name><<taConnections(I)>></Name>
					<<>>	<Comment><<DBGETPROP(taConnections(I),"CONNECTION","Comment")>></Comment>
					<<>>	<DataSource><<DBGETPROP(taConnections(I),"CONNECTION","DataSource")>></DataSource>
					<<>>	<Database><<DBGETPROP(taConnections(I),"CONNECTION","Database")>></Database>
					<<>>	<ConnectString><<DBGETPROP(taConnections(I),"CONNECTION","ConnectString")>></ConnectString>
					<<>>	<Asynchronous><<DBGETPROP(taConnections(I),"CONNECTION","Asynchronous")>></Asynchronous>
					<<>>	<BatchMode><<DBGETPROP(taConnections(I),"CONNECTION","BatchMode")>></BatchMode>
					<<>>	<ConnectTimeout><<DBGETPROP(taConnections(I),"CONNECTION","ConnectTimeout")>></ConnectTimeout>
					<<>>	<DisconnectRollback><<DBGETPROP(taConnections(I),"CONNECTION","DisconnectRollback")>></DisconnectRollback>
					<<>>	<DispLogin><<DBGETPROP(taConnections(I),"CONNECTION","DispLogin")>></DispLogin>
					<<>>	<DispWarnings><<DBGETPROP(taConnections(I),"CONNECTION","DispWarnings")>></DispWarnings>
					<<>>	<IdleTimeout><<DBGETPROP(taConnections(I),"CONNECTION","IdleTimeout")>></IdleTimeout>
					<<>>	<PacketSize><<DBGETPROP(taConnections(I),"CONNECTION","PacketSize")>></PacketSize>
					<<>>	<PassWord><<DBGETPROP(taConnections(I),"CONNECTION","PassWord")>></PassWord>
					<<>>	<QueryTimeout><<DBGETPROP(taConnections(I),"CONNECTION","QueryTimeout")>></QueryTimeout>
					<<>>	<Transactions><<DBGETPROP(taConnections(I),"CONNECTION","Transactions")>></Transactions>
					<<>>	<UserId><<DBGETPROP(taConnections(I),"CONNECTION","UserId")>></UserId>
					<<>>	<WaitTime><<DBGETPROP(taConnections(I),"CONNECTION","WaitTime")>></WaitTime>
					</CONNECTION>
				ENDTEXT
			ENDFOR

			C_FB2PRG_CODE	= C_FB2PRG_CODE + lcText

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DBC_TABLES
		LPARAMETERS taTables, tnTable_Count

		EXTERNAL ARRAY taTables

		TRY
			LOCAL I, X, lcText, lcDBC, lnField_Count, laFields(1), loEx as Exception
			STORE 0 TO I, X, tnTable_Count, lnField_Count
			lcText	= ''
			lcDBC	= JUSTSTEM(DBC())

			DIMENSION taTables(1)
			tnTable_Count	= ADBOBJECTS( taTables,"TABLE" )
			ASORT( taTables, 1, -1, 0, 1 )

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2


				*-----------------------------------------------------------------------------------
				*-- TABLES INFO
				*-----------------------------------------------------------------------------------
			ENDTEXT

			FOR I = 1 TO tnTable_Count

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<TABLE>
					<<>>	<Name><<taTables(I)>></Name>
					<<>>	<Comment><<DBGETPROP(taTables(I),"TABLE","Comment")>></Comment>
					<<>>	<Path><<DBGETPROP(taTables(I),"TABLE","Path")>></Path>
					<<>>	<DeleteTrigger><<DBGETPROP(taTables(I),"TABLE","DeleteTrigger")>></DeleteTrigger>
					<<>>	<InsertTrigger><<DBGETPROP(taTables(I),"TABLE","InsertTrigger")>></InsertTrigger>
					<<>>	<UpdateTrigger><<DBGETPROP(taTables(I),"TABLE","UpdateTrigger")>></UpdateTrigger>
					<<>>	<PrimaryKey><<DBGETPROP(taTables(I),"TABLE","PrimaryKey")>></PrimaryKey>
					<<>>	<RuleExpression><<DBGETPROP(taTables(I),"TABLE","RuleExpression")>></RuleExpression>
					<<>>	<RuleText><<DBGETPROP(taTables(I),"TABLE","RuleText")>></RuleText>
				ENDTEXT

				_TALLY	= 0
				SELECT LOWER(TB.objectname) FROM TABLABIN TB ;
					INNER JOIN TABLABIN TB2 ON STR(TB.parentid)+PADR('Table',10) = STR(TB2.objectid)+TB2.objecttype ;
					WHERE STR(TB2.parentid)+TB2.objecttype+TB2.objectname = STR(1)+PADR('Table',10)+PADR(LOWER(taTables(I)),128) ;
					INTO ARRAY laFields
				lnField_Count	= _TALLY

				IF lnField_Count > 0
					TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	*-- FIELDS
						<<>>	<FIELD>
					ENDTEXT

					FOR X = 1 TO lnField_Count
						TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
							<<>>		<Name><<RTRIM(laFields(I))>></Name>
							<<>>		<Caption><<DBGETPROP( RTRIM(taTables(I)) + '.' + RTRIM(laFields(I)),"FIELD","Caption")>></Caption>
							<<>>		<Comment><<DBGETPROP( RTRIM(taTables(I)) + '.' + RTRIM(laFields(I)),"FIELD","Comment")>></Comment>
							<<>>		<DefaultValue><<DBGETPROP( RTRIM(taTables(I)) + '.' + RTRIM(laFields(I)),"FIELD","DefaultValue")>></DefaultValue>
							<<>>		<DisplayClass><<DBGETPROP( RTRIM(taTables(I)) + '.' + RTRIM(laFields(I)),"FIELD","DisplayClass")>></DisplayClass>
							<<>>		<DisplayClassLibrary><<DBGETPROP( RTRIM(taTables(I)) + '.' + RTRIM(laFields(I)),"FIELD","DisplayClassLibrary")>></DisplayClassLibrary>
							<<>>		<Format><<DBGETPROP( RTRIM(taTables(I)) + '.' + RTRIM(laFields(I)),"FIELD","Format")>></Format>
							<<>>		<InputMask><<DBGETPROP( RTRIM(taTables(I)) + '.' + RTRIM(laFields(I)),"FIELD","InputMask")>></InputMask>
							<<>>		<RuleExpression><<DBGETPROP( RTRIM(taTables(I)) + '.' + RTRIM(laFields(I)),"FIELD","RuleExpression")>></RuleExpression>
							<<>>		<RuleText><<DBGETPROP( RTRIM(taTables(I)) + '.' + RTRIM(laFields(I)),"FIELD","RuleText")>></RuleText>
						ENDTEXT
					ENDFOR

					TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	</FIELD>
					ENDTEXT
				ENDIF

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					</TABLE>
				ENDTEXT
			ENDFOR

			C_FB2PRG_CODE	= C_FB2PRG_CODE + lcText

		CATCH TO loEx
			IF BETWEEN(I, 1, tnTable_Count)
				loEx.UserValue	= loEx.UserValue + CR_LF + "taTables(" + TRANSFORM(I) + ") = " + RTRIM(taTables(I))
			ENDIF
			IF BETWEEN(X, 1, lnField_Count)
			 	loEx.UserValue	= loEx.UserValue + CR_LF + "laFields(" + TRANSFORM(X) + ") = " + RTRIM(laFields(I))
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TB"))
			USE IN (SELECT("TB2"))
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DBC_VIEWS
		LPARAMETERS taViews, tnView_Count

		EXTERNAL ARRAY taViews

		TRY
			LOCAL I, lcText, lcDBC, lnField_Count, laFields(1), loEx as Exception
			STORE 0 TO I, X, tnView_Count, lnField_Count
			lcText	= ''
			lcDBC	= JUSTSTEM(DBC())

			DIMENSION taViews(1)
			tnView_Count	= ADBOBJECTS( taViews,"VIEW" )
			ASORT( taViews, 1, -1, 0, 1 )

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2


				*-----------------------------------------------------------------------------------
				*-- VIEWS INFO
				*-----------------------------------------------------------------------------------
			ENDTEXT

			FOR I = 1 TO tnView_Count

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<VIEW>
					<<>>	<Name><<taViews(I)>></Name>
					<<>>	<Comment><<DBGETPROP(taViews(I),"VIEW","Comment")>></Comment>
					<<>>	<Tables><<DBGETPROP(taViews(I),"VIEW","Tables")>></Tables>
					<<>>	<SQL><<DBGETPROP(taViews(I),"VIEW","SQL")>></SQL>
					<<>>	<AllowSimultaneousFetch><<DBGETPROP(taViews(I),"VIEW","AllowSimultaneousFetch")>></AllowSimultaneousFetch>
					<<>>	<BatchUpdateCount><<DBGETPROP(taViews(I),"VIEW","BatchUpdateCount")>></BatchUpdateCount>
					<<>>	<CompareMemo><<DBGETPROP(taViews(I),"VIEW","CompareMemo")>></CompareMemo>
					<<>>	<ConnectName><<DBGETPROP(taViews(I),"VIEW","ConnectName")>></ConnectName>
					<<>>	<FetchAsNeeded><<DBGETPROP(taViews(I),"VIEW","FetchAsNeeded")>></FetchAsNeeded>
					<<>>	<FetchMemo><<DBGETPROP(taViews(I),"VIEW","FetchMemo")>></FetchMemo>
					<<>>	<FetchSize><<DBGETPROP(taViews(I),"VIEW","FetchSize")>></FetchSize>
					<<>>	<MaxRecords><<DBGETPROP(taViews(I),"VIEW","MaxRecords")>></MaxRecords>
					<<>>	<Offline><<DBGETPROP(taViews(I),"VIEW","Offline")>></Offline>
					<<>>	<ParameterList><<DBGETPROP(taViews(I),"VIEW","ParameterList")>></ParameterList>
					<<>>	<Prepared><<DBGETPROP(taViews(I),"VIEW","Prepared")>></Prepared>
					<<>>	<RuleExpression><<DBGETPROP(taViews(I),"VIEW","RuleExpression")>></RuleExpression>
					<<>>	<RuleText><<DBGETPROP(taViews(I),"VIEW","RuleText")>></RuleText>
					<<>>	<SendUpdates><<DBGETPROP(taViews(I),"VIEW","SendUpdates")>></SendUpdates>
					<<>>	<ShareConnection><<DBGETPROP(taViews(I),"VIEW","ShareConnection")>></ShareConnection>
					<<>>	<SourceType><<DBGETPROP(taViews(I),"VIEW","SourceType")>></SourceType>
					<<>>	<UpdateType><<DBGETPROP(taViews(I),"VIEW","UpdateType")>></UpdateType>
					<<>>	<UseMemoSize><<DBGETPROP(taViews(I),"VIEW","UseMemoSize")>></UseMemoSize>
					<<>>	<WhereType><<DBGETPROP(taViews(I),"VIEW","WhereType")>></WhereType>
				ENDTEXT

				_TALLY	= 0
				SELECT LOWER(TB.objectname) FROM TABLABIN TB ;
					INNER JOIN TABLABIN TB2 ON STR(TB.parentid)+PADR('View',10) = STR(TB2.objectid)+TB2.objecttype ;
					WHERE STR(TB2.parentid)+TB2.objecttype+TB2.objectname = STR(1)+PADR('View',10)+PADR(LOWER(taViews(I)),128) ;
					INTO ARRAY laFields
				lnField_Count	= _TALLY

				IF lnField_Count > 0
					TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	*-- FIELDS
						<<>>	<FIELD>
					ENDTEXT

					FOR X = 1 TO lnField_Count
						TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
							<<>>		<Name><<RTRIM(laFields(I))>></Name>
							<<>>		<Caption><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","Caption")>></Caption>
							<<>>		<Comment><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","Comment")>></Comment>
							<<>>		<DataType><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","DataType")>></DataType>
							<<>>		<DefaultValue><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","DefaultValue")>></DefaultValue>
							<<>>		<Format><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","Format")>></Format>
							<<>>		<InputMask><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","InputMask")>></InputMask>
							<<>>		<KeyField><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","KeyField")>></KeyField>
							<<>>		<RuleExpression><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","RuleExpression")>></RuleExpression>
							<<>>		<RuleText><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","RuleText")>></RuleText>
							<<>>		<Updatable><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","Updatable")>></Updatable>
							<<>>		<UpdateName><<DBGETPROP( RTRIM(taViews(I)) + '.' + RTRIM(laFields(I)),"FIELD","UpdateName")>></UpdateName>
						ENDTEXT
					ENDFOR

					TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<>>	</FIELD>
					ENDTEXT
				ENDIF

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					</VIEW>
				ENDTEXT
			ENDFOR

			C_FB2PRG_CODE	= C_FB2PRG_CODE + lcText

		CATCH TO loEx
			IF BETWEEN(I, 1, tnTable_Count)
				loEx.UserValue	= loEx.UserValue + CR_LF + "taViews(" + TRANSFORM(I) + ") = " + RTRIM(taViews(I))
			ENDIF
			IF BETWEEN(X, 1, lnField_Count)
			 	loEx.UserValue	= loEx.UserValue + CR_LF + "laFields(" + TRANSFORM(X) + ") = " + RTRIM(laFields(I))
			ENDIF

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DBC_RELATIONS
		LPARAMETERS taRelations, tnRelation_Count

		EXTERNAL ARRAY taRelations

		TRY
			LOCAL I, lcText, lcDBC, loEx as Exception
			lcText	= ''
			lcDBC	= JUSTSTEM(DBC())

			DIMENSION taRelations(1,5)
			tnRelation_Count	= ADBOBJECTS( taRelations,"RELATION" )
			ASORT( taRelations, 2, -1, 0, 1 )
			ASORT( taRelations, 1, -1, 0, 1 )

			FOR I = 1 TO tnRelation_Count

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2


					*-----------------------------------------------------------------------------------
					*-- RELATIONS INFO		(REF.INTEGRITY: "C"=cascade, "R"=restrict, "I"=ignore)
					*-----------------------------------------------------------------------------------
					<<>>
				ENDTEXT

				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+8
					<RELATION>
					<<>>	<ChildTable><<ALLTRIM(taRelations(I,1))>></ChildTable>
					<<>>	<ParentTable><<ALLTRIM(taRelations(I,2))>></ParentTable>
					<<>>	<ChildIndex><<ALLTRIM(taRelations(I,3))>></ChildIndex>
					<<>>	<ParentIndex><<ALLTRIM(taRelations(I,4))>></ParentIndex>
					<<>>	<RefIntegrity><<ALLTRIM(taRelations(I,5))>></RefIntegrity>
					</RELATION>
				ENDTEXT
			ENDFOR

			C_FB2PRG_CODE	= C_FB2PRG_CODE + lcText

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_DefinicionObjetosOLE
		*-- Crea la definición del tag *< OLE: /> con la información de todos los objetos OLE
		LOCAL lnOLECount, lcOLEChecksum, llOleExistente, loReg

		TRY
			SELECT TABLABIN
			SET ORDER TO PARENT_OBJ
			lnOLECount	= 0

			SCAN ALL FOR TABLABIN.PLATFORM = "WINDOWS" AND BASECLASS = 'olecontrol'
				SCATTER MEMO NAME loReg
				lcOLEChecksum	= SYS(2007, loReg.OLE, 0, 1)
				llOleExistente	= .F.

				IF lnOLECount > 0 AND ASCAN(laOLE, lcOLEChecksum, 1, 0, 0, 0) > 0
					llOleExistente	= .T.
				ENDIF

				lnOLECount	= lnOLECount + 1
				DIMENSION laOLE( lnOLECount )
				laOLE( lnOLECount )	= lcOLEChecksum

				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2

				ENDTEXT

				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+8
					<<C_OLE_I>>
					Nombre="<<IIF(EMPTY(loReg.Parent),'',loReg.Parent+'.') + loReg.objName>>"
					Parent="<<loReg.Parent>>"
					ObjName="<<loReg.objname>>"
					OLEObject="<<STREXTRACT(loReg.ole2, 'OLEObject = ', CHR(13)+CHR(10), 1, 1+2)>>"
					Checksum="<<lcOLEChecksum>>" <<>>
				ENDTEXT

				IF NOT llOleExistente
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
						Value="<<STRCONV(loReg.ole,13)>>" <<>>
					ENDTEXT
				ENDIF

				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					<<C_OLE_F>>
				ENDTEXT

			ENDSCAN

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				*
			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE FixOle2Fields
		*******************************************************************************************************************
		* (This method is taken from Open Source project TwoFox, from Christof Wallenhaupt - http://www.foxpert.com/downloads.htm)
		* OLE2 contains the physical name of the OCX or DLL when a record refers to an ActiveX
		* control. On different developer machines these controls can be located in different
		* folders without affecting the code.
		*
		* When a control is stored outside the project directory, we assume that every developer
		* is responsible for installing and registering the control. Therefore we only leave
		* the file name which should be fixed. It's also sufficient for VFP to locate an OCX
		* file when the control is not registered and the OCX file is stored in the current
		* directory or the application path.
		*--------------------------------------------------------------------------------------
		* Project directory for comparision purposes
		*--------------------------------------------------------------------------------------
		LOCAL lcProjDir
		lcProjDir = UPPER(ALLTRIM(THIS.cHomeDir))
		IF RIGHT(m.lcProjDir,1) == "\"
			lcProjDir = LEFT(m.lcProjDir, LEN(m.lcProjDir)-1)
		ENDIF

		*--------------------------------------------------------------------------------------
		* Check all OLE2 fields
		*--------------------------------------------------------------------------------------
		LOCAL lcOcx
		SCAN FOR NOT EMPTY(OLE2)
			lcOcx = STREXTRACT (OLE2, "OLEObject = ", CHR(13), 1, 1+2)
			IF THIS.OcxOutsideProjDir (m.lcOcx, m.lcProjDir)
				THIS.TruncateOle2 (m.lcOcx)
			ENDIF
		ENDSCAN

	ENDPROC


	*******************************************************************************************************************
	FUNCTION OcxOutsideProjDir
		LPARAMETERS tcOcx, tcProjDir
		*******************************************************************************************************************
		* (This method is taken from Open Source project TwoFox, from Christof Wallenhaupt - http://www.foxpert.com/downloads.htm)
		* Returns .T. when the OCX control resides outside the project directory

		LOCAL lcOcxDir, llOutside
		lcOcxDir = UPPER (JUSTPATH (m.tcOcx))
		IF LEFT(m.lcOcxDir, LEN(m.tcProjDir)) == m.tcProjDir
			llOutside = .F.
		ELSE
			llOutside = .T.
		ENDIF

		RETURN m.llOutside


		*******************************************************************************************************************
		* (This method is taken from Open Source project TwoFox, from Christof Wallenhaupt - http://www.foxpert.com/downloads.htm)
		* Cambios de un campo OLE2 exclusivamente en el nombre del archivo
	PROCEDURE TruncateOle2 (tcOcx)
		REPLACE OLE2 WITH STRTRAN ( ;
			OLE2 ;
			,"OLEObject = " + m.tcOcx ;
			,"OLEObject = " + JUSTFNAME(m.tcOcx) ;
			)
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_vcx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_vcx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	*_MEMBERDATA	= [<VFPData>] ;
	+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
	+ [</VFPData>]

	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, loRegClass, loRegObj, lnMethodCount, laMethods(1), laCode(1), laProtected(1) ;
				, laPropsAndValues(1), laPropsAndComments(1), lnLastClass, lnRecno, lcMethods, lcObjName, la_NombresObjsOle(1)
			STORE 0 TO lnCodError, lnLastClass
			STORE '' TO laMethods(1), laCode(1), laProtected(1), laPropsAndComments(1)
			STORE NULL TO loRegClass, loRegObj

			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS TABLABIN

			INDEX ON PADR(LOWER(PLATFORM + IIF(EMPTY(PARENT),'',ALLTRIM(PARENT)+'.')+OBJNAME),240) TAG PARENT_OBJ OF TABLABIN ADDITIVE
			SET ORDER TO 0 IN TABLABIN

			THIS.write_PROGRAM_HEADER()

			THIS.get_NombresObjetosOLEPublic( @la_NombresObjsOle )

			THIS.write_DefinicionObjetosOLE()

			*-- Escribo los métodos ordenados
			lnLastClass		= 0

			*----------------------------------------------
			*-- RECORRO LAS CLASES
			*----------------------------------------------
			SELECT TABLABIN
			SET ORDER TO PARENT_OBJ

			SCAN ALL FOR TABLABIN.PLATFORM = "WINDOWS" AND TABLABIN.RESERVED1=="Class"
				SCATTER MEMO NAME loRegClass
				lcObjName	= ALLTRIM(loRegClass.OBJNAME)

				THIS.write_ENDDEFINE_SiCorresponde( lnLastClass )

				THIS.write_DEFINE_CLASS( @la_NombresObjsOle, @loRegClass )

				THIS.write_DEFINE_CLASS_COMMENTS( @loRegClass )

				THIS.write_METADATA( @loRegClass )

				THIS.write_INCLUDE( @loRegClass )

				THIS.write_CLASS_PROPERTIES( @loRegClass, @laPropsAndValues, @laPropsAndComments, @laProtected )


				*-------------------------------------------------------------------------------
				*-- RECORRO LOS OBJETOS DENTRO DE LA CLASE ACTUAL PARA EXPORTAR SU DEFINICIÓN
				*-------------------------------------------------------------------------------
				lnRecno	= RECNO()
				LOCATE FOR TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

				SCAN REST WHILE TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName
					SCATTER MEMO NAME loRegObj
					ADDPROPERTY( loRegObj, '_ZOrder', RECNO()*100 )		&& Para permitir insertar objetos manualmente entre medias al integrar cambios
					THIS.write_ADD_OBJECTS_WithProperties( @loRegObj )
				ENDSCAN

				GOTO RECORD (lnRecno)


				*-- OBTENGO LOS MÉTODOS DE LA CLASE PARA POSTERIOR TRATAMIENTO
				DIMENSION laMethods(1,3)
				lcMethods	= ''
				THIS.SortMethod( loRegClass.METHODS, @laMethods, @laCode, '', @lnMethodCount )

				THIS.write_CLASS_METHODS( @lnMethodCount, @laMethods, @laCode, @laProtected, @laPropsAndComments )

				lnLastClass		= 1
				lcMethods		= ''

				*-- RECORRO LOS OBJETOS DENTRO DE LA CLASE ACTUAL PARA OBTENER SUS MÉTODOS
				lnRecno	= RECNO()
				LOCATE FOR TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

				SCAN REST ;
						FOR TABLABIN.PLATFORM = "WINDOWS" AND NOT TABLABIN.RESERVED1=="Class" ;
						WHILE ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

					SCATTER MEMO NAME loRegObj
					THIS.get_ADD_OBJECT_METHODS( @loRegObj, @loRegClass, @lcMethods )
				ENDSCAN

				THIS.write_ALL_OBJECT_METHODS( @lcMethods )

				GOTO RECORD (lnRecno)
			ENDSCAN

			THIS.write_ENDDEFINE_SiCorresponde( lnLastClass )

			*-- Genero el VC2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				IF STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDIF
			ENDIF


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_scx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_scx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	*_MEMBERDATA	= [<VFPData>] ;
	+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
	+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lnCodError, loRegClass, loRegObj, lnMethodCount, laMethods(1), laCode(1), laProtected(1) ;
				, laPropsAndValues(1), laPropsAndComments(1), lnLastClass, lnRecno, lcMethods, lcObjName, la_NombresObjsOle(1)
			STORE 0 TO lnCodError, lnLastClass
			STORE '' TO laMethods(1), laCode(1), laProtected(1), laPropsAndComments(1)
			STORE NULL TO loRegClass, loRegObj

			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS TABLABIN

			INDEX ON PADR(LOWER(PLATFORM + IIF(EMPTY(PARENT),'',ALLTRIM(PARENT)+'.')+OBJNAME),240) TAG PARENT_OBJ OF TABLABIN ADDITIVE
			SET ORDER TO 0 IN TABLABIN

			*toModulo	= NULL
			*toModulo	= CREATEOBJECT('CL_MODULO')

			THIS.write_PROGRAM_HEADER()

			THIS.get_NombresObjetosOLEPublic( @la_NombresObjsOle )

			THIS.write_DefinicionObjetosOLE()

			*-- Escribo los métodos ordenados
			lnLastObj		= 0
			lnLastClass		= 0

			*----------------------------------------------
			*-- RECORRO LAS CLASES
			*----------------------------------------------
			SELECT TABLABIN
			SET ORDER TO PARENT_OBJ
			GOTO RECORD 1

			SCATTER FIELDS RESERVED8 MEMO NAME loRegClass

			IF NOT EMPTY(loRegClass.RESERVED8) THEN
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					#INCLUDE "<<loRegClass.Reserved8>>"

				ENDTEXT
			ENDIF


			SCAN ALL FOR TABLABIN.PLATFORM = "WINDOWS" ;
					AND (EMPTY(TABLABIN.PARENT) ;
					AND (TABLABIN.BASECLASS == 'dataenvironment' OR TABLABIN.BASECLASS == 'form' OR TABLABIN.BASECLASS == 'formset' ) )

				*loRegClass	= NULL
				SCATTER MEMO NAME loRegClass
				*toModulo.add_Class( loRegClass )
				lcObjName	= ALLTRIM(loRegClass.OBJNAME)

				THIS.write_ENDDEFINE_SiCorresponde( lnLastClass )

				THIS.write_DEFINE_CLASS( @la_NombresObjsOle, @loRegClass )

				THIS.write_DEFINE_CLASS_COMMENTS( @loRegClass )

				THIS.write_METADATA( @loRegClass )

				THIS.write_INCLUDE( @loRegClass )

				THIS.write_CLASS_PROPERTIES( @loRegClass, @laPropsAndValues, @laPropsAndComments, @laProtected )


				*-------------------------------------------------------------------------------
				*-- RECORRO LOS OBJETOS DENTRO DE LA CLASE ACTUAL PARA EXPORTAR SU DEFINICIÓN
				*-------------------------------------------------------------------------------
				lnRecno	= RECNO()
				LOCATE FOR TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

				SCAN REST WHILE TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName
					SCATTER MEMO NAME loRegObj
					ADDPROPERTY( loRegObj, '_ZOrder', RECNO()*100 )		&& Para permitir insertar objetos manualmente entre medias al integrar cambios
					THIS.write_ADD_OBJECTS_WithProperties( @loRegObj )
				ENDSCAN

				GOTO RECORD (lnRecno)


				*-- OBTENGO LOS MÉTODOS DE LA CLASE PARA POSTERIOR TRATAMIENTO
				DIMENSION laMethods(1,3)
				lcMethods	= ''
				THIS.SortMethod( loRegClass.METHODS, @laMethods, @laCode, '', @lnMethodCount )

				THIS.write_CLASS_METHODS( @lnMethodCount, @laMethods, @laCode, @laProtected, @laPropsAndComments )

				lnLastClass		= 1
				lcMethods		= ''

				*-- RECORRO LOS OBJETOS DENTRO DE LA CLASE ACTUAL PARA OBTENER SUS MÉTODOS
				lnRecno	= RECNO()
				LOCATE FOR TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

				SCAN REST ;
						FOR TABLABIN.PLATFORM = "WINDOWS" ;
						AND NOT (EMPTY(TABLABIN.PARENT) ;
						AND (TABLABIN.BASECLASS == 'dataenvironment' OR TABLABIN.BASECLASS == 'form' OR TABLABIN.BASECLASS == 'formset' ) ) ;
						WHILE ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

					SCATTER MEMO NAME loRegObj
					THIS.get_ADD_OBJECT_METHODS( @loRegObj, @loRegClass, @lcMethods )
				ENDSCAN

				THIS.write_ALL_OBJECT_METHODS( @lcMethods )

				GOTO RECORD (lnRecno)
			ENDSCAN

			THIS.write_ENDDEFINE_SiCorresponde( lnLastClass )

			*-- Genero el SC2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				IF STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDIF
			ENDIF


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			loRegObj	= NULL
			loRegClass	= NULL
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_pjx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_pjx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	*_MEMBERDATA	= [<VFPData>] ;
	*	+ [<memberdata name="write_program_header" type="method" display="write_PROGRAM_HEADER"/>] ;
	*	+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE write_PROGRAM_HEADER
		*-- Cabecera del PRG e inicio de DEF_CLASS
		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
			*--------------------------------------------------------------------------------------------------------------------------------------------------------
			* (ES) AUTOGENERADO - PARA MANTENER INFORMACIÓN DE SERVIDORES DLL USAR "FOXBIN2PRG", SI NO IMPORTAN, EJECUTAR DIRECTAMENTE PARA REGENERAR EL PROYECTO.
			* (EN) AUTOGENERATED - TO KEEP DLL SERVER INFORMATION USE "FOXBIN2PRG", OTHERWISE YOU CAN EXECUTE DIRECTLY TO REGENERATE PROJECT.
			*--------------------------------------------------------------------------------------------------------------------------------------------------------
			<<C_FB2PRG_META_I>> Version="<<TRANSFORM(THIS.n_FB2PRG_Version)>>" SourceFile="<<THIS.c_InputFile>>" Generated="<<TTOC(DATETIME())>>" <<C_FB2PRG_META_F>> (Para uso con Visual FoxPro 9.0)
			*
		ENDTEXT
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, lcStr, lnPos, lnLen, lnServerCount, loReg, lcDevInfo ;
				, loEx AS EXCEPTION ;
				, loProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG' ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG' ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

			STORE NULL TO loProject, loReg, loServerHead, loServerData
			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS TABLABIN
			loServerHead	= CREATEOBJECT('CL_PROJ_SRV_HEAD')


			*-- Obtengo los archivos del proyecto
			loProject		= CREATEOBJECT('CL_PROJECT')
			SCATTER MEMO NAME loReg
			loProject._HomeDir		= ALLTRIM( loReg.HOMEDIR )
			loProject._ServerInfo	= loReg.RESERVED2
			loProject._Debug		= loReg.DEBUG
			loProject._Encrypted	= loReg.ENCRYPT
			lcDevInfo				= loReg.DEVINFO


			*--- Ubico el programa principal
			LOCATE FOR MAINPROG

			IF FOUND()
				loProject._MainProg	= LOWER( ALLTRIM( NAME, 0, ' ', CHR(0) ) )
			ENDIF


			*-- Ubico el Project Hook
			LOCATE FOR TYPE == 'W'

			IF FOUND()
				loProject._ProjectHookLibrary	= LOWER( ALLTRIM( NAME, 0, ' ', CHR(0) ) )
				loProject._ProjectHookClass	= LOWER( ALLTRIM( RESERVED1, 0, ' ', CHR(0) ) )
			ENDIF


			*-- Ubico el icono del proyecto
			LOCATE FOR TYPE == 'i'

			IF FOUND()
				loProject._Icon	= LOWER( ALLTRIM( NAME, 0, ' ', CHR(0) ) )
			ENDIF


			*-- Escaneo el proyecto
			SCAN ALL FOR NOT INLIST(TYPE, 'H','W','i' )
				SCATTER FIELDS NAME,TYPE,EXCLUDE,COMMENTS,CPID,TIMESTAMP,ID,OBJREV MEMO NAME loReg
				loReg.NAME		= LOWER( ALLTRIM( loReg.NAME, 0, ' ', CHR(0) ) )
				loReg.COMMENTS	= CHRTRAN( ALLTRIM( loReg.COMMENTS, 0, ' ', CHR(0) ), ['], ["] )

				TRY
					loProject.ADD( loReg, loReg.NAME )
				CATCH TO loEx WHEN loEx.ERRORNO = 2062	&& The specified key already exists ==> loProject.ADD( loReg, loReg.NAME )
					*-- Saltear y no agregar el archivo duplicado / Bypass and not add the duplicated file
				ENDTRY
			ENDSCAN


			THIS.write_PROGRAM_HEADER()


			*-- Directorio de inicio
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				LPARAMETERS tcDir

				lcCurdir = SYS(5)+CURDIR()
				CD ( EVL( tcDir, JUSTPATH( SYS(16) ) ) )

			ENDTEXT


			*-- Información del programa
			loProject.parseDeviceInfo( lcDevInfo )
			C_FB2PRG_CODE	= C_FB2PRG_CODE + loProject.getFormattedDeviceInfoText() + CR_LF


			*-- Información de los Servidores definidos
			IF NOT EMPTY(loProject._ServerInfo)
				loServerHead.parseServerInfo( loProject._ServerInfo )
				C_FB2PRG_CODE	= C_FB2PRG_CODE + loServerHead.getFormattedServerText() + CR_LF
				loServerHead	= NULL
			ENDIF


			*-- Generación del proyecto
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_BUILDPROJ_I>>
				FOR EACH loProj IN _VFP.Projects FOXOBJECT
				<<C_TAB>>loProj.Close()
				ENDFOR

				STRTOFILE( '', '__newproject.f2b' )
				BUILD PROJECT <<JUSTFNAME( THIS.c_inputFile )>> FROM '__newproject.f2b'
			ENDTEXT


			*-- Abro el proyecto
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				FOR EACH loProj IN _VFP.Projects FOXOBJECT
				<<C_TAB>>loProj.Close()
				ENDFOR

				MODIFY PROJECT '<<JUSTFNAME( THIS.c_inputFile )>>' NOWAIT NOSHOW NOPROJECTHOOK

				loProject = _VFP.Projects('<<JUSTFNAME( THIS.c_inputFile )>>')

				WITH loProject.FILES
			ENDTEXT


			*-- Definir archivos del proyecto y metadata: CPID, Timestamp, ID, etc.
			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>>.ADD('<<loReg.NAME>>')
				ENDTEXT
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2+4+8
					<<C_TAB>><<C_TAB>><<'&'>><<'&'>> <<C_FILE_META_I>>
					Type="<<loReg.TYPE>>"
					Cpid="<<INT( loReg.CPID )>>"
					Timestamp="<<INT( loReg.TIMESTAMP )>>"
					ID="<<INT( loReg.ID )>>"
					ObjRev="<<INT( loReg.OBJREV )>>"
					<<C_FILE_META_F>>
				ENDTEXT
			ENDFOR

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>><<C_BUILDPROJ_F>>

				<<C_TAB>>.ITEM('__newproject.f2b').Remove()

			ENDTEXT


			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>><<C_FILE_CMTS_I>>
			ENDTEXT


			*-- Agrego los comentarios
			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				IF NOT EMPTY(loReg.COMMENTS)
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>>.ITEM(lcCurdir + '<<loReg.NAME>>').Description = '<<loReg.COMMENTS>>'
					ENDTEXT
				ENDIF
			ENDFOR


			*-- Exclusiones
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>><<C_FILE_CMTS_F>>

				<<C_TAB>><<C_FILE_EXCL_I>>
			ENDTEXT

			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				IF loReg.EXCLUDE
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>>.ITEM(lcCurdir + '<<loReg.NAME>>').Exclude = .T.
					ENDTEXT
				ENDIF
			ENDFOR


			*-- Tipos de archivos especiales
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>><<C_FILE_EXCL_F>>

				<<C_TAB>><<C_FILE_TXT_I>>
			ENDTEXT

			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				IF INLIST( UPPER( JUSTEXT( loReg.NAME ) ), 'H','FPW' )
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>>.ITEM(lcCurdir + '<<loReg.NAME>>').Type = 'T'
					ENDTEXT
				ENDIF
			ENDFOR


			*-- ProjectHook, Debug, Encrypt, Build y cierre
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>><<C_FILE_TXT_F>>
				ENDWITH

				WITH loProject
				<<C_TAB>><<C_PROJPROPS_I>>
			ENDTEXT

			IF NOT EMPTY(loProject._MainProg)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>>.SetMain(lcCurdir + '<<loProject._MainProg>>')
				ENDTEXT
			ENDIF

			IF NOT EMPTY(loProject._Icon)
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>>.Icon = lcCurdir + '<<loProject._Icon>>'
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>>.Debug = <<loProject._Debug>>
				<<C_TAB>>.Encrypted = <<loProject._Encrypted>>
				<<C_TAB>>*<.CmntStyle = <<loProject._CmntStyle>> />
				<<C_TAB>>*<.NoLogo = <<loProject._NoLogo>> />
				<<C_TAB>>*<.SaveCode = <<loProject._SaveCode>> />
				<<C_TAB>>.ProjectHookLibrary = '<<loProject._ProjectHookLibrary>>'
				<<C_TAB>>.ProjectHookClass = '<<loProject._ProjectHookClass>>'
				<<C_TAB>><<C_PROJPROPS_F>>
				ENDWITH

			ENDTEXT


			*-- Build y cierre
			*	_VFP.Projects('<<JUSTFNAME( THIS.c_inputFile )>>').FILES('__newproject.f2b').Remove()
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2

				_VFP.Projects('<<JUSTFNAME( THIS.c_inputFile )>>').Close()
			ENDTEXT

			*-- Restauro Directorio de inicio
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				*ERASE '__newproject.f2b'
				CD (lcCurdir)
				RETURN
			ENDTEXT


			*-- Genero el PJ2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				IF STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDIF
				*COMPILE ( THIS.c_outputFile )
			ENDIF


		CATCH TO toEx
			lnCodError	= toEx.ERRORNO

			DO CASE
			CASE lnCodError = 2062	&& The specified key already exists ==> loProject.ADD( loReg, loReg.NAME )
				toEx.USERVALUE	= 'Archivo duplicado: ' + loReg.NAME
			ENDCASE

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_frx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_frx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	*_MEMBERDATA	= [<VFPData>] ;
	+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
	+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, loRegCab, loRegDataEnv, loRegCur, loRegObj, lnMethodCount, laMethods(1), laCode(1), laProtected(1) ;
				, laPropsAndValues(1), laPropsAndComments(1), lnLastClass, lnRecno, lcMethods, lcObjName, la_NombresObjsOle(1)
			STORE 0 TO lnCodError, lnLastClass
			STORE '' TO laMethods(1), laCode(1), laProtected(1), laPropsAndComments(1)
			STORE NULL TO loRegObj, loRegCab, loRegDataEnv, loRegCur

			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS TABLABIN_0

			*-- Header
			LOCATE FOR ObjType = 1
			IF FOUND()
				SCATTER MEMO NAME loRegCab
			ENDIF

			*-- Dataenvironment
			LOCATE FOR ObjType = 25
			IF FOUND()
				SCATTER MEMO NAME loRegDataEnv
			ENDIF

			*-- Cursor1 (¿puede haber más de 1 cursor?)
			LOCATE FOR ObjType = 26
			IF FOUND()
				SCATTER MEMO NAME loRegCur
			ENDIF

			IF THIS.l_ReportSort_Enabled
				*-- ORDENADO
				SELECT * FROM TABLABIN_0 ;
					WHERE ObjType NOT IN (1,25,26) ;
					ORDER BY vpos,hpos ;
					INTO CURSOR TABLABIN READWRITE
			ELSE
				*-- SIN ORDENAR (Sólo para poder comparar con el original)
				SELECT * FROM TABLABIN_0 ;
					WHERE ObjType NOT IN (1,25,26) ;
					INTO CURSOR TABLABIN
			ENDIF

			loRegObj	= NULL
			USE IN (SELECT("TABLABIN_0"))


			THIS.write_PROGRAM_HEADER()

			*-- Recorro los registros y genero el texto
			IF VARTYPE(loRegCab) = "O"
				THIS.write_CABECERA_REPORTE( @loRegCab )
			ENDIF

			SELECT TABLABIN
			GOTO TOP

			SCAN ALL
				SCATTER MEMO NAME loRegObj
				THIS.write_DETALLE_REPORTE( @loRegObj )
			ENDSCAN

			IF VARTYPE(loRegDataEnv) = "O"
				THIS.write_DATAENVIRONMENT_REPORTE( @loRegDataEnv )
			ENDIF

			IF VARTYPE(loRegCur) = "O"
				THIS.write_DETALLE_REPORTE( @loRegCur )
			ENDIF

			*-- Genero el FR2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				IF STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDIF
			ENDIF


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
			USE IN (SELECT("TABLABIN_0"))

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_dbf_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_dbf_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	*_MEMBERDATA	= [<VFPData>] ;
	+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
	+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, laDatabases(1), lnDatabases_Count, laDatabases2(1) ;
				, ln_HexFileType, ll_FileHasCDX, ll_FileHasMemo, ll_FileIsDBC, lc_DBC_Name
			STORE 0 TO lnCodError

			lnDatabases_Count	= ADATABASES(laDatabases)
			THIS.getDBFmetadata( THIS.c_InputFile, @ln_HexFileType, @ll_FileHasCDX, @ll_FileHasMemo, @ll_FileIsDBC, @lc_DBC_Name )
			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS TABLABIN

			THIS.write_PROGRAM_HEADER()

			*-- Header
			THIS.write_DBF_HEADER( ln_HexFileType, ll_FileHasCDX, ll_FileHasMemo, ll_FileIsDBC, lc_DBC_Name )

			*-- Fields
			THIS.write_DBF_FIELDS()

			*-- Indexes
			THIS.write_DBF_INDEXES()


			*-- Genero el DB2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				IF STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDIF
			ENDIF


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))

			*-- Cierro DBC
			FOR I = 1 TO ADATABASES(laDatabases2)
				IF ASCAN( laDatabases, laDatabases2(I) ) = 0
					SET DATABASE TO (laDatabases2(I))
					CLOSE DATABASES
					EXIT
				ENDIF
			ENDFOR

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_dbc_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_dbc_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	*_MEMBERDATA	= [<VFPData>] ;
	+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
	+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS toModulo, toEx AS EXCEPTION
		DODEFAULT( @toModulo, @toEx )

		TRY
			LOCAL lnCodError, laDatabases(1), lnDatabases_Count, laDatabases2(1) ;
				, ln_HexFileType, ll_FileHasCDX, ll_FileHasMemo, ll_FileIsDBC, lc_DBC_Name
			STORE 0 TO lnCodError

			lnDatabases_Count	= ADATABASES(laDatabases)
			THIS.getDBFmetadata( THIS.c_InputFile, @ln_HexFileType, @ll_FileHasCDX, @ll_FileHasMemo, @ll_FileIsDBC, @lc_DBC_Name )
			USE (THIS.c_InputFile) SHARED NOUPDATE ALIAS TABLABIN
			OPEN DATABASE (THIS.c_InputFile) SHARED NOUPDATE

			THIS.write_PROGRAM_HEADER()

			*-- Header
			THIS.write_DBC_HEADER()

			*-- Connections
			THIS.write_DBC_CONNECTIONS()

			*-- Tables
			THIS.write_DBC_TABLES()

			*-- Views
			THIS.write_DBC_VIEWS()

			*-- Relations
			THIS.write_DBC_RELATIONS()


			*-- Genero el DC2
			IF THIS.l_Test
				toModulo	= C_FB2PRG_CODE
			ELSE
				IF STRTOFILE( C_FB2PRG_CODE, THIS.c_OutputFile ) = 0
					ERROR 'No se puede generar el archivo [' + THIS.c_OutputFile + '] porque es ReadOnly'
				ENDIF
			ENDIF


		CATCH TO toEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			USE IN (SELECT("TABLABIN"))
			CLOSE DATABASES

		ENDTRY

		RETURN
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_BASE AS CUSTOM
	*-- Propiedades. CLASS,
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="l_debug" type="property" display="l_Debug"/>] ;
		+ [</VFPData>]

	l_Debug				= .F.


	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF
		SET TABLEPROMPT OFF

		THIS.l_Debug	= (_VFP.STARTMODE=0)
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_MODULO AS CL_BASE
	#IF .F.
		LOCAL THIS AS CL_MODULO OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="add_ole" type="method" display="add_OLE"/>] ;
		+ [<memberdata name="add_class" type="method" display="add_Class"/>] ;
		+ [<memberdata name="existeobjetoole" type="method" display="existeObjetoOLE"/>] ;
		+ [<memberdata name="_clases" type="property" display="_Clases"/>] ;
		+ [<memberdata name="_clases_count" type="property" display="_Clases_Count"/>] ;
		+ [<memberdata name="_includefile" type="property" display="_IncludeFile"/>] ;
		+ [<memberdata name="_ole_objs" type="property" display="_Ole_Objs"/>] ;
		+ [<memberdata name="_ole_obj_count" type="property" display="_Ole_Obj_Count"/>] ;
		+ [<memberdata name="_sourcefile" type="property" display="_SourceFile"/>] ;
		+ [<memberdata name="_version" type="property" display="_Version"/>] ;
		+ [</VFPData>]

	DIMENSION _Ole_Objs[1], _Clases[1]
	_Version			= 0
	_SourceFile			= ''
	_Ole_Obj_count		= 0
	_Clases_Count		= 0
	_includeFile		= ''


	************************************************************************************************
	PROCEDURE add_OLE
		LPARAMETERS toOle

		#IF .F.
			LOCAL toOle AS CL_OLE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		THIS._Ole_Obj_count	= THIS._Ole_Obj_count + 1
		DIMENSION THIS._Ole_Objs( THIS._Ole_Obj_count )
		THIS._Ole_Objs( THIS._Ole_Obj_count )	= toOle
	ENDPROC


	************************************************************************************************
	PROCEDURE add_Class
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		THIS._Clases_Count	= THIS._Clases_Count + 1
		DIMENSION THIS._Clases( THIS._Clases_Count )
		THIS._Clases( THIS._Clases_Count )	= toClase
	ENDPROC


	************************************************************************************************
	PROCEDURE existeObjetoOLE
		*-- Ubico el objeto ole por su nombre (parent+objname), que no se repite.
		LPARAMETERS tcNombre, X
		LOCAL llExiste

		FOR X = 1 TO THIS._Ole_Obj_count
			IF THIS._Ole_Objs(X)._Nombre == tcNombre
				llExiste = .T.
				EXIT
			ENDIF
		ENDFOR

		RETURN llExiste
	ENDPROC

ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_OLE AS CL_BASE
	#IF .F.
		LOCAL THIS AS CL_OLE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_checksum" type="property" display="_CheckSum"/>] ;
		+ [<memberdata name="_nombre" type="property" display="_Nombre"/>] ;
		+ [<memberdata name="_objname" type="property" display="_ObjName"/>] ;
		+ [<memberdata name="_parent" type="property" display="_Parent"/>] ;
		+ [<memberdata name="_value" type="property" display="_Value"/>] ;
		+ [</VFPData>]

	_Nombre		= ''
	_Parent		= ''
	_ObjName	= ''
	_CheckSum	= ''
	_Value		= ''
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_CLASE AS CL_BASE
	#IF .F.
		LOCAL THIS AS CL_CLASE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="add_procedure" type="method" display="add_Procedure"/>] ;
		+ [<memberdata name="add_property" type="method" display="add_Property"/>] ;
		+ [<memberdata name="add_object" type="method" display="add_Object"/>] ;
		+ [<memberdata name="_addobject_count" type="property" display="_AddObject_Count"/>] ;
		+ [<memberdata name="_addobjects" type="property" display="_AddObjects"/>] ;
		+ [<memberdata name="_baseclass" type="property" display="_BaseClass"/>] ;
		+ [<memberdata name="_class" type="property" display="_Class"/>] ;
		+ [<memberdata name="_classicon" type="property" display="_ClassIcon"/>] ;
		+ [<memberdata name="_classloc" type="property" display="_ClassLoc"/>] ;
		+ [<memberdata name="_comentario" type="property" display="_Comentario"/>] ;
		+ [<memberdata name="_defined_pam" type="property" display="_Defined_PAM"/>] ;
		+ [<memberdata name="_definicion" type="property" display="_Definicion"/>] ;
		+ [<memberdata name="_fin" type="property" display="_Fin"/>] ;
		+ [<memberdata name="_fin_cab" type="property" display="_Fin_Cab"/>] ;
		+ [<memberdata name="_fin_cuerpo" type="property" display="_Fin_Cuerpo"/>] ;
		+ [<memberdata name="_hiddenmethods" type="property" display="_HiddenMethods"/>] ;
		+ [<memberdata name="_hiddenprops" type="property" display="_HiddenProps"/>] ;
		+ [<memberdata name="_includefile" type="property" display="_IncludeFile"/>] ;
		+ [<memberdata name="_inicio" type="property" display="_Inicio"/>] ;
		+ [<memberdata name="_ini_cab" type="property" display="_Ini_Cab"/>] ;
		+ [<memberdata name="_ini_cuerpo" type="property" display="_Ini_Cuerpo"/>] ;
		+ [<memberdata name="_metadata" type="property" display="_MetaData"/>] ;
		+ [<memberdata name="_nombre" type="property" display="_Nombre"/>] ;
		+ [<memberdata name="_objname" type="property" display="_ObjName"/>] ;
		+ [<memberdata name="_ole" type="property" display="_Ole"/>] ;
		+ [<memberdata name="_ole2" type="property" display="_Ole2"/>] ;
		+ [<memberdata name="_olepublic" type="property" display="_OlePublic"/>] ;
		+ [<memberdata name="_parent" type="property" display="_Parent"/>] ;
		+ [<memberdata name="_procedures" type="property" display="_Procedures"/>] ;
		+ [<memberdata name="_procedure_count" type="property" display="_Procedure_Count"/>] ;
		+ [<memberdata name="_projectclassicon" type="property" display="_ProjectClassIcon"/>] ;
		+ [<memberdata name="_protectedmethods" type="property" display="_ProtectedMethods"/>] ;
		+ [<memberdata name="_protectedprops" type="property" display="_ProtectedProps"/>] ;
		+ [<memberdata name="_props" type="property" display="_Props"/>] ;
		+ [<memberdata name="_prop_count" type="property" display="_Prop_Count"/>] ;
		+ [<memberdata name="_scale" type="property" display="_Scale"/>] ;
		+ [<memberdata name="_timestamp" type="property" display="_TimeStamp"/>] ;
		+ [<memberdata name="_uniqueid" type="property" display="_UniqueID"/>] ;
		+ [<memberdata name="_properties" type="property" display="_PROPERTIES"/>] ;
		+ [<memberdata name="_protected" type="property" display="_PROTECTED"/>] ;
		+ [<memberdata name="_methods" type="property" display="_METHODS"/>] ;
		+ [<memberdata name="_reserved1" type="property" display="_RESERVED1"/>] ;
		+ [<memberdata name="_reserved2" type="property" display="_RESERVED2"/>] ;
		+ [<memberdata name="_reserved3" type="property" display="_RESERVED3"/>] ;
		+ [<memberdata name="_reserved4" type="property" display="_RESERVED4"/>] ;
		+ [<memberdata name="_reserved5" type="property" display="_RESERVED5"/>] ;
		+ [<memberdata name="_reserved6" type="property" display="_RESERVED6"/>] ;
		+ [<memberdata name="_reserved7" type="property" display="_RESERVED7"/>] ;
		+ [<memberdata name="_reserved8" type="property" display="_RESERVED8"/>] ;
		+ [<memberdata name="_user" type="property" display="_USER"/>] ;
		+ [</VFPData>]


	DIMENSION _Props[1,2], _AddObjects[1], _Procedures[1]
	_Nombre				= ''
	_ObjName			= ''
	_Parent				= ''
	_Definicion			= ''
	_Class				= ''
	_ClassLoc			= ''
	_OlePublic			= ''
	_Ole				= ''
	_Ole2				= ''
	_UniqueID			= ''
	_Comentario			= ''
	_ClassIcon			= ''
	_ProjectClassIcon	= ''
	_Inicio				= 0
	_Fin				= 0
	_Ini_Cab			= 0
	_Fin_Cab			= 0
	_Ini_Cuerpo			= 0
	_Fin_Cuerpo			= 0
	_Prop_Count			= 0
	_HiddenProps		= ''
	_ProtectedProps		= ''
	_HiddenMethods		= ''
	_ProtectedMethods	= ''
	_MetaData			= ''
	_BaseClass			= ''
	_TimeStamp			= ''
	_Scale				= ''
	_Defined_PAM		= ''
	_includeFile		= ''
	_AddObject_Count	= 0
	_Procedure_Count	= 0
	_PROPERTIES			= ''
	_PROTECTED			= ''
	_METHODS			= ''
	_RESERVED1			= ''
	_RESERVED2			= ''
	_RESERVED3			= ''
	_RESERVED4			= ''
	_RESERVED5			= ''
	_RESERVED6			= ''
	_RESERVED7			= ''
	_RESERVED8			= ''
	_User				= ''


	************************************************************************************************
	PROCEDURE add_Procedure
		LPARAMETERS toProcedure

		#IF .F.
			LOCAL toProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		THIS._Procedure_Count	= THIS._Procedure_Count + 1
		DIMENSION THIS._Procedures( THIS._Procedure_Count )
		THIS._Procedures( THIS._Procedure_Count )	= toProcedure
	ENDPROC


	************************************************************************************************
	PROCEDURE add_Property
		LPARAMETERS tcProperty AS STRING, tcValue AS STRING, tcComment AS STRING
		THIS._Prop_Count	= THIS._Prop_Count + 1
		DIMENSION THIS._Props( THIS._Prop_Count, 3 )
		THIS._Props( THIS._Prop_Count, 1 )	= tcProperty
		THIS._Props( THIS._Prop_Count, 2 )	= tcValue
		THIS._Props( THIS._Prop_Count, 3 )	= tcComment
	ENDPROC


	************************************************************************************************
	PROCEDURE add_Object
		LPARAMETERS toObjeto

		#IF .F.
			LOCAL toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		THIS._AddObject_Count	= THIS._AddObject_Count + 1
		DIMENSION THIS._AddObjects( THIS._AddObject_Count )
		THIS._AddObjects( THIS._AddObject_Count )	= toObjeto
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROCEDURE AS CL_BASE
	#IF .F.
		LOCAL THIS AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="add_line" type="method" display="add_Line"/>] ;
		+ [<memberdata name="_comentario" type="property" display="_Comentario"/>] ;
		+ [<memberdata name="_nombre" type="property" display="_Nombre"/>] ;
		+ [<memberdata name="_procline_count" type="property" display="_ProcLine_Count"/>] ;
		+ [<memberdata name="_proclines" type="property" display="_ProcLines"/>] ;
		+ [<memberdata name="_proctype" type="property" display="_ProcType"/>] ;
		+ [</VFPData>]

	DIMENSION _ProcLines[1]
	_Nombre			= ''
	_ProcType		= ''
	_Comentario		= ''
	_ProcLine_Count	= 0


	************************************************************************************************
	PROCEDURE add_Line
		LPARAMETERS tcLine AS STRING
		THIS._ProcLine_Count	= THIS._ProcLine_Count + 1
		DIMENSION THIS._ProcLines( THIS._ProcLine_Count )
		THIS._ProcLines( THIS._ProcLine_Count )	= tcLine
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_OBJETO AS CL_BASE
	#IF .F.
		LOCAL THIS AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="add_procedure" type="method" display="add_Procedure"/>] ;
		+ [<memberdata name="add_property" type="method" display="add_Property"/>] ;
		+ [<memberdata name="_baseclass" type="property" display="_BaseClass"/>] ;
		+ [<memberdata name="_class" type="property" display="_Class"/>] ;
		+ [<memberdata name="_classlib" type="property" display="_ClassLib"/>] ;
		+ [<memberdata name="_nombre" type="property" display="_Nombre"/>] ;
		+ [<memberdata name="_objname" type="property" display="_ObjName"/>] ;
		+ [<memberdata name="_ole" type="property" display="_Ole"/>] ;
		+ [<memberdata name="_ole2" type="property" display="_Ole2"/>] ;
		+ [<memberdata name="_parent" type="property" display="_Parent"/>] ;
		+ [<memberdata name="_writeorder" type="property" display="_WriteOrder"/>] ;
		+ [<memberdata name="_procedures" type="property" display="_Procedures"/>] ;
		+ [<memberdata name="_procedure_count" type="property" display="_Procedure_Count"/>] ;
		+ [<memberdata name="_props" type="property" display="_Props"/>] ;
		+ [<memberdata name="_prop_count" type="property" display="_Prop_Count"/>] ;
		+ [<memberdata name="_timestamp" type="property" display="_TimeStamp"/>] ;
		+ [<memberdata name="_uniqueid" type="property" display="_UniqueID"/>] ;
		+ [<memberdata name="_user" type="property" display="_User"/>] ;
		+ [<memberdata name="_zorder" type="property" display="_ZOrder"/>] ;
		+ [</VFPData>]

	DIMENSION _Props[1,1], _Procedures[1]
	_Nombre				= ''
	_ObjName			= ''
	_Parent				= ''
	_Class				= ''
	_ClassLib			= ''
	_BaseClass			= ''
	_UniqueID			= ''
	_TimeStamp			= 0
	_Ole				= ''
	_Ole2				= ''
	_Prop_Count			= 0
	_Procedure_Count	= 0
	_User				= ''
	_WriteOrder			= 0
	_ZOrder				= 0


	************************************************************************************************
	PROCEDURE add_Procedure
		LPARAMETERS toProcedure

		#IF .F.
			LOCAL toProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		IF '.' $ THIS._Nombre
			toProcedure._Nombre	= SUBSTR( toProcedure._Nombre, AT( '.', toProcedure._Nombre, OCCURS( '.', THIS._Nombre) ) + 1 )
		ENDIF

		THIS._Procedure_Count	= THIS._Procedure_Count + 1
		DIMENSION THIS._Procedures( THIS._Procedure_Count )
		THIS._Procedures( THIS._Procedure_Count )	= toProcedure
	ENDPROC


	************************************************************************************************
	PROCEDURE add_Property
		LPARAMETERS tcProperty AS STRING, tcValue AS STRING
		THIS._Prop_Count	= THIS._Prop_Count + 1
		DIMENSION THIS._Props( THIS._Prop_Count, 2 )
		THIS._Props( THIS._Prop_Count, 1 )	= tcProperty
		THIS._Props( THIS._Prop_Count, 2 )	= tcValue
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_REPORT AS COLLECTION
	#IF .F.
		LOCAL THIS AS CL_REPORT OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades. CLASS,
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="l_debug" type="property" display="l_Debug"/>] ;
		+ [<memberdata name="_sourcefile" type="property" display="_SourceFile"/>] ;
		+ [<memberdata name="_timestamp" type="property" display="_TimeStamp"/>] ;
		+ [<memberdata name="_version" type="property" display="_Version"/>] ;
		+ [<memberdata name="_sourcefile" type="property" display="_SourceFile"/>] ;
		+ [<memberdata name="l_debug" type="method" display="l_Debug"/>] ;
		+ [</VFPData>]

	*-- Proj.Info
	l_Debug				= .F.
	_TimeStamp			= 0
	_Version			= ''
	_SourceFile			= ''


	************************************************************************************************
	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF
		SET TABLEPROMPT OFF

		THIS.l_Debug	= (_VFP.STARTMODE=0)
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJECT AS COLLECTION
	#IF .F.
		LOCAL THIS AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades. CLASS,
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_cmntstyle" type="property" display="_CmntStyle"/>] ;
		+ [<memberdata name="_debug" type="property" display="_Debug"/>] ;
		+ [<memberdata name="_encrypted" type="property" display="_Encrypted"/>] ;
		+ [<memberdata name="_homedir" type="property" display="_HomeDir"/>] ;
		+ [<memberdata name="_icon" type="property" display="_Icon"/>] ;
		+ [<memberdata name="_mainprog" type="property" display="_MainProg"/>] ;
		+ [<memberdata name="_nologo" type="property" display="_NoLogo"/>] ;
		+ [<memberdata name="_objrev" type="property" display="_ObjRev"/>] ;
		+ [<memberdata name="_projecthookclass" type="property" display="_ProjectHookClass"/>] ;
		+ [<memberdata name="_projecthooklibrary" type="property" display="_ProjectHookLibrary"/>] ;
		+ [<memberdata name="_savecode" type="property" display="_SaveCode"/>] ;
		+ [<memberdata name="_serverinfo" type="property" display="_ServerInfo"/>] ;
		+ [<memberdata name="_serverhead" type="property" display="_ServerHead"/>] ;
		+ [<memberdata name="_sourcefile" type="property" display="_SourceFile"/>] ;
		+ [<memberdata name="_timestamp" type="property" display="_TimeStamp"/>] ;
		+ [<memberdata name="_version" type="property" display="_Version"/>] ;
		+ [<memberdata name="_address" type="property" display="_Address"/>] ;
		+ [<memberdata name="_autor" type="property" display="_Autor"/>] ;
		+ [<memberdata name="_company" type="property" display="_Company"/>] ;
		+ [<memberdata name="_city" type="property" display="_City"/>] ;
		+ [<memberdata name="_state" type="property" display="_State"/>] ;
		+ [<memberdata name="_postalcode" type="property" display="_PostalCode"/>] ;
		+ [<memberdata name="_country" type="property" display="_Country"/>] ;
		+ [<memberdata name="_comments" type="property" display="_Comments"/>] ;
		+ [<memberdata name="_companyname" type="property" display="_CompanyName"/>] ;
		+ [<memberdata name="_filedescription" type="property" display="_FileDescription"/>] ;
		+ [<memberdata name="_legalcopyright" type="property" display="_LegalCopyright"/>] ;
		+ [<memberdata name="_legaltrademark" type="property" display="_LegalTrademark"/>] ;
		+ [<memberdata name="_productname" type="property" display="_ProductName"/>] ;
		+ [<memberdata name="_majorver" type="property" display="_MajorVer"/>] ;
		+ [<memberdata name="_minorver" type="property" display="_MinorVer"/>] ;
		+ [<memberdata name="_revision" type="property" display="_Revision"/>] ;
		+ [<memberdata name="_languageid" type="property" display="_LanguageID"/>] ;
		+ [<memberdata name="_autoincrement" type="property" display="_AutoIncrement"/>] ;
		+ [<memberdata name="getformatteddeviceinfotext" type="method" display="getFormattedDeviceInfoText"/>] ;
		+ [<memberdata name="parsedeviceinfo" type="method" display="parseDeviceInfo"/>] ;
		+ [<memberdata name="parsenullterminatedvalue" type="method" display="parseNullTerminatedValue"/>] ;
		+ [<memberdata name="setparsedinfoline" type="method" display="setParsedInfoLine"/>] ;
		+ [<memberdata name="setparsedprojinfoline" type="method" display="setParsedProjInfoLine"/>] ;
		+ [<memberdata name="getrowdeviceinfo" type="method" display="getRowDeviceInfo"/>] ;
		+ [<memberdata name="l_debug" type="method" display="l_Debug"/>] ;
		+ [</VFPData>]


	*-- Proj.Info
	_CmntStyle			= 1
	_Debug				= .F.
	_Encrypted			= .F.
	_HomeDir			= ''
	_Icon				= ''
	_ID					= ''
	_MainProg			= ''
	_NoLogo				= .F.
	_ObjRev				= 0
	_ProjectHookClass	= ''
	_ProjectHookLibrary	= ''
	_SaveCode			= .T.
	_ServerHead			= NULL
	_ServerInfo			= ''
	_SourceFile			= ''
	_TimeStamp			= 0
	_Version			= ''

	*-- Dev.info
	_Autor				= ''
	_Company			= ''
	_Address			= ''
	_City				= ''
	_State				= ''
	_PostalCode			= ''
	_Country			= ''

	_Comments			= ''
	_CompanyName		= ''
	_FileDescription	= ''
	_LegalCopyright		= ''
	_LegalTrademark		= ''
	_ProductName		= ''
	_MajorVer			= ''
	_MinorVer			= ''
	_Revision			= ''
	_LanguageID			= ''
	_AutoIncrement		= ''
	l_Debug				= .F.


	************************************************************************************************
	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF
		SET TABLEPROMPT OFF

		THIS.l_Debug	= (_VFP.STARTMODE=0)
		THIS._ServerHead	= CREATEOBJECT('CL_PROJ_SRV_HEAD')
	ENDPROC


	************************************************************************************************
	PROCEDURE setParsedProjInfoLine
		LPARAMETERS tcProjInfoLine
		THIS.setParsedInfoLine( THIS, tcProjInfoLine )
	ENDPROC


	************************************************************************************************
	PROCEDURE setParsedInfoLine
		LPARAMETERS toObject, tcInfoLine
		LOCAL lcAsignacion, lcCurDir
		lcCurDir	= ADDBS(JUSTPATH(THIS._SourceFile))
		IF LEFT(tcInfoLine,1) == '.'
			lcAsignacion	= 'toObject' + tcInfoLine
		ELSE
			lcAsignacion	= 'toObject.' + tcInfoLine
		ENDIF
		&lcAsignacion.
	ENDPROC


	************************************************************************************************
	PROCEDURE parseNullTerminatedValue
		LPARAMETERS tcDevInfo, tnPos, tnLen
		LOCAL lcValue, lnNullPos
		lcStr		= SUBSTR( tcDevInfo, tnPos, tnLen )
		lnNullPos	= AT(CHR(0), lcStr )
		IF lnNullPos = 0
			lcValue		= CHRTRAN( LEFT( lcStr, tnLen ), ['], ["] )
		ELSE
			lcValue		= CHRTRAN( LEFT( lcStr, MIN(tnLen, lnNullPos - 1 ) ), ['], ["] )
		ENDIF
		RETURN lcValue
	ENDPROC


	************************************************************************************************
	PROCEDURE parseDeviceInfo
		LPARAMETERS tcDevInfo

		TRY
			WITH THIS
				._Autor				= .parseNullTerminatedValue( @tcDevInfo, 1, 45 )
				._Company			= .parseNullTerminatedValue( @tcDevInfo, 47, 45 )
				._Address			= .parseNullTerminatedValue( @tcDevInfo, 93, 45 )
				._City				= .parseNullTerminatedValue( @tcDevInfo, 139, 20 )
				._State				= .parseNullTerminatedValue( @tcDevInfo, 160, 5 )
				._PostalCode		= .parseNullTerminatedValue( @tcDevInfo, 166, 10 )
				._Country			= .parseNullTerminatedValue( @tcDevInfo, 177, 45 )
				*--
				._Comments			= .parseNullTerminatedValue( @tcDevInfo, 223, 254 )
				._CompanyName		= .parseNullTerminatedValue( @tcDevInfo, 478, 254 )
				._FileDescription	= .parseNullTerminatedValue( @tcDevInfo, 733, 254 )
				._LegalCopyright	= .parseNullTerminatedValue( @tcDevInfo, 988, 254 )
				._LegalTrademark	= .parseNullTerminatedValue( @tcDevInfo, 1243, 254 )
				._ProductName		= .parseNullTerminatedValue( @tcDevInfo, 1498, 254 )
				._MajorVer			= .parseNullTerminatedValue( @tcDevInfo, 1753, 4 )
				._MinorVer			= .parseNullTerminatedValue( @tcDevInfo, 1758, 4 )
				._Revision			= .parseNullTerminatedValue( @tcDevInfo, 1763, 4 )
				._LanguageID		= .parseNullTerminatedValue( @tcDevInfo, 1768, 19 )
				._AutoIncrement		= IIF( SUBSTR( tcDevInfo, 1788, 1 ) = CHR(1), '1', '0' )
			ENDWITH && THIS

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

	ENDPROC


	************************************************************************************************
	PROCEDURE getRowDeviceInfo
		LPARAMETERS tcDevInfo

		TRY
			IF VARTYPE(tcDevInfo) # 'C' OR LEN(tcDevInfo) = 0
				tcDevInfo	= REPLICATE( CHR(0), 1795 )
			ENDIF

			WITH THIS
				tcDevInfo	= STUFF( tcDevInfo, 1, LEN(._Autor), ._Autor)
				tcDevInfo	= STUFF( tcDevInfo, 47, LEN(._Company), ._Company)
				tcDevInfo	= STUFF( tcDevInfo, 93, LEN(._Address), ._Address)
				tcDevInfo	= STUFF( tcDevInfo, 139, LEN(._City), ._City)
				tcDevInfo	= STUFF( tcDevInfo, 160, LEN(._State), ._State)
				tcDevInfo	= STUFF( tcDevInfo, 166, LEN(._PostalCode), ._PostalCode)
				tcDevInfo	= STUFF( tcDevInfo, 177, LEN(._Country), ._Country)
				tcDevInfo	= STUFF( tcDevInfo, 223, LEN(._Comments), ._Comments)
				tcDevInfo	= STUFF( tcDevInfo, 478, LEN(._CompanyName), ._CompanyName)
				tcDevInfo	= STUFF( tcDevInfo, 733, LEN(._FileDescription), ._FileDescription)
				tcDevInfo	= STUFF( tcDevInfo, 988, LEN(._LegalCopyright), ._LegalCopyright)
				tcDevInfo	= STUFF( tcDevInfo, 1243, LEN(._LegalTrademark), ._LegalTrademark)
				tcDevInfo	= STUFF( tcDevInfo, 1498, LEN(._ProductName), ._ProductName)
				tcDevInfo	= STUFF( tcDevInfo, 1753, LEN(._MajorVer), ._MajorVer)
				tcDevInfo	= STUFF( tcDevInfo, 1758, LEN(._MinorVer), ._MinorVer)
				tcDevInfo	= STUFF( tcDevInfo, 1763, LEN(._Revision), ._Revision)
				tcDevInfo	= STUFF( tcDevInfo, 1768, LEN(._LanguageID), ._LanguageID)
				tcDevInfo	= STUFF( tcDevInfo, 1788, 1, CHR(VAL(._AutoIncrement)))
				tcDevInfo	= STUFF( tcDevInfo, 1792, 1, CHR(1))
			ENDWITH && THIS

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN tcDevInfo
	ENDPROC


	************************************************************************************************
	PROCEDURE getFormattedDeviceInfoText
		TRY
			LOCAL lcText
			lcText		= ''

			WITH THIS
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_DEVINFO_I>>
				_Autor = "<<._Autor>>"
				_Company = "<<._Company>>"
				_Address = "<<._Address>>"
				_City = "<<._City>>"
				_State = "<<._State>>"
				_PostalCode = "<<._PostalCode>>"
				_Country = "<<._Country>>"
				*--
				_Comments = "<<._Comments>>"
				_CompanyName = "<<._CompanyName>>"
				_FileDescription = "<<._FileDescription>>"
				_LegalCopyright = "<<._LegalCopyright>>"
				_LegalTrademark = "<<._LegalTrademark>>"
				_ProductName = "<<._ProductName>>"
				_MajorVer = "<<._MajorVer>>"
				_MinorVer = "<<._MinorVer>>"
				_Revision = "<<._Revision>>"
				_LanguageID = "<<._LanguageID>>"
				_AutoIncrement = "<<._AutoIncrement>>"
				<<C_DEVINFO_F>>

				ENDTEXT
			ENDWITH && THIS

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJ_SRV_HEAD AS CL_BASE
	#IF .F.
		LOCAL THIS AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_internalname" type="property" display="_InternalName"/>] ;
		+ [<memberdata name="_libraryname" type="property" display="_LibraryName"/>] ;
		+ [<memberdata name="_projectname" type="property" display="_ProjectName"/>] ;
		+ [<memberdata name="_servercount" type="property" display="_ServerCount"/>] ;
		+ [<memberdata name="_servers" type="property" display="_Servers"/>] ;
		+ [<memberdata name="_servertype" type="property" display="_ServerType"/>] ;
		+ [<memberdata name="_typelib" type="property" display="_TypeLib"/>] ;
		+ [<memberdata name="_typelibdesc" type="property" display="_TypeLibDesc"/>] ;
		+ [<memberdata name="add_server" type="method" display="add_Server"/>] ;
		+ [<memberdata name="getdatafrompair_lendata_structure" type="method" display="getDataFromPair_LenData_Structure"/>] ;
		+ [<memberdata name="getformattedservertext" type="method" display="getFormattedServerText"/>] ;
		+ [<memberdata name="getrowserverinfo" type="method" display="getRowServerInfo"/>] ;
		+ [<memberdata name="getserverdataobject" type="method" display="getServerDataObject"/>] ;
		+ [<memberdata name="parseserverinfo" type="property" display="parseServerInfo"/>] ;
		+ [<memberdata name="setparsedheadinfoline" type="property" display="setParsedHeadInfoLine"/>] ;
		+ [<memberdata name="setparsedinfoline" type="property" display="setParsedInfoLine"/>] ;
		+ [</VFPData>]

	*-- Información interesante sobre Servidores OLE y corrupción de IDs: http://www.west-wind.com/wconnect/weblog/ShowEntry.blog?id=880

	*-- Server Head info
	DIMENSION _Servers[1]
	_ServerCount		= 0
	_LibraryName		= ''
	_InternalName		= ''
	_ProjectName		= ''
	_TypeLibDesc		= ''
	_ServerType			= ''
	_TypeLib			= ''


	************************************************************************************************
	PROCEDURE setParsedHeadInfoLine
		LPARAMETERS tcHeadInfoLine
		THIS.setParsedInfoLine( THIS, tcHeadInfoLine )
	ENDPROC


	************************************************************************************************
	PROCEDURE setParsedInfoLine
		LPARAMETERS toObject, tcInfoLine
		LOCAL lcAsignacion, lcCurDir
		IF LEFT(tcInfoLine,1) == '.'
			lcAsignacion	= 'toObject' + tcInfoLine
		ELSE
			lcAsignacion	= 'toObject.' + tcInfoLine
		ENDIF
		&lcAsignacion.
	ENDPROC


	************************************************************************************************
	PROCEDURE add_Server
		LPARAMETERS toServer

		#IF .F.
			LOCAL toServer AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'
		#ENDIF

		THIS._ServerCount	= THIS._ServerCount + 1
		DIMENSION THIS._Servers( THIS._ServerCount )
		THIS._Servers( THIS._ServerCount )	= toServer
	ENDPROC


	************************************************************************************************
	PROCEDURE getDataFromPair_LenData_Structure
		LPARAMETERS tcData, tnPos, tnLen
		LOCAL lcData, lnLen
		tnPos	= tnPos + 4 + tnLen
		tnLen	= INT( VAL( SUBSTR( tcData, tnPos, 4 ) ) )
		lcData	= SUBSTR( tcData, tnPos + 4, tnLen )
		RETURN lcData
	ENDPROC


	PROCEDURE getServerDataObject
		RETURN CREATEOBJECT('CL_PROJ_SRV_DATA')
	ENDPROC


	************************************************************************************************
	PROCEDURE parseServerInfo
		LPARAMETERS tcServerInfo

		IF NOT EMPTY(tcServerInfo)
			TRY
				LOCAL loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

				WITH THIS
					lcStr			= ''
					lnPos			= 1
					lnLen			= 4

					lnServerCount	= INT( VAL( .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen ) ) )
					._LibraryName	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
					._InternalName	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
					._ProjectName	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
					._TypeLibDesc	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
					._ServerType	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
					._TypeLib		= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )

					*-- Información de los servidores
					FOR I = 1 TO lnServerCount
						loServerData	= NULL
						loServerData	= .getServerDataObject()

						loServerData._HelpContextID	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._ServerName	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._Description	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._HelpFile		= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._ServerClass	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._ClassLibrary	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._Instancing	= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._CLSID			= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )
						loServerData._Interface		= .getDataFromPair_LenData_Structure( @tcServerInfo, @lnPos, @lnLen )

						THIS.add_Server( loServerData )
					ENDFOR

				ENDWITH && THIS
				loServerData	= NULL

			CATCH TO loEx
				IF THIS.l_Debug AND _VFP.STARTMODE = 0
					SET STEP ON
				ENDIF

				THROW

			ENDTRY

		ENDIF
	ENDPROC


	************************************************************************************************
	PROCEDURE getRowServerInfo
		TRY
			LOCAL lcStr, lnLenH, lnLen, lnPos ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

			lcStr				= ''

			IF THIS._ServerCount > 0
				WITH THIS
					lnPos		= 1
					lnLen		= 4
					lnLenH		= 8 + LEN(._LibraryName) + 4 + LEN(._InternalName) + 4 + LEN(._ProjectName) + 4 + LEN(._TypeLibDesc) - 1

					*-- Header
					lcStr		= lcStr + PADL( 4, 4, ' ' ) + PADL( lnLenH, 4, ' ' )
					lcStr		= lcStr + PADL( 4, 4, ' ' ) + PADL( ._ServerCount, 4, ' ' )
					lcStr		= lcStr + PADL( LEN(._LibraryName), 4, ' ' ) + ._LibraryName
					lcStr		= lcStr + PADL( LEN(._InternalName), 4, ' ' ) + ._InternalName
					lcStr		= lcStr + PADL( LEN(._ProjectName), 4, ' ' ) + ._ProjectName
					lcStr		= lcStr + PADL( LEN(._TypeLibDesc), 4, ' ' ) + ._TypeLibDesc
					lcStr		= lcStr + PADL( LEN(._ServerType), 4, ' ' ) + ._ServerType
					lcStr		= lcStr + PADL( LEN(._TypeLib), 4, ' ' ) + ._TypeLib

					FOR I = 1 TO ._ServerCount
						loServerData	= ._Servers(I)
						lcStr		= lcStr + loServerData.getRowServerInfo()
					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcStr
	ENDPROC


	************************************************************************************************
	PROCEDURE getFormattedServerText
		TRY
			LOCAL lcText ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'
			lcText	= ''

			TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
			<<C_SRV_HEAD_I>>
			_LibraryName = '<<THIS._LibraryName>>'
			_InternalName = '<<THIS._InternalName>>'
			_ProjectName = '<<THIS._ProjectName>>'
			_TypeLibDesc = '<<THIS._TypeLibDesc>>'
			_ServerType = '<<THIS._ServerType>>'
			_TypeLib = '<<THIS._TypeLib>>'
			<<C_SRV_HEAD_F>>
			ENDTEXT

			*-- Recorro los servidores
			FOR I = 1 TO THIS._ServerCount
				loServerData	= THIS._Servers(I)
				lcText			= lcText + loServerData.getFormattedServerText()
				loServerData	= NULL
			ENDFOR

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJ_SRV_DATA AS CL_BASE
	#IF .F.
		LOCAL THIS AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_classlibrary" type="property" display="_ClassLibrary"/>] ;
		+ [<memberdata name="_clsid" type="property" display="_CLSID"/>] ;
		+ [<memberdata name="_description" type="property" display="_Description"/>] ;
		+ [<memberdata name="_helpcontextid" type="property" display="_HelpContextID"/>] ;
		+ [<memberdata name="_helpfile" type="property" display="_HelpFile"/>] ;
		+ [<memberdata name="_interface" type="property" display="_Interface"/>] ;
		+ [<memberdata name="_instancing" type="property" display="_Instancing"/>] ;
		+ [<memberdata name="_serverclass" type="property" display="_ServerClass"/>] ;
		+ [<memberdata name="_servername" type="property" display="_ServerName"/>] ;
		+ [<memberdata name="getformattedservertext" type="method" display="getFormattedServerText"/>] ;
		+ [<memberdata name="getrowserverinfo" type="method" display="getRowServerInfo"/>] ;
		+ [</VFPData>]

	_HelpContextID	= 0
	_ServerName		= ''
	_Description	= ''
	_HelpFile		= ''
	_ServerClass	= ''
	_ClassLibrary	= ''
	_Instancing		= 0
	_CLSID			= ''
	_Interface		= ''


	************************************************************************************************
	PROCEDURE getRowServerInfo
		TRY
			LOCAL lcStr, lnLen, lnPos

			lcStr				= ''

			IF NOT EMPTY(THIS._ServerName)
				WITH THIS
					lnPos				= 1
					lnLen				= 4

					*-- Data
					lcStr	= lcStr + PADL( LEN(._HelpContextID), 4, ' ' ) + ._HelpContextID
					lcStr	= lcStr + PADL( LEN(._ServerName), 4, ' ' ) + ._ServerName
					lcStr	= lcStr + PADL( LEN(._Description), 4, ' ' ) + ._Description
					lcStr	= lcStr + PADL( LEN(._HelpFile), 4, ' ' ) + ._HelpFile
					lcStr	= lcStr + PADL( LEN(._ServerClass), 4, ' ' ) + ._ServerClass
					lcStr	= lcStr + PADL( LEN(._ClassLibrary), 4, ' ' ) + ._ClassLibrary
					lcStr	= lcStr + PADL( LEN(._Instancing), 4, ' ' ) + ._Instancing
					lcStr	= lcStr + PADL( LEN(._CLSID), 4, ' ' ) + ._CLSID
					lcStr	= lcStr + PADL( LEN(._Interface), 4, ' ' ) + ._Interface
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcStr
	ENDPROC


	************************************************************************************************
	PROCEDURE getFormattedServerText
		TRY
			LOCAL lcText
			lcText	= ''

			WITH THIS
				TEXT TO lcText ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_SRV_DATA_I>>
				_HelpContextID = '<<._HelpContextID>>'
				_ServerName = '<<._ServerName>>'
				_Description = '<<._Description>>'
				_HelpFile = '<<._HelpFile>>'
				_ServerClass = '<<._ServerClass>>'
				_ClassLibrary = '<<._ClassLibrary>>'
				_Instancing = '<<._Instancing>>'
				_CLSID = '<<._CLSID>>'
				_Interface = '<<._Interface>>'
				<<C_SRV_DATA_F>>
				ENDTEXT
			ENDWITH

		CATCH TO loEx
			IF THIS.l_Debug AND _VFP.STARTMODE = 0
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC

ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJ_FILE AS CL_BASE
	#IF .F.
		LOCAL THIS AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_comments" type="property" display="_Comments"/>] ;
		+ [<memberdata name="_cpid" type="property" display="_CPID"/>] ;
		+ [<memberdata name="_exclude" type="property" display="_Exclude"/>] ;
		+ [<memberdata name="_id" type="property" display="_ID"/>] ;
		+ [<memberdata name="_name" type="property" display="_Name"/>] ;
		+ [<memberdata name="_objrev" type="property" display="_ObjRev"/>] ;
		+ [<memberdata name="_timestamp" type="property" display="_Timestamp"/>] ;
		+ [<memberdata name="_type" type="property" display="_Type"/>] ;
		+ [</VFPData>]

	_Name				= ''
	_Type				= ''
	_Exclude			= .F.
	_Comments			= ''
	_CPID				= 0
	_ID					= 0
	_ObjRev				= 0
	_TimeStamp			= 0

ENDDEFINE

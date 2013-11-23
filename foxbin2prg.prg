*---------------------------------------------------------------------------------------------------
* Módulo.........: FOXBIN2PRG.PRG
* Autor..........: Fernando D. Bozzo (mailto:fdbozzo@gmail.com)
* Fecha creación.: 04/11/2013
*
* LICENCIA:	Reconocimiento – CompartirIgual (by-sa):
* 		Se permite el uso comercial de la obra y de las posibles obras derivadas, la distribución de las cuales
* 		se debe hacer con una licencia igual a la que regula la obra original.
* 		(http://es.creativecommons.org/blog/licencias/)
*
*---------------------------------------------------------------------------------------------------
* DESCRIPCIÓN....: CONVIERTE EL ARCHIVO VCX/SCX/PJX INDICADO A UN "PRG HÍBRIDO" PARA POSTERIOR RECONVERSIÓN.
*                  * EL PRG HÍBRIDO ES UN PRG CON ALGUNAS SECCIONES BINARIAS (OLE DATA, ETC)
*                  * EL OBJETIVO ES PODER USARLO COMO REEMPLAZO DEL SCCTEXT.PRG, PODER HACER MERGE
*                  DEL CÓDIGO DIRECTAMENTE SOBRE ESTE NUEVO PRG Y GUARDARLO EN UNA HERRAMIENTA DE SCM
*                  COMO CVS O SIMILAR SIN NECESIDAD DE GUARDAR LOS BINARIOS ORIGINALES.
*                  * EXTENSIONES GENERADAS: VC2, SC2, PJ2
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
* 04/11/2013	FDBOZZO		Creación inicial de las clases y soporte de los archivos VCX
*
*---------------------------------------------------------------------------------------------------
* TRAMIENTOS ESPECIALES DE ASIGNACIONES DE PROPIEDADES:
*	PROPIEDAD				ARREGLO Y EJEMPLO
*-------------------------	--------------------------------------------------------------------------------------
*	_memberdata				Se le agregan los delimitadores [] para que compile
*	props =					Se le agrega "" para que compile. Ej: props = 				==> props = ""
*	props =	BadCahrValue	Se le agrega "" para que compile. Ej: props = ###			==> props = "###"
*
*---------------------------------------------------------------------------------------------------
* PARÁMETROS:				!=Obligatorio, ?=Opcional, @=Pasar por referencia, v=Pasar por valor (IN/OUT)
* tc_InputFile				(v! IN    ) Nombre completo (fullpath) del archivo a convertir
* tcType_na					(         ) Por ahora se mantiene por compatibilidad con SCCTEXT.PRG
* tcTextName_na				(         ) Por ahora se mantiene por compatibilidad con SCCTEXT.PRG
* tlGenText_na				(         ) Por ahora se mantiene por compatibilidad con SCCTEXT.PRG
* tcDontShowErrors			(v? IN    ) '1' para NO mostrar errores con MESSAGEBOX
* tcDebug					(v? IN    ) '1' para depurar en el sitio donde ocurre el error (solo modo desarrollo)
*
*							Ej: DO FOXBIN2PRG.PRG WITH "C:\DESA\INTEGRACION\LIBRERIA.VCX"
*---------------------------------------------------------------------------------------------------
LPARAMETERS tc_InputFile, tcType_na, tcTextName_na, tlGenText_na, tcDontShowErrors, tcDebug

*-- Internacionalización / Internationalization
*-- Fin / End

*-- NO modificar! / Do NOT change!
#DEFINE C_CMT_I			'*--'
#DEFINE C_CMT_F			'--*'
#DEFINE C_METADATA_I	'*< CLASSDATA:'
#DEFINE C_METADATA_F	'/>'
#DEFINE C_OLE_I			'*< OLE:'
#DEFINE C_OLE_F			'/>'
#DEFINE C_DEFINED_PEM_I	'*< DEFINED_PEM:'
#DEFINE C_DEFINED_PEM_F	'/>'
#DEFINE C_END_OBJECT_I	'*< END OBJECT:'
#DEFINE C_END_OBJECT_F	'/>'
#DEFINE C_FB2PRG_META_I	'*< FOXBIN2PRG:'
#DEFINE C_FB2PRG_META_F	'/>'
#DEFINE C_DEFINE_CLASS	'DEFINE CLASS'
#DEFINE C_ENDDEFINE		'ENDDEFINE'
#DEFINE C_TEXT			'TEXT'
#DEFINE C_ENDTEXT		'ENDTEXT'
#DEFINE C_PROCEDURE		'PROCEDURE'
#DEFINE C_ENDPROC		'ENDPROC'
#DEFINE C_SRV_HEAD_I	'*<ServerHead>'
#DEFINE C_SRV_HEAD_F	'*</ServerHead>'
#DEFINE C_SRV_DATA_I	'*<ServerData>'
#DEFINE C_SRV_DATA_F	'*</ServerData>'
#DEFINE C_DEVINFO_I		'*<DevInfo>'
#DEFINE C_DEVINFO_F		'*</DevInfo>'
#DEFINE C_BUILDPROJ_I	'*<BuildProj>'
#DEFINE C_BUILDPROJ_F	'*</BuildProj>'
#DEFINE C_PROJPROPS_I	'*<ProjectProperties>'
#DEFINE C_PROJPROPS_F	'*</ProjectProperties>'
#DEFINE C_FILE_CMTS_I	'*<FileComments>'
#DEFINE C_FILE_CMTS_F	'*</FileComments>'
#DEFINE C_FILE_EXCL_I	'*<ExcludedFiles>'
#DEFINE C_FILE_EXCL_F	'*</ExcludedFiles>'
#DEFINE C_FILE_TXT_I	'*<TextFiles>'
#DEFINE C_FILE_TXT_F	'*</TextFiles>'
#DEFINE C_TAB			CHR(9)
#DEFINE C_CR			CHR(13)
#DEFINE C_LF			CHR(10)
#DEFINE CR_LF			C_CR + C_LF
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

LOCAL lcSys16, lcPath, lnResp, loCnv AS c_foxbin2prg OF 'FOXBIN2PRG.PRG'
lnResp	= 0

IF EMPTY(tc_InputFile) OR NOT FILE(tc_InputFile)
	lnResp	= 1
ELSE
	lcSys16	= SYS(16)
	lcPath	= SET("Path")
	SET PATH TO (JUSTPATH(lcSys16))
	CD (JUSTPATH(tc_InputFile))
	loCnv	= CREATEOBJECT("c_foxbin2prg")
	loCnv.l_Debug		= (TRANSFORM(tcDebug)=='1')
	loCnv.l_ShowErrors	= NOT (TRANSFORM(tcDontShowErrors) == '1')
	lnResp = loCnv.Convertir( tc_InputFile )
	CD (JUSTPATH(lcSys16))
	SET PATH TO (lcPath)
ENDIF

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
		+ [<memberdata name="l_debug" type="property" display="l_Debug"/>] ;
		+ [<memberdata name="l_showerrors" type="property" display="l_ShowErrors"/>] ;
		+ [<memberdata name="c_inputfile" type="property" display="c_inputFile"/>] ;
		+ [<memberdata name="c_outputfile" type="property" display="c_outputFile"/>] ;
		+ [<memberdata name="o_conversor" type="property" display="o_Conversor"/>] ;
		+ [<memberdata name="n_fb2prg_version" type="property" display="n_FB2PRG_Version"/>] ;
		+ [</VFPData>]

	l_Debug				= .F.
	l_ShowErrors		= .F.
	c_inputFile			= ''
	c_outputFile		= ''
	lFileMode			= .F.
	nClassTimeStamp		= ''
	o_Conversor			= NULL
	n_FB2PRG_Version	= 1.2

	*******************************************************************************************************************
	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
		LPARAMETERS tc_InputFile

		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, lcErrorInfo
			THIS.c_inputFile	= FULLPATH( tc_InputFile )

			IF NOT FILE(THIS.c_inputFile)
				ERROR 'El archivo [' + THIS.c_inputFile + '] no existe'
			ENDIF
			IF FILE( THIS.c_inputFile + '.ERR' )
				TRY
					ERASE ( THIS.c_inputFile + '.ERR' )
				CATCH
				ENDTRY
			ENDIF

			DO CASE
			CASE JUSTEXT(THIS.c_inputFile) = 'VCX'
				THIS.c_outputFile					= FORCEEXT( THIS.c_inputFile, 'VC2' )
				THIS.o_Conversor					= CREATEOBJECT('c_conversor_vcx_a_prg')
				THIS.o_Conversor.c_inputFile		= THIS.c_inputFile
				THIS.o_Conversor.c_outputFile		= THIS.c_outputFile
				THIS.o_Conversor.l_Debug			= THIS.l_Debug
				THIS.o_Conversor.n_FB2PRG_Version	= THIS.n_FB2PRG_Version
				THIS.o_Conversor.Convertir()

			CASE JUSTEXT(THIS.c_inputFile) = 'SCX'
				THIS.c_outputFile					= FORCEEXT( THIS.c_inputFile, 'SC2' )
				THIS.o_Conversor					= CREATEOBJECT('c_conversor_scx_a_prg')
				THIS.o_Conversor.c_inputFile		= THIS.c_inputFile
				THIS.o_Conversor.c_outputFile		= THIS.c_outputFile
				THIS.o_Conversor.l_Debug			= THIS.l_Debug
				THIS.o_Conversor.n_FB2PRG_Version	= THIS.n_FB2PRG_Version
				THIS.o_Conversor.Convertir()

			CASE JUSTEXT(THIS.c_inputFile) = 'PJX'
				THIS.c_outputFile					= FORCEEXT( THIS.c_inputFile, 'PJ2' )
				THIS.o_Conversor					= CREATEOBJECT('c_conversor_pjx_a_prg')
				THIS.o_Conversor.c_inputFile		= THIS.c_inputFile
				THIS.o_Conversor.c_outputFile		= THIS.c_outputFile
				THIS.o_Conversor.l_Debug			= THIS.l_Debug
				THIS.o_Conversor.n_FB2PRG_Version	= THIS.n_FB2PRG_Version
				THIS.o_Conversor.Convertir()

			CASE JUSTEXT(THIS.c_inputFile) = 'VC2'
				THIS.c_outputFile					= FORCEEXT( THIS.c_inputFile, 'VCX' )
				THIS.o_Conversor					= CREATEOBJECT('c_conversor_prg_a_vcx')
				THIS.o_Conversor.c_inputFile		= THIS.c_inputFile
				THIS.o_Conversor.c_outputFile		= THIS.c_outputFile
				THIS.o_Conversor.l_Debug			= THIS.l_Debug
				THIS.o_Conversor.n_FB2PRG_Version	= THIS.n_FB2PRG_Version
				THIS.o_Conversor.Convertir()

			CASE JUSTEXT(THIS.c_inputFile) = 'SC2'
				THIS.c_outputFile					= FORCEEXT( THIS.c_inputFile, 'SCX' )
				THIS.o_Conversor					= CREATEOBJECT('c_conversor_prg_a_scx')
				THIS.o_Conversor.c_inputFile		= THIS.c_inputFile
				THIS.o_Conversor.c_outputFile		= THIS.c_outputFile
				THIS.o_Conversor.l_Debug			= THIS.l_Debug
				THIS.o_Conversor.n_FB2PRG_Version	= THIS.n_FB2PRG_Version
				THIS.o_Conversor.Convertir()

			CASE JUSTEXT(THIS.c_inputFile) = 'PJ2'
				THIS.c_outputFile					= FORCEEXT( THIS.c_inputFile, 'PJX' )
				THIS.o_Conversor					= CREATEOBJECT('c_conversor_prg_a_pjx')
				THIS.o_Conversor.c_inputFile		= THIS.c_inputFile
				THIS.o_Conversor.c_outputFile		= THIS.c_outputFile
				THIS.o_Conversor.l_Debug			= THIS.l_Debug
				THIS.o_Conversor.n_FB2PRG_Version	= THIS.n_FB2PRG_Version
				THIS.o_Conversor.Convertir()

			OTHERWISE
				ERROR 'El archivo [' + THIS.c_inputFile + '] no está soportado'

			ENDCASE

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO
			lcErrorInfo	= THIS.Exception2Str(loEx) + CR_LF + CR_LF + 'Fuente: ' + THIS.c_inputFile

			TRY
				STRTOFILE( lcErrorInfo, THIS.c_inputFile + '.ERR' )
			CATCH TO loEx2
			ENDTRY

			IF THIS.l_Debug
				SET STEP ON
			ENDIF
			IF THIS.l_Debug OR THIS.l_ShowErrors
				MESSAGEBOX( lcErrorInfo, 0+16+4096, 'FOXBIN2PRG: ERROR!', 5*60*1000 )
			ENDIF
		ENDTRY

		RETURN lnCodError
	ENDPROC


	*******************************************************************************************************************
	HIDDEN PROCEDURE Exception2Str
		LPARAMETERS toEx AS EXCEPTION
		LOCAL lcError
		lcError		= 'Error ' + TRANSFORM(toEx.ERRORNO) + ', ' + toEx.MESSAGE + CR_LF ;
			+ toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) + CR_LF ;
			+ toEx.LINECONTENTS + CR_LF + CR_LF ;
			+ EVL(toEx.UserValue,'')
		RETURN lcError
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS c_conversor_base AS SESSION
	#IF .F.
		LOCAL THIS AS c_conversor_base OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="buscarobjetodelmetodopornombre" type="method" display="buscarObjetoDelMetodoPorNombre"/>] ;
		+ [<memberdata name="comprobarexpresionvalida" type="method" display="comprobarExpresionValida"/>] ;
		+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
		+ [<memberdata name="desnormalizarasignacion" type="method" display="desnormalizarAsignacion"/>] ;
		+ [<memberdata name="dobackup" type="method" display="doBackup"/>] ;
		+ [<memberdata name="evaluarlineadeprocedure" type="method" display="evaluarLineaDeProcedure"/>] ;
		+ [<memberdata name="exception2str" type="method" display="Exception2Str"/>] ;
		+ [<memberdata name="getnext_bak" type="method" display="getNext_BAK"/>] ;
		+ [<memberdata name="identificarbloquesdeexclusion" type="method" display="identificarBloquesDeExclusion"/>] ;
		+ [<memberdata name="lineisonlycomment" type="method" display="lineIsOnlyComment"/>] ;
		+ [<memberdata name="l_debug" type="property" display="l_Debug"/>] ;
		+ [<memberdata name="c_curdir" type="property" display="c_CurDir"/>] ;
		+ [<memberdata name="c_inputfile" type="property" display="c_inputFile"/>] ;
		+ [<memberdata name="c_outputfile" type="property" display="c_outputFile"/>] ;
		+ [<memberdata name="c_type" type="property" display="c_Type"/>] ;
		+ [<memberdata name="includefile" type="property" display="includeFile"/>] ;
		+ [<memberdata name="filetypecode" type="method" display="fileTypeCode"/>] ;
		+ [<memberdata name="normalizarasignacion" type="method" display="normalizarAsignacion"/>] ;
		+ [<memberdata name="n_fb2prg_version" type="property" display="n_FB2PRG_Version"/>] ;
		+ [</VFPData>]

	l_Debug				= .F.
	c_inputFile			= ''
	c_outputFile		= ''
	lFileMode			= .F.
	nClassTimeStamp		= ''
	n_FB2PRG_Version	= 1.0
	c_Type				= ''
	includeFile			= ''
	c_CurDir			= ''

	*******************************************************************************************************************
	PROCEDURE INIT
		SET DELETED ON
		SET DATE YMD
		SET HOURS TO 24
		SET CENTURY ON
		SET SAFETY OFF

		PUBLIC C_FB2PRG_CODE
		C_FB2PRG_CODE	= ''	&& Contendrá todo el código generado
		THIS.c_CurDir	= SYS(5) + CURDIR()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		RELEASE C_FB2PRG_CODE
		USE IN (SELECT("TABLABIN"))
		TRY
			IF FILE( FORCEPATH( "TABLABIN.CDX", THIS.c_CurDir ) )
				ERASE ( FORCEPATH( "TABLABIN.CDX", THIS.c_CurDir ) )
			ENDIF
		CATCH
		ENDTRY
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir

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
			, tcExtension = 'H', 'T' ;
			, 'x' )
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE lineIsOnlyComment
		LPARAMETERS tcLine, tcComment
		LOCAL llLineIsOnlyComment, ln_AT_Cmt

		IF '&'+'&' $ tcLine
			ln_AT_Cmt	= AT( '&'+'&', tcLine)
			tcComment	= LTRIM( SUBSTR( tcLine, ln_AT_Cmt + 2 ) )
			tcLine		= RTRIM( LEFT( tcLine, ln_AT_Cmt - 1 ), 0, ' ', CHR(9) )	&& Quito comentarios. Ej: '#IF .F.&&cmt' ==> '#IF .F.'
		ENDIF

		DO CASE
		CASE LEFT(tcLine,2) == '*<'
			tcComment	= tcLine

		CASE EMPTY(tcLine) OR LEFT(tcLine, 1) == '*' OR LEFT(tcLine + ' ', 5) == 'NOTE ' && Vacía o Comentarios
			llLineIsOnlyComment = .T.

		ENDCASE

		RETURN llLineIsOnlyComment
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE getNext_BAK
		LPARAMETERS tcOutputFileName
		LOCAL lcNext_Bak, I
		lcNext_Bak = ''

		FOR I = 0 TO 100
			IF I = 0
				IF NOT FILE( tcOutputFileName + '.BAK' )
					lcNext_Bak	= '.BAK'
					EXIT
				ENDIF
			ELSE
				IF NOT FILE( tcOutputFileName + '.' + PADL(I,3,'0') + '.BAK' )
					lcNext_Bak	= '.' + PADL(I,3,'0') + '.BAK'
					EXIT
				ENDIF
			ENDIF
		ENDFOR

		lcNext_Bak	= EVL( lcNext_Bak, '.101.BAK' )	&& Para que no quede nunca vacío

		RETURN lcNext_Bak
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE doBackup
		LOCAL lcNext_Bak
		lcNext_Bak	= THIS.getNext_BAK( THIS.c_outputFile )

		DO CASE
		CASE JUSTEXT( THIS.c_outputFile ) = 'VCX'
			IF FILE( FORCEEXT(THIS.c_outputFile,'VCX') )
				COPY FILE (FORCEEXT(THIS.c_outputFile,'VCX')) TO (FORCEEXT(THIS.c_outputFile, 'VCX' + lcNext_Bak))

				IF FILE( FORCEEXT(THIS.c_outputFile,'VCT') )
					COPY FILE (FORCEEXT(THIS.c_outputFile,'VCT')) TO (FORCEEXT(THIS.c_outputFile,'VCT' + lcNext_Bak))
				ENDIF
			ENDIF

		CASE JUSTEXT( THIS.c_outputFile ) = 'SCX'
			IF FILE( FORCEEXT(THIS.c_outputFile,'SCX') )
				COPY FILE (FORCEEXT(THIS.c_outputFile,'SCX')) TO (FORCEEXT(THIS.c_outputFile,'SCX' + lcNext_Bak))

				IF FILE( FORCEEXT(THIS.c_outputFile,'SCT') )
					COPY FILE (FORCEEXT(THIS.c_outputFile,'SCT')) TO (FORCEEXT(THIS.c_outputFile,'SCT' + lcNext_Bak))
				ENDIF
			ENDIF

		CASE JUSTEXT( THIS.c_outputFile ) = 'PJX'
			IF FILE( FORCEEXT(THIS.c_outputFile,'PJX') )
				COPY FILE (FORCEEXT(THIS.c_outputFile,'PJX')) TO (FORCEEXT(THIS.c_outputFile,'PJX' + lcNext_Bak))

				IF FILE( FORCEEXT(THIS.c_outputFile,'PJT') )
					COPY FILE (FORCEEXT(THIS.c_outputFile,'PJT')) TO (FORCEEXT(THIS.c_outputFile,'PJT' + lcNext_Bak))
				ENDIF
			ENDIF

		OTHERWISE
			ERROR 'Tipo de archivo [' + JUSTFNAME(THIS.c_outputFile) + '] no soportado para backup!'

		ENDCASE
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE lineaExcluida
		LPARAMETERS tn_Linea, tnBloquesExclusion, ta_Pos_BloquesExclusion

		EXTERNAL ARRAY ta_Pos_BloquesExclusion
		LOCAL X, llExcluida

		FOR X = 1 TO tnBloquesExclusion
			IF BETWEEN( tn_Linea, ta_Pos_BloquesExclusion(X,1), ta_Pos_BloquesExclusion(X,2) )
				llExcluida	= .T.
				EXIT
			ENDIF
		ENDFOR

		RETURN llExcluida
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		LPARAMETERS ta_Lineas, ta_Pos_BloquesExclusion, toModulo
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

			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lnObjeto
	ENDPROC


	*******************************************************************************************************************
	* Generate a FoxPro 3.0-style row timestamp
	FUNCTION RowTimeStamp(tDateTime)
		LOCAL cTimeValue, tnTimeStamp

		IF VARTYPE(m.tDateTime) <> 'T'
			m.tDateTime = DATETIME()
			m.cTimeValue = TIME()
		ELSE
			m.cTimeValue = TTOC(m.tDateTime, 2)
		ENDIF

		tnTimeStamp = ((YEAR(m.tDateTime) - 1980) * 2 ** 25);
			+ (MONTH(m.tDateTime) * 2 ** 21);
			+ (DAY(m.tDateTime) * 2 ** 16);
			+ (VAL(LEFTC(m.cTimeValue, 2)) * 2 ** 11);
			+ (VAL(SUBSTRC(m.cTimeValue, 4, 2)) * 2 ** 5);
			+  VAL(RIGHTC(m.cTimeValue, 2))
		RETURN tnTimeStamp
	ENDFUNC


	*******************************************************************************************************************
	FUNCTION GetTimeStamp(tnTimeStamp)
		LOCAL lcTimeStamp,lnYear,lnMonth,lnDay,lnHour,lnMinutes,lnSeconds,lcTime,lnHour,ldTimeStamp,lnResto
		LOCAL laDir[1]

		IF EMPTY(tnTimeStamp)
			IF THIS.lFileMode
				IF ADIR(laDir,THIS.cFileName)=0
					RETURN ""
				ENDIF
				lcTime=laDir[1,4]
				lnHour=VAL(lcTime)
				IF lnHour<12
					lcTime=ALLTRIM(STR(IIF(lnHour=0,12,lnHour),2))+SUBSTR(lcTime,3)+" AM"
				ELSE
					lcTime=ALLTRIM(STR(IIF(lnHour=12,24,lnHour)-12,2))+SUBSTR(lcTime,3)+" PM"
				ENDIF
				IF VAL(lcTime)<10
					lcTime="0"+lcTime
				ENDIF
				RETURN DTOC(laDir[1,3])+" "+lcTime
			ENDIF
			tnTimeStamp=THIS.nClassTimeStamp
			IF EMPTY(tnTimeStamp)
				RETURN ""
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

		lcTimeStamp	= STR(lnYear,4) + "-" + STR(lnMonth,2) + "-" + STR(lnDay,2) + " " ;
			+ STR(lnHour,2) + ":" + STR(lnMinutes,2) + ":" + STR(lnSeconds,2)
		ldTimeStamp	= TTOC( EVALUATE( "{^" + lcTimeStamp + "}" ) )
		RETURN ldTimeStamp
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
	FUNCTION desnormalizarAsignacion(tcAsignacion)
		RETURN tcAsignacion
		*-- METODO ANULADO

		LOCAL lcPropName, lcValor, lnCodError, lcExpNormalizada
		*-- Tipos de asignación posibles:
		*-- 	_memberdata = [<VFPData><memberdata name="mimetodo" display="miMetodo"/></VFPData>]
		*--		ForeColor = (RGB(0,0,0))	==> Asignado por el usuario con RGB()
		*--		ForeColor = RGB(0,0,0)		==> Guardado por el sistema como 0,0,0
		*-- 	propiedad = n_valor
		*-- 	propiedad = {d_valor}
		*-- 	propiedad = "c_valor"
		lcPropName		= ALLTRIM( STREXTRACT( tcAsignacion, '', '=' ) )
		lcValor			= ALLTRIM( STREXTRACT( tcAsignacion, '=', '' ) )

		*-- Ajustes de algunos casos especiales
		DO CASE
		CASE lcPropName == '_memberdata'
			tcAsignacion = lcPropName + ' = ' + SUBSTR( tcAsignacion, 16, LEN(tcAsignacion) - 16 )

		CASE ( 'BACKCOLOR' $ UPPER(lcPropName) OR 'FORECOLOR' $ UPPER(lcPropName) ) ;
				AND ' '+'RGB(' $ UPPER(tcAsignacion)
			tcAsignacion = lcPropName + ' = ' + STREXTRACT( lcValor, 'RGB(', ')', 1, 1 )
		ENDCASE

		RETURN tcAsignacion
	ENDFUNC


	*******************************************************************************************************************
	FUNCTION normalizarAsignacion(tcAsignacion, tcComentario)
		RETURN tcAsignacion
		*-- METODO ANULADO

		LOCAL lcPropName, lcValor, lnCodError, lcExpNormalizada
		lcPropName		= ALLTRIM( STREXTRACT( tcAsignacion, '', '=' ) )
		lcValor			= ALLTRIM( STREXTRACT( tcAsignacion, '=', '' ) )
		tcComentario	= ''

		*-- Ajustes de algunos casos especiales
		DO CASE
		CASE lcPropName == '_memberdata'
			tcAsignacion = STUFF( tcAsignacion, 15, 0, '[') + ']'

		CASE NOT THIS.ComprobarExpresionValida( tcAsignacion, @lnCodError, @lcExpNormalizada )
			*-- La mayoría de los errores deben relanzarse, ya que intentar arreglarlos
			*-- puede empeorar las cosas con asignaciones válidas para guardar pero no
			*-- para la lógica del programa.
			*--
			DO CASE
			CASE lnCodError = 1231	&& Missing operand
				IF EMPTY(lcValor)	&& ej: 'prop =' sin valor asignado (==> 'prop = ""')
					tcAsignacion = tcAsignacion + ' ""'
				ELSE	&& ej: 'prop = ??' sin valor asignado (==> 'prop = "badVal"')
					*FDB*
					SET STEP ON
					tcAsignacion = lcPropName + ' = ' + '"' + lcValor + '"'
				ENDIF

			CASE lnCodError = 10	&& Syntax Error
				IF EMPTY(lcValor)	&& ej: 'prop = PROC.' con valor asignado incorrecto (==> 'prop = "PROC."')
					tcAsignacion = tcAsignacion + ' ""'
				ELSE
					tcAsignacion = lcPropName + ' = ' + '"' + lcValor + '"'
				ENDIF

			OTHERWISE
				*-- Relanzo el error original
				NORMALIZE( tcAsignacion )
			ENDCASE

		CASE ( 'BACKCOLOR' $ UPPER(lcPropName) OR 'FORECOLOR' $ UPPER(lcPropName) ) ;
				AND NOT 'RGB(' $ UPPER(lcValor) AND OCCURS(',', lcValor) = 2
			*-- Caso especial: Los colores se guardan en un formato incompatible que no compila.
			*-- Los convierto en algo compilable equivalente.
			tcAsignacion	= lcPropName + ' = ' + 'RGB(' + lcValor + ')'
			tcComentario	= ''

		OTHERWISE
			*-- Demás propiedades
			tcAsignacion = lcPropName + ' = ' + lcValor
		ENDCASE

		RETURN tcAsignacion
	ENDFUNC


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


ENDDEFINE



*******************************************************************************************************************
DEFINE CLASS c_conversor_prg_a_bin AS c_conversor_base
	#IF .F.
		LOCAL THIS AS c_conversor_prg_a_bin OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="analizarbloque_foxbin2prg" type="method" display="analizarBloque_FoxBin2Prg"/>] ;
		+ [<memberdata name="getclassmethodcomment" type="method" display="getClassMethodComment"/>] ;
		+ [<memberdata name="classmethods2memo" type="method" display="classMethods2Memo"/>] ;
		+ [<memberdata name="getclasspropertycomment" type="method" display="getClassPropertyComment"/>] ;
		+ [<memberdata name="classprops2memo" type="method" display="classProps2Memo"/>] ;
		+ [<memberdata name="createform" type="method" display="createForm"/>] ;
		+ [<memberdata name="createclasslib" type="method" display="createClasslib"/>] ;
		+ [<memberdata name="defined_pem2memo" type="method" display="defined_PEM2Memo"/>] ;
		+ [<memberdata name="escribirarchivobin" type="method" display="escribirArchivoBin"/>] ;
		+ [<memberdata name="evaluate_pem" type="method" display="Evaluate_PEM"/>] ;
		+ [<memberdata name="hiddenandprotected_pem" type="method" display="hiddenAndProtected_PEM"/>] ;
		+ [<memberdata name="identificarbloquesdeexclusion" type="method" display="identificarBloquesDeExclusion"/>] ;
		+ [<memberdata name="insert_allobjects" type="method" display="insert_AllObjects"/>] ;
		+ [<memberdata name="insert_object" type="method" display="insert_Object"/>] ;
		+ [<memberdata name="objectmethods2memo" type="method" display="objectMethods2Memo"/>] ;
		+ [</VFPData>]

	*******************************************************************************************************************
	PROCEDURE INIT
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
		*LPARAMETERS

		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE evaluarDefinicionDeProcedure
		LPARAMETERS toClase, tnX, tcProcedureAbierto, tcAddobjectAbierto ;
			, tc_Comentario, tcProcName, tcProcType, toObjeto
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
			IF NOT EMPTY(tcAddobjectAbierto)
				ERROR 'Se ha encontrado "PROCEDURE" en la línea ' + TRANSFORM(tnX) ;
					+ ' cuando se esperaba encontrar el metatag "END OBJECT"'
			ENDIF

			loProcedure		= CREATEOBJECT("CL_PROCEDURE")
			loProcedure._Nombre			= tcProcName
			loProcedure._ProcType		= tcProcType
			loProcedure._Comentario		= tc_Comentario
			tcProcedureAbierto			= loProcedure._Nombre

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
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			STORE NULL TO loProcedure

		ENDTRY

		RELEASE loProcedure
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE evaluarLineaDeProcedure
		LPARAMETERS tcLine, tcLine_Orig, toProcedure, tcProcedureAbierto
		*--------------------------------------------------------------------------------------------------------------
		* ta_Lineas					(!@ IN    ) El array con las líneas del bloque de texto donde buscar
		* ta_ID_Bloques				(?@ IN    ) Array de pares de identificadores (2 cols). Ej: '#IF .F.','#ENDI' ; 'TEXT','ENDTEXT' ; etc
		* ta_Ubicacion_Bloques		(?@    OUT) Array con las posiciones de los bloques (2 cols). Ej: 3,14 ; 23,58 ; etc
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY toProcedure
		#IF .F.
			LOCAL toProcedure AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		IF LEFT( tcLine, 8 ) + ' ' == C_ENDPROC + ' ' && Fin del PROCEDURE
			tcProcedureAbierto	= ''
		ELSE
			*-- Quito 2 TABS de la izquierda (si se puede y si el integrador/desarrollador no la lió quitándolos)
			DO CASE
			CASE LEFT( tcLine_Orig,2 ) = C_TAB + C_TAB
				toProcedure.add_Line( SUBSTR(tcLine_Orig, 3) )
			CASE LEFT( tcLine_Orig,1 ) = C_TAB
				toProcedure.add_Line( SUBSTR(tcLine_Orig, 2) )
			OTHERWISE
				toProcedure.add_Line( tcLine_Orig )
			ENDCASE
		ENDIF
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeExclusion
		LPARAMETERS ta_Lineas, ta_ID_Bloques, ta_Ubicacion_Bloques
		*--------------------------------------------------------------------------------------------------------------
		* ta_Lineas					(!@ IN    ) El array con las líneas del bloque de texto donde buscar
		* ta_ID_Bloques				(?@ IN    ) Array de pares de identificadores (2 cols). Ej: '#IF .F.','#ENDI' ; 'TEXT','ENDTEXT' ; etc
		* ta_Ubicacion_Bloques		(?@    OUT) Array con las posiciones de los bloques (2 cols). Ej: 3,14 ; 23,58 ; etc
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY ta_ID_Bloques, ta_Ubicacion_Bloques

		TRY
			LOCAL lnBloques, I, X, lnPrimerID, lnLineas, lnLen_IDFinBQ
			DIMENSION ta_Ubicacion_Bloques(1,2)
			STORE 0 TO lnBloques, lnPrimerID, I, X, lnLen_IDFinBQ

			lnLineas	= ALEN(ta_Lineas,1)

			IF lnLineas > 1
				IF EMPTY(ta_ID_Bloques)
					DIMENSION ta_ID_Bloques(2,2)
					ta_ID_Bloques(1,1)	= '#IF .F.'
					ta_ID_Bloques(1,2)	= '#ENDI'
					ta_ID_Bloques(2,1)	= C_TEXT
					ta_ID_Bloques(2,2)	= C_ENDTEXT
				ENDIF

				*-- Búsqueda del ID de inicio de bloque
				FOR I = 1 TO lnLineas
					lcLine = LTRIM( STRTRAN( STRTRAN( CHRTRAN( ta_Lineas(I), CHR(9), ' ' ), '  ', ' ' ), '  ', ' ' ) )	&& Reduzco los espacios. Ej: '#IF  .F. && cmt' ==> '#IF .F.&&cmt'

					IF THIS.lineIsOnlyComment( @lcLine )
						LOOP
					ENDIF

					lnPrimerID	= ASCAN( ta_ID_Bloques, lcLine, 1, 0, 1, 1+8 )

					IF lnPrimerID > 0	&& Se ha identificado un ID de bloque excluyente
						lnBloques							= lnBloques + 1
						lnLen_IDFinBQ						= LEN( ta_ID_Bloques(lnPrimerID,2) )
						DIMENSION ta_Ubicacion_Bloques(lnBloques,2)
						ta_Ubicacion_Bloques(lnBloques,1)	= I

						* Búsqueda del ID de fin de bloque
						FOR X = ta_Ubicacion_Bloques(lnBloques,1) + 1 TO lnLineas
							lcLine = LTRIM( STRTRAN( STRTRAN( CHRTRAN( ta_Lineas(X), CHR(9), ' ' ), '  ', ' ' ), '  ', ' ' ) )	&& Reduzco los espacios. Ej: '#IF  .F. && cmt' ==> '#IF .F.&&cmt'

							IF THIS.lineIsOnlyComment( @lcLine )
								LOOP
							ENDIF

							IF LEFT( lcLine, lnLen_IDFinBQ ) == ta_ID_Bloques(lnPrimerID,2)	&& Fin de bloque encontrado (#ENDI, ENDTEXT, etc)
								ta_Ubicacion_Bloques(lnBloques,2)	= X
								EXIT
							ENDIF
						ENDFOR

						I = X

						*-- Validación
						IF EMPTY(ta_Ubicacion_Bloques(lnBloques,2))
							ERROR 'No se ha encontrado el marcador de fin [' + ta_ID_Bloques(lnPrimerID,2) ;
								+ '] que cierra al marcador de inicio [' + ta_ID_Bloques(lnPrimerID,1) ;
								+ '] de la línea ' + TRANSFORM(ta_Ubicacion_Bloques(lnBloques,1))
						ENDIF
					ENDIF
				ENDFOR
			ENDIF

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
		LPARAMETERS toModulo, tcLine, ta_Lineas, I, tnLineas

		LOCAL llBloqueEncontrado, X

		IF LEFT( tcLine + ' ', LEN(C_FB2PRG_META_I) + 1 ) == C_FB2PRG_META_I + ' '
			llBloqueEncontrado	= .T.

			*-- Metadatos del módulo
			tcLine					= ALLTRIM( STREXTRACT( tcLine, C_FB2PRG_META_I, C_FB2PRG_META_F, 1, 1 ) )
			tcLine					= CHRTRAN( tcLine, ['], ["] )
			toModulo._Version		= VAL( ALLTRIM( STREXTRACT( tcLine, 'version = "', '"', 1, 1 ) ) )
			toModulo._SourceFile	= ALLTRIM( STREXTRACT( tcLine, 'SourceFile = "', '"', 1, 1 ) )
		ENDIF

		RETURN llBloqueEncontrado
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createClasslib

		CREATE CLASSLIB (THIS.c_outputFile)
		USE (THIS.c_outputFile) ALIAS TABLABIN AGAIN SHARED

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE createForm

		CREATE TABLE (THIS.c_outputFile) ;
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

		USE (THIS.c_outputFile) ALIAS TABLABIN AGAIN SHARED
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
	PROCEDURE escribirArchivoBin
		LPARAMETERS toModulo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE classProps2Memo
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I
		lcMemo	= ''

		FOR I = 1 TO toClase._Prop_Count
			TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<<toClase._Props(I,1)>>

			ENDTEXT
		ENDFOR

		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE objectProps2Memo
		LPARAMETERS toObjeto, toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG' ;
				, toObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I
		lcMemo	= ''

		FOR I = 1 TO toObjeto._Prop_Count
			TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<<toObjeto._Props(I,1)>>

			ENDTEXT
		ENDFOR

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

			*-- Comentarios (NO DEBEN IR EN EL VCX!!)

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
	PROCEDURE defined_PEM2Memo
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I, lcPEM, lcComentario
		lcMemo	= ''

		IF NOT EMPTY( toClase._Defined_PEM )
			FOR I = 1 TO OCCURS( ',', toClase._Defined_PEM ) + 1
				lcPEM			= RTRIM( GETWORDNUM( toClase._Defined_PEM + ',', I, ',' ) )
				lcComentario	= ''

				IF LEFT( lcPEM, 1 ) == '*'
					*-- Método
					lcComentario	= THIS.getClassMethodComment( SUBSTR(lcPEM,2), toClase )
				ELSE
					*-- Propiedad
					lcComentario	= THIS.getClassPropertyComment( lcPEM, toClase )
				ENDIF

				TEXT TO lcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					<<lcPEM>> <<lcComentario>>

				ENDTEXT
			ENDFOR
		ENDIF

		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE hiddenAndProtected_PEM
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		LOCAL lcMemo, I, lcPEM, lcComentario
		lcMemo	= ''

		THIS.Evaluate_PEM( @lcMemo, toClase._ProtectedProps, 'property', 'protected' )
		THIS.Evaluate_PEM( @lcMemo, toClase._HiddenProps, 'property', 'hidden' )
		THIS.Evaluate_PEM( @lcMemo, toClase._ProtectedMethods, 'method', 'protected' )
		THIS.Evaluate_PEM( @lcMemo, toClase._HiddenMethods, 'method', 'hidden' )

		RETURN lcMemo
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Evaluate_PEM
		LPARAMETERS tcMemo AS STRING, tcPEM AS STRING, tcPEM_Type AS STRING, tcPEM_Visibility AS STRING

		LOCAL lcPEM, I

		FOR I = 1 TO OCCURS( ',', tcPEM + ',' )
			lcPEM	= ALLTRIM( GETWORDNUM( tcPEM, I, ',' ) )

			IF NOT EMPTY(lcPEM)
				IF EVL(tcPEM_Visibility, 'normal') == 'hidden'
					lcPEM	= lcPEM + '^'
				ENDIF

				TEXT TO tcMemo ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					<<lcPEM>>

				ENDTEXT
			ENDIF
		ENDFOR
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE insert_Object
		LPARAMETERS toClase, toObjeto

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
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE insert_AllObjects
		*-- Recorro primero los objetos con ZOrder definido, y luego los demás
		*-- NOTA: Como consecuencia de una integración de código, puede que se hayan agregado objetos nuevos (desconocidos).
		LPARAMETERS toClase

		#IF .F.
			LOCAL toClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL loObjeto, X, lcObjName
	
			IF toClase._AddObject_Count > 0

				*-- Armo array con el orden Z de los objetos
				DIMENSION laObjNames( toClase._AddObject_Count, 2 )

				FOR X = 1 TO toClase._AddObject_Count
					loObjeto			= toClase._AddObjects( X )
					laObjNames( X, 1 )	= JUSTEXT( loObjeto._Nombre )
					laObjNames( X, 2 )	= loObjeto._ZOrder
				ENDFOR

				ASORT( laObjNames, 2, -1, 0, 1 )
				

				*-- Escribo los objetos en el orden Z
				FOR X = 1 TO toClase._AddObject_Count
					lcObjName	= laObjNames( X, 1 )

					FOR EACH loObjeto IN toClase._AddObjects FOXOBJECT
						*-- Verifico que sea el objeto que corresponde
						IF loObjeto._Pendiente AND loObjeto._ObjName == lcObjName
							loObjeto._Pendiente	= .F.
							THIS.insert_Object( toClase, loObjeto )
							EXIT
						ENDIF
					ENDFOR
				ENDFOR


				*-- Recorro los objetos Desconocidos
				FOR EACH loObjeto IN toClase._AddObjects FOXOBJECT
					IF loObjeto._Pendiente
						THIS.insert_Object( toClase, loObjeto )
					ENDIF
				ENDFOR

			ENDIF	&& toClase._AddObject_Count > 0

		CATCH TO loEx
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE identificarBloquesDeCodigo
		LPARAMETERS ta_Lineas, ta_Pos_BloquesExclusion, toModulo
		*--------------------------------------------------------------------------------------------------------------
		* ta_Lineas					(!@ IN    ) El array con las líneas del bloque de texto donde buscar
		* ta_Pos_BloquesExclusion	(!@ IN    ) Array con las posiciones de inicio/fin de los bloques de exclusion
		* toModulo					(?@    OUT) Objeto con toda la información del módulo analizado
		*
		* NOTA:
		* Como identificador se usa el nombre de clase o de procedimiento, según corresponda.
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY ta_Lineas, ta_Pos_BloquesExclusion

		#IF .F.
			LOCAL toModulo AS CL_MODULO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, X, Z, lnCodError, loEx as Exception, lnPrimerID, lnLineas, lnBloquesExclusion ;
				, ln_ID_LimitesDeCabecera, ln_AT_Cmt, lc_Comentario, la_cab_props(1) ;
				, ln_cab_props, lcProp, lnPropsObj, ln_AT, lnOle_Len ;
				, lcProcedureAbierto, lcAddobjectAbierto, lcLine, lnLine_Len, lcProcName ;
				, loOle AS CL_OLE OF 'FOXBIN2PRG.PRG' ;
				, loObjeto AS CL_OBJETO OF 'FOXBIN2PRG.PRG' ;
				, loClase AS CL_CLASE OF 'FOXBIN2PRG.PRG'
			DIMENSION ta_Ubicacion_Bloques(1,2)
			STORE 0 TO lnPrimerID, I, X, lnOle_Len
			STORE '' TO lcProcedureAbierto, lcAddobjectAbierto

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_outputFile))
			lnLineas	= ALEN(ta_Lineas,1)

			IF lnLineas > 1

				*-- Defino el objeto de módulo y sus propiedades
				toModulo	= NULL
				toModulo	= CREATEOBJECT('CL_MODULO')
				lnOle_Len	= LEN(C_OLE_I)

				*-- Determino la cantidad de exclusiones del array
				IF EMPTY(ta_Pos_BloquesExclusion)
					lnBloquesExclusion = 0
				ELSE
					lnBloquesExclusion	= ALEN(ta_Pos_BloquesExclusion,1)
				ENDIF

				*-- Búsqueda del ID de inicio de bloque (DEFINE CLASS / PROCEDURE)
				WITH THIS
					FOR I = 1 TO lnLineas
						STORE '' TO lc_Comentario, lcProp, lcAddobjectAbierto
						STORE 0 TO lnPropsObj

						lcLine = LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

						IF THIS.lineaExcluida( I, lnBloquesExclusion, @ta_Pos_BloquesExclusion ) ;
								OR .lineIsOnlyComment( @lcLine, @lc_Comentario ) && Excluida, vacía o solo Comentarios

							IF NOT EMPTY(lcProcedureAbierto)	&& Líneas del PROCEDURE (de Clase u Objeto)
								IF '.' $ lcProcedureAbierto AND loObjeto._Procedure_Count > 0
									.evaluarLineaDeProcedure( @lcLine, ta_Lineas(I), loObjeto._Procedures(loObjeto._Procedure_Count), @lcProcedureAbierto )
								ELSE
									.evaluarLineaDeProcedure( @lcLine, ta_Lineas(I), loClase._Procedures(loClase._Procedure_Count), @lcProcedureAbierto )
								ENDIF
							ENDIF

							LOOP
						ENDIF

						lnPrimerID	= 0

						DO CASE
						CASE LEFT(lcLine + ' ', 13) == C_DEFINE_CLASS + ' '
							*-- Se encontró el inicio de una clase (DEFINE CLASS)
							lnPrimerID	= 1

						CASE THIS.c_Type = 'SCX' AND LEFT(lcLine, 9) == '#INCLUDE '
							*FDB*
							* Específico para SCX que lo tiene al inicio
							.includeFile		= ALLTRIM( CHRTRAN( SUBSTR( lcLine, 10 ), ["'], [] ) )

						CASE LEFT( lcLine + ' ', lnOle_Len + 1 ) == C_OLE_I + ' '
							*-- Se encontró una definición de objeto OLE
							*< OLE: Nombre = "frm_d.ole_ImageControl2" parent = "frm_d" objname = "ole_ImageControl2" checksum = "4171274922" value = "b64-value" />
							lcLine			= STREXTRACT( lcLine, C_OLE_I, C_OLE_F, 1, 1 )
							lcLine			= CHRTRAN( lcLine, ['], ["] )
							loOle			= NULL
							loOle			= CREATEOBJECT('CL_OLE')

							loOle._Nombre	= ALLTRIM( STREXTRACT( lcLine, ' Nombre = "', '"', 1, 1 ) )
							loOle._Parent	= ALLTRIM( STREXTRACT( lcLine, ' Parent = "', '"', 1, 1 ) )
							loOle._ObjName	= ALLTRIM( STREXTRACT( lcLine, ' ObjName = "', '"', 1, 1 ) )
							loOle._CheckSum	= ALLTRIM( STREXTRACT( lcLine, ' CheckSum = "', '"', 1, 1 ) )
							loOle._Value	= STRCONV( ALLTRIM( STREXTRACT( lcLine, ' value = "', '"', 1, 1 ) ), 14 )
							toModulo.add_OLE( loOle )

							IF EMPTY( loOle._Value )
								*-- Si el objeto OLE no tiene VALUE, es porque hay otro con el mismo contenido y no se duplicó para preservar espacio.
								*-- Busco el VALUE del duplicado que se guardó y lo asigno nuevamente
								FOR Z = 1 TO toModulo._Ole_Obj_count - 1
									IF toModulo._Ole_Objs(Z)._CheckSum == loOle._CheckSum ;
											AND NOT EMPTY( toModulo._Ole_Objs(Z)._Value )
										loOle._Value	= toModulo._Ole_Objs(Z)._Value
										EXIT
									ENDIF
								ENDFOR
							ENDIF

							LOOP

						CASE THIS.analizarBloque_FoxBin2Prg( toModulo, @lcLine, @ta_Lineas, @I, lnLineas )
							*-- Metadatos del módulo
							LOOP

						ENDCASE

						IF lnPrimerID > 0	&& Se ha identificado un ID de bloque (DEFINE CLASS) e inicio de cabecera
							loClase					= CREATEOBJECT('CL_CLASE')
							loClase._Nombre			= ALLTRIM( STREXTRACT( lcLine, 'DEFINE CLASS ', ' AS ', 1, 1 ) )
							loClase._ObjName		= loClase._Nombre
							loClase._Definicion		= ALLTRIM( lcLine )
							IF NOT ' OF ' $ UPPER(lcLine)	&& Puede no tener "OF libreria.vcx"
								loClase._Class			= ALLTRIM( CHRTRAN( STREXTRACT( lcLine + ' OLEPUBLIC', ' AS ', ' OLEPUBLIC', 1, 1 ), ["'], [] ) )
							ELSE
								loClase._Class			= ALLTRIM( CHRTRAN( STREXTRACT( lcLine + ' OF ', ' AS ', ' OF ', 1, 1 ), ["'], [] ) )
							ENDIF
							loClase._ClassLoc		= ALLTRIM( CHRTRAN( STREXTRACT( lcLine + ' OLEPUBLIC', ' OF ', ' OLEPUBLIC', 1, 1 ), ["'], [] ) )
							loClase._OlePublic		= ' OLEPUBLIC' $ UPPER(lcLine)
							loClase._Comentario		= lc_Comentario
							loClase._Inicio			= I
							loClase._Ini_Cab		= I + 1
							toModulo.add_Class( loClase )

							*-- Ubico el objeto ole por su nombre (parent+objname), que no se repite.
							IF toModulo.existeObjetoOLE( loClase._Nombre, @Z )
								loClase._Ole	= toModulo._Ole_Objs(Z)._Value
							ENDIF

							* Búsqueda del ID de fin de bloque (ENDDEFINE)
							FOR I = loClase._Ini_Cab TO lnLineas
								lc_Comentario	= ''
								lcLine 			= LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

								IF THIS.lineaExcluida( I, lnBloquesExclusion, @ta_Pos_BloquesExclusion ) ;
										OR .lineIsOnlyComment( @lcLine, @lc_Comentario ) && Excluida, vacía o solo Comentarios

									IF NOT EMPTY(lcProcedureAbierto)	&& Líneas del PROCEDURE
										IF '.' $ lcProcName AND VARTYPE(loObjeto) = 'O' AND loObjeto._Procedure_Count > 0
											.evaluarLineaDeProcedure( @lcLine, ta_Lineas(I), loObjeto._Procedures(loObjeto._Procedure_Count), @lcProcedureAbierto )
										ELSE
											.evaluarLineaDeProcedure( @lcLine, ta_Lineas(I), loClase._Procedures(loClase._Procedure_Count), @lcProcedureAbierto )
										ENDIF
									ENDIF

									LOOP
								ENDIF

								lnLine_Len	= LEN(lcLine)


								DO CASE
								CASE LEFT( lcLine, 20 ) == 'PROTECTED PROCEDURE '
									*-- Estructura a reconocer: PROTECTED PROCEDURE nombre_del_procedimiento
									lcProcName	= ALLTRIM( SUBSTR( lcLine, 21 ) )
									.evaluarDefinicionDeProcedure( loClase, I ;
										, @lcProcedureAbierto, lcAddobjectAbierto, @lc_Comentario, lcProcName, 'protected', @loObjeto )


								CASE LEFT( lcLine, 17 ) == 'HIDDEN PROCEDURE '
									*-- Estructura a reconocer: HIDDEN PROCEDURE nombre_del_procedimiento
									lcProcName	= ALLTRIM( SUBSTR( lcLine, 18 ) )
									.evaluarDefinicionDeProcedure( loClase, I ;
										, @lcProcedureAbierto, lcAddobjectAbierto, @lc_Comentario, lcProcName, 'hidden', @loObjeto )


								CASE LEFT(lcLine, 10) == 'PROTECTED '
									loClase._ProtectedProps		= ALLTRIM( SUBSTR( lcLine, 11 ) )


								CASE LEFT(lcLine, 7) == 'HIDDEN '
									loClase._HiddenProps		= ALLTRIM( SUBSTR( lcLine, 8 ) )


								CASE LEFT(lcLine, 9) == '#INCLUDE '
									loClase._IncludeFile			= ALLTRIM( CHRTRAN( SUBSTR( lcLine, 10 ), ["'], [] ) )


								CASE LEFT(lcLine, LEN(C_METADATA_I)) == C_METADATA_I	&& METADATA de la CLASE
									lcLine						= CHRTRAN( lcLine, ['], ["] )
									loClase._MetaData			= STREXTRACT( lcLine, C_METADATA_I, C_METADATA_F, 1, 1 )
									loClase._BaseClass			= ALLTRIM( STREXTRACT( loClase._MetaData + ',', ' BaseClass = "', '"', 1, 1 ) )
									loClase._TimeStamp			= INT( .RowTimeStamp( EVALUATE( '{^' + ALLTRIM( STREXTRACT( loClase._MetaData + ',', ' Timestamp = "', '"', 1, 1 ) ) + '}') ) )
									loClase._Scale				= ALLTRIM( STREXTRACT( loClase._MetaData + ',', ' Scale = "', '"', 1, 1 ) )
									loClase._UniqueID			= ALLTRIM( STREXTRACT( loClase._MetaData + ',', ' UniqueID = "', '"', 1, 1 ) )
									loClase._ProjectClassIcon	= ALLTRIM( STREXTRACT( loClase._MetaData + ',', ' ProjectClassIcon = "', '"', 1, 1 ) )
									loClase._ClassIcon			= ALLTRIM( STREXTRACT( loClase._MetaData + ',', ' ClassIcon = "', '"', 1, 1 ) )
									loClase._Ole2				= ALLTRIM( STREXTRACT( loClase._MetaData + ',', ' OLEObject = "', '"', 1, 1 ) )

									IF NOT EMPTY( loClase._Ole2 )	&& Le agrego "OLEObject = " delante
										loClase._Ole2	= 'OLEObject = ' + loClase._Ole2 + CR_LF
									ENDIF


								CASE LEFT(lcLine, LEN(C_DEFINED_PEM_I)) == C_DEFINED_PEM_I
									loClase._Defined_PEM		= ALLTRIM( STREXTRACT( lcLine, C_DEFINED_PEM_I, C_DEFINED_PEM_F, 1, 1) )


								CASE LEFT( lcLine, 11 ) == 'ADD OBJECT '
									*-- Estructura a reconocer: ADD OBJECT 'frm_a.Check1' AS check [WITH]
									lcLine		= CHRTRAN( lcLine, ['], ["] )

									IF EMPTY(loClase._Fin_Cab)
										loClase._Fin_Cab	= I-1
										loClase._Ini_Cuerpo	= I
									ENDIF

									loObjeto			= NULL
									loObjeto			= CREATEOBJECT('CL_OBJETO')
									loClase.add_Object( loObjeto )
									loObjeto._Nombre	= ALLTRIM( CHRTRAN( STREXTRACT(lcLine, 'ADD OBJECT ', ' AS ', 1, 1), ['"], [] ) )

									IF '.' $ loObjeto._Nombre
										loObjeto._ObjName	= JUSTEXT( loObjeto._Nombre )
										loObjeto._Parent	= loClase._ObjName + '.' + JUSTSTEM( loObjeto._Nombre )
									ELSE
										loObjeto._ObjName	= loObjeto._Nombre
										loObjeto._Parent	= loClase._ObjName
									ENDIF

									loObjeto._Nombre	= loObjeto._Parent + '.' + loObjeto._ObjName
									loObjeto._Class		= ALLTRIM( STREXTRACT(lcLine + ' WITH', ' AS ', ' WITH', 1, 1) )
									lcAddobjectAbierto	= loObjeto._Nombre


								CASE LEFT( lcLine, 10 ) == 'PROCEDURE '
									*-- Estructura a reconocer: PROCEDURE [objeto.]nombre_del_procedimiento
									lcProcName	= ALLTRIM( SUBSTR( lcLine, 11 ) )
									.evaluarDefinicionDeProcedure( loClase, I ;
										, @lcProcedureAbierto, lcAddobjectAbierto, @lc_Comentario, lcProcName, 'normal', @loObjeto )


								CASE LEFT( lcLine + ' ', 10 ) == C_ENDDEFINE + ' '	&& Fin de bloque (ENDDEF / ENDPROC) encontrado
									loClase._Fin	= I

									IF EMPTY( loClase._Ini_Cuerpo )
										loClase._Ini_Cuerpo	= I-1
									ENDIF

									loClase._Fin_Cuerpo	= I-1

									IF EMPTY( loClase._Fin_Cab )
										loClase._Fin_Cab	= I-1
									ENDIF

									STORE '' TO lclProcedureAbierto, lcAddobjectAbierto
									EXIT


								CASE EMPTY( loClase._Fin_Cab ) && Propiedades del DEFINE CLASS
									*loClase.add_Property( THIS.desnormalizarAsignacion( RTRIM(lcLine) ), RTRIM(lc_Comentario) )
									loClase.add_Property( RTRIM(lcLine), RTRIM(lc_Comentario) )


								CASE NOT EMPTY(lcAddobjectAbierto) && Propiedades del ADD OBJECT
									IF NOT LEFT(lcLine,2) == '*<'
										IF RIGHT(lcLine, 3) == ', ;'
											*loObjeto.add_Property( .desnormalizarAsignacion( LEFT(lcLine, lnLine_Len - 3) ) )
											loObjeto.add_Property( LEFT(lcLine, lnLine_Len - 3) )
										ELSE
											*loObjeto.add_Property( .desnormalizarAsignacion( RTRIM(lcLine) ) )
											loObjeto.add_Property( RTRIM(lcLine) )
										ENDIF
									ENDIF

									IF NOT EMPTY(lc_Comentario) AND C_END_OBJECT_I $ lc_Comentario && Fin del ADD OBJECT y METADATOS
										*< END OBJECT: baseclass = "olecontrol" Uniqueid = "_3X50L3I7V" OLEObject = "C:\WINDOWS\system32\FOXTLIB.OCX" checksum = "4101493921" />
										lc_Comentario		= ALLTRIM( STREXTRACT( lc_Comentario, C_END_OBJECT_I, C_END_OBJECT_F, 1, 1 ) ) + ','
										lc_Comentario		= CHRTRAN( lc_Comentario, ['], ["] )
										loObjeto._ClassLib	= ALLTRIM( STREXTRACT( lc_Comentario, 'ClassLib = "', '"', 1, 1 ) )
										loObjeto._BaseClass	= ALLTRIM( STREXTRACT( lc_Comentario, 'BaseClass = "', '"', 1, 1 ) )
										loObjeto._UniqueID	= ALLTRIM( STREXTRACT( lc_Comentario, 'UniqueID = "', '"', 1, 1 ) )
										loObjeto._Ole2		= ALLTRIM( STREXTRACT( lc_Comentario, 'OLEObject = "', '"', 1, 1 ) )
										loObjeto._ZOrder	= INT( VAL( ALLTRIM( STREXTRACT( lc_Comentario, 'ZOrder = "', '"', 1, 1 ) ) ) )
										loObjeto._TimeStamp	= INT( .RowTimeStamp( EVALUATE( '{^' + ALLTRIM( STREXTRACT( lc_Comentario + ',', 'Timestamp = "', '"', 1, 1 ) ) + '}' ) ) )

										IF NOT EMPTY( loObjeto._Ole2 )	&& Le agrego "OLEObject = " delante
											loObjeto._Ole2		= 'OLEObject = ' + loObjeto._Ole2 + CR_LF
										ENDIF

										*-- Ubico el objeto ole por su nombre (parent+objname), que no se repite.
										IF toModulo.existeObjetoOLE( loObjeto._Nombre, @Z )
											loObjeto._Ole	= toModulo._Ole_Objs(Z)._Value
										ENDIF

										lcAddobjectAbierto	= ''
										lnPropsObj			= 0
									ENDIF

								CASE NOT EMPTY(lcProcedureAbierto)	&& Líneas del PROCEDURE (de Clase u Objeto)
									IF '.' $ lcProcName AND VARTYPE(loObjeto) = 'O' AND loObjeto._Procedure_Count > 0
										.evaluarLineaDeProcedure( @lcLine, ta_Lineas(I), loObjeto._Procedures(loObjeto._Procedure_Count), @lcProcedureAbierto )
									ELSE
										.evaluarLineaDeProcedure( @lcLine, ta_Lineas(I), loClase._Procedures(loClase._Procedure_Count), @lcProcedureAbierto )
									ENDIF

								OTHERWISE
									IF .l_Debug
										MESSAGEBOX( 'Se escapó esta línea del análisis. Ver que es en el DEBUG que se va a abrir.' )
										SET STEP ON
									ENDIF
								ENDCASE

							ENDFOR

							*-- Validación
							IF EMPTY( loClase._Fin )
								ERROR 'No se ha encontrado el marcador de fin [ENDDEFINE] ' ;
									+ 'que cierra al marcador de inicio [DEFINE CLASS] ' ;
									+ 'de la línea ' + TRANSFORM( loClase._Inicio ) + ' ' ;
									+ 'para el identificador [' + loClase._Nombre + ']'
							ENDIF
						ENDIF
					ENDFOR
				ENDWITH	&& THIS
			ENDIF

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO
			*loEx.UserValue	= 'ATENCION: EL ERROR PODRIA SER DEL PROGRAMA FUENTE' + CR_LF + CR_LF ;
				+ JUSTEXT(THIS.c_inputFile) + ' Line ' + TRANSFORM(I) + ':' + ta_Lineas(I)

			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		FINALLY
			STORE NULL TO loObjeto, loOle, loClase
			RELEASE loObjeto, loOle, loClase
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
	PROCEDURE INIT
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
		DODEFAULT()

		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, loReg, lcLine, laCode(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laUbicacionBloquesExclusion(1,2), I, toModulo
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_inputFile )
			lnCodeLines			= ALINES( laCode, C_FB2PRG_CODE )

			*-- Identifico los TEXT/ENDTEXT, #IF .F./#ENDIF
			THIS.identificarBloquesDeExclusion( @laCode, .F., @laUbicacionBloquesExclusion )

			*-- Identifico el inicio/fin de bloque, definición, cabecera y cuerpo de cada clase
			THIS.identificarBloquesDeCodigo( @laCode, @laUbicacionBloquesExclusion, @toModulo )

			THIS.escribirArchivoBin( @toModulo )


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lnCodError
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
		*-- 	Ini_Cab/Fin_Cab			Línea de inicio/fin de la cabecera (def.propiedades, Hidden, Protected, #Include, CLASSDATA, DEFINED_PEM)
		*-- 	Ini_Cuerpo/Fin_Cuerpo	Línea de inicio/fin del cuerpo (ADD OBJECTs y PROCEDURES)
		*-- 	HiddenProps				Propiedades definidas como HIDDEN (ocultas)
		*-- 	ProtectedProps			Propiedades definidas como PROTECTED (protegidas)
		*-- 	Defined_PEM				Propiedades, eventos o métodos definidos por el usuario
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

			THIS.doBackup()
			THIS.createClasslib()


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
					, THIS.classProps2Memo( loClase ) ;
					, THIS.hiddenAndProtected_PEM( loClase ) ;
					, THIS.classMethods2Memo( loClase ) ;
					, loClase._Ole ;
					, loClase._Ole2 ;
					, 'Class' ;
					, TRANSFORM( loClase._AddObject_Count + 1 ) ;
					, THIS.defined_PEM2Memo( loClase ) ;
					, loClase._ClassIcon ;
					, loClase._ProjectClassIcon ;
					, loClase._Scale ;
					, loClase._Comentario ;
					, loClase._IncludeFile ;
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
			COMPILE CLASSLIB (THIS.c_outputFile)


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
	PROCEDURE INIT
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
		DODEFAULT()

		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, loReg, lcLine, laCode(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laUbicacionBloquesExclusion(1,2), I, toModulo
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_inputFile )
			lnCodeLines			= ALINES( laCode, C_FB2PRG_CODE )

			*-- Identifico los TEXT/ENDTEXT, #IF .F./#ENDIF
			THIS.identificarBloquesDeExclusion( @laCode, .F., @laUbicacionBloquesExclusion )

			*-- Identifico el inicio/fin de bloque, definición, cabecera y cuerpo de cada clase
			THIS.identificarBloquesDeCodigo( @laCode, @laUbicacionBloquesExclusion, @toModulo )

			THIS.escribirArchivoBin( @toModulo )


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lnCodError
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
		*-- 	Ini_Cab/Fin_Cab			Línea de inicio/fin de la cabecera (def.propiedades, Hidden, Protected, #Include, CLASSDATA, DEFINED_PEM)
		*-- 	Ini_Cuerpo/Fin_Cuerpo	Línea de inicio/fin del cuerpo (ADD OBJECTs y PROCEDURES)
		*-- 	HiddenProps				Propiedades definidas como HIDDEN (ocultas)
		*-- 	ProtectedProps			Propiedades definidas como PROTECTED (protegidas)
		*-- 	Defined_PEM				Propiedades, eventos o métodos definidos por el usuario
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

			THIS.doBackup()
			THIS.createForm()

			*-- El SCX tiene el INCLUDE en el primer registro
			IF NOT EMPTY(THIS.includeFile)
				REPLACE RESERVED8 WITH THIS.includeFile
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
					, THIS.classProps2Memo( loClase ) ;
					, THIS.hiddenAndProtected_PEM( loClase ) ;
					, THIS.classMethods2Memo( loClase ) ;
					, loClase._Ole ;
					, loClase._Ole2 ;
					, '' ;
					, TRANSFORM( loClase._AddObject_Count + 1 ) ;
					, THIS.defined_PEM2Memo( loClase ) ;
					, loClase._ClassIcon ;
					, loClase._ProjectClassIcon ;
					, loClase._Scale ;
					, loClase._Comentario ;
					, loClase._IncludeFile ;
					, loClase._User )


				THIS.insert_AllObjects( @loClase )


				IF NOT loClase._BaseClass == 'dataenvironment'
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
			COMPILE FORM (THIS.c_outputFile)


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
	PROCEDURE INIT
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
		DODEFAULT()

		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, loReg, lcLine, laCode(1), lnCodeLines, lnFB2P_Version, lcSourceFile ;
				, laUbicacionBloquesExclusion(1,2), I ;
				, loProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
			STORE 0 TO lnCodError, lnCodeLines, lnFB2P_Version
			STORE '' TO lcLine, lcSourceFile
			STORE NULL TO loReg, toModulo

			C_FB2PRG_CODE		= FILETOSTR( THIS.c_inputFile )
			lnCodeLines			= ALINES( laCode, C_FB2PRG_CODE )

			*-- Identifico los TEXT/ENDTEXT, #IF .F./#ENDIF
			*THIS.identificarBloquesDeExclusion( @laCode, .F., @laUbicacionBloquesExclusion )

			*-- Identifico el inicio/fin de bloque, definición, cabecera y cuerpo de cada clase
			THIS.identificarBloquesDeCodigo( @laCode, @laUbicacionBloquesExclusion, @loProject )

			THIS.escribirArchivoBin( @loProject )


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lnCodError
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

			THIS.doBackup()

			STRTOFILE( '', '__newproject.f2b' )
			BUILD PROJECT (THIS.c_outputFile) FROM '__newproject.f2b'
			ERASE ( '__newproject.f2b' )

			USE (THIS.c_outputFile) ALIAS TABLABIN AGAIN SHARED
			
			lcMainProg	= ''
			
			IF NOT EMPTY(toProject._MainProg)
				lcMainProg	= LOWER( SYS(2014, toProject._MainProg, ADDBS(JUSTPATH(toProject._HomeDir)) ) )			
			ENDIF

			*-- Actualizo información del Header
			SCATTER FIELDS DEVINFO,RESERVED2 MEMO NAME loReg
			loReg.DEVINFO	= toProject.getRowDeviceInfo()
			loServerHead	= toProject._ServerHead
			loReg.RESERVED2	= loServerHead.getRowServerInfo()
			GATHER NAME loReg FIELDS DEVINFO,RESERVED2 MEMO

			*-- Si hay ProjectHook, reutilizo registro del archivo dummy
			GOTO RECORD 2

			IF EMPTY(toProject._ProjectHookLibrary)
				*-- Erase Dummy file record '__newproject.f2b'
				DELETE
			ELSE
				*-- Project Hook
				REPLACE ;
					NAME WITH toProject._ProjectHookLibrary + CHR(0), ;
					TYPE WITH 'W', ;
					EXCLUDE WITH .T., ;
					KEY WITH UPPER(JUSTSTEM(toProject._ProjectHookLibrary)), ;
					RESERVED1 WITH toProject._ProjectHookClass + CHR(0)
			ENDIF

			*-- Si hay icono de proyecto, lo inserto
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

			*-- Agrego los archivos
			FOR EACH loFile IN toProject FOXOBJECT
				INSERT INTO TABLABIN ;
					( NAME ;
					, TYPE ;
					, EXCLUDE ;
					, MAINPROG ;
					, COMMENTS ;
					, LOCAL ;
					, KEY ) ;
					VALUES ;
					( loFile._Name + CHR(0) ;
					, THIS.fileTypeCode(JUSTEXT(loFile._Name)) ;
					, loFile._Exclude ;
					, (loFile._Name == lcMainProg) ;
					, loFile._Comments ;
					, .T. ;
					, UPPER(JUSTSTEM(loFile._Name)) )
			ENDFOR


			USE IN (SELECT("TABLABIN"))


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
		LPARAMETERS ta_Lineas, ta_Pos_BloquesExclusion, toProject
		*--------------------------------------------------------------------------------------------------------------
		* ta_Lineas					(!@ IN    ) El array con las líneas del bloque de texto donde buscar
		* ta_Pos_BloquesExclusion	(!@ IN    ) Array con las posiciones de inicio/fin de los bloques de exclusion
		* toProject					(?@    OUT) Objeto con toda la información del proyecto analizado
		*
		* NOTA:
		* Como identificador se usa el nombre de clase o de procedimiento, según corresponda.
		*--------------------------------------------------------------------------------------------------------------
		EXTERNAL ARRAY ta_Lineas, ta_Pos_BloquesExclusion

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL I, lc_Comentario, lcLine, lnLineas, llBuildProj_Completed, llDevInfo_Completed ;
				, llServerHead_Completed, llFileComments_Completed, llFoxBin2Prg_Completed ;
				, llExcludedFiles_Completed, llTextFiles_Completed, llProjectProperties_Completed
			DIMENSION ta_Ubicacion_Bloques(1,2)
			STORE 0 TO I

			THIS.c_Type	= UPPER(JUSTEXT(THIS.c_outputFile))
			lnLineas	= ALEN(ta_Lineas,1)

			IF lnLineas > 1
				toProject			= CREATEOBJECT('CL_PROJECT')
				toProject._HomeDir	= ADDBS(JUSTPATH(THIS.c_outputFile))

				WITH THIS
					FOR I = 1 TO lnLineas
						lcLine = LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

						IF .lineIsOnlyComment( @lcLine, @lc_Comentario ) && Vacía o solo Comentarios
							LOOP
						ENDIF

						DO CASE
						CASE NOT llFoxBin2Prg_Completed AND .analizarBloque_FoxBin2Prg( toProject, @lcLine, @ta_Lineas, @I, lnLineas )
							llFoxBin2Prg_Completed	= .T.

						CASE NOT llDevInfo_Completed AND .analizarBloque_DevInfo( toProject, @lcLine, @ta_Lineas, @I, lnLineas )
							llDevInfo_Completed	= .T.

						CASE NOT llServerHead_Completed AND .analizarBloque_ServerHead( toProject, @lcLine, @ta_Lineas, @I, lnLineas )
							llServerHead_Completed	= .T.

						CASE .analizarBloque_ServerData( toProject, @lcLine, @ta_Lineas, @I, lnLineas )
							*-- Puede haber varios servidores, por eso se siguen valuando

						CASE NOT llBuildProj_Completed AND .analizarBloque_BuildProj( toProject, @lcLine, @ta_Lineas, @I, lnLineas )
							llBuildProj_Completed	= .T.

						CASE NOT llFileComments_Completed AND .analizarBloque_FileComments( toProject, @lcLine, @ta_Lineas, @I, lnLineas )
							llFileComments_Completed	= .T.

						CASE NOT llExcludedFiles_Completed AND .analizarBloque_ExcludedFiles( toProject, @lcLine, @ta_Lineas, @I, lnLineas )
							llExcludedFiles_Completed	= .T.

						CASE NOT llTextFiles_Completed AND .analizarBloque_TextFiles( toProject, @lcLine, @ta_Lineas, @I, lnLineas )
							llTextFiles_Completed	= .T.

						CASE NOT llProjectProperties_Completed AND .analizarBloque_ProjectProperties( toProject, @lcLine, @ta_Lineas, @I, lnLineas )
							llProjectProperties_Completed	= .T.

						ENDCASE

					ENDFOR
				ENDWITH && THIS
			ENDIF

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
		LPARAMETERS toProject, tcLine, ta_Lineas, I, tnLineas

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, X ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_BUILDPROJ_I) ) == C_BUILDPROJ_I
				llBloqueEncontrado	= .T.
				STORE NULL TO loProject, loFile
				X = I + 1

				FOR I = X TO tnLineas
					tcLine = LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

					DO CASE
					CASE LEFT( tcLine, LEN(C_BUILDPROJ_F) ) == C_BUILDPROJ_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyComment( @tcLine )
						LOOP	&& Saltear comentarios

					CASE UPPER( LEFT( tcLine, 14 ) ) == 'BUILD PROJECT '
						LOOP

					CASE UPPER( LEFT( tcLine, 5 ) ) == '.ADD('
						* loFile: NAME,TYPE,EXCLUDE,COMMENTS
						tcLine			= CHRTRAN( tcLine, ["] + '[]', "'''" )	&& Convierto "[] en '
						loFile			= CREATEOBJECT('CL_PROJ_FILE')
						loFile._Name	= ALLTRIM( STREXTRACT( tcLine, ['], ['] ) )
						toProject.ADD( loFile, loFile._Name )
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
		LPARAMETERS toProject, tcLine, ta_Lineas, I, tnLineas

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, X ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_DEVINFO_I) ) == C_DEVINFO_I
				llBloqueEncontrado	= .T.

				X = I + 1

				FOR I = X TO tnLineas
					tcLine = LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

					DO CASE
					CASE LEFT( tcLine, LEN(C_DEVINFO_F) ) == C_DEVINFO_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyComment( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						toProject.setParsedProjInfoLine( @tcLine )
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
		LPARAMETERS toProject, tcLine, ta_Lineas, I, tnLineas

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, X ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_SRV_HEAD_I) ) == C_SRV_HEAD_I
				llBloqueEncontrado	= .T.

				STORE NULL TO loServerHead, loServerData
				loServerHead	= toProject._ServerHead
				X = I + 1

				FOR I = X TO tnLineas
					tcLine = LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

					DO CASE
					CASE LEFT( tcLine, LEN(C_SRV_HEAD_F) ) == C_SRV_HEAD_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyComment( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						loServerHead.setParsedHeadInfoLine( @tcLine )
					ENDCASE
				ENDFOR

				I = I - 1
			ENDIF

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
		LPARAMETERS toProject, tcLine, ta_Lineas, I, tnLineas

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, X ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG' ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_SRV_DATA_I) ) == C_SRV_DATA_I
				llBloqueEncontrado	= .T.

				STORE NULL TO loServerHead, loServerData
				loServerHead	= toProject._ServerHead
				loServerData	= loServerHead.getServerDataObject()
				X = I + 1

				FOR I = X TO tnLineas
					tcLine = LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

					DO CASE
					CASE LEFT( tcLine, LEN(C_SRV_DATA_F) ) == C_SRV_DATA_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyComment( @tcLine )
						LOOP	&& Saltear comentarios

					OTHERWISE
						loServerHead.setParsedInfoLine( loServerData, @tcLine )
					ENDCASE
				ENDFOR

				loServerHead.add_Server( loServerData )
				I = I - 1
			ENDIF

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
		LPARAMETERS toProject, tcLine, ta_Lineas, I, tnLineas

		EXTERNAL ARRAY toProject
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, X, lcFile, lcComment ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_FILE_CMTS_I) ) == C_FILE_CMTS_I
				llBloqueEncontrado	= .T.
				X = I + 1

				FOR I = X TO tnLineas
					tcLine = LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

					DO CASE
					CASE LEFT( tcLine, LEN(C_FILE_CMTS_F) ) == C_FILE_CMTS_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyComment( @tcLine )
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
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
		LPARAMETERS toProject, tcLine, ta_Lineas, I, tnLineas

		EXTERNAL ARRAY toProject
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, X, lcFile, llExclude ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_FILE_EXCL_I) ) == C_FILE_EXCL_I
				llBloqueEncontrado	= .T.
				X = I + 1

				FOR I = X TO tnLineas
					tcLine = LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

					DO CASE
					CASE LEFT( tcLine, LEN(C_FILE_EXCL_F) ) == C_FILE_EXCL_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyComment( @tcLine )
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
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
		LPARAMETERS toProject, tcLine, ta_Lineas, I, tnLineas

		EXTERNAL ARRAY toProject
		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, X, lcFile, lcType ;
				, loFile AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'

			IF LEFT( tcLine, LEN(C_FILE_TXT_I) ) == C_FILE_TXT_I
				llBloqueEncontrado	= .T.
				X = I + 1

				FOR I = X TO tnLineas
					tcLine = LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

					DO CASE
					CASE LEFT( tcLine, LEN(C_FILE_TXT_F) ) == C_FILE_TXT_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyComment( @tcLine )
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
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
		LPARAMETERS toProject, tcLine, ta_Lineas, I, tnLineas

		#IF .F.
			LOCAL toProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL llBloqueEncontrado, X, lcLine

			IF LEFT( tcLine, LEN(C_PROJPROPS_I) ) == C_PROJPROPS_I
				llBloqueEncontrado	= .T.
				X = I + 1

				FOR I = X TO tnLineas
					tcLine = LTRIM( ta_Lineas(I), 0, ' ', CHR(9) )

					DO CASE
					CASE LEFT( tcLine, LEN(C_PROJPROPS_F) ) == C_PROJPROPS_F
						I = I + 1
						EXIT

					CASE THIS.lineIsOnlyComment( @tcLine )
						LOOP	&& Saltear comentarios

					CASE LEFT( tcLine, 9 ) == '.SetMain('
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
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN llBloqueEncontrado
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
	PROCEDURE INIT
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, loRegClass, loRegObj, lnMethodCount, laMethods(1), laCode(1), laProtected(1) ;
				, laProps(1), laPropsWithComments(1), lnLastClass, lnRecno, lcMethods, lcObjName, la_NombresObjsOle(1)
			STORE 0 TO lnCodError, lnLastClass
			STORE '' TO laMethods(1), laCode(1), laProtected(1), laPropsWithComments(1)
			STORE NULL TO loRegClass, loRegObj

			USE (THIS.c_inputFile) SHARED NOUPDATE ALIAS TABLABIN

			IF FILE('C_SUB_OBJS.CDX')
				ERASE 'C_SUB_OBJS.CDX'
			ENDIF
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

				THIS.write_Define_Class_COMMENTS( @loRegClass )

				THIS.write_METADATA( @loRegClass )

				THIS.write_INCLUDE( @loRegClass )

				THIS.write_CLASS_PROPERTIES( @loRegClass, @laProps, @laPropsWithComments, @laProtected )


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

				THIS.write_CLASS_METHODS( @lnMethodCount, @laMethods, @laCode, @laProtected, @laPropsWithComments )

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
			STRTOFILE( C_FB2PRG_CODE, THIS.c_outputFile )

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
DEFINE CLASS c_conversor_scx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_scx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	*_MEMBERDATA	= [<VFPData>] ;
	+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
	+ [</VFPData>]

	*******************************************************************************************************************
	PROCEDURE INIT
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
		TRY
			LOCAL lnCodError, loEx AS EXCEPTION, loRegClass, loRegObj, lnMethodCount, laMethods(1), laCode(1), laProtected(1) ;
				, laProps(1), laPropsWithComments(1), lnLastClass, lnRecno, lcMethods, lcObjName, la_NombresObjsOle(1)
			STORE 0 TO lnCodError, lnLastClass
			STORE '' TO laMethods(1), laCode(1), laProtected(1), laPropsWithComments(1)
			STORE NULL TO loRegClass, loRegObj

			USE (THIS.c_inputFile) SHARED NOUPDATE ALIAS TABLABIN

			IF FILE('C_SUB_OBJS.CDX')
				ERASE 'C_SUB_OBJS.CDX'
			ENDIF
			INDEX ON PADR(LOWER(PLATFORM + IIF(EMPTY(PARENT),'',ALLTRIM(PARENT)+'.')+OBJNAME),240) TAG PARENT_OBJ OF TABLABIN ADDITIVE
			SET ORDER TO 0 IN TABLABIN

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

			*-- #INCLUDE
			*FDB*
			SCATTER FIELDS RESERVED8 MEMO NAME loRegClass

			IF NOT EMPTY(loRegClass.RESERVED8) THEN
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					#INCLUDE "<<loRegClass.Reserved8>>"

				ENDTEXT
			ENDIF


			SCAN ALL FOR TABLABIN.PLATFORM = "WINDOWS" AND (TABLABIN.CLASS == 'dataenvironment' OR TABLABIN.CLASS == 'form')
				SCATTER MEMO NAME loRegClass
				lcObjName	= ALLTRIM(loRegClass.OBJNAME)

				THIS.write_ENDDEFINE_SiCorresponde( lnLastClass )

				THIS.write_DEFINE_CLASS( @la_NombresObjsOle, @loRegClass )

				THIS.write_Define_Class_COMMENTS( @loRegClass )

				THIS.write_METADATA( @loRegClass )

				THIS.write_INCLUDE( @loRegClass )

				THIS.write_CLASS_PROPERTIES( @loRegClass, @laProps, @laPropsWithComments, @laProtected )


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

				THIS.write_CLASS_METHODS( @lnMethodCount, @laMethods, @laCode, @laProtected, @laPropsWithComments )

				lnLastClass		= 1
				lcMethods		= ''

				*-- RECORRO LOS OBJETOS DENTRO DE LA CLASE ACTUAL PARA OBTENER SUS MÉTODOS
				lnRecno	= RECNO()
				LOCATE FOR TABLABIN.PLATFORM = "WINDOWS" AND ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

				SCAN REST ;
						FOR TABLABIN.PLATFORM = "WINDOWS" AND NOT (TABLABIN.CLASS == 'dataenvironment' OR TABLABIN.CLASS == 'form') ;
						WHILE ALLTRIM(GETWORDNUM(TABLABIN.PARENT, 1, '.')) == lcObjName

					SCATTER MEMO NAME loRegObj
					THIS.get_ADD_OBJECT_METHODS( @loRegObj, @loRegClass, @lcMethods )
				ENDSCAN

				THIS.write_ALL_OBJECT_METHODS( @lcMethods )

				GOTO RECORD (lnRecno)
			ENDSCAN

			THIS.write_ENDDEFINE_SiCorresponde( lnLastClass )

			*-- Genero el SC2
			STRTOFILE( C_FB2PRG_CODE, THIS.c_outputFile )

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
DEFINE CLASS c_conversor_pjx_a_prg AS c_conversor_bin_a_prg
	#IF .F.
		LOCAL THIS AS c_conversor_pjx_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	*_MEMBERDATA	= [<VFPData>] ;
	*	+ [<memberdata name="write_program_header" type="method" display="write_PROGRAM_HEADER"/>] ;
	*	+ [</VFPData>]

	*******************************************************************************************************************
	PROCEDURE INIT
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_PROGRAM_HEADER
		*-- Cabecera del PRG e inicio de DEF_CLASS
		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
			*--------------------------------------------------------------------------------------------------------------------------------------------------------
			* (ES) AUTOGENERADO - PARA MANTENER INFORMACIÓN DE SERVIDORES DLL USAR "FOXBIN2PRG", SI NO IMPORTAN, EJECUTAR DIRECTAMENTE PARA REGENERAR EL PROYECTO.
			* (EN) AUTOGENERATED - TO KEEP DLL SERVER INFORMATION USE "FOXBIN2PRG", OTHERWISE YOU CAN EXECUTE DIRECTLY TO REGENERATE PROJECT.
			*--------------------------------------------------------------------------------------------------------------------------------------------------------
			<<C_FB2PRG_META_I>> Version = "<<TRANSFORM(THIS.n_FB2PRG_Version)>>", SourceFile = "<<THIS.c_InputFile>>" <<C_FB2PRG_META_F>>
			*
		ENDTEXT
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
		TRY
			LOCAL lnCodError, lcStr, lnPos, lnLen, lnServerCount, loReg, lcDevInfo ;
				, loEx AS EXCEPTION ;
				, loProject AS CL_PROJECT OF 'FOXBIN2PRG.PRG' ;
				, loServerHead AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG' ;
				, loServerData AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'

			STORE NULL TO loProject, loReg, loServerHead, loServerData
			USE (THIS.c_inputFile) SHARED NOUPDATE ALIAS TABLABIN
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
				SCATTER FIELDS NAME,TYPE,EXCLUDE,COMMENTS MEMO NAME loReg
				loReg.NAME		= LOWER( ALLTRIM( loReg.NAME, 0, ' ', CHR(0) ) )
				loReg.COMMENTS	= CHRTRAN( ALLTRIM( loReg.COMMENTS, 0, ' ', CHR(0) ), ['], ["] )
				loProject.ADD( loReg, loReg.NAME )
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


			*-- Definir archivos del proyecto
			loProject.KEYSORT = 2

			FOR EACH loReg IN loProject &&FOXOBJECT
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>>.ADD('<<loReg.NAME>>')
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

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				<<C_TAB>>.Icon = lcCurdir + '<<loProject._Icon>>'
				<<C_TAB>>.Debug = <<loProject._Debug>>
				<<C_TAB>>.Encrypted = <<loProject._Encrypted>>
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
				ERASE '__newproject.f2b'
				CD (lcCurdir)
				RETURN
			ENDTEXT


			*-- Genero el PJ2
			STRTOFILE( C_FB2PRG_CODE, THIS.c_outputFile )
			*COMPILE ( THIS.c_outputFile )


		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
DEFINE CLASS c_conversor_bin_a_prg AS c_conversor_base
	#IF .F.
		LOCAL THIS AS c_conversor_bin_a_prg OF 'FOXBIN2PRG.PRG'
	#ENDIF
	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="write_all_object_methods" type="method" display="write_ALL_OBJECT_METHODS"/>] ;
		+ [<memberdata name="get_add_object_methods" type="method" display="get_ADD_OBJECT_METHODS"/>] ;
		+ [<memberdata name="write_add_objects_withproperties" type="method" display="write_ADD_OBJECTS_WithProperties"/>] ;
		+ [<memberdata name="write_define_class_comments" type="method" display="write_Define_Class_COMMENTS"/>] ;
		+ [<memberdata name="write_enddefine_sicorresponde" type="method" display="write_ENDDEFINE_SiCorresponde"/>] ;
		+ [<memberdata name="comprobarexpresionvalida" type="method" display="ComprobarExpresionValida"/>] ;
		+ [<memberdata name="convertir" type="method" display="Convertir"/>] ;
		+ [<memberdata name="write_definicionobjetosole" type="method" display="write_DefinicionObjetosOLE"/>] ;
		+ [<memberdata name="write_class_methods" type="method" display="write_CLASS_METHODS"/>] ;
		+ [<memberdata name="write_define_class" type="method" display="write_DEFINE_CLASS"/>] ;
		+ [<memberdata name="write_metadata" type="method" display="write_METADATA"/>] ;
		+ [<memberdata name="write_include" type="method" display="write_INCLUDE"/>] ;
		+ [<memberdata name="write_class_properties" type="method" display="write_CLASS_PROPERTIES"/>] ;
		+ [<memberdata name="write_program_header" type="method" display="write_PROGRAM_HEADER"/>] ;
		+ [<memberdata name="exception2str" type="method" display="Exception2Str"/>] ;
		+ [<memberdata name="get_propswithcomments" type="method" display="Get_PropsWithComments"/>] ;
		+ [<memberdata name="indentarmemo" type="method" display="IndentarMemo"/>] ;
		+ [<memberdata name="memoinoneline" type="method" display="MemoInOneLine"/>] ;
		+ [<memberdata name="set_multilinememowithaddobjectproperties" type="method" display="set_MultilineMemoWithAddObjectProperties"/>] ;
		+ [<memberdata name="normalizarasignacion" type="method" display="normalizarAsignacion"/>] ;
		+ [<memberdata name="get_nombresobjetosolepublic" type="method" display="get_NombresObjetosOLEPublic"/>] ;
		+ [<memberdata name="sortnames" type="method" display="SortNames"/>] ;
		+ [<memberdata name="sortmethod" type="method" display="SortMethod"/>] ;
		+ [</VFPData>]


	*******************************************************************************************************************
	PROCEDURE INIT
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE DESTROY
		DODEFAULT()
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Convertir
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_ALL_OBJECT_METHODS
		LPARAMETERS tcMethods

		*-- Finalmente, todos los métodos los ordeno y escribo juntos
		LOCAL laMethods(1), laCode(1), lnMethodCount, I

		IF NOT EMPTY(tcMethods)
			DIMENSION laMethods(1,3)
			THIS.SortMethod( @tcMethods, @laMethods, @laCode, '', @lnMethodCount )

			FOR I = 1 TO lnMethodCount
				*-- Genero los métodos indentados
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<C_TAB>><<laMethods(I,3)>>PROCEDURE <<laMethods(I,1)>>
					<<THIS.IndentarMemo( laCode(laMethods(I,2)), CHR(9) + CHR(9) )>>
					<<C_TAB>>ENDPROC

				ENDTEXT
			ENDFOR
		ENDIF

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE get_ADD_OBJECT_METHODS
		LPARAMETERS toRegObj, toRegClass, tcMethods

		TRY
			LOCAL laMethods(1,3), laCode(1), lnMethodCount

			THIS.SortMethod( toRegObj.METHODS, @laMethods, @laCode, '', @lnMethodCount )

			*-- Ubico los métodos protegidos y les cambio la definición.
			*-- Los métodos se deben generar con la ruta completa, porque si no es imposible saber a que objeto corresponden,
			*-- o si son de la clase.
			IF lnMethodCount > 0 THEN
				FOR I = 1 TO lnMethodCount
					IF EMPTY(toRegObj.PARENT)
						lcMethodName	= toRegObj.OBJNAME + '.' + laMethods(I,1)
					ELSE
						DO CASE
						CASE '.' $ toRegObj.PARENT
							lcMethodName	= SUBSTR(toRegObj.PARENT, AT('.', toRegObj.PARENT) + 1) + '.' + toRegObj.OBJNAME + '.' + laMethods(I,1)

						CASE LEFT(toRegObj.PARENT + '.', LEN( toRegClass.OBJNAME + '.' ) ) == toRegClass.OBJNAME + '.'
							lcMethodName	= toRegObj.OBJNAME + '.' + laMethods(I,1)

						OTHERWISE
							lcMethodName	= toRegObj.PARENT + '.' + toRegObj.OBJNAME + '.' + laMethods(I,1)

						ENDCASE
					ENDIF

					*-- Genero el método SIN indentar, ya que se hace luego
					TEXT TO tcMethods ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						PROCEDURE <<lcMethodName>>
						<<THIS.IndentarMemo( laCode(laMethods(I,2)) )>>
						ENDPROC
					ENDTEXT
				ENDFOR
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_ADD_OBJECTS_WithProperties
		LPARAMETERS toRegObj
		
		#IF .F.
			LOCAL toRegObj AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
		#ENDIF

		TRY
			LOCAL lcMemo

			*-- Defino los objetos a cargar
			THIS.SortNames( toRegObj.PROPERTIES, '', '', @lcMemo )
			lcMemo	= THIS.set_MultilineMemoWithAddObjectProperties( lcMemo, C_TAB + C_TAB, .T. )

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
					ClassLib = "<<toRegObj.ClassLoc>>" <<>>
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				BaseClass = "<<toRegObj.Baseclass>>" Uniqueid = "<<toRegObj.Uniqueid>>" <<>>
			ENDTEXT

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				Timestamp = "<<THIS.getTimeStamp(toRegObj.Timestamp)>>"  ZOrder = "<<TRANSFORM(toRegObj._ZOrder)>>" <<>>
			ENDTEXT

			*-- Agrego metainformación para objetos OLE
			IF toRegObj.BASECLASS == 'olecontrol'
				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
					OLEObject = "<<STREXTRACT(toRegObj.ole2, 'OLEObject = ', CHR(13)+CHR(10), 1, 1+2)>>" checksum = "<<SYS(2007, toRegObj.ole, 0, 1)>>" <<>>
				ENDTEXT
			ENDIF

			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<<C_END_OBJECT_F>>

			ENDTEXT

		CATCH TO loEx
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_CLASS_METHODS
		LPARAMETERS tnMethodCount, taMethods, taCode, taProtected, taPropsWithComments
		*-- DEFINIR MÉTODOS DE LA CLASE
		*-- Ubico los métodos protegidos y les cambio la definición
		EXTERNAL ARRAY taMethods, taCode, taProtected, taPropsWithComments

		TRY
			LOCAL lcMethod, lnProtectedItem, lnCommentRow, lcProcDef, lcMethods
			STORE '' TO lcMethod, lcProcDef, lcMethods

			IF tnMethodCount > 0 THEN
				FOR I = 1 TO tnMethodCount
					lcMethod		= CHRTRAN( taMethods(I,1), '^', '' )
					lnProtectedItem	= ASCAN( taProtected, taMethods(I,1), 1, 0, 0, 0)
					lnCommentRow		= ASCAN( taPropsWithComments, '*' + lcMethod, 1, 0, 1, 8)

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

					IF lnCommentRow > 0 AND NOT EMPTY(taPropsWithComments(lnCommentRow,2))
						TEXT TO lcMethods ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
							<<C_TAB + C_TAB>>&& <<taPropsWithComments(lnCommentRow,2)>>
						ENDTEXT
					ENDIF

					TEXT TO lcMethods ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<THIS.IndentarMemo( taCode(taMethods(I,2)), CHR(9) + CHR(9) )>>
						<<C_TAB>>ENDPROC

					ENDTEXT
				ENDFOR

				TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
					<<lcMethods>>
				ENDTEXT

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_PROGRAM_HEADER
		*-- Cabecera del PRG e inicio de DEF_CLASS
		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
			*--------------------------------------------------------------------------------------------------------------------------------------------------------
			* (ES) AUTOGENERADO - ¡¡ATENCIÓN!! - ¡¡NO PENSADO PARA EJECUTAR!! USAR SOLAMENTE PARA INTEGRAR CAMBIOS Y ALMACENAR CON HERRAMIENTAS SCM!!
			* (EN) AUTOGENERATED - ATTENTION!! - NOT INTENDED FOR EXECUTION!! USE ONLY FOR MERGING CHANGES AND STORING WITH SCM TOOLS!!
			*--------------------------------------------------------------------------------------------------------------------------------------------------------
			<<C_FB2PRG_META_I>> Version = "<<TRANSFORM(THIS.n_FB2PRG_Version)>>", SourceFile = "<<THIS.c_InputFile>>" <<C_FB2PRG_META_F>>
			*
		ENDTEXT
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_CLASS_PROPERTIES
		LPARAMETERS toRegClass, taProps, taPropsWithComments, taProtected

		EXTERNAL ARRAY taProps, taPropsWithComments

		TRY
			LOCAL lnLineCount, lcHiddenProp, lcProtectedProp, lcPropsMethodsDefd, lnComments, I ;
				, lcPropName, lnProtectedItem, lcComentarios

			WITH THIS
				*-- DEFINIR PROPIEDADES ( HIDDEN, PROTECTED, *DEFINED_PEM )
				DIMENSION taProtected(1)
				THIS.SortNames( toRegClass.PROPERTIES, @taProps, @lnLineCount, '' )
				STORE '' TO lcHiddenProp, lcProtectedProp, lcPropsMethodsDefd
				THIS.Get_PropsWithComments( @taPropsWithComments, @lnComments, toRegClass.RESERVED3 )
				=ALINES(taProtected, toRegClass.PROTECTED)

				IF lnLineCount > 0 THEN
					*-- Recorro las propiedades (campo Properties)
					FOR I = 1 TO lnLineCount
						lcPropName		= RTRIM( GETWORDNUM( taProps(I), 1, '=' ) )
						lnProtectedItem	= ASCAN(taProtected, lcPropName, 1, 0, 0, 0)

						*-- Ajustes de algunos casos especiales
						*taProps(I)	= THIS.normalizarAsignacion( taProps(I), @lcComentarios )

						*-- Estos comentarios solo son los generados como metadados por los autoajustes especiales
						*IF NOT EMPTY( lcComentarios )
						*	taProps(I)	= taProps(I) + C_TAB + C_TAB + lcComentarios
						*ENDIF

						DO CASE
						CASE lnProtectedItem = 0
							*-- Propiedad común

						CASE taProtected(lnProtectedItem) == lcPropName
							*-- Propiedad protegida
							lcProtectedProp	= lcProtectedProp + ',' + lcPropName

						CASE taProtected(lnProtectedItem) == lcPropName + '^'
							*-- Propiedad oculta
							lcHiddenProp	= lcHiddenProp + ',' + lcPropName

						ENDCASE
					ENDFOR

					*-- Escribo propiedades DEFINED (Reserved3)
					IF NOT EMPTY(taPropsWithComments)
						FOR I = 1 TO lnComments
							lcPropsMethodsDefd	= lcPropsMethodsDefd + ',' + taPropsWithComments(I,1)
						ENDFOR

						TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<C_TAB>><<C_DEFINED_PEM_I>> <<SUBSTR(lcPropsMethodsDefd,2)>> <<C_DEFINED_PEM_F>>
						ENDTEXT
					ENDIF

					*-- Escribo propiedades HIDDEN
					IF NOT EMPTY(lcHiddenProp)
						TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<C_TAB>>HIDDEN <<SUBSTR(lcHiddenProp,2)>>
						ENDTEXT
					ENDIF

					*-- Escribo propiedades PROTECTED
					IF NOT EMPTY(lcProtectedProp)
						TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<C_TAB>>PROTECTED <<SUBSTR(lcProtectedProp,2)>>
						ENDTEXT
					ENDIF

					*-- Escribo las propiedades de la clase y sus comentarios
					FOR I = 1 TO ALEN(taProps, 1)
						lcPropName		= RTRIM( GETWORDNUM( taProps(I), 1, '=' ) )

						TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
						<<C_TAB + taProps(I)>>
						ENDTEXT

						lnComment	= ASCAN( taPropsWithComments, lcPropName, 1, 0, 1, 8)

						IF lnComment > 0 AND NOT EMPTY(taPropsWithComments(lnComment,2))
							TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
							<<C_TAB + C_TAB>>&& <<taPropsWithComments(lnComment,2)>>
							ENDTEXT
						ENDIF
					ENDFOR

					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2

					ENDTEXT
				ENDIF
			ENDWITH && THIS

		CATCH TO loEx
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
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
			<<C_TAB>><<C_METADATA_I>> Baseclass = "<<toRegClass.Baseclass>>" Timestamp = "<<THIS.getTimeStamp(toRegClass.Timestamp)>>" Scale = "<<toRegClass.Reserved6>>" Uniqueid = "<<EVL(toRegClass.Uniqueid,SYS(2015))>>" <<>>
		ENDTEXT

		IF NOT EMPTY(toRegClass.OLE2)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				OLEObject = "<<STREXTRACT(toRegClass.ole2, 'OLEObject = ', CHR(13)+CHR(10), 1, 1+2)>>" <<>>
			ENDTEXT
		ENDIF

		IF NOT EMPTY(toRegClass.RESERVED5)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				ProjectClassIcon = "<<toRegClass.Reserved5>>" <<>>
			ENDTEXT
		ENDIF

		IF NOT EMPTY(toRegClass.RESERVED4)
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				ClassIcon = "<<toRegClass.Reserved4>>" <<>>
			ENDTEXT
		ENDIF

		TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
			<<C_METADATA_F>>
		ENDTEXT
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_Define_Class_COMMENTS
		LPARAMETERS toRegClass
		*-- Comentario de la clase
		IF NOT EMPTY(toRegClass.RESERVED7) THEN
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
				<<C_TAB + C_TAB + '&& ' + toRegClass.Reserved7>>
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
			DEFINE CLASS <<ALLTRIM(toRegClass.ObjName)>> AS <<ALLTRIM(toRegClass.Class)>> <<lcOF_Classlib + IIF(llOleObject, 'OLEPUBLIC', '')>>
		ENDTEXT

	ENDPROC


	*******************************************************************************************************************
	PROCEDURE write_ENDDEFINE_SiCorresponde
		LPARAMETERS tnLastClass
		IF tnLastClass = 1
			TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2
				ENDDEFINE

			ENDTEXT
		ENDIF
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
					<<C_OLE_I>> Nombre = "<<IIF(EMPTY(loReg.Parent),'',loReg.Parent+'.') + loReg.objName>>" parent = "<<loReg.Parent>>" objname = "<<loReg.objname>>" checksum = "<<lcOLEChecksum>>" <<>>
				ENDTEXT

				IF NOT llOleExistente
					TEXT TO C_FB2PRG_CODE ADDITIVE TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
						value = "<<STRCONV(loReg.ole,13)>>" <<>>
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
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE Get_PropsWithComments( taLines, tnLines, tcMemo )
		EXTERNAL ARRAY taLines

		TRY
			LOCAL laLines(1), I, lnPos, loEx AS EXCEPTION
			tnLines	= ALINES(laLines, tcMemo)
			DIMENSION taLines(tnLines,2)

			FOR I = 1 TO tnLines
				lnPos			= AT(' ', laLines(I))

				IF lnPos = 0
					taLines(I,1)	= laLines(I)
					taLines(I,2)	= ''
				ELSE
					taLines(I,1)	= LEFT( laLines(I), lnPos - 1 )
					taLines(I,2)	= SUBSTR( laLines(I), lnPos + 1 )
				ENDIF
			ENDFOR

		CATCH TO loEx
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
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
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN lcLine
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE set_MultilineMemoWithAddObjectProperties( tcMethod, tcLeftIndentation, tlNormalizeLine )
		TRY
			LOCAL lcLine, I, lcComentarios, laLines(1), lcFinDeLinea_Coma_PuntoComa_CR
			lcLine			= ''
			lcFinDeLinea	= ', ;' + CR_LF

			IF NOT EMPTY(tcMethod)
				IF VARTYPE(tcLeftIndentation) # 'C'
					tcLeftIndentation	= ''
				ENDIF

				FOR I = 1 TO ALINES(laLines, m.tcMethod, 0)
					*lcComentarios	= ''
					*lcLine			= lcLine + tcLeftIndentation

					*-- Ajustes de algunos casos especiales
					*laLines(I)		= THIS.normalizarAsignacion( laLines(I), @lcComentarios )
					*lcLine			= lcLine + laLines(I) + ', ;'

					*-- Estos comentarios solo con los metadatos autogenerados por los ajustes especiales
					*IF NOT EMPTY( lcComentarios )
					*	lcLine	= lcLine + C_TAB + C_TAB + lcComentarios
					*ENDIF

					*lcLine		= lcLine + CR_LF
					
					lcLine			= lcLine + tcLeftIndentation + laLines(I) + lcFinDeLinea
				ENDFOR

				*-- Si la última propiedad tiene comentarios, los quito temporalmente
				*IF NOT EMPTY(lcComentarios)
				*	lcLine	= STUFF( lcLine, LEN(lcLine) - LEN(lcComentarios) - 2 - 2 + 1, LEN(lcComentarios) + 2, '' )
				*ENDIF

				*-- Quito el ", ;<CRLF>" final
				lcLine	= tcLeftIndentation + SUBSTR(lcLine, 1 + LEN(tcLeftIndentation), LEN(lcLine) - LEN(tcLeftIndentation) - LEN(lcFinDeLinea))

				*-- Si la última línea tiene comentarios, los restablezco
				*IF NOT EMPTY(lcComentarios)
				*	lcLine	= lcLine + C_TAB + C_TAB + lcComentarios
				*ENDIF
			ENDIF

		CATCH TO loEx
			*loEx.UserValue	= 'ATENCION: EL ERROR PODRIA SER DEL PROGRAMA FUENTE' + CR_LF + CR_LF ;
				+ JUSTEXT(THIS.c_inputFile) + ' MEMO Line ' + TRANSFORM(I) + ':' + laLines(I) + CR_LF + CR_LF ;
				+ 'Analyzed memo content:' + CR_LF + tcMethod
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN lcLine
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE IndentarMemo( tcMethod, tcIndentation )
		*-- INDENTA EL CÓDIGO DE UN MÉTODO DADO Y QUITA LA CABECERA DE MÉTODO (PROCEDURE/ENDPROC) SI LA ENCUENTRA
		TRY
			LOCAL I, lcMethod, llProcedure, lnInicio, lnFin
			lcMethod		= ''
			llProcedure		= ( LEFT(tcMethod,10) == 'PROCEDURE ' ;
				OR LEFT(tcMethod,17) == 'HIDDEN PROCEDURE ' ;
				OR LEFT(tcMethod,20) == 'PROTECTED PROCEDURE ' )
			lnInicio		= 1
			lnFin			= ALINES(laLineas, tcMethod)
			IF VARTYPE(tcIndentation) # 'C'
				tcIndentation	= ''
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

			lcMethod	= SUBSTR(lcMethod,3)	&& Quito el primer ENTER

		CATCH TO loEx
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN lcMethod
	ENDPROC


	*******************************************************************************************************************
	PROCEDURE SortMethod( tcMethod, taMethods, taCode, tcSorted, tnMethodCount )
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
				lnLineCount	= ALINES(laLine, m.tcMethod)

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

					CASE tnMethodCount = 0	&& Skip empty lines before methos begin

					OTHERWISE && Method Code
						taCode(tnMethodCount)	= taCode(tnMethodCount) + laLine(I) + CR_LF

					ENDCASE
				ENDFOR

				*-- Alphabetical ordering of methods
				ASORT(taMethods,1,-1,0,1)

				FOR I = 1 TO tnMethodCount
					m.tcSorted	= m.tcSorted + taCode(taMethods(I,2))
				ENDFOR

			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC	&& SordMethod


	*******************************************************************************************************************
	PROCEDURE SortNames( tcMemo, taSortedItems, tnLineCount, tcSortedMemo )
		*-- 29/10/2013	Fernando D. Bozzo
		*-- Sort method for Reserved3, Properties and Protected memo fields
		TRY
			LOCAL lcMethods, loEx AS EXCEPTION
			DIMENSION taSortedItems(1)
			STORE '' TO tcSortedMemo, lcMethods, taSortedItems
			tnLineCount	= 0

			IF NOT EMPTY(m.tcMemo)
				tnLineCount = ALINES(taSortedItems, m.tcMemo, 1+4)
				ASORT(taSortedItems,1,-1,0,1)

				*-- Add properties first
				FOR I = 1 TO m.tnLineCount
					IF LEFT(taSortedItems(I), 1) == '*'	&& Only Reserved3 have this
						lcMethods	= m.lcMethods + m.taSortedItems(I) + CR_LF
						LOOP
					ENDIF

					tcSortedMemo	= m.tcSortedMemo + m.taSortedItems(I) + CR_LF
				ENDFOR

				*-- Add methods to the end
				tcSortedMemo	= m.tcSortedMemo + m.lcMethods
			ENDIF

		CATCH TO loEx
			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW
		ENDTRY

		RETURN
	ENDPROC


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
	PROCEDURE FixOle2Fields

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
	* (This method is taken from Open Source project TwoFox, from Christof Wallenhaupt - http://www.foxpert.com/downloads.htm)
	* Returns .T. when the OCX control resides outside the project directory
	FUNCTION OcxOutsideProjDir (tcOcx, tcProjDir)

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
DEFINE CLASS CL_MODULO AS CUSTOM
	#IF .F.
		LOCAL THIS AS CL_MODULO OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades. CLASS,
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="add_ole" type="method" display="add_OLE"/>] ;
		+ [<memberdata name="add_class" type="method" display="add_Class"/>] ;
		+ [<memberdata name="existeobjetoole" type="method" display="existeObjetoOLE"/>] ;
		+ [<memberdata name="_clases" type="property" display="_Clases"/>] ;
		+ [<memberdata name="_clases_count" type="property" display="_Clases_Count"/>] ;
		+ [<memberdata name="_ole_objs" type="property" display="_Ole_Objs"/>] ;
		+ [<memberdata name="_ole_obj_count" type="property" display="_Ole_Obj_Count"/>] ;
		+ [<memberdata name="_sourcefile" type="property" display="_SourceFile"/>] ;
		+ [<memberdata name="_version" type="property" display="_Version"/>] ;
		+ [</VFPData>]

	DIMENSION _Ole_Objs[1], _Clases[1]
	_Version		= 0
	_SourceFile		= ''
	_Ole_Obj_count	= 0
	_Clases_Count	= 0
	l_Debug				= .F.


	************************************************************************************************
	PROCEDURE INIT
		l_Debug	= (_VFP.STARTMODE=0)
	ENDPROC


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
DEFINE CLASS CL_OLE AS CUSTOM
	#IF .F.
		LOCAL THIS AS CL_OLE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades. CLASS,
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

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
DEFINE CLASS CL_CLASE AS CUSTOM
	#IF .F.
		LOCAL THIS AS CL_CLASE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades. CLASS,
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

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
		+ [<memberdata name="_defined_pem" type="property" display="_Defined_PEM"/>] ;
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
		+ [<memberdata name="_user" type="property" display="_User"/>] ;
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
	_Defined_PEM		= ''
	_IncludeFile		= ''
	_AddObject_Count	= 0
	_Procedure_Count	= 0
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
		LPARAMETERS tcProperty AS STRING, tcComment AS STRING
		THIS._Prop_Count	= THIS._Prop_Count + 1
		DIMENSION THIS._Props( THIS._Prop_Count, 2 )
		THIS._Props( THIS._Prop_Count, 1 )	= tcProperty
		THIS._Props( THIS._Prop_Count, 2 )	= tcComment
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
DEFINE CLASS CL_PROCEDURE AS CUSTOM
	#IF .F.
		LOCAL THIS AS CL_PROCEDURE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades. CLASS,
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

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
DEFINE CLASS CL_OBJETO AS CUSTOM
	#IF .F.
		LOCAL THIS AS CL_OBJETO OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades. CLASS,
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

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
		+ [<memberdata name="_pendiente" type="property" display="_Pendiente"/>] ;
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
	_Pendiente			= .T.
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
		LPARAMETERS tcProperty
		THIS._Prop_Count	= THIS._Prop_Count + 1
		DIMENSION THIS._Props( THIS._Prop_Count, 1 )
		THIS._Props( THIS._Prop_Count, 1 )	= tcProperty
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
		+ [<memberdata name="_debug" type="property" display="_Debug"/>] ;
		+ [<memberdata name="_encrypted" type="property" display="_Encrypted"/>] ;
		+ [<memberdata name="_homedir" type="property" display="_HomeDir"/>] ;
		+ [<memberdata name="_icon" type="property" display="_Icon"/>] ;
		+ [<memberdata name="_mainprog" type="property" display="_MainProg"/>] ;
		+ [<memberdata name="_projecthookclass" type="property" display="_ProjectHookClass"/>] ;
		+ [<memberdata name="_projecthooklibrary" type="property" display="_ProjectHookLibrary"/>] ;
		+ [<memberdata name="_serverinfo" type="property" display="_ServerInfo"/>] ;
		+ [<memberdata name="_serverhead" type="property" display="_ServerHead"/>] ;
		+ [<memberdata name="_sourcefile" type="property" display="_SourceFile"/>] ;
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
		+ [<memberdata name="setparsedinfoline" type="method" display="setParsedInfoLine"/>] ;
		+ [<memberdata name="setparsedprojinfoline" type="method" display="setParsedProjInfoLine"/>] ;
		+ [<memberdata name="getrowdeviceinfo" type="method" display="getRowDeviceInfo"/>] ;
		+ [</VFPData>]

	*-- Proj.Info
	_HomeDir			= ''
	_ServerInfo			= ''
	_Debug				= .F.
	_Encrypted			= .F.
	_MainProg			= ''
	_ProjectHookLibrary	= ''
	_ProjectHookClass	= ''
	_Icon				= ''
	_ServerHead			= NULL
	_Version			= ''
	_SourceFile			= ''

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
		l_Debug	= (_VFP.STARTMODE=0)
	ENDPROC


	************************************************************************************************
	PROCEDURE INIT
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
	PROCEDURE parseDeviceInfo
		LPARAMETERS tcDevInfo

		TRY
			WITH THIS
				._Autor				= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 1, 45 ), 0, ' ', CHR(0) ), ['], ["] )
				._Company			= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 47, 45 ), 0, ' ', CHR(0) ), ['], ["] )
				._Address			= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 93, 45 ), 0, ' ', CHR(0) ), ['], ["] )
				._City				= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 139, 20 ), 0, ' ', CHR(0) ), ['], ["] )
				._State				= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 160, 5 ), 0, ' ', CHR(0) ), ['], ["] )
				._PostalCode		= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 166, 10 ), 0, ' ', CHR(0) ), ['], ["] )
				._Country			= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 177, 45 ), 0, ' ', CHR(0) ), ['], ["] )
				*--
				._Comments			= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 223, 254 ), 0, ' ', CHR(0) ), ['], ["] )
				._CompanyName		= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 478, 254 ), 0, ' ', CHR(0) ), ['], ["] )
				._FileDescription	= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 733, 254 ), 0, ' ', CHR(0) ), ['], ["] )
				._LegalCopyright	= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 988, 254 ), 0, ' ', CHR(0) ), ['], ["] )
				._LegalTrademark	= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 1243, 254 ), 0, ' ', CHR(0) ), ['], ["] )
				._ProductName		= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 1498, 254 ), 0, ' ', CHR(0) ), ['], ["] )
				._MajorVer			= RTRIM( SUBSTR( tcDevInfo, 1753, 4 ), 0, ' ', CHR(0) )
				._MinorVer			= RTRIM( SUBSTR( tcDevInfo, 1758, 4 ), 0, ' ', CHR(0) )
				._Revision			= RTRIM( SUBSTR( tcDevInfo, 1763, 4 ), 0, ' ', CHR(0) )
				._LanguageID		= CHRTRAN( RTRIM( SUBSTR( tcDevInfo, 1768, 19 ), 0, ' ', CHR(0) ), ['], ["] )
				._AutoIncrement		= IIF( SUBSTR( tcDevInfo, 1788, 1 ) = CHR(1), '1', '0' )
			ENDWITH && THIS

		CATCH TO loEx
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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

			IF THIS.l_Debug
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
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC


ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJ_SRV_HEAD AS CUSTOM
	#IF .F.
		LOCAL THIS AS CL_PROJ_SRV_HEAD OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades. CLASS,
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

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

	*-- Server Head info
	DIMENSION _Servers[1]
	_ServerCount		= 0
	_LibraryName		= ''
	_InternalName		= ''
	_ProjectName		= ''
	_TypeLibDesc		= ''
	_ServerType			= ''
	_TypeLib			= ''
	l_Debug				= .F.


	************************************************************************************************
	PROCEDURE INIT
		l_Debug	= (_VFP.STARTMODE=0)
	ENDPROC


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
				lnCodError	= loEx.ERRORNO

				IF THIS.l_Debug
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
					lnLenH		= 8 + 8 + LEN(._LibraryName) + 4 + LEN(._InternalName) + 4 + LEN(._ProjectName) + 4 + LEN(._TypeLibDesc) - 1

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
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC
ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJ_SRV_DATA AS CUSTOM
	#IF .F.
		LOCAL THIS AS CL_PROJ_SRV_DATA OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades. CLASS,
	HIDDEN BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

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
	l_Debug			= .F.


	************************************************************************************************
	PROCEDURE INIT
		l_Debug	= (_VFP.STARTMODE=0)
	ENDPROC


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
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
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
			lnCodError	= loEx.ERRORNO

			IF THIS.l_Debug
				SET STEP ON
			ENDIF

			THROW

		ENDTRY

		RETURN lcText
	ENDPROC

ENDDEFINE


*******************************************************************************************************************
DEFINE CLASS CL_PROJ_FILE AS CUSTOM
	#IF .F.
		LOCAL THIS AS CL_PROJ_FILE OF 'FOXBIN2PRG.PRG'
	#ENDIF

	*-- Propiedades.
	HIDDEN CLASS, BASECLASS, TOP, WIDTH, CLASSLIB, CONTROLS, CLASSLIBRARY, COMMENT ;
		, CONTROLCOUNT, HEIGHT, HELPCONTEXTID, LEFT, NAME, OBJECTS, PARENT ;
		, PARENTCLASS, PICTURE, TAG, WHATSTHISHELPID

	*-- Métodos (Se preservan: init, destroy, error)
	HIDDEN ADDOBJECT, ADDPROPERTY, NEWOBJECT, READEXPRESSION, READMETHOD, REMOVEOBJECT ;
		, RESETTODEFAULT, SAVEASCLASS, SHOWWHATSTHIS, WRITEEXPRESSION, WRITEMETHOD

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="_name" type="property" display="_Name"/>] ;
		+ [<memberdata name="_type" type="property" display="_Type"/>] ;
		+ [<memberdata name="_exclude" type="property" display="_Exclude"/>] ;
		+ [<memberdata name="_comments" type="property" display="_Comments"/>] ;
		+ [</VFPData>]

	_Name			= ''
	_Type			= ''
	_Exclude		= .F.
	_Comments		= ''

ENDDEFINE

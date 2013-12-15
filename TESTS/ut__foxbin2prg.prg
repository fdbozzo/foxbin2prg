DEFINE CLASS ut__foxbin2prg AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg OF ut__foxbin2prg.prg
	#ENDIF

	#DEFINE C_FB2P_VALUE_I		'<fb2p_value>'
	#DEFINE C_FB2P_VALUE_F		'</fb2p_value>'
	#DEFINE CR_LF				CHR(13) + CHR(10)
	#DEFINE C_CR				CHR(13)
	#DEFINE C_LF				CHR(10)
	#DEFINE C_TAB				CHR(9)
	#DEFINE C_PROC				'PROCEDURE'
	#DEFINE C_ENDPROC			'ENDPROC'
	#DEFINE C_TEXT				'TEXT'
	#DEFINE C_ENDTEXT			'ENDTEXT'
	#DEFINE C_IF_F				'#IF .F.'
	#DEFINE C_ENDIF				'#ENDIF'
	#DEFINE C_DEFINE_CLASS		'DEFINE CLASS'
	#DEFINE C_ENDDEFINE_CLASS	'ENDDEFINE'
	icObj = NULL


	*******************************************************************************************************************************************
	FUNCTION SETUP
		PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		*LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		SET PROCEDURE TO 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		oFXU_LIB = CREATEOBJECT('CL_FXU_CONFIG')
		oFXU_LIB.setup_comun()

		*THIS.icObj 	= NEWOBJECT("c_conversor_base", "FOXBIN2PRG.PRG")
		*loObj			= THIS.icObj
		*loObj.l_Test	= .F.

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION TearDown
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		THIS.icObj = NULL

		IF VARTYPE(oFXU_LIB) = "O"
			oFXU_LIB.teardown_comun()
			oFXU_LIB = NULL
		ENDIF
		RELEASE PROCEDURE 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Evaluate_results
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado, tc_OutputFile, tcParent, tcClass, tcObjName, toReg_Esperado ;
			, toReg, tcTipoBinario, tnRecno

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF


		IF ISNULL(toEx)
			DO CASE
			CASE INLIST(tcTipoBinario, 'FRX', 'LBX')
				*--------------------------------------------
				*-- REPORTES
				*--------------------------------------------
				LOCAL I, laProps(1)

				*-- Visualización de valores
				THIS.messageout( LOWER(PROGRAM(PROGRAM(-1)-1)) )

				THIS.messageout( 'Recno#' + TRANSFORM(tnRecno) + ' UniqueID="' + toReg_Esperado.UniqueID + '" ObjType=' + TRANSFORM(toReg_Esperado.ObjType) ;
					+ ' ObjCode=' + TRANSFORM(toReg_Esperado.ObjCode) + ' Expr=[' + LEFT(toReg_Esperado.Expr,20) ;
					+ IIF(LEN(toReg_Esperado.Expr)>20,'...]',']') ;
					+ ' vpos=' + TRANSFORM(toReg_Esperado.VPOS) + ' hpos=' + TRANSFORM(toReg_Esperado.HPOS) ;
					+ ' height=' + TRANSFORM(toReg_Esperado.HEIGHT) + ' width=' + TRANSFORM(toReg_Esperado.WIDTH) )

				*-- Evaluación de valores
				FOR I = 1 TO AMEMBERS( laProps, toReg_Esperado, 0 )
					*-- Formateo
					ADDPROPERTY( toReg_Esperado, laProps(I) ;
						, '[' + oFXU_LIB.mejorarPresentacionCaracteresEspeciales( TRANSFORM( EVALUATE('toReg_Esperado.'+laProps(I)) ) ) + ']' )

					ADDPROPERTY( toReg, laProps(I) ;
						, '[' + oFXU_LIB.mejorarPresentacionCaracteresEspeciales( TRANSFORM( EVALUATE('toReg.'+laProps(I)) ) ) + ']' )

					*-- COMPARO
					THIS.assertequals( LEN(EVALUATE('toReg_Esperado.'+laProps(I))) ;
						, LEN(EVALUATE('toReg.'+laProps(I))) ;
						, 'Longitud de ' + laProps(I) + ' para el reg#' + TRANSFORM(tnRecno) ;
						+ ' UniqueID="' + toReg.UniqueID + '" ObjType=' + TRANSFORM(toReg.ObjType) )

					THIS.assertequals( (EVALUATE('toReg_Esperado.'+laProps(I))) ;
						, (EVALUATE('toReg.'+laProps(I))) ;
						, 'Valor de ' + laProps(I) + ' para el reg#' + TRANSFORM(tnRecno) ;
						+ ' UniqueID="' + toReg.UniqueID + '" ObjType=' + TRANSFORM(toReg.ObjType) )
				ENDFOR


			CASE INLIST(tcTipoBinario, 'VCX', 'SCX')
				*--------------------------------------------
				*-- FORMS / CLASES
				*--------------------------------------------
				LOCAL laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
					, lnPropsAndComments_Count, lnPropsAndComments_Count_Esperado, laPropsAndComments(1,2), laPropsAndComments_Esperado(1,2) ;
					, laProtected(1), lnProtected_Count, laProtected_Esperado(1), lnProtected_Count_Esperado ;
					, laMethods(1,2), lnMethods_Count, laMethods_Esperado(1,2), lnMethods_Count_Esperado, lcExtraData
				LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"

				*-- Algunos ajustes para mejor visualización de caracteres especiales
				*tcPropValue				= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcPropValue )
				loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")

				*-- Reserved3
				loObj.get_PropsAndCommentsFrom_RESERVED3( toReg.RESERVED3, .F., @laPropsAndComments, @lnPropsAndComments_Count, '' )
				loObj.get_PropsAndCommentsFrom_RESERVED3( toReg_Esperado.RESERVED3, .F., @laPropsAndComments_Esperado, @lnPropsAndComments_Count_Esperado, '' )

				*-- Properties
				loObj.get_PropsAndValuesFrom_PROPERTIES( toReg.PROPERTIES, 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )
				loObj.get_PropsAndValuesFrom_PROPERTIES( toReg_Esperado.PROPERTIES, 0, @laPropsAndValues_Esperado, @lnPropsAndValues_Count_Esperado, '' )

				*-- Protected
				loObj.get_PropsFrom_PROTECTED( toReg.PROTECTED, .F., @laProtected, @lnProtected_Count, '' )
				loObj.get_PropsFrom_PROTECTED( toReg_Esperado.PROTECTED, .F., @laProtected_Esperado, @lnProtected_Count_Esperado, '' )

				*-- Methods
				loObj.get_ADD_OBJECT_METHODS( toReg, toReg, '', @laMethods, '', @lnMethods_Count )
				loObj.get_ADD_OBJECT_METHODS( toReg_Esperado, toReg_Esperado, '', @laMethods_Esperado, '', @lnMethods_Count_Esperado )

				lcExtraData	= tcParent + '.' + tcObjName + ' (' + tcClass + ')'


				*-- Visualización de valores
				THIS.messageout( LOWER(PROGRAM(PROGRAM(-1)-1)) )

				THIS.messageout( 'PROPERTIES esperadas para ' + lcExtraData + ': ' ;
					+ TRANSFORM(lnPropsAndValues_Count_Esperado) + ' (Tamaño = ' + TRANSFORM(LEN(toReg_Esperado.PROPERTIES)) + ' bytes)' )
				*THIS.messageout( REPLICATE('-',80) )
				*FOR I = 1 TO lnPropsAndValues_Count_Esperado
				*	THIS.messageout( 'PropName = ' + TRANSFORM(laPropsAndValues_Esperado(I,1)) )
				*ENDFOR

				THIS.messageout( 'PROTECTED esperadas para ' + lcExtraData + ': ' ;
					+ TRANSFORM(lnProtected_Count_Esperado) + ' (Tamaño = ' + TRANSFORM(LEN(toReg_Esperado.PROTECTED)) + ' bytes)' )
				*THIS.messageout( REPLICATE('-',80) )
				*FOR I = 1 TO lnProtected_Count_Esperado
				*	THIS.messageout( 'PropName = ' + TRANSFORM(laProtected_Esperado(I,1)) )
				*ENDFOR

				THIS.messageout( 'RESERVED3 esperadas para ' + lcExtraData + ': ' ;
					+ TRANSFORM(lnPropsAndComments_Count_Esperado) + ' (Tamaño = ' + TRANSFORM(LEN(toReg_Esperado.RESERVED3)) + ' bytes)' )
				*THIS.messageout( REPLICATE('-',80) )
				*FOR I = 1 TO lnPropsAndComments_Count_Esperado
				*	THIS.messageout( 'PropName = ' + TRANSFORM(laPropsAndComments_Esperado(I,1)) )
				*ENDFOR

				THIS.messageout( 'METHODS esperadas para ' + lcExtraData + ': ' ;
					+ TRANSFORM(lnMethods_Count_Esperado) + ' (Tamaño = ' + TRANSFORM(LEN(toReg_Esperado.METHODS)) + ' bytes)' )
				*THIS.messageout( REPLICATE('-',80) )
				*FOR I = 1 TO lnMethods_Count_Esperado
				*	THIS.messageout( 'Name = ' + TRANSFORM(laMethods_Esperado(I,1)) )
				*ENDFOR

				THIS.messageout( 'OLE2 esperado para ' + lcExtraData + ': ' + TRANSFORM(toReg_Esperado.OLE2) )

				THIS.messageout( 'Checksum OLE esperado para ' + lcExtraData + ': ' + TRANSFORM(SYS(2007, toReg_Esperado.OLE)) )


				*-- Evaluación de valores
				THIS.assertequals( toReg_Esperado.Reserved1, toReg.Reserved1, "Valor de RESERVED1 para " + lcExtraData )
				THIS.assertequals( LEN(toReg_Esperado.Reserved1), LEN(toReg.Reserved1), "Tamaño de RESERVED1 para " + lcExtraData )

				THIS.assertequals( toReg_Esperado.Reserved2, toReg.Reserved2, "Valor de RESERVED2 para " + lcExtraData )
				THIS.assertequals( LEN(toReg_Esperado.Reserved2), LEN(toReg.Reserved2), "Tamaño de RESERVED2 para " + lcExtraData )

				THIS.assertequals( toReg_Esperado.Reserved4, toReg.Reserved4, "Valor de RESERVED4 para " + lcExtraData )
				THIS.assertequals( LEN(toReg_Esperado.Reserved4), LEN(toReg.Reserved4), "Tamaño de RESERVED4 para " + lcExtraData )

				THIS.assertequals( toReg_Esperado.Reserved5, toReg.Reserved5, "Valor de RESERVED5 para " + lcExtraData )
				THIS.assertequals( LEN(toReg_Esperado.Reserved5), LEN(toReg.Reserved5), "Tamaño de RESERVED5 para " + lcExtraData )

				THIS.assertequals( toReg_Esperado.Reserved6, toReg.Reserved6, "Valor de RESERVED6 para " + lcExtraData )
				THIS.assertequals( LEN(toReg_Esperado.Reserved6), LEN(toReg.Reserved6), "Tamaño de RESERVED6 para " + lcExtraData )

				THIS.assertequals( toReg_Esperado.Reserved7, toReg.Reserved7, "Valor de RESERVED7 para " + lcExtraData )
				THIS.assertequals( LEN(toReg_Esperado.Reserved7), LEN(toReg.Reserved7), "Tamaño de RESERVED7 para " + lcExtraData )

				THIS.assertequals( toReg_Esperado.Reserved8, toReg.Reserved8, "Valor de RESERVED8 para " + lcExtraData )
				THIS.assertequals( LEN(toReg_Esperado.Reserved8), LEN(toReg.Reserved8), "Tamaño de RESERVED8 para " + lcExtraData )

				THIS.assertequals( toReg_Esperado.OLE2, toReg.OLE2, "Valor de OLE2 para " + lcExtraData )
				THIS.assertequals( LEN(toReg_Esperado.OLE2), LEN(toReg.OLE2), "Tamaño de OLE2 para " + lcExtraData )

				THIS.assertequals( SYS(2007, toReg_Esperado.OLE), SYS(2007, toReg.OLE), "Valor de OLE (Checksum) para " + lcExtraData )
				THIS.assertequals( LEN(toReg_Esperado.OLE), LEN(toReg.OLE), "Tamaño de OLE para " + lcExtraData )

				*-- PROPERTIES
				THIS.assertequals( LEN(toReg_Esperado.PROPERTIES), LEN(toReg.PROPERTIES), "Tamaño de PROPERTIES para " + lcExtraData )
				THIS.assertequals( lnPropsAndValues_Count_Esperado, lnPropsAndValues_Count, "Cantidad de PROPERTIES para " + lcExtraData )
				FOR I = 1 TO lnPropsAndValues_Count_Esperado
					THIS.asserttrue( ASCAN( laPropsAndValues, laPropsAndValues_Esperado(I,1), 1, -1, 1, 0+2+4) > 0 ;
						, ' Comprobación de que existe la Property "' + TRANSFORM(laPropsAndValues_Esperado(I,1)) + '"' + " para " + lcExtraData )
				ENDFOR

				*-- RESERVED3
				THIS.assertequals( LEN(toReg_Esperado.RESERVED3), LEN(toReg.RESERVED3), "Tamaño de RESERVED3 para " + lcExtraData )
				THIS.assertequals( lnPropsAndComments_Count_Esperado, lnPropsAndComments_Count, "Cantidad de RESERVED3 para " + lcExtraData )
				FOR I = 1 TO lnPropsAndComments_Count_Esperado
					THIS.asserttrue( ASCAN( laPropsAndComments, laPropsAndComments_Esperado(I,1), 1, -1, 1, 0+2+4) > 0 ;
						, ' Comprobación de que existe la Reserved3 "' + TRANSFORM(laPropsAndComments_Esperado(I,1)) + '"' + " para " + lcExtraData )
				ENDFOR

				*-- PROTECTED
				THIS.assertequals( LEN(toReg_Esperado.PROTECTED), LEN(toReg.PROTECTED), "Tamaño de PROTECTED para " + lcExtraData )
				THIS.assertequals( lnProtected_Count_Esperado, lnProtected_Count, "Cantidad de PROTECTED para " + lcExtraData )
				FOR I = 1 TO lnProtected_Count_Esperado
					THIS.asserttrue( ASCAN( laProtected, laProtected_Esperado(I,1), 1, -1, 1, 0+2+4) > 0 ;
						, ' Comprobación de que existe la Protected "' + TRANSFORM(laProtected_Esperado(I,1)) + '"' + " para " + lcExtraData )
				ENDFOR

				*-- METHODS
				lcMensaje	= "Tamaño de METHODS para " + lcExtraData
				* COMPROBAR "BUG DEL MÉTODO MOVIDO"
				IF LEN( STRTRAN( toReg_Esperado.METHODS, CHR(13)+CHR(10), CHR(13) ) ) <> LEN( STRTRAN( toReg.METHODS, CHR(13)+CHR(10), CHR(13) ) )
					IF "BUG DEL MÉTODO MOVIDO" $ toReg.METHODS AND NOT "BUG DEL MÉTODO MOVIDO" $ toReg_Esperado.METHODS
						lcMensaje	= lcMensaje +  '   >>> ATENCIÓN!! - COMPROBAR "BUG DEL MÉTODO MOVIDO"'
					ENDIF
				ENDIF
				*-- Fin comprobación

				THIS.assertequals( LEN( STRTRAN( toReg_Esperado.METHODS, CHR(13)+CHR(10), CHR(13) ) ) ;
					, LEN( STRTRAN( toReg.METHODS, CHR(13)+CHR(10), CHR(13) ) ), lcMensaje )

				THIS.assertequals( lnMethods_Count_Esperado, lnMethods_Count, "Cantidad de METHODS para " + lcExtraData )
				FOR I = 1 TO lnMethods_Count_Esperado
					THIS.asserttrue( ASCAN( laMethods, laMethods_Esperado(I,1), 1, -1, 1, 0+2+4) > 0 ;
						, ' Comprobación de que existe el Method "' + TRANSFORM(laMethods_Esperado(I,1)) + '"' + " para " + lcExtraData )
				ENDFOR

			ENDCASE

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			IF NOT INLIST( toEx.ERRORNO, 1098, 2071 )	&& Error del usuario (ERROR y THROW)
				THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )
			ENDIF

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF

		THIS.messageout( '' )
		THIS.messageout( REPLICATE('*',80) )
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElReporte_FB2P_FRX_YValidarLosCamposDelRegistro
		*-- REPORTES (FRX)
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario, lnRecno ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loCnv.l_Debug		= .F.
			loCnv.l_ShowErrors	= .F.
			*loCnv.l_Test		= .T.
			*loCnv.l_ReportSort_Enabled	= .F.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lc_File				= 'FB2P_FOXUSER.FRX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIBOBIN_IN

			SCAN ALL FOR NOT DELETED()
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				lnRecno		= RECNO()
				SCATTER MEMO NAME loReg_Esperado
				lcUniqueID	= loReg_Esperado.UNIQUEID

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				LOCATE FOR UNIQUEID==lcUniqueID

				IF NOT FOUND()
					ERROR 'No se encontró el registro #' + TRANSFORM(RECNO('ARCHIBOBIN_IN')) + ' con UniqueID "' + lcUniqueID + '" en el archivo "' + lc_OutputFile + '"'
				ENDIF

				SCATTER MEMO NAME loReg
				USE IN (SELECT("TABLABIN"))

				THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
					, loReg_Esperado, loReg, lcTipoBinario, lnRecno )
			ENDSCAN

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIBOBIN_IN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElReporte_FB2P_LBX_YValidarLosCamposDelRegistro
		*-- ETIQUETAS (LBX)
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario, lnRecno ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loCnv.l_Debug		= .F.
			loCnv.l_ShowErrors	= .F.
			*loCnv.l_Test		= .T.
			*loCnv.l_ReportSort_Enabled	= .F.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lc_File				= 'FB2P_FOXUSER.LBX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIBOBIN_IN

			SCAN ALL FOR NOT DELETED()
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				lnRecno		= RECNO()
				SCATTER MEMO NAME loReg_Esperado
				lcUniqueID	= loReg_Esperado.UNIQUEID

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				LOCATE FOR UNIQUEID==lcUniqueID

				IF NOT FOUND()
					ERROR 'No se encontró el registro #' + TRANSFORM(RECNO('ARCHIBOBIN_IN')) + ' con UniqueID "' + lcUniqueID + '" en el archivo "' + lc_OutputFile + '"'
				ENDIF

				SCATTER MEMO NAME loReg
				USE IN (SELECT("TABLABIN"))

				THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
					, loReg_Esperado, loReg, lcTipoBinario, lnRecno )
			ENDSCAN

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIBOBIN_IN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCamposDelRegistro
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loCnv.l_Debug		= .F.
			loCnv.l_ShowErrors	= .F.
			*loCnv.l_Test		= .T.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lc_File				= 'FB2P_FRM_1.SCX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIBOBIN_IN

			SCAN ALL FOR NOT DELETED() AND ( UNIQUEID==PADR('Form',10) OR PLATFORM==PADR("WINDOWS",8) )
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				SCATTER MEMO NAME loReg_Esperado
				lcClass				= loReg_Esperado.CLASS
				lcParent			= loReg_Esperado.PARENT
				lcObjName			= loReg_Esperado.objName

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				IF EMPTY(lcParent) AND EMPTY(lcClass) AND EMPTY(lcObjName)
					LOCATE FOR PLATFORM==PADR("COMMENT",8) AND UNIQUEID==PADR("Screen",10)
					IF NOT FOUND()
						ERROR 'No se encontró el registro de cabecera "' + UNIQUEID + '"'
					ENDIF
				ELSE
					LOCATE FOR CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName
					IF NOT FOUND()
						ERROR 'No se encontró el registro para CLASS=="' + lcClass + '" AND PARENT=="' + lcParent + '" AND objName=="' + lcObjName + '"'
					ENDIF
				ENDIF

				SCATTER MEMO NAME loReg
				USE IN (SELECT("TABLABIN"))

				THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
					, loReg_Esperado, loReg, lcTipoBinario )
			ENDSCAN

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIBOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCamposDelRegistro
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loCnv.l_Debug				= .F.
			loCnv.l_ShowErrors			= .F.
			*loCnv.l_Test				= .T.
			*loCnv.l_PropSort_Enabled	= .F.	&& Para buscar diferencias
			*loCnv.l_MethodSort_Enabled	= .F.	&& Para buscar diferencias


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lc_File				= 'FB2P_TEST.VCX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIBOBIN_IN

			SCAN ALL FOR NOT DELETED() AND ( UNIQUEID==PADR('Class',10) OR PLATFORM==PADR("WINDOWS",8) )
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				SCATTER MEMO NAME loReg_Esperado
				lcClass				= loReg_Esperado.CLASS
				lcParent			= loReg_Esperado.PARENT
				lcObjName			= loReg_Esperado.objName

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				IF EMPTY(lcParent) AND EMPTY(lcClass) AND EMPTY(lcObjName)
					LOCATE FOR PLATFORM==PADR("COMMENT",8) AND UNIQUEID==PADR("Class",10)
					IF NOT FOUND()
						ERROR 'No se encontró el registro de cabecera "' + UNIQUEID + '"'
					ENDIF
				ELSE
					LOCATE FOR CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName
					IF NOT FOUND()
						ERROR 'No se encontró el registro para CLASS=="' + lcClass + '" AND PARENT=="' + lcParent + '" AND objName=="' + lcObjName + '"'
					ENDIF
				ENDIF

				SCATTER MEMO NAME loReg
				USE IN (SELECT("TABLABIN"))

				THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
					, loReg_Esperado, loReg, lcTipoBinario )
			ENDSCAN

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIBOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarEl_BUG_DelMetodoMovidoEntreClases
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loCnv.l_Debug				= .F.
			loCnv.l_ShowErrors			= .F.
			*loCnv.l_Test				= .T.
			*loCnv.l_PropSort_Enabled	= .F.	&& Para buscar diferencias
			*loCnv.l_MethodSort_Enabled	= .F.	&& Para buscar diferencias


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lc_File				= 'FB2P_TEST_BUG_METODO_MOVIDO.VCX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIBOBIN_IN

			SCAN ALL FOR NOT DELETED() AND ( UNIQUEID==PADR('Class',10) OR PLATFORM==PADR("WINDOWS",8) )
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				SCATTER MEMO NAME loReg_Esperado
				lcClass				= loReg_Esperado.CLASS
				lcParent			= loReg_Esperado.PARENT
				lcObjName			= loReg_Esperado.objName

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				IF EMPTY(lcParent) AND EMPTY(lcClass) AND EMPTY(lcObjName)
					LOCATE FOR PLATFORM==PADR("COMMENT",8) AND UNIQUEID==PADR("Class",10)
					IF NOT FOUND()
						ERROR 'No se encontró el registro de cabecera "' + UNIQUEID + '"'
					ENDIF
				ELSE
					LOCATE FOR CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName
					IF NOT FOUND()
						ERROR 'No se encontró el registro para CLASS=="' + lcClass + '" AND PARENT=="' + lcParent + '" AND objName=="' + lcObjName + '"'
					ENDIF
				ENDIF

				SCATTER MEMO NAME loReg
				USE IN (SELECT("TABLABIN"))

				THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
					, loReg_Esperado, loReg, lcTipoBinario )
			ENDSCAN

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIBOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarEl_BUG_Del_PROCEDURE_SIN_ENDPROC
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loCnv.l_Debug				= .F.
			loCnv.l_ShowErrors			= .F.
			*loCnv.l_Test				= .T.
			*loCnv.l_PropSort_Enabled	= .F.	&& Para buscar diferencias
			*loCnv.l_MethodSort_Enabled	= .F.	&& Para buscar diferencias


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lc_File				= 'FB2P_TEST_BUG_ESTRUCTURAL.VCX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIBOBIN_IN

			SCAN ALL FOR NOT DELETED() AND ( UNIQUEID==PADR('Class',10) OR PLATFORM==PADR("WINDOWS",8) )
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				SCATTER MEMO NAME loReg_Esperado
				lcClass				= loReg_Esperado.CLASS
				lcParent			= loReg_Esperado.PARENT
				lcObjName			= loReg_Esperado.objName

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				IF EMPTY(lcParent) AND EMPTY(lcClass) AND EMPTY(lcObjName)
					LOCATE FOR PLATFORM==PADR("COMMENT",8) AND UNIQUEID==PADR("Class",10)
					IF NOT FOUND()
						ERROR 'No se encontró el registro de cabecera "' + UNIQUEID + '"'
					ENDIF
				ELSE
					LOCATE FOR CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName
					IF NOT FOUND()
						ERROR 'No se encontró el registro para CLASS=="' + lcClass + '" AND PARENT=="' + lcParent + '" AND objName=="' + lcObjName + '"'
					ENDIF
				ENDIF

				SCATTER MEMO NAME loReg
				USE IN (SELECT("TABLABIN"))

				THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
					, loReg_Esperado, loReg, lcTipoBinario )
			ENDSCAN

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
				, loReg_Esperado, loReg, lcTipoBinario )

		FINALLY
			USE IN (SELECT("ARCHIBOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


ENDDEFINE

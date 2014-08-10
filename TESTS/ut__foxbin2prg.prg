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
	nMouseX	= 0
	nMouseY	= 0
	run_AfterCreate_DB2__Ejecutado	= .F.
	run_AfterCreateTable__Ejecutado	= .F.


	*******************************************************************************************************************************************
	FUNCTION SETUP
		PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		*LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		*DOEVENTS FORCE
		THIS.nMouseX	= MCOL('',3)
		THIS.nMouseY	= MROW('',3)
		MOUSE AT (_SCREEN.Height), (_SCREEN.Width) PIXELS
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
		RELEASE oFXU_LIB
		CLOSE PROCEDURES
		CLEAR RESOURCES
		SYS(1104)
		MOUSE AT (THIS.nMouseY), (THIS.nMouseX) PIXELS

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
					+ ' ObjCode=' + TRANSFORM(toReg_Esperado.ObjCode) + ' Expr=[' + LEFT(toReg_Esperado.EXPR,20) ;
					+ IIF(LEN(toReg_Esperado.EXPR)>20,'...]',']') ;
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
				LOCAL loFoxBin2Prg AS c_foxbin2prg OF "FOXBIN2PRG.PRG"

				*-- Algunos ajustes para mejor visualización de caracteres especiales
				*tcPropValue				= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcPropValue )
				loFoxBin2Prg	= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
				loObj			= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")

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
				STORE 0 TO lnMethods_Count, lnMethods_Count_Esperado
				loObj.get_ADD_OBJECT_METHODS( toReg, toReg, '', @laMethods, '', @lnMethods_Count, '', 0, '', 0, loFoxBin2Prg )
				loObj.get_ADD_OBJECT_METHODS( toReg_Esperado, toReg_Esperado, '', @laMethods_Esperado, '', @lnMethods_Count_Esperado, '', 0, '', 0, loFoxBin2Prg )
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
					THIS.asserttrue( ASCAN( laMethods, laMethods_Esperado(I,1), 1, -1, 1, 1+2+4) > 0 ;
						, ' Comprobación de que existe el Method "' + TRANSFORM(laMethods_Esperado(I,1)) + '"' + " para " + lcExtraData )
				ENDFOR
				
				loFoxBin2Prg = NULL
				RELEASE loFoxBin2Prg

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
			loCnv.l_NoTimestamps			= .F.
			loCnv.l_ClearUniqueID			= .F.

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIVOBIN_IN

			SCAN ALL FOR NOT DELETED()
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				lnRecno		= RECNO()
				SCATTER MEMO NAME loReg_Esperado
				lcUniqueID	= loReg_Esperado.UniqueID

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				LOCATE FOR UniqueID==lcUniqueID

				IF NOT FOUND()
					ERROR 'No se encontró el registro #' + TRANSFORM(RECNO('ARCHIVOBIN_IN')) + ' con UniqueID "' + lcUniqueID + '" en el archivo "' + lc_OutputFile + '"'
				ENDIF

				SCATTER MEMO NAME loReg
				USE IN (SELECT("TABLABIN"))

				THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
					, loReg_Esperado, loReg, lcTipoBinario, lnRecno )
			ENDSCAN

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			STORE NULL TO loModulo, loCnv
			RELEASE loModulo, loCnv
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElReporte_FB2P_LBX_YValidarLosCamposDelRegistro
		*-- ETIQUETAS (LBX)
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lc_OutputFile2, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario, lnRecno ;
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
			*loCnv.l_ShowErrors	= .F.
			*loCnv.l_Test		= .T.
			*loCnv.l_ReportSort_Enabled	= .F.
			*loCnv.l_NoTimestamps	= .F.
			*loCnv.l_ClearUniqueID	= .F.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lc_File				= 'FB2P_FOXUSER.LBX'
			lc_InputFile		= FULLPATH( FORCEPATH( lc_File, oFXU_LIB.cPathDatosReadOnly ) )
			lc_OutputFile		= FULLPATH( FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest ) )
			lc_OutputFile2		= FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )
			loCnv.EvaluarConfiguracion( '1', '1', '0', '0', SYS(5)+CURDIR(), '1', '0', '0' )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, 'LBX' ) )
			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, 'LBT' ) )

			loCnv.Ejecutar( lc_OutputFile, '', '', '', '1', '0', '1', '', '', .T. )
			loCnv.Ejecutar( lc_OutputFile2, '', '', '', '1', '0', '1', '', '', .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIVOBIN_IN

			SCAN ALL FOR NOT DELETED()
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				lnRecno		= RECNO()
				SCATTER MEMO NAME loReg_Esperado
				lcUniqueID	= loReg_Esperado.UniqueID

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				LOCATE FOR UniqueID==lcUniqueID

				IF NOT FOUND()
					ERROR 'No se encontró el registro #' + TRANSFORM(RECNO('ARCHIVOBIN_IN')) + ' con UniqueID "' + lcUniqueID + '" en el archivo "' + lc_OutputFile + '"'
				ENDIF

				SCATTER MEMO NAME loReg
				USE IN (SELECT("TABLABIN"))

				THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
					, loReg_Esperado, loReg, lcTipoBinario, lnRecno )
			ENDSCAN

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			STORE NULL TO loModulo, loCnv
			RELEASE loModulo, loCnv
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_FRM_1_SCX_YValidarLosCamposDelRegistro
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lc_OutputFile2, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
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
			lc_InputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosReadOnly )
			lc_OutputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest )
			lc_OutputFile2		= FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )
			loCnv.l_NoTimestamps			= .F.
			loCnv.l_ClearUniqueID			= .F.

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Ejecutar( lc_OutputFile, '', '', '', '', '', '', '', '', .T. )
			loCnv.Ejecutar( lc_OutputFile2, '', '', '', '', '', '', '', '', .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIVOBIN_IN

			SCAN ALL FOR NOT DELETED() AND ( UniqueID==PADR('Form',10) OR PLATFORM==PADR("WINDOWS",8) )
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				SCATTER MEMO NAME loReg_Esperado
				lcClass				= LOWER(loReg_Esperado.CLASS)
				lcParent			= LOWER(loReg_Esperado.PARENT)
				lcObjName			= LOWER(loReg_Esperado.objName)

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				IF EMPTY(lcParent) AND EMPTY(lcClass) AND EMPTY(lcObjName)
					LOCATE FOR PLATFORM==PADR("COMMENT",8) AND UniqueID==PADR("Screen",10)
					IF NOT FOUND()
						ERROR 'No se encontró el registro de cabecera "' + UniqueID + '"'
					ENDIF
				ELSE
					LOCATE FOR LOWER(CLASS)==lcClass AND LOWER(PARENT)==lcParent AND LOWER(objName)==lcObjName
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
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
			STORE NULL TO loModulo, loCnv
			RELEASE loModulo, loCnv
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_FRM_2_SCX_YValidarElOrdenDeLasPropsDelObjeto_PageFrame1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laProps(1), lcProp, I, laProps_Esperado(1) ;
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
			lc_File				= 'FB2P_FRM_2.SCX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_OutputFile) SHARED AGAIN NOUPDATE ALIAS TABLABIN

			LOCATE FOR objName = 'Pageframe1' AND NOT DELETED() AND PLATFORM==PADR("WINDOWS",8)

			THIS.assertequals( .T., FOUND(), 'No se ha encontrado el objeto "Pageframe1" que se iba a testear' )

			*-- DATOS ESPERADOS
			STORE 0 TO lnCodError_Esperado
			SCATTER FIELDS PROPERTIES MEMO NAME loReg
			DIMENSION laProps_Esperado(8)
			laProps_Esperado( 1)	= 'ErasePage'
			laProps_Esperado( 2)	= 'PageCount'
			laProps_Esperado( 3)	= 'ActivePage'
			laProps_Esperado( 4)	= 'Top'
			laProps_Esperado( 5)	= 'Left'
			laProps_Esperado( 6)	= 'Height'
			laProps_Esperado( 7)	= 'Width'
			laProps_Esperado( 8)	= 'Name'

			*-- TEST
			=ALINES(laProps, loReg.PROPERTIES)

			THIS.messageout( 'Línea : Valor esperado => Valor actual' )
			THIS.messageout( REPLICATE('-',50) )

			FOR I = 1 TO ALEN(laProps_Esperado)
				lcProp	= GETWORDNUM(laProps(I),1)
				THIS.messageout( 'Línea ' + TRANSFORM(I) + ': ' + laProps_Esperado(I) + ' => ' + lcProp )
			ENDFOR

			FOR I = 1 TO ALEN(laProps_Esperado)
				lcProp	= GETWORDNUM(laProps(I),1)
				THIS.assertequals( laProps_Esperado(I), lcProp, 'Elemento (' + TRANSFORM(I) + ') del Memo Properties' )
			ENDFOR

			*USE IN (SELECT("TABLABIN"))

			*THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
			, loReg_Esperado, loReg, lcTipoBinario )

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("TABLABIN"))
			STORE NULL TO loModulo, loCnv
			RELEASE loModulo, loCnv
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_FRM_2_SCX_YValidarElOrdenDeLasPropsDelObjeto_Optiongroup1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laProps(1), lcProp, I, laProps_Esperado(1) ;
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
			lc_File				= 'FB2P_FRM_2.SCX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_OutputFile) SHARED AGAIN NOUPDATE ALIAS TABLABIN

			LOCATE FOR objName = 'Optiongroup1' AND NOT DELETED() AND PLATFORM==PADR("WINDOWS",8)

			THIS.assertequals( .T., FOUND(), 'No se ha encontrado el objeto "Optiongroup1" que se iba a testear' )

			*-- DATOS ESPERADOS
			STORE 0 TO lnCodError_Esperado
			SCATTER FIELDS PROPERTIES MEMO NAME loReg
			DIMENSION laProps_Esperado(7)
			*laProps_Esperado( 1)	= 'ButtonCount'
			*laProps_Esperado( 2)	= 'Value'
			*laProps_Esperado( 3)	= 'Top'
			*laProps_Esperado( 4)	= 'Left'
			*laProps_Esperado( 5)	= 'Height'
			*laProps_Esperado( 6)	= 'Width'
			*laProps_Esperado( 7)	= 'Name'
			*-- 13/05/2014. v1.19.22 - Reordenamiento de todas propiedades
			laProps_Esperado( 1)	= 'ButtonCount'
			laProps_Esperado( 2)	= 'Value'
			laProps_Esperado( 3)	= 'Height'
			laProps_Esperado( 4)	= 'Left'
			laProps_Esperado( 5)	= 'Top'
			laProps_Esperado( 6)	= 'Width'
			laProps_Esperado( 7)	= 'Name'

			*-- TEST
			=ALINES(laProps, loReg.PROPERTIES)

			THIS.messageout( 'Línea : Valor esperado => Valor actual' )
			THIS.messageout( REPLICATE('-',50) )

			FOR I = 1 TO ALEN(laProps_Esperado)
				lcProp	= GETWORDNUM(laProps(I),1)
				THIS.messageout( 'Línea ' + TRANSFORM(I) + ': ' + laProps_Esperado(I) + ' => ' + lcProp )
			ENDFOR

			FOR I = 1 TO ALEN(laProps_Esperado)
				lcProp	= GETWORDNUM(laProps(I),1)
				THIS.assertequals( laProps_Esperado(I), lcProp, 'Elemento (' + TRANSFORM(I) + ') del Memo Properties' )
			ENDFOR

			*USE IN (SELECT("TABLABIN"))

			*THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName ;
			, loReg_Esperado, loReg, lcTipoBinario )

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("TABLABIN"))
			STORE NULL TO loModulo, loCnv
			RELEASE loModulo, loCnv
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
			loCnv.l_NoTimestamps			= .F.
			loCnv.l_ClearUniqueID			= .F.

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIVOBIN_IN

			SCAN ALL FOR NOT DELETED() AND ( UniqueID==PADR('Class',10) OR PLATFORM==PADR("WINDOWS",8) )
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				SCATTER MEMO NAME loReg_Esperado
				lcClass				= LOWER(loReg_Esperado.CLASS)
				lcParent			= LOWER(loReg_Esperado.PARENT)
				lcObjName			= LOWER(loReg_Esperado.objName)

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				IF EMPTY(lcParent) AND EMPTY(lcClass) AND EMPTY(lcObjName)
					LOCATE FOR PLATFORM==PADR("COMMENT",8) AND UniqueID==PADR("Class",10)
					IF NOT FOUND()
						ERROR 'No se encontró el registro de cabecera "' + UniqueID + '"'
					ENDIF
				ELSE
					LOCATE FOR LOWER(CLASS)==lcClass AND LOWER(PARENT)==lcParent AND LOWER(objName)==lcObjName
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
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
			STORE NULL TO loModulo, loCnv
			RELEASE loModulo, loCnv
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
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIVOBIN_IN

			SCAN ALL FOR NOT DELETED() AND ( UniqueID==PADR('Class',10) OR PLATFORM==PADR("WINDOWS",8) )
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				SCATTER MEMO NAME loReg_Esperado
				lcClass				= LOWER(loReg_Esperado.CLASS)
				lcParent			= LOWER(loReg_Esperado.PARENT)
				lcObjName			= LOWER(loReg_Esperado.objName)

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				IF EMPTY(lcParent) AND EMPTY(lcClass) AND EMPTY(lcObjName)
					LOCATE FOR PLATFORM==PADR("COMMENT",8) AND UniqueID==PADR("Class",10)
					IF NOT FOUND()
						ERROR 'No se encontró el registro de cabecera "' + UniqueID + '"'
					ENDIF
				ELSE
					LOCATE FOR LOWER(CLASS)==lcClass AND LOWER(PARENT)==lcParent AND LOWER(objName)==lcObjName
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
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
			STORE NULL TO loModulo, loCnv
			RELEASE loModulo, loCnv
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_CLASSLIB_METHOD_ORDER_BUG_TEST_VCX_YValidarEl_BUG_DelOrdenDeMetodosDeClases_v1_19_29
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario, lcTXT0, lcTXT1 ;
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
			lc_File				= 'CLASSLIB_METHOD_ORDER_BUG_TEST.VCX'
			lc_InputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosReadOnly )
			lc_OutputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			*loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			*-- Comparo resultados
			lcTXT0		= FORCEPATH( FORCEEXT(lc_File,'VC2'), ADDBS( oFXU_LIB.cPathDatosReadOnly ) )
			lcTXT1		= FORCEPATH( FORCEEXT(lc_File,'VC2'), ADDBS( oFXU_LIB.cPathDatosTest ) )

			llEqual	= ( FILETOSTR( lcTXT0 ) == FILETOSTR( lcTXT1 ) )

			THIS.messageout( "Se comparan archivos VC2, para saber si hay cambios" )
			THIS.messageout( "lcTXT0 = " + lcTXT0 )
			THIS.messageout( "lcTXT1 = " + lcTXT1 )

			THIS.asserttrue( llEqual, "COMPARACIÓN DE VC2" )

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
			STORE NULL TO loModulo, loCnv
			RELEASE loModulo, loCnv
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
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIVOBIN_IN

			SCAN ALL FOR NOT DELETED() AND ( UniqueID==PADR('Class',10) OR PLATFORM==PADR("WINDOWS",8) )
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				SCATTER MEMO NAME loReg_Esperado
				lcClass				= LOWER(loReg_Esperado.CLASS)
				lcParent			= LOWER(loReg_Esperado.PARENT)
				lcObjName			= LOWER(loReg_Esperado.objName)

				*-- TEST
				IF FILE(lc_OutputFile)
					SELECT 0
					USE (lc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
				ELSE
					ERROR 'No se encontró el archivo "' + lc_OutputFile + '"'
				ENDIF

				IF EMPTY(lcParent) AND EMPTY(lcClass) AND EMPTY(lcObjName)
					LOCATE FOR PLATFORM==PADR("COMMENT",8) AND UniqueID==PADR("Class",10)
					IF NOT FOUND()
						ERROR 'No se encontró el registro de cabecera "' + UniqueID + '"'
					ENDIF
				ELSE
					LOCATE FOR LOWER(CLASS)==lcClass AND LOWER(PARENT)==lcParent AND LOWER(objName)==lcObjName
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
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
			STORE NULL TO loModulo, loCnv
			RELEASE loModulo, loCnv
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Evaluate_Bitmap_Test
		LPARAMETERS tcTestName, tcControlName, tcFormName, tnComparacionEsperada
		*-- tnComparacionEsperada		0=False, [1]=True, 2=Don't report (special case)

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lcFile2, lc_OutputFile, lcTipoBinario, lcLib, lcBMP0, lcBMP1, llEqual ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loCtl AS f_optiongroup OF "TESTS\DATOS_READONLY\LIB_CONTROLES.VCX" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			THIS.messageout( this.ICCURRENTTEST )
			THIS.messageout( '' )

			IF VARTYPE(tnComparacionEsperada) = "L"
				tnComparacionEsperada = 1
			ENDIF

			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			loCnv.EvaluarConfiguracion( '', '', '', '1', '1', '4' )
			*loCnv.n_ExtraBackupLevels	= 4
			*loCnv.l_Debug				= .T.
			*loCnv.l_ShowErrors			= .F.
			*loCnv.l_Test				= .T.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			
			lcTipoBinario		= EVL( UPPER(JUSTEXT(EVL(tcFormName,''))), 'VCX' )

			*-- Copio la librería en DATOS_TEST
			lcLib				= FORCEPATH( "LIB_CONTROLES.VCX", oFXU_LIB.cPathDatosTest )
			lc_File2			= 'LIB_CONTROLES.VCX'
			lc_OutputFile		= FORCEPATH( lc_File2, oFXU_LIB.cPathDatosTest )

			IF lcTipoBinario = 'SCX'
				lc_File			= UPPER(tcFormName)
				lc_OutputFile	= FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest )
			ENDIF

			loCnv.l_NoTimestamps			= .F.
			loCnv.l_ClearUniqueID			= .F.

			IF lcTipoBinario = 'SCX'
				oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + 'X' ) )
				oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + 'T' ) )
			ENDIF

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File2, LEFT( JUSTEXT(lc_File2),2 ) + 'X' ) )
			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File2, LEFT( JUSTEXT(lc_File2),2 ) + 'T' ) )

			*-- Genero BMP con libreria ORIGINAL
			SET CLASSLIB TO (lcLib) ADDITIVE
			IF lcTipoBinario = 'SCX'
				DO FORM (lc_OutputFile) NAME loCtl LINKED NOSHOW
			ELSE
				loCtl = CREATEOBJECT( tcControlName )
			ENDIF
			loCtl.c_testname = FORCEPATH( THIS.ICCURRENTTEST + '_0.bmp', ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
			IF loCtl.BaseClass = 'Formset'
				loCtl.Forms(1).ALWAYSONTOP= .T.
				loCtl.SHOW()
				loCtl.REFRESH()
			ELSE
				loCtl.ALWAYSONTOP= .T.
				loCtl.SHOW()
			ENDIF
			loCtl.HIDE()
			loCtl.RELEASE()
			loCtl = NULL
			RELEASE CLASSLIB (lcLib)
			CLEAR CLASSLIB (lcLib)

			*-- Genero TX2
			loCnv.Ejecutar( lc_OutputFile, .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR(), '1', '0' )

			*-- Genero BIN
			loCnv.Ejecutar( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_OutputFile),2 ) + '2' ), .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR(), '1', '0' )

			*-- Genero TX2
			loCnv.Ejecutar( lc_OutputFile, .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR(), '1', '0' )

			*-- Genero BIN
			loCnv.Ejecutar( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_OutputFile),2 ) + '2' ), .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR(), '1', '0' )

			*-- Genero BMP con libreria regenerada
			SET CLASSLIB TO (lcLib) ADDITIVE
			IF lcTipoBinario = 'SCX'
				DO FORM (lc_OutputFile) NAME loCtl LINKED NOSHOW
			ELSE
				loCtl = CREATEOBJECT( tcControlName )
			ENDIF
			loCtl.c_testname = FORCEPATH( THIS.ICCURRENTTEST + '_1.bmp', ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
			IF loCtl.BaseClass = 'Formset'
				loCtl.Forms(1).ALWAYSONTOP= .T.
				loCtl.SHOW()
				loCtl.REFRESH()
			ELSE
				loCtl.ALWAYSONTOP= .T.
				loCtl.SHOW()
			ENDIF
			loCtl.HIDE()
			loCtl.RELEASE()
			loCtl = NULL
			RELEASE CLASSLIB (lcLib)
			CLEAR CLASSLIB (lcLib)

			*-- Comparo resultados
			lcBMP0		= FORCEPATH( THIS.ICCURRENTTEST + '_0.bmp', ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
			lcBMP1		= FORCEPATH( THIS.ICCURRENTTEST + '_1.bmp', ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )

			llEqual	= ( FILETOSTR( lcBMP0 ) == FILETOSTR( lcBMP1 ) )

			THIS.messageout( "Se comparan bitmaps de pantalla, para saber si hay cambios estéticos y detectar fallos al ensamblar el binario" )
			THIS.messageout( "lcBMP0 = " + lcBMP0 )
			THIS.messageout( "lcBMP1 = " + lcBMP1 )
			THIS.messageout( "Comparación esperada  = " + ICASE(tnComparacionEsperada = 0, "DISTINTOS", tnComparacionEsperada = 1, "IGUALES", "NO_COMPARAR") )
			THIS.messageout( "Comparación realizada = " + IIF(llEqual, "IGUALES", "DISTINTOS") )
			
			DO CASE
			CASE tnComparacionEsperada = 0
				THIS.asserttrue( NOT llEqual, "COMPARACIÓN DE BITMAPS" )

			CASE tnComparacionEsperada = 1
				THIS.asserttrue( llEqual, "COMPARACIÓN DE BITMAPS" )

			OTHERWISE
				*- No se quiere reporte de respuesta para evitar un fallo (caso especial)
			ENDCASE


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			STORE NULL TO loCtl, loCnv
			RELEASE loCtl, loCnv
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaClase__LIB_CONTROLES__F_OptionGroup__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'OptionGroup_Test', 'f_OptionGroup', '' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm__F_OptionGroup__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'OptionGroup_Test', 'f_OptionGroup', 'F_OPTIONGROUP.SCX', 2 )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaClase__LIB_CONTROLES__F_Checkbox__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'Checkbox_Test', 'f_Checkbox', '' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm__F_Checkbox__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'Checkbox_Test', 'f_Checkbox', 'F_CHECKBOX.SCX' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaClase__LIB_CONTROLES__F_Textbox__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'Textbox_Test', 'f_Textbox', '' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm__F_Textbox__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'Textbox_Test', 'f_Textbox', 'F_TEXTBOX.SCX' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaClase__LIB_CONTROLES__F_Combobox__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'Combobox_Test', 'f_Combobox', '' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm__F_Combobox__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'Combobox_Test', 'f_Combobox', 'F_Combobox.SCX' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaClase__LIB_CONTROLES__F_CommandGroup__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'CommandGroup_Test', 'f_CommandGroup', '' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm__F_CommandGroup__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'CommandGroup_Test', 'f_CommandGroup', 'F_CommandGroup.SCX' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaClase__LIB_CONTROLES__F_ListBox__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'ListBox_Test', 'f_ListBox', '' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm__F_ListBox__YValidarLaVisualizacionDePantalla

		THIS.evaluate_bitmap_test( 'ListBox_Test', 'f_ListBox', 'F_ListBox.SCX' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaClase__LIB_CONTROLES__F_Form_Controles__YValidarLaVisualizacionDePantalla

		IF NOT DIRECTORY( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
			MKDIR ( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
		ENDIF
		COPY FILE ( ADDBS(oFXU_LIB.cPathDatosReadOnly) + 'bmps\*.*' ) TO ( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps\*.*' )

		THIS.evaluate_bitmap_test( 'Form_Controles_Test', 'f_Form_Controles', '' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm__F_Form_Controles__YValidarLaVisualizacionDePantalla

		IF NOT DIRECTORY( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
			MKDIR ( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
		ENDIF
		COPY FILE ( ADDBS(oFXU_LIB.cPathDatosReadOnly) + 'bmps\*.*' ) TO ( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps\*.*' )

		THIS.evaluate_bitmap_test( 'Form_Controles_Test', 'f_Form_Controles', 'F_Form_Controles.SCX' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm__F_Formset__YValidarLaVisualizacionDePantalla
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		oFXU_LIB.copiarArchivosParaTest( 'encuestas.*' )
		THIS.evaluate_bitmap_test( 'Formset_Test', 'f_Formset', 'F_Formset.SCX' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm__F_Form_AA__YValidarLaVisualizacionDePantalla
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		IF NOT DIRECTORY( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
			MKDIR ( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
		ENDIF
		COPY FILE ( ADDBS(oFXU_LIB.cPathDatosReadOnly) + 'bmps\*.*' ) TO ( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps\*.*' )

		THIS.evaluate_bitmap_test( 'Form_Test_Eventos_y_Controles', 'f_Form_AA', 'F_Form_AA.SCX' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm__F_Form_AA2__YValidarLaVisualizacionDePantalla
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		IF NOT DIRECTORY( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
			MKDIR ( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps' )
		ENDIF
		COPY FILE ( ADDBS(oFXU_LIB.cPathDatosReadOnly) + 'bmps\*.*' ) TO ( ADDBS(oFXU_LIB.cPathDatosTest) + 'bmps\*.*' )

		THIS.evaluate_bitmap_test( 'Form_Test_Eventos_y_Controles2', 'f_Form_AA2', 'F_Form_AA2.SCX' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_GenerarUnArchivo_SC2_DesdeUnBinarioQueContieneNullsEnElCodigo_SinLosNulls
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_OutputFile, lc_OutputFileTx2, lc_OutputFileBak, lcExt2, lcFileName, lnNulls, lnNulls_Esperados ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loCtl AS f_optiongroup OF "TESTS\DATOS_READONLY\LIB_CONTROLES.VCX" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			loCnv.EvaluarConfiguracion( '', '', '1', '1', '1', '4', '1', '0' )
			*loCnv.l_DropNullCharsFromCode	= .T.
			*loCnv.l_Test				= .T.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado, lnNulls, lnNulls_Esperados
			lcFileName			= 'f_nullchars_incode.scx'
			lnNulls_Esperados	= 0
			
			*-- Copio la librería en DATOS_TEST
			lc_File				= UPPER(lcFileName)
			lcExt2				= loCnv.Get_Ext2FromExt( JUSTEXT( lc_File ) )
			lc_OutputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest )
			lc_OutputFileTx2	= FORCEEXT( FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest ), lcExt2 )
			lc_OutputFileBak	= lc_OutputFileTx2 + '.bak'

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )
			COPY FILE (lc_OutputFileTx2) TO (lc_OutputFileBak)

			*-- Genero TX2
			loCnv.Ejecutar( lc_OutputFile, .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR() )
			lnNulls		= OCCURS( CHR(0), FILETOSTR( lc_OutputFileTx2 ) )

			*-- Comparo resultados
			THIS.messageout( "Se comprueba si el archivo texto generado contiene NULLs" )
			THIS.messageout( "NULLs esperados:   " + TRANSFORM(lnNulls_Esperados) )
			THIS.messageout( "NULLs encontrados: " + TRANSFORM(lnNulls) )
			THIS.assertequals( lnNulls_Esperados, lnNulls, "COMPROBACIÓN THE NULLS" )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			STORE NULL TO loCnv, loCtl
			RELEASE loCnv, loCtl
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_GenerarUnArchivo_SC2_DesdeUnBinarioQueContieneNullsEnElCodigo_ConLosNulls
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_OutputFile, lc_OutputFileTx2, lc_OutputFileBak, lcExt2, lcFileName, lnNulls, lnNulls_Esperados ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loCtl AS f_optiongroup OF "TESTS\DATOS_READONLY\LIB_CONTROLES.VCX" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			loCnv.EvaluarConfiguracion( '', '', '1', '1', '1', '4', '1', '0' )
			loCnv.l_DropNullCharsFromCode	= .F.
			*loCnv.l_Test				= .T.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado, lnNulls, lnNulls_Esperados
			lcFileName			= 'f_nullchars_incode.scx'
			lnNulls_Esperados	= 2
			
			*-- Copio la librería en DATOS_TEST
			lc_File				= UPPER(lcFileName)
			lcExt2				= loCnv.Get_Ext2FromExt( JUSTEXT( lc_File ) )
			lc_OutputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest )
			lc_OutputFileTx2	= FORCEEXT( FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest ), lcExt2 )
			lc_OutputFileBak	= lc_OutputFileTx2 + '.bak'

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )
			COPY FILE (lc_OutputFileTx2) TO (lc_OutputFileBak)

			*-- Genero TX2
			loCnv.Ejecutar( lc_OutputFile, .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR() )
			lnNulls		= OCCURS( CHR(0), FILETOSTR( lc_OutputFileTx2 ) )

			*-- Comparo resultados
			THIS.messageout( "Se comprueba si el archivo texto generado contiene NULLs" )
			THIS.messageout( "NULLs esperados:   " + TRANSFORM(lnNulls_Esperados) )
			THIS.messageout( "NULLs encontrados: " + TRANSFORM(lnNulls) )
			THIS.assertequals( lnNulls_Esperados, lnNulls, "COMPROBACIÓN THE NULLS" )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			STORE NULL TO loCnv, loCtl
			RELEASE loCnv, loCtl
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Evaluate_TX2_Output_Test
		LPARAMETERS tcFileName

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_OutputFile, lc_OutputFileTx2, lc_OutputFileBak, lcExt2 ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loCtl AS f_optiongroup OF "TESTS\DATOS_READONLY\LIB_CONTROLES.VCX" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			loCnv.EvaluarConfiguracion( '', '', '1', '1', '1', '4', '1', '0' )
			*loCnv.l_Test				= .T.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			
			*-- Copio la librería en DATOS_TEST
			lc_File				= UPPER(tcFileName)
			lcExt2				= loCnv.Get_Ext2FromExt( JUSTEXT( tcFileName ) )
			lc_OutputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest )
			lc_OutputFileTx2	= FORCEEXT( FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest ), lcExt2 )
			lc_OutputFileBak	= lc_OutputFileTx2 + '.bak'

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )
			COPY FILE (lc_OutputFileTx2) TO (lc_OutputFileBak)

			*-- Genero TX2
			loCnv.Ejecutar( lc_OutputFile, .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR() )

			*-- Genero BIN
			loCnv.Ejecutar( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_OutputFile),2 ) + '2' ), .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR() )

			*-- Genero TX2
			loCnv.Ejecutar( lc_OutputFile, .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR() )

			*-- Comparo resultados
			THIS.messageout( "Se compara el archivo de texto generado con el original luego de 2 regeneraciones, para saber si hay cambios" )
			THIS.messageout( "OutputFileTx2 = " + lc_OutputFileTx2 )
			THIS.messageout( "OutputFileBak = " + lc_OutputFileBak )
			THIS.asserttrue( FILETOSTR( lc_OutputFileTx2 ) == FILETOSTR( lc_OutputFileBak ), "COMPARACIÓN DE ARCHIVOS TX2" )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
		*	USE IN (SELECT("ARCHIVOBIN_IN"))
		*	USE IN (SELECT("TABLABIN"))
			STORE NULL TO loCnv, loCtl
			RELEASE loCnv, loCtl
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_Para__test_public_protected_vcx__ValidarEl_VC2_GeneradoConElOriginal_Y_NoEncontrarDiferencias
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		THIS.Evaluate_TX2_Output_Test( 'test_public_protected.vcx' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_Para__test_report_frx__ValidarEl_FR2_GeneradoConElOriginal_Y_NoEncontrarDiferencias
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		THIS.Evaluate_TX2_Output_Test( 'test_report.frx' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_Para__Menu_LineBreak_mnx__ValidarEl_MN2_GeneradoConElOriginal_Y_NoEncontrarDiferencias
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		THIS.Evaluate_TX2_Output_Test( 'Menu_LineBreak.mnx' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_Para__Menu_Comments_Procedure_mnx__ValidarEl_MN2_GeneradoConElOriginal_Y_NoEncontrarDiferencias
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		THIS.Evaluate_TX2_Output_Test( 'Menu_Comments_Procedure.mnx' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_Para__Lib_Controles_vcx__ValidarEl_MN2_GeneradoConElOriginal_Y_NoEncontrarDiferencias
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		THIS.Evaluate_TX2_Output_Test( 'Lib_Controles.vcx' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_Para__f_form_aa_scx__ValidarEl_MN2_GeneradoConElOriginal_Y_NoEncontrarDiferencias
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		THIS.Evaluate_TX2_Output_Test( 'f_form_aa.scx' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_Para__f_form_aa2_scx__ValidarEl_MN2_GeneradoConElOriginal_Y_NoEncontrarDiferencias
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		THIS.Evaluate_TX2_Output_Test( 'f_form_aa2.scx' )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_CrearUnArchivo_DB2_DesdeUn_DBF_Y_EjecutarElMetodo__run_AfterCreate_DB2
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lcFileName, lc_OutputFile, lc_OutputFileTx2, lc_OutputFileBak, lcExt2 ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loCtl AS f_optiongroup OF "TESTS\DATOS_READONLY\LIB_CONTROLES.VCX" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			PUBLIC goFXU AS ut__foxbin2prg OF ut__foxbin2prg.prg
			goFXU		= THIS
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			loCnv.EvaluarConfiguracion( '', '1', '1', '1', '1', '4', '1', '0' )
			*loCnv.l_Test				= .T.
			loCnv.run_AfterCreate_DB2	= 'run_AfterCreate_DB2__Ejecutado'
			THIS.run_AfterCreate_DB2__Ejecutado	= .F.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			
			*-- Copio la librería en DATOS_TEST
			lcFileName			= FORCEPATH( 'FB2P_FREE.DBF', oFXU_LIB.cPathDatosReadOnly )
			lc_File				= UPPER(lcFileName)
			lcExt2				= loCnv.Get_Ext2FromExt( JUSTEXT( lcFileName ) )
			lc_OutputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest )
			lc_OutputFileTx2	= FORCEEXT( FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest ), lcExt2 )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, '*' ) )

			*-- Genero TX2
			loCnv.Ejecutar( lc_OutputFile, .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR() )

			*-- Comparo resultados
			THIS.messageout( "Respuesta esperada = .T." )
			THIS.asserttrue( THIS.run_AfterCreate_DB2__Ejecutado, "RESPUESTA DE run_AfterCreate_DB2__Ejecutado" )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
		*	USE IN (SELECT("ARCHIVOBIN_IN"))
		*	USE IN (SELECT("TABLABIN"))
			STORE NULL TO loCnv, loCtl, goFXU
			RELEASE loCnv, loCtl, goFXU
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_CrearUnArchivo_DBF_DesdeUn_DB2_Y_EjecutarElMetodo__run_AfterCreateTable
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lcFileName, lc_OutputFile, lc_OutputFileTx2, lc_OutputFileBak, lcExt2 ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loCtl AS f_optiongroup OF "TESTS\DATOS_READONLY\LIB_CONTROLES.VCX" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			PUBLIC goFXU AS ut__foxbin2prg OF ut__foxbin2prg.prg
			goFXU		= THIS
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			loCnv.EvaluarConfiguracion( '', '1', '1', '1', '1', '4', '1', '0' )
			*loCnv.l_Test				= .T.
			loCnv.DBF_Conversion_Support	= 2
			loCnv.run_AfterCreateTable	= 'run_AfterCreateTable__Ejecutado'
			THIS.run_AfterCreateTable__Ejecutado	= .F.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			
			*-- Copio la librería en DATOS_TEST
			lcFileName			= FORCEPATH( 'FB2P_FREE.DB2', oFXU_LIB.cPathDatosReadOnly )
			lc_File				= UPPER(lcFileName)
			lcExt2				= loCnv.Get_Ext2FromExt( JUSTEXT( lcFileName ) )
			lc_OutputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest )
			lc_OutputFileTx2	= FORCEEXT( FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest ), lcExt2 )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, '*' ) )

			*-- Genero TX2
			loCnv.Ejecutar( lc_OutputFile, .F., .F., .F., '1', '0', '1', '', '', .T., '', SYS(5)+CURDIR() )

			*-- Comparo resultados
			THIS.messageout( "Respuesta esperada = .T." )
			THIS.asserttrue( THIS.run_AfterCreateTable__Ejecutado, "RESPUESTA DE run_AfterCreateTable__Ejecutado" )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
		*	USE IN (SELECT("ARCHIVOBIN_IN"))
		*	USE IN (SELECT("TABLABIN"))
			STORE NULL TO loCnv, loCtl, goFXU
			RELEASE loCnv, loCtl, goFXU
		ENDTRY

	ENDFUNC


ENDDEFINE


PROCEDURE run_AfterCreate_DB2__Ejecutado
	LPARAMETERS tnDataSession, tcOutputFile, toTable
	goFXU.run_AfterCreate_DB2__Ejecutado	= .T.
ENDPROC


PROCEDURE run_AfterCreateTable__Ejecutado
	LPARAMETERS tnDataSession, tcOutputFile, toTable
	goFXU.run_AfterCreateTable__Ejecutado	= .T.
ENDPROC



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
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado, tc_OutputFile, tcParent, tcClass, tcObjName, toReg_Esperado

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF


		LOCAL lnCodError, lcTipoBinario, toReg ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG"

		*-- TEST
		TRY
*!*				loCnv	= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
*!*				*loCnv.l_Debug		= .F.
*!*				loCnv.l_ShowErrors	= .F.
*!*				*loCnv.l_Test		= .T.
			lcTipoBinario		= UPPER( JUSTEXT( tc_OutputFile ) )

*!*				lnCodError	= loCnv.Convertir( tc_OutputFile, @loModulo, @toEx )

*!*				IF lnCodError > 0
*!*					EXIT
*!*				ENDIF

*!*				DO CASE
*!*				CASE lcTipoBinario = 'SCX'
*!*					lnCodError	= loCnv.Convertir( FORCEEXT(tc_OutputFile,'SC2'), @loModulo, @toEx )
*!*				CASE lcTipoBinario = 'VCX'
*!*					lnCodError	= loCnv.Convertir( FORCEEXT(tc_OutputFile,'VC2'), @loModulo, @toEx )
*!*				OTHERWISE
*!*					ERROR 'Archivo [' + tc_OutputFile + '] no contemplado en los tests!'
*!*				ENDCASE

*!*				IF lnCodError > 0
*!*					EXIT
*!*				ENDIF

			IF FILE(tc_OutputFile)
				SELECT 0
				USE (tc_OutputFile) SHARED NOUPDATE ALIAS TABLABIN
			ELSE
				ERROR 'No se encontró el archivo "' + tc_OutputFile + '"'
			ENDIF

			IF EMPTY(tcParent) AND EMPTY(tcClass) AND EMPTY(tcObjName)
				DO CASE
				CASE lcTipoBinario = 'SCX'
					LOCATE FOR PLATFORM=="COMMENT " AND UniqueID=="Screen    "
				CASE lcTipoBinario = 'VCX'
					LOCATE FOR PLATFORM=="COMMENT " AND UniqueID=="Class     "
				ENDCASE
				IF NOT FOUND()
					ERROR 'No se encontró el registro de cabecera "' + UniqueID + '"'
				ENDIF
			ELSE
				LOCATE FOR CLASS==tcClass AND PARENT==tcParent AND objName==tcObjName
				IF NOT FOUND()
					ERROR 'No se encontró el registro para CLASS=="' + tcClass + '" AND PARENT=="' + tcParent + '" AND objName=="' + tcObjName + '"'
				ENDIF
			ENDIF

			SCATTER MEMO NAME toReg

		CATCH TO toEx
		FINALLY
			USE IN (SELECT("TABLABIN"))
		ENDTRY


		IF ISNULL(toEx)
			LOCAL laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
				, lnPropsAndComments_Count, lnPropsAndComments_Count_Esperado, laPropsAndComments(1,2), laPropsAndComments_Esperado(1,2) ;
				, laProtected(1), lnProtected_Count, laProtected_Esperado(1), lnProtected_Count_Esperado ;
				, laMethods(1,2), lnMethods_Count, laMethods_Esperado(1,2), lnMethods_Count_Esperado
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



			*-- Visualización de valores
			THIS.messageout( LOWER(PROGRAM(PROGRAM(-1)-1)) )

			THIS.messageout( '' )
			THIS.messageout( 'PROPERTIES esperadas para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' + TRANSFORM(lnPropsAndValues_Count_Esperado) )
			*THIS.messageout( REPLICATE('-',80) )
			*FOR I = 1 TO lnPropsAndValues_Count_Esperado
			*	THIS.messageout( 'PropName = ' + TRANSFORM(laPropsAndValues_Esperado(I,1)) )
			*ENDFOR

			THIS.messageout( '' )
			THIS.messageout( 'PROTECTED esperadas para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' + TRANSFORM(lnProtected_Count_Esperado) )
			*THIS.messageout( REPLICATE('-',80) )
			*FOR I = 1 TO lnProtected_Count_Esperado
			*	THIS.messageout( 'PropName = ' + TRANSFORM(laProtected_Esperado(I,1)) )
			*ENDFOR

			THIS.messageout( '' )
			THIS.messageout( 'RESERVED3 esperadas para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' + TRANSFORM(lnPropsAndComments_Count_Esperado) )
			*THIS.messageout( REPLICATE('-',80) )
			*FOR I = 1 TO lnPropsAndComments_Count_Esperado
			*	THIS.messageout( 'PropName = ' + TRANSFORM(laPropsAndComments_Esperado(I,1)) )
			*ENDFOR

			THIS.messageout( '' )
			THIS.messageout( 'METHODS esperadas para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' + TRANSFORM(lnMethods_Count_Esperado) )
			*THIS.messageout( REPLICATE('-',80) )
			*FOR I = 1 TO lnMethods_Count_Esperado
			*	THIS.messageout( 'Name = ' + TRANSFORM(laMethods_Esperado(I,1)) )
			*ENDFOR

			THIS.messageout( '' )
			THIS.messageout( 'OLE2 esperado para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' + TRANSFORM(toReg_Esperado.OLE2) )

			THIS.messageout( '' )
			THIS.messageout( 'Checksum OLE esperado para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' + TRANSFORM(SYS(2007, toReg_Esperado.OLE)) )


			*-- Evaluación de valores
			THIS.assertequals( toReg_Esperado.Reserved1, toReg.Reserved1, "Valor de Reserved1" )
			THIS.assertequals( toReg_Esperado.Reserved2, toReg.Reserved2, "Valor de Reserved2" )
			THIS.assertequals( toReg_Esperado.Reserved4, toReg.Reserved4, "Valor de Reserved4" )
			THIS.assertequals( toReg_Esperado.Reserved5, toReg.Reserved5, "Valor de Reserved5" )
			THIS.assertequals( toReg_Esperado.Reserved6, toReg.Reserved6, "Valor de Reserved6" )
			THIS.assertequals( toReg_Esperado.Reserved7, toReg.Reserved7, "Valor de Reserved7" )
			THIS.assertequals( toReg_Esperado.Reserved8, toReg.Reserved8, "Valor de Reserved8" )
			THIS.assertequals( toReg_Esperado.OLE2, toReg.OLE2, "Valor de OLE2" )
			THIS.assertequals( SYS(2007, toReg_Esperado.OLE), SYS(2007, toReg.OLE), "Valor de OLE (Checksum)" )

			*-- PROPERTIES
			THIS.assertequals( lnPropsAndValues_Count_Esperado, lnPropsAndValues_Count, "Cantidad de PROPERTIES" )
			FOR I = 1 TO lnPropsAndValues_Count_Esperado
				THIS.asserttrue( ASCAN( laPropsAndValues, laPropsAndValues_Esperado(I,1), 1, -1, 1, 0+2+4) > 0, ' Comprobación de que existe la Property "' + TRANSFORM(laPropsAndValues_Esperado(I,1)) + '"' )
			ENDFOR

			*-- RESERVED3
			THIS.assertequals( lnPropsAndComments_Count_Esperado, lnPropsAndComments_Count, "Cantidad de RESERVED3" )
			FOR I = 1 TO lnPropsAndComments_Count_Esperado
				THIS.asserttrue( ASCAN( laPropsAndComments, laPropsAndComments_Esperado(I,1), 1, -1, 1, 0+2+4) > 0, ' Comprobación de que existe la Reserved3 "' + TRANSFORM(laPropsAndValues_Esperado(I,1)) + '"' )
			ENDFOR

			*-- PROTECTED
			THIS.assertequals( lnProtected_Count_Esperado, lnProtected_Count, "Cantidad de PROTECTED" )
			FOR I = 1 TO lnProtected_Count_Esperado
				THIS.asserttrue( ASCAN( laProtected, laProtected_Esperado(I,1), 1, -1, 1, 0+2+4) > 0, ' Comprobación de que existe la Protected "' + TRANSFORM(laPropsAndValues_Esperado(I,1)) + '"' )
			ENDFOR

			*-- METHODS
			THIS.assertequals( lnMethods_Count_Esperado, lnMethods_Count, "Cantidad de METHODS" )
			FOR I = 1 TO lnMethods_Count_Esperado
				THIS.asserttrue( ASCAN( laMethods, laMethods_Esperado(I,1), 1, -1, 1, 0+2+4) > 0, ' Comprobación de que existe el Method "' + TRANSFORM(laPropsAndValues_Esperado(I,1)) + '"' )
			ENDFOR

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
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCamposDelRegistro
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado ;
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
			lc_File				= 'fb2p_frm_1.scx'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIBOBIN_IN

			SCAN ALL FOR NOT DELETED() AND ( UniqueID==PADR('Form',10) OR PLATFORM==PADR("WINDOWS",8) )
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				SCATTER MEMO NAME loReg_Esperado
				lcClass				= loReg_Esperado.CLASS
				lcParent			= loReg_Esperado.PARENT
				lcObjName			= loReg_Esperado.objName

				THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )
			ENDSCAN

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIBOBIN_IN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCamposDelRegistro
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado ;
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
			lc_File				= 'fb2p_test.vcx'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.Convertir( lc_OutputFile, .F., .F., .T. )
			loCnv.Convertir( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), .F., .F., .T. )

			SELECT 0
			USE (lc_InputFile) SHARED AGAIN NOUPDATE ALIAS ARCHIBOBIN_IN

			SCAN ALL FOR NOT DELETED() AND ( UniqueID==PADR('Class',10) OR PLATFORM==PADR("WINDOWS",8) )
				*-- DATOS ESPERADOS
				STORE 0 TO lnCodError_Esperado
				SCATTER MEMO NAME loReg_Esperado
				lcClass				= loReg_Esperado.CLASS
				lcParent			= loReg_Esperado.PARENT
				lcObjName			= loReg_Esperado.objName

				THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )
			ENDSCAN

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIBOBIN_IN"))
		ENDTRY

	ENDFUNC


ENDDEFINE

DEFINE CLASS ft__foxbin2prg__c_conversor_prg_a_dbf AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ft__foxbin2prg__c_conversor_prg_a_dbf OF ft__foxbin2prg__c_conversor_prg_a_dbf.PRG
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
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF


		IF ISNULL(toEx)
			*-- Validaciones en método
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
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElArchivo_FB2P_FREE_DB2_YValidarQueGenereUn_DBF_ConTodosLosCamposYLasMismasDefinicionesYOrden
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laCampos_IN(1,18), laCampos_OUT(1,18), lnFields_OUT, lnFields_IN, I, X ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			lc_File				= 'FB2P_FREE.DB2'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )
			loCnv.DBF_Conversion_Support	= 2
			loCnv.l_NoTimestamps			= .F.
			loCnv.l_ClearUniqueID			= .F.

			oFXU_LIB.copiarArchivosParaTest( lc_File )

			loCnv.Ejecutar( lc_File, '', '', '', '1', '0', '1',.F.,.F.,.T. )

			SELECT 0
			USE (FORCEEXT(lc_InputFile,'DBF')) SHARED AGAIN NOUPDATE ALIAS ARCHIVOBIN_IN
			SELECT 0
			USE (FORCEEXT(lc_OutputFile,'DBF')) SHARED AGAIN NOUPDATE ALIAS TABLABIN
			lnFields_OUT	= AFIELDS( laCampos_OUT, 'TABLABIN' )
			lnFields_IN		= AFIELDS( laCampos_IN, 'ARCHIVOBIN_IN' )
			
			
			*-- Visualización de valores
			THIS.messageout( 'Cantidad de campos: ' + TRANSFORM(lnFields_OUT) )
			THIS.messageout( '' )
			THIS.messageout( PADR('Nombre',12) + ' ' + PADC('Tipo',4) + ' ' + PADL('Long',4) + ' ' + PADL('Dec',4) )
			THIS.messageout( PADR('----------',12) + ' ' + PADC('----',4) + ' ' + PADL('----',4) + ' ' + PADL('---',4) )

			FOR I = 1 TO lnFields_IN
				THIS.messageout( PADR(laCampos_IN(I,1),12) + ' ' + PADC(laCampos_IN(I,2),4) + ' ' + PADL(laCampos_IN(I,3),4) + ' ' + PADL(laCampos_IN(I,4),4) )
			ENDFOR

			THIS.messageout( PADR('----------',12) + ' ' + PADC('----',4) + ' ' + PADL('----',4) + ' ' + PADL('---',4) )

			
			*-- Evaluación de valores
			this.assertequals( lnFields_OUT, lnFields_IN, '[Cantidad de campos IN y OUT]' )

			FOR I = 1 TO lnFields_IN
				FOR X = 1 TO 18
					THIS.assertequals( laCampos_IN(I,X), laCampos_OUT(I,X), '[Comparando estructura del campo ' + laCampos_IN(I,1) + ']' )
				ENDFOR
			ENDFOR

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElArchivo_FB2P_FREE_DB2_YValidarQueGenereUn_DBF_ConLosMismosIndices
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laIndices_IN(1,18), laIndices_OUT(1,18), lnIndices_OUT, lnIndices_IN, I, X ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			lc_File				= 'FB2P_FREE.DB2'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )
			loCnv.DBF_Conversion_Support	= 2
			loCnv.l_NoTimestamps			= .F.
			loCnv.l_ClearUniqueID			= .F.

			oFXU_LIB.copiarArchivosParaTest( lc_File )

			loCnv.Ejecutar( lc_File, '', '', '', '1', '0', '1',.F.,.F.,.T. )

			SELECT 0
			USE (FORCEEXT(lc_InputFile,'DBF')) SHARED AGAIN NOUPDATE ALIAS ARCHIVOBIN_IN
			SELECT 0
			USE (FORCEEXT(lc_OutputFile,'DBF')) SHARED AGAIN NOUPDATE ALIAS TABLABIN
			lnIndices_IN	= ATAGINFO( laIndices_IN, '', 'ARCHIVOBIN_IN' )
			lnIndices_OUT	= ATAGINFO( laIndices_OUT, '', 'TABLABIN' )
			
			
			*-- Visualización de valores
			THIS.messageout( 'Cantidad de índices para [' + DBF("TABLABIN") + ']: ' + TRANSFORM(lnIndices_OUT) )
			THIS.messageout( '' )
			THIS.messageout( PADR('Tag',12) + ' ' + PADR('Tipo',12) + ' ' + PADR('Clave',30) + ' ' + PADR('Filtro',30) + ' ' + PADR('Order',12) + ' ' + PADR('Collate',12) )
			THIS.messageout( PADR('----------',12) + ' ' + PADR('----------',12) + ' ' + PADR('----------------------------',30) + ' ' + PADR('----------------------------',30) + ' ' + PADR('----------',12) + ' ' + PADR('----------',12) )

			FOR I = 1 TO lnIndices_OUT
				THIS.messageout( PADR(laIndices_OUT(I,1),12) + ' ' + PADR(laIndices_OUT(I,2),12) + ' ' + PADR(laIndices_OUT(I,3),30) + ' ' + PADR(laIndices_OUT(I,4),30) ;
					 + ' ' + PADR(laIndices_OUT(I,5),12) + ' ' + PADR(laIndices_OUT(I,6),12) )
			ENDFOR

			THIS.messageout( PADR('----------',12) + ' ' + PADR('----------',12) + ' ' + PADR('----------------------------',30) + ' ' + PADR('----------------------------',30) + ' ' + PADR('----------',12) + ' ' + PADR('----------',12) )

			
			*-- Evaluación de valores
			this.assertequals( lnIndices_OUT, lnIndices_IN, '[Cantidad de campos IN y OUT]' )

			FOR I = 1 TO lnIndices_IN
				FOR X = 1 TO 6
					THIS.assertequals( laIndices_IN(I,X), laIndices_OUT(I,X), '[Comparando estructura del indice ' + laIndices_IN(I,1) + ']' )
				ENDFOR
			ENDFOR

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaTabla_FB2P_FREE_DBF_YValidarQueGenereUn_DB2yDBF_ConTodosLosCamposYLasMismasDefinicionesYOrden
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laCampos_IN(1,18), laCampos_OUT(1,18), lnFields_OUT, lnFields_IN, I, X ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			lc_File				= 'FB2P_FREE.DB2'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )
			loCnv.DBF_Conversion_Support	= 2
			loCnv.l_NoTimestamps			= .F.
			loCnv.l_ClearUniqueID			= .F.

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT(lc_File,'*') )

			loCnv.Ejecutar( FORCEEXT(lc_File,'DBF'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			loCnv.Ejecutar( FORCEEXT(lc_File,'DB2'), '', '', '', '1', '0', '1',.F.,.F.,.T. )

			SELECT 0
			USE (FORCEEXT(lc_InputFile,'DBF')) SHARED AGAIN NOUPDATE ALIAS ARCHIVOBIN_IN
			SELECT 0
			USE (FORCEEXT(lc_OutputFile,'DBF')) SHARED AGAIN NOUPDATE ALIAS TABLABIN
			lnFields_OUT	= AFIELDS( laCampos_OUT, 'TABLABIN' )
			lnFields_IN		= AFIELDS( laCampos_IN, 'ARCHIVOBIN_IN' )
			
			
			*-- Visualización de valores
			THIS.messageout( 'Cantidad de campos: ' + TRANSFORM(lnFields_OUT) )
			THIS.messageout( '' )
			THIS.messageout( PADR('Nombre',12) + ' ' + PADC('Tipo',4) + ' ' + PADL('Long',4) + ' ' + PADL('Dec',4) )
			THIS.messageout( PADR('----------',12) + ' ' + PADC('----',4) + ' ' + PADL('----',4) + ' ' + PADL('---',4) )

			FOR I = 1 TO lnFields_IN
				THIS.messageout( PADR(laCampos_IN(I,1),12) + ' ' + PADC(laCampos_IN(I,2),4) + ' ' + PADL(laCampos_IN(I,3),4) + ' ' + PADL(laCampos_IN(I,4),4) )
			ENDFOR

			THIS.messageout( PADR('----------',12) + ' ' + PADC('----',4) + ' ' + PADL('----',4) + ' ' + PADL('---',4) )

			
			*-- Evaluación de valores
			this.assertequals( lnFields_OUT, lnFields_IN, '[Cantidad de campos IN y OUT]' )

			FOR I = 1 TO lnFields_IN
				FOR X = 1 TO 18
					THIS.assertequals( laCampos_IN(I,X), laCampos_OUT(I,X), '[Comparando estructura del campo ' + laCampos_IN(I,1) + ']' )
				ENDFOR
			ENDFOR

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaTabla_FB2P_FREE_DBF_YValidarQueGenereUn_DB2yDBF_ConLosMismosIndices
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laIndices_IN(1,18), laIndices_OUT(1,18), lnIndices_OUT, lnIndices_IN, I, X ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loCnv		= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			lc_File				= 'FB2P_FREE.DB2'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )
			loCnv.DBF_Conversion_Support	= 2
			loCnv.l_NoTimestamps			= .F.
			loCnv.l_ClearUniqueID			= .F.

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT(lc_File,'*') )

			loCnv.Ejecutar( FORCEEXT(lc_File,'DBF'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			loCnv.Ejecutar( FORCEEXT(lc_File,'DB2'), '', '', '', '1', '0', '1',.F.,.F.,.T. )

			SELECT 0
			USE (FORCEEXT(lc_InputFile,'DBF')) SHARED AGAIN NOUPDATE ALIAS ARCHIVOBIN_IN
			SELECT 0
			USE (FORCEEXT(lc_OutputFile,'DBF')) SHARED AGAIN NOUPDATE ALIAS TABLABIN
			lnIndices_IN	= ATAGINFO( laIndices_IN, '', 'ARCHIVOBIN_IN' )
			lnIndices_OUT	= ATAGINFO( laIndices_OUT, '', 'TABLABIN' )
			
			
			*-- Visualización de valores
			THIS.messageout( 'Cantidad de índices para [' + DBF("TABLABIN") + ']: ' + TRANSFORM(lnIndices_OUT) )
			THIS.messageout( '' )
			THIS.messageout( PADR('Tag',12) + ' ' + PADR('Tipo',12) + ' ' + PADR('Clave',30) + ' ' + PADR('Filtro',30) + ' ' + PADR('Order',12) + ' ' + PADR('Collate',12) )
			THIS.messageout( PADR('----------',12) + ' ' + PADR('----------',12) + ' ' + PADR('----------------------------',30) + ' ' + PADR('----------------------------',30) + ' ' + PADR('----------',12) + ' ' + PADR('----------',12) )

			FOR I = 1 TO lnIndices_OUT
				THIS.messageout( PADR(laIndices_OUT(I,1),12) + ' ' + PADR(laIndices_OUT(I,2),12) + ' ' + PADR(laIndices_OUT(I,3),30) + ' ' + PADR(laIndices_OUT(I,4),30) ;
					 + ' ' + PADR(laIndices_OUT(I,5),12) + ' ' + PADR(laIndices_OUT(I,6),12) )
			ENDFOR

			THIS.messageout( PADR('----------',12) + ' ' + PADR('----------',12) + ' ' + PADR('----------------------------',30) + ' ' + PADR('----------------------------',30) + ' ' + PADR('----------',12) + ' ' + PADR('----------',12) )

			
			*-- Evaluación de valores
			this.assertequals( lnIndices_OUT, lnIndices_IN, '[Cantidad de campos IN y OUT]' )

			FOR I = 1 TO lnIndices_IN
				FOR X = 1 TO 6
					THIS.assertequals( laIndices_IN(I,X), laIndices_OUT(I,X), '[Comparando estructura del indice ' + laIndices_IN(I,1) + ']' )
				ENDFOR
			ENDFOR

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


ENDDEFINE

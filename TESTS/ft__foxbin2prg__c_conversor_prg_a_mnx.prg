DEFINE CLASS ft__foxbin2prg__c_conversor_prg_a_mnx AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ft__foxbin2prg__c_conversor_prg_a_mnx OF ft__foxbin2prg__c_conversor_prg_a_mnx.PRG
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
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElArchivo_MENU1_MN2_YRegenerarEl_MNX_ConTodosSusObjetos
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laCampos_IN(1,18), laCampos_OUT(1,18), lnFields_OUT, lnFields_IN, I, X, lcMN2, lcMN3, lnLenHeader ;
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
			STORE 0 TO lnCodError
			lc_File				= 'MENU1.MNX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT(lc_File,'*') )

			*-- Genero el DC2
			loCnv.Ejecutar( FORCEEXT(lc_File,'MNX'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Regenero el DBC
			loCnv.Ejecutar( FORCEEXT(lc_File,'MN2'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Renombro el DC2 a DC3 (ORIGINAL)
			RENAME (FORCEEXT(lc_OutputFile,'MN2')) TO (FORCEEXT(lc_OutputFile,'MN3'))
			*-- Genero el DC2 desde el DBC regenerado
			loCnv.Ejecutar( FORCEEXT(lc_File,'MNX'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Comparo los MN2 y MN3
			lnLenHeader	= LEN( loCnv.get_PROGRAM_HEADER() )
			lcMN2	= SUBSTR( FILETOSTR( FORCEEXT(lc_File,'MN2') ), lnLenHeader )
			lcMN3	= SUBSTR( FILETOSTR( FORCEEXT(lc_File,'MN3') ), lnLenHeader )
			
			
			*-- Visualización de valores
			THIS.messageout( 'Bytes MN3: ' + TRANSFORM(LEN(lcMN3)) )
			THIS.messageout( 'Bytes MN2: ' + TRANSFORM(LEN(lcMN2)) )

			
			*-- Evaluación de valores
			this.assertequals( lcMN2, lcMN3, '[Comparación MN2 y MN3]' )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElArchivo_MENU2_MN2_YRegenerarEl_MNX_ConTodosSusObjetos
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laCampos_IN(1,18), laCampos_OUT(1,18), lnFields_OUT, lnFields_IN, I, X, lcMN2, lcMN3, lnLenHeader ;
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
			STORE 0 TO lnCodError
			lc_File				= 'MENU2.MNX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT(lc_File,'*') )

			*-- Genero el DC2
			loCnv.Ejecutar( FORCEEXT(lc_File,'MNX'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Regenero el DBC
			loCnv.Ejecutar( FORCEEXT(lc_File,'MN2'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Renombro el DC2 a DC3 (ORIGINAL)
			RENAME (FORCEEXT(lc_OutputFile,'MN2')) TO (FORCEEXT(lc_OutputFile,'MN3'))
			*-- Genero el DC2 desde el DBC regenerado
			loCnv.Ejecutar( FORCEEXT(lc_File,'MNX'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Comparo los MN2 y MN3
			lnLenHeader	= LEN( loCnv.get_PROGRAM_HEADER() )
			lcMN2	= SUBSTR( FILETOSTR( FORCEEXT(lc_File,'MN2') ), lnLenHeader )
			lcMN3	= SUBSTR( FILETOSTR( FORCEEXT(lc_File,'MN3') ), lnLenHeader )
			
			
			*-- Visualización de valores
			THIS.messageout( 'Bytes MN3: ' + TRANSFORM(LEN(lcMN3)) )
			THIS.messageout( 'Bytes MN2: ' + TRANSFORM(LEN(lcMN2)) )

			
			*-- Evaluación de valores
			this.assertequals( lcMN2, lcMN3, '[Comparación MN2 y MN3]' )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElArchivo_MENU3_MN2_YRegenerarEl_MNX_ConTodosSusObjetos
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laCampos_IN(1,18), laCampos_OUT(1,18), lnFields_OUT, lnFields_IN, I, X, lcMN2, lcMN3, lnLenHeader ;
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
			STORE 0 TO lnCodError
			lc_File				= 'MENU3.MNX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT(lc_File,'*') )

			*-- Genero el DC2
			loCnv.Ejecutar( FORCEEXT(lc_File,'MNX'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Regenero el DBC
			loCnv.Ejecutar( FORCEEXT(lc_File,'MN2'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Renombro el DC2 a DC3 (ORIGINAL)
			RENAME (FORCEEXT(lc_OutputFile,'MN2')) TO (FORCEEXT(lc_OutputFile,'MN3'))
			*-- Genero el DC2 desde el DBC regenerado
			loCnv.Ejecutar( FORCEEXT(lc_File,'MNX'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Comparo los MN2 y MN3
			lnLenHeader	= LEN( loCnv.get_PROGRAM_HEADER() )
			lcMN2	= SUBSTR( FILETOSTR( FORCEEXT(lc_File,'MN2') ), lnLenHeader )
			lcMN3	= SUBSTR( FILETOSTR( FORCEEXT(lc_File,'MN3') ), lnLenHeader )
			
			
			*-- Visualización de valores
			THIS.messageout( 'Bytes MN3: ' + TRANSFORM(LEN(lcMN3)) )
			THIS.messageout( 'Bytes MN2: ' + TRANSFORM(LEN(lcMN2)) )

			
			*-- Evaluación de valores
			this.assertequals( lcMN2, lcMN3, '[Comparación MN2 y MN3]' )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElArchivo_MENU_SHORTCUT_MN2_YRegenerarEl_MNX_ConTodosSusObjetos
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laCampos_IN(1,18), laCampos_OUT(1,18), lnFields_OUT, lnFields_IN, I, X, lcMN2, lcMN3, lnLenHeader ;
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
			STORE 0 TO lnCodError
			lc_File				= 'MENU_SHORTCUT.MNX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT(lc_File,'*') )

			*-- Genero el DC2
			loCnv.Ejecutar( FORCEEXT(lc_File,'MNX'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Regenero el DBC
			loCnv.Ejecutar( FORCEEXT(lc_File,'MN2'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Renombro el DC2 a DC3 (ORIGINAL)
			RENAME (FORCEEXT(lc_OutputFile,'MN2')) TO (FORCEEXT(lc_OutputFile,'MN3'))
			*-- Genero el DC2 desde el DBC regenerado
			loCnv.Ejecutar( FORCEEXT(lc_File,'MNX'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Comparo los MN2 y MN3
			lnLenHeader	= LEN( loCnv.get_PROGRAM_HEADER() )
			lcMN2	= SUBSTR( FILETOSTR( FORCEEXT(lc_File,'MN2') ), lnLenHeader )
			lcMN3	= SUBSTR( FILETOSTR( FORCEEXT(lc_File,'MN3') ), lnLenHeader )
			
			
			*-- Visualización de valores
			THIS.messageout( 'Bytes MN3: ' + TRANSFORM(LEN(lcMN3)) )
			THIS.messageout( 'Bytes MN2: ' + TRANSFORM(LEN(lcMN2)) )

			
			*-- Evaluación de valores
			this.assertequals( lcMN2, lcMN3, '[Comparación MN2 y MN3]' )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElArchivo_MENU_SHORTCUT2_MN2_YRegenerarEl_MNX_ConTodosSusObjetos
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laCampos_IN(1,18), laCampos_OUT(1,18), lnFields_OUT, lnFields_IN, I, X, lcMN2, lcMN3, lnLenHeader ;
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
			STORE 0 TO lnCodError
			lc_File				= 'MENU_SHORTCUT2.MNX'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT(lc_File,'*') )

			*-- Genero el DC2
			loCnv.Ejecutar( FORCEEXT(lc_File,'MNX'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Regenero el DBC
			loCnv.Ejecutar( FORCEEXT(lc_File,'MN2'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Renombro el DC2 a DC3 (ORIGINAL)
			RENAME (FORCEEXT(lc_OutputFile,'MN2')) TO (FORCEEXT(lc_OutputFile,'MN3'))
			*-- Genero el DC2 desde el DBC regenerado
			loCnv.Ejecutar( FORCEEXT(lc_File,'MNX'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Comparo los MN2 y MN3
			lnLenHeader	= LEN( loCnv.get_PROGRAM_HEADER() )
			lcMN2	= SUBSTR( FILETOSTR( FORCEEXT(lc_File,'MN2') ), lnLenHeader )
			lcMN3	= SUBSTR( FILETOSTR( FORCEEXT(lc_File,'MN3') ), lnLenHeader )
			
			
			*-- Visualización de valores
			THIS.messageout( 'Bytes MN3: ' + TRANSFORM(LEN(lcMN3)) )
			THIS.messageout( 'Bytes MN2: ' + TRANSFORM(LEN(lcMN2)) )

			
			*-- Evaluación de valores
			this.assertequals( lcMN2, lcMN3, '[Comparación MN2 y MN3]' )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


ENDDEFINE

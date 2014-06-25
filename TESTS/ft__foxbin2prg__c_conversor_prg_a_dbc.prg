DEFINE CLASS ft__foxbin2prg__c_conversor_prg_a_dbc AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ft__foxbin2prg__c_conversor_prg_a_dbc OF ft__foxbin2prg__c_conversor_prg_a_dbc.PRG
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
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElArchivo_FB2P_DBC_DC2_YRegenerarEl_DBC_ConTodosSusObjetos
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_InputFile, lc_OutputFile, lcParent, lcClass, lcObjName, loReg_Esperado, loReg, lcTipoBinario ;
			, laCampos_IN(1,18), laCampos_OUT(1,18), lnFields_OUT, lnFields_IN, I, X, lcDC2, lcDC3 ;
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
			lc_File				= 'FB2P_DBC.DBC'
			lc_InputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosReadOnly )
			lc_OutputFile		= FORCEPATH( lc_File, oFXU_LIB.cPathDatosTest )
			lcTipoBinario		= UPPER( JUSTEXT( lc_OutputFile ) )

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT(lc_File,'*') )
			oFXU_LIB.copiarArchivosParaTest( 'EVENTSFILE.PRG' )

			*-- Genero el DC2
			loCnv.Ejecutar( FORCEEXT(lc_OutputFile,'DBC'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Regenero el DBC
			loCnv.Ejecutar( FORCEEXT(lc_OutputFile,'DC2'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Renombro el DC2 a DC3 (ORIGINAL)
			RENAME (FORCEEXT(lc_OutputFile,'DC2')) TO (FORCEEXT(lc_OutputFile,'DC3'))
			*-- Genero el DC2 desde el DBC regenerado
			*WAIT WINDOW TIMEOUT 2	&& Para forzar una diferencia de 2 segundos entre el DC2 y el DC3
			loCnv.Ejecutar( FORCEEXT(lc_OutputFile,'DBC'), '', '', '', '1', '0', '1',.F.,.F.,.T. )
			*-- Comparo los DC2 y DC3
			lcDC2	= STREXTRACT( FILETOSTR( FORCEEXT(lc_OutputFile,'DC2') ), '<DATABASE>', '</DATABASE>' )
			lcDC3	= STREXTRACT( FILETOSTR( FORCEEXT(lc_OutputFile,'DC3') ), '<DATABASE>', '</DATABASE>' )
			
			
			*-- Visualización de valores
			THIS.messageout( 'Bytes DC3: ' + TRANSFORM(LEN(lcDC3)) )
			THIS.messageout( 'Bytes DC2: ' + TRANSFORM(LEN(lcDC2)) )

			
			*-- Evaluación de valores
			this.assertequals( lcDC2, lcDC3, '[Comparación DC2 y DC3]' )


		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
		ENDTRY

	ENDFUNC


ENDDEFINE

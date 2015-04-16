DEFINE CLASS ft__foxbin2prg__c_conversor_prg_a_bin AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ft__foxbin2prg__c_conversor_prg_a_bin OF ft__foxbin2prg__c_conversor_prg_a_bin.PRG
	#ENDIF

	#DEFINE CR_LF				CHR(13) + CHR(10)
	#DEFINE C_CR				CHR(13)
	#DEFINE C_LF				CHR(10)
	#DEFINE C_TAB				CHR(9)
	icObj = NULL


	*******************************************************************************************************************************************
	FUNCTION SETUP
		PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		*LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		*DOEVENTS FORCE
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

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Evaluate_results
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF

		IF ISNULL(toEx)
			*-- Visualización de valores
			THIS.messageout( ' CodError: ' + TRANSFORM(tnCodError_Esperado) )

			
			*-- Evaluación de valores
			*THIS.assertequals( '[' + tcMemo_Esperado + ']', '[' + tcMemo_Salida + ']', "Contenido del Memo de PROCEDURE" )

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_PROCEDURE_IN_LPARAMETERS_VC2_y_NoDevolverErrores
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
			*loCnv.l_ShowErrors			= .F.
			*loCnv.l_Test				= .T.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lc_File				= 'PROCEDURE_IN_LPARAMETERS.VC2'
			lc_InputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_READONLY' )
			lc_OutputFile		= FORCEPATH( lc_File, 'TESTS\DATOS_TEST' )
			lnCodError_Esperado	= 0

			oFXU_LIB.copiarArchivosParaTest( FORCEEXT( lc_File, LEFT( JUSTEXT(lc_File),2 ) + '?' ) )

			loCnv.execute( lc_OutputFile, '', '', '', '1', '0', '1', '', '', .T. )
			*loCnv.execute( FORCEEXT(lc_OutputFile, LEFT( JUSTEXT(lc_File),2 ) + '2' ), '', '', '', '1', '0', '1', '', '', .T. )
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		CATCH TO loEx
			THIS.Evaluate_results( loEx, lnCodError_Esperado )

		FINALLY
			USE IN (SELECT("ARCHIVOBIN_IN"))
			USE IN (SELECT("TABLABIN"))
			STORE NULL TO loModulo, loCnv
			RELEASE loModulo, loCnv
		ENDTRY

	ENDFUNC


ENDDEFINE

DEFINE CLASS ut__foxbin2prg__c_conversor_base__doBackup AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_conversor_base__doBackup OF ut__foxbin2prg__c_conversor_base__doBackup.PRG
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
		LOCAL loObj AS c_foxbin2prg OF "FOXBIN2PRG.PRG"
		SET PROCEDURE TO 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		oFXU_LIB = CREATEOBJECT('CL_FXU_CONFIG')
		oFXU_LIB.setup_comun()

		THIS.icObj 	= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
		loObj			= THIS.icObj
		loObj.l_Test	= .T.

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
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado, tcBackFile_1, tcBackFile_2, tcBackFile_3

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		LOCAL loObj AS c_foxbin2prg OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF

		IF VARTYPE(toEx) <> 'O'
			*-- Visualización de valores
			THIS.messageout( 'BackFile_1: ' + TRANSFORM(tcBackFile_1) )
			THIS.messageout( 'BackFile_2: ' + TRANSFORM(tcBackFile_2) )
			THIS.messageout( 'BackFile_3: ' + TRANSFORM(tcBackFile_3) )

			
			*-- Evaluación de valores
			THIS.assertequals( .T., FILE(tcBackFile_1), "Existencia del archivo " + tcBackFile_1 )
			IF NOT EMPTY(tcBackFile_2)
				THIS.assertequals( .T., FILE(tcBackFile_2), "Existencia del archivo " + tcBackFile_2 )
			ENDIF
			IF NOT EMPTY(tcBackFile_3)
				THIS.assertequals( .T., FILE(tcBackFile_3), "Existencia del archivo " + tcBackFile_3 )
			ENDIF

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_HacerElBackupDelArchivoIndicado

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcMemo, lcMemo_Salida, lcMemo_Esperado, lcBackFile_1, lcBackFile_2, lcBackFile_3 ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_foxbin2prg OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL
		loObj.c_OutputFile	= FORCEPATH( 'FB2P_DBC.DBC', oFXU_LIB.cPathDatosTest )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		COPY FILE ( FORCEPATH( 'FB2P_DBC.D??', oFXU_LIB.cPathDatosReadOnly ) ) TO ( FORCEPATH( 'FB2P_DBC.D??', oFXU_LIB.cPathDatosTest ) )

		*-- TEST
		loObj.doBackup( @loEx, .F., @lcBackFile_1, @lcBackFile_2, @lcBackFile_3 )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lcBackFile_1, lcBackFile_2, lcBackFile_3 )

	ENDFUNC


ENDDEFINE

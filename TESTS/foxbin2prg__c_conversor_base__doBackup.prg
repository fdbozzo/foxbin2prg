DEFINE CLASS foxbin2prg__c_conversor_base__doBackup AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS foxbin2prg__c_conversor_base__doBackup OF foxbin2prg__c_conversor_base__doBackup.PRG
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
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		SET PROCEDURE TO 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		oFXU_LIB = CREATEOBJECT('CL_FXU_CONFIG')
		oFXU_LIB.setup_comun()

		THIS.icObj 	= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
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
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado, tcMemo, tcMemo_Salida, tcMemo_Esperado

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
			*-- Algunos ajustes para mejor visualización de caracteres especiales
			tcMemo			= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcMemo )
			tcMemo_Esperado	= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcMemo_Esperado )
			tcMemo_Salida	= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcMemo_Salida )
			
			*-- Visualización de valores
			THIS.messageout( ' Memo de entrada:' )
			THIS.messageout( '[' + tcMemo + ']' )

			THIS.messageout( REPLICATE('-',80) )

			THIS.messageout( ' Memo esperado:' )
			THIS.messageout( '[' + tcMemo_Esperado + ']' )

			
			*-- Evaluación de valores
			THIS.assertequals( '[' + tcMemo_Esperado + ']', '[' + tcMemo_Salida + ']', "Contenido del Memo de PROCEDURE" )

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
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcMemo, lcMemo_Salida, lcMemo_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		*loObj

		*-- TEST
		loObj.doBackup()

		THIS.Evaluate_results( loEx, lnCodError_Esperado, @lcMemo, @lcMemo_Salida, @lcMemo_Esperado )

	ENDFUNC


ENDDEFINE

DEFINE CLASS ut__foxbin2prg__c_conversor_base__RowTimeStamp AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_conversor_base__RowTimeStamp OF ut__foxbin2prg__c_conversor_base__RowTimeStamp.PRG
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

		THIS.icObj 	= NEWOBJECT("c_conversor_base", "FOXBIN2PRG.PRG")
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
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF

		IF ISNULL(toEx)
			
			*-- Visualización de valores
			THIS.messageout( ' TimeStamp (T) = ' + TRANSFORM(ltTimeStamp) )
			THIS.messageout( ' TimeStamp (N) = ' + TRANSFORM(lnTimeStamp) )

			
			*-- Evaluación de valores
			THIS.assertequals( lnTimeStamp_Esperado, lnTimeStamp, "[Valor de TimeStamp]" )

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverElValor_1132544064_ParaLaFechaHora_2013_12_01_08_02_00
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		ltTimeStamp				= {^2013/12/01  8:02:00}	&& Le corresponde el numero 1132544064

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lnTimeStamp_Esperado	= 1132544064
		*lnTimeStamp_Esperado	= loObj.rowtimestamp( ltTimeStamp )

		*-- TEST
		lnTimeStamp	= loObj.rowtimestamp( ltTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverElValor_1132544065_ParaLaFechaHora_2013_12_01_08_02_01
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		ltTimeStamp				= {^2013/12/01  8:02:01}	&& Le corresponde el numero 1132544065

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lnTimeStamp_Esperado	= 1132544065
		*lnTimeStamp_Esperado	= loObj.rowtimestamp( ltTimeStamp )

		*-- TEST
		lnTimeStamp	= loObj.rowtimestamp( ltTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverElValor_1132544095_ParaLaFechaHora_2013_12_01_08_02_31
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		ltTimeStamp				= {^2013/12/01  8:02:31}	&& Le corresponde el numero 1132544095

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lnTimeStamp_Esperado	= 1132544095
		*lnTimeStamp_Esperado	= loObj.rowtimestamp( ltTimeStamp )

		*-- TEST
		lnTimeStamp	= loObj.rowtimestamp( ltTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverElValor_1132544096_ParaLaFechaHora_2013_12_01_08_02_32
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		ltTimeStamp				= {^2013/12/01  8:02:32}	&& Le corresponde el numero 1132544096

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lnTimeStamp_Esperado	= 1132544096
		*lnTimeStamp_Esperado	= loObj.rowtimestamp( ltTimeStamp )

		*-- TEST
		lnTimeStamp	= loObj.rowtimestamp( ltTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverElValor_1132544097_ParaLaFechaHora_2013_12_01_08_02_33
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		ltTimeStamp				= {^2013/12/01  8:02:33}	&& Le corresponde el numero 1132544097

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lnTimeStamp_Esperado	= 1132544097
		*lnTimeStamp_Esperado	= loObj.rowtimestamp( ltTimeStamp-1 )

		*-- TEST
		lnTimeStamp	= loObj.rowtimestamp( ltTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverElValor_1132544123_ParaLaFechaHora_2013_12_01_08_02_59
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		ltTimeStamp				= {^2013/12/01  8:02:59}	&& Le corresponde el numero 1132544123

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lnTimeStamp_Esperado	= 1132544123
		*lnTimeStamp_Esperado	= loObj.rowtimestamp( ltTimeStamp )

		*-- TEST
		lnTimeStamp	= loObj.rowtimestamp( ltTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverElValor_1132544096_ParaLaFechaHora_2013_12_01_08_03_00
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		ltTimeStamp				= {^2013/12/01  8:03:00}	&& Le corresponde el numero 1132544096

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lnTimeStamp_Esperado	= 1132544096
		*lnTimeStamp_Esperado	= loObj.rowtimestamp( ltTimeStamp )

		*-- TEST
		lnTimeStamp	= loObj.rowtimestamp( ltTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverElValor_1132544097_ParaLaFechaHora_2013_12_01_08_03_01
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		ltTimeStamp				= {^2013/12/01  8:03:01}	&& Le corresponde el numero 1132544097

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lnTimeStamp_Esperado	= 1132544097
		*lnTimeStamp_Esperado	= loObj.rowtimestamp( ltTimeStamp-1 )

		*-- TEST
		lnTimeStamp	= loObj.rowtimestamp( ltTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverElValor_1132544123_ParaLaFechaHora_2013_12_01_08_03_27
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		ltTimeStamp				= {^2013/12/01  8:03:27}	&& Le corresponde el numero 1132544123

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lnTimeStamp_Esperado	= 1132544123
		*lnTimeStamp_Esperado	= loObj.rowtimestamp( ltTimeStamp )

		*-- TEST
		lnTimeStamp	= loObj.rowtimestamp( ltTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


ENDDEFINE

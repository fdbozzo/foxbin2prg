DEFINE CLASS ut__foxbin2prg__c_conversor_base__GetTimeStamp AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_conversor_base__GetTimeStamp OF ut__foxbin2prg__c_conversor_base__GetTimeStamp.PRG
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
			THIS.assertequals( ltTimeStamp_Esperado, ltTimeStamp, "[Fecha y Hora]" )

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverLaFechaHora_2013_12_01_08_02_00_ParaElValor_1132544064
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lnTimeStamp				= 1132544064	&& Corresponde a {^2013/12/01  8:02:00}

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		ltTimeStamp_Esperado	= TTOC({^2013/12/01  8:02:00})

		*-- TEST
		ltTimeStamp	= loObj.gettimestamp( lnTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverLaFechaHora_2013_12_01_08_02_01_ParaElValor_1132544065
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lnTimeStamp				= 1132544065	&& Corresponde a {^2013/12/01  8:02:01}

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		ltTimeStamp_Esperado	= TTOC({^2013/12/01  8:02:01})

		*-- TEST
		ltTimeStamp	= loObj.gettimestamp( lnTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverLaFechaHora_2013_12_01_08_02_30_ParaElValor_1132544094
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lnTimeStamp				= 1132544094	&& Corresponde a {^2013/12/01  8:02:30}

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		ltTimeStamp_Esperado	= TTOC({^2013/12/01  8:02:30})

		*-- TEST
		ltTimeStamp	= loObj.gettimestamp( lnTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverLaFechaHora_2013_12_01_08_02_31_ParaElValor_1132544095
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lnTimeStamp				= 1132544095	&& Corresponde a {^2013/12/01  8:02:31}

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		ltTimeStamp_Esperado	= TTOC({^2013/12/01  8:02:31})

		*-- TEST
		ltTimeStamp	= loObj.gettimestamp( lnTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverLaFechaHora_2013_12_01_08_03_00_ParaElValor_1132544096
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lnTimeStamp				= 1132544096	&& Corresponde a {^2013/12/01  8:02:32}

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		ltTimeStamp_Esperado	= TTOC({^2013/12/01  8:03:00})

		*-- TEST
		ltTimeStamp	= loObj.gettimestamp( lnTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverLaFechaHora_2013_12_01_08_03_01_ParaElValor_1132544097
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lnTimeStamp				= 1132544097	&& Corresponde a {^2013/12/01  8:02:33}

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		ltTimeStamp_Esperado	= TTOC({^2013/12/01  8:03:01})

		*-- TEST
		ltTimeStamp	= loObj.gettimestamp( lnTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverLaFechaHora_2013_12_01_08_03_27_ParaElValor_1132544123__HoraReal__08_02_59
		LOCAL lnCodError, lnCodError_Esperado  ;
			, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lnTimeStamp				= 1132544123	&& Corresponde a {^2013/12/01  8:02:59}

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		ltTimeStamp_Esperado	= TTOC({^2013/12/01  8:03:27})

		*-- TEST
		ltTimeStamp	= loObj.gettimestamp( lnTimeStamp )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, ltTimeStamp, ltTimeStamp_Esperado, lnTimeStamp, lnTimeStamp_Esperado )

	ENDFUNC


ENDDEFINE

DEFINE CLASS ut__foxbin2prg__c_conversor_base__get_SeparatedPropAndValue AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_conversor_base__get_SeparatedPropAndValue OF ut__foxbin2prg__c_conversor_base__get_SeparatedPropAndValue.PRG
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
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado ;
			, tcPropName, tcPropValue, tcComentario, tcPropName_Esperado, tcPropValue_Esperado

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
			*-- Algunos ajustes para mejor visualización de caracteres especiales
			tcPropValue				= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcPropValue )
			tcPropValue_Esperado	= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcPropValue_Esperado )
		
			
			*-- Visualización de valores
			THIS.messageout( ' PropName = ' + TRANSFORM(tcPropName) )
			THIS.messageout( ' PropValue = ' + TRANSFORM(tcPropValue) )

			
			*-- Evaluación de valores
			THIS.assertequals( tcPropName_Esperado, tcPropName, "PropsAndValues_Count" )
			THIS.assertequals( tcPropValue_Esperado, tcPropValue, "PropsAndValues_Count" )

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverSeparados_Prop_y_Value
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, laProps(1,2) ,lcPropName, lcPropValue, lcComentario, lcPropName_Esperado, lcPropValue_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lcPropName	= '_memberdata'
		lcPropValue = '<VFPData><memberdata name="mimetodo" display="miMetodo"/></VFPData>'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		laProps( 1,1)			= 'prop_especial_cr = <fb2p_value>Este es el valor 1&#13;Este el 2&#13;Y este bajo Shift_Enter el 3</fb2p_value>'
		laProps( 1,2)			= ''
		lcPropName_Esperado		= 'prop_especial_cr'
		lcPropValue_Esperado	= '<fb2p_value>Este es el valor 1&#13;Este el 2&#13;Y este bajo Shift_Enter el 3</fb2p_value>'

		*-- TEST
		loObj.get_SeparatedPropAndValue( laProps(1,1), @lcPropName, @lcPropValue )

		THIS.Evaluate_results( loEx, lnCodError_Esperado ;
			, @lcPropName, @lcPropValue, @lcComentario, @lcPropName_Esperado, @lcPropValue_Esperado )

	ENDFUNC


ENDDEFINE

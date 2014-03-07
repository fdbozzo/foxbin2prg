DEFINE CLASS ut__foxbin2prg__c_conversor_prg_a_bin__analizarAsignacion_TAG_Indicado AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_conversor_prg_a_bin__analizarAsignacion_TAG_Indicado OF ut__foxbin2prg__c_conversor_prg_a_bin__analizarAsignacion_TAG_Indicado.PRG
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

		THIS.icObj 	= NEWOBJECT("c_conversor_prg_a_bin", "FOXBIN2PRG.PRG")
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
			, tcPropName, tcPropValue, taProps, tnProp_Count ;
			, I, tcTag_I, tcTag_F, tnLen_lcTag_I, tnLen_lcTag_F, tcMemo, tcValue_Esperado

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF

		IF ISNULL(toEx)
			*-- Algunos ajustes para mejor visualización de caracteres especiales
			tcPropValue			= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcPropValue )
			tcValue_Esperado	= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcValue_Esperado )
		
			
			*-- Visualización de valores
			THIS.messageout( ' Value = ' + TRANSFORM(tcPropValue) )
			THIS.messageout( ' Value_Esperado = ' + TRANSFORM(tcValue_Esperado) )

			
			*-- Evaluación de valores
			THIS.assertequals( tcValue_Esperado, tcPropValue, "Valor devuelto" )

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_analizarAsignacion_TAG__fb2p_value__EnUnaAsignacion_InLine
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcPropName, lcPropValue, laProps(1,2), lnProp_Count, I, lcTag_I, lcTag_F, lnLen_lcTag_I, lnLen_lcTag_F, lcMemo ;
			, lcValue_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lcTag_I			= '<fb2p_value>'
		lcTag_F			= '</fb2p_value>'
		lnLen_lcTag_I	= LEN(lcTag_I)
		lnLen_lcTag_F	= LEN(lcTag_F)
		lnProp_Count	= 17
		DIMENSION laProps(lnProp_Count,2)
		laProps			= ''
		laProps( 1,1)	= 'Height = 2.73'
		laProps( 1,2)	= ''
		laProps( 2,1)	= 'Name = "c1"'
		laProps( 2,2)	= ''
		laProps( 3,1)	= 'prop1 = .F.'
		laProps( 3,2)	= 'Mi prop1'
		laProps( 4,1)	= 'prop_especial_cr = <fb2p_value>Este es el valor 1&#13;Este el 2&#13;Y este bajo Shift_Enter el 3</fb2p_value>'
		laProps( 4,2)	= ''
		laProps( 5,1)	= 'prop_especial_crlf = <fb2p_value>'
		laProps( 5,2)	= ''
		laProps( 6,1)	= 'El valor 1'
		laProps( 6,2)	= ''
		laProps( 7,1)	= 'El valor 2'
		laProps( 7,2)	= ''
		laProps( 8,1)	= 'Y el 3!'
		laProps( 8,2)	= ''
		laProps( 9,1)	= ''
		laProps( 9,2)	= ''
		laProps(10,1)	= '</fb2p_value>'
		laProps(10,2)	= ''
		laProps(11,2)	= 'Debería tener CR+LF'
		laProps(11,2)	= ''
		laProps(12,1)	= 'Width = 27.4'
		laProps(12,2)	= ''
		laProps(13,1)	= '_memberdata = [<VFPData> ;'
		laProps(13,2)	= ''
		laProps(14,1)	= '<memberdata name="mimetodo" display="miMetodo"/> ;'
		laProps(14,2)	= ''
		laProps(15,1)	= '</VFPData>]'
		laProps(15,2)	= 'XML Metadata for customizable properties'
		I				= 4
		loObj.get_SeparatedPropAndValue( laProps(I,1), @lcPropName, @lcPropValue )
		*lcPropName		= 'prop_especial_cr'
		*lcPropValue 	= '<fb2p_value>Este es el valor 1&#13;Este el 2&#13;Y este bajo Shift_Enter el 3</fb2p_value>'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcValue_Esperado	= REPLICATE( CHR(1), 517 ) + STR(57,8) + 'Este es el valor 1' + CHR(13) + 'Este el 2' + CHR(13) + 'Y este bajo Shift_Enter el 3'

		*-- TEST
		loObj.analizarAsignacion_TAG_Indicado( @lcPropName, @lcPropValue, @laProps, @lnProp_Count ;
			, @I, lcTag_I, lcTag_F, lnLen_lcTag_I, lnLen_lcTag_F )

		THIS.Evaluate_results( loEx, lnCodError_Esperado ;
			, @lcPropName, @lcPropValue, @laProps, @lnProp_Count ;
			, @I, lcTag_I, lcTag_F, lnLen_lcTag_I, lnLen_lcTag_F, @lcMemo, @lcValue_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_analizarAsignacion_TAG__fb2p_value__EnUnaAsignacion_MultiLine
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcPropName, lcPropValue, laProps(1,2), lnProp_Count, I, lcTag_I, lcTag_F, lnLen_lcTag_I, lnLen_lcTag_F, lcMemo ;
			, lcValue_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lcTag_I			= '<fb2p_value>'
		lcTag_F			= '</fb2p_value>'
		lnLen_lcTag_I	= LEN(lcTag_I)
		lnLen_lcTag_F	= LEN(lcTag_F)
		lnProp_Count	= 17
		DIMENSION laProps(lnProp_Count,2)
		laProps			= ''
		laProps( 1,1)	= 'Height = 2.73'
		laProps( 1,2)	= ''
		laProps( 2,1)	= 'Name = "c1"'
		laProps( 2,2)	= ''
		laProps( 3,1)	= 'prop1 = .F.'
		laProps( 3,2)	= 'Mi prop1'
		laProps( 4,1)	= 'prop_especial_cr = <fb2p_value>Este es el valor 1&#13;Este el 2&#13;Y este bajo Shift_Enter el 3</fb2p_value>'
		laProps( 4,2)	= ''
		laProps( 5,1)	= 'prop_especial_crlf = <fb2p_value>'
		laProps( 5,2)	= ''
		laProps( 6,1)	= 'El valor 1'
		laProps( 6,2)	= ''
		laProps( 7,1)	= 'El valor 2'
		laProps( 7,2)	= ''
		laProps( 8,1)	= 'Y el 3!'
		laProps( 8,2)	= ''
		laProps( 9,1)	= ''
		laProps( 9,2)	= ''
		laProps(10,1)	= '</fb2p_value>'
		laProps(10,2)	= ''
		laProps(11,2)	= 'Debería tener CR+LF'
		laProps(11,2)	= ''
		laProps(12,1)	= 'Width = 27.4'
		laProps(12,2)	= ''
		laProps(13,1)	= '_memberdata = [<VFPData> ;'
		laProps(13,2)	= ''
		laProps(14,1)	= '<memberdata name="mimetodo" display="miMetodo"/> ;'
		laProps(14,2)	= ''
		laProps(15,1)	= '</VFPData>]'
		laProps(15,2)	= 'XML Metadata for customizable properties'
		I				= 5
		loObj.get_SeparatedPropAndValue( laProps(I,1), @lcPropName, @lcPropValue )

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcValue_Esperado	= REPLICATE( CHR(1), 517 ) + STR(33,8) + 'El valor 1' + CR_LF + 'El valor 2' + CR_LF + 'Y el 3!' + CR_LF

		*-- TEST
		loObj.analizarAsignacion_TAG_Indicado( @lcPropName, @lcPropValue, @laProps, @lnProp_Count ;
			, @I, lcTag_I, lcTag_F, lnLen_lcTag_I, lnLen_lcTag_F )

		THIS.Evaluate_results( loEx, lnCodError_Esperado ;
			, @lcPropName, @lcPropValue, @laProps, @lnProp_Count ;
			, @I, lcTag_I, lcTag_F, lnLen_lcTag_I, lnLen_lcTag_F, @lcMemo, @lcValue_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_analizarAsignacion_TAG__memberdata__EnUnaAsignacion_MultiLine
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcPropName, lcPropValue, laProps(1,2), lnProp_Count, I, lcTag_I, lcTag_F, lnLen_lcTag_I, lnLen_lcTag_F, lcMemo ;
			, lcValue_Esperado, lcMemberdata ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lcTag_I			= '<VFPData>'
		lcTag_F			= '</VFPData>'
		lnLen_lcTag_I	= LEN(lcTag_I)
		lnLen_lcTag_F	= LEN(lcTag_F)
		lnProp_Count	= 17
		lcMemberdata	= '<memberdata name="mimetodo_1" display="miMetodo_1"/>' + CR_LF
		lcMemberdata	= lcMemberdata + '<memberdata name="mimetodo_2" display="miMetodo_2"/>' + CR_LF
		lcMemberdata	= lcMemberdata + '<memberdata name="mimetodo_3" display="miMetodo_3"/>' + CR_LF
		lcMemberdata	= lcMemberdata + '<memberdata name="mimetodo_4" display="miMetodo_4"/>' + CR_LF
		lcMemberdata	= lcMemberdata + '<memberdata name="mimetodo_5" display="miMetodo_5"/>' + CR_LF
		lcMemberdata	= lcMemberdata + '<memberdata name="mimetodo_6" display="miMetodo_6"/>'
		DIMENSION laProps(lnProp_Count,2)
		laProps			= ''
		laProps( 1,1)	= 'Height = 2.73'
		laProps( 1,2)	= ''
		laProps( 2,1)	= 'Name = "c1"'
		laProps( 2,2)	= ''
		laProps( 3,1)	= 'prop1 = .F.'
		laProps( 3,2)	= 'Mi prop1'
		laProps( 4,1)	= 'prop_especial_cr = <fb2p_value>Este es el valor 1&#13;Este el 2&#13;Y este bajo Shift_Enter el 3</fb2p_value>'
		laProps( 4,2)	= ''
		laProps( 5,1)	= 'prop_especial_crlf = <fb2p_value>'
		laProps( 5,2)	= ''
		laProps( 6,1)	= 'El valor 1'
		laProps( 6,2)	= ''
		laProps( 7,1)	= 'El valor 2'
		laProps( 7,2)	= ''
		laProps( 8,1)	= 'Y el 3!'
		laProps( 8,2)	= ''
		laProps( 9,1)	= ''
		laProps( 9,2)	= ''
		laProps(10,1)	= '</fb2p_value>'
		laProps(10,2)	= ''
		laProps(11,2)	= 'Debería tener CR+LF'
		laProps(11,2)	= ''
		laProps(12,1)	= 'Width = 27.4'
		laProps(12,2)	= ''
		laProps(13,1)	= '_memberdata = <VFPData>'
		laProps(13,2)	= ''
		laProps(14,1)	= lcMemberdata
		laProps(14,2)	= ''
		laProps(15,1)	= '</VFPData>'
		laProps(15,2)	= 'XML Metadata for customizable properties'
		I				= 13
		loObj.get_SeparatedPropAndValue( laProps(I,1), @lcPropName, @lcPropValue )

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcValue_Esperado	= REPLICATE( CHR(1), 517 ) + STR(23 + LEN(lcMemberdata),8) + '<VFPData>' + CR_LF + lcMemberdata + CR_LF + '</VFPData>'

		*-- TEST
		loObj.analizarAsignacion_TAG_Indicado( @lcPropName, @lcPropValue, @laProps, @lnProp_Count ;
			, @I, lcTag_I, lcTag_F, lnLen_lcTag_I, lnLen_lcTag_F )

		THIS.Evaluate_results( loEx, lnCodError_Esperado ;
			, @lcPropName, @lcPropValue, @laProps, @lnProp_Count ;
			, @I, lcTag_I, lcTag_F, lnLen_lcTag_I, lnLen_lcTag_F, @lcMemo, @lcValue_Esperado )

	ENDFUNC


ENDDEFINE

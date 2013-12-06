DEFINE CLASS ut__foxbin2prg__c_conversor_bin_a_prg__get_PropsAndValuesFrom_PROPERTIES AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_conversor_bin_a_prg__get_PropsAndValuesFrom_PROPERTIES OF ut__foxbin2prg__c_conversor_bin_a_prg__get_PropsAndValuesFrom_PROPERTIES.PRG
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
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado ;
			, tcMemo, tnSort, taPropsAndValues, tnPropsAndValues_Count, tcSortedMemo ;
			, taPropsAndValues_Esperado, tnPropsAndValues_Count_Esperado, tcMemo_Esperado

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
			tcSortedMemo	= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcSortedMemo )
			tcMemo_Esperado	= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcMemo_Esperado )
			FOR I = 1 TO tnPropsAndValues_Count
				taPropsAndValues(I,2)	= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( TRANSFORM(taPropsAndValues(I,2)) )
			ENDFOR
			FOR I = 1 TO tnPropsAndValues_Count_Esperado
				taPropsAndValues_Esperado(I,2)	= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( TRANSFORM(taPropsAndValues_Esperado(I,2)) )
			ENDFOR
		
			
			*-- Visualización de valores
			THIS.messageout( ' Sort = ' + TRANSFORM(tnSort) )
			THIS.messageout( REPLICATE('-',50) )
			FOR I = 1 TO tnPropsAndValues_Count
				THIS.messageout( "taPropsAndValues(" + STR(I,3) + '): ' ;
					+ TRANSFORM(taPropsAndValues(I,1)) + ' = ' + TRANSFORM(taPropsAndValues(I,2)) + '' )
			ENDFOR
			THIS.messageout( REPLICATE('-',50) )
			FOR I = 1 TO tnPropsAndValues_Count_Esperado
				THIS.messageout( "taPropsAndValues_Esp(" + STR(I,3) + '): ' ;
					+ TRANSFORM(taPropsAndValues_Esperado(I,1)) + ' = ' + TRANSFORM(taPropsAndValues_Esperado(I,2)) + '' )
			ENDFOR
			THIS.messageout( REPLICATE('-',50) )
			THIS.messageout( 'Sorted Memo: [' + tcSortedMemo + ']' )

			
			*-- Evaluación de valores
			THIS.assertequals( tnPropsAndValues_Count_Esperado, tnPropsAndValues_Count, "PropsAndValues_Count" )

			FOR I = 1 TO MIN(tnPropsAndValues_Count, tnPropsAndValues_Count_Esperado)
				THIS.assertequals( taPropsAndValues_Esperado(I,1), taPropsAndValues(I,1), "PropAndValue" )
			ENDFOR

			THIS.assertequals( tcMemo_Esperado, tcSortedMemo, "Memo" )

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_evaluarUnMemo_PROPERTIES_yDevolverUnArrayConLasPropsOrdenadas_PrimeroLasNormalesYLuegoLasDeObjeto_Sorted
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lnSort, laPropsAndValues(1,2), lnPropsAndValues_Count, lcMemo, lcSortedMemo ;
			, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado, lcMemo_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError

		TEXT TO lcMemo TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
			Height =   2.73
			Width =  27.40
			prop1 = .F.
			_memberdata = <VFPData><memberdata name="mimetodo" display="miMetodo"/></VFPData>
			prop_especial_cr = <<REPLICATE( CHR(1), 517 )>>      57Este es el valor 1&#13;Este el 2&#10;Y este bajo Shift_Enter el 3
			prop_especial_crlf = <<REPLICATE( CHR(1), 517 )>>      35El valor 1
			El valor 2
			Y el 3!
			<<SPACE(2)>>
			Name = "c1"
			Page2.Caption = "Page2"
			Page1.Name = "Page1"
		ENDTEXT

		lcMemo = STRTRAN( STRTRAN( lcMemo, '&#13;', CHR(13) ), '&#10;', CHR(10) )
		lnSort					= 1

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		DIMENSION laPropsAndValues_Esperado(9,2)
		laPropsAndValues_Esperado		= ''
		laPropsAndValues_Esperado( 1,1)	= 'Height'
		laPropsAndValues_Esperado( 1,2)	= '2.73'
		laPropsAndValues_Esperado( 2,1)	= 'Name'
		laPropsAndValues_Esperado( 2,2)	= '"c1"'
		laPropsAndValues_Esperado( 3,1)	= 'prop1'
		laPropsAndValues_Esperado( 3,2)	= '.F.'
		laPropsAndValues_Esperado( 4,1)	= 'prop_especial_cr'
		laPropsAndValues_Esperado( 4,2)	= 'Este es el valor 1' + CHR(13) + 'Este el 2' + CHR(13) + 'Y este bajo Shift_Enter el 3'
		laPropsAndValues_Esperado( 5,1)	= 'prop_especial_crlf'
		laPropsAndValues_Esperado( 5,2)	= 'El valor 1' + CHR(13) + CHR(10) ;
			+ 'El valor 2' + CHR(13) + CHR(10) + 'Y el 3!' + CHR(13) + CHR(10) + SPACE(2)
		laPropsAndValues_Esperado( 6,1)	= 'Width'
		laPropsAndValues_Esperado( 6,2)	= '27.40'
		laPropsAndValues_Esperado( 7,1)	= '_memberdata'
		laPropsAndValues_Esperado( 7,2)	= '<VFPData><memberdata name="mimetodo" display="miMetodo"/></VFPData>'
		laPropsAndValues_Esperado( 8,1)	= 'Page1.Name'
		laPropsAndValues_Esperado( 8,2)	= '"Page1"'
		laPropsAndValues_Esperado( 9,1)	= 'Page2.Caption'
		laPropsAndValues_Esperado( 9,2)	= '"Page2"'
		lnPropsAndValues_Count_Esperado	= 9

		TEXT TO lcMemo_Esperado TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
			Height = 2.73
			Name = "c1"
			prop1 = .F.
			prop_especial_cr = <fb2p_value>Este es el valor 1&#13;Este el 2&#10;Y este bajo Shift_Enter el 3</fb2p_value>
			prop_especial_crlf = <fb2p_value>
			El valor 1
			El valor 2
			Y el 3!
			<<SPACE(2)>>
			</fb2p_value>
			Width = 27.40
			_memberdata = <VFPData>
			<<>>		<memberdata name="mimetodo" display="miMetodo"/>
			<<>>		</VFPData>
			Page1.Name = "Page1"
			Page2.Caption = "Page2"

		ENDTEXT


		*-- TEST
		loObj.get_PropsAndValuesFrom_PROPERTIES( @lcMemo, lnSort, @laPropsAndValues, @lnPropsAndValues_Count, @lcSortedMemo )

		THIS.Evaluate_results( loEx, lnCodError_Esperado ;
			, @lcMemo, lnSort, @laPropsAndValues, @lnPropsAndValues_Count, @lcSortedMemo ;
			, @laPropsAndValues_Esperado, @lnPropsAndValues_Count_Esperado, @lcMemo_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_evaluarUnMemo_PROPERTIES_yDevolverUnArrayConLasPropsSinOrdenar_PrimeroLasNormalesYLuegoLasDeObjeto
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lnSort, laPropsAndValues(1,2), lnPropsAndValues_Count, lcMemo, lcSortedMemo ;
			, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado, lcMemo_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError

		TEXT TO lcMemo TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
			Height =   2.73
			Width =  27.40
			prop1 = .F.
			_memberdata = <VFPData><memberdata name="mimetodo" display="miMetodo"/></VFPData>
			prop_especial_cr = <<REPLICATE( CHR(1), 517 )>>      57Este es el valor 1&#13;Este el 2&#10;Y este bajo Shift_Enter el 3
			prop_especial_crlf = <<REPLICATE( CHR(1), 517 )>>      35El valor 1
			El valor 2
			Y el 3!
			<<SPACE(2)>>
			Name = "c1"
			Page2.Caption = "Page2"
			Page1.Name = "Page1"
		ENDTEXT

		lcMemo = STRTRAN( STRTRAN( lcMemo, '&#13;', CHR(13) ), '&#10;', CHR(10) )
		lnSort					= 0


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		DIMENSION laPropsAndValues_Esperado(9,2)
		laPropsAndValues_Esperado		= ''
		laPropsAndValues_Esperado( 1,1)	= 'Height'
		laPropsAndValues_Esperado( 1,2)	= '2.73'
		laPropsAndValues_Esperado( 2,1)	= 'Width'
		laPropsAndValues_Esperado( 2,2)	= '27.40'
		laPropsAndValues_Esperado( 3,1)	= 'prop1'
		laPropsAndValues_Esperado( 3,2)	= '.F.'
		laPropsAndValues_Esperado( 4,1)	= '_memberdata'
		laPropsAndValues_Esperado( 4,2)	= '<VFPData><memberdata name="mimetodo" display="miMetodo"/></VFPData>'
		laPropsAndValues_Esperado( 5,1)	= 'prop_especial_cr'
		laPropsAndValues_Esperado( 5,2)	= 'Este es el valor 1' + C_CR + 'Este el 2' + C_LF + 'Y este bajo Shift_Enter el 3'
		laPropsAndValues_Esperado( 6,1)	= 'prop_especial_crlf'
		laPropsAndValues_Esperado( 6,2)	= 'El valor 1' + CR_LF ;
			+ 'El valor 2' + CR_LF + 'Y el 3!' + CR_LF + SPACE(2)
		laPropsAndValues_Esperado( 7,1)	= 'Name'
		laPropsAndValues_Esperado( 7,2)	= '"c1"'
		laPropsAndValues_Esperado( 8,1)	= 'Page2.Caption'
		laPropsAndValues_Esperado( 8,2)	= '"Page2"'
		laPropsAndValues_Esperado( 9,1)	= 'Page1.Name'
		laPropsAndValues_Esperado( 9,2)	= '"Page1"'
		lnPropsAndValues_Count_Esperado	= 9

		TEXT TO lcMemo_Esperado TEXTMERGE NOSHOW FLAGS 1 PRETEXT 1+2
			Height = 2.73
			Width = 27.40
			prop1 = .F.
			_memberdata = <VFPData>
			<<>>		<memberdata name="mimetodo" display="miMetodo"/>
			<<>>		</VFPData>
			prop_especial_cr = <fb2p_value>Este es el valor 1&#13;Este el 2&#10;Y este bajo Shift_Enter el 3</fb2p_value>
			prop_especial_crlf = <fb2p_value>
			El valor 1
			El valor 2
			Y el 3!
			<<SPACE(2)>>
			</fb2p_value>
			Name = "c1"
			Page2.Caption = "Page2"
			Page1.Name = "Page1"

		ENDTEXT


		*-- TEST
		loObj.get_PropsAndValuesFrom_PROPERTIES( @lcMemo, lnSort, @laPropsAndValues, @lnPropsAndValues_Count, @lcSortedMemo )

		THIS.Evaluate_results( loEx, lnCodError_Esperado ;
			, @lcMemo, lnSort, @laPropsAndValues, @lnPropsAndValues_Count, @lcSortedMemo ;
			, @laPropsAndValues_Esperado, @lnPropsAndValues_Count_Esperado, @lcMemo_Esperado )

	ENDFUNC


ENDDEFINE

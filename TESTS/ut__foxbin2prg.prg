DEFINE CLASS ut__foxbin2prg AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg OF ut__foxbin2prg.prg
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
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado ;
			, tc_InputFile, taPropsAndValues, tnPropsAndValues_Count ;
			, taPropsAndValues_Esperado, tnPropsAndValues_Count_Esperado, tcParent, tcClass, tcObjName

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		*LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		*loObj		= THIS.icObj

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF

		IF ISNULL(toEx)
			*-- Algunos ajustes para mejor visualización de caracteres especiales
			*tcPropValue				= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcPropValue )


			*-- Visualización de valores
			THIS.messageout( LOWER(PROGRAM(PROGRAM(-1)-1)) )
			THIS.messageout( '' )
			THIS.messageout( 'Propiedades esperadas para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' )
			THIS.messageout( REPLICATE('-',80) )
			FOR I = 1 TO tnPropsAndValues_Count_Esperado
				THIS.messageout( 'PropName = ' + TRANSFORM(taPropsAndValues_Esperado(I,1)) )
			ENDFOR


			*-- Evaluación de valores
			THIS.assertequals( tnPropsAndValues_Count_Esperado, tnPropsAndValues_Count, "Cantidad de propiedades" )
			FOR I = 1 TO tnPropsAndValues_Count_Esperado
				THIS.asserttrue( ASCAN( taPropsAndValues, taPropsAndValues_Esperado(I,1), 1, -1, 1, 0+2+4) > 0, ' Comprobación de que existe la propiedad "' + TRANSFORM(taPropsAndValues_Esperado(I,1)) + '"' )
			ENDFOR

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__dataenvironment
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('dataenvironment')
		lcParent						= ''
		lcObjName						= 'Dataenvironment'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Top = 404
			Left = 11
			Width = 520
			Height = 200
			DataSource = .NULL.
			Name = "Dataenvironment"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__dataenvironment__Cursor1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('cursor')
		lcParent						= 'Dataenvironment'
		lcObjName						= 'Cursor1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Top = 20
			Left = 10
			Height = 98
			Width = 102
			Alias = "encuestas"
			CursorSource = encuestas.dbf
			Name = "Cursor1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('cl_form')
		lcParent						= ''
		lcObjName						= 'Cl_form1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Top = 0
			Left = 0
			Height = 345
			Width = 644
			DoCreate = .T.
			Name = "Cl_form1"
			Cl_optiongroup1.Option1.Value = 0
			Cl_optiongroup1.Option1.Left = 8
			Cl_optiongroup1.Option1.Top = 8
			Cl_optiongroup1.Option1.Name = "Option1"
			Cl_optiongroup1.Option2.Value = 1
			Cl_optiongroup1.Option2.Left = 124
			Cl_optiongroup1.Option2.Top = 8
			Cl_optiongroup1.Option2.Name = "Option2"
			Cl_optiongroup1.Value = 2
			Cl_optiongroup1.ZOrderSet = 1
			Cl_optiongroup1.propiedad_de_clase_sin_valor = Valor reescrito en el form!
			Cl_optiongroup1.Name = "Cl_optiongroup1"
			Cl_commandgroup1.Command1.Top = 4
			Cl_commandgroup1.Command1.Left = 8
			Cl_commandgroup1.Command1.Name = "Command1"
			Cl_commandgroup1.Command2.Top = 4
			Cl_commandgroup1.Command2.Left = 124
			Cl_commandgroup1.Command2.Name = "Command2"
			Cl_commandgroup1.ZOrderSet = 2
			Cl_commandgroup1.una_prop_cmgroup = Ahora tiene valor
			Cl_commandgroup1.Name = "Cl_commandgroup1"
			Cl_imagen1.Left = 268
			Cl_imagen1.Top = 292
			Cl_imagen1.ZOrderSet = 3
			Cl_imagen1.Name = "Cl_imagen1"
			Cl_imagen2.Left = 316
			Cl_imagen2.Top = 292
			Cl_imagen2.ZOrderSet = 4
			Cl_imagen2.Name = "Cl_imagen2"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__shape1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('shape')
		lcParent						= 'Cl_form1'
		lcObjName						= 'Shape1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Top = 284
			Left = 264
			Height = 49
			Width = 101
			BorderStyle = 2
			BorderWidth = 1
			Curvature = 16
			SpecialEffect = 0
			ZOrderSet = 0
			Name = "Shape1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__txtPromotor
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('textbox')
		lcParent						= 'Cl_form1'
		lcObjName						= 'txtPromotor'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Comment = ""
			ControlSource = "encuestas.promotor"
			Height = 23
			Left = 328
			MaxLength = 20
			ReadOnly = .T.
			TabIndex = 4
			Top = 164
			Width = 149
			ForeColor = 0,0,255
			DisabledForeColor = 0,0,160
			ZOrderSet = 5
			Name = "txtPromotor"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__lblPromotor
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('label')
		lcParent						= 'Cl_form1'
		lcObjName						= 'lblPromotor'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			AutoSize = .T.
			WordWrap = .T.
			BackStyle = 0
			Caption = "Promotor"
			Left = 271
			Top = 164
			Width = 51
			TabIndex = 3
			ZOrderSet = 6
			Name = "lblPromotor"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__txtIdenc
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('textbox')
		lcParent						= 'Cl_form1'
		lcObjName						= 'txtIdenc'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Comment = ""
			ControlSource = "encuestas.idenc"
			Height = 23
			Left = 328
			MaxLength = 20
			ReadOnly = .T.
			TabIndex = 6
			Top = 192
			Width = 149
			ForeColor = 0,0,255
			DisabledForeColor = 0,0,160
			ZOrderSet = 7
			Name = "txtIdenc"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__lblIdenc
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('label')
		lcParent						= 'Cl_form1'
		lcObjName						= 'lblIdenc'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			AutoSize = .T.
			WordWrap = .T.
			BackStyle = 0
			Caption = "Idenc"
			Left = 292
			Top = 192
			Width = 30
			TabIndex = 5
			ZOrderSet = 8
			Name = "lblIdenc"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__txtCalific
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('textbox')
		lcParent						= 'Cl_form1'
		lcObjName						= 'txtCalific'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Comment = ""
			ControlSource = "encuestas.calific"
			Height = 23
			Left = 532
			MaxLength = 2
			ReadOnly = .T.
			TabIndex = 8
			Top = 164
			Width = 38
			ForeColor = 0,0,255
			DisabledForeColor = 0,0,160
			ZOrderSet = 9
			Name = "txtCalific"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__lblCalific
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('label')
		lcParent						= 'Cl_form1'
		lcObjName						= 'lblCalific'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			AutoSize = .T.
			WordWrap = .T.
			BackStyle = 0
			Caption = "Calific"
			Left = 491
			Top = 164
			Width = 34
			TabIndex = 7
			ZOrderSet = 10
			Name = "lblCalific"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__lblCalific
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('textbox')
		lcParent						= 'Cl_form1'
		lcObjName						= 'txtFecha'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Comment = ""
			ControlSource = "encuestas.fecha"
			Height = 23
			Left = 532
			ReadOnly = .T.
			TabIndex = 10
			Top = 192
			Width = 73
			ForeColor = 0,0,255
			DisabledForeColor = 0,0,160
			ZOrderSet = 11
			Name = "txtFecha"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__lblFecha
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('label')
		lcParent						= 'Cl_form1'
		lcObjName						= 'lblFecha'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			AutoSize = .T.
			WordWrap = .T.
			BackStyle = 0
			Caption = "Fecha"
			Left = 491
			Top = 192
			Width = 34
			TabIndex = 9
			ZOrderSet = 12
			Name = "lblFecha"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__txtResultado
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('textbox')
		lcParent						= 'Cl_form1'
		lcObjName						= 'txtResultado'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Comment = ""
			ControlSource = "encuestas.resultado"
			Height = 23
			Left = 532
			MaxLength = 10
			ReadOnly = .T.
			TabIndex = 12
			Top = 220
			Width = 81
			ForeColor = 0,0,255
			DisabledForeColor = 0,0,160
			ZOrderSet = 13
			Name = "txtResultado"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__lblResultado
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('label')
		lcParent						= 'Cl_form1'
		lcObjName						= 'lblResultado'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			AutoSize = .T.
			WordWrap = .T.
			BackStyle = 0
			Caption = "Resultado"
			Left = 472
			Top = 220
			Width = 57
			TabIndex = 11
			ZOrderSet = 14
			Name = "lblResultado"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1__grdEncuestas
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('grid')
		lcParent						= 'Cl_form1'
		lcObjName						= 'grdEncuestas'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			ColumnCount = 5
			DeleteMark = .F.
			Height = 140
			Left = 268
			Panel = 1
			ReadOnly = .T.
			RecordSource = "encuestas"
			RecordSourceType = 1
			Top = 12
			Width = 320
			ZOrderSet = 15
			Name = "grdEncuestas"
			Column1.ControlSource = "encuestas.promotor"
			Column1.Width = 58
			Column1.ReadOnly = .T.
			Column1.Name = "Column1"
			Column2.ControlSource = "encuestas.idenc"
			Column2.Width = 46
			Column2.ReadOnly = .T.
			Column2.Name = "Column2"
			Column3.ControlSource = "encuestas.calific"
			Column3.Width = 41
			Column3.ReadOnly = .T.
			Column3.Name = "Column3"
			Column4.ControlSource = "encuestas.fecha"
			Column4.Width = 69
			Column4.ReadOnly = .T.
			Column4.Name = "Column4"
			Column5.ControlSource = "encuestas.resultado"
			Column5.Width = 58
			Column5.ReadOnly = .T.
			Column5.Name = "Column5"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1_grdEncuestas_Column1__Header1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('header')
		lcParent						= 'Cl_form1.grdEncuestas.Column1'
		lcObjName						= 'Header1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Caption = "promotor"
			Name = "Header1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1_grdEncuestas_Column1__Text1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('textbox')
		lcParent						= 'Cl_form1.grdEncuestas.Column1'
		lcObjName						= 'Text1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			BorderStyle = 0
			Margin = 0
			ReadOnly = .T.
			ForeColor = 0,0,0
			BackColor = 255,255,255
			Name = "Text1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1_grdEncuestas_Column2__Header1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('header')
		lcParent						= 'Cl_form1.grdEncuestas.Column2'
		lcObjName						= 'Header1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Caption = "idenc"
			Name = "Header1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1_grdEncuestas_Column2__Text1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('textbox')
		lcParent						= 'Cl_form1.grdEncuestas.Column2'
		lcObjName						= 'Text1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			BorderStyle = 0
			Margin = 0
			ReadOnly = .T.
			ForeColor = 0,0,0
			BackColor = 255,255,255
			Name = "Text1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1_grdEncuestas_Column3__Header1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('header')
		lcParent						= 'Cl_form1.grdEncuestas.Column3'
		lcObjName						= 'Header1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Caption = "calific"
			Name = "Header1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1_grdEncuestas_Column3__Text1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('textbox')
		lcParent						= 'Cl_form1.grdEncuestas.Column3'
		lcObjName						= 'Text1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			BorderStyle = 0
			Margin = 0
			ReadOnly = .T.
			ForeColor = 0,0,0
			BackColor = 255,255,255
			Name = "Text1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1_grdEncuestas_Column4__Header1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('header')
		lcParent						= 'Cl_form1.grdEncuestas.Column4'
		lcObjName						= 'Header1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Caption = "fecha"
			Name = "Header1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1_grdEncuestas_Column4__Text1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('textbox')
		lcParent						= 'Cl_form1.grdEncuestas.Column4'
		lcObjName						= 'Text1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			BorderStyle = 0
			Margin = 0
			ReadOnly = .T.
			ForeColor = 0,0,0
			BackColor = 255,255,255
			Name = "Text1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1_grdEncuestas_Column5__Header1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('header')
		lcParent						= 'Cl_form1.grdEncuestas.Column5'
		lcObjName						= 'Header1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Caption = "resultado"
			Name = "Header1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1_grdEncuestas_Column5__Text1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('textbox')
		lcParent						= 'Cl_form1.grdEncuestas.Column5'
		lcObjName						= 'Text1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			BorderStyle = 0
			Margin = 0
			ReadOnly = .T.
			ForeColor = 0,0,0
			BackColor = 255,255,255
			Name = "Text1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1___Commandgroup1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('commandgroup')
		lcParent						= 'Cl_form1'
		lcObjName						= 'Commandgroup1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			ButtonCount = 2
			Value = 1
			Height = 76
			Left = 8
			Top = 172
			Width = 244
			BackColor = 255,128,255
			ZOrderSet = 16
			Name = "Commandgroup1"
			Command1.Top = 8
			Command1.Left = 12
			Command1.Height = 56
			Command1.Width = 100
			Command1.Picture = bmps\carpetaabierta.bmp
			Command1.Caption = "\<Abrir"
			Command1.Name = "Command1"
			Command2.Top = 8
			Command2.Left = 128
			Command2.Height = 56
			Command2.Width = 96
			Command2.Picture = bmps\carpetacerrada.bmp
			Command2.Caption = "\<Cerrar"
			Command2.Name = "Command2"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1___Optiongroup1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('Optiongroup')
		lcParent						= 'Cl_form1'
		lcObjName						= 'Optiongroup1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			ButtonCount = 2
			Value = 2
			Height = 72
			Left = 8
			Top = 256
			Width = 244
			BackColor = 0,128,255
			ZOrderSet = 17
			Name = "Optiongroup1"
			Option1.Picture = bmps\scccheckout.bmp
			Option1.Caption = "Option1"
			Option1.Value = 0
			Option1.Height = 48
			Option1.Left = 16
			Option1.Style = 1
			Option1.Top = 12
			Option1.Width = 92
			Option1.Name = "Option1"
			Option2.Picture = bmps\scccheckout.bmp
			Option2.Caption = "Option2"
			Option2.Value = 1
			Option2.Height = 48
			Option2.Left = 132
			Option2.Style = 1
			Option2.Top = 12
			Option2.Width = 88
			Option2.Name = "Option2"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarElCampo_PROPERTIES_ParaElObjeto__Cl_form1___Cl_olecontrol1
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
			, laDatos(1,1), lcParent, lcClass, lcObjName, lcMemo, laProps(1), lcProp, lcValue ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
		loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass							= LOWER('Cl_olecontrol')
		lcParent						= 'Cl_form1'
		lcObjName						= 'Cl_olecontrol1'

		TEXT TO lcMemo NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Top = 256
			Left = 484
			Height = 67
			Width = 131
			Name = "Cl_olecontrol1"
		ENDTEXT

		lnPropsAndValues_Count_Esperado	= ALINES( laProps, lcMemo, 1+4 )
		DIMENSION laPropsAndValues_Esperado(lnPropsAndValues_Count_Esperado,2)
		
		FOR I = 1 TO lnPropsAndValues_Count_Esperado
			loObj.get_SeparatedPropAndValue( laProps(I), @lcProp, @lcValue )
			laPropsAndValues_Esperado(I,1)	= lcProp
			laPropsAndValues_Esperado(I,2)	= lcValue
		ENDFOR


		*-- TEST
		DO FOXBIN2PRG.prg WITH lc_InputFile, lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress
		DO FOXBIN2PRG.prg WITH FORCEEXT(lc_InputFile,'VC2'), lcType_na, lcTextName_na, llGenText_na, lcDontShowErrors, lcDebug, lcDontShowProgress

		IF FILE(lc_InputFile)
			USE (lc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
		ELSE
			ERROR 'No se encontró el archivo "' + lc_InputFile + '"'
		ENDIF

		SELECT Properties FROM TABLABIN WHERE CLASS==lcClass AND PARENT==lcParent AND objName==lcObjName INTO ARRAY laDatos
		USE IN (SELECT("TABLABIN"))
		loObj.get_PropsAndValuesFrom_PROPERTIES( laDatos(1), 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, @laPropsAndValues, lnPropsAndValues_Count ;
			, @laPropsAndValues_Esperado, lnPropsAndValues_Count_Esperado, lcParent, lcClass, lcObjName )

	ENDFUNC


ENDDEFINE

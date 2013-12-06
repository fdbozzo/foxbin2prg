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
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado, tc_InputFile, tcParent, tcClass, tcObjName, toReg_Esperado

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		*LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		*loObj		= THIS.icObj

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF


		LOCAL lnCodError, lcTipoBinario, toReg ;
			, loModulo AS CL_CLASE OF "FOXBIN2PRG.PRG" ;
			, loCnv AS c_foxbin2prg OF "FOXBIN2PRG.PRG"

		*-- TEST
		TRY
			loCnv	= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loCnv.l_Debug		= .F.
			loCnv.l_ShowErrors	= .F.
			*loCnv.l_Test		= .T.
			lcTipoBinario		= UPPER( JUSTEXT( tc_InputFile ) )
			lnCodError	= loCnv.Convertir( tc_InputFile, @loModulo, @toEx )
			IF lnCodError > 0
				EXIT
			ENDIF

			DO CASE
			CASE lcTipoBinario = 'SCX'
				lnCodError	= loCnv.Convertir( FORCEEXT(tc_InputFile,'SC2'), @loModulo, @toEx )
			CASE lcTipoBinario = 'VCX'
				lnCodError	= loCnv.Convertir( FORCEEXT(tc_InputFile,'VC2'), @loModulo, @toEx )
			OTHERWISE
				ERROR 'Archivo [' + tc_InputFile + '] no contemplado en los tests!'
			ENDCASE

			IF lnCodError > 0
				EXIT
			ENDIF
			
			IF FILE(tc_InputFile)
				USE (tc_InputFile) SHARED NOUPDATE ALIAS TABLABIN
			ELSE
				ERROR 'No se encontró el archivo "' + tc_InputFile + '"'
			ENDIF

			IF EMPTY(tcParent) AND EMPTY(tcClass) AND EMPTY(tcObjName)
				DO CASE
				CASE lcTipoBinario = 'SCX'
					LOCATE FOR PLATFORM=="COMMENT " AND UniqueID=="Screen    "
				CASE lcTipoBinario = 'VCX'
					LOCATE FOR PLATFORM=="COMMENT " AND UniqueID=="Class     "
				ENDCASE
			ELSE
				LOCATE FOR CLASS==tcClass AND PARENT==tcParent AND objName==tcObjName
			ENDIF
			
			IF NOT FOUND()
				ERROR 'No se encontró el registro de cabecera "Screen"'
			ENDIF
			SCATTER MEMO NAME toReg

		CATCH TO toEx
		FINALLY
			USE IN (SELECT("TABLABIN"))
		ENDTRY


		IF ISNULL(toEx)
			LOCAL laPropsAndValues(1,2), lnPropsAndValues_Count, laPropsAndValues_Esperado(1,2), lnPropsAndValues_Count_Esperado ;
				, lnPropsAndComments_Count, lnPropsAndComments_Count_Esperado, laPropsAndComments(1,2), laPropsAndComments_Esperado(1,2) ;
				, laProtected(1), lnProtected_Count, laProtected_Esperado(1), lnProtected_Count_Esperado ;
				, laMethods(1,2), lnMethods_Count, laMethods_Esperado(1,2), lnMethods_Count_Esperado
			LOCAL loObj AS c_conversor_bin_a_prg OF "FOXBIN2PRG.PRG"
			
			*-- Algunos ajustes para mejor visualización de caracteres especiales
			*tcPropValue				= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcPropValue )
			loObj		= NEWOBJECT("c_conversor_bin_a_prg", "FOXBIN2PRG.PRG")

			*-- Reserved3
			loObj.get_PropsAndCommentsFrom_RESERVED3( toReg.RESERVED3, .F., @laPropsAndComments, @lnPropsAndComments_Count, '' )
			loObj.get_PropsAndCommentsFrom_RESERVED3( toReg_Esperado.RESERVED3, .F., @laPropsAndComments_Esperado, @lnPropsAndComments_Count_Esperado, '' )

			*-- Properties
			loObj.get_PropsAndValuesFrom_PROPERTIES( toReg.PROPERTIES, 0, @laPropsAndValues, @lnPropsAndValues_Count, '' )
			loObj.get_PropsAndValuesFrom_PROPERTIES( toReg_Esperado.PROPERTIES, 0, @laPropsAndValues_Esperado, @lnPropsAndValues_Count_Esperado, '' )
			
			*-- Protected
			loObj.get_PropsFrom_PROTECTED( toReg.PROTECTED, .F., @laProtected, @lnProtected_Count, '' )
			loObj.get_PropsFrom_PROTECTED( toReg_Esperado.PROTECTED, .F., @laProtected_Esperado, @lnProtected_Count_Esperado, '' )
			
			*-- Methods
			loObj.get_ADD_OBJECT_METHODS( toReg, toReg, '', @laMethods, '', @lnMethods_Count )
			loObj.get_ADD_OBJECT_METHODS( toReg_Esperado, toReg_Esperado, '', @laMethods_Esperado, '', @lnMethods_Count_Esperado )
			


			*-- Visualización de valores
			THIS.messageout( LOWER(PROGRAM(PROGRAM(-1)-1)) )

			THIS.messageout( '' )
			THIS.messageout( 'PROPERTIES esperadas para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' + TRANSFORM(lnPropsAndValues_Count_Esperado) )
			*THIS.messageout( REPLICATE('-',80) )
			*FOR I = 1 TO lnPropsAndValues_Count_Esperado
			*	THIS.messageout( 'PropName = ' + TRANSFORM(laPropsAndValues_Esperado(I,1)) )
			*ENDFOR

			THIS.messageout( '' )
			THIS.messageout( 'PROTECTED esperadas para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' + TRANSFORM(lnProtected_Count_Esperado) )
			*THIS.messageout( REPLICATE('-',80) )
			*FOR I = 1 TO lnProtected_Count_Esperado
			*	THIS.messageout( 'PropName = ' + TRANSFORM(laProtected_Esperado(I,1)) )
			*ENDFOR

			THIS.messageout( '' )
			THIS.messageout( 'RESERVED3 esperadas para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' + TRANSFORM(lnPropsAndComments_Count_Esperado) )
			*THIS.messageout( REPLICATE('-',80) )
			*FOR I = 1 TO lnPropsAndComments_Count_Esperado
			*	THIS.messageout( 'PropName = ' + TRANSFORM(laPropsAndComments_Esperado(I,1)) )
			*ENDFOR

			THIS.messageout( '' )
			THIS.messageout( 'METHODS esperadas para ' + tcParent + '.' + tcObjName + ' (' + tcClass + ')' + ': ' + TRANSFORM(lnMethods_Count_Esperado) )
			*THIS.messageout( REPLICATE('-',80) )
			*FOR I = 1 TO lnMethods_Count_Esperado
			*	THIS.messageout( 'Name = ' + TRANSFORM(laMethods_Esperado(I,1)) )
			*ENDFOR


			*-- Evaluación de valores
			*-- Reserved1
			THIS.assertequals( toReg_Esperado.Reserved1, toReg.Reserved1, "Valor de Reserved1" )

			*-- Reserved2
			THIS.assertequals( toReg_Esperado.Reserved2, toReg.Reserved2, "Valor de Reserved2" )

			*-- Reserved4
			THIS.assertequals( toReg_Esperado.Reserved4, toReg.Reserved4, "Valor de Reserved4" )

			*-- Reserved5
			THIS.assertequals( toReg_Esperado.Reserved5, toReg.Reserved5, "Valor de Reserved5" )

			*-- Reserved6
			THIS.assertequals( toReg_Esperado.Reserved6, toReg.Reserved6, "Valor de Reserved6" )

			*-- Reserved7
			THIS.assertequals( toReg_Esperado.Reserved7, toReg.Reserved7, "Valor de Reserved7" )

			*-- Reserved8
			THIS.assertequals( toReg_Esperado.Reserved8, toReg.Reserved8, "Valor de Reserved8" )

			*-- PROPERTIES
			THIS.assertequals( lnPropsAndValues_Count_Esperado, lnPropsAndValues_Count, "Cantidad de Properties" )
			FOR I = 1 TO lnPropsAndValues_Count_Esperado
				THIS.asserttrue( ASCAN( laPropsAndValues, laPropsAndValues_Esperado(I,1), 1, -1, 1, 0+2+4) > 0, ' Comprobación de que existe la Property "' + TRANSFORM(laPropsAndValues_Esperado(I,1)) + '"' )
			ENDFOR

			*-- RESERVED3
			THIS.assertequals( lnPropsAndComments_Count_Esperado, lnPropsAndComments_Count, "Cantidad de Reserved3" )
			FOR I = 1 TO lnPropsAndComments_Count_Esperado
				THIS.asserttrue( ASCAN( laPropsAndComments, laPropsAndComments_Esperado(I,1), 1, -1, 1, 0+2+4) > 0, ' Comprobación de que existe la Reserved3 "' + TRANSFORM(laPropsAndValues_Esperado(I,1)) + '"' )
			ENDFOR

			*-- PROTECTED
			THIS.assertequals( lnProtected_Count_Esperado, lnProtected_Count, "Cantidad de Protected" )
			FOR I = 1 TO lnProtected_Count_Esperado
				THIS.asserttrue( ASCAN( laProtected, laProtected_Esperado(I,1), 1, -1, 1, 0+2+4) > 0, ' Comprobación de que existe la Protected "' + TRANSFORM(laPropsAndValues_Esperado(I,1)) + '"' )
			ENDFOR

			*-- METHODS
			THIS.assertequals( lnMethods_Count_Esperado, lnMethods_Count, "Cantidad de Methods" )
			FOR I = 1 TO lnMethods_Count_Esperado
				THIS.asserttrue( ASCAN( laMethods, laMethods_Esperado(I,1), 1, -1, 1, 0+2+4) > 0, ' Comprobación de que existe el Method "' + TRANSFORM(laPropsAndValues_Esperado(I,1)) + '"' )
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
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElRegistroDeCabecera
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('')
		lcParent			= ''
		lcObjName			= ''
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		loReg_Esperado.Reserved1	= 'VERSION =   3.00'


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__dataenvironment
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('dataenvironment')
		lcParent			= ''
		lcObjName			= 'Dataenvironment'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		loReg_Esperado.Reserved2	= '2'
		loReg_Esperado.Reserved4	= '1'
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Top = 404
			Left = 11
			Width = 520
			Height = 200
			DataSource = .NULL.
			Name = "Dataenvironment"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__dataenvironment__Cursor1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('cursor')
		lcParent			= 'Dataenvironment'
		lcObjName			= 'Cursor1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Top = 20
			Left = 10
			Height = 98
			Width = 102
			Alias = "encuestas"
			CursorSource = encuestas.dbf
			Name = "Cursor1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('cl_form')
		lcParent			= ''
		lcObjName			= 'Cl_form1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__shape1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('shape')
		lcParent			= 'Cl_form1'
		lcObjName			= 'Shape1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__txtPromotor
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('textbox')
		lcParent			= 'Cl_form1'
		lcObjName			= 'txtPromotor'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__lblPromotor
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('label')
		lcParent			= 'Cl_form1'
		lcObjName			= 'lblPromotor'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__txtIdenc
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('textbox')
		lcParent			= 'Cl_form1'
		lcObjName			= 'txtIdenc'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__lblIdenc
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('label')
		lcParent			= 'Cl_form1'
		lcObjName			= 'lblIdenc'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__txtCalific
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('textbox')
		lcParent			= 'Cl_form1'
		lcObjName			= 'txtCalific'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__lblCalific
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('label')
		lcParent			= 'Cl_form1'
		lcObjName			= 'lblCalific'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__lblCalific
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('textbox')
		lcParent			= 'Cl_form1'
		lcObjName			= 'txtFecha'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__lblFecha
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('label')
		lcParent			= 'Cl_form1'
		lcObjName			= 'lblFecha'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__txtResultado
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('textbox')
		lcParent			= 'Cl_form1'
		lcObjName			= 'txtResultado'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__lblResultado
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('label')
		lcParent			= 'Cl_form1'
		lcObjName			= 'lblResultado'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1__grdEncuestas
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('grid')
		lcParent			= 'Cl_form1'
		lcObjName			= 'grdEncuestas'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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
		TEXT TO loReg_Esperado.Methods NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			<<'PROCEDURE AfterRowColChange'>>
			LPARAMETERS nColIndex

			thisform.Refresh()

			<<'ENDPROC'>>
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1_grdEncuestas_Column1__Header1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('header')
		lcParent			= 'Cl_form1.grdEncuestas.Column1'
		lcObjName			= 'Header1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Caption = "promotor"
			Name = "Header1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1_grdEncuestas_Column1__Text1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
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
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			BorderStyle = 0
			Margin = 0
			ReadOnly = .T.
			ForeColor = 0,0,0
			BackColor = 255,255,255
			Name = "Text1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1_grdEncuestas_Column2__Header1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('header')
		lcParent			= 'Cl_form1.grdEncuestas.Column2'
		lcObjName			= 'Header1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Caption = "idenc"
			Name = "Header1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1_grdEncuestas_Column2__Text1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('textbox')
		lcParent			= 'Cl_form1.grdEncuestas.Column2'
		lcObjName			= 'Text1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			BorderStyle = 0
			Margin = 0
			ReadOnly = .T.
			ForeColor = 0,0,0
			BackColor = 255,255,255
			Name = "Text1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1_grdEncuestas_Column3__Header1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('header')
		lcParent			= 'Cl_form1.grdEncuestas.Column3'
		lcObjName			= 'Header1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Caption = "calific"
			Name = "Header1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1_grdEncuestas_Column3__Text1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('textbox')
		lcParent			= 'Cl_form1.grdEncuestas.Column3'
		lcObjName			= 'Text1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			BorderStyle = 0
			Margin = 0
			ReadOnly = .T.
			ForeColor = 0,0,0
			BackColor = 255,255,255
			Name = "Text1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1_grdEncuestas_Column4__Header1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('header')
		lcParent			= 'Cl_form1.grdEncuestas.Column4'
		lcObjName			= 'Header1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Caption = "fecha"
			Name = "Header1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1_grdEncuestas_Column4__Text1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('textbox')
		lcParent			= 'Cl_form1.grdEncuestas.Column4'
		lcObjName			= 'Text1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			BorderStyle = 0
			Margin = 0
			ReadOnly = .T.
			ForeColor = 0,0,0
			BackColor = 255,255,255
			Name = "Text1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1_grdEncuestas_Column5__Header1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('header')
		lcParent			= 'Cl_form1.grdEncuestas.Column5'
		lcObjName			= 'Header1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Caption = "resultado"
			Name = "Header1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1_grdEncuestas_Column5__Text1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('textbox')
		lcParent			= 'Cl_form1.grdEncuestas.Column5'
		lcObjName			= 'Text1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			BorderStyle = 0
			Margin = 0
			ReadOnly = .T.
			ForeColor = 0,0,0
			BackColor = 255,255,255
			Name = "Text1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1___Commandgroup1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('commandgroup')
		lcParent			= 'Cl_form1'
		lcObjName			= 'Commandgroup1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1___Optiongroup1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('Optiongroup')
		lcParent			= 'Cl_form1'
		lcObjName			= 'Optiongroup1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
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


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaElForm_FB2P_SCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_form1___Cl_olecontrol1
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_FRM_1.SC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_frm_1.scx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('Cl_olecontrol')
		lcParent			= 'Cl_form1'
		lcObjName			= 'Cl_olecontrol1'
		oFXU_LIB.prepararObjetoReg_SCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Top = 256
			Left = 484
			Height = 67
			Width = 131
			Name = "Cl_olecontrol1"
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElRegistroDeCabecera
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('')
		lcParent			= ''
		lcObjName			= ''
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		loReg_Esperado.Reserved1	= 'VERSION =   3.00'


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto__Cl_optiongroup

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('optiongroup')
		lcParent			= ''
		lcObjName			= 'cl_optiongroup'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		loReg_Esperado.Reserved1	= 'Class'
		loReg_Esperado.Reserved2	= '1'
		TEXT TO loReg_Esperado.Reserved3 NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			propiedad_de_clase_con_valor Tiene un valor por defecto
			propiedad_de_clase_sin_valor Una propiedad sin valor para heredar
			*propiedad_de_clase_con_valor_access
			*propiedad_de_clase_con_valor_assign

		ENDTEXT
		loReg_Esperado.Reserved6	= 'Pixels'
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			ButtonCount = 2
			Value = 1
			Height = 46
			Width = 71
			propiedad_de_clase_con_valor = UN VALOR DE LA CLASE
			propiedad_de_clase_sin_valor = .F.
			Name = "cl_optiongroup"
			Option1.Caption = "Option1"
			Option1.Value = 1
			Option1.Height = 17
			Option1.Left = 5
			Option1.Top = 5
			Option1.Width = 61
			Option1.Name = "Option1"
			Option2.Caption = "Option2"
			Option2.Height = 17
			Option2.Left = 5
			Option2.Top = 24
			Option2.Width = 61
			Option2.Name = "Option2"

		ENDTEXT
		TEXT TO loReg_Esperado.METHODS NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			<<'PROCEDURE propiedad_de_clase_con_valor_access'>>
			*To do: Modify this routine for the Access method
			RETURN THIS.propiedad_de_clase_con_valor
			<<'ENDPROC'>>
			<<'PROCEDURE propiedad_de_clase_con_valor_assign'>>
			LPARAMETERS vNewVal
			*To do: Modify this routine for the Assign method
			THIS.propiedad_de_clase_con_valor = m.vNewVal

			<<'ENDPROC'>>

		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )
	ENDFUNC





	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto____cl_optiongroup

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('')
		lcParent			= ''
		lcObjName			= 'cl_optiongroup'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Arial, 0, 9, 5, 15, 12, 32, 3, 0
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

	ENDFUNC



	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto____cl_commandgroup

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('commandgroup')
		lcParent			= ''
		lcObjName			= 'cl_commandgroup'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		loReg_Esperado.Reserved1	= 'Class'
		loReg_Esperado.Reserved2	= '1'
		TEXT TO loReg_Esperado.Reserved3 NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			una_prop_cmgroup Con comentario, pero sin valor

		ENDTEXT
		loReg_Esperado.Reserved6	= 'Pixels'
		loReg_Esperado.Reserved7	= 'Descripción de cl_CommandGroup'
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			ButtonCount = 2
Value = 1
Height = 66
Width = 94
una_prop_cmgroup = .F.
Name = "cl_commandgroup"
Command1.Top = 5
Command1.Left = 5
Command1.Height = 27
Command1.Width = 84
Command1.Caption = "Command1"
Command1.Name = "Command1"
Command2.Top = 34
Command2.Left = 5
Command2.Height = 27
Command2.Width = 84
Command2.Caption = "Command2"
Command2.Name = "Command2"

		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

ENDFUNC



	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto____cl_commandgroup

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('')
		lcParent			= ''
		lcObjName			= 'cl_commandgroup'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Arial, 0, 9, 5, 15, 12, 32, 3, 0
		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

ENDFUNC



	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto____cl_imagen

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('image')
		lcParent			= ''
		lcObjName			= 'cl_imagen'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		loReg_Esperado.Reserved1	= 'Class'
		loReg_Esperado.Reserved2	= '1'
		loReg_Esperado.Reserved6	= 'Pixels'
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Picture = bmps\sobrepostal.bmp
Height = 16
Width = 17
Name = "cl_imagen"

		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

ENDFUNC



	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto____cl_imagen

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('')
		lcParent			= ''
		lcObjName			= 'cl_imagen'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

ENDFUNC



	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto____cl_form

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('form')
		lcParent			= ''
		lcObjName			= 'cl_form'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		loReg_Esperado.Reserved1	= 'Class'
		loReg_Esperado.Reserved2	= '5'
		loReg_Esperado.Reserved6	= 'Pixels'
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Top = 0
Left = 0
Height = 345
Width = 570
DoCreate = .T.
Caption = "Form"
Name = "cl_form"

		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

ENDFUNC



	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto__cl_form__Cl_optiongroup1

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('cl_optiongroup')
		lcParent			= 'cl_form'
		lcObjName			= 'Cl_optiongroup1'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Height = 68
Left = 8
Top = 12
Width = 244
BackColor = 0,128,255
Name = "Cl_optiongroup1"
Option1.Picture = bmps\scccheckout.bmp
Option1.Height = 52
Option1.Left = 8
Option1.Style = 1
Option1.Top = 8
Option1.Width = 104
Option1.Name = "Option1"
Option2.Picture = bmps\scccheckout.bmp
Option2.Height = 52
Option2.Left = 124
Option2.Style = 1
Option2.Top = 8
Option2.Width = 104
Option2.Name = "Option2"

		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

ENDFUNC



	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto__cl_form__Cl_commandgroup1

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('cl_commandgroup')
		lcParent			= 'cl_form'
		lcObjName			= 'Cl_commandgroup1'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Height = 66
Left = 8
Top = 88
Width = 244
BackColor = 255,128,192
Name = "Cl_commandgroup1"
Command1.Top = 4
Command1.Left = 8
Command1.Height = 52
Command1.Width = 104
Command1.Picture = bmps\carpetaabierta.bmp
Command1.Caption = "Abrir"
Command1.Name = "Command1"
Command2.Top = 4
Command2.Left = 124
Command2.Height = 52
Command2.Width = 104
Command2.Picture = bmps\carpetacerrada.bmp
Command2.Caption = "Cerrar"
Command2.Name = "Command2"

		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

ENDFUNC



	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto__cl_form__Cl_imagen1

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('cl_imagen')
		lcParent			= 'cl_form'
		lcObjName			= 'Cl_imagen1'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Picture = bmps\sobrepostal.bmp
Stretch = 1
Height = 34
Left = 452
Top = 276
Width = 38
Name = "Cl_imagen1"

		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

ENDFUNC



	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto__cl_form__Cl_imagen2

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('cl_imagen')
		lcParent			= 'cl_form'
		lcObjName			= 'Cl_imagen2'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Picture = bmps\treeview.bmp
Stretch = 1
Height = 34
Left = 500
Top = 276
Width = 38
Name = "Cl_imagen2"

		ENDTEXT


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

ENDFUNC



	*******************************************************************************************************************************************
	FUNCTION Deberia_Ejecutar_FOXBIN2PRG_ParaLaLibreria_FB2P_TEST_VCX_YValidarLosCampos_MEMO_ParaElObjeto____cl_olecontrol

		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_InputFile, lcDontShowErrors, lcDebug, lcDontShowProgress ;
			, lcParent, lcClass, lcObjName, loReg_Esperado ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		loEx		= NULL
		oFXU_LIB.copiarArchivosParaTest( 'FB2P_TEST.VC?' )


		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lc_InputFile		= 'TESTS\DATOS_TEST\fb2p_test.vcx'
		lcDontShowErrors	= '1'


		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcClass				= LOWER('olecontrol')
		lcParent			= ''
		lcObjName			= 'cl_olecontrol'
		oFXU_LIB.prepararObjetoReg_VCX(	@loReg_Esperado, lcClass, lcParent, lcObjName )
		loReg_Esperado.Reserved1	= 'Class'
		loReg_Esperado.Reserved2	= '1'
		loReg_Esperado.Reserved6	= 'Pixels'
		TEXT TO loReg_Esperado.Properties NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			Height = 67
Width = 131
Name = "cl_olecontrol"

		ENDTEXT
		TEXT TO loReg_Esperado.OLE2 NOSHOW FLAGS 1+2 PRETEXT 1+2+4
			OLEObject = C:\Windows\system32\richtx32.ocx

		ENDTEXT
		TEXT TO lcOLE TEXTMERGE NOSHOW FLAGS 1+2 PRETEXT 1+2+3
			0M8R4KGxGuEAAAAAAAAAAAAAAAAAAAAAPgADAP7/CQAGAAAAAAAAAAAAAAABAAAAAQAAAAAAAAAAEAAAAgAAAAEAAAD+////AAAAAAAAAAD////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9/////v////7////+/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////1IAbwBvAHQAIABFAG4AdAByAHkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWAAUA//////////8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADDfG05c8M4BAwAAAAACAAAAAAAAAwBPAGwAZQBPAGIAagBlAGMAdABEAGEAdABhAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB4AAgEDAAAAAgAAAP////8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzAAAAAAAAAADAEEAYwBjAGUAcwBzAE8AYgBqAFMAaQB0AGUARABhAHQAYQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJgACAP///////////////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAABPAAAAAAAAAAMAQwBoAGEAbgBnAGUAZABQAHIAbwBwAHMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcAAIA////////////////AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAAEoAAAAAAAAABAAAAAIAAAD+////BQAAAAYAAAD+////BwAAAP7///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9giHw7j9cbELm1BAIcAJQCIUM0EggAAACKDQAA7QYAACFDNBIBAAYAoAAAAAAA//8AAP//AQAAAAAAAAAAAAAATwAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAABcAAAA4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgcWhqIFp0dVFoYTtqZGZuW2lhZXRyIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAACADAAAAFJpZ2h0TWFyZ2luABEAAABODQAAAAcAAAAAAAAAAAAAAAUAAABUZXh0ABQAAABIAAAAAAsAAABPAAAAAAUAAIAAAAAAAAABAAAAAQABAAIACAAAAHtccnRmMVxhbnNpXGRlZmYwe1xmb250dGJse1xmMFxmbmlsXGxlY29udHJvbDEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABmY2hhcnNldDAgQXJpYWw7fX0NClx2aWV3a2luZDRcdWMxXHBhcmRcbGFuZzMwODJcZnMxOCBPbGVjb250cm9sMQ0KXHBhciB9DQoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
		ENDTEXT
		loReg_Esperado.OLE	= STRCONV( lcOLE,14 )


		THIS.Evaluate_results( loEx, lnCodError_Esperado, lc_InputFile, lcParent, lcClass, lcObjName, loReg_Esperado )

ENDFUNC


ENDDEFINE

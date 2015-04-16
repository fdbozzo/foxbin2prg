DEFINE CLASS ut__foxbin2prg__c_conversor_base__lineIsOnlyCommentAndNoMetadata AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_conversor_base__lineIsOnlyCommentAndNoMetadata OF ut__foxbin2prg__c_conversor_base__lineIsOnlyCommentAndNoMetadata.PRG
	#ENDIF

	#DEFINE CR_LF				CHR(13) + CHR(10)
	#DEFINE C_CR				CHR(13)
	#DEFINE C_LF				CHR(10)
	#DEFINE C_TAB				CHR(9)
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
			, tcLinea, tcComentario, tlRetorno, tcLinea_Esperada, tcComentario_Esperado, tlRetorno_Esperado

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
			tcLinea					= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcLinea )
			tcLinea_Esperada		= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcLinea_Esperada )
			tcComentario			= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcComentario )
			tcComentario_Esperado	= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcComentario_Esperado )
		
			
			*-- Visualización de valores
			THIS.messageout( ' Linea = [' + TRANSFORM(tcLinea) + ']' )
			THIS.messageout( ' Comentario = [' + TRANSFORM(tcComentario) + ']' )
			THIS.messageout( ' tlRetorno = [' + TRANSFORM(tlRetorno) + ']' )

			
			*-- Evaluación de valores
			THIS.assertequals( tcLinea_Esperada, tcLinea, "Línea de código" )
			THIS.assertequals( tcComentario_Esperado, tcComentario, "Comentario" )
			THIS.assertequals( tlRetorno_Esperado, tlRetorno, "Retorno" )

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverSeparados_LineaDeCodigo_y_Valor_y_Retornar_False
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcLinea, lcLineaOriginal, lcComentario, lcLinea_Esperada, lcComentario_Esperado, llRetorno, llRetorno_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lcComentario			= '    ' + CHR(9) + CHR(9) + 'con algunos comentarios  	'
		lcLinea					= '	' + CHR(9) + CHR(9) + '   esta es una linea de código   ' + CHR(9) + ' '
		lcLineaOriginal			= lcLinea + '&' + '&' + lcComentario

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcLinea_Esperada		= lcLinea
		lcComentario_Esperado	= LTRIM(lcComentario)
		llRetorno_Esperado		= .F.

		*-- TEST
		llRetorno	= loObj.lineIsOnlyCommentAndNoMetadata( @lcLineaOriginal, @lcComentario )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, @lcLinea, @lcComentario, @llRetorno, @lcLinea_Esperada, @lcComentario_Esperado, @llRetorno_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverSeparados_LineaDeTAG_y_Valor_y_Retornar_False
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcLinea, lcLineaOriginal, lcComentario, lcLinea_Esperada, lcComentario_Esperado, llRetorno, llRetorno_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lcComentario			= '    		con algunos comentarios  	'
		lcLinea					= '			*<TAG>   esta es una linea de código   	 '
		lcLineaOriginal			= lcLinea + '&' + '&' + lcComentario
		lcLineaOriginal			= LTRIM( lcLineaOriginal, 0, CHR(9), ' ' )

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcLinea_Esperada		= ALLTRIM( lcLinea, 0, CHR(9), ' ' )
		lcComentario_Esperado	= lcLinea_Esperada
		llRetorno_Esperado		= .F.

		*-- TEST
		llRetorno	= loObj.lineIsOnlyCommentAndNoMetadata( @lcLineaOriginal, @lcComentario )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, @lcLineaOriginal, @lcComentario, @llRetorno, @lcLinea_Esperada, @lcComentario_Esperado, @llRetorno_Esperado )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverSeparados_LineaDeCodigo_y_Valor_y_Retornar_True
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcLinea, lcLineaOriginal, lcComentario, lcLinea_Esperada, lcComentario_Esperado, llRetorno, llRetorno_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lcComentario			= '    		con algunos comentarios  	'
		lcLinea					= '			*   esta es una linea de código   	 '
		lcLineaOriginal			= lcLinea + '&' + '&' + lcComentario
		lcLineaOriginal			= LTRIM(lcLineaOriginal, 0, CHR(9), ' ')

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcLinea_Esperada		= lcLinea
		lcComentario_Esperado	= LTRIM(lcComentario)
		llRetorno_Esperado		= .T.

		*-- TEST
		llRetorno	= loObj.lineIsOnlyCommentAndNoMetadata( @lcLineaOriginal, @lcComentario )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, @lcLinea, @lcComentario, @llRetorno, @lcLinea_Esperada, @lcComentario_Esperado, @llRetorno_Esperado )

	ENDFUNC


ENDDEFINE

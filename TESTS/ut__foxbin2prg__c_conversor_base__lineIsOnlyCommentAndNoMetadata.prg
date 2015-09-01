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
			, tcLinea, tcComentario, tlRetorno, tcLinea_Esperada, tcComentario_Esperado, tlRetorno_Esperado, tcLineaOriginal

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
			tcLineaOriginal			= oFXU_LIB.mejorarPresentacionCaracteresEspeciales( tcLineaOriginal )
		
			
			*-- Visualización de valores
			THIS.messageout( ' Línea original = [' + tcLineaOriginal + ']' )
			THIS.messageout( ' Linea = [' + TRANSFORM(tcLinea) + ']' )
			THIS.messageout( ' Comentario = [' + TRANSFORM(tcComentario) + ']' )
			THIS.messageout( ' OnlyCommentAndNoMetadata? = [' + TRANSFORM(tlRetorno) + ']' )

			
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
		lcLinea					= '	' + CHR(9) + CHR(9) + '   esta es una linea de código   ' + CHR(9) + ' '
		lcComentario			= '    ' + CHR(9) + CHR(9) + 'con algunos comentarios  	'
		lcLineaOriginal			= lcLinea + '&' + '&' + lcComentario
		lcLineaOriginal			= LTRIM(lcLineaOriginal, 0, CHR(9), ' ' )	&& Este tratamiento lo hace set_Line normalmente

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcLinea_Esperada		= ALLTRIM(lcLinea, 0, CHR(9), ' ' )
		lcComentario_Esperado	= LTRIM(lcComentario)
		llRetorno_Esperado		= .F.
		lcLinea					= LTRIM( lcLineaOriginal, 0, CHR(9), ' ' )	&& Este tratamiento lo hace set_Line normalmente

		*-- TEST
		llRetorno	= loObj.lineIsOnlyCommentAndNoMetadata( @lcLinea, @lcComentario )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, @lcLinea, @lcComentario, @llRetorno, @lcLinea_Esperada, @lcComentario_Esperado, @llRetorno_Esperado, @lcLineaOriginal )

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
		lcLinea					= '			*<TAG>   esta es una linea de código   	 '	&& Empieza con "*<", por lo que es metadata la línea
		lcComentario			= '    		con algunos comentarios  	'
		lcLineaOriginal			= lcLinea + '&' + '&' + lcComentario
		lcLineaOriginal			= LTRIM(lcLineaOriginal, 0, CHR(9), ' ' )	&& Este tratamiento lo hace set_Line normalmente

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		*lcLinea_Esperada		= LTRIM(lcLineaOriginal, 0, CHR(9), ' ' )	&&ALLTRIM( lcLinea, 0, CHR(9), ' ' )
		lcLinea_Esperada		= ALLTRIM(lcLinea, 0, CHR(9), ' ' )
		lcComentario_Esperado	= lcLinea_Esperada	&& Se espera la línea, porque es todo comentario
		llRetorno_Esperado		= .F.
		lcLinea					= LTRIM( lcLineaOriginal, 0, CHR(9), ' ' )	&& Este tratamiento lo hace set_Line normalmente

		*-- TEST
		llRetorno	= loObj.lineIsOnlyCommentAndNoMetadata( @lcLinea, @lcComentario )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, @lcLinea, @lcComentario, @llRetorno, @lcLinea_Esperada, @lcComentario_Esperado, @llRetorno_Esperado, @lcLineaOriginal )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverLaLineaDeCodigoComoComentario_y_Retornar_True
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcLinea, lcLineaOriginal, lcComentario, lcLinea_Esperada, lcComentario_Esperado, llRetorno, llRetorno_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lcLinea					= '			*   esta es una linea de código   	 '	&& Empieza con "*", por lo que es solo comentario la línea
		lcComentario			= '    		con algunos comentarios  	'
		lcLineaOriginal			= lcLinea + '&' + '&' + lcComentario
		lcLineaOriginal			= LTRIM(lcLineaOriginal, 0, CHR(9), ' ')

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcLinea_Esperada		= ALLTRIM(lcLinea, 0, CHR(9), ' ' )
		lcComentario_Esperado	= LTRIM(lcComentario)
		llRetorno_Esperado		= .T.
		lcLinea					= LTRIM( lcLineaOriginal, 0, CHR(9), ' ' )	&& Este tratamiento lo hace set_Line normalmente

		*-- TEST
		llRetorno	= loObj.lineIsOnlyCommentAndNoMetadata( @lcLinea, @lcComentario )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, @lcLinea, @lcComentario, @llRetorno, @lcLinea_Esperada, @lcComentario_Esperado, @llRetorno_Esperado, @lcLineaOriginal )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverSeparados_LineaDeCodigoQueIncluye_DobleAmpersand_y_Valor_y_Retornar_False
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcLinea, lcLineaOriginal, lcComentario, lcLinea_Esperada, lcComentario_Esperado, llRetorno, llRetorno_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lcLinea					= [DEFINE BAR 2 OF OpciónAsub PROMPT ""+var+'aa'+]+'["bb]'+[+"Opción A&]+[&2"]	&& No debe confundir el '&&' del código con comentarios
		lcComentario			=  [ Comentario Opción A-2]
		lcLineaOriginal			= lcLinea + '&' + '&' + lcComentario
		lcLineaOriginal			= LTRIM(lcLineaOriginal, 0, CHR(9), ' ' )	&& Este tratamiento lo hace set_Line normalmente

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcLinea_Esperada		= ALLTRIM(lcLinea, 0, CHR(9), ' ' )
		lcComentario_Esperado	= LTRIM(lcComentario)
		llRetorno_Esperado		= .F.
		lcLinea					= LTRIM( lcLineaOriginal, 0, CHR(9), ' ' )	&& Este tratamiento lo hace set_Line normalmente

		*-- TEST
		llRetorno	= loObj.lineIsOnlyCommentAndNoMetadata( @lcLinea, @lcComentario, .F., .T. )	&& Activando Deep Comment Analysis

		THIS.Evaluate_results( loEx, lnCodError_Esperado, @lcLinea, @lcComentario, @llRetorno, @lcLinea_Esperada, @lcComentario_Esperado, @llRetorno_Esperado, @lcLineaOriginal )

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverSeparados_LineaDeCodigoQueIncluye_DobleAmpersand_y_ComentarioConComillas_y_Retornar_False
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, lcLinea, lcLineaOriginal, lcComentario, lcLinea_Esperada, lcComentario_Esperado, llRetorno, llRetorno_Esperado ;
			, loEx AS EXCEPTION
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		lcLinea					= [DEFINE BAR 2 OF OpciónAsub PROMPT ""+var+'aa'+]+'["bb]'+[+"Opción A&]+[&2"]	&& No debe confundir el '&&' del código con comentarios
		lcComentario			=  [ Comentario's Opción A-2]
		lcLineaOriginal			= lcLinea + '&' + '&' + lcComentario
		lcLineaOriginal			= LTRIM(lcLineaOriginal, 0, CHR(9), ' ' )	&& Este tratamiento lo hace set_Line normalmente

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		lcLinea_Esperada		= ALLTRIM(lcLinea, 0, CHR(9), ' ' )
		lcComentario_Esperado	= LTRIM(lcComentario)
		llRetorno_Esperado		= .F.
		lcLinea					= LTRIM( lcLineaOriginal, 0, CHR(9), ' ' )	&& Este tratamiento lo hace set_Line normalmente

		*-- TEST
		llRetorno	= loObj.lineIsOnlyCommentAndNoMetadata( @lcLinea, @lcComentario, .F., .T. )	&& Activando Deep Comment Analysis

		THIS.Evaluate_results( loEx, lnCodError_Esperado, @lcLinea, @lcComentario, @llRetorno, @lcLinea_Esperada, @lcComentario_Esperado, @llRetorno_Esperado, @lcLineaOriginal )

	ENDFUNC


ENDDEFINE

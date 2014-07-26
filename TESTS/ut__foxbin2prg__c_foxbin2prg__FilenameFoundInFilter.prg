DEFINE CLASS ut__foxbin2prg__c_foxbin2prg__FilenameFoundInFilter AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_foxbin2prg__FilenameFoundInFilter OF ut__foxbin2prg__c_foxbin2prg__FilenameFoundInFilter.PRG
	#ENDIF

	icObj = NULL


	*******************************************************************************************************************************************
	FUNCTION SETUP
		PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		*LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		SET PROCEDURE TO 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		oFXU_LIB	= CREATEOBJECT('CL_FXU_CONFIG')
		*oFXU_LIB.setup_comun()
		THIS.icObj 	= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
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
			*oFXU_LIB.teardown_comun()
			oFXU_LIB = NULL
		ENDIF
		RELEASE PROCEDURE 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		RELEASE oFXU_LIB
		CLOSE PROCEDURES
		CLEAR RESOURCES

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Evaluate_results
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado, tl_Valor, tl_ValorEsperado

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF

		LOCAL loFoxBin2Prg AS c_foxbin2prg OF "FOXBIN2PRG.PRG"

		IF ISNULL(toEx)
			loFoxBin2Prg = THIS.icObj

			*-- MESSAGES
			THIS.messageout( 'Filename found in filter >> Esperado: ' + TRANSFORM(tl_ValorEsperado) )
			THIS.messageout( 'Filename found in filter >> Actual  : ' + TRANSFORM(tl_Valor) )

			*-- ASSERTIONS
			THIS.assertequals( tl_ValorEsperado, tl_Valor, 'Filename found in filter' )
			
			loFoxBin2Prg = NULL
			RELEASE loFoxBin2Prg

		ELSE
			*-- Evaluación de errores
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			IF NOT INLIST( toEx.ERRORNO, 1098, 2071 )	&& Error del usuario (ERROR y THROW)
				THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )
			ENDIF

			THIS.assertequals( tnCodError_Esperado, toEx.ERRORNO, 'Error' )
		ENDIF

		THIS.messageout( '' )
		THIS.messageout( REPLICATE('*',80) )
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_EncontrarElArchivo__FB2P_FOXUSER_DBF__UsandoElFiltro__TB2P_xpx
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_Filtros, ll_Valor, ll_ValorEsperado ;
			, loFoxBin2Prg AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx						= NULL
			loFoxBin2Prg				= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loFoxBin2Prg.l_Debug		= .F.
			loFoxBin2Prg.l_ShowErrors	= .F.
			*loFoxBin2Prg.l_Test		= .T.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			lc_File				= 'FB2P_FOXUSER.DBF'
			lc_Filtros			= 'XX.DBF,FF.FRX,FB2P_*.*'
			ll_ValorEsperado	= .T.

			*-- EVALUACIÓN DEL TEST
			ll_Valor	= loFoxBin2Prg.FilenameFoundInFilter( lc_File, lc_Filtros )

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, ll_Valor, ll_ValorEsperado )
			STORE NULL TO loFoxBin2Prg
			RELEASE loFoxBin2Prg
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_EncontrarElArchivo__FB2P_FOXUSER_DBF__UsandoElFiltro__x_FOXUSERpx
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_Filtros, ll_Valor, ll_ValorEsperado ;
			, loFoxBin2Prg AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx						= NULL
			loFoxBin2Prg				= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loFoxBin2Prg.l_Debug		= .F.
			loFoxBin2Prg.l_ShowErrors	= .F.
			*loFoxBin2Prg.l_Test		= .T.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			lc_File				= 'FB2P_FOXUSER.DBF'
			lc_Filtros			= 'XX.DBF,FF.FRX,*_FOXUSER.*'
			ll_ValorEsperado	= .T.

			*-- EVALUACIÓN DEL TEST
			ll_Valor	= loFoxBin2Prg.FilenameFoundInFilter( lc_File, lc_Filtros )

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, ll_Valor, ll_ValorEsperado )
			STORE NULL TO loFoxBin2Prg
			RELEASE loFoxBin2Prg
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_EncontrarElArchivo__FB2P_FOXUSER_DBF__UsandoElFiltro__x_F_Xxpx
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_Filtros, ll_Valor, ll_ValorEsperado ;
			, loFoxBin2Prg AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx						= NULL
			loFoxBin2Prg				= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loFoxBin2Prg.l_Debug		= .F.
			loFoxBin2Prg.l_ShowErrors	= .F.
			*loFoxBin2Prg.l_Test		= .T.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			lc_File				= 'FB2P_FOXUSER.DBF'
			lc_Filtros			= 'XX.DBF,FF.FRX,*_F?X*.*'
			ll_ValorEsperado	= .T.

			*-- EVALUACIÓN DEL TEST
			ll_Valor	= loFoxBin2Prg.FilenameFoundInFilter( lc_File, lc_Filtros )

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, ll_Valor, ll_ValorEsperado )
			STORE NULL TO loFoxBin2Prg
			RELEASE loFoxBin2Prg
		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_NoEncontrarElArchivo__FB2P_FOXUSER_DBF__UsandoElFiltro__uuFxpx
		LOCAL lnCodError, lnCodError_Esperado  ;
			, lc_File, lc_Filtros, ll_Valor, ll_ValorEsperado ;
			, loFoxBin2Prg AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx						= NULL
			loFoxBin2Prg				= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
			*loFoxBin2Prg.l_Debug		= .F.
			loFoxBin2Prg.l_ShowErrors	= .F.
			*loFoxBin2Prg.l_Test		= .T.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError, lnCodError_Esperado
			lc_File				= 'FB2P_FOXUSER.DBF'
			lc_Filtros			= 'XX.DBF,FF.FRX,??F*.*'
			ll_ValorEsperado	= .F.

			*-- EVALUACIÓN DEL TEST
			ll_Valor	= loFoxBin2Prg.FilenameFoundInFilter( lc_File, lc_Filtros )

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, ll_Valor, ll_ValorEsperado )
			STORE NULL TO loFoxBin2Prg
			RELEASE loFoxBin2Prg
		ENDTRY

	ENDFUNC


ENDDEFINE

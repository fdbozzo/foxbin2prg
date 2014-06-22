DEFINE CLASS ut__foxbin2prg__c_foxbin2prg__EvaluarConfiguracion AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_foxbin2prg__EvaluarConfiguracion OF ut__foxbin2prg__c_foxbin2prg__EvaluarConfiguracion.PRG
	#ENDIF

	#DEFINE C_CR		CHR(13)
	#DEFINE C_LF		CHR(10)
	#DEFINE CRLF		C_CR + C_LF
	#DEFINE C_TAB		CHR(9)
	ioFB2P = NULL


	*******************************************************************************************************************************************
	FUNCTION SETUP
		PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		*LOCAL loFB2P AS c_conversor_base OF "FOXBIN2PRG.PRG"
		SET PROCEDURE TO 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG', 'FOXBIN2PRG.PRG'
		oFXU_LIB = CREATEOBJECT('CL_FXU_CONFIG')
		oFXU_LIB.setup_comun()

		THIS.ioFB2P 	= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
		*loFB2P			= THIS.ioFB2P
		*loFB2P.l_Test	= .F.
		
		ERASE ('TESTS\DATOS_TEST\foxbin2prg.cfg')
		ERASE ('TESTS\DATOS_TEST\foxbin2prg.cfg.bak')
		ERASE ('TESTS\DATOS_TEST\foxbin2prg.cfg.1.bak')
		ERASE ('TESTS\DATOS_TEST\foxbin2prg.cfg.2.bak')

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION TearDown
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		THIS.ioFB2P = NULL

		IF VARTYPE(oFXU_LIB) = "O"
			oFXU_LIB.teardown_comun()
			oFXU_LIB = NULL
		ENDIF
		RELEASE PROCEDURE 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG', 'FOXBIN2PRG.PRG'

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Evaluate_results
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado, tcSeteo, teValorEsperado, teValor

		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF


		IF ISNULL(toEx)
			LOCAL loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG"
			LOCAL loFB2P_Esperado AS c_foxbin2prg OF "FOXBIN2PRG.PRG"
			loFB2P		= THIS.ioFB2P
			loFB2P_Esperado	= teValorEsperado
			THIS.messageout( LOWER(PROGRAM(PROGRAM(-1)-1)) )
			THIS.messageout( '.' )
			THIS.messageout( 'Archivo ' + loFB2P.c_Foxbin2prg_ConfigFile + IIF(FILE(loFB2P.c_Foxbin2prg_ConfigFile),': EXISTE', ': NO EXISTE') )
			THIS.messageout( '.' )

			IF tcSeteo = 'CONFIG' THEN
				*-- Evaluación de configuraciones
				THIS.messageout( 'CONFIGURACIÓN ESPERADA: ' )
				THIS.messageout( 'PJX_Conversion_Support: ' + TRANSFORM(loFB2P_Esperado.PJX_Conversion_Support) )
				THIS.messageout( 'VCX_Conversion_Support: ' + TRANSFORM(loFB2P_Esperado.VCX_Conversion_Support) )
				THIS.messageout( 'SCX_Conversion_Support: ' + TRANSFORM(loFB2P_Esperado.SCX_Conversion_Support) )
				THIS.messageout( 'FRX_Conversion_Support: ' + TRANSFORM(loFB2P_Esperado.FRX_Conversion_Support) )
				THIS.messageout( 'LBX_Conversion_Support: ' + TRANSFORM(loFB2P_Esperado.LBX_Conversion_Support) )
				THIS.messageout( 'MNX_Conversion_Support: ' + TRANSFORM(loFB2P_Esperado.MNX_Conversion_Support) )
				THIS.messageout( 'DBF_Conversion_Support: ' + TRANSFORM(loFB2P_Esperado.DBF_Conversion_Support) )
				THIS.messageout( 'DBC_Conversion_Support: ' + TRANSFORM(loFB2P_Esperado.DBC_Conversion_Support) )
				THIS.messageout( 'l_ShowProgress: ' + TRANSFORM(loFB2P_Esperado.l_ShowProgress) )
				THIS.messageout( 'l_ShowErrors: ' + TRANSFORM(loFB2P_Esperado.l_ShowErrors) )
				THIS.messageout( 'l_Recompile: ' + TRANSFORM(loFB2P_Esperado.l_Recompile) )
				THIS.messageout( 'l_NoTimestamps: ' + TRANSFORM(loFB2P_Esperado.l_NoTimestamps) )
				THIS.messageout( 'l_ClearUniqueID: ' + TRANSFORM(loFB2P_Esperado.l_ClearUniqueID) )
				THIS.messageout( 'l_Debug: ' + TRANSFORM(loFB2P_Esperado.l_Debug) )
				THIS.messageout( 'n_ExtraBackupLevels: ' + TRANSFORM(loFB2P_Esperado.n_ExtraBackupLevels) )
				THIS.messageout( 'l_OptimizeByFilestamp: ' + TRANSFORM(loFB2P_Esperado.l_OptimizeByFilestamp) )
			
				*-- VALIDACIONES
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.PJX_Conversion_Support), TRANSFORM(loFB2P.PJX_Conversion_Support), '> PJX_Conversion_Support' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.VCX_Conversion_Support), TRANSFORM(loFB2P.VCX_Conversion_Support), '> VCX_Conversion_Support' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.SCX_Conversion_Support), TRANSFORM(loFB2P.SCX_Conversion_Support), '> SCX_Conversion_Support' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.FRX_Conversion_Support), TRANSFORM(loFB2P.FRX_Conversion_Support), '> FRX_Conversion_Support' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.LBX_Conversion_Support), TRANSFORM(loFB2P.LBX_Conversion_Support), '> LBX_Conversion_Support' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.MNX_Conversion_Support), TRANSFORM(loFB2P.MNX_Conversion_Support), '> MNX_Conversion_Support' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.DBF_Conversion_Support), TRANSFORM(loFB2P.DBF_Conversion_Support), '> DBF_Conversion_Support' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.DBC_Conversion_Support), TRANSFORM(loFB2P.DBC_Conversion_Support), '> DBC_Conversion_Support' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.l_ShowProgress), TRANSFORM(loFB2P.l_ShowProgress), '> l_ShowProgress' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.l_ShowErrors), TRANSFORM(loFB2P.l_ShowErrors), '> l_ShowErrors' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.l_Recompile), TRANSFORM(loFB2P.l_Recompile), '> l_Recompile' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.l_NoTimestamps), TRANSFORM(loFB2P.l_NoTimestamps), '> l_NoTimestamps' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.l_ClearUniqueID), TRANSFORM(loFB2P.l_ClearUniqueID), '> l_ClearUniqueID' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.l_Debug), TRANSFORM(loFB2P.l_Debug), '> l_Debug' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.n_ExtraBackupLevels), TRANSFORM(loFB2P.n_ExtraBackupLevels), '> n_ExtraBackupLevels' )
				THIS.assertequals( TRANSFORM(loFB2P_Esperado.l_OptimizeByFilestamp), TRANSFORM(loFB2P.l_OptimizeByFilestamp), '> l_OptimizeByFilestamp' )

			ELSE
				*-- Visualización de valores
				THIS.messageout( TRANSFORM(tcSeteo) )
				THIS.messageout( 'Valor esperado: ' + TRANSFORM(teValorEsperado) )
				THIS.messageout( 'Valor: ' + TRANSFORM(teValor) )

				*-- Formateo
				* '[' + oFXU_LIB.mejorarPresentacionCaracteresEspeciales( TRANSFORM( EVALUATE('toReg_Esperado.'+laProps(I)) ) ) + ']' )

				*-- VALIDACIONES
				THIS.assertequals( TRANSFORM(teValorEsperado), TRANSFORM(teValor), tcSeteo )
			ENDIF


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
	FUNCTION Deberia_GenerarLaConfiguracionPorDefectoCuandoNoHayArchivoDeConfiguracion
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loFB2P_Esperado AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P_Esperado	= CREATEOBJECT("EMPTY")
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo		= 'CONFIG'
			ADDPROPERTY( loFB2P_Esperado, 'PJX_Conversion_Support', 2 )
			ADDPROPERTY( loFB2P_Esperado, 'VCX_Conversion_Support', 2 )
			ADDPROPERTY( loFB2P_Esperado, 'SCX_Conversion_Support', 2 )
			ADDPROPERTY( loFB2P_Esperado, 'FRX_Conversion_Support', 2 )
			ADDPROPERTY( loFB2P_Esperado, 'LBX_Conversion_Support', 2 )
			ADDPROPERTY( loFB2P_Esperado, 'MNX_Conversion_Support', 2 )
			ADDPROPERTY( loFB2P_Esperado, 'DBF_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'DBC_Conversion_Support', 2 )
			ADDPROPERTY( loFB2P_Esperado, 'l_ShowProgress', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'l_ShowErrors', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'l_Recompile', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'l_NoTimestamps', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'l_ClearUniqueID', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'l_Debug', .F. )
			ADDPROPERTY( loFB2P_Esperado, 'n_ExtraBackupLevels', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'l_OptimizeByFilestamp', .F. )
			*STRTOFILE('', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- TEST
			loFB2P.EvaluarConfiguracion()


		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, loFB2P_Esperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_UsarLaConfiguracionDelArchivoDeConfiguracion
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loFB2P_Esperado AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P_Esperado	= CREATEOBJECT("EMPTY")
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo		= 'CONFIG'
			ADDPROPERTY( loFB2P_Esperado, 'PJX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'VCX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'SCX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'FRX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'LBX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'MNX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'DBF_Conversion_Support', 2 )
			ADDPROPERTY( loFB2P_Esperado, 'DBC_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'l_ShowProgress', .F. )
			ADDPROPERTY( loFB2P_Esperado, 'l_ShowErrors', .F. )
			ADDPROPERTY( loFB2P_Esperado, 'l_Recompile', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'l_NoTimestamps', .F. )
			ADDPROPERTY( loFB2P_Esperado, 'l_ClearUniqueID', .F. )
			ADDPROPERTY( loFB2P_Esperado, 'l_Debug', .F. )
			ADDPROPERTY( loFB2P_Esperado, 'n_ExtraBackupLevels', 0 )
			ADDPROPERTY( loFB2P_Esperado, 'l_OptimizeByFilestamp', .F. )
			*--
			STRTOFILE( '* ' + PROGRAM() + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg')
			STRTOFILE( 'PJX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'VCX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'SCX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'FRX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'LBX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'MNX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'DBF_Conversion_Support: 2' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'DBC_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'DontShowProgress: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'DontShowErrors: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			*STRTOFILE( 'Recompile: ' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'NoTimestamps: 0' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'ClearUniqueID: 0' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'Debug: 0' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'ExtraBackupLevels: 0' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'OptimizeByFilestamp: 0' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )


			*-- TEST
			loFB2P.EvaluarConfiguracion()


		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, loFB2P_Esperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_UsarLaConfiguracionPorParametrosAunqueHayaArchivoDeConfiguracion
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loFB2P_Esperado AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P_Esperado	= CREATEOBJECT("EMPTY")
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo		= 'CONFIG'
			ADDPROPERTY( loFB2P_Esperado, 'PJX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'VCX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'SCX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'FRX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'LBX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'MNX_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'DBF_Conversion_Support', 2 )
			ADDPROPERTY( loFB2P_Esperado, 'DBC_Conversion_Support', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'l_ShowProgress', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'l_ShowErrors', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'l_Recompile', .F. )
			ADDPROPERTY( loFB2P_Esperado, 'l_NoTimestamps', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'l_ClearUniqueID', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'l_Debug', .T. )
			ADDPROPERTY( loFB2P_Esperado, 'n_ExtraBackupLevels', 1 )
			ADDPROPERTY( loFB2P_Esperado, 'l_OptimizeByFilestamp', .T. )
			*--
			STRTOFILE( '* ' + PROGRAM() + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg')
			STRTOFILE( 'PJX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'VCX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'SCX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'FRX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'LBX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'MNX_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'DBF_Conversion_Support: 2' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'DBC_Conversion_Support: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'DontShowProgress: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'DontShowErrors: 1' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			*STRTOFILE( 'Recompile: ' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'NoTimestamps: 0' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'ClearUniqueID: 0' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'Debug: 0' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'ExtraBackupLevels: 0' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )
			STRTOFILE( 'OptimizeByFilestamp: 0' + CRLF, 'TESTS\DATOS_TEST\foxbin2prg.cfg', 1 )


			*-- TEST
			loFB2P.EvaluarConfiguracion( '0', '0', '1', '1', '0', '1', '1', '1' )


		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, loFB2P_Esperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_GenerarExtension_BAK_Cuando_ExtraBackupLevels_EsteComentado_UseElValorPorDefecto_YNoExistaBAK
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'Extensión de Backup'
			leValorEsperado	= '.BAK'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.getNext_BAK('TESTS\DATOS_TEST\foxbin2prg.cfg')
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_GenerarExtension_BAK_Cuando_ExtraBackupLevels_EsteComentado_UseElValorPorDefecto_YExistaBAK
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('', 'TESTS\DATOS_TEST\foxbin2prg.cfg')
			STRTOFILE('', 'TESTS\DATOS_TEST\foxbin2prg.cfg.BAK')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'Extensión de Backup'
			leValorEsperado	= '.BAK'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.getNext_BAK('TESTS\DATOS_TEST\foxbin2prg.cfg')
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_GenerarExtension_BAK_Cuando_ExtraBackupLevels_Sea_0_YNoExistaBAK
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('ExtraBackupLevels:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'Extensión de Backup'
			leValorEsperado	= '.BAK'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.getNext_BAK('TESTS\DATOS_TEST\foxbin2prg.cfg')
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_GenerarExtension_BAK_Cuando_ExtraBackupLevels_Sea_0_YExistaBAK
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('ExtraBackupLevels:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')
			STRTOFILE('ExtraBackupLevels:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg.bak')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'Extensión de Backup'
			leValorEsperado	= '.BAK'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.getNext_BAK('TESTS\DATOS_TEST\foxbin2prg.cfg')
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_GenerarExtension_BAK_Cuando_ExtraBackupLevels_Sea_1_YNoExistaBAK
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('ExtraBackupLevels:1', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'Extensión de Backup'
			leValorEsperado	= '.BAK'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.getNext_BAK('TESTS\DATOS_TEST\foxbin2prg.cfg')
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_GenerarExtension_1_BAK_Cuando_ExtraBackupLevels_Sea_1_YExistaBAK
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('ExtraBackupLevels:1', 'TESTS\DATOS_TEST\foxbin2prg.cfg')
			STRTOFILE('ExtraBackupLevels:1', 'TESTS\DATOS_TEST\foxbin2prg.cfg.bak')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'Extensión de Backup'
			leValorEsperado	= '.BAK'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.getNext_BAK('TESTS\DATOS_TEST\foxbin2prg.cfg')
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_GenerarExtension_BAK_Cuando_ExtraBackupLevels_Sea_2_YExista_1_BAK
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('ExtraBackupLevels:2', 'TESTS\DATOS_TEST\foxbin2prg.cfg')
			STRTOFILE('ExtraBackupLevels:2', 'TESTS\DATOS_TEST\foxbin2prg.cfg.bak')
			STRTOFILE('ExtraBackupLevels:2', 'TESTS\DATOS_TEST\foxbin2prg.cfg.1.bak')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'Extensión de Backup'
			leValorEsperado	= '.BAK'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.getNext_BAK('TESTS\DATOS_TEST\foxbin2prg.cfg')
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_GenerarExtension_BAK_Cuando_ExtraBackupLevels_Sea_2_YExista_2_BAK
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('ExtraBackupLevels:2', 'TESTS\DATOS_TEST\foxbin2prg.cfg')
			STRTOFILE('ExtraBackupLevels:2', 'TESTS\DATOS_TEST\foxbin2prg.cfg.bak')
			STRTOFILE('ExtraBackupLevels:2', 'TESTS\DATOS_TEST\foxbin2prg.cfg.1.bak')
			STRTOFILE('ExtraBackupLevels:2', 'TESTS\DATOS_TEST\foxbin2prg.cfg.2.bak')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'Extensión de Backup'
			leValorEsperado	= '.BAK'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.getNext_BAK('TESTS\DATOS_TEST\foxbin2prg.cfg')
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_Debug_False_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_Debug'
			leValorEsperado	= .F.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_Debug
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_Debug_False_CuandoElArhivo_foxbin2prg_cfg_Tenga_Debug_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('Debug:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_Debug'
			leValorEsperado	= .F.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_Debug
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_Debug_True_CuandoElArhivo_foxbin2prg_cfg_Tenga_Debug_1
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('Debug:1', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_Debug'
			leValorEsperado	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_Debug
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_NoTimestamps_True_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_NoTimestamps'
			leValorEsperado	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_NoTimestamps
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_NoTimestamps_False_CuandoElArhivo_foxbin2prg_cfg_Tenga_NoTimestamps_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('NoTimestamps:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_NoTimestamps'
			leValorEsperado	= .F.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_NoTimestamps
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_NoTimestamps_True_CuandoElArhivo_foxbin2prg_cfg_Tenga_NoTimestamps_1
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('NoTimestamps:1', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_NoTimestamps'
			leValorEsperado	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_NoTimestamps
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_ClearUniqueID_True_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_ClearUniqueID'
			leValorEsperado	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_ClearUniqueID
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_ClearUniqueID_False_CuandoElArhivo_foxbin2prg_cfg_Tenga_ClearUniqueID_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('ClearUniqueID:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_ClearUniqueID'
			leValorEsperado	= .F.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_ClearUniqueID
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_ClearUniqueID_True_CuandoElArhivo_foxbin2prg_cfg_Tenga_ClearUniqueID_1
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('ClearUniqueID:1', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_ClearUniqueID'
			leValorEsperado	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_ClearUniqueID
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_ShowProgress_True_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_ShowProgress'
			leValorEsperado	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_ShowProgress
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_ShowProgress_True_CuandoElArhivo_foxbin2prg_cfg_Tenga_DontShowProgress_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('DontShowProgress:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_ShowProgress'
			leValorEsperado	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_ShowProgress
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_ShowProgress_False_CuandoElArhivo_foxbin2prg_cfg_Tenga_DontShowProgress_1
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			loFB2P.l_ShowErrors	= .F.
			STRTOFILE('DontShowProgress:1', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_ShowProgress'
			leValorEsperado	= .F.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_ShowProgress
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_ShowErrors_True_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_ShowErrors'
			leValorEsperado	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_ShowErrors
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_ShowErrors_True_CuandoElArhivo_foxbin2prg_cfg_Tenga_DontShowErrors_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('DontShowErrors:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_ShowErrors'
			leValorEsperado	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_ShowErrors
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_Setear_ShowErrors_False_CuandoElArhivo_foxbin2prg_cfg_Tenga_DontShowErrors_1
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('DontShowErrors:1', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'l_ShowErrors'
			leValorEsperado	= .F.


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.l_ShowErrors
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_DB2_Como_DB2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'DB2 Extension:'
			leValorEsperado	= 'DB2'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_DB2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_DB2_Como_DBA_CuandoElArhivo_foxbin2prg_cfg_TengaExtension_DB2_igual_DBA
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('Extension:db2=dba', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'DB2 Extension:'
			leValorEsperado	= 'DBA'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_DB2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_DC2_Como_DC2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'DC2 Extension:'
			leValorEsperado	= 'DC2'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_DC2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_DC2_Como_DCA_CuandoElArhivo_foxbin2prg_cfg_TengaExtension_DC2_igual_DCA
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('Extension:dc2=dca', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'DC2 Extension:'
			leValorEsperado	= 'DCA'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_DC2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_FR2_Como_FR2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'FR2 Extension:'
			leValorEsperado	= 'FR2'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_FR2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_FR2_Como_FRA_CuandoElArhivo_foxbin2prg_cfg_TengaExtension_FR2_igual_FRA
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('Extension:fr2=fra', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'FR2 Extension:'
			leValorEsperado	= 'FRA'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_FR2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_LB2_Como_LB2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'LB2 Extension:'
			leValorEsperado	= 'LB2'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_LB2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_LB2_Como_LBA_CuandoElArhivo_foxbin2prg_cfg_TengaExtension_LB2_igual_LBA
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('Extension:lb2=lba', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'LB2 Extension:'
			leValorEsperado	= 'LBA'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_LB2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_MN2_Como_MN2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'MN2 Extension:'
			leValorEsperado	= 'MN2'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_MN2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_MN2_Como_MNA_CuandoElArhivo_foxbin2prg_cfg_TengaExtension_MN2_igual_MNA
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('Extension:mn2=mna', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'MN2 Extension:'
			leValorEsperado	= 'MNA'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_MN2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_PJ2_Como_PJ2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'PJ2 Extension:'
			leValorEsperado	= 'PJ2'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_PJ2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_PJ2_Como_PJA_CuandoElArhivo_foxbin2prg_cfg_TengaExtension_PJ2_igual_PJA
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('Extension:pj2=pja', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'PJ2 Extension:'
			leValorEsperado	= 'PJA'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_PJ2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_SC2_Como_SC2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'SC2 Extension:'
			leValorEsperado	= 'SC2'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_SC2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_SC2_Como_SCA_CuandoElArhivo_foxbin2prg_cfg_TengaExtension_SC2_igual_SCA
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('Extension:sc2=sca', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'SC2 Extension:'
			leValorEsperado	= 'SCA'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_SC2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_VC2_Como_VC2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'VC2 Extension:'
			leValorEsperado	= 'VC2'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_VC2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearLaExtension_VC2_Como_VCA_CuandoElArhivo_foxbin2prg_cfg_TengaExtension_VC2_igual_VCA
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('Extension:vc2=vca', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'VC2 Extension:'
			leValorEsperado	= 'VCA'


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.c_VC2
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_DBF_Como_1_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'DBF_Conversion_Support:'
			leValorEsperado	= 1


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.DBF_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_DBF_Como_0_CuandoElArhivo_foxbin2prg_cfg_Y_DBF_Conversion_Support_Sea_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('DBF_Conversion_Support:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'DBF_Conversion_Support:'
			leValorEsperado	= 0


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.DBF_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_DBC_Como_2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'DBC_Conversion_Support:'
			leValorEsperado	= 2


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.DBC_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_DBC_Como_0_CuandoElArhivo_foxbin2prg_cfg_Y_DBC_Conversion_Support_Sea_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('DBC_Conversion_Support:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'DBC_Conversion_Support:'
			leValorEsperado	= 0


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.DBC_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_PJX_Como_2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'PJX_Conversion_Support:'
			leValorEsperado	= 2


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.PJX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_PJX_Como_0_CuandoElArhivo_foxbin2prg_cfg_Y_PJX_Conversion_Support_Sea_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('PJX_Conversion_Support:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'PJX_Conversion_Support:'
			leValorEsperado	= 0


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.PJX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_SCX_Como_2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'SCX_Conversion_Support:'
			leValorEsperado	= 2


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.SCX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_SCX_Como_0_CuandoElArhivo_foxbin2prg_cfg_Y_SCX_Conversion_Support_Sea_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('SCX_Conversion_Support:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'SCX_Conversion_Support:'
			leValorEsperado	= 0


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.SCX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_VCX_Como_2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'VCX_Conversion_Support:'
			leValorEsperado	= 2


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.VCX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_VCX_Como_0_CuandoElArhivo_foxbin2prg_cfg_Y_VCX_Conversion_Support_Sea_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('VCX_Conversion_Support:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'VCX_Conversion_Support:'
			leValorEsperado	= 0


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.VCX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_MNX_Como_2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'MNX_Conversion_Support:'
			leValorEsperado	= 2


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.MNX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_MNX_Como_0_CuandoElArhivo_foxbin2prg_cfg_Y_MNX_Conversion_Support_Sea_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('MNX_Conversion_Support:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'MNX_Conversion_Support:'
			leValorEsperado	= 0


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.MNX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_FRX_Como_2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'FRX_Conversion_Support:'
			leValorEsperado	= 2


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.FRX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_FRX_Como_0_CuandoElArhivo_foxbin2prg_cfg_Y_FRX_Conversion_Support_Sea_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('FRX_Conversion_Support:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'FRX_Conversion_Support:'
			leValorEsperado	= 0


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.FRX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_LBX_Como_2_CuandoNoExistaElArhivo_foxbin2prg_cfg
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors				= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'LBX_Conversion_Support:'
			leValorEsperado	= 2


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.LBX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_LBX_Como_0_CuandoElArhivo_foxbin2prg_cfg_Y_LBX_Conversion_Support_Sea_0
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE('LBX_Conversion_Support:0', 'TESTS\DATOS_TEST\foxbin2prg.cfg')


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'LBX_Conversion_Support:'
			leValorEsperado	= 0


			*-- TEST
			loFB2P.EvaluarConfiguracion()
			leValor		= loFB2P.LBX_Conversion_Support
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_LBX_Como_1_CuandoExistaElArhivo_foxbin2prg_cfg_Secundario
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor, lcCFG_File ;
			, laCFG_CachedAccess(3), laCFG_CachedAccess_Esperado(3), I ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.l_AllowMultiConfig	= .T.
			loFB2P.c_InputFile	= FORCEPATH( 'test.vcx', oFXU_LIB.cPathDatosTest )
			lcCFG_File	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE( 'LBX_Conversion_Support: 1', lcCFG_File )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'LBX_Conversion_Support:'
			leValorEsperado	= 1
			laCFG_CachedAccess_Esperado(1)	= .F.
			laCFG_CachedAccess_Esperado(2)	= .T.
			laCFG_CachedAccess_Esperado(3)	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()	&& Carga config.Principal

			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(1)	= loFB2P.get_l_CFG_CachedAccess()

			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(2)	= loFB2P.get_l_CFG_CachedAccess()

			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(3)	= loFB2P.get_l_CFG_CachedAccess()

			leValor		= loFB2P.LBX_Conversion_Support
			
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

			THIS.messageout( 'Configuración Principal: ' + loFB2P.c_Foxbin2prg_ConfigFile )
			THIS.messageout( 'Configuración Secundaria: ' + lcCFG_File )
			FOR I = 1 TO ALEN(laCFG_CachedAccess_Esperado)
				THIS.assertequals( laCFG_CachedAccess_Esperado(I), laCFG_CachedAccess(I), 'CONFIGURACIÓN CACHEADA EN ACCESO ' + TRANSFORM(I) )
			ENDFOR

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_LBX_Como_0_CuandoNoHaya_CFG_Principal_Y_NoExista_CFG_Secundario_EnElDirEvaluado
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor, lcCFG_File ;
			, laCFG_CachedAccess(3), laCFG_CachedAccess_Esperado(3), I ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.l_AllowMultiConfig	= .T.
			loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', ADDBS(oFXU_LIB.cPathDatosTest) + 'noexiste' )
			loFB2P.c_InputFile	= FORCEPATH( 'test.vcx', oFXU_LIB.cPathDatosTest )
			lcCFG_File	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE( 'LBX_Conversion_Support: 1', lcCFG_File )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'LBX_Conversion_Support:'
			leValorEsperado	= 0
			laCFG_CachedAccess_Esperado(1)	= .F.
			laCFG_CachedAccess_Esperado(2)	= .T.
			laCFG_CachedAccess_Esperado(3)	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()	&& Carga config.Principal

			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(1)	= loFB2P.get_l_CFG_CachedAccess()

			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(2)	= loFB2P.get_l_CFG_CachedAccess()

			loFB2P.LBX_Conversion_Support = 0
			loFB2P.c_InputFile	= FORCEPATH( 'test.vcx', ADDBS(oFXU_LIB.cPathDatosTest) + 'otro' )
			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(3)	= loFB2P.get_l_CFG_CachedAccess()

			leValor		= loFB2P.LBX_Conversion_Support
			
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

			THIS.messageout( 'Configuración Principal: ' + loFB2P.c_Foxbin2prg_ConfigFile )
			THIS.messageout( 'Configuración Secundaria: ' + lcCFG_File )

			FOR I = 1 TO ALEN(laCFG_CachedAccess_Esperado)
				THIS.messageout( 'Configuración cacheada en acceso ' + TRANSFORM(I) + ' esperada: ' + TRANSFORM( laCFG_CachedAccess_Esperado(I) ) )
				THIS.assertequals( laCFG_CachedAccess_Esperado(I), laCFG_CachedAccess(I), 'CONFIGURACIÓN CACHEADA EN ACCESO ' + TRANSFORM(I) )
			ENDFOR

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_LBX_Como_0_CuandoExista_CFG_Secundario_EnElDirEvaluado_Y_NoUsarValorCacheadoEnPrimerAcceso
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor, lcCFG_File ;
			, laCFG_CachedAccess(3), laCFG_CachedAccess_Esperado(3), I ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.l_AllowMultiConfig	= .T.
			lcCFG_File	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE( 'LBX_Conversion_Support: 1', lcCFG_File )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'LBX_Conversion_Support:'
			leValorEsperado	= 1
			laCFG_CachedAccess_Esperado(1)	= .T.
			laCFG_CachedAccess_Esperado(2)	= .T.
			laCFG_CachedAccess_Esperado(3)	= .F.


			*-- TEST
			loFB2P.EvaluarConfiguracion()	&& Carga config.Principal

			loFB2P.c_InputFile	= loFB2P.c_Foxbin2prg_ConfigFile
			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(1)	= loFB2P.get_l_CFG_CachedAccess()

			loFB2P.c_InputFile	= FORCEPATH( 'test.vcx', ADDBS(oFXU_LIB.cPathDatosTest) + 'otro' )
			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(2)	= loFB2P.get_l_CFG_CachedAccess()

			loFB2P.c_InputFile	= FORCEPATH( 'test.vcx', oFXU_LIB.cPathDatosTest )
			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(3)	= loFB2P.get_l_CFG_CachedAccess()

			leValor		= loFB2P.LBX_Conversion_Support
			
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

			THIS.messageout( 'Configuración Principal: ' + loFB2P.c_Foxbin2prg_ConfigFile )
			THIS.messageout( 'Configuración Secundaria: ' + lcCFG_File )

			FOR I = 1 TO ALEN(laCFG_CachedAccess_Esperado)
				THIS.messageout( 'Configuración cacheada en acceso ' + TRANSFORM(I) + ' esperada: ' + TRANSFORM( laCFG_CachedAccess_Esperado(I) ) )
				THIS.assertequals( laCFG_CachedAccess_Esperado(I), laCFG_CachedAccess(I), 'CONFIGURACIÓN CACHEADA EN ACCESO ' + TRANSFORM(I) )
			ENDFOR

		ENDTRY

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_SetearElSoporte_LBX_Como_0_CuandoExista_CFG_Secundario_EnElDirEvaluado_Y_UsarValorCacheadoDesdeSegundoAccesoConsecutivo
		LOCAL lnCodError, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor, lcCFG_File ;
			, laCFG_CachedAccess(3), laCFG_CachedAccess_Esperado(3), I ;
			, loFB2P AS c_foxbin2prg OF "FOXBIN2PRG.PRG" ;
			, loEx AS EXCEPTION
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF

		TRY
			loEx		= NULL
			loFB2P		= THIS.ioFB2P
			loFB2P.l_ShowErrors	= .F.
			loFB2P.l_AllowMultiConfig	= .T.
			*loFB2P.c_Foxbin2prg_ConfigFile	= FORCEPATH( 'foxbin2prg.cfg', ADDBS(oFXU_LIB.cPathDatosTest) + 'noexiste' )
			*loFB2P.c_InputFile	= FORCEPATH( 'test.vcx', oFXU_LIB.cPathDatosTest )
			lcCFG_File	= FORCEPATH( 'foxbin2prg.cfg', oFXU_LIB.cPathDatosTest )
			STRTOFILE( 'LBX_Conversion_Support: 1', lcCFG_File )


			*-- DATOS DE ENTRADA
			STORE 0 TO lnCodError
			lcSeteo			= 'LBX_Conversion_Support:'
			leValorEsperado	= 1
			laCFG_CachedAccess_Esperado(1)	= .T.
			laCFG_CachedAccess_Esperado(2)	= .F.
			laCFG_CachedAccess_Esperado(3)	= .T.


			*-- TEST
			loFB2P.EvaluarConfiguracion()	&& Carga config.Principal

			*loFB2P.c_InputFile	= loFB2P.c_Foxbin2prg_ConfigFile

			loFB2P.c_InputFile	= FORCEPATH( 'test1.vcx', ADDBS(oFXU_LIB.cPathDatosTest) + 'otro' )
			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(1)	= loFB2P.get_l_CFG_CachedAccess()

			loFB2P.c_InputFile	= FORCEPATH( 'test2.vcx', oFXU_LIB.cPathDatosTest )
			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(2)	= loFB2P.get_l_CFG_CachedAccess()

			loFB2P.c_InputFile	= FORCEPATH( 'test3.vcx', oFXU_LIB.cPathDatosTest )
			loFB2P.EvaluarConfiguracion()	&& Carga config.secundaria
			laCFG_CachedAccess(3)	= loFB2P.get_l_CFG_CachedAccess()

			leValor		= loFB2P.LBX_Conversion_Support
			
			

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnCodError_Esperado, lcSeteo, leValorEsperado, leValor )

			THIS.messageout( 'Configuración Principal: ' + loFB2P.c_Foxbin2prg_ConfigFile )
			THIS.messageout( 'Configuración Secundaria: ' + lcCFG_File )

			FOR I = 1 TO ALEN(laCFG_CachedAccess_Esperado)
				THIS.messageout( 'Configuración cacheada en acceso ' + TRANSFORM(I) + ' esperada: ' + TRANSFORM( laCFG_CachedAccess_Esperado(I) ) )
				THIS.assertequals( laCFG_CachedAccess_Esperado(I), laCFG_CachedAccess(I), 'CONFIGURACIÓN CACHEADA EN ACCESO ' + TRANSFORM(I) )
			ENDFOR

		ENDTRY

	ENDFUNC


ENDDEFINE

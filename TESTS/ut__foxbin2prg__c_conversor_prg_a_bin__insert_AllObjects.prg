DEFINE CLASS ut__foxbin2prg__c_conversor_prg_a_bin__insert_AllObjects AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_conversor_prg_a_bin__insert_AllObjects OF ut__foxbin2prg__c_conversor_prg_a_bin__insert_AllObjects.PRG
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
	icObj 		= NULL
	icClase		= NULL


	*******************************************************************************************************************************************
	FUNCTION SETUP
		PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		LOCAL loObjeto AS CL_OBJETO OF "FOXBIN2PRG.PRG"
		LOCAL loClase AS CL_CLASE OF "FOXBIN2PRG.PRG"
		SET PROCEDURE TO 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		oFXU_LIB = CREATEOBJECT('CL_FXU_CONFIG')
		oFXU_LIB.setup_comun()

		THIS.icObj 	= NEWOBJECT("c_conversor_prg_a_bin", "FOXBIN2PRG.PRG")
		THIS.icClase	= NEWOBJECT("CL_CLASE", "FOXBIN2PRG.PRG")
		loClase			= THIS.icClase
		loObj			= THIS.icObj
		loObj.l_Test	= .T.

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION TearDown
		#IF .F.
			PUBLIC oFXU_LIB AS CL_FXU_CONFIG OF 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'
		#ENDIF
		THIS.icObj = NULL
		THIS.icClase	= NULL
		
		IF VARTYPE(oFXU_LIB) = "O"
			oFXU_LIB.teardown_comun()
			oFXU_LIB = NULL
		ENDIF
		RELEASE PROCEDURE 'TESTS\fxu_lib_objetos_y_funciones_de_soporte.PRG'

	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Evaluate_results
		LPARAMETERS toEx AS EXCEPTION, tnCodError_Esperado, toClase, taWriteOrder_Esperado

		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		LOCAL loObjeto AS CL_OBJETO OF "FOXBIN2PRG.PRG"
		LOCAL loClase AS CL_CLASE OF "FOXBIN2PRG.PRG"
		LOCAL I
		loObj		= THIS.icObj
		loClase		= toClase

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF

		IF ISNULL(toEx)
			*-- Visualización de valores
			FOR I = 1 TO loClase._AddObject_Count
				loObjeto	= loClase._AddObjects(I)
				THIS.messageout( ' objeto._Nombre = ' + TRANSFORM(loObjeto._Nombre) )
				THIS.messageout( ' objeto._ZOrder = ' + TRANSFORM(loObjeto._ZOrder) )
				THIS.messageout( ' objeto._WriteOrder = ' + TRANSFORM(loObjeto._WriteOrder) )
				THIS.messageout( REPLICATE('-',50) )
			ENDFOR

			
			*-- Evaluación de valores
			FOR I = 1 TO loClase._AddObject_Count
				loObjeto	= loClase._AddObjects(I)
				THIS.assertequals( taWriteOrder_Esperado(I), loObjeto._WriteOrder, "[WriteOrder para objeto " + loObjeto._Nombre + "]" )
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
	FUNCTION Deberia_ordenarLosObjetosSegunSuOrdenOriginal
		LOCAL lnCodError, lcMenError, lnCodError_Esperado  ;
			, laWriteOrder_Esperado(3) ;
			, loEx AS EXCEPTION

		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		LOCAL loObjeto AS CL_OBJETO OF "FOXBIN2PRG.PRG"
		LOCAL loClase AS CL_CLASE OF "FOXBIN2PRG.PRG"
		loObj		= THIS.icObj
		loClase		= THIS.icClase
		loEx		= NULL

		*-- DATOS DE ENTRADA
		STORE 0 TO lnCodError
		*--
		loObjeto	= NULL
		loObjeto	= NEWOBJECT("CL_OBJETO", "FOXBIN2PRG.PRG")
		loObjeto._ObjName	= 'Label3'
		loObjeto._Parent	= 'Form1.pgfPanel.pagApariencia'
		loObjeto._Nombre	= 'Form1.pgfPanel.pagApariencia.Label3'
		loObjeto._ZOrder	= 50
		loClase.add_Object( loObjeto )
		*--
		loObjeto	= NULL
		loObjeto	= NEWOBJECT("CL_OBJETO", "FOXBIN2PRG.PRG")
		loObjeto._ObjName	= 'Label3'
		loObjeto._Parent	= 'Form1.pgfPanel.pagAvanzado'
		loObjeto._Nombre	= 'Form1.pgfPanel.pagAvanzado.Label3'
		loObjeto._ZOrder	= 82
		loClase.add_Object( loObjeto )
		*--
		loObjeto	= NULL
		loObjeto	= NEWOBJECT("CL_OBJETO", "FOXBIN2PRG.PRG")
		loObjeto._ObjName	= 'Label3'
		loObjeto._Parent	= 'Form1.pgfPanel.pagSeteos'
		loObjeto._Nombre	= 'Form1.pgfPanel.pagSeteos.Label3'
		loObjeto._ZOrder	= 30
		loClase.add_Object( loObjeto )
		*--
		loObjeto	= NULL

		*-- DATOS ESPERADOS
		STORE 0 TO lnCodError_Esperado
		laWriteOrder_Esperado(1)	= 2
		laWriteOrder_Esperado(2)	= 3
		laWriteOrder_Esperado(3)	= 1

		*-- TEST
		loObj.insert_AllObjects( @loClase )

		THIS.Evaluate_results( loEx, lnCodError_Esperado, @loClase, @laWriteOrder_Esperado )

	ENDFUNC


ENDDEFINE

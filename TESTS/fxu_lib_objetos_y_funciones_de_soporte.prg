*-- Módulo:		fxu_lib_objetos_y_funciones_de_soporte.PRG
*-- Autor:		Fernando D. Bozzo - 30/11/2013
*-- Detalle:	LIBRERÍA DE SOPORTE DE LOS TESTS PARA OBJETOS Y FUNCIONES DE FOXBIN2PRG
*----------------------------------------------------------------------------------------



FUNCTION TaskBarHeight
	DECLARE INTEGER GetWindowRect IN user32;
		INTEGER HWND, STRING lpRect
	DECLARE INTEGER FindWindow IN user32;
		STRING lpClassName,;
		STRING lpWindowName

	LOCAL cBuffer
	cBuffer = REPLICATE(CHR(0), 16)
	hWindow= FindWindow('Shell_TrayWnd', '')
	cRect = GetWinRect(hWindow)
	RETURN TRANSFORM( buf2dword( SUBSTR(cRect, 13,4)) - buf2dword( SUBSTR(cRect, 5,4) ) )
ENDFUNC


FUNCTION GetWinRect(hWindow)
	LOCAL cBuffer
	cBuffer = REPLICATE(CHR(0), 16)
	= GetWindowRect(hWindow, @cBuffer)
	RETURN cBuffer
ENDFUNC


FUNCTION buf2dword(lcBuffer)
	RETURN ASC(SUBSTR(lcBuffer, 1,1)) + ;
		BITLSHIFT(ASC(SUBSTR(lcBuffer, 2,1)),  8) +;
		BITLSHIFT(ASC(SUBSTR(lcBuffer, 3,1)), 16) +;
		BITLSHIFT(ASC(SUBSTR(lcBuffer, 4,1)), 24)
ENDFUNC


DEFINE CLASS cl_Column AS Column
ENDDEFINE


DEFINE CLASS cl_Header AS Header
ENDDEFINE


DEFINE CLASS CL_FXU_CONFIG AS CUSTOM
	#IF .F.
		LOCAL THIS AS CL_FXU_CONFIG OF 'fxu_lib_objetos_y_funciones_de_soporte.PRG'
	#ENDIF

	_MEMBERDATA	= [<VFPData>] ;
		+ [<memberdata name="cpath" display="cPath"/>] ;
		+ [<memberdata name="coldpath" display="cOldPath"/>] ;
		+ [<memberdata name="cpathdatosreadonly" display="cPathDatosReadOnly"/>] ;
		+ [<memberdata name="cpathdatostest" display="cPathDatosTest"/>] ;
		+ [<memberdata name="copiararchivosparatest" display="copiarArchivosParaTest"/>] ;
		+ [<memberdata name="csetdate" display="cSetDate"/>] ;
		+ [<memberdata name="mejorarpresentacioncaracteresespeciales" display="mejorarPresentacionCaracteresEspeciales"/>] ;
		+ [<memberdata name="prepararobjetoreg_scx" display="prepararObjetoReg_SCX"/>] ;
		+ [<memberdata name="prepararobjetoreg_vcx" display="prepararObjetoReg_VCX"/>] ;
		+ [</VFPData>]


	cOldPath			= ''
	cPath				= 'TESTS;TESTS\DATOS_TEST'
	
	cPathDatosReadOnly	= 'TESTS\DATOS_READONLY'
	cPathDatosTest		= 'TESTS\DATOS_TEST'
	cSetDate			= ''


	*----------------------------------------------------------------------------------------
	PROCEDURE INIT
		THIS.cSetDate	= SET("Date")

		SET DATE TO YMD
		SET HOURS TO 24
		SET SAFETY OFF
		SET TABLEPROMPT OFF
		SET TALK OFF

		THIS.cOldPath	= SET("Path")

		IF FILE("FOXUNIT_PATH.TXT")
			THIS.cPath	= THIS.cPath + ';' + FILETOSTR("FOXUNIT_PATH.TXT")
		ELSE
			THIS.cPath	= THIS.cPath + ';FOXUNIT'
		ENDIF
		
		THIS.cPathDatosReadOnly	= ADDBS( SYS(5) + CURDIR() ) + THIS.cPathDatosReadOnly
		THIS.cPathDatosTest		= ADDBS( SYS(5) + CURDIR() ) + THIS.cPathDatosTest
		
		SET PATH TO (THIS.cPath)
	ENDPROC


	*----------------------------------------------------------------------------------------
	PROCEDURE DESTROY
		SET PATH TO (THIS.cOldPath)
		SET DATE (THIS.cSetDate)
	ENDPROC


	*----------------------------------------------------------------------------------------
	PROCEDURE SETUP_COMUN
		IF DIRECTORY( THIS.cPathDatosTest )
			ERASE ( FORCEPATH( '*.*', THIS.cPathDatosTest ) )
		ELSE
			TRY
				MKDIR ( THIS.cPathDatosTest )
			CATCH
			ENDTRY
		ENDIF

		IF NOT DIRECTORY( ADDBS(THIS.cPathDatosTest) + 'bmps' )
			TRY
				MKDIR ( ADDBS(THIS.cPathDatosTest) + 'bmps' )
			CATCH
			ENDTRY
		ENDIF
	ENDPROC


	*----------------------------------------------------------------------------------------
	PROCEDURE TEARDOWN_COMUN
		USE IN (SELECT("TABLABIN"))
	ENDPROC


	*----------------------------------------------------------------------------------------
	PROCEDURE copiarArchivosParaTest
		LPARAMETERS tcFileSpec

		TRY
			LOCAL loEx AS Exception
			COPY FILE (FORCEPATH( tcFileSpec, THIS.cPathDatosReadOnly )) TO (FORCEPATH( tcFileSpec, THIS.cPathDatosTest ))

		CATCH TO loEx
			loEx.UserValue = 'cPathDatosReadOnly = "' + THIS.cPathDatosReadOnly + CHR(13) + CHR(10) ;
				+ 'cPathDatosTest = "' + THIS.cPathDatosTest
			THROW
		ENDTRY
	ENDPROC


	*----------------------------------------------------------------------------------------
	FUNCTION mejorarPresentacionCaracteresEspeciales
		LPARAMETERS tcText
		RETURN STRTRAN( ;
			STRTRAN( ;
			STRTRAN( ;
			STRTRAN( ;
			STRTRAN( ;
			STRTRAN( tcText, CHR(13)+CHR(10), '<CRLF>' ) ;
			, CHR(13), '<CR>' ) ;
			, CHR(10), '<LF>' ) ;
			, CHR(9), '<TAB>' ) ;
			, ' ', '·' ) ;
			, '<CRLF>', '<CRLF>'+CHR(13)+CHR(10) )
	ENDFUNC


	*----------------------------------------------------------------------------------------
	PROCEDURE prepararObjetoReg_SCX
		LPARAMETERS toReg, tcClass, tcParent, tcObjName

		toReg	= CREATEOBJECT("EMPTY")
		ADDPROPERTY( toReg, 'Class', tcClass )
		ADDPROPERTY( toReg, 'Parent', tcParent )
		ADDPROPERTY( toReg, 'objName', tcObjName )
		ADDPROPERTY( toReg, 'Reserved1', '' )
		ADDPROPERTY( toReg, 'Reserved2', '' )
		ADDPROPERTY( toReg, 'Reserved3', '' )
		ADDPROPERTY( toReg, 'Reserved4', '' )
		ADDPROPERTY( toReg, 'Reserved5', '' )
		ADDPROPERTY( toReg, 'Reserved6', '' )
		ADDPROPERTY( toReg, 'Reserved7', '' )
		ADDPROPERTY( toReg, 'Reserved8', '' )
		ADDPROPERTY( toReg, 'Properties', '' )
		ADDPROPERTY( toReg, 'Protected', '' )
		ADDPROPERTY( toReg, 'Methods', '' )
	ENDPROC


	*----------------------------------------------------------------------------------------
	PROCEDURE prepararObjetoReg_VCX
		LPARAMETERS toReg, tcClass, tcParent, tcObjName

		toReg	= CREATEOBJECT("EMPTY")
		ADDPROPERTY( toReg, 'Class', tcClass )
		ADDPROPERTY( toReg, 'Parent', tcParent )
		ADDPROPERTY( toReg, 'objName', tcObjName )
		ADDPROPERTY( toReg, 'Reserved1', '' )
		ADDPROPERTY( toReg, 'Reserved2', '' )
		ADDPROPERTY( toReg, 'Reserved3', '' )
		ADDPROPERTY( toReg, 'Reserved4', '' )
		ADDPROPERTY( toReg, 'Reserved5', '' )
		ADDPROPERTY( toReg, 'Reserved6', '' )
		ADDPROPERTY( toReg, 'Reserved7', '' )
		ADDPROPERTY( toReg, 'Reserved8', '' )
		ADDPROPERTY( toReg, 'Properties', '' )
		ADDPROPERTY( toReg, 'Protected', '' )
		ADDPROPERTY( toReg, 'Methods', '' )
	ENDPROC


ENDDEFINE

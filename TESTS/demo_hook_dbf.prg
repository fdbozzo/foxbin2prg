*-- DEMO HOOK PARA PREPROCESO DE UN DBF
LOCAL oFB AS 'c_foxbin2prg' OF 'c:\desa\foxbin2prg\foxbin2prg.prg'
oFB = NEWOBJECT( 'c_foxbin2prg', 'c:\desa\foxbin2prg\foxbin2prg.prg' )
oFB.DBF_Conversion_Support	= 2
oFB.run_AfterCreateTable 	= 'p_AfterCreateTable'
oFB.Ejecutar( 'C:\DESA\foxbin2prg\TESTS\DATOS_TEST\fb2p_dbc.dc2' )
oFB.Ejecutar( 'C:\DESA\foxbin2prg\TESTS\DATOS_TEST\fb2p_dbf.db2' )
oFB	= NULL
RETURN


PROCEDURE p_AfterCreateTable
	LPARAMETERS lnDataSessionID, tc_OutputFile, toTable
	MESSAGEBOX( 'Datasession actual: ' + TRANSFORM(SET("Datasession")) + CHR(13) ;
		+ 'lnDataSessionID: ' + TRANSFORM(lnDataSessionID) )
	*-- Aquí se puede rellenar la tabla.
	*-- Recordar no cambiar la sesión de datos, que es privada.
	INSERT INTO fb2p_dbf (nombre,edad,depto) VALUES ('Fer', 45, 'dpto')
ENDPROC

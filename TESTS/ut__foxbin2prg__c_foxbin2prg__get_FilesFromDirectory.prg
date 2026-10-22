DEFINE CLASS ut__foxbin2prg__c_foxbin2prg__get_FilesFromDirectory AS FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_foxbin2prg__get_FilesFromDirectory OF ut__foxbin2prg__c_foxbin2prg__get_FilesFromDirectory.PRG
	#ENDIF

	icObj		= NULL
	icRootDir	= ''


	*******************************************************************************************************************************************
	FUNCTION SETUP
		LOCAL lcRoot
		THIS.icObj 	= NEWOBJECT("c_foxbin2prg", "FOXBIN2PRG.PRG")
		THIS.icObj.l_ShowErrors	= .F.

		*-- Tree:
		*-- ROOT\a.prg
		*-- ROOT\SUB_OK\b.prg
		*-- ROOT\SUB_IGN\.FoxBin2Prg_Ignore
		*-- ROOT\SUB_IGN\c.prg
		*-- ROOT\SUB_IGN\DEEP\d.prg
		lcRoot			= ADDBS( SYS(2023) ) + 'FB2P_IGN_' + SYS(2015) + '\'
		THIS.icRootDir	= lcRoot
		MKDIR (lcRoot)
		MKDIR (lcRoot + 'SUB_OK')
		MKDIR (lcRoot + 'SUB_IGN')
		MKDIR (lcRoot + 'SUB_IGN\DEEP')
		STRTOFILE( '*', lcRoot + 'a.prg' )
		STRTOFILE( '*', lcRoot + 'SUB_OK\b.prg' )
		STRTOFILE( '*', lcRoot + 'SUB_IGN\c.prg' )
		STRTOFILE( '*', lcRoot + 'SUB_IGN\DEEP\d.prg' )
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION TearDown
		LOCAL loFSO
		IF NOT EMPTY(THIS.icRootDir) AND DIRECTORY(THIS.icRootDir)
			loFSO	= CREATEOBJECT("Scripting.FileSystemObject")
			loFSO.DeleteFolder( RTRIM(THIS.icRootDir, '\'), .T. )
			loFSO	= NULL
		ENDIF
		THIS.icObj = NULL
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Evaluate_results
		LPARAMETERS toEx AS EXCEPTION, tnFileCount, tnFileCountEsperado, tnIgnoredFound

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF

		IF ISNULL(toEx)
			THIS.messageout( 'File count >> Esperado: ' + TRANSFORM(tnFileCountEsperado) )
			THIS.messageout( 'File count >> Actual  : ' + TRANSFORM(tnFileCount) )
			THIS.messageout( 'Files from ignored tree: ' + TRANSFORM(tnIgnoredFound) )

			THIS.assertequals( tnFileCountEsperado, tnFileCount, 'File count' )
			THIS.assertequals( 0, tnIgnoredFound, 'Files from ignored tree' )
		ELSE
			THIS.messageout( "Error " + TRANSFORM(toEx.ERRORNO) + ', ' + TRANSFORM(toEx.MESSAGE) )
			THIS.messageout( toEx.PROCEDURE + ', ' + TRANSFORM(toEx.LINENO) )
			THIS.messageout( TRANSFORM(toEx.LINECONTENTS) )
			THIS.assertequals( 0, toEx.ERRORNO, 'Error' )
		ENDIF

		THIS.messageout( '' )
		THIS.messageout( REPLICATE('*',80) )
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Count_IgnoredFiles
		LPARAMETERS taFiles, tnFileCount
		EXTERNAL ARRAY taFiles
		LOCAL I, lnFound
		lnFound	= 0
		FOR I = 1 TO tnFileCount
			IF '\SUB_IGN\' $ UPPER(taFiles(m.I))
				lnFound	= lnFound + 1
			ENDIF
		ENDFOR
		RETURN lnFound
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_NoDevolverArchivosDeUnSubdirectorioConFoxBin2Prg_Ignore
		LOCAL laFiles(1), lnFileCount, lnIgnoredFound ;
			, loEx AS EXCEPTION

		TRY
			loEx			= NULL
			lnFileCount		= 0
			lnIgnoredFound	= 0
			STRTOFILE( '', THIS.icRootDir + 'SUB_IGN\.FoxBin2Prg_Ignore' )

			THIS.icObj.get_FilesFromDirectory( THIS.icRootDir, @laFiles, @lnFileCount )
			lnIgnoredFound	= THIS.Count_IgnoredFiles( @laFiles, lnFileCount )

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnFileCount, 2, lnIgnoredFound )
		ENDTRY
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_NoDevolverArchivosDeUnSubdirectorioConFoxBin2Prg_IgnoreOculto
		LOCAL laFiles(1), lnFileCount, lnIgnoredFound, lcLockFile ;
			, loEx AS EXCEPTION

		TRY
			loEx			= NULL
			lnFileCount		= 0
			lnIgnoredFound	= 0
			lcLockFile		= THIS.icRootDir + 'SUB_IGN\.FoxBin2Prg_Ignore'
			STRTOFILE( '', lcLockFile )
			THIS.icObj.o_FSO.GetFile( lcLockFile ).Attributes = 2	&& Hidden

			THIS.icObj.get_FilesFromDirectory( THIS.icRootDir, @laFiles, @lnFileCount )
			lnIgnoredFound	= THIS.Count_IgnoredFiles( @laFiles, lnFileCount )

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnFileCount, 2, lnIgnoredFound )
		ENDTRY
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_NoDevolverArchivosSiElDirectorioRaizTieneFoxBin2Prg_Ignore
		LOCAL laFiles(1), lnFileCount ;
			, loEx AS EXCEPTION

		TRY
			loEx			= NULL
			lnFileCount		= 0
			STRTOFILE( '', THIS.icRootDir + '.FoxBin2Prg_Ignore' )

			THIS.icObj.get_FilesFromDirectory( THIS.icRootDir, @laFiles, @lnFileCount )

		CATCH TO loEx

		FINALLY
			THIS.Evaluate_results( loEx, lnFileCount, 0, 0 )
		ENDTRY
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_DevolverTodosLosArchivosSinFoxBin2Prg_Ignore
		LOCAL laFiles(1), lnFileCount ;
			, loEx AS EXCEPTION

		TRY
			loEx			= NULL
			lnFileCount		= 0

			THIS.icObj.get_FilesFromDirectory( THIS.icRootDir, @laFiles, @lnFileCount )

		CATCH TO loEx

		FINALLY
			*-- 4 files: a.prg, b.prg, c.prg, d.prg
			THIS.assertequals( 4, lnFileCount, 'File count without ignore file' )
		ENDTRY
	ENDFUNC


ENDDEFINE

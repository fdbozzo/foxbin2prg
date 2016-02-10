*--------------------------------------------------------------------------------------------------------------
*-- FileName_Caps.PRG
*-- CAPITALIZA EL NOMBRE Y EXTENSIÓN DEL ARCHIVO INDICADO SEGÚN LA CONFIGURACIÓN INDICADA
*-- Fernando D. Bozzo - 24/12/2013
*--------------------------------------------------------------------------------------------------------------
* EJEMPLOS CON MÁSCARAS IN-LINE (SIN ARCHIVO CONFIG):
* filename_caps( 'un_EjeMplo.PrG', '*.pRg:M.M' )			==> 'un_EjeMplo.PrG'
* filename_caps( 'un_EjeMplo.PrG', '*.pRg:U.L' )			==> 'UN_EJEMPLO.prg'
* filename_caps( 'un_EjeMplo.PrG', '*.pRg:P.U' )			==> 'Un_ejemplo.PRG'
* filename_caps( 'UN_EJEMPLO.PRG', 'un_EjeMplo.pRg:M.M' )	==> 'un_EjeMplo.pRg'
*
* EJEMPLO CON MÁSCARAS EN ARCHIVO CONFIG 'filename_caps.cfg':
* filemask=*.TXT:P.L
* filemask=*.PDF:U.L
* filemask=*.APP:P.U
* filemask=un_EjeMplo.pRg:M.M
*
* filename_caps( 'UN_EJEMPLO.TXT', 'filename_caps.cfg', 'F' )	==> 'Un_ejemplo.prg'
* filename_caps( 'un_ejemplo.PDF', 'filename_caps.cfg', 'F' )	==> 'UN_EJEMPLO.prg'
* filename_caps( 'un_ejemplo.prg', 'filename_caps.cfg', 'F' )	==> 'Un_ejemplo.PRG'
* filename_caps( 'UN_EJEMPLO.PRG', 'filename_caps.cfg', 'F' )	==> 'un_EjeMplo.PrG'
*--------------------------------------------------------------------------------------------------------------
* PARÁMETROS:				(!=Obligatorio | ?=Opcional) (@=Pasar por referencia | v=Pasar por valor) (IN/OUT)
* tcFileName				(!v IN    ) Archivo a capitalizar
* tcFileMask				(?v IN    ) Mascara de archivo o archivo de configuración de máscaras (U,L,P,N,M)
*							            => Significado: (U)pper,(L)ower,(P)roper,(M)atch,(N)one
* tcFileMaskType			(?v IN    ) 'M' o nada=FileMask es una máscara, 'F'=FileMask es un archivo config.
* tcLog						(?@    OUT) Log generado por este programa
* tlRelanzarError			(?v IN    ) Indica si el error se debe relanzar (THROW) o no
* tcDontShowErrors			(?v IN    ) '1'=Don't show errors, Otherwise=Show errors
*--------------------------------------------------------------------------------------------------------------
LPARAMETERS tcFileName, tcFileMask, tcFileMaskType, tcLog, tlRelanzarError, tcDontShowErrors

#DEFINE CR_LF	CHR(13)+CHR(10)

LOCAL lcFileName ;
	, loFNC AS cl_FileName_Caps OF FileName_Caps.prg ;
	, loEx AS EXCEPTION

loFNC		= CREATEOBJECT("cl_FileName_Caps")
lcFileName	= loFNC.Capitalize( tcFileName, tcFileMask, tcFileMaskType, tcLog, tlRelanzarError, tcDontShowErrors )

RETURN lcFileName


DEFINE CLASS cl_FileName_Caps AS Custom

	PROCEDURE Capitalize
		LPARAMETERS tcFileName, tcFileMask, tcFileMaskType, tcLog, tlRelanzarError, tcDontShowErrors

		TRY
			LOCAL loEx AS EXCEPTION, laMasks(1,4), lcDefinition, lcFileDef, lcMaskDef, laLines(1), lcMenErr ;
				, I, X, lcName, lcExt, lcPath, lcFileName, laFile(1,5), lcLogFile, lcSys16, lnPosProg ;
				, loFSO AS Scripting.FileSystemObject

			loEx				= NULL
			loFSO				= CREATEOBJECT('Scripting.FileSystemObject')
			tcFileMaskType		= EVL(tcFileMaskType,'M')
			lcFileName			= tcFileName
			lcLogFile			= FORCEEXT(SYS(16),'LOG')
			tcLog				= ''
			tcDontShowErrors	= EVL( tcDontShowErrors, '0' )

			IF EMPTY(tcFileMask)
				IF tcFileMaskType <> 'F'
					tcLog	= tcLog + CR_LF + '- No hay máscara definida ni archivo de configuración'
					EXIT	&& No se indicó nada que hacer
				ELSE
					lcSys16 = SYS(16)
					IF LEFT(lcSys16,10) == 'PROCEDURE '
						lnPosProg	= AT(" ", lcSys16, 2) + 1
					ELSE
						lnPosProg	= 1
					ENDIF

					tcFileMask	= FORCEEXT( SUBSTR( lcSys16, lnPosProg ), 'CFG' )
					tcLog	= tcLog + CR_LF + '- Se usará el archivo de configuración [' + tcFileMask + ']'
					IF NOT FILE(tcFileMask)
						ERROR 'El archivo de configuración de FileName_CAPS [' + tcFileMask + '] no existe!'
					ENDIF
				ENDIF
			ENDIF

			IF tcFileMaskType == 'M'	&& Máscara in-line
				*-- Estructura: Filename.Ext:FNameMask.ExtMask;...
				tcLog	= tcLog + CR_LF + '- Máscaras definidas: [' + tcFileMask + ']'
				FOR I = 1 TO OCCURS( ';', tcFileMask + ';' )
					lcDefinition	= GETWORDNUM( tcFileMask + ';', I, ';' )
					lcFileDef		= GETWORDNUM( lcDefinition, 1, ':' )
					lcMaskDef		= GETWORDNUM( lcDefinition, 2, ':' )
					laMasks(I,1)	= JUSTSTEM( lcFileDef )
					laMasks(I,2)	= JUSTEXT( lcFileDef )
					laMasks(I,3)	= JUSTSTEM( lcMaskDef )
					laMasks(I,4)	= JUSTEXT( lcMaskDef )
				ENDFOR
			ELSE	&& Archivo de configuración
				*-- Estructura:
				* filemask=Filename.Ext:FilenameCap.ExtCap => Cap: (U)pper,(L)ower,(P)roper,(M)atch,(N)one
				* filemask=*.PDF:U.L		==> <NOMBREARCHIVO.pdf>
				* filemask=*.DOT:L.U		==> <nombrearchivo.DOT>
				* filemask=*.PRG:C.N		==> <Nombrearchivo.ini>
				* filemask=EjEmPlO.iNi:C.N	==> <Ejemplo.iNi>
				X = 0
				FOR I = 1 TO ALINES( laLines, FILETOSTR( tcFileMask ), 1+4 )
					IF LOWER( LEFT( laLines(I), 8 ) ) == 'filemask'
						tcLog	= tcLog + CR_LF + '- Se encontró la máscara: [' + laLines(I) + ']'
						X = X + 1
						lcDefinition	= GETWORDNUM( laLines(I), 2, '=' )
						lcFileDef		= GETWORDNUM( lcDefinition, 1, ':' )
						lcMaskDef		= GETWORDNUM( lcDefinition, 2, ':' )
						DIMENSION laMasks(X,4)
						laMasks(X,1)	= JUSTSTEM( lcFileDef )		&& Name
						laMasks(X,2)	= JUSTEXT( lcFileDef )		&& Ext
						laMasks(X,3)	= JUSTSTEM( lcMaskDef )		&& Name Mask
						laMasks(X,4)	= JUSTEXT( lcMaskDef )		&& Ext Mask
					ENDIF
				ENDFOR
			ENDIF

			*-- FileName: "c:\desa\sourcesafe\myfile.ext"
			lcPath	= JUSTPATH( lcFileName )
			lcName	= JUSTSTEM( lcFileName )
			lcExt	= JUSTEXT( lcFileName )

			FOR I = 1 TO ALEN( laMasks, 1 )
				IF LIKE( UPPER( FORCEEXT( laMasks(I,1), laMasks(I,2) ) ), UPPER( FORCEEXT( lcName, lcExt ) ) )
					*-- EVALUACIÓN DEL NOMBRE
					DO CASE
					CASE UPPER(laMasks(I,3)) == 'U'
						lcFileName	= UPPER(lcName)
					CASE UPPER(laMasks(I,3)) == 'L'
						lcFileName	= LOWER(lcName)
					CASE UPPER(laMasks(I,3)) == 'P'
						lcFileName	= PROPER(lcName)
					CASE UPPER(laMasks(I,3)) == 'N'
						lcFileName	= lcName
					OTHERWISE	&& (M)atch: Tal cual aparece definido
						IF '?' $ laMasks(I,1) OR '*' $ laMasks(I,1)
							ERROR 'Para (M)atch no puede usar máscara "' + laMasks(I,1) + '"'
						ENDIF
						lcFileName	= laMasks(I,1)
					ENDCASE

					*-- EVALUACIÓN DE LA EXTENSIÓN
					DO CASE
					CASE UPPER(laMasks(I,4)) == 'U'
						lcFileName	= FORCEEXT( lcFileName + '.' + lcExt, UPPER(lcExt) )
					CASE UPPER(laMasks(I,4)) == 'L'
						lcFileName	= FORCEEXT( lcFileName + '.' + lcExt, LOWER(lcExt) )
					CASE UPPER(laMasks(I,4)) == 'P'
						lcFileName	= FORCEEXT( lcFileName + '.' + lcExt, PROPER(lcExt) )
					CASE UPPER(laMasks(I,4)) == 'N'
						lcFileName	= FORCEEXT( lcFileName + '.' + lcExt, lcExt )
					OTHERWISE	&& (M)atch: Tal cual aparece definido
						IF '?' $ laMasks(I,1) OR '*' $ laMasks(I,1)
							ERROR 'Para (M)atch no puede usar máscara "' + laMasks(I,1) + '"'
						ENDIF
						lcFileName	= FORCEEXT( lcFileName + '.' + lcExt, laMasks(I,2) )
					ENDCASE

					lcFileName	= FORCEPATH( lcFileName, lcPath )
					tcLog	= tcLog + CR_LF + '- El archivo se debe renombrar a [' + lcFileName + ']'
					EXIT
				ENDIF
			ENDFOR

			IF ADIR( laFile, lcFileName, '', 1 ) > 0 AND laFile(1,1) <> JUSTFNAME(lcFileName)
				loFSO.MoveFile( FORCEPATH( laFile(1,1), JUSTPATH(lcFileName) ), lcFileName )
				tcLog	= tcLog + CR_LF + '  => Se renombrará a [' + lcFileName + ']'
			ELSE
				tcLog	= tcLog + CR_LF + '  => No se renombrará a [' + lcFileName + '] porque ya estaba correcto.'
			ENDIF


		CATCH TO loEx
			IF tlRelanzarError THEN
				THROW
			ELSE
				IF '800a0046:' $ loEx.Details
					tcLog	= tcLog + CR_LF + '  => No se renombrará a [' + lcFileName + '] porque el archivo estaba en uso o no se puede acceder a el.'
				ENDIF

				lcMenErr	= 'ERROR ' + TRANSFORM(loEx.ERRORNO) + ', ' + loEx.MESSAGE + CHR(13) ;
					+ loEx.PROCEDURE + ', line ' + TRANSFORM(loEx.LINENO) + CHR(13) ;
					+ loEx.LINECONTENTS

				IF TRANSFORM(tcDontShowErrors) # '1' THEN
					MESSAGEBOX( lcMenErr, 0+16+4096, 'ATENCIÓN!! Ha ocurrido un error al capitalizar', 600000 )
				ENDIF
			ENDIF

		FINALLY
			loFSO		= NULL
			tcFileName	= lcFileName

			*-- Si existe FileName_Caps.LOG, lo actualiza
			IF FILE(lcLogFile)
				IF NOT EMPTY(lcMenErr)
					tcLog	= tcLog + CR_LF + CR_LF + lcMenErr
				ENDIF

				STRTOFILE( tcLog, lcLogFile, 1 )
			ENDIF

		ENDTRY

		RETURN lcFileName
	ENDPROC

ENDDEFINE && CLASS cl_FileName_Caps AS Custom

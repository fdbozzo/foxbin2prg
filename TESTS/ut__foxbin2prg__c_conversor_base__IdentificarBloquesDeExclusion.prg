DEFINE CLASS ut__foxbin2prg__c_conversor_base__IdentificarBloquesDeExclusion as FxuTestCase OF FxuTestCase.prg

	#IF .F.
		LOCAL THIS AS ut__foxbin2prg__c_conversor_base__IdentificarBloquesDeExclusion OF ut__foxbin2prg__c_conversor_base__IdentificarBloquesDeExclusion.PRG
	#ENDIF
	
	#DEFINE C_PROC		'PROCEDURE'
	#DEFINE C_ENDPROC	'ENDPROC'
	#DEFINE C_TEXT		'TEXT'
	#DEFINE C_ENDTEXT	'ENDTEXT'
	#DEFINE C_IF_F		'#IF'
	#DEFINE C_ENDIF		'#ENDIF'
	icObj = NULL
	
	*******************************************************************************************************************************************
	FUNCTION Setup
		THIS.icObj = NEWOBJECT("c_conversor_prg_a_bin", "FOXBIN2PRG.PRG")

	ENDFUNC

	
	*******************************************************************************************************************************************
	FUNCTION TearDown
		THIS.icObj = NULL
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Evaluate_results
		LPARAMETERS taExpected_Pos, taPos, tnPos_Count

		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF
		
		THIS.messageout( "Pares de posiciones esperados: " + TRANSFORM(tnPos_Count) )
		FOR I = 1 TO tnPos_Count
			THIS.messageout( "Posición de Inicio/Fin esperados: " + TRANSFORM(taExpected_Pos(I,1)) + ',' + TRANSFORM(taExpected_Pos(I,2)) )
		ENDFOR
		
		THIS.assertequals( ALEN(taExpected_Pos,1), ALEN(taPos,1), "Posición de Inicio/Fin" )

		FOR I = 1 TO tnPos_Count
			THIS.assertequals( TRANSFORM(taExpected_Pos(I,1)) + ',' + TRANSFORM(taExpected_Pos(I,2)) ;
				, TRANSFORM(taPos(I,1)) + ',' + TRANSFORM(taPos(I,2)) ;
				, "Posición de Inicio/Fin" )
		ENDFOR
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_ObtenerLaUbicacionDelBloque_IF_ENDIF_CuandoCodigoCon_IF_ENDIF_predominante_esEvaluado
		LOCAL lcMethod, laLineas(1), lnLineas, laPos(1,2), lnPos_Count, laExpected_Pos(2,2)
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj
		
		*-- Input and expected params
		STORE '' TO lcMethod
		laExpected_Pos(1,1)	= 3
		laExpected_Pos(1,2)	= 5
		laExpected_Pos(2,1)	= 7
		laExpected_Pos(2,2)	= 9

		TEXT TO lcMethod NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2+4
			<<C_PROC>> myMethod_B
				*-- Code Block
				<<C_IF_F>>
					<<C_TEXT>>
				<<C_ENDIF>>
				*-- Code Block
				<<C_IF_F>>
					<<C_ENDTEXT>>
				<<C_ENDIF>>
			<<C_ENDPROC>>
		ENDTEXT
		
		lnLineas	= ALINES( laLineas, lcMethod )

		*-- Test
		loObj.identificarBloquesDeExclusion( @laLineas, lnLineas, , @laPos, @lnPos_Count )
		
		THIS.Evaluate_results( @laExpected_Pos, @laPos, lnPos_Count )
		
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_ObtenerLaUbicacionDelBloque_IF_ENDIF_Externo_CuandoCodigoCon_IF_ENDIF_predominante_esEvaluado
		LOCAL lcMethod, laLineas(1), lnLineas, laPos(1,2), lnPos_Count, laExpected_Pos(1,2)
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj
		
		*-- Input and expected params
		STORE '' TO lcMethod
		laExpected_Pos(1,1)	= 3
		laExpected_Pos(1,2)	= 9

		TEXT TO lcMethod NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2+4
			<<C_PROC>> myMethod_B
				*-- Code Block
				<<C_IF_F>>
					<<C_IF_F>>
						<<C_TEXT>>
						*-- Code Block
						<<C_ENDTEXT>>
					<<C_ENDIF>>
				<<C_ENDIF>>
			<<C_ENDPROC>>
		ENDTEXT
		
		lnLineas	= ALINES( laLineas, lcMethod )

		*-- Test
		loObj.identificarBloquesDeExclusion( @laLineas, lnLineas, , @laPos, @lnPos_Count )
		
		THIS.Evaluate_results( @laExpected_Pos, @laPos, lnPos_Count )
		
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_ObtenerLaUbicacionDelBloque_TEXT_ENDTEXT_CuandoCodigoCon_TEXT_ENDTEXT_predominante_esEvaluado
		LOCAL lcMethod, laLineas(1), lnLineas, laPos(1,2), lnPos_Count, laExpected_Pos(2,2)
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj
		
		*-- Input and expected params
		STORE '' TO lcMethod
		laExpected_Pos(1,1)	= 3
		laExpected_Pos(1,2)	= 5
		laExpected_Pos(2,1)	= 7
		laExpected_Pos(2,2)	= 9

		TEXT TO lcMethod NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2+4
			<<C_PROC>> myMethod_B
				*-- Code Block
				<<C_TEXT>>
					<<C_IF_F>>
				<<C_ENDTEXT>>
				*-- Code Block
				<<C_TEXT>>
					<<C_ENDIF>>
				<<C_ENDTEXT>>
			<<C_ENDPROC>>
		ENDTEXT
		
		lnLineas	= ALINES( laLineas, lcMethod )

		*-- Test
		loObj.identificarBloquesDeExclusion( @laLineas, lnLineas, , @laPos, @lnPos_Count )
		
		THIS.Evaluate_results( @laExpected_Pos, @laPos, lnPos_Count )
		
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_NoEncontrarNingunBloque_TEXT_ENDTEXT_CuandoUnaLineaQueComienzaConUnCampoLlamado_Text_esEvaluado
		LOCAL lcMethod, laLineas(1), lnLineas, laPos(1,2), lnPos_Count, laExpected_Pos(1,2)
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj
		
		*-- Input and expected params
		STORE '' TO lcMethod
		laExpected_Pos(1,1)	= 0
		laExpected_Pos(1,2)	= 0

		TEXT TO lcMethod NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2+4
			<<C_PROC>> myMethod_B
				*-- Code Block
				IF !FOUND()
					APPEND BLANK
					REPLACE CURSOR	WITH "cawlmain", START WITH 1, END WITH 999999, isnumeric WITH .F., lastused WITH "", ;	&& Worst case for next line
						  TEXT	WITH "Wärmeobjekte", standard WITH .T.
				ENDIF

				*-- Code Block
				CREATE CURSOR vorlaufsatz (;
					Satzlaenge 		C(4),;
					Satzart    		C(2),;
					Folgekennz 		C(2),;
					Absender			C(2),;
					Empfaenger		C(2),;
					Rohdatum			C(8),;
					RohZeit			C(4),;
					LFDNr				C(4),;	&& Worst case for next line
					Text				C(26),;
					Trenner			C(2),;
					DATUM				D				NULL,;
					ZEIT				C(8)			NULL,;
					KEYLINEID		N(6,0)		NULL )

				*-- Code Block
				CREATE CURSOR eomaildbf (;
					adresse c(8) NULL DEFAULT .NULL.,;
					zaehler i AUTOINC NEXTVALUE 1 STEP 1,;
					startseite N(6) NOT NULL DEFAULT 0,;
					endseite N(6) NOT NULL DEFAULT 0,;
					vseite N(6) NOT NULL DEFAULT 0,;
					lfdnr c(30) NULL DEFAULT .NULL.,;
					linkkey int,;
					email CHAR(60) NULL DEFAULT .NULL.,;
					subject VARCHAR(254) NULL DEFAULT .NULL.,;	&& Worst case for next line
					TEXT m NULL DEFAULT .NULL.,;
					docname c(50) NULL DEFAULT .NULL.,;
					versenden l NOT NULL DEFAULT .F.,;
					signierung l NOT NULL DEFAULT .F.,;
					praefix c(10) NULL DEFAULT .NULL.,;
					signdatei VARCHAR(254) NULL DEFAULT .NULL.,;
					signiert l NOT NULL DEFAULT .F.,;
					ccemail VARCHAR(254) NULL DEFAULT .NULL.,;
					datei VARCHAR(254) NULL DEFAULT .NULL.)

				*-- Code Block
				CREATE CURSOR c_prf_zeilen (;
					lauf I NULL, ;
					zeile I NOT NULL, ;
					Text C(200) NULL ;
					)

			<<C_ENDPROC>>
		ENDTEXT
		
		lnLineas	= ALINES( laLineas, lcMethod )

		*-- Test
		loObj.identificarBloquesDeExclusion( @laLineas, lnLineas, , @laPos, @lnPos_Count )
		
		THIS.Evaluate_results( @laExpected_Pos, @laPos, lnPos_Count )
		
	ENDFUNC


ENDDEFINE

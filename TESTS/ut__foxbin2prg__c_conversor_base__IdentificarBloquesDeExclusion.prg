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
		LPARAMETERS taExpected_Pos, taPos, tnPos_Count, taLineasExclusion_Esperadas, taLineasExclusion

		LOCAL loObj AS c_conversor_base OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj

		IF PCOUNT() = 0
			THIS.messageout( "* Support method, not a valid test." )
			RETURN .T.
		ENDIF
		
		*-- INFORMACIÓN
		THIS.messageout( "Pares de posiciones esperados: " + TRANSFORM(tnPos_Count) )
		FOR I = 1 TO tnPos_Count
			THIS.messageout( "Posición de Inicio/Fin esperados: " + TRANSFORM(taExpected_Pos(I,1)) + ',' + TRANSFORM(taExpected_Pos(I,2)) )
		ENDFOR

		THIS.messageout( "" )

		IF TYPE( "taLineasExclusion",1 ) = "A"
			FOR I = 1 TO ALEN(taLineasExclusion_Esperadas,1)
				THIS.messageout( "Línea de exclusión " + STR(I,2) + " esperada: " + TRANSFORM( taLineasExclusion_Esperadas(I) ) ;
					+ IIF( taLineasExclusion_Esperadas(I), ' <', '' ) )
			ENDFOR
		ENDIF

		THIS.messageout( REPLICATE("*",80) )
		
		*-- TESTS
		THIS.assertequals( ALEN(taExpected_Pos,1), ALEN(taPos,1), "Posición de Inicio/Fin" )

		FOR I = 1 TO tnPos_Count
			THIS.assertequals( TRANSFORM(taExpected_Pos(I,1)) + ',' + TRANSFORM(taExpected_Pos(I,2)) ;
				, TRANSFORM(taPos(I,1)) + ',' + TRANSFORM(taPos(I,2)) ;
				, "Posición de Inicio/Fin" )
		ENDFOR
		
		IF TYPE( "taLineasExclusion",1 ) = "A"
			THIS.assertequalsarrays( @taLineasExclusion_Esperadas, @taLineasExclusion, "Líneas de Exclusión" )
		ENDIF
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_ObtenerLaUbicacionDelBloque_IF_ENDIF_CuandoCodigoCon_IF_ENDIF_predominante_esEvaluado
		LOCAL lcMethod, laLineas(1), lnLineas, laPos(1,2), lnPos_Count, laExpected_Pos(2,2) ;
			, laLineasExclusion(12), laLineasExclusion_Esperadas(12)
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj
		
		*-- Input and expected params
		STORE '' TO lcMethod
		laExpected_Pos(1,1)	= 3
		laExpected_Pos(1,2)	= 6
		laExpected_Pos(2,1)	= 8
		laExpected_Pos(2,2)	= 11
		laLineasExclusion_Esperadas( 3)	= .T.
		laLineasExclusion_Esperadas( 4)	= .T.
		laLineasExclusion_Esperadas( 5)	= .T.
		laLineasExclusion_Esperadas( 7)	= .T.
		laLineasExclusion_Esperadas( 8)	= .T.
		laLineasExclusion_Esperadas( 9)	= .T.
		laLineasExclusion_Esperadas(10)	= .T.
		laLineasExclusion_Esperadas(11)	= .T.

		TEXT TO lcMethod NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2
			<<C_PROC>> myMethod_B
				*-- Code Block
				<<C_IF_F>>
					<<C_TEXT>>
					value ;
				<<C_ENDIF>>
				*-- Code Block
				<<C_IF_F>>
					<<C_ENDTEXT>>
					value ,
				<<C_ENDIF>>
			<<C_ENDPROC>>
		ENDTEXT
		
		lnLineas	= ALINES( laLineas, lcMethod )

		*-- Test
		loObj.identificarBloquesDeExclusion( @laLineas, lnLineas, , @laLineasExclusion, @lnPos_Count, @laPos )
		
		*-- Evaluación de resultados
		THIS.Evaluate_results( @laExpected_Pos, @laPos, lnPos_Count, @laLineasExclusion_Esperadas, @laLineasExclusion )
		
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_ObtenerLaUbicacionDelBloque_IF_ENDIF_Externo_CuandoCodigoCon_IF_ENDIF_predominante_esEvaluado
		LOCAL lcMethod, laLineas(1), lnLineas, laPos(1,2), lnPos_Count, laExpected_Pos(1,2) ;
			, laLineasExclusion(10), laLineasExclusion_Esperadas(10)
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj
		
		*-- Input and expected params
		STORE '' TO lcMethod
		laExpected_Pos(1,1)	= 3
		laExpected_Pos(1,2)	= 9
		laLineasExclusion_Esperadas( 3)	= .T.
		laLineasExclusion_Esperadas( 4)	= .T.
		laLineasExclusion_Esperadas( 5)	= .T.
		laLineasExclusion_Esperadas( 6)	= .T.
		laLineasExclusion_Esperadas( 7)	= .T.
		laLineasExclusion_Esperadas( 8)	= .T.
		laLineasExclusion_Esperadas( 9)	= .T.

		TEXT TO lcMethod NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2
			<<C_PROC>> myMethod_B
				*-- Code Block
				<<C_IF_F>>
					<<C_IF_F>>
						<<C_TEXT>>
						*-- Code Block ;
						<<C_ENDTEXT>>
					<<C_ENDIF>>
				<<C_ENDIF>>
			<<C_ENDPROC>>
		ENDTEXT
		
		lnLineas	= ALINES( laLineas, lcMethod )

		*-- Test
		loObj.identificarBloquesDeExclusion( @laLineas, lnLineas, , @laLineasExclusion, @lnPos_Count, @laPos )
		
		*-- Evaluación de resultados
		THIS.Evaluate_results( @laExpected_Pos, @laPos, lnPos_Count, @laLineasExclusion_Esperadas, @laLineasExclusion )
		
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_ObtenerLaUbicacionDelBloque_TEXT_ENDTEXT_CuandoCodigoCon_TEXT_ENDTEXT_predominante_esEvaluado
		LOCAL lcMethod, laLineas(1), lnLineas, laPos(1,2), lnPos_Count, laExpected_Pos(2,2) ;
			, laLineasExclusion(12), laLineasExclusion_Esperadas(12)
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj
		
		*-- Input and expected params
		STORE '' TO lcMethod
		laExpected_Pos(1,1)	= 3
		laExpected_Pos(1,2)	= 6
		laExpected_Pos(2,1)	= 8
		laExpected_Pos(2,2)	= 11
		laLineasExclusion_Esperadas( 3)	= .T.
		laLineasExclusion_Esperadas( 4)	= .T.
		laLineasExclusion_Esperadas( 5)	= .T.
		laLineasExclusion_Esperadas( 7)	= .T.
		laLineasExclusion_Esperadas( 8)	= .T.
		laLineasExclusion_Esperadas( 9)	= .T.
		laLineasExclusion_Esperadas(10)	= .T.
		laLineasExclusion_Esperadas(11)	= .T.

		TEXT TO lcMethod NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2
			<<C_PROC>> myMethod_B
				*-- Code Block
				<<C_TEXT>>
					<<C_IF_F>>
					value ;
				<<C_ENDTEXT>>
				*-- Code Block
				<<C_TEXT>>
					<<C_ENDIF>>
					value ,
				<<C_ENDTEXT>>
			<<C_ENDPROC>>
		ENDTEXT
		
		lnLineas	= ALINES( laLineas, lcMethod )

		*-- Test
		loObj.identificarBloquesDeExclusion( @laLineas, lnLineas, , @laLineasExclusion, @lnPos_Count, @laPos )
		
		*-- Evaluación de resultados
		THIS.Evaluate_results( @laExpected_Pos, @laPos, lnPos_Count, @laLineasExclusion_Esperadas, @laLineasExclusion )
		
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_NoEncontrarBloque_TEXT_ENDTEXT_CuandoEvaluaUnaLineaQueComienzaConUnCampoLlamado_Text_YLineaAnteriorTerminaEn_PuntoYComa
		LOCAL lcMethod, laLineas(1), lnLineas, laPos(1,2), lnPos_Count, laExpected_Pos(1,2)
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj
		
		*-- Input and expected params
		STORE '' TO lcMethod
		laExpected_Pos(1,1)	= 0
		laExpected_Pos(1,2)	= 0

		TEXT TO lcMethod NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2
			<<C_PROC>> myMethod_B
				*-- Code Block
				IF !FOUND()
					APPEND BLANK
					REPLACE CURSOR	WITH "cawlmain", START WITH 1, END WITH 999999, isnumeric WITH .F., lastused WITH "", ;	&& Worst case for next line with a field called "text"
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
					LFDNr				C(4),;	&& Worst case for next line with a field called "text"
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
					subject VARCHAR(254) NULL DEFAULT .NULL.,;	&& Worst case for next line with a field called "text"
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
		loObj.identificarBloquesDeExclusion( @laLineas, lnLineas, , , @lnPos_Count, @laPos )
		
		THIS.Evaluate_results( @laExpected_Pos, @laPos, lnPos_Count )
		
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_NoEncontrarBloque_TEXT_ENDTEXT_CuandoEvaluaUnaLineaQueComienzaConUnCampoLlamado_Text_YLineaAnteriorTerminaEn_Coma
		LOCAL lcMethod, laLineas(1), lnLineas, laPos(1,2), lnPos_Count, laExpected_Pos(1,2) ;
			, laLineasExclusion(29), laLineasExclusion_Esperadas(29)
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj
		
		*-- Input and expected params
		STORE '' TO lcMethod
		laExpected_Pos(1,1)	= 4
		laExpected_Pos(1,2)	= 15
		FOR I = 4 TO 15
			laLineasExclusion_Esperadas(I)	= .T.
		ENDFOR

		TEXT TO lcMethod NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2
			<<C_PROC>> myMethod_B
				*-- Code Block
				IF ODBC_Query.odbc
				   <<C_TEXT>> TO cSQL NOSHOW
				      update menuitems
				      set    parent_menuitem_id = ?iParent_menuitem_id,	&& Worst case for next line with a field called "text"
				             text     = ?strText,
				             command  = ?strCommand,
				             message  = ?strMessage,
				             keyname  = ?strKeyname,
				             keylabel = ?strKeylabel,
				             skipfor  = ?strSkipfor,
				             sequence = ?iSequence
				      where  menuitem_id = ?iMenuitem_id
				   <<C_ENDTEXT>>
				   ODBC_Query(cSQL)
				ELSE
				   update menuitems;
				   set    parent_menuitem_id = iParent_menuitem_id,;	&& Worst case for next line with a field called "text"
				          text     = strText,;
				          command  = strCommand,;
				          message  = strMessage,;
				          keyname  = strKeyname,;
				          keylabel = strKeylabel,;
				          skipfor  = strSkipfor,;
				          sequence = iSequence;
				   where  menuitem_id == iMenuitem_id
				ENDIF
			<<C_ENDPROC>>
		ENDTEXT
		
		lnLineas	= ALINES( laLineas, lcMethod )

		*-- Test
		loObj.identificarBloquesDeExclusion( @laLineas, lnLineas, , @laLineasExclusion, @lnPos_Count, @laPos )
		
		*-- Evaluación de resultados
		THIS.Evaluate_results( @laExpected_Pos, @laPos, lnPos_Count, @laLineasExclusion_Esperadas, @laLineasExclusion )
		
	ENDFUNC


	*******************************************************************************************************************************************
	FUNCTION Deberia_EncontrarBloque_TEXT_ENDTEXT_CuandoEvaluaUnaLineaQueTerminaConUn_EndText_YLineaAnteriorTerminaEn_Coma
		LOCAL lcMethod, laLineas(1), lnLineas, laPos(1,2), lnPos_Count, laExpected_Pos(1,2) ;
			, laLineasExclusion(23), laLineasExclusion_Esperadas(23)
		LOCAL loObj AS c_conversor_prg_a_bin OF "FOXBIN2PRG.PRG"
		loObj	= THIS.icObj
		
		*-- Input and expected params
		STORE '' TO lcMethod
		laExpected_Pos(1,1)	= 3
		laExpected_Pos(1,2)	= 13
		FOR I = 3 TO 13
			laLineasExclusion_Esperadas(I)	= .T.
		ENDFOR

		TEXT TO lcMethod NOSHOW TEXTMERGE FLAGS 1 PRETEXT 1+2
			<<C_PROC>> Init
			Local lcRowSource
			<<C_TEXT>> To lcRowSource Textmerge Noshow
			Overview,ItemDtl,
			Forecasting,Forecasting,
			Purchase Orders,PurchaseOrders,
			Sales Orders,SalesOrders,
			Sales History,History,
			Inventory,Bins,
			Inventory History,InventoryHistory,
			Configuration,PartsInfo,
			Operations,Operations,
			<<C_ENDTEXT>>


			This.RowSource	   = Chrtran(lcRowSource, CRLF, '')
			This.ControlSource = 'Thisform.cStartPage'
			This.Value		   = ReadSetting('Item Detail Start Page', 'ItemDtl', .F., .T.)
			<<C_ENDPROC>>
			<<C_PROC>> Valid
			WriteSetting('Item Detail Start Page', This.Value, .F., .T.)
			Thisform.comboPartno.SetFocus()
			<<C_ENDPROC>>
		ENDTEXT
		
		lnLineas	= ALINES( laLineas, lcMethod )

		*-- Test
		loObj.identificarBloquesDeExclusion( @laLineas, lnLineas, , @laLineasExclusion, @lnPos_Count, @laPos )
		
		*-- Evaluación de resultados
		THIS.Evaluate_results( @laExpected_Pos, @laPos, lnPos_Count, @laLineasExclusion_Esperadas, @laLineasExclusion )
		
	ENDFUNC


ENDDEFINE

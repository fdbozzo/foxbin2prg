*-------------------------------------------------------------------------------------------------------------------------------------------
*-- DEUTSCHE ÜBERSETZUNG => UMBENENNEN DIESER DATEI IN [foxbin2prg.h] UND NEUKOMPILIEREN DER FOXBIN2PRG.PRG - Jeder ist frei die Strings anzupassen und zu übersetzen.
*-- NOTE: ES MÜSSEN ANFÜHRUNGSZEICHEN BENUTZT WERDEN, ODER SYNTAX ERRORS PASSIEREN BEIM COMPILE. SELTSAM :(
*-------------------------------------------------------------------------------------------------------------------------------------------
#DEFINE C_ASTERISK_EXT_NOT_ALLOWED_LOC						"* und ? Erweiterungen sind nicht erlaubt, da es gefährlich ist (binaries könnten überschrieben werden mit xx2 leeren Dateien)"
#DEFINE C_BACKLINK_CANT_UPDATE_BL_LOC						"Backlink kann nicht geupdated werden"
#DEFINE C_BACKLINK_OF_TABLE_LOC								"von Tabelle"
#DEFINE C_BACKUP_OF_LOC										"Mache Backup von: "
#DEFINE C_CANT_GENERATE_FILE_BECAUSE_IT_IS_READONLY_LOC		"Kann Datei [<<THIS.c_OutputFile>>] nicht generieren da sie Schreibgeschützt ist"
#DEFINE C_CONFIGFILE_LOC									"Benutze Konfigurationsdatei:"
#DEFINE C_CONVERTER_UNLOAD_LOC								"Konverter wird entladen"
#DEFINE C_CONVERTING_FILE_LOC								"Konvertiere Datei"
#DEFINE C_DATA_ERROR_CANT_PARSE_UNPAIRING_DOUBLE_QUOTES_LOC	"Datenfehler: Keine Analyse möglich da ungepaarte Anführungszeichen in Zeile <<lcMetadatos>>"
#DEFINE C_DUPLICATED_FILE_LOC								"Doppelte Datei"
#DEFINE C_ENDDEFINE_MARKER_NOT_FOUND_LOC					"Kann keinen Ende Marker [ENDDEFINE] in Zeile <<TRANSFORM( toClase._Inicio )>> für die ID [<<toClase._Nombre>>] finden"
#DEFINE C_END_MARKER_NOT_FOUND_LOC							"Kann keinen Ende Marker [<<ta_ID_Bloques(lnPrimerID,2)>>] welcher den Start Marker [<<ta_ID_Bloques(lnPrimerID,1)>>] in Zeile <<TRANSFORM(taBloquesExclusion(tnBloquesExclusion,1))>> schließt"
#DEFINE C_FIELD_NOT_FOUND_ON_FILE_STRUCTURE_LOC				"Feld [<<laProps(I)>>] nicht in der Struktur von Datei <<DBF('TABLABIN')>> gefunden"
#DEFINE C_FILE_DOESNT_EXIST_LOC								'Datei existiert nicht:'
#DEFINE C_FILE_NAME_IS_NOT_SUPPORTED_LOC					"Datei [<<.c_InputFile>>] wird nicht unterstützt"
#DEFINE C_FILE_NOT_FOUND_LOC								"Datei nicht gefunden"
#DEFINE C_EXTENSION_RECONFIGURATION_LOC						"Erweiterungsneukonfiguration:"
#DEFINE C_FOXBIN2PRG_ERROR_CAPTION_LOC						"FOXBIN2PRG: FEHLER!!"
#DEFINE C_FOXBIN2PRG_INFO_SINTAX_LOC						"FOXBIN2PRG: SYNTAX INFO"
#DEFINE C_FOXBIN2PRG_INFO_SINTAX_EXAMPLE_LOC				"FOXBIN2PRG <cFileSpec.Ext> [,cType ,cTextName ,cGenText ,cDontShowErrors ,cDebug, cDontShowProgress, cOriginalFileName, cRecompile, cNoTimestamps]" + CR_LF + CR_LF ;
	+ "Ein Beispiel für die Generierung der TXT von allen VCX in 'c:\development\classes', ohne Anzeige des Fehlerfensters und Generierung der LOG Datei: " + CR_LF ;
	+ "   FOXBIN2PRG 'c:\development\classes\*.vcx'  '0'  '0'  '0'  '1'  '1'" + CR_LF + CR_LF ;
	+ "Ein Beispiel für die Generierung der TXT von allen VCX in 'c:\development\classes', ohne Anzeige des Fehlerfensters und ohne LOG datei: " + CR_LF ;
	+ "   FOXBIN2PRG 'c:\development\classes\*.vc2'  '0'  '0'  '0'  '1'  '0'"
#DEFINE C_FOXBIN2PRG_JUST_VFP_9_LOC							"FOXBIN2PRG ist nur für Visual FoxPro 9.0!"
#DEFINE C_FOXBIN2PRG_WARN_CAPTION_LOC						"FOXBIN2PRG: WARNUNG!"
#DEFINE C_MENU_NOT_IN_VFP9_FORMAT_LOC						"Menu [<<THIS.c_InputFile>>] ist NICHT in VFP 9 Format! - Bitte zuerst nach VFP 9 konvertieren mit MODIFY MENU <<JUSTFNAME((THIS.c_InputFile))>>"
#DEFINE C_OBJECT_NAME_WITHOUT_OBJECT_OREG_LOC				"Objekt [<<toObj.CLASS>>] enthält nicht oReg Objekt (level <<TRANSFORM(tnNivel)>>)"
#DEFINE C_NAMES_CAPITALIZATION_PROGRAM_FOUND_LOC			"* Programm für Großschreibungssetzung [<<lcEXE_CAPS>>] gefunden"
#DEFINE C_NAMES_CAPITALIZATION_PROGRAM_NOT_FOUND_LOC		"* Programm für Großschreibungssetzung [<<lcEXE_CAPS>>] nicht gefunden"
#DEFINE C_ONLY_SETNAME_AND_GETNAME_RECOGNIZED_LOC			"Befehl nicht erkannt. Nur SETNAME und GETNAME erlaubt."
#DEFINE C_OUTPUT_FILE_IS_NOT_OVERWRITEN_LOC					"Optimierung: Ausgabedatei [<<THIS.c_OutputFile>>] wurde nicht überschrieben da sie dieselbe ist wie die neu generierte."
#DEFINE C_OUTPUTFILE_NEWER_THAN_INPUTFILE_LOC				"Optimierung: Ausgabedatei [<<THIS.c_OutputFile>>] wurde nicht erneuert da sie neuer ist als die Ursprungsdatei."
#DEFINE C_PROCEDURE_NOT_CLOSED_ON_LINE_LOC					"Procedur nicht geschlossen. Letzte Zeile des Codes muss ENDPROC sein. [<<laLineas(1)>>, Recno:<<RECNO()>>]"
#DEFINE C_PROCESSING_LOC									"Bearbeite Datei"
#DEFINE C_PROCESS_PROGRESS_LOC								"Bearbeitungsfortschritt:"
#DEFINE C_PROPERTY_NAME_NOT_RECOGNIZED_LOC					"Eigenschaft [<<TRANSFORM(tnPropertyID)>>] nicht erkannt."
#DEFINE C_REQUESTING_CAPITALIZATION_OF_FILE_LOC				"- Forder Großschreibung für Datei [<<tcFileName>>] an"
#DEFINE C_SOURCEFILE_LOC									"Source Datei: "
#DEFINE C_STRUCTURE_NESTING_ERROR_ENDPROC_EXPECTED_LOC		"Fehler in Verschachtelungsstruktur. ENDPROC erwartet, aber es wurde ENDDEFINE in Klasse <<toClase._Nombre>> (<<loProcedure._Nombre>>), Zeile <<TRANSFORM(I)>> der Datei <<THIS.c_InputFile>> gefunden"
#DEFINE C_STRUCTURE_NESTING_ERROR_ENDPROC_EXPECTED_2_LOC	"Fehler in Verschachtelungsstruktur. ENDPROC wurde erwartet, aber es wurde ENDDEFINE in Klasse <<toClase._Nombre>> (<<toObjeto._Nombre>>.<<loProcedure._Nombre>>), Zeile <<TRANSFORM(I)>> der Datei <<THIS.c_InputFile>> gefunden"
#DEFINE C_UNKNOWN_CLASS_NAME_LOC							"Unbekannte Klasse [<<THIS.CLASS>>]"
#DEFINE C_WARN_TABLE_ALIAS_ON_INDEX_EXPRESSION_LOC			"WARNUNG!!" + CR_LF+ "SICHERSTELLEN DAS KEIN TABELLENALIAS IN DEM INDEXAUSDRUCK BENUTZT WIRD!! (z.B.: index on <<UPPER(JUSTSTEM(THIS.c_InputFile))>>.campo tag keyname)"

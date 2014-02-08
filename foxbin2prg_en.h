*-------------------------------------------------------------------------------------------------------------------------------------------
*-- ENGLISH TRANSLATION => RENAME OR COPY TO [foxbin2prg.h] TO USE, AND RECOMPILE FOXBIN2PRG.PRG - Feel free to change or adapt the strings.
*-- NOTE: MUST USE DOUBLE QUOTES, OR SYNTAX ERRORS HAPPEN WHEN COMPILING. STRANGE :(
*-------------------------------------------------------------------------------------------------------------------------------------------
#DEFINE C_ASTERISK_EXT_NOT_ALLOWED_LOC						"* and ? extensions are not allowed because is dangerous (binaries can be overwriten with xx2 empty files)"
#DEFINE C_BACKLINK_CANT_UPDATE_BL_LOC						"Could not update backlink"
#DEFINE C_BACKLINK_OF_TABLE_LOC								"of table"
#DEFINE C_BACKUP_OF_LOC										"Doing Backup of: "
#DEFINE C_CANT_GENERATE_FILE_BECAUSE_IT_IS_READONLY_LOC		"Can not generate file [<<THIS.c_OutputFile>>] because it is ReadOnly"
#DEFINE C_CONFIGFILE_LOC									"Using configuration file:"
#DEFINE C_CONVERTER_UNLOAD_LOC								"Converter unload"
#DEFINE C_CONVERTING_FILE_LOC								"Converting file"
#DEFINE C_DATA_ERROR_CANT_PARSE_UNPAIRING_DOUBLE_QUOTES_LOC	"Data Error: Cant't parse because unpairing double-quotes on line <<lcMetadatos>>"
#DEFINE C_DUPLICATED_FILE_LOC								"Duplicated file"
#DEFINE C_ENDDEFINE_MARKER_NOT_FOUND_LOC					"No se ha encontrado el marcador de fin [ENDDEFINE] de la línea <<TRANSFORM( toClase._Inicio )>> para el identificador [<<toClase._Nombre>>]"
#DEFINE C_END_MARKER_NOT_FOUND_LOC							"Can not found end marker [<<ta_ID_Bloques(lnPrimerID,2)>>] that closes start marker [<<ta_ID_Bloques(lnPrimerID,1)>>] on line <<TRANSFORM(taBloquesExclusion(tnBloquesExclusion,1))>>"
#DEFINE C_FIELD_NOT_FOUND_ON_FILE_STRUCTURE_LOC				"Field [<<laProps(I)>>] not found on structure of file <<DBF('TABLABIN')>>"
#DEFINE C_FILE_DOESNT_EXIST_LOC								'File does not exist:'
#DEFINE C_FILE_NAME_IS_NOT_SUPPORTED_LOC					"File [<<.c_InputFile>>] is not supported"
#DEFINE C_FILE_NOT_FOUND_LOC								"File not found"
#DEFINE C_EXTENSION_RECONFIGURATION_LOC						"Extension Reconfiguration:"
#DEFINE C_FOXBIN2PRG_ERROR_CAPTION_LOC						"FOXBIN2PRG: ERROR!!"
#DEFINE C_FOXBIN2PRG_INFO_SINTAX_LOC						"FOXBIN2PRG: SYNTAX INFO"
#DEFINE C_FOXBIN2PRG_INFO_SINTAX_EXAMPLE_LOC				"FOXBIN2PRG <cFileSpec.Ext> [,cType ,cTextName ,cGenText ,cNoMostrarErrores ,cDebug, cDontShowProgress, cOriginalFileName, cRecompile, cNoTimestamps]" + CR_LF + CR_LF ;
	+ "Example to generate TXT of all VCX of 'c:\desa\clases', without showing error window and generating LOG file: " + CR_LF ;
	+ "   FOXBIN2PRG 'c:\desa\clases\*.vcx'  '0'  '0'  '0'  '1'  '1'" + CR_LF + CR_LF ;
	+ "Example to generate TXT of all VCX of 'c:\desa\clases', without showing error window and without LOG file: " + CR_LF ;
	+ "   FOXBIN2PRG 'c:\desa\clases\*.vc2'  '0'  '0'  '0'  '1'  '0'"
#DEFINE C_FOXBIN2PRG_JUST_VFP_9_LOC							"FOXBIN2PRG is only for Visual FoxPro 9.0!"
#DEFINE C_FOXBIN2PRG_WARN_CAPTION_LOC						"FOXBIN2PRG: WARNING!"
#DEFINE C_MENU_NOT_IN_VFP9_FORMAT_LOC						"Menu [<<THIS.c_InputFile>>] is NOT VFP 9 Format! - Please convert to VFP 9 with MODIFY MENU <<JUSTFNAME((THIS.c_InputFile))>>"
#DEFINE C_OBJECT_NAME_WITHOUT_OBJECT_OREG_LOC				"Object [<<toObj.CLASS>>] does not contain oReg object (level <<TRANSFORM(tnNivel)>>)"
#DEFINE C_NAMES_CAPITALIZATION_PROGRAM_FOUND_LOC			"* Names capitalization program [<<lcEXE_CAPS>>] found"
#DEFINE C_NAMES_CAPITALIZATION_PROGRAM_NOT_FOUND_LOC		"* Names capitalization program [<<lcEXE_CAPS>>] not found"
#DEFINE C_ONLY_SETNAME_AND_GETNAME_RECOGNIZED_LOC			"Operation not recognized. Only SETNAME and GETNAME allowed."
#DEFINE C_OUTPUT_FILE_IS_NOT_OVERWRITEN_LOC					"Optimization: Output file [<<THIS.c_OutputFile>>] is not overwriten because it is the same as the genereted."
#DEFINE C_PROCEDURE_NOT_CLOSED_ON_LINE_LOC					"Procedure not closed. Last line of code must be ENDPROC. [<<laLineas(1)>>]"
#DEFINE C_PROCESSING_LOC									"Processing file"
#DEFINE C_PROCESS_PROGRESS_LOC								"Process Progress:"
#DEFINE C_PROPERTY_NAME_NOT_RECOGNIZED_LOC					"Property [<<TRANSFORM(tnPropertyID)>>] is not recognized."
#DEFINE C_REQUESTING_CAPITALIZATION_OF_FILE_LOC				"- Requesting capitalization of file [<<tcFileName>>]"
#DEFINE C_SOURCEFILE_LOC									"Source file: "
#DEFINE C_STRUCTURE_NESTING_ERROR_ENDPROC_EXPECTED_LOC		"Nesting structure error. ENDPROC expected but found ENDDEFINE on class <<toClase._Nombre>> (<<loProcedure._Nombre>>), line <<TRANSFORM(I)>> of file <<THIS.c_InputFile>>"
#DEFINE C_STRUCTURE_NESTING_ERROR_ENDPROC_EXPECTED_2_LOC	"Nesting structure error. ENDPROC expected but found ENDDEFINE on class <<toClase._Nombre>> (<<toObjeto._Nombre>>.<<loProcedure._Nombre>>), line <<TRANSFORM(I)>> of file <<THIS.c_InputFile>>"
#DEFINE C_UNKNOWN_CLASS_NAME_LOC							"Unknown class [<<THIS.CLASS>>]"
#DEFINE C_WARN_TABLE_ALIAS_ON_INDEX_EXPRESSION_LOC			"WARNING!!" + CR_LF+ "MAKE SURE YOU ARE NOT USING A TABLE ALIAS ON INDEX KEY EXPRESSIONS!! (ex: index on <<UPPER(JUSTSTEM(THIS.c_InputFile))>>.campo tag keyname)"

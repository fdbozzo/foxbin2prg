*-- Para Fidel
#DEFINE HISTORIAL_I	'* <HISTORIAL DE CAMBIOS Y NOTAS IMPORTANTES>'
#DEFINE HISTORIAL_F	'* </HISTORIAL DE CAMBIOS Y NOTAS IMPORTANTES>'

LOCAL lcHistorial, laLinea(1), laHistorial(1,4)
lcHistorial	= STREXTRACT( FILETOSTR('FOXBIN2PRG.PRG'), HISTORIAL_I, HISTORIAL_F )
SET MEMOWIDTH TO 220	&& Solo para prueba. Quitar en la función
CLEAR					&& Solo para prueba. Quitar en la función
*-- Formato a leer:
*-- [* 04/11/2013	FDBOZZO		v1.0 Creación inicial de las clases y soporte de los archivos VCX/SCX/PJX]
FOR I = 1 TO ALINES(laLinea, lcHistorial, 1+4+8)
	DIMENSION laHistorial(I,4)
	laHistorial(I,1)	= GETWORDNUM( laLinea(I), 2 )
	laHistorial(I,2)	= GETWORDNUM( laLinea(I), 3 )
	laHistorial(I,3)	= GETWORDNUM( laLinea(I), 4 )
	laHistorial(I,4)	= SUBSTR( laLinea(I), AT(laHistorial(I,3), laLinea(I)) + LEN(laHistorial(I,3)) + 1 )
	*-- Este '?' es solo de prueba
	? '['+laHistorial(I,1)+']', '['+laHistorial(I,2)+']', '['+laHistorial(I,3)+']', '['+laHistorial(I,4)+']'
ENDFOR

*-- En este punto tenés el array laHistorial con 1 columna para cada dato.
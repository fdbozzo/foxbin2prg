LOCAL I, lcStrIn, lcStrOut, laStr(1), lcLeftDelim, lcRightDelim, lcStr, lnLines, lnPosDlr
ON KEY LABEL CTRL+R DO preparar_specialprops_desde_lista.prg
lcStrOut	= ''
lcStrIn		= _CLIPTEXT
lnLines		= ALINES(laStr, lcStrIn)
lnPosDlr	= AT('.',laStr(1))

FOR I = 1 TO lnLines
	lcStrOut	= lcStrOut + CHR(13) + ".SortSpecialProps_Form_Add( '" + laStr(I) + "', @I )"
ENDFOR

_CLIPTEXT	= SUBSTR( lcStrOut, 2 )

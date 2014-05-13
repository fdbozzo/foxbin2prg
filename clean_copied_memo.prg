LOCAL I, lcStrIn, lcStrOut, laStr(1), lcLeftDelim, lcRightDelim, lcStr, lnLines, lnPosDlr
ON KEY LABEL CTRL+R DO clean_copied_memo.prg
lcStrOut	= ''
lcStrIn		= _CLIPTEXT
lnLines		= ALINES(laStr, lcStrIn)
lnPosDlr	= AT('.',laStr(1))

*--
lcLeftDelim		= IIF(lnPosDlr > 0 AND lnPosDlr < AT('=', laStr(1)), LEFT(laStr(1), lnPosDlr), '')
lcRightDelim	= ' ='
*--
MESSAGEBOX( "LeftDelim = " + lcLeftDelim)

FOR I = 1 TO lnLines
	lcStr	= STREXTRACT( laStr(I), lcLeftDelim, lcRightDelim )
	*IF EMPTY(lcStr)
	*	lcStr	= STREXTRACT( laStr(I), '', lcRightDelim )
	*ENDIF
	laStr(I)	= lcStr
	lcStrOut	= lcStrOut + CHR(13) + laStr(I)
ENDFOR

_CLIPTEXT	= SUBSTR( lcStrOut, 2 )

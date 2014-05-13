FOR /F "tokens=*" %%i IN ('dir /S /B *.prg') DO cm chgrevtype %%i -type=txt
FOR /F "tokens=*" %%i IN ('dir /S /B *.??2') DO cm chgrevtype %%i -type=txt
FOR /F "tokens=*" %%i IN ('dir /S /B *.??a') DO cm chgrevtype %%i -type=txt
FOR /F "tokens=*" %%i IN ('dir /S /B *.cfg*') DO cm chgrevtype %%i -type=txt

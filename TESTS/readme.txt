
Last year, I've spend a lot of time to develop a picture treatment dll, there are 6 functions in this dll,
they are:

1 formtobmp
2 formtobmpA
3 tojpeg
4 tobmp
5 getbmpdimension
6 getjpgdimension

In this paper, I'll simply explain their functionality, parameters and how to use them.

Anybody who need source code of this dll, please email to njjane@21cn.com (they are write by are C++,not vfp).

        James Khan
        njjane@21cn.com
        http://www.myf1.net/foxcryptor/
====================================================================================================

Important : To correct use PCT_DLL.dll, you must put it to your system directory or current directory!!!



1 formtobmp
--------------------------------------------------------------------------------
Description:
    capture window or screen image into a bitmap file

Declareation:
    Declare Integer formtobmp IN "PCT_DLL.dll" integer hwnd,String bmpFileName

Parameters:
   hwnd 
     Handle to the window to be saves to a bitmap file. if this parameter is zero, then saves desktop to a bitmap file.

   bmpFileName
     The bitmap filename to be save. must include full path name.

Note:
   The function returns a zero result on success,else 1 is returned.

Example in Visual FoxPro:

retVal = formtobmp(0,"c:\screen.bmp")  && Save screen to file c:\screen.bmp
if retval = 0                          && if success
   messagebox("Capture screen ok! bmp file has been saved to file c:\screen.bmp")
endif
--------------------------------------------------------------------------------



2 formtobmpA
--------------------------------------------------------------------------------
Description:
    also a function to capture window or screen image into a bitmap file,but in this function,
    you can specified a area of screen/window to save.

Declareation:
    Declare Integer formtobmpA  IN "PCT_DLL.dll" string bmpfilename,integer nX,integer nY,integer nX2,integer nY2

Parameters:
   bmpFileName
     The bitmap filename to be save. must include full path name.
   nX
     x-coord of upper-left corner of bitmap file
   nX2
     x-coord of lower-right corner of bitmap file
   nY
     y-coord of upper-left corner of bitmap file
   nY2
     y-coord of lower-right corner of bitmap file

Note:
   The function returns a zero result on success,else 1 is returned.

Example in Visual FoxPro:

retVal = formtobmpA("c:\screen0.bmp",20,20,400,400)  && Save screen to file c:\screen.bmp
if retval = 0
   messagebox("Capture screen ok!")
endif
--------------------------------------------------------------------------------


3 tojpeg
--------------------------------------------------------------------------------
Description:
    Convert a bmp file to a jpg file

Declareation:
    Declare Integer tojpeg          IN "PCT_DLL.dll" String bmpfilename, String jpgfilename

Parameters:
    bmpfilename
       BMP filename to be convert.
    jpgfilename
       JPEG filename

Note:
   The function returns a zero result on success,else 1 is returned.

Example in Visual FoxPro:

retval = tojpeg("c:\screen.bmp","c:\screen.jpg") && Convert c:\screen.bmp to c:\screen.jpg

if retval = 0
   messagebox("Convert bitmap to jpeg ok!")
endif
--------------------------------------------------------------------------------

4 tobmp
--------------------------------------------------------------------------------
Description:
    Convert a jpg file to a bmp file

Declareation:
    Declare Integer tobmp           IN "PCT_DLL.dll" String jpgfilename, String bmpfilename

Parameters:
    jpgfilename
       JPEG filename to be convert.
    bmpfilename
       BMP filename

Note:
   The function returns a zero result on success,else 1 is returned.

Example in Visual FoxPro:

retval = tobmp("c:\screen.jpg","c:\screen2.bmp") && Convert c:\screen.jpg to c:\screen2.bmp
if retval = 0
   messagebox("Convert jpeg to bitmap success!")
endif
--------------------------------------------------------------------------------


5 getbmpdimension
--------------------------------------------------------------------------------
Description:
    Get a dimensions of a bitmap

Declareation:
    Declare Integer getbmpdimension IN "PCT_DLL.dll" string bmpfilename, integer @ nwidth,integer @ nheight

Parameters:
   bmpfilename
     origin bitmap filename.

   nwidth
     bitmap's width measured in pixels.

   nheight
     bitmap's height measured in pixels.

Note:
  if success, return value 0, else return 1.
  if success, variable nwidth hold the bitmap's width ,variable nheight hold the bitmap's height.

Example in Visual FoxPro:

nwidth=0
nheight=0
retval = getbmpdimension("c:\screen.bmp",@ nwidth, @ nheight)
if retval = 0
   messagebox("Width:"+str(nwidth)+chr(13)+"Height:"+str(nheight))
endif
--------------------------------------------------------------------------------

6 getjpgdimension
--------------------------------------------------------------------------------
Description:
    Get a dimensions of a jpeg file

Declareation:
    Declare Integer getjpgdimension IN "PCT_DLL.dll" string jpgfilename, integer @ nwidth,integer @ nheight

Parameters:
   jpgfilename
     origin jpeg filename.

   nwidth
     jpeg's width measured in pixels.

   nheight
     jpeg's height measured in pixels.

Note:
   if success, return value 0, else return 1.
   if success, variable nwidth hold the jpeg's width ,variable nheight hold the jpeg's height.

Example in Visual FoxPro:

nwidth=0
nheight=0
retval = getjpgdimension("c:\screen.jpg",@ nwidth, @ nheight)
if retval = 0
   messagebox("Width:"+str(nwidth)+chr(13)+"Height:"+str(nheight))
endif

clear dlls
@ECHO OFF
SETLOCAL
CLS
ECHO.       ����������������������������������������������������������������Ŀ
ECHO.       �            REXXCC v3.21 (c) Bernd Schemmer 1994-1997           �
ECHO.       �                 a tiny REXX "compiler" for OS/2                �
ECHO.       ����������������������������������������������������������������Ĵ
ECHO.       �                       FileList for REXXCC                      �
ECHO.       ������������������������������������������������������������������
ECHO.              INSTALL.CMD  - install program for REXXCC
ECHO.              README.CMD   - this file
ECHO.              REXXCC.CMD   - the REXX "compiler"
ECHO.              REXXCC2.CMD  - the WPS front end for REXXCC
ECHO.              REXXCC.EA    - the EAs of REXXCC.CMD
ECHO.              UPCKREXX.CMD - program to unpack "packed" REXX programs
ECHO.              REXXCCM.CMD  - another REXX "compiler" using the macro space
ECHO.       �����������������������������������������������������������������
ECHO.              RXDLG.DLL    - Rexx Dialog DLL (used by REXXCC2.CMD)
ECHO.              RX.EXE       - Rexx Dialog EXE (used by REXXCC2.CMD)
ECHO.              RX.INF       - online documentation for Rexx Dialog
ECHO.       ����������������������������������������������������������������Ŀ
ECHO.       �                           Use                                  �
ECHO.       �              EAUTIL REXXCC.CMD REXXCC.EA /J /P                 �
ECHO.       �        to attach the EAs to REXXCC if they are missing.        �
ECHO.       ������������������������������������������������������������������
ECHO.   Press any key to view the documentation for REXXCC or CTRL-C to abort ...
PAUSE >NUL
ECHO.   Loading the documentation. Please wait ...
REM *** use list if 4OS2 is the command shell
if NOT "%_4ver%" == "" ALIAS more=list/s
call rexxcc /?
if NOT "%_4ver%" == "" UNALIAS more
CLS
ECHO.
ECHO.       ����������������������������������������������������������������Ŀ
ECHO.       �  To view the documentation for REXXCC again you can view the   �
ECHO.       �            file REXXCC.CMD with any fileviewer.                �
ECHO.       ������������������������������������������������������������������
ECHO.
ECHO.                       Use INSTALL.CMD to install REXXCC.
ECHO.
ECHO.                               Press any key ...
PAUSE >NUL
ENDLOCAL

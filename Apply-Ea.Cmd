echo off
cls
echo This batch file was created by LH/2 v2.20.
echo �
echo It contains the necessary OS/2 commands to attach Extended Attributes
echo to the files you just extracted from RC321.Lzh.
echo (RC321.Lzh was the name of the archive when it was first created).
echo �
echo This batch file will not be necessary if you extracted the archive
echo using LH 2.20 (or greater).
echo �
echo   (C) 1993 A:WARE Computing Inc.  bbs: (416)858-8488
echo �
echo �
pause
EAUTIL "REXXCC.CMD" /j
EAUTIL "REXXCC2.CMD" /j

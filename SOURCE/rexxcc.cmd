/* ------------------------------------------------------------------ */
/* REXXCC.CMD - a tiny REXX "compiler" (c) Bernd Schemmer 1994-2014   */
/*                                                                    */
/* Usage: REXXCC source TO target {WITH copyrightfile}                */
/*               {/IExt} {/IDate} {/IVer} {/Overwrite}                */
/*               {/UseSource} {/LineCount=n} {/Compress}              */
/*               {/AddCode} {/CMode} {/ShowDate} {/NoDate}            */
/*               {/LOG=logfilename} {/Sound} {/NoColors} {/?} {/HELP} */
/*                                                                    */
/* Author                                                             */
/*   Bernd Schemmer                                                   */
/*   Jenaer Weg 11                                                    */
/*   65931 Frankfurt                                                  */
/*   Germany                                                          */
/*   Bernd.Schemmer@gmx.de                                            */
/*                                                                    */
/* /================================================================\ */
/* | IMPORTANT:                                                     | */
/* |                                                                | */
/* | This program will only work if the Extended Attributes are OK! | */
/* \================================================================/ */
/*                                                                    */
/* Description:                                                       */
/* ============                                                       */
/*                                                                    */
/* REXXCC knows two modes:                                            */
/*                                                                    */
/*   "compiling"                                                      */
/*                                                                    */
/* and                                                                */
/*                                                                    */
/*   "compressing" (you can also call it "packing")                   */
/*                                                                    */
/* REXXCC "compiles" an OS/2 REXX program by substituting the source  */
/* code with mostly any text. This is possible because the OS/2 REXX  */
/* interpreter stores a tokenized copy of each executed REXX program  */
/* in the EAs of the program. If you execute an OS/2 REXX program,    */
/* the OS/2 REXX interpreter first checks if the tokenized copy in    */
/* the EAs is still valid and, if so, executes the tokenized copy     */
/* and ignores the source code.                                       */
/*                                                                    */
/* REXXCC "compresses" an OS/2 REXX program by deleting mostly all    */
/* superfluous whitespaces, all linefeeds and all comments from the   */
/* sourcefile.                                                        */
/*                                                                    */
/*                                                                    */
/* Compatiblity                                                       */
/* ============                                                       */
/*                                                                    */
/* "Compiling" tested with OS/2 v2.1, OS/2 v2.1 and the Service Pak,  */
/* OS/2 v2.11, OS/2 v2.99 WARP BETA II, OS/2 Version 3 WARP for       */
/* Windows, OS/2 Version 3 WARP Fullpack and OS/2 WARP Connect        */
/* and OS/2 WARP Version 4 (with Classic REXX as default REXX         */
/* interpreter).                                                      */
/* The REXX interpreter version of all of these OS/2 Versions is 4.00.*/
/* If you're using Object REXX, please see the notes in the section   */
/* 'Known limitations' below.                                         */
/*                                                                    */
/* "Compressed" REXX programs will work using ANY REXX interpreter.   */
/*                                                                    */
/*                                                                    */
/* Usage                                                              */
/* =====                                                              */
/*                                                                    */
/* 1. execute your REXX file to get the token image of the program.   */
/*                                                                    */
/* Note: You may call your program with the switch '//t' (yes, there  */
/*       are two slashes!) to force the creation of the token         */
/*       image of the program without executing it.                   */
/*                                                                    */
/* Further note:  This step is only neccessary, if you want to        */
/*                "compile" your REXX program.                        */
/*                                                                    */
/* 2. call REXXCC to "compile" or "compress" your REXX file.          */
/* The syntax for REXXCC is:                                          */
/*                                                                    */
/*   REXXCC source TO target {WITH copyrightFile} {option} {voption}  */
/*                                                                    */
/* with:                                                              */
/*   source                                                           */
/*     is the name of the sourcefile                                  */
/*     The extension of the sourcefile must be '.CMD'.                */
/*     If you ommit the extension, REXXCC appends '.CMD' to the       */
/*     name of the sourcefile.                                        */
/*                                                                    */
/*   TO                                                               */
/*     this is a neccessary keyword!                                  */
/*                                                                    */
/*   target                                                           */
/*     is the name of the targetfile or directory                     */
/*     The extension for the targetfile must be '.CMD'. If you ommit  */
/*     the extension, REXXCC appends '.CMD' to the name of the target */
/*     file. If you enter a directory name for this parameter, REXXCC */
/*     uses the name of the sourcefile as name for the targetfile.    */
/*                                                                    */
/*   WITH                                                             */
/*     this is a neccessary keyword!                                  */
/*                                                                    */
/*   copyrightfile                                                    */
/*     is the file with the copyright message which replaces the      */
/*     original source code in the "compiled" version of the program. */
/*     If you ommit the parameter copyrightFile, REXXCC uses only its */
/*     copyright message as copyright file. If the copyright file is  */
/*     equal with the sourcefile REXXCC uses only the leading         */
/*     comment lines of the sourcefile as copyright file.             */
/*                                                                    */
/*     Hint: You may use the equal sign (=) as name of the            */
/*           copyright file if you want to use the sourcefile as      */
/*           copyright file.                                          */
/*                                                                    */
/*   options                                                          */
/*     are misc. options for REXXCC. All options are in the format    */
/*                                                                    */
/*       /optionName{=optionValue}                                    */
/*                                                                    */
/*     with optionValue = 1 to turn the option on and optionValue = 0 */
/*     to turn the option off. Any other value for optionValue turns  */
/*     the option on. The default for optionValue if not entered is 1 */
/*     (= turn the option on).                                        */
/*     The only exception to this rule is the option LOG (see below). */
/*     There must be a blank before the leading slash of an option!   */
/*     You may use an option at any position in the parameters.       */
/*                                                                    */
/*     Possible options for REXXCC are:                               */
/*                                                                    */
/*       LOG                                                          */
/*         The value of this option is the name of the logfile.       */
/*         Normally REXXCC appends all messages to an existing        */
/*         logfile.                                                   */
/*         Add a leading exclamation mark to the name of the logfile  */
/*         to change this behaviour to overwrite mode.                */
/*         Example:                                                   */
/*                                                                    */
/*            /LOG=!rexxcc.log                                        */
/*         or                                                         */
/*            /LOG="!rexxcc-00.log"                                   */
/*                                                                    */
/*       IExt                                                         */
/*         if ON : do NOT check                                       */
/*                   - the extension of the sourcefile                */
/*                   - the extension of the targetfile                */
/*                   - the format of the sourcefile                   */
/*                 and                                                */
/*                   - the format of the copyright file               */
/*                 (def.: OFF)                                        */
/*                                                                    */
/*       IVer                                                         */
/*         if ON : do NOT check                                       */
/*                   - the version of the REXX interpreter            */
/*                 and                                                */
/*                   - the version of the token image of the source   */
/*                     file                                           */
/*                 (def.: OFF)                                        */
/*                                                                    */
/*       IDate                                                        */
/*         if ON : do not check the date of the sourcefile            */
/*                 (def.: OFF)                                        */
/*                                                                    */
/*       Overwrite                                                    */
/*         if ON : overwrite an existing targetfile (def.: OFF)       */
/*                                                                    */
/*       UseSource                                                    */
/*         if ON : use the sourcefile as copyright file if the        */
/*                 parameter copyrightfile is missing (def.: OFF)     */
/*                                                                    */
/*       Compress                                                     */
/*         if ON : only compress the source code                      */
/*                 (delete whitespaces & comments, def.: OFF)         */
/*                                                                    */
/*       AddCode                                                      */
/*         if ON : add code to check if the EAs are okay to the       */
/*                 targetfile                                         */
/*                 (def.: OFF, ignored if /Compress is ON)            */
/*                                                                    */
/*       ShowDate                                                     */
/*         if ON : show the execution and changing time stamps        */
/*                 (def.: OFF, ignored if /Compress is ON)            */
/*                                                                    */
/*       NoDate                                                       */
/*         if ON : don't insert the time and date in the copyright    */
/*                 footer of the "compiled" file                      */
/*                 (def.: OFF = include the time and date in the      */
/*                              footer)                               */
/*                                                                    */
/*       CMode                                                        */
/*         if ON : don't process strings in compress mode             */
/*                 CMode is a little faster than the normal mode, but */
/*                 the compression rate is not as good as with the    */
/*                 normal compression mode.                           */
/*                 (def.: OFF, ignored if /Compress is OFF)           */
/*                                                                    */
/*       Sound                                                        */
/*         if ON : use sounds in case of an error (def.: OFF)         */
/*                                                                    */
/*       NoColors                                                     */
/*         if ON : don't use colors for the messages (def.: OFF)      */
/*                                                                    */
/*                                                                    */
/*   voptions                                                         */
/*     are misc. options for REXXCC. All voptions are in the format   */
/*                                                                    */
/*       /voptionName=voptionValue                                    */
/*                                                                    */
/*     vopitonValue can be any integer value greater or equal 0.      */
/*     You may enter a voption at any position in the parameters.     */
/*                                                                    */
/*     Possible voptions for REXXCC are:                              */
/*                                                                    */
/*       LineCount=n                                                  */
/*         n is the number of leading comment lines of the source     */
/*         file which REXXCC should use as copyright file for the     */
/*         targetfile. REXXCC ignores this parameter, if you don't    */
/*         use the sourcefile as copyright file.                      */
/*         (def.: use all leading comment lines of the sourcefile)    */
/*         If n is not a whole number or if n is equal 0, REXXCC      */
/*         ignores n. If there are less than n leading comment lines  */
/*         in the sourcefile, REXXCC ignores the value of n.          */
/*         example:                                                   */
/*                                                                    */
/*           REXXCC TEST.CMD TO PROGS\ WITH TEST.CMD /LineCount=50    */
/*                                                                    */
/*           -> compile the file "TEST.CMD" to "PROGS\TEST.CMD" and   */
/*              use the first 50 comment lines of the sourcefile as   */
/*              copyright file.                                       */
/*                                                                    */
/*         Note that REXXCC counts multi-line comments as *one*       */
/*         comment. Note further, that there's only a restricted      */
/*         handling of nested comments in this part of REXXCC!        */
/*         (means: Depending on how you use this REXX feature it may  */
/*                 or may not work)                                   */
/*                                                                    */
/*                                                                    */
/*     You may also set the defaults for the options and voptions in  */
/*     the environment variable "REXXCC", for example:                */
/*                                                                    */
/*       SET REXXCC="/IExt=1 /Overwrite /LineCount=20 /UseSource"     */
/*                                                                    */
/*     Note that you must use the double quotes if the value for the  */
/*     environment variable contains one or more equal signs.         */
/*     Options and VOptions in the parameters overwrite the values    */
/*     from the environment variable "REXXCC".                        */
/*                                                                    */
/*                                                                    */
/* See also the notes below the history section.                      */
/*                                                                    */
/*                                                                    */
/* History                                                            */
/* =======                                                            */
/*                                                                    */
/*   V1.00  - 05.07.1994 /bs                                          */
/*     - initial release                                              */
/*   V1.01  - 12.07.1994 /bs                                          */
/*     - added code to check if the temporary path exists             */
/*     - change meaning of the 2nd parameter -- now it can            */
/*       be a directory name or a file name                           */
/*     - added code to check if the sourcefile was changed after the  */
/*       last execution                                               */
/*     - added code to check if the current ADDRESS() environment is  */
/*       the CMD                                                      */
/*                                                                    */
/*   V2.00  - 20.08.1994 /bs                                          */
/*     - fixed a bug, where REXXCC did not delete the temporary files */
/*       and the targetfile if an error occured                       */
/*     - added the parameters -IExt, -IVer and -IDate                 */
/*     - added the support for the envrionment variable REXXCC        */
/*     - added the parameter -LineCount                               */
/*     - added the color support                                      */
/*   V2.01  - 01.10.1994 /bs                                          */
/*     - INTERNAL VERSION                                             */
/*   V2.05  - 18.11.1994 /bs                                          */
/*     - advanced the error handling                                  */
/*     - added the abbreviation '=' for the parameter copyrightfile   */
/*     - added the parameter -Overwrite                               */
/*     - added the parameter -UseSource                               */
/*   v2.10  - 08.04.1995 /bs                                          */
/*     - use TEMPLATE v2.52 as base source (1)                        */
/*     - changed the return codes above 250 to 230+. Added the new    */
/*       returncodes from TEMPLATE v2.52 (see below)                  */
/*     - added sounds                                                 */
/*     - added the parameter -Sound                                   */
/*     - extended the color support                                   */
/*     - expanded the version tests                                   */
/*     - added code to distinguish between batch and REXX programs    */
/*                                                                    */
/*   v3.00  - 01.06.1995 /bs                                          */
/*     - added the file REXXCC.EA containing the EAs of REXXCC to the */
/*       archive. This was neccessary, because some users or sysops   */
/*       unpacked REXXCC and packed it again with a program not       */
/*       supporting EAs.                                              */
/*     - added code to compress a REXX program (parameter /compress)  */
/*     - added code to add code to test the EAs to the compiled       */
/*       programs (parameter /AddCode)                                */
/*     - rewrote the WPS frontend and rename it to REXXCC/2.          */
/*       REXXCC/2 uses Rexx Dialog (2) instead of VREXX for the       */
/*       dialog boxes. All neccessary parts of Rexx Dialog for        */
/*       executing REXXCC/2 are included in this package.             */
/*   v3.01  - 01.10.1995 /bs                                          */
/*     - INTERNAL VERSION                                             */
/*   v3.10  - 25.10.1995 /bs                                          */
/*     - in the previous version REXXCC ended with error 2 if the     */
/*       contents of the environment variable TEMP or TMP were in     */
/*       lowercase or mixcase. Fixed.                                 */
/*     - in the previous version REXXCC issued the error 53 if        */
/*       you tried to "compile" a CMD from a FAT partition. Fixed.    */
/*     - in the previous version REXXCC had problems with comments    */
/*       like                                                         */
/*           /*/*/*/* This is a really deep nested comment */*/*/*/   */
/*       Fixed.                                                       */
/*     - added code to suppress the use of ANSI codes if the current  */
/*       environment is not 'CMD'.                                    */
/*     - implement some enhancements for REXXCC/2                     */
/*     - added the program UPCKREXX.CMD to unpack "packed" or         */
/*       "compressed" REXX programs                                   */
/*     - enhanced the "compressing" of REXX cmds                      */
/*     - now you can use tabulators in string constants and nested    */
/*       multi line comments in REXX programs which you want to       */
/*       compress                                                     */
/*     - now REXXCC deletes mostly all superfluous whitespaces within */
/*       REXX statements also                                         */
/*     - added the parameter -ShowDate and -CMode                     */
/*     - added the error code 63 ("comments nested to deep")          */
/*     - added some more technical information                        */
/*   v3.11  - 29.10.1995 /bs                                          */
/*     - INTERNAL VERSION                                             */
/*   v3.20  - 09.09.1997 /bs                                          */
/*     - added the program REXXCCM.CMD: a "compiler" using the        */
/*       macro space                                                  */
/*   v3.21  - 01.12.1997 /bs                                          */
/*     - redesigned major parts of the program to save space in the   */
/*       token image                                                  */
/*     - fixed some minor bugs                                        */
/*     - REXXCC now handles filenames with imbedded special chars.    */
/*       (e.g. -, blanks, etc.)                                       */
/*     - added the option -NoDate                                     */
/*     - deleted the undocumented parameter /L:                       */
/*     - added the new paramter /LOG=logfilename                      */
/*     - added the new paramter /NoColors                             */
/*     - removed the use of the environment variable SOUND            */
/*     - removed the use of the environment variable ANSI             */
/*     - added support for multi-line comments in the text, that      */
/*       replaces the original source code                            */
/*     - added some more technical information                        */
/*   v3.22  - 01.12.1998 /bs                                          */
/*     - changed the length of the Copyright notice from 80 to 79     */
/*       characters                                                   */
/*     - corrected a bug in the handling of multi-line comments used  */
/*       in the copyright files                                       */
/*   v3.23  - 12.09.2014 /bs                                          */
/*     - changed license to Open Source                               *
/*                                                                    */
/*                                                                    */
/* (1)  TEMPLATE is a "runtime system" for REXX programs.             */
/*      You can get TEMPLATE at the same source as this file.         */
/*      The name of the archiv with TEMPLATE is "RXTMPnnn.EXE"        */
/*      or "RXTnnn.EXE" where nnn is the version of TEMPLATE          */
/*      (e.g. "306").                                                 */
/*      TEMPLATE is distributed as freeware.                          */
/*                                                                    */
/* (2)  "Rexx Dialog" is an excellent package for using PM dialogs    */
/*      in REXX programs. "Rexx Dialog" was written by Jeff Glatt.    */
/*      You can get the complete "Rexx Dialog" package at every BBS   */
/*      with OS/2 software. The name of the archiv with               */
/*      "Rexx Dialog" is RXDLG10.ZIP (were 10 is the version number   */
/*      I think).                                                     */
/*      "Rexx Dialog" is distributed as freeware.                     */
/*                                                                    */
/*                                                                    */
/*                                                                    */
/* Generell notes                                                     */
/* ==============                                                     */
/*                                                                    */
/* The ADDRESS environment for REXXCC must be 'CMD' (CMD is the       */
/* address environment of CMD.EXE).                                   */
/* REXXCC uses the internal CMD commands TYPE, ECHO, and DEL.         */
/* REXXCC uses these commands with the prefix '@'.                    */
/* If you use another command line processor, you must make sure that */
/* it is compatible to CMD.EXE in the points mentioned above.         */
/* (Note: 4OS2 for example is compatible.)                            */
/*                                                                    */
/* REXXCC also uses the external OS/2 programm ATTRIB.EXE.            */
/*                                                                    */
/* REXXCC uses temporary files to "compile" the REXX programs.        */
/* REXXCC checks the environment variables TEMP and TMP (in this      */
/* order) to find the directory for temporary files. If neither TEMP  */
/* nor TMP is set, REXXCC creates temporary files in the current      */
/* directory.                                                         */
/* REXXCC uses unique filenames for temporary files. Therefore it is  */
/* possible to run multiple copies of REXXCC at the same time.        */
/*                                                                    */
/* To use filenames or directory names with special chars like '-'    */
/* or blanks, enclose them with double quotes '"'.                    */
/*                                                                    */
/* Example:                                                           */
/*                                                                    */
/*   REXXCC "my -Test" TO "-mydir" WITH "my doc" /LOG="test 1.log"    */
/*                                                                    */
/* REXXCC only overwrites existing targetfiles if called with the     */
/* parameter '-Overwrite'.                                            */
/*                                                                    */
/* The sourcefile must begin with a valid REXX comment in line        */
/* 1, column 1. You may suppress this check with the parameter        */
/* '-IExt'.                                                           */
/*                                                                    */
/* The copyright file must begin with a valid REXX comment in line 1  */
/* column 1. You may suppress this check with the parameter '-IExt'.  */
/*                                                                    */
/* You should not use 'TO' or 'WITH' as name for any of the           */
/* parameters for REXXCC.                                             */
/*                                                                    */
/* You should load REXXUTIL before calling REXXCC if you are using    */
/* a CMD window with more or less than 80 columns.                    */
/*                                                                    */
/* REXXCC does not load REXXUTIL but will use it if it's already      */
/* loaded.                                                            */
/*                                                                    */
/* To get a smaller version of REXXCC use the following commands:     */
/*                                                                    */
/*   MD PROGRAM                                                       */
/*   REXXCC REXXCC.CMD to PROGRAM WITH REXCC.CMD /LINECOUNT=16        */
/*                                                                    */
/* Note that you can't change the name of REXXCC. Note also that you  */
/* only get a very short usage description if you use the parameter   */
/* '/?' with the smaller version.                                     */
/*                                                                    */
/*                                                                    */
/*                                                                    */
/* "Compiling" notes                                                  */
/* =================                                                  */
/*                                                                    */
/* If you're going to distribute REXX files "compiled" with REXXCC    */
/* I strongly suppose you add an additional file with the EAs to      */
/* the archive with your "compiled" REXX program.                     */
/* This is neccessary because there are many BBS Sysops around who    */
/* unpack all uploaded archives with a DOS unpack program, check the  */
/* files for a virus and pack the files again into an archive with a  */
/* DOS pack program. And that was the last time you've seen the EAs   */
/* of your REXX program :-((.                                         */
/*                                                                    */
/* REXXCC can only "compile" files on a read/write medium. So if you  */
/* want to "compile" a REXX file from a read-only medium (a CD ROM    */
/* for example) you MUST copy it to a read/write medium (e.g. a hard  */
/* disk) and execute it there (!) before "compiling" it!              */
/*                                                                    */
/* The program EAUTIL.EXE is necessary for REXXCC to "compile" a      */
/* REXX program. EAUTIL.EXE must be accessible about the environment  */
/* variable "PATH".                                                   */
/*                                                                    */
/* Note that you must reExecute a sourcefile after you changed it     */
/* before you can "compile" it. You may suppress this check with the  */
/* parameter '-IDate'.                                                */
/*                                                                    */
/*                                                                    */
/* Known limitations for "compiling"                                  */
/* =================================                                  */
/*                                                                    */
/* You can only "compile" REXX files which are less than 64 K in      */
/* tokenized form. 64 K is the maximum length of the EAs in which the */
/* REXX interpreter stores the token image of REXX programs.          */
/* (Note that the second length shown by the dir command on an HPFS   */
/* drive is the length of the EAs. To get the length of the EAs on an */
/* FAT drive use the switch /N for the OS/2 command "DIR".)           */
/*                                                                    */
/* To get around this limitation, you might use the program           */
/* REXXCCM.CMD (which is also part of the REXXCC package).            */
/* But please be aware, that REXXCCM.CMD and the images created with  */
/* REXXCCM need the new REXXUTIL DLL from Object REXX (either as      */
/* default REXXUTIL.DLL or as additional REXXUTIL.DLL - see the       */
/* source code of REXXCCM.CMD)!                                       */
/*                                                                    */
/* You should not use the function "SOURCELINE" in a program          */
/* "compiled" by REXXCC because there is no source code anymore :-).  */
/* If you want to use the function "SOURCELINE" (e.g. in an error     */
/* handler) use the following command sequence (this avoids an error  */
/* if you call the function "SOURCELINE" with a non-existing line     */
/* number):                                                           */
/*                                                                    */
/*  if sourceLine() >= errorLineNo then                               */
/*  do                                                                */
/*    call charOut, " The line reads: "                               */
/*    call charOut, " *-* " || sourceline( errorLineNo )              */
/*  end                                                               */
/*  else                                                              */
/*    call charOut, " The line is not available!"                     */
/*                                                                    */
/* You may use difficult lines in the sourcefile and the copyright    */
/* file to distinguish between the original and the "compiled"        */
/* version using "SOURCELINE" while running your program.             */
/*                                                                    */
/* You can not load a "compiled" program into the REXX macro space.   */
/*                                                                    */
/* To distribute a "compiled" REXX program on a CD-ROM you must       */
/* either add the EAs in an extra file or pack the file with a        */
/* packer which includes the EAs in the archive (like for example     */
/* LH2.) This is neccessary because the CD-ROM filesystem does NOT    */
/* support EAs.                                                       */
/*                                                                    */
/* You must use a local drive (harddisk or diskette) for the target   */
/* file! You can't "compile" a REXX program to a network drive. But   */
/* you can move or copy "compiled" REXX programs to network drives,   */
/* of course.                                                         */
/*                                                                    */
/* You can NOT execute "compiled" programs if you're running          */
/* Object REXX. Object REXX can not handle the token image created by */
/* Classic REXX.                                                      */
/* It is also impossible to "compile" REXX programs tokenized by the  */
/* Object REXX interpreter.                                           */
/* Note that Object REXX contains a program called REXXC.EXE to       */
/* "compile" Object REXX programs. REXXC.EXE stores the token image   */
/* in the CMD file - so there's no 64 K limitation for the size of    */
/* the token image.                                                   */
/*                                                                    */
/*                                                                    */
/* Known limitations for "compressing"                                */
/* ===================================                                */
/*                                                                    */
/* The lines of the REXX programs must end with a CR/LF sequence.     */
/*                                                                    */
/* You _MUST_ use the format                                          */
/*                                                                    */
/*    '/' || '*'                                                      */
/*                                                                    */
/* and                                                                */
/*                                                                    */
/*    '*' || '/'                                                      */
/*                                                                    */
/* (or something similar) if you want to use the REXX comment begin   */
/* and comment end sequences in string constants used in your         */
/* program!                                                           */
/*                                                                    */
/* REXXCC does not parse the source code like the REXX interpreter.   */
/* Therefore it handles a few constructs incorrect.                   */
/*                                                                    */
/* For example: Because REXXCC can't detect if a comment should be    */
/* replaced with a blank, the string concatenator or nothing, it      */
/* deletes ALL comments. This may lead to an error, if you use        */
/* comments as separators in your REXX programs, see examples below.  */
/*                                                                    */
/* The following are examples of REXX statements not handled correct  */
/* by REXXCC:                                                         */
/*                                                                    */
/*  statement                         is converted to                 */
/*  ----------------------------------------------------------------- */
/*  str1 = 'aa'/* comment */'bb'      str1 = 'aa''bb'                 */
/*  if a = b/* */then/* */say 'bb'    if a =bthensay 'bb'             */
/*                                                                    */
/*                                                                    */
/* You should not use the function "SOURCELINE" in a program          */
/* "compressed" by REXXCC because there is normally only one          */
/* sourceline in the "compressed" REXX program.                       */
/*                                                                    */
/* You can add the special comment                                    */
/*                                                                    */
/*    /*!*/                                                           */
/*                                                                    */
/* to the end of a line to insert a CR/LF into the compressed file.   */
/*                                                                    */
/* ------------------------------------------------------------------ */
/* Terms for using this version of REXXCC                             */
/* ======================================                             */
/*                                                                    */
/* This version of REXXCC is Open Source.                             */
/*                                                                    */
/*                                                                    */
/* If you find REXXCC useful, your gift in any amount would be        */
/* appreciated.                                                       */
/*                                                                    */
/* Please direct your inquiries, complaints, suggestions, bug lists   */
/* etc. to the address noted above.                                   */
/*                                                                    */
/*                                                                    */
/* ------------------------------------------------------------------ */
/* Warranty Disclaimer                                                */
/* ===================                                                */
/*                                                                    */
/* Bernd Schemmer makes no warranty of any kind, expressed or         */
/* implied, including without limitation any warranties of            */
/* merchantability and/or fitness for a particular purpose.           */
/*                                                                    */
/* In no event will Bernd Schemmer be liable to you for any           */
/* additional damages, including any lost profits, lost savings, or   */
/* other incidental or consequential damages arising from the use of, */
/* or inability to use, this software and its accompanying documen-   */
/* tation, even if Bernd Schemmer has been advised of the possibility */
/* of such damages.                                                   */
/*                                                                    */
/* ------------------------------------------------------------------ */
/* Copyright                                                          */
/* =========                                                          */
/*                                                                    */
/* REXXCC, the documentation for REXXCC and all other related files,  */
/* except for the files RXDLG.DLL, RX.EXE and RX.INF, are             */
/* -- Copyright 1994-2014 by Bernd Schemmer. All rights reserved. --  */
/*                                                                    */
/* The files RXDLG.DLL, RX.EXE and RX.INF are                         */
/* -- Copyright 1995 by Jeff Glatt.  --                               */
/* Please see the file RX.INF for the using and redistribution policy */
/* for these files.                                                   */
/*                                                                    */
/*                                                                    */
/* ------------------------------------------------------------------ */
/* License                                                            */
/* =========                                                          */
/*                                                                    */
/* CDDL HEADER START                                                  */
/*                                                                    */
/* The contents of this file are subject to the terms of the          */
/* Common Development and Distribution License, Version 1.0 only      */
/* (the "License").  You may not use this file except in compliance   */
/* with the License.                                                  */
/*                                                                    */
/* You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE*/
/* or http://www.opensolaris.org/os/licensing.                        */
/* See the License for the specific language governing permissions    */
/* and limitations under the License.                                 */
/*                                                                    */
/* When distributing Covered Code, include this CDDL HEADER in each   */
/* file and include the License file at usr/src/OPENSOLARIS.LICENSE.  */
/* If applicable, add the following below this CDDL HEADER, with the  */
/* fields enclosed by brackets "[]" replaced with your own identifying*/
/* information: Portions Copyright [yyyy] [name of copyright owner]   */
/*                                                                    */
/* CDDL HEADER END                                                    */
/*

/* ------------------------------------------------------------------ */
/* Technical information                                              */
/* =====================                                              */
/*                                                                    */
/* Warnings                                                           */
/* --------                                                           */
/*                                                                    */
/* Warning: No time stamp checking possible for files on or from FAT  */
/*          partitions!                                               */
/*                                                                    */
/*   Description:                                                     */
/*      REXXCC can't check if the file was changed after the          */
/*      creation of the token image. If REXXCC shows this warning     */
/*      for a file on an HPFS partition, I suppose you delete and     */
/*      recreate the EAs of the REXX CMD before "compiling" it.       */
/*      You may suppress this warning with the parameter '-IDate'.    */
/*                                                                    */
/*   Background:                                                      */
/*      REXXCC shows this warning, while "compiling" a REXX CMD for   */
/*      which the token image in the EAs was created on a FAT         */
/*      partition. This is independent from the file system of the    */
/*      current drive with the CMD. Note that the execution time      */
/*      stamp for CMDs on FAT partitions is always 0.                 */
/*                                                                    */
/*                                                                    */
/* Warning: Unmatched comment delimiter "/*" in the sourcefile!       */
/* Warning: Unmatched comment delimiter "*/" in the sourcefile!       */
/*                                                                    */
/*   Description:                                                     */
/*      REXXCC found unmatched comment delimiter in the source file.  */
/*      Note that you CAN NOT execute the created target file!        */
/*                                                                    */
/*   Background:                                                      */
/*      REXXCC does not delete the target file, to give you a         */
/*      hint for the position of the unmatched comment delimiter      */
/*      (just load the target file into your favorite editor and      */
/*      do a search for the comment delimiter).                       */
/*                                                                    */
/* Warning: Unmatched string delimiter <'> in the sourcefile!         */
/* Warning: Unmatched string delimiter <"> in the sourcefile!         */
/*                                                                    */
/*   Description:                                                     */
/*      REXXCC found unmatched string delimiter in the source file.   */
/*      Note that you CAN NOT execute the created target file!        */
/*                                                                    */
/*   Background:                                                      */
/*      REXXCC does not delete the target file, to give you a         */
/*      hint for the position of the unmatched string delimiter       */
/*      (just load the target file into your favorite editor and      */
/*      do a search for the string delimiter).                        */
/*                                                                    */
/* Returncodes and error messages                                     */
/* ------------------------------                                     */
/*                                                                    */
/* Note: If you get one of the errors marked with a plus (+) in the   */
/*       table below - please contact the author!                     */
/*                                                                    */
/*    RC  Error message                                               */
/*   ---------------------------------------------------------------- */
/*     0  ok, targetfile successfully created (NO ERROR)              */
/*     1  parameter for usage help detected, usage shown (NO ERROR)   */
/*     2  Can not find a name for a temporary file (Check the         */
/*        variable "TEMP" or "TMP")                                   */
/*     3  Can not find the program EAUTIL.EXE                         */
/*        (Check the variable "PATH")                                 */
/*     4  Can not find the program ATTRIB.EXE                         */
/*        (Check the variable "PATH")                                 */
/*    11  Parameter missing or invalid parameter found                */
/*    12  The sourcefile "%1" does not exist                          */
/*    13  The extension of the sourcefile must be ".CMD"              */
/*    14  The extension for the targetfile must be ".CMD"             */
/*    15  The targetfile "%1" already exist                           */
/*    16  The copyrightFile "%1" does not exist                       */
/*    17  The copyrightFile can not be a device                       */
/*    18  The targetfile can not be equal with the source file        */
/*    19  The drive %1 is not ready                                   */
/*    31  The copyrightFile must begin with a REXX comment in         */
/*        line 1 column 1                                             */
/*        Note: This error also occurs, if REXXCC can *not* read the  */
/*              copyright file (for example if it's opened by another */
/*              program)                                              */
/* +  32  OS Error %1 deleting the temporary file "%2"                */
/* +  33  OS Error %1 deleting the existing targetfile "%2"           */
/* +  34  OS Error %1 compiling the sourcefile "%2"                   */
/*    35  You must first execute the sourcefile "%1" before           */
/*        compiling it                                                */
/*        Note: If you have already executed the sourcefile, your     */
/*              REXX program is to big to fit in the EAs.             */
/*              In this case no "compiling" is possible.              */
/*              You might use REXXCCM.CMD to compile your REXX        */
/*              program using the macro space.                        */
/*    36  Can not find a name for a temporary file (Check the         */
/*        environment variable "TEMP" or "TMP")                       */
/* +  37  OS Error %1 creating the targetfile "%2"                    */
/* +  38  OS Error %1 creating the targetfile "%2"                    */
/* +  39  OS Error %1 creating the targetfile "%2"                    */
/* +  40  OS Error %1 creating the targetfile "%2"                    */
/* +  41  OS Error %1 creating the targetfile "%2"                    */
/* +  42  OS Error %1 creating the targetfile "%2"                    */
/*    51  You must first execute the sourcefile "%1" before           */
/*        compiling it                                                */
/*        Note: see error number 35.                                  */
/*    52  You must first execute the sourcefile "%1" before           */
/*        compiling it                                                */
/*        Note: see error number 35                                   */
/*    53  You must reExecute the sourcefile after every               */
/*        change before you can compile it                            */
/*        Note: See error number 35                                   */
/* +  54  Internal error E1                                           */
/* +  55  Unknown format of the token image                           */
/*    56  Unknown REXX interpreter version (%1)                       */
/*    57  The file "%1" is NOT a REXX program                         */
/*    60  Invalid switches "%1" in the environment variable "REXXCC"! */
/*    61  The string "%1" in the environment variable "REXXCC" is     */
/*        not a valid option                                          */
/*    62  The string "%1" in the parameters is not a valid option     */
/*    63  The comments in the source file nested to deep (max. is 40) */
/*        Note:                                                       */
/*        This limitation is there, because REXXCC uses a recursive   */
/*        algorithm to compress a REXX cmd and the number of nested   */
/*        control structs in REXX is 100.                             */
/*                                                                    */
/* + 232  This is a patched version of the program. It won't work     */
/* + 233  Invalid REXX interpreter version                            */
/* + 234  Internal error OTFT                                         */
/* + 234  Internal error FTOT                                         */
/* + 234  Internal error ODFD                                         */
/* + 234  Internal error FDOD                                         */
/*   235  You can only execute this program in a CMD session!         */
/*        Note: Try using 'CMD /C REXXCC ...'                         */
/*   254  user break (CTRL-C)                                         */
/*   255  internal runtime system error                               */
/*                                                                    */
/* ------------------------------------------------------------------ */
/* Based on TEMPLATE.CMD v2.52, TEMPLATE is (c) Bernd Schemmer, 1995  */
/* Jenaer Weg 11, 65931 Frankfurt, Bernd.Schemmer@gmx.de              */
/*                                                                    */
/**********************************************************************/


  dummy = trace( 'OFF' )

                    /* save current environment                       */
  call SETLOCAL

/* ------------------------------------------------------------------ */

                    /* names of the global variables, which all       */
                    /* procedures must know                           */
  exposeList = 'prog. screen. I!. global. strs. argv. option. progOption. '

                    /* init all global stems                          */
  interpret 'parse value "" with ' exposeList

                    /* Version of REXXCC                              */
  global.__Version = 3.23

                    /* constants for the comment begin and comment    */
                    /* end tokens                                     */
  global.__c1 = '/' || '*'
  global.__c2 = '*' || '/'

                    /* get the first no. of the first line with       */
                    /* user code                                      */
  call I!.__GetUserCode

/* ------------------------------------------------------------------ */
/* install the error handler                                          */

                    /* break errors (CTRL-C)                          */
  CALL ON HALT        NAME I!.__UserAbort

                    /* syntax errors                                  */
  SIGNAL ON SYNTAX    NAME I!.__ErrorAbort

                    /* using of not initialisized variables           */
  SIGNAL ON NOVALUE   NAME I!.__ErrorAbort

                    /* handle Failure, Error and NotReady ourself     */
  SIGNAL OFF FAILURE
  SIGNAL OFF ERROR
  SIGNAL OFF NOTREADY

/* ------------------------------------------------------------------ */
/* init the variables                                                 */

                    /* return code if an internal error occurs        */
  global.__ErrorExitCode = 255

                    /* init the program return code                   */
  prog.__ExitCode = 0

                    /* get drive, path and name of this program       */
  parse upper source . . prog.__FName
  prog.__Drive      = filespec( "D", prog.__FName )
  prog.__Path       = filespec( "P",  prog.__FName )
  prog.__Name       = filespec( "N",  prog.__FName )
  prog.__env        = 'OS2ENVIRONMENT'
  prog.__CurDir     = translate( directory() )

                    /* default log file is the NUL device             */
  prog.__LogFile = 'NUL'
  prog.__LogAll = '2>NUL 1>NUL'

                    /* default screen length and width                */
  prog.__ScreenCols = 80
  prog.__ScreenRows = 25

                    /* use the real screen length and width if        */
                    /* REXXUTIL is loaded                             */
  SIGNAL on SYNTAX Name NRU

  parse value SysTextScreenSize() with prog.__ScreenRows prog.__ScreenCols

NRU:
  SIGNAL ON SYNTAX    NAME I!.__ErrorAbort

/* ------------------------------------------------------------------ */
                    /* check current ADDRESS() environment            */
  if ADDRESS() <> 'CMD' then
  do
    call I!.__SignMsg
    call ShowError 235 ,,
                   'You can only execute this program in a CMD session'
  end /* if */

/* ------------------------------------------------------------------ */

  drop progOption.

/* ------------------------------------------------------------------ */

  progOption.__TFound = 0

/* ------------------------------------------------------------------ */

                    /* init variables for the options                 */
  parse value 0 0 0 0 0 0 0 0 0 0 0 0 0 with ,
   progOption.__Sound     , /* <> 0 : use sounds                      */
   progOption.__IVer      , /* <> 0 : don't check the REXX version    */
   progOption.__IExt      , /* <> 0 : don't check the file extensions */
   progOption.__IDate     , /* <> 0 : don't check the date of the src */
   progOption.__Overwrite , /* <> 0 : overwrite existing targetfiles  */
   progOption.__UseSource , /* <> 0 : use the src as copyright file   */
   progOption.__LineCount , /* no of lines for the copyright file     */
   progOption.__Compress  , /* <> 0 : only compress the file          */
   progOption.__AddCode   , /* <> 0 : add error checking code         */
   progOption.__ShowDate  , /* <> 0 : show time stamps                */
   progOption.__NoDate    , /* <> 0 : suppress time stamp in footer   */
   progOption.__CMode     , /* <> 0 : old compression sheme           */
   progOption.__NoColors    /* <> 0 : don't use colors                */

                    /* init the result stems for the parameters       */
  argv.0 = 0
  option.0 = 0

                    /* first check the environment variable           */
  call SplitParameter strip( value( 'REXXCC' ,, prog.__env ), 'B', '"'), 0

                    /* arguments in the environment variable are      */
                    /* invalid!                                       */
  do i = 1 to argv.0
    option.__EErrors = option.__EErrors argv.i
  end /* do */

                    /* now check the parameter                        */
  call SplitParameter arg(1), 1

                    /* and now check the options from the environment */
                    /* variable and the parameter                     */
  do i = 1 to option.0
    select
                    /* check for the parameter /SILENT                */
      when option.i.__keyword = 'SILENT' then
        prog.__QMode = 1

      when wordpos( option.i.__keyword, '? H HELP' ) <> 0 then
        prog.__ShowHelp = 1

      when option.i.__keyword = 'LOG' then
      do

        if option.i.__keyValue <> '' then
        do

          parse var option.i.__keyValue _1char +1 logFile
          if _1char = '!' then
            call DeleteFile logfile
          else
            logFile = option.i.__keyValue

                    /* check if we can write to the logfile           */
          logStatus = stream( logfile, 'c', 'OPEN WRITE')
          if logStatus <> 'READY:' then
            call ShowWarning 'Can not write to the logfile "' || logfile || ,
                             '", the status of the logfile is "' || ,
                             logStatus || ,
                             '". Now using the NUL device for logging'
          else
          do
                    /* close the logfile                              */
            call stream logfile, 'c', 'CLOSE'

                    /* get the full name (incl. the path) of the      */
                    /* logfile                                        */
            prog.__LogFile = translate( stream( logFile, 'c', 'QUERY EXIST' ) )

          end /* else */
        end /* if */

      end /* when */

      otherwise
      do
        pOK = datatype( option.i.__keyWord, 'SYMBOL' )
        if pOK then
          pOK = symbol( 'progOption.__' || VALUE( option.i.__keyword ) ) = 'VAR'

        if \ pOK then
        do
          if option.i.__addInfo = 1 then
            option.__PErrors = option.__PErrors option.i.__keyword
          else
            option.__EErrors = option.__EErrors option.i.__curArg
        end /* if */
        else
        do
          if option.i.__KeyValue = '' then
            option.i.__KeyValue = '1'
          iLIne = 'progOption.__' || option.i.__keyWord ' = option.i.__keyvalue '
          interpret iLine
        end /* else */
      end /* otherwise */

    end /* select */
  end /* do i = 1 to option.0 */

/* ------------------------------------------------------------------ */

   fn = ConvertNameToOS( prog.__LogFile )

                    /* variable to direct STDOUT of an OS/2           */
                    /* program into the logfile                       */
   prog.__LogSTDOUT = ' 1>>' || fn

                    /* variable to direct STDERR of an OS/2           */
                    /* program into the logfile                       */
   prog.__LogSTDERR = ' 2>>' || fn

                    /* variable to direct STDOUT and STDERR of        */
                    /* an OS/2 program into the log file              */
   prog.__LogALL = prog.__LogSTDERR  || ' 1>>&2'

/* ------------------------------------------------------------------ */
                    /* default: compile the sourcefile                */
  global.__cMsg1 = ' Compiling '
  global.__cMsg2 = 'compiled'

  if progOption.__Compress <> 0 then
  do
    global.__cMsg1 = ' Compressing '
    global.__cMsg2 = 'compressed'
  end /* if progOption.__Compress = 1 then */

/* ------------------------------ */
                    /* init further variables                         */
  fn = ''
  if progOption.__NoDate = 0 then
    fn = ' on ' || date( 'U' ) || ' at ' || time()

  global.__CopyrightMessage = global.__c1                  || ,
                              ' created'                   || ,
                              fn                           || ,
                              ' with '                     || ,
                              'REXXCC V'                   || ,
                              global.__version             || ,
                              ' (c) Bernd Schemmer 1998 '  || ,
                              global.__c2

                    /* place holder for string constants              */
  global.__sM1 = '01'x
  global.__sM2 = '02'x

                    /* special comment for programs based on TEMPLATE */
  global.__sCmt = global.__c1 || '!' || global.__c2

                    /* place holder for the special comments          */
  global.__sCmtMarker = '03'x

/* ------------------------------------------------------------------ */

  if progOption.__NoColors <> 1 then
  do
                    /* delete rest of the line                        */
       screen.__DelEOL = '[K'

                    /* define color attributes                        */
      screen.__AttrOff = '[0;m'
    screen.__Highlight = '[1;m'
       screen.__normal = '[2;m'

/*        screen.__blink = '[5;m'    */
/*       screen.__invers = '[7;m'    */
/*    screen.__invisible = '[8;m'    */

                    /* save the cursor position                       */
    screen.__SavePos     = '1B'x || '[s'
                    /* restore the cursor position                    */
    screen.__RestPos     = '1B'x || '[u'

                    /* define foreground color variables              */
/*      screen.__fgBlack = '[30;m'   */
/*        screen.__fgRed = '[31;m'   */
/*   screen.__fgMagnenta = '[35;m'   */
/*       screen.__fgCyan = '[36;m'   */

      screen.__fgGreen = '[32;m'
     screen.__fgYellow = '[33;m'
       screen.__fgBlue = '[34;m'
      screen.__fgWhite = '[37;m'

                    /* define background color variables              */
      screen.__bgBlack = '[40;m'
        screen.__bgRed = '[41;m'

/*      screen.__bgGreen = '[42;m'   */
/*     screen.__bgYellow = '[43;m'   */
/*       screen.__bgBlue = '[44;m'   */
/*   screen.__bgMagnenta = '[45;m'   */
/*       screen.__bgCyan = '[46;m'   */
/*      screen.__bgWhite = '[47;m'   */

                    /* define color variables                         */
    screen.__ErrorColor = screen.__AttrOff || screen.__Highlight || ,
                          screen.__FGYellow || screen.__bgRed
   screen.__NormalColor = screen.__AttrOff || ,
                          screen.__fgWhite || screen.__bgBlack

   screen.__SignOnColor = screen.__AttrOff || screen.__Highlight || ,
                          screen.__fggreen || screen.__bgBlack

/*
    screen.__DebugColor = screen.__AttrOff || screen.__Highlight || ,
                          screen.__fgBlue || screen.__bgWhite

*/

/*
   screen.__PromptColor = screen.__AttrOf || screen.__Highlight || ,
                          screen.__fgYellow || screen.__bgMagnenta
*/
                    /* set the default color                          */
      screen.__CurColor = screen.__NormalColor

  end /* if */

                    /* strings that should not be written into        */
                    /* the log file                                   */
  prog.__LogExWords = screen.__fgYellow screen.__highlight screen.__AttrOff

/* ------------------------------------------------------------------ */
                    /* output device for the 'in progress' message    */
  global.__PDev = 'NUL'
  if ( prog.__QMode <> 1 ) & ( screen.__normalColor <> '' ) then
    global.__PDev = 'STDOUT'

/* ------------------------------------------------------------------ */
                    /* show program start message                     */
  call I!.__SignMsg

/* ------------------------------------------------------------------ */
  if prog.__ShowHelp = 1 then
  do
    prog.__ExitCode = 1

    if stream( prog.__FName, 'c', 'OPEN READ' ) = 'READY:' then
    do
      do i = 1 while lines( prog.__FName ) <> 0
        call log lineIn( prog.__FName )
        if i = 20 then
        do
          i = 1
          say ''
          say center( '--- Press RETURN to continue ---', prog.__ScreenCols )

/*
          call lineIn
*/
          if wordpos( translate( strip( lineIN() ) ), 'EXIT Q' ) <> 0 then
            leave
        end /* if i = 20 then */
      end /* do i = 1 while lines( ... */
                    /* close the file                                 */
      call stream prog.__FName, 'c', 'CLOSE'
    end /* if */
    else
    do
                    /* the source code is not available               */
                    /* (either it's in the macro space or used by     */
                    /*  another program)                              */
      call ShowString 'Usage: REXXCC ',,
              'source TO target {WITH copyrightfile}',
              '{/IExt} {/IDate} {/IVer} {/Overwrite}',
              '{/UseSource} {/LineCount=n} {/Compress} {/AddCode}',
              '{/CMode} {/ShowDate} {/NoDate}',
              '{/LOG=logfilename} {/Sound} {/NoColors} {/?} {/HELP}'
    end /* if */

    SIGNAL I!.__programEnd
  end /* if prog.__ShowHelp = 1 then */

/* ------------------------------------------------------------------ */

  CRC1 = GetCRC( global.__CopyrightMessage )

  if ( CRC1 <> 3722 & CRC1 <> 4494 ) then
    call showError 232 ,,
                   'This is a patched version of the program. It won''t work'

  if InMacroSpace() <> 1 then
  do
    fn = ''
    do i = 1 to 16
      fn = fn || sourceLine( i );
    end /* do */
    CRC2 = GetCRC( fn )

                      /* check if version is changed                    */
    if CRC2 <> 59161 | prog.__Name <> 'REXXCC.CMD' then
    do
      screen.__CurColor = screen.__ErrorColor

      if progOption.__Sound = 1 then
        call CharOut prog.__STDOUT, ''

      call log center( ' WARNING ', prog.__ScreenCols,'*' )

      call ShowString 4,,
         'This version of REXXCC is not a copy of the original version!',
         'You may use this program but you should get an original copy of ',
         'this program as soon as possible from your local BBS, CompuServe,',
         'the Internet, or you may contact the author:'

      call log center( 'Bernd Schemmer, CompuServe: 100104,613' , prog.__ScreenCols,' ' )

      call log center( ' ', prog.__ScreenCols, ' ' )
      call log center( ' Press RETURN to continue ',prog.__ScreenCols,'-' )
      screen.__CurColor = screen.__NormalColor

      call linein
    end /* if sourceLine( 2 ) <> ... */
  end /* if */

  if progOption.__IVer = 0 then
  do
                    /* check the rexx version                         */
    parse version rexx.vName rexx.vNo rexx.vDate
    if rexx.vName <> 'REXXSAA' |,
       rexx.vNo   < 4.00 then
      call ShowError 233 ,,
                'Invalid REXX interpreter version'
  end /* if progOption.__IVer = 0 then */

                    /* check, if we can create temporary files        */
  global.__TempFile = getTempFile()
  if global.__TempFile = '' then
    call ShowError 2 ,,
                   'Can not find a name for a temporary file (Check the environment variable "TEMP" or "TMP")'

  global.__CurDirectory = directory()

  drop rexx.

/* ------------------------------------------------------------------ */
                    /* check the options for REXXCC                   */
  if option.__EErrors <> '' then
    call ShowError 60 ,,
                   'Invalid string(s) "' || option.__EErrors || '" in the environment variable "REXXCC"'

  if option.__PErrors <> '' then
    call ShowError 62 ,,
      'The string "' || option.__PErrors || '" in the parameters is not a valid option'

/* ------------------------------ */
                    /* check the parameters sourcefile,               */
                    /* targetfile and copyrightfile                   */
  call CheckFileParameter

/* ------------------------------ */

  np = 'ATTRIB.EXE'
  if progOption.__Compress = 0 then
    nP = 'EAUTIL.EXE' np

                    /* check if the programs EAUTIL.EXE and           */
                    /* ATTRIB.EXE are in the path                     */
  do i = 1 to words( nP )
    curNp = word( nP,i )
    if SearchFile( curNp, 'PATH', prog.__env ) = '' then
      call ShowError 3 ,,
                     'Can not find the program "' || ,
                     curNP || ,
                     '" (Check the variable "PATH")'
  end /* do i = 1 to ... */

  progOption.__TFound = 1

/* ------------------------------ */
                    /* compile the sourcefile                         */
  call CompileSourceFile

/* ------------------------------------------------------------------ */
/* house keeping                                                      */

I!.__ProgramEnd:
                    /* delete temporary files                         */
  call DelTemporaryFiles

                    /* reset the current directory                    */
  if symbol( 'prog.__CurDir' ) = 'VAR' then
    call directory prog.__CurDir

                    /* show sign off message                          */
  call I!.__SignMsg 'E'

EXIT prog.__ExitCode

/* ------------------------------------------------------------------ */
/*-function: show the sign on or sign off message                     */
/*                                                                    */
/*-call:     I!.__SignMsg which                                       */
/*                                                                    */
/*-where:    which - 'E' - show the sign off message                  */
/*                         else show the sign on message              */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
I!.__SignMsg: PROCEDURE expose (exposeList)
                    /* default: sign on message                       */
  tMsg1 = ' started on '
  tMsg2 = ' ...'

  if arg(1) = 'E' then
  do
                    /* sign off message                               */
    tMsg1 = ' ended on '
    tMsg2 = ' with RC = ' || prog.__ExitCode

                    /* check if the exit code is decimal              */
    if dataType( prog.__ExitCode, 'W' ) then
      tMsg2 = tMsg2 || " ('" || D2X( prog.__ExitCode ) || "'x)"

  end /* if arg(1) = 'E' then */

  screen.__CurColor = screen.__SignOnColor
  call Log prog.__Name || ' ' || global.__version || tMsg1 || ,
       date() || ' at ' || time() || tMsg2

  screen.__CurColor = screen.__NormalColor
RETURN

/* ------------------------------------------------------------------ */
/*-function: call a user defined routine                              */
/*           (avoid errors if the routine is not defined)             */
/*                                                                    */
/*-call:     I!.__CallUserProc errorAction, procName {prcoParameter}  */
/*                                                                    */
/*-where:    errorAction - action, if procName is not defined         */
/*                         0: do nothing (only set the RC)            */
/*                         1: show a warning and set the RC           */
/*                         2: abort the program                       */
/*           procName - name of the procedure                         */
/*           procParameter - parameter for the procedure              */
/*                                                                    */
/*-returns:  1 - ok                                                   */
/*           0 - procname not found                                   */
/*                                                                    */
/*-output:   I!.__UserProcRC - Returncode of the called procedure     */
/*                             (uninitialisied if the proedure didn't */
/*                             reeturn a value)                       */
/*                                                                    */
I!.__CallUserProc: PROCEDURE expose (exposeList) result rc sigl
  parse arg I!.__ErrorAction , I!.__procName I!.__procParameter

  I!.__thisRC = 0
  drop I!.__UserProcRC

  iLine =  'call ' I!.__procName

/*** DO NOT CHANGE, ADD OR DELETE ONE OF THE FOLLOWING FOUR LINES!! ***/
  SIGNAL I!.__CallUserProc1                                        /*!*/
I!.__CallUserProc1:                                                /*!*/
  I!.__InterpretCMDLine = sigl + 3                                 /*!*/
  interpret iLine "I!.__ProcParameter"                             /*!*/
/*** DO NOT CHANGE, ADD OR DELETE ONE OF THE PRECEEDING FOUR LINES! ***/
  I!.__thisRC = 1
  if symbol( 'RESULT' ) = 'VAR' then
    I!.__UserProcRC = value( 'RESULT' )

I!.__CallUserProc2:

RETURN I!.__thisRC

/* ------------------------------------------------------------------ */
/*-function:  convert a file or directory name to OS conventions      */
/*            by adding a leading and trailing quote or double quote  */
/*                                                                    */
/*-call:      convertNameToOS dir_or_file_name                        */
/*                                                                    */
/*-where:     dir_or_file_name = name to convert                      */
/*                                                                    */
/*-returns:   converted file or directory name                        */
/*                                                                    */
ConvertNameToOS: PROCEDURE expose (exposeList)
  parse arg fn

  if left( fn,1 ) = '-' then
    fn = '.\' || fn

RETURN '"' || fn || '"'

/* ------------------------------------------------------------------ */
/*-function: show a string with word wrapping                         */
/*                                                                    */
/*-call:     showString Prefix, thisString                            */
/*                                                                    */
/*-where:                                                             */
/*           Prefix = prefix for the first line (e.g. "*-*" or "#" to */
/*                    use # leading blanks, # = 1 ... n )             */
/*           thisString - string to print                             */
/*                                                                    */
/*-returns:  ''                                                       */
/*                                                                    */
ShowString: PROCEDURE EXPOSE (exposeList)
  parse arg Prefix, thisStr

  maxLineL = prog.__ScreenCols-4

  if datatype( prefix, 'W' ) == 1 then
    prefix = copies( ' ' , prefix )

  maxWordL = maxLineL - length( prefix )

  thisRC = 0
  curStr = ''

  do i = 1 to words( thisStr)
    pStr = 0

    curStr = curStr || word( thisStr, i ) || ' '

    if length( curStr ) + ,
       length( prefix ) + ,
       length( word( thisStr, i+1 ) ) > maxLineL then
      pStr = 1

    if 1 == pStr | i == words( thisStr ) then
    do
      if length( prefix || curStr ) > prog.__ScreenCols then
      do until curStr = ''
        parse var curStr curStr1 =(maxWordL) ,
                                  curStr
        call log left( prefix || curStr1, prog.__ScreenCols )

        prefix = copies( ' ', length( prefix ) )
      end /* if length( ... then do until */
      else
        call Log left( prefix || curStr, prog.__ScreenCols )

      curStr = ''
      prefix = copies( ' ', length( prefix ) )
    end /* if 1 == pStr | ... */

  end /* do i = 1 to words( thisStr */

RETURN ''

/* ------------------------------------------------------------------ */
/*-function: show a warning message                                   */
/*                                                                    */
/*-call:     showWarning message                                      */
/*                                                                    */
/*-where:    warningMessage - warning Message                         */
/*                                                                    */
/*-returns:  ''                                                       */
/*                                                                    */
ShowWarning: PROCEDURE expose (exposeList)
  parse arg wMsg

  screen.__CurColor = screen.__ErrorColor

  call I!.__LogSeparator1
  call ShowString ' Warning: ', wMsg || '!'
  call I!.__LogSeparator

  screen.__CurColor = screen.__NormalColor
  call Log ''

RETURN ''

/* ------------------------------------------------------------------ */
/*-function: show an error message and end the program                */
/*                                                                    */
/*-call:     ShowError exitCode, errorMessage                         */
/*                                                                    */
/*-where:    ExitCode - no of the error (= program exit code)         */
/*           errorMessage - error Message                             */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*-Note:     THIS ROUTINE WILL NOT COME BACK!!!                       */
/*                                                                    */
ShowError: PROCEDURE expose (exposeList)
  parse arg prog.__ExitCode, prog.__errMsg

  I!.__QM = prog.__QMode
                    /* turn quiet mode off                            */
  prog.__QMode = ''

  screen.__CurColor = screen.__ErrorColor

  call I!.__LogSeparator1
  call Log left(' REXXCC - Error ' || prog.__ExitCode  || ' detected! ' || ,
      'The error message is: ',prog.__ScreenCols )
  call ShowString 1, prog.__errMsg || '!'

  call I!.__LogSeparator
  call Log ''
                    /* restore quiet mode status                      */
  prog.__QMode = I!.__QM

  if progOption.__Sound = 1 then
  do
    call beep 537,300
    call beep 237,300
    call beep 537,300
  end /* if */

SIGNAL I!.__ProgramEnd

/* ------------------------------------------------------------------ */
/*-function: write a separator line to the screen and to the logfile  */
/*                                                                    */
/*-call:     I!.__LogSeparator                                        */
/*                                                                    */
/*-where:    -                                                        */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
I!.__LogSeparator1:
  call log ''
I!.__LogSeparator:
  call Log ' ' || left('-', prog.__ScreenCols-2, '-' ) || ' '
RETURN

/* ------------------------------------------------------------------ */
/*-function: log a message and clear the rest of the line             */
/*                                                                    */
/*-call:     log message                                              */
/*                                                                    */
/*-where:    message - message to show                                */
/*                                                                    */
/*-returns:  ''                                                       */
/*                                                                    */
/*-Note:     You do not need the 'call' keyword to use this routine.  */
/*                                                                    */
Log: PROCEDURE expose (exposeList)
  parse arg msg

  logmsg = msg
  do i = 1 to words( prog.__LogExWords )
    curWord = word( prog.__LogExWords, i )
    do until j = 0
      j = Pos( curWord, logmsg )
      if j <> 0 then
        logmsg = delstr( logmsg, j, length( curWord )  )
    end /* do until j = 0 */
  end /* do i = 1 to words( prog.__LogExWords ) */

  if prog.__QMode <> 1 then
  do
    ds = ''
    if \(length( logmsg ) = prog.__ScreenCols & ADDRESS() = 'CMD') then
      ds = screen.__DelEOL || '0D0A'x

    call charout prog.__STDOUT, screen.__CurColor || msg || screen.__AttrOff || ds

  end /* if prog.__QMode <> 1 then */

  if symbol( 'prog.__LogFile' ) = 'VAR' then
    if prog.__LogFile <> '' then
    do
      call lineout prog.__LogFile, logmsg

                    /* close the logfile                              */
      call stream prog.__LogFile, 'c', 'CLOSE'
    end /* if prog.__LogFile <> '' then */

RETURN ''

/* ------------------------------------------------------------------ */
/*-function: error handler for user breaks                            */
/*                                                                    */
/*-call:     DO NOT CALL THIS ROUTINE BY HAND!!!                      */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*           In exit routines you may test if the variable            */
/*           prog.__ExitCode is 254 to check if the program           */
/*           was aborted by the user.                                 */
/*                                                                    */
I!.__UserAbort:
                    /* reinstall the error handler                    */
  I!.__sigl = sigl
  CALL ON HALT        NAME I!.__UserAbort

/*
                    /* check if user aborts are allowed               */
  if prog.__UserAbort = 0 then
    RETURN
*/

  if prog.__ShowHelp <> 1 then
  do
    I!.__QM = prog.__QMode

                    /* turn quiet mode off                            */
    prog.__QMode = ''

    screen.__CurColor = screen.__ErrorColor
    call I!.__LogSeparator1
    call Log left( ' REXXCC aborted by the user (sigl=' || i!.__sigl || ')' , prog.__ScreenCols )
    call I!.__LogSeparator
    screen.__CurColor = screen.__NormalColor

    prog.__ExitCode = 254

                    /* restore quiet mode status                      */
    prog.__QMode = I!.__QM
  end /* if */
SIGNAL I!.__ProgramEnd

/* ------------------------------------------------------------------ */
/*-function: get the no. of the first line with the user code         */
/*                                                                    */
/*-call:     DO NOT CALL THIS ROUTINE BY HAND!!!                      */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*                                                                    */
I!.__GetUserCode:
/*** DO NOT CHANGE, ADD OR DELETE ONE OF THE FOLLOWING FOUR LINES!! ***/
  SIGNAL I!.__GetUserCode1                                         /*!*/
I!.__GetUserCode1:                                                 /*!*/
  I!.__FirstUserCodeLine = sigl + 4                                /*!*/
/*** DO NOT CHANGE, ADD OR DELETE ONE OF THE PRECEEDING FOUR LINES! ***/
RETURN

/********************** End of Runtime Routines ***********************/

/* ------------------------------------------------------------------ */

/*** INSERT FURTHER SUBROUTINES HERE ***/

/* ------------------------------------------------------------------ */
/*-function: house keeping                                            */
/*                                                                    */
/*-call:     DelTemporaryFiles                                        */
/*                                                                    */
/*-where:    -                                                        */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*                                                                    */
DelTemporaryFiles: PROCEDURE expose (exposeList)

                    /* delete temporary files                         */
  call DeleteFile global.__TempFile
  call DeleteFile global.__TempCFile

                    /* in case of an error delete the target file     */
                    /* also                                           */
  if prog.__ExitCode <> 0 then
    call DeleteFile global.__TargetFile

RETURN

/* ------------------------------------------------------------------ */
/* Function: check if a drive is ready                                */
/*                                                                    */
/* call:     ChkDrv drive                                             */
/*                                                                    */
/* where:    drive - drive specifier (E.g. "A:")                      */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* note:     This routine aborts the program if the drive is not      */
/*           ready                                                    */
/*                                                                    */
ChkDrv: PROCEDURE expose (exposeList)
  tDrv = left( arg(1), 2 )

  SIGNAL ON NOTREADY NAME DNR

  call stream tDrv || '*'

RETURN

DNR:
  call ShowError 19, 'Drive "' || tDrv || '" is not ready'
RETURN

/* ------------------------------------------------------------------ */
/* Function: add quote chars and color codes to a string              */
/*                                                                    */
/* call:     AddColor1( quoteChar ,myString )                         */
/*                                                                    */
/* where:    quoteChar - leading and trailing character for the       */
/*                       converted string (may be ommited)            */
/*           myString - string to convert                             */
/*                                                                    */
/* returns:  converted string                                         */
/*                                                                    */
AddColor1: PROCEDURE expose (exposeList)
  parse arg qChar, mStr

return qChar || screen.__fgYellow || screen.__highlight || ,
       mStr || ,
       screen.__AttrOff || qChar

/* ------------------------------------------------------------------ */
/*-function: convert a time in the format hh:mm:ss into the file time */
/*           format                                                   */
/*                                                                    */
/*-call:     OSTImeToFileTime time_string                             */
/*                                                                    */
/*-where:    time_string - string to convert                          */
/*                                                                    */
/*-returns:  the time in file time format as decimal string           */
/*                                                                    */
/*-Note:     use D2C(filetime) to convert the result into a binary    */
/*           value                                                    */
/*                                                                    */
/* The format of the file time format is:                             */
/* Length: 16 Bit                                                     */
/* Description:                                                       */
/* Bit         contents                                               */
/* -------------------------                                          */
/*  0 ...  4   seconds mod 2                                          */
/*  5 ... 10   minutes                                                */
/* 11 ... 15   hours                                                  */
/*                                                                    */
OSTimeToFileTime: PROCEDURE EXPOSE ( exposeList )
   parse arg tStr

   parse var tStr hh +2 sep +1 mm ( sep ) ss

   if datatype( hh || mm || ss,   'W' ) <> 1 then
     call ShowError 234 ,,
                    'Internal error OTFT'

   fT = ( ss % 2 ) + ( mm * 32 ) + ( hh * 2048 )
RETURN fT

/* ------------------------------------------------------------------ */
/*-function: convert a time in the file time format into the format   */
/*           hh:mm:ss                                                 */
/*                                                                    */
/*-call:     FileTImeToOSTIme time_string                             */
/*                                                                    */
/*-where:    time_string - string to convert                          */
/*                                                                    */
/*-returns:  the time in OS time format as decimal string             */
/*                                                                    */
/*                                                                    */
FileTimeToOSTime: PROCEDURE EXPOSE ( exposeList )
   parse arg ft sep

   if datatype( ft, 'W' ) <> 1 then
     call ShowError 234 ,,
                    'Internal error FTOT'

   ss = right( ( ft // 32 ) * 2, 2, '0' )
   mm = right( ( ft // 2048 ) % 32, 2, '0' )
   hh = right( ( ft % 2048 ), 2, '0' )

   OSTime = hh || sep || mm || sep || ss

RETURN OStime

/* ------------------------------------------------------------------ */
/*-function: convert a date in the format mm-dd-yy or dd-mm-yy into   */
/*           the file date format                                     */
/*                                                                    */
/*-call:     OSDateToFileDate date_string dateFormat                  */
/*                                                                    */
/*-where:    date_string - string to convert                          */
/*           dateFormat - A = mm-dd-yy                                */
/*                        E = dd-mm-yy                                */
/*                                                                    */
/*-returns:  the date in file time format as decimal string           */
/*                                                                    */
/*-Note:     use D2C(filedate) to convert the result into a binary    */
/*           value                                                    */
/*                                                                    */
/* Note: use D2C(filedate) to convert the result into a binary value  */
/*                                                                    */
/* The format of the file date format is:                             */
/* Length: 16 Bit                                                     */
/* Description:                                                       */
/* Bit         contents                                               */
/* -------------------------                                          */
/*  0 ...  4   day                                                    */
/*  5 ...  8   month                                                  */
/*  9 ... 15   year - 1980                                            */
/*                                                                    */
OSdateToFiledate: PROCEDURE EXPOSE ( exposeList )
   parse arg dt df

   if translate( df ) = 'E' then
     parse var dt dd +2 sep +1 mm ( sep ) yy
   else
     parse var dt mm +2 sep +1 dd ( sep ) yy

   if datatype( mm || dd || yy,   'W' ) <> 1 then
     call ShowError 234 ,,
                    'Internal error ODFD'

   filedate = ( dd ) + ( mm * 32 ) + ( ( yy-80 ) * 512 )

RETURN filedate

/* ------------------------------------------------------------------ */
/*-function: convert a date in the file date format into the format   */
/*           mm-dd-yy or dd-mm-yy                                     */
/*                                                                    */
/*-call:     FileTImeToOSTIme date_string separator dateFormat        */
/*                                                                    */
/*-where:    date_string - string to convert                          */
/*           separator - separator char for the date in OS format     */
/*           dateFormat - A = mm-dd-yy                                */
/*                        E = dd-mm-yy                                */
/*                                                                    */
/*-returns:  the date in OS date format as decimal string             */
/*                                                                    */
/*                                                                    */
FiledateToOSdate: PROCEDURE EXPOSE ( exposeList )
   parse arg fd sep df

   if datatype( fd, 'W' ) <> 1 then
     call ShowError 234 ,,
                    'Internal error FDOD'

   dd = right( ( fd // 32 ) , 2, '0' )
   mm = right( ( fd // 512 ) % 32, 2, '0' )
   yy = right( ( fd % 512 )+80, 2, '0' )

   if translate( df ) = 'E' then
     OSdate = dd || sep || mm || sep || yy
   else
     OSdate = mm || sep || dd || sep || yy

RETURN OSdate


/* ------------------------------------------------------------------ */
/*-function: check the parameters                                     */
/*                                                                    */
/*-call:     CheckFileParameter                                       */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
CheckFileParameter: PROCEDURE EXPOSE ( exposeList )

  if argv.2 <> 'TO' |,
     argv.1 = '' | ,
     argv.3 = '' | ,
     (argv.4 <> 'WITH' & argv.5 <> '' ) |,
     (argv.4 <> '' & argv.5 = '' ) | ,
     argv.6 <> '' then
    call ShowError 11, 'Parameter missing or invalid parameter found'

  global.__sourceFile = argv.1
  global.__targetDir = argv.3
  global.__copyrightFile = argv.5

                    /* check the extension of the sourcefile          */
  global.__sourceFile = CheckExt( global.__sourceFile )
  if global.__sourceFile = '' then
    call ShowError 13 ,,
                  'The extension of the sourcefile must be ".CMD"'

  if ( global.__copyrightFile = '' & progOption.__UseSource <> 0 ) | ,
     ( global.__CopyrightFile = '=' ) then
    global.__CopyrightFile = global.__SourceFile

  call ChkDrv global.__SourceFile

                    /* check if the sourcefile exists                 */
  if stream( global.__sourceFile,'c', 'QUERY EXIST' ) = '' then
    call ShowError 12 ,,
                   'The sourcefile "' || global.__SourceFile || '" does not exist'

                    /* check if the sourcefile is a valid REXX program*/
  if progoption.__IExt = 0 then
    if CharIn( global.__SourceFile,1, 2 ) <> global.__c1 then
      call ShowError 57,,
                     'The file "' || global.__SourceFile || '" is NOT a REXX program'
    else
      call stream global.__SourceFile, 'c', 'CLOSE'

  call ChkDrv global.__TargetDir

                    /* check if the target is a directory             */
                    /* or a filename                                  */
                    /* and create and test the name for               */
                    /* the targetfile                                 */
  saveDir = directory( filespec( "drive", global.__TargetDir ) )

  if pos( right( global.__TargetDir, 1 ), '\:' ) <> 0 then
    global.__TargetFile = global.__TargetDir || fileSpec( 'Name', global.__SourceFile )
  else
  do
    if directory( global.__targetDir ) = '' then
      if directory( directory() || global.__TargetDir ) = '' then
        if directory( directory() || '\' || global.__TargetDir ) = '' then
        do
          global.__TargetFile = global.__TargetDir
          global.__TargetDir = filespec( "drive", global.__TargetDir ) || ,
                             filespec( "path", global.__TargetDir )
        end /* if directory( ... */
        else
          global.__TargetDir = directory()
      else
        global.__TargetDir = directory()
  end /* else */

  if global.__TargetDir <> '' then
    if pos( right( global.__TargetDir, 1 ), '\:' ) = 0 then
      global.__TargetDir = global.__TargetDir || '\'

  if global.__targetFile = '' then
    global.__targetFile = global.__targetDir || filespec( 'N', global.__sourceFile )

                    /* reset the current directory                    */
  call directory saveDir
  call directory global.__CurDirectory

  global.__TargetFile = CheckExt( global.__TargetFile )
  if global.__TargetFile = '' then
    call ShowError 14 ,,
                   'The extension for the targetfile must be ".CMD"'

  if stream( global.__TargetFile ,'c', 'QUERY EXIST' ) <> '' then
    if progOption.__Overwrite = '0' then
    do
                    /* avoid deleting the targetfile!!!               */
      dummy = global.__TargetFile
      global.__TargetFile = ''

      call ShowError 15 ,,
                     'The targetfile "' || dummy || '" already exist'
    end /* if stream( global.__TargetFile ... */
    else
      if stream( global.__Targetfile, 'c', 'QUERY EXIST' ) = ,
         stream( global.__SourceFile, 'c', 'QUERY EXIST' ) then
        do
          global.__TargetFile = ''
          call ShowError 18 ,,
                         'The targetfile can not be equal with the sourcefile'
        end /* if stream( ... */

  if global.__CopyrightFile <> '' then
  do
    call ChkDrv global.__CopyrightFile

                    /* check if the copyright file exists             */
    if stream( global.__copyrightFile,'c', 'QUERY EXIST' ) = '' then
      call ShowError 16 ,,
                     'The CopyrightFile "' || global.__CopyrightFile || '" does not exist'

    if stream( global.__copyrightFile, 'c', 'QUERY DATETIME' ) = '' then
      call ShowError 17 ,,
                     'The copyrightFile can not be a device'

  end /* if global.__CopyrightFile <> '' then */

RETURN

/* ------------------------------------------------------------------ */
/*-function: check the extension of a filename                        */
/*                                                                    */
/*-call:     filename1 = CheckExt( filename )                         */
/*                                                                    */
/*-where:    fileName = the filename to check                         */
/*                                                                    */
/*-returns:  either the correct filename or ""                        */
/*                                                                    */
CheckExt: PROCEDURE expose (exposeList)
  parse arg tf

  i = lastpos( '.', tf )
                    /* check if the '.' is part of the path           */
  if lastPos( '\', tf ) < i then
  do
    if progOption.__IExt = 0 then
    do
      parse var tf +(i) ext
      if ext <> 'CMD' then
        tf = ''
    end /* if */
  end /* if i <> 0 then */
  else
    tf = tf || '.CMD'
return tf

/* ------------------------------------------------------------------ */
/*-function: compile the sourcefile                                   */
/*                                                                    */
/*-call:     CompileSourceFile                                        */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
CompileSourceFile:
  call log global.__cMsg1 || AddColor1( '"', global.__sourceFile )
  call log ' to ' || AddColor1( '"', global.__TargetFile )

  if global.__CopyrightFile <> '' then
  do
    call log ' The Copyright file is ' ||  AddColor1( '"', global.__CopyrightFile )

    call stream global.__CopyrightFile, 'c', 'OPEN READ'

                    /* check if the copyright file begins with a      */
                    /* comment                                        */
    dd = ReadNextCmt( global.__CopyrightFile )

                    /* close the copyright file                       */
    call stream global.__CopyrightFile, 'c', 'CLOSE'

    if dd = '' & progOption.__IExt = 0 then
        call ShowError 31 ,,
               'The CopyrightFile must begin with a REXX comment in line 1, column 1'

  end /* if global.__CopyrightFile <> '' then */

                    /* delete existing temporary file                 */
  if DeleteFile( global.__TempFile ) <> 1 then
    call ShowError 32 ,,
                    'OS Error ' || rc || ' deleting the temporary file "' || global.__TempFile || '"'

  if progOption.__Compress = 0 then
  do
                    /* copy the EAs of the source into a file         */
    '@eautil ' ConvertNameToOS( global.__sourceFile ) ConvertNameToOS( global.__TempFile ) ' /P /S ' prog.__LogAll
    if rc <> 0 then
      call ShowError 34 ,,
                     'OS Error ' || rc || ' compiling the sourcefile "' || global.__SourceFile || '"'

    if stream( global.__TempFile,'c', 'QUERY EXIST' ) = '' then
      call ShowError 35 ,,
                     'You must first execute the sourcefile "' || global.__SourceFile || '" before compiling it'

  end /* if progOption.__Compress = 0 then */

                    /* delete existing targetfile                     */
  if DeleteFile( global.__TargetFile ) <> 1 then
    call ShowError 33 ,,
                   'OS Error ' || rc || ' deleting the existing targetfile "' || global.__TargetFile || '"'

  if global.__CopyrightFile <> '' then
  do
    if global.__CopyrightFile = global.__SourceFile then
    do
                    /* use the leading comment lines from the         */
                    /* sourcefile as copyright file                   */
      global.__TempCFile = getTempFile()
      global.__CopyrightFile = global.__TempCFile

      if global.__TempCFile = '' then
        call ShowError 36 ,,
                       'Can not find a name for a temporary file ( Check the variable "TEMP" or "TMP" )'

      cLines = 0
      if DATATYPE( progOption.__LineCount, "W" ) = 1 then
        if progOption.__LineCount <> 0 then
          cLines = progOption.__LineCount

      curText = ''

      do i=1
        if cLines <> 0 & i > cLines then
            leave
        curCmt = ReadNextCmt( global.__sourceFile )
        if curCmt = '' then
          leave
        curText = curText || curCmt || '0D0A'x
      end /* do i=1 */

      if curText = '' & progOption.__IExt = 0 then
        call ShowError 31, 'The copyrightfile must begin with a REXX comment in line 1, column 1'
      else
        rc = LineOut( global.__CopyrightFile, curText )

                    /* close the sourcefile                           */
      call stream global.__SourceFile, 'c', 'CLOSE'

                    /* close the copyright file                       */
      call stream global.__CopyrightFile, 'c', 'CLOSE'

    end /* if global.__CopyrightFile = global.__SourceFile then */

                    /* copy the copyright file into the target        */
                    /* file                                           */
    '@type ' ConvertNameToOS( global.__copyrightFile ) prog.__LogSTDErr '>' ConvertNameToOS( global.__TargetFile )
    if rc <> 0 then
      call ShowError 37 ,,
                     'OS Error ' || rc || ' creating the targetfile "' || global.__TargetFile || '"'

  end /* if global.__CopyrightFile <> '' then */
  else
  do
                    /* create an empty targetfile                     */
                    /* (neccessary for 4OS2)                          */
    ' ' '@ECHO.' || global.__c1 ||,
       ' This is a ' || ,
        global.__cmsg2 || ,
        ' REXX file. DO NOT MODIFY THIS FILE! ' || ,
        global.__c2 prog.__LogSTDErr || ' >' || ConvertNameToOS( global.__TargetFile )
    if rc <> 0 then
      call ShowError 38 ,,
                     'OS Error ' || rc || ' creating the targetfile "' || global.__TargetFile || '"'

  end /* else */

  if progOption.__Compress = 0 then
  do
    if progOption.__AddCode <> 0 then
      '@ECHO.' || ,
           '  say "Error: Either you are using an unknown REXX Interpreter version or";'  ||,
           'say "       this program lost it''s extended attributes!" "07"x ;' ||,
           'exit 255' ,
           prog.__LogSTDErr || ' >>' || ConvertNameToOS( global.__TargetFile )

                    /* save the creation date and time of the         */
                    /* new file!                                      */
    dateTimeString = stream( global.__TargetFile, 'c', 'QUERY DATETIME' )
    parse var DateTimeString global.__TargetFileCreationDate global.__TargetFileCreationTime
    drop dateTimeString

    '@attrib -r ' ConvertNameToOS( global.__TargetFile ) prog.__LogAll
    if rc <> 0 then
      call ShowError 39 ,,
                     'OS Error ' || rc || ' creating the targetfile "' || global.__TargetFile || '"'

                    /* append the copyright message to the target     */
                    /* file                                           */
    '@ECHO.' || global.__CopyrightMessage || prog.__LogSTDErr'>>'ConvertNameToOS( global.__TargetFile )
    if rc <> 0 then
      call ShowError 40 ,,
                     'OS Error ' || rc || ' creating the targetfile "' || global.__TargetFile || '"'

                    /* change the EAs of the targetfile               */
    call ChangeEAs

                    /* join the EAs of the sourcefile to the          */
                    /* targetfile                                     */
    '@eautil ' ConvertNameToOS( global.__TargetFile ) ConvertNameToOS( global.__TempFile ) ' /O /J ' prog.__LogAll

    if rc <> 0 then
      call ShowError 41 ,,
                     'OS Error ' || rc || ' creating the targetfile "' || global.__TargetFile || '"'

                    /* change targetfile to read only                 */

    '@attrib +r ' ConvertNameToOS( global.__TargetFile ) prog.__LogAll
    if rc <> 0 then
      call ShowError 42 ,,
                     'OS Error ' || rc || ' creating the targetfile "' || global.__TargetFile || '"'
  end
  else
    call CompressRexxProgram global.__SourceFile , global.__TargetFile

  call log ' ' || AddColor1( '"', global.__TargetFile ) || ' successfully created.'
RETURN

/* ------------------------------------------------------------------ */
/*-function: read a REXX comment from a file                          */
/*                                                                    */
/*-call:     nextComment = ReadNextCmt( rexxprogram )                 */
/*                                                                    */
/*-where:    rexxProgram - name of the REXX program                   */
/*                                                                    */
/*-returns:  "" - the next line is not a REXX comment                 */
/*           else the REXX comment                                    */
/*                                                                    */
/*-note:     This functions reads the next comment from a REXX        */
/*           program. ReadNextCmt handles also multi-line comments.   */
/*                                                                    */
ReadNextCmt: PROCEDURE expose (exposeList)
  parse arg srcFile

  if lines( srcFile ) = 0 then
    RETURN ''

  cLine = strip( lineIn( srcFile ), 'T' )

  if left( cLine,2 ) <> global.__c1 then
    RETURN ''

  do while ( lines( srcFile ) <> 0 ) & ( right( cLine,2 ) <> global.__c2 )
    cLine = cLine || '0D0A'x || strip( lineIn( srcFile ) )
  end /* do while lines( srcFile ) <> 0 & ... */

  if right( cLine,2 ) = global.__c2 then
    RETURN cLine
  else
    RETURN ''

/* ------------------------------------------------------------------ */
/*-function: delete a file if it exists                               */
/*                                                                    */
/*-call:     DeleteFile FileName                                      */
/*                                                                    */
/*-where:    fileName - name of the file to delete                    */
/*                                                                    */
/*-returns:  1 - file deleted or file does not exist                  */
/*           0 - error deleting the file                              */
/*               rc = OS error code                                   */
/*                                                                    */
DeleteFile: PROCEDURE expose ( exposeList ) rc
  parse arg fn

  thisRC = 1
  fn = strip( fn )

  if fn <> '' then
  do
                    /* close the file if open                         */
    if right( stream( fn ),5 ) = 'READY' then
      call stream fn, 'c', 'CLOSE'

    if stream( fn, 'c', 'QUERY EXIST' ) <> '' then
    do
      rc = 0
      if progOption.__TFound = 1 then
        '@attrib -r ' ConvertNameToOS( fn ) prog.__LogAll
      if rc = 0 then
         '@del ' ConvertNameToOS( fn ) prog.__LogAll

      thisRC = ( rc = 0 )
    end /* if stream( fn, 'c', ... */
  end /* if fn <> '' then */

RETURN thisRC

/* ------------------------------------------------------------------ */
/*-functions: swap byte 1 and 2 of a two-byte string                  */
/*                                                                    */
/*-call:      swapWord swapstring                                     */
/*                                                                    */
/*-where:     swapString - string to swap                             */
/*                                                                    */
/* returns:   a string with the bytes swaped                          */
/*                                                                    */
swapWord:
RETURN translate( '21', arg(1), '12' )

/* ------------------------------------------------------------------ */
/*-function: swap word 1 and 2 of a two-word string                   */
/*           ( incl. swapping the bytes )                             */
/*                                                                    */
/*-call:     swapDword swapstring                                     */
/*                                                                    */
/*-where:    swapstring the string to swap                            */
/*                                                                    */
/*-returns:  a string with the words swaped                           */
/*                                                                    */
swapDWord:
RETURN translate( '4321', arg(1), '1234' )

/* ------------------------------------------------------------------ */
/*-function: change the EAs of the new file                           */
/*                                                                    */
/*-call:     ChangesEAs                                               */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/* IMPORTANT NOTE:                                                    */
/* You can NOT use the SysGetEA and SysSetEA functions to make this   */
/* work!                                                              */
/*                                                                    */
ChangeEAs:

                    /* get the file size of the targetfile            */
  global.__TargetFileSize = stream( global.__TargetFile, 'c', 'QUERY SIZE' )

                    /* get the file date for last changes             */
                    /* of the targetfile                              */
  CEA.filedate = stream( global.__TargetFile, 'c', 'QUERY DATETIME' )
  parse var CEA.FileDate global.__TargetFileLastChangesDate global.__TargetFileLastChangesTime

                    /* get the compilation date for the               */
                    /* targetfile - it's just now :-)                 */
  global.__TargetFileCompilationDate = date( 'U' )
  global.__TargetFileCompilationTime = time( 'N' )

                    /* convert the values in the format               */
                    /* for the EAs                                    */
  global.__TargetFileSize = swapDWord( RIGHT( D2C( global.__TargetFileSize ), 4, '0'x ) )

  global.__TargetFileLastChangesDate = swapWord( RIGHT( D2C( OSDateToFileDate( strip( global.__TargetFileLastChangesDate, 'B' ), 'A' ) ), 2, '0'x ) )
  global.__TargetFileLastChangesTime = swapWord( RIGHT( D2C( OSTimeToFileTime( strip( global.__TargetFileLastChangesTime, 'B' )      ) ), 2, '0'x ) )

     global.__TargetFileCreationDate = swapWord( RIGHT( D2C( OSDateToFileDate( strip( global.__TargetFileCreationDate,    'B' ), 'A' ) ), 2, '0'x ) )
     global.__TargetFileCreationTime = swapWord( RIGHT( D2C( OSTimeToFileTime( strip( global.__TargetFileCreationTime,    'B' )      ) ), 2, '0'x ) )

  global.__TargetFileCompilationDate = swapWord( RIGHT( D2C( OSDateToFileDate( strip( global.__TargetFileCompilationDate, 'B' ), 'A' ) ), 2, '0'x ) )
  global.__TargetFileCompilationTime = swapWord( RIGHT( D2C( OSTimeToFileTime( strip( global.__TargetFileCompilationTime, 'B' )      ) ), 2, '0'x ) )

                    /* read the file with the EAs                     */
  global.__TargetEALength = chars( global.__TempFile )
  if global.__TargetEALength = 0 then
    call ShowError 51 ,,
                   'You must first execute the sourcefile "' || ,
                   global.__SourceFile || '" before compiling it'

  global.__TargetEAs = charIn( global.__TempFile, 1, global.__TargetEALength )

                    /* close the temporary file with the EAs!         */
  call lineOut global.__TempFile

/*
  global.__TargetEASearchString = '00'x || 'OS/2     REXXSAA '
  global.__TargetEASearchStringLength = 18 /* length( global.__TargetEASearchString ) */
*/

  global.__TargetEABase = pos( '00'x || 'OS/2     REXXSAA ' , global.__TargetEAs )

  if global.__TargetEABase = 0 then
    call ShowError 52 ,,
                   'You must first execute the sourcefile "' || global.__SourceFile || '" before compiling it'

  if progOption.__IVer = 0 then
  do
    testVersion = substr( global.__TargetEAs, global.__TargetEABase+18, 4 )

    if testVersion <> '4.00'  then
      call ShowError 56 ,,
                     'Unknown token image version (' || ,
                     testVersion || ')'

  end /* if progOption.__IVer = 0 */

  if substr( global.__TargetEAs, global.__TargetEABase-3,3 ) <> '60'x || 'EA'x || '0C'x then
    call ShowError 55 ,,
                   'Unknown format of the token image'

  global.__TargetEABase = global.__TargetEABase -1 -3

                    /* Offsets in the EAs for various                 */
                    /* fields (This are decimal values                */
                    /* the first byte in the EA has an                */
                    /* offset of 1)                                   */
                    /* All values except the last are                 */
                    /* WORD PTR!                                      */
  EAStruc.FileCreationDateOffset = 45 + global.__TargetEABase
  EAStruc.FileCreationTimeOffset = 47 + global.__TargetEABase

  EAStruc.FileCompilationDateOffset = 49 + global.__TargetEABase
  EAStruc.FileCompilationTimeOffset = 51 + global.__TargetEABase

  EAStruc.FileChangingDateOffset = 53 + global.__TargetEABase
  EAStruc.FileChangingTimeOffset = 55 + global.__TargetEABase

                    /* THIS IS A DWORD PTR                            */
  EAStruc.FileLengthOffset = 57 + global.__TargetEABase

                    /* get the date and time of the                   */
                    /* sourcefile                                     */
  dateTimeString = stream( global.__SourceFile, 'c', 'QUERY DATETIME' )
  parse var DateTimeString real.SourceFileChangingDateS real.SourceFileChangingTimeS
  drop dateTimeString

  real.SourceFileChangingDateS = strip( real.SourceFileChangingDateS, 'B' )
  real.SourceFileChangingTimeS = strip( real.SourceFileChangingTimeS, 'B' )

  real.SourceFileChangingDate = OSDateToFileDate( real.SourceFileChangingDateS  'A' )
  real.SourceFileChangingTime = OSTimeToFileTime( real.SourceFileChangingTimeS  )

/*
  real.SourceFileChangingDate = swapWord( RIGHT( D2C( real.SourceFileChangingDateS ), 2, '0'x ) )
  real.SourceFileChangingTime = swapWord( RIGHT( D2C( real.SourceFileChangingTimeS ), 2, '0'x ) )
*/

                    /* check the EAs                                  */
     old.SourceFileCreationDate = C2D( swapWord( substr( global.__TargetEAs, EAStruc.FileCreationDateoffset,    2 ) ) )
     old.SourceFileCreationTime = C2D( swapWord( substr( global.__TargetEAs, EAStruc.FileCreationTimeoffset,    2 ) ) )

  old.SourceFileCompilationDate = C2D( swapWord( substr( global.__TargetEAs, EAStruc.FileCompilationDateoffset, 2 ) ) )
  old.SourceFileCompilationTime = C2D( swapWord( substr( global.__TargetEAs, EAStruc.FileCompilationTimeoffset, 2 ) ) )

     old.SourceFileChangingDate = C2D( swapWord( substr( global.__TargetEAs, EAStruc.FileChangingDateoffset,    2 ) ) )
     old.SourceFileChangingTime = C2D( swapWord( substr( global.__TargetEAs, EAStruc.FileChangingTimeoffset,    2 ) ) )

       old.SourceFileCreationDateS = FileDateToOSDate( old.SourceFileCreationDate    '-' 'A' )
       old.SourceFileCreationTimeS = FileTimeToOSTime( old.SourceFileCreationTime    ':' )

    old.SourceFileCompilationDateS = FileDateToOSDate( old.SourceFileCompilationDate '-' 'A' )
    old.SourceFileCompilationTimeS = FileTimeToOSTime( old.SourceFileCompilationTime ':' )

       old.SourceFileChangingDateS = FileDateToOSDate( old.SourceFileChangingDate    '-' 'A' )
       old.SourceFileChangingTimes = FileTimeToOSTime( old.SourceFileChangingTime    ':' )

  if progOption.__ShowDate = 1 then
  do
    call log ' Sourcefile time stamps:'
    call log '  File execution time stamp is: ' || ,
             AddColor1( , old.SourceFilecompilationDateS old.SourceFilecompilationTimeS )
    call log '  File changing time stamp is:  ' || ,
             AddColor1( , real.SourceFileChangingDateS   real.SourceFileChangingTimeS )
  end /* if progOption.__ShowDate = 1 then */

                    /* check if the file was changed after the        */
                    /* execution                                      */
                    /* Note: The creation date for files on FAT       */
                    /*       partitions is 0!                         */
  if ( real.SourceFileChangingDate > old.SourceFileCompilationDate ) | ,
     ( ( real.SourceFileChangingDate = old.SourceFileCompilationDate ) & ,
       ( real.SourceFileChangingTime > old.SourceFileCompilationTime ) ) then
  do
    if progOption.__IDate = 0 then
    do
      if ( old.SourceFileCreationDate = 0 ) then
        call log '  Warning: No time stamp checking possible for files on or from FAT partitions!'
      else
        call ShowError 53 ,,
                       'You must reExecute the sourcefile after every change before you can compile it'
    end /* if progOption.__Idate = 0 then */
    else
      if ( old.SourceFileCreationDate <> 0 ) then
        call log '  Warning: The token image of the sourcefile is out of date!'

  end /* if ( real.SourceFileChangingDate > ... */

                    /* manipulate the EAs                             */
  global.__TargetEAs = overlay( global.__targetFileSize,            global.__TargetEAs, EAStruc.FileLengthOffset )

  global.__TargetEAs = overlay( global.__targetFileCreationDate,    global.__TargetEAs, EAStruc.FileCreationDateOffset )
  global.__TargetEAs = overlay( global.__targetFileCreationTime,    global.__TargetEAs, EAStruc.FileCreationTimeOffset )

  global.__TargetEAs = overlay( global.__targetFileLastChangesDate, global.__TargetEAs, EAStruc.FileChangingDateOffset )
  global.__TargetEAs = overlay( global.__targetFileLastChangesTime, global.__TargetEAs, EAStruc.FileChangingTimeOffset )

  global.__TargetEAs = overlay( global.__targetFileCompilationDate, global.__TargetEAs, EAStruc.FileCompilationDateOffset )
  global.__TargetEAs = overlay( global.__targetFileCompilationTime, global.__TargetEAs, EAStruc.FileCompilationTimeOffset )

                    /* write the changed EAs                          */
  rc = charOut( global.__TempFile,  global.__TargetEAs, 1 )
  if rc <> 0 then
    call ShowError 54 ,,
                   'Internal error E1'

                    /* close the file with the new EAs                */
  rc = charOut( global.__TempFile )

  drop EAStruc. old. real.
RETURN

/* ------------------------------------------------------------------ */
/*-function: get unique name for a  temporary file                    */
/*                                                                    */
/*-call:     GetTempFile                                              */
/*                                                                    */
/*-returns:  name of the file                                         */
/*                                                                    */
/*-note:     If GetTempFile finds a name for a new temporary file,    */
/*           it opens this file to avoid using the file by another    */
/*           process!                                                 */
/*                                                                    */
GetTempFile: PROCEDURE expose ( exposeList )

  tPath = value( 'TEMP', , prog.__Env )
  if tPath = '' then
    tPath = value( 'TMP', , prog.__Env )
  if tPath = '' then
    tPath = directory()

  tName = ''
                    /* save the current drive and directory           */
  CurDir = directory()

                    /* get the drive with the directory for the       */
                    /* temporary files                                */
  CurTDrive = filespec( "D", tPath )

                    /* save the current directory of the drive        */
                    /* with the directory for temporary files!        */
  CurTDir = directory( curTDrive )

  if translate( directory( tPath ) ) = translate( tPath ) then
  do
                    /* restore the current directory of the drive     */
                    /* with the directory for temporary files!        */
    call directory CurTDir
                    /* restore the current drive and directory        */
    call directory CurDir

    tPath = strip( tPath, 'B', '"' )
    if right( tPath, 1 ) <> '\' then
      tPath = tPath || '\'

    do i=0 to 999
      tName = tPath || '$$' || right( '000' || i, 3 ) || '$$' || '.TMP'
      if stream( tName, 'C', 'QUERY EXIST' ) = '' then
      do
        call stream tName, 'C', 'OPEN'
        leave
      end
      else
        tName = ''
    end /* do i=1 to 999 ... */
  end /* if translate( directory( tPath ) ) = translate( tPath ) then */

RETURN tName

/* ------------------------------------------------------------------ */
/*-function: Search a file in the current directory and in the        */
/*           directorys saved in an environment variable (e.g. PATH)  */
/*                                                                    */
/*-call:     SearchFile( fileName, varName {,environment} )           */
/*                                                                    */
/*-where:    fileName - name of the file to search                    */
/*           varName - name of the environment variable containing    */
/*                     the directorys to search                       */
/*           environment - environment with the environment Variable  */
/*                                                                    */
/*-returns:  full name of the file or '' if not found                 */
/*                                                                    */
SearchFile: PROCEDURE expose ( exposeList )
  parse arg fn , envV, env
  rStr = ''

  if fn <> '' & envV <> '' then
  do
    if env = '' then
      env = prog.__env

    sDirs = '.;' || value( envV, , env )

    do forever
      parse var sDirs cSDir ';' sDirs

      cSDir = strip( cSDir )

      if cSDir = '' then
        iterate

      if right( cSDir, 1 ) <> '\' & ,
         right( cSDir, 1 ) <> ':' then
        cSDir = cSDir || '\'

      rStr = stream( cSDir || fn, 'c', 'QUERY EXIST' )
      if rStr <> '' | sDirs = '' then
        leave

    end /* do forever */
  end /* if fn <> '' & ... */

RETURN rStr

/* ------------------------------------------------------------------ */
/* function: read, compress and write a REXX program                  */
/*                                                                    */
/* call:     CompressRexxProgram f1 , f2                              */
/*                                                                    */
/* where:    f1 - REXX program                                        */
/*           f2 - name of the file for the output                     */
/*                                                                    */
/* returns:  0 - ok                                                   */
/*           else  error                                              */
/*                                                                    */
CompressRexxProgram: PROCEDURE expose (exposeList) lines.
  parse arg f1, f2

  thisRC = 1
                    /* CR/LF                                          */
  crlf = '0D0A'x
                    /* ANSI codes to restore the cursor               */
                    /* position and delete until the end of           */
                    /* the line                                       */
  global.__RestPos = screen.__RestPos || screen.__DelEOL

  call CharOut global.__PDev, '  Reading the file ' || AddColor1( '"', f1 ) || ' ... '

                    /* init the variable for the file contents        */
  inFile = ''
                    /* init the variable for the converted code       */
  outFile = ''

                    /* length of the source file                      */
  fiLength = 0

  if stream( f1, "c", "QUERY EXIST" ) <> "" then
  do
                    /* open the file in READ ONLY mode                */
    call stream f1, "c", "OPEN READ"

    fiLength = chars( f1 )
                    /* read the complete file using Charin()          */
    inFile = charIN( f1, 1, fiLength ) || crLf

                    /* close the file                                 */
    call stream f1, "c", "CLOSE"

  end /* if stream( ... */

  if fiLength <> 0 then
  do
    call LineOut global.__PDev, AddColor1( , fiLength ) || ' bytes read.'

                    /* delete comments                                */
    call DeleteComments

/* not neccessary /bs
                    /* check for ASCII codes 01, 02 and 03            */
    if verify( inFile, '010203'x, 'M' ) <> 0 then
      call ShowError 64 ,,
             'Use the format "nn"x for ASCII codes 01, 02 and 03 in the source file'
*/

                    /* replace string constants with placeholder      */
    if progOption.__CMode = 0 then
      call ReplaceStrings

    call CharOut global.__PDev , '  Compressing the file ... Offset ' || screen.__SavePos

    i1 = 1
                    /* compress the file                              */
    do forever
      call CharOut global.__PDev, global.__RestPos || i1

      i2 = pos( crlf, inFile, i1 )
      if i2 = 0 then
        leave
                    /* get the next line                              */
      cLine = substr( inFile, i1, i2-i1 )

                    /* correct the pointer for the start of the       */
                    /* next line                                      */
      i1 = i2+2

                    /* translate tabulator to blanks and              */
                    /* compress blanks                                */
      if progOption.__CMode = 0 then
        cLine = space( strip( translate( cLine, ' ', '09'x ) ) )
      else
        cLine = strip( cLine )

      if cLine = '' & global.__InsertEmptyLine = 0 then
        iterate

      global.__InsertEmptyLine = 0

      lastChar = right( cLine,1 )

      select

        when lastChar = global.__sCmtMarker then
          outFile = outFile || dbrright( cLine,1 ) || crLF

        when lastChar = ',' then
        do
          outFile = outFile || dbrright( cline, 1) || ' '
          global.__InsertEmptyLine = 1
        end /* when */

        otherwise
          outFile = outFile || cLine || ';'

      end /* select */

    end /* do forever */

    call LineOut global.__PDev , screen.__RestPos || copies( '08'x, 7 ) || ' done.'  || screen.__DelEOL

                    /* insert string constants again                  */
    if progOption.__cMode = 0 then
      call InsertStrings

    call CharOut global.__PDev , '  Writing the output file ... '

                    /* write the compressed file                      */
    call CharOut f2, outFile || crLF || global.__CopyrightMessage

                    /* close the target file                          */
    call stream f2, 'c', 'CLOSE'

                    /* get the length of the target file              */
    foLength = chars( f2 )

                    /* done message                                   */
    call LineOut global.__PDev, AddColor1( , foLength ) || ' bytes written (' ||,
                                AddColor1( , foLength * 100 % fiLength ) || '%).'
    thisRC = 0

  end /* if readFile( f1 ) = 0 then */

RETURN thisRC

/* ------------------------------------------------------------------ */
/* function: delete comments                                          */
/*                                                                    */
/* call:     DeleteComments                                           */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  -                                                        */
/*                                                                    */
/* input:    inFile = file contents                                   */
/*                                                                    */
/* output:   inFile = converted file contents                         */
/*                                                                    */
DeleteComments: PROCEDURE expose (exposeList) inFile

  call CharOut global.__PDev,,
        '  Deleting comments ... Offset ' || screen.__SavePos

                    /* get the start of the first comment             */
  i1 = pos( global.__c1 , inFile )

  do while i1 <> 0

    call CharOut global.__PDev, screen.__RestPos || i1

    global.__iCRLF = 0

                    /* save the position of the comment start         */
                    /* delimiter                                      */
    i5 = i1

    do forever
                    /* search the end of the comment                  */

                    /* init the variable for the current nest         */
                    /* level                                          */
      global.__nestLevel = 1

      i2 = FindCommentEnd( i1 )
      if i2 = 0 then
        leave       /* unmatched comments in the source file!         */

      call CharOut global.__PDev , global.__RestPos || i2

                    /* check for sequential comment lines             */
      if substr( inFile, i2+2, 4 ) <> '0D0A'x || global.__c1 then
        leave

                    /* handle sequential comment lines as one comment */
      i1 = i2 +4
                    /* set a marker to insert an CR/LF for the        */
                    /* comment                                        */
      global.__iCRLF = 1
    end /* do forever */

                    /* check for unmatched comments                   */
    cio = global.__c1
    if i2 = 0 then
      leave
    cio = ''        /* <> '' if unmatched comment delimiter found     */

                    /* get the comment                                */
    cCmt = substr( inFile, i5, i2-i5+2 )

                    /* OVERLAY with blanks is SLOWER                  */
    inFile = delStr( inFile, i5, i2-i5+2 )

                    /* insert a marker for /*!*/ comments             */
    if cCmt = global.__sCmt then
      inFile = insert( global.__sCmtMarker, inFile,i5-1 )

    if global.__iCRLF  then
      inFile = insert( '0D0A'x, inFile,i5-1 )

    i1 = pos( global.__c1 , inFile, i5 )

  end /* do forever */

  call LineOut global.__PDev,,
        screen.__RestPos || copies( '08'x, 7 ) || ' done.' screen.__DelEOL

  if cio = '' & pos( global.__c2, inFile ) <> 0 then
    cio = global.__c2

  if cio <> '' then
    call ShowWarning 'Unmatched comment delimiter "' || ,
                      cio || '" in the sourcefile'

RETURN

/* ------------------------------------------------------------------ */
/* function: find the end of a comment                                */
/*                                                                    */
/* call:     FindCommentEnd commentStart                              */
/*                                                                    */
/* where:    commentStart - offset of the start of the comment        */
/*                                                                    */
/* returns:  0 - error                                                */
/*           else  offset of the end of the comment                   */
/*                                                                    */
/*                                                                    */
FindCommentEnd: PROCEDURE expose (exposeList) infile
  parse arg i1

                    /* check the nested comment level                 */
  global.__NestLevel = global.__NestLevel + 1
  if global.__NestLevel >= 40 then
    call ShowError 63,,
           'The comments in the source file nested to deep (max. is 40)'

  do until i2 < i3 | i3 = 0

                    /* i2 = end of comment                            */
    i2 = pos( global.__c2, inFile, i1+2 )

                    /* i3 = start of next or imbedded comment         */
    i3 = pos( global.__c1, inFile, i1+2 )

    if i3 < i2 & i3 <> 0 then
      i1 = FindCommentEnd( i3 )

    if i1 = 0 then
    do
      i2 = 0
      leave
    end /* if i1 = 0 then */

  end /* do until i2 > i3 | i3 = 0 */

RETURN i2

/* ------------------------------------------------------------------ */
/* function: replace string constants in the source file with place   */
/*           holder                                                   */
/*                                                                    */
/* call:     ReplaceStrings                                           */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  0 - ok                                                   */
/*           else  error                                              */
/*                                                                    */
/* input:    inFile = file contents                                   */
/*                                                                    */
/* output:   inFile = converted file contents                         */
/*                                                                    */
/*                                                                    */
ReplaceStrings: PROCEDURE expose (exposeList) inFile

                    /* init the stem for the string constants         */
  strs.0 = 0
  j = 1
  i0 = 1

  call charOut global.__PDev, '  Replacing string constants ... Offset ' || screen.__SavePos

  do forever
    cio = ''        /* <> '' if unmatched string delimiter found      */

                    /* take care of the two possible string constant  */
                    /* delimiters in REXX                             */
            /* DO NOT CHANGE THE SEQUENCE OF THE NEXT TO STATEMENTS!! */
    i2 = pos( "'" , inFile, i0 )
    i1 = pos( '"' , inFile, i0 )

    curStringChar = '"'

                    /* use the string delimiter at the first position */
    if ( i2 < i1 | i1 = 0 ) & i2 <> 0 then
    do
      i1 = i2
      curStringChar = "'"
    end /* else */

    if i1 = 0 then
      leave         /* no further string found                        */

                    /* 'in progress' message                          */
    call CharOut global.__PDev, global.__RestPos || i1

                    /* get the position of the string end delimiter   */
    i2 = pos( curStringChar, inFile, i1+1 )

    cio = curStringChar
    if i2 = 0 then
      leave         /* unmatched string delimiter found               */

                    /* get the length of the string                   */
    strLength = i2-i1+1

                    /* ignore empty strings                           */
    i0 = i2+1
    if strLength <> 2 then
    do
                    /* save the string constant in the stem for the   */
                    /* string constants                               */
      strs.j = substr( inFile, i1, strLength )

                    /* check if we must replace this string with a    */
                    /* placeholder                                    */
      if verify( strs.j, ' ' || '01020309'x , 'M', ) <> 0 then
      do

                    /* delete the string constant                     */
        inFile = delStr( inFile, i1, strLength )

                    /* and insert a marker                            */
        inFile = insert( global.__sM1 || j || global.__sM2 ,inFile, i1-1,)

                    /* increase the index for the next string in the  */
                    /* stem for the string constants                  */
        j = j+1

        i0 = i1
      end
    end /* if */
  end /* do forever */

                    /* save the number of strings                     */
  strs.0 = j-1
                    /* done.                                          */
  call LineOut global.__PDev, Screen.__RestPos || copies( '08'x, 7 ) || ' done.'  || screen.__DelEOL

  if cio <> '' then
    call ShowWarning 'Unmatched string delimiter <' || ,
                     cio || '> in the sourcefile'
RETURN

/* ------------------------------------------------------------------ */
/* function: insert string constants back into the source file        */
/*                                                                    */
/* call:     InsertStrings                                            */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* input:    outFile = file contents                                  */
/*                                                                    */
/* output:   outFile = converted file contents                        */
/*                                                                    */
InsertStrings: PROCEDURE expose (exposeList) outFile

  call charOut global.__PDev, '  Inserting string constants again ... Offset ' || screen.__SavePos

  j = 0
  i1 = 1
  do forever

    i1 = pos( global.__sM1, outFile, i1 )
    i2 = pos( global.__sM2, outFile, i1+1 )
    if i1 = 0 | i2 = 0 then
      leave

                    /* 'in progress' message                          */
    call CharOut global.__PDev, global.__RestPos || i1

                    /* get the index for the stem entry               */
    j = substr( outFile,i1+1,i2-i1-1 )

                    /* delete the place holder                        */
    outFile = delStr( outFile,i1,i2-i1+1 )

                    /* insert the string                              */
    outFile = insert( strs.j,outFile,i1-1 )

    i1 = i1+length( strs.j )

  end /* do forever */

                    /* done.                                          */
  call LineOut global.__PDev, Screen.__RestPos || copies( '08'x, 7 ) || ' done.' || screen.__DelEOL

RETURN

/* ------------------------------------------------------------------ */
/* function: Calculate a simple CRC of a string                       */
/*                                                                    */
/* call:     thisCRC = GetCRC( string )                               */
/*                                                                    */
/* where:    string = the string to use                               */
/*                                                                    */
/* returns:  the CRC value                                            */
/*                                                                    */
/*                                                                    */
GetCRC: PROCEDURE expose (exposeList)
  parse arg tStr
  CRC = 0
  do i = 1 to length( tStr )
    cC = substr( tStr,i,1 )
    if ( cC < '0' | cC > '9' ) then
      CRC = crc + C2D( cC )
  end /* do i = 1 to length( tStr ) */
RETURN CRC

/* ------------------------------------------------------------------ */
/* function: split a string into separate arguments                   */
/*                                                                    */
/* call:     call SplitParameter Parameter_string, addInfo            */
/*                                                                    */
/* where:    parameter_string - string to split                       */
/*           addInfo - additional information                         */
/*                                                                    */
/* returns:  the number of parameters (arguments and options)         */
/*           The arguments are returned in the stems option. and      */
/*           argv.:                                                   */
/*                                                                    */
/*             argv.0 = number of arguments                           */
/*             argv.n = argument n                                    */
/*             argv.n.__msg = message                                 */
/*                                                                    */
/*             option.0 = number of options                           */
/*             option.n.__keyword = option keyword n                  */
/*             option.n.__keyValue = option keyValue n                */
/*             option.n.__msg = message                               */
/*                                                                    */
/*           Options are all parameter beginning with '/' or '-'.     */
/*                                                                    */
/* note:     This routine handles arguments in quotes and double      */
/*           quotes also. You can use either the format               */
/*                                                                    */
/*             keyword:'k e y v a l u e'                              */
/*                                                                    */
/*           or                                                       */
/*                                                                    */
/*             'keyword:k e y v a l u e'                              */
/*                                                                    */
/*           (':' is the separator in this example).                  */
/*                                                                    */
/*           argv.0 and option.0 must be initialized before calling   */
/*           this routine!                                            */
/*                                                                    */
SplitParameter: PROCEDURE EXPOSE (exposeList) argv. option.

                    /* get the parameter                              */
  parse upper arg tArgs, aInfo

                    /* nothing to do?                                 */
  if tArgs = '' then
    RETURN 0


  do while tArgs <> ''

    parse value strip( tArgs, "B" ) with tc1 +1 1 cArg tArgs

    if tc1 = '"' | tc1 = "'" then
      parse value cArg tArgs with (tc1) cArg (tc1) tArgs
    else
      cArg = strip( cArg )

    if ( tc1 <> '-' & tc1 <> '/' ) then
    do
                    /* normal argument                                */
      i = argv.0+1
      argv.i = cArg
      argv.0 = i

      argv.i.__addInfo = aInfo
    end /* if */
    else
    do
                    /* option                                         */
      i = option.0+1
      option.i.__addInfo = aInfo
      option.i.__CurArg = cArg
      option.0 = i
                    /* split the parameter into keyword and keyvalue  */
      parse var cArg dummy +1 option.i.__keyword '=' option.i.__keyvalue

      parse var option.i.__keyValue tc2 +1 .
      if tc2 = '"' | tc2 = "'" then
        parse value option.i.__keyValue tArgs with (tc2) option.i.__keyValue (tc2) tArgs

      if tc1 <> '"' & tc1 <> "'" & tc2 <> '"' & tc2 <> "'" then
      do
        option.i.__keyword  = strip( option.i.__keyword  )
        option.i.__keyValue = strip( option.i.__keyValue )
      end /* if */
    end /* else */
  end /* do while tArgs <> '' */

RETURN argv.0 + option.0

/* ------------------------------------------------------------------ */
/* function: Check if the program is in the macrospace                */
/*                                                                    */
/* call:     InMacroSpace                                             */
/*                                                                    */
/* returns:  1 - yes                                                  */
/*           0 - no                                                   */
/*                                                                    */
InMacroSpace: PROCEDURE expose (exposeList)
  SIGNAL ON SYNTAX NAME NIMC

  d = sourceLine( 1 )
RETURN 0

NIMC:
                        /* program seems to be in the macro space     */
                        /* do a second check to be sure               */
  parse source . . tf
  if fileSpec( "D", tf ) <> '' then
    RETURN 0            /* Oops, we are not in the macro space        */

RETURN 1

/* ------------------------------------------------------------------ */
/*            THIS MUST BE THE LAST ROUTINE IN THE PROGRAM!!!         */

/* ------------------------------------------------------------------ */
/*-function: error handler for unexpected errors                      */
/*                                                                    */
/*-call:     DO NOT CALL THIS ROUTINE BY HAND!!!                      */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*-Note:     THIS FUNCTION ABORTS THE PROGRAM WITH A JUMP TO THE      */
/*           LABEL I!.__PROGRAMEND!!!                                 */
/*                                                                    */
I!.__ErrorAbort:
                    /* check if the error occured in the error        */
                    /* handler                                        */
  if I!.__ErrorL = sigl then
  do
    call beep 637,300; call beep 437,300; call beep 637,300

    call charout 'STDERR:',,
                                                            '0D0A'x  ,
       'Fatal Error: Error in the error handler detected!'  '0D0A'x  ,
                                                            '0D0A'x  ,
       'Linenumber:       ' || sigl ||                      '0D0A'x  ,
       'Errorname:        ' || condition('C')               '0D0A'x  ,
       'Errordescription: ' || condition('D')               '0D0A'x  ,
                                                            '0D0A'x
    exit 255

  end /* if I!.__ErrorL = sigl then */

                    /* get the number of the line causing the error   */
  I!.__ErrorL = sigl

                    /* get the name of this error                     */
  I!.__ErrorN = condition('C')

                    /* get further information for this error         */
                    /* if available                                   */
  I!.__ErrorC = condition('D')
  if I!.__ErrorC <> '' then
    I!.__ErrorC = ' (Desc.: "' || I!.__ErrorC || '")'

  if datatype( prog.__ScreenCols, 'W' ) <> 1 then
    prog.__ScreenCols = 80

  i!.__pName = prog.__Name
  if SYMBOL( 'prog.__Name' ) <> 'VAR' | value( 'prog.__Name' ) = '' then
    if I!.__ErrorL < I!.__FirstUserCodeLine then
      I!.__pName = '**Runtime**'
    else
      I!.__pName = '***???***'

                    /* reInstall the error handler                    */
  INTERPRET  'SIGNAL ON ' value(condition('C')) ' NAME I!.__ErrorAbort'

                    /* check, if we should ignore the error           */
  if value( 'sigl' ) = value( 'I!.__InterpretCMDLine' ) then
    SIGNAL I!.__CallUserProc2

  screen.__CurColor = screen.__ErrorColor

  I!.__QM = prog.__QMode
                    /* turn quiet mode off                            */
  prog.__QMode = ''

  call I!.__LogSeparator1
  call ShowString ' ' || I!.__pName || ' - ', I!.__ErrorN || ,
                  I!.__ErrorC || ' error detected!'

                    /* check, if the RC is meaningfull for this       */
                    /* error                                          */
  if pos( I!.__ErrorN, 'ERROR FAILURE SYNTAX' ) <> 0 then
  do
    if datatype(rc, "W") = 1 then
      if I!.__ErrorN = 'SYNTAX' then
         if rc > 0 & rc < 100 then
            call Log left( ' The error code is ' || rc || ,
                           ', the REXX error message is: ' || ,
                           errorText( rc ), ,
                           prog.__ScreenCols )
         else
           call log left( ' The error code is ' || rc || ,
                          ', this error code is unknown.' ,,
                          prog.__ScreenCols )
      else
          call Log left( ' The RC is ' || rc || '.', prog.__ScreenCols )
  end /* if pos( ... */

  call ShowString 1, 'The error occured in line ' ||,
                     I!.__ErrorL || '.'

  call Log left( ' The sourcecode for this line is not available' ,,
                  prog.__ScreenCols )

  call I!.__LogSeparator
  call Log ''

  prog.__ExitCode = global.__ErrorExitCode

  if progOption.__Sound = 1 then
  do
    call beep 137,300;  call beep 337,300;  call beep 137,300
  end /* if */

                    /* restore quiet mode status                      */
  prog.__QMode = I!.__QM

SIGNAL I!.__programEnd

/* ------------------------------------------------------------------ */


/* ------------------------------------------------------------------ */
/* REXXCC.CMD - a tiny REXX "compiler" (c) Bernd Schemmer 1994,1997   */
/*                                                                    */
/* Usage: REXXCC source TO target {WITH copyrightfile}                */
/*               {/IExt} {/IDate} {/IVer} {/Overwrite}                */
/*               {/UseSource} {/LineCount=n} {/Compress}              */
/*               {/AddCode} {/CMode} {/ShowDate} {/NoDate}            */
/*               {/LOG=logfilename} {/Sound} {/NoColors} {/?} {/HELP} */
/*                                                                    */
/* Author                                                             */
/*   Bernd Schemmer                                                   */
/*   Baeckerweg 48                                                    */
/*   60316 Frankfurt                                                  */
/*   Germany                                                          */
/*   CompuServe: 100104,613                                           */
/*   Internet: 100104.613@compuserve.com                              */
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
/*   "compressing" (you can also call it  "packing")                  */
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
/* IMPORTANT: YOU MUSTN'T DISTRIBUTE A CHANGED VERSION OF REXXCC!     */
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
/* This version of REXXCC is Freeware. You can use and share it as    */
/* long as you neither delete nor change any file or program in the   */
/* archiv!                                                            */
/* IT IS VERY IMPORTANT THAT YOU SHARE THIS PROGRAM ONLY WITH IT'S    */
/* EXTENDED ATTRIBUTES (EAs) - BECAUSE WITHOUT THEM IT WILL NOT RUN!  */
/*                                                                    */
/* IMPORTANT !!! IMPORTANT !!! IMPORTANT !!! IMPORTANT !!! IMPORTANT  */
/*  ===============================================================   */
/*    TO DISTRIBUTE REXXCC ON MEDIUMS NOT SUPPORTING EXTENDED         */
/*    ATTRIBUTES LIKE CD-ROMs, BBS or CompuServe YOU MUST USE         */
/*    THE ARCHIVE FILE RCnnn.EXE!!!                                   */
/*  ===============================================================   */
/* IMPORTANT !!! IMPORTANT !!! IMPORTANT !!! IMPORTANT !!! IMPORTANT  */
/*                                                                    */
/* If you find REXXCC useful, your gift in any amount would be        */
/* appreciated.                                                       */
/*                                                                    */
/* Please direct your inquiries, complaints, suggestions, bug lists   */
/* etc. to the address noted above.                                   */
/*                                                                    */
/* If you like and use REXXCC it would be nice if you send me a       */
/* postcard.                                                          */
/*                                                                    */
/* ------------------------------------------------------------------ */
/* Terms for distributing REXXCC                                      */
/* for vendors, sysops and others 'for-profit' distributors           */
/* ========================================================           */
/*                                                                    */
/* I encourage all shareware vendors, BBS sysops and other            */
/* 'for-profit' distributors to copy and distribute this version      */
/* of REXXCC subject to the following restrictions:                   */
/*                                                                    */
/*  The REXXCC freeware package - including all related program files */
/*  and documentation files - cannot be modified in any way (other    */
/*  than that mentioned below) and must be distributed as a complete  */
/*  package, without exception.                                       */
/*                                                                    */
/*  Small additions to the package, such as the introductory or       */
/*  installation batch files used by many shareware disk vendors, are */
/*  acceptable.                                                       */
/*                                                                    */
/*  You may charge a distribution fee for the package, but you must   */
/*  not represent in any way that you are selling the software itself.*/
/*                                                                    */
/*  The disk-based documentation may not be distributed in printed    */
/*  form without the prior written permission of the author.          */
/*                                                                    */
/*  You shall not use, copy, rent, lease, sell, modify, decompile,    */
/*  disassemble, otherwise reverse engineer, or transfer this         */
/*  program except as provided in this agreement. Any such unautho-   */
/*  rized use shall result in immediate and automatic termination of  */
/*  the permission to distribute this program.                        */
/*                                                                    */
/*  I reserve the right to withdraw permission from any vendor to     */
/*  distribute my products at any time and for any reason.            */
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
/* -- Copyright 1994,1997 by Bernd Schemmer. All rights reserved. --  */
/*                                                                    */
/* The files RXDLG.DLL, RX.EXE and RX.INF are                         */
/* -- Copyright 1995 by Jeff Glatt.  --                               */
/* Please see the file RX.INF for the using and redistribution policy */
/* for these files.                                                   */
/*                                                                    */
/*                                                                    */
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
/* Baeckerweg 48, D-60316 Frankfurt, Germany, CompuServe: 100104,613  */
/*                                                                    */
/**********************************************************************/

  say "Error: Either you are using an unknown REXX Interpreter version or";say "       this program lost it's extended attributes!" "07"x ;exit 255  
/* created on 12/06/97 at 18:31:05 with REXXCC V3.21  (c) Bernd Schemmer 1997 */ 

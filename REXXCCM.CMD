/* ------------------------------------------------------------------ */
/* REXXCCM.CMD - REXX program to create a token image of a REXX       */
/*               program using the macro space                        */
/*                                                                    */
/* (c) 1997 Bernd Schemmer                                            */
/*                                                                    */
/* Author:                                                            */
/*   Bernd Schemmer                                                   */
/*   Baeckerweg 48                                                    */
/*   D-60316 Frankfurt                                                */
/*   Germany                                                          */
/*   CompuServe: 100104,613                                           */
/*                                                                    */
/* Initial Release:                                                   */
/*   09.09.1997 /bs                                                   */
/* Last Update:                                                       */
/*   10.09.1997 /bs                                                   */
/*                                                                    */
/* Usage:                                                             */
/*                                                                    */
/*  REXXCCM Source:sourceFile Target:targetDirectory                  */
/*          {/L:logfile} {/H} {/Silent} {/NoSound} {/NoAnsi}          */
/*          {/Trace}                                                  */
/*                                                                    */
/* Parameters:                                                        */
/*                                                                    */
/*   Source:sourceFile                                                */
/*     The name of the source file                                    */
/*     The name of the macro will be the name of the file without the */
/*     extension.                                                     */
/*     To change the name for the macro you can use the string        */
/*                                                                    */
/*         /* MACRONAME: myName */                                    */
/*     or                                                             */
/*         /* MACRONAME: "m y n a m e " */                            */
/*                                                                    */
/*     as first line of the file.                                     */
/*                                                                    */
/*     You can use this parameter as often as you like. All macros    */
/*     will be in the image. But REXXCCM only creates a loader for    */
/*     the first macro found in the parameters.                       */
/*                                                                    */
/*   Target:targetDirectory                                           */
/*     Name of the target directory; the directory must exist.        */
/*     The target directory can not be the directory with the         */
/*     source file.                                                   */
/*     Existing target file are always overwritten!                   */
/*     The name of the target image file is the name of the first     */
/*     source file with the extension ".IMC" for Classic REXX and     */
/*     ".IMO" for Object REXX.                                        */
/*     (depending on the current active REXX interpreter).            */
/*     The name of the loader is the name of the first source file    */
/*     with the extension ".CMD".                                     */
/*                                                                    */
/*                                                                    */
/*   /L:logFile - logfile is the name of the logfile :-)              */
/*                This parameter is case-sensitive!                   */
/*                def.: do not use a logfile                          */
/*                                                                    */
/*   /H         - show usage, you may also use                        */
/*                /h, /?, /HELP, -h, -H, -HELP or -?                  */
/*                (MAIN is not called!)                               */
/*                                                                    */
/*   /Silent    - suppress all messages (except error messages)       */
/*                You should also use the parameter /L:logfile if you */
/*                use this parameter!                                 */
/*                You may also set the environment variable SILENT to */
/*                "1" to suppress all messages.                       */
/*                                                                    */
/*   /NoSound   - suppress all sounds. You may also set the           */
/*                environment variable SOUND to "0" to suppress the   */
/*                sounds.                                             */
/*                                                                    */
/*   /NoAnsi    - do not use ANSI codes. You may also set the         */
/*                environment variable ANSI to "0" to suppress the    */
/*                use of ANSI codes.                                  */
/*                                                                    */
/*   /Trace     - turn TRACE on before calling MAIN. You may also     */
/*                set the environment variable RXTTRACE to ON to      */
/*                turn the TRACE mode for MAIN on.                    */
/*                                                                    */
/* Notes:                                                             */
/*                                                                    */
/*  REXXCCM and the programs created with REXXCCM need the new        */
/*  REXXUTIL.DLL from Object REXX.                                    */
/*  Note that you can use this DLL also in Classic REXX.              */
/*  To do this simply copy the Object REXX files REXXUTIL.DLL and     */ 
/*  REXXCRT.DLL to the directory \OS2\DLL.                            */
/*                                                                    */
/*  If you do not want to use the new REXXUTIL DLL as default DLL,    */
/*  copy the the new REXXUTIL DLL into the directory C:\OREXX and     */
/*  only the DLL REXXCRT.DLL into a directory in the LIBPATH.         */
/*  If you change the directory for the new REXXUTIL.DLL in this      */
/*  case, you must also change the variable 'global.__REXXUTILLDLL'   */
/*  below.                                                            */
/*                                                                    */
/*  REXXCCM always creates two files:                                 */
/*                                                                    */
/*    Either sourceFile.IMC or sourceFile.IMO                         */
/*                                                                    */
/*  and the loader to load the tokenized program called               */
/*                                                                    */
/*     sourceFile.CMD                                                 */
/*                                                                    */
/*  (where 'sourceFile' is the name of the first source file)         */
/*  Note that you can't execute the created image without the         */
/*  loader!                                                           */
/*                                                                    */
/*  REXXCCM always clears the complete macro space!                   */
/*                                                                    */
/*  To create REXX programs that run under Classic REXX and           */
/*  Object REXX you should run REXXCCM once under both REXX           */
/*  interpreters and distribute always both images.                   */
/*  Note that the loader always loads the correct image.              */
/*                                                                    */
/*                                                                    */
/* returncodes:                                                       */
/*      0 - execution okay                                            */
/*    240 ... 252                                                     */
/*          reserved for the runtime system                           */
/*    253 - syntax help called (parameter /h)                         */
/*    254 - user break (CTRL-C)                                       */
/*    255 - internal runtime system error                             */
/*   else - program specific errors                                   */
/*                                                                    */
/*                                                                    */
/*                                                                    */
/* Environment variables used while running the program               */
/*                                                                    */
/* þ ANSI                                                             */
/*   - Set the environment variable 'ANSI' to "0" or "OFF" if you     */
/*     don't want colors.                                             */
/*                                                                    */
/* þ PATCHDRIVE                                                       */
/*   - Set the environment variable 'PATCHDRIVE' to the drive with    */
/*     a patched version of your program (if any exist, see the       */
/*     routine 'I!.__CheckPatch' for the algorithm used ).            */
/*                                                                    */
/* þ SILENT                                                           */
/*   - Set the environment variable 'SILENT' to "1" or "ON" to        */
/*     suppress all messages.                                         */
/*                                                                    */
/* þ SOUND                                                            */
/*   - Set the environment variable 'SOUND' to "0" or "OFF" if you    */
/*     don't want sounds.                                             */
/*                                                                    */
/* þ RXTTRACE                                                         */
/*   - Set the environment variable 'RXTTRACE' to "MAIN" to turn the  */
/*     trace mode for the function MAIN on.                           */
/*                                                                    */
/* þ VERBOSE                                                          */
/*   - Set the environment variable 'VERBOSE' to any value not equal  */
/*     '' if you want debug information. If the value of the variable */
/*     is 'DEBUG', the error handler turns interactive trace on if an */
/*     error occured.                                                 */
/*     Note that the error handler also turns interactive trace on if */
/*     the environment variable RXTTRACE is set to 'MAIN' or if the   */
/*     parameter '/TRACE' is specified.                               */
/*                                                                    */
/* Distribution                                                       */
/*   This program is part of the REXXCC package. Please see the file  */
/*   REXXCC.CMD for my distribution policy.                           */
/*                                                                    */
/* Based on TEMPLATE.CMD v3.06, TEMPLATE is (c) 1996 Bernd Schemmer,  */
/* Baeckerweg 48, D-60316 Frankfurt, Germany, Compuserve: 100104,613  */
/* ------------------------------------------------------------------ */

  call trace 'off'      /* turn interactive trace off                 */
                        /* use this statement as the first statement  */
                        /* in your program, to ignore the value of    */
                        /* the environment variable RXTRACE.          */

                  global. = ''  /* init the stem global. with ''      */

/*** change the following values to your need                       ***/

                        /* additional parameter                 v3.06 */
                        /* (string for the usage routine)       v3.06 */
  global.__userUsage  = 'SOURCE:sourceFile TARGET:targetDirectory'

         global.__Version = 1.0          /* Version of YOUR program   */

       global.__SignOnMsg = 1   /* set to 0 if you do not want the    */
                                /* program start and end messages     */

                                /* name & path of the REXXUTIL.DLL if */
                                /* it is NOT the default REXXUTIL DLL */
     global.__REXXUTILDLL = 'C:\OREXX\REXXUTIL.DLL'

         global.__NeedCID = 1   /* set to 1 if you need CID support   */

      global.__NeedColors = 1   /* set to 1 if you want colored msgs  */

  global.__NeedPatchCheck = 1   /* set to 1 if you want the program   */
                                /* to search for a patched version of */
                                /* this program                       */

              /* set default values for EXPOSELIST if necessary       */
/*             exposeList = ''                                        */

              /* name of the routine for the message handling         */
              /* Note: Use '' for hardcoded messages                  */
/*          global.__GetMsg = 'GETMSG'                                */

             /* base number for the message numbers (def.: 1000)      */
/*          global.__BaseMsgNo = 1000                                 */

             /* note: set the variable prog.__STDOUT to "STDERR:"     */
             /*       or "NUL" if your program is a filter program!   */

  prog.__STDOUT = 'STDOUT'        /* necessary for Object REXX        */
  prog.__STDERR = 'STDOUT'        /* necessary for Object REXX        */
                                                                   /*!*/
/***                End of variables to change                      ***/
/*      HINT: The further program code is in the function MAIN        */

/***        End of Part 1 of the source code of TEMPLATE.CMD        ***/

/***       Start of Part 2 of the source code of TEMPLATE.CMD       ***/

/*************** DO NOT CHANGE THE FOLLOWING LINES ********************/

                        /* names of the global variables, which all   */
                        /* procedures must know                       */
  exposeList = 'prog. screen. I!. global. exposeList ' exposeList

                        /* check the type of the base message number  */
  if datatype( global.__BaseMsgNo, 'W' ) <> 1 then
    global.__BaseMsgNo = 1000

                        /* init internal variables                    */
  I!. = ''
                        /* save default STDOUT and STDERR             */
  if symbol( 'prog.__STDOUT' ) = 'VAR' then
    I!.__2 = prog.__STDOUT
  if symbol( 'prog.__STDERR' ) = 'VAR' then
    I!.__3 = prog.__STDERR

                        /* init the stems prog. & screen.             */
  parse value '' with prog. screen.

                        /* reset the timer                            */
  call time 'R'

                        /* restore default STDOUT and STDERR          */
  prog.__STDOUT = I!.__2;    prog.__STDERR = I!.__3

                        /* get the number of the first line with      */
                        /* user code                                  */
  call I!.__GetUserCode

/* ------------------------------------------------------------------ */
/* install the error handler                                          */

                        /* break errors (CTRL-C)                      */
  CALL ON HALT        NAME I!.__UserAbort
                        /* syntax errors                              */
  SIGNAL ON SYNTAX    NAME I!.__ErrorAbort
                        /* using of not initialisized variables       */
  SIGNAL ON NOVALUE   NAME I!.__ErrorAbort
                        /* failure condition                          */
  SIGNAL ON FAILURE   NAME I!.__ErrorAbort
                        /* error condition                            */
  SIGNAL ON ERROR     NAME I!.__ErrorAbort
                        /* disk not ready condition                   */
  SIGNAL ON NOTREADY  NAME I!.__ErrorAbort

/* ------------------------------------------------------------------ */
/* init the variables                                                 */

                        /* get & save the parameter                   */
  parse arg I!.__RealParam 1 prog.__Param

                        /* init the variables                         */

                        /* define exit code values                    */
  global.__ErrorExitCode = 255
     global.__OKExitCode = 0

                        /* init the compound variable prog.           */
  call I!.__InitProgStem

                        /* define the variables for CID programs      */
  call I!.__InitCIDVars

                        /* init the program exit code                 */
  prog.__ExitCode = global.__OKExitCode

                        /* check the parameter and env. variables     */
                        /* This must run before I!.__InitColorVars!   */
  call I!.__chkPandE

                        /* define the color variables                 */
  call I!.__InitColorVars

                        /* check if there is a logfile parameter      */
  call I!.__SetLogVars

/* ------------------------------------------------------------------ */
/* show program start message                                         */

  call I!.__SignMsg

/* ------------------------------------------------------------------ */
/* check if there is a patched version of this program                */

  call I!.__CheckPatch

/* ------------------------------------------------------------------ */

                        /* check for a help parameter                 */
  if pos( translate( word( prog.__Param,1 ) ), ,
          '/?/H/HELP/-?-H-HELP' ) <> 0 then
  do
    prog.__exitCode = 253

    call I!.__CallUserProc 1, 'ShowUsage'

    SIGNAL I!.__programEnd

  end /* pos( translate( ... */

/* ------------------------------------------------------------------ */

                        /* call the main procedure                    */
  call I!.__CallUserProc 2, 'main' strip( prog.__Param )

                        /* use the return code of 'main' as exitcode  */
                        /* if a returncode was returned               */
  if symbol( 'I!.__UserProcRC' ) == 'VAR' then
    prog.__ExitCode = I!.__UserProcRC

/* ------------------------------------------------------------------ */
/* house keeping                                                      */

I!.__ProgramEnd:

                                /* call the exit routines             */
  do while prog.__exitRoutines <> ''

                        /* delete the name of the routine from the    */
                        /* list to avoid endless loops!               */
    parse var prog.__ExitRoutines I!.__cer prog.__ExitRoutines

    call I!.__CallUserProc 1, I!.__cer

  end /* do while prog.__ExitRoutines <> '' */

                                /* restore the current directory      */
  if symbol( 'prog.__CurDir' ) == 'VAR' then
    call directory prog.__CurDir

                                /* show sign off message              */
  call I!.__SignMsg 'E'

EXIT prog.__ExitCode

/* ------------------------------------------------------------------ */
/* function: show the sign on or sign off message                     */
/*                                                                    */
/* call:     I!.__SignMsg which                                       */
/*                                                                    */
/* where:    which - 'E' - show the sign off message                  */
/*                         else show the sign on message              */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
I!.__SignMsg: PROCEDURE expose (exposeList)
  if global.__SignOnMsg <> 1 then
    RETURN

                        /* default: program start message             */
  i = 12

  if arg(1) = 'E' then
  do
    i = 13
                        /* program end message                        */
    i!.__rc1 = prog.__ExitCode

                                /* check if the exit code is decimal  */
                                /* and convert it to hexadecimal if   */
                                /* possible                           */
    if dataType( prog.__ExitCode, 'W' ) then
    do
      if prog.__ExitCode < 0 then
        prog.__ExitCode = 65536 + prog.__ExitCode
      i!.__rc2 = D2X( prog.__ExitCode )
    end /* if .. */

  end /* if arg(1) = 'E' then */

  screen.__CurColor = screen.__SignOnColor
  call Log I!.__GetMsg( i, prog.__Name, global.__Version, date(),,
                        time(), i!.__rc1, i!.__rc2 )
  screen.__CurColor = screen.__NormalColor
RETURN

/* ------------------------------------------------------------------ */
/* function: call a user defined routine                              */
/*           (avoid errors if the routine is not defined)             */
/*                                                                    */
/* call:     I!.__CallUserProc errorAction, procName {procParameter}  */
/*                                                                    */
/* where:    errorAction - action, if procName is not defined         */
/*                         0: do nothing (only set the RC)            */
/*                         1: show a warning and set the RC           */
/*                         2: abort the program                       */
/*           procName - name of the procedure                         */
/*           procParameter - parameter for the procedure              */
/*                                                                    */
/* returns:  1 - ok                                                   */
/*           0 - procname not found                                   */
/*                                                                    */
/* output:   I!.__UserProcRC - Returncode of the called procedure     */
/*                             (dropped if the proedure don't         */
/*                             return a value)                        */
/*                                                                    */
I!.__CallUserProc: PROCEDURE expose (exposeList) result rc sigl
  parse arg I!.__ErrorAction , I!.__ProcN I!.__ProcP

  I!.__thisRC = 0
  drop I!.__UserProcRC

  iLine = 'call ' I!.__ProcN
  if prog.__Trace = 1 & I!.__ProcN = 'main' then
    iLine = 'trace ?a;'|| iLine

/** DO NOT CHANGE, ADD OR DELETE ONE OF THE FOLLOWING SEVEN LINES!!! **/
  I!.__ICmdLine = GetLineNo()+2+(I!.__ProcP <> '')*2               /*!*/
  if I!.__ProcP = '' then                                          /*!*/
    interpret iLine                                                /*!*/
  else                                                             /*!*/
    interpret iLine "I!.__ProcP"                                   /*!*/
/** DO NOT CHANGE, ADD OR DELETE ONE OF THE PRECEEDING SEVEN LINES!! **/

/* Caution: The CALL statement changes the variable RESULT!           */
  I!.__0 = trace( 'off' )

  I!.__thisRC = 1
  if symbol( 'RESULT' ) == 'VAR' then
    I!.__UserProcRC = value( 'RESULT' )
    
                    /* this label is used if the interpret command    */
                    /* ends with an error                             */
I!.__CallUserProc2:

  if I!.__ThisRC = 0 then
  do
    if I!.__ErrorAction = 2 then
      call ShowError global.__ErrorExitCode , ,
                   I!.__GetMsg( 1, I!.__ProcN )

    if I!.__ErrorAction = 1 then
      call ShowWarning I!.__GetMsg( 1 , I!.__ProcN )
  end /* if I!.__thisRC = 0 then */

RETURN I!.__thisRC

/* ------------------------------------------------------------------ */
/* function: set the variables for the logfile handling               */
/*                                                                    */
/* call:     I!.__SetLogVars                                          */
/*                                                                    */
/* input:    prog.__Param - parameter for the program                 */
/*                                                                    */
/* output:   prog.__LogFile     - name of the logfile (or NUL)        */
/*           prog.__LogSTDERR   - string to direct STDERR into the    */
/*                                logfile                             */
/*           prog.__LogSTDOUT   - string to direct STDOUT into the    */
/*                                logfile                             */
/*           prog.__LogAll      - string to direct STDOUT and STDERR  */
/*                                into the logfile                    */
/*           prog.__LogFileParm - string to inherit the logfile       */
/*                                parameter to a child CMD            */
/*           prog.__Param       - program parameter without the       */
/*                                logfile parameter                   */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
I!.__SetLogVars: PROCEDURE expose (exposeList)

  parse var prog.__Param prog.__param '/L:' logFileName ' ' rest
  prog.__param = prog.__Param rest

                        /* avoid an error if the drive is not ready   */
  SIGNAL OFF NOTREADY

                        /* default log device is the NUL device       */
  prog.__LogFile = 'NUL'

  if logFileName <> '' then
  do
                        /* check if we can write to the logfile       */
    logStatus = stream( logFileName, 'c', 'OPEN WRITE')
    if logStatus <> 'READY:' then
    do
      prog.__LogFileParm = ''

      call ShowWarning I!.__GetMsg( 2, logFileName, logStatus )

    end /* if logStatus <> 'READY:' then */
    else
    do
                        /* close the logfile                          */
      call stream logFileName, 'c', 'CLOSE'

                        /* get the fully qualified name of the        */
                        /* logfile                                    */
                        /*                                      v3.04 */
      parse upper value stream( logFileName, 'c', 'QUERY EXIST' ) WITH prog.__LogFile

      prog.__LogFileParm = '/L:' || prog.__LogFile
    end /* else */
  end /* if prog.__LogFile <> '' then */

                        /* variable to direct STDOUT of an OS/2       */
                        /* program into the logfile                   */
  prog.__LogSTDOUT = ' 1>>' || prog.__LogFile

                        /* variable to direct STDERR of an OS/2       */
                        /* program into the logfile                   */
  prog.__LogSTDERR = ' 2>>' || prog.__LogFile

                        /* variable to direct STDOUT and STDERR of    */
                        /* an OS/2 program into the log file          */
  prog.__LogALL = prog.__LogSTDERR || ' 1>>&2'

RETURN

/* ------------------------------------------------------------------ */
/* function: check the parameter and the environment variables for    */
/*           the runtime system                                       */
/*                                                                    */
/* call:     I!.__chkPandE                                            */
/*                                                                    */
/* input:    prog.__Param - parameter for the program                 */
/*           prog.__env - name of the environment                     */
/*                                                                    */
/* output:   prog.__QuietMode - 1 if parameter '/Silent' found        */
/*                              or environment variable SILENT set    */
/*           prog.__NoSound   - 1 if parameter '/NoSound' found       */
/*                              or environment variable SOUND set     */
/*           screen.          - "" if parameter '/NoANSI' found       */
/*                              or environment variable ANSI set      */
/*           prog.__Param     - remaining parameter for the procedure */
/*                              MAIN.                                 */
/*           prog.__Trace     - 1 if parameter '/Trace' found         */
/*                              or if the environment variable        */
/*                              RXTTRACE is set to MAIN               */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
I!.__chkPandE: PROCEDURE expose (exposeList)

  global.__verbose = value( 'VERBOSE' ,, prog.__env )

  o!.0 = 4                              /* no. of known parameters    */
                                        /* and environment variables  */

  o!.1.parm = '/SILENT'                 /* parameter name             */
  o!.1.env  = 'SILENT'                  /* name of the env. var       */
  o!.1.vals = 'ON 1'                    /* possible values for the    */
                                        /* environment variable       */
  o!.1.stmt = 'prog.__QuietMode=1'      /* statement to execute       */
                                        /* if this parameter was      */
                                        /* entered or the environment */
                                        /* variable is set            */

  o!.2.parm = '/NOSOUND'                /* turn sound off             */
  o!.2.env  = 'SOUND'
  o!.2.vals = 'OFF 0'
  o!.2.stmt = 'prog.__NoSound=1'

  o!.3.parm = '/NOANSI'                 /* turn ANSI support off      */
  o!.3.env  = 'ANSI'
  o!.3.vals = 'OFF 0'
  o!.3.stmt = 'global.__NeedColors=0'

  o!.4.parm = '/TRACE'          /* exeucte MAIN in single step mode   */
  o!.4.env  = 'RXTTRACE'
  o!.4.vals = 'MAIN'
  o!.4.stmt = 'prog.__Trace=1'

  do i = 1 to o!.0
                        /* check the parameter                        */
    j = wordPos( o!.i.parm, translate( prog.__Param ) )
    if j = 0 then       /* no parameter found, check the env. var     */
      j = wordPos( translate( value( o!.i.env ,, prog.__env ) ) ,,
                    o!.i.vals )
    else                /* parameter found, delete the parameter      */
      prog.__Param = strip( delWord( prog.__Param, j,1 ) )

                        /* if j is not zero either the parameter was  */
                        /* found or the environment variable is set   */
    if j <> 0 then
      interpret o!.i.stmt
  end /* do i = 1 to o!.0 */

RETURN

/* ------------------------------------------------------------------ */
/* function:  convert a file or directory name to OS conventions      */
/*            by adding a leading and trailing double quote           */
/*                                                                    */
/* call:      convertNameToOS dir_or_file_name                        */
/*                                                                    */
/* where:     dir_or_file_name = name to convert                      */
/*                                                                    */
/* returns:   converted file or directory name                        */
/*                                                                    */
ConvertNameToOS: PROCEDURE expose (exposeList)
  parse arg fn
RETURN '"' || fn || '"'                                      /* v3.06 */

/* ------------------------------------------------------------------ */
/* function: flush the default REXX queue                             */
/*                                                                    */
/* call:     FlushQueue                                               */
/*                                                                    */
/* returns:  ''                                                       */
/*                                                                    */
FlushQueue: /* PROCEDURE expose (exposeList) */
  do while QUEUED() <> 0
    parse pull
  end /* do while QUEUED() <> 0 */
RETURN ' '                                                   /* v3.03 */

/* ------------------------------------------------------------------ */
/* function: include a file if it exists                              */
/*                                                                    */
/* call:     TryInclude( IncludeFile )                                */
/*                                                                    */
/* where:    IncludeFile = name of the file to include                */
/*                                                                    */
/* output:   prog.__rc = 0 - include file executed                    */
/*           else: file not found                                     */
/*                                                                    */
/* returns:  ''                                                       */
/*                                                                    */
TryInclude:
  parse upper arg I!.__IncFileName
  prog.__rc = 1

  if I!.__IncFileName = '' then
    RETURN ' '                                               /* v3.03 */

  if stream( I!.__IncFileName,'c','QUERY EXIST' ) = '' then
    RETURN ' '                                               /* v3.03 */

  prog.__rc = 0

  /* execute INCLUDE */

/* ------------------------------------------------------------------ */
/* function: include a file                                           */
/*                                                                    */
/* call:     Include( IncludeFile )                                   */
/*                                                                    */
/* where:    IncludeFile = name of the file to include                */
/*                                                                    */
/* returns:  ''                                                       */
/*                                                                    */
Include:
  parse upper arg I!.__IncFileName

                        /* check if the include file exists           */
  if stream( I!.__IncFileName, 'c', 'QUERY EXIST' ) == '' then
    call ShowError global.__ErrorExitCode, ,
                   I!.__GetMsg( 3, I!.__IncFileName )

                        /* read and interpret the include file        */
  do I!.__IncLineNO = 1 while lines( I!.__IncFileName ) <> 0
    I!.__IncCurLine = ''
                        /* save the absolute position of the start of */
                        /* this line for the error handler            */
    I!.__IncCurLinePos = stream(I!.__IncFileName,'c','SEEK +0')

                        /* handle multi line statements               */
    do forever
      I!.__IncCurLine = I!.__IncCurLine ,
                        strip( lineIn( I!.__IncFileName ) )

      if right( I!.__IncCurLine,1 ) <> ',' then
        leave

                        /* statement continues on the next line       */
      if lines( I!.__IncFileName ) == 0 then
        call ShowError global.__ErrorExitCode ,,
             I!.__GetMsg( 4, I!.__IncFileName )

                        /* the next lines is only executed if the IF */
                        /* statement above is FALSE                  */
      I!.__IncCurLine = substr( I!.__IncCurLine,1, ,
                                length( I!.__IncCurLine )-1 )

    end /* do forever */

    I!.__IncActive = 1
    interpret I!.__IncCurLine
    I!.__IncActive = 0

  end /* do I!.__IncLineNO = 1 while lines( I!.__IncFileName ) <> 0 ) */

                        /* close the include file!                    */
  call stream I!.__IncFileName, 'c', 'CLOSE'

                    /* do NOT return a NULL string ('')!        v3.03 */
                    /* Due to a bug in the CMD.EXE this will    v3.03 */
                    /* cause the error SYS0008 after the 32nd   v3.03 */
                    /* call of this function!                   v3.03 */
RETURN ' '

/* ------------------------------------------------------------------ */
/* function: init color variables                                     */
/*                                                                    */
/* call:     I!.__InitColorVars                                       */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
I!.__InitColorVars: /* PROCEDURE expose (exposeList) */

  if 1 == global.__NeedColors then
  do
    escC = '1B'x || '['                                      /* v3.04 */

    t1 = 'SAVEPOS RESTPOS ATTROFF' ,                         /* v3.05 */
         'HIGHLIGHT NORMAL BLINK INVERS INVISIBLE'           /* v3.05 */

    t2 = 's u 0;m 1;m 2;m 5;m 7;m 8;m'                       /* v3.05 */

    screen.__DELEOL = escC || 'K'                            /* v3.05 */

    do i = 1 to 8                                            /* v3.05 */

      call value 'SCREEN.__' || word( t1, i ) ,,             /* v3.05 */
                 escC || word( t2,i )                        /* v3.05 */

                                                             /* v3.05 */
      s = word( 'BLACK RED GREEN YELLOW BLUE MAGNENTA CYAN WHITE', i )
      call value 'SCREEN.__FG' || s,,                        /* v3.05 */
                 escC || 29+i || ';m'                        /* v3.05 */
      call value 'SCREEN.__BG' || s,,                        /* v3.05 */
                 escC || 39+i || ';m'                        /* v3.05 */
    end /* do i = 1 to 8 */                                  /* v3.05 */

    drop t1 t2 s i                                           /* v3.05 */

/* --------------------------- */
                        /* define color variables                     */
    screen.__ErrorColor  = screen.__AttrOff || screen.__Highlight || ,
                           screen.__FGYellow || screen.__bgRed

    screen.__NormalColor = screen.__AttrOff ||                       ,
                           screen.__fgWhite || screen.__bgBlack

    screen.__DebugColor  = screen.__AttrOff || screen.__Highlight || ,
                           screen.__fgBlue || screen.__bgWhite

    screen.__PromptColor = screen.__AttrOff || screen.__Highlight || ,
                           screen.__fgYellow || screen.__bgMagnenta

/* +++++++++++++++ DO NOT USE THE FOLLOWING COLORS! +++++++++++++++++ */
    screen.__SignOnColor = screen.__AttrOff || screen.__Highlight || ,
                           screen.__fggreen || screen.__bgBlack

    screen.__PatchColor  = screen.__AttrOff || screen.__Highlight || ,
                           screen.__fgcyan || screen.__bgRed
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

                            /* set the default color                  */
    screen.__CurColor    = screen.__NormalColor

                            /* turn ANSI word wrapping on             */
    if prog.__QuietMode <> 1 then
      call CharOut prog.__STDOUT, '1B'x || '[7h'

  end /* if 1 == global.__NeedColors then */

RETURN

/* ------------------------------------------------------------------ */
/* function: init the stem prog.                                      */
/*                                                                    */
/* call:     I!.__InitProgStem                                        */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* Note:     DO NOT ADD ANY CODE TO THIS ROUTINE!                     */
/*                                                                    */
I!.__InitProgStem: /* PROCEDURE expose (exposeList) */
  prog.__Defparms = ' {/L:logfile} {/H} {/Silent} {/NoAnsi} {/NoSound} {/Trace}'

                        /* get drive, path and name of this program   */
  parse upper source . . prog.__FullName
        prog.__Drive = filespec( 'D', prog.__FullName )
         prog.__Path = filespec( 'P',  prog.__FullName )
         prog.__Name = filespec( 'N',  prog.__FullName )

                                                             /* v3.05 */
 parse upper value 'V3.06 1 80 25 OS2ENVIRONMENT' directory() with ,
             prog.__Version ,         /* version of template    v3.05 */
             prog.__UserAbort ,       /* allow useraborts       v3.05 */
             prog.__ScreenCols ,      /* def. screen cols       v3.05 */
             prog.__ScreenRows ,      /* def. screen rows       v3.05 */
             prog.__env ,             /* def. environment       v3.05 */
             prog.__CurDir            /* current directory      v3.05 */

                                /* install a local error handler      */
  SIGNAL ON SYNTAX Name I!.__InitProgStem1
                                /* try to call SysTextScreenSize()    */
  parse value SysTextScreenSize() with prog.__ScreenRows prog.__ScreenCols

I!.__InitProgStem1:

RETURN

/* ------------------------------------------------------------------ */
/* function: init the variables for CID programs (only if the value   */
/*           of the variable global.__NeedCID is 1)                   */
/*                                                                    */
/* call:     I!.__InitCIDVars                                         */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* Note:     DO NOT ADD ANY CODE TO THIS ROUTINE!                     */
/*           Returncodes as defined by LCU 2.0                        */
/*                                                                    */
I!.__InitCIDVars: /* PROCEDURE expose (exposeList) exposeList CIDRC. */

  if 1 == global.__NeedCID then
  do

    I!.__cidRCValues = ,                                     /* v3.05 */
      '0000'x 'SUCCESSFUL_PROGRAM_TERMINATION',              /* v3.05 */
      '0004'x 'SUCCESSFUL_LOG_WARNING_MESSAGE',              /* v3.05 */
      '0008'x 'SUCCESSFUL_LOG_ERROR_MESSAGE',                /* v3.05 */
      '0012'x 'SUCCESSFUL_LOG_SEVERE_ERROR',                 /* v3.05 */
      '0800'x 'DATA_RESOURCE_NOT_FOUND',                     /* v3.05 */
      '0804'x 'DATA_RESOURCE_ALREADY_IN_USE',                /* v3.05 */
      '0808'x 'DATA_RESOURCE_NOAUTHORIZATION',               /* v3.05 */
      '0812'x 'DATA_PATH_NOT_FOUND',                         /* v3.05 */
      '0816'x 'PRODUCT_NOT_CONFIGURED',                      /* v3.05 */
      '1200'x 'STORAGE_MEDIUM_EXCEPTION',                    /* v3.05 */
      '1204'x 'DEVICE_NOT_READY',                            /* v3.05 */
      '1208'x 'NOT_ENOUGH_DISKSPACE',                        /* v3.05 */
      '1600'x 'INCORRECT_PROGRAM_INVOCATION',                /* v3.05 */
      '1604'x 'UNEXPECTED_CONDITION',                        /* v3.05 */
      'FE00'x 'SUCCESSFULL_REBOOT',                          /* v3.05 */
      'FE04'x 'SUCCESSFULL_REBOOT_WITH_WARNING',             /* v3.05 */
      'FE08'x 'SUCCESSFULL_REBOOT_WITH_ERRMSG',              /* v3.05 */
      'FE12'x 'SUCCESSFULL_REBOOT_WITH_SERVER_ERRMSG',       /* v3.05 */
                                                             /* v3.05 */
    do i = 1 to words( I!.__cidRCValues ) by 2               /* v3.05 */
      call value 'CIDRC.__' || word( I!.__cidRCValues,i+1 ),,
                 c2d( word( I!.__cidRCValues,i ),2 )         /* v3.05 */
                                                             /* v3.05 */
    end /* do i = 1 to words( I!.__cidRCValues ) by 2 */     /* v3.05 */
                                                             /* v3.05 */
    drop I!.__cidRCValues                                    /* v3.05 */


                        /* xx = next state of the program             */
/*    CIDRC.__successfull_reboot_with_callback = C2D('FFxx'x, 2);     */

                        /* define exit code values                    */
    global.__ErrorExitCode = CIDRC.__unexpected_condition
       global.__OKExitCode = CIDRC.__successful_program_termination

                        /* add the stem CIDRC. to the exposeList      */
    exposeList = exposeList 'CIDRC. '
  end /* if 1 == global.__NeedCID then */

RETURN


/***        End of Part 2 of the source code of TEMPLATE.CMD        ***/

/***       Start of Part 3 of the source code of TEMPLATE.CMD       ***/

/* ------------------------------------------------------------------ */
/* function:  load a dll                                              */
/*                                                                    */
/* call:                                                              */
/*   thisRC = LoadDll( registerFunction, dllName, entryPoint,         */
/*                     ,{deRegisterFunction},{checkFunction}          */
/*                     ,{IgnoreRxFuncAddRC},{RegisterErrorRC}         */
/*                     ,{errorAction}                                 */
/*                                                                    */
/* where:                                                             */
/*         registerFunc = name of the dll init function               */
/*                        (e.g. "SysLoadFuncs")                       */
/*              dllName = name of the dll                             */
/*                        (e.g. "REXXUTIL")                           */
/*           entryPoint = entryPoint for the dll init function        */
/*                        (e.g. "SysLoadFuncs")                       */
/*       deRegisterFunc = name of the dll exit function               */
/*                        (e.g. "SysDropFuncs")                       */
/*                        If this parameter is entered, the           */
/*                        deRegisterFunction is automaticly called    */
/*                        at program end if the loading of the dll    */
/*                        was successfull.                            */
/*            checkFunc = function which must be loaded if the dll is */
/*                        loaded (def.: none -> always load the dll)  */
/*                        Note:                                       */
/*                        Do not use the registerFunction for this    */
/*                        parameter! A good candidate for this        */
/*                        parameter is the deRegisterFunction.        */
/*    IgnoreRxFuncAddRC = 1: ignore the rc from rxFuncAdd             */
/*                        0: do not ignore the rc from rxFuncAdd      */
/*                        (def.: 0)                                   */
/*                        Note: Always set this parameter to 1 if     */
/*                              using the program under WARP.         */
/*       RegisterErroRC = returncode of the dll init function         */
/*                        indicating a load error                     */
/*                        (def. none, -> ignore the returncode of the */
/*                         dll init function)                         */
/*           actionCode = 1: abort program if loading failed          */
/*                        0: do not abort program if loading failed   */
/*                        (def.: 1)                                   */
/*                                                                    */
/* returns:                                                           */
/*   0 - loading failed                                               */
/*   1 - dll loaded                                                   */
/*   2 - dll already loaded                                           */
/*                                                                    */
/* Note:                                                              */
/*   See the routine MAIN for some examples for using LoadDLL.        */
/*   LoadDLL can only handle dlls with an init function to register   */
/*   the further routines in the dll (like the function SysLoadFuncs  */
/*   in the dll REXXUTIL).                                            */
/*                                                                    */
LoadDll:  PROCEDURE expose (exposeList)
  parse arg regFunc , ,
            dllName , ,
            entryPoint , ,
            deregFunc , ,
            checkFunc , ,
            ignoreRXFuncAddRC, ,
            registerErrorRC, ,
            errorAction

                        /* check the necessary parameters             */
  if '' == entryPoint | '' == dllName | '' == regFunc then
    call ShowError global.__ErrorExitCode, I!.__GetMsg( 6 )

  if '' == ignoreRXFuncAddRC then
    ignoreRXFuncAddRc = 0

  if '' == errorAction then
    errorAction = 1

  I!.__LoadDLLRc = 0
                        /* if the 'checkFunc' is missing, we          */
                        /* assume that the dll is not loaded          */
  dllNotLoaded = 1
  if ( checkFunc <> '' ) then
    dllNotLoaded = rxFuncQuery( checkFunc )

  if dllNotLoaded then
  do
                        /* first deRegister the function        v3.01 */
    call rxFuncDrop regFunc                                  /* v3.01 */

                        /* load the dll and register the init         */
                        /* function of the dll                        */
    rxFuncAddRC = rxFuncAdd( regFunc, dllName, entryPoint )

    if \ rxFuncAddRC | ignoreRxFuncAddRC then
    do

      I!.__DllInitRC = 0
      if I!.__CallUserProc( 0, regFunc ) == 0 then
        I!.__DllInitRC = 'ERROR'

      if ( registerErrorRC <> '' & I!.__DLLInitRC == registerErrorRC ) | ,
         ( I!.__DllInitRC == 'ERROR' ) then
        nop
      else
      do
                        /* add the dll deregister function to the     */
                        /* program exit routine list                  */
        if DeregFunc <> '' then
          if \ rxFuncQuery( DeregFunc ) then
            prog.__ExitRoutines = prog.__ExitRoutines || ' ' || ,
                                  DeregFunc

        I!.__LoadDLLRc = 1
      end /* else */
    end /* if \ rxFuncAddRC | ignoreRxFuncAddRC then */
  end /* if dllNotLoaded then */
  else
    I!.__LoadDLLRc = 2  /* dll is already loaded                      */

  if 1 == errorAction & 0 == I!.__LoadDLLRC then
    call ShowError global.__ErrorExitCode,,
                   I!.__GetMsg( 5, dllName )

RETURN I!.__LoadDLLRc

/* ------------------------------------------------------------------ */
/* function: show a string with word wrapping                         */
/*                                                                    */
/* call:     showString Prefix, thisString                            */
/*                                                                    */
/* where:                                                             */
/*           Prefix = prefix for the first line (e.g. "*-*" or "#" to */
/*                    use # leading blanks, # = 1 ... n )             */
/*           thisString - string to print                             */
/*                                                                    */
/* returns:  ''                                                       */
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

    if length( curStr || prefix ||  word( thisStr, i+1 ) ) > maxLineL then
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

RETURN ' '                                                   /* v3.03 */

/* ------------------------------------------------------------------ */
/* function: show a warning message                                   */
/*                                                                    */
/* call:     showWarning message                                      */
/*                                                                    */
/* where:    warningMessage - warning Message                         */
/*                                                                    */
/* returns:  ''                                                       */
/*                                                                    */
ShowWarning: PROCEDURE expose (exposeList)
  parse arg wMsg

  screen.__CurColor = screen.__ErrorColor

  call I!.__LogStart

  call ShowString I!.__GetMsg( 7 ) || ' ', wMsg || '!'
  call I!.__LogSeparator

  screen.__CurColor = screen.__NormalColor
  call Log

RETURN ' '                                                   /* v3.03 */

/* ------------------------------------------------------------------ */
/* function: show an error message and end the program                */
/*                                                                    */
/* call:     ShowError exitCode, errorMessage                         */
/*                                                                    */
/* where:    ExitCode - no of the error (= program exit code)         */
/*           errorMessage - error Message                             */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* Note:     THIS ROUTINE WILL NOT COME BACK!!!                       */
/*                                                                    */
ShowError: PROCEDURE expose (exposeList)
  parse arg prog.__ExitCode, I!.__errMsg

  I!.__QM = prog.__QuietMode
                        /* turn quiet mode off                        */
  prog.__QuietMode = ''

  screen.__CurColor = screen.__ErrorColor

  call I!.__LogStart

  call Log left( I!.__GetMsg( 8, prog.__Name , prog.__ExitCode ) ,,
                 prog.__ScreenCols )
  call ShowString 1, I!.__errMsg || '!'

  call I!.__LogSeparator
  call Log
                        /* restore quiet mode status                  */
  prog.__QuietMode = I!.__QM

  if prog.__NoSound <> 1 then
  do
    call beep 537,300
    call beep 237,300
    call beep 537,300
  end /* if prog.__NoSound <> 1 then */

SIGNAL I!.__ProgramEnd

RETURN

/* ------------------------------------------------------------------ */
/* function: log a debug message and clear the rest of the line       */
/*                                                                    */
/* call:     logDebugMsg message                                      */
/*                                                                    */
/* where:    message - message to show                                */
/*                                                                    */
/* returns:  ''                                                       */
/*                                                                    */
/* Note:     You do not need the 'call' keyword to use this routine.  */
/*                                                                    */
LogDebugMsg: PROCEDURE expose (exposeList)
  if global.__verbose <> '' then
  do
    parse arg dMsg
    screen.__CurColor = screen.__DebugColor
    call Log '+++' dMsg
    screen.__CurColor = screen.__NormalColor
  end /* if global.__verbose <> '' then */
RETURN ' '                                                   /* v3.03 */

/* ------------------------------------------------------------------ */
/* function: write a CR/LF and a separator line to the screen and to  */
/*           the logfile                                              */
/*                                                                    */
/* call:     I!.__LogStart                                            */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */

/* ------------------------------------------------------------------ */
/* function: write a separator line to the screen and to the logfile  */
/*                                                                    */
/* call:     I!.__LogSeparator                                        */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
I!.__LogStart:
  call log
I!.__LogSeparator:
  call Log ' ' || left('-', prog.__ScreenCols-2, '-' ) || ' '
RETURN

/* ------------------------------------------------------------------ */
/* function: log a message and clear the rest of the line             */
/*                                                                    */
/* call:     log message                                              */
/*                                                                    */
/* where:    message - message to show                                */
/*                                                                    */
/* returns:  ''                                                       */
/*                                                                    */
/* Note:     You do not need the 'call' keyword to use this routine.  */
/*                                                                    */
Log: PROCEDURE expose (exposeList)
  parse arg msg

  logmsg = msg
  do i = 1 to words( prog.__LogExcludeWords )
    curWord = word( prog.__LogExcludeWords, i )
   
    do until j = 0
      j = Pos( curWord, logmsg )
      if j <> 0 then
        logmsg = delstr( logmsg, j, length( curWord ) )
    end /* do until j = 0 */
  end /* do i = 1 to words( prog.__LogExcludeWords ) */

  if prog.__QuietMode <> 1 then
  do

    if length( logmsg ) == prog.__ScreenCols  then
      call charout prog.__STDOUT, screen.__CurColor || ,
                                  msg || screen.__AttrOff
    else
      call lineOut prog.__STDOUT, screen.__CurColor || ,
                                  msg || screen.__AttrOff ||,
                                  screen.__DelEOL

  end /* if prog.__Quietmode <> 1 then */

  if symbol( 'prog.__LogFile' ) == 'VAR' then
    if prog.__LogFile <> '' then
    do
      call lineout prog.__LogFile, logmsg

                                /* close the logfile                  */
      call stream prog.__LogFile, 'c', 'CLOSE'
    end /* if prog.__LogFile <> '' then */

RETURN ' '                                                   /* v3.03 */

/* ------------------------------------------------------------------ */
/* function: check if there is a patched version of this program      */
/*                                                                    */
/* call:     I!.__CheckPatch                                          */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* Note:     I!.__RealParam must contain the parameters for           */
/*           this program.                                            */
/*           The variables prog.__Path and prog.__Name must be set!   */
/*           This procedure ends the program with an EXIT command!    */
/*                                                                    */
I!.__CheckPatch: PROCEDURE expose (exposeList)

                        /* get the drive with patch cmd files         */
                        /*                                      v3.04 */
  parse upper value value( 'PATCHDRIVE',, prog.__env ) with pLW

  if global.__NeedPatchCheck <> 0 & ( pLW <> '' & pLW <> prog.__Drive ) then
  do

    pVer = pLW || prog.__Path || prog.__Name

                        /* check if a patched program version exists  */
    if stream( pVer, 'c', 'QUERY EXIST' ) <> '' then
    do
      pCmd = pVer || ' ' || I!.__RealParam

      screen.__CurColor = screen.__PatchColor
      call Log left( I!.__GetMsg( 9, pver ), prog.__ScreenCols )
      screen.__CurColor = screen.__AttrOff
      call I!.__LogSeparator

      '@cmd /c ' pCmd

      screen.__CurColor = screen.__AttrOff
      call I!.__LogSeparator
      screen.__CurColor = screen.__PatchColor
      call Log left( I!.__GetMsg( 10, rc ), prog.__ScreenCols )

      exit rc
    end /* if stream( ... */
  end /* if pLW <> '' */
RETURN

/* ------------------------------------------------------------------ */
/* function: error handler for unexpected errors                      */
/*                                                                    */
/* call:     DO NOT CALL THIS ROUTINE BY HAND!!!                      */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* input:    I!.__IncActive:                                          */
/*             if 1 the error occured while executing an include file */
/*             statement. In this case the following variables are    */
/*             also used (Note that this variables are automaticly    */
/*             set by the routine INCLUDE()):                         */
/*               I!.__IncLineNo                                       */
/*                 Line no. of the include file                       */
/*               I!.__IncFileName:                                    */
/*                 Name of the include file                           */
/*               I!.__IncCurLinePos:                                  */
/*                 Fileposition of the first char of the line causing */
/*                 the error                                          */
/*                                                                    */
/* Note:     THIS FUNCTION ABORTS THE PROGRAM WITH A JUMP TO THE      */
/*           LABEL I!.__PROGRAMEND!!!                                 */
/*                                                                    */
I!.__ErrorAbort:

                            /* turn ANSI word wrap on                 */   
  if screen.__CurColor <> '' then
    call CharOut prog.__STDOUT, '1B'x || '[7h'

                        /* check if the error occured in the error    */
                        /* handler                                    */
  if I!.__errorLineNo == sigl then
  do
    call charout 'STDERR:',,
                                                            '0D0A'x  ,
       'Fatal Error: Error in the error handler detected!'  '0D0A'x  ,
                                                            '0D0A'x  ,
       'Linenumber:       ' || sigl                         '0D0A'x  ,
       'Errorname:        ' || condition('C')               '0D0A'x  ,
       'Errordescription: ' || condition('D')               '0D0A'x  ,
                                                            '0D0A'x  ,
       'The program exit routines were not called!'         '0D0A'x  ,
       'Check if "(EXPOSELIST)" is included in the ' || ,
       'expose lists of all procedures!'                    '0D0A'x

    call beep 637,300 ; call beep 437,300 ; call beep 637,300
    exit 255

  end /* if I!.__errorLineNo == sigl then */

                        /* get the number of the line causing the     */
                        /* error                                      */
  I!.__errorLineNo = sigl

                        /* get the name of this error                 */
  I!.__ErrorName = condition('C')

                        /* get further information for this error     */
                        /* if available                               */
  I!.__ErrorCondition = condition('D')
  if I!.__ErrorCondition <> '' then
    I!.__ErrorCondition = ' (Desc.: "' || I!.__ErrorCondition || '")'

  if datatype( prog.__ScreenCols, 'W' ) <> 1 then
    prog.__ScreenCols = 80

  if SYMBOL( 'prog.__Name' ) <> 'VAR' | value( 'prog.__Name' ) == '' then
    if I!.__errorLineNO < I!.__FirstUserCodeLine then
      I!.__pName = '**Runtime**'
    else
      I!.__pName = '***???***'
  else
    i!.__pName = prog.__Name

                        /* reInstall the error handler                */
  INTERPRET  'SIGNAL ON ' value(condition('C')) ' NAME I!.__ErrorAbort'

                        /* check, if we should ignore the error       */
  if value( 'sigl' ) == value( 'I!.__ICmdLine' ) then
  do
    I!.__errorLineNo = 0
    SIGNAL I!.__CallUserProc2
  end /* if value( ... */

  screen.__CurColor = screen.__ErrorColor

  I!.__QM = prog.__QuietMode
                        /* turn quiet mode off                        */
  prog.__QuietMode = ''

                        /* init variables for printing the line       */
                        /* causing the error to the screen            */
  I!.__ThisSRCLine = ''
  I!.__ThisPrefix = ' *-* '

  call I!.__LogStart

  call ShowString ' ' || I!.__pName || ' - ', I!.__ErrorName || ,
                  I!.__ErrorCondition || ' error detected!'

                        /* check, if the RC is meaningfull for this   */
                        /* error                                      */
  if pos( I!.__ErrorName, 'ERROR FAILURE SYNTAX' ) <> 0 then
  do
    if datatype(rc, 'W' ) == 1 then
      if 'SYNTAX' == I!.__ErrorName then
         if rc > 0 & rc < 100 then
            call Log left( ' The error code is ' || rc || ,
                           ', the REXX error message is: ' || ,
                           errorText( rc ), ,
                           prog.__ScreenCols )
         else
           call log left( ' The error code is ' || rc || ,
                          ', this error code is unknown.',,
                          prog.__ScreenCols )
      else
        call Log left( ' The RC is ' || rc || '.', prog.__ScreenCols )
  end /* if pos( ... */

  if value( 'I!.__IncActive' ) == 1 then
  do
                /* error occured while interpreting an include file   */
    call ShowString 1, 'The error occured while executing the line ' || ,
                       I!.__IncLineNo || ' of the include file "' || ,
                       I!.__IncFileName || '".'

                        /* reset the file pointer of the include file */
                        /* to the start of the line causing the error */
    call stream I!.__IncFileName, 'c', 'SEEK =' || ,
                                                   I!.__IncCurLinePos

    I!.__SrcAvailable = stream( I!.__IncFileName, ,
                                   'c', 'QUERY EXIST' ) <> ''
  end
  else
  do
    call ShowString 1, 'The error occured in line ' ||,
                       I!.__errorLineNo || '.'

    I!.__thisLineNo = I!.__errorLineNo

                /* error occured in this file                         */
                /* check if the sourcecode is available               */
    SIGNAL ON SYNTAX   NAME I!.__NoSourceCode
    I!.__inMacroSpace = 1
    I!.__SrcAvailable = 0
    if sourceLine( I!.__errorLineNo ) <> '' then
      I!.__SrcAvailable = 1

    SIGNAL ON SYNTAX NAME I!.__ErrorAbort
    I!.__inMacroSpace = 0

  end /* else */

                        /* print the statement causing the error to   */
                        /* the screen                                 */
  if 1 == I!.__SrcAvailable then
  do
    call Log left( ' The line reads: ', prog.__ScreenCols )
    I!.__InterpretVar = 0

                /* read the line causing the error                    */
    call I!.__GetSourceLine

    I!.__FirstToken = strip(word( I!.__ThisSRCLine,1))
    if translate( I!.__FirstToken ) == 'INTERPRET' then
    do
      parse var I!.__ThisSRCLine (I!.__FirstToken) ,
                I!.__interpretValue
      I!.__InterpretVar = 1
    end /* if I!.__thisLineNo = I!.__errorLineNo */

                        /* handle multi line statements               */
    do forever
      call ShowString I!.__ThisPrefix, I!.__ThisSRCLine

      if right( strip( I!.__ThisSRCLine),1 ) <> ',' then
        leave

      I!.__ThisPrefix = 5

      call I!.__GetSourceLine
    end /* do forever */

    if 1 == I!.__InterpretVar then
    do
      I!.__interpretValue = strip( word(I!.__interpretValue,1) )

      if symbol( I!.__interpretValue ) == 'VAR' then
      do
        call Log left( '', prog.__ScreenCols )
        call Log left( ' The value of "' || I!.__interpretValue || ,
                       '" is:', prog.__ScreenCols )
        call ShowString ' >V> ', value( I!.__interpretValue )
      end /* if symbol( I!.__interpretValue ) = 'VAR' then */

    end /* if 1 == I!.__InterpretVar */

  end /* if 1 == I!.__SrcAvailable  then do */
  else
    call Log left( ' The sourcecode for this line is not available',,
                   prog.__ScreenCols )

I!.__NoSourceCode:
  SIGNAL ON SYNTAX NAME I!.__ErrorAbort

  if 1 == I!.__inMacroSpace then
  do
    parse source . . I!.__thisProgName

    if fileSpec( 'D', I!.__thisProgName ) == '' then
      call ShowString 1, ' The sourcecode for this line is not' || ,
                         ' available because the program is in' || ,
                         ' the macro space.'
    else
      call ShowString 1, ' The sourcecode for this line is not' || ,
                         ' available because the program is unreadable.'
  end /* if 1 == I!.__inMacroSpace then */

  call I!.__LogSeparator
  call Log

  prog.__ExitCode = global.__ErrorExitCode

  if prog.__NoSound <> 1 then
  do
    call beep 137,300;  call beep 337,300;  call beep 137,300
  end /* if prog.__NoSound <> 1 then */

  if 'DEBUG' == global.__verbose | prog.__Trace = 1 then
  do
                        /* enter interactive debug mode               */
    trace ?a
    nop
  end /* if 'DEBUG' == global.__verbose | ... */

                        /* restore quiet mode status                  */
  prog.__QuietMode = I!.__QM

SIGNAL I!.__programEnd

/* ------------------------------------------------------------------ */
/* function: get the sourceline causing an error (subroutine of       */
/*           I!.__ErrorAbort)                                         */
/*                                                                    */
/* call:     DO NOT CALL THIS IN YOUR CODE!!!                         */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* Note:     -                                                        */
/*                                                                    */
I!.__GetSourceLine:
  if 1 == I!.__IncActive then
    I!.__ThisSRCLine = lineIn( I!.__IncFileName )
  else
  do
    I!.__ThisSRCLine = sourceLine( I!.__ThisLineNo )
    I!.__ThisLineNo = I!.__ThisLineNo + 1
  end /* else */
RETURN

/* ------------------------------------------------------------------ */
/* function: error handler for user breaks                            */
/*                                                                    */
/* call:     DO NOT CALL THIS ROUTINE BY HAND!!!                      */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* Note:     THIS FUNCTION ABORTS THE PROGRAM WITH A JUMP TO THE      */
/*           LABEL I!.__PROGRAMEND IF prog.__UserAbort IS NOT 0!!!    */
/*                                                                    */
/*           In exit routines you may test if the variable            */
/*           prog.__ExitCode is 254 to check if the program           */
/*           was aborted by the user.                                 */
/*                                                                    */
I!.__UserAbort:
  I!.__sSigl = sigl

                        /* reinstall the error handler                */
  CALL ON HALT NAME I!.__UserAbort

                        /* check if user aborts are allowed           */
  if 0 == prog.__UserAbort then
    RETURN              /* CTRL-BREAK not allowed                     */

  I!.__QM = prog.__QuietMode

                        /* turn quiet mode off                        */
  prog.__QuietMode = ''

  call Log

  screen.__CurColor = screen.__ErrorColor
  call I!.__LogSeparator
  call Log left( I!.__GetMsg( 11, I!.__sSigl ), prog.__ScreenCols )
  call I!.__LogSeparator
  screen.__CurColor = screen.__NormalColor

  prog.__ExitCode = 254

                        /* restore quiet mode status                  */
  prog.__QuietMode = I!.__QM

SIGNAL I!.__ProgramEnd

/* ------------------------------------------------------------------ */
/* function: get a message                                            */
/*                                                                    */
/* call:     I!.__GetMsg msgNo {,msgP1} {...,msgP9}                   */
/*                                                                    */
/* returns:  the message or an empty string                           */
/*                                                                    */
/* note:     This routines calls the external routine which name is   */
/*           saved in the variable 'global.__GetMsg' if this variable */
/*           is not equal ''.                                         */
/*                                                                    */
/*           I!.__GetMsg adds global.__BaseMsgNo to the msgNo.        */
/*                                                                    */
I!.__GetMsg: PROCEDURE expose (exposeList)
  parse arg msgNo, mP1 , mP2 , mP3, mP4, mP5, mP6, mP7, mP8, mP9

  f = 0
  t = ''

  if symbol( 'global.__GetMsg' ) = 'VAR' then
    if global.__GetMsg <> '' then
    do
            /* first check if there's a user defined GetMsg routine   */

                        /* install a local error handler              */
      SIGNAL ON SYNTAX Name I!.__GetMsg1

                    /* try to call the user defined GetMsg routine    */
      interpret 'call ' global.__GetMsg ' msgNo+global.__BaseMsgNo,,' ,
                ' mP1, mP2, mP3, mP4, mP5, mP6, mP7, mP8, mP9 '
      f = 1
    end /* if global.__GetMsg <> '' then */

I!.__GetMsg1:

  if f = 1 then
  do
                        /* user defined GetMsg routine found -- use   */
                        /* the result                                 */
    if symbol( 'RESULT' ) == 'VAR' then
      t = result
  end /* if result = 0 then */
  else
  do
                        /* user defined GetMsg routine not found --   */
                        /* use the hardcoded message strings          */
      msgString =  ,
/* 1001 */      'Routine_"@1"_not_found',
/* 1002 */      'Can_not_write_to_the_logfile_"@1",_the_status_of_the_logfile_is_"@2"._Now_using_the_NUL_device_for_logging',
/* 1003 */      'Include_file_"@1"_not_found' ,
/* 1004 */      'Unexpected_EOF_detected_while_reading_the_include_file_"@1"' ,
/* 1005 */      'Error_loading_the_DLL_"@1"' ,
/* 1006 */      'Invalid_call_to_LOADDLL' ,
/* 1007 */      '_Warning:' ,
/* 1008 */      '_@1_-_Error_@2_detected!_The_error_message_is_',
/* 1009 */      '_Calling_the_patched_version_@1_...' ,
/* 1010 */      '_..._the_patched_version_endet_with_RC_=_@1' ,
/* 1011 */      '_Program_aborted_by_the_user_(sigl=@1)' ,
/* 1012 */      '@1_@2_started_on_@3_at_@4_...' ,
/* 1013 */      '@1_@2_ended_on_@3_at_@4_with_RC_=_@5_(=''@6''x)' ,
/* 1014 */      '_Usage:'

                    /* get the message and translate all underscores  */
                    /* to blanks                                      */
    t = translate( word( msgString, msgNo ), ' ', '_'  )

                    /* replace place holder                           */
    i = 1
    do until i > 9
     j = pos( '@' || i, t )
     if j <> 0 then
       t = insert( arg( i+1 ), delStr(t, j, 2) , j-1 )
     else
       i = i +1
    end /* do until i > 9 */
  end /* else */
return t

/* ------------------------------------------------------------------ */
/* function: get the line no of the call statement of this routine    */
/*                                                                    */
/* call:     GetLineNo                                                */
/*                                                                    */
/* returns:  the line number                                          */
/*                                                                    */
/*                                                                    */
GetLineNo:
  RETURN sigl

/* ------------------------------------------------------------------ */
/* function: get the no. of the first line with the user code         */
/*                                                                    */
/* call:     DO NOT CALL THIS ROUTINE BY HAND!!!                      */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/*                                                                    */
I!.__GetUserCode:
  I!.__FirstUserCodeLine = GetLineNo()+2
RETURN

/********************** End of Runtime Routines ***********************/
/**********************************************************************/

/***        End of Part 3 of the source code of TEMPLATE.CMD        ***/

/***       Start of Part 4 of the source code of TEMPLATE.CMD       ***/
                                                                   /*!*/

/* ------------------------------------------------------------------ */
/* function: main procedure of the program                            */
/*                                                                    */
/* call:     called by the runtime system with:                       */
/*           => call main parameter_of_the_program <=                 */
/*                                                                    */
/* returns:  program return code                                      */
/*           If no return code is returned, the value of the variable */
/*           prog.__ExitCode is returned to the calling program.      */
/*                                                                    */
/* Note:     YOU MUST FILL THIS ROUTINE WITH CODE.                    */
/*           If you want to add further global variables you SHOULD   */
/*           add them to the expose list of the procedure MAIN!       */
/*                                                                    */
Main: PROCEDURE expose (exposeList)

                    /* strings which should not be written into       */
                    /* the log file                                   */
  prog.__LogExcludeWords = screen.__fgYellow screen.__highlight ,
                           screen.__AttrOff

                    /* init the variables for the filenames and       */
                    /* directory names                                */
  sourceFiles. = ''
  sourceFiles.0 = 0
  targetFile = ''
  targetDirectory = ''

                    /* get the parameter of the program               */
  parse arg thisparameter
  call SplitParameter thisParameter , ':'

  do i = 1 to argv.0

    select

      when argv.i.__keyWord = 'SOURCE' then
      do
        k = sourceFiles.0+1
        sourceFiles.k = argv.i.__keyValue
        sourceFiles.0 = k
      end /* when */

      when argv.i.__keyWord = 'TARGET' then
      do
        if targetDirectory = '' then
          targetDirectory = argv.i.__KeyValue
        else
          call ShowError CIDRC.__unexpected_condition,,
                 'Duplicate parameter "' || argv.i.__KeyWord || '" found'
      end /* when */

      otherwise
      do
        call ShowError CIDRC.__unexpected_condition,,
               'Unknown parameter "' || argv.i.__keyword,
                                        argv.i.__keyvalue || '" found'
      end /* otherwise */
    end /* select */
  end /* do i = 1 to argv.i */

                    /* check the parameter                            */
  if sourceFiles.0 = 0 then
    call ShowError CIDRC.__unexpected_condition,,
           'Parameter "SOURCE:sourceFile" missing!'

  if targetDirectory = '' then
    call ShowError CIDRC.__unexpected_condition,,
           'Parameter "TARGET:targetDirectory" missing!'

                    /* check if the source files exist                */
                    /* also check for duplicate macronames            */
  do i = 1 to sourceFiles.0
                    /* add the extension if necessary                 */
    if fileSpec( 'E', sourceFiles.i ) = '' then
      sourceFiles.i = sourceFiles.i || '.CMD'

    tFileName = stream( sourceFiles.i, 'c', 'QUERY EXISTS' )
    if tFileName = '' then
      call ShowError CIDRC.__unexpected_condition,,
             'Can not find the source file "' || sourceFiles.i || '"'
    else
    do
                    /* get & check the macro name                     */
      sourceFiles.i = tFileName
      curMacroName = translate( GetMacroName( tFileName ) )

      if curMacroName = '' then
        call ShowError CIDRC.__unexpected_condition,,
             'Can not detect the name for the macro!'

      do k = 1 to i-1
        if curMacroName = sourceFiles.k.__MacroName then
          call ShowError CIDRC.__unexpected_condition,,
             'Duplicate macro found.' ,
             'The macroname is "' || curMacroName || '", filename 1 is "' || ,
             sourceFiles.k || '", filename 2 is "' || sourceFiles.i || '"'
      end /* do k = 1 to i-1 */

      sourceFiles.i.__MacroName = curMacroName
    end /* else */
  end /* do i = 1 to sourceFiles.0 */

  BaseSourceFile = sourceFiles.1
  BaseSourceDirectory = translate( FileSpec( 'H', BaseSourceFile ) )

                    /* check if the target directory exists           */
  if right( targetDirectory, 1 ) = '\' then
    targetDirectory = dbrright( targetDirectory, 1 )

  tTargetName = translate( DirExist( targetDirectory ) )
  if tTargetName = '' then
    call ShowError CIDRC.__unexpected_condition,,
         'The target directory "' || targetDirectory || '" does not exist'

  targetDirectory = tTargetName

                    /* determine the extension for the target image   */
  parse version rexxVersion .
  if rexxVersion = 'OBJREXX' then
     newExtension = '.IMO'
  else
     newExtension = '.IMC'

                    /* create the names for the target files          */
  targetBaseName = targetDirectory || '\' || fileSpec( 'B', BaseSourceFile )
  targetImgFile = targetBaseName || newExtension
  targetCmdFile = targetBasename || '.CMD'


  call log 'Creating the image file '
  call log ' ' || AddColor1( '"', targetImgFile )
  call log 'The target CMD file (loader) is '
  call log ' ' || AddColor1( '"', targetCmdFile )
  call log 'The base source file is'
  call log ' ' || AddColor1( '"', BaseSourceFile )
  call log 'The base source directory is'
  call log ' ' || AddColor1( '"', BaseSourceDirectory )

  if targetDirectory = BaseSourceDirectory then
    call ShowError CIDRC.__unexpected_condition,,
            'The target directory can not be equal to the base source directory!'

                    /* load the DLL functions to work on the macro    */
                    /* space                                          */
  if LoadMacroSpaceFunctions() <> 0 then
    call ShowError CIDRC.__unexpected_condition,,
           'Can not load the DLL functions to work with' ,
           'the macrospace functions'

  call log 'Creating the IMG file ...'

                    /* first clear the macro space                    */
  curClearRC = SysClearREXXMacroSpace()
  if curClearRC <> 0 & curClearRC <> 2 then
    call ShowError CIDRC.__unexpected_condition,,
           'Error ' || curClearRC || ' (' || ,
            GetMacroDllErrorMessage( curClearRC ) || ,
            ') clearing the macro space.'

                    /* clear the macro space at the end of the        */
                    /* program in all cases                           */
  prog.__exitRoutines = prog.__exitRoutines ' SysClearREXXMacroSpace '

                    /* load the macros into the macro space           */
  do i = 1 to sourceFiles.0
    curSourceFile = sourceFiles.i
    curMacroName =  sourceFiles.i.__MacroName

    if i = 1 then
      baseMacroName = curMacroName

    call log '  Loading the file ' || AddColor1( '"', curSourceFile )
    call log '    (The name of the macro is ' || AddColor1( '"', curMacroName ) || ')'

    if SysQueryRexxMacro( curMacroName ) <> '' then
      call ShowError CIDRC.__unexpected_condition,,
           'Duplicate macro found (Macro is already loaded)'

                    /* now load the REXX programs into the macro      */
                    /* space                                          */
    curLoadRC = SysAddRexxMacro( curMacroName,,
                                 curSourceFile ,,
                                 'B' )
    if curLoadRC <> 0 then
      call ShowError CIDRC.__unexpected_condition,,
           'Error ' || curLoadRC || ' (' || ,
            GetMacroDllErrorMessage( curLoadRC ) || ,
            ') loading the program into the macro space.'

  end /* do i = 1 to sourceFiles.0 */

                    /* now save the macro space into the target file  */
  curSaveImgRC = SysSaveRexxMacroSpace( targetImgFile )
  if curSaveImgRC <> 0 then
    call ShowError CIDRC.__unexpected_condition,,
           'Error ' || curSaveImgRC || ' (' || ,
            GetMacroDllErrorMessage( curSaveImgRC ) || ,
            ') saving the macro space into the target image file'

                    /* and last, clear the macro space again          */
  curClearRC = SysClearREXXMacroSpace()
  if curClearRC <> 0 & curClearRC <> 2 then
    call ShowWarning ,
           'Error ' || curClearRC || ' (' || ,
            GetMacroDllErrorMessage( curClearRC ) || ,
            ') clearing the macro space.'

  call log '... IMG file successfully created.'

                    /* and last, create the loader CMD file           */
  call log 'Creating the CMD file ...'

  call InitLoaderVariable baseMacroName

  if stream( targetCmdFile, 'c', 'QUERY EXISTS' ) <> '' then
    '@del ' targetCmdFile '2>NUL 1>NUL'

  call stream targetCmdFile, 'c', 'OPEN WRITE'

  thisRC = LineOut( targetCmdFile, loaderSourceCode )

  call stream targetCmdFile, 'c', 'CLOSE'

  if thisRC <> 0 then
    call ShowError CIDRC.__unexpected_condition,,
           'Error creating the CMD file'

  call log 'Target files succesfully created.'
exit 0


/* ------------------------------ */

                        /* exit the program                           */
RETURN

/* ------------------------------------------------------------------ */

/*** INSERT FURTHER SUBROUTINES HERE ***/

/*** Note: Do not forget the string 'EXPOSELIST' in the exposeList  ***/
/***       of ALL procedures!                                       ***/

/* ------------------------------------------------------------------ */
/* function: get the message for an error number from the macro       */
/*           functions                                                */
/*                                                                    */
/* call:     GetMacroDLLErrorMessage errorNo                          */
/*                                                                    */
/* where:    errorNo - error number                                   */
/*                                                                    */
/* returns:  error message                                            */
/*                                                                    */
GetMacroDllErrorMessage: PROCEDURE expose (exposeList)
  parse arg thisErrorNo .

  select

    when thisErrorNo = 1 then
      thisErrorMessage =  'Not enough memory'

    when thisErrorNo = 2 then
      thisErrorMessage =  'Macro not found'

    when thisErrorNo = 3 then
      thisErrorMessage =  'Extension required'

    when thisErrorNo = 4 then
      thisErrorMessage =  'Macro already exist'

    when thisErrorNo = 5 then
      thisErrorMessage =  'File error'

    when thisErrorNo = 6 then
      thisErrorMessage =  'Signatur error'

    when thisErrorNo = 7 then
      thisErrorMessage =  'Sourcefile not found'

    when thisErrorNo = 8 then
      thisErrorMessage =  'Invalid position'

    otherwise
      thisErrorMessage = 'Unknwon error'

  end /* select */

RETURN thisErrorMessage

/* ------------------------------------------------------------------ */
/* function: load the functions to process the macro space            */
/*                                                                    */
/* call:     thisRC = LoadMacroSpaceFunctions()                       */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  0 =  okay                                                */
/*           else error                                               */
/*                                                                    */
/*                                                                    */
LoadMacroSpaceFunctions: PROCEDURE expose (exposeList)
                    /* init the stem with the macro function names    */

                    /* functions from the new REXXUTIL DLL            */
  i = 0; newFunctions.0 = i;
  i=i+1; newFunctions.i = 'SysQueryRexxMacro'
  i=i+1; newFunctions.i = 'SysAddRexxMacro'
  i=i+1; newFunctions.i = 'SysClearRexxMacroSpace'
  i=i+1; newFunctions.i = 'SysdropRexxMacro'
  i=i+1; newFunctions.i = 'SysLoadRexxMacroSpace'
  i=i+1; newFunctions.i = 'SysSaveRexxMacroSpace'
         newFunctions.0 = i

                    /* name of the DLL with the functions             */
  DLLtoUse = ''

                    /* possible names of the DLL to use               */
  possibleDLLS = 'REXXUTIL ' global.__REXXUTILDLL

  do i = 1 to words( possibleDLLs ) while DLLToUse = ''
    curDLLName = word( possibleDLLs, i )

                    /* try to load the first function                 */
    call rxFuncAdd newFunctions.1, curDLLName, newFunctions.1

                    /* check if the call was successfull              */
    if FunctionLoaded( newFunctions.1, '"dummy"' ) = 0 then
      DLLToUse = curDLLName
    else
      call rxFuncDrop newFunctions.1
  end /* do i = 1 to ... */

  if DLLToUse <> '' then
  do
    thisRC = 0
                    /* load the other functions                       */
    do i = 2 to newFunctions.0
      call rxFuncAdd newFunctions.i, DLLToUse, newFunctions.i
    end /* do i = 2 to newFunctions.0 */
  end /* if */
  else
    thisRC = 1

RETURN thisRC

/* ------------------------------------------------------------------ */
/* function: Check if a function is loaded                            */
/*                                                                    */
/* call:     thisRC = FunctionLoaded( Name {,parm1} {...} {,parm#}    */
/*                                                                    */
/* where:    name - name of the function                              */
/*           parm1 ... parm#                                          */
/*              parameter for the function                            */
/*                                                                    */
/* returns:  0 - okay, function is loaded                             */
/*           else error: either the function is not loaded or the     */
/*                       parameter are invalid                        */
/*                                                                    */
FunctionLoaded: PROCEDURE expose (exposeList)

                    /* init the return code                           */
  thisRC = 1
                    /* install a local error handler                  */
  signal on syntax name functionLoadedEnd

                    /* create the statement to call the function      */
  stmt = 'functionRC = ' || arg(1) || '('

  do i = 2 to arg()
    stmt = stmt arg( i )
  end /* do i = 1 to arg() */

  stmt = stmt || ')'

                    /* execute the statement                          */
  interpret stmt

                    /* the next statement is only executed if there's */
                    /* no error                                       */
  thisRC = 0

FunctionLoadedEnd:

return thisRC

/* ------------------------------------------------------------------ */
/* function: Check if a directory exist                               */
/*                                                                    */
/* call:     DirExist( testDir )                                      */
/*                                                                    */
/* where:    testDir - name of the directory to test                  */
/*                                                                    */
/* returns:  full name of the directory or "" if the directory        */
/*           don't exist                                              */
/*                                                                    */
DirExist: PROCEDURE
  parse arg testDir .

                        /* init the return code                       */
  thisRC = ""

                        /* install a temporary error handler to check */
                        /* if the drive with the directory to test is */
                        /* ready                                      */
  SIGNAL ON NOTREADY NAME DirDoesNotExist

                        /* check if the drive is ready                */
  call stream testDir || "\*", "D"


                        /* save the current directory of the current  */
                        /* drive                                      */
  curDir = directory()

                        /* save the current directory of the drive    */
                        /* with the directory to test                 */
  curDir1 = directory( fileSpec( "drive", testDir ) )


                        /* test if the directory exist                */
  thisRC = directory( testDir )

                        /* restore the current directory of the drive */
                        /* with the directory to test                 */
  call directory curDir1

                        /* restore the current directory of the       */
                        /* current drive                              */
  call directory curDir
DirDoesNotExist:

return thisRC

/* ------------------------------------------------------------------ */
/* function: Extended FILESPEC function                               */
/*                                                                    */
/* call:     FileSpec option,fileName                                 */
/*                                                                    */
/* where:    option                                                   */
/*                                                                    */
/*             - E{xtension}                                          */
/*               return the extension of the file                     */
/*                                                                    */
/*             - B{asename}                                           */
/*               returns the name of the file without extension       */
/*                                                                    */
/*             - H{ome]                                               */
/*               returns the fully qualified path of the file         */
/*               (including the drive specifier; without the trailing */
/*               backslash)                                           */
/*                                                                    */
/*             All other values for "option" are processed by the     */
/*             original FILESPEC function.                            */
/*                                                                    */
/*           fileName                                                 */
/*             - name of the file                                     */
/*                                                                    */
/* returns:  if option = E{xtension}:                                 */
/*             the extension of the fileName or "" if none            */
/*           else                                                     */
/*             if option = B{asename}:                                */
/*               the name of the file without the path and extension  */
/*             else                                                   */
/*               the return code of the original FILESPEC function    */
/*               or "SYNTAX ERROR" if called with invalid parameter   */
/*                                                                    */
/* note:     To call the original FILESPEC function direct use        */
/*             myResult = "FILESPEC"( option, fileName )              */
/*                                                                    */
/* history:                                                           */
/*           RXT&T v1.90 /bs                                          */
/*            - added the option B{asename}                           */
/*           RXT&T v2.30 /bs                                          */
/*            - added the option H{ome}                               */
/*                                                                    */
FileSpec: PROCEDURE
  parse arg option, fileName

                        /* init the return code                       */
  rc = "SYNTAX ERROR"
                        /* install a local error handler              */

  SIGNAL ON SYNTAX NAME FileSpecError

  fileName = strip( fileName )                               /* v2.30 */
  option = translate( strip( option ) )

                        /* check the option code                      */
  select

    when abbrev( "EXTENSION", option ) = 1 then
    do
                        /* process the new added option code          */
      i = lastPos( ".", fileName )
      if i > lastPos( "\", fileName ) then
        rc = substr( fileName, i )
      else
        rc = ""
    end /* when */

    when abbrev( "BASENAME", option ) = 1 then               /* v1.90 */
    do                                                       /* v1.90 */
                        /* call the original FILESPEC function  v1.90 */
                        /* to get the filename                  v1.90 */
      rc = "FILESPEC"( "N", fileName )                       /* v1.90 */
      i = lastpos( ".", rc )                                 /* v1.90 */
      if i <> 0 then                                         /* v1.90 */
        rc = substr( rc,1, i-1 )                             /* v1.90 */
    end /* when */                                           /* v1.90 */

    when abbrev( "HOME", option ) = 1 then                   /* v2.30 */
    do                                                       /* v2.30 */
      rc = "FILESPEC"( "D", fileName ) ||,                   /* v2.30 */
           "FILESPEC"( "P", fileName )                       /* v2.30 */
      if right( rc,1 ) = "\" then                            /* v2.30 */
        rc = dbrright( rc,1 )                                /* v2.30 */
    end /* when */                                           /* v2.30 */

    otherwise
    do
                        /* call the original FILESPEC function        */
      rc = "FILESPEC"( option, fileName )
    end /* otherwise */

  end /* select */

FileSpecError:

RETURN rc



/* ------------------------------------------------------------------ */
/* function: Show the invocation syntax                               */
/*                                                                    */
/* call:     called by the runtime system with                        */
/*           => call ShowUsage <=                                     */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  ''                                                       */
/*                                                                    */
/* Note:     YOU SHOULD FILL THIS ROUTINE WITH CODE.                  */
/*           You may change the return code for your program in this  */
/*           routine. The default for the return code is 253.         */
/*           (The variable for the return code is prog.__ExitCode)    */
/*                                                                    */
/*                                                                    */
ShowUsage: PROCEDURE expose (exposeList)
  call ShowString I!.__GetMsg( 14 ) || ' ' ,,                /* v3.06 */
                  prog.__name ,                              /* v3.06 */
                  global.__userUsage prog.__DefParms         /* v3.06 */

RETURN ' '                                                   /* v3.03 */


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
/* note:     Add the color codes used in this routine to the          */
/*           variable 'prog.__LogExcludeWords' if you don't want      */
/*           them in the logfile. Example:                            */
/*                                                                    */
/*               prog.__LogExcludeWords = screen.__fgYellow ,         */
/*                                        screen.__highlight ,        */
/*                                        screen.__AttrOff            */
/*                                                                    */
/*           This should be one of the first statements in the        */
/*           routine main.                                            */
/*                                                                    */
AddColor1: PROCEDURE expose (exposeList)
  parse arg quoteChar, myString

return quoteChar || screen.__fgYellow || screen.__highlight || ,
       myString || ,
      screen.__AttrOff || quoteChar


/* ------------------------------------------------------------------ */
/* function: split a string into separate arguments                   */
/*                                                                    */
/* call:     call SplitParameter Parameter_string, separator          */
/*                                                                    */
/* where:    parameter_string - string to split                       */
/*           separator - separator character to split a parameter     */
/*                       into keyword and keyvalue                    */
/*                                                                    */
/* returns:  the number of arguments                                  */
/*           The arguments are returned in the stem argv.:            */
/*             argv.0 = number of arguments                           */
/*             argv.n.__keyword = keyword                             */
/*             argv.n.__keyValue = keyValue                           */
/*                                                                    */
/* note:     handles arguments in quotes and double quotes also       */
/*                                                                    */
/*                                                                    */
SplitParameter: PROCEDURE EXPOSE (exposeList) argv.

                    /* get the parameter                              */
  parse arg thisArgs, thisSeparator

                    /* init the result stem                           */
  argv.0 = 0

  do while thisargs <> ''

    parse value strip( thisArgs, "B" ) with curArg thisArgs

    parse var curArg tc +1 .
    if tc = '"' | tc = "'" then
      parse value curArg thisArgs with (tc) curArg (tc) ThisArgs

    parse var curArg '' -1 lastChar 1 argType (thisSeparator) argValue

    parse var argValue tc +1 .
    if tc = '"' | tc = "'" then
      parse value argValue thisArgs with (tc) argValue (tc) ThisArgs

    argtype  = strip( argType  )
    argValue = strip( argValue )

    i = argv.0 + 1

    argv.i.__keyword = translate( argType )
    argv.i.__KeyValue = argValue

    argv.0 = i

  end /* do while thisArgs <> '' */

RETURN argv.0

/* ------------------------------------------------------------------ */
/* function: get the name for a macro                                 */
/*                                                                    */
/* call:     curMacroName = GetMacroName( curMacroCMDFile )           */
/*                                                                    */
/* where:    curMacroCMDFile - name of the file with the macro        */
/*                                                                    */
/* returns:  the name of the macro or ''                              */
/*                                                                    */
/* notes:    GetMacroName first tries to get the macro name form the  */
/*           first line of the file. Is this fails, it uses the name  */
/*           of the file without the extension as macro name.         */
/*                                                                    */
GetMacroName: PROCEDURE expose (exposeList)
  parse arg CurMacroCMDFile

                    /* init the return code                           */
  curMacroName = ''

  if curMacroCMDFile <> '' then
  do
                    /* check the filetype                             */
    if stream( curMacroCMDFile, 'c', 'QUERY EXISTS' ) <> '' then
    do
      curMacroSignatur = charIn( curMacroCMDFile, 1,2 )

                    /* close the file                                 */
      call stream curMacroCMDFile, 'c', 'CLOSE'

      if length( curMacroSignatur ) = 2 then
      do
        if curMacroSignatur = '/' || '*' then
        do
                    /* get the name for the macro                     */
          firstMacroLine = lineIn( curMacroCMDFile )

                    /* close the macro file                           */
          call stream curMacroCmdFile, 'c', 'CLOSE'

          parse upper var firstMacroLine . 'MACRONAME:' curMacroName .
          curMacroName = strip( curMacroName )
          parse var curMacroName tc +1 .
          if tc = '"' | tc = "'" then
            parse var firstMacroLine . 'MACRONAME:' (tc) curMacroName (tc)
          else
            curMacroName = strip( word( curMacroName, 1 ) )
        end /* if */

        if curMacroName = '' then
        do
          curMacroName = fileSpec( "name", curMacroCMDFile )
          if lastPos( '.', curMacroName ) <> 0 then
            curMacroName = substr( curMacroName, 1,,
                           lastPos( '.', curMacroName )-1 )
        end /* if curMacroName = '' then */
      end /* if length( curMacroSignatur ) = 2 then */
    end /* if stream( curMacroCMDFile, 'c', 'QUERY EXISTS' ) <> '' then */
  end /* if curMacroCMDFile <> '' then */

return curMacroName

/* ------------------------------------------------------------------ */
/* function: Init the variable with the source for the loader         */
/*                                                                    */
/* call:     call InitLoaderVariable curMacorName                     */
/*                                                                    */
/* where:    curMacroName - name of the base macro                    */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* notes:    The variable 'LoaderSourceCode' holds the source code    */
/*           after executing this routine.                            */
/*                                                                    */
InitLoaderVariable: PROCEDURE expose (exposeList) LoaderSourceCode
  parse arg curMacroName

LoaderSourceCode = ,
'/* ------------------------------------------------------------------ */' || '0D0A'x || ,
'/* loader to load a saved macro space image into the macro space,     */' || '0D0A'x || ,
'/* execute it there and clear the macro space afterwards              */' || '0D0A'x || ,
'/*                                                                    */' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  signal on syntax Name FunctionNotFound                                ' || '0D0A'x || ,
'  parse arg programParameter                                            ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  call rxFuncAdd "SysLoadFuncs", "REXXUTIL", "SysLoadFuncs"             ' || '0D0A'x || ,
'  call SysLoadFuncs                                                     ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  parse version rexxVersion .                                           ' || '0D0A'x || ,
'  if rexxVersion = "OBJREXX" then                                       ' || '0D0A'x || ,
'    extension = ".IMO"                                                  ' || '0D0A'x || ,
'  else                                                                  ' || '0D0A'x || ,
'    extension = ".IMC"                                                  ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  parse source . . thisFile                                             ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  i = lastPos( "\", thisFile )                                          ' || '0D0A'x || ,
'  j = lastPos( ".", thisFile )                                          ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  imgFile = substr( thisFile, 1, j-1 ) || extension                     ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  if stream( imgFile, "c", "QUERY EXISTS" ) = "" then                   ' || '0D0A'x || ,
'  do                                                                    ' || '0D0A'x || ,
'    say "Error: Can not find the image "                                ' || '0D0A'x || ,
'    say "       " || imgFile                                            ' || '0D0A'x || ,
'    say "Please check the installation!"                                ' || '0D0A'x || ,
'    exit 3                                                              ' || '0D0A'x || ,
'  end                                                                   ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  thisRC = SysClearRexxMacroSpace()                                     ' || '0D0A'x || ,
'  if thisRC <> 0 & thisRC <> 2 then                                     ' || '0D0A'x || ,
'  do                                                                    ' || '0D0A'x || ,
'    say "Error " || thisRC || " clearing the macro space!"              ' || '0D0A'x || ,
'    exit 1                                                              ' || '0D0A'x || ,
'  end                                                                   ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  thisRC = SysLoadRexxMacroSpace( imgFile )                             ' || '0D0A'x || ,
'  if thisRC <> 0 then                                                   ' || '0D0A'x || ,
'  do                                                                    ' || '0D0A'x || ,
'    say "Error " || thisRC || " loading the image into the macro space!"' || '0D0A'x || ,
'    exit 1                                                              ' || '0D0A'x || ,
'  end                                                                   ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  call ' || curMacroName || ' programParameter                          ' || '0D0A'x || ,
'  if symbol( "result" ) = "VAR" then                                    ' || '0D0A'x || ,
'    programRC = result                                                  ' || '0D0A'x || ,
'  else                                                                  ' || '0D0A'x || ,
'    programRC = 0                                                       ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'  thisRC = SysClearRexxMacroSpace()                                     ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'exit result                                                             ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'FunctionNotFound:                                                       ' || '0D0A'x || ,
'  say "Syntax error in line " || sigl || ,                              ' || '0D0A'x || ,
'      " (condition("D") is "" || condition(D) || "")."                  ' || '0D0A'x || ,
'  say "Maybe you are using an invalid REXXUTIL DLL:"                    ' || '0D0A'x || ,
'  say "  This program needs the REXXUTIL DLL from Object REXX."         ' || '0D0A'x || ,
'exit 255                                                                ' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
'/* ------------------------------------------------------------------ */' || '0D0A'x || ,
'                                                                        ' || '0D0A'x || ,
''
return

/* ------------------------------------------------------------------ */
/* NOTE: You must uncomment this routines before using them!!!        */

/*** DEBUGGING SUBROUTINES ***/

/**DEBUG** Delete this line before using the debugging routines!!! */


/* ------------------------------------------------------------------ */
/* function: show all variables defined for the routine calling       */
/*           this routine.                                            */
/*                                                                    */
/* call:     ShowDefinedVariables {N}, {varMask}                      */
/*                                                                    */
/* where:    N - no pause if the screen is full                       */
/*           varMask - mask for the variables                         */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* note:     This routine needs the Dave Boll's DLL RXU.DLL!          */
/*           Be aware that the special REXX variables SIGL, RC and    */
/*           RESULT are changed if you call this routine!             */
/*                                                                    */
/*                                                                    */
ShowDefinedVariables:
  parse upper arg SDV.__pauseMode, SDV.__varMask


                                /* install a local error handler      */
  signal on syntax name SDV.__RXUNotFound

                                /* load the necessary DLL function    */
  call rxFuncDrop 'RxVLIst'
  call rxFuncAdd 'RxVlist', 'RXU', 'RxVList'

  call rxFuncDrop 'RxPullQueue'
  call rxFuncAdd 'RxPullQueue', 'RXU', 'RxPullQueue'

                                /* create a queue for the variables   */
  SDV.__newQueue = rxqueue( 'create' )

                                /* the 'D' parameter of the RxVList   */
                                /* functions won't pause if the       */
                                /* screen is full                     */
  SDV.__thisRC = RxVList( SDV.__varMask, 'V' , SDV.__newQueue )

                                /* ignore local variables of this     */
                                /* routine                            */
  SDV.__thisRC = SDV.__thisRC

  say '  ' || copies( 'Ä',76 )

  if SDV.__thisRC <> 0 then
  do

    say '  Defined variable(s) and their values:'
    SDV.__i = 0

    do SDV.__n = 1 to SDV.__ThisRC
      if SDV.__i >= 23 & ,
         SDV.__pauseMode <> 'N' then
      do
        ADDRESS 'CMD' 'PAUSE'
        SDV.__i = 0
      end /* if */
      SDV.__varName = RxPullQueue( SDV.__newQueue, 'Nowait', 'SDV.__dummy' )
      SDV.__varValue = RxPullQueue( SDV.__newQueue, 'Nowait', 'SDV.__dummy' )

                                /* ignore local variables of this     */
                                /* routine                            */
      if left( SDV.__varName, 6 ) <> 'SDV.__' then
      do
        say '     ' || SDV.__varName || ' = "' || SDV.__varValue || '"'
        SDV.__i = SDV.__i+1
      end /* if right( ... */

    end /* do */

                        /* delete the queue for the variables         */
    call rxqueue 'Delete', SDV.__newQueue
  end
  else
    say '  No variables defined.'

  say '  ' || copies( 'Ä',76 )

                        /* delete local variables                     */
  drop SDV.
RETURN ' '                                                   /* v3.03 */

                        /* error exit for ShowDefinedVariables        */
SDV.__RXUNotFound:
  say 'ShowDefinedVariables: RXU.DLL not found'
RETURN 255

/*   Delete this line before using the debugging routines!!!    **DEBUG**/

/***        End of Part 4 of the source code of TEMPLATE.CMD        ***/
/**********************************************************************/
   


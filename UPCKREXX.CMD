/* ------------------------------------------------------------------ */
/* UPCKREXX.CMD - unpack packed or "compressed" REXX programs         */
/*                                                                    */
/* (c) Copyright Bernd Schemmer 1995 - 1997                           */
/*                                                                    */
/*-Author:                                                            */
/*   Bernd Schemmer                                                   */
/*   Baeckerweg 48                                                    */
/*   D-60316 Frankfurt am Main                                        */
/*   Germany                                                          */
/*   Compuserve: 100104,613                                           */
/*   Internet:   100104.613@compuserve.com                            */
/*                                                                    */
/*-History:                                                           */
/*   25.10.1995 /bs v1.00                                             */
/*     - initial release                                              */
/*                                                                    */
/*                                                                    */
/*-Distribution:                                                      */
/*   UPCKREXX.CMD is part of the REXXCC package. Please see the file  */
/*   REXXCC.CMD for my distribution policy.                           */
/*                                                                    */
/*-Usage:                                                             */
/*                                                                    */
/*   UPCKREXX sourceFile                                              */
/*            {/LL:n} {/SI:n} {/BI:n}                                 */
/*            {/FH{:n}} {/CM{:n}} {/NL{:n}} {/DL{:n}}                 */
/*            {/IE{xt}{:n}}                                           */
/*            {/L:logfile} {/H} {/Silent} {/NoSound} {/NoAnsi}        */
/*            {/Trace}                                                */
/*                                                                    */
/*-where:                                                             */
/*   sourcefile - name of the sourcefile                              */
/*                                                                    */
/*   /LL:n      - n is the line length for the output file            */
/*                (def.: 72, n >= 60)                                 */
/*                                                                    */
/*   /SI:n      - n is the indent for the lines of the output file    */
/*                (def.: 2, n >= 0)                                   */
/*                                                                    */
/*   /BI:n      - n is the indent for code blocks (like DO ... END)   */
/*                (def.: 2, n >= 0)                                   */
/*                                                                    */
/*   /FH:n      - insert file and function headers if n is 1          */
/*                (def.: 1, range: 0-1, default for n: 1)             */
/*                                                                    */
/*   /CM{:n}    - insert comments after END statements if n is 1      */
/*                (def.: 1, range: 0-1, default for n: 1)             */
/*                                                                    */
/*   /NL{:n}    - insert empty lines to format the file if n is 1     */
/*                (def.: 1, range: 0-1, default for n: 1)             */
/*                                                                    */
/*   /DL{:n}    - delete all comments from the sourcefile before      */
/*                processing the file if n is 1                       */
/*                (def.: 0, range: 0-1, default for n: 1)             */
/*                                                                    */
/*   /IE{xt}{:n}- don't check the file extension and don't check the  */
/*                file format if n is 1                               */
/*                (def.: 0, range: 0-1, default for n: 1)             */
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
/*-notes:                                                             */
/*   You may also set the default values for the option parameters    */
/*   (parameter in the format "/xx:n") in the environment variable    */
/*   "UPCKREXX".                                                      */
/*   Parameter for UPCKREXX.CMD overwrite the values from the         */
/*   environment variable.                                            */
/*   All parameter, except the parameter "sourceFile", are optional.  */
/*   All parameter parts shown in {} are optional.                    */
/*   You may use the parameter in any sequence.                       */
/*                                                                    */
/*   UPCKREXX _always_ creates a backup of the source file with the   */
/*   extension "nnn" where nnn is a unique number.                    */
/*                                                                    */
/*-Warning: Check the target file carefully if using UPCKREXX for     */
/*          unpacked REXX programs which include comments!!!          */
/*                                                                    */
/*-Limitations:                                                       */
/*                                                                    */
/* UPCKREXX can NOT handle files with one of the ASCII codes 01, 02,  */
/* 03 or 04. These codes are used internally by UPCKREXX.             */
/*                                                                    */
/* UPCKREXX does NOT parse the source code like the REXX interpreter. */
/* Therefore it handles a few constructs incorrect.                   */
/* If there are string constants without leading and trailing quotes  */
/* or double quotes in the sourcefile, the unpacked file may be       */
/* invalid.                                                           */
/*                                                                    */
/* see also 'Limitations for compressing" in REXXCC.CMD.              */
/*                                                                    */
/* ------------------------------------------------------------------ */
/* Planed future Enhancements:                                        */
/*   - correct bugs if any exist                                      */
/*   - delete the limitation for files with ASCII codes 01 to 04      */
/*   - enhance performance                                            */
/*   - split lines longer than n (/LL:n) into multiple lines          */
/*   - add further logic for additional comments                      */
/*   - add support for file masks (like *.cmd)                        */
/*   - add support for OO REXX programs (I have NOT tested this       */
/*     version with OO REXX programs)                                 */
/*                                                                    */
/* ------------------------------------------------------------------ */
/* Based on TEMPLATE.CMD v3.02á, TEMPLATE is (c) 1995 Bernd Schemmer, */
/* Baeckerweg 48, D-60316 Frankfurt, Germany, Compuserve: 100104,613  */
/*                                                                    */
/* ------------------------------------------------------------------ */

/* ------------------------------------------------------------------ */

                        /* turn interactive trace off                 */
  call trace 'off'

                  global. = ''  /* init the stem global. with ''      */

         global.__Version = 1.0          /* Version of UPCKREXX.CMD   */

       global.__SignOnMsg = 1   /* set to 0 if you do not want the    */
                                /* program start and end messages     */

         global.__NeedCID = 0   /* set to 1 if you need CID support   */

      global.__NeedColors = 1   /* set to 1 if you want colored msgs  */

  global.__NeedPatchCheck = 1   /* set to 1 if you want the program   */
                                /* to search for a patched version of */
                                /* this program                       */

                                /* set default values for EXPOSELIST  */
                                /* if necessary                       */
/*             exposeList = ''                                        */

                                /* name of the routine for the        */
                                /* message handling.                  */
                                /* Note: Use '' if you want to use    */
                                /*       the hardcoded messages       */
/*          global.__GetMsg = ''                                      */

                                /* base number for the message        */
                                /* numbers (def.: 1000)               */
/*          global.__BaseMsgNo = 1000                                 */
             
  prog.__STDOUT = 'STDOUT'        /* necessary for OO REXX            */
  prog.__STDOUT = 'STDOUT'        /* necessary for OO REXX            */
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
                        /* SIGNAL on VALUE is off at this time!       */
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
  prog. = '' ; screen. = ''

                        /* reset the timer                            */
  call time( 'R' )

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
                        /*                                            */
  SIGNAL ON FAILURE   NAME I!.__ErrorAbort
                        /*                                            */
  SIGNAL ON ERROR     NAME I!.__ErrorAbort
                        /*                                            */
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

                        /* check if there is a patched version of     */
                        /* this program                               */
  if global.__NeedPatchCheck <> 0 then
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

                        /* set prog.__ExitCode to the return          */
                        /* code of the function main, if any          */
                        /* returned                                   */
  if symbol( 'I!.__UserProcRC' ) == 'VAR' then
    prog.__ExitCode = I!.__UserProcRC

/* ------------------------------------------------------------------ */
/* house keeping                                                      */

I!.__ProgramEnd:

                                /* call exit routines                 */
  do while strip( prog.__exitRoutines ) <> ''
    I!.__cer = word( prog.__ExitRoutines,1 )

                        /* delete the name of the routine from the    */
                        /* list to avoid endless loops!               */
    prog.__ExitRoutines = substr( prog.__ExitRoutines , ,
                          Pos( I!.__cer, ,
                               prog.__ExitRoutines ) + ,
                          length( I!.__cer ) )

    call I!.__CallUserProc 1, I!.__cer

  end /* do while strip( prog.__ExitRoutines ) <> '' */

                                /* restore the current directory      */
  if symbol( 'prog.__CurDir' ) == 'VAR' then
    call directory prog.__CurDir

                                /* show sign off message              */
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
  if 1 == global.__SignOnMsg then
  do

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
  end /* if 1 == global.__SignOnMsg then */
RETURN

/* ------------------------------------------------------------------ */
/*-function: call a user defined routine                              */
/*           (avoid errors if the routine is not defined)             */
/*                                                                    */
/*-call:     I!.__CallUserProc errorAction, procName {procParameter}  */
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
  I!.__dummy = trace( 'off' )

  I!.__thisRC = 1
  if symbol( 'RESULT' ) == 'VAR' then
    I!.__UserProcRC = value( 'RESULT' )
    
                    /* this label is used if the interpret command    */
                    /* ends with an error                             */
I!.__CallUserProc2:

  if 0 == I!.__ThisRC then
    select

      when 1 == I!.__ErrorAction then
        call ShowWarning I!.__GetMsg( 1 , I!.__ProcN )

      when 2 == I!.__ErrorAction then
        call ShowError global.__ErrorExitCode , ,
                       I!.__GetMsg( 1, I!.__ProcN )
      otherwise
        nop

    end /* select */

RETURN I!.__thisRC

/* ------------------------------------------------------------------ */
/*-function: set the variables for the logfile handling               */
/*                                                                    */
/*-call:     I!.__SetLogVars                                          */
/*                                                                    */
/*-input:    prog.__Param - parameter for the program                 */
/*                                                                    */
/*-output:   prog.__LogFile     - name of the logfile (or NUL)        */
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
/*-returns:  nothing                                                  */
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
      prog.__LogFile = translate( stream( logFileName, 'c', 'QUERY EXIST' ) )

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
/*-function: check the parameter and the environment variables for    */
/*           the runtime system                                       */
/*                                                                    */
/*-call:     I!.__chkPandE                                            */
/*                                                                    */
/*-input:    prog.__Param - parameter for the program                 */
/*           prog.__env - name of the environment                     */
/*                                                                    */
/*-output:   prog.__QuietMode - 1 if parameter '/Silent' found        */
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
/*-returns:  nothing                                                  */
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

  if pos( '"', fn ) == 0 then
    fn = '"' || fn || '"'
  else if pos( "'", fn ) == 0 then
    fn = "'" || fn || "'"

RETURN fn

/* ------------------------------------------------------------------ */
/*-function: flush the default REXX queue                             */
/*                                                                    */
/*-call:     FlushQueue                                               */
/*                                                                    */
/*-returns:  ''                                                       */
/*                                                                    */
FlushQueue: /* PROCEDURE expose (exposeList) */
  do while QUEUED() <> 0
    parse pull
  end /* do while QUEUED() <> 0 */
RETURN ''

/* ------------------------------------------------------------------ */
/*-function: include a file if it exists                              */
/*                                                                    */
/*-call:     TryInclude( IncludeFile )                                */
/*                                                                    */
/*-where:    IncludeFile = name of the file to include                */
/*                                                                    */
/*-output:   prog.__rc = 0 - include file executed                    */
/*           else: file not found                                     */
/*                                                                    */
/*-returns:  ''                                                       */
/*                                                                    */
TryInclude:
  parse upper arg I!.__IncFileName
  prog.__rc = 1

  if I!.__IncFileName = '' then
    RETURN ''

  if stream( I!.__IncFileName,'c','QUERY EXIST' ) = '' then
    RETURN ''

  prog.__rc = 0

  /* execute INCLUDE */

/* ------------------------------------------------------------------ */
/*-function: include a file                                           */
/*                                                                    */
/*-call:     Include( IncludeFile )                                   */
/*                                                                    */
/*-where:    IncludeFile = name of the file to include                */
/*                                                                    */
/*-returns:  ''                                                       */
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

      if right( I!.__IncCurLine,1 ) == ',' then
      do
                        /* statement continues on the next line       */
        if lines( I!.__IncFileName ) == 0 then
          call ShowError global.__ErrorExitCode ,,
               I!.__GetMsg( 4, I!.__IncFileName )
        else
          I!.__IncCurLine = substr( I!.__IncCurLine,1, ,
                                    length( I!.__IncCurLine )-1 )
      end /* if right( ... */
      else
        leave
    end /* do forever */

    I!.__IncActive = 1
    interpret I!.__IncCurLine
    I!.__IncActive = 0

  end /* do I!.__IncLineNO = 1 while lines( I!.__IncFileName ) <> 0 ) */

                        /* close the include file!                    */
  call stream I!.__IncFileName, 'c', 'CLOSE'

RETURN ''

/* ------------------------------------------------------------------ */
/*-function: init color variables                                     */
/*                                                                    */
/*-call:     I!.__InitColorVars                                       */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
I!.__InitColorVars: /* PROCEDURE expose (exposeList) */

  if 1 == global.__NeedColors then
  do

                        /* delete rest of the line                    */
    screen.__DelEOL      = '1B'x || '[K'

                        /* save the cursor position                   */
    screen.__SavePos     = '1B'x || '[s'

                        /* restore the cursor position                */
    screen.__RestPos     = '1B'x || '[u'

                        /* define color attributes                    */
    screen.__AttrOff     = '1B'x || '[0;m'
    screen.__Highlight   = '1B'x || '[1;m'
    screen.__normal      = '1B'x || '[2;m'
    screen.__blink       = '1B'x || '[5;m'
    screen.__invers      = '1B'x || '[7;m'
    screen.__invisible   = '1B'x || '[8;m'

                        /* define foreground color variables          */
    screen.__fgBlack     = '1B'x || '[30;m'
    screen.__fgRed       = '1B'x || '[31;m'
    screen.__fgGreen     = '1B'x || '[32;m'
    screen.__fgYellow    = '1B'x || '[33;m'
    screen.__fgBlue      = '1B'x || '[34;m'
    screen.__fgMagnenta  = '1B'x || '[35;m'
    screen.__fgCyan      = '1B'x || '[36;m'
    screen.__fgWhite     = '1B'x || '[37;m'

                        /* define background color variables          */
    screen.__bgBlack     = '1B'x || '[40;m'
    screen.__bgRed       = '1B'x || '[41;m'
    screen.__bgGreen     = '1B'x || '[42;m'
    screen.__bgYellow    = '1B'x || '[43;m'
    screen.__bgBlue      = '1B'x || '[44;m'
    screen.__bgMagnenta  = '1B'x || '[45;m'
    screen.__bgCyan      = '1B'x || '[46;m'
    screen.__bgWhite     = '1B'x || '[47;m'

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
      call charout prog.__STDOUT, '1B'x || '[7h'

  end /* if 1 == global.__NeedColors then */

RETURN

/* ------------------------------------------------------------------ */
/*-function: init the stem prog.                                      */
/*                                                                    */
/*-call:     I!.__InitProgStem                                        */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*-Note:     DO NOT ADD ANY CODE TO THIS ROUTINE!                     */
/*                                                                    */
I!.__InitProgStem: /* PROCEDURE expose (exposeList) */
  prog.__Defparms = ' {/L:logfile} {/H} {/Silent} {/NoAnsi} {/NoSound} {/Trace}'

                        /* get drive, path and name of this program   */
  parse upper source . . prog.__FullName
        prog.__Drive = filespec( 'D', prog.__FullName )
         prog.__Path = filespec( 'P',  prog.__FullName )
         prog.__Name = filespec( 'N',  prog.__FullName )
          prog.__Env = 'OS2ENVIRONMENT'
       prog.__CurDir = translate( directory() )
                        /* version of TEMPLATE.CMD                    */
      prog.__Version = 'V3.02'
    prog.__UserAbort = 1        /* allow user aborts                  */
 prog.__ExitRoutines = ''       /* list of routines to execute at     */
                                /* program end                        */

                                /* init the variables for cols and    */
                                /* rows                               */
  prog.__ScreenCols = 80
  prog.__ScreenRows = 25

                                /* install a local error handler      */
  SIGNAL ON SYNTAX Name I!.__InitProgStem1
                                /* try to call SysTextScreenSize()    */
  parse value SysTextScreenSize() with prog.__ScreenRows prog.__ScreenCols

I!.__InitProgStem1:

RETURN

/* ------------------------------------------------------------------ */
/*-function: init the variables for CID programs (only if the value   */
/*           of the variable global.__NeedCID is 1)                   */
/*                                                                    */
/*-call:     I!.__InitCIDVars                                         */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*-Note:     DO NOT ADD ANY CODE TO THIS ROUTINE!                     */
/*           Returncodes as defined by LCU 2.0                        */
/*                                                                    */
I!.__InitCIDVars: /* PROCEDURE expose (exposeList) exposeList CIDRC. */

  if 1 == global.__NeedCID then
  do
                        /* define return codes for CID programs       */
    CIDRC.__successful_program_termination  = C2D('0000'x, 2);
    CIDRC.__successful_log_warning_message  = C2D('0004'x, 2);
    CIDRC.__successful_log_error_Message    = C2D('0008'x, 2);
    CIDRC.__successful_log_severe_error     = C2D('0012'x, 2);

    CIDRC.__data_resource_not_found         = C2D('0800'x, 2);
    CIDRC.__data_resource_already_in_use    = C2D('0804'x, 2);
    CIDRC.__data_resource_Noauthorization   = C2D('0808'x, 2);
    CIDRC.__data_path_not_found             = C2D('0812'x, 2);
    CIDRC.__product_not_configured          = C2D('0816'x, 2);

    CIDRC.__storage_medium_exception        = C2D('1200'x, 2);
    CIDRC.__device_Not_Ready                = C2D('1204'x, 2);
    CIDRC.__not_enough_diskspace            = C2D('1208'x, 2);

    CIDRC.__incorrect_program_invocation    = C2D('1600'x, 2);
    CIDRC.__unexpected_condition            = C2D('1604'x, 2);
    CIDRC.__successfull_reboot              = C2D('FE00'x, 2);
    CIDRC.__successfull_reboot_with_warning = C2D('FE04'x, 2);
    CIDRC.__successfull_reboot_with_errmsg  = C2D('FE08'x, 2);
    CIDRC.__successfull_reboot_with_server_errMsg = C2D('FE12'x, 2);


                        /* xx = next state of the program             */
/*    CIDRC.__successfull_reboot_with_callback = C2D('FFxx'x, 2);     */

                        /* define exit code values                    */
    global.__ErrorExitCode = CIDRC.__unexpected_condition
       global.__OKExitCode = CIDRC.__successful_program_termination

                        /* add the stem CIDRC. to the exposeList      */
    exposeList = exposeList || ' CIDRC. '
  end /* if 1 == global.__NeedCID then */

RETURN


/***        End of Part 2 of the source code of TEMPLATE.CMD        ***/

/***       Start of Part 3 of the source code of TEMPLATE.CMD       ***/

/* ------------------------------------------------------------------ */
/*-function:  load a dll                                              */
/*                                                                    */
/*-call:                                                              */
/*   thisRC = LoadDll( registerFunction, dllName, entryPoint,         */
/*                     ,{deRegisterFunction},{checkFunction}          */
/*                     ,{IgnoreRxFuncAddRC},{RegisterErrorRC}         */
/*                     ,{errorAction}                                 */
/*                                                                    */
/*-where:                                                             */
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
/*-returns:                                                           */
/*   0 - loading failed                                               */
/*   1 - dll loaded                                                   */
/*   2 - dll already loaded                                           */
/*                                                                    */
/*-Note:                                                              */
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
                        /* if the 'checkFunc' is missing, we      */
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

  call I!.__LogStart

  call ShowString I!.__GetMsg( 7 ) || ' ', wMsg || '!'
  call I!.__LogSeparator

  screen.__CurColor = screen.__NormalColor
  call Log

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
/*-function: log a debug message and clear the rest of the line       */
/*                                                                    */
/*-call:     logDebugMsg message                                      */
/*                                                                    */
/*-where:    message - message to show                                */
/*                                                                    */
/*-returns:  ''                                                       */
/*                                                                    */
/*-Note:     You do not need the 'call' keyword to use this routine.  */
/*                                                                    */
LogDebugMsg: PROCEDURE expose (exposeList)
  if global.__verbose <> '' then
  do
    parse arg dMsg
    screen.__CurColor = screen.__DebugColor
    call Log '+++' dMsg
    screen.__CurColor = screen.__NormalColor
  end /* if global.__verbose <> '' then */
RETURN ''

/* ------------------------------------------------------------------ */
/*-function: write a CR/LF and a separator line to the screen and to  */
/*           the logfile                                              */
/*                                                                    */
/*-call:     I!.__LogStart                                            */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */

/* ------------------------------------------------------------------ */
/*-function: write a separator line to the screen and to the logfile  */
/*                                                                    */
/*-call:     I!.__LogSeparator                                        */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
I!.__LogStart:
  call log
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

RETURN ''

/* ------------------------------------------------------------------ */
/*-function: check if there is a patched version of this program      */
/*                                                                    */
/*-call:     I!.__CheckPatch                                          */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*-Note:     I!.__RealParam must contain the parameters for           */
/*           this program.                                            */
/*           The variables prog.__Path and prog.__Name must be set!   */
/*           This procedure ends the program with an EXIT command!    */
/*                                                                    */
I!.__CheckPatch: PROCEDURE expose (exposeList)

                        /* get the drive with patch cmd files         */
  pLW = translate( value( 'PATCHDRIVE',, prog.__Env) )

  if pLW <> '' & pLW <> prog.__Drive then
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
/*-function: error handler for unexpected errors                      */
/*                                                                    */
/*-call:     DO NOT CALL THIS ROUTINE BY HAND!!!                      */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*-input:    I!.__IncActive:                                          */
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
/*-Note:     THIS FUNCTION ABORTS THE PROGRAM WITH A JUMP TO THE      */
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
/*-function: get the sourceline causing an error (subroutine of       */
/*           I!.__ErrorAbort)                                         */
/*                                                                    */
/*-call:     DO NOT CALL THIS IN YOUR CODE!!!                         */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*-Note:     -                                                        */
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
/*-function: error handler for user breaks                            */
/*                                                                    */
/*-call:     DO NOT CALL THIS ROUTINE BY HAND!!!                      */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*-Note:     THIS FUNCTION ABORTS THE PROGRAM WITH A JUMP TO THE      */
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
  call Log left( I!.__GetMsg( 11, I!.__ssigl ), prog.__ScreenCols )
  call I!.__LogSeparator
  screen.__CurColor = screen.__NormalColor

  prog.__ExitCode = 254

                        /* restore quiet mode status                  */
  prog.__QuietMode = I!.__QM

SIGNAL I!.__ProgramEnd

/* ------------------------------------------------------------------ */
/*-function: get a message                                            */
/*                                                                    */
/*-call:     I!.__GetMsg msgNo {,msgP1} {...,msgP9}                   */
/*                                                                    */
/*-returns:  the message or an empty string                           */
/*                                                                    */
/*-note:     This routines calls the external routine which name is   */
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
/* 1001 */      'Routine_"@1"_not_found ',
/* 1002 */      'Can_not_write_to_the_logfile_"@1",_the_status_of_the_logfile_is_"@2"._Now_using_the_NUL_device_for_logging ',
/* 1003 */      'Include_file_"@1"_not_found ' ||,
/* 1004 */      'Unexpected_EOF_detected_while_reading_the_include_file_"@1" ' || ,
/* 1005 */      'Error_loading_the_DLL_"@1" ' ||,
/* 1006 */      'Invalid_call_to_LOADDLL ' ||,
/* 1007 */      '_Warning: ' ||,
/* 1008 */      '_@1_-_Error_@2_detected!_The_error_message_is_ ' ||,
/* 1009 */      '_Calling_the_patched_version_@1_... ' ||,
/* 1010 */      '_..._the_patched_version_endet_with_RC_=_@1 ' ||,
/* 1011 */      '_Program_aborted_by_the_user_(sigl=@1) ' ||,
/* 1012 */      '@1_@2_started_on_@3_at_@4_... ' ||,
/* 1013 */      '@1_@2_ended_on_@3_at_@4_with_RC_=_@5_(=''@6''x) ' || ,
/* 1014 */      '_Usage: '

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
/*-function: get the line no of the call statement of this routine    */
/*                                                                    */
/*-call:     GetLineNo                                                */
/*                                                                    */
/*-returns:  the line number                                          */
/*                                                                    */
/*                                                                    */
GetLineNo:
  RETURN sigl

/* ------------------------------------------------------------------ */
/*-function: get the no. of the first line with the user code         */
/*                                                                    */
/*-call:     DO NOT CALL THIS ROUTINE BY HAND!!!                      */
/*                                                                    */
/*-returns:  nothing                                                  */
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
/*-function: main procedure of the program                            */
/*                                                                    */
/*-call:     called by the runtime system with:                       */
/*           => call main parameter_of_the_program <=                 */
/*                                                                    */
/*-returns:  program return code                                      */
/*           If no return code is returned, the value of the variable */
/*           prog.__ExitCode is returned to the calling program.      */
/*                                                                    */
Main: PROCEDURE expose (exposeList)

                        /* get the parameter of the program           */
  parse arg thisParameter

/* ------------------------------ */
                        /* strings which should not be written into   */
                        /* the log file                               */
  prog.__LogExcludeWords = screen.__fgYellow screen.__highlight,
                           screen.__AttrOff

/* ------------------------------ */
                        /* init the global variables                  */
  call InitGlobalVariables

/* ------------------------------ */
                        /* get the options and parameters from the    */
                        /* environment variable and from the command  */
                        /* line                                       */
  call GetProgramOptions thisParameter

/* ------------------------------ */

  call UnpackFile global.__sourceFile

/* ------------------------------ */

                        /* exit the program                           */
RETURN

/* ------------------------------------------------------------------ */

/* ------------------------------------------------------------------ */
/* function: unpack a file                                            */
/*                                                                    */
/* call:     UnpackFile sFile                                         */
/*                                                                    */
/* where:    sFile - name of the source file                          */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
UnpackFile: PROCEDURE expose (exposeList)
  parse arg sFile

  call log ' Unpacking the file ' || AddColor1( '"', sFile ) || ' ...'

                        /* check if the source file exist             */
  if stream( sFile, 'c', 'QUERY EXIST' ) = '' then
    call ShowError global.__ErrorExitCode ,,
          "File not found"

                        /* check the extension of the source file     */
  if translate( FileSpec( 'E', sFile ) ) <> 'CMD' & ,
     global.__IgnoreExtension = 0 then
    call ShowError global.__ErrorExitCode,,
          'The extension of the source file must be "CMD"'

                        /* read the source file                       */
  call ReadFile sFile

                        /* check the file                             */
                        /* (The first two characters of the file      */
                        /*  should be a comment start delimiter)      */
  if substr( global.__SourceCode,1,2 ) <> global.__c1 then
  do
    global.__Warnings = global.__Warnings + 1
    if global.__IgnoreExtension = 1 then
      call ShowWarning ,
            'The file "' || sfile || '" seems not to be a valid REXX program'
    else
      call ShowError global.__ErrorExitCode ,,
            'The file "' || sfile || '" seems not to be a valid REXX program'
  end /* if ... */

                        /* check for the internal used ASCII codes    */
    if verify( global.__SourceCode, '01020304'x, 'M' ) <> 0 then
      call ShowError global.__ErrorExitCode ,,
            'Can not handle files with the ASCII codes 01, 02, 03 or 04'

                        /* replace the comments with placeholder      */
                        /* or delete them (depending on the /DL       */
                        /* switch)                                    */
  call ReplaceComments

                        /* replace string constants with placeholder  */
  call ReplaceStrings

                        /* split the file into lines                  */
  call SplitFile

/* --------------------------- */
/* --- FOR DEBUGGING ONLY! --- */

  if global.__verbose <> '' then
    call WriteInternalVariablestoFile sFile

/* -- END OF DEBUGGING CODE -- */
/* --------------------------- */

                        /* format the file for propper indents        */
  call FormatFile sFile

                        /* insert the string constants again          */
  call Insertstrings

  if global.__DeleteComments <> 1 then
  do
                        /* insert the comments again                  */
    call InsertComments
  end /* if */

                        /* create a backup of the source file         */
  call CreateBackupFile sFile

                        /* write the target file                      */
  call WriteFile sFile

  if global.__Warnings = 0 then
    call log ' ... file successfully unpacked.'
  else
    call log ' ... file unpacked with warnings.'

RETURN

/* ------------------------------------------------------------------ */
/* function: format a statement (line or block)                       */
/*                                                                    */
/* call:     FormatLine curIndent, curIndex                           */
/*                                                                    */
/* where:    curIndent - current indent in number of chars            */
/*           curIndex - index of the current line in the sourceStem   */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
FormatLine: PROCEDURE expose (exposeList) format.
  parse arg curIndent, curIndex

  call CharOut global.__DeviceForStatusMsgs,,
        screen.__RestPos || curIndex

                    /* format the statement according to it's type    */
  select

    when format.__SyntaxType = 1 then   /* IF, or WHEN                */
    do
                        /* take care of the type of the previous line */
      if format.__PrevSyntaxType <> 1 & ,       /* no IF or WHEN      */
         format.__PrevSyntaxType <> 7 then      /* no ELSE            */
        format.__PrefixLine = global.__NewLine  /* add an empty line  */

                    /* use the current indent for the current line    */
                    /* (this is the IF or WHEN statement)             */
      call PutLine curIndent

                    /* get the next line ( if i = -1 -> EOF reached)  */
      i = GetLine()

                    /* use an increased indent for the next line(s)   */
      if i <> -1 then
      do
        call FormatLine curIndent + global.__IndentStep, i

                                /* check for following ELSE statement */
        if CheckSyntaxType( format.__curIndex + 1 ) = 7 then
        do
                                        /* process the ELSE statement */

                    /* get the next line ( if i = -1 -> EOF reached)  */
          i = GetLine()

                    /* use the current indent for the ELSE statement  */
          call PutLine CurIndent

                    /* use an increased indent for the next line(s)   */
                    /* get the next line ( if i = -1 -> EOF reached)  */
          i = GetLine()
          if i <> - 1 then
            call FormatLine curIndent + global.__IndentStep, i
        end /* if */
        /* ELSE SYNTAX WARNING */

        i = CheckSyntaxType( format.__CurIndex + 1 )

                    /* insert an empty line if the next statement is  */
                    /* neither IF/WHEN nor ELSE                       */
        if i <> 1 & i <> 7 then
          format.__PrefixLine = global.__NewLine

      end /* if i <> -1 then */
      /* ELSE SYNTAX WARNING */

    end /* when */

    when format.__SyntaxType = 3 then   /* DO                         */
    do
      format.__InBlock = format.__InBlock + 1

                        /* create the comment for the END statement   */

                        /* take care of the type of the previous line */
      if format.__PrevSyntaxType = 1 | ,        /* IF, WHEN           */
         format.__PrevSyntaxType = 7 | ,        /* ELSE               */
         format.__PrevSyntaxType = 8 then       /* OTHERWISE          */
      do
                    /* use the previous statement for the comment     */
                    /* after the END statement                        */
        curComment = global.__c1 ,
                     value( 'sourceStem.' || curIndex-1 ) ,
                     sourceStem.curIndex ,
                     global.__c2
        curIndent = curIndent - global.__IndentStep
      end /* if */
      else
      do
                    /* use only the DO statement for the              */
                    /* comment after the END statement                */
        curComment = global.__c1 ,
                     sourceStem.curIndex ,
                     global.__c2

        format.__PrefixLine = global.__NewLine
      end /* else */
      format.__PostLine = global.__NewLine

                    /* use the current indent for the current line    */
      call PutLine curIndent

                    /* get the next line ( if i = -1 -> EOF reached)  */
      i = GetLine()

                    /* now process the block until the corresponding  */
                    /* END statement                                  */
      do while format.__SyntaxType <> 6 & format.__eofReached = 0

                    /* increase the indent for the next line(s)       */
        call FormatLine curIndent + global.__IndentStep, i

                    /* get the next line ( if i = -1 -> EOF reached)  */
        i = GetLine()
      end /* do until ... */

                    /* now process the END statement                  */
      if i <> -1 then
      do
                    /* insert a new line if the next statement is not */
                    /* ELSE                                           */
        if CheckSyntaxType( format.__curIndex + 1 ) <> 7 then
          format.__PostLine = global.__NewLine

        format.__PrefixLine = global.__NewLine

        call PutLine curIndent , curComment
      end /* if */
      /* ELSE SYNTAX ERROR */

      format.__InBlock = format.__InBlock - 1

    end /* when */

    when format.__SyntaxType = 4 then   /* SELECT                     */
    do
      format.__InBlock = format.__InBlock + 1

      if format.__PrevSyntaxType = 1 then
      do
        /* curIndent = curIndent - global.__IndentStep */
      end /* if */
      else
      do
        format.__PrefixLine = global.__NewLine
      end /* else */

                    /* create the comment for the END statement       */
      curComment = global.__c1 sourceStem.curIndex global.__c2

                    /* use the current indent for the current line    */
      call PutLine curIndent

                    /* now process the block until the corresponding  */
                    /* END statement                                  */

                    /* get the next line ( if i = -1 -> EOF reached)  */
      i = GetLine()

      do while format.__SyntaxType <> 6 & format.__eofReached = 0

                    /* increase the indent for the next line(s)       */
        call FormatLine curIndent + global.__IndentStep, i

                    /* get the next line ( if i = -1 -> EOF reached)  */
        i = GetLine()
      end /* do until ... */

                    /* now process the END statement                  */
      if i <> -1 then
      do
        format.__PrefixLine = global.__NewLine
        if CheckSyntaxType( format.__curIndex + 1 ) <> 7 then
          format.__PostLine = global.__NewLine

        call PutLine curIndent , curComment
      end /* if */
      /* ELSE SYNTAX ERROR */

      format.__InBlock = format.__InBlock - 1

    end /* when */

    when format.__SyntaxType = 8 then    /* OTHERWISE                 */
    do
      format.__prefixLine = global.__NewLine

      call PutLine curIndent
    end /* when */

    when format.__SyntaxType = 99 then   /* label                      */
    do
                        /* get the name of the function/procedure      */
      global.__funcName = substr( format.__FirstWord,1, pos( ':', format.__FirstWord )-1 )

                    /* insert the function header if the last          */
                    /* statement was RETURN, EXIT or SIGNAL            */
      if format.__PrevSyntaxType = 5 | ,    /* RETURN                  */
         format.__PrevSyntaxType = 9 | ,    /* SIGNAL                  */
         format.__PrevSyntaxType = 10 then  /* EXIT                    */
        format.__prefixLine = PrepareFunctionHeader( global.__funcName )
      else
        format.__prefixLine = global.__NewLine

      call PutLine 0

    end /* when */

    when format.__SyntaxType = 5  | ,    /* RETURN                    */
         format.__SyntaxType = 10 | ,    /* EXIT                      */
         format.__SyntaxType = 9 then    /* SIGNAL                    */
    do
                    /* insert a new line if the next statement is     */
                    /* a label or a comment                           */
      i = CheckSyntaxType( format.__curIndex + 1 )
                                         /* 99 : LABEL                */
                                         /* 98 : comment              */
      if i = 99 | i = 98  then
        format.__PostLine = global.__NewLine

      curComment = ''
      if format.__Syntaxtype = 5 then    /* RETURN                    */
        if global.__funcName = '' then   /* end of the program        */
          curComment = global.__c1 global.__sourceFile global.__c2
        else                             /* end of a subroutine/func. */
          curComment = global.__c1 global.__funcName global.__c2

      if format.__SyntaxType = 10 then   /* EXIT                      */
        curComment = global.__c1 global.__sourceFile global.__c2

      if format.__InBlock > 0 | format.__PrevSyntaxType = 1 then
        call PutLine curIndent, curComment  /* either in a block or   */
      else                              /* the prev. stmt is IF/WHEN  */
        call PutLine 0, curComment
    end /* when */

    when format.__SyntaxType = 98 then  /* comment                    */
    do
                    /* write comments ranged right                    */
      n = 0
      i = format.__CurIndex
      if  left( sourceStem.i, 1 ) = global.__CommentStartMarker then
        if right( sourceStem.i, 1 ) = global.__CommentEndMarker then
        do
          i = dbrleft( dbrright( sourceStem.i, 1 ),1 )
          i = length( commentStem.i )
          if i < global.__LineLength then
            n = global.__LineLength - i
        end /* if */

      call PutLine n
    end /* when */

    otherwise
    do
                                        /* all other lines            */
      call PutLine curIndent
    end /* otherwise */

  end /* select */

RETURN

/* ------------------------------------------------------------------ */
/* function: format the file for propper indents                      */
/*                                                                    */
/* call:     FormatFile fileName                                      */
/*                                                                    */
/* where:    fileName - name of the source file                       */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
FormatFile: PROCEDURE expose (exposeList) format.
  parse arg fileName

  call CharOut global.__DeviceForStatusMsgs,,
        '  Formating lines ... line ' || screen.__SavePos

  format.__curIndex = 0       /* index for the stem sourceStem.       */
  format.__eofReached = 0     /* 1: eof reached                       */
  format.__FirstWord = ''     /* first word of the current line in    */
                              /* uppercase                            */
  format.__SyntaxType = ''    /* syntax type of the current line      */

  format.__PrefixLine = ''    /* prefix for the current line          */
  format.__PostLine = ''      /* postfix for the current line         */

  format.__InBlock = 0        /* <> 0: currently in a DO/SELECT block */

                              /* 1: last line was an empty line       */
  format.__LastLineWasEmpty = 0

                              /* indent for the current line          */
  curIndent = global.__IndentStart

                              /* variable for the target code         */
  if global.__InsertHeader <> 0 then
    global.__TargetCode = ,
     '/' || '* ------------------------------------------------------------------ *' || '/' || global.__crLF || ,
     '/' || '* ' || left(  translate( fileName ), 66 ) || ' *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF || ,
     '/' || '* function:                                                          *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF || ,
     '/' || '* usage:                                                             *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF || ,
     '/' || '* parameters:                                                        *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF || ,
     '/' || '* history:                                                           *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF || ,
     '/' || '* notes:                                                             *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF || ,
     '/' || '*                                                                    *' || '/' || global.__crLF
  else
    global.__TargetCode = ''

  global.__TargetCode = global.__TargetCode || ,
    '/' || '* ------------------------------------------------------------------ *' || '/' || global.__crLF || ,
    '/' || '* unpacked on ' || date( 'U' ) || ' at ' || time() || ' with UPCKREXX.CMD (c) B. Schemmer *' || '/' || global.__crLF || ,
    '/' || '* ------------------------------------------------------------------ *' || '/' || global.__crLF || ,
    global.__crLF

                    /* get the first line ( if i = -1 -> EOF reached) */
  i = GetLine()

  do while format.__eofReached = 0

                    /* format the line                                */
    call FormatLine curIndent, i

                    /* get the next line ( if i = -1 -> EOF reached)  */
    i = GetLine()

  end /* while */

  call LineOut global.__DeviceForStatusMsgs,,
        screen.__RestPos || copies( '08'x, 5) || ' done. ' || screen.__DelEOL

RETURN

/* ------------------------------------------------------------------ */
/* function: add a line to the target source                          */
/*                                                                    */
/* call:     PutLine curIndent {, curComment}                         */
/*                                                                    */
/* where:    curIndent - current indent in chars                      */
/*           curComment - comment for the current line                */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
PutLine: PROCEDURE expose (exposeList) format.
  parse arg curIndent, curComment

            /* get the index of the current line of the source code   */
  i = format.__curIndex

                    /* suppress comments if necessary                 */
  if global.__InsertComments = 0 then
    curComment = ''

                    /* suppress superflous empty lines                */
  if format.__LastLineWasEmpty = 1 & ,
     format.__PrefixLine = global.__NewLine then
    format.__PrefixLine = ''

                    /* add the line to the target code                */
  global.__TargetCode = global.__TargetCode || ,
                        format.__PrefixLine || ,
                        copies( ' ', curIndent ) || ,
                        sourceStem.i curComment || ,
                        global.__CRLF || ,
                        format.__PostLine

              /* save status of the last line (empty or not empty)    */
  if format.__PostLine = global.__NewLine then
    format.__LastLineWasEmpty = 1
  else
    format.__LastLineWasEmpty = 0

                        /* reset the line prefix and post variables   */
  format.__PrefixLine = ''
  format.__PostLine = ''
RETURN

/* ------------------------------------------------------------------ */
/* function: get and prepeare the next line of the source file        */
/*                                                                    */
/* call:     GetLine                                                  */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  -1 : eof reached                                         */
/*           else index of the current line                           */
/*                                                                    */
/* output:   format.__SyntaxType : type of the line                   */
/*           format.__FirstWord : first word of the line              */
/*           format.__PrevSyntaxType : type of the previous line      */
/*           format.__PrevFirstWord : first word of the previous line */
/*           format.__curIndex : index of the current line            */
/*           format.__eofReached : 1 if eof reached                   */
/*                                                                    */
GetLine: PROCEDURE expose (exposeList) format.

                        /* save the values of the last line           */
  format.__PrevFirstWord  = format.__FirstWord
  format.__PrevSyntaxType = format.__SyntaxType

  format.__curIndex = format.__curIndex + 1
  if format.__curIndex > sourceStem.0 then
  do
                        /* end of file reached                        */
    format.__eofReached = 1
    thisRC = -1
  end
  else
  do
    i = format.__curIndex

                        /* get the values for this line               */
    format.__FirstWord = word( sourceStem.i,1 )
    format.__SyntaxType = CheckSyntaxType( i )

    thisRC = i
  end /* else */

RETURN thisRC

/* ------------------------------------------------------------------ */
/* function: get the syntax type of a line                            */
/*                                                                    */
/* call:     CheckSyntaxType lineNo                                   */
/*                                                                    */
/* where:    lineNo - line number                                     */
/*                                                                    */
/* returns:  the type of the line                                     */
/*           or -1 if the parameter is invalid or the line does not   */
/*           exist                                                    */
/*                                                                    */
CheckSyntaxType: PROCEDURE expose (exposeList)
  parse arg lineNo

  thisRC = -1

                    /* variables for detecting the type of the line   */
  specialWords = 'IF WHEN ELSE DO SELECT EXIT RETURN END SIGNAL OTHERWISE' /* comment */ /* label */
  syntaxTypes  = ' 1   1   7   3    4     10     5     6    9        8           98          99'

  if datatype( lineNo, 'W' ) = 1 then
    if symbol( 'sourceStem.' || lineNo ) = 'VAR' then
    do
                        /* translate the test values to uppercase     */
      testLine = translate( sourceStem.lineNo )
      FirstWord = word( testLine,1 )

      SyntaxType = wordPos( FirstWord, specialWords )

      select

        when SyntaxType <> 0 then
        do
          SyntaxType = word( syntaxtypes, SyntaxType )
                        /* handle statements like                     */
                        /*   SIGNAL ON ... NAME ...                   */
                        /* correct                                    */
          if SyntaxType = 9 then
            if words( sourceStem.lineNo ) >= 3 then
              SyntaxType = 0
        end /* when */

        when right( FirstWord,1 ) = ':' | ,
             pos( ':PROCEDURE', FirstWord ) <> 0 then
        do
                        /* LABEL                                      */
          SyntaxType = 99
        end /* when */

        when left( FirstWord,1 ) = global.__CommentStartMarker then
        do
                        /* COMMENT                                    */
          SyntaxType = 98
        end /* when */

        otherwise
          nop

      end /* select */

      thisRC = SyntaxType
    end /* if */

RETURN thisRC

/* ------------------------------------------------------------------ */
/* function: split file into lines                                    */
/*                                                                    */
/* call:     SplitFile                                                */
/*                                                                    */
/* where:    sFile - name of the input file                           */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
SplitFile: PROCEDURE expose (exposeList)

  call CharOut global.__DeviceForStatusMsgs,,
        '  Splitting the file into lines ... Offset ' || screen.__SavePos

                    /* init the variables                             */
  j = sourceStem.0+1

                    /* begin at the start of the file                 */
  curPtr = 1


                    /* replace LFs with ';' and CRs and TABs with ' ' */
  global.__SourceCode = translate( global.__SourceCode, ' ; ', '0D0A09'x )

  do forever

                    /* show the 'in progress' message                 */
    call CharOut global.__DeviceForStatusMsgs,,
          screen.__RestPos || curPtr || screen.__DelEOL

    curLine = ''

                    /* get the first line                             */
                    /* There's always at least one semicolon!         */
                    /* (see routine ReadFile)                         */
    i = pos( ';', global.__SourceCode, curPtr )

    if i = 0 then
      leave         /* end of file reached                            */

    do while i <> 0
                        /* FUTURE enhancement:                        */
                        /*   Create a copy of the line with NO        */
                        /*   comments in it!                          */

                        /* get the line                               */
      curLine = curLine || strip( space( ( substr( global.__SourceCode, curPtr, i-curPtr ) ) ) )

                        /* correct the pointer to the next line       */
      curPtr = i + 1

                        /* check for multi line statements            */
      tStr = curLine
      lastCharPos = length( tStr )
      lastChar = right( tStr,1 )

                        /* ignore comments at the end of the line     */
      do while lastChar = global.__CommentEndMarker
        tStr = strip( substr( curLine, 1, lastPos( global.__CommentStartMarker, tStr )-1 ), 'T' )

        lastCharPos = length( tstr )
        LastChar = right( tstr,1 )
      end /* do while */

      if LastChar = ',' then
        curLine = overlay( ' ', curLine, lastCharPos )
      else
        leave
                    /* get the next line                              */
      i = pos( ';', global.__SourceCode, curPtr )

    end /* do while i = 0 */

    cmtLine = ''
                    /* cut leading comments                           */
    do forever
      curLine = strip( curLine )
      if left( curLine,1 ) <> global.__commentStartMarker then
        leave

      n = pos( global.__CommentEndMarker, curLine )

      cmtLine = cmtLine || substr( curLine, 1, n )
      curLine =            substr( curLine, n+1 )
    end /* do forever */

                /* save the leading comment into an additional line   */
    if cmtLine <> '' then
    do
      sourceStem.j = cmtLine
      j = j + 1
    end /* if cmtLine <> '' then */

                /* save the line in the source stem                   */
    sourceStem.j = curLine

    if sourceStem.j <> '' then
    do

                /* split the line into multiple lines if necessary    */
      FirstWord = translate( word( sourceStem.j ,1 ) )
      LastWord  = translate( word( sourceStem.j, words( sourceStem.j ) ) )

      select

        when ( FirstWord = 'IF' | FirstWord = 'WHEN' ) & ,
             ( LastWord <> 'THEN' ) then
        do
                    /* ensure that THEN is the last word in a line    */
          n = pos( ' THEN ', translate( sourceStem.j ) )
          if n <> 0 then
          do
            k = j + 1
            sourceStem.k = strip( substr( sourceStem.j, n+5 ) )

                    /* ignore comments after THEN                     */
            if left( sourceStem.k,1 ) = global.__CommentStartMarker & ,
               right( sourceStem.k, 1 ) = global.__CommentEndMarker then
              nop
            else
            do
              sourceStem.j = strip( substr( sourceStem.j, 1, n+5 ) )
              j = k
            end /* else */
          end /* if n <> 0 then */
        end /* when */

        when ( ( FirstWord = 'ELSE') | ( FirstWord = 'OTHERWISE' ) ) &,
             ( LastWord <> FirstWord ) then
        do
          n = length( firstword )

                    /* ensure that ELSE and OTHERWISE are the only    */
                    /* words in a line                                */
          k = j + 1
          sourceStem.k = strip( substr( sourceStem.j, n+2 ) )

                    /* ignore comments after ELSE                     */
          if left( sourceStem.k,1 ) = global.__CommentStartMarker & ,
             right( sourceStem.k, 1 ) = global.__CommentEndMarker then
            nop
          else
          do
            sourceStem.j = strip( substr( sourceStem.j, 1, n ) )
            j = k
          end /* else */
        end /* when */

        otherwise
          nop

      end /* select */

                /* increase the index into the source stem            */
      j = j + 1

    end /* if sourceStem.j <> '' then */

  end /* until i = 0 */

  sourceStem.0 = j - 1

  call LineOut global.__DeviceForStatusMsgs,,
        screen.__RestPos || copies( '08'x, 7) || ' done. ' || screen.__DelEOL

RETURN

/* ------------------------------------------------------------------ */
/* function: init global variables                                    */
/*                                                                    */
/* call:     InitGlobalVariables                                      */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
InitGlobalVariables: PROCEDURE expose (exposeList) ,
                               stringStem. commentStem. sourceStem.

                                /* number of warnings                 */
  global.__Warnings = 0

                                /* default line delimiter             */
  global.__CRLF = '0D0A'x

                                /* name of the environment variable   */
                                /* for default switches               */
  global.__envVarName = 'UPCKREXX'

                                /* comment start and end delimiter    */
  global.__c1 = '/' || '*'
  global.__c2 = '*' || '/'

                                /* string start and end delimiter     */
  global.__stringChar1 = "'"
  global.__stringChar2 = '"'

                                /* start and end delimiter for        */
                                /* comment place holder               */
  global.__CommentStartMarker = '01'x
  global.__CommentEndMarker   = '02'x

                                /* start and end delimiter for string */
                                /* place holder                       */
  global.__StringStartMarker  = '03'x
  global.__StringEndMarker    = '04'x

                                /* get the output device for          */
                                /* 'In progress' messages             */
  if ( prog.__QuietMode <> 1 ) & ( screen.__normalColor <> '' ) then
    global.__DeviceForStatusMsgs = 'STDOUT'
  else
    global.__DeviceForStatusMsgs = 'NUL'

                                /* variable with the contents of the  */
                                /* source file                        */
  global.__SourceCode = ''

                                /* variable with the lines for the    */
                                /* target file                        */
  global.__TargetCode = ''

                                /* last function or procedure name    */
  global._FuncName = ''

                                /* stem for the lines from the source */
                                /* file                               */
  sourceStem.0 = 0

                                /* stem to temporary save the string  */
                                /* constants                          */
  stringStem.0 = 0

                                /* stem to temporary save the         */
                                /* comments                           */
  commentStem.0 = 0

                                /* name of the source file            */
  global.__sourceFile = ''

                                /* name of the target file            */
  global.__targetFile = ''

                                /* default line length for the target */
                                /* file                               */
  global.__LineLength = 72

                                /* default start indent value for the */
                                /* lines                              */
  global.__IndentStart = 2

                                /* default indent step value          */
  global.__IndentStep = 2

                                /* ASCII codes to insert a new line   */
  global.__NewLine = global.__CRLF

                                /* 1 : insert comments after END      */
                                /*     statements                     */
  global.__InsertComments = 1

                                /* 1 : delete all existing comments   */
  global.__DeleteComments = 0

                                /* 1 : check the extension and the    */
                                /*     format of the file             */
  global.__IgnoreExtension = 0

                                /* 1 : insert function & procedure    */
                                /*     headers                        */
  global.__InsertHeader = 1

                                /* default function header            */
                                /* place holder used:                 */
                                /*   %f - insert the function name    */
                                /*                                    */
  global.__functionHeader = ,
  global.__CRLF || ,
'/' || '* ------------------------------------------------------------------ *' || '/' || global.__CRLF || ,
'/' || '* function:                                                          *' || '/' || global.__CRLF || ,
'/' || '*                                                                    *' || '/' || global.__CRLF || ,
'/' || '* usage:     %f                                                      *' || '/' || global.__CRLF || ,
'/' || '*                                                                    *' || '/' || global.__CRLF || ,
'/' || '* where:     -                                                       *' || '/' || global.__CRLF || ,
'/' || '*                                                                    *' || '/' || global.__CRLF || ,
'/' || '* returns:   -                                                       *' || '/' || global.__CRLF || ,
'/' || '*                                                                    *' || '/' || global.__CRLF || ,
'/' || '*                                                                    *' || '/' || global.__CRLF || ,
'/' || '* notes:     -                                                       *' || '/' || global.__CRLF || ,
'/' || '*                                                                    *' || '/' || global.__CRLF || ,
'/' || '*                                                                    *' || '/' || global.__CRLF || ,
''
                                /* correct the expose list            */
  exposeList = exposeList 'stringStem. commentStem. sourceStem. '
RETURN

/* ------------------------------------------------------------------ */
/* function: prepare the function header                              */
/*                                                                    */
/* call:     PrepareFunctionHeader functionName                       */
/*                                                                    */
/* where:    functionName = name of the function/procedure            */
/*                                                                    */
/* returns:  the prepared function header                             */
/*                                                                    */
PrepareFunctionHeader: PROCEDURE expose (exposeList)
  parse arg functionName

  if global.__InsertHeader = 1 then
  do
    fHeader = global.__FunctionHeader

    if length( functionName ) = 1 then
      functionName = functionName || ' '

    do until i = 0
      i = pos( '%f', fHeader )
      if i <> 0 then
        fHeader = overlay( functionName, fHeader, i )
    end /* do until i = 0 */

  end /* if */
  else
    fHeader = ''

return fHeader

/* ------------------------------------------------------------------ */
/* function: replace comments in the source file with place holder    */
/*                                                                    */
/* call:     ReplaceComments                                          */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  0 - ok                                                   */
/*           else  error                                              */
/*                                                                    */
/* input:    global.__SourceCode contains the source file contents    */
/*                                                                    */
/*                                                                    */
/* output:   global.__SourceCode contains the converted file contents */
/*                                                                    */
ReplaceComments: PROCEDURE expose (exposeList)

  cio = ''          /* <> '' if unmatched comment delimiter found     */

  if global.__DeleteComments <> 1 then
    call CharOut global.__DeviceForStatusMsgs,,
          '  Replacing comments ... Offset ' || screen.__SavePos
  else
    call CharOut global.__DeviceForStatusMsgs,,
          '  Deleting comments ... Offset ' || screen.__SavePos

                        /* search the start of the first comment      */
  i1 = pos( global.__c1 , global.__SourceCode )

  do while i1 <> 0

    call CharOut global.__DeviceForStatusMsgs,screen.__RestPos || i1

                /* if 1: replace the comment with CR/LF               */
    global.__InsertEmptyLine = 0

                /* save the position of the comment start delimiter   */
    i5 = i1

    do forever
                        /* search the end of the comment              */
      global.__NestedCommentLevel = 1
      i2 = FindCommentEnd( i1 )

      if i2 = 0 then
        leave           /* unmatched comments in the source file      */

                        /* check for sequential comment lines         */
      if substr( global.__SourceCode, i2+2,4 ) <> global.__CRLF || global.__c1 then
        leave           /* no comment following this line             */

                        /* sequential comment following               */

                        /* i1 = start of next comment                 */
      i1 = i2 +4
                        /* set the marker to replace this comment     */
                        /* with CR/LF                                 */
      global.__InsertEmptyLine = 1

    end /* do forever */

                        /* check for unmatched comments               */
    if i2 = 0 then
    do
                        /* unmatched comments in the file             */
      global.__Warnings = global.__Warnings + 1
      cio = global.__c1
      leave
    end /* if i2 = 0 then */

    if global.__DeleteComments <> 1 then
    do
                    /* save the comment in the comment stem           */

                    /* current index to the stem for the comments     */
      j = commentStem.0 +1

                    /* save the comment in the stem for the comments  */
      CommentStem.j = substr( global.__SourceCode, i5, i2-i5+2 )
    end /* if global.__DeleteComments <> 1 then */

                    /* delete the comment                             */
    global.__SourceCode = delStr( global.__SourceCode, i5, i2-i5+2 )

    if global.__DeleteComments <> 1 then
    do
                    /* insert a place holder                          */
      global.__SourceCode = insert( global.__CommentStartMarker || j || global.__CommentEndMarker ,,
                                    global.__SourceCode, i5-1, )

      CommentStem.0 = j
    end /* if global.__DeleteComments <> 1 then */
    else
      if global.__InsertEmptyLine = 1 then
        global.__SourceCode = insert( global.__CRLF, global.__SourceCode, i5-1 )

                    /* search the start of the next comment           */
    i1 = pos( global.__c1 , global.__SourceCode, i5 )

  end /* do forever */

  call LineOut global.__DeviceForStatusMsgs,,
        screen.__RestPos || copies( '08'x, 7) || ' done (' || ,
        AddColor1( , commentStem.0 ) || ' comment(s) found). ' || screen.__DelEOL

                    /* check for unmatched comment end delimiter      */
  if cio = '' & pos( global.__c2, global.__SourceCode ) <> 0 then
    cio = global.__c2

  if cio <> '' then
  do
    global.__Warnings = global.__Warnings + 1

    call ShowWarning 'Unmatched comment chars <' || ,
                     cio || '> in the sourcefile'
  end /* if cio <> '' then */

RETURN

/* ------------------------------------------------------------------ */
/* function: find the end of a comment                                */
/*                                                                    */
/* call:     FindCommentEnd commentStart                              */
/*                                                                    */
/* where:    commentStart - comment start offset                      */
/*                                                                    */
/* returns:  0 - error                                                */
/*           else  offset of the end of the comment                   */
/*                                                                    */
/*                                                                    */
FindCommentEnd: PROCEDURE expose (exposeList)
  parse arg i1

  global.__NestedCommentLevel = global.__NestedCommentLevel + 1
  if global.__NestedCommentLevel >= 40 then
    call ShowError global.__ErrorExitCode,,
          'Comment level nested to deep (max. is 40)'

  do until i2 < i3 | i3 = 0

                        /* i2 = end of comment                        */
    i2 = pos( global.__c2, global.__SourceCode, i1+2 )

                        /* i3 = start of next or imbedded comment     */
    i3 = pos( global.__c1, global.__SourceCode, i1+2 )

    if i3 < i2 & i3 <> 0 then
      i1 = FindCommentEnd( i3, 1 )      /* imbedded comment found     */

    if i1 = 0 then
    do
                        /* unmatched comment delimiter found          */
      i2 = 0
      leave
    end /* if i1 = 0 then */

  end /* do until i2 > i3 */

RETURN i2

/* ------------------------------------------------------------------ */
/* function: insert comments back into the source file                */
/*                                                                    */
/* call:     InsertComments                                           */
/*                                                                    */
/* where:    -                                                        */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* input:    global.__TargetCode contains the source file contents    */
/*                                                                    */
/* output:   global.__TargetCode contains the converted file contents */
/*                                                                    */
InsertComments: PROCEDURE expose (exposeList)

  call CharOut global.__DeviceForStatusMsgs,,
        '  Inserting comments again ... Comment ' || screen.__SavePos

  j = 0
  i1 = 1

  do forever
                        /* search comment place holder                */
    i1 = pos( global.__CommentStartMarker, global.__TargetCode, i1 )
    i2 = pos( global.__CommentEndMarker, global.__TargetCode, i1+1 )
    if i1 = 0 | i2 = 0 then
      leave

                        /* get the index for the comment stem         */
    j = substr( global.__TargetCode ,i1+1,i2-i1-1 )

    call CharOut global.__DeviceForStatusMsgs,,
          screen.__RestPos || j

                        /* delete the place holder                    */
    global.__TargetCode = delStr( global.__TargetCode,i1,i2-i1+1 )

                        /* insert the comment                         */
    global.__TargetCode = insert( commentStem.j, global.__TargetCode,i1-1 )

  end /* do forever */

  call LineOut global.__DeviceForStatusMsgs,,
        screen.__RestPos || copies( '08'x, 8) || ' done. ' || screen.__DelEOL

RETURN

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
/* input:    global.__SourceCode contains the source file contents    */
/*                                                                    */
/* output:   global.__SourceCode contains the converted file contents */
/*                                                                    */
ReplaceStrings: PROCEDURE expose (exposeList)

  cio = ''          /* <> '' if unmatched string delimiter found      */

  call CharOut global.__DeviceForStatusMsgs,,
        '  Replacing string constants ... Offset ' || screen.__SavePos

  i1 = 1
  i0 = 1

  do forever

                    /* take care of the two possible string constant  */
                    /* delimiters in REXX                             */
    i2 = pos( global.__StringChar2 , global.__SourceCode, i0 )
    i1 = pos( global.__StringChar1 , global.__SourceCode, i0 )
    
    if ( i2 < i1 | i1 = 0 ) & i2 <> 0 then
    do
      i1 = i2
      curStringChar = global.__StringChar2
    end /* if i1 < i2 then */
    else
    do
      curStringChar = global.__StringChar1
    end /* else */

    if i1 = 0 then
      leave

    call CharOut global.__DeviceForStatusMsgs,,
          screen.__RestPos || i1

    i2 = pos( curStringChar, global.__SourceCode, i1 +1 )

    if i2 = 0 then
    do
      global.__Warnings = global.__Warnings + 1
      cio = curStringChar
      leave
    end /* if i2 = 0 then */

                    /* current index to the stem for the string       */
                    /* constants                                      */
    j = stringStem.0 +1

                    /* save the comment in the stem for the string    */
                    /* constants                                      */
    StringStem.j = substr( global.__SourceCode, i1, i2-i1+1 )

                    /* delete the string constant                     */
    global.__SourceCode = delStr( global.__SourceCode, i1, i2-i1+1 )

                    /* and insert a marker                            */
    global.__SourceCode = insert( global.__StringStartMarker || j || global.__StringEndMarker ,,
                                  global.__SourceCode, i1-1,,
              )

    StringStem.0 = j
    i0 = i1
  end /* do forever */

  call LineOut global.__DeviceForStatusMsgs,,
        screen.__RestPos || copies( '08'x, 7) || ' done (' ||,
        AddColor1( , StringStem.0 ) || ' string constant(s) found). ' || screen.__DelEOL

  if cio <> '' then
    call ShowWarning 'Unmatched string chars <' || ,
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
/* input:    global.__TargetCode contains the source file contents    */
/*                                                                    */
/* output:   global.__TargetCode contains the converted file contents */
/*                                                                    */
InsertStrings: PROCEDURE expose (exposeList)

  call CharOut global.__DeviceForStatusMsgs,,
        '  Inserting string constants again ... String ' || screen.__SavePos

  j = 0
  i1 = 1
  do forever
                        /* search the string placeholder              */
    i1 = pos( global.__StringStartMarker, global.__TargetCode, i1 )
    i2 = pos( global.__StringEndMarker, global.__TargetCode, i1+1 )
    if i1 = 0 | i2 = 0 then
      leave

    call CharOut global.__DeviceForStatusMsgs,,
          screen.__RestPos || j

                        /* get the index for the strings stem         */
    j = substr( global.__TargetCode ,i1+1,i2-i1-1 )

                        /* delete the placeholder                     */
    global.__TargetCode = delStr( global.__TargetCode,i1,i2-i1+1 )

                        /* insert the string                          */
    global.__TargetCode = insert( stringStem.j,,
                                  global.__TargetCode,,
                                  i1-1 )

  end /* do forever */

  call LineOut global.__DeviceForStatusMsgs,,
        screen.__RestPos || copies( '08'x, 7) || ' done. ' || screen.__DelEOL

RETURN

/* ------------------------------------------------------------------ */
/* function: Read a file using CharIn()                               */
/*                                                                    */
/* call:     ReadFile fileName                                        */
/*                                                                    */
/* where:    fileName - name of the file to read                      */
/*                                                                    */
/* returns:  -1 - file not found                                      */
/*           0 - okay                                                 */
/*                                                                    */
/* output:   global.__SourceCode contains the file contents           */
/*                                                                    */
ReadFile: PROCEDURE expose (exposeList)
  parse arg fileName

                        /* init the return code                       */
  thisRC = -1

  if fileName <> "" then
    if stream( fileName, "c", "QUERY EXIST" ) <> "" then
    do
                            /* open the file in READ ONLY mode        */
      call stream fileName, "c", "OPEN READ"

                            /* read the complete file using Charin()  */
      global.__SourceCode = charIN( fileName, 1, chars( fileName ) ) || '0D0A'x

                            /* close the file                         */
      call stream fileName, "c", "CLOSE"

                            /* correct the return code                */
      thisRC = 0
    end /* if */

RETURN thisRC

/* ------------------------------------------------------------------ */
/* function: Write the file                                           */
/*                                                                    */
/* call:     WriteFile fileName                                       */
/*                                                                    */
/* where:    fileName - name of the file to write                     */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
/* input:    global.__TargetCode contains the file contents           */
/*                                                                    */
WriteFile: PROCEDURE expose (exposeList)
  parse arg tFile

                        /* delete the original file                   */
  ADDRESS 'CMD' '@del ' tFile  prog.__logAll
  if rc <> 0 then
    call ShowError global.__ErrorExitCode ,,
          'Error deleting the source file!'

                        /* open, write and close the converted file   */
  call stream tFile, 'c', 'OPEN WRITE'
  call CharOut tFile, global.__TargetCode
  call stream tFile, 'c', 'CLOSE'
RETURN

/* ------------------------------------------------------------------ */
/* Function: create a backup of a file                                */
/*                                                                    */
/* call:     CreateBackupFile fileToBackup                            */
/*                                                                    */
/* where:    fileToBackup = name of the file to backup                */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
CreateBackupFile: PROCEDURE EXPOSE (exposeList)
  parse arg cbf.oldfileName

  cbf.i = lastpos( '.', cbf.oldFileName )
  if cbf.i <> 0 then
    cbf.testFileName = substr( cbf.oldFileName, 1, cbf.i-1 )
  else
    cbf.testFileName = cbf.oldFileName

  do cbf.index=0 to 999
    cbf.newFileName = cbf.testFileName || '.' || copies( '0', 3 - LENGTH( cbf.index ) ) || cbf.index
    if stream( cbf.newFileName,'c', 'QUERY EXISTS' ) = '' then
      leave
    cbf.newFileName = ''
  end /* do cbf.index=0 to 999 */

  if cbf.newFilename = '' then
  do
                                /* no possible file name found        */
    call ShowError global.__ErrorExitCode,,
          'Can not create a backup of the file "' || ,
                        cbf.oldfilename || '"'
  end /* if cbf.newFilename then */
  else
  do
                                /* create the backup                  */
    call log '  Creating backup of the file ' || ,
             AddColor1( '"', cbf.oldFilename ) || ' with name ' || ,
             AddColor1( '"', cbf.newFileName )

    ADDRESS 'CMD' '@copy ' convertNameToOS( cbf.oldFileName ),
             convertNameToOS( cbf.newFileName ) '/V ' prog.__LogALL
    if rc <> 0 & rc <> "RC" then
      call ShowError global.__ErrorExitCode,,
            'Error creating a backup of the file "' || ,
            cbf.oldfilename || '"' || ' (RC is ' || RC || ')'
  end /* else */

  drop cbf.
RETURN

/* ------------------------------------------------------------------ */
/* function: Extended FILESPEC function                               */
/*                                                                    */
/* call:     FileSpec option,fileName                                 */
/*                                                                    */
/* where:    option                                                   */
/*             - E{xtension}                                          */
/*                 return the extension of the file                   */
/*             - B{asename}                                           */
/*                 returns the name of the file without extension     */
/*             All other values for "option" are processed by the     */
/*             original FILESPEC function.                            */
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
/* Source:   REXX Tips & Tricks v1.90 by Bernd Schemmer               */
/*                                                                    */
FileSpec: PROCEDURE
  parse arg option, fileName

                        /* init the return code                       */
  rc = "SYNTAX ERROR"
                        /* install a local error handler              */
  SIGNAL ON SYNTAX NAME FileSpecError

  option = translate( strip( option ) )

                        /* check the option code                      */
  select
    when abbrev( "EXTENSION", option ) = 1 then
    do
                        /* process the new added option code          */
      i = lastPos( ".", fileName )
      if i > lastPos( "\", fileName ) then
        rc = substr( fileName, i+1 )
      else
        rc = ""
    end /* when */

    when abbrev( "BASENAME", option ) = 1 then
    do
      rc = "FILESPEC"( "N", fileName )
      i = lastpos( ".", rc )
      if i <> 0 then
        rc = substr( rc,1, i-1 )
    end /* when */

    otherwise
    do
                        /* call the original FILESPEC function        */
      rc = "FILESPEC"( option, fileName )
    end /* otherwise */
  end /* when */
FileSpecError:

RETURN rc

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
/*-function: Get the options and parameter from the environment       */
/*           variable and from the command line                       */
/*                                                                    */
/*-call:     GetProgramOptions thisParameter                          */
/*                                                                    */
/*-where:    thisParameter = parameter for the program                */
/*                                                                    */
/*-returns:  nothing                                                  */
/*                                                                    */
/*                                                                    */
/*                                                                    */
GetProgramOptions: PROCEDURE expose (exposeList)
  parse arg thisParameter

                        /* first process the environment variable if  */
                        /* it is defined                              */
  envValue = value( global.__envVarName ,, prog.__env )
  if envValue <> '' then
  do
    envValue = strip( ProcessOptions( 'E', envValue ) )
    if envValue <> '' then
      call ShowError global.__ErrorExitCode ,,
            'Invalid options in the environment variable "' || ,
            global.__envVarName || ,
                           '. The invalid options are "' || envValue || '"'

  end /* if envValue <> '' then */

                        /* now process the parameater                 */
  thisParameter = ProcessOptions( 'P', thisParameter )

  global.__sourceFile = strip( thisParameter )

  select
    when left( global.__sourceFile, 1 ) = '"' & ,
        right( global.__sourceFile, 1 ) = '"' then
      parse var global.__sourceFile '"' global.__sourceFile '"'

    when left( global.__sourceFile, 1 ) = "'" & ,
        right( global.__sourceFile, 1 ) = "'" then
      parse var global.__sourceFile "'" global.__sourceFile "'"

    otherwise
      nop
  end /* select */

  if global.__sourceFile = '' then
    call ShowError global.__ErrorExitCode,,
          'Sourcefile parameter missing'

/* --------------------------- */
/* --- FOR DEBUGGING ONLY! --- */

  if global.__verbose <> '' then
  do
    call logDebugMsg 'Current values of the parameters:'
    call logDebugMsg '  Global.__LineLength      /LL   = ' || global.__LineLength
    call logDebugMsg '  Global.__EmptyLines      /NL   = ' || (global.__NewLine <> '')
    call logDebugMsg '  Global.__DeleteComments  /DL   = ' || global.__DeleteComments
    call logDebugMsg '  Global.__IndentStart     /SI   = ' || global.__IndentStart
    call logDebugMsg '  Global.__IndentStep      /BI   = ' || global.__IndentStep
    call logDebugMsg '  Global.__InsertComments  /CM   = ' || global.__InsertComments
    call logDebugMsg '  Global.__InsertHeader    /FH   = ' || global.__InsertHeader
    call logDebugMsg '  Global.__IgnoreExtension /IExt = ' || global.__IgnoreExtension
    call logDebugMsg '  Global.__SourceFile  =' '"' || global.__SourceFile || '"'
  end /* if global.__Verbose <> '' then */

/* -- END OF DEBUGGING CODE -- */
/* --------------------------- */

RETURN

/* ------------------------------------------------------------------ */
/*-function: Process the options for the program                      */
/*                                                                    */
/*-call:     ProcessOptions sourceTyp, optionString                   */
/*                                                                    */
/*-where:    sourceType = 'E' - environment variable                  */
/*                        'P' - parameter                             */
/*                        'S' - get usage help for additional         */
/*                              parameter                             */
/*           optionString = string with the options                   */
/*                                                                    */
/*-returns:  if sourceType = 'E' or 'P':                              */
/*             the remaining string after extracting the options      */
/*           if sourceType = 'S':                                     */
/*             string with the additional parameter                   */
/*                                                                    */
/*                                                                    */
/*                                                                    */
ProcessOptions: PROCEDURE expose (exposeList)
  parse arg sourceTyp, OptionString

  if sourceTyp = 'S' then
  do
                    /* return the additional options for the program  */
                    /* (used by the ShowUsage routine)                */
    return 'sourceFile {/LL:n} {/SI:n} {/BI:n} {/FH{:n}} {/CM{:n}} {/NL{:n}} {/DL{:n}} {/IE{xt}{:n}}'
  end

  if sourceTyp = 'E' then
    sourceMsg = ' in the environment variable "' || global.__envVarName || '"'
  else
    sourceMsg = ' in the parameters'

  do forever

    parse var optionString optionString '/' curOption rest
    optionString = optionString rest
    parse var curOption switchName ':' switchValue

    switchName = translate( switchName )

    select

      when switchName = '' then
        leave

      when switchName = 'NL' then
      do
        if CheckOptionValue( switchname,switchValue,sourceMsg,0,1,1 ) = 0 then
          global.__NewLine = ''
        else
          global.__NewLine = '0D0A'x
      end /* when */

      when switchName = 'SI' then
      do
        global.__IndentStart = CheckOptionValue( switchname,switchValue,sourceMsg,0 )
      end /* when */

      when switchName = 'LL' then
      do
        global.__LineLength = ,
          CheckOptionValue( switchname,switchValue,sourceMsg,60 )
      end /* when */

      when switchName = 'IE' | switchName = 'IEXT' then
      do
        global.__IgnoreExtension = ,
          CheckOptionValue( switchname,switchValue,sourceMsg,0,1,1 )
      end /* when */

      when switchName = 'BI' then
      do
        global.__IndentStep = ,
          CheckOptionValue( switchname,switchValue,sourceMsg,0 )
      end /* when */

      when switchName = 'FH' then
      do
        global.__InsertHeader = ,
          CheckOptionValue( switchname,switchValue,sourceMsg,0,1,1 )
      end /* when */

      when switchName = 'DL' then
      do
        global.__DeleteComments = ,
          CheckOptionValue( switchname,switchValue,sourceMsg,0,1,1 )
      end /* when */

      when switchName = 'CM' then
      do
        global.__InsertComments = ,
          CheckOptionValue( switchname,switchValue,sourceMsg,0,1,1 )
      end /* when */

      otherwise
      do
        call ShowError global.__ErrorExitCode,,
              'Invalid switch found' || sourceMsg || ,
              '. The invalid switch is "' || switchName || '"'
      end /* otherwise */

    end /* select */

  end /* do forever */
RETURN optionString

/* ------------------------------------------------------------------ */
/*-function: check the value of an option                             */
/*                                                                    */
/*-call:     CheckOptionValue switchName, switchValue, sourceMsg,,    */
/*                            minValue, maxValue, default             */
/*                                                                    */
/*-where:    switchName  - name of the switch                         */
/*           switchValue - value of the switch                        */
/*           sourceMsg - source for the option                        */
/*           minValue - minimum value                                 */
/*           maxValue - maximum value                                 */
/*           default - default value if the switch is specified with  */
/*                     no value                                       */
/*                                                                    */
/*-returns:  if ok: the value                                         */
/*           else: program abort                                      */
/*                                                                    */
/*                                                                    */
/*                                                                    */
CheckOptionValue: PROCEDURE expose (exposeList)
  parse arg switchName, switchValue, sourceMsg, minValue, maxValue, default

  thisValue = ''

                    /* use the default value if no value specified    */
  if switchValue = '' & default <> '' then
    switchValue = default

  if datatype( switchValue, 'W' ) <> 1 then
    call ShowError global.__ErrorExitCode,,
           'Invalid value for switch "' || switchName || '" found' ||,
           sourceMsg || '. The invalid value is "' || switchValue || '"'
  else
  do
    thisValue = switchValue

    if (minValue <> '' & thisValue < minValue) |,
       (maxValue <> '' & thisValue > maxValue) then
    do
      if minValue = '' then
        minValue = 'n'
      if maxValue = '' then
        maxValue = 'm'

      call ShowError global.__ErrorExitCode,,
             'The value for the switch "' || switchname || ,
             '" must be in the range ' || ,
             minValue || ' ... ' || maxValue
    end /* if */
  end /* else */

RETURN thisValue

/* ------------------------------------------------------------------ */
/*-function: Show the invocation syntax                               */
/*                                                                    */
/*-call:     called by the runtime system with                        */
/*           => call ShowUsage <=                                     */
/*                                                                    */
/*-where:    -                                                        */
/*                                                                    */
/*-returns:  ''                                                       */
/*                                                                    */
/*                                                                    */
ShowUsage: PROCEDURE expose (exposeList)
  call ShowString I!.__GetMsg( 14 ) || ' ' || prog.__name || ' ',,
           ProcessOptions( 'S' ) ,
           prog.__DefParms
RETURN ''

/* ------------------------------------------------------------------ */

/*** DEBUGGING SUBROUTINES ***/

/* ------------------------------------------------------------------ */
/* function: Write internal variables to a file                       */
/*                                                                    */
/* call:     WriteInternalVariablesToFile sFile                       */
/*                                                                    */
/* where:    sFile - name of the source file                          */
/*                                                                    */
/* returns:  nothing                                                  */
/*                                                                    */
WriteInternalVariablesToFile: PROCEDURE expose (exposeList)
  parse arg sFile
                    /* create filenames for the files to hold the     */
                    /* internal data                                  */
  global.__DebugCmtFile = FileSpec( 'B', sFile ) || '.CMT'
  global.__DebugStrFile = FileSpec( 'B', sFile ) || '.STR'
  global.__DebugSrcFile = FileSpec( 'B', sFile ) || '.SCR'
  global.__DebugTmpFile = FileSpec( 'B', sFile ) || '.TMP'

  call logDebugMsg 'Writing the comment stem to "' || ,
                   global.__debugCmtFile || '" ...'
  ADDRESS 'CMD' '@del ' ConvertNameToOS( global.__DebugCmtFile ) prog.__logAll
  call LineOut global.__DebugCmtFile, 'There are ' || ,
                                      commentStem.0 ,
                                      ' entrys in the comment stem:'
  do i = 1 to commentStem.0
    call LineOut global.__DebugCmtFile, i || ': >>' || commentStem.i || '<<'
  end
  call stream global.__DebugCmtFile , 'c', 'CLOSE'

  call logDebugMsg 'Writing the string constant stem to "' || ,
                   global.__DebugStrFile || '" ...'

  ADDRESS 'CMD' '@del ' ConvertNameToOS( global.__DebugStrFile ) prog.__logAll
  call LineOut global.__DebugStrFile, 'There are ' || ,
                                      stringStem.0 ,
                                      ' entrys in the string constant stem:'
  do i = 1 to stringStem.0
    call LineOut global.__DebugStrFile, i || ': >>' || stringStem.i || '<<'
  end
  call stream global.__DebugStrFile , 'c', 'CLOSE'

  call LogDebugMsg 'Writing the source code to "' || ,
                   global.__DebugSrcFile || '" ...'
  ADDRESS 'CMD' '@del ' ConvertNameToOS( global.__DebugSrcFile ) prog.__LogAll

  call CharOut global.__DebugSrcFile, global.__SourceCode
  call stream global.__DebugSrcFile, 'c', 'CLOSE'

  call logDebugMsg 'Writing the sourcelines stem to "' || ,
                   global.__debugTmpFile || '" ...'
  ADDRESS 'CMD' '@del ' ConvertNameToOS( global.__DebugTmpFile ) prog.__logAll
  call LineOut global.__DebugTmpFile, 'There are ' || ,
                                      sourceStem.0 ,
                                      ' entrys in the sourceLines stem:'
  do i = 1 to sourceStem.0
    call LineOut global.__DebugTmpFile, i || ': >>' || sourceStem.i || '<<'
  end
  call stream global.__DebugTmpFile , 'c', 'CLOSE'

RETURN

/* ------------------------------------------------------------------ */
/* NOTE: You must uncomment this routines before using them!!!        */

/**DEBUG** Delete this line before using the debugging routines!!!

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
/* note:     This routine needs the DLL YDBAUTIL.                     */
/*           Be aware that the special REXX variables SIGL, RC and    */
/*           RESULT are changed if you call this routine!             */
/*                                                                    */
/*           This routine uses Dave Bolls excellent DLL YDBAUTIL      */
/*                                                                    */
/*                                                                    */
ShowDefinedVariables:
  parse upper arg SDV.__pauseMode, SDV.__varMask

                                /* install a local error handler      */
  signal on syntax name SDV.__YDbaUtilNotFound

                                /* load the necessary DLL function    */
  if RxFuncQuery( 'RxVList' ) then
    call rxFuncAdd 'RxVlist', 'YdbaUtil', 'RxVList'

  if RxFuncQuery( 'RxPullQueue' ) then
    call rxFuncAdd 'RxPullQueue', 'YdbaUtil', 'RxPullQueue'

                                /* create a queue for the variables   */
  SDV.__newQueue = rxqueue( 'create' )

                                /* the 'D' parameter of the RxVList   */
                                /* functions won't pause if the       */
                                /* screen is full                     */
  SDV.__thisRC = RxVList( SDV.__varMask, 'V' , SDV.__newQueue )

                                /* ignore local variables of this     */
                                /* routine                            */
  SDV.__thisRC = SDV.__thisRC

  call log '  ' || copies( 'Ä',76 )

  if SDV.__thisRC <> 0 then
  do

    call log '  Defined variable(s) and their values:'
    SDV.__i = 0

    do SDV.__n = 1 to SDV.__ThisRC
      if SDV.__i >= prog.__ScreenRows-2 & ,
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
        call log '     ' || SDV.__varName || ' = "' || SDV.__varValue ||,
                 '"' || screen.__AttrOff || screen.__DelEOL
        SDV.__i = SDV.__i+1
      end /* if right( ... */

    end /* do */

                        /* delete the queue for the variables         */
    call rxqueue 'Delete', SDV.__newQueue
  end
  else
    call log '  No variables defined.'
  call log '  ' || copies( 'Ä',76 )

                        /* delete local variables                     */
  drop SDV.
return ''
                        /* error exit for ShowDefinedVariables        */
SDV.__YDbaUtilNotFound:
  call ShowError global.__ErrorExitCode ,,
        'ShowDefinedVariables: YDBAUTIL not found'
return

   Delete this line before using the debugging routines!!!    **DEBUG**/

/***        End of Part 4 of the source code of TEMPLATE.CMD        ***/
/**********************************************************************/
   
